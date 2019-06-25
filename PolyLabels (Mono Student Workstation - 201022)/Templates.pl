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
    
    # Main Library Locations ##################################################
    if ($location eq '1dayres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
    if ($location eq '1hourres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
    if ($location eq '2dayres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
    if ($location eq '2hourres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
    if ($location eq '2hrovntres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
    if ($location eq '4hourres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
	if ($location eq 'agxdocs') {
        $spine =
		"AGX\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "AGX $call_number $description\n" .
        "$author\n" .
        "$title";
    }

    if ($location eq 'deskcopy') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title";    
    }		

    if ($location eq 'califdocs') {
        $spine =
		"CALIF\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
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
        "$title";    
    }

    if ($location eq 'dvdsnors') {
        $spine =
		"DVD\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
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
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
	
    if ($location eq 'permres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }

    if ($location eq 'research') {
         $spine =
		 "REF\n" .
         "$parsed_call_number\n" .
         "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";   
    }
	
	    if ($location eq 'soilsurv') {
         $spine =
		 "Ref.\n" .
         "$parsed_call_number\n" .
         "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";   
    }

    if ($location eq 'stackper') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$author\n" .
        "$title";      
    }

    if ($location eq 'stackperov') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";      
    }

    if ($location eq 'stacks') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }

    if ($location eq 'stacksnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'stacksovr') {
        $spine =
		"OVR\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'staovrnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'stoovrnors') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
	
    if ($location eq 'tempres') {
        $spine =
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
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
        "$call_number $description\n" .
        "$author\n" .
        "$title";      
    }
    
    # SCA Library Locations ###################################################
    if ($location eq 'arch') {
        $spine =
        "ARCH\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archdrawer') {
        $spine =
        "ADRAW\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archfol') {
        $spine =
        "AFOLIO\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archfolfl') {
        $spine =
        "AFOLOFL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archmini') {
        $spine =
        "AMINI\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'archovr') {
        $spine =
        "AOVER\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archovrfl') {
        $spine =
        "AOVERFL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archref') {
        $spine =
        "AREF\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archvfilet') {
        $spine =
        "AVERTLT\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archvfileg') {
        $spine =
        "AVERTLG\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archdrawer') {
        $spine =
        "ADRAW\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'archroll') {
        $spine =
        "AROLL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'spec') {
        $spine =
        "SPECCOL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'specdrawer') {
        $spine =
        "DRAW\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'specfol') {
        $spine =
        "FOLIO\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }

    if ($location eq 'specfolfl') {
        $spine =
        "FOLIOFL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'specmini') {
        $spine =
        "MINI\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";    
    }
    
    if ($location eq 'specovr') {
        $spine =
        "OVER\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
        
    if ($location eq 'specovrfl') {
        $spine =
        "OVERFL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
        
    if ($location eq 'specref') {
        $spine =
        "REF\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
        
    if ($location eq 'specvfilet') {
        $spine =
        "VERTLT\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
        
    if ($location eq 'specvfileg') {
        $spine =
        "VERTLG\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
        
    if ($location eq 'specroll') {
        $spine =
        "ROLL\n" .
        "$parsed_call_number\n" .
        "$description";
  
        $pocket =
        "$call_number $description\n" .
        "$author\n" .
        "$title";
    }
    
    # Clean up
    $spine =~ s/HASH\(.*//; #/Removes empty hash refs
    
    # Finish
    return ($spine, $pocket);
}

1;