use PDL;

sub get_port_piddle_and_image {
	my $port_map = shift;
	my $port_chip = shift;
	
	################ get port map piddle ####################
	# open handle
	open my $fh, '<:raw', "images//port//$port_map";  #029

	# read some bytes
	my $bytes_read = read($fh, my $bytes, 9216);
	close($fh);
	# Unpack bytes into variables
	my @numbers = unpack('C*', $bytes);

	# add 1 to each element in array
	my $length = @numbers;
	for(my $i=0;$i<$length;$i++){
		$numbers[$i] += 1;
	}

	my $piddle = pdl(@numbers);
	$piddle->reshape(96,96);	
	
	################ get port tileset images ####################
	
	my sub make_tile_set {   # make_tile_set(000,dawn);
		############ read image ###############
		my $img = Imager->new();                         
		$img->read(file=>'images//port//'.$port_chip.'  day.png',type=>'png');
		
		############ cut to tiles ###############
		my @img_croped = ();
		for my $k(0..15){
			for my $i(0..15){
				$img_croped[1+$i+$k*16] = $img->crop(left=>0+$i*16, top=>0+$k*16, width=>16, height=>16);  
			}
		}
	
		return \@img_croped;
	}
	
	my @port_tiles = @{make_tile_set()};	
	# $port_tiles[2]->write(file => '1_port_tile.png');
	
	######### make port map image #########
	use Imager;

	my $port_image = Imager->new(xsize => 96*16, ysize => 96*16, channels => 3);

	foreach my $r(0..95){
		foreach my $c(0..95){
			$port_image->paste(left=>0+$c*16, top=>0+$r*16, src=>$port_tiles[at($piddle,0+$c,0+$r)]);
		}
	}

	return ($piddle, $port_image);	
	
}

#($piddle, $port_image)  = get_port_piddle_and_image('PORTMAP.029', 'PORTCHIP.002');



1;