	$pid = fork();
	  
	if( $pid == 0 ) {	######  child
		###################  connect  #####################
		use IO::Socket;
		
		my ($host, $port, $kidpid, $handle, $line);
		my $linea;
		$EOL = "\015\012";     

		my $handle = IO::Socket::INET->new(Proto     => "tcp",
						PeerAddr  => $fork_address,  # 3s.net579.com:15163
						PeerPort  => $fork_port) # 8081
					   || die "can't connect to port $port on $host: $!";
		$handle->autoflush(1);    

		############ subs ##############
		sub translate_message {
			############ show test text ##############
			my $json = JSON->new->allow_nonref;
			my $perl_arrayref = $json->decode($message);
			
			@cx = @{$perl_arrayref->[0]};
			@cy = @{$perl_arrayref->[1]}; 
			@on = @{$perl_arrayref->[2]};
			@mp = @{$perl_arrayref->[3]};
			@pubmes = @{$perl_arrayref->[4]};
			@ai_x_y = @{$perl_arrayref->[5]};
			unshift(@ai_x_y, "0");
	
		}
			  
		##############  read loop ##################### 
		my @message_from_gate;  	
		while(<$handle>){   
			############ get $channel and $message from $_ ############### 
			@message_from_gate = split(":",$_);
			$channel = $message_from_gate[0];
			$message = $message_from_gate[1];

			########### when data comes from 'newsfeed'  (coordinates) ###############
			if($channel eq 'newsfeed'){
				translate_message();
			}
			
			############ when data comes from 'world_chat' ###############	
			if($channel eq 'world_chat'){   		
				my $size = @chat_message;
			
				$message = convert_gbk_to_utf8($message);
				
				if ( $size <= 50 ) {
					push( @chat_message, $message );
				}
				else {
					push( @chat_message, $message );
					shift(@chat_message);
				}		
			}
			
			############ when data comes from 'ocean_day' ###############	
			if($channel eq 'ocean_day'){  
				############ decode message ##############
				my $json = JSON->new->allow_nonref;
				my $arrayref = $json->decode($message);					
				@ocean_day = @{$arrayref};	
			}
			
			############ when data comes from 'sea_supply' ###############	
			if($channel eq 'sea_supply'){  
				@b = split(",",$message);

				@water_all1 = split(" ","@b[0]"); 
				unshift(@water_all1, 0);
			
				@food_all1 = split(" ","@b[1]");
				unshift(@food_all1, 0);

				@lumber_all1 = split(" ","@b[2]");
				unshift(@lumber_all1, 0);

				@shot_all1 = split(" ","@b[3]");
				unshift(@shot_all1, 0);
			}
		}
	}
	

1;	