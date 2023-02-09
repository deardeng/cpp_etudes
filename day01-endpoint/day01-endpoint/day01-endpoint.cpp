   
#include <iostream>   
#include "endpoint.h"
using namespace std;
using namespace boost;

int main()
{
	client_end_point();
	server_end_point();
	create_tcp_socket();
	create_acceptor_socket();
	return 0;
}
