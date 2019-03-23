	################################## !load photoes #########################################
	sub image2data {
		my $image = shift;
		my $data;
		
		$image->write(data => \$data, type => 'png');
		$data = encode_base64($data);
		
		return $data;
	}

	######## others ########
	$cover_gif = $mw->Photo(-file => 'images//z_others//'."cover.gif", -format => 'gif',-width => 145,-height => 196 );
	$mate_info_gif = $mw->Photo(-file => 'images//z_others//'."mate_info.gif", -format => 'gif',-width => 345,-height => 354 );
	$market_options_gif = $mw->Photo(-file => 'images//z_others//'."market_options.gif", -format => 'gif',-width => 116,-height => 194 );
	$bar_meet_png = $mw->Photo(-file => 'images//z_others//'."bar_meet.png", -format => 'png',-width => 313,-height => 143 );
	$bar_girl_png = $mw->Photo(-file => 'images//z_others//'."bar_girl.png", -format => 'png',-width => 312,-height => 146 );
	$battle_left_png = $mw->Photo(-file => 'images//z_others//'."battle_left.png", -format => 'png',-width => 1188,-height => 656  );

	####### world map ########

		####### get world map regular tiles ###############
			####### read image ###############
			my $img = Imager->new();                         
			$img->read(file=>'images//z_others//'.'w_map regular tileset.png',type=>'png');

			####### cut to tiles ###############
			@img_croped = ();
			for my $k(0..7){
				for my $i(0..15){
					$img_croped[1+$i+$k*16] = $img->crop(left=>0+$i*16, top=>0+$k*16, width=>16, height=>16);  
				}
			}
		####### get world map piddle ###############
			###### columns and rows  ###############
			my $collums = 12*2*30*3;
			my $rows = 12*2*45;
			
			###### get piddle from txt  ###############
			my $buffer = read_file('images//z_others//'."w_map_piddle_array.txt");
			my @a = split(',',$buffer);
			$big_piddle_new = pdl(@a);
			$big_piddle_new->reshape($collums, $rows);
		
		############ get small world map ###############
		# $sea_gif = $mw->Photo(-file => 'images//z_others//'."map1.gif", -format => 'gif',-width => 1188,-height => 656 );
		# login_bg.PNG
		$sea_gif = $mw->Photo(-file => 'images//z_others//'."login_bg.PNG", -format => 'png',-width => 522,-height => 375 );
		
	
	######## right and left canvas ########
		###### sea ######
		$sea_left_gif = $mw->Photo(-file => 'images//z_others//'."left1.gif", -format => 'gif',-width => 96,-height => 406 );
		$pright_sea = $mw->Photo(-file => 'images//z_others//'."right1.gif", -format => 'gif',-width => 162,-height => 406 );

		###### port ######
		$port_left_png = $mw->Photo(-file => 'images//z_others//'."port_left.png", -format => 'png',-width => 96,-height => 403 );
		$pright_port = $mw->Photo(-file => 'images//z_others//'."port_right.png", -format => 'png',-width => 158,-height => 403 );

	######## npc ########	
		my @npc_sprites = @{get_npcs()};
	
		######## animations for static npcs ########
		my sub make_npcs_animation {  # $animation = make_ships_animation(16,18);
				my $first = shift;
				my $second = shift;
			
				my $data = image2data($npc_sprites[$first]);
				my $p2_up_sprite_1 = $mw->Photo(-data => $data, -format => 'png',-width => 36,-height => 36 );
				
				my $data = image2data($npc_sprites[$second]);
				my $p2_up_sprite_2 = $mw->Photo(-data => $data, -format => 'png',-width => 36,-height => 36 );
				
				my $p2_up = $mw->Animation();
				push(my @p2_up_images, $p2_up_sprite_1, $p2_up_sprite_2, $p2_up_sprite_2, $p2_up_sprite_1, $p2_up_sprite_2);
				$p2_up->add_frame(@p2_up_images);
				 
				$p2_up->set_disposal_method(1);
				$p2_up->start_animation(300);	
			
				return $p2_up;
		}
		
		$npc_by_marcket_animation = make_npcs_animation(32,34);	
		$npc_by_bar_animation = make_npcs_animation(36,38);	
		$npc_by_inn_animation = make_npcs_animation(44,46);	
	
		######## images for moving npcs ########
			my sub make_images_for_moving_npcs {	#  make_images_for_moving_npcs(0, 2, 'p_moving_npc_lady_up_1', 'p_moving_npc_lady_up_2');
				my $sprite_1_num = shift;
				my $sprite_2_num = shift;	

				my $produced_photo_1 = shift;	
				my $produced_photo_2 = shift;			
			
				my $data = image2data($npc_sprites[$sprite_1_num]);
				${$produced_photo_1} = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32);
				my $data = image2data($npc_sprites[$sprite_2_num]);
				${$produced_photo_2} = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32);
			}
			
			######## lady ########
			make_images_for_moving_npcs(0, 2, 'p_moving_npc_lady_up_1', 'p_moving_npc_lady_up_2');
			make_images_for_moving_npcs(4, 6, 'p_moving_npc_lady_right_1', 'p_moving_npc_lady_right_2');
			make_images_for_moving_npcs(8, 10, 'p_moving_npc_lady_down_1', 'p_moving_npc_lady_down_2');
			make_images_for_moving_npcs(12, 14, 'p_moving_npc_lady_left_1', 'p_moving_npc_lady_left_2');
			
			######## man ########
			make_images_for_moving_npcs(16, 18, 'p_moving_npc_man_up_1', 'p_moving_npc_man_up_2');
			make_images_for_moving_npcs(20, 22, 'p_moving_npc_man_right_1', 'p_moving_npc_man_right_2');
			make_images_for_moving_npcs(24, 26, 'p_moving_npc_man_down_1', 'p_moving_npc_man_down_2');
			make_images_for_moving_npcs(28, 30, 'p_moving_npc_man_left_1', 'p_moving_npc_man_left_2');

	######## player ########
		######## ship on sea ########
		my @ships_at_sea_sprites = @{get_ships_at_sea_sprites()};

		my sub make_ships_animation {  # $animation = make_ships_animation(16,18);
			my $first = shift;
			my $second = shift;
		
			my $data = image2data($ships_at_sea_sprites[$first]);
			my $p2_up_sprite_1 = $mw->Photo(-data => $data, -format => 'png',-width => 36,-height => 36 );
			
			my $data = image2data($ships_at_sea_sprites[$second]);
			my $p2_up_sprite_2 = $mw->Photo(-data => $data, -format => 'png',-width => 36,-height => 36 );
			
			my $p2_up = $mw->Animation();
			push(my @p2_up_images, $p2_up_sprite_1, $p2_up_sprite_2);
			$p2_up->add_frame(@p2_up_images);
			 
			$p2_up->set_disposal_method(1);
			$p2_up->start_animation(500);	
		
			return $p2_up;
		}
		
		$p2_up = make_ships_animation(16,18);		
		$p2_down = make_ships_animation(24,26);
		$p2_left = make_ships_animation(28,30);
		$p2_right = make_ships_animation(20,22);
		
		
		######## person in port ########		
		my @sprites = @{get_sprites()};

		my $data = image2data($sprites[0]);
		$p_player_up_1 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32);
		my $data = image2data($sprites[2]);
		$p_player_up_2 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32);

		my $data = image2data($sprites[8]);
		$p_player_down_1 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32 );
		my $data = image2data($sprites[10]);
		$p_player_down_2 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32 );
		
			
		my $data = image2data($sprites[12]);
		$p_player_left_1 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32 );
		my $data = image2data($sprites[14]);
		$p_player_left_2 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32 );
		
		
		my $data = image2data($sprites[4]);
		$p_player_right_1 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32 );
		my $data = image2data($sprites[6]);
		$p_player_right_2 = $mw->Photo(-data => $data, -format => 'png',-width => 32,-height => 32 );
		
		######## ship in battle ########
		$pshipinbattle_up = $mw->Photo(-file => 'images//z_others//'."shipinbattle_up.png", -format => 'png',-width => 30,-height => 34 );
		$pshipinbattle_upright = $mw->Photo(-file => 'images//z_others//'."shipinbattle_upright.png", -format => 'png',-width => 37,-height => 37 );
		$pshipinbattle_upleft = $mw->Photo(-file => 'images//z_others//'."shipinbattle_upleft.png", -format => 'png',-width => 37,-height => 37 );
		$pshipinbattle_down = $mw->Photo(-file => 'images//z_others//'."shipinbattle_down.png", -format => 'png',-width => 37,-height => 37 );
		$pshipinbattle_downright = $mw->Photo(-file => 'images//z_others//'."shipinbattle_downright.png", -format => 'png',-width => 37,-height => 37 );
		$pshipinbattle_downleft = $mw->Photo(-file => 'images//z_others//'."shipinbattle_downleft.png", -format => 'png',-width => 37,-height => 37 );

		$pshipinbattlelist[0]=$pshipinbattle_up;
		$pshipinbattlelist[1]=$pshipinbattle_up;
		$pshipinbattlelist[2]=$pshipinbattle_upright;
		$pshipinbattlelist[3]=$pshipinbattle_downright;
		$pshipinbattlelist[4]=$pshipinbattle_down;
		$pshipinbattlelist[5]=$pshipinbattle_downleft;
		$pshipinbattlelist[6]=$pshipinbattle_upleft;
	
	######## ships images ########
	my sub load_ship_images {
		my $ship_name = shift;
		${$ship_name} = $mw->Photo(-file => 'images//ships//'."$ship_name.png" );
	
	}
	
	load_ship_images(atakabune);
	load_ship_images(balsa);
	load_ship_images(barge);
	load_ship_images(brigantine);
	load_ship_images(buss);
	
	load_ship_images('caravela latina');
	load_ship_images('caravela redonda');
	load_ship_images(carrack);
	load_ship_images(dhow);
	load_ship_images('flemish galleon');
	
	load_ship_images(frigate);
	load_ship_images('full rigged ship');
	load_ship_images(galleon);
	load_ship_images('hansa cog');
	load_ship_images(junk);
	
	load_ship_images(kansen);
	load_ship_images('la reale');
	load_ship_images('light galley');
	load_ship_images(nao);
	load_ship_images(pinnace);
	
	load_ship_images(sloop);
	load_ship_images(tallette);
	load_ship_images(tekkousen);
	load_ship_images('venetian galeass');
	load_ship_images(xebec);
		
	######## menu ########
	$buy_menu1 = $mw->Photo(-file => 'images//z_others//'."buy_menu1.png", -format => 'png',-width => 368,-height => 156 );
	$fleet_info_photo = $mw->Photo(-file => 'images//z_others//'."fleet_info.gif", -format => 'gif',-width => 640,-height => 403 );

	
	
	
	
1;	