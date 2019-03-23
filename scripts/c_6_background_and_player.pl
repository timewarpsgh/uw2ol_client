	#################  !whole game canvas ################
	sub bg_back{

		if(defined($canvasbg) == 0){
			$canvasbg=$mw->Canvas(-background => "blue",-width => 643,-height => 405,-highlightthickness => 0)->place(-x => 0, -y => 0);   # -x => 305, -y => 179
			my $pbg = $mw->Photo(-file => 'images//z_others//'."port_bg1.png", -format => 'png',-width => 643,-height => 405 );
			$canvasbg->createImage( 321,202, -image => $pbg);
		}
	}
	bg_back;

	################### !middle small map canvas ###################
	sub mid_map {
		if(defined($canvas) == 0){
			$canvas = $mw->Canvas(-background => "white",-width => 386,-height => 386,-highlightthickness => 0)->place(-x => 96, -y => 10);	# -x => 400, -y => 190

			if($mp[$j] ne "sea"){
				######### get port_index and tileset ###############
				for my $i(1..101){
					if(${$ports{$i}}{name} eq $mp[$j]){
						$port_index = $i - 1;
						last;
					}
				}

				$port_tile_set = 2*${$ports{$port_index+1}}{tileset};
				$port_tile_set = sprintf("%03s", $port_tile_set);
				
				$port_index_with_leaidng_zero = sprintf("%03s", $port_index);
				
				######### create port image and piddle ###############  images//port//$lower_name.txt
					######### big image and piddle #########
					($piddle, $port_image)  = get_port_piddle_and_image('PORTMAP.'."$port_index_with_leaidng_zero", 'PORTCHIP.'."$port_tile_set");
					$data = image2data($port_image);
					
					$portImage = $mw->Photo(-data => $data, -format => 'png',-width => 96*16,-height => 96*16);
				
					$pi = $canvas->createImage( 0, 0, -image => $portImage);	

					######### mini port image #########
					$portImageShrinked = $port_image->scale(scalefactor=>0.1);
					$data = image2data($portImageShrinked);
							
					$portImage_mini = $mw->Photo(-data => $data, -format => 'png',-width => 141,-height => 159);

					
			}	
			if($mp[$j] eq "sea"){
				$pi = $canvas->createImage( 0, 0, -image => $sea_gif);    # $cx[$j],$cy[$j],
			}  
			
			######### create static npcs ###############
			$npc_by_marcket_animation = $canvas->createImage( -50, -50, -image => $npc_by_marcket_animation);
			$npc_by_bar_animation = $canvas->createImage( -50, -50, -image => $npc_by_bar_animation);
			$npc_by_inn_animation = $canvas->createImage( -50, -50, -image => $npc_by_inn_animation);
			
			######### create moving npcs ###############
				######### lady ###############
				$npc_moving_1_x = 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x};
				$npc_moving_1_y = 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y};
				$npc_moving_1 = $canvas->createImage( 204 - $cx[$j] + $npc_moving_1_x , 204 - $cy[$j] + $npc_moving_1_y, -image => $p_moving_npc_lady_up_1);
				
				######### man ###############
				$npc_moving_2_x = 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x};
				$npc_moving_2_y = 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y};
				$npc_moving_2 = $canvas->createImage( 204 - $cx[$j] + $npc_moving_2_x , 204 - $cy[$j] + $npc_moving_2_y, -image => $p_moving_npc_man_up_1);
			
		}
	}
	mid_map;

	########################## !player  ##########
	if($mp[$j] eq "sea"){
		$pship=$canvas->createImage( 203,203, -image => $p2_up);
	}
	if($mp[$j] ne "sea"){
		$pship=$canvas->createImage( 203,203, -image => $p_player_up_1);
	}
	
	######### ai fleets ############
	$ai_fleet_1 = $canvas->createImage( 203,203, -image => $p2_up);
	$ai_fleet_2 = $canvas->createImage( 203,203, -image => $p2_up);
	$ai_fleet_3 = $canvas->createImage( 203,203, -image => $p2_up);

	################### !left canvas ###################
	sub bg_left{
		if(defined($canvasleft) == 0){
			if($mp[$j] eq "sea"){
				################ initialize left canvas ####################
				$canvasleft=$mw->Canvas(-background => "black",-width => 96,-height => 403,-highlightthickness => 0)->place(-x => 0, -y => 0);	# -x => 304, -y => 180
				$left_image = $canvasleft->createImage( 48,201, -image => $sea_left_gif);

				################ initialize gold ####################
				$ingots = int($zy[$j]/10000);
				$coins = $zy[$j]-$ingots*10000;
				$ingots_num = $canvasleft->createText(65  , 330+40, -text  => "$ingots", -font =>"Times 12 bold");
				$coins_num = $canvasleft->createText(65  , 330, -text  => "$coins", -font =>"Times 12 bold");
				
				################ hide gold ####################
				$canvasleft->coords($ingots_num, 2000, 2000);
				$canvasleft->coords($coins_num, 2000, 2000); 					
			}
			if($mp[$j] ne "sea"){
				################ initialize left canvas ####################
				$canvasleft=$mw->Canvas(-background => "black",-width => 96,-height => 403,-highlightthickness => 0)->place(-x => 0, -y => 0);	# -x => 304, -y => 180
				$left_image = $canvasleft->createImage( 48,201, -image => $port_left_png);

				################ initialize gold ####################
				$ingots = int($zy[$j]/10000);
				$coins = $zy[$j]-$ingots*10000;
				$ingots_num = $canvasleft->createText(65  , 330+40, -text  => "$ingots", -font =>"Times 12 bold");
				$coins_num = $canvasleft->createText(65  , 330, -text  => "$coins", -font =>"Times 12 bold");
				
				################ initialize supply ####################
				$water_all = $canvasleft->createText(65  , 270, -text  => "water_all", -font =>"Times 12 bold");
				$food_all = $canvasleft->createText(65  , 270+35, -text  => "food_all", -font =>"Times 12 bold");
				$lumber_all = $canvasleft->createText(65  , 270+35*2, -text  => "lumber_all", -font =>"Times 12 bold");
				$shot_all = $canvasleft->createText(65  , 270+35*3, -text  => "shot_all", -font =>"Times 12 bold");		
			
				################ hide supply ####################
				$canvasleft->coords($water_all, 2000, 2000);
				$canvasleft->coords($food_all, 2000, 2000);
				$canvasleft->coords($lumber_all, 2000, 2000);
				$canvasleft->coords($shot_all, 2000, 2000);
			}
		}
	}
	bg_left;

	################### !right canvas ###################
	sub bg_right{
		if(defined($canvasright) == 0){
			################### initialize right canvas ###################
			$canvasright=$mw->Canvas(-background => "black",-width => 162,-height => 406,-highlightthickness => 0)->place(-x => 480, -y => 0);		# -x => 788, -y => 180
			my $pright_sea = $mw->Photo(-file => 'images//z_others//'."right1.gif", -format => 'gif',-width => 162,-height => 406 );
			my $pright_port = $mw->Photo(-file => 'images//z_others//'."port_right.PNG", -format => 'png',-width => 158,-height => 403 );
			
				################### when sea ###################
				if ( $mp[$j] eq "sea" ) {
					$right_image = $canvasright->createImage( 81,203, -image => $pright_sea);
				}
				################### when port ###################
				else {
					################### make canvas ###################
					$right_image = $canvasright->createImage( 81,203, -image => $pright_port);
					
					################### get data ###################
					my $response = command_get(get_data_for_right_hud); 	
					
					my $json = JSON->new->allow_nonref;
					my $hash_ref = $json->decode($response);
				
					my $port_name = $hash_ref->{port_name};
					
					print "$port_name \n";
					
					################### initialize texts on the canvas ###################
					$right_canvas_city_text = $canvasright->createText( 80,15, -text  => $hash_ref->{port_name} , -font =>"Times 12 bold");
					$right_canvas_region_text = $canvasright->createText( 80,30, -text  => $hash_ref->{region} , -font =>"Times 12 bold");
					$right_canvas_economy_text = $canvasright->createText( 100,90, -text  => $hash_ref->{economy} , -font =>"Times 12 bold");
					$right_canvas_industry_text = $canvasright->createText( 100,180, -text  => $hash_ref->{industry} , -font =>"Times 12 bold");
					$right_canvas_price_text = $canvasright->createText( 100,283, -text  => $hash_ref->{price_index} , -font =>"Times 12 bold");
					
					
				}

			################### make right buttons ###################
			my $p3 = $mw->Photo(-file => 'images//z_others//'."fleetbutton.gif", -format => 'gif',-width => 21,-height => 80 );
			$pa=$canvasright->createImage( 146,113, -image => $p3);
			my $p4 = $mw->Photo(-file => 'images//z_others//'."crewbutton.gif", -format => 'gif',-width => 21,-height => 80 );
			$pb=$canvasright->createImage( 146,113+80, -image => $p4);
			my $p5 = $mw->Photo(-file => 'images//z_others//'."infobutton.gif", -format => 'gif',-width => 21,-height => 80 );
			$pc=$canvasright->createImage( 147,113+160, -image => $p5);
			my $p6 = $mw->Photo(-file => 'images//z_others//'."navigationbutton.gif", -format => 'gif',-width => 21,-height => 80 );
			$pd=$canvasright->createImage( 145,113+240, -image => $p6);

			################### bind right buttons ###################
			$canvasright->bind($pa,"<Button-1>", \&fleetbutton);
			$canvasright->bind($pb,"<Button-1>", \&crewbutton);
			$canvasright->bind($pc,"<Button-1>", \&infobutton);
			$canvasright->bind($pd,"<Button-1>", \&navigationbutton);

		}
	}
	bg_right;
	

1;	