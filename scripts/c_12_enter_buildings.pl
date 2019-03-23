	############# !buildings market\bar\port\bank\dry dock\item shop\inn\palace\church\job house\fortune\am port\am market ###############
	sub enter2{
		################ @london_market ########################             		 
		if ( $mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{1}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{1}}{y}){	
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."market_fore.gif", -format => 'gif',-width => 139,-height => 114 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Hi! I'm the owner of this market.\nHow may I help you? ",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 

			############# #buy ###############				
			$buy=$canvas2->createText( 58,30, -text  => 'Buy',-font =>"Times 12 bold");
			$canvas2->bind($buy,"<Button-1>",  \&buy2_london);$canvas2->bind($buy,"<Motion>",  \&buy);$canvas2->bind($buy,"<Leave>",  \&buy1);
			sub buy{ $canvas2->itemconfigure($buy, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub buy1{ $canvas2->itemconfigure($buy, -font =>"Times 12 bold",-fill=>"black");}
			sub buy2_london{ 
				###### download data ######
				@d = ();
				foreach my $i ((0..9)){         
					@{VARcargo.$i} = DOWN_small_pipe(VARcargo.$i,ships2); 
				}

				$redis->wait_all_responses;

				foreach my $i ((0..9)){         
					pipe_get(VARcargo.$i,$i);
				}

				###### show buy_menu ######
				$p7 = $mw->Photo(-file => 'images//z_others//'."buy_menu1.png", -format => 'png',-width => 368,-height => 156 );
				$p7=$canvas1->createImage( 190,230, -image => $p7); 

				###### show available items and prices ######
				my $received_jason = command_get(show_items_in_market);
				my $json = JSON->new->allow_nonref;
				my $hash_ref_available_items = $json->decode( $received_jason );
				my %got_hash = %$hash_ref_available_items;
				
				my @item_names;
				my @item_price;
				
				foreach my $key (sort(keys %got_hash)) {
					if ( $key ne 'special_item' ) {
						push(@item_names, $key);
						push(@item_price, $got_hash{$key}[0]);
					}
				}
				
				# print $received_jason;
				# my $hash_ref_available_items = decode_json($received_data);
				# print $ { $hash_ref_available_items}{Cheese}[0];
				# print "$got_hash{special_item} is special here \n";
				$canvas1->itemconfigure($welcome, -text => "$got_hash{special_item} is special here");
				
				my $small_red_potion=$canvas1->createText( 30,190, -text =>  "$item_names[0]",-font =>"Times 12 bold", -anchor => "w");
				my $small_red_potion_price=$canvas1->createText( 190,190, -text =>  "$item_price[0]",-font =>"Times 12 bold", -anchor => "e");

				my $mid_red_potion=$canvas1->createText( 30,190+20, -text => "$item_names[1] ",-font =>"Times 12 bold", -anchor => "w");
				my $mid_red_potion_price=$canvas1->createText( 190,190+20, -text =>  "$item_price[1]",-font =>"Times 12 bold", -anchor => "e");

				my $cotton_cloth=$canvas1->createText( 30,190+40, -text => "$item_names[2]",-font =>"Times 12 bold", -anchor => "w");
				my $cotton_cloth_price=$canvas1->createText( 190,190+40, -text =>  "$item_price[2]",-font =>"Times 12 bold", -anchor => "e");

				my $wool=$canvas1->createText( 30,190+60, -text => "$item_names[3]",-font =>"Times 12 bold", -anchor => "w");
				my $wool_price=$canvas1->createText( 190,190+60, -text =>  "$item_price[3]",-font =>"Times 12 bold", -anchor => "e");			

				my $fifth_item=$canvas1->createText( 30,190+80, -text => "$item_names[4]",-font =>"Times 12 bold", -anchor => "w");
				my $fifth_item_price=$canvas1->createText( 190,190+80, -text =>  "$item_price[4]",-font =>"Times 12 bold", -anchor => "e");
				
				
				#############
				my $fish=$canvas1->createText( 200,190+0, -text => "$item_names[5]",-font =>"Times 12 bold", -anchor => "w");
				my $fish_price=$canvas1->createText( 360,190+0, -text =>  "$item_price[5]",-font =>"Times 12 bold", -anchor => "e");

				my $cotton=$canvas1->createText( 200,190+20, -text => "$item_names[6]",-font =>"Times 12 bold", -anchor => "w");
				my $cotton_price=$canvas1->createText( 360,190+20, -text =>  "$item_price[6]",-font =>"Times 12 bold", -anchor => "e");

				my $iron_ore=$canvas1->createText( 200,190+40, -text => "$item_names[7]",-font =>"Times 12 bold", -anchor => "w");
				my $iron_ore_price=$canvas1->createText( 360,190+40, -text =>  "$item_price[7]",-font =>"Times 12 bold", -anchor => "e");		

				my $ninth_item=$canvas1->createText( 200,190+60, -text => "$item_names[8]",-font =>"Times 12 bold", -anchor => "w");
				my $ninth_item_price=$canvas1->createText( 360,190+60, -text =>  "$item_price[8]",-font =>"Times 12 bold", -anchor => "e");
				
				my $tenth_item=$canvas1->createText( 200,190+80, -text => "$item_names[9]",-font =>"Times 12 bold", -anchor => "w");
				my $tenth_item_price=$canvas1->createText( 360,190+80, -text =>  "$item_price[9]",-font =>"Times 12 bold", -anchor => "e");
				
				
				sub bind_motion_leave{    	## bind_motion_leave($fish); 
					my $a = shift;
					$canvas1->bind($a,"<Motion>",  sub{
						$canvas1->itemconfigure($a, -font =>"Times 12 bold ",-fill=>"grey20");
					});
					$canvas1->bind($a,"<Leave>",  sub {
						$canvas1->itemconfigure($a, -font =>"Times 12 bold",-fill=>"black");
					});
				}
					
				bind_motion_leave($small_red_potion);				
				bind_motion_leave($mid_red_potion);
				bind_motion_leave($cotton_cloth); 
				bind_motion_leave($wool); 
				bind_motion_leave($fish); 
				bind_motion_leave($cotton); 
				bind_motion_leave($iron_ore); 
				bind_motion_leave($fifth_item);
				bind_motion_leave($ninth_item);
				bind_motion_leave($tenth_item);
				
				#####################################  buy   ##########################
									
				bind_button_1($small_red_potion, "$item_names[0]");
				bind_button_1($mid_red_potion, "$item_names[1]");
				bind_button_1($cotton_cloth, "$item_names[2]");
				bind_button_1($wool, "$item_names[3]");
				bind_button_1($fifth_item, "$item_names[4]");
				bind_button_1($fish, "$item_names[5]");
				bind_button_1($cotton, "$item_names[6]");
				bind_button_1($iron_ore, "$item_names[7]");
				bind_button_1($ninth_item, "$item_names[8]");
				bind_button_1($tenth_item, "$item_names[9]");
			
				sub bind_button_1{    	## bind_motion_leave($fish, "Fish"); 
					my $a = shift;
					my $b = shift;
					$canvas1->bind($a,"<Button-1>",  sub{
						$mw->bind("<Escape>", sub {
							$fleet2->destroy; 
							$mw->bind("<Escape>", \&exit_building);	
						});
								  
						$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
						my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
						$fleet2->createImage( 172,177, -image => $p4c); 
						
						my $item_name = $fleet2->createText( 60,20+9*15, -text =>"$b",-font =>"Times 12 bold");

						$load = $fleet2->createText( 150,20+1*15, -text =>"Buy",-font =>"Times 12 bold");
						$fleet2->bind($load,"<Motion>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"grey20");});
						$fleet2->bind($load,"<Leave>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"black");});
						$fleet2->bind($load,"<Button-1>", sub {$fleet2->destroy;smallredpotion2london3();});

						$fleet2->createText( 150+50,20+1*15, -text =>"Cargo",-font =>"Times 12 bold");
						
						for($i=0;$i<10;$i++){
							$fleet2->createText( 150,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
						}
						
						@cargo0=split(/</,$VARcargo0[$j]);@cargo1=split(/</,$VARcargo1[$j]);@cargo2=split(/</,$VARcargo2[$j]);@cargo3=split(/</,$VARcargo3[$j]);@cargo4=split(/</,$VARcargo4[$j]);@cargo5=split(/</,$VARcargo5[$j]);@cargo6=split(/</,$VARcargo6[$j]);@cargo7=split(/</,$VARcargo7[$j]);@cargo8=split(/</,$VARcargo8[$j]);@cargo9=split(/</,$VARcargo9[$j]);
						@cargoofallships = (@cargo0[0],@cargo1[0],@cargo2[0],@cargo3[0],@cargo4[0],@cargo5[0],@cargo6[0],@cargo7[0],@cargo8[0],@cargo9[0]);
						@cargo_type_ofallships = (@cargo0[1],@cargo1[1],@cargo2[1],@cargo3[1],@cargo4[1],@cargo5[1],@cargo6[1],@cargo7[1],@cargo8[1],@cargo9[1]);
						@cargoz = ($cargo_text0,$cargo_text1,$cargo_text2,$cargo_text3,$cargo_text4,$cargo_text5,$cargo_text6,$cargo_text7,$cargo_text8,$cargo_text9);

						#$cargoz[$i]
						#$fleet2->createText( 70+50,20+(2+0)*25, -text =>"$cargoofallships[0]",-font =>"Times 12 bold");
						foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){  
							if($cargoofallships[$i] == 0){
								$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"none",-font =>"Times 12 bold");
							}
							else{
								$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$cargoofallships[$i] $cargo_type_ofallships[$i]",-font =>"Times 12 bold");
							}
							#$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$cargoofallships[$i] $cargo_type_ofallships[$i]",-font =>"Times 12 bold");
							$fleet2->bind($cargoz[$i],"<Motion>", sub {$fleet2->itemconfigure($cargoz[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
							$fleet2->bind($cargoz[$i],"<Leave>", sub {$fleet2->itemconfigure($cargoz[$i], -font =>"Times 12 bold ",-fill=>"black");});
							$fleet2->bind($cargoz[$i],"<Button-1>", sub{						
								$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
								$entrybox->focus;
								$entrybox->bind('<Return>', sub{ 
									######## command_get() ##############
										#####  send buy_trade_goods, ship_num, number_entered, cargo_type   ########
										my $received_jason = command_get('buy_trade_goods:'.$i.':'.$enteredvalue2.':'.$b);
									
										#####  get remaining_gold_coins and cargo_left   ########
										my $json = JSON->new->allow_nonref;
										my $array_ref_zy_and_cargo_num = $json->decode( $received_jason );
										
										my $zy = ${ $array_ref_zy_and_cargo_num }[0];
										my $cargo_num = ${ $array_ref_zy_and_cargo_num }[1];

									########### change display ####################
									if( $cargo_num > 0 ){ 
										##### remove entrybox ######
										$entrybox->destroy;
								
										##### if gold changed ######
										if ( $zy != $zy[$j] ) {
											##### change gold ######
											$zy[$j] = $zy;
											
											$ingots=int($zy[$j]/10000);
											$coins=$zy[$j]-$ingots*10000;

											$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
											$canvasleft->itemconfigure($coins_num,-text=>"$coins");
											
											##### change cargo_left ######
											$fleet2->itemconfigure($cargoz[$i],-text=>"$cargo_num $b");
										}
										
										##### if no gold changed ######
										else {
											##### do nothing ######
										}		
									}
									elsif( $cargo_num == 0 ){        	        	      	        		    
										##### remove entrybox ######
										$entrybox->destroy;
								
										##### change gold ######
										$zy[$j] = $zy;
										
										$ingots=int($zy[$j]/10000);
										$coins=$zy[$j]-$ingots*10000;

										$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
										$canvasleft->itemconfigure($coins_num,-text=>"$coins");
										
										##### change cargo_left ######
										$fleet2->itemconfigure($cargoz[$i],-text=>"none");											
									}
									else {
										##### remove entrybox ######
										$entrybox->destroy;
									
									}
								
									# if($cargoofallships[$i] > 0 && $cargo_type_ofallships[$i] eq "$b"){												   
										# $entrybox->destroy;
										# $cargoofallships[$i]+=$enteredvalue2;

										# $zy[$j]-=$enteredvalue2 * 5;
										# my $sum=$enteredvalue1 * 5;
										# #$canvas1->itemconfigure($welcome, -text =>"bought $enteredvalue1 small_red_potion \nfor $sum !");

										# $ingots=int($zy[$j]/10000);
										# $coins=$zy[$j]-$ingots*10000;


										# $fleet2->itemconfigure($cargoz[$i],-text=>"$cargoofallships[$i] $cargo_type_ofallships[$i]");
										# $canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
										# $canvasleft->itemconfigure($coins_num,-text=>"$coins");

										# (@cargo0[0],@cargo1[0],@cargo2[0],@cargo3[0],@cargo4[0],@cargo5[0],@cargo6[0],@cargo7[0],@cargo8[0],@cargo9[0]) = @cargoofallships ;
										# $cargo0add=@cargo0[0]."<".@cargo0[1];$cargo1add=@cargo1[0]."<".@cargo1[1];$cargo2add=@cargo2[0]."<".@cargo2[1];$cargo3add=@cargo3[0]."<".@cargo3[1];$cargo4add=@cargo4[0]."<".@cargo4[1];$cargo5add=@cargo5[0]."<".@cargo5[1];$cargo6add=@cargo6[0]."<".@cargo6[1];$cargo7add=@cargo7[0]."<".@cargo7[1];$cargo8add=@cargo8[0]."<".@cargo8[1];$cargo9add=@cargo9[0]."<".@cargo9[1];
										# $VARcargo0[$j]=$cargo0add;$VARcargo1[$j]=$cargo1add;$VARcargo2[$j]=$cargo2add;$VARcargo3[$j]=$cargo3add;$VARcargo4[$j]=$cargo4add;$VARcargo5[$j]=$cargo5add;$VARcargo6[$j]=$cargo6add;$VARcargo7[$j]=$cargo7add;$VARcargo8[$j]=$cargo8add;$VARcargo9[$j]=$cargo9add;

										# UP_small_someone_from(VARzeny,$zy[$j],$j,primary1);
										# UP_small_someone_from(VARcargo.$i,"${VARcargo.$i}[$j]",$j,ships2);
									# }
									# if($cargoofallships[$i] == 0){
										# $entrybox->destroy;
										# $cargoofallships[$i]+=$enteredvalue2;
										# $cargo_type_ofallships[$i] = "$b";		

										# $zy[$j]-=$enteredvalue2 * 5;
										# my $sum=$enteredvalue1 * 5;
										# #$canvas1->itemconfigure($welcome, -text =>"bought $enteredvalue1 small_red_potion \nfor $sum !");

										# $ingots=int($zy[$j]/10000);
										# $coins=$zy[$j]-$ingots*10000;

										# $fleet2->itemconfigure($cargoz[$i],-text=>"$cargoofallships[$i] $cargo_type_ofallships[$i]");
										# $canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
										# $canvasleft->itemconfigure($coins_num,-text=>"$coins");

										# (@cargo0[0],@cargo1[0],@cargo2[0],@cargo3[0],@cargo4[0],@cargo5[0],@cargo6[0],@cargo7[0],@cargo8[0],@cargo9[0]) = @cargoofallships ;
										# (@cargo0[1],@cargo1[1],@cargo2[1],@cargo3[1],@cargo4[1],@cargo5[1],@cargo6[1],@cargo7[1],@cargo8[1],@cargo9[1]) = @cargo_type_ofallships;	
										# $cargo0add=@cargo0[0]."<".@cargo0[1];$cargo1add=@cargo1[0]."<".@cargo1[1];$cargo2add=@cargo2[0]."<".@cargo2[1];$cargo3add=@cargo3[0]."<".@cargo3[1];$cargo4add=@cargo4[0]."<".@cargo4[1];$cargo5add=@cargo5[0]."<".@cargo5[1];$cargo6add=@cargo6[0]."<".@cargo6[1];$cargo7add=@cargo7[0]."<".@cargo7[1];$cargo8add=@cargo8[0]."<".@cargo8[1];$cargo9add=@cargo9[0]."<".@cargo9[1];
										# $VARcargo0[$j]=$cargo0add;$VARcargo1[$j]=$cargo1add;$VARcargo2[$j]=$cargo2add;$VARcargo3[$j]=$cargo3add;$VARcargo4[$j]=$cargo4add;$VARcargo5[$j]=$cargo5add;$VARcargo6[$j]=$cargo6add;$VARcargo7[$j]=$cargo7add;$VARcargo8[$j]=$cargo8add;$VARcargo9[$j]=$cargo9add;

										# UP_small_someone_from(VARzeny,$zy[$j],$j,primary1);
										# UP_small_someone_from(VARcargo.$i,"${VARcargo.$i}[$j]",$j,ships2);
									# }	
								});
							});	
						}
					  
						#################### sell ################
						sub smallredpotion2london3{ 
							###### make background #######	
							$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
							my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
							$fleet2->createImage( 172,177, -image => $p4c); 

							###### display text #######	
							$load = $fleet2->createText( 150,20+1*15, -text =>"Sell",-font =>"Times 12 bold");
							$fleet2->bind($load,"<Motion>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"grey20");});
							$fleet2->bind($load,"<Leave>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"black");});
							$fleet2->bind($load,"<Button-1>", sub {$fleet2->destroy;smallredpotion2london2();});

							$fleet2->createText( 150+50,20+1*15, -text =>"Cargo",-font =>"Times 12 bold");

							for($i=0;$i<10;$i++){
							$fleet2->createText( 150,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
							}

							###### prepare data #######	
							@cargo0=split(/</,$VARcargo0[$j]);@cargo1=split(/</,$VARcargo1[$j]);@cargo2=split(/</,$VARcargo2[$j]);@cargo3=split(/</,$VARcargo3[$j]);@cargo4=split(/</,$VARcargo4[$j]);@cargo5=split(/</,$VARcargo5[$j]);@cargo6=split(/</,$VARcargo6[$j]);@cargo7=split(/</,$VARcargo7[$j]);@cargo8=split(/</,$VARcargo8[$j]);@cargo9=split(/</,$VARcargo9[$j]);
							@cargoofallships = (@cargo0[0],@cargo1[0],@cargo2[0],@cargo3[0],@cargo4[0],@cargo5[0],@cargo6[0],@cargo7[0],@cargo8[0],@cargo9[0]);
							@cargo_type_ofallships = (@cargo0[1],@cargo1[1],@cargo2[1],@cargo3[1],@cargo4[1],@cargo5[1],@cargo6[1],@cargo7[1],@cargo8[1],@cargo9[1]);
							@cargoz = ($cargo_text0,$cargo_text1,$cargo_text2,$cargo_text3,$cargo_text4,$cargo_text5,$cargo_text6,$cargo_text7,$cargo_text8,$cargo_text9);
							
							###### make and bind 10 items #######
							foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   #for($i=0;$i<10;$i++)
								if($cargoofallships[$i] == 0){
									$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"none",-font =>"Times 12 bold");
								}
								else{
									$cargoz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$cargoofallships[$i] $cargo_type_ofallships[$i]",-font =>"Times 12 bold");
								}
								$fleet2->bind($cargoz[$i],"<Motion>", sub {$fleet2->itemconfigure($cargoz[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
								$fleet2->bind($cargoz[$i],"<Leave>", sub {$fleet2->itemconfigure($cargoz[$i], -font =>"Times 12 bold ",-fill=>"black");});
								$fleet2->bind($cargoz[$i],"<Button-1>", sub{					
									$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
									$entrybox->focus;
									$entrybox->bind('<Return>', sub{ 
										######## command_get() ##############
											#####  send sell_trade_goods, ship_num, number_entered, cargo_type   ########
											my $received_jason = command_get('sell_trade_goods:'.$i.':'.$enteredvalue2.':'.$cargo_type_ofallships[$i]);
										
											#####  get remaining_gold_coins and cargo_left   ########
											my $json = JSON->new->allow_nonref;
											my $array_ref_zy_and_cargo_num = $json->decode( $received_jason );
											
											my $zy = ${ $array_ref_zy_and_cargo_num }[0];
											my $cargo_num = ${ $array_ref_zy_and_cargo_num }[1];

										########### change display ####################
										if( $cargo_num > 0 ){ 
											##### remove entrybox ######
											$entrybox->destroy;
									
											##### change gold ######
											$zy[$j] = $zy;
											
											$ingots=int($zy[$j]/10000);
											$coins=$zy[$j]-$ingots*10000;

											$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
											$canvasleft->itemconfigure($coins_num,-text=>"$coins");
											
											##### change cargo_left ######
											$fleet2->itemconfigure($cargoz[$i],-text=>"$cargo_num $cargo_type_ofallships[$i]");
										}
										elsif( $cargo_num == 0 ){        	        	      	        		    
											##### remove entrybox ######
											$entrybox->destroy;
									
											##### change gold ######
											$zy[$j] = $zy;
											
											$ingots=int($zy[$j]/10000);
											$coins=$zy[$j]-$ingots*10000;

											$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
											$canvasleft->itemconfigure($coins_num,-text=>"$coins");
											
											##### change cargo_left ######
											$fleet2->itemconfigure($cargoz[$i],-text=>"none");											
										}
										else {
											##### remove entrybox ######
											$entrybox->destroy;
										
										}
									});									
								});	
							}  
						}	
				###############################################################				
					}); 
				}				
			}
				
			################ #sell ##################
			$sell=$canvas2->createText( 58,30+20, -text  => 'Sell',-font =>"Times 12 bold");
			$canvas2->bind($sell,"<Button-1>",  sub{
				$mw->bind("<Escape>", sub {
					$fleet2->destroy; 
					$mw->bind("<Escape>", \&exit_building);	
				});	
					
				@d = ();
				foreach my $i ((0..9)){         
					@{VARcargo.$i} = DOWN_small_pipe(VARcargo.$i,ships2); 
				}

				$redis->wait_all_responses;

				foreach my $i ((0..9)){         
					pipe_get(VARcargo.$i,$i);
				}

				smallredpotion2london3();  #####sell	
			});
			
			$canvas2->bind($sell,"<Motion>",  \&sell);
			$canvas2->bind($sell,"<Leave>",  \&sell1);
			sub sell{ $canvas2->itemconfigure($sell, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub sell1{ $canvas2->itemconfigure($sell, -font =>"Times 12 bold",-fill=>"black");}

			################ #market rate ##################
			$market_rate=$canvas2->createText( 58,30+40, -text  => 'Market Rate',-font =>"Times 12 bold");
			$canvas2->bind($market_rate,"<Button-1>",  \&market_rate2);$canvas2->bind($market_rate,"<Motion>",  \&market_rate);$canvas2->bind($market_rate,"<Leave>",  \&market_rate1);
			sub market_rate{ $canvas2->itemconfigure($market_rate, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub market_rate1{ $canvas2->itemconfigure($market_rate, -font =>"Times 12 bold",-fill=>"black");}

			################ #invest ##################
			$invest=$canvas2->createText( 58,30+60, -text  => 'Invest',-font =>"Times 12 bold");
			$canvas2->bind($invest,"<Button-1>",  \&invest2);$canvas2->bind($invest,"<Motion>",  \&invest);$canvas2->bind($invest,"<Leave>",  \&invest1);
			sub invest{ $canvas2->itemconfigure($invest, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub invest1{ $canvas2->itemconfigure($invest, -font =>"Times 12 bold",-fill=>"black");}

			################ #escape  ##################	
			$mw->bind("<Escape>", \&exit_building);
			#$mw->bind("<Key-o>", sub {$fleet2->destroy; });	
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
				$canvasleft->destroy;
				
				bg_left;			  
			}                     			
		} 
	#################################### @london_bar ##########################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{2}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{2}}{y}){
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."bar_fore.png", -format => 'png',-width => 138,-height => 115 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to the bar!\nWhat can I do for you?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			#$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $market_options_gif); 

			############### #recruit #################
			$recruit=$canvas2->createText( 58,30, -text  => 'Recruit',-font =>"Times 12 bold");
			$canvas2->bind($recruit,"<Button-1>",  \&recruit2);$canvas2->bind($recruit,"<Motion>",  \&recruit);$canvas2->bind($recruit,"<Leave>",  \&recruit1);
			sub recruit{ $canvas2->itemconfigure($recruit, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub recruit1{ $canvas2->itemconfigure($recruit, -font =>"Times 12 bold",-fill=>"black");}
			sub recruit2{ 
				############### get data #################
				@d = ();
				foreach my $i ((0..9)){         
					@{VARcrew.$i} = DOWN_small_pipe(VARcrew.$i,ships2); 
				}

				$redis->wait_all_responses;

				foreach my $i ((0..9)){         
					pipe_get(VARcrew.$i,$i);
				}

				############### make canvas #################
				$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 
				
				$mw->bind("<Escape>", sub {
					$fleet2->destroy; 
					$mw->bind("<Escape>", sub {
						$canvas1->destroy;   
						$canvas2->destroy; 
					});
				});

				############### make text #################
				$load = $fleet2->createText( 150,20+1*15, -text =>"Load",-font =>"Times 12 bold");
				$fleet2->bind($load,"<Motion>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"grey20");});
				$fleet2->bind($load,"<Leave>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"black");});
				$fleet2->bind($load,"<Button-1>", sub {$fleet2->destroy;recruit3();});

				$fleet2->createText( 150+50,20+1*15, -text =>"Crew",-font =>"Times 12 bold");
				
				for($i=0;$i<10;$i++){
					$fleet2->createText( 150,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
				}
				
				@crew0=split(/</,$VARcrew0[$j]);@crew1=split(/</,$VARcrew1[$j]);@crew2=split(/</,$VARcrew2[$j]);@crew3=split(/</,$VARcrew3[$j]);@crew4=split(/</,$VARcrew4[$j]);@crew5=split(/</,$VARcrew5[$j]);@crew6=split(/</,$VARcrew6[$j]);@crew7=split(/</,$VARcrew7[$j]);@crew8=split(/</,$VARcrew8[$j]);@crew9=split(/</,$VARcrew9[$j]);
				@crewofallships = (@crew0[0],@crew1[0],@crew2[0],@crew3[0],@crew4[0],@crew5[0],@crew6[0],@crew7[0],@crew8[0],@crew9[0]);
				@crewz = ($crew_text0,$crew_text1,$crew_text2,$crew_text3,$crew_text4,$crew_text5,$crew_text6,$crew_text7,$crew_text8,$crew_text9);

				############### bind text #################
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   #for($i=0;$i<10;$i++)
					$crewz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$crewofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($crewz[$i],"<Motion>", sub {$fleet2->itemconfigure($crewz[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($crewz[$i],"<Leave>", sub {$fleet2->itemconfigure($crewz[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($crewz[$i],"<Button-1>", sub {					
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub {										 
							$entrybox->destroy;
							
							############## command_get() ##############
								#############  send buy_crew, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('buy_crew:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my %current_crew_money = json_decode($received_jason);
								
								############# change display ##############
									############# money ##############
									$zy[$j] = $current_crew_money{money};
									$ingots=int($zy[$j]/10000);
									$coins=$zy[$j]-$ingots*10000;
									
									$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
									$canvasleft->itemconfigure($coins_num,-text=>"$coins");
									
									############# crew ##############
									$crewofallships[$i] = $current_crew_money{current_crew};	
						
									$fleet2->itemconfigure($crewz[$i],-text=>$crewofallships[$i]);	
						});						
					});	
				}
			} 

			sub recruit3{ 			
				$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 
				
				$discard = $fleet2->createText( 150,20+1*15, -text =>"Discard",-font =>"Times 12 bold");
				$fleet2->bind($discard,"<Motion>", sub {$fleet2->itemconfigure($discard, -font =>"Times 12 bold ",-fill=>"grey20");});
				$fleet2->bind($discard,"<Leave>", sub {$fleet2->itemconfigure($discard, -font =>"Times 12 bold ",-fill=>"black");});
				$fleet2->bind($discard,"<Button-1>", sub {$fleet2->destroy;recruit2();});

				$fleet2->createText( 150+50,20+1*15, -text =>"Crew",-font =>"Times 12 bold");
				
				for($i=0;$i<10;$i++){
					$fleet2->createText( 150,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
				}
				
				@crew0=split(/</,$VARcrew0[$j]);@crew1=split(/</,$VARcrew1[$j]);@crew2=split(/</,$VARcrew2[$j]);@crew3=split(/</,$VARcrew3[$j]);@crew4=split(/</,$VARcrew4[$j]);@crew5=split(/</,$VARcrew5[$j]);@crew6=split(/</,$VARcrew6[$j]);@crew7=split(/</,$VARcrew7[$j]);@crew8=split(/</,$VARcrew8[$j]);@crew9=split(/</,$VARcrew9[$j]);
				@crewofallships = (@crew0[0],@crew1[0],@crew2[0],@crew3[0],@crew4[0],@crew5[0],@crew6[0],@crew7[0],@crew8[0],@crew9[0]);
				@crewz = ($crew_text0,$crew_text1,$crew_text2,$crew_text3,$crew_text4,$crew_text5,$crew_text6,$crew_text7,$crew_text8,$crew_text9);
				
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   #for($i=0;$i<10;$i++)
					$crewz[$i] = $fleet2->createText( 150+50,20+(2+$i)*25, -text =>"$crewofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($crewz[$i],"<Motion>", sub {$fleet2->itemconfigure($crewz[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($crewz[$i],"<Leave>", sub {$fleet2->itemconfigure($crewz[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($crewz[$i],"<Button-1>", sub {			
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub { 											 
							$entrybox->destroy;
							############## command_get() ##############
								#############  send discard_crew, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('discard_crew:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my $json = JSON->new->allow_nonref;
								my $food_money_hash_ref = $json->decode( $received_jason );
								my %current_crew_money = %{$food_money_hash_ref};
								
								print %current_crew_money, "\n";
								
								############# change display ##############
									############# money ##############
									$zy[$j] = $current_crew_money{money};
									$ingots=int($zy[$j]/10000);
									$coins=$zy[$j]-$ingots*10000;
									
									$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
									$canvasleft->itemconfigure($coins_num,-text=>"$coins");
									
									############# crew ##############
									$crewofallships[$i] = $current_crew_money{current_crew};	
						
									$fleet2->itemconfigure($crewz[$i],-text=>$crewofallships[$i]);
						});							
					});
				}   
			}	
			
			############### #bar girl #################
			$bar_girl=$canvas2->createText( 58,30+20, -text  => 'Bar girl',-font =>"Times 12 bold");
			$canvas2->bind($bar_girl,"<Motion>",  \&bar_girl);
			$canvas2->bind($bar_girl,"<Leave>",  \&bar_girl1);
			sub bar_girl{ $canvas2->itemconfigure($bar_girl, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub bar_girl1{ $canvas2->itemconfigure($bar_girl, -font =>"Times 12 bold",-fill=>"black");}
			$canvas2->bind($bar_girl,"<Button-1>",  sub{
				########## left girl chat box ########
				my $canvas_girl=$mw->Canvas(-background => "red",-width => 312,-height => 146,-highlightthickness => 0)->place(-x => 430-308, -y => 350-180);
				my $p6=$canvas_girl->createImage( 156,73, -image => $bar_girl_png); 

				########## right menu #######
				$canvas_tell_give=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
				my $p6=$canvas_tell_give->createImage( 58,97, -image => $market_options_gif); 			
				
				my $tell_stories = $canvas_tell_give->createText( 58,30+0, -text  => 'Tell Stories',-font =>"Times 12 bold");
				my $give_gift = $canvas_tell_give->createText( 58,30+20, -text  => 'Give Gift',-font =>"Times 12 bold");
				my $investigate = $canvas_tell_give->createText( 58,30+40, -text  => 'Investigate',-font =>"Times 12 bold");
				my $ask_info = $canvas_tell_give->createText( 58,30+60, -text  => 'Ask Info',-font =>"Times 12 bold");

				bind_motion_leave_canvas($tell_stories, $canvas_tell_give);
				bind_motion_leave_canvas($give_gift, $canvas_tell_give);
				bind_motion_leave_canvas($investigate, $canvas_tell_give);
				bind_motion_leave_canvas($ask_info, $canvas_tell_give);

				$canvas_tell_give->bind($investigate,"<Button-1>",  sub{
					my $canvas_nations=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
					my $p6=$canvas_nations->createImage( 58,97, -image => $market_options_gif); 

					####### escape #######	 
					$mw->bind("<Escape>", sub{   
						$canvas_nations->destroy;
						$mw->bind("<Escape>", sub {
							$canvas_tell_give->destroy;
							$canvas_girl->destroy;
							$mw->bind("<Escape>", \&exit_building);	
						});
					});

					####### create text items #######	
					my @nations = ();   
					my @nation_names = (Portugal, Spain, Turkey, England, Italy, Holland, Piracy);
					for($i=0;$i<7;$i++){
						$nations[$i] = $canvas_nations->createText( 58,30+$i*20, -text  => "$nation_names[$i]",-font =>"Times 12 bold");
					}

					####### bind motion leave #######	
					for($i=0;$i<7;$i++){   
						bind_motion_leave_canvas($nations[$i], $canvas_nations);
					}

					######## bind_button_1_canvas($fish,$canvas2_1); ##############
					my sub bind_button_1_canvas{    	
						my $a = shift;
						my $b = shift;
						my $i = shift;
						$b->bind($a,"<Button-1>",  sub{
							############ right menu canvas ############
							my $canvas2_1_1=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
							my $p6=$canvas2_1_1->createImage( 58,97, -image => $market_options_gif); 

							$mw->bind("<Escape>", sub {
								$canvas2_1_1->destroy;	
								$mw->bind("<Escape>", sub {
									$canvas_nations->destroy;
									$mw->bind("<Escape>", sub {
										$canvas_tell_give->destroy;
										$canvas_girl->destroy;
										$mw->bind("<Escape>", \&exit_building);	
									});
								});
							});


							####### create text items #######
							my @fleet_types = ();   
							my @fleet_type_names = ("Merchant Fleet", "Convoy Fleet", "Voyaging Fleet");
							for($i=0;$i<3;$i++){
								$fleet_types[$i] = $canvas2_1_1->createText( 58,30+$i*20, -text  => "$fleet_type_names[$i]",-font =>"Times 12 bold");
							}

							####### bind motion leave #######		
							for($i=0;$i<3;$i++){   
								bind_motion_leave_canvas($fleet_types[$i], $canvas2_1_1);
							}
						});
					}
					
					####### bind button 1 #######		
					for($i=0;$i<7;$i++){   
						bind_button_1_canvas($nations[$i], $canvas_nations, $i);
					}						
				});

				$canvas_tell_give->bind($ask_info,"<Button-1>",  sub{
					my $canvas_ask_info=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
					my $p6=$canvas_ask_info->createImage( 58,97, -image => $market_options_gif); 
					
					####### escape #######	
					$mw->bind("<Escape>", sub{   
						$canvas_ask_info->destroy;
						$mw->bind("<Escape>", sub {
							$canvas_tell_give->destroy;
							$canvas_girl->destroy;
							$mw->bind("<Escape>", \&exit_building);	
						});
					});

					####### create text items #######
					my @info = ();   
					my @info_names = (Job, Port);
					for($i=0;$i<2;$i++){
						$info[$i] = $canvas_ask_info->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
					}

					####### bind motion leave #######	
					for($i=0;$i<2;$i++){   
						bind_motion_leave_canvas($info[$i], $canvas_ask_info);
					}			
				});

				#################### Escape key ####################
				$mw->bind("<Escape>", sub {
					$canvas_tell_give->destroy;
					$canvas_girl->destroy;
					$mw->bind("<Escape>", \&exit_building);	
				});
			});

			############### #other captains #################
				############### make text #################
				$other_captains=$canvas2->createText( 58,30+40, -text  => 'Other Captains',-font =>"Times 12 bold");
				$canvas2->bind($other_captains,"<Motion>",  \&other_captains);
				$canvas2->bind($other_captains,"<Leave>",  \&other_captains1);
				sub other_captains{ $canvas2->itemconfigure($other_captains, -font =>"Times 12 bold ",-fill=>"grey20");}
				sub other_captains1{ $canvas2->itemconfigure($other_captains, -font =>"Times 12 bold",-fill=>"black");}
			
				############### bind text #################
				$canvas2->bind($other_captains,"<Button-1>",  sub{	
					############### make canvas #################	
					$canvas2_1=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);		     	
					my $p6=$canvas2_1->createImage( 58,97, -image => $market_options_gif); 			
					
					$mw->bind("<Escape>", sub {
						$canvas2_1->destroy;
						$mw->bind("<Escape>", \&exit_building);	
					});
					
					############### get @mate_names_10to15 #################
					my @mate_names = $redis->hmget("$j:mates0to9", VARmatename1, VARmatename2, VARmatename3, VARmatename4, VARmatename5, VARmatename6, VARmatename7, VARmatename8, VARmatename9); 
					unshift(@mate_names, 0);
					my @mate_names_10to15 = $redis->hmget("$j:mates10to15", VARmatename10, VARmatename11, VARmatename12, VARmatename13, VARmatename14, VARmatename15); 
					push(@mate_names, @mate_names_10to15);

					########### display data ###########
					my @caps = ();		
					for($i=1;$i<15;$i++){
						if($mate_names[$i] ne "NA"){
							$caps[$i] = $canvas2_1->createText( 58,14+($i-1)*12, -text  => "$mate_names[$i]",-font =>"Times 12 bold");
						}		
					}
					my $next = $canvas2_1->createText( 58,14+(15-1)*12, -text  => "Next",-font =>"Times 12 bold");
				
					######### bind_motion_leave ############	
					sub bind_motion_leave_canvas{    	
						my $a = shift;
						my $b = shift;
						$b->bind($a,"<Motion>",  sub{
							$b->itemconfigure($a, -font =>"Times 12 bold ",-fill=>"grey20");
						});
						$b->bind($a,"<Leave>",  sub {
							$b->itemconfigure($a, -font =>"Times 12 bold",-fill=>"black");
						});
					}
					
					for($i=1;$i<15;$i++){
						bind_motion_leave_canvas($caps[$i], $canvas2_1);
					}
					
					bind_motion_leave_canvas($next, $canvas2_1);

					########### bind all captains #############	
					my sub bind_button_1_canvas{    	
						my $a = shift;
						my $b = shift;
						my $i = shift;
						$b->bind($a,"<Button-1>",  sub{
							############ right menu canvas ############
							my $canvas2_1_1=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
							my $p6=$canvas2_1_1->createImage( 58,97, -image => $market_options_gif); 
							
							############left captain canvas ############
							my $canvas2_1_2=$mw->Canvas(-background => "red",-width => 313,-height => 143,-highlightthickness => 0)->place(-x => 430-308, -y => 350-180);
							my $p6=$canvas2_1_2->createImage( 156,71, -image => $bar_meet_png); 
				
							$mw->bind("<Escape>", sub {
								$canvas2_1_1->destroy;
								$canvas2_1_2->destroy; 	
								$mw->bind("<Escape>", sub {
									$canvas2_1->destroy;
									$mw->bind("<Escape>", \&exit_building);
								});	
							});
							
							my $treat = $canvas2_1_1->createText( 58,30, -text  => 'Treat',-font =>"Times 12 bold");
							my $gossip = $canvas2_1_1->createText( 58,30+20, -text  => 'Gossip',-font =>"Times 12 bold");
							my $hire = $canvas2_1_1->createText( 58,30+40, -text  => 'Hire',-font =>"Times 12 bold");
							my $fire = $canvas2_1_1->createText( 58,30+60, -text  => 'Fire',-font =>"Times 12 bold");	

							bind_motion_leave_canvas($treat, $canvas2_1_1);
							bind_motion_leave_canvas($gossip, $canvas2_1_1);
							bind_motion_leave_canvas($hire, $canvas2_1_1);
							bind_motion_leave_canvas($fire, $canvas2_1_1);

							############# bind_button_1_canvas($fish,$canvas2_1); #################	
							my sub bind_button_1_canvas{    	
								my $a = shift;
								my $b = shift;
								$b->bind($a,"<Button-1>",  sub{
									if($i<10){
										# $redis->hset("$j:mates0to9", VARmatename.$i, 0); 
										$redis->hmset("$j:mates0to9", 	
																VARmatename.$i, 0, 
																VARnation.$i, 0,  
																VARage.$i, 0,  
																VARseamanship.$i, 0, 
										); 		
									}
									if($i>=10){
										# $redis->hset("$j:mates10to15", VARmatename.$i, 0); 
										$redis->hmset("$j:mates0to9", 	
																VARmatename.$i, 0, 
																VARnation.$i, 0,  
																VARage.$i, 0,  
																VARseamanship.$i, 0, 
										); 		
									}
									$mate_names[$i] = 0;
									
									$canvas2_1->delete($caps[$i]);	
									$canvas2_1_1->destroy;
									$canvas2_1_2->destroy; 	

									$mw->bind("<Escape>", sub {
										$canvas2_1->destroy;
										$mw->bind("<Escape>", \&exit_building);
									});															
								});
							}
							bind_button_1_canvas($fire,$canvas2_1_1); 
						});	
					}
					
					for($i=1;$i<15;$i++){
						bind_button_1_canvas($caps[$i], $canvas2_1, $i);
					}
					
					############# bind next #################
					$canvas2_1->bind($next,"<Button-1>",  sub{
						############# make canvas #################
						my $canvas2_2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
						my $p6=$canvas2_2->createImage( 58,97, -image => $market_options_gif); 	
						
						$mw->bind("<Escape>", sub {
							$canvas2_2->destroy;
							$mw->bind("<Escape>", sub{
								$canvas2_1->destroy;
								$mw->bind("<Escape>", \&exit_building);
							});	    
						});		

						############# hirable captain #################
						my $cap1 = $canvas2_2->createText( 58,30, -text  => 'Gus Johnson',-font =>"Times 12 bold");
						bind_motion_leave_canvas($cap1, $canvas2_2);
						$canvas2_2->bind($cap1,"<Button-1>",  sub{
							############ right menu canvas ############
							my $canvas2_1_1=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
							my $p6=$canvas2_1_1->createImage( 58,97, -image => $market_options_gif); 
							
							############ left captain canvas ############
							my $canvas2_1_2=$mw->Canvas(-background => "red",-width => 313,-height => 143,-highlightthickness => 0)->place(-x => 430-308, -y => 350-180);
							my $p6=$canvas2_1_2->createImage( 156,71, -image => $bar_meet_png); 
				
							$mw->bind("<Escape>", sub {
								$canvas2_1_1->destroy;
								$canvas2_1_2->destroy; 	
								$mw->bind("<Escape>", sub {
									$canvas2_2->destroy;
									$mw->bind("<Escape>", sub{
										$canvas2_1->destroy;
										$mw->bind("<Escape>", \&exit_building);
									});			
								});	
							});
							
							############ make texts ############
							my $treat = $canvas2_1_1->createText( 58,30, -text  => 'Treat',-font =>"Times 12 bold");
							my $gossip = $canvas2_1_1->createText( 58,30+20, -text  => 'Gossip',-font =>"Times 12 bold");
							my $hire = $canvas2_1_1->createText( 58,30+40, -text  => 'Hire',-font =>"Times 12 bold");

							bind_motion_leave_canvas($treat, $canvas2_1_1);
							bind_motion_leave_canvas($gossip, $canvas2_1_1);
							bind_motion_leave_canvas($hire, $canvas2_1_1);

							############ bind texts ############
							$canvas2_1_1->bind($hire,"<Button-1>",  sub{
								for($i=1;$i<15;$i++){
									#&& not('Gus Johnson' ~~ @mate_names)
									if( $mate_names[$i] eq '0' ){
										$mate_names[$i] = 'Gus Johnson'.$i;
										if($i<10){
											# $redis->hset("$j:mates0to9", VARmatename.$i, "Gus Johnson"); 										
											$redis->hmset("$j:mates0to9", 	
																VARmatename.$i, $mate_names[$i], 
																VARnation.$i, 'England',  
																VARage.$i, '22',  
																VARseamanship.$i, '70', 
											); 
											
										}
										if($i>=10){
											# $redis->hset("$j:mates10to15", VARmatename.$i, "Gus Johnson"); 
											$redis->hmset("$j:mates0to9", 	
																VARmatename.$i, $mate_names[$i], 
																VARnation.$i, 'England',  
																VARage.$i, '22',  
																VARseamanship.$i, '70', 
											); 
										}								

										$canvas2_1_1->destroy;
										$canvas2_1_2->destroy; 
										$canvas2_2->destroy; 
			
										$caps[$i] = $canvas2_1->createText( 58,14+($i-1)*12, -text  => "$mate_names[$i]",-font =>"Times 12 bold");
										bind_motion_leave_canvas($caps[$i], $canvas2_1);
										bind_button_1_canvas($caps[$i], $canvas2_1, $i);	

										$mw->bind("<Escape>", sub {
											$canvas2_1->destroy;
											$mw->bind("<Escape>", \&exit_building);
										});
										
										last;	
									}
								}
							});
						});
					});
				});
	 
			############### #treat ###############
			$treat=$canvas2->createText( 58,30+60, -text  => 'Treat',-font =>"Times 12 bold");
			$canvas2->bind($treat,"<Button-1>",  \&treat2);$canvas2->bind($treat,"<Motion>",  \&treat);$canvas2->bind($treat,"<Leave>",  \&treat1);
			sub treat{ $canvas2->itemconfigure($treat, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub treat1{ $canvas2->itemconfigure($treat, -font =>"Times 12 bold",-fill=>"black");}

			############### #escape ###############	
			$mw->bind("<Escape>", \&exit_building);  
			$mw->bind("<Key-o>", sub {$fleet2->destroy; });
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}     
		}
	################################# @london_port ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{4}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{4}}{y}){	#  #$port_index+1
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."port_fore.png", -format => 'png',-width => 138,-height => 116 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to the port!\nReady to go?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 

			############ #sail ##############
			$sail=$canvas2->createText( 58,30, -text  => 'Sail',-font =>"Times 12 bold");
			$canvas2->bind($sail,"<Button-1>",  \&sail2london);$canvas2->bind($sail,"<Motion>",  \&sail);$canvas2->bind($sail,"<Leave>",  \&sail1);
			sub sail{ $canvas2->itemconfigure($sail, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub sail1{ $canvas2->itemconfigure($sail, -font =>"Times 12 bold",-fill=>"black");}
			sub sail2london{
				my $response = command_get(sailFromPort); 
				
				if($response eq "0\n"){
				}   
				else{
					##############  decode response to get speed   ##############
					my %speed = json_decode($response);
					my $speed_average = $speed{speed};
					
					$move_interval = int( 4000/$speed_average );
					
					print "$move_interval \n";
					
					############ change data ##################
					$mp[$j] = sea;
					$cx[$j] = 16*${$ports{$port_index+1}}{x};
					$cy[$j] = 16*${$ports{$port_index+1}}{y};
				
					############ change pic ##################
						############ mid_map and player ##################
						$canvas->itemconfigure($pship,-image => $p2_up); 
						$canvas->itemconfigure($pi,-image => $sea_gif); 
						$canvas->coords($pi, 200, 195); 

						############ left_canvas ##################
						$canvasleft->itemconfigure( $left_image, -image => $sea_left_gif ); 
							
							############ ingots and coins ##################
							$canvasleft->coords($ingots_num, 2000, 2000);
							$canvasleft->coords($coins_num, 2000, 2000);
		
							############ 4 supplies ##################
							$canvasleft->coords($water_all, 65  , 270);
							$canvasleft->coords($food_all, 65  , 270+35);
							$canvasleft->coords($lumber_all, 65  , 270+35*2);
							$canvasleft->coords($shot_all, 65  , 270+35*3); 

						############ right_canvas ##################
						$canvasright->itemconfigure( $right_image, -image => $pright_sea);  
						$canvasright->coords($ocean_day_box, 75, 250);
						$speed_average_box = $canvasright->createText( 75,217, -text => $speed_average, -font =>"Times 12 bold");
						
						
							############ delete texts ##################
							$canvasright->delete($right_canvas_city_text, $right_canvas_region_text, $right_canvas_economy_text, $right_canvas_industry_text, $right_canvas_price_text);
					
					############ destroy canvas ##################
					$canvas2->destroy;
					$canvas1->destroy;
					
					########### hide npc_animation  ###############
					$canvas->coords($npc_by_marcket_animation, 2000, 2000);
					$canvas->coords($npc_by_bar_animation, 2000, 2000);
					$canvas->coords($npc_by_inn_animation, 2000, 2000);
					
					$canvas->coords($npc_moving_1, 2000, 2000);
					$canvas->coords($npc_moving_2, 2000, 2000);
				}				     
			}
			  
			############ #supply ##############	
			$supply=$canvas2->createText( 58,30+20, -text  => 'Supply',-font =>"Times 12 bold");
			$canvas2->bind($supply,"<Button-1>",  \&supply2);$canvas2->bind($supply,"<Motion>",  \&supply);$canvas2->bind($supply,"<Leave>",  \&supply1);
			sub supply{ $canvas2->itemconfigure($supply, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub supply1{ $canvas2->itemconfigure($supply, -font =>"Times 12 bold",-fill=>"black");}
			
			############ sub supply2 ############## 
			sub supply2{ 
				############ bind escape ##############
				$mw->bind("<Escape>", sub {
					$fleet2->destroy; 
					$mw->bind("<Escape>", \&exit_building);	
				});				

				############ make canvas ##############
				$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 
					
				############ make load text and bind it ##############	
				$load = $fleet2->createText( 70,20+1*15, -text =>"Load",-font =>"Times 12 bold");
				$fleet2->bind($load,"<Motion>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"grey20");});
				$fleet2->bind($load,"<Leave>", sub {$fleet2->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"black");});
				$fleet2->bind($load,"<Button-1>", sub {$fleet2->destroy;supply3();});

				############ food water lumber shot text ##############
				$fleet2->createText( 70+50,20+1*15, -text =>"Food",-font =>"Times 12 bold");
				$fleet2->createText( 70+100,20+1*15, -text =>"Water",-font =>"Times 12 bold");
				$fleet2->createText( 70+150,20+1*15, -text =>"Lumber",-font =>"Times 12 bold");
				$fleet2->createText( 70+200,20+1*15, -text =>"Shot",-font =>"Times 12 bold");
					
				############ ships 0 to 9 ##############	
				for($i=0;$i<10;$i++){
					$fleet2->createText( 70,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
				}
			
				############ download supply info ##############
				sub read_for_supply_info{         #  read_for_supply_info;
					@d = ();
					foreach my $i ((0..9)){ 
						@{VARfood.$i} = DOWN_small_pipe(VARfood.$i,ships2); 
						@{VARwater.$i} = DOWN_small_pipe(VARwater.$i,ships2); 
						@{VARlumber.$i} = DOWN_small_pipe(VARlumber.$i,ships2);
						@{VARshot.$i} = DOWN_small_pipe(VARshot.$i,ships2);
					}

					$redis->wait_all_responses;
					
					foreach my $i ((0..9)){  
						pipe_get(VARfood.$i,$i+3*$i);
						pipe_get(VARwater.$i,$i+1+3*$i);
						pipe_get(VARlumber.$i,$i+2+3*$i);
						pipe_get(VARshot.$i,$i+3+3*$i);	
					}
				}
				read_for_supply_info();

				@foodofallships = ($VARfood0[$j],$VARfood1[$j],$VARfood2[$j],$VARfood3[$j],$VARfood4[$j],$VARfood5[$j],$VARfood6[$j],$VARfood7[$j],$VARfood8[$j],$VARfood9[$j]);
				@waterofallships = ($VARwater0[$j],$VARwater1[$j],$VARwater2[$j],$VARwater3[$j],$VARwater4[$j],$VARwater5[$j],$VARwater6[$j],$VARwater7[$j],$VARwater8[$j],$VARwater9[$j]);
				@lumberofallships = ($VARlumber0[$j],$VARlumber1[$j],$VARlumber2[$j],$VARlumber3[$j],$VARlumber4[$j],$VARlumber5[$j],$VARlumber6[$j],$VARlumber7[$j],$VARlumber8[$j],$VARlumber9[$j]);
				@shotofallships = ($VARshot0[$j],$VARshot1[$j],$VARshot2[$j],$VARshot3[$j],$VARshot4[$j],$VARshot5[$j],$VARshot6[$j],$VARshot7[$j],$VARshot8[$j],$VARshot9[$j]);
				@food = ($food0,$food1,$food2,$food3,$food4,$food5,$food6,$food7,$food8,$food9);
				@water = ($water0,$water1,$water2,$water3,$water4,$water5,$water6,$water7,$water8,$water9);
				@lumber = ($lumber0,$lumber1,$lumber2,$lumber3,$lumber4,$lumber5,$lumber6,$lumber7,$lumber8,$lumber9);
				@shot = ($shot0,$shot1,$shot2,$shot3,$shot4,$shot5,$shot6,$shot7,$shot8,$shot9);
				
				############ ships 0 to 9's food water lumber shot ##############
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   #for($i=0;$i<10;$i++)
					############ food ##############
					$food[$i] = $fleet2->createText( 70+50,20+(2+$i)*25, -text =>"$foodofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($food[$i],"<Motion>", sub {$fleet2->itemconfigure($food[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($food[$i],"<Leave>", sub {$fleet2->itemconfigure($food[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($food[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub { 
							$entrybox->destroy;
							
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('buy_food:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my $json = JSON->new->allow_nonref;
								my $food_money_hash_ref = $json->decode( $received_jason );
								my %food_money = %{$food_money_hash_ref};
								
								print %food_money, "\n";
								
								############# change display ##############
								$zy[$j] = $food_money{money};
								$foodofallships[$i] = $food_money{food};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($food[$i],-text=>"$foodofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});
					});
					
					############ water ##############	
					$water[$i] = $fleet2->createText( 70+100,20+(2+$i)*25, -text =>"$waterofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($water[$i],"<Motion>", sub {$fleet2->itemconfigure($water[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($water[$i],"<Leave>", sub {$fleet2->itemconfigure($water[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($water[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub {
							$entrybox->destroy;
							
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('buy_water:'.$i.':'.$enteredvalue2);
							
								##############  get water and money   ##############
								my $json = JSON->new->allow_nonref;
								my $water_money_hash_ref = $json->decode( $received_jason );
								my %water_money = %{$water_money_hash_ref};
								
								print %water_money, "\n";
								
								############# change display ##############
								$zy[$j] = $water_money{money};
								$waterofallships[$i] = $water_money{water};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($water[$i],-text=>"$waterofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});								
					});

					############ lumber ##############	
					$lumber[$i] = $fleet2->createText( 70+150,20+(2+$i)*25, -text =>"$lumberofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($lumber[$i],"<Motion>", sub {$fleet2->itemconfigure($lumber[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($lumber[$i],"<Leave>", sub {$fleet2->itemconfigure($lumber[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($lumber[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub { 												 
							$entrybox->destroy;
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('buy_lumber:'.$i.':'.$enteredvalue2);
							
								##############  get lumber and money   ##############
								my $json = JSON->new->allow_nonref;
								my $lumber_money_hash_ref = $json->decode( $received_jason );
								my %lumber_money = %{$lumber_money_hash_ref};
								
								print %lumber_money, "\n";
								
								############# change display ##############
								$zy[$j] = $lumber_money{money};
								$lumberofallships[$i] = $lumber_money{lumber};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($lumber[$i],-text=>"$lumberofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});								
					});

					############ shot ##############
					$shot[$i] = $fleet2->createText( 70+200,20+(2+$i)*25, -text =>"$shotofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($shot[$i],"<Motion>", sub {$fleet2->itemconfigure($shot[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($shot[$i],"<Leave>", sub {$fleet2->itemconfigure($shot[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($shot[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub {												 
							$entrybox->destroy;
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('buy_shot:'.$i.':'.$enteredvalue2);
							
								##############  get shot and money   ##############
								my $json = JSON->new->allow_nonref;
								my $shot_money_hash_ref = $json->decode( $received_jason );
								my %shot_money = %{$shot_money_hash_ref};
								
								print %shot_money, "\n";
								
								############# change display ##############
								$zy[$j] = $shot_money{money};
								$shotofallships[$i] = $shot_money{shot};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($shot[$i],-text=>"$shotofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins"); 
						});								
					});
				}
			}	
			 
			############ sub supply3 ############## 
			sub supply3{ 			
				$fleet2=$mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
				$fleet2->createImage( 172,177, -image => $p4c); 
				
				$discard = $fleet2->createText( 70,20+1*15, -text =>"Discard",-font =>"Times 12 bold");
				$fleet2->bind($discard,"<Motion>", sub {$fleet2->itemconfigure($discard, -font =>"Times 12 bold ",-fill=>"grey20");});
				$fleet2->bind($discard,"<Leave>", sub {$fleet2->itemconfigure($discard, -font =>"Times 12 bold ",-fill=>"black");});
				$fleet2->bind($discard,"<Button-1>", sub {$fleet2->destroy;supply2();});

				$fleet2->createText( 70+50,20+1*15, -text =>"Food",-font =>"Times 12 bold");
				$fleet2->createText( 70+100,20+1*15, -text =>"Water",-font =>"Times 12 bold");
				$fleet2->createText( 70+150,20+1*15, -text =>"Lumber",-font =>"Times 12 bold");
				$fleet2->createText( 70+200,20+1*15, -text =>"Shot",-font =>"Times 12 bold");
				
				for($i=0;$i<10;$i++){
					$fleet2->createText( 70,20+(2+$i)*25, -text =>"$i",-font =>"Times 12 bold");
				}
				
				@foodofallships = ($VARfood0[$j],$VARfood1[$j],$VARfood2[$j],$VARfood3[$j],$VARfood4[$j],$VARfood5[$j],$VARfood6[$j],$VARfood7[$j],$VARfood8[$j],$VARfood9[$j]);
				@waterofallships = ($VARwater0[$j],$VARwater1[$j],$VARwater2[$j],$VARwater3[$j],$VARwater4[$j],$VARwater5[$j],$VARwater6[$j],$VARwater7[$j],$VARwater8[$j],$VARwater9[$j]);
				@lumberofallships = ($VARlumber0[$j],$VARlumber1[$j],$VARlumber2[$j],$VARlumber3[$j],$VARlumber4[$j],$VARlumber5[$j],$VARlumber6[$j],$VARlumber7[$j],$VARlumber8[$j],$VARlumber9[$j]);
				@shotofallships = ($VARshot0[$j],$VARshot1[$j],$VARshot2[$j],$VARshot3[$j],$VARshot4[$j],$VARshot5[$j],$VARshot6[$j],$VARshot7[$j],$VARshot8[$j],$VARshot9[$j]);
				@food = ($food0,$food1,$food2,$food3,$food4,$food5,$food6,$food7,$food8,$food9);
				@water = ($water0,$water1,$water2,$water3,$water4,$water5,$water6,$water7,$water8,$water9);
				@lumber = ($lumber0,$lumber1,$lumber2,$lumber3,$lumber4,$lumber5,$lumber6,$lumber7,$lumber8,$lumber9);
				@shot = ($shot0,$shot1,$shot2,$shot3,$shot4,$shot5,$shot6,$shot7,$shot8,$shot9);
				
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){   #for($i=0;$i<10;$i++)
					############ food ##############
					$food[$i] = $fleet2->createText( 70+50,20+(2+$i)*25, -text =>"$foodofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($food[$i],"<Motion>", sub {$fleet2->itemconfigure($food[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($food[$i],"<Leave>", sub {$fleet2->itemconfigure($food[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($food[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub {												 
							$entrybox->destroy;
							
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('discard_food:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my $json = JSON->new->allow_nonref;
								my $food_money_hash_ref = $json->decode( $received_jason );
								my %food_money = %{$food_money_hash_ref};
								
								print %food_money, "\n";
								
								############# change display ##############
								$zy[$j] = $food_money{money};
								$foodofallships[$i] = $food_money{food};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($food[$i],-text=>"$foodofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});								
					});
					
					############ water ##############
					$water[$i] = $fleet2->createText( 70+100,20+(2+$i)*25, -text =>"$waterofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($water[$i],"<Motion>", sub {$fleet2->itemconfigure($water[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($water[$i],"<Leave>", sub {$fleet2->itemconfigure($water[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($water[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub {												 
							$entrybox->destroy;
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('discard_water:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my $json = JSON->new->allow_nonref;
								my $water_money_hash_ref = $json->decode( $received_jason );
								my %water_money = %{$water_money_hash_ref};
								
								print %water_money, "\n";
								
								############# change display ##############
								$zy[$j] = $water_money{money};
								$waterofallships[$i] = $water_money{water};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($water[$i],-text=>"$waterofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});								
					});


					############ lumber ##############
					$lumber[$i] = $fleet2->createText( 70+150,20+(2+$i)*25, -text =>"$lumberofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($lumber[$i],"<Motion>", sub {$fleet2->itemconfigure($lumber[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($lumber[$i],"<Leave>", sub {$fleet2->itemconfigure($lumber[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($lumber[$i],"<Button-1>", sub {				
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub { 												 
							$entrybox->destroy;
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('discard_lumber:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my $json = JSON->new->allow_nonref;
								my $lumber_money_hash_ref = $json->decode( $received_jason );
								my %lumber_money = %{$lumber_money_hash_ref};
								
								print %lumber_money, "\n";
								
								############# change display ##############
								$zy[$j] = $lumber_money{money};
								$lumberofallships[$i] = $lumber_money{lumber};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($lumber[$i],-text=>"$lumberofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});								
					});

					############ shot ##############	
					$shot[$i] = $fleet2->createText( 70+200,20+(2+$i)*25, -text =>"$shotofallships[$i]",-font =>"Times 12 bold");
					$fleet2->bind($shot[$i],"<Motion>", sub {$fleet2->itemconfigure($shot[$i], -font =>"Times 12 bold ",-fill=>"grey20");});
					$fleet2->bind($shot[$i],"<Leave>", sub {$fleet2->itemconfigure($shot[$i], -font =>"Times 12 bold ",-fill=>"black");});
					$fleet2->bind($shot[$i],"<Button-1>", sub {
					
						$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 530-308, -y => 520-180);
						$entrybox->focus;
						$entrybox->bind('<Return>', sub {												 
							$entrybox->destroy;
							############## command_get() ##############
								#############  send buy_trade_goods, ship_num, number_entered, cargo_type   ##############
								my $received_jason = command_get('discard_shot:'.$i.':'.$enteredvalue2);
							
								##############  get food and money   ##############
								my $json = JSON->new->allow_nonref;
								my $shot_money_hash_ref = $json->decode( $received_jason );
								my %shot_money = %{$shot_money_hash_ref};
								
								print %shot_money, "\n";
								
								############# change display ##############
								$zy[$j] = $shot_money{money};
								$shotofallships[$i] = $shot_money{shot};

								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$fleet2->itemconfigure($shot[$i],-text=>"$shotofallships[$i]");
								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");
						});							
					});
				}   
			}		

			############ #dock ##############	  
			$dock=$canvas2->createText( 58,30+40, -text  => 'Dock',-font =>"Times 12 bold");
			$canvas2->bind($dock,"<Button-1>",  \&dock2);$canvas2->bind($dock,"<Motion>",  \&dock);$canvas2->bind($dock,"<Leave>",  \&dock1);
			sub dock{ $canvas2->itemconfigure($dock, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub dock1{ $canvas2->itemconfigure($dock, -font =>"Times 12 bold",-fill=>"black");}

			############ #treat ##############	
			$treat=$canvas2->createText( 58,30+60, -text  => 'Treat',-font =>"Times 12 bold");
			$canvas2->bind($treat,"<Button-1>",  \&treat2);$canvas2->bind($treat,"<Motion>",  \&treat);$canvas2->bind($treat,"<Leave>",  \&treat1);
			sub treat{ $canvas2->itemconfigure($treat, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub treat1{ $canvas2->itemconfigure($treat, -font =>"Times 12 bold",-fill=>"black");}

			$mw->bind("<Escape>", \&exit_building);
			$mw->bind("<Key-o>", sub {$fleet2->destroy; });
		
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy; 	  
			}
		}
				
	################################# @london_bank ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{9}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{9}}{y}){
			################### bg ###################
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."bank_fore.png", -format => 'png',-width => 138,-height => 114 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			my $welcome = $canvas1->createText( 267,36, -text  => "Welcome to the bank!\nHow may I help you?",-font =>"Times 12 bold"); 
								
			################### right menu ###################
			my $canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			my $p6=$canvas2->createImage( 58,97, -image => $market_options_gif); 			
			
			$mw->bind("<Escape>", sub {
				$canvas1->destroy;   
				$canvas2->destroy; 
			});

			####### create text items #######
			my @info = ();   
			my @info_names = (Deposit, Withdraw, Borrow, Repay);
			for($i=0;$i<@info_names;$i++){
				$info[$i] = $canvas2->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
			}

			####### bind motion leave #######
			for($i=0;$i<@info_names;$i++){   
				bind_motion_leave_canvas($info[$i], $canvas2);
			}

			########  deposit ########	
			$canvas2->bind($info[0],"<Button-1>",  sub{ 
				my $amount = $redis->hget("$j:primary1", VARbankamount); 
				my $amount_zeny = $redis->hget("$j:primary1", VARzeny); 
				$canvas1->itemconfigure($welcome, -text  => "Your ballance is $amount.\nHow much would you like\n to deposit?");

				###### entry box ######
				my $enteredvalue1;   
				my $entrybox1 = $canvas1->Entry(-textvariable => \$enteredvalue1, -width => 16)->place(-x => 200, -y => 22*(2+1));
				$entrybox1->focus;
				$entrybox1->bind('<Return>', sub {
					$entrybox1->destroy; 
					############## command_get() ##############
						#############  send deposit_money, number_entered   ##############
						my $received_jason = command_get('deposit_money:'.$enteredvalue1);
					
						##############  get food and money   ##############
						my %money_ballance = json_decode($received_jason);

						############# change display ##############
							############# money ##############
							$zy[$j] = $money_ballance{money};
							$ingots=int($zy[$j]/10000);
							$coins=$zy[$j]-$ingots*10000;
							
							$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
							$canvasleft->itemconfigure($coins_num,-text=>"$coins");

							$canvas1->itemconfigure($welcome, -text =>"Thank you! Your current ballance\n is $money_ballance{ballance}.");
				});
			});

			######## withdraw	########
			$canvas2->bind($info[1],"<Button-1>",  sub{ 
				my $amount = $redis->hget("$j:primary1", VARbankamount); 
				my $amount_zeny = $redis->hget("$j:primary1", VARzeny); 
				$canvas1->itemconfigure($welcome, -text  => "Your ballance is $amount.\nHow much would you like\n to withdraw?");

				###### entry box ######
				my $enteredvalue1;   
				my $entrybox1 = $canvas1->Entry(-textvariable => \$enteredvalue1, -width => 16)->place(-x => 200, -y => 22*(2+1));
				$entrybox1->focus;
				$entrybox1->bind('<Return>', sub {
					$entrybox1->destroy;   
					############## command_get() ##############
						#############  send withdraw_money, number_entered   ##############
						my $received_jason = command_get('withdraw_money:'.$enteredvalue1);
					
						##############  get food and money   ##############
						my %money_ballance = json_decode($received_jason);

						############# change display ##############
							############# money ##############
							$zy[$j] = $money_ballance{money};
							$ingots=int($zy[$j]/10000);
							$coins=$zy[$j]-$ingots*10000;
							
							$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
							$canvasleft->itemconfigure($coins_num,-text=>"$coins");

							$canvas1->itemconfigure($welcome, -text =>"Thank you! Your current ballance\n is $money_ballance{ballance}.");
				});
			});

			######## borrow ########
			$canvas2->bind($info[2],"<Button-1>",  sub{  
				# my $amount = $redis->hget("$j:primary1", VARbankamount); 
				# my $amount_zeny = $redis->hget("$j:primary1", VARzeny); 
				# if($amount <= 0 ){
					# $canvas1->itemconfigure($welcome, -text  => "Your ballance is $amount.\nHow much would you like\n to borrow?");

					# ###### entry box	######	
					# my $enteredvalue1;   
					# my $entrybox1 = $canvas1->Entry(-textvariable => \$enteredvalue1, -width => 16)->place(-x => 200, -y => 22*(2+1));
					# $entrybox1->focus;
					# $entrybox1->bind('<Return>', sub {
						# # ######## ballance ########
						# # $entrybox1->destroy;   
						# # my $a = $amount - $enteredvalue1;
						# # $redis->hset("$j:primary1", VARbankamount, "$a");
						# # $canvas1->itemconfigure($welcome, -text =>"Thank you! Your current ballance\n is $a.");

						# # ####### in pocket #######
						# # my $b = $amount_zeny + $enteredvalue1; 
						# # $redis->hset("$j:primary1", VARzeny, "$b");
						# # my $ingots=int($b/10000);
						# # my $coins=$b-$ingots*10000;
						# # $canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
						# # $canvasleft->itemconfigure($coins_num,-text=>"$coins");     
					# });
				# }
				
				# if($amount > 0 ){
					# $canvas1->itemconfigure($welcome, -text  => "You have to withdraw all \nyour deposit before you can borrow.");
				# }				
			});

			######## repay ########
			$canvas2->bind($info[3],"<Button-1>",  sub{  
				# my $amount = $redis->hget("$j:primary1", VARbankamount); 
				# my $amount_zeny = $redis->hget("$j:primary1", VARzeny); 
				# if($amount < 0 ){
					# $canvas1->itemconfigure($welcome, -text  => "Your ballance is $amount.\nHow much would you like\n to repay?");

					# ###### entry box	######
					# my $enteredvalue1;   
					# my $entrybox1 = $canvas1->Entry(-textvariable => \$enteredvalue1, -width => 16)->place(-x => 200, -y => 22*(2+1));
					# $entrybox1->focus;
					# $entrybox1->bind('<Return>', sub {
						# # ######## ballance ########
						# # $entrybox1->destroy;   
						# # my $a = $amount + $enteredvalue1;
						# # $redis->hset("$j:primary1", VARbankamount, "$a");
						# # $canvas1->itemconfigure($welcome, -text =>"Thank you! Your current ballance\n is $a.");

						# # ####### in pocket #######
						# # my $b = $amount_zeny - $enteredvalue1; 
						# # $redis->hset("$j:primary1", VARzeny, "$b");
						# # my $ingots=int($b/10000);
						# # my $coins=$b-$ingots*10000;
						# # $canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
						# # $canvasleft->itemconfigure($coins_num,-text=>"$coins");     
					# });
				# }
				
				# if($amount >= 0 ){
					# $canvas1->itemconfigure($welcome, -text  => "You don't owe us anything.");
				# }				
			});		
		}

	################################# @london_dry_dock ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{3}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{3}}{y}){
			######## bg ########
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."drydock_fore.png", -format => 'png',-width => 140,-height => 116 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to the drydock!\nWant a new ship?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 
			 
			######## repair ########	
			$repair=$canvas2->createText( 58,30, -text  => 'Repair',-font =>"Times 12 bold");
			$canvas2->bind($repair,"<Button-1>",  \&repair2);$canvas2->bind($repair,"<Motion>",  \&repair);$canvas2->bind($repair,"<Leave>",  \&repair1);
			sub repair{ $canvas2->itemconfigure($repair, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub repair1{ $canvas2->itemconfigure($repair, -font =>"Times 12 bold",-fill=>"black");}
			sub repair2{
				$mw->bind("<Escape>", sub {
					$fleet->destroy; 
					$mw->bind("<Escape>", \&exit_building);	
				});

				$fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
				$fleet->createImage( 72,98, -image => $p4c); 
				

				my @a = $redis->hmget("$j:ships2", VARdurability0, VARdurability1, VARdurability2, VARdurability3, VARdurability4, VARdurability5, VARdurability6, VARdurability7, VARdurability8, VARdurability9);
				
				my (@dura0, @dura1, @dura2, @dura3, @dura4, @dura5, @dura6, @dura7, @dura8, @dura9);
				
				for($i=0;$i<10;$i++){
					@{dura.$i} =();
					@{dura.$i} = split(/</,$a[$i]);
				}	

				my @ships = ();
				for($i=0;$i<10;$i++){
					push(@ships, ${ship.$i});
				}				

				###### show text ######
				for($i=0;$i<10;$i++){				
					$ships[$i] = $fleet->createText( 70,15*(2+$i), -text  => "Ship$i   $a[$i]  ",-font =>"Times 12 bold");
				}
				
				##### bind #####
				foreach my $i(qw/0 1 2 3 4 5 6 7 8 9/){            
					$fleet->bind($ships[$i],"<Motion>", sub { 
						$fleet->itemconfigure($ships[$i], -font =>"Times 12 bold ",-fill=>"grey20");
					});
					$fleet->bind($ships[$i],"<Leave>", sub { 
						$fleet->itemconfigure($ships[$i], -font =>"Times 12 bold ",-fill=>"black");
					});
					$fleet->bind($ships[$i],"<Button-1>", sub { 	
						$redis->hset("$j:ships2", VARdurability.$i, "@{dura.$i}[1]<@{dura.$i}[1]");       #     $fleet->itemconfigure($ships[$i], -text =>"@{dura.$i}[0]");					
						$fleet->itemconfigure($ships[$i], -text =>"Ship$i    @{dura.$i}[1]<@{dura.$i}[1]", -font =>"Times 12 bold");					
					});				
				}
			}
			
			######## refit ########	
			$refit=$canvas2->createText( 58,30+20, -text  => 'Refit',-font =>"Times 12 bold");
			$canvas2->bind($refit,"<Button-1>",  \&refit2);$canvas2->bind($refit,"<Motion>",  \&refit);$canvas2->bind($refit,"<Leave>",  \&refit1);
			sub refit{ $canvas2->itemconfigure($refit, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub refit1{ $canvas2->itemconfigure($refit, -font =>"Times 12 bold",-fill=>"black");}
			sub refit2{		
				my $canvas3=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
				my $p6=$canvas3->createImage( 58,97, -image => $market_options_gif); 

				$mw->bind("<Escape>", sub {
					$canvas3->destroy; 
					$mw->bind("<Escape>", sub {
						$canvas1->destroy;   
						$canvas2->destroy; 
					});
				});	
				
				my sub bind_escape {						
					$mw->bind("<Escape>", sub {
						$fleet->destroy; 
						$mw->bind("<Escape>", sub {	
							$canvas3->destroy; 
							$mw->bind("<Escape>", sub {
								$canvas1->destroy;   
								$canvas2->destroy; 
							});
						});
					});
				}
				
				my sub bind_escape_2 {
					$mw->bind("<Escape>", sub {
						$fleet2->destroy; 
						$fleet_1->destroy; 
						$entrybox->destroy if (Exists($entrybox));	
						$mw->bind("<Escape>", sub {
							$fleet->destroy; 
							$mw->bind("<Escape>", sub {	
								$canvas3->destroy; 
								$mw->bind("<Escape>", sub {
									$canvas1->destroy;   
									$canvas2->destroy; 
								});
							});
						});
					});	
				}
				
				######## figure ########	
				my $figure = $canvas3->createText( 58,30+0, -text  => 'Figure',-font =>"Times 12 bold");
				$canvas3->bind($figure,"<Motion>",  sub { 	
					$canvas3->itemconfigure($figure, -font =>"Times 12 bold ",-fill=>"grey20");
				});
				$canvas3->bind($figure,"<Leave>",  sub { 						
					$canvas3->itemconfigure($figure, -font =>"Times 12 bold ",-fill=>"black");					
				});
				$canvas3->bind($figure,"<Button-1>",  sub {
					############## make canvas ##############
					my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
					my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
					$fleet->createImage( 72,98, -image => $p4c); 

					############## bind escape ##############
					$mw->bind("<Escape>", sub {
						$fleet->destroy;   
						$mw->bind("<Escape>", sub {
							$canvas1->destroy;   
							$canvas2->destroy; 
							$canvas3->destroy; 
						});
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

							############## bind escape ##############
							$mw->bind("<Escape>", sub {
								$fleet2->destroy; 
								$fleet_1->destroy;
								$mw->bind("<Escape>", sub {
									$fleet->destroy;   
									$mw->bind("<Escape>", sub {
										$canvas1->destroy;   
										$canvas2->destroy; 
										$canvas3->destroy; 
									});
								});	
							});	
							
							############## get data ##############
							my $received_jason = command_get('show_ship_info:'.$ship_num);
							my $json = JSON->new->allow_nonref;
							my $ref_of_items = $json->decode( $received_jason );
							my @ship_data = @$ref_of_items;
							
							############## show data ##############
							my @ship_attributes = (shipname,class,captain,figure,xinb,yinb,durability,tacking,power,speed,capacity,guns,crew,minimumcrew,navigation,lookout,combat,cargo,water,food,lumber,shot);
							my @attributes;
							for my $i(0..@ship_attributes-1) {
								                  $fleet2->createText( 50,20+$i*15, -text =>@ship_attributes[$i]);  
								$attributes[$i] = $fleet2->createText( 130,20+$i*15, -text => @ship_data[$i] ); 
							} 	
							
							############## show ship image ##############
							my $ship_type = lc(@ship_data[1]);
							if ( $ship_type ne '0') {
								my $ship_image = $fleet2->createImage( 260, 70, -image => ${$ship_type} );
							}	

							
							###### make control canvas ######
							$fleet_1 = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
							$fleet_1->createImage( 72,98, -image => $cover_gif);

							###### show text figures ######
							my @figures = ();	
							my @figure_names = ("Sea Horse", "Commodore", "Unicorn", "Lion", "Giant Eagle", "Hero", "Neptune", "Dragon");
							for(my $k=0;$k<8;$k++){					
								$figures[$k] = $fleet_1->createText( 70,15*(2+$k), -text  => "$figure_names[$k]  ",-font =>"Times 12 bold");
							}

							##### bind #####
							foreach my $k(qw/0 1 2 3 4 5 6 7/){            
								$fleet_1->bind($figures[$k],"<Motion>", sub { 									
									$fleet_1->itemconfigure($figures[$k], -font =>"Times 12 bold ",-fill=>"grey20");									
								});
								$fleet_1->bind($figures[$k],"<Leave>",  sub { 
									$fleet_1->itemconfigure($figures[$k], -font =>"Times 12 bold ",-fill=>"black");
								});
								$fleet_1->bind($figures[$k],"<Button-1>",  sub { 									
									$redis->hset("$j:ships2", VARfigure.$ship_num, "$figure_names[$k]");       				
									$fleet2->itemconfigure($attributes[3], -text =>"$figure_names[$k]");									
								}); 
							}		
						});		
					}
					
					############## use sub for available ships ##############
					for my $i(0..@ships_available_index-1) {
						show_ship_info(@ships_available_index[$i]);	
					}																			
				});

				######## guns ########
				my $guns = $canvas3->createText( 58,30+20, -text  => 'Guns',-font =>"Times 12 bold");
				$canvas3->bind($guns,"<Motion>", sub { 	 
					$canvas3->itemconfigure($guns, -font =>"Times 12 bold ",-fill=>"grey20");
				});
				$canvas3->bind($guns,"<Leave>", sub {  						
					$canvas3->itemconfigure($guns, -font =>"Times 12 bold ",-fill=>"black");					
				});
				$canvas3->bind($guns,"<Button-1>",  sub {
					############## make canvas ##############
					my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
					my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
					$fleet->createImage( 72,98, -image => $p4c); 

					############## bind escape ##############
					$mw->bind("<Escape>", sub {
						$fleet->destroy;   
						$mw->bind("<Escape>", sub {
							$canvas1->destroy;   
							$canvas2->destroy; 
							$canvas3->destroy; 
						});
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

							############## bind escape ##############
							$mw->bind("<Escape>", sub {
								$fleet2->destroy; 
								$fleet_1->destroy;
								$mw->bind("<Escape>", sub {
									$fleet->destroy;   
									$mw->bind("<Escape>", sub {
										$canvas1->destroy;   
										$canvas2->destroy; 
										$canvas3->destroy; 
									});
								});	
							});	
							
							############## get data ##############
							my $received_jason = command_get('show_ship_info:'.$ship_num);
							my $json = JSON->new->allow_nonref;
							my $ref_of_items = $json->decode( $received_jason );
							my @ship_data = @$ref_of_items;
							
							############## show data ##############
							my @ship_attributes = (shipname,class,captain,figure,xinb,yinb,durability,tacking,power,speed,capacity,guns,crew,minimumcrew,navigation,lookout,combat,cargo,water,food,lumber,shot);
							my @attributes;
							for my $i(0..@ship_attributes-1) {
								                  $fleet2->createText( 50,20+$i*15, -text =>@ship_attributes[$i]);  
								$attributes[$i] = $fleet2->createText( 130,20+$i*15, -text => @ship_data[$i] ); 
							} 	
							
							############## show ship image ##############
							my $ship_type = lc(@ship_data[1]);
							if ( $ship_type ne '0') {
								my $ship_image = $fleet2->createImage( 260, 70, -image => ${$ship_type} );
							}	

							
							###### make control canvas ######
							$fleet_1 = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
							$fleet_1->createImage( 72,98, -image => $cover_gif);

							###### show text figures ######
							my @guns = ();	
							my @gun_names = ("Cannon", "Demicannon", "Canon Pedrero", "Culverin", "Demiculverin", "Saker");
							for(my $k=0;$k<6;$k++){					
								$guns[$k] = $fleet_1->createText( 70,15*(2+$k), -text  => "$gun_names[$k]  ",-font =>"Times 12 bold");
							}

							my $chosen_gun;
							my $temp_add_cannon;

							##### bind #####
							foreach my $k(qw/0 1 2 3 4 5/){            
								$fleet_1->bind($guns[$k],"<Motion>", sub {  									
									$fleet_1->itemconfigure($guns[$k], -font =>"Times 12 bold ",-fill=>"grey20");								
								});
								$fleet_1->bind($guns[$k],"<Leave>",  sub { 									
									$fleet_1->itemconfigure($guns[$k], -font =>"Times 12 bold ",-fill=>"black");								
								});
								$fleet_1->bind($guns[$k],"<Button-1>",  sub { 								
									$fleet_1->delete($temp_add_cannon);
									$temp_add_cannon = $fleet_1->createText( 120,15*(2+$k), -text  => "+",-font =>"Times 12 bold");	
									$chosen_gun = "$gun_names[$k]";								
								}); 
							}

							$fleet_1->createText( 50,15*(2+7), -text  => "Amount",-font =>"Times 12 bold");

							my $enteredvalue1;
							my $entrybox1 = $fleet_1->Entry(-textvariable => \$enteredvalue1, -width => 5)->place(-x => 80, -y => 14*(2+7));	

							my $ok = $fleet_1->createText( 70,15*(2+9), -text  => "OK",-font =>"Times 12 bold");		
							$fleet_1->bind($ok,"<Button-1>", sub { 
								my $guns = $ship_data[11];
								my @b = split(/</,$guns);
								$redis->hset("$j:ships2", VARguns.$ship_num, "$enteredvalue1<$b[1]<$chosen_gun");       				
								$fleet2->itemconfigure($attributes[11], -text =>"$enteredvalue1<$b[1]<$chosen_gun");		
							});	
							
							bind_motion_leave_canvas($ok, $fleet_1);	
						});		
					}
					
					############## use sub for available ships ##############
					for my $i(0..@ships_available_index-1) {
						show_ship_info(@ships_available_index[$i]);	
					}						
				});

				######## load ########	
				my $load = $canvas3->createText( 58,30+40, -text  => 'Load Capacity',-font =>"Times 12 bold");
				$canvas3->bind($load,"<Motion>",  sub {					
					$canvas3->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"grey20");				
				});
				$canvas3->bind($load,"<Leave>", sub { 					
					$canvas3->itemconfigure($load, -font =>"Times 12 bold ",-fill=>"black");				
				});
				$canvas3->bind($load,"<Button-1>", sub {  
					############## make canvas ##############
					my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
					my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
					$fleet->createImage( 72,98, -image => $p4c); 

					############## bind escape ##############
					$mw->bind("<Escape>", sub {
						$fleet->destroy;   
						$mw->bind("<Escape>", sub {
							$canvas1->destroy;   
							$canvas2->destroy; 
							$canvas3->destroy; 
						});
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

							############## bind escape ##############
							$mw->bind("<Escape>", sub {
								$fleet2->destroy; 
								$fleet_1->destroy;
								$mw->bind("<Escape>", sub {
									$fleet->destroy;   
									$mw->bind("<Escape>", sub {
										$canvas1->destroy;   
										$canvas2->destroy; 
										$canvas3->destroy; 
									});
								});	
							});	
							
							############## get data ##############
							my $received_jason = command_get('show_ship_info:'.$ship_num);
							my $json = JSON->new->allow_nonref;
							my $ref_of_items = $json->decode( $received_jason );
							my @ship_data = @$ref_of_items;
							
							############## show data ##############
							my @ship_attributes = (shipname,class,captain,figure,xinb,yinb,durability,tacking,power,speed,capacity,guns,crew,minimumcrew,navigation,lookout,combat,cargo,water,food,lumber,shot);
							my @attributes;
							for my $i(0..@ship_attributes-1) {
								                  $fleet2->createText( 50,20+$i*15, -text =>@ship_attributes[$i]);  
								$attributes[$i] = $fleet2->createText( 130,20+$i*15, -text => @ship_data[$i] ); 
							} 	
							
							############## show ship image ##############
							my $ship_type = lc(@ship_data[1]);
							if ( $ship_type ne '0') {
								my $ship_image = $fleet2->createImage( 260, 70, -image => ${$ship_type} );
							}	
	
							###### make control canvas ######
							$fleet_1 = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
							$fleet_1->createImage( 72,98, -image => $cover_gif);

							$fleet_1->createText( 50,20*(2+0), -text  => "capacity",-font =>"Times 12 bold");
							my @temp_capacity = split(/</,$ship_data[10]);
							$fleet_1->createText( 100,20*(2+0), -text  => "$temp_capacity[1]",-font =>"Times 12 bold");

							$fleet_1->createText( 50,20*(2+1), -text  => "guns",-font =>"Times 12 bold");
							$fleet_1->createText( 50,20*(2+2), -text  => "crew",-font =>"Times 12 bold");
							$fleet_1->createText( 50,20*(2+3), -text  => "cargo",-font =>"Times 12 bold");


							my ($enteredvalue1, $enteredvalue2,$enteredvalue3);
							my $entrybox1 = $fleet_1->Entry(-textvariable => \$enteredvalue1, -width => 5)->place(-x => 80, -y => 18*(2+1));
							my $entrybox2 = $fleet_1->Entry(-textvariable => \$enteredvalue2, -width => 5)->place(-x => 80, -y => 18*(2+2));

							my $ok = $fleet_1->createText( 75,20*(2+5), -text  => "OK",-font =>"Times 12 bold");
							$fleet_1->bind($ok,"<Button-1>", sub{
								if(defined($enteredvalue1) == 1 && defined($enteredvalue2) == 1){
									my @temp_guns = split(/</,$ship_data[11]);
									$redis->hmset("$j:ships2", 	VARguns.$ship_num, "0<$enteredvalue1<@temp_guns[2]",
																VARcrew.$ship_num, "0<$enteredvalue2",
																VARcargo.$ship_num, "NA"
									); 
	
									$fleet2->itemconfigure($attributes[11], -text =>"0<$enteredvalue1<@temp_guns[2]");
									$fleet2->itemconfigure($attributes[12], -text =>"0<$enteredvalue2");
									$fleet2->itemconfigure($attributes[17], -text =>"$a");
								}
							}); 
							
							$fleet_1->bind($ok,"<Motion>", sub{
								$fleet_1->itemconfigure($ok, -font =>"Times 12 bold ",-fill=>"grey20");	
								if(defined($enteredvalue1) == 1 && defined($enteredvalue2) == 1){
									my $a = $temp_capacity[1] - $enteredvalue1 - $enteredvalue2;
									$fleet_1->delete($temp_load);
									$temp_load = $fleet_1->createText( 100,20*(2+3), -text  => "$a", -font =>"Times 12 bold");	
								}
							}); 
							
							$fleet_1->bind($ok,"<Leave>", sub{
								$fleet_1->itemconfigure($ok, -font =>"Times 12 bold ",-fill=>"black");	
							}); 	
						});		
					}
					
					############## use sub for available ships ##############
					for my $i(0..@ships_available_index-1) {
						show_ship_info(@ships_available_index[$i]);	
					}	  					
				});

				######## rename ########	
				my $rename = $canvas3->createText( 58,30+60, -text  => 'Rename',-font =>"Times 12 bold");
				$canvas3->bind($rename,"<Motion>", sub { 						
					$canvas3->itemconfigure($rename, -font =>"Times 12 bold ",-fill=>"grey20");					
				});
				$canvas3->bind($rename,"<Leave>", sub {  						
					$canvas3->itemconfigure($rename, -font =>"Times 12 bold ",-fill=>"black");					
				});
				$canvas3->bind($rename,"<Button-1>", sub { 
					############## make canvas ##############
					my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
					my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
					$fleet->createImage( 72,98, -image => $p4c); 

					############## bind escape ##############
					$mw->bind("<Escape>", sub {
						$fleet->destroy;   
						$mw->bind("<Escape>", sub {
							$canvas1->destroy;   
							$canvas2->destroy; 
							$canvas3->destroy; 
						});
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

							############## bind escape ##############
							$mw->bind("<Escape>", sub {
								$fleet2->destroy; 
								$fleet_1->destroy;
								$mw->bind("<Escape>", sub {
									$fleet->destroy;   
									$mw->bind("<Escape>", sub {
										$canvas1->destroy;   
										$canvas2->destroy; 
										$canvas3->destroy; 
									});
								});	
							});	
							
							############## get data ##############
							my $received_jason = command_get('show_ship_info:'.$ship_num);
							my $json = JSON->new->allow_nonref;
							my $ref_of_items = $json->decode( $received_jason );
							my @ship_data = @$ref_of_items;
							
							############## show data ##############
							my @ship_attributes = (shipname,class,captain,figure,xinb,yinb,durability,tacking,power,speed,capacity,guns,crew,minimumcrew,navigation,lookout,combat,cargo,water,food,lumber,shot);
							my @attributes;
							for my $i(0..@ship_attributes-1) {
								                  $fleet2->createText( 50,20+$i*15, -text =>@ship_attributes[$i]);  
								$attributes[$i] = $fleet2->createText( 130,20+$i*15, -text => @ship_data[$i] ); 
							} 	
							
							############## show ship image ##############
							my $ship_type = lc(@ship_data[1]);
							if ( $ship_type ne '0') {
								my $ship_image = $fleet2->createImage( 260, 70, -image => ${$ship_type} );
							}	
	
							###### make control canvas ######
							$fleet_1 = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
							$fleet_1->createImage( 72,98, -image => $cover_gif);

							my $enteredvalue2;
							$entrybox = $mw->Entry(-textvariable => \$enteredvalue2)->place(-x => 780-308, -y => 220-180);
							$entrybox->focus;
							$entrybox->bind('<Return>', sub {
								$entrybox->destroy;
								$redis->hset("$j:ships2", VARshipname.$ship_num, "$enteredvalue2");       
								
								$fleet2->itemconfigure($attributes[0], -text =>"$enteredvalue2");
							});		
						});		
					}
					
					############## use sub for available ships ##############
					for my $i(0..@ships_available_index-1) {
						show_ship_info(@ships_available_index[$i]);	
					}	  								
				});
			}
			
			##### sell ship #####	
			$sell_ship=$canvas2->createText( 58,30+40, -text  => 'Sell',-font =>"Times 12 bold");
			$canvas2->bind($sell_ship,"<Button-1>",  \&sell_ship2_sell);$canvas2->bind($sell_ship,"<Motion>",  \&sell_ship);$canvas2->bind($sell_ship,"<Leave>",  \&sell_ship1);
			sub sell_ship{ $canvas2->itemconfigure($sell_ship, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub sell_ship1{ $canvas2->itemconfigure($sell_ship, -font =>"Times 12 bold",-fill=>"black");}
			sub sell_ship2_sell{
				############## make canvas ##############
				my $fleet=$mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200-180);
				my $p4c = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
				$fleet->createImage( 72,98, -image => $p4c); 

				############## bind escape ##############
				$mw->bind("<Escape>",  sub{
					$fleet->destroy;
					$fleet2->destroy;
					$mw->bind("<Escape>", \&exit_building);				
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
						my $sell_text = $fleet2->createText( 260, 200, -text =>'Sell', -font =>"Times 12 bold" );
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
			
			##### buy ship #####	
			$buy_ship=$canvas2->createText( 58,30+60, -text  => 'Buy',-font =>"Times 12 bold");
			$canvas2->bind($buy_ship,"<Button-1>",  \&buy_ship2);$canvas2->bind($buy_ship,"<Motion>",  \&buy_ship);$canvas2->bind($buy_ship,"<Leave>",  \&buy_ship1);
			sub buy_ship{ $canvas2->itemconfigure($buy_ship, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub buy_ship1{ $canvas2->itemconfigure($buy_ship, -font =>"Times 12 bold",-fill=>"black");}
			sub buy_ship2{
				############## make canvas #############
				$p7 = $mw->Photo(-file => 'images//z_others//'."buy_menu1.png", -format => 'png',-width => 368,-height => 156 );
				$p7=$canvas1->createImage( 190,230, -image => $p7); 
				
				############## show available ships #############
					############## send command and receive data #############	
					my $received_jason = command_get(show_available_ships_in_dry_dock);
					my $json = JSON->new->allow_nonref;
					my $ref_of_items = $json->decode( $received_jason );
					
					my @ships_available = @{$ref_of_items};
				
					############## display data #############
					my @text_widgets = ();
					for my $i( 0..@ships_available ) {	
						$text_widgets[$i] = $canvas1->createText( 20,185+($i*15), -text => "$ships_available[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
					}
											
					############## bind motion_leave ############## 
					foreach my $i(0..@ships_available){  
						bind_motion_leave_canvas($text_widgets[$i], $canvas1);
					}

					############## bind click ##############
					my $canvas_left;
					my $canvas_current_items;
					foreach my $i(0..@ships_available){  
						$canvas1->bind($text_widgets[$i],"<Button-1>", sub{
							############# destroy opened canvas ###########
							$canvas_left->destroy if(Exists($canvas_left));
							$canvas_current_items->destroy if(Exists($canvas_current_items));
																			
							########### make left canvas #############
							$canvas_left = $mw->Canvas(-background => "red",-width => 368,-height => 156,-highlightthickness => 0)->place(-x => 400-308, -y => 330-180);	
							my $p7=$canvas_left->createImage( 368/2,156/2, -image => $buy_menu1); 

							############## make text (ship attributes) on canvas ##############
							my $ship_name = $ships_available[$i];
							$canvas_left->createText( 35,35, -text => "$ship_name", -font =>"Times 12 bold", -anchor =>"w"); 

							my %hash_for_ship_attributes =  % { $ship_name_to_attributes{$ship_name} };
							
							my $text_to_display;
							my $count = 0;
							foreach my $key ( sort(keys %hash_for_ship_attributes) ) {				
								$canvas_left->createText( 15,55+($count*12), -text => "$key", -font =>"Times 12 bold", -anchor =>"w"); 
								$canvas_left->createText( 100,55+($count*12), -text => "$hash_for_ship_attributes{$key} ", -font =>"Times 12 bold", -anchor =>"w"); 

								$count += 1;
							}
							
							############## make ship image on canvas ##############
							my $ship_type = $ships_available[$i];
							$ship_type = lc($ship_type);
							
							my $ship_image = $canvas_left->createImage( 50 + 368/2, 20+ 156/2, -image => ${$ship_type} );
	
							############## make buy text and bind it ##############
							my $buy_text = $canvas_left->createText( 200,35, -text => "buy", -font =>"Times 12 bold", -anchor =>"w"); 
							bind_motion_leave_canvas($buy_text, $canvas_left);
							
							$canvas_left->bind($buy_text,"<Button-1>", sub{
								########### buy this ship #############
								my $gold_left = command_get('buy_ship:'.$ships_available[$i]);		#$items_available[$i]

								########### update gold #############										
								$zy[$j] = $gold_left;
								
								$ingots=int($zy[$j]/10000);
								$coins=$zy[$j]-$ingots*10000;

								$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
								$canvasleft->itemconfigure($coins_num,-text=>"$coins");	

							});
							
							########### bind escape #############
							$mw->bind("<Escape>", sub {
								$canvas_left->destroy;
								$mw->bind("<Escape>", \&exit_building);	
							});
						});
					}      
			}	
	 
			##### build #####
			$build=$canvas2->createText( 58,30+80, -text  => 'Build',-font =>"Times 12 bold");
			$canvas2->bind($build,"<Button-1>",  \&build2);$canvas2->bind($build,"<Motion>",  \&build);$canvas2->bind($build,"<Leave>",  \&build1);
			sub build{ $canvas2->itemconfigure($build, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub build1{ $canvas2->itemconfigure($build, -font =>"Times 12 bold",-fill=>"black");}

			$mw->bind("<Escape>", \&exit_building);
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}				
		}
	################################# @london_item_shop ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{10}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{10}}{y}){
			########### make background #############
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."itemshop_fore.png", -format => 'png',-width => 140,-height => 117 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to the item shop!\nHow may I help you?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 

			########### buy #############
			$buy_item=$canvas2->createText( 58,30, -text  => 'Buy',-font =>"Times 12 bold");
			$canvas2->bind($buy_item,"<Button-1>",  \&buy_item2);$canvas2->bind($buy_item,"<Motion>",  \&buy_item);$canvas2->bind($buy_item,"<Leave>",  \&buy_item1);
			sub buy_item{ $canvas2->itemconfigure($buy_item, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub buy_item1{ $canvas2->itemconfigure($buy_item, -font =>"Times 12 bold",-fill=>"black");}
			sub buy_item2 {
				########### make right canvas #############
				my $canvas_right = $mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
				my $p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
				my $p6=$canvas_right->createImage( 58,97, -image => $p6); 

				########### bind escape #############
				$mw->bind("<Escape>", sub {
					$canvas_right->destroy;
					$mw->bind("<Escape>", \&exit_building);		
				});

				###### show available items and prices ######
				my $received_jason = command_get(show_items_in_item_shop);
				my $json = JSON->new->allow_nonref;
				my $ref_of_items = $json->decode( $received_jason );
				my @items_available = @$ref_of_items;
					
				########### make text #############
				my @items = @items_available;
				my @text_items_1 = ();
				foreach my $i(0..@items){  
					$text_items_1[$i] = $canvas_right->createText( 10,14+($i*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
				}				

				############## bind text ############## 
				foreach my $i(0..@items){  
					bind_motion_leave_canvas($text_items_1[$i], $canvas_right);
				}

				my $canvas_left;
				my $canvas_current_items;
				foreach my $i(0..@items){  
					$canvas_right->bind($text_items_1[$i],"<Button-1>", sub{
						############## destroy opened canvas ###########
						$canvas_left->destroy if(Exists($canvas_left));
						$canvas_current_items->destroy if(Exists($canvas_current_items));
					
						########### make current items canvas #############
						$canvas_current_items = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+120-180);
						my $temp = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
						$canvas_current_items->createImage( 72,98, -image => $temp);

						############## make text ############## 
						my $item_list = $redis->hget("$j:primary1", VARitem);
						my $sign = "/";
						my @items = split(/$sign/,$item_list);

						my @text_items = ();
						my $slot_position = 0;
						foreach my $i(0..@items){  
							if($items[$i] ne "0"){
								$slot_position += 1;
								$text_items[$i] = $canvas_current_items->createText( 10,14+(($slot_position-1)*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
							}
						}
						
						########### make left canvas #############
						$canvas_left = $mw->Canvas(-background => "red",-width => 368,-height => 156,-highlightthickness => 0)->place(-x => 400-308, -y => 330-180);	
						my $p7 = $mw->Photo(-file => 'images//z_others//'."buy_menu1.png", -format => 'png',-width => 368,-height => 156 );
						my $p7=$canvas_left->createImage( 368/2,156/2, -image => $p7); 

						########### bind escape #############
						$mw->bind("<Escape>", sub {
							$canvas_right->destroy;
							$canvas_left->destroy;
							$canvas_current_items->destroy;
							$mw->bind("<Escape>", \&exit_building);	
						});

						############## make image #############
						my $name = $canvas_right->itemcget($text_items_1[$i],-text);
						my $lower_name = lc($name);		
						my $item_image = $mw->Photo(-file => "images//item//$lower_name.png", -format => 'png',-width => 49,-height => 48 );
						$canvas_left->createImage( 40,50, -image => $item_image); 

						############## make description #############
						open( my $input, '<', "images//item//$lower_name.txt" );
						my $line_count = 0;
						while (<$input>) {
							chomp;
							my @temp = $_;
							$line_count += 1;
							$canvas_left->createText( 100,30+(20*$line_count), -text => "@temp\n", -font =>"Times 12 bold", -anchor =>"w");
						}
						close($input);

						############## make buy text #############
						my $buy_widget = $canvas_left->createText( 30,100, -text => "Buy", -font =>"Times 12 bold", -anchor =>"w");
						bind_motion_leave_canvas($buy_widget, $canvas_left);
						$canvas_left->bind($buy_widget,"<Button-1>", sub{
							#####  send buy_trade_goods, ship_num, number_entered, cargo_type   ########
							my $received_jason = command_get('buy_item:'.$items_available[$i]);		#$items_available[$i]
						
							#####  get remaining_gold_coins and current_items   ########
							my $json = JSON->new->allow_nonref;
							my $zy_and_current_items_ref = $json->decode( $received_jason );
							
							my $zy = ${ $zy_and_current_items_ref }[0];
							my $current_items = ${ $zy_and_current_items_ref }[1];

							print $zy, $current_items;
	
							##### update gold ######
							$zy[$j] = $zy;
							
							$ingots=int($zy[$j]/10000);
							$coins=$zy[$j]-$ingots*10000;

							$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
							$canvasleft->itemconfigure($coins_num,-text=>"$coins");
							
							############## update current_items #############		
							$canvas_current_items->destroy;
							$canvas_current_items = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+120-180);
							my $temp = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
							$canvas_current_items->createImage( 72,98, -image => $temp); 
													

							my $sign = "/";
							my @items = split(/$sign/,$current_items);

							my @text_items = ();
							my $slot_position = 0;
							foreach my $i(0..@items){  
								if($items[$i] ne "0"){
									$slot_position += 1;
									$text_items[$i] = $canvas_current_items->createText( 10,14+(($slot_position-1)*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
								}
							}
							
						});
					});
				}
			}
					
			########### sell #############
			$sell_item=$canvas2->createText( 58,30+20, -text  => 'Sell',-font =>"Times 12 bold");
			$canvas2->bind($sell_item,"<Button-1>",  \&sell_item2);$canvas2->bind($sell_item,"<Motion>",  \&sell_item);$canvas2->bind($sell_item,"<Leave>",  \&sell_item1);
			sub sell_item{ $canvas2->itemconfigure($sell_item, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub sell_item1{ $canvas2->itemconfigure($sell_item, -font =>"Times 12 bold",-fill=>"black");}
			sub sell_item2 {
				########### make current items canvas #############
				my $canvas_current_items = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+120-65-180);
				my $temp = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
				$canvas_current_items->createImage( 72,98, -image => $temp);

				########### bind escape #############
				$mw->bind("<Escape>", sub {
					#$canvas_right->destroy;
					#$canvas_left->destroy;
					$canvas_current_items->destroy;
					$mw->bind("<Escape>", \&exit_building);	
				});
				
				############## make text ############## 	
				my $received_jason = command_get('sell_show');		#$items_available[$i]		
				my $json = JSON->new->allow_nonref;
				my $items_ref = $json->decode( $received_jason );		
				my @items = @$items_ref;
				
				my @text_items = ();
				my $slot_position = 0;
				foreach my $i(0..@items - 1){  
					if($items[$i] ne "0"){
						$slot_position += 1;
						$text_items[$i] = $canvas_current_items->createText( 10,14+(($slot_position-1)*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
					}
				}

				############## bind text ############## 
				foreach my $i(0..@items){  
					bind_motion_leave_canvas($text_items[$i], $canvas_current_items);
				}

				my $canvas_left;
				foreach my $i(0..@items){  
					$canvas_current_items->bind($text_items[$i],"<Button-1>", sub{
						############## destroy opened canvas ###########
						$canvas_left->destroy if(Exists($canvas_left));	

						############### create left canvas  ###############
						$canvas_left = $mw->Canvas(-background => "red",-width => 345,-height => 354,-highlightthickness => 0)->place(-x => 420-308, -y => 200-180);
						my $p4c = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
						$canvas_left->createImage( 172,177, -image => $p4c);

						############## bind escape #############
						$mw->bind("<Escape>", sub {
							$canvas_left->destroy;
							$canvas_current_items->destroy;
							$mw->bind("<Escape>", \&exit_building);							
						});

						############## make image #############
						my $name = $canvas_current_items->itemcget($text_items[$i],-text);
						my $lower_name = lc($name);		
						my $item_image = $mw->Photo(-file => "images//item//$lower_name.png", -format => 'png',-width => 49,-height => 48 );
						$canvas_left->createImage( 40,40, -image => $item_image); 

						############## make description #############
						open( my $input, '<', "images//item//$lower_name.txt" );
						my $line_count = 0;
						while (<$input>) {
							chomp;
							my @temp = $_;
							$line_count += 1;
							$canvas_left->createText( 100,30+(20*$line_count), -text => "@temp\n", -font =>"Times 12 bold", -anchor =>"w");
						}
						close($input);

						############## make sell text #############
						my $sell_widget = $canvas_left->createText( 30,100, -text => "Sell", -font =>"Times 12 bold", -anchor =>"w");
						bind_motion_leave_canvas($sell_widget, $canvas_left);
						$canvas_left->bind($sell_widget,"<Button-1>", sub{
							#####  send buy_trade_goods, ship_num, number_entered, cargo_type   ########
							my $received_jason = command_get('sell_item:'.$name);		#$items_available[$i]
							
							###  get remaining_gold_coins and current_items   ########
							my $json = JSON->new->allow_nonref;
							my $zy_and_current_items_ref = $json->decode( $received_jason );
							
							my $zy = ${ $zy_and_current_items_ref }[0];
							my $current_items = ${ $zy_and_current_items_ref }[1];

							### update gold ######
							$zy[$j] = $zy;
							
							$ingots=int($zy[$j]/10000);
							$coins=$zy[$j]-$ingots*10000;

							$canvasleft->itemconfigure($ingots_num,-text=>"$ingots");
							$canvasleft->itemconfigure($coins_num,-text=>"$coins");
							
							############ update current_items #############		
							$canvas_current_items->destroy;
							$canvas_current_items = $mw->Canvas(-background => "red",-width => 145,-height => 196,-highlightthickness => 0)->place(-x => 770-308, -y => 200+120-65-180);   
							my $temp = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );			
							$canvas_current_items->createImage( 72,98, -image => $temp); 
													

							my $sign = "/";
							my @items = split(/$sign/,$current_items);

							my @text_items = ();
							my $slot_position = 0;
							foreach my $i(0..@items){  
								if($items[$i] ne "0"){
									$slot_position += 1;
									$text_items[$i] = $canvas_current_items->createText( 10,14+(($slot_position-1)*12), -text => "$items[$i]", -font =>"Times 12 bold", -anchor =>"w"); 
								}
							}								
							
						});	

					});
				}
			}

			############## escape #############
			$mw->bind("<Escape>", \&exit_building);
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}                     
		}
	################################# @london_inn ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{5}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{5}}{y}){
			############## make bg #############
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."inn_fore.png", -format => 'png',-width => 137,-height => 115 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to the inn!\nHow may I help you?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 
		 
			############## rest #############
			$rest=$canvas2->createText( 58,30, -text  => 'Rest',-font =>"Times 12 bold");
			$canvas2->bind($rest,"<Button-1>",  \&rest2);$canvas2->bind($rest,"<Motion>",  \&rest);$canvas2->bind($rest,"<Leave>",  \&rest1);
			sub rest{ $canvas2->itemconfigure($rest, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub rest1{ $canvas2->itemconfigure($rest, -font =>"Times 12 bold",-fill=>"black");}

			############## port info #############
			$port_info=$canvas2->createText( 58,30+20, -text  => 'Port Info',-font =>"Times 12 bold");
			$canvas2->bind($port_info,"<Button-1>",  \&port_info2);$canvas2->bind($port_info,"<Motion>",  \&port_info);$canvas2->bind($port_info,"<Leave>",  \&port_info1);
			sub port_info{ $canvas2->itemconfigure($port_info, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub port_info1{ $canvas2->itemconfigure($port_info, -font =>"Times 12 bold",-fill=>"black");}

			############## escape #############	
			$mw->bind("<Escape>", \&exit_building);
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}			  
		}
						
	################################# @london_palace ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{6}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{6}}{y}){
			############## make bg #############
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 
			
			$p4 = $mw->Photo(-file => 'images//z_others//'."palace_fore.png", -format => 'png',-width => 141,-height => 114 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "This is the palace.\nDo not play around here.",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 

			############## sub create_and_bind_motion_leave($canvas,@a); ##############
			sub create_and_bind_motion_leave{  	
				my $canvas = shift;
				my $info_names_ref = shift;
				my @info_names = @$info_names_ref;
				my @info = (); 
				
				####### create items #######
				for($i=0;$i<@info_names;$i++){   
					$info[$i] = $canvas->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
				}

				####### bind motion leave #######
				for($i=0;$i<@info_names;$i++){   
					bind_motion_leave_canvas($info[$i], $canvas);
				}

				######## click meet ruler ######## 
				$canvas->bind($info[0],"<Button-1>",  sub{  
					####### make bg #######
					my $canvas3=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
					my $p6=$canvas3->createImage( 58,97, -image => $market_options_gif);  
					
					####### escape #######
					$mw->bind("<Escape>", sub {
						$canvas3->destroy; 
						$mw->bind("<Escape>", sub {
							$canvas1->destroy;   
							$canvas2->destroy; 
						});
					});
						
					####### create text items #######	
					my @info = ();   
					my @info_names = ("Sphere of Influence", "Letter of Marque", "Tax Free Permit");
					my $a = $canvas3;
					for($i=0;$i<@info_names;$i++){
						$info[$i] = $a->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
					}

					####### bind motion leave #######
					for($i=0;$i<@info_names;$i++){   
						bind_motion_leave_canvas($info[$i], $a);
					}

					######## click Sphere of Influence ######## 
					$a->bind($info[0],"<Button-1>",  sub{  
						####### make bg #######
						my $canvas4=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
						my $p6=$canvas4->createImage( 58,97, -image => $market_options_gif); 

						####### escape #######
						$mw->bind("<Escape>", sub {
							$canvas4->destroy; 
							$mw->bind("<Escape>", sub {
								$canvas3->destroy;   
								$mw->bind("<Escape>", sub {
									$canvas1->destroy;   
									$canvas2->destroy;
								});
							});
						});

						####### create text items #######
						my @info = ();   
						my @info_names = ("Europe", "New World", "West Africa", "East Africa", "Middle East", "India", "Southeast Asia", "Far East");
						my $a = $canvas4;
						for($i=0;$i<@info_names;$i++){
							$info[$i] = $a->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
						}

						####### bind motion leave #######	
						for($i=0;$i<@info_names;$i++){   
							bind_motion_leave_canvas($info[$i], $a);
						}
					});
				});			
			}
			my @items = ("Meet Ruler", "Defect");
			$items_ref = create_and_bind_motion_leave($canvas2, \@items);

			############## escape #############
			$mw->bind("<Escape>", sub {
				$canvas1->destroy;   
				$canvas2->destroy; 
			});		
		}

	################################# @london_church ###################################
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{11}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{11}}{y}){
			############## make bg #############
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."church_fore.png", -format => 'png',-width => 138,-height => 115 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to our church.",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 
			 
			############## pray #############
			$pray=$canvas2->createText( 58,30, -text  => 'Pray',-font =>"Times 12 bold");
			$canvas2->bind($pray,"<Button-1>",  \&pray2);$canvas2->bind($pray,"<Motion>",  \&pray);$canvas2->bind($pray,"<Leave>",  \&pray1);
			sub pray{ $canvas2->itemconfigure($pray, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub pray1{ $canvas2->itemconfigure($pray, -font =>"Times 12 bold",-fill=>"black");}

			############## donate #############
			$donate=$canvas2->createText( 58,30+20, -text  => 'Donate',-font =>"Times 12 bold");
			$canvas2->bind($donate,"<Button-1>",  \&donate2);$canvas2->bind($donate,"<Motion>",  \&donate);$canvas2->bind($donate,"<Leave>",  \&donate1);
			sub donate{ $canvas2->itemconfigure($donate, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub donate1{ $canvas2->itemconfigure($donate, -font =>"Times 12 bold",-fill=>"black");}

			############## escape #############
			$mw->bind("<Escape>", \&exit_building);
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}		
		}
	################################# @london_job_house ###################################	images//port//'
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{7}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{7}}{y}){
			############## make bg #############
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."jobhouse_fore.png", -format => 'png',-width => 140,-height => 114 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "What do you want?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 
			
			############## job #############		
			my $job=$canvas2->createText( 58,30, -text  => 'Job',-font =>"Times 12 bold");
			$canvas2->bind($job,"<Motion>",  \&job);
			$canvas2->bind($job,"<Leave>",  \&job1);
			sub job{ $canvas2->itemconfigure($job, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub job1{ $canvas2->itemconfigure($job, -font =>"Times 12 bold",-fill=>"black");}
			$canvas2->bind($job,"<Button-1>", sub{
				my $canvas2_1=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
				my $p6=$canvas2_1->createImage( 58,97, -image => $market_options_gif); 			
				
				$mw->bind("<Escape>", sub {
					$canvas2_1->destroy;
					$mw->bind("<Escape>", \&exit_building);	
				});

				####### create text items #######
				my @info = ();   
				my @info_names = ("Defeat Pirates", "Deliver Letter", "Buy Goods");
				for($i=0;$i<3;$i++){
					$info[$i] = $canvas2_1->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
				}

				####### bind motion leave #######
				for($i=0;$i<3;$i++){   
					bind_motion_leave_canvas($info[$i], $canvas2_1);
				}
			});

			############## country info #############		        
			my $country_info=$canvas2->createText( 58,30+20, -text  => 'Country Info',-font =>"Times 12 bold");
			$canvas2->bind($country_info,"<Motion>",  \&country_info);
			$canvas2->bind($country_info,"<Leave>",  \&country_info1);
			sub country_info{ $canvas2->itemconfigure($country_info, -font =>"Times 12 bold ",-fill=>"grey20");}
			sub country_info1{ $canvas2->itemconfigure($country_info, -font =>"Times 12 bold",-fill=>"black");}
			$canvas2->bind($country_info,"<Button-1>", sub{
				my $canvas2_1=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
				my $p6=$canvas2_1->createImage( 58,97, -image => $market_options_gif); 			
				
				$mw->bind("<Escape>", sub {
					$canvas2_1->destroy;
					$mw->bind("<Escape>", \&exit_building);	
				});

				####### create text items #######
				my @info = ();   
				my @info_names = (Portugal, Spain, Turkey, England, Italy, Holland);
				for($i=0;$i<@info_names;$i++){
					$info[$i] = $canvas2_1->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
				}

				####### bind motion leave #######
				for($i=0;$i<@info_names;$i++){   
					bind_motion_leave_canvas($info[$i], $canvas2_1);
				}
			});

			############## escape #############
			$mw->bind("<Escape>", \&exit_building);
			my sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}		
		}
	####################### @london_fortune ##################################		  
		elsif ($mp[$j] ne "sea" &&  $cx[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{12}}{x} && $cy[$j] == 16*${${${$ports{$port_index+1}}{buildings}}{12}}{y}){
			############## make bg #############							
			$canvas1=$mw->Canvas(-background => "red",-width => 385,-height => 387,-highlightthickness => 0)->place(-x => 400-308, -y => 190-180);
			$p3 = $mw->Photo(-file => 'images//z_others//'."market_back.gif", -format => 'gif',-width => 385,-height => 387 );
			$p3=$canvas1->createImage( 192,193, -image => $p3); 

			$p4 = $mw->Photo(-file => 'images//z_others//'."fortune_fore.png", -format => 'png',-width => 137,-height => 116 );
			$p4=$canvas1->createImage( 73,60, -image => $p4); 

			$p5 = $mw->Photo(-file => 'images//z_others//'."market_chat.gif", -format => 'gif',-width => 240,-height => 129 );
			$p5=$canvas1->createImage( 265,65, -image => $p5); 

			$welcome=$canvas1->createText( 267,36, -text  => "Welcome to the fortune house.\nWhat do you want to know?",-font =>"Times 12 bold"); 

			$canvas2=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
			$p6 = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
			$p6=$canvas2->createImage( 58,97, -image => $p6); 

			###################### block sub  create and bind_motion_leave items ######################    
			my $canvas = $canvas2; 	######argument 1
			my @info_names = ("Life", "Career", "Love", "Mates");   ######argument 2
			my @info = (); 
			
			####### create items #######
			for($i=0;$i<@info_names;$i++){   
				$info[$i] = $canvas->createText( 58,30+$i*20, -text  => "$info_names[$i]",-font =>"Times 12 bold");
			}

			####### bind motion leave #######
			for($i=0;$i<@info_names;$i++){   
				bind_motion_leave_canvas($info[$i], $canvas);
			}
				
			###################### bind button 1 ######################	
			######## click life ######## 
			$canvas->bind($info[0],"<Button-1>",  sub{  
				my $a = $redis->hget("$j:mates0to9", VARluck0);
				$canvas1->itemconfigure($welcome, -text => "Your luck is $a.");
			});
			
			######## click mates ######## 
			$canvas->bind($info[3],"<Button-1>",  sub{  
				my $canvas3=$mw->Canvas(-background => "red",-width => 116,-height => 194,-highlightthickness => 0)->place(-x => 790-308, -y => 250-180);
				my $p6=$canvas3->createImage( 58,97, -image => $market_options_gif); 
				
				$mw->bind("<Escape>", sub {
					$canvas3->destroy;
					$mw->bind("<Escape>", \&exit_building);	
				});
				
				###################### block sub  create and bind_motion_leave items  ###################### 
				my @mate_names = $redis->hmget("$j:mates0to9", VARmatename1, VARmatename2, VARmatename3, VARmatename4, VARmatename5, VARmatename6, VARmatename7, VARmatename8, VARmatename9); 
				unshift(@mate_names, 0);
				my @mate_names_10to15 = $redis->hmget("$j:mates10to15", VARmatename10, VARmatename11, VARmatename12, VARmatename13, VARmatename14, VARmatename15); 
				push(@mate_names, @mate_names_10to15);

				my $canvas = $canvas3; 	######argument 1
				my @info_names = @mate_names;   ######argument 2
				my @info1 = (); 

				####### create items #######
				for($i=1;$i<@info_names;$i++){   
					$info1[$i] = $canvas->createText( 58,14+($i-1)*12, -text  => "$info_names[$i]",-font =>"Times 12 bold");
				}

				####### bind motion leave #######
				for($i=1;$i<@info_names;$i++){   
					bind_motion_leave_canvas($info1[$i], $canvas);
				}
				
				####### bind motion leave 1-9 #######
				foreach my $i ((1..9)){   
					######### bind button 1	#########
					######## click mate names ######## 
					$canvas->bind($info1[$i],"<Button-1>",  sub{  
						my $a = $redis->hget("$j:mates0to9", VARluck.$i);
						$canvas1->itemconfigure($welcome, -text => "$mate_names[$i] has luck $a.");
					});
				}
				
				####### bind motion leave 10-15 #######
				foreach my $i ((10..15)){   
					########### bind button 1 #######	
					######## click mate names ######## 
					$canvas->bind($info1[$i],"<Button-1>",  sub{  
						my $a = $redis->hget("$j:mates10to15", VARluck.$i);
						$canvas1->itemconfigure($welcome, -text => "$mate_names[$i] has luck $a.");
					});
				}			
			});

			############## escape #############
			$mw->bind("<Escape>", \&exit_building);
			sub exit_building{
				$canvas1->destroy;   
				$canvas2->destroy; 
				$entry->destroy;  
			}			
		}
			
	####################### @else ##################################
		else {                     
			do UP;
		}
		dfleet();
	}

	

1;	