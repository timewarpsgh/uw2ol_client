####### local or remote  ###########
	####### use  ###########
	$connection_state = 'remote';

	####### logic  ###########
	if ( $connection_state eq 'local' ) {
		$fork_address = 'localhost';
		$fork_port = '8081';
		
		$connect_address = 'localhost';
		$connect_port = '8080';
		
		$redis_in_connect = 'localhost:6379';
	}
	elsif ( $connection_state eq 'remote' ) {
		$fork_address = 'a2z3673391.51mypc.cn:21768';
		$fork_port = ' ';
		
		$connect_address = 'a2z3673391.51mypc.cn:11835';
		$connect_port = ' ';
		
		$redis_in_connect = 'a2z3673391.51mypc.cn:25336';
	}