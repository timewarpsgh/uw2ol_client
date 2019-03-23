sub convert_utf8_to_gbk {

    my ($utf8) = @_;
    my $gbk = "";

    if (Encode::is_utf8($utf8)){
        $gbk = Encode::encode('gbk',$utf8);
    }
    else{
        $gbk = Encode::encode('gbk',Encode::decode('utf8',$utf8));
    }

    return $gbk;
}

sub convert_gbk_to_utf8 {

    my ($gbk) = @_;
    my $utf8 = "";

    $utf8 = Encode::decode('gbk',$gbk);

    return $utf8;
}



1;