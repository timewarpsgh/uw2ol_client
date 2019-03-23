################# !connect to gate server ########################
use IO::Socket;

my $linea;
$EOL = "\015\012";  

$handle = IO::Socket::INET->new(Proto     => "tcp",
								PeerAddr  => "$connect_address" ,  # 3s.net579.com:28925
								PeerPort  => "$connect_port") # 8080
			   || die "can't connect to port $port on $host: $!";
$handle->autoflush(1);  

############ !get one message from server  (hello client) ##############
while(<$handle>){            
	print "$_\n";
	last;
}
	
########  login window ##############
	########  start window ############## 
	$mw = MainWindow->new;
	# hide_console;
	$mw->overrideredirect (0);
	$mw->geometry ('644x420+0+200'); 
	$mw->title("Uncharted Waters 2 Online");
	$mw->focus(-force);	
	
	my $login_canvas =$mw->Canvas(-background => "white",-width => 643,-height => 405,-highlightthickness => 0)->place(-x => 0, -y => 0);   # -x => 305, -y => 179
	my $login_bg_image = $mw->Photo(-file => 'images//z_others//'."login_bg.png", -format => 'png',-width => 643,-height => 405 );
	$login_canvas->createImage( 321,202, -image => $login_bg_image);

	######## display entry box ##############
		########  account box ##############
		my $account;
		my $entrybox1 = $mw->Entry(-textvariable => \$account,-width => 20)->place(-x => 400, -y => 180);
		$entrybox1->focus;
	
		######## password box ##############
		my $password;
		my $entrybox2 = $mw->Entry(-textvariable => \$password,-width => 20, -show => '*')->place(-x => 400, -y => 230);
		$entrybox2->focus;
			
		######## make text widget ##############
		$login_text_widget = $login_canvas->createText(415, 280, -text  => "Login", -font =>"Times 12 bold");
		$register_text_widget = $login_canvas->createText(495, 280, -text  => "Register", -font =>"Times 12 bold");
	
		################# bind enter ########################
		my $wrong_ac_pwd_alert;
		my sub login { 
			######## disable register button by moving it ##############
			$login_canvas->coords($login_text_widget, 2000, 2000);
			$mw->after(1000, sub {
				$login_canvas->coords($login_text_widget, 415, 280);
			});
		
			################# delete wrong input alert ########################
			$login_canvas->delete($wrong_ac_pwd_alert);
		
			################# get account and password ########################	
			my $ap= "$account".' '."$password";	
			print $ap, "\n";
			@b=split(" ",$ap);
				
			################# login to gate server and sub send_command ########################
			sub send_command {    
				my $command = shift;
				print $handle "$command";			
			}
					
			############ send login info and get j ##############		
			$j = command_get("login $ap");
			chomp($j);
			print "jjjjj $j jjjj   \n";
			
			############ !sub send command and wait for reply ##############
			sub command_get {    
				my $command = shift;
				my $retrun;

				print $handle "$command\n";
				
				while(<$handle>){            
					$return = $_;
					last;
				}
				return($return);			
			}

			############# decide to enter UI or exit #################
			if($j==undef){
				$wrong_ac_pwd_alert = $login_canvas->createText(450, 150, -text  => "Wrong account or pwd", -font =>"Times 12 bold");					
			}
			else {
				############# delete stuff #################
				$login_canvas->delete($login_text_widget);	
				$login_canvas->delete($register_text_widget);		
				$entrybox1->destroy;
				$entrybox2->destroy;
			
				$login_canvas->createText(420, 200, -text  => "Loading. . .", -font =>"Times 12 bold");

				############# get starting data and start UI #################
				$mw->after(3000, sub {   # 3000 ms
					############# get starting data #################
					print "connecting to redis \n";
					$redis = Redis->new( reconnect => 5, every => 200_000, server => "$redis_in_connect" );		# localhost:6379  # 3s.net579.com:14804
			
					$id = command_get(id); 
					chomp($id);
										
					print "idididdid $id idididid \n";

					print "connected to redis \n";

					############ show test text ##############
					my $initial_ca_cp_mp_cx_cy_zy = command_get(initial_ca_cp_mp_cx_cy_zy); 
					
					my $json = JSON->new->allow_nonref;
					my $perl_arrayref = $json->decode($initial_ca_cp_mp_cx_cy_zy);
					
					@ca = @{$perl_arrayref->[0]};
					@cp = @{$perl_arrayref->[1]}; 
					@mp = @{$perl_arrayref->[2]};
					@cx = @{$perl_arrayref->[3]};
					@cy = @{$perl_arrayref->[4]};
					@zy = @{$perl_arrayref->[5]};	
											
					############# UI #################
					require 'scripts\\c_UI.pl';		
				});			
			}
		}	
		$mw->bind('<Return>', \&login);
			
	######## Login and Register ##############
		# ######## make text widget ##############
		# my $login_text_widget = $login_canvas->createText(415, 280, -text  => "Login", -font =>"Times 12 bold");
		# my $register_text_widget = $login_canvas->createText(495, 280, -text  => "Register", -font =>"Times 12 bold");
	
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
		
		bind_motion_leave_canvas($login_text_widget, $login_canvas);
		bind_motion_leave_canvas($register_text_widget, $login_canvas);
		
		######### bind click ############
			######### login ############
			$login_canvas->bind( $login_text_widget,"<Button-1>", \&login );
	
			######### register ############
			$login_canvas->bind($register_text_widget,"<Button-1>", sub {
				######### rebind return key ############
				$mw->bind('<Return>', sub{});
			
				######### make register canvas ############
				my $register_canvas = $mw->Canvas(-background => "white",-width => 643,-height => 405,-highlightthickness => 0)->place(-x => 0, -y => 0);   # -x => 305, -y => 179
				$register_canvas->createImage( 321,202, -image => $login_bg_image);

				######### make entry boxes ############
					########  register_account box ##############
					my $register_account;
					my $entrybox3 = $register_canvas->Entry(-textvariable => \$register_account,-width => 20)->place(-x => 400, -y => 130);
					$entrybox3->focus;
				
				    $register_canvas->createText(370, 135, -text  => "Account", -font =>"Times 12 bold");

					######## register_password box ##############
					my $register_password;
					my $entrybox4 = $register_canvas->Entry(-textvariable => \$register_password,-width => 20, -show => '*')->place(-x => 400, -y => 180);
					$entrybox4->focus;	
					
					$register_canvas->createText(370-5, 135+50, -text  => "Password", -font =>"Times 12 bold");
					
					######## register_character_name box ##############
					my $register_character_name;
					my $entrybox5 = $register_canvas->Entry(-textvariable => \$register_character_name,-width => 20 )->place(-x => 400, -y => 230);
					$entrybox5->focus;	

					$register_canvas->createText(370-28, 135+50*2, -text  => "Character Name", -font =>"Times 12 bold");		
					
				######## Submit and Cancel ##############
					######## make text widget ##############
					my $submit = $register_canvas->createText(415, 280, -text  => "Submit", -font =>"Times 12 bold");
					my $cancel = $register_canvas->createText(495, 280, -text  => "Cancel", -font =>"Times 12 bold");
					
					######## bind_motion_leave ##############
					bind_motion_leave_canvas($submit, $register_canvas);
					bind_motion_leave_canvas($cancel, $register_canvas);
					
					######## bind click ##############
						######## initilize 3 alert responses ##############
						my $account_response = $register_canvas->createText(2000, 135, -text  => "Used!", -font =>"Times 12 bold");
						my $pwd_response = $register_canvas->createText(2000, 135+50, -text  => "OK!", -font =>"Times 12 bold");
						my $p_name_response = $register_canvas->createText(2000, 135+50*2, -text  => "Used!", -font =>"Times 12 bold");

						######## submit ##############
						$register_canvas->bind($submit,"<Button-1>", sub {
							######## disable register button by moving it ##############
							$register_canvas->coords($submit, 2000, 2000);
							$mw->after(1000, sub {
								$register_canvas->coords($submit, 415, 280);
							});
						
							# ######## judge input ##############
							# my $register_info;
							
							if ( $register_account eq '' || $register_password eq '' || $register_character_name eq '' ) {
								
								$register_account = 'empty!';
								$register_password = 'empty!';
								$register_character_name = 'Alice';
							}
							
							######## combine input to one string ##############
							my $register_info = "$register_account".' '."$register_password".' '."$register_character_name";
							print "$register_info\n";

							############ send and get ##############
							# my $got_message;
							# $mw->after(1000, sub {
							
							my $got_message = command_get("register $register_info");
							
							# });
							
							my $json = JSON->new->allow_nonref;
							my $array_ref = $json->decode($got_message);
							
							$mw->after(1000, sub {
								print "@{$array_ref}\n";	
							});
							
							my @got_response = @{$array_ref};
							
							############ if registration fails ##############
							if ( @got_response[0] == 1 || @got_response[1] == 1 ) {
								############ account_response ##############
								if ( @got_response[0] == 1 ) {
									$register_canvas->itemconfigure($account_response , -text  => "X");
									$register_canvas->coords($account_response, 370+180, 135); 
								}
								else {
									$register_canvas->itemconfigure($account_response , -text  => "OK");
									$register_canvas->coords($account_response, 370+180, 135); 
								}
							
								############ pwd_response ##############
								$register_canvas->itemconfigure($pwd_response , -text  => "OK");
								$register_canvas->coords($pwd_response, 370+180, 135+50); 
							
								############ p_name_response ##############
								if ( @got_response[1] == 1 ) {
									$register_canvas->itemconfigure($p_name_response , -text  => "X");
									$register_canvas->coords($p_name_response, 370+180, 135+50*2); 								
								}
								else {
									$register_canvas->itemconfigure($p_name_response , -text  => "OK");
									$register_canvas->coords($p_name_response, 370+180, 135+50*2); 
								}
							}	
							############ if registration succeeds ##############
							else {
								######### delete register canvas ############
								$register_canvas->destroy;	
								
								######### make success canvas ############
									######### make canvas ############
									my $sucess_canvas = $mw->Canvas(-background => "white",-width => 643,-height => 405,-highlightthickness => 0)->place(-x => 0, -y => 0);   # -x => 305, -y => 179
									$sucess_canvas->createImage( 321,202, -image => $login_bg_image);
									
									######### make texts ############
									$sucess_canvas->createText(415, 220, -text  => "Registration Successful!", -font =>"Times 12 bold");
									
									my $OK = $sucess_canvas->createText(415, 260, -text  => "OK", -font =>"Times 12 bold");
									bind_motion_leave_canvas($OK, $sucess_canvas);
									$sucess_canvas->bind($OK,"<Button-1>", sub {
										$sucess_canvas->destroy;	
									});		
							}	
						});
					
						######## cancel ##############
						$register_canvas->bind($cancel,"<Button-1>", sub {
							$register_canvas->destroy;														
						});
					

					
			});

		
		
		

MainLoop;



	