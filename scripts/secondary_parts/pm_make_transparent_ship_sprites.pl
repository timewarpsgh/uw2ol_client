use Imager;

sub get_ships_at_sea_sprites {
	############ read image ###############
	my $img = Imager->new();                         
	$img->read(file=>'images//z_others//'.'ships_sprites.png',type=>'png');
	$img = $img->convert(preset=>'addalpha');
	
	############ cut to sprites ###############
	my @img_croped = ();
	for my $k(0..7){
		for my $i(0..7){
			$img_croped[$i+$k*8] = $img->crop(left=>0+$i*32, top=>0+$k*32, width=>32, height=>32);  
		}
	}

	############ set background transparent ###############
	my $transparent_color = Imager::Color->new( 0, 0, 0, 0 );
	my $index_color;
	my $mid_color;

	for my $j(0..31){
		$mid_color = $img_croped[$j*2+1]->getpixel(x=>0, y=>0);
		for $k(0..31){
			for $i(0..31){
				$index_color = $img_croped[$j*2+1]->getpixel(x=>$i, y=>$k);
				if ( $index_color->equals(other=>$mid_color) ) {		
					$img_croped[$j*2]->setpixel(x=>$i, y=>$k, color=>$transparent_color);			
				}		
			}
		}
	}	

	
	
	############ write file ###############
	# for $j(0..31){
		# $img_croped[$j*2]->write(file => '128'."$j".'.png');
	# }
	return \@img_croped;
}

# my @img_croped = @{get_sprites()};

# $img_croped[16]->write(file => '1.png'); 	#up
# $img_croped[22]->write(file => '2.png');	#right
# $img_croped[24]->write(file => '3.png');	#down
# $img_croped[30]->write(file => '4.png');	#left

1;

