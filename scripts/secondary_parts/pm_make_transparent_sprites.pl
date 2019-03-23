use Imager;

sub get_sprites {
	############ read image ###############
	my $img = Imager->new();                         
	$img->read(file=>'images//z_others//'.'CHAR.000  day.png',type=>'png');

	############ cut to sprites ###############
	my @img_croped = ();
	for my $k(0..1){
		for my $i(0..7){
			$img_croped[$i+$k*8] = $img->crop(left=>0+$i*32, top=>0+$k*32, width=>32, height=>32);  
		}
	}

	############ set background transparent ###############
	my $transparent_color = Imager::Color->new( 0, 0, 0, 0 );
	my $index_color;
	my $mid_color;

	for my $j(0..7){
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

	# ############ write file ###############
	# for $j(0..7){
		# $img_croped[$j*2]->write(file => '128'."$j".'.png');
	# }
	return \@img_croped;
}

# my @img_croped = @{get_sprites()};

# $img_croped[4]->write(file => '112.png');

1;

