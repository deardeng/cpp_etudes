#pragma once
#include <memory>
#include <atomic>

template<typename T>
class lock_free_stack {
private:
	struct node {
		std::shared_ptr<T> data;
		node* next;
		node(T const& data_) :data(std::make_shared<T>(data_)) {}
	};
	lock_free_stack(const lock_free_stack&) = delete;
	lock_free_stack& operator = (const lock_free_stack&) = delete;
	std::atomic<node*> head;
	std::atomic<node*> to_be_deleted;
	std::atomic<int> threads_in_pop;
public:
	lock_free_stack() {}

	void push(T const& data) {
		node* const new_node = new node(data);    //⇽-- - 2			
		new_node->next = head.load();    //⇽-- - 3			
		while (!head.compare_exchange_weak(new_node->next, new_node));    //⇽-- - 4	
	}

	std::shared_ptr<T> pop() {
		++threads_in_pop;   //1 计数器首先自增，然后才执行其他操作
		node* old_head = nullptr; 	
		do {
			old_head = head.load();  //2 加载head节点给旧head存储
			if (old_head == nullptr) {
				return nullptr; 
			}
		} while (!head.compare_exchange_weak(old_head, old_head->next)); // 3	比较更新head为旧head的下一个节点	
	
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

    void try_reclaim(node* old_head)
	{
        //1 原子变量模糊判断仅有一个线程进入
		if(threads_in_pop == 1)
		{
			//2 当前线程把待删列表取出
            node* nodes_to_delete = to_be_deleted.exchange(nullptr);
            //3 更新原子变量获取准确状态，判断pop是否仅仅正被当前线程唯一调用
            if(!--threads_in_pop)
            {
	            //4 如果唯一调用则将待删列表删除
                delete_nodes(nodes_to_delete);
            }else if(nodes_to_delete)
            {
	            //5 如果pop还有其他线程调用且待删列表不为空，
	            //则将待删列表首届点更新给to_be_deleted
                chain_pending_nodes(nodes_to_delete);
            }
		}
	}
};


template<typename T>
class lock_free_stack
{
private:
    std::atomic<node*> to_be_deleted;
    static void delete_nodes(node* nodes)
    {
        while (nodes)
        {
            node* next = nodes->next;
            delete nodes;
            nodes = next;
        }
    }
    void try_reclaim(node* old_head)
    {
        if (threads_in_pop == 1)    ⇽-- - ①
        {
            node * nodes_to_delete = to_be_deleted.exchange(nullptr);    ⇽-- - ②当前线程把候删链表收归己有
            if (!--threads_in_pop)    ⇽-- - ③pop()是否仅仅正被当前线程唯一地调用
            {
                delete_nodes(nodes_to_delete);    ⇽-- - ④
            }
            else if (nodes_to_delete)    ⇽-- - ⑤
            {
                chain_pending_nodes(nodes_to_delete);    ⇽-- - ⑥
            }
            delete old_head;     ⇽-- - ⑦
        }
        else
        {
            chain_pending_node(old_head);    ⇽-- - ⑧
                --threads_in_pop;
        }
    }
    void chain_pending_nodes(node* nodes)
    {
        node* last = nodes;
        while (node* const next = last->next)    ⇽-- - ⑨沿着next指针前进到候删链表末端
        {
            last = next;
        }
        chain_pending_nodes(nodes, last);
    }
    void chain_pending_nodes(node* first, node* last)
    {
        last->next = to_be_deleted;    ⇽-- - ⑩
            while (!to_be_deleted.compare_exchange_weak(
                last->next, first));     ⇽-- - ⑪借循环保证 last->next指向正确
    }
    void chain_pending_node(node* n)
    {
        chain_pending_nodes(n, n);    ⇽-- - ⑫
    }
};

