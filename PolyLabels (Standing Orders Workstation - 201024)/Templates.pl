use strict;

sub applyTemplate
{
    my $xml_hash = shift;
    my $library  = shift;
    my $location = shift;

    #/Get XML elements
    my $title              = $xml_hash->{bib_data}->{title};
    my $author             = $xml_hash->{bib_data}->{author};
    my $author_short       = $xml_hash->{author_short};
    my $description        = $xml_hash->{item_data}->{description};
    my $call_number        = $xml_hash->{holding_data}->{call_number};
    my $parsed_call_number = $xml_hash->{parsed_call_number};
    my $parsed_holdings    = $xml_hash->{parsed_holdings};

    #/Enumeration fields
    my $enumeration_a      = $xml_hash->{item_data}->{enumeration_a};
    my $enumeration_b      = $xml_hash->{item_data}->{enumeration_b};
    my $enumeration_c      = $xml_hash->{item_data}->{enumeration_c};
    my $enumeration_d      = $xml_hash->{item_data}->{enumeration_d};
    my $enumeration_e      = $xml_hash->{item_data}->{enumeration_e};
    my $enumeration_f      = $xml_hash->{item_data}->{enumeration_f};
    my $enumeration_g      = $xml_hash->{item_data}->{enumeration_g};
    my $enumeration_h      = $xml_hash->{item_data}->{enumeration_h};
    
    my $spine;
    my $pocket;
    
    if ($location eq 'agxdocs') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";
    }
    
    if ($location eq 'arch') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archovr') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'califdocs') {
        $spine =
		"CALIF\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'curperdisp') {
        $spine =
		"Per\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$title\n" .
        "*** FOR DISPLAY ***";
    }

    if ($location eq 'currentper') {
        $spine =
		"Per\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$title\n";  
    }

    if ($location eq 'dvds') {
        $spine =
		"DVD\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'dvdsnors') {
        $spine =
		"DVD\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'goodreads') {
        $spine = "";
  
        $pocket =
        "$author_short";     
    }

    if ($location eq 'localdocs') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'research') {
         $spine =
		 "REF\n" .
         "$parsed_call_number\n" .
         "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";
    }

    if ($location eq 'spec') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'specovr') {
         $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title"; 
    }

    if ($location eq 'stackper') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";  
    }

    if ($location eq 'stackperov') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";       
    }

    if ($location eq 'stacks') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";
    }

    if ($location eq 'stacksnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";    
    }

    if ($location eq 'stacksovr') {
        $spine =
		"OVR\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";   
    }

    if ($location eq 'staovrnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";     
    }

    if ($location eq 'stoovrnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$title\n" .
        "$parsed_holdings";     
    }

    if ($location eq 'trc') {
        $spine =
        "WB\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "WB $call_number\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'trcspanish') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number\n" .
        "$author\n" .
        "$title";      
    }
    
    $spine =~ s/HASH\(.*//; #/Removes empty hash refs
    
    return ($spine, $pocket);
}

1;