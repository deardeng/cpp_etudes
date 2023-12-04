
## 简介
前文我们通过锁的互斥机制实现了并发安全的栈，队列，查找表，以及链表等结构。接下来本文介绍通过无锁的原子变量的方式实现对应的容器，我们这一篇先从无锁的方式实现栈讲起。

## 栈的设计思路
栈容器是一种先进后出的结构，简单来讲，我们将n个元素1，2，3，4依次入栈，那么出栈的顺序是4，3，2，1.

先考虑单线程情况下操作顺序

1 创建新节点

2 将元素入栈，将新节点的next指针指向现在的head节点。

3 将head节点更新为新节点的值。

再考虑多线程的情况下

假设线程1执行到第2步，没来得及更新head节点的值为新节点的值。此时线程2也执行完第2步，将head更新为线程2插入的新节点，之后线程1又将head更新为线程1的新插入节点，那么此时head的位置就是错的。

如下图

![https://cdn.llfc.club/1701670454146.jpg](https://cdn.llfc.club/1701670454146.jpg)

我们可以通过原子变量的compare_exchange(比较交换操作)来控制更新head节点，以此来达到线程安全的目的。

我们先定义节点的结构
``` cpp
template<typename T>
struct node
{
	T data;
	node* next;
	node(T const& data_) : 
			data(data_)
	{}
};
```
一个node节点包含两部分内容，一个T类型的数据域，一个`node* `的next指针，指向下一个节点。

我们接下来定义一个无锁栈的结构
``` cpp
template<typename T>
class lock_free_stack
{
private:
	lock_free_stack(const lock_free_stack&) = delete;
	lock_free_stack& operator = (const lock_free_stack&) = delete;
	
	std::atomic<node*> head;
public:
    lock_free_stack() {}
}
```

我们同样将拷贝构造和拷贝赋值删除了，将head设置为原子变量，这样我们实现push操作的时候，可以通过比较交换的方式达到安全更新head的效果。

``` cpp
template<typename T>
void push(const T& value){
    auto new_node = new Node(T)
    do{
        new_node->next = head.load();
    }while(!head.compare_exchange_strong(new_node->next, new_node));
}
```
当然<Concurrency Programing C++>书中的做法更简略一些
``` cpp
template<typename T>
void push(const T& value){
    auto new_node = new Node(T)
    do{
        new_node->next = head.load();
    }while(!head.compare_exchange_weak(new_node->next, new_node));
}
```
我还是建议大家用do-while的方式实现，这样我们可以在do-while中增加很多自己的定制逻辑,另外推荐大家用compare_exchange_weak，尽管存在失败的情况，但是他的开销小，所以compare_exchange_weak返回false我们再次重试即可。

单线程情况下pop操作的顺序

1 取出头节点元素
2 更新head为下一个节点。
3 返回取出头节点元素的数据域。

多线程情况下，第1，2点同样存在线程安全问题。此外我们返回节点数据域时会进行拷贝赋值，如果出现异常会造成数据丢失，这一点也要考虑。
所以我们同样通过head原子变量比较和交换的方式检测并取出头部节点。

我们先写一个单线程版本

``` cpp
template<typename T>
void pop(T& value){
    node* old_head = head.load(); //1
    head = head->next; //2
    value = old_head->data;
}
```
我们知道1处和2处在多线程情况下会存在线程安全问题。所以我们用原子变量的比较交换操作改写上面的代码
``` cpp
template<typename T>
void pop(T& value){
    do{
        node* old_head = head.load(); //1
    }while(!head.compare_exchange_weak(old_head, old_head->next)); //2
    value = old_head->data; //3
}
```
我们通过判断head和old_head的值是否相等，如果相等则将head的值设置为old_head的下一个节点，否则返回false，并且将old_head更新为当前head的值(比较交换函数帮我们做的)。

我们看上面的代码，有三点严重问题

1 未判断空栈的情况，这一点比较好处理，如果为空栈我们可以令pop返回false，或者抛出异常，当然抛出异常不可取。

2 将数据域赋值给引用类型的value时存在拷贝赋值(3处)，我们都知道拷贝赋值会存在异常的情况，当异常发生时元素已经从栈定移除了，破坏了栈的结构，这一点和锁处理时不一样，锁处理的时候是先将元素数据域取出赋值再出栈，所以不会有问题，但是无锁的方式就会出现栈被破坏的情况。解决方式也比较简单，数据域不再存储T类型数据，而是存储`std::shared_ptr<T>`类型的数据。智能指针在赋值的时候不会产生异常。

3 未释放弹出的节点的内存。这一点我们也可以通过智能指针管理节点。打到自动释放的效果。

那我们修改之后的代码就是这样了
``` cpp
class lock_free_stack
{
private:
	struct node
	{
		std::shared_ptr<T> data;
		node* next;
		node(T const& data_) : //⇽-- - 1
			data(std::make_shared<T>(data_))
		{}
	};
	lock_free_stack(const lock_free_stack&) = delete;
	lock_free_stack& operator = (const lock_free_stack&) = delete;
	std::atomic<node*> head;
public:
	lock_free_stack() {}
	void push(T const& data)
	{
		node* const new_node = new node(data);    //⇽-- - 2
			new_node->next = head.load();    //⇽-- - 3
			while (!head.compare_exchange_weak(new_node->next, new_node));    //⇽-- - 4
	}

	template<typename T>
	std::shared_ptr<T> pop() {
		node* old_head = head.load(); //1
		if (old_head == nullptr) {
			return nullptr;
		}
		while (!head.compare_exchange_weak(old_head, old_head->next)); //2
		return old_head->data;  //3
	}
};
```
资源回收的问题我们还没处理。