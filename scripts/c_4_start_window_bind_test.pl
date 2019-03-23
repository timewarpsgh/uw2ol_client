########  !main window ##############	
# hide_console;
 
# $mw = MainWindow->new;

$mw->overrideredirect (0);

if($j == 1){
	$mw->geometry ('644x420+0+200'); 	# 644x420+0+50	  #  950x600+0+50
}
if($j == 2){
	$mw->geometry ('644x420+640+200');
}

$mw->title("Uncharted Waters 2 Online");



$mw->focus(-force);	
	
########  change icon ( tricky ) ##############
# my $photo = $mw->Photo(-file => 'ship4.ico' );


# $mw->iconimage($photo);


# my $xpm = $mw->Photo(-file => 'wheel.xpm', -format => 'xpm');
# $mw->Icon(-image => $xpm);

# my $xpm = $mw->Photo(-file => 'ship.gif', -format => 'gif');

# $mw->Icon(-image => $xpm);   
	
########  !bind test ##############
$mw->bind("<Key-t>", \&test);
	

1;	