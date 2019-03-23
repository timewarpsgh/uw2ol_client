#######################   *see self/others chat (former f)  ####################
	########### coord world map image ############
	use experimental 'smartmatch';
	
	my $seaGifa;
	my $seaGifb;
		
	use PDL::NiceSlice;
		
	my $collums_small = 73;
	my $rows_small = 73;
		
	my $map_image_rotation = 1;
	
	my $current_map;
	my $block_image;
	my $small_piddle;
	my $data1;
	
	########### update map when  ###############
	$mw->repeat(200, sub {
		if($mp[$j] eq "sea"){ 	
			if ( abs($cx[$j] - $start_x)/16 >= 12 ||  abs($cy[$j] - $start_y)/16 >= 12 ) {			
				########### new 9 block image ###############
					########### update start_x and start_y  ###############
					my $start_x_inner = $cx[$j];
					my $start_y_inner = $cy[$j];
				
					########### make small piddle  ###############			
					$block_image = Imager->new(xsize => $collums_small*16, ysize => $rows_small*16, channels => 3);
					$small_piddle = $big_piddle_new($cx[$j]/16 - 36: $cx[$j]/16 + 36, $cy[$j]/16 - 36 : $cy[$j]/16 + 36);

					########### small piddle to image  ###############
					foreach my $r(0..($rows_small-1)){
						foreach my $c(0..($collums_small-1)){
							$block_image->paste(left=>0+$c*16, top=>0+$r*16, src=>$img_croped[at($small_piddle,0+$c,0+$r)]);
						}
					}		
					$data1 = image2data($block_image);	
					undef($block_image);
					
					if ( defined($seaGifa) ) {
						$seaGifa->delete;
					}
					$seaGifa = $mw->Photo(-data => $data1, -format => 'png',-width => $collums_small*16,-height => $rows_small*16 );

					########### change image  ###############
					$canvas->itemconfigure($pi,-image => $seaGifa);  
					$canvas->coords($pi, -$cx[$j] + $start_x_inner + 12*16 , -$cy[$j] + $start_y_inner + 12*16); 	

					########### change start_x start_y  ###############
					$start_x  = $start_x_inner;
					$start_y  = $start_y_inner;
			}
		}
	});
	
	########### update player coords  ###############
	$canvas->coords($pi,1536-($cx[$j]+586-5),1536-($cy[$j]+586-5)); 
	
	$mw->repeat(200, sub {
		########### when at sea  ###############
		if($mp[$j] eq "sea" ){ 			
			########### coord block image  ###############
			$canvas->itemconfigure($pi,-image => $seaGifa);  
			$canvas->coords($pi, -$cx[$j] + $start_x + 12*16 , -$cy[$j] + $start_y + 12*16); 	
		
			########### coord other players and AI fleet  ###############
			show_others_B();
			update_AI_fleet(1);
			update_AI_fleet(2);
			update_AI_fleet(3);
			
			########### if dead  ###############
			if ( $cx[$j] == -444 && $cy[$j] == -444 ) {
				print "dead \n";
				
				########### dead image  ###############
				my $dead_image = $mw->Photo(-file => 'images//z_others//'."dead.png", -format => 'png',-width => 640,-height => 482 );
				my $dead_canvas = $mw->Canvas(-background => "blue",-width => 640,-height => 482,-highlightthickness => 0)->place(-x => 0, -y => 0);   # -x => 305, -y => 179
				$dead_canvas->createImage( 320 ,241 , -image => $dead_image);

				########### restart button  ###############
				my $restart_text = $dead_canvas->createText( 320,400, -text  => 'End',-font =>"Times 12 bold");
				bind_motion_leave_canvas($restart_text, $dead_canvas);          
				
				$dead_canvas->bind($restart_text,"<Button-1>", sub{
					kill( 'KILL', $$ );
				});
				
				########### set variables  ###############
				send_move_command(dead);			
			}
			
			
		}
	
		########### when in port  ###############
		if($mp[$j] ne "sea" && $mp[$j] ne 'battle_ground' && $mp[$j] ne 'battle_ground_with_AI'){	
			########### if player not near eddge of map  ###############
			if ( $cx[$j] >= 192 && $cy[$j] >= 192 && $cx[$j] <= 1328 && $cy[$j] <= 1328  ) {
				
			
				####### player to the middle #########
				$canvas->coords( $pship, 203, 203);

				####### port image #########
				# @port_image_position =  $canvas->coords($pi);
				# $canvas->move($pi, $port_image_position[0] - (1536-($cx[$j]+586-5)), $port_image_position[1] - (1536-($cy[$j]+586-5)) );
				# }); 
				# print "@port_image_position \n";
				
				# $tempx = 1536-$cx[$j]-586+5;
				# $tempy = 1536-$cy[$j]-586+5;
				# # $canvas->move($pi, $port_image_position[0] - $cx[$j], $port_image_position[1] - $cy[$j] );
				# print "$cx[$j]  $cy[$j]  \n";
				# # print "$tempx  $tempy  \n";
				# print @port_image_position, "\n";
				# undef @port_image_position;
				# print "1536-($cx[$j]+586-5)", "\n";
				$canvas->coords($pi,1536-($cx[$j]+586-5),1536-($cy[$j]+586-5)); 
		
				####### coord static npcs #########
				$canvas->coords($npc_by_marcket_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y}); 
				$canvas->coords($npc_by_bar_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y}); 
				$canvas->coords($npc_by_inn_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{y}); 
			
				####### coord moving npcs #########
				$canvas->coords($npc_moving_1, 204 - $cx[$j] + $npc_moving_1_x , 204 - $cy[$j] + $npc_moving_1_y); 
				$canvas->coords($npc_moving_2, 204 - $cx[$j] + $npc_moving_2_x , 204 - $cy[$j] + $npc_moving_2_y); 
				
				########### coord other players and AI fleet  ###############
				show_others_B();
				update_AI_fleet(1);
				update_AI_fleet(2);
				update_AI_fleet(3);
			}
			
			########### if player is near eddge of map  ###############
			else {
				########### 4 corners  ###############
					########### left up ###############
					if ( $cx[$j] < 192 && $cy[$j] < 192  ) {
						$canvas->coords( $pship, $cx[$j] - 192 + 203, $cy[$j] - 192 + 203);
					}
					########### left down  ###############
					elsif ( $cx[$j] < 192 && $cy[$j] > 1328  ) {
						$canvas->coords( $pship, $cx[$j] - 192 + 203, $cy[$j] - 1328 + 203);
					}
					########### right up ###############
					elsif ( $cx[$j] > 1328 && $cy[$j] < 192  ) {
						$canvas->coords( $pship, $cx[$j] - 1328 + 203, $cy[$j] - 192 + 203);
					}
					########### right down  ###############
					elsif ( $cx[$j] > 1328 && $cy[$j] > 1328  ) {
						$canvas->coords( $pship, $cx[$j] - 1328 + 203, $cy[$j] - 1328 + 203);
					}
				
				########### 4 stripes  ###############
					########### left  ###############
					elsif ( $cx[$j] < 192 && $cy[$j] >= 192 && $cy[$j] <= 1328 ) {
						####### coord player and map #########
						$canvas->coords( $pship, $cx[$j] - 192 + 203, 203);
						$canvas->coords($pi,1536-(192+586-5),1536-($cy[$j]+586-5)); 
						
						####### coord static npcs #########
						$canvas->coords($npc_by_marcket_animation, 204 + 32 - 192 + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y}); 
						$canvas->coords($npc_by_bar_animation, 204 + 32 - 192 + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y}); 
						$canvas->coords($npc_by_inn_animation, 204 + 32 - 192 + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{y}); 
					
						####### coord moving npcs #########
						$canvas->coords($npc_moving_1, 204 - 192 + $npc_moving_1_x , 204 - $cy[$j] + $npc_moving_1_y); 
						$canvas->coords($npc_moving_2, 204 - 192 + $npc_moving_2_x , 204 - $cy[$j] + $npc_moving_2_y); 
						
						########### coord other players and AI fleet  ###############
						show_others_B();
					}
					########### right  ###############
					elsif ( $cx[$j] > 1328 && $cy[$j] >= 192 && $cy[$j] <= 1328  ) {
						####### coord player and map #########
						$canvas->coords( $pship, $cx[$j] - 1328 + 203, 203);
						$canvas->coords($pi,1536-(1328+586-5),1536-($cy[$j]+586-5)); 
	
						####### coord static npcs #########
						$canvas->coords($npc_by_marcket_animation, 204 + 32 - 1328 + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y}); 
						$canvas->coords($npc_by_bar_animation, 204 + 32 - 1328 + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y}); 
						$canvas->coords($npc_by_inn_animation, 204 + 32 - 1328 + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{x} , 204 + 16 - $cy[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{y}); 
					
						####### coord moving npcs #########
						$canvas->coords($npc_moving_1, 204 - 1328 + $npc_moving_1_x , 204 - $cy[$j] + $npc_moving_1_y); 
						$canvas->coords($npc_moving_2, 204 - 1328 + $npc_moving_2_x , 204 - $cy[$j] + $npc_moving_2_y); 
						
						########### coord other players and AI fleet  ###############
						show_others_B();
						
					}
					########### up  ###############
					elsif ( $cy[$j] < 192 && $cx[$j] >= 192 && $cx[$j] <= 1328 ) {
						####### coord player and map #########
						$canvas->coords( $pship, 203, $cy[$j] - 192 + 203);
						$canvas->coords($pi,1536-($cx[$j]+586-5),1536-(192+586-5)); 

						####### coord static npcs #########
						$canvas->coords($npc_by_marcket_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x} , 204 + 16 - 192 + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y}); 
						$canvas->coords($npc_by_bar_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x} , 204 + 16 - 192 + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y}); 
						$canvas->coords($npc_by_inn_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{x} , 204 + 16 - 192 + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{y}); 
					
						####### coord moving npcs #########
						$canvas->coords($npc_moving_1, 204 - $cx[$j] + $npc_moving_1_x , 204 - 192 + $npc_moving_1_y); 
						$canvas->coords($npc_moving_2, 204 - $cx[$j] + $npc_moving_2_x , 204 - 192 + $npc_moving_2_y); 

						########### coord other players and AI fleet  ###############
						show_others_B();
					}
					########### down  ###############
					elsif ( $cy[$j] > 1328 && $cx[$j] >= 192 && $cx[$j] <= 1328  ) {
						####### coord player and map #########
						$canvas->coords( $pship, 203, $cy[$j] - 1328 + 203);
						$canvas->coords($pi,1536-($cx[$j]+586-5),1536-(1328+586-5)); 
						
						####### coord static npcs #########
						$canvas->coords($npc_by_marcket_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x} , 204 + 16 - 1328 + 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y}); 
						$canvas->coords($npc_by_bar_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x} , 204 + 16 - 1328 + 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y}); 
						$canvas->coords($npc_by_inn_animation, 204 + 32 - $cx[$j] + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{x} , 204 + 16 - 1328 + 16*${${${$ports{$port_index+1}}{buildings}}{5}}{y}); 
					
						####### coord moving npcs #########
						$canvas->coords($npc_moving_1, 204 - $cx[$j] + $npc_moving_1_x , 204 - 1328 + $npc_moving_1_y); 
						$canvas->coords($npc_moving_2, 204 - $cx[$j] + $npc_moving_2_x , 204 - 1328 + $npc_moving_2_y); 

						########### coord other players and AI fleet  ###############
						show_others_B();
					}
			}
	
		}
 		
		########### when in battle_ground  ###############
		if( $mp[$j] eq 'battle_ground' || $mp[$j] eq 'battle_ground_with_AI' ){	
			show_others_B();	
			$canvas->coords( $pship, 2000, 2000);			
		}
		
		# if( $mp[$j] ne 'battle_ground' || $mp[$j] ne 'battle_ground_with_AI' ){		
			# $canvas->coords( $pship, 203, 203);			
		# }
		
		################ update other players' positions ####################	
		sub show_others_B {
			########## get @on_now list e.g (1,2,3)  #################
			@on_now = ();
			for my $i(1..@on-1) {
				if ( $on[$i] == 1 && $i != $j ) {
					push(@on_now, $i);
				}
			}
		
			########## get @players_to_add and @players_to_delete  #################
			@players_to_add = array_minus( @on_now, @on_then );
			@players_to_delete = array_minus( @on_then, @on_now );
		
			@on_then = @on_now;
			
		
			# print "add : @players_to_add \n";
			# print "delete :@players_to_delete \n";
		
			########## add players according to @players_to_add  #################
			for my $i( @players_to_add ) {
				${other_player_.$i} = $canvas->createImage( 203-$cx[$j]+$cx[$i],203-$cy[$j]+$cy[$i], -image => $p2_up);
			}

			########## delete players according to @players_to_delete  #################
			for my $i( @players_to_delete ) {
				$canvas->delete( ${other_player_.$i} );
			}
			
			########## change direction and coords accroding to @on_now #################
			for my $i( @on_now ) {			
				###### if can see on sea ######
				if($mp[$j] eq $mp[$i] && $mp[$j] eq "sea"){    
					########## change direction #################
						###### if no movement ########
						if(${previous_other_player_x_.$i} == $cx[$i] && ${previous_other_player_y_.$i} == $cy[$i]){
								
						}
						###### if movement ########
						else{
							if(${previous_other_player_x_.$i} > $cx[$i]){
								$canvas->itemconfigure(${other_player_.$i},-image => $p2_left); 
							}			
							elsif(${previous_other_player_x_.$i} < $cx[$i]){
								$canvas->itemconfigure(${other_player_.$i},-image => $p2_right); 
							}
							else{
								if(${previous_other_player_y_.$i} > $cy[$i]){
									$canvas->itemconfigure(${other_player_.$i},-image => $p2_up); 
								}
								else{
									$canvas->itemconfigure(${other_player_.$i},-image => $p2_down); 
								}
							}
							
							${previous_other_player_x_.$i} = $cx[$i];
							${previous_other_player_y_.$i} = $cy[$i];	
						}
				
					########## change coords #################
					$canvas->coords( ${other_player_.$i} ,203-$cx[$j]+$cx[$i], 203-$cy[$j]+$cy[$i] );	

					########## bind view #################	
					sub right_click_other_player_fleet {
						my $fleet_num = shift;
					
						####### make canvas #########
						my $right_click_info = $mw->Canvas(-background => "red",-width => 60,-height => 80,-highlightthickness => 0)->place(-x => 308 - $cx[$j] + $cx[$fleet_num] + 5, -y => 180 - $cy[$j] + $cy[$fleet_num] );
						$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
						
						####### make texts #########
						my $view = $right_click_info->createText( 23, 10, -text  => 'View', -font =>"Times 12 bold");
						my $gossip = $right_click_info->createText( 23, 30, -text  => 'Gossip',-font =>"Times 12 bold");
						my $battle = $right_click_info->createText( 23, 50, -text  => 'Battle',-font =>"Times 12 bold");

						####### bind texts #########
							####### view #########
							$right_click_info->bind($view,"<Button-1>",  sub {
								####### make canvas #########
								my $view_info = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 308 , -y => 180 );
								
								####### bind escape #########
								$mw->bind("<Escape>",  sub {
									$view_info->destroy();
									$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
								
								});  
						
								####### download data #########
								my @view_data = $redis->hgetall($fleet_num.':right_click:view'); 

								####### display data #########
								for my $i(1..5) {
									$view_info->createText( 5, 10 + ($i-1)* 15, -text  => @view_data[2*$i - 1], -font =>"Times 12 bold", -anchor => 'w');
								}
								
								my @ships = split(/,/, @view_data[11]);  
								for my $i(1..@ships) {
									if ( $i <= 5 ) {
										$view_info->createText( 5, 20 + ($i + 5 -1)* 15, -text  => @ships[$i-1], -font =>"Times 12 bold", -anchor => 'w');
									}
									else {
										$view_info->createText( 70, 20 + ($i -1)* 15, -text  => @ships[$i-1], -font =>"Times 12 bold", -anchor => 'w');	
									}
								}
							});
							
							####### gossip #########
							$right_click_info->bind($gossip,"<Button-1>",  sub {
								####### make canvas #########
								my $gossip_info = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 308 , -y => 180 );
								
								####### bind escape #########
								$mw->bind("<Escape>",  sub {
									$gossip_info->destroy();
									$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
								});  

								####### download data #########
								my @gossip_data = $redis->hgetall($fleet_num.':right_click:gossip'); 

								####### display data #########
								$gossip_info->createText( 20, 90, -text  => @gossip_data[1], -font =>"Times 12 bold", -anchor => 'w', -width => 80);									
							});
							
							####### battle #########
							$right_click_info->bind($battle,"<Button-1>",  sub {
								####### make canvas #########
								my $battle_info = $mw->Canvas(-background => "red",-width => 300,-height => 240,-highlightthickness => 0)->place(-x => 308 , -y => 180 );
								
								####### bind escape #########
								$mw->bind("<Escape>",  sub {
									$battle_info->destroy();
									$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
								});  

								####### download data #########
								my @battle_data = $redis->hgetall($fleet_num.':right_click:battle'); 
								
								####### display data #########
									####### above info #########
									$battle_info->createText( 5, 10 + 0*15, -text  => @battle_data[1], -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 1*15, -text  => @battle_data[3], -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 2*15, -text  => 'Age '."@battle_data[5]", -font =>"Times 12 bold", -anchor => 'w');
								
									####### bottom left info #########
									$battle_info->createText( 5, 10 + 4*15, -text  => "@battle_data[2*19 - 2] @battle_data[2*19 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 5*15, -text  => "@battle_data[2*4 - 2] @battle_data[2*4 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 6*15, -text  => "@battle_data[2*5 - 2] @battle_data[2*5 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 7*15, -text  => "@battle_data[2*6 - 2] @battle_data[2*6 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 8*15, -text  => "@battle_data[2*7 - 2] @battle_data[2*7 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 9*15, -text  => "@battle_data[2*8 - 2] @battle_data[2*8 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 5, 10 + 10*15, -text  => "@battle_data[2*9 - 2] @battle_data[2*9 - 1]", -font =>"Times 12 bold", -anchor => 'w');

									####### bottom right info #########
									$battle_info->createText( 130, 10 + 4*15, -text  => "@battle_data[2*10 - 2] @battle_data[2*10 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 5*15, -text  => "@battle_data[2*11 - 2] @battle_data[2*11 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 6*15, -text  => "@battle_data[2*12 - 2] @battle_data[2*12 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 7*15, -text  => "@battle_data[2*13 - 2] @battle_data[2*13 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									
									$battle_info->createText( 130, 10 + 9*15, -text  => "@battle_data[2*14 - 2] @battle_data[2*14 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 10*15, -text  => "@battle_data[2*15 - 2] @battle_data[2*15 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 11*15, -text  => "@battle_data[2*16 - 2] @battle_data[2*16 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 12*15, -text  => "@battle_data[2*17 - 2] @battle_data[2*17 - 1]", -font =>"Times 12 bold", -anchor => 'w');
									$battle_info->createText( 130, 10 + 13*15, -text  => "@battle_data[2*18 - 2] @battle_data[2*18 - 1]", -font =>"Times 12 bold", -anchor => 'w');					
							});
					}		
					$canvas->bind( ${other_player_.$i}, "<Button-3>", sub {right_click_other_player_fleet($i)});		
				}
				
				###### if can see in port ######
				if( $mp[$j] eq $mp[$i] && $mp[$j] ne "sea"){ 
					#### up sprite direction  #######
						###### if no movement ########
						if(${previous_other_player_x_.$i} == $cx[$i] && ${previous_other_player_y_.$i} == $cy[$i]){
								
						}
						###### if movement ########
						else{
							if(${previous_other_player_x_.$i} > $cx[$i]){
								if($canvas->itemcget(${other_player_.$i}, -image) == $p_player_left_1){	
									$canvas->itemconfigure(${other_player_.$i},-image => $p_player_left_2); 
								}
								else{
									$canvas->itemconfigure(${other_player_.$i},-image => $p_player_left_1); 
								}									
							}			
							elsif(${previous_other_player_x_.$i} < $cx[$i]){
								if($canvas->itemcget(${other_player_.$i}, -image) == $p_player_right_1){	
									$canvas->itemconfigure(${other_player_.$i},-image => $p_player_right_2); 
								}
								else{
									$canvas->itemconfigure(${other_player_.$i},-image => $p_player_right_1); 
								}
							}
							else{
								if(${previous_other_player_y_.$i} > $cy[$i]){
									if($canvas->itemcget(${other_player_.$i}, -image) == $p_player_up_1){	
										$canvas->itemconfigure(${other_player_.$i},-image => $p_player_up_2); 
									}
									else{
										$canvas->itemconfigure(${other_player_.$i},-image => $p_player_up_1); 
									}
								}	
								else{										
									if($canvas->itemcget(${other_player_.$i}, -image) == $p_player_down_1){	
										$canvas->itemconfigure(${other_player_.$i},-image => $p_player_down_2); 
									}
									else{
										$canvas->itemconfigure(${other_player_.$i},-image => $p_player_down_1); 
									}											
								}
							}
							
							${previous_other_player_x_.$i} = $cx[$i];
							${previous_other_player_y_.$i} = $cy[$i];	
						}
					
					##### up coords  #######
						##### if not near edge of map  #######
						if ( $cx[$j] >= 192 && $cy[$j] >= 192 && $cx[$j] <= 1328 && $cy[$j] <= 1328  ) {
							$canvas->coords(${other_player_.$i},203-$cx[$j]+$cx[$i],203-$cy[$j]+$cy[$i]);	
						}
						##### if near edge of map  #######
						else {
							##### 4 stripes  #######
								##### down  #######
								if ( $cy[$j] > 1328 && $cx[$j] >= 192 && $cx[$j] <= 1328 ) {
									$canvas->coords(${other_player_.$i},203-$cx[$j]+$cx[$i],203-1328+$cy[$i]);
								}
								##### up  #######
								elsif ( $cy[$j] < 192 && $cx[$j] >= 192 && $cx[$j] <= 1328 ) {
									$canvas->coords(${other_player_.$i},203-$cx[$j]+$cx[$i],203-192+$cy[$i]);
								}
								##### left  #######
								elsif ( $cx[$j] < 192 && $cy[$j] >= 192 && $cy[$j] <= 1328 ) {
									$canvas->coords(${other_player_.$i},203-192+$cx[$i],203-$cy[$j]+$cy[$i]);
								}
								##### right  #######
								elsif ( $cx[$j] > 1328 && $cy[$j] >= 192 && $cy[$j] <= 1328 ) {
									$canvas->coords(${other_player_.$i},203-1328+$cx[$i],203-$cy[$j]+$cy[$i]);
								}
							##### 4 corners  #######	
							
						}
					
				}
				
				#####   if can see in battle	#####
				if( $mp[$j] eq $mp[$i] && $mp[$j] eq "battle_ground" ){   					
					$canvas->coords( ${other_player_.$i}, 2000, 2000 );				
				}
				
				#####   if can't see  #####
				if( $mp[$j] ne $mp[$i] ){  	 	
					$canvas->coords( ${other_player_.$i}, 2000, 2000 );			
				}
			}	
		}
										
		######### update ai fleet ############
		sub update_AI_fleet {
			my $fleet_num = shift;
			
			##### up sprite direction  #######
				###### if no movement ########
				if(${previous_ai_fleet_.$fleet_num._x} == $ai_x_y[2*$fleet_num - 1] && ${previous_ai_fleet_.$fleet_num._y} == $ai_x_y[2*$fleet_num]){
						
				}
				###### if movement ########
				else{
					if(${previous_ai_fleet_.$fleet_num._x} > $ai_x_y[2*$fleet_num - 1]){
						$canvas->itemconfigure(${ai_fleet_.$fleet_num},-image => $p2_left); 
					}			
					elsif(${previous_ai_fleet_.$fleet_num._x} < $ai_x_y[2*$fleet_num - 1]){
						$canvas->itemconfigure(${ai_fleet_.$fleet_num},-image => $p2_right); 
					}
					else{
						if(${previous_ai_fleet_.$fleet_num._y} > $ai_x_y[2*$fleet_num]){
							$canvas->itemconfigure(${ai_fleet_.$fleet_num},-image => $p2_up); 
						}
						else{
							$canvas->itemconfigure(${ai_fleet_.$fleet_num},-image => $p2_down); 
						}
					}
					
					${previous_ai_fleet_.$fleet_num._x} = $ai_x_y[2*$fleet_num - 1];
					${previous_ai_fleet_.$fleet_num._y} = $ai_x_y[2*$fleet_num];	
				}
					
			##### up coords #######
			$canvas->coords(${ai_fleet_.$fleet_num},203-$cx[$j]+$ai_x_y[2*$fleet_num - 1],203-$cy[$j]+$ai_x_y[2*$fleet_num]);					
		}	
	
	}); 
	
	####### bind AI_fleet ######### 
	sub right_click_AI_fleet {	
		my $fleet_num = shift;
	
		####### make canvas #########
		my $right_click_info = $mw->Canvas(-background => "red",-width => 60,-height => 80,-highlightthickness => 0)->place(-x => 308 - $cx[$j] + $ai_x_y[ $fleet_num*2 - 1 ] + 5, -y => 180 - $cy[$j] + $ai_x_y[ $fleet_num*2 ]);
		$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
		
		####### make texts #########
		my $view = $right_click_info->createText( 23, 10, -text  => 'View', -font =>"Times 12 bold");
		my $gossip = $right_click_info->createText( 23, 30, -text  => 'Gossip',-font =>"Times 12 bold");
		my $battle = $right_click_info->createText( 23, 50, -text  => 'Battle',-font =>"Times 12 bold");

		####### bind texts #########
			####### view #########
			$right_click_info->bind($view,"<Button-1>",  sub {
				####### make canvas #########
				my $view_info = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 308 , -y => 180 );
				
				####### bind escape #########
				$mw->bind("<Escape>",  sub {
					$view_info->destroy();
					$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
				
				});  
		
				####### download data #########
				my @view_data = $redis->hgetall('ai'.$fleet_num.':view'); 

				####### display data #########
				for my $i(1..5) {
					$view_info->createText( 5, 10 + ($i-1)* 15, -text  => @view_data[2*$i - 1], -font =>"Times 12 bold", -anchor => 'w');
				}
				
				my @ships = split(/,/, @view_data[11]);  
				for my $i(1..@ships) {
					if ( $i <= 5 ) {
						$view_info->createText( 5, 20 + ($i + 5 -1)* 15, -text  => @ships[$i-1], -font =>"Times 12 bold", -anchor => 'w');
					}
					else {
						$view_info->createText( 70, 20 + ($i -1)* 15, -text  => @ships[$i-1], -font =>"Times 12 bold", -anchor => 'w');	
					}
				}
			});
			
			####### gossip #########
			$right_click_info->bind($gossip,"<Button-1>",  sub {
				####### make canvas #########
				my $gossip_info = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 308 , -y => 180 );
				
				####### bind escape #########
				$mw->bind("<Escape>",  sub {
					$gossip_info->destroy();
					$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
				});  

				####### download data #########
				my @gossip_data = $redis->hgetall('ai'.$fleet_num.':gossip'); 

				####### display data #########
				$gossip_info->createText( 20, 90, -text  => @gossip_data[1], -font =>"Times 12 bold", -anchor => 'w', -width => 80);									
			});
			
			####### battle #########
			$right_click_info->bind($battle,"<Button-1>",  sub {
				####### make canvas #########
				my $battle_info = $mw->Canvas(-background => "red",-width => 300,-height => 240,-highlightthickness => 0)->place(-x => 308 , -y => 180 );
				
				####### bind escape #########
				$mw->bind("<Escape>",  sub {
					$battle_info->destroy();
					$mw->bind("<Escape>",  sub {$right_click_info->destroy();}  );
				});  

				####### download data #########
				my @battle_data = $redis->hgetall('ai'.$fleet_num.':battle'); 
				
				####### display data #########
					####### above info #########
					$battle_info->createText( 5, 10 + 0*15, -text  => @battle_data[1], -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 1*15, -text  => @battle_data[3], -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 2*15, -text  => 'Age '."@battle_data[5]", -font =>"Times 12 bold", -anchor => 'w');
				
					####### bottom left info #########
					$battle_info->createText( 5, 10 + 4*15, -text  => "@battle_data[2*19 - 2] @battle_data[2*19 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 5*15, -text  => "@battle_data[2*4 - 2] @battle_data[2*4 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 6*15, -text  => "@battle_data[2*5 - 2] @battle_data[2*5 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 7*15, -text  => "@battle_data[2*6 - 2] @battle_data[2*6 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 8*15, -text  => "@battle_data[2*7 - 2] @battle_data[2*7 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 9*15, -text  => "@battle_data[2*8 - 2] @battle_data[2*8 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 5, 10 + 10*15, -text  => "@battle_data[2*9 - 2] @battle_data[2*9 - 1]", -font =>"Times 12 bold", -anchor => 'w');

					####### bottom right info #########
					$battle_info->createText( 130, 10 + 4*15, -text  => "@battle_data[2*10 - 2] @battle_data[2*10 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 5*15, -text  => "@battle_data[2*11 - 2] @battle_data[2*11 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 6*15, -text  => "@battle_data[2*12 - 2] @battle_data[2*12 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 7*15, -text  => "@battle_data[2*13 - 2] @battle_data[2*13 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					
					$battle_info->createText( 130, 10 + 9*15, -text  => "@battle_data[2*14 - 2] @battle_data[2*14 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 10*15, -text  => "@battle_data[2*15 - 2] @battle_data[2*15 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 11*15, -text  => "@battle_data[2*16 - 2] @battle_data[2*16 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 12*15, -text  => "@battle_data[2*17 - 2] @battle_data[2*17 - 1]", -font =>"Times 12 bold", -anchor => 'w');
					$battle_info->createText( 130, 10 + 13*15, -text  => "@battle_data[2*18 - 2] @battle_data[2*18 - 1]", -font =>"Times 12 bold", -anchor => 'w');
	
				####### enter battle #########
				my $enter_battle_widget = $battle_info->createText( 130, 10 + 0*15, -text  => 'Enter Battle', -font =>"Times 12 bold", -anchor => 'w');
				$battle_info->bind( $enter_battle_widget, "<Button-1>", sub { enter_battle_with_AI_fleet($fleet_num);});		

				
			});
	}
   
	$canvas->bind( $ai_fleet_1, "<Button-3>", sub {right_click_AI_fleet(1);});		
	$canvas->bind( $ai_fleet_2, "<Button-3>", sub {right_click_AI_fleet(2)});	
	$canvas->bind( $ai_fleet_3, "<Button-3>", sub {right_click_AI_fleet(3)});	
	
	######### when battle show self and other ships ############
	sub battle_show_self_and_others {			
		if($mp[$j] eq "battle_ground"){		
			####################### remove AI feet images ####################
			sub remove_AI_fleet {
				my $fleet_num = shift;
				
				##### up coords #######
				$canvas->coords(${ai_fleet_.$fleet_num}, 2000, 2000);					
			}
			remove_AI_fleet(1);
			remove_AI_fleet(2);
			remove_AI_fleet(3);	
		
			############# download data ship info ############
			sub read_ships_data{
				@d = ();
				foreach my $i ((0..9)){         					
					${VARclass.$i} = VARclass.$i;
					@{VARclass.$i} = DOWN_small_pipe(${VARclass.$i},ships2);

					${VARxinb.$i} = VARxinb.$i;
					@{VARxinb.$i} = DOWN_small_pipe(${VARxinb.$i},ships2);

					${VARyinb.$i} = VARyinb.$i;
					@{VARyinb.$i} = DOWN_small_pipe(${VARyinb.$i},ships2);

					${VARspeed.$i} = VARspeed.$i;
					@{VARspeed.$i} = DOWN_small_pipe(${VARspeed.$i},ships2);

					${VARdurability.$i} = VARdurability.$i;
					@{VARdurability.$i} = DOWN_small_pipe(${VARdurability.$i},ships2);

					${VARcrew.$i} = VARcrew.$i;
					@{VARcrew.$i} = DOWN_small_pipe(${VARcrew.$i},ships2);						
				}
				
				@VARmatename15 = DOWN_small_pipe(VARmatename15,mates10to15);
				$redis->wait_all_responses;
				
				foreach my $i ((0..9)){  
					pipe_get(VARclass.$i,$i+5*$i);
					pipe_get(VARxinb.$i,$i+1+5*$i);
					pipe_get(VARyinb.$i,$i+2+5*$i);
					pipe_get(VARspeed.$i,$i+3+5*$i);
					pipe_get(VARdurability.$i,$i+4+5*$i);
					pipe_get(VARcrew.$i,$i+5+5*$i);
				}
				pipe_get(VARmatename15,60);
			}
			read_ships_data();		

			############# change mid map and position ############
			$canvas->itemconfigure($pi,-image => $battle_left_png);
			$canvas->coords($pi,${VARxinb.0}[$j],${VARyinb.0}[$j]);
					 
			############# delete ship images covering grids ##########
			if(defined($myfleetimageinbattle[0])){
				for($i=0;$i<10;$i++){
					$canvas->delete($myfleetimageinbattle[$i], $myfleetNumber[$i]); ## delete my ships
					$canvas->delete($enemyfleetimageinbattle[$i], $enemyfleetNumber[$i]); ## delete enemy ships
				
				}
			}

			############# initial my and enemy fleet images and numbers ##########
			@myfleetimageinbattle = ();
			@myfleetNumber = ();
			@enemyfleetimageinbattle = ();
			@enemyfleetNumber = ();
	
			############# display my_fleet ##############
			for($i=0;$i<10;$i++){
				push(@myfleetimageinbattle, ${myfleetimageinbattle.$i});
			}
			for($i=0;$i<10;$i++){
				push(@myfleetNumber, ${myfleetNumber.$i});
			}
			for($i=0;$i<10;$i++){
				if(${VARclass.$i}[$j] ne "NA"){    #####  ${VARdurability.$empty_shipslot}[$j]   ${VARclass.$i}[$j]
					if(defined($myfleetimageinbattle[$i])){
						$canvas->itemconfigure($myfleetimageinbattle[$i],-image =>$pshipinbattlelist[${VARspeed.$i}[$j]]); 
						$canvas->coords($myfleetimageinbattle[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$j],203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]);
						$canvas->coords($myfleetNumber[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$j]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]-7);
				
					}
					else{
						$myfleetimageinbattle[$i] = $canvas->createImage(203+${VARxinb.0}[$j]-${VARxinb.$i}[$j],203+${VARyinb.0}[$j]-${VARyinb.$i}[$j], -image => $pshipinbattlelist[${VARspeed.$i}[$j]]);
						$myfleetNumber[$i] = $canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.$i}[$j]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]-7, -text => "$i", -font =>"Times 14 bold",-fill=>"white");
					}
				}
			}
	
			############ get other guy num  ###################
			for($na=1;$na<@on;$na++){
				if($on[$na]==1 && $na != $j && $mp[$j] eq $mp[$na] && $cy[$j] == $cy[$na]){
					$otherguy_num=$na;
					for($i=1;$i<7;$i++){
						if($VARspeed0[$otherguy_num] == $i){
							$canvas->itemconfigure($firstOther,-image => $pshipinbattlelist[$i]);
							$canvas->coords($firstOther,203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num]);
						}
					}						   
				}	
			}  		

			############ display enemy_fleet  ###################
			#@enemyfleetimageinbattle = ();
			for($i=0;$i<10;$i++){
				push(@enemyfleetimageinbattle, ${enemyfleetimageinbattle.$i});
			}
			#@enemyfleetNumber = ();
			for($i=0;$i<10;$i++){
				push(@enemyfleetNumber, ${enemyfleetNumber.$i});
			}
			for($i=0;$i<10;$i++){
				if(${VARclass.$i}[$otherguy_num] ne "NA"){    ##### #variable_variable ${VARdurability.$empty_shipslot}[$j]   ${VARclass.$i}[$j]
					if(defined($enemyfleetimageinbattle[$i])){
						$canvas->itemconfigure($enemyfleetimageinbattle[$i],-image =>$pshipinbattlelist[${VARspeed.$i}[$otherguy_num]]); 
						$canvas->coords($enemyfleetimageinbattle[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num]);
						$canvas->coords($enemyfleetNumber[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num]-7);				
					}
					else{
						$enemyfleetimageinbattle[$i] = $canvas->createImage(203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num], -image => $pshipinbattlelist[${VARspeed.$i}[$otherguy_num]]);
						$enemyfleetNumber[$i] = $canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num]-7, -text => "$i", -font =>"Times 14 bold",-fill=>"black");
					}
				}
			}
 
			############ IF other guy move END THEN enter battle mode ###################
			if($VARmatename15[$otherguy_num] eq "me"){ 
				$VARmatename15[$otherguy_num] = "afterme";
				UP_small_someone_from(VARmatename15,$VARmatename15[$otherguy_num],$otherguy_num,mates10to15);
				#battle2();
				my $temp = $canvasleft->createText(65,300,-text => "YOUR TURN!");	
			}

			############ IF other guy move attack END THEN enter battle mode  ###################
			if($VARmatename15[$otherguy_num] eq "mae"){ 
				$VARmatename15[$otherguy_num] = "aftermae";
				UP_small_someone_from(VARmatename15 ,"aftermae",$otherguy_num,mates10to15);
				attacked();
				sub attacked{   
					$cannon = $mw->Photo(-file => "images//z_others//cannon.png", -format => 'png',-width => 10,-height => 10 );
					#$cannon1=$canvas->createImage(203,203,-image => $cannon);
					$distance_x=${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num];
					$distance_y=${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num];

					$show_cannon1 = AnyEvent->timer (after => 0.5*1,  cb => sub{$cannon1=$canvas->createImage(203+4*$distance_x/5,203+4*$distance_y/5,-image => $cannon);});
					$show_cannon2 = AnyEvent->timer (after => 0.5*2,  cb => sub{$canvas->coords($cannon1,203+3*$distance_x/5,203+3*$distance_y/5);});
					$show_cannon3 = AnyEvent->timer (after => 0.5*3,  cb => sub{$canvas->coords($cannon1,203+2*$distance_x/5,203+2*$distance_y/5);});
					$show_cannon4 = AnyEvent->timer (after => 0.5*4,  cb => sub{$canvas->coords($cannon1,203+1*$distance_x/5,203+1*$distance_y/5);});

					my @durability=split(/</,$VARdurability0[$j]);

					$show_cannon5 = AnyEvent->timer (after => 0.5*5,  cb => sub{$durability_beforehit = $canvas->createText(203,203-30, -text => @durability[0]+3,-font =>"Times 12 bold",-fill=>"red");$canvas->delete($cannon1);});
									$show_cannon6 = AnyEvent->timer (after => 0.5*6,  cb => sub{$canvas->itemconfigure($durability_beforehit, -text => @durability[0]);});
					$show_cannon7 = AnyEvent->timer (after => 0.5*7,  cb => sub{$canvas->delete($durability_beforehit);});
					#$my_turntoattack = AnyEvent->timer (after => 0.5*8,  cb => sub{battle2();});				
				} 			
				#battle2();
				#test  $canvasleft->createText(65,280,-text => "22222");
			}

			############ if other guys move attack still going ###################
			if($VARmatename15[$otherguy_num] =~ m/magoing/ ){ 				
				my $whichship = substr("$VARmatename15[$otherguy_num]", 7, 1);
				my $target = substr("$VARmatename15[$otherguy_num]", 8, 1);

				$VARmatename15[$otherguy_num] = "aftermae";
				UP_small_someone_from(VARmatename15 ,"aftermae",$otherguy_num,mates10to15);
				
				sub attackedByOthers_Player{  
					my $whichship = shift;
					my $target = shift; 

					my @durability=split(/</,${VARdurability.$target}[$j]);
					my $cannon = $mw->Photo(-file => "images//z_others//cannon.png", -format => 'png',-width => 10,-height => 10 );
					
					
					my $distance_x=${VARxinb.$target}[$j]-${VARxinb.$whichship}[$otherguy_num];
					my $distance_y=${VARyinb.$target}[$j]-${VARyinb.$whichship}[$otherguy_num];

					my $zx = $VARxinb0[$j]-${VARxinb.$target}[$j];
					my $zy = $VARyinb0[$j]-${VARyinb.$target}[$j];
								
					my $show_cannon1 = $mw->after(1000*0.5*1, sub{$cannon1=$canvas->createImage(203+$VARxinb0[$j]-${VARxinb.$target}[$j]+4*$distance_x/5,203+$VARyinb0[$j]-${VARyinb.$target}[$j]+4*$distance_y/5,-image => $cannon);});				
					my $show_cannon2 = $mw->after(1000*0.5*2, sub{$canvas->coords($cannon1,203+$zx+3*$distance_x/5,203+$zy+3*$distance_y/5);});
					my $show_cannon3 = $mw->after(1000*0.5*3, sub{$canvas->coords($cannon1,203+$zx+2*$distance_x/5,203+$zy+2*$distance_y/5);});
					my $show_cannon4 = $mw->after(1000*0.5*4, sub{$canvas->coords($cannon1,203+$zx+1*$distance_x/5,203+$zy+1*$distance_y/5);});					
					my $show_cannon5 = $mw->after(1000*0.5*5, sub{$durability_beforehit = $canvas->createText(203+$zx,203+$zy-30, -text => @durability[0],-font =>"Times 12 bold",-fill=>"red");$canvas->delete($cannon1);});
					my $show_cannon6 = $mw->after(1000*0.5*6, sub{$canvas->itemconfigure($durability_beforehit, -text => @durability[0]-3);});
					my $show_cannon7 = $mw->after(1000*0.5*7, sub{$canvas->delete($durability_beforehit);});
				
				} 
				attackedByOthers_Player($whichship,$target);

				print "$whichship attacked $target\n";
			}
			
			############ if other guys move engage still going then show crew engaging ###################
			if( $VARmatename15[$otherguy_num] =~ m/MEgoing/ ){ 
				my $whichship = substr("$VARmatename15[$otherguy_num]", 7, 1);
				my $target = substr("$VARmatename15[$otherguy_num]", 8, 1);

				$VARmatename15[$otherguy_num] = "aftermae";
				UP_small_someone_from(VARmatename15 ,"aftermae",$otherguy_num,mates10to15);
				
				
				sub engagedByOthers_player{  
					my $whichship = shift;
					my $target = shift; 
					
					######### get target and which ship crew number ##############
					my @crew_target = split(/</,${VARcrew.$target}[$j]);
					my @crew_whichship = split(/</,${VARcrew.$whichship}[$otherguy_num]);

					############ show crew engaged ##########
					$mw->after(0, [\&ShowCrewHit_Player, $whichship, $target]);
					sub ShowCrewHit_Player {
						my $i = shift; 
						my $m = shift; 
						
						my $crew_hit_icon_1 = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$i}[$otherguy_num],203+$VARyinb0[$j]- ${VARyinb.$i}[$otherguy_num] , -text => X,-font =>"Times 12 bold",-fill=>"black");
						my $crew_hit_icon_2 = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$m}[$j],203+$VARyinb0[$j]- ${VARyinb.$m}[$j] , -text => X,-font =>"Times 12 bold",-fill=>"black");
			
						$mw->after(1000,sub {
							$canvas->delete($crew_hit_icon_1, $crew_hit_icon_2);					
						});									
					}			
				} 
				engagedByOthers_player($whichship,$target);

				print "$whichship attacked $target\n";			
			
			}			

			############ if end battle signal received  ###################
			if($VARmatename15[$j] eq "end" ){      
				$VARmatename15[$j] = 0;
				UP_small_someone_from(VARmatename15 ,0,$j,mates10to15);
				$mp[$j] = "sea";
				UP_small_someone_from(VARmp,$mp[$j],$j,primary1);

				################ delete my and enemy ships in battle ###################
				if(defined($myfleetimageinbattle[0])){
					for($i=0;$i<10;$i++){
						$canvas->delete($myfleetimageinbattle[$i], $myfleetNumber[$i]); ## delete my ships
						$canvas->delete($enemyfleetimageinbattle[$i], $enemyfleetNumber[$i]); ## delete enemy ships				
					}
				}
				@myfleetimageinbattle = ();
				@myfleetNumber = ();
				@enemyfleetimageinbattle = ();
				@enemyfleetNumber = ();				
			}	
		}		 
	}

	$mw->repeat(200, \&battle_show_self_and_others); 
	
sub battle_show_self_and_AI {			
		if($mp[$j] eq "battle_ground_with_AI"){		
			####################### remove AI feet images ####################
			sub remove_AI_fleet {
				my $fleet_num = shift;
				
				##### up coords #######
				$canvas->coords(${ai_fleet_.$fleet_num}, 2000, 2000);					
			}
			remove_AI_fleet(1);
			remove_AI_fleet(2);
			remove_AI_fleet(3);	
		
			############# download data ship info ############
			sub read_ships_data{
				@d = ();
				foreach my $i ((0..9)){         					
					${VARclass.$i} = VARclass.$i;
					@{VARclass.$i} = DOWN_small_pipe(${VARclass.$i},ships2);

					${VARxinb.$i} = VARxinb.$i;
					@{VARxinb.$i} = DOWN_small_pipe(${VARxinb.$i},ships2);

					${VARyinb.$i} = VARyinb.$i;
					@{VARyinb.$i} = DOWN_small_pipe(${VARyinb.$i},ships2);

					${VARspeed.$i} = VARspeed.$i;
					@{VARspeed.$i} = DOWN_small_pipe(${VARspeed.$i},ships2);

					${VARdurability.$i} = VARdurability.$i;
					@{VARdurability.$i} = DOWN_small_pipe(${VARdurability.$i},ships2);

					${VARcrew.$i} = VARcrew.$i;
					@{VARcrew.$i} = DOWN_small_pipe(${VARcrew.$i},ships2);						
				}
				
				@VARmatename15 = DOWN_small_pipe(VARmatename15,mates10to15);
				$redis->wait_all_responses;
				
				foreach my $i ((0..9)){  
					pipe_get(VARclass.$i,$i+5*$i);
					pipe_get(VARxinb.$i,$i+1+5*$i);
					pipe_get(VARyinb.$i,$i+2+5*$i);
					pipe_get(VARspeed.$i,$i+3+5*$i);
					pipe_get(VARdurability.$i,$i+4+5*$i);
					pipe_get(VARcrew.$i,$i+5+5*$i);
				}
				pipe_get(VARmatename15,60);
			}
			read_ships_data();		

			############# change mid map and position ############
			$canvas->itemconfigure($pi,-image => $battle_left_png);
			$canvas->coords($pi,${VARxinb.0}[$j],${VARyinb.0}[$j]);
					 
			############# delete ship images covering grids ##########
			if(defined($myfleetimageinbattle[0])){
				for($i=0;$i<10;$i++){
					$canvas->delete($myfleetimageinbattle[$i], $myfleetNumber[$i]); ## delete my ships
					$canvas->delete($enemyfleetimageinbattle[$i], $enemyfleetNumber[$i]); ## delete enemy ships
				
				}
			}

			############# initial my and enemy fleet images and numbers ##########
			@myfleetimageinbattle = ();
			@myfleetNumber = ();
			@enemyfleetimageinbattle = ();
			@enemyfleetNumber = ();
	
			############# display my_fleet ##############
			for($i=0;$i<10;$i++){
				push(@myfleetimageinbattle, ${myfleetimageinbattle.$i});
			}
			for($i=0;$i<10;$i++){
				push(@myfleetNumber, ${myfleetNumber.$i});
			}
			for($i=0;$i<10;$i++){
				if(${VARclass.$i}[$j] ne "NA"){    #####  ${VARdurability.$empty_shipslot}[$j]   ${VARclass.$i}[$j]
					if(defined($myfleetimageinbattle[$i])){
						$canvas->itemconfigure($myfleetimageinbattle[$i],-image =>$pshipinbattlelist[${VARspeed.$i}[$j]]); 
						$canvas->coords($myfleetimageinbattle[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$j],203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]);
						$canvas->coords($myfleetNumber[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$j]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]-7);
				
					}
					else{
						$myfleetimageinbattle[$i] = $canvas->createImage(203+${VARxinb.0}[$j]-${VARxinb.$i}[$j],203+${VARyinb.0}[$j]-${VARyinb.$i}[$j], -image => $pshipinbattlelist[${VARspeed.$i}[$j]]);
						$myfleetNumber[$i] = $canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.$i}[$j]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]-7, -text => "$i", -font =>"Times 14 bold",-fill=>"white");
					}
				}
			}
			
			################ get AI ships data ################			
			@pipe_get_data = ();
			@AI_battle_status = ();
			
			for my $i(0..9) {
				$redis->hmget('ai'.$otherguy_num.':in_battle:ship'.$i, X, Y, Direction, Class, Durability, Crew, sub  {
					my ($reply, $error) = @_;
					push(@pipe_get_data, $reply);
				}); 
			}	
			
			$redis->hmget('ai'.$otherguy_num.':battle', Battle_status, sub  {
				my ($reply, $error) = @_;
				push(@AI_battle_status, $reply);   #print $AI_battle_status[0]->[0]
			}); 
				

			
			$redis->wait_all_responses;			# print @pipe_get_data[3]->[3];	

			########## display enemy_fleet  ###################
			@enemyfleetimageinbattle = ();
			for($i=0;$i<10;$i++){
				push(@enemyfleetimageinbattle, ${enemyfleetimageinbattle.$i});
			}
			@enemyfleetNumber = ();
			for($i=0;$i<10;$i++){
				push(@enemyfleetNumber, ${enemyfleetNumber.$i});
			}
			for($i=0;$i<10;$i++){
				if(@pipe_get_data[$i]->[3] ne "NA"){    ##### #variable_variable ${VARdurability.$empty_shipslot}[$j]   ${VARclass.$i}[$j]
					if(defined($enemyfleetimageinbattle[$i])){
						$canvas->itemconfigure($enemyfleetimageinbattle[$i],-image =>$pshipinbattlelist[@pipe_get_data[$i]->[2]]); 
						$canvas->coords($enemyfleetimageinbattle[$i],203+${VARxinb.0}[$j]-@pipe_get_data[$i]->[0],203+${VARyinb.0}[$j]-@pipe_get_data[$i]->[1]);
						$canvas->coords($enemyfleetNumber[$i],203+${VARxinb.0}[$j]-@pipe_get_data[$i]->[0]-11,203+${VARyinb.0}[$j]-@pipe_get_data[$i]->[1]-7);				
					}
					else{
						$enemyfleetimageinbattle[$i] = $canvas->createImage(203+${VARxinb.0}[$j]-@pipe_get_data[$i]->[0],203+${VARyinb.0}[$j]-@pipe_get_data[$i]->[1], -image => $pshipinbattlelist[@pipe_get_data[$i]->[2]]);
						$enemyfleetNumber[$i] = $canvas->createText(203+${VARxinb.0}[$j]-@pipe_get_data[$i]->[0]-11,203+${VARyinb.0}[$j]-@pipe_get_data[$i]->[1]-7, -text => "$i", -font =>"Times 14 bold",-fill=>"black");
					}
				}
			}
 
			############ IF other guy move END THEN enter battle mode ###################
			if( $AI_battle_status[0]->[0] eq "me" ){  
				$AI_battle_status[0]->[0] = "afterme";
				
				
				$redis->hset('ai'.$otherguy_num.':battle', 'Battle_status', $AI_battle_status[0]->[0]);
				#battle2();
				my $temp = $canvasleft->createText(65,300,-text => "YOUR TURN!");	
				
				enter_battle_with_AI_fleet($otherguy_num);
			}

			# ############ IF other guy move attack END THEN enter battle mode  ###################
			# if($VARmatename15[$otherguy_num] eq "mae"){ 
				# $VARmatename15[$otherguy_num] = "aftermae";
				# UP_small_someone_from(VARmatename15 ,"aftermae",$otherguy_num,mates10to15);
				# attacked();
				# sub attacked{   
					# $cannon = $mw->Photo(-file => "images//z_others//cannon.png", -format => 'png',-width => 10,-height => 10 );
					# #$cannon1=$canvas->createImage(203,203,-image => $cannon);
					# $distance_x=${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num];
					# $distance_y=${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num];

					# $show_cannon1 = AnyEvent->timer (after => 0.5*1,  cb => sub{$cannon1=$canvas->createImage(203+4*$distance_x/5,203+4*$distance_y/5,-image => $cannon);});
					# $show_cannon2 = AnyEvent->timer (after => 0.5*2,  cb => sub{$canvas->coords($cannon1,203+3*$distance_x/5,203+3*$distance_y/5);});
					# $show_cannon3 = AnyEvent->timer (after => 0.5*3,  cb => sub{$canvas->coords($cannon1,203+2*$distance_x/5,203+2*$distance_y/5);});
					# $show_cannon4 = AnyEvent->timer (after => 0.5*4,  cb => sub{$canvas->coords($cannon1,203+1*$distance_x/5,203+1*$distance_y/5);});

					# my @durability=split(/</,$VARdurability0[$j]);

					# $show_cannon5 = AnyEvent->timer (after => 0.5*5,  cb => sub{$durability_beforehit = $canvas->createText(203,203-30, -text => @durability[0]+3,-font =>"Times 12 bold",-fill=>"red");$canvas->delete($cannon1);});
									# $show_cannon6 = AnyEvent->timer (after => 0.5*6,  cb => sub{$canvas->itemconfigure($durability_beforehit, -text => @durability[0]);});
					# $show_cannon7 = AnyEvent->timer (after => 0.5*7,  cb => sub{$canvas->delete($durability_beforehit);});
					# #$my_turntoattack = AnyEvent->timer (after => 0.5*8,  cb => sub{battle2();});				
				# } 			
				# #battle2();
				# #test  $canvasleft->createText(65,280,-text => "22222");
			# }

			############ if other guys move shoot still going then show cannon ball hitting ###################
			if( $AI_battle_status[0]->[0] =~ m/magoing/ ){ 		#$AI_battle_status[0]->[0]		
				my $whichship = substr("$AI_battle_status[0]->[0]", 7, 1);
				my $target = substr("$AI_battle_status[0]->[0]", 8, 1);

				$AI_battle_status[0]->[0] = "aftermae";
				$redis->hset('ai'.$otherguy_num.':battle', 'Battle_status', $AI_battle_status[0]->[0]);
				
				
				sub attackedByOthers_AI{  
					my $whichship = shift;
					my $target = shift; 

					my @durability=split(/</,${VARdurability.$target}[$j]);
					my $cannon = $mw->Photo(-file => "images//z_others//cannon.png", -format => 'png',-width => 10,-height => 10 );
					
					
					my $distance_x=${VARxinb.$target}[$j]-@pipe_get_data[$whichship]->[0];
					my $distance_y=${VARyinb.$target}[$j]-@pipe_get_data[$whichship]->[1];

					my $zx = $VARxinb0[$j]-${VARxinb.$target}[$j];
					my $zy = $VARyinb0[$j]-${VARyinb.$target}[$j];
								
					my $show_cannon1 = $mw->after(1000*0.5*1, sub{$cannon1=$canvas->createImage(203+$VARxinb0[$j]-${VARxinb.$target}[$j]+4*$distance_x/5,203+$VARyinb0[$j]-${VARyinb.$target}[$j]+4*$distance_y/5,-image => $cannon);});				
					my $show_cannon2 = $mw->after(1000*0.5*2, sub{$canvas->coords($cannon1,203+$zx+3*$distance_x/5,203+$zy+3*$distance_y/5);});
					my $show_cannon3 = $mw->after(1000*0.5*3, sub{$canvas->coords($cannon1,203+$zx+2*$distance_x/5,203+$zy+2*$distance_y/5);});
					my $show_cannon4 = $mw->after(1000*0.5*4, sub{$canvas->coords($cannon1,203+$zx+1*$distance_x/5,203+$zy+1*$distance_y/5);});					
					my $show_cannon5 = $mw->after(1000*0.5*5, sub{$durability_beforehit = $canvas->createText(203+$zx,203+$zy-30, -text => @durability[0],-font =>"Times 12 bold",-fill=>"red");$canvas->delete($cannon1);});
					my $show_cannon6 = $mw->after(1000*0.5*6, sub{$canvas->itemconfigure($durability_beforehit, -text => @durability[0]-3);});
					my $show_cannon7 = $mw->after(1000*0.5*7, sub{$canvas->delete($durability_beforehit);});
				
				} 
				attackedByOthers_AI($whichship,$target);

				print "$whichship attacked $target\n";
			}
			
			############ if other guys move engage still going then show crew engaging ###################
			if( $AI_battle_status[0]->[0] =~ m/MEgoing/ ){ 
				my $whichship = substr("$AI_battle_status[0]->[0]", 7, 1);
				my $target = substr("$AI_battle_status[0]->[0]", 8, 1);

				$AI_battle_status[0]->[0] = "aftermae";
				$redis->hset('ai'.$otherguy_num.':battle', 'Battle_status', $AI_battle_status[0]->[0]);
				
				
				sub engagedByOthers_AI{  
					my $whichship = shift;
					my $target = shift; 
					
					######### get target and which ship crew number ##############
					my @crew_target = split(/</,${VARcrew.$target}[$j]);
					my @crew_whichship = split(/</,@pipe_get_data[$whichship]->[5]);

					############ show crew engaged ##########
					$mw->after(0, [\&ShowCrewHit_AI, $whichship, $target]);
					sub ShowCrewHit_AI {
						my $i = shift; 
						my $m = shift; 
						
						my $crew_hit_icon_1 = $canvas->createText(203+$VARxinb0[$j]- $pipe_get_data[$i]->[0],203+$VARyinb0[$j]- $pipe_get_data[$i]->[1] , -text => X,-font =>"Times 12 bold",-fill=>"black");
						my $crew_hit_icon_2 = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$m}[$j],203+$VARyinb0[$j]- ${VARyinb.$m}[$j] , -text => X,-font =>"Times 12 bold",-fill=>"black");
			
						$mw->after(1000,sub {
							$canvas->delete($crew_hit_icon_1, $crew_hit_icon_2);					
						});									
					}			
				} 
				engagedByOthers_AI($whichship,$target);

				print "$whichship attacked $target\n";			
			
			}

			# ############ if end battle signal received  ###################
			# if($VARmatename15[$j] eq "end" ){      
				# $VARmatename15[$j] = 0;
				# UP_small_someone_from(VARmatename15 ,0,$j,mates10to15);
				# $mp[$j] = "sea";
				# UP_small_someone_from(VARmp,$mp[$j],$j,primary1);

				# ################ delete my and enemy ships in battle ###################
				# if(defined($myfleetimageinbattle[0])){
					# for($i=0;$i<10;$i++){
						# $canvas->delete($myfleetimageinbattle[$i], $myfleetNumber[$i]); ## delete my ships
						# $canvas->delete($enemyfleetimageinbattle[$i], $enemyfleetNumber[$i]); ## delete enemy ships				
					# }
				# }
				# @myfleetimageinbattle = ();
				# @myfleetNumber = ();
				# @enemyfleetimageinbattle = ();
				# @enemyfleetNumber = ();				
			# }	
		}		 
	}

	$mw->repeat(200, \&battle_show_self_and_AI); 	
	
	sub remove__ship_images_in_battle {
		################ auto delete my and enemy ships after battle battle ###################
		if($mp[$j] eq 'sea'){
			if(defined($myfleetimageinbattle[0])){
				for($i=0;$i<10;$i++){
					$canvas->delete($myfleetimageinbattle[$i], $myfleetNumber[$i]); ## delete my ships
					$canvas->delete($enemyfleetimageinbattle[$i], $enemyfleetNumber[$i]); ## delete enemy ships		
				}
				
				@myfleetimageinbattle = ();
				@myfleetNumber = ();
				@enemyfleetimageinbattle = ();
				@enemyfleetNumber = ();	
			}
		}
	}
		
	$mw->repeat(200, \&remove__ship_images_in_battle); 
	
	##### see x and y change #####
	# my $temp = $canvasleft->createText(25,290, -text => "x: $cx[$j] \ny: $cy[$j]");
	# $mw->repeat(200, sub { $canvasleft->itemconfigure($temp,-text => "x: $cx[$j] \ny: $cy[$j]"); }); 	
	
	##### update public chat_message #####
		##### initiate text widgets #####
		my $public_message_1 = $canvas->createText( 2000, 2000, -text => "  ", -fill => 'white'); 
		my $public_message_2 = $canvas->createText( 2000, 2000, -text => "  ", -fill => 'white'); 
		my $public_message_3 = $canvas->createText( 2000, 2000, -text => "  ", -fill => 'white'); 
		my $public_message_4 = $canvas->createText( 2000, 2000, -text => "  ", -fill => 'white'); 
		my $public_message_5 = $canvas->createText( 2000, 2000, -text => "  ", -fill => 'white'); 
		
		my @public_message_list = ($public_message_1, $public_message_2, $public_message_3, $public_message_4, $public_message_5 );
		
		##### update text widgets #####
		$mw->repeat(200, sub {
			
			##### clear text widgets #####
			for my $i(1..5) { 
				$canvas->itemconfigure( $public_message_list[$i-1], -text => " "); 		
			}
		
			##### get @players_with_public_message by adding to list if player has message #####
			my @players_with_public_message;
			
			for my $i(1..@pubmes-1) {
				if ( $pubmes[$i] ne '0' ) {
					push( @players_with_public_message, $i );	
				}		
			}

			##### get @players_with_public_message_and_in_range #####
			my @players_with_public_message_and_in_range;
			
			for my $i( 1..@players_with_public_message ) {
				if ( $mp[$j] eq $mp[$players_with_public_message[$i-1]] ) {
					push( @players_with_public_message_and_in_range, $players_with_public_message[$i-1] );	
				}		
			}
			
			##### update message on top of player #####
				##### get number of messages to update #####
				my $size;
				if ( @players_with_public_message_and_in_range <= 4 ) {
					$size = @players_with_public_message_and_in_range;
				}
				else {
					$size = 5;
				}
					
				##### update message #####
				if ( $size == 0 ) {
				}
				else {
					for my $i(1..$size) {					
						my $k = $players_with_public_message_and_in_range[$i-1];
						my $message = convert_gbk_to_utf8($pubmes[$k]);
						
						$canvas->itemconfigure( $public_message_list[$i-1], -text => "$message"); 		
						$canvas->coords( $public_message_list[$i-1], 203-$cx[$j]+$cx[$k], 203-$cy[$j]+$cy[$k]-20,); 	
					}	
				}				
		}); 
	
	
	##### update world chat_message #####
		##### background #####
		my $transparent_chat_canvas_photo = $mw->Photo(-file => 'images//z_others//'."transparent_chat_canvas.png", -format => 'png',-width => 230,-height => 190 );
		my $transparent_chat_box_image = $canvas->createImage( 110,313, -image => $transparent_chat_canvas_photo);
	
		##### text #####
		my $chat_box = $canvas->createText(22, 295, -text => "nothing", -anchor => "w", -fill => 'white'); 
		
		
		my sub start_chat_timer {
			$chat_timer = $mw->repeat(200, sub { 
				my @chat_message_10 = @chat_message[ @a-10..@a-1 ];
				$canvas->itemconfigure($chat_box,-text => " @chat_message_10"); 
			}); 
		}
		start_chat_timer();

		##### navigation buttons #####
			##### make texts #####
			my $go_up = $canvas->createText(5, 300, -text => "^", -anchor => "w", -fill => 'white', -font =>"Times 12 bold");    
			my $go_down = $canvas->createText(5, 320, -text => "v", -anchor => "w", -fill => 'white', -font =>"Times 12 bold");    
			my $go_down_to_bottom = $canvas->createText(5, 340, -text => "V", -anchor => "w", -fill => 'white', -font =>"Times 12 bold");   

			##### bind texts #####
				##### bind motion_leave #####
				my sub bind_motion_leave_white_canvas {    	
					my $a = shift;
					my $b = shift;
					$b->bind($a,"<Motion>",  sub{
						$b->itemconfigure($a, -font =>"Times 12 bold ",-fill=>"yellow");
					});
					$b->bind($a,"<Leave>",  sub {
						$b->itemconfigure($a, -font =>"Times 12 bold",-fill=>"white");
					});
				}
				
				bind_motion_leave_white_canvas($go_up, $canvas);
				bind_motion_leave_white_canvas($go_down, $canvas);
				bind_motion_leave_white_canvas($go_down_to_bottom, $canvas);
			
				##### bind click #####
					##### bind up #####
					my $move_up_index = 0;
					my $move_down_index = 0;
					
					$canvas->bind( $go_up, "<Button-1>",  sub {
						##### stop chat_timer #####
						if ( defined($chat_timer) ) {
							$chat_timer->cancel;
							undef $chat_timer;
						}
						
						##### store @chat_message #####
						if ( !(@frozen_chat_message) ) {
							@frozen_chat_message   = @chat_message;
							$move_up_index = 0;
							$move_down_index = 0;
						}
						
						##### move messages up #####
						$move_up_index += 1;
						my @chat_message_10 = @frozen_chat_message[ @a-10-$move_up_index+$move_down_index..@a-1-$move_up_index+$move_down_index ];
						$canvas->itemconfigure($chat_box,-text => " @chat_message_10"); 
						
						
					});
		
					##### bind down #####					
					$canvas->bind( $go_down, "<Button-1>",  sub {
						##### stop chat_timer #####
						if ( defined($chat_timer) ) {
							$chat_timer->cancel;
							undef $chat_timer;
						}
						
						##### store @chat_message #####
						if ( !(@frozen_chat_message) ) {
							@frozen_chat_message   = @chat_message;
							$move_down_index = 0;
							$move_up_index = 0;
						}
						
						##### move messages up #####
						$move_down_index += 1;
						my @chat_message_10 = @frozen_chat_message[ @a-10-$move_up_index+$move_down_index..@a-1-$move_up_index+$move_down_index ];
						$canvas->itemconfigure($chat_box,-text => " @chat_message_10"); 
						
						
					});
		
					##### bind down_to_bottom #####
					my $entrybox;
					
					$canvas->bind( $go_down_to_bottom, "<Button-1>",  sub {
						if ( !defined($chat_timer) ) {
							start_chat_timer();
						}
						
						if ( @frozen_chat_message ) {
							undef @frozen_chat_message;
						}	
						
						######### sub in c_13_enter_to_speak ###########
						if ( Exists($entrybox) ) {
	
						}
						else {
							my $enteredvalue;
							$entrybox = $mw->Entry(-textvariable => \$enteredvalue,-width => 35)->place(-x => 100, -y => 375);
							$entrybox->focus;
							$entrybox->bind('<Return>', sub { 
								$entrybox->destroy;
								if ( $enteredvalue ne '') {
									my $punctuation = "; ";
									my $message = $player_name . $punctuation . $enteredvalue;
									$message = convert_utf8_to_gbk($message);
									
									$redis->publish('world_chat', "$message");
								}
							});
						}	
						
					});
			
	
	
	##### update ocean_day #####
	$ocean_day_box = $canvasright->createText( 75,250, -text => 0, -font =>"Times 12 bold");
	$mw->repeat(200, sub { $canvasright->itemconfigure($ocean_day_box,-text => "@ocean_day[$j]"); }); 	

	################ update supply ####################
	$water_all = $canvasleft->createText(65  , 270, -text  => " ", -font =>"Times 12 bold");
	$food_all = $canvasleft->createText(65  , 270+35, -text  => " ", -font =>"Times 12 bold");
	$lumber_all = $canvasleft->createText(65  , 270+35*2, -text  => " ", -font =>"Times 12 bold");
	$shot_all = $canvasleft->createText(65  , 270+35*3, -text  => " ", -font =>"Times 12 bold");

	$mw->repeat( 200, sub { 
		if ( $mp[$j] eq 'sea' ) {
			$canvasleft->itemconfigure($water_all, -text => "@water_all1[$j]"); 
			$canvasleft->itemconfigure($food_all, -text => "@food_all1[$j]");
			$canvasleft->itemconfigure($lumber_all, -text => "@lumber_all1[$j]");
			$canvasleft->itemconfigure($shot_all, -text => "@shot_all1[$j]");
		}
	});
    
	###### update npc_moving x and y #########
	my sub update_npc_moving {  ##  update_npc_moving('npc_moving_2_x', 'npc_moving_2_y', 'npc_moving_2', 'man');
		my $npc_moving_2_x = shift;
		my $npc_moving_2_y = shift;
		my $npc_moving_2 = shift;
		my $man_or_lady = shift;
	
		$mw->repeat(500, sub { 
			if($mp[$j] ne "sea" && $mp[$j] ne 'battle_ground' && $mp[$j] ne 'battle_ground_with_AI'){	
				my $rand_num_1 = int(rand(2));
				my $rand_num_2 = int(rand(2));
			
				if($rand_num_1 == 0 && $rand_num_2 == 0){
					if( at($piddle, ${$npc_moving_2_x}/16, ${$npc_moving_2_y}/16) ~~ @walkabale_tiles && at($piddle, ${$npc_moving_2_x}/16 + 1, ${$npc_moving_2_y}/16) ~~ @walkabale_tiles){						
						if(${$npc_moving_2_y}/16 >= 4){						
							if($canvas->itemcget(${$npc_moving_2}, -image) == ${'p_moving_npc_'.$man_or_lady.'_up_1'}){	   #  p_moving_npc_lady_up_1
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_up_2'}); 
							}
							else{
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_up_1'}); 
							}
							
							${$npc_moving_2_y} -= 16;	
						}
					}			
				}
				elsif($rand_num_1 == 1 && $rand_num_2 == 0){
					if( at($piddle, ${$npc_moving_2_x}/16, ${$npc_moving_2_y}/16 + 2 ) ~~ @walkabale_tiles && at($piddle, ${$npc_moving_2_x}/16 + 1, ${$npc_moving_2_y}/16 + 2 ) ~~ @walkabale_tiles){
						if(${$npc_moving_2_y}/16 <= 90){		
							if($canvas->itemcget(${$npc_moving_2}, -image) == ${'p_moving_npc_'.$man_or_lady.'_down_1'}){	
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_down_2'}); 
							}
							else{
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_down_1'}); 
							}
							
							${$npc_moving_2_y} += 16;	
						}	
					}
				}
				elsif($rand_num_1 == 0 && $rand_num_2 == 1){
					if( at($piddle, ${$npc_moving_2_x}/16 - 1, ${$npc_moving_2_y}/16 + 1 ) ~~ @walkabale_tiles ){
						if(${$npc_moving_2_x}/16 >= 4){		
							if($canvas->itemcget(${$npc_moving_2}, -image) == ${'p_moving_npc_'.$man_or_lady.'_left_1'}){	
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_left_2'}); 
							}
							else{
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_left_1'}); 
							}
							
							${$npc_moving_2_x} -= 16;	
						}	
					}
				}
				elsif($rand_num_1 == 1 && $rand_num_2 == 1){
					if( at($piddle, ${$npc_moving_2_x}/16 + 2 , ${$npc_moving_2_y}/16 + 1 ) ~~ @walkabale_tiles ){
						if(${$npc_moving_2_x}/16 <= 90){		
							if($canvas->itemcget(${$npc_moving_2}, -image) == ${'p_moving_npc_'.$man_or_lady.'_right_1'}){	
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_right_2'}); 
							}
							else{
								$canvas->itemconfigure(${$npc_moving_2},-image => ${'p_moving_npc_'.$man_or_lady.'_right_1'}); 
							}
							
							${$npc_moving_2_x} += 16;	
						}	
					}
				}
			}
		}); 	
	}
	
	update_npc_moving('npc_moving_2_x', 'npc_moving_2_y', 'npc_moving_2', 'man');
	update_npc_moving('npc_moving_1_x', 'npc_moving_1_y', 'npc_moving_1', 'lady');
	
	
1;	