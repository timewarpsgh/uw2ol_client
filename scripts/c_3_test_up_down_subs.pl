	###########  *test  (key t in background) ###########
	sub test {
		$canvasleft->delete($temp);
		
		my $a = $cx[$j]/16;
		my $b = $cy[$j]/16;
		# my $c = at($piddle, $a - 1, $b + 1);
		my $temp = $canvasleft->createText(65,300,-text => "@ai_x_y");
	}

	###########  *up/down  ###########

	########### !subs DOWN ############ 
	sub DOWN_small{ 		# @dd = DOWN_small(VARclass0,ships2);
		my $a = shift;
		my $b = shift;
		my @c;

		for($i=1;$i<$id+1;$i++){
			@c[$i] = $redis->hget("$i:$b", $a); 
		}

		return(@c);
	}

	sub DOWN_small_pipe{ 		# @dd = DOWN_small_pipe(VARclass0,ships2);
		my $a = shift;
		my $b = shift;
		my @c;

		for($i=1;$i<$id+1;$i++){
			@c[$i] = $redis->hget("$i:$b", $a, sub {
				my ($reply, $error) = @_;
				push(@d, $reply);
			}); 
		}

		return(@c);
	}

	sub pipe_get{ 			# pipe_get(on,2)
		my $a_n = shift;
		my $num = shift;
		
		foreach my $a ($num){
			my $x = $a * $id;
			my $y = $x + ($id -1);
			@{$a_n} = @d[$x..$y]; 
			unshift(@{$a_n},"$a_n"); 
		}
	}

	############# !subs UP ################          
	sub UP_small_self_move{                   # UP_small_self(1,VARxn,value);  
		my $f = shift;
		my $a = shift;
		my $v = shift;
		
		$redis->hincrby($f, $a, $v);    
	}


	sub UP_small_self{                   # UP_small_self(VARxn,value);  
		my $a = shift;
		my $v = shift;

		$redis->hset("$j:primary1", $a, $v); 
	}

	sub UP_small_someone{                   # UP_small_someone(VARxn,value,ID);  
		my $a = shift;
		my $v = shift;
		my $c = shift;	
	 
		$redis->hset("$c:primary1", $a, $v); 
	}

	sub UP_small_someone_from{                   # UP_small_someone_from(VARxn,value,ID,table);  
		my $a = shift;
		my $v = shift;
		my $c = shift;	
		my $z = shift;
	 
		$redis->hset("$c:$z", $a, $v); 
	}

	sub UP_small_someone_from_pipe{                   # UP_small_someone_from(VARxn,value,ID,table);  
		my $a = shift;
		my $v = shift;
		my $c = shift;	
		my $z = shift;

		$redis->hset("$c:$z", $a, $v,sub {
			my ($reply, $error) = @_;
						
		});
	}

	############# json decode $received_json ################
	$json = JSON->new->allow_nonref;
	sub json_decode {
		my $received_jason = shift;
		
		my $hash_ref = $json->decode( $received_jason );
		my %hash = %{$hash_ref};
	
		return %hash;
	}
	


1;	