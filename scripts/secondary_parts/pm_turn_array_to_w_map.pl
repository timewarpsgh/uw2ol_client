use File::Slurp;
use PDL;
use PDL::NiceSlice;

use Cwd qw(getcwd);
use File::Spec::Functions qw( canonpath );
push(@INC, canonpath(getcwd()));

use Imager;

sub make_9_blocks_map {
	my $x = shift;
	my $y = shift;

	########### columns and rows  ###############
	my $collums = 12*2*30;
	my $rows = 12*2*45;

	########### get piddle from txt  ###############
	my $buffer = read_file("w_map_piddle_array.txt");
	my @a = split(',',$buffer);
	my $big_piddle_new = pdl(@a);
	$big_piddle_new->reshape($collums, $rows);


	########### small piddle size  ###############
	my $collums_small = 12*2*3;
	my $rows_small = 12*2*3;

	########### x,y 2 current 9 blocks  ###############
	my sub x_y_2_current_blocks {	# x_y_2_current_blocks(x,y,$piddle);
		my $x = shift;
		my $y = shift;
		my $p = shift;
		
		$p = $p( (int($x/24)-1)*24 :(int($x/24)+2)*24-1, (int($y/24)-1)*24 :(int($y/24)+2)*24-1);
		
		return $p;
	}

	my $small_piddle = x_y_2_current_blocks($x,$y,$big_piddle_new);
	#my $small_piddle = $big_piddle_new(0:12*2*3-1,0:12*2*3-1);

	########### get regular tiles  ###############
	sub make_regular_tiles {   # my @regular_tiles = make_tile_set('DATA1.011','day');		
		############ read image ###############
		my $img = Imager->new();                         
		$img->read(file=>'images//z_others//'.'w_map regular tileset.png',type=>'png');

		############ cut to tiles ###############
		my @img_croped = ();
		for my $k(0..7){
			for my $i(0..15){
				$img_croped[1+$i+$k*16] = $img->crop(left=>0+$i*16, top=>0+$k*16, width=>16, height=>16);  
			}
		}
		
		return \@img_croped;
	}
	my @regular_tiles = @{make_regular_tiles()};	
	
	# $regular_tiles[4]->write(file => '128.png');
	
	########### make block image  ###############	
	my $block_image = Imager->new(xsize => $collums_small*16, ysize => $rows_small*16, channels => 3);

	foreach my $r(0..($rows_small-1)){
		foreach my $c(0..($collums_small-1)){
			$block_image->paste(left=>0+$c*16, top=>0+$r*16, src=>$regular_tiles[at($small_piddle,0+$c,0+$r)]);
		}
	}
	#$block_image->write(file => '130.png');
	
	return ($small_piddle, $block_image);
}
 # my $block_image = make_9_blocks_map();
 # $block_image->write(file => '130.png');
1;