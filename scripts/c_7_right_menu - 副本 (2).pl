	###########  *menu-right  (fleet crew info navigation buttons) ###########
	########  !sub dfleet (destroy fleet canvas)  ##############
	sub dfleet {
		$fleet->destroy();
		$canvasfleet->destroy();
		$fleet2->destroy();
	}

	###########  !fleet ###########
	###########  @button clicked ###########
	sub fleetbutton{ 
		   $canvasfleet=$mw->Canvas(-background => "red",-width => 20,-height => 80,-highlightthickness => 0)->place(-x => 942-18-308, -y => 253-180);  #942-18 , 253
		   my $p3c = $mw->Photo(-file => 'images//z_others//'."fleetbuttonclicked.gif", -format => 'gif',-width => 20,-height => 80 );
		   $pac=$canvasfleet->createImage( 10,40, -image => $p3c);
		   $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);	# -x => 770, -y => 200
		   my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		   $fleet->createImage( 72,98, -image => $p4c); 

		   $mw->bind("<Escape>",  \&dfleet);

		   $transfer_cargo=$fleet->createText( 70,155, -text  => 'Transfer Cargo',-font =>"Times 12 bold");$fleet->bind($transfer_cargo,"<Button-1>", \&transfer_cargo2);
		   $fleet->bind($transfer_cargo,"<Motion>",  \&transfer_cargo);$fleet->bind($transfer_cargo,"<Leave>",  \&transfer_cargo1);
		   $log_of_goods=$fleet->createText( 70,155-20, -text  => 'Log of Goods',-font =>"Times 12 bold");
		   $fleet->bind($log_of_goods,"<Motion>",  \&log_of_goods);$fleet->bind($log_of_goods,"<Leave>",  \&log_of_goods1);
		   $cargo_info=$fleet->createText( 70,155-40, -text  => 'Cargo Info',-font =>"Times 12 bold");
		   $fleet->bind($cargo_info,"<Motion>",  \&cargo_info);$fleet->bind($cargo_info,"<Leave>",  \&cargo_info1);$fleet->bind($cargo_info,"<Button-1>", \&cargo_info2);
		   $scrap=$fleet->createText( 70,155-60, -text  => 'Scrap',-font =>"Times 12 bold");
		   $fleet->bind($scrap,"<Motion>",  \&scrap);$fleet->bind($scrap,"<Leave>",  \&scrap1);$fleet->bind($scrap,"<Button-1>", \&scrap_open);
		   $rearrange=$fleet->createText( 70,155-80, -text  => 'Rearrange',-font =>"Times 12 bold");
		   $fleet->bind($rearrange,"<Motion>",  \&rearrange);$fleet->bind($rearrange,"<Leave>",  \&rearrange1);$fleet->bind($rearrange,"<Button-1>",  \&rearrange_open);
		   $ship_info=$fleet->createText( 70,155-100, -text  => 'Ship Info',-font =>"Times 12 bold");
		   $fleet->bind($ship_info,"<Motion>",  \&ship_info);$fleet->bind($ship_info,"<Leave>",  \&ship_info1);$fleet->bind($ship_info,"<Button-1>", \&ship_info_open);
		   $fleet_info=$fleet->createText( 70,155-120, -text  => 'Fleet Info',-font =>"Times 12 bold");
		   $fleet->bind($fleet_info,"<Motion>",  \&fleet_info);$fleet->bind($fleet_info,"<Leave>",  \&fleet_info1);$fleet->bind($fleet_info,"<Button-1>", \&fleet_info_open);
	 }
	 
	###################### @fleet visual effects ################
	sub transfer_cargo{ $fleet->itemconfigure($transfer_cargo, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub transfer_cargo1{ $fleet->itemconfigure($transfer_cargo, -font =>"Times 12 bold",-fill=>"black");
	}
	sub log_of_goods{ $fleet->itemconfigure($log_of_goods, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub log_of_goods1{ $fleet->itemconfigure($log_of_goods, -font =>"Times 12 bold",-fill=>"black");
	}
	sub cargo_info{ $fleet->itemconfigure($cargo_info, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub cargo_info1{ $fleet->itemconfigure($cargo_info, -font =>"Times 12 bold",-fill=>"black");
	}
	sub scrap{ $fleet->itemconfigure($scrap, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub scrap1{ $fleet->itemconfigure($scrap, -font =>"Times 12 bold",-fill=>"black");
	}
	sub rearrange{ $fleet->itemconfigure($rearrange, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub rearrange1{ $fleet->itemconfigure($rearrange, -font =>"Times 12 bold",-fill=>"black");
	}
	sub ship_info{ $fleet->itemconfigure($ship_info, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub ship_info1{ $fleet->itemconfigure($ship_info, -font =>"Times 12 bold",-fill=>"black");
	}
	sub fleet_info{ $fleet->itemconfigure($fleet_info, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub fleet_info1{ $fleet->itemconfigure($fleet_info, -font =>"Times 12 bold",-fill=>"black");
	}

	###################### @fleet click events ################
	sub scrap_open{ 
		############## make canvas ##############
		my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet->createImage( 72,98, -image => $p4c); 

		############## bind escape ##############
		$mw->bind("<Escape>",  sub{
			$fleet->destroy;
			$fleet2->destroy;
			$mw->bind("<Escape>", \&dfleet);				
		});	

		$fleet2=$mw->Canvas(-background => "black",-width => 1,-height => 1,-highlightthickness => 0)->place(-x => 770, -y => 200+60);
		
		########### get ships available ###############
		my @ships_available = $redis->hmget("$j:ships2", VARclass0, VARclass1, VARclass2, VARclass3, VARclass4, VARclass5, VARclass6, VARclass7, VARclass8, VARclass9 );
		my @ships_available_index;
		for $i( 0..@ships_available-1 ) {
			if ( @ships_available[$i] ne '0' ) {
				push( @ships_available_index, $i );
			}
		}
		
		############## sub show_ship_info ##############
		my sub show_ship_info {
			my $ship_num = shift;

			############## make text ##############
			my $ship_text = $fleet->createText( 70,15*(2+$ship_num), -text  => 'Ship'.$ship_num,-font =>"Times 12 bold");
			bind_motion_leave_canvas($ship_text, $fleet);
			$fleet->bind($ship_text,"<Button-1>",  sub{
				############## make canvas ##############
				$fleet2->destroy;
				$fleet2 = $mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				$fleet2->createImage( 172,177, -image => $mate_info_gif); 

				############## get data ##############
				my $received_jason = command_get('show_ship_info:'.$ship_num);
				my $json = JSON->new->allow_nonref;
				my $ref_of_items = $json->decode( $received_jason );
				my @ship_data = @$ref_of_items;
				
				############## show data ##############
				my @ship_attributes = (shipname,class,captain,figure,xinb,yinb,durability,tacking,power,speed,capacity,guns,crew,minimumcrew,navigation,lookout,combat,cargo,water,food,lumber,shot);
				for my $i(0..@ship_attributes-1) {
					$fleet2->createText( 50,20+$i*15, -text =>@ship_attributes[$i]);  $fleet2->createText( 130,20+$i*15, -text => @ship_data[$i] ); 
				} 	
				
				############## show ship image ##############
				my $ship_type = lc(@ship_data[1]);
				if ( $ship_type ne '0') {
					my $ship_image = $fleet2->createImage( 260, 70, -image => ${$ship_type} );
				}	

				############## show command ##############
				my $sell_text = $fleet2->createText( 260, 200, -text =>'Scrape', -font =>"Times 12 bold" );
				bind_motion_leave_canvas($sell_text, $fleet2);
				$fleet2->bind($sell_text,"<Button-1>",  sub{
					$redis->hmset("$j:ships2", 	VARshipname.$ship_num, 0, 
												VARclass.$ship_num, 0,  
												VARcaptain.$ship_num, 0,  
												VARfigure.$ship_num, 0, 
												VARxinb.$ship_num, 0,
												VARyinb.$ship_num, 0, 
												VARdurability.$ship_num, 0,  
												VARtacking.$ship_num, 0,  
												VARpower.$ship_num, 0, 
												VARspeed.$ship_num, 0,

												VARcapacity.$ship_num, 0, 
												VARguns.$ship_num, 0,  
												VARcrew.$ship_num, 0,  
												VARminimumcrew.$ship_num, 0, 
												VARnavigation.$ship_num, 0,
												VARlookout.$ship_num, 0, 
												VARcombat.$ship_num, 0,  
												VARcargo.$ship_num, 0,  
												VARwater.$ship_num, 0, 
												VARfood.$ship_num, 0,	

												VARlumber.$ship_num, 0, 
												VARshot.$ship_num, 0,				
					); 
					
					$fleet2->destroy;
				});			
			});		
		}
		
		############## use sub for available ships ##############
		for my $i(0..@ships_available_index-1) {
			show_ship_info(@ships_available_index[$i]);	
		
		}			
	}

	sub cargo_info2{ 
		############## get @VARcargo #############
		@d = ();
		foreach my $i ((0..9)){         
			@{VARcargo.$i} = DOWN_small_pipe(VARcargo.$i,ships2); 
		}

		$redis->wait_all_responses;

		foreach my $i ((0..9)){         
			pipe_get(VARcargo.$i,$i);
		}

		smallredpotion2london3();  #####sell	

		############## bind escape #############
		$mw->bind("<Escape>", sub {
			$fleet2->destroy; 
			$mw->bind("<Escape>", \&dfleet);
		});
	}

	sub transfer_cargo2 {
		############## get @VARcargo #############	
		@d = ();
		foreach my $i ((0..9)){         
			@{VARcargo.$i} = DOWN_small_pipe(VARcargo.$i,ships2); 
		}
		$redis->wait_all_responses;
		foreach my $i ((0..9)){         
			pipe_get(VARcargo.$i,$i);
		}

		############### canvas  ###############
		my $fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
		$fleet2->createImage( 172,177, -image => $p4c); 

		############## bind escape #############
		$mw->bind("<Escape>", sub {
			$fleet2->destroy;
			$mw->bind("<Escape>", \&dfleet);
		});

		############## text on canvas #############
		my $load = $fleet2->createText( 150,20+1*15, -text =>"Unload",-font =>"Times 12 bold");	
		bind_motion_leave_canvas($load, $fleet2);

		$fleet2->createText( 150+50,20+1*15, -text =>"Cargo",-font =>"Times 12 bold");
		$fleet2->createText( 70,20+5*15, -text =>"Remaining",-font =>"Times 12 bold");
								
		for($i=0;$i<10;$i++){
			$fleet2->createText( 150,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
		}
		
		############## unload cargo num and type #############
		@cargo0=split(/</,$VARcargo0[$j]);@cargo1=split(/</,$VARcargo1[$j]);@cargo2=split(/</,$VARcargo2[$j]);@cargo3=split(/</,$VARcargo3[$j]);@cargo4=split(/</,$VARcargo4[$j]);@cargo5=split(/</,$VARcargo5[$j]);@cargo6=split(/</,$VARcargo6[$j]);@cargo7=split(/</,$VARcargo7[$j]);@cargo8=split(/</,$VARcargo8[$j]);@cargo9=split(/</,$VARcargo9[$j]);
		@cargoofallships = (@cargo0[0],@cargo1[0],@cargo2[0],@cargo3[0],@cargo4[0],@cargo5[0],@cargo6[0],@cargo7[0],@cargo8[0],@cargo9[0]);
		@cargo_type_ofallships = (@cargo0[1],@cargo1[1],@cargo2[1],@cargo3[1],@cargo4[1],@cargo5[1],@cargo6[1],@cargo7[1],@cargo8[1],@cargo9[1]);
		@cargoz = ($cargo_text0,$cargo_text1,$cargo_text2,$cargo_text3,$cargo_text4,$cargo_text5,$cargo_text6,$cargo_text7,$cargo_text8,$cargo_text9);

		my $remains = "0 none";
		my $amount_item = $fleet2->createText( 70,20+6*15, -text =>"$remains",-font =>"Times 12 bold");
		
		
		foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   #for($i=0;$i<10;$i++)
			if($cargoofallships[$i] == 0){
				$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"none",-font =>"Times 12 bold");
			}
			else{
				$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$cargoofallships[$i] $cargo_type_ofallships[$i]",-font =>"Times 12 bold");
			}
			bind_motion_leave_canvas($cargoz[$i], $fleet2);
		}
			
		my sub unload_cargo{	
			foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){ 	
				$fleet2->bind($cargoz[$i],"<Button-1>", sub{
					my $enteredvalue2;	
					my $entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
					$entrybox->focus;
					$entrybox->bind('<Return>', sub{ 
						$entrybox->destroy;
						my @remains_list = split(/ /,$remains);
						my $sum = $remains_list[0]+$enteredvalue2;
						$remains = "$sum $cargo_type_ofallships[$i]";

						$fleet2->itemconfigure( $amount_item, -text =>"$remains");
						$cargoofallships[$i]-= $enteredvalue2;	
						$fleet2->itemconfigure( $cargoz[$i], -text =>"$cargoofallships[$i] $cargo_type_ofallships[$i]",-font =>"Times 12 bold");
					});

					$mw->bind("<Escape>", sub {
						$fleet2->destroy;
						$entrybox->destroy if(Exists($entrybox));
						$mw->bind("<Escape>", \&dfleet);
					});	
				});
			}
		}
		unload_cargo();
		############## load cargo num and type #############
		$fleet2->bind($load,"<Button-1>", sub{

			#############sub load cargo################	
			my sub load_cargo{
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){ 
					$fleet2->bind($cargoz[$i],"<Button-1>", sub{
						my $enteredvalue2;	
						my $entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub{ 
							$entrybox->destroy;
							my @remains_list = split(/ /,$remains);
							my $sum = $remains_list[0]-$enteredvalue2;
							$remains = "$sum $cargo_type_ofallships[$i]";

							$fleet2->itemconfigure( $amount_item, -text =>"$remains");
							$cargoofallships[$i]+= $enteredvalue2;	
							$fleet2->itemconfigure( $cargoz[$i], -text =>"$cargoofallships[$i] $cargo_type_ofallships[$i]",-font =>"Times 12 bold");
						});

						$mw->bind("<Escape>", sub {
							$fleet2->destroy;
							$entrybox->destroy if(Exists($entrybox));
							$mw->bind("<Escape>", \&dfleet);
						});	
					});
				}
			}

			#############get text and then bind accrodingly################
			my $a = $fleet2->itemcget($load,-text);
			if($a eq "Unload"){
				$fleet2->itemconfigure($load,-text => "Load");
				load_cargo();
			}	
			
			if($a eq "Load"){
				$fleet2->itemconfigure($load,-text => "Unload");
				unload_cargo();
			}
		});

		############## OK #############
		my $ok = $fleet2->createText( 70,20+8*15,  -text =>"OK",-font =>"Times 12 bold");	
		bind_motion_leave_canvas($ok, $fleet2);
		$fleet2->bind($ok,"<Button-1>", sub{
			for($i=0;$i<10;$i++){
				$redis->hset("$j:ships2", VARcargo.$i, "$cargoofallships[$i]<$cargo_type_ofallships[$i]", sub{}); 
			}
			$redis->wait_all_responses;

			$fleet2->destroy;
			dfleet();

		});
	}
	
	sub rearrange_open {
		############## make canvas #############
		my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet->createImage( 72,98, -image => $p4c); 

		############## bind escape #############
		$mw->bind("<Escape>",  sub{
			$fleet->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});
		
		############## text #############
		$fleet->createText( 70,20*2, -text  => 'Ship',-font =>"Times 12 bold");
		$fleet->createText( 70,20*4, -text  => 'to',-font =>"Times 12 bold");
		$fleet->createText( 70,20*6, -text  => 'Ship',-font =>"Times 12 bold");
		
		############## entry box #############
			############## box from #############
			my $enteredvalue1;	
			my $entrybox1 = $fleet->Entry(-textvariable => \$enteredvalue1, -width => 2)->place(-x => 70+20, -y => 15*2);
			$entrybox1->focus;

			############## box to #############
			my $enteredvalue2;	
			my $entrybox2 = $fleet->Entry(-textvariable => \$enteredvalue2, -width => 2)->place(-x => 70+20, -y => 20*6-5);
			$entrybox2->focus;
		
		############## ok button #############
		my $ok = $fleet->createText( 70,20*8, -text  => 'OK',-font =>"Times 12 bold");
		bind_motion_leave_canvas($ok, $fleet);
		
		$fleet->bind($ok,"<Button-1>", sub{
			############## command_get() ##############
				#############  send rearrange_ships, ship_num_from, ship_num_to  ##############
				my $received_jason = command_get('rearrange_ships:'.$enteredvalue1.':'.$enteredvalue2);
			
				############## get ok_state ##############
				my %ok_state = json_decode($received_jason);
				
			############## destroy canvas ##############
			$fleet->destroy;
			dfleet();
		});
	}
		
	sub fleet_info_open { 
		############## command_get @ships_classes  ##############
		my $received_jason = command_get(fleet_info_open);
		my $json = JSON->new->allow_nonref;
		my $ref_of_items = $json->decode( $received_jason );
		my @ships_classes = @$ref_of_items;
		
		############## make canvas ##############
		my $fleet=$mw->Canvas(-background => "red",-width => 640,-height => 403,-highlightthickness => 0)->place(-x => 308-308, -y => 178-180);
		$fleet->createImage( 320,201, -image => $fleet_info_photo); 

		############## add ship images onto canvas ##############
		my sub show_ships_on_canvas {
			my $ship_num = shift;
			my $x = shift;
			my $y = shift;
		
			if ( $ships_classes[$ship_num] ne '0' ) {
				$fleet->createImage( $x, $y, -image => ${lc($ships_classes[$ship_num])} ); 
			}
		}
		my $delta_x = 130;
		my $delta_y = 100;
		
		show_ships_on_canvas(0,320,201);
		show_ships_on_canvas(1,320,201- $delta_y * 1.5);
		show_ships_on_canvas(2, 320 - $delta_x, 201 - $delta_y );
		show_ships_on_canvas(3, 320 + $delta_x, 201 - $delta_y );
		show_ships_on_canvas(4, 320 + $delta_x, 201 + $delta_y * 0.5);
		
		show_ships_on_canvas(5, 320 - $delta_x , 201 + $delta_y * 0.5 );
		show_ships_on_canvas(6, 320 + $delta_x * 2 , 201 - $delta_y * 1.5 );
		show_ships_on_canvas(7, 320 + $delta_x * 2 , 201);
		show_ships_on_canvas(8, 320 - $delta_x * 2 , 201 - $delta_y * 1.5);
		show_ships_on_canvas(9, 320 - $delta_x * 2 ,201);
		
		
		############## bind escape ##############
		$mw->bind("<Escape>",  sub{
			$fleet->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});
	}
								 
	sub ship_info_open {  
		############## make canvas ##############
		my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet->createImage( 72,98, -image => $p4c); 

		############## bind escape ##############
		$mw->bind("<Escape>",  sub{
			$fleet->destroy;
			$fleet2->destroy;
			$mw->bind("<Escape>", \&dfleet);				
		});	

		$fleet2=$mw->Canvas(-background => "black",-width => 1,-height => 1,-highlightthickness => 0)->place(-x => 770, -y => 200+60);
		
		########### get ships available ###############
		my @ships_available = $redis->hmget("$j:ships2", VARclass0, VARclass1, VARclass2, VARclass3, VARclass4, VARclass5, VARclass6, VARclass7, VARclass8, VARclass9 );
		my @ships_available_index;
		for $i( 0..@ships_available-1 ) {
			if ( @ships_available[$i] ne '0' ) {
				push( @ships_available_index, $i );
			}
		}
		
		############## sub show_ship_info ##############
		my sub show_ship_info {
			my $ship_num = shift;

			############## make text ##############
			my $ship_text = $fleet->createText( 70,15*(2+$ship_num), -text  => 'Ship'.$ship_num,-font =>"Times 12 bold");
			bind_motion_leave_canvas($ship_text, $fleet);
			$fleet->bind($ship_text,"<Button-1>",  sub{
				############## make canvas ##############
				$fleet2->destroy;
				$fleet2 = $mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				$fleet2->createImage( 172,177, -image => $mate_info_gif); 

				############## get data ##############
				my $received_jason = command_get('show_ship_info:'.$ship_num);
				my $json = JSON->new->allow_nonref;
				my $ref_of_items = $json->decode( $received_jason );
				my @ship_data = @$ref_of_items;
				
				############## show data ##############
				my @ship_attributes = (shipname,class,captain,figure,xinb,yinb,durability,tacking,power,speed,capacity,guns,crew,minimumcrew,navigation,lookout,combat,cargo,water,food,lumber,shot);
				for my $i(0..@ship_attributes-1) {
					$fleet2->createText( 50,20+$i*15, -text =>@ship_attributes[$i]);  $fleet2->createText( 130,20+$i*15, -text => @ship_data[$i] ); 
				} 	
				
				############## show ship image ##############
				my $ship_type = lc(@ship_data[1]);
				if ( $ship_type ne '0') {
					my $ship_image = $fleet2->createImage( 260, 70, -image => ${$ship_type} );
				}					
			});		
		}
		
		############## use sub for available ships ##############
		for my $i(0..@ships_available_index-1) {
			show_ship_info(@ships_available_index[$i]);	
		
		}

	}

	###########  !crew ###########
	###########  @button clicked ###########
	sub crewbutton{       
		   $canvasfleet=$mw->Canvas(-background => "red",-width => 20,-height => 78,-highlightthickness => 0)->place(-x => 942-18-308, -y => 253+80-180);
		   my $p3c = $mw->Photo(-file => 'images//z_others//'."crewbuttonclicked.gif", -format => 'gif',-width => 20,-height => 80 );
		   $pac=$canvasfleet->createImage( 10,40, -image => $p3c);
		   $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+60-180);
		   my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		   $fleet->createImage( 72,98, -image => $p4c); 

		   $mw->bind("<Escape>",  \&dfleet);
	 
		   $rations=$fleet->createText( 70,160+5, -text  => 'Rations',-font =>"Times 12 bold");
		   $fleet->bind($rations,"<Motion>",  \&rations);$fleet->bind($rations,"<Leave>",  \&rations1);
		   $wages=$fleet->createText( 70,140+5, -text  => 'Wages',-font =>"Times 12 bold");
		   $fleet->bind($wages,"<Motion>",  \&wages);$fleet->bind($wages,"<Leave>",  \&wages1);
		   $assign_crew=$fleet->createText( 70,120+5, -text  => 'Assign Crew',-font =>"Times 12 bold");
		   $fleet->bind($assign_crew,"<Motion>",  \&assign_crew);$fleet->bind($assign_crew,"<Leave>",  \&assign_crew1);
		   $transfer_crew=$fleet->createText( 70,100+5, -text  => 'Transfer Crew',-font =>"Times 12 bold");
		   $fleet->bind($transfer_crew,"<Motion>",  \&transfer_crew);$fleet->bind($transfer_crew,"<Leave>",  \&transfer_crew1);$fleet->bind($transfer_crew,"<Button-1>",  \&transfer_crew2);
		   $change_duty=$fleet->createText( 70,80+5, -text  => 'Change Duty',-font =>"Times 12 bold");
		   $fleet->bind($change_duty,"<Motion>",  \&change_duty);$fleet->bind($change_duty,"<Leave>",  \&change_duty1);$fleet->bind($change_duty,"<Button-1>", \&change_duty2);
		   $change_captain=$fleet->createText( 70,60+5, -text  => 'Change Captain',-font =>"Times 12 bold");
		   $fleet->bind($change_captain,"<Motion>",  \&change_captain);$fleet->bind($change_captain,"<Leave>",  \&change_captain1);$fleet->bind($change_captain,"<Button-1>", \&change_captain2); 
		   $mate_info=$fleet->createText( 70,40+5, -text  => 'Mate Info',-font =>"Times 12 bold");
		   $fleet->bind($mate_info,"<Motion>",  \&mate_info);$fleet->bind($mate_info,"<Leave>",  \&mate_info1);$fleet->bind($mate_info,"<Button-1>", \&mate_info_open);        
		   $hero_info=$fleet->createText( 70,20+5, -text  => 'Hero Info',-font =>"Times 12 bold");
		   $fleet->bind($hero_info,"<Motion>",  \&hero_info);$fleet->bind($hero_info,"<Leave>",  \&hero_info1);
	}  
	 
	###################### @crew visual effects ################
	sub rations{ $fleet->itemconfigure($rations, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub rations1{ $fleet->itemconfigure($rations, -font =>"Times 12 bold",-fill=>"black");
	}
	sub wages{ $fleet->itemconfigure($wages, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub wages1{ $fleet->itemconfigure($wages, -font =>"Times 12 bold",-fill=>"black");
	}
	sub assign_crew{ $fleet->itemconfigure($assign_crew, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub assign_crew1{ $fleet->itemconfigure($assign_crew, -font =>"Times 12 bold",-fill=>"black");
	}
	sub transfer_crew{ $fleet->itemconfigure($transfer_crew, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub transfer_crew1{ $fleet->itemconfigure($transfer_crew, -font =>"Times 12 bold",-fill=>"black");
	}
	sub change_duty{ $fleet->itemconfigure($change_duty, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub change_duty1{ $fleet->itemconfigure($change_duty, -font =>"Times 12 bold",-fill=>"black");
	}
	sub change_captain{ $fleet->itemconfigure($change_captain, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub change_captain1{ $fleet->itemconfigure($change_captain, -font =>"Times 12 bold",-fill=>"black");
	}

	###################### @crew click events ################
	sub change_captain2{ 
		############## create canvas right#############
		my $fleet1=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+60-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet1->createImage( 72,98, -image => $p4c); 

		############## show ships and captains #############
		my @captain_names = $redis->hmget("$j:ships2", VARcaptain0, VARcaptain1, VARcaptain2, VARcaptain3, VARcaptain4, VARcaptain5, VARcaptain6, VARcaptain7, VARcaptain8, VARcaptain9); 
		my @mate_keeper_navi_names = $redis->hmget("$j:ships2", VARfirstmate, VARbookkeeper, VARchiefnavigator); 
		my @mate_keeper_navi_text = ("First Mate", "Book Keeper", "Chief Navigator");

		my @ship_captains = ();
		foreach my $i ((0..9)){
			$ship_captains[$i] = $fleet1->createText( 40,15*(2+$i), -text => "$i $captain_names[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
			bind_motion_leave_canvas($ship_captains[$i], $fleet1);
		}
		
		my $fleet2;
		my $plus = $fleet1->createText( 200,15*(2+$i), -text => "+", -font =>"Times 12 bold"); 
		foreach my $i ((0..9)){
			$fleet1->bind($ship_captains[$i],"<Button-1>", sub{
				############## plus sign ###########
				$fleet1->coords($plus, 30, 15*(2+$i)); 			

				############## destroy opened canvas ###########
				$fleet2->destroy if(Exists($fleet2));

				############## create canvas left ###########
				$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 

				############## bind escape #############
				$mw->bind("<Escape>",  sub{
					$fleet2->destroy;
					$mw->bind("<Escape>",  sub{
						$fleet1->destroy;
						$mw->bind("<Escape>", \&dfleet);	
					});
				});


				############## get mate names #############
				my @mate_names = $redis->hmget("$j:mates0to9", VARmatename0, VARmatename1, VARmatename2, VARmatename3, VARmatename4, VARmatename5, VARmatename6, VARmatename7, VARmatename8, VARmatename9); 
				my @mate_names_10to15 = $redis->hmget("$j:mates10to15", VARmatename10, VARmatename11, VARmatename12, VARmatename13, VARmatename14, VARmatename15); 
				push(@mate_names, @mate_names_10to15);	
					
				############## show mate names #############
				my @name_items = ();
				foreach my $k ((0..15)){
					$name_items[$k] = $fleet2->createText( 70,15*(2+$k), -text => "$mate_names[$k]", -font =>"Times 12 bold"); 

				}
				
				############## show jobs #############
				my @captain_names = $redis->hmget("$j:ships2", VARcaptain0, VARcaptain1, VARcaptain2, VARcaptain3, VARcaptain4, VARcaptain5, VARcaptain6, VARcaptain7, VARcaptain8, VARcaptain9); 
				my @jobs = ();
				for($k=0;$k<16;$k++){
					$jobs[$k] = $fleet2->createText( 150,15*(2+$k), -text => "no duty", -font =>"Times 12 bold"); 
					for(my $q=0;$q<10;$q++){	######## captains
						if($mate_names[$k] eq $captain_names[$q]){
							$fleet2->itemconfigure($jobs[$k], -text => "captain of $q"); 
						}
						
					}
					for(my $q=0;$q<3;$q++){		######## navigators
						if($mate_names[$k] eq $mate_keeper_navi_names[$q]){
							$fleet2->itemconfigure($jobs[$k], -text => "$mate_keeper_navi_text[$q]"); 
						}
						
					}

				}

				############## bind mate names #############
				foreach my $k ((0..15)){
					bind_motion_leave_canvas($name_items[$k], $fleet2);
				}
				foreach my $k ((0..15)){
					$fleet2->bind($name_items[$k],"<Button-1>", sub{
						my $job_text = $fleet2->itemcget($jobs[$k],-text);

						############## judge whether contained #############
						my $contained_question = 0;
						my $cap_num_when_contained;
						for(my $z=0;$z<10;$z++){
							if($mate_names[$k] eq $captain_names[$z]){
								$contained_question = 1;
								$cap_num_when_contained = $z;
							}
						}

						############## if no duty #############
						if($job_text eq "no duty"){
							$fleet1->itemconfigure($ship_captains[$i], -text =>"$i $mate_names[$k]" );
							$fleet2->itemconfigure($jobs[$k], -text =>"captain of $i" );

							foreach my $j ((0..15)){
								my $job_text = $fleet2->itemcget($jobs[$j],-text);
								if($job_text eq "captain of $i" && $j != $k){
									$fleet2->itemconfigure($jobs[$j], -text =>"no duty" );
								}
							}

							$redis->hset("$j:ships2", VARcaptain.$i, $mate_names[$k]);
							$fleet1->destroy;
							$fleet2->destroy;	
							change_captain2();
						}

						############## if captain #############
						if($contained_question == 1){
							$fleet1->itemconfigure($ship_captains[$i], -text =>"$i $mate_names[$k]" );
							$fleet1->itemconfigure($ship_captains[$cap_num_when_contained], -text =>"$cap_num_when_contained $mate_names[$i]" );

							$fleet2->itemconfigure($jobs[$k], -text =>"captain of $i" );
							foreach my $j ((0..15)){
								my $job_text = $fleet2->itemcget($jobs[$j],-text);
								if($job_text eq "captain of $i" && $j != $k){
									$fleet2->itemconfigure($jobs[$j], -text =>"captain of $cap_num_when_contained" );
								}
							}

							$redis->hmset("$j:ships2", VARcaptain.$i, $mate_names[$k], VARcaptain.$cap_num_when_contained, $captain_names[$i]);
							$fleet1->destroy;
							$fleet2->destroy;	
							change_captain2();	
						}

						############## if navigators #############
						if($job_text eq "First Mate" or $job_text eq "Book Keeper" or $job_text eq "Chief Navigator"){
							$fleet1->itemconfigure($ship_captains[$i], -text =>"$i $mate_names[$k]" );
							$fleet2->itemconfigure($jobs[$k], -text =>"captain of $i" );

							my $temp = $job_text;
							foreach my $j ((0..15)){
								my $job_text1 = $fleet2->itemcget($jobs[$j],-text);
								if($job_text1 eq "captain of $i" && $j != $k){
									$fleet2->itemconfigure($jobs[$j], -text =>"$temp" );
								}
							}
							
							my $position;
							if($temp eq "First Mate"){
								$position = "VARfirstmate";
							}
							if($temp eq "Book Keeper"){
								$position = "VARbookkeeper";
							}
							if($temp eq "Chief Navigator"){
								$position = "VARchiefnavigator";
							}	

							$redis->hmset("$j:ships2", VARcaptain.$i, $mate_names[$k], $position, $captain_names[$i]);
							$fleet1->destroy;
							$fleet2->destroy;	
							change_captain2();
						}
					});
				}
			});
		}

		############## bind escape #############			
		$mw->bind("<Escape>",  sub{
			$fleet1->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});			
	}

	sub change_duty2{
		############## create canvas right#############
		my $fleet1=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+60-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet1->createImage( 72,98, -image => $p4c); 

		############## show ships and captains #############
		my @mate_keeper_navi_names = $redis->hmget("$j:ships2", VARfirstmate, VARbookkeeper, VARchiefnavigator); 
		my @mate_keeper_navi_text = ("First Mate", "Book Keeper", "Chief Navigator");
		my @mate_keeper_navi_items = ();
		foreach my $i ((0..2)){
			$fleet1->createText( 75,20+15*(2+$i*2), -text => "$mate_keeper_navi_text[$i]", -font =>"Times 12 bold", -anchor =>"c"); 	
			$mate_keeper_navi_items[$i] = $fleet1->createText( 75,20+15*(3+$i*2), -text => "$mate_keeper_navi_names[$i]", -font =>"Times 12 bold", -anchor =>"c"); 
			bind_motion_leave_canvas($mate_keeper_navi_items[$i], $fleet1);
		}
		
		my $fleet2;
		my $plus = $fleet1->createText( 200,15*(2+$i), -text => "+", -font =>"Times 12 bold"); 
		foreach my $i ((0..2)){
			$fleet1->bind($mate_keeper_navi_items[$i],"<Button-1>", sub{
				############## plus sign ###########
				$fleet1->coords($plus, 30, 20+15*(3+$i*2)); 			

				############## destroy opened canvas ###########
				$fleet2->destroy if(Exists($fleet2));

				############## create canvas left ###########
				$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 

				############## bind escape #############
				$mw->bind("<Escape>",  sub{
					$fleet2->destroy;
					$mw->bind("<Escape>",  sub{
						$fleet1->destroy;
						$mw->bind("<Escape>", \&dfleet);	
					});
				});

				############## get mate names #############
				my @mate_names = $redis->hmget("$j:mates0to9", VARmatename0, VARmatename1, VARmatename2, VARmatename3, VARmatename4, VARmatename5, VARmatename6, VARmatename7, VARmatename8, VARmatename9); 
				my @mate_names_10to15 = $redis->hmget("$j:mates10to15", VARmatename10, VARmatename11, VARmatename12, VARmatename13, VARmatename14, VARmatename15); 
				push(@mate_names, @mate_names_10to15);	
					
				############## show mate names #############
				my @name_items = ();
				foreach my $k ((0..15)){
					$name_items[$k] = $fleet2->createText( 70,15*(2+$k), -text => "$mate_names[$k]", -font =>"Times 12 bold"); 

				}
				
				############## show jobs #############
				my @captain_names = $redis->hmget("$j:ships2", VARcaptain0, VARcaptain1, VARcaptain2, VARcaptain3, VARcaptain4, VARcaptain5, VARcaptain6, VARcaptain7, VARcaptain8, VARcaptain9); 
				my @jobs = ();
				for($k=0;$k<16;$k++){
					$jobs[$k] = $fleet2->createText( 150,15*(2+$k), -text => "no duty", -font =>"Times 12 bold"); 
					for(my $q=0;$q<10;$q++){	######## captains
						if($mate_names[$k] eq $captain_names[$q]){
							$fleet2->itemconfigure($jobs[$k], -text => "captain of $q"); 
						}
						
					}
					for(my $q=0;$q<3;$q++){		######## navigators
						if($mate_names[$k] eq $mate_keeper_navi_names[$q]){
							$fleet2->itemconfigure($jobs[$k], -text => "$mate_keeper_navi_text[$q]"); 
						}
						
					}
				}

				############## bind mate names #############
				foreach my $k ((0..15)){
					bind_motion_leave_canvas($name_items[$k], $fleet2);
				}
				foreach my $k ((0..15)){
					$fleet2->bind($name_items[$k],"<Button-1>", sub{
						my $job_text = $fleet2->itemcget($jobs[$k],-text);

						############## if no duty #############
						if($job_text eq "no duty"){
							$fleet2->itemconfigure($jobs[$k],-text => "$mate_keeper_navi_text[$i]");
							$fleet1->itemconfigure($mate_keeper_navi_items[$i], -text => "$mate_names[$k]");

							############## change to no duty#############
							foreach my $j ((0..15)){
								my $job_text = $fleet2->itemcget($jobs[$j],-text);
								if($job_text eq "$mate_keeper_navi_text[$i]" && $j != $k){
									$fleet2->itemconfigure($jobs[$j], -text =>"no duty" );
								}
							}
							############## update and end #############
							my @a = ("VARfirstmate", "VARbookkeeper", "VARchiefnavigator"); 
							$redis->hset("$j:ships2", $a[$i], $mate_names[$k]);
							$fleet1->destroy;
							$fleet2->destroy;	
							change_duty2();
						}

						############## if captain #############
						if($job_text =~ /captain/){
							############## judge whether contained #############
							my $contained_question = 0;
							my $cap_num_when_contained;
							for(my $z=0;$z<10;$z++){
								if($mate_names[$k] eq $captain_names[$z]){
									$contained_question = 1;
									$cap_num_when_contained = $z;
								}
							}

							############## change right canvas #############
							$fleet1->itemconfigure($mate_keeper_navi_items[$i], -text =>"$mate_names[$k]" );

							############## change left canvas #############
							$fleet2->itemconfigure($jobs[$k], -text =>"$mate_keeper_navi_text[$i]" );
							foreach my $j ((0..15)){
								my $job_text = $fleet2->itemcget($jobs[$j],-text);
								if($job_text eq "$mate_keeper_navi_text[$i]" && $j != $k){
									$fleet2->itemconfigure($jobs[$j], -text =>"captain of $cap_num_when_contained" );
								}
							}

							############## update and end #############
							my @a = ("VARfirstmate", "VARbookkeeper", "VARchiefnavigator"); 		
							$redis->hmset("$j:ships2", $a[$i], $mate_names[$k], VARcaptain.$cap_num_when_contained, $mate_keeper_navi_names[$i]);
							$fleet1->destroy;
							$fleet2->destroy;	
							change_duty2();
						}
						############## if navigator #############
						if($job_text eq "First Mate" or $job_text eq "Book Keeper" or $job_text eq "Chief Navigator"){
							############## judge whether contained #############
							my $contained_question = 0;
							my $cap_num_when_contained;
							for(my $z=0;$z<10;$z++){
								if($mate_names[$k] eq $captain_names[$z]){
									$contained_question = 1;
									$cap_num_when_contained = $z;
								}
							}

							############## change right canvas #############
							$fleet1->itemconfigure($mate_keeper_navi_items[$i], -text =>"$mate_names[$k]" );

							my $temp;
							foreach my $j ((0..2)){
								my $job_text = $fleet1->itemcget($mate_keeper_navi_items[$j],-text);
								if($job_text eq "$mate_names[$k]" && $j != $i){
									$fleet1->itemconfigure($mate_keeper_navi_items[$j], -text =>"$mate_keeper_navi_names[$i]" );
									$temp = $j;
								}
							}

							############## update and end #############
							my @a = ("VARfirstmate", "VARbookkeeper", "VARchiefnavigator"); 		
							$redis->hmset("$j:ships2", $a[$i], $mate_names[$k], $a[$temp], $mate_keeper_navi_names[$i]);
							$fleet1->destroy;
							$fleet2->destroy;	
							change_duty2();
						}
					});
				}
			});
		}

		############## bind escape #############			
		$mw->bind("<Escape>",  sub{
			$fleet1->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});		
	}

	sub transfer_crew2{
		############## get @VARcrew ###############	
		@d = ();
		foreach my $i ((0..9)){         
			@{VARcrew.$i} = DOWN_small_pipe(VARcrew.$i,ships2); 
		}
		$redis->wait_all_responses;
		foreach my $i ((0..9)){         
			pipe_get(VARcrew.$i,$i);
		}

		############### canvas  ###############
		my $fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
		$fleet2->createImage( 172,177, -image => $p4c); 

		############## bind escape #############
		$mw->bind("<Escape>", sub {
			$fleet2->destroy;
			$mw->bind("<Escape>", \&dfleet);
		});

		############## text on canvas #############
		my $load = $fleet2->createText( 150,20+1*15, -text =>"Unload",-font =>"Times 12 bold");	
		bind_motion_leave_canvas($load, $fleet2);

		$fleet2->createText( 150+50,20+1*15, -text =>"Crew",-font =>"Times 12 bold");
		$fleet2->createText( 70,20+5*15, -text =>"Remaining",-font =>"Times 12 bold");
								
		for($i=0;$i<10;$i++){
			$fleet2->createText( 150,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
		}
		
		############## unload cargo num and type #############
		my @cargo0=split(/</,$VARcrew0[$j]);@cargo1=split(/</,$VARcrew1[$j]);@cargo2=split(/</,$VARcrew2[$j]);@cargo3=split(/</,$VARcrew3[$j]);@cargo4=split(/</,$VARcrew4[$j]);@cargo5=split(/</,$VARcrew5[$j]);@cargo6=split(/</,$VARcrew6[$j]);@cargo7=split(/</,$VARcrew7[$j]);@cargo8=split(/</,$VARcrew8[$j]);@cargo9=split(/</,$VARcrew9[$j]);
		my @cargoofallships = (@cargo0[0],@cargo1[0],@cargo2[0],@cargo3[0],@cargo4[0],@cargo5[0],@cargo6[0],@cargo7[0],@cargo8[0],@cargo9[0]);
		my @cargo_type_ofallships = (@cargo0[1],@cargo1[1],@cargo2[1],@cargo3[1],@cargo4[1],@cargo5[1],@cargo6[1],@cargo7[1],@cargo8[1],@cargo9[1]);

		my @cargoz = ($cargo_text0,$cargo_text1,$cargo_text2,$cargo_text3,$cargo_text4,$cargo_text5,$cargo_text6,$cargo_text7,$cargo_text8,$cargo_text9);

		my $remains = "0";
		my $amount_item = $fleet2->createText( 70,20+6*15, -text =>"$remains",-font =>"Times 12 bold");
		
		foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   	
			$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$cargoofallships[$i]",-font =>"Times 12 bold");
			bind_motion_leave_canvas($cargoz[$i], $fleet2);
		}
			
		my sub unload_cargo{	
			foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){ 	
				$fleet2->bind($cargoz[$i],"<Button-1>", sub{	
					my $enteredvalue2;	
					my $entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
					$entrybox->focus;
					$entrybox->bind('<Return>', sub{ 
						$entrybox->destroy;
						
						my $sum = $remains+$enteredvalue2;
						$remains = "$sum";

						$fleet2->itemconfigure( $amount_item, -text =>"$remains");
						$cargoofallships[$i]-= $enteredvalue2;	
						$fleet2->itemconfigure( $cargoz[$i], -text =>"$cargoofallships[$i]",-font =>"Times 12 bold");
					});

					$mw->bind("<Escape>", sub {
						$fleet2->destroy;
						$entrybox->destroy if(Exists($entrybox));
						$mw->bind("<Escape>", \&dfleet);
					});				
				});
			}
		}
		unload_cargo();
		
		############## load cargo num and type #############
		$fleet2->bind($load,"<Button-1>", sub{
			#############sub load cargo################	
			my sub load_cargo{
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){ 
					$fleet2->bind($cargoz[$i],"<Button-1>", sub{
						
						my $enteredvalue2;	
						my $entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub{ 
							$entrybox->destroy;
							my $sum = $remains-$enteredvalue2;
							$remains = "$sum";
							
							$fleet2->itemconfigure( $amount_item, -text =>"$remains");
							$cargoofallships[$i]+= $enteredvalue2;	
							$fleet2->itemconfigure( $cargoz[$i], -text =>"$cargoofallships[$i]",-font =>"Times 12 bold");
						});

						$mw->bind("<Escape>", sub {
							$fleet2->destroy;
							$entrybox->destroy if(Exists($entrybox));
							$mw->bind("<Escape>", \&dfleet);
						});		
					});
				}
			}

			#############get text and then bind accrodingly################
			my $a = $fleet2->itemcget($load,-text);
			if($a eq "Unload"){
				$fleet2->itemconfigure($load,-text => "Load");
				load_cargo();
			}	
			
			if($a eq "Load"){
				$fleet2->itemconfigure($load,-text => "Unload");
				unload_cargo();
			}
		});

		############## OK #############
		my $ok = $fleet2->createText( 70,20+8*15,  -text =>"OK",-font =>"Times 12 bold");	
		bind_motion_leave_canvas($ok, $fleet2);
		$fleet2->bind($ok,"<Button-1>", sub{
			for($i=0;$i<10;$i++){
				$redis->hset("$j:ships2", VARcrew.$i, "$cargoofallships[$i]<$cargo_type_ofallships[$i]", sub{}); 
			}
			$redis->wait_all_responses;

			$fleet2->destroy;
			dfleet();
		});
	}



	sub mate_info_open{ 
		my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+60-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet->createImage( 72,98, -image => $p4c); 
		
		$mw->bind("<Escape>",  sub{
			$fleet->destroy;
			$fleet2->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});

		$fleet2=$mw->Canvas(-background => "black",-width => 1,-height => 1,-highlightthickness => 0)->place(-x => 770-308, -y => 200+60-180);

		$mate0=$fleet->createText( 70,15*2, -text  => 'Mate0',-font =>"Times 12 bold");
		$fleet->bind($mate0,"<Button-1>",  \&mate02);$fleet->bind($mate0,"<Motion>",  \&mate0);$fleet->bind($mate0,"<Leave>",  \&mate01);
		sub mate0{ $fleet->itemconfigure($mate0, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate01{ $fleet->itemconfigure($mate0, -font =>"Times 12 bold",-fill=>"black");}
		sub mate02{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			
			sub read_for_mate_info_A{         #  read_for_mate_info_A(mate_num);
				my $a = shift;
				@d = ();

				@{VARmatename.$a} = DOWN_small_pipe(VARmatename.$a,mates0to9); @{VARmatename.$a}[0] = VARmatename.$a;
				@{VARnation.$a} = DOWN_small_pipe(VARnation.$a,mates0to9); @{VARnation.$a}[0] = VARnation.$a;
				@{VARage.$a} = DOWN_small_pipe(VARage.$a,mates0to9); @{VARage.$a}[0] = VARage.$a;
				@{VARleadership.$a} = DOWN_small_pipe(VARleadership.$a,mates0to9); @{VARleadership.$a}[0] = VARleadership.$a;
				@{VARseamanship.$a} = DOWN_small_pipe(VARseamanship.$a,mates0to9); @{VARseamanship.$a}[0] = VARseamanship.$a;
				@{VARknowledge.$a} = DOWN_small_pipe(VARknowledge.$a,mates0to9); @{VARknowledge.$a}[0] = VARknowledge.$a;
				@{VARintuition.$a} = DOWN_small_pipe(VARintuition.$a,mates0to9); @{VARintuition.$a}[0] = VARintuition.$a;
				@{VARcourage.$a} = DOWN_small_pipe(VARcourage.$a,mates0to9); @{VARcourage.$a}[0] = VARcourage.$a;
				@{VARswordplay.$a} = DOWN_small_pipe(VARswordplay.$a,mates0to9); @{VARswordplay.$a}[0] = VARswordplay.$a;
				@{VARcharm.$a} = DOWN_small_pipe(VARcharm.$a,mates0to9); @{VARcharm.$a}[0] = VARcharm.$a;
				@{VARluck.$a} = DOWN_small_pipe(VARluck.$a,mates0to9); @{VARluck.$a}[0] = VARluck.$a;
				@{VARrank.$a} = DOWN_small_pipe(VARrank.$a,mates0to9); @{VARrank.$a}[0] = VARrank.$a;
				@{VARnavigationLV.$a} = DOWN_small_pipe(VARnavigationLV.$a,mates0to9); @{VARnavigationLV.$a}[0] = VARnavigationLV.$a;
				@{VARnavigationEXP.$a} = DOWN_small_pipe(VARnavigationEXP.$a,mates0to9); @{VARnavigationEXP.$a}[0] = VARnavigationEXP.$a;
				@{VARbattleLV.$a} = DOWN_small_pipe(VARbattleLV.$a,mates0to9); @{VARbattleLV.$a}[0] = VARbattleLV.$a;
				@{VARbattleEXP.$a} = DOWN_small_pipe(VARbattleEXP.$a,mates0to9); @{VARbattleEXP.$a}[0] = VARbattleEXP.$a;
				@{VARmerchantLV.$a} = DOWN_small_pipe(VARmerchantLV.$a,mates0to9); @{VARmerchantLV.$a}[0] = VARmerchantLV.$a;
				@{VARmerchantEXP.$a} = DOWN_small_pipe(VARmerchantEXP.$a,mates0to9); @{VARmerchantEXP.$a}[0] = VARmerchantEXP.$a;
				
				$redis->wait_all_responses;
		
				pipe_get(VARmatename.$a,0);
				pipe_get(VARnation.$a,1);
				pipe_get(VARage.$a,2);
				pipe_get(VARleadership.$a,3);
				pipe_get(VARseamanship.$a,4);
				pipe_get(VARknowledge.$a,5);
				pipe_get(VARintuition.$a,6);
				pipe_get(VARcourage.$a,7);
				pipe_get(VARswordplay.$a,8);
				pipe_get(VARcharm.$a,9);	
				pipe_get(VARluck.$a,10);
				pipe_get(VARrank.$a,11);
				pipe_get(VARnavigationLV.$a,12);
				pipe_get(VARnavigationEXP.$a,13);
				pipe_get(VARbattleLV.$a,14);
				pipe_get(VARbattleEXP.$a,15);	
				pipe_get(VARmerchantLV.$a,16);
				pipe_get(VARmerchantEXP.$a,17);
			}
			read_for_mate_info_A(0);



			@sms0=([@VARmatename0],[@VARnation0], [@VARage0],[@VARleadership0],[@VARseamanship0],[@VARknowledge0],[@VARintuition0],[@VARcourage0],[@VARswordplay0],[@VARcharm0],[@VARluck0],[@VARrank0],[@VARnavigationLV0],[@VARnavigationEXP0],[@VARbattleLV0],[@VARbattleEXP0],[@VARmerchantLV0],[@VARmerchantEXP0],[@VARcelestialNavigation0],[@VARcartography0],[@VARgunnery0],[@VARaccounting0],[@VARnegotiation0]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}       
		}
			  
		$mate1=$fleet->createText( 70,15*3, -text  => 'Mate1',-font =>"Times 12 bold");
		$fleet->bind($mate1,"<Button-1>",  \&mate12);$fleet->bind($mate1,"<Motion>",  \&mate1);$fleet->bind($mate1,"<Leave>",  \&mate11);
		sub mate1{ $fleet->itemconfigure($mate1, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate11{ $fleet->itemconfigure($mate1, -font =>"Times 12 bold",-fill=>"black");}
		sub mate12{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c);
			   
			sub read_for_mate_info_B{         #  read_for_mate_info_B(mate_num);
				my $a = shift;
				@d = ();

				@{VARmatename.$a} = DOWN_small_pipe(VARmatename.$a,mates0to9); @{VARmatename.$a}[0] = VARmatename.$a;
				@{VARnation.$a} = DOWN_small_pipe(VARnation.$a,mates0to9); @{VARnation.$a}[0] = VARnation.$a;
				@{VARage.$a} = DOWN_small_pipe(VARage.$a,mates0to9); @{VARage.$a}[0] = VARage.$a;
				@{VARleadership.$a} = DOWN_small_pipe(VARleadership.$a,mates0to9); @{VARleadership.$a}[0] = VARleadership.$a;
				@{VARseamanship.$a} = DOWN_small_pipe(VARseamanship.$a,mates0to9); @{VARseamanship.$a}[0] = VARseamanship.$a;
				@{VARknowledge.$a} = DOWN_small_pipe(VARknowledge.$a,mates0to9); @{VARknowledge.$a}[0] = VARknowledge.$a;
				@{VARintuition.$a} = DOWN_small_pipe(VARintuition.$a,mates0to9); @{VARintuition.$a}[0] = VARintuition.$a;
				@{VARcourage.$a} = DOWN_small_pipe(VARcourage.$a,mates0to9); @{VARcourage.$a}[0] = VARcourage.$a;
				@{VARswordplay.$a} = DOWN_small_pipe(VARswordplay.$a,mates0to9); @{VARswordplay.$a}[0] = VARswordplay.$a;
				@{VARcharm.$a} = DOWN_small_pipe(VARcharm.$a,mates0to9); @{VARcharm.$a}[0] = VARcharm.$a;
				@{VARluck.$a} = DOWN_small_pipe(VARluck.$a,mates0to9); @{VARluck.$a}[0] = VARluck.$a;
				@{VARwage.$a} = DOWN_small_pipe(VARwage.$a,mates0to9); @{VARwage.$a}[0] = VARwage.$a;
				@{VARnavigationLV.$a} = DOWN_small_pipe(VARnavigationLV.$a,mates0to9); @{VARnavigationLV.$a}[0] = VARnavigationLV.$a;
				@{VARnavigationEXP.$a} = DOWN_small_pipe(VARnavigationEXP.$a,mates0to9); @{VARnavigationEXP.$a}[0] = VARnavigationEXP.$a;
				@{VARbattleLV.$a} = DOWN_small_pipe(VARbattleLV.$a,mates0to9); @{VARbattleLV.$a}[0] = VARbattleLV.$a;
				@{VARbattleEXP.$a} = DOWN_small_pipe(VARbattleEXP.$a,mates0to9); @{VARbattleEXP.$a}[0] = VARbattleEXP.$a;
				@{VARmerchantLV.$a} = DOWN_small_pipe(VARmerchantLV.$a,mates0to9); @{VARmerchantLV.$a}[0] = VARmerchantLV.$a;
				@{VARmerchantEXP.$a} = DOWN_small_pipe(VARmerchantEXP.$a,mates0to9); @{VARmerchantEXP.$a}[0] = VARmerchantEXP.$a;
				
				$redis->wait_all_responses;

				pipe_get(VARmatename.$a,0);
				pipe_get(VARnation.$a,1);
				pipe_get(VARage.$a,2);
				pipe_get(VARleadership.$a,3);
				pipe_get(VARseamanship.$a,4);
				pipe_get(VARknowledge.$a,5);
				pipe_get(VARintuition.$a,6);
				pipe_get(VARcourage.$a,7);
				pipe_get(VARswordplay.$a,8);
				pipe_get(VARcharm.$a,9);	
				pipe_get(VARluck.$a,10);
				pipe_get(VARwage.$a,11);
				pipe_get(VARnavigationLV.$a,12);
				pipe_get(VARnavigationEXP.$a,13);
				pipe_get(VARbattleLV.$a,14);
				pipe_get(VARbattleEXP.$a,15);	
				pipe_get(VARmerchantLV.$a,16);
				pipe_get(VARmerchantEXP.$a,17);	
			}
			read_for_mate_info_B(1);

			@sms0=([@VARmatename1],[@VARnation1], [@VARage1],[@VARleadership1],[@VARseamanship1],[@VARknowledge1],[@VARintuition1],[@VARcourage1],[@VARswordplay1],[@VARcharm1],[@VARluck1],[@VARwage1],[@VARnavigationLV1],[@VARnavigationEXP1],[@VARbattleLV1],[@VARbattleEXP1],[@VARmerchantLV1],[@VARmerchantEXP1],[@VARcelestialNavigation1],[@VARcartography1],[@VARgunnery1],[@VARaccounting1],[@VARnegotiation1]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}              
		}

		$mate2=$fleet->createText( 70,15*4, -text  => 'Mate2',-font =>"Times 12 bold");
		$fleet->bind($mate2,"<Button-1>",  \&mate22);$fleet->bind($mate2,"<Motion>",  \&mate2);$fleet->bind($mate2,"<Leave>",  \&mate21);
		sub mate2{ $fleet->itemconfigure($mate2, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate21{ $fleet->itemconfigure($mate2, -font =>"Times 12 bold",-fill=>"black");}
		sub mate22{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(2);
			@sms0=([@VARmatename2],[@VARnation2], [@VARage2],[@VARleadership2],[@VARseamanship2],[@VARknowledge2],[@VARintuition2],[@VARcourage2],[@VARswordplay2],[@VARcharm2],[@VARluck2],[@VARwage2],[@VARnavigationLV2],[@VARnavigationEXP2],[@VARbattleLV2],[@VARbattleEXP2],[@VARmerchantLV2],[@VARmerchantEXP2],[@VARcelestialNavigation2],[@VARcartography2],[@VARgunnery2],[@VARaccounting2],[@VARnegotiation2]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}            
		}

		$mate3=$fleet->createText( 70,15*5, -text  => 'Mate3',-font =>"Times 12 bold");
		$fleet->bind($mate3,"<Button-1>",  \&mate32);$fleet->bind($mate3,"<Motion>",  \&mate3);$fleet->bind($mate3,"<Leave>",  \&mate31);
		sub mate3{ $fleet->itemconfigure($mate3, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate31{ $fleet->itemconfigure($mate3, -font =>"Times 12 bold",-fill=>"black");}
		sub mate32{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(3);
			@sms0=([@VARmatename3],[@VARnation3], [@VARage3],[@VARleadership3],[@VARseamanship3],[@VARknowledge3],[@VARintuition3],[@VARcourage3],[@VARswordplay3],[@VARcharm3],[@VARluck3],[@VARwage3],[@VARnavigationLV3],[@VARnavigationEXP3],[@VARbattleLV3],[@VARbattleEXP3],[@VARmerchantLV3],[@VARmerchantEXP3],[@VARcelestialNavigation3],[@VARcartography3],[@VARgunnery3],[@VARaccounting3],[@VARnegotiation3]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}             
		}

		$mate4=$fleet->createText( 70,15*6, -text  => 'Mate4',-font =>"Times 12 bold");
		$fleet->bind($mate4,"<Button-1>",  \&mate42);$fleet->bind($mate4,"<Motion>",  \&mate4);$fleet->bind($mate4,"<Leave>",  \&mate41);
		sub mate4{ $fleet->itemconfigure($mate4, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate41{ $fleet->itemconfigure($mate4, -font =>"Times 12 bold",-fill=>"black");}
		sub mate42{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(4);
			@sms0=([@VARmatename4],[@VARnation4], [@VARage4],[@VARleadership4],[@VARseamanship4],[@VARknowledge4],[@VARintuition4],[@VARcourage4],[@VARswordplay4],[@VARcharm4],[@VARluck4],[@VARwage4],[@VARnavigationLV4],[@VARnavigationEXP4],[@VARbattleLV4],[@VARbattleEXP4],[@VARmerchantLV4],[@VARmerchantEXP4],[@VARcelestialNavigation4],[@VARcartography4],[@VARgunnery4],[@VARaccounting4],[@VARnegotiation4]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}          
		}

		$mate5=$fleet->createText( 70,15*7, -text  => 'Mate5',-font =>"Times 12 bold");
		$fleet->bind($mate5,"<Button-1>",  \&mate52);$fleet->bind($mate5,"<Motion>",  \&mate5);$fleet->bind($mate5,"<Leave>",  \&mate51);
		sub mate5{ $fleet->itemconfigure($mate5, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate51{ $fleet->itemconfigure($mate5, -font =>"Times 12 bold",-fill=>"black");}
		sub mate52{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(5);
			@sms0=([@VARmatename5],[@VARnation5], [@VARage5],[@VARleadership5],[@VARseamanship5],[@VARknowledge5],[@VARintuition5],[@VARcourage5],[@VARswordplay5],[@VARcharm5],[@VARluck5],[@VARwage5],[@VARnavigationLV5],[@VARnavigationEXP5],[@VARbattleLV5],[@VARbattleEXP5],[@VARmerchantLV5],[@VARmerchantEXP5],[@VARcelestialNavigation5],[@VARcartography5],[@VARgunnery5],[@VARaccounting5],[@VARnegotiation5]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}            
		}

		$mate6=$fleet->createText( 70,15*8, -text  => 'Mate6',-font =>"Times 12 bold");
		$fleet->bind($mate6,"<Button-1>",  \&mate62);$fleet->bind($mate6,"<Motion>",  \&mate6);$fleet->bind($mate6,"<Leave>",  \&mate61);
		sub mate6{ $fleet->itemconfigure($mate6, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate61{ $fleet->itemconfigure($mate6, -font =>"Times 12 bold",-fill=>"black");}
		sub mate62{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(6);
			@sms0=([@VARmatename6],[@VARnation6], [@VARage6],[@VARleadership6],[@VARseamanship6],[@VARknowledge6],[@VARintuition6],[@VARcourage6],[@VARswordplay6],[@VARcharm6],[@VARluck6],[@VARwage6],[@VARnavigationLV6],[@VARnavigationEXP6],[@VARbattleLV6],[@VARbattleEXP6],[@VARmerchantLV6],[@VARmerchantEXP6],[@VARcelestialNavigation6],[@VARcartography6],[@VARgunnery6],[@VARaccounting6],[@VARnegotiation6]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}          
		}

		$mate7=$fleet->createText( 70,15*9, -text  => 'Mate7',-font =>"Times 12 bold");
		$fleet->bind($mate7,"<Button-1>",  \&mate72);$fleet->bind($mate7,"<Motion>",  \&mate7);$fleet->bind($mate7,"<Leave>",  \&mate71);
		sub mate7{ $fleet->itemconfigure($mate7, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate71{ $fleet->itemconfigure($mate7, -font =>"Times 12 bold",-fill=>"black");}
		sub mate72{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(7);
			@sms0=([@VARmatename7],[@VARnation7], [@VARage7],[@VARleadership7],[@VARseamanship7],[@VARknowledge7],[@VARintuition7],[@VARcourage7],[@VARswordplay7],[@VARcharm7],[@VARluck7],[@VARwage7],[@VARnavigationLV7],[@VARnavigationEXP7],[@VARbattleLV7],[@VARbattleEXP7],[@VARmerchantLV7],[@VARmerchantEXP7],[@VARcelestialNavigation7],[@VARcartography7],[@VARgunnery7],[@VARaccounting7],[@VARnegotiation7]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}            
		}

		$mate8=$fleet->createText( 70,15*10, -text  => 'Mate8',-font =>"Times 12 bold");
		$fleet->bind($mate8,"<Button-1>",  \&mate82);$fleet->bind($mate8,"<Motion>",  \&mate8);$fleet->bind($mate8,"<Leave>",  \&mate81);
		sub mate8{ $fleet->itemconfigure($mate8, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate81{ $fleet->itemconfigure($mate8, -font =>"Times 12 bold",-fill=>"black");}
		sub mate82{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(8);
			@sms0=([@VARmatename8],[@VARnation8], [@VARage8],[@VARleadership8],[@VARseamanship8],[@VARknowledge8],[@VARintuition8],[@VARcourage8],[@VARswordplay8],[@VARcharm8],[@VARluck8],[@VARwage8],[@VARnavigationLV8],[@VARnavigationEXP8],[@VARbattleLV8],[@VARbattleEXP8],[@VARmerchantLV8],[@VARmerchantEXP8],[@VARcelestialNavigation8],[@VARcartography8],[@VARgunnery8],[@VARaccounting8],[@VARnegotiation8]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}    
		}

		$mate9=$fleet->createText( 70,15*11, -text  => 'Mate9',-font =>"Times 12 bold");
		$fleet->bind($mate9,"<Button-1>",  \&mate92);$fleet->bind($mate9,"<Motion>",  \&mate9);$fleet->bind($mate9,"<Leave>",  \&mate91);
		sub mate9{ $fleet->itemconfigure($mate9, -font =>"Times 12 bold ",-fill=>"grey20");}
		sub mate91{ $fleet->itemconfigure($mate9, -font =>"Times 12 bold",-fill=>"black");}
		sub mate92{
			$fleet2->destroy;
			$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
			$fleet2->createImage( 172,177, -image => $p4c); 
			   
			read_for_mate_info_B(9);
			@sms0=([@VARmatename9],[@VARnation9], [@VARage9],[@VARleadership9],[@VARseamanship9],[@VARknowledge9],[@VARintuition9],[@VARcourage9],[@VARswordplay9],[@VARcharm9],[@VARluck9],[@VARwage9],[@VARnavigationLV9],[@VARnavigationEXP9],[@VARbattleLV9],[@VARbattleEXP9],[@VARmerchantLV9],[@VARmerchantEXP9],[@VARcelestialNavigation9],[@VARcartography9],[@VARgunnery9],[@VARaccounting9],[@VARnegotiation9]);
			for($i=0;$i<@sms0;$i++){
				$var1 = substr($sms0[$i][0], 3);
				$var2 = substr($var1,0,-1);
				$fleet2->createText( 120,20+$i*14, -text =>"$var2");  $fleet2->createText( 200,20+$i*14, -text => "$sms0[$i][$j]"); 
			}             
		}

		for(my $i=0;$i<10;$i++){
			bind_motion_leave_canvas(${mate.$i}, $fleet);
		}    
	}
			  
	###########  !info ###########
	###########  @button clicked ###########
	sub infobutton{       
		   $canvasfleet=$mw->Canvas(-background => "red",-width => 18,-height => 80,-highlightthickness => 0)->place(-x => 943-18-308, -y => 253+160-180);
		   my $p3c = $mw->Photo(-file => 'images//z_others//'."infobuttonclicked.gif", -format => 'gif',-width => 18,-height => 80 );
		   $pac=$canvasfleet->createImage( 9,40, -image => $p3c);
		   $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+120-180);
		   my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		   $fleet->createImage( 72,98, -image => $p4c); 

		   $mw->bind("<Escape>",  \&dfleet);

		   $port_map=$fleet->createText( 70,60+80, -text  => 'Port Map',-font =>"Times 12 bold");
		   $fleet->bind($port_map,"<Motion>",  \&port_map);$fleet->bind($port_map,"<Leave>",  \&port_map1);$fleet->bind($port_map,"<Button-1>",  \&port_map2);
		   $chart=$fleet->createText( 70,60+60, -text  => 'Chart',-font =>"Times 12 bold");
		   $fleet->bind($chart,"<Motion>",  \&chart);$fleet->bind($chart,"<Leave>",  \&chart1);$fleet->bind($chart,"<Button-1>", \&chart_open); 
		   $journal=$fleet->createText( 70,60+40, -text  => 'Journal',-font =>"Times 12 bold");
		   $fleet->bind($journal,"<Motion>",  \&journal);$fleet->bind($journal,"<Leave>",  \&journal1);
		   $discovery=$fleet->createText( 70,60+20, -text  => 'Discovery',-font =>"Times 12 bold");
		   $fleet->bind($discovery,"<Motion>",  \&discovery);$fleet->bind($discovery,"<Leave>",  \&discovery1);$fleet->bind($discovery,"<Button-1>",  \&discovery2);
		   $item=$fleet->createText( 70,60, -text  => 'Item',-font =>"Times 12 bold");
		   $fleet->bind($item,"<Motion>",  \&item);$fleet->bind($item,"<Leave>",  \&item1);$fleet->bind($item,"<Button-1>",  \&item2);
	}	   
		   
	###################### @info visual effects ################
	sub port_map{ $fleet->itemconfigure($port_map, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub port_map1{ $fleet->itemconfigure($port_map, -font =>"Times 12 bold",-fill=>"black");
	}
	sub chart{ $fleet->itemconfigure($chart, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub chart1{ $fleet->itemconfigure($chart, -font =>"Times 12 bold",-fill=>"black");
	}
	sub journal{ $fleet->itemconfigure($journal, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub journal1{ $fleet->itemconfigure($journal, -font =>"Times 12 bold",-fill=>"black");
	}
	sub discovery{ $fleet->itemconfigure($discovery, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub discovery1{ $fleet->itemconfigure($discovery, -font =>"Times 12 bold",-fill=>"black");
	}
	sub item{ $fleet->itemconfigure($item, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub item1{ $fleet->itemconfigure($item, -font =>"Times 12 bold",-fill=>"black");
	}
	sub hero_info{ $fleet->itemconfigure($hero_info, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub hero_info1{ $fleet->itemconfigure($hero_info, -font =>"Times 12 bold",-fill=>"black");
	}
	sub mate_info{ $fleet->itemconfigure($mate_info, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub mate_info1{ $fleet->itemconfigure($mate_info, -font =>"Times 12 bold",-fill=>"black");
	}

	###################### @info click events ################
	sub chart_open{ 
		############### create mini_map canvas  ###############
		my $mini_map = $mw->Canvas(-background => "red",-width => 600,-height => 288,-highlightthickness => 0)->place(-x => 320-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."world_map_grids_1.PNG", -format => 'png',-width => 600,-height => 291 );
		$mini_map->createImage( 600/2, 288/2, -image => $p4c); 	

		############## bind escape #############
		$mw->bind("<Escape>", sub {
			$mini_map->destroy;
			$mw->bind("<Escape>", \&dfleet);	
			
		});

		############## calculate longtitude and latitude #############
		my sub calc_longti_lati {   # calc_longti_lati($x,$y);
			my $i = shift;
			my $k = shift;
			my $longitude;
			my $latitude;
		
			############ transform to longitude   ###############
			if ( $i >= 900 && $i <= 1980 ) {
				$longitude = int(( $i - 900 )/6);
				$longitude = $longitude.e;	
			
			}
			elsif ( $i > 1980 ) {
				$longitude = int((900 + 2160 - $i)/6);
				$longitude = $longitude.w;
			}
			else {
				$longitude = int((900 - $i)/6);
				$longitude = $longitude.w;
			
			}

			############ transform to latitude   ###############
			if ( $k <= 640 ) {
				$latitude = int((640 - $k)/7.2);
				$latitude = $latitude.N;
			}
			else {
				$latitude = int(($k - 640)/7.2);
				$latitude = $latitude.S;
			
			}
			
			$mini_map->createText( 300, 5, -text => "$latitude $longitude ", -fill => "red", -font =>"Times 12 bold"); 

			# print "$k $i  = $latitude   $longitude    \n";
		}
		calc_longti_lati( $cx[$j]/16, $cy[$j]/16 );			
	}

	sub item2{
		############## create right canvas ############## 
		my $fleet1=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+120-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet1->createImage( 72,98, -image => $p4c); 

		############## bind escape ############## 			
		$mw->bind("<Escape>",  sub{
			$fleet1->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});		

		############## make text ############## 
		my $item_list = $redis->hget("$j:primary1", VARitem);
		my $sign = "/";
		my @items = split(/$sign/,$item_list);

		my @text_items = ();
		foreach my $i(0..@items){  
			$text_items[$i] = $fleet1->createText( 10,14+($i*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
		}

		############## bind text ############## 
		foreach my $i(0..@items){  
			bind_motion_leave_canvas($text_items[$i], $fleet1);
		}

		my $fleet2;
		foreach my $i(0..@items){  
			$fleet1->bind($text_items[$i],"<Button-1>", sub{
				############## destroy opened canvas ###########
				$fleet2->destroy if(Exists($fleet2));

				############### create left canvas  ###############
				$fleet2 = $mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 	

				############## bind escape #############
				$mw->bind("<Escape>", sub {
					$fleet2->destroy;
					$mw->bind("<Escape>",  sub{
						$fleet1->destroy;
						$mw->bind("<Escape>", \&dfleet);	
					});
				});
	
				############## make image #############
				my $name = $fleet1->itemcget($text_items[$i],-text);
				my $lower_name = $name;		
				my $item_image = $mw->Photo(-file => "images//item//$lower_name.png", -format => 'png',-width => 49,-height => 48 );
				$fleet2->createImage( 40,40, -image => $item_image); 

				############## make description #############
				open( my $input, '<', "images//item//$lower_name.txt" );

				my $description;
				while (<$input>) {
					chomp;
					$description = $description.$_;
				}
				close($input);
				
				$fleet2->createText( 180,120, -text => $description, -font =>"Times 12 bold", -width =>"300" );	

			});
		}
	}

	sub discovery2 {
		############### create left canvas  ###############
		my $fleet2 = $mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
		$fleet2->createImage( 172,177, -image => $p4c); 

		############## bind escape #############
		$mw->bind("<Escape>", sub {
			$fleet2->destroy;
			$mw->bind("<Escape>", \&dfleet);		
		});

		############## make text ############## 
		my $item_list = $redis->hget("$j:primary1", VARdiscovery);
		my $sign = "/";
		my @items = split(/$sign/,$item_list);

		my @text_items = ();
		foreach my $i(0..@items){  
			$text_items[$i] = $fleet2->createText( 10,14+($i*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
		}

		############## bind text ############## 
		foreach my $i(0..@items){  
			bind_motion_leave_canvas($text_items[$i], $fleet2);
		}

		my $fleet3;
		foreach my $i(0..@items){  
			$fleet2->bind($text_items[$i],"<Button-1>", sub{
				############### create left canvas  ###############
				$fleet3 = $mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet3->createImage( 172,177, -image => $p4c); 

				############## bind escape #############
				$mw->bind("<Escape>", sub {
					$fleet3->destroy;
					$mw->bind("<Escape>",  sub{
						$fleet2->destroy;
						$mw->bind("<Escape>", \&dfleet);	
					});
				});

				############## make image #############
				my $name = $fleet2->itemcget($text_items[$i],-text);
				my $lower_name = lc($name);		
				my $item_image = $mw->Photo(-file => "images//discovery//$lower_name.png", -format => 'png',-width => 49,-height => 48 );
				$fleet3->createImage( 40,40, -image => $item_image); 

				############## make description #############
				open( my $input, '<', "images//discovery//$lower_name.txt" );

				my $description;
				while (<$input>) {
					chomp;
					$description = $description.$_;
				}
				close($input);
				
				$fleet3->createText( 180,120, -text => $description, -font =>"Times 12 bold", -width =>"300" );	
			});
		}
	}

	sub port_map2 {
		############### create mini_map canvas  ###############
		my $mini_map = $mw->Canvas(-background => "red",-width => 141,-height => 150,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
		# my $p4c = $mw->Photo(-file => 'images//z_others//'."london mini.gif", -format => 'gif',-width => 141,-height => 159 );
		
		# my $portImageShrinked = $port_image->scale(scalefactor=>0.11);
		# my $data = image2data($portImageShrinked);
				
		# my $portImage = $mw->Photo(-data => $data, -format => 'png',-width => 141,-height => 159);
		
		$mini_map->createImage( 139/2, 150/2, -image => $portImage_mini); 	

		############## bind escape #############
		$mw->bind("<Escape>", sub {
			$mini_map->destroy;
			# $portImage->delete;
			$mw->bind("<Escape>", \&dfleet);		
		});
		
		############## show coordinates pointer on mini_map #############
		$mini_map->createText(141*(480-$cx[$j])/(480+75), 159*(525-$cy[$j])/(525+105), -text => "X", -fill => "red", -font =>"Times 12 bold"); 	
	}

	###########  !navigation ###########
	###########  @button clicked ###########
	sub navigationbutton{       
			$canvasfleet=$mw->Canvas(-background => "red",-width => 20,-height => 80,-highlightthickness => 0)->place(-x => 941-18-308, -y => 253+240-180);
			my $p3c = $mw->Photo(-file => 'images//z_others//'."navigationbuttonclicked.gif", -format => 'gif',-width => 20,-height => 80 );
			$pac=$canvasfleet->createImage( 10,40, -image => $p3c);
			$fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+180-180);
			my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
			$fleet->createImage( 72,98, -image => $p4c); 

			$mw->bind("<Escape>",  \&dfleet);

			$enter=$fleet->createText( 70,155-10, -text  => 'Enter',-font =>"Times 12 bold");
			$fleet->bind($enter,"<Motion>",  \&enter);$fleet->bind($enter,"<Leave>",  \&enter1);$fleet->bind($enter,"<Button-1>",  \&enter2);

			$options=$fleet->createText( 70,155+10, -text  => 'Options',-font =>"Times 12 bold");
			$fleet->bind($options,"<Motion>",  \&options);$fleet->bind($options,"<Leave>",  \&options1);$fleet->bind($options,"<Button-1>", \&options_open);

			$battle=$fleet->createText( 70,155-30, -text  => 'Battle',-font =>"Times 12 bold");
			$fleet->bind($battle,"<Motion>",  \&battle);$fleet->bind($battle,"<Leave>",  \&battle1);$fleet->bind($battle,"<Button-1>",  \&battle2);

			$gossip=$fleet->createText( 70,155-50, -text  => 'Gossip',-font =>"Times 12 bold");
			$fleet->bind($gossip,"<Motion>",  \&gossip);$fleet->bind($gossip,"<Leave>",  \&gossip1);
		   		
			$view = $fleet->createText( 70,155-70, -text  => 'View',-font =>"Times 12 bold");
			$fleet->bind($view,"<Motion>",  \&view);$fleet->bind($view,"<Leave>",  \&view1);
	
		    $go_ashore=$fleet->createText( 70,155-90, -text  => 'Go Ashore',-font =>"Times 12 bold");
		    $fleet->bind($go_ashore,"<Motion>",  \&go_ashore);$fleet->bind($go_ashore,"<Leave>",  \&go_ashore1);$fleet->bind($go_ashore,"<Button-1>",  \&enter_village);
		   
		    $port_call=$fleet->createText( 70,155-110, -text  => 'Port Call',-font =>"Times 12 bold");
		    $fleet->bind($port_call,"<Motion>",  \&port_call);$fleet->bind($port_call,"<Leave>",  \&port_call1);$fleet->bind($port_call,"<Button-1>",  \&port_call2);
		   
		    $auto_sail=$fleet->createText( 70,155-130, -text  => 'Auto Sail',-font =>"Times 12 bold");
		    $fleet->bind($auto_sail,"<Motion>",  \&auto_sail);$fleet->bind($auto_sail,"<Leave>",  \&auto_sail1);
	}
			   
	############################## @naviagtion visual effects ################
	sub options{ $fleet->itemconfigure($options, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub options1{ $fleet->itemconfigure($options, -font =>"Times 12 bold",-fill=>"black");
	}
	sub battle{ $fleet->itemconfigure($battle, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub battle1{ $fleet->itemconfigure($battle, -font =>"Times 12 bold",-fill=>"black");
	}
	sub gossip{ $fleet->itemconfigure($gossip, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub gossip1{ $fleet->itemconfigure($gossip, -font =>"Times 12 bold",-fill=>"black");
	}
	sub view{ $fleet->itemconfigure($view, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub view1{ $fleet->itemconfigure($view, -font =>"Times 12 bold",-fill=>"black");
	}
	sub go_ashore{ $fleet->itemconfigure($go_ashore, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub go_ashore1{ $fleet->itemconfigure($go_ashore, -font =>"Times 12 bold",-fill=>"black");
	}
	sub port_call{ $fleet->itemconfigure($port_call, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub port_call1{ $fleet->itemconfigure($port_call, -font =>"Times 12 bold",-fill=>"black");
	}
	sub enter{ $fleet->itemconfigure($enter, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub enter1{ $fleet->itemconfigure($enter, -font =>"Times 12 bold",-fill=>"black");
	}
	sub auto_sail{ $fleet->itemconfigure($auto_sail, -font =>"Times 12 bold ",-fill=>"grey20");
	}
	sub auto_sail1{ $fleet->itemconfigure($auto_sail, -font =>"Times 12 bold",-fill=>"black");
	}  

	############################## @naviagtion click events ################
	sub options_open{ 
		my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+180-180);
		my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
		$fleet->createImage( 72,98, -image => $p4c); 

		$mw->bind("<Escape>",  sub{
			$fleet->destroy;
			$mw->bind("<Escape>", \&dfleet);	
		});	
			
		$end=$fleet->createText( 70,155, -text  => 'End Game',-font =>"Times 12 bold");
		$fleet->bind($end,"<Button-1>",  \&end2);
		bind_motion_leave_canvas($end, $fleet);
		
		sub end2{ 
			kill( 'KILL', $$ );	    
		}

		$load=$fleet->createText( 70,155-20, -text  => 'Load',-font =>"Times 12 bold");
		$fleet->bind($load,"<Button-1>",  \&load2);
		bind_motion_leave_canvas($load, $fleet);

		$save=$fleet->createText( 70,155-40, -text  => 'Save',-font =>"Times 12 bold");
		$fleet->bind($save,"<Button-1>",  \&save2);
		bind_motion_leave_canvas($save, $fleet);

		$settings=$fleet->createText( 70,155-60, -text  => 'Settings',-font =>"Times 12 bold");
		$fleet->bind($settings,"<Button-1>",  \&settings2);
		bind_motion_leave_canvas($settings, $fleet);          
	}

	##############################  @end2  key q ################
	$mw->bind("<Key-q>", sub {
		kill( 'KILL', $$ );
	}); 



1;	