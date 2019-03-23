use experimental 'smartmatch';

################################### !key bindings ########################
	# ############### discrete movement #####################
	# $mw->bind("<Key-w>", \&up);   
	# $mw->bind("<Key-s>", \&down);
	# $mw->bind("<Key-a>", \&left);
	# $mw->bind("<Key-d>", \&right);

	# ############### continuous movement #####################
	# $mw->bind("<Up>", \&up_go_on);
	# $mw->bind("<Down>", \&down_go_on);
	# $mw->bind("<Left>", \&left_go_on);
	# $mw->bind("<Right>", \&right_go_on);

	$mw->bind("<Key-w>", \&up_go_on);
	$mw->bind("<Key-s>", \&down_go_on);
	$mw->bind("<Key-a>", \&left_go_on);
	$mw->bind("<Key-d>", \&right_go_on);
	
	

	$move_interval = 200;
	sub up_go_on {	
		if ( defined($move_down_timer) ) {
			$move_down_timer->cancel;	
			undef $move_down_timer;		
			$move_up_timer = $mw->repeat($move_interval, \&up); 	
		}
		elsif ( defined($move_left_timer) ) {
			$move_left_timer->cancel;	
			undef $move_left_timer;		
			$move_up_timer = $mw->repeat($move_interval, \&up); 	
		}
		elsif ( defined($move_right_timer) ) {
			$move_right_timer->cancel;	
			undef $move_right_timer;		
			$move_up_timer = $mw->repeat($move_interval, \&up); 	
		}			
		else {
			if ( defined($move_up_timer) ) {
				$move_up_timer->cancel;	
				undef $move_up_timer;		
			}
			else {
				$move_up_timer = $mw->repeat($move_interval, \&up); 	
			}
		}			
	}
	sub down_go_on {	
		if ( defined($move_up_timer) ) {
			$move_up_timer->cancel;	
			undef $move_up_timer;	
			$move_down_timer = $mw->repeat($move_interval, \&down); 			
		}
		elsif ( defined($move_left_timer) ) {
			$move_left_timer->cancel;	
			undef $move_left_timer;		
			$move_down_timer = $mw->repeat($move_interval, \&down);	
		}
		elsif ( defined($move_right_timer) ) {
			$move_right_timer->cancel;	
			undef $move_right_timer;		
			$move_down_timer = $mw->repeat($move_interval, \&down);	
		}			
		else {				
			if ( defined($move_down_timer) ) {
				$move_down_timer->cancel;	
				undef $move_down_timer;		
			}		
			else {
				$move_down_timer = $mw->repeat($move_interval, \&down); 	
			}	
		}			
	}
	sub left_go_on {	
		if ( defined($move_up_timer) ) {
			$move_up_timer->cancel;	
			undef $move_up_timer;	
			$move_left_timer = $mw->repeat($move_interval, \&left); 			
		}
		elsif ( defined($move_down_timer) ) {
			$move_down_timer->cancel;	
			undef $move_down_timer;		
			$move_left_timer = $mw->repeat($move_interval, \&left); 	
		}
		elsif ( defined($move_right_timer) ) {
			$move_right_timer->cancel;	
			undef $move_right_timer;		
			$move_left_timer = $mw->repeat($move_interval, \&left); 	
		}			
		else {				
			if ( defined($move_left_timer) ) {
				$move_left_timer->cancel;	
				undef $move_left_timer;		
			}		
			else {
				$move_left_timer = $mw->repeat($move_interval, \&left); 	
			}	
		}			
	}
	sub right_go_on {	
		if ( defined($move_up_timer) ) {
			$move_up_timer->cancel;	
			undef $move_up_timer;	
			$move_right_timer = $mw->repeat($move_interval, \&right); 			
		}
		elsif ( defined($move_down_timer) ) {
			$move_down_timer->cancel;	
			undef $move_down_timer;		
			$move_right_timer = $mw->repeat($move_interval, \&right); 	
		}
		elsif ( defined($move_left_timer) ) {
			$move_left_timer->cancel;	
			undef $move_left_timer;		
			$move_right_timer = $mw->repeat($move_interval, \&right); 	
		}
		else {				
			if ( defined($move_right_timer) ) {
				$move_right_timer->cancel;	
				undef $move_right_timer;		
			}		
			else {
				$move_right_timer = $mw->repeat($move_interval, \&right); 	
			}	
		}			
	}
	
	
	
	
	

############### !send_move_command(up/left..) #####################
sub send_move_command {    
	my $direction = shift;
	print $handle "$direction\n";   
}

############### !subs up/down/left/right #####################
@walkabale_tiles = (1..31);
@sailable_tiles = (1..31);
		
sub up{		
	if($mp[$j] ne "sea"){
		if($canvas->itemcget($pship, -image) == $p_player_up_1){	
			$canvas->itemconfigure($pship,-image => $p_player_up_2); 
		}
		else{
			$canvas->itemconfigure($pship,-image => $p_player_up_1); 
		}
					
		######### move if no collision ############
		if( at($piddle, $cx[$j]/16, $cy[$j]/16) ~~ @walkabale_tiles && at($piddle, $cx[$j]/16 + 1, $cy[$j]/16) ~~ @walkabale_tiles){
			if ( $cy[$j] > 0  ) {
				send_move_command(up);
			}
		}		
	}
	if($mp[$j] eq "sea"){
		$canvas->itemconfigure($pship,-image => $p2_up); 
			
		######### move if no collision ############ 
		if( at($big_piddle_new, $cx[$j]/16, $cy[$j]/16 - 1) ~~ @sailable_tiles){
			
			send_move_command(up);	
				
		}
	}
}

sub down{	
	if($mp[$j] ne "sea"){
		if($canvas->itemcget($pship, -image) == $p_player_down_1){	
			$canvas->itemconfigure($pship,-image => $p_player_down_2); 
		}
		else{
			$canvas->itemconfigure($pship,-image => $p_player_down_1); 
		}
		
		######### move if no collision ############
		if( at($piddle, $cx[$j]/16, $cy[$j]/16 + 2) ~~ @walkabale_tiles && at($piddle, $cx[$j]/16 + 1, $cy[$j]/16 + 2) ~~ @walkabale_tiles){
			if ( $cy[$j] < 1504  ) {
				send_move_command(down);
			}
		}				
	}
			
	if($mp[$j] eq "sea"){
		$canvas->itemconfigure($pship,-image => $p2_down); 
				
		######### move if no collision ############  && at($sea_piddle, $sea_piddle_x + 1, $sea_piddle_y + 2) ~~ @sailable_tiles
		if( at($big_piddle_new, $cx[$j]/16, $cy[$j]/16 + 2) ~~ @sailable_tiles){
			send_move_command(down);
		}	
	}
}

sub left{	
	if($mp[$j] ne "sea"){
		if($canvas->itemcget($pship, -image) == $p_player_left_1){	
			$canvas->itemconfigure($pship,-image => $p_player_left_2); 
		}
		else{
			$canvas->itemconfigure($pship,-image => $p_player_left_1); 
		}
		
		######### move if no collision ############
		if( at($piddle, $cx[$j]/16 - 1, $cy[$j]/16 + 1) ~~ @walkabale_tiles ){
			if ( $cx[$j] > 0  ) {
				send_move_command(left);	##do UP; 
			}
		}				
	}
	
	if($mp[$j] eq "sea"){
		$canvas->itemconfigure($pship,-image => $p2_left); 
		
		######### move if no collision ############
		if( at($big_piddle_new, $cx[$j]/16 - 1, $cy[$j]/16 + 1) ~~ @sailable_tiles ){
			send_move_command(left);	##do UP; 
		}		
	}
}

sub right{	
	if($mp[$j] ne "sea"){
		if($canvas->itemcget($pship, -image) == $p_player_right_1){	
			$canvas->itemconfigure($pship,-image => $p_player_right_2); 
		}
		else{
			$canvas->itemconfigure($pship,-image => $p_player_right_1); 
		}
		
		######### move if no collision ############
		if( at($piddle, $cx[$j]/16 + 2, $cy[$j]/16 + 1) ~~ @walkabale_tiles ){
			if ( $cx[$j] < 1504  ) {
				send_move_command(right);	 		##do UP;   
			}	
		}				
	}
		
	if($mp[$j] eq "sea"){
		$canvas->itemconfigure($pship,-image => $p2_right); 
				
		######### move if no collision ############
		if( at($big_piddle_new, $cx[$j]/16 + 2, $cy[$j]/16 + 1) ~~ @sailable_tiles ){
			send_move_command(right);	 		##do UP;
		}
	}
}	
	

1;	
