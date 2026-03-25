## Documentation

The books have been downloaded from [VintageApple.org](https://vintageapple.org/) or [Bitsavers](https://bitsavers.org/).

## Tools

All tools have been downloaded from [Macintosh Repository](https://www.macintoshrepository.org/) or [Macintosh Garden](https://macintoshgarden.org/).

The following instructions apply to the [Basilisk II](https://basilisk.cebix.net/) emulator running System 7.5.3.

### Install MPW (Macintosh Programmer's Workshop) 3.3

* Power off the emulator.
* Extract the archive named `Tools/MPW (Macintosh Programmer's Workshop) 3.3/MPW 3.3 extracted floppy images.zip`.
* Mount all five floppy images from the emulator *Volumes* tab.
* Follow the setup instructions from the first floppy image *readme* file.

### Install the Pascal compiler

* Put the `Tools/MPW (Macintosh Programmer's Workshop) 3.3/MPW Pascal 3.3.3.bin` archive into the emulator shared drive on the host machine.
* Power on the emulator.
* From the emulated guest, extract the Pascal compiler archive. All following steps occur on the emulated guest.
* Rename the `MPW Pascal` file into `Pascal` and move it to the `MPW/Tools` directory.
* Move the `PLibraries` directory to the `MPW/Libraries` directory.
* Move the `PInterfaces` directory to the `MPW/Interfaces` directory.
