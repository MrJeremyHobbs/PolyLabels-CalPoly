
![Alt text](https://github.com/MrJeremyHobbs/PolyLabels-CalPoly/blob/master/screenshot.JPG?raw=true "Title")
# PolyLabels
PolyLabels is for printing spine and pocket labels in Alma on dot matrix printers.

## Requirements
PolyLabels requires Perl 5, version 24 or later.

Once this is installed, you can run the install.bat file in the setup folder to install all needed dependecies from cpanm.

## API Key
PolyLabels requires an API key with the following permissions: BIBS read.

## Notes
There are different version of PolyLabels installed on different workstations. Each version is slightly modified to fit the needs of standing orders printing, SCA printing, etc.

My goal was to combine these different versions into a single stream-lined version, rewritten in Python using an OOP style, but I wasn't able to finish this before moving on.

If you are interested in taking up the task of creating a unified program, the best place to start is with the version I've shared on the general PolyLabels repository--version 1.7. You can find there [here]([https://github.com/MrJeremyHobbs/PolyLabels](https://github.com/MrJeremyHobbs/PolyLabels).

If maintaining PolyLabels proves unsustainable, there is also the option that most campuses use, which is [Spine-O-Matic](https://github.com/BCLibraries/SpineOMatic) (though the author of this program has since retired and the program is not in active development).


## How it Works
When the user scans the barcode of an item-in-hand, an Alma API call is made to gather information to generate a spine and pocket label based on local configurations.

### Config.ini
This file contains the printer configurations that tell the dot matrix printer how long, short, wide, etc. the labels are.
This file is different on each machine, depending on the type of label stock in use.
Each section is separated based on the elements of a label: spine (the small label that goes on a books spine), pocket label (the label that goes inside the book), and form (the entire label itself, between each perforation mark).

### Locations.ini
This file contains a list of all Alma locations and configurations for each.
Whe new locations are created, they must be added to this file if they will be printing labels for this location.
#### active
Is this an active location for printing? yes or no.
#### callType
Choices are lc (library of congress) or other (non-LC).
This field tells PolyLabels how to parse the call number for the item.
#### bold
Use bold type? yes or no.
#### condensed
Use condensed printing? This is only used for SCA locations.
### SCA locations
SCA locations have a slightly different set up, because they use condensed printing. 
The entire label is printed on the pocket label only (and not on the spine).
#### spineLabelSkip
The amount of characters to skip to reach the pocket label (from left to right).
#### pocketLabelSliceA
The width of the first section of the SCA label.
#### pocketLabelSliceB
The width of the second section of the SCA label.
### Templates.pl
This Perl file contains functions corresponding to each location in the Locations.ini file.
These functions generate the label based on the simple template within the function.
Many will be carbon copies of each other, but for the sake of clarity, they are seperated in a granular fashion.
Some locations have special prefixes that go at the top of the spine label. This template file provides an easy way to quickly add these prefixes or other information as needed.
## Printing Labels
If any changes are made to the configuration file, the printer needs to be turned off, and the user must exit PolyLabels.
Make sure the printer is lined up to the top of the next label.
Turn on the printer.
Open PolyLabels.
PolyLabels will not register changes to the config.ini file in real-time (and dot matrix printers won't adjust to these changes in real-time), so both must be restarted before the changes will take effect.