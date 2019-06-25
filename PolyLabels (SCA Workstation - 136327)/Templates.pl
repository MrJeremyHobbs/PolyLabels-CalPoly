use strict;

sub applyTemplate
{
    my $xml_hash = shift;
    my $library  = shift;
    my $location = shift;
    
    my $location_uc = uc $location;

    #/Get XML elements
    
    # title
    my $title              = $xml_hash->{bib_data}->{title};
    my $title_short        = $title;
       $title_short        =~ s/\s\/(?!.*\/).*//g; # replaces only last occurence of '/' in 245 field
       $title_short        = substr($title_short, 0, 23);
    my $title_len          = length $title_short;
    if ($title_len > 20) {
        $title_short        = $title_short . '...';
    }
    
    my $author             = $xml_hash->{bib_data}->{author};
    
    # remove end period
    $author =~ s/([a-z])(\.)(?!.*\.)/$1/;
    
    # remove end comma
    my $last_char = substr($author, -1);
    if ($last_char eq ',') {
        $author = substr($author, 0, -1);
    }
    
    my $author_short       = $xml_hash->{author_short};
    my $description        = $xml_hash->{item_data}->{description};
    my $call_number        = $xml_hash->{holding_data}->{call_number};
    my $parsed_call_number = $xml_hash->{parsed_call_number};
	
	#/Clear description if blank
	   $description = "" if ($description =~ /HASH\(/);

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
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";
    }
    
    if ($location eq 'arch') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }
    
    if ($location eq 'archovr') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }
	
    if ($location eq 'archdrawer') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archfol') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archfolfl') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archmini') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archovrfl') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archref') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archsrproj') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'archvfile') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'deskcopy') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";    
    }		

    if ($location eq 'califdocs') {
        $spine =
		"CALIF\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'curperdisp') {
        $spine =
		"Per\n" .
        "$parsed_call_number\n" .
        "$enumeration_a:$enumeration_b\n" .
        "$enumeration_c";
  
        $pocket =
        "$call_number\n" .
        "$title\n" .
        "*** FOR DISPLAY ***";
    }

    if ($location eq 'currentper') {
        $spine =
		"Per\n" .
        "$parsed_call_number\n" .
        "$enumeration_a:$enumeration_b\n" .
        "$enumeration_c";
  
        $pocket =
        "$call_number\n" .
        "$title\n";  
    }

    if ($location eq 'dvds') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "DVD $call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'dvdsnors') {
        $spine =
		"DVD\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
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
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'research') {
         $spine =
		 "REF\n" .
         "$parsed_call_number\n" .
         "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";   
    }

    if ($location eq 'spec') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }
	
    if ($location eq 'specdrawer') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'specfolfl') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'specmini') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'specovr') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'specovrfl') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'specref') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'specvfile') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }	

    if ($location eq 'specfol') {
        $spine =
        "$location_uc\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }	
	
    if ($location eq 'specovr') {
         $spine =
         "$location_uc\n" .
         "$parsed_call_number\n" .
         "$description";
  
         $pocket =
         "$author\n" .
         "$title_short"; 
    }

    if ($location eq 'stackper') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title_short";      
    }

    if ($location eq 'stackperov') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";      
    }

    if ($location eq 'stacks') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";
    }

    if ($location eq 'stacksnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'stacksovr') {
        $spine =
		"OVR\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'staovrnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'stoovrnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'trc') {
        $spine =
        "WB\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "WB $call_number\n" .
        "$author\n" .
        "$title_short";    
    }

    if ($location eq 'trcspanish') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title_short";      
    }
    
    $spine =~ s/HASH\(.*//; #/Removes empty hash refs
    
    return ($spine, $pocket);
}

1;