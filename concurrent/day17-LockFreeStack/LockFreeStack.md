
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

3 未释放弹出的节点的内存。

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

	std::shared_ptr<T> pop() {
		node* old_head = nullptr; //1		
		do {
			old_head = head.load(); //2
			if (old_head == nullptr) {
				return nullptr; 
			}
		} while (!head.compare_exchange_weak(old_hejinad, old_head->next)); //3		
	
		return old_head->data;  //4	
	}
};
```
简单描述下pop函数的功能， 
1 处初始化一个临时old_head的变量，  
2 处加载head节点
3 处通过比较和交换操作，判断head和old_head是否相等，如相等则将head更新为old_head的next节点。如不相等，将old_head更新为head的值(compare_exchange_weak自动帮我们做了),再次进入循环。尽管2处又加载了一次head的值给old_head有些重复，但是为了代码的可读性和指针判空，我觉得这么写更合适一点。

资源回收的问题我们还没处理。
我们先实现一个简单的回收处理逻辑
``` cpp
template<typename T>
std::shared_ptr<T> pop() {
	node* old_head = nullptr; //1		
	do {
		old_head = head.load();
		if (old_head == nullptr) {
			return nullptr; 
		}
	} while (!head.compare_exchange_weak(old_head, old_head->next)); //2		
	
	std::shared_ptr<T> res;   //3
	res.swap(old_head->data); //4
	delete old_head;  //5 
	return res;  //6	
}
```
上面的代码在3处定义了一个T类型的智能指针res用来返回pop的结果，所以在4处将old_head的data值转移给res，这样就相当于清除old_head的data了。

在5处删除了old_head. 意在回收数据，但这存在很大问题，比如线程1执行到5处删除old_head，而线程2刚好执行到2处用到了和线程1相同的old_head，线程2执行compare_exchange_weak的时候`old_head->next`会引发崩溃。

所以要引入一个机制，延迟删除节点。将本该及时删除的节点放入待珊节点。基本思路如下

1  如果有多个线程同时pop，而且存在一个线程1已经交换取出head数据并更新了head值，另一个线程2即将基于旧有的head获取next数据，如果线程1删除了旧有head，线程2就有可能产生崩溃。这种情况我们就要将线程1取出的head放入待删除的列表。

2 同一时刻仅有一个线程1执行pop函数，不存在其他线程。那么线程1可以将旧head删除，并删除待删列表中的其他节点。

3 如果线程1已经将head节点交换弹出，线程2还未执行pop操作，当线程1准备将head删除时发现此时线程2进入执行pop操作，那么线程1能将旧head删除，因为线程2读取的head和线程1不同(线程2读取的是线程1交换后新的head值)。此情形和情形1略有不同，情形1是两个线程同时pop只有一个线程交换成功的情况，情形3是一个线程已经将head交换出，准备删除之前发现线程2执行pop进入，所以这种情况下线程1可将head删除，但是线程1不能将待删除列表删除，因为有其他线程可能会用到待删除列表中的节点。

我们思考这种情形

线程1 执行pop已经将head换出

线程2 执行pop函数，发现线程1正在pop操作，线程2就将待删除的节点head(此head非线程1head)放入待删列表.

线程3 和线程2几乎同时执行pop函数但是还未执行head的交换操作，此head和线程2的head相同。

这种情况下线程1可能读取待删列表为空，因为线程2可能还未更新，也可能读取待删列表不为空(线程2已更新)，但是线程1不能删除这个待删列表，因为线程3可能在用。

那基于上述三点，我们可以简单理解为

1 如果head已经被更新，且旧head不会被其他线程引用，那旧head就可以被删除。否则放入待删列表。
2 如果仅有一个线程执行pop操作，那么待删列表可以被删除，如果有多个线程执行pop操作，那么待删列表不可被删除。

我们需要用一个原子变量threads_in_pop记录有几个线程执行pop操作。在pop结束后再减少threads_in_pop。
我们需要一个原子变量to_be_deleted记录待删列表的首节点。

那么我们先实现一个改造版本
``` cpp
std::shared_ptr<T> pop() {
	 //1 计数器首先自增，然后才执行其他操作
	++threads_in_pop;  
	node* old_head = nullptr; 	
	do {
		//2 加载head节点给旧head存储
		old_head = head.load();  
		if (old_head == nullptr) {
			return nullptr; 
		}
	} while (!head.compare_exchange_weak(old_head, old_head->next)); // 3	
	//3处 比较更新head为旧head的下一个节点	
	
	std::shared_ptr<T> res;
	if (old_head)
	{
		// 4 只要有可能，就回收已删除的节点数据
		res.swap(old_head->data);    
	}
	// 5 从节点提取数据，而非复制指针
	try_reclaim(old_head);   
	return res;
}
```
1  在1处我们对原子变量threads_in_pop增加以表示线程执行pop函数。
2  在2处我们将head数据load给old_head。如果old_head为空则直接返回。
3  3处通过head和old_head作比较，如果相等则交换，否则重新do while循环。这么做的目的是为了防止多线程访问，保证只有一个线程将head更新为old_head的下一个节点。
4  将old_head的数据data交换给res。
5  try_reclaim函数就是删除old_head或者将其放入待删列表，以及判断是否删除待删列表。
