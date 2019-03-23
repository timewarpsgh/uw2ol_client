sub enter_village {
	my $response = command_get(enter_village); 	
	$response = substr($response,0,-1);
	
	if($response eq "0\n"){
	} 
	else{
		print "$response \n";
	}







}

1;