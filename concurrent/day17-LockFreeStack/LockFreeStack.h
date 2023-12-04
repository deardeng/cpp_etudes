#pragma once

template<typename T>
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


