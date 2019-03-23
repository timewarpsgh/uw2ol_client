	############## !port_call ############################
	sub port_call2{ 
		my $response = command_get(portCall); 	
		$response = substr($response,0,-1);
		
		if($response eq "0\n"){
		} 
		else{
			################ set move_interval back to port speed ########################
			$move_interval = 200;

			################ get port_index and tile_set ########################
			my $json = JSON->new->allow_nonref;
			my $hash_ref = $json->decode($response);
		
			my $port_name = $hash_ref->{port_name};
		
			# print %$hash_ref;
		
			################ get port_index and tile_set ########################
			# my $port_index;
			for $i(1..101){
				if(${$ports{$i}}{name} eq "$port_name"){
					$port_index = $i - 1;
					last;
				}
			}
					
			$port_tile_set = 2*${$ports{$port_index+1}}{tileset};
			$port_tile_set = sprintf("%03s", $port_tile_set);
			
			$port_index_with_leaidng_zero = sprintf("%03s", $port_index);
		
			# print "~~~~~~~~   $port_index_with_leaidng_zero \n";
			# print "~~~~~~~~ $port_tile_set";
		
			################ create port image ########################
				######  big image  ##########
				if(defined($portImage)){
					$portImage->delete;
				}
				
				($piddle, $port_image)  = get_port_piddle_and_image('PORTMAP.'."$port_index_with_leaidng_zero", 'PORTCHIP.'.$port_tile_set);
				$data = image2data($port_image);
								
				$portImage = $mw->Photo(-data => $data, -format => 'png',-width => 96*16,-height => 96*16);
				
				######  mini image  ##########
				if(defined($portImage_mini)){
					$portImage_mini->delete;
				}
				
				$portImageShrinked = $port_image->scale(scalefactor=>0.1);
				$data = image2data($portImageShrinked);
						
				$portImage_mini = $mw->Photo(-data => $data, -format => 'png',-width => 141,-height => 159);
			
			################ change mid_map ########################
			$canvas->itemconfigure($pi,-image => $portImage);   		 
			$mp[$j]=land;
			
			######### create moving npcs ###############
				######### lady ###############
				$npc_moving_1_x = 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x};
				$npc_moving_1_y = 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y};
				# $npc_moving_1 = $canvas->createImage( 204 - $cx[$j] + $npc_moving_1_x , 204 - $cy[$j] + $npc_moving_1_y, -image => $p_moving_npc_lady_up_1);
				
				######### man ###############
				$npc_moving_2_x = 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x};
				$npc_moving_2_y = 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y};
				# $npc_moving_2 = $canvas->createImage( 204 - $cx[$j] + $npc_moving_2_x , 204 - $cy[$j] + $npc_moving_2_y, -image => $p_moving_npc_man_up_1);

			
			################ change right canvas ########################
			$canvasright->itemconfigure( $right_image, -image => $pright_port );  
			$canvasright->coords($ocean_day_box, 2000, 2000);
			$canvasright->delete($speed_average_box);
			
			
				################ create texts ########################	
				$right_canvas_city_text = $canvasright->createText( 80,15, -text  => $hash_ref->{port_name} , -font =>"Times 12 bold");
				$right_canvas_region_text = $canvasright->createText( 80,30, -text  => $hash_ref->{region} , -font =>"Times 12 bold");
				$right_canvas_economy_text = $canvasright->createText( 100,90, -text  => $hash_ref->{economy} , -font =>"Times 12 bold");
				$right_canvas_industry_text = $canvasright->createText( 100,180, -text  => $hash_ref->{industry} , -font =>"Times 12 bold");
				$right_canvas_price_text = $canvasright->createText( 100,283, -text  => $hash_ref->{price_index} , -font =>"Times 12 bold");
			

			################ change left canvas #######################
			$canvasleft->itemconfigure( $left_image, -image => $port_left_png );  
			
				################ show gold ########################
				$canvasleft->coords($ingots_num, 65, 330+40);
				$canvasleft->coords($coins_num, 65, 330);
			
				################ hide 4 supplies ########################
				$canvasleft->coords($water_all, 2000, 2000);
				$canvasleft->coords($food_all, 2000, 2000);
				$canvasleft->coords($lumber_all, 2000, 2000);
				$canvasleft->coords($shot_all, 2000, 2000);		
		
			################ change data ########################	
			$mp[$j] = ${$ports{$port_index+1}}{name};;
			$cx[$j] = 16*${${${$ports{$port_index+1}}{buildings}}{4}}{x};
			$cy[$j] = 16*${${${$ports{$port_index+1}}{buildings}}{4}}{y};

			################ change player icon ########################		
			$mw->after(100, sub{ 	
				$canvas->itemconfigure($pship,-image => $p_player_up_1); 
			});
			  
			################ destroy canvas ########################		
			dfleet();		
		
		}
	}	
	

1;	