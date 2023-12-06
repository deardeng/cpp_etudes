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
			res.swap(old_head->data);    // 4 只要有可能，就回收已删除的节点数据
		}
		//try_reclaim(old_head);   // 5 从节点提取数据，而非复制指针
		return res;
	}
};



