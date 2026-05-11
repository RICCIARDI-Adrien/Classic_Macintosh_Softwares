## Documentation

The books have been downloaded from [VintageApple.org](https://vintageapple.org/) or [Bitsavers](https://bitsavers.org/).

## Softwares

This directory contains the developed softwares source code.

To build an application :

1. Use the `Create_Archive.sh` script to create a `.sit` archive of the wanted application directory (for instance, `Minimal_Program` or `PRAM_Loader`). The archive will preserve some Macintosh-specific file attributes, like the file type code.
2. Transfer the archive to a Macintosh (either real or emulated) where the MPW and the Pascal compiler have been installed (see the [Tools](#tools) section of this document).
3. On the Mac, extract the archive in whatever directory.
4. Start the `MPW Shell`, then change the directory to the newly extracted one. You can use the `Set Directory...` sub-menu of the `Directory` menu.
5. In a `MPW Shell` worksheet, type `Build` to build and link the application. See the [tips and tricks](#tips-and-tricks) section of this document to know about the key combination needed to execute a command, or press the `MPW Shell` button on the top left side of the MPW worksheet window.

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

### Tips and tricks

* The MPW Shell uses various key combinations. On a host PC running Linux, type :
  * `Alt+Enter` to execute the command on the line where the cursor is located,
  * `Alt+Super+Enter` to open the Commando interface for the command on the line where the cursor is located,
  * `Alt+Super+Shift+Enter` to exit from the currently running command (think of Linux `Ctrl+C`).
