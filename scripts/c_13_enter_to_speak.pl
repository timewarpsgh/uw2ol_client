	##### initialize chat mode #####
	my $chat_mode = 'public';
	
	################### enter to speak ####################
		######## chat box picture only ###########
		# my $enteredvalue_picture_only;
		# my $entrybox_picture_only = $mw->Entry(-textvariable => \$enteredvalue_picture_only,-width => 35)->place(-x => 100, -y => 375);
		
		######## get player_name ###########
		$player_name = $redis->hget("$j:primary1", VARplayer_name);
		
		######## real chat box ###########	
		$mw->bind("<Return>", sub {
			my $enteredvalue;
			my $entrybox = $mw->Entry(-textvariable => \$enteredvalue,-width => 35)->place(-x => 100, -y => 375);
			$entrybox->focus;
			$entrybox->bind('<Return>', sub { 
				$entrybox->destroy;
				if ( $enteredvalue ne '') {
					########  world chat ###########
					
					
					if ( $chat_mode eq 'world' ) {
						my $punctuation = "; ";
						my $message = $player_name . $punctuation . $enteredvalue;
						$message = convert_utf8_to_gbk($message);
						
						$redis->publish('world_chat', "$message");
					}
					######## public chat ###########
					if ( $chat_mode eq 'public' ) {
						my $message = $player_name.';'.$enteredvalue;
						$message = convert_utf8_to_gbk($message);
						
						$redis->hset("$j:primary1", VARpubmes, $message);
					
						$mw->after(3000, sub {
							$redis->hset("$j:primary1", VARpubmes, 0);
						});
					}	
				}				
			});
		});
		
	################### click to choose chat_mode ####################	
		##### make text wigets #####
		my $world_chat_mode_widget = $canvas->createText( 45,358, -text => 'world'  , -font =>"Times 12", -fill=>"white");
		my $public_chat_mode_widget = $canvas->createText( 85,358, -text => 'public'  , -font =>"Times 12", -fill=>"yellow");

		##### bind motion_leave #####
		my sub bind_motion_leave_white_canvas {    	
			my $a = shift;
			my $b = shift;
			$b->bind($a,"<Motion>",  sub{
				$b->itemconfigure($a, -font =>"Times 12 bold");
			});
			$b->bind($a,"<Leave>",  sub {
				$b->itemconfigure($a, -font =>"Times 12");
			});
		}
		
		bind_motion_leave_white_canvas($world_chat_mode_widget, $canvas);
		bind_motion_leave_white_canvas($public_chat_mode_widget, $canvas);
		
		##### bind click #####
		$canvas->bind( $world_chat_mode_widget, "<Button-1>",  sub {
			$canvas->itemconfigure($world_chat_mode_widget, -fill=>"yellow");
			$canvas->itemconfigure($public_chat_mode_widget, -fill=>"white");

			$chat_mode = 'world';		
		});
		
		$canvas->bind( $public_chat_mode_widget, "<Button-1>",  sub {
			$canvas->itemconfigure($public_chat_mode_widget, -fill=>"yellow");
			$canvas->itemconfigure($world_chat_mode_widget, -fill=>"white");

			$chat_mode = 'public';	
		});
		
		
		

1;	