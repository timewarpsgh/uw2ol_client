
	#######################   *battle  ####################

	############################### !enter battle ground ############################
	sub battle2{
	
		####################### read ships data ####################
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
			
		################  initiate arrays  ##############
		@battlemove_iconlist = ();
		@battlemovelistx = ();
		@battlemovelisty = ();
		@battlemovelistdirection = ();
		@battlemove_realposition_x = ();
		@battlemove_realposition_y = ();
			
		############# left control panel in battle  ############
		if(defined($p_leftbar_in_battle) == 0){   
			my $p_leftbar_in_battle = $mw->Photo(-file => 'images//z_others//'."left_bar_in_battle.png", -format => 'png',-width => 80,-height => 333  );
			my $p_leftbar_in_battle_created = $canvasleft->createImage( 53,223, -image => $p_leftbar_in_battle);
				
			my $Enemy_Fleet = $canvasleft->createText( 53,60, -text => "Enemy Fleet");
			my $Strategy = $canvasleft->createText( 53,200, -text => "Strategy");

			my $my_ship_index = $canvasleft->createText( 20,220, -text => "#");
			my $Order = $canvasleft->createText( 45,220, -text => "Order");	
			my $Target = $canvasleft->createText( 75,220, -text => "Target");
			
			my @ship_index;
			@ship_order;
			@target_index;
			
			for(  $i=0;$i<10;$i++){
				push(@ship_index, ${shipIndex.$i});
				push(@ship_order, ${shipOrder.$i});
				push(@target_index, ${targetIndex.$i});
			}
			for(  $i=1;$i<10;$i++){
				$ship_index[$i] = $canvasleft->createText( 20,240 + ($i-1)*13, -text => "$i", -font =>"Times 12 bold");
				$ship_order[$i] = $canvasleft->createText( 45,240 + ($i-1)*13, -text => "shoot", -font =>"Times 12 bold");     #   -font =>"Times 12 bold"
				$target_index[$i] = $canvasleft->createText( 75,240 + ($i-1)*13, -text => "0", -font =>"Times 12 bold");
			}		
			for($i=1;$i<10;$i++){
				bind_something_a($ship_order[$i]);
			}			
			sub bind_something_a{
				my $a = shift;
				$canvasleft->bind($a,"<Button-1>", sub {
					my $temp_text = $canvasleft->itemcget($a,-text);
					if( $temp_text eq "shoot"){		
						$canvasleft->itemconfigure($a, -text =>"engage");	
					}
					if( $temp_text eq "engage"){		
						$canvasleft->itemconfigure($a, -text =>"escape");	
					}			
					if( $temp_text eq "escape"){		
						$canvasleft->itemconfigure($a, -text =>"shoot");	
					}									
				});				
				$canvasleft->bind($a,"<Motion>", sub {$canvasleft->itemconfigure($a, -font =>"Times 12 bold ",-fill=>"grey20");});
				$canvasleft->bind($a,"<Leave>",  sub {$canvasleft->itemconfigure($a, -font =>"Times 12 bold",-fill=>"black");});
			}

			for($i=1;$i<10;$i++){
				bind_something_b($target_index[$i]);
			}			
			sub bind_something_b{
				my $a = shift;
				$canvasleft->bind($a,"<Button-1>", sub {
					$entrybox = $mw->Entry(-textvariable => \$enteredvalue2,-width => 3)->place(-x => 370, -y => 390);
					$entrybox->focus;
					$entrybox->bind('<Return>', sub{ 
						$entrybox->destroy;
						$canvasleft->itemconfigure($a, -text =>"$enteredvalue2");
					});

				});				
				$canvasleft->bind($a,"<Motion>", sub {$canvasleft->itemconfigure($a, -font =>"Times 12 bold ",-fill=>"grey20");});
				$canvasleft->bind($a,"<Leave>",  sub {$canvasleft->itemconfigure($a, -font =>"Times 12 bold",-fill=>"black");});
			}

			################  exit battle  ##############
			$mw->bind("<Key-m>", sub {   
				###########  update status   ##################
				$VARmp[$j] = "sea";
				UP_small_someone_from(VARmp,$VARmp[$j],$j,primary1);

				$VARmp[$otherguy_num] = "sea";
				UP_small_someone_from(VARmp,$VARmp[$otherguy_num],$otherguy_num,primary1);

				###########  update parent status   ##################
				$mp[$j] = "sea";		
				 
				###########  delete grids/steps/battlemove_icons   ##################
				for($i=1;$i<111;$i++){
					$canvas->delete($p_battle_grid[$i]); 	
				}

				$canvas->delete($step1,$step2,$step3); 
				$canvas->delete(@battlemove_iconlist);

				###########  remove_Ship_In_Battle_Images ##################
				sub remove_ShipInBattleImages{
					for($i=0;$i<10;$i++){  ######## remove ship_in_battle images after battle
						if(defined($AA_myfleetimageinbattle[0])){
							$canvas->delete($AA_myfleetimageinbattle[$i],$AA_myfleetNumber[$i]);     			
							$canvas->delete($AA_enemyfleetimageinbattle[$i],$AA_enemyfleetNumber[$i]);
						}
						if(defined($myfleetimageinbattle[0])){
							$canvas->delete($myfleetimageinbattle[$i],$myfleetNumber[$i]);
							$canvas->delete($enemyfleetimageinbattle[$i],$enemyfleetNumber[$i]);
						}		
					}

					@AA_myfleetimageinbattle = ();
					@AA_myfleetNumber = ();
					@AA_enemyfleetimageinbattle = ();
					@AA_enemyfleetNumber = ();

					@myfleetimageinbattle = ();
					@myfleetNumber = ();
					@enemyfleetimageinbattle = ();
					@enemyfleetNumber = ();	
				}
				remove_ShipInBattleImages();

				################# delete canvasleft and remake it #################################
				$canvasleft->delete($p_leftbar_in_battle_created, $Enemy_Fleet, $Strategy, $my_ship_index, $Order, $Target);
				for($i=0;$i<10;$i++){
					$canvasleft->delete($ship_index[$i], $ship_order[$i], $target_index[$i]);
				}										  
			});   
		}	
		
		############# download @on @mp etc. ############	
		for($i=1;$i<$id+1;$i++){
			${a.($i)} = $redis->hmget("$i:primary1", VARonline, VARmp, VARyn); 		
		}

		for($i=0;$i<$id;$i++){
			@on[$i+1] = @${a.($i+1)}[0];  
			@mp[$i+1] = @${a.($i+1)}[1];  
			@cy[$i+1] = @${a.($i+1)}[2];  
		}
		
		############# update map ############	
		for($na=1;$na<@on;$na++){
			if($on[$na]==1 && $na != $j && $mp[$j] eq $mp[$na] && $cy[$j] == $cy[$na]){								 		 			                           
				$mp[$j] = "battle_ground";
				$mp[$na] = "battle_ground";        
				$otherguy_num=$na;
				UP_small_someone(VARmp,$mp[$na],$otherguy_num);
				UP_small_self(VARmp,$mp[$j]);	
				#UP_small_someone(VARmp,$mp[$na],$otherguy_num); 	#UP;

				$pz = $mw->Photo(-file => 'images//z_others//'."battle_left.png", -format => 'png',-width => 1188,-height => 656  );
				$canvas->itemconfigure($pi,-image => $pz);   ###background		                           		  
			}
		}	

		############# make green grids ############	
		$p_battle_grid = $mw->Photo(-file => 'images//z_others//'."battle_grid.png", -format => 'png',-width => 30,-height => 30  );

		for($i=1;$i<6;$i++){ #right1
			$p_battle_grid[$i]=$canvas->createImage(203+30,203+30*($i-1)+15,-image => $p_battle_grid);
		}
		for($i=6;$i<11;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203+30,203-30*($i+1-6)+15,-image => $p_battle_grid);
		}


		for($i=11;$i<16;$i++){#mid
			$p_battle_grid[$i]=$canvas->createImage(203,203+30*($i-10)+2,-image => $p_battle_grid);
		}
		for($i=16;$i<21;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203,203-30*($i+1-16)-3,-image => $p_battle_grid);
		}

		for($i=21;$i<26;$i++){#left1
			$p_battle_grid[$i]=$canvas->createImage(203-30,203+30*($i-21)+15,-image => $p_battle_grid);
		}
		for($i=26;$i<31;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203-30,203-30*($i+1-26)+15,-image => $p_battle_grid);
		}     

		for($i=31;$i<36;$i++){#right2
			$p_battle_grid[$i]=$canvas->createImage(203+30*2,203+30*($i-31),-image => $p_battle_grid);
		}
		for($i=36;$i<41;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203+30*2,203-30*($i+1-36),-image => $p_battle_grid);
		}     

		for($i=41;$i<46;$i++){#left2
			$p_battle_grid[$i]=$canvas->createImage(203-30*2,203+30*($i-41),-image => $p_battle_grid);
		}
		for($i=46;$i<51;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203-30*2,203-30*($i+1-46),-image => $p_battle_grid);
		}     

		for($i=51;$i<56;$i++){#right3
			$p_battle_grid[$i]=$canvas->createImage(203+30*3,203+30*($i-51)+15,-image => $p_battle_grid);
		}
		for($i=56;$i<61;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203+30*3,203-30*($i+1-56)+15,-image => $p_battle_grid);
		}  

		for($i=61;$i<66;$i++){#left3
			$p_battle_grid[$i]=$canvas->createImage(203-30*3,203+30*($i-61)+15,-image => $p_battle_grid);
		}
		for($i=66;$i<71;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203-30*3,203-30*($i+1-66)+15,-image => $p_battle_grid);
		}   

		for($i=71;$i<76;$i++){#right4
			$p_battle_grid[$i]=$canvas->createImage(203+30*4,203+30*($i-71),-image => $p_battle_grid);
		}
		for($i=76;$i<81;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203+30*4,203-30*($i+1-76),-image => $p_battle_grid);
		}  

		for($i=81;$i<86;$i++){#left4
			$p_battle_grid[$i]=$canvas->createImage(203-30*4,203+30*($i-81),-image => $p_battle_grid);
		}
		for($i=86;$i<91;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203-30*4,203-30*($i+1-86),-image => $p_battle_grid);
		}   

		for($i=91;$i<96;$i++){#right5
			$p_battle_grid[$i]=$canvas->createImage(203+30*5,203+30*($i-91)+15,-image => $p_battle_grid);
		}
		for($i=96;$i<101;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203+30*5,203-30*($i+1-96)+15,-image => $p_battle_grid);
		}  

		for($i=101;$i<106;$i++){#left5
			$p_battle_grid[$i]=$canvas->createImage(203-30*5,203+30*($i-101)+15,-image => $p_battle_grid);
		}
		for($i=106;$i<111;$i++){
			$p_battle_grid[$i]=$canvas->createImage(203-30*5,203-30*($i+1-106)+15,-image => $p_battle_grid);
		} 

	###############  make ship images to cover grids    ################# 			
	sub MakeShipsToCoverGrids{			
		############### make MY ship images to cover grids #################     	
		for($i=0;$i<10;$i++){
			push(@AA_myfleetimageinbattle, ${AA_myfleetimageinbattle.$i});
		}
		
		for($i=0;$i<10;$i++){
			push(@AA_myfleetNumber, ${AA_myfleetNumber.$i});
		}
		for($i=0;$i<10;$i++){
			if(${VARclass.$i}[$j] ne "NA"){    #####  ${VARdurability.$empty_shipslot}[$j]   ${VARclass.$i}[$j]
				if(defined($AA_myfleetimageinbattle[$i])){
					$canvas->itemconfigure($AA_myfleetimageinbattle[$i],-image =>$pshipinbattlelist[${VARspeed.$i}[$j]]); 
					$canvas->coords($AA_myfleetimageinbattle[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$j],203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]);
					$canvas->coords($AA_myfleetNumber[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$j]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]-7);
		
				}
				else{
					$AA_myfleetimageinbattle[$i] = $canvas->createImage(203+${VARxinb.0}[$j]-${VARxinb.$i}[$j],203+${VARyinb.0}[$j]-${VARyinb.$i}[$j], -image => $pshipinbattlelist[${VARspeed.$i}[$j]]);
					$AA_myfleetNumber[$i] = $canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.$i}[$j]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$j]-7, -text => "$i", -font =>"Times 14 bold",-fill=>"white");
				}
			}
		}
		
		################ make ENEMY ship images to cover grids ################     
		@AA_enemyfleetimageinbattle = ();
		for($i=0;$i<10;$i++){
			push(@AA_enemyfleetimageinbattle, ${AA_enemyfleetimageinbattle.$i});
		}
		@AA_enemyfleetNumber = ();
		for($i=0;$i<10;$i++){
			push(@AA_enemyfleetNumber, ${AA_enemyfleetNumber.$i});
		}
		for($i=0;$i<10;$i++){
			if(${VARclass.$i}[$otherguy_num] ne "NA"){    ##### #variable_variable ${VARdurability.$empty_shipslot}[$j]   ${VARclass.$i}[$j]
				if(defined($AA_enemyfleetimageinbattle[$i])){
					$canvas->itemconfigure($AA_enemyfleetimageinbattle[$i],-image =>$pshipinbattlelist[${VARspeed.$i}[$otherguy_num]]); 
					$canvas->coords($AA_enemyfleetimageinbattle[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num]);
					$canvas->coords($AA_enemyfleetNumber[$i],203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num]-7);
				}
				else{
					$AA_enemyfleetimageinbattle[$i] = $canvas->createImage(203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num], -image => $pshipinbattlelist[${VARspeed.$i}[$otherguy_num]]);
					$AA_enemyfleetNumber[$i] = $canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.$i}[$otherguy_num]-11,203+${VARyinb.0}[$j]-${VARyinb.$i}[$otherguy_num]-7, -text => "$i", -font =>"Times 14 bold",-fill=>"black");
				}
			}
		}	
	}




	################ show moveoptions ################ 
	$cbx = 203;
	$cby = 203;

	# up 1, up_right 2, down-right 3, down 4, down-left 5, up-left 6
			  
	sub show_moveoptions{   #if current direction
		if($VARspeed0[$j]  == 1){			        
			$p_battle_grid_red = $mw->Photo(-file => 'images//z_others//'."battle_grid_red.png", -format => 'png',-width => 29,-height => 32 );

			$step1 = $canvas->createImage($cbx,$cby-30,-image => $p_battle_grid_red);
			$step2 = $canvas->createImage($cbx-30,$cby-15,-image => $p_battle_grid_red);
			$step3 = $canvas->createImage($cbx+30,$cby-15,-image => $p_battle_grid_red);
		}
		
		if($VARspeed0[$j]  == 6){			        
			$p_battle_grid_red = $mw->Photo(-file => 'images//z_others//'."battle_grid_red.png", -format => 'png',-width => 29,-height => 32 );

			$step1 = $canvas->createImage($cbx,$cby-30,-image => $p_battle_grid_red);
			$step2 = $canvas->createImage($cbx-30,$cby-15,-image => $p_battle_grid_red);
			$step3 = $canvas->createImage($cbx-30,$cby+15,-image => $p_battle_grid_red);
		}
		
		if($VARspeed0[$j]  == 5){			        
			$p_battle_grid_red = $mw->Photo(-file => 'images//z_others//'."battle_grid_red.png", -format => 'png',-width => 29,-height => 32 );

			$step1 = $canvas->createImage($cbx,$cby+30,-image => $p_battle_grid_red);
			$step2 = $canvas->createImage($cbx-30,$cby+15,-image => $p_battle_grid_red);
			$step3 = $canvas->createImage($cbx-30,$cby-15,-image => $p_battle_grid_red);
		}
		
		if($VARspeed0[$j]  == 4){			        
			$p_battle_grid_red = $mw->Photo(-file => 'images//z_others//'."battle_grid_red.png", -format => 'png',-width => 29,-height => 32 );

			$step1 = $canvas->createImage($cbx-30,$cby+15,-image => $p_battle_grid_red);
			$step2 = $canvas->createImage($cbx,$cby+30,-image => $p_battle_grid_red);
			$step3 = $canvas->createImage($cbx+30,$cby+15,-image => $p_battle_grid_red);
		}
		
		if($VARspeed0[$j]  == 3){			        
			$p_battle_grid_red = $mw->Photo(-file => 'images//z_others//'."battle_grid_red.png", -format => 'png',-width => 29,-height => 32 );

			$step1 = $canvas->createImage($cbx,$cby+30,-image => $p_battle_grid_red);
			$step2 = $canvas->createImage($cbx+30,$cby+15,-image => $p_battle_grid_red);
			$step3 = $canvas->createImage($cbx+30,$cby-15,-image => $p_battle_grid_red);
		}
		
		if($VARspeed0[$j]  == 2){			        
			$p_battle_grid_red = $mw->Photo(-file => 'images//z_others//'."battle_grid_red.png", -format => 'png',-width => 29,-height => 32 );

			$step1 = $canvas->createImage($cbx,$cby-30,-image => $p_battle_grid_red);
			$step2 = $canvas->createImage($cbx+30,$cby-15,-image => $p_battle_grid_red);
			$step3 = $canvas->createImage($cbx+30,$cby+15,-image => $p_battle_grid_red);
		}                               
	}
	  
	################ bind moveoptions ################   
	sub bind_moveoptions{   
		if($VARspeed0[$j]  == 1){
			$canvas->bind($step1,"<Button-1>", \&move_tostep1); 
			$canvas->bind($step2,"<Button-1>", \&move_tostep2);
			$canvas->bind($step3,"<Button-1>", \&move_tostep3);
		}
		if($VARspeed0[$j]  == 6){
			$canvas->bind($step1,"<Button-1>", \&move_tostep1); #OK common move to step1
			$canvas->bind($step2,"<Button-1>", \&move_tostep2); #OK common move to step2
			$canvas->bind($step3,"<Button-1>", \&when6move_tostep3); 
		}
		if($VARspeed0[$j]  == 5){
			$canvas->bind($step1,"<Button-1>", \&when5move_tostep1); 
			$canvas->bind($step2,"<Button-1>", \&when5move_tostep2); 
			$canvas->bind($step3,"<Button-1>", \&when5move_tostep3); 
		}
		if($VARspeed0[$j]  == 4){
			$canvas->bind($step1,"<Button-1>", \&when4move_tostep1); 
			$canvas->bind($step2,"<Button-1>", \&when4move_tostep2); 
			$canvas->bind($step3,"<Button-1>", \&when4move_tostep3); 
		}
		if($VARspeed0[$j]  == 3){
			$canvas->bind($step1,"<Button-1>", \&when3move_tostep1); 
			$canvas->bind($step2,"<Button-1>", \&when3move_tostep2); 
			$canvas->bind($step3,"<Button-1>", \&when3move_tostep3); 
		}
		if($VARspeed0[$j]  == 2){
			$canvas->bind($step1,"<Button-1>", \&when2move_tostep1); 
			$canvas->bind($step2,"<Button-1>", \&when2move_tostep2); 
			$canvas->bind($step3,"<Button-1>", \&when2move_tostep3); 
		}
	} 

	################ show attackoptions ################
	sub show_attackoptions{
		if($VARspeed0[$j]  == 1){		
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x +60 && ${VARyinb.0}[$otherguy_num] == $planedposition_y){
				$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
			}			
		}
	}

	################ press N to move ################
	$mw->bind("<Key-n>", \&moveinbattle);

	sub moveinbattle{
		################ delete stuff ################
		for($i=1;$i<111;$i++){
			$canvas->delete($p_battle_grid[$i]);                                     
		}
		$canvas->delete($step1,$step2,$step3);
		$canvas->delete(@battlemove_iconlist);
		
		################## delete ship images covering grids #####################
		for($i=0;$i<10;$i++){
			$canvas->delete($AA_myfleetimageinbattle[$i], $AA_myfleetNumber[$i]); ## delete my ships
			$canvas->delete($AA_enemyfleetimageinbattle[$i], $AA_enemyfleetNumber[$i]); ## delete enemy ships				
		}
		@AA_myfleetimageinbattle = ();
		@AA_myfleetNumber = ();
		@AA_enemyfleetimageinbattle = ();
		@AA_enemyfleetNumber = ();
		
		############## subs movetostep1-5##################
		sub movetostep1{		 
			$canvas->coords($pfocusinbattle1,2000,2000);

			${VARxinb.0}[$j] = $battlemove_realposition_x[0];
			${VARyinb.0}[$j] = $battlemove_realposition_y[0];
			$VARspeed0[$j] = $battlemovelistdirection[0];

			UP_small_someone_from(VARxinb0,${VARxinb.0}[$j],$j,ships2); 	##UP;
			UP_small_someone_from(VARyinb0,${VARyinb.0}[$j],$j,ships2); 
			UP_small_someone_from(VARspeed0,$VARspeed0[$j],$j,ships2);
		}
		
		sub movetostep2{		
			${VARxinb.0}[$j]=$battlemove_realposition_x[1];
			${VARyinb.0}[$j]=$battlemove_realposition_y[1];
			$VARspeed0[$j] = $battlemovelistdirection[1];
			
			UP_small_someone_from(VARxinb0,${VARxinb.0}[$j],$j,ships2); 	##UP;
			UP_small_someone_from(VARyinb0,${VARyinb.0}[$j],$j,ships2); 
			UP_small_someone_from(VARspeed0,$VARspeed0[$j],$j,ships2);
		}
		
		sub movetostep3{
			${VARxinb.0}[$j]=$battlemove_realposition_x[2];
			${VARyinb.0}[$j]=$battlemove_realposition_y[2];
			$VARspeed0[$j] = $battlemovelistdirection[2];
			
			UP_small_someone_from(VARxinb0,${VARxinb.0}[$j],$j,ships2); 	##UP;
			UP_small_someone_from(VARyinb0,${VARyinb.0}[$j],$j,ships2); 
			UP_small_someone_from(VARspeed0,$VARspeed0[$j],$j,ships2);
		}
		
		sub movetostep4{
			${VARxinb.0}[$j]=$battlemove_realposition_x[3];
			${VARyinb.0}[$j]=$battlemove_realposition_y[3];
			$VARspeed0[$j] = $battlemovelistdirection[3];
			
			UP_small_someone_from(VARxinb0,${VARxinb.0}[$j],$j,ships2); 	##UP;
			UP_small_someone_from(VARyinb0,${VARyinb.0}[$j],$j,ships2); 
			UP_small_someone_from(VARspeed0,$VARspeed0[$j],$j,ships2);
		}
		
		sub movetostep5{
			${VARxinb.0}[$j]=$battlemove_realposition_x[4];
			${VARyinb.0}[$j]=$battlemove_realposition_y[4];
			$VARspeed0[$j] = $battlemovelistdirection[4];
			
			UP_small_someone_from(VARxinb0,${VARxinb.0}[$j],$j,ships2); 	##UP;
			UP_small_someone_from(VARyinb0,${VARyinb.0}[$j],$j,ships2); 
			UP_small_someone_from(VARspeed0,$VARspeed0[$j],$j,ships2);
		}

		############## subs battlerealmove1-5##################
		sub battlerealmove1{				
			$canvas->coords($pfocusinbattle1,203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num]);
			$canvas->bind($pfocusinbattle1,"<Button-1>", \&attack);
			sub attack{    
				$canvas->delete($pfocusinbattle1);
				$cannon = $mw->Photo(-file => 'images//z_others//'."cannon.png", -format => 'png',-width => 10,-height => 10 );
				#$cannon1=$canvas->createImage(203,203,-image => $cannon);
				$distance_x=${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num];
				$distance_y=${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num];

				$show_cannon1 = AnyEvent->timer (after => 0.5*1,  cb => sub{$cannon1=$canvas->createImage(203+$distance_x/5,203+$distance_y/5,-image => $cannon);});
				$show_cannon2 = AnyEvent->timer (after => 0.5*2,  cb => sub{$canvas->coords($cannon1,203+2*$distance_x/5,203+2*$distance_y/5);});
				$show_cannon3 = AnyEvent->timer (after => 0.5*3,  cb => sub{$canvas->coords($cannon1,203+3*$distance_x/5,203+3*$distance_y/5);});
				$show_cannon4 = AnyEvent->timer (after => 0.5*4,  cb => sub{$canvas->coords($cannon1,203+4*$distance_x/5,203+4*$distance_y/5);});

				my @durability=split(/</,$VARdurability0[$otherguy_num]);
				@durability[0] -= 3;
				$durabilityadd=@durability[0]."<".@durability[1];
				$VARdurability0[$otherguy_num]=$durabilityadd;
				$VARmatename15[$j] = "mae";
				
				UP_small_someone_from(VARdurability0,$VARdurability0[$otherguy_num],$otherguy_num,ships2);
				UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);

				$show_cannon5 = AnyEvent->timer (after => 0.5*5,  cb => sub{$durability_beforehit = $canvas->createText(203+$distance_x,203+$distance_y-30, -text => @durability[0]+3,-font =>"Times 12 bold",-fill=>"red");$canvas->delete($cannon1);});
				$show_cannon6 = AnyEvent->timer (after => 0.5*6,  cb => sub{$canvas->itemconfigure($durability_beforehit, -text => @durability[0]);});
				$show_cannon7 = AnyEvent->timer (after => 0.5*7,  cb => sub{$canvas->delete($durability_beforehit);});
				$ship1move = AnyEvent->timer (after => 0.5*8, cb => sub{battle2_1(1,$canvasleft->itemcget($target_index[1] ,-text),$canvasleft->itemcget($ship_order[1] ,-text));});
			} 
			
			if(defined($pfocusinbattle1) == 0){
				$other_ship_to_move = 1;
				$other_ships_movable = 1;
				
				$in_battle_other_ships_move_timer_id = $mw->repeat( 500,  sub{
					if ( $other_ships_movable == 1 ) {
						if ( $other_ship_to_move < 9) {
							$other_ships_movable = 0;
							battle2_1($other_ship_to_move ,$canvasleft->itemcget($target_index[$other_ship_to_move] ,-text),$canvasleft->itemcget($ship_order[$other_ship_to_move] ,-text));							
						}
						else {
							$other_ships_movable = 0;
							battle2_1($other_ship_to_move ,$canvasleft->itemcget($target_index[$other_ship_to_move] ,-text),$canvasleft->itemcget($ship_order[$other_ship_to_move] ,-text));
							
							$in_battle_other_ships_move_timer_id->cancel;
						}
					}				
				});				
			}							
		}
		sub battlerealmove2{
			$canvas->coords($pfocusinbattle1,203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num]);
			$canvas->bind($pfocusinbattle1,"<Button-1>", \&attack);
			if(defined($pfocusinbattle1) == 0){
				$VARmatename15[$j] = "me";
				UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);
			}	
		}
		sub battlerealmove3{
			$canvas->coords($pfocusinbattle1,203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num]);
			$canvas->bind($pfocusinbattle1,"<Button-1>", \&attack);
			if(defined($pfocusinbattle1) == 0){
				$VARmatename15[$j] = "me";
				UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);
			}	
		}
		sub battlerealmove4{		
			$canvas->coords($pfocusinbattle1,203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num]);
			$canvas->bind($pfocusinbattle1,"<Button-1>", \&attack);
			if(defined($pfocusinbattle1) == 0){
				$VARmatename15[$j] = "me";
				UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);
			}	
		}
		sub battlerealmove5{		
			$canvas->coords($pfocusinbattle1,203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num]);
			$canvas->bind($pfocusinbattle1,"<Button-1>", \&attack);
			if(defined($pfocusinbattle1) == 0){
				$VARmatename15[$j] = "me";
				UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);
			}	
		}

		############## subs battlestep1-5##################
		sub battlestep1{
			$moveto1 = AnyEvent->timer (after => 1*1, cb => sub{movetostep1;});	
		}
		sub battlestep2{
			$moveto2 = AnyEvent->timer (after => 1*2, cb => sub{movetostep2;}); 
		}
		sub battlestep3{
			$moveto3 = AnyEvent->timer (after => 1*3, cb => sub{movetostep3;}); 
		}
		sub battlestep4{
			$moveto4 = AnyEvent->timer (after => 1*4, cb => sub{movetostep4;}); 
		}
		sub battlestep5{
			$moveto5 = AnyEvent->timer (after => 1*5, cb => sub{movetostep5;}); 
		}

		############## subs endbattlestep1-5##################
		sub endbattlestep1{
			$moveto1z = AnyEvent->timer (after => 1*1+1, cb => sub{battlerealmove1;});
		}
		sub endbattlestep2{
			$moveto2z = AnyEvent->timer (after => 1*2+1, cb => sub{battlerealmove2;});
		}
		sub endbattlestep3{
			$moveto3z = AnyEvent->timer (after => 1*3+1, cb => sub{battlerealmove3;});
		}
		sub endbattlestep4{
			$moveto4z = AnyEvent->timer (after => 1*4+1, cb => sub{battlerealmove4;});
		}
		sub endbattlestep5{
			$moveto5z = AnyEvent->timer (after => 1*5+1, cb => sub{battlerealmove5;});
		}
		
		############## move based on planned steps ##################
		if(@battlemovelistx == 1){
			battlestep1;endbattlestep1;
		}  
		if(@battlemovelistx == 2){
			battlestep1;battlestep2;endbattlestep2;
		} 
		if(@battlemovelistx == 3){
			battlestep1;battlestep2;battlestep3;endbattlestep3;
		} 
		if(@battlemovelistx == 4){
			battlestep1;battlestep2;battlestep3;battlestep4;endbattlestep4;
		}   
		if(@battlemovelistx == 5){
			battlestep1;battlestep2;battlestep3;battlestep4;battlestep5;endbattlestep5;
		} 
	}

	############## subs when direction x move to step y ##################
	$planedposition_x = ${VARxinb.0}[$j];
	$planedposition_y = ${VARyinb.0}[$j];
										 
	sub move_tostep1{#movewhen
		$canvas->delete($pfocusinbattle1);			

		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_up.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx,$cby-30,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx);
		push(@battlemovelisty, $cby-30);
		push(@battlemovelistdirection,1);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 1;
		$cbx += 0;
		$cby += -30;

		$planedposition_x += 0;
		$planedposition_y += 30;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;
				
		####show_attackoptions1##ATK
		sub when_position1ShowAttackOptions{
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x +60 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 30 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 30 ){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x -60 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 30 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 30 ){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x +90 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y +15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 45 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 45){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x -90 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y +15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 45 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 45){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}		
		}
		when_position1ShowAttackOptions;						                                                 								
	}
					   
	sub move_tostep2{#left  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_upleft.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx-30,$cby-15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx-30);
		push(@battlemovelisty, $cby-15);
		push(@battlemovelistdirection,6);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 6;
		$cbx += -30;
		$cby += -15;

		$planedposition_x += 30;
		$planedposition_y += 15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);


		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		sub when_position6ShowAttackOptions{
			if(${VARxinb.0}[$otherguy_num] > $planedposition_x && ${VARyinb.0}[$otherguy_num] < $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");						
				}
			}
			if(${VARxinb.0}[$otherguy_num] < $planedposition_x && ${VARyinb.0}[$otherguy_num] > $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");						
				}
			}	
		}

		when_position6ShowAttackOptions;					           						    
	}

					
	sub move_tostep3{#right 
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_upright.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx+30,$cby-15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx+30);
		push(@battlemovelisty, $cby-15);
		push(@battlemovelistdirection,2);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 2;
		$cbx += 30;
		$cby += -15;

		$planedposition_x += -30;
		$planedposition_y += 15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		sub when_position2ShowAttackOptions{
			if(${VARxinb.0}[$otherguy_num] > $planedposition_x && ${VARyinb.0}[$otherguy_num] > $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");						
				}
			}
			if(${VARxinb.0}[$otherguy_num] < $planedposition_x && ${VARyinb.0}[$otherguy_num] < $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");						
				}
			}					
		}
		when_position2ShowAttackOptions;	
	}
					
	sub when6move_tostep3{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_downleft.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx-30,$cby+15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);
		
		push(@battlemovelistx, $cbx-30);
		push(@battlemovelisty, $cby+15);
		push(@battlemovelistdirection,5);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 5;
		$cbx += -30;
		$cby += 15;

		$planedposition_x += 30;
		$planedposition_y += -15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		sub when_position5ShowAttackOptions{
			if(${VARxinb.0}[$otherguy_num] > $planedposition_x && ${VARyinb.0}[$otherguy_num] > $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");						
				}
			}
			if(${VARxinb.0}[$otherguy_num] < $planedposition_x && ${VARyinb.0}[$otherguy_num] < $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");						
				}
			}	
		}
		when_position5ShowAttackOptions;	
	}			
	sub when5move_tostep1{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_down.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx,$cby+30,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx);
		push(@battlemovelisty, $cby+30);
		push(@battlemovelistdirection,4);			

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 4;
		$cbx += 0;
		$cby += 30;

		$planedposition_x += 0;
		$planedposition_y += -30;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		sub when_position4ShowAttackOptions{
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x +60 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 30 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 30 ){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x -60 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 30 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 30 ){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x +90 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y +15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 45 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 45){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}
			if(${VARxinb.0}[$otherguy_num] == $planedposition_x -90 ){
				if(${VARyinb.0}[$otherguy_num] == $planedposition_y +15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 15 || ${VARyinb.0}[$otherguy_num] == $planedposition_y + 45 || ${VARyinb.0}[$otherguy_num] == $planedposition_y - 45){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
				}
			}		
		}
		when_position4ShowAttackOptions;			
	} 
	sub when5move_tostep2{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_downleft.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx-30,$cby+15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx-30);
		push(@battlemovelisty, $cby+15);
		push(@battlemovelistdirection,5);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 5;
		$cbx += -30;
		$cby += 15;

		$planedposition_x += 30;
		$planedposition_y += -15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
					bind_moveoptions;

		####show_attackoptions
		when_position5ShowAttackOptions;		
	}
	sub when5move_tostep3{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_upleft.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx-30,$cby-15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx-30);
		push(@battlemovelisty, $cby-15);
		push(@battlemovelistdirection,6);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 6;
		$cbx += -30;
		$cby += -15;

		$planedposition_x += 30;
		$planedposition_y += 15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position6ShowAttackOptions;		
	}
	sub when4move_tostep1{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_downleft.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx-30,$cby+15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx-30);
		push(@battlemovelisty, $cby+15);
		push(@battlemovelistdirection,5);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 5;
		$cbx += -30;
		$cby += 15;

		$planedposition_x += 30;
		$planedposition_y += -15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position5ShowAttackOptions;	
	}
	sub when4move_tostep2{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_down.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx,$cby+30,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx);
		push(@battlemovelisty, $cby+30);
		push(@battlemovelistdirection,4);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 4;
		$cbx += 0;
		$cby += 30;

		$planedposition_x += 0;
		$planedposition_y += -30;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position4ShowAttackOptions;		
	}
	sub when4move_tostep3{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_downright.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx+30,$cby+15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx+30);
		push(@battlemovelisty, $cby+15);
		push(@battlemovelistdirection,3);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 3;
		$cbx += 30;
		$cby += 15;

		$planedposition_x += -30;
		$planedposition_y += -15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		sub when_position3ShowAttackOptions{
			if(${VARxinb.0}[$otherguy_num] > $planedposition_x && ${VARyinb.0}[$otherguy_num] < $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
					
				}
			}
			if(${VARxinb.0}[$otherguy_num] < $planedposition_x && ${VARyinb.0}[$otherguy_num] > $planedposition_y ){
				my $a = abs(${VARxinb.0}[$otherguy_num] - $planedposition_x)+ abs(${VARyinb.0}[$otherguy_num]- $planedposition_y);
				if($a > 1*30 && $a < 4.5 * 30){
					$pfocusinbattle1=$canvas->createText(203+${VARxinb.0}[$j]-${VARxinb.0}[$otherguy_num],203+${VARyinb.0}[$j]-${VARyinb.0}[$otherguy_num],-text=>"[+]", -font =>"Times 18 bold",-fill=>"orange");		
					
				}
			}	
		}
		when_position3ShowAttackOptions;	
	}
	sub when3move_tostep1{  
		$canvas->delete($pfocusinbattle1);
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_down.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx,$cby+30,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx);
		push(@battlemovelisty, $cby+30);
		push(@battlemovelistdirection,4);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 4;
		$cbx += 0;
		$cby += 30;

		$planedposition_x += 0;
		$planedposition_y += -30;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position4ShowAttackOptions;	
	}
	sub when3move_tostep2 { 
		$canvas->delete($pfocusinbattle1); 
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_downright.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx+30,$cby+15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx+30);
		push(@battlemovelisty, $cby+15);
		push(@battlemovelistdirection,3);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 3;
		$cbx += 30;
		$cby += 15;

		$planedposition_x += -30;
		$planedposition_y += -15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position3ShowAttackOptions;	
	}
	sub when3move_tostep3 { 
		$canvas->delete($pfocusinbattle1);  
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_upright.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx+30,$cby-15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx+30);
		push(@battlemovelisty, $cby-15);
		push(@battlemovelistdirection,2);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 2;
		$cbx += 30;
		$cby += -15;

		$planedposition_x += -30;
		$planedposition_y += 15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position2ShowAttackOptions;	
	}
	sub when2move_tostep1 { 
		$canvas->delete($pfocusinbattle1);  
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_up.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx,$cby-30,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx);
		push(@battlemovelisty, $cby-30);
		push(@battlemovelistdirection,1);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 1;
		$cbx += 0;
		$cby += -30;

		$planedposition_x += 0;
		$planedposition_y += 30;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position1ShowAttackOptions;
	} 
	sub when2move_tostep2 { 
		$canvas->delete($pfocusinbattle1);  
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_upright.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx+30,$cby-15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx+30);
		push(@battlemovelisty, $cby-15);
		push(@battlemovelistdirection,2);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 2;
		$cbx += 30;
		$cby += -15;

		$planedposition_x += -30;
		$planedposition_y += 15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position2ShowAttackOptions;		
	} 
	sub when2move_tostep3 { 
		$canvas->delete($pfocusinbattle1);  
		$p_battle_move_icon = $mw->Photo(-file => 'images//z_others//'."battle_move_downright.png", -format => 'png',-width => 36,-height => 35 );
		$moveicon = $canvas->createImage($cbx+30,$cby+15,-image => $p_battle_move_icon);
		push(@battlemove_iconlist, $moveicon);

		push(@battlemovelistx, $cbx+30);
		push(@battlemovelisty, $cby+15);
		push(@battlemovelistdirection,3);

		$canvas->delete($step1,$step2,$step3);

		$VARspeed0[$j] = 3;
		$cbx += 30;
		$cby += 15;

		$planedposition_x += -30;
		$planedposition_y += -15;
		push(@battlemove_realposition_x, $planedposition_x);
		push(@battlemove_realposition_y, $planedposition_y);

		show_moveoptions;
		bind_moveoptions;

		####show_attackoptions
		when_position3ShowAttackOptions;	
	}

	############ main sequence ##############                    
	show_moveoptions;
	bind_moveoptions; 
	MakeShipsToCoverGrids();                                                                                
	}   
	 
	############################## !order other ships to move ############################
	sub battle2_1{       
		############ read arguments #############
		my $i = shift; #whichship 	1
		my $m = shift; #target 	  	0
		my $n = shift; #battleorder 	"escape"	
		
		# ########### VARxinb.0 = ${VARxinb.0} ###########
		# ${VARxinb.0}[$j] = ${VARxinb.0}[$j];
		# ${VARyinb.0}[$j] = ${VARyinb.0}[$j];
		# ${VARxinb.0}[$otherguy_num] = ${VARxinb.0}[$otherguy_num];
		# ${VARyinb.0}[$otherguy_num] = ${VARyinb.0}[$otherguy_num];
		
		############# if escape ordered ################
		if($n eq "escape"){
			$step_moved_escape = 0;
			EscapeWhenEscape($i,$m);
			sub EscapeWhenEscape{
				my $i = shift;
				my $m = shift;
				$step_moved_escape += 1;

				if(${VARspeed.$i}[$j]  == 1){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
					my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
					my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
					my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
					my @distances = ($distance1,$distance2,$distance3);
					my $max_distance = List::Util::max @distances;

					MoveToUnblockedPositionEscape($i,$m,$distance1,$distance2,$distance3,$max_distance,1,0,30,6,30,15,2,-30,15);
				}

				elsif(${VARspeed.$i}[$j]  == 2){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
					my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
					my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
					my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
					my @distances = ($distance1,$distance2,$distance3);
					my $max_distance = List::Util::max @distances;

					MoveToUnblockedPositionEscape($i,$m,$distance1,$distance2,$distance3,$max_distance,1,0,30,2,-30,15,3,-30,-15);
				}
				elsif(${VARspeed.$i}[$j]  == 3){			        
					my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
					my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
					my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
					my @distances = ($distance1,$distance2,$distance3);
					my $max_distance = List::Util::max @distances;

					MoveToUnblockedPositionEscape($i,$m,$distance1,$distance2,$distance3,$max_distance,4,0,-30,3,-30,-15,2,-30,15);
				}
				elsif(${VARspeed.$i}[$j]  == 4){			        
					my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) );  
					my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) ) ;
					my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
					my @distances = ($distance1,$distance2,$distance3);
					my $max_distance = List::Util::max @distances;	
											
					sub StepStackCheck{       
						my $x = shift;
						my $y = shift;	
						my $stack = 0;
						for(my $k=0;$k<10;$k++){  
							if($x == ${VARxinb.$k}[$j] && $y == ${VARyinb.$k}[$j] ){
								$stack += 1;	
							}
							if($x == ${VARxinb.$k}[$otherguy_num] && $y == ${VARyinb.$k}[$otherguy_num] ){
								$stack += 1;	
							}
						}
						return($stack);
					}

					MoveToUnblockedPositionEscape($i,$m,$distance1,$distance2,$distance3,$max_distance,5,30,-15,4,0,-30,3,-30,-15);	
					sub MoveToUnblockedPositionEscape{
						my $i= shift;
						my $m= shift;

						my $distance1 = shift;
						my $distance2 = shift;
						my $distance3 = shift;	
						my $max_distance = shift;
						
						my $FirstStepDirection = shift;
						my $FirstStepX = shift;
						my $FirstStepY = shift;
						
						my $SecondStepDirection = shift;
						my $SecondStepX = shift;
						my $SecondStepY = shift;

						my $ThirdStepDirection = shift;
						my $ThirdStepX = shift;
						my $ThirdStepY = shift;

						my $stack1 = StepStackCheck(${VARxinb.$i}[$j] + $FirstStepX, ${VARyinb.$i}[$j] + $FirstStepY);
						my $stack2 = StepStackCheck(${VARxinb.$i}[$j] + $SecondStepX, ${VARyinb.$i}[$j] + $SecondStepY);
						my $stack3 = StepStackCheck(${VARxinb.$i}[$j] + $ThirdStepX, ${VARyinb.$i}[$j] + $ThirdStepY);	
						
						################max and movable##########
						if($max_distance == $distance1 && $stack1 == 0 && $step_moved_escape <= 3){
							#step choice 1
							${VARspeed.$i}[$j] = $FirstStepDirection;
							${VARxinb.$i}[$j] += $FirstStepX;
							${VARyinb.$i}[$j] += $FirstStepY;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
							UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
							UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);
							
							$timer1 = AnyEvent->timer (after => 1, cb => sub{EscapeWhenEscape($i,$m);});
						}
						elsif($max_distance == $distance2 && $stack2 == 0 && $step_moved_escape <= 3){
							#step choice 2
							${VARspeed.$i}[$j] = $SecondStepDirection;
							${VARxinb.$i}[$j] += $SecondStepX;
							${VARyinb.$i}[$j] += $SecondStepY;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
							UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
							UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

							$timer1 = AnyEvent->timer (after => 1, cb => sub{EscapeWhenEscape($i,$m);});				
						}
						elsif($max_distance == $distance3 && $stack3 == 0 && $step_moved_escape <= 3){
							#step choice 3
							${VARspeed.$i}[$j] = $ThirdStepDirection;
							${VARxinb.$i}[$j] += $ThirdStepX;
							${VARyinb.$i}[$j] += $ThirdStepY;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
							UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
							UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

							$timer1 = AnyEvent->timer (after => 1, cb => sub{EscapeWhenEscape($i,$m);});
						}##################### only movable ###############
						elsif( $stack1 == 0 && $step_moved_escape <= 3){
							#step choice 1
							${VARspeed.$i}[$j] = $FirstStepDirection;
							${VARxinb.$i}[$j] += $FirstStepX;
							${VARyinb.$i}[$j] += $FirstStepY;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
							UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
							UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

							$timer1 = AnyEvent->timer (after => 1, cb => sub{EscapeWhenEscape($i,$m);});
						}
						elsif( $stack2 == 0 && $step_moved_escape <= 3){
							#step choice 2
							${VARspeed.$i}[$j] = $SecondStepDirection;
							${VARxinb.$i}[$j] += $SecondStepX;
							${VARyinb.$i}[$j] += $SecondStepY;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
							UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
							UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

							$timer1 = AnyEvent->timer (after => 1, cb => sub{EscapeWhenEscape($i,$m);});				
						}
						elsif( $stack3 == 0 && $step_moved_escape <= 3){
							#step choice 3
							${VARspeed.$i}[$j] = $ThirdStepDirection;
							${VARxinb.$i}[$j] += $ThirdStepX;
							${VARyinb.$i}[$j] += $ThirdStepY;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
							UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
							UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

							$timer1 = AnyEvent->timer (after => 1, cb => sub{EscapeWhenEscape($i,$m);});
						}
						else{  ###can't move #####	       	  	       			
							my $cannotmoveIcon = $canvas->createText(203+$VARxinb0[$j]-${VARxinb.$i}[$j],203+$VARyinb0[$j]-${VARyinb.$i}[$j], -text => "X", -font =>"Times 18 bold",-fill=>"red");
							$timer1 = AnyEvent->timer (after => 0.2, cb => sub{$canvas->delete($cannotmoveIcon);});

							#######################next ship move #################
							if($i < 9){
								$mw->after(1000, sub {
									$other_ship_to_move += 1;
									$other_ships_movable = 1;
								});
								# $mw->after(1000, [\&battle2_1, $i+1,$canvasleft->itemcget($target_index[$i+1] ,-text),$canvasleft->itemcget($ship_order[$i+1] ,-text)]);							
							}
							else{
								$mw->after(1000, sub {$VARmatename15[$j] = "me";UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);;return; });
								#$VARmatename15[$j] = "me";  ####switch to other player
								#UP;
								#return;
							}						
						}	
					}
						 
				}
				elsif(${VARspeed.$i}[$j]  == 5){			        
					  my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
					  my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
					  my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
					  my @distances = ($distance1,$distance2,$distance3);
					  my $max_distance = List::Util::max @distances;

					  MoveToUnblockedPositionEscape($i,$m,$distance1,$distance2,$distance3,$max_distance,4,0,-30,5,30,-15,6,30,15);	 
				}
				elsif(${VARspeed.$i}[$j]  == 6){			        
					  my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
					  my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
					  my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
					  my @distances = ($distance1,$distance2,$distance3);
					  my $max_distance = List::Util::max @distances;

					  MoveToUnblockedPositionEscape($i,$m,$distance1,$distance2,$distance3,$max_distance,1,0,30,6,30,15,5,30,-15);
				}
				else{  
				}  
			}						
		}
		
		############# if engage ordered ################
		if($n eq "engage"){
			$step_moved_engage = 0;
			OthersMoveToClosestStepEngage($i,$m);
			sub OthersMoveToClosestStepEngage{   #if current direction  ${VARspeed.$i}[$j]
				my $i = shift; 
				my $m = shift;  
				my $distanceim = abs(${VARyinb.$m}[$otherguy_num] - ${VARyinb.$i}[$j]) + abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]);	
			
				############# if distance 1 ################
				if( $distanceim > 1.5 * 30  ){
					$step_moved_engage += 1;
				
					if(${VARspeed.$i}[$j]  == 1){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloserEngage($i,$m,$distance1,$distance2,$distance3,$min_distance,1,0,30,6,30,15,2,-30,15);
					}

					elsif(${VARspeed.$i}[$j]  == 2){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloserEngage($i,$m,$distance1,$distance2,$distance3,$min_distance,1,0,30,2,-30,15,3,-30,-15);
					}
					elsif(${VARspeed.$i}[$j]  == 3){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloserEngage($i,$m,$distance1,$distance2,$distance3,$min_distance,4,0,-30,3,-30,-15,2,-30,15);	
					}
					elsif(${VARspeed.$i}[$j]  == 4){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloserEngage($i,$m,$distance1,$distance2,$distance3,$min_distance,5,30,-15,4,0,-30,3,-30,-15);
						sub StepStackCheckFar{       
							my $x = shift;
							my $y = shift;	
							my $stack = 0;
							for(my $k=0;$k<10;$k++){  
								if($x == ${VARxinb.$k}[$j] && $y == ${VARyinb.$k}[$j] ){
									$stack += 1;	
								}
								if($x == ${VARxinb.$k}[$otherguy_num] && $y == ${VARyinb.$k}[$otherguy_num] ){
									$stack += 1;	
								}
							}
							return($stack);
						}	
						sub WhenFarMoveCloserEngage{
							my $i= shift;
							my $m= shift;
							
							my $distance1 = shift;
							my $distance2 = shift;
							my $distance3 = shift;	
							my $min_distance = shift;	
							
							my $FirstStepDirection = shift;
							my $FirstStepX = shift;
							my $FirstStepY = shift;
							
							my $SecondStepDirection = shift;
							my $SecondStepX = shift;
							my $SecondStepY = shift;

							my $ThirdStepDirection = shift;
							my $ThirdStepX = shift;
							my $ThirdStepY = shift;

							my $stack1 = StepStackCheckFar(${VARxinb.$i}[$j] + $FirstStepX, ${VARyinb.$i}[$j] + $FirstStepY);
							my $stack2 = StepStackCheckFar(${VARxinb.$i}[$j] + $SecondStepX, ${VARyinb.$i}[$j] + $SecondStepY);
							my $stack3 = StepStackCheckFar(${VARxinb.$i}[$j] + $ThirdStepX, ${VARyinb.$i}[$j] + $ThirdStepY);	
							
							################min and movable##########
							if($min_distance == $distance1 && $stack1 == 0 && $step_moved_engage <= 3){    
								#step choice 1
								${VARspeed.$i}[$j] = $FirstStepDirection;
								${VARxinb.$i}[$j] += $FirstStepX;
								${VARyinb.$i}[$j] += $FirstStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStepEngage($i,$m);});
							}
											
							elsif($min_distance == $distance2 && $stack2 == 0 && $step_moved_engage <= 3){
								#step choice 2
								${VARspeed.$i}[$j] = $SecondStepDirection;
								${VARxinb.$i}[$j] += $SecondStepX;
								${VARyinb.$i}[$j] += $SecondStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStepEngage($i,$m);});				
							}
							elsif($min_distance == $distance3 && $stack3 == 0 && $step_moved_engage <= 3){
								#step choice 3
								${VARspeed.$i}[$j] = $ThirdStepDirection;
								${VARxinb.$i}[$j] += $ThirdStepX;
								${VARyinb.$i}[$j] += $ThirdStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStepEngage($i,$m);});
							}##################### only movable ###############
							elsif( $stack1 == 0 && $step_moved_engage <= 3){
								#step choice 1
								${VARspeed.$i}[$j] = $FirstStepDirection;
								${VARxinb.$i}[$j] += $FirstStepX;
								${VARyinb.$i}[$j] += $FirstStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStepEngage($i,$m);});
							}
							elsif( $stack2 == 0 && $step_moved_engage <= 3){
								#step choice 2
								${VARspeed.$i}[$j] = $SecondStepDirection;
								${VARxinb.$i}[$j] += $SecondStepX;
								${VARyinb.$i}[$j] += $SecondStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStepEngage($i,$m);});				
							}
							elsif( $stack3 == 0 && $step_moved_engage <= 3){
								#step choice 3
								${VARspeed.$i}[$j] = $ThirdStepDirection;
								${VARxinb.$i}[$j] += $ThirdStepX;
								${VARyinb.$i}[$j] += $ThirdStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStepEngage($i,$m);});
							}
							else{  ###can't move #####		
								my $cannotmoveIcon = $canvas->createText(203+$VARxinb0[$j]-${VARxinb.$i}[$j],203+$VARyinb0[$j]-${VARyinb.$i}[$j], -text => "X", -font =>"Times 18 bold",-fill=>"red");
								$timer1 = AnyEvent->timer (after => 0.2, cb => sub{$canvas->delete($cannotmoveIcon);});

								#######################next ship move #################
								if($i < 9){
									$mw->after(1000, sub {
										$other_ship_to_move += 1;
										$other_ships_movable = 1;
									});
									# $mw->after(1000, [\&battle2_1, $i+1,$canvasleft->itemcget($target_index[$i+1] ,-text),$canvasleft->itemcget($ship_order[$i+1] ,-text)]);return;	
								}
								else{
									$mw->after(1000, sub {$VARmatename15[$j] = "me";UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);return; });
								}
								#######################################################
							}	
						}				
					}
					elsif(${VARspeed.$i}[$j]  == 5){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloserEngage($i,$m,$distance1,$distance2,$distance3,$min_distance,4,0,-30,5,30,-15,6,30,15);				
					}
					elsif(${VARspeed.$i}[$j]  == 6){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloserEngage($i,$m,$distance1,$distance2,$distance3,$min_distance,1,0,30,6,30,15,5,30,-15);				  
					}
					else{  
					} 		                     
				}

				############# if   current distance <= 1.5 , move to farest step ################
				if( $distanceim <= 1.5 * 30  ){   
					OthersAttack_Engage($i,$m);
					sub OthersAttack_Engage{   
						my $i = shift; 
						my $m = shift;  
						my @crew_m = split(/</,${VARcrew.$m}[$otherguy_num]);
						my @crew_i = split(/</,${VARcrew.$i}[$j]);

						############ show crew engaged ##########
						$mw->after(0, [\&ShowCrewHit, $i, $m]);
						sub ShowCrewHit{
							my $i = shift; 
							my $m = shift; 
							my $distance_x = ${VARxinb.$i}[$j]-${VARxinb.$m}[$otherguy_num];
							my $distance_y = ${VARyinb.$i}[$j]-${VARyinb.$m}[$otherguy_num]; 
							
							my $crew_hit_icon = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$i}[$j]+$distance_x,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+$distance_y , -text => X,-font =>"Times 12 bold",-fill=>"black");
							$mw->after(500,sub{$canvas->coords($crew_hit_icon, 203+$VARxinb0[$j]- ${VARxinb.$i}[$j],203+$VARyinb0[$j]- ${VARyinb.$i}[$j] );});
							$mw->after(1000,sub {$canvas->delete($crew_hit_icon);});
						}
						
						############ show crew number left ##########
						$mw->after(1500, [\&MiddleOfCannonAndShowCrew, $i,$m]); 
						sub MiddleOfCannonAndShowCrew{
							my $i = shift; 
							my $m = shift; 
							my $distance_x = ${VARxinb.$i}[$j]-${VARxinb.$m}[$otherguy_num];
							my $distance_y = ${VARyinb.$i}[$j]-${VARyinb.$m}[$otherguy_num];
							
							@crew_m[0] -= 10;
							@crew_i[0] -= 10;
							$crew_m = @crew_m[0]."<".@crew_m[1];
							$crew_i = @crew_i[0]."<".@crew_i[1];

							${VARcrew.$m}[$otherguy_num] = $crew_m;
							${VARcrew.$i}[$j] = $crew_i;

							$VARmatename15[$j] = "MEgoing$i$m";   ####
							UP_small_someone_from(VARmatename15 ,$VARmatename15[$j],$j,mates10to15);
							UP_small_someone_from(${VARcrew.$m} ,${VARcrew.$m}[$otherguy_num],$otherguy_num,ships2);
							UP_small_someone_from(${VARcrew.$i} ,${VARcrew.$i}[$j],$j,ships2);
							
							my $crew_beforehit_m = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$i}[$j]+$distance_x,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+$distance_y + 30, -text => @crew_m[0] + 10,-font =>"Times 12 bold",-fill=>"blue");
							my $crew_beforehit_i = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$i}[$j],203+$VARyinb0[$j]- ${VARyinb.$i}[$j] + 30, -text => @crew_i[0] + 10,-font =>"Times 12 bold",-fill=>"blue");
							
							$show_cannon6 = AnyEvent->timer (after => 0.5,  cb => sub{$canvas->itemconfigure($crew_beforehit_m, -text => @crew_m[0]);$canvas->itemconfigure($crew_beforehit_i, -text => @crew_i[0]);});
							#$show_cannon6 = AnyEvent->timer (after => 0.5,  cb => sub{$canvas->itemconfigure($crew_beforehit_i, -text => @crew_i[0]);});
							$show_cannon7 = AnyEvent->timer (after => 1,  cb => sub{$canvas->delete($crew_beforehit_m,$crew_beforehit_i);});
							#$show_cannon7 = AnyEvent->timer (after => 1,  cb => sub{$canvas->delete($crew_beforehit_i);});
						}
						
						#######################next ship move #################
						if($i < 9){
							$mw->after(3500, sub {
								$other_ship_to_move += 1;
								$other_ships_movable = 1;
							});
						
							# $mw->after(3500, [\&battle2_1, $i+1,$canvasleft->itemcget($target_index[$i+1] ,-text),$canvasleft->itemcget($ship_order[$i+1] ,-text)]);
						}
						else{
							$mw->after(4000, sub {$VARmatename15[$j] = "me";UP_small_someone_from(VARmatename15,$VARmatename15[$j],$j,mates10to15);return; });
							#$VARmatename15[$j] = "me";  ####switch to other player
							#UP;
							#return;
						}					
					}  
				}
			}  
		}  

		############# if shoot ordered ################
		if($n eq "shoot"){
=pod	my $i = shift; #whichship 	1
			my $m = shift; #target 	  	0
=cut	my $n = shift; #battleorder 	"escape"
			my $HaveShot = 0;
			
			########### VARxinb.0 = ${VARxinb.0} ###########
			${VARxinb.0}[$j] = ${VARxinb.0}[$j];
			${VARyinb.0}[$j] = ${VARyinb.0}[$j];
			${VARxinb.0}[$otherguy_num] = ${VARxinb.0}[$otherguy_num];
			${VARyinb.0}[$otherguy_num] = ${VARyinb.0}[$otherguy_num];
			
			########### OthersMoveToClosestStep ################
			OthersMoveToClosestStep($i,$m);
			sub OthersMoveToClosestStep{   #if current direction  ${VARspeed.$i}[$j]
				my $i = shift; 
				my $m = shift;  
				my $distanceim = abs(${VARyinb.$m}[$otherguy_num] - ${VARyinb.$i}[$j]) + abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]);	
			
				########### if distance 1 ################
				if( $distanceim > 4.5 * 30  ){			
					if(${VARspeed.$i}[$j]  == 1){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloser($i,$m,$distance1,$distance2,$distance3,$min_distance,1,0,30,6,30,15,2,-30,15);
					}
					elsif(${VARspeed.$i}[$j]  == 2){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloser($i,$m,$distance1,$distance2,$distance3,$min_distance,1,0,30,2,-30,15,3,-30,-15);
					}
					elsif(${VARspeed.$i}[$j]  == 3){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloser($i,$m,$distance1,$distance2,$distance3,$min_distance,4,0,-30,3,-30,-15,2,-30,15);	
					}
					elsif(${VARspeed.$i}[$j]  == 4){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloser($i,$m,$distance1,$distance2,$distance3,$min_distance,5,30,-15,4,0,-30,3,-30,-15);
						sub StepStackCheckFar{       
							my $x = shift;
							my $y = shift;	
							my $stack = 0;
							for(my $k=0;$k<10;$k++){  
								if($x == ${VARxinb.$k}[$j] && $y == ${VARyinb.$k}[$j] ){
									$stack += 1;	
								}
								if($x == ${VARxinb.$k}[$otherguy_num] && $y == ${VARyinb.$k}[$otherguy_num] ){
									$stack += 1;	
								}
							}
							return($stack);
						}	
						sub WhenFarMoveCloser{
							my $i= shift;
							my $m= shift;
							
							my $distance1 = shift;
							my $distance2 = shift;
							my $distance3 = shift;	
							my $min_distance = shift;	
							
							my $FirstStepDirection = shift;
							my $FirstStepX = shift;
							my $FirstStepY = shift;
							
							my $SecondStepDirection = shift;
							my $SecondStepX = shift;
							my $SecondStepY = shift;

							my $ThirdStepDirection = shift;
							my $ThirdStepX = shift;
							my $ThirdStepY = shift;

							my $stack1 = StepStackCheckFar(${VARxinb.$i}[$j] + $FirstStepX, ${VARyinb.$i}[$j] + $FirstStepY);
							my $stack2 = StepStackCheckFar(${VARxinb.$i}[$j] + $SecondStepX, ${VARyinb.$i}[$j] + $SecondStepY);
							my $stack3 = StepStackCheckFar(${VARxinb.$i}[$j] + $ThirdStepX, ${VARyinb.$i}[$j] + $ThirdStepY);	
							
							################min and movable##########
							



							if($min_distance == $distance1 && $stack1 == 0){    
								#step choice 1
								${VARspeed.$i}[$j] = $FirstStepDirection;
								${VARxinb.$i}[$j] += $FirstStepX;
								${VARyinb.$i}[$j] += $FirstStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
							}

							elsif($min_distance == $distance2 && $stack2 == 0){
								#step choice 2
								${VARspeed.$i}[$j] = $SecondStepDirection;
								${VARxinb.$i}[$j] += $SecondStepX;
								${VARyinb.$i}[$j] += $SecondStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});				
							}
							elsif($min_distance == $distance3 && $stack3 == 0){
								#step choice 3
								${VARspeed.$i}[$j] = $ThirdStepDirection;
								${VARxinb.$i}[$j] += $ThirdStepX;
								${VARyinb.$i}[$j] += $ThirdStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
							}##################### only movable ###############
							elsif( $stack1 == 0){
								#step choice 1
								${VARspeed.$i}[$j] = $FirstStepDirection;
								${VARxinb.$i}[$j] += $FirstStepX;
								${VARyinb.$i}[$j] += $FirstStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
							}
							elsif( $stack2 == 0){
								#step choice 2
								${VARspeed.$i}[$j] = $SecondStepDirection;
								${VARxinb.$i}[$j] += $SecondStepX;
								${VARyinb.$i}[$j] += $SecondStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});				
							}
							elsif( $stack3 == 0){
								#step choice 3
								${VARspeed.$i}[$j] = $ThirdStepDirection;
								${VARxinb.$i}[$j] += $ThirdStepX;
								${VARyinb.$i}[$j] += $ThirdStepY;
								UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
								UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
								UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

								$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
							}
							else{  ###can't move #####		
								my $cannotmoveIcon = $canvas->createText(203+$VARxinb0[$j]-${VARxinb.$i}[$j],203+$VARyinb0[$j]-${VARyinb.$i}[$j], -text => "X", -font =>"Times 18 bold",-fill=>"red");
								$timer1 = AnyEvent->timer (after => 0.2, cb => sub{$canvas->delete($cannotmoveIcon);});

								#######################next ship move #################
								if($i < 9){
									$mw->after(1000, sub {
										$other_ship_to_move += 1;
										$other_ships_movable = 1;
									});
									# $mw->after(1000, [\&battle2_1, $i+1,$canvasleft->itemcget($target_index[$i+1] ,-text),$canvasleft->itemcget($ship_order[$i+1] ,-text)]);								
								}
								else{
									$mw->after(1000, sub {$VARmatename15[$j] = "me";UP_small_someone_from(VARmatename15 ,$VARmatename15[$j],$j,mates10to15);return; });
								}							
							}						
						}				
					}
					elsif(${VARspeed.$i}[$j]  == 5){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloser($i,$m,$distance1,$distance2,$distance3,$min_distance,4,0,-30,5,30,-15,6,30,15);				
					}
					elsif(${VARspeed.$i}[$j]  == 6){			        
						my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
						my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
						my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
						my @distances = ($distance1,$distance2,$distance3);
						my $min_distance = List::Util::min @distances;

						WhenFarMoveCloser($i,$m,$distance1,$distance2,$distance3,$min_distance,1,0,30,6,30,15,5,30,-15);				  
					}
					else{  
					}     
				}

				########### if   current distance <= 1.5 , move to farest step ################	
				if( $distanceim <= 1.5 * 30  ){   
					$continue = "yes";
					EscapeWhenClose($i,$m);
					sub EscapeWhenClose{
						my $i = shift;
						my $m = shift;
						
						if(${VARspeed.$i}[$j]  == 1){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
							my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
							my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
							my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
							my @distances = ($distance1,$distance2,$distance3);
							my $max_distance = List::Util::max @distances;

							MoveToUnblockedPosition($i,$m,$distance1,$distance2,$distance3,$max_distance,1,0,30,6,30,15,2,-30,15);
						}
						elsif(${VARspeed.$i}[$j]  == 2){	  #  my current coords = $VARxinb1[$j]  $VARyinb1[$j];target coords = $VARxb[$otherguy_num]  $VARyb[$otherguy_num] ;       
							my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
							my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
							my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
							my @distances = ($distance1,$distance2,$distance3);
							my $max_distance = List::Util::max @distances;

							MoveToUnblockedPosition($i,$m,$distance1,$distance2,$distance3,$max_distance,1,0,30,2,-30,15,3,-30,-15);
						}
						elsif(${VARspeed.$i}[$j]  == 3){			        
							my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
							my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
							my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
							my @distances = ($distance1,$distance2,$distance3);
							my $max_distance = List::Util::max @distances;

							MoveToUnblockedPosition($i,$m,$distance1,$distance2,$distance3,$max_distance,4,0,-30,3,-30,-15,2,-30,15);
						}
						elsif(${VARspeed.$i}[$j]  == 4){			        
							my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) );  
							my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) ) ;
							my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]-30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
							my @distances = ($distance1,$distance2,$distance3);
							my $max_distance = List::Util::max @distances;	
												
							sub StepStackCheck{       
								my $x = shift;
								my $y = shift;	
								my $stack = 0;
								for(my $k=0;$k<10;$k++){  
									if($x == ${VARxinb.$k}[$j] && $y == ${VARyinb.$k}[$j] ){
										$stack += 1;	
									}
									if($x == ${VARxinb.$k}[$otherguy_num] && $y == ${VARyinb.$k}[$otherguy_num] ){
										$stack += 1;	
									}
								}
								return($stack);
							}

							MoveToUnblockedPosition($i,$m,$distance1,$distance2,$distance3,$max_distance,5,30,-15,4,0,-30,3,-30,-15);	
							sub MoveToUnblockedPosition{
								my $i= shift;
								my $m= shift;

								my $distance1 = shift;
								my $distance2 = shift;
								my $distance3 = shift;	
								my $max_distance = shift;
								
								my $FirstStepDirection = shift;
								my $FirstStepX = shift;
								my $FirstStepY = shift;
								
								my $SecondStepDirection = shift;
								my $SecondStepX = shift;
								my $SecondStepY = shift;

								my $ThirdStepDirection = shift;
								my $ThirdStepX = shift;
								my $ThirdStepY = shift;

								my $stack1 = StepStackCheck(${VARxinb.$i}[$j] + $FirstStepX, ${VARyinb.$i}[$j] + $FirstStepY);
								my $stack2 = StepStackCheck(${VARxinb.$i}[$j] + $SecondStepX, ${VARyinb.$i}[$j] + $SecondStepY);
								my $stack3 = StepStackCheck(${VARxinb.$i}[$j] + $ThirdStepX, ${VARyinb.$i}[$j] + $ThirdStepY);	
								
								################max and movable##########
								if($max_distance == $distance1 && $stack1 == 0){
									#step choice 1
									${VARspeed.$i}[$j] = $FirstStepDirection;
									${VARxinb.$i}[$j] += $FirstStepX;
									${VARyinb.$i}[$j] += $FirstStepY;
									UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
									UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
									UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

									$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
								}
								elsif($max_distance == $distance2 && $stack2 == 0){
									#step choice 2
									${VARspeed.$i}[$j] = $SecondStepDirection;
									${VARxinb.$i}[$j] += $SecondStepX;
									${VARyinb.$i}[$j] += $SecondStepY;
									UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
									UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
									UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

									$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});				
								}
								elsif($max_distance == $distance3 && $stack3 == 0){
									#step choice 3
									${VARspeed.$i}[$j] = $ThirdStepDirection;
									${VARxinb.$i}[$j] += $ThirdStepX;
									${VARyinb.$i}[$j] += $ThirdStepY;
									UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
									UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
									UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

									$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
								}##################### only movable ###############
								elsif( $stack1 == 0){
									#step choice 1
									${VARspeed.$i}[$j] = $FirstStepDirection;
									${VARxinb.$i}[$j] += $FirstStepX;
									${VARyinb.$i}[$j] += $FirstStepY;
									UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
									UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
									UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

									$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
								}
								elsif( $stack2 == 0){
									#step choice 2
									${VARspeed.$i}[$j] = $SecondStepDirection;
									${VARxinb.$i}[$j] += $SecondStepX;
									${VARyinb.$i}[$j] += $SecondStepY;
									UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
									UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
									UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

									$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});				
								}
								elsif( $stack3 == 0){
									#step choice 3
									${VARspeed.$i}[$j] = $ThirdStepDirection;
									${VARxinb.$i}[$j] += $ThirdStepX;
									${VARyinb.$i}[$j] += $ThirdStepY;
									UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2);  
									UP_small_someone_from(${VARxinb.$i} ,${VARxinb.$i}[$j],$j,ships2);
									UP_small_someone_from(${VARyinb.$i} ,${VARyinb.$i}[$j],$j,ships2);

									$timer1 = AnyEvent->timer (after => 1, cb => sub{OthersMoveToClosestStep($i,$m);});
								}
								else{  ###can't move #####								
									my $cannotmoveIcon = $canvas->createText(203+$VARxinb0[$j]-${VARxinb.$i}[$j],203+$VARyinb0[$j]-${VARyinb.$i}[$j], -text => "X", -font =>"Times 18 bold",-fill=>"red");
									$timer1 = AnyEvent->timer (after => 0.2, cb => sub{$canvas->delete($cannotmoveIcon);});

									#######################next ship move #################
									if($i < 9){
										$mw->after(1000, sub {
											$other_ship_to_move += 1;
											$other_ships_movable = 1;
										});
										# $mw->after(1000, [\&battle2_1, $i+1,$canvasleft->itemcget($target_index[$i+1] ,-text),$canvasleft->itemcget($ship_order[$i+1] ,-text)]);									
									}
									else{
										$mw->after(1000, sub {$VARmatename15[$j] = "me";UP_small_someone_from(VARmatename15 ,$VARmatename15[$j],$j,mates10to15);return; });
										#$VARmatename15[$j] = "me";  ####switch to other player
										#UP;
										#return;
									}
								}	
							}						 
						}
						elsif(${VARspeed.$i}[$j]  == 5){			        
							my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-30) );  
							my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
							my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
							my @distances = ($distance1,$distance2,$distance3);
							my $max_distance = List::Util::max @distances;

							MoveToUnblockedPosition($i,$m,$distance1,$distance2,$distance3,$max_distance,4,0,-30,5,30,-15,6,30,15);	 
						}
						elsif(${VARspeed.$i}[$j]  == 6){			        
							my $distance1 = abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+30) );  
							my $distance2 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]+15) ) ;
							my $distance3 = abs(${VARxinb.$m}[$otherguy_num] - (${VARxinb.$i}[$j]+30)) + abs(${VARyinb.$m}[$otherguy_num] - (${VARyinb.$i}[$j]-15) ) ;
							my @distances = ($distance1,$distance2,$distance3);
							my $max_distance = List::Util::max @distances;

							MoveToUnblockedPosition($i,$m,$distance1,$distance2,$distance3,$max_distance,1,0,30,6,30,15,5,30,-15);
						}
						else{  
						}  
					} 
				}
										
				################## if distance 3 #################
				if( $distanceim > 1.5 * 30 && $distanceim <= 4.5 * 30){
					sub WhetherTargetAttackable{
						my $i = shift;
						my $TestDirection = shift;
						my $m = shift;
						my $attackable = 0;

						if($TestDirection  == 1 || $TestDirection  == 4){	 #test direction
								if(${VARxinb.$m}[$otherguy_num] == ${VARxinb.$i}[$j] +60 ){
									if(${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] + 30 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] - 30 ){
										$attackable += 1;		
									}						
								}
								if(${VARxinb.$m}[$otherguy_num] == ${VARxinb.$i}[$j] -60 ){
									if(${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] + 30 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] - 30 ){
										$attackable += 1;		
									}
								}
								if(${VARxinb.$m}[$otherguy_num] == ${VARxinb.$i}[$j] +90 ){
									if(${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] +15 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] - 15 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] + 45 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] - 45){
										$attackable += 1;			
									}
								}
								if(${VARxinb.$m}[$otherguy_num] == ${VARxinb.$i}[$j] -90 ){
									if(${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] +15 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] - 15 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] + 45 || ${VARyinb.$m}[$otherguy_num] == ${VARyinb.$i}[$j] - 45){
										$attackable += 1;			
									}	
								}
						}
						
						if($TestDirection  == 2 || $TestDirection  == 5){	 #current direction
							if(${VARxinb.$m}[$otherguy_num] >= ${VARxinb.$i}[$j] && ${VARyinb.$m}[$otherguy_num] > ${VARyinb.$i}[$j] ){
								$attackable += 1;		
							}
							if(${VARxinb.$m}[$otherguy_num] <= ${VARxinb.$i}[$j] && ${VARyinb.$m}[$otherguy_num] < ${VARyinb.$i}[$j]){
								$attackable += 1;
							}							
						}
						if($TestDirection  == 3 || $TestDirection  == 6){	 
							if(${VARxinb.$m}[$otherguy_num] >= ${VARxinb.$i}[$j] && ${VARyinb.$m}[$otherguy_num] < ${VARyinb.$i}[$j] ){
								$attackable += 1;
							}
						
							
							if(${VARxinb.$m}[$otherguy_num] <= ${VARxinb.$i}[$j] && ${VARyinb.$m}[$otherguy_num] > ${VARyinb.$i}[$j]){
								$attackable += 1;
							}		
						}					
						return($attackable);
					}

					if(${VARspeed.$i}[$j] > 1 && ${VARspeed.$i}[$j] < 6 ){
					
						my $attackable1 = WhetherTargetAttackable($i,${VARspeed.$i}[$j],$m);	
						my $attackable2 = WhetherTargetAttackable($i,${VARspeed.$i}[$j] + 1,$m);
						my $attackable3 = WhetherTargetAttackable($i,${VARspeed.$i}[$j] - 1,$m);
					
						if ($attackable1 == 1){
							$HaveShot = 1;
							OthersAttack($i,$m);	
						}
						elsif ($attackable2 == 1){
							$HaveShot = 1;
							${VARspeed.$i}[$j] = ${VARspeed.$i}[$j] + 1;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp11 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});	
						}
						else{
							$HaveShot = 1;
							${VARspeed.$i}[$j] = ${VARspeed.$i}[$j] - 1;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp12 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});	
						}
					}
					
					elsif(${VARspeed.$i}[$j] == 1){

						my $attackable1 = WhetherTargetAttackable($i,1,$m);	
						my $attackable2 = WhetherTargetAttackable($i,2,$m);
						my $attackable3 = WhetherTargetAttackable($i,6,$m);

						if ($attackable1 == 1){
							$HaveShot = 1;
							${VARspeed.$i}[$j] = 1;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp13 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});
						}
						elsif ($attackable2 == 1){
							$HaveShot = 1;
							${VARspeed.$i}[$j] = 2;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp13 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});	
						}
						else {
							$HaveShot = 1;
							${VARspeed.$i}[$j] = 6;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp14 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});	
						}		
					}

					else{   #  if(${VARspeed.$i}[$j] == 6)

						my $attackable1 = WhetherTargetAttackable($i,6,$m);	
						my $attackable2 = WhetherTargetAttackable($i,5,$m);
						my $attackable3 = WhetherTargetAttackable($i,1,$m);

						if ($attackable1 == 1){
							$HaveShot = 1;
							OthersAttack($i,$m);
						}
						elsif ($attackable2 == 1){
							$HaveShot = 1;
							${VARspeed.$i}[$j] = 5;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp15 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});	
						}
						else {
							$HaveShot = 1;
							${VARspeed.$i}[$j] = 1;
							UP_small_someone_from(${VARspeed.$i} ,${VARspeed.$i}[$j],$j,ships2); 
							$temp16 = AnyEvent->timer (after => 1.5, cb => sub{OthersAttack($i,$m);});
						}
					}

					sub OthersAttack{   
						my $i = shift; 
						my $m = shift;  
						my @durability=split(/</,${VARdurability.$m}[$otherguy_num]);
						$canvas->delete($pfocusinbattle1);
						
						##### send attacked signal to other guy #####
						$VARmatename15[$j] = "magoing$i$m";
						UP_small_someone_from(VARmatename15 ,$VARmatename15[$j],$j,mates10to15);
						
						##### show cannon moving #####
						$cannon = $mw->Photo(-file => 'images//z_others//'."cannon.png", -format => 'png',-width => 10,-height => 10 );
						
						$distance_x=${VARxinb.$i}[$j]-${VARxinb.$m}[$otherguy_num];
						$distance_y=${VARyinb.$i}[$j]-${VARyinb.$m}[$otherguy_num];

						$show_cannon1 = AnyEvent->timer (after => 0.5*1,  cb => sub{$cannon1=$canvas->createImage(203+$VARxinb0[$j]- ${VARxinb.$i}[$j]  +$distance_x/5,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+$distance_y/5,-image => $cannon);});
						$show_cannon2 = AnyEvent->timer (after => 0.5*2,  cb => sub{$canvas->coords($cannon1,203+$VARxinb0[$j]- ${VARxinb.$i}[$j]+2*$distance_x/5,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+2*$distance_y/5);});
						$show_cannon3 = AnyEvent->timer (after => 0.5*3,  cb => sub{$canvas->coords($cannon1,203+$VARxinb0[$j]- ${VARxinb.$i}[$j]+3*$distance_x/5,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+3*$distance_y/5);});
						$show_cannon4 = AnyEvent->timer (after => 0.5*4,  cb => sub{$canvas->coords($cannon1,203+$VARxinb0[$j]- ${VARxinb.$i}[$j]+4*$distance_x/5,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+4*$distance_y/5);});

						$mw->after(2500, [\&MiddleOfCannonAndShowHP, $i,$m]);

						sub MiddleOfCannonAndShowHP{
							my $i = shift; 
							my $m = shift; 
							@durability[0] -= 3;
							$durabilityadd=@durability[0]."<".@durability[1];
							${VARdurability.$m}[$otherguy_num]=$durabilityadd;
							UP_small_someone_from(${VARdurability.$m} ,${VARdurability.$m}[$otherguy_num],$otherguy_num,ships2);
			
							$canvas->delete($cannon1);
							my $durability_beforehit = $canvas->createText(203+$VARxinb0[$j]- ${VARxinb.$i}[$j]+$distance_x,203+$VARyinb0[$j]- ${VARyinb.$i}[$j]+$distance_y-30, -text => @durability[0]+3,-font =>"Times 12 bold",-fill=>"red");
							
							$show_cannon6 = AnyEvent->timer (after => 0.5,  cb => sub{$canvas->itemconfigure($durability_beforehit, -text => @durability[0]);});
							$show_cannon7 = AnyEvent->timer (after => 1,  cb => sub{$canvas->delete($durability_beforehit);});
						}
						
						#######################next ship move #################
						if($i < 9){
							$mw->after(4500, sub {
								$other_ship_to_move += 1;
								$other_ships_movable = 1;
							});
							# $mw->after(4500, [\&battle2_1, $i+1,$canvasleft->itemcget($target_index[$i+1] ,-text),$canvasleft->itemcget($ship_order[$i] ,-text)]);
						}
						else{
							$mw->after(6000, sub {$VARmatename15[$j] = "me";UP_small_someone_from(VARmatename15 ,$VARmatename15[$j],$j,mates10to15);return; });
							#$VARmatename15[$j] = "me";  ####switch to other player
							#UP;
							#return;
						}		
					} 			
				}  #if distance 1.5-4.5 
			  
			$distanceimAfter = abs(${VARyinb.$m}[$otherguy_num] - ${VARyinb.$i}[$j]) + abs(${VARxinb.$m}[$otherguy_num] - ${VARxinb.$i}[$j]);
		  
			}  #sub OthersMoveToClosestStep		
		}  #if($n eq "shoot"){	
	} 


1;	