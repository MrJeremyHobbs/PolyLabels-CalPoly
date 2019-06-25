#!/usr/bin/perl
use strict;
use Tk;
use Tk::PNG;
use Tk::Dialog;
use Config::Simple;
use LWP::Simple;
use XML::Simple;
use Perl6::Form;
use Library::CallNumber::LC;
use Data::Dumper;
require 'Templates.pl';

#/Load configuration files
my $cfg = new Config::Simple("Config.ini");    #/General configurations
my $loc = new Config::Simple("Locations.ini"); #/Location-specific configurations

#/Printer and Label Settings
my $spine_label_length  = $cfg->param("spineLabel.length");
my $spine_label_width   = $cfg->param("spineLabel.width");
my $pocket_label_length = $cfg->param("pocketLabel.length");
my $pocket_label_width  = $cfg->param("pocketLabel.width");
my $form_length         = $cfg->param("form.length");
my $form_width          = $cfg->param("form.width");
my $gap                 = $cfg->param("form.gap");
my $form_length_inches  = $cfg->param("form.lengthInches");
my $perf_skip           = $cfg->param("form.perfSkip");
my $printer_port        = $cfg->param("printer.port");
my $print_mode          = $cfg->param("printer.printMode");
my $apiKey              = $cfg->param("misc.apiKey");
my $ver                 = $cfg->param("misc.ver");

#/Initialize Printer
initializePrinter();


#/GUI ###################################################################################

#/Main window
my $mw = MainWindow->new;
   $mw->title("PolyLabels v$ver");
   $mw->resizable( 0, 0 ); #not resizable in either width or height
   $mw->toplevel->iconbitmap("./images/logo_small.ico");

#/Canvas and logo
my $canvas = $mw->Canvas(-width => 0, -height => 110)->pack(-side => 'top', -expand => 1, -fill => 'both');
my $logo   = $canvas->Photo(-format => 'png', -file => "./images/logo_large.png");
   $canvas->createImage(165,60, -image => $logo);

#/Entry and button frame
my $top_frame = $mw->Frame()->pack( -side => 'top', -fill => 'both');
my $ent = $top_frame->Entry(-font => 'Consolas 16')->pack(-side => 'top', -fill => 'both', -expand => 1);
   $ent->bind('<Key-Return>', \&main); #/Sends barcode to main sub on pressing enter
   $ent->focus;
my $printer_img = $mw->Photo(-format => 'png', -file=>'./images/printer.png');
my $print_but = $top_frame->Button(-image => $printer_img, -command =>\&printCustomLabel)->pack(-side => 'right', -fill => 'none', -expand => 0); #/Sends to printer
my $scan_but = $top_frame->Button(-text => "SCAN", -font => "Arial 11", -command =>\&main)->pack(-side => 'top', -fill => 'both', -expand => 1); #/Sends barcode to main sub on button press

#/Label display frame
my $label_frame = $mw           ->Frame()->pack( -side => 'top');   
my $spine_txt   = $label_frame  -> Text(-width => $spine_label_width,  -height => 20, -background => 'lemon chiffon', -wrap => 'none', -font => 'Consolas 12')->pack(-side => 'left', -expand => 1);
my $pocket_txt  = $label_frame  -> Text(-width => $pocket_label_width, -height => 20, -background => 'lemon chiffon', -wrap => 'none', -font => 'Consolas 12')->pack(-side => 'left', -expand => 1);

#/Status bar frame
my $bot_frame = $mw->Frame()->pack( -side => 'top', -fill => 'both');
my $status = $bot_frame->Text(-width => $spine_label_width,  -height => 1, -background => 'ghost white', -wrap => 'none', -font => 'Monospace 9', relief => 'flat')->pack(-side => 'top', -fill => 'both', -expand => 1);
   $status -> insert('end', "Current Location: none");

#/Menus
my $mbar     = $mw -> Menu();
               $mw -> configure(-menu => $mbar);
my $file     = $mbar -> cascade(-label=>"~File",    -tearoff => 0);

#/File menu
$file->command(-label =>'~Print Custom Label     ', -command=>sub {printCustomLabel();});
$file->command(-label =>'~Test Print     ',         -command=>sub {printTestLabel();});

MainLoop;



#/ Main #################################################################################
sub main
{
    #/Get barcode
    clearWidgets();
    my $barcode = getBarcode();
    clearEntry();
    
    #/Get Alma XML
    my $alma_xml = getAlmaXML($barcode);
    my $xml_OK   = checkXML($alma_xml);
    return if $xml_OK eq 'false';   
    my $xml_hash = createXMLHash($alma_xml);
    
    #/Modify some elements, add to xml hash
    my $author_short = shortenAuthor($xml_hash);
       $xml_hash->{author_short} = $author_short;
    my $parsed_description = parseDescription($xml_hash);
       $xml_hash->{item_data}->{description} = $parsed_description;
    
    #/Check location
    my ($library, $location) = getLocations($xml_hash);
    my $OK_to_print          = activeForPrinting($location);
    return if $OK_to_print eq 'false';
    insertStatus("Current Location: $library - $location");
    
    #/Parse call number
    my ($call_number, $call_number_type) = getCallNumber($xml_hash, $location);
    my @call                             = parseCall($call_number, $location, $call_number_type); #/Calls out to CallParser.pl
    my $call_num_OK                      = checkCallNumber(@call, $call_number, $location, $call_number_type);
    my $parsed_call_number               = join("\n", @call);
    return if $call_num_OK eq 'false';
    $xml_hash->{parsed_call_number}      = $parsed_call_number;
    
    #/Apply template
    my ($spine, $pocket) = applyTemplate($xml_hash, $library, $location);
       
    #/Generate display labels
    my ($display_spine, $display_pocket) = generateDisplayLabel($spine, $pocket);
    insertLabels($display_spine, $display_pocket);
    
    #/Check spine label for errors
    my $spine_label_OK = checkSpineLabel();
    return if $spine_label_OK eq 'false';
    
    #/Generate final label
    my $label = generateFinalLabel($location, $library);
    
    #/Print label
    printLabel($label, $location);
    
    return;
}


#/Subs ##################################################################################
sub msgbox
{
    my $msg = shift;

    $mw->Dialog(-title => 'Attention',
                -text => "$msg",
                -bitmap => 'error' )->Show();

    return;
}

sub initializePrinter
{
    open (PRINTER, ">", "lpt$printer_port:");
    print PRINTER chr(27)."C".chr(0).chr($form_length_inches); #/Sets form length in inches
    print PRINTER chr(27)."N".chr($perf_skip);                 #/Sets perforation skip in lines
    close PRINTER;
    
    return;
}

sub clearWidgets
{
    $spine_txt  -> delete('1.0', 'end');
    $pocket_txt -> delete('1.0', 'end');
    $status     -> delete('1.0', 'end');
    
    return;
}

sub getBarcode
{
    my $barcode = $ent -> get(); #/Retrieve barcode from entry field
       $barcode =~ s/\s//g;      #/Deletes spaces in barcode
    
    return $barcode;
}

sub clearEntry
{
    $ent -> delete('0', 'end'); #/Clears out entry field in GUI
    
    return;
}

sub getAlmaXML
{
    my $barcode  = shift;
    
    my $url      = "https://api-na.hosted.exlibrisgroup.com/almaws/v1/items?view=label&item_barcode=$barcode&apikey=$apiKey";
    my $alma_xml = get $url; #/Makes call to LWP::Simple module
    
    return $alma_xml;
}

sub checkXML
{
    my $alma_xml = shift;

    if ($alma_xml eq undef) {
        msgbox("Record not found.");
        return 'false';
    } else {
        return 'true';
    }
}

sub createXMLHash
{
    my $alma_xml = shift;
    
    my $xml      = XML::Simple->new();
    my $xml_hash = $xml->XMLin($alma_xml);
    
    return $xml_hash;
}

sub shortenAuthor
{
    my $xml_hash = shift;
    my $author = $xml_hash->{bib_data}->{author};
    
    #/Generate uppercase author name for GoodReads labels
    my @author = split /\s/, $author;
    my $author_short = $author[0];
    $author_short =~ s/,//g;
    $author_short = uc($author_short); 
    
    return $author_short;
}

sub parseDescription
{
    my $xml_hash = shift;
    
    my $parsed_description = $xml_hash->{item_data}->{description};
       $parsed_description =~ s/\s/\n/g;

    return $parsed_description;
}

sub activeForPrinting
{
    my $location = shift;
    
    my $active = $loc->param("$location.active");
    if ($active eq 'no') {
        msgbox("Cannot print labels for this location ($location)");
        return 'false';
    } else {
        return 'true';
    }
}

sub getLocations
{
    my $xml_hash = shift;
    
    my $library     = $xml_hash->{item_data}->{library}->{content};
    my $location    = $xml_hash->{item_data}->{location}->{content};
	
    return ($library, $location);
}

sub insertStatus
{
    my $status_msg = shift;
    $status -> insert('end', "$status_msg");

    return;
}

sub getCallNumber
{
    my $xml_hash = shift;
    my $location = shift;

    my $call_number         = $xml_hash->{holding_data}->{call_number};
    my $call_number_type    = $loc->param("$location.callType");
    
    return ($call_number, $call_number_type);
}

sub checkCallNumber
{
    my @call = shift;
    my $call_number = shift;
    my $location = shift;
    my $call_number_type = shift;
    
    if ($call[0] eq "") {
        msgbox("Bad Call#: $call_number\n\nCall# doesn't match its location type ($location - $call_number_type).");
        return 'false';
    } else {
        return 'true';
    }
}

sub generateDisplayLabel
{
    my $spine = shift;
    my $pocket = shift;
    
	#/Generate display spine label
	my $display_spine = form
	{height=>{min=>$spine_label_length, max=>$spine_label_length}, vfill=>" "},
	"{[{$spine_label_width}}",
	$spine;
	
	#/Generate display pocket label
	my $display_pocket = form
	{height=>{min=>$spine_label_length, max=>$pocket_label_length}, vfill=>" "},
	"{[{$pocket_label_width}}",
	$pocket;
	
	return ($display_spine, $display_pocket);
}

sub insertLabels
{
    my $display_spine  = shift;
    my $display_pocket = shift;
    
    #/Insert labels on screen
    $spine_txt  -> insert('end', $display_spine);
	$pocket_txt -> insert('end', $display_pocket);

    return;
}

sub getLabelText
{
    my $spine  = $spine_txt -> get('1.0','end-1c');
    my $pocket = $pocket_txt-> get('1.0','end-1c');
    
    return ($spine, $pocket);
}

sub checkSpineLabel
{   
	#/Grab spine label from screen
	my $spine  = $spine_txt -> get('1.0','end-1c');
	
	#/Check length
	my $len_spine = $spine =~ tr/\n//;
	if ($len_spine > $spine_label_length) {
		msgbox("Spine label is too long ($len_spine lines). Max is $spine_label_length lines.");
		return 'false';
	}
	
	#/Check width
	my @width = split /\n/, $spine;
	foreach my $line (@width) {
		my $line_width = length($line);
		if ($line_width > $spine_label_width) {
			msgbox("Spine label is too wide ($line). Max is $spine_label_width characters.");
			return 'false';
        }
	}
    
    return 'true';
}

sub generateFinalLabel
{
    my $location = shift;
	my $library = shift;
    
    my ($spine, $pocket) = getLabelText();
	
	#/Generate Full Label
	my $label = form
	{height=>{min=>$spine_label_length, max=>$spine_label_length}, vfill=>" "},
	"{[{$spine_label_width}} {|{$gap}} {[{$pocket_label_width}}",
	$spine,                   " ",     $pocket;
    
    #/Generate SpecColl label
	if ($library eq 'CPSLO_SCA') {
        my $SPEC_spineSkip    = $loc->param("spec.spineLabelSkip");
        my $SPEC_pocketSliceA = $loc->param("spec.pocketLabelSliceA");
        my $SPEC_pocketSliceB = $loc->param("spec.pocketLabelSliceB");
        
        $label = form
        {height=>{min=>$spine_label_length, max=>$spine_label_length}, vfill=>" "},
        "{[{$SPEC_spineSkip}} {[{$SPEC_pocketSliceA}} {[{$SPEC_pocketSliceB}}",
        " ", "$spine", "$pocket";
    }
    
    #/Generate Good Reads label
    if ($location eq 'goodreads') {
        $label = form
        {height=>{min=>$spine_label_length, max=>$spine_label_length}, vfill=>" "},
        "{[{$spine_label_width}} {|{$gap}} {=|{$pocket_label_width}}",
        " ", " ", $pocket;
    }
    
    #/Generate test label
    if ($location eq 'test') {
        $label = form
        {height=>{min=>$spine_label_length, max=>$spine_label_length}, hfill=>"X"},
        "{[{$spine_label_width}} {|{$gap}} {[{$pocket_label_width}}",
        "X", " ", "X";

        $label = $label x 2; #print 2 test label;    
    }
    
    return $label;
}

sub printLabel
{
    my $label               = shift;
    my $location            = shift;
    my $bold                = $loc->param("$location.bold");
    my $condensed           = $loc->param("$location.condensed");
    
    #/Check
    return if $print_mode eq 'no';
	
	#/Print full label
    open (PRINTER, ">", "lpt$printer_port:");
    print PRINTER chr(27)."E" if $bold eq 'yes';      #/Sets bold on
    print PRINTER chr(27)."g" if $condensed eq 'yes'; #Sets condensed printing mode 15
    print PRINTER "$label";
    print PRINTER chr(27)."F" if $bold eq 'yes';      #/Sets bold off
    print PRINTER chr(18) if $condensed eq 'yes';     #Cancels condensed printing mode
    close PRINTER;
	
	return;
}

sub printCustomLabel
{
    my $status_txt = $status -> get('1.0','end-1c');
    my $library = $1 if  $status_txt =~ /Current Location: (.*) - (.*)/;
    my $location = $2 if  $status_txt =~ /Current Location: (.*) - (.*)/;
    
    my ($spine, $pocket) = getLabelText();
	my $label_OK = checkSpineLabel($spine);
    my $label = generateFinalLabel($location, $library) if $label_OK eq 'true';
	printLabel($label, $location);
	
	return;
}

sub changeSettings
{
    my $om = $mw->Toplevel;
       $om->title("Settings");
       $om->resizable( 0, 0 ); #not resizable in either width or height
       
    #/Printer Settings
       $om->Label(-text => "Printer Settings\n---------------------------------", -font => 'Arial 10')->pack();
       
    my $f1 = $om->Frame()->pack(-fill=>'both');   
       $f1->Label(-text => "Printer Port:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f1->Optionmenu(-variable => \$printer_port, -options => [1,2,3,4,5], -command => [sub {$cfg->param("printer.port", $printer_port)}])->pack(-side=>'right');

    my $f2 = $om->Frame()->pack(-fill=>'both');   
       $f2->Label(-text => "Print Mode:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f2->Optionmenu(-variable => \$print_mode, -options => ["yes", "no"], -command => [sub {$cfg->param("printer.printMode", $print_mode)}])->pack(-side=>'right');

    #/Form Settings
       $om->Label(-text => "\n\nForm Settings\n---------------------------------", -font => 'Arial 10')->pack();

    my $f3 = $om->Frame()->pack(-fill=>'both');   
       $f3->Label(-text => "Length:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f3->Optionmenu(-variable => \$form_length, -options => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25], -command => [sub {$cfg->param("form.length", $form_length)}])->pack(-side=>'right');

    my $f4 = $om->Frame()->pack(-fill=>'both');   
       $f4->Label(-text => "Length (inches):  ", -font => 'Arial 10')->pack(-side=>'left');
       $f4->Optionmenu(-variable => \$form_length_inches, -options => [1,2,3,4,5,6,7,8], -command => [sub {$cfg->param("form.lengthInches", $form_length_inches)}])->pack(-side=>'right');
       
    my $f5 = $om->Frame()->pack(-fill=>'both');
       $f5->Label(-text => "Width:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f5->Optionmenu(-variable => \$form_width, -options => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30], -command => [sub {$cfg->param("form.width", $form_width)}])->pack(-side=>'right');

    my $f6 = $om->Frame()->pack(-fill=>'both');   
       $f6->Label(-text => "Gap:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f6->Optionmenu(-variable => \$gap, -options => [1,2,3,4,5], -command => [sub {$cfg->param("form.gap", $gap)}])->pack(-side=>'right');


    my $f7 = $om->Frame()->pack(-fill=>'both');   
       $f7->Label(-text => "Perforation skip:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f7->Optionmenu(-variable => \$perf_skip, -options => [1,2,3,4,5], -command => [sub {$cfg->param("form.perfSkip", $perf_skip)}])->pack(-side=>'right');

    #/Spine Label Settings
       $om->Label(-text => "\n\nSpine Label\n---------------------------------", -font => 'Arial 10')->pack();

    my $f8 = $om->Frame()->pack(-fill=>'both');   
       $f8->Label(-text => "Length:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f8->Optionmenu(-variable => \$spine_label_length, -options => [1,2,3,4,5,6,7,8,9,10,11,12], -command => [sub {$cfg->param("spineLabel.length", $spine_label_length)}])->pack(-side=>'right');
    

    my $f9 = $om->Frame()->pack(-fill=>'both');   
       $f9->Label(-text => "Width:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f9->Optionmenu(-variable => \$spine_label_width, -options => [4,5,6,7,8,9,10,11,12], -command => [sub {$cfg->param("spineLabel.width", $spine_label_width)}])->pack(-side=>'right');


    #/Pocket Label Settings
       $om->Label(-text => "\n\nPocket Label\n---------------------------------", -font => 'Arial 10')->pack();
       
    my $f10 = $om->Frame()->pack(-fill=>'both');   
       $f10->Label(-text => "Length:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f10->Optionmenu(-variable => \$pocket_label_length, -options => [1,2,3,4,5,6,7,8,9,10,11,12], -command => [sub {$cfg->param("pocketLabel.length", $pocket_label_length)}])->pack(-side=>'right');

    my $f11 = $om->Frame()->pack(-fill=>'both');   
       $f11->Label(-text => "Width:  ", -font => 'Arial 10')->pack(-side=>'left');
       $f11->Optionmenu(-variable => \$pocket_label_width, -options => [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30], -command => [sub {$cfg->param("pocketLabel.width", $pocket_label_width)}])->pack(-side=>'right');
    

    $om->Label(-text => "\n", -font => 'Arial 10')->pack(); #/padding

    #/Buttons
    my $f12 = $om->Frame()->pack(-fill =>'both');
    my $test_button    = $f12->Button(-text => "Print Test Label", -font => "Arial 11", -command =>\&printTestLabel)->pack(-side => 'top', -fill => 'both', -expand => 1, -ipady=>3);
    my $save_button    = $f12->Button(-text => "Save Settings", -font => "Arial 11", -command =>\&saveSettings)->pack(-side => 'top', -fill => 'both', -expand => 1, -ipady=>3);
    my $default_button = $f12->Button(-text => "Restore Defaults", -font => "Arial 11", -command =>\&loadDefaults)->pack(-side => 'top', -fill => 'both', -expand => 1, -ipady=>3);

    return;
}

sub printTestLabel
{
    my $location = 'test';
    
    my $label = generateFinalLabel('test');
    printLabel($label);

    return;
}

sub parseCall
{
    my $call_number = shift;
 	my $location    = shift;
	my $callType    = shift;   
    
    #/Clean-up
	$call_number =~ s/\(.*\)//g; #/Clean up paren statements
    
    #/Parse call number into array
    my @call;
    if ($callType eq 'lc') {
        @call = Library::CallNumber::LC->new($call_number)->components();
    }
    
    if ($callType eq 'docs') {
        @call = ($1, $2, $3) if $call_number =~ /([A-Z][0-9].*)(\.[A-Z]\d{1,5})\s(.*)/, $call_number;
    }
    
    if ($callType eq 'other') {
        @call = split /\s/, $call_number;
    }
    
    if ($callType eq 'none') {
        @call = ("blank")
    }
    
    return @call;
}