# PRAM Loader

The goal is to restore a saved copy of the [Parameter RAM](https://apple.fandom.com/wiki/Parameter_RAM) during system boot.  
This allows to keep the PRAM settings even when the backup battery is removed.

This application has been built for and tested on System 7.5.3.

## How it works

The application's operation is really simple :

* The application starts by looking if the `PRAM_Data.bin` file is present in the same directory.
* If the file is found, the file content is read and replaces the current PRAM content.
* If the file is not found, the application reads the current PRAM content and stores it into the `PRAM_Data.bin` file.

## Installation

* Create a directory in whatever location (this could be the root of the system volume for example). Using a dedicated directory is the preferred way because the application will generate a data file at the same location it resides.
* Extract the archive content to this directory.
* Create an alias of the `PRAM_Loader` application and move it to the `Startup Items` directory of the `System Folder`, so the application is automatically ran during system startup.

## How to update the PRAM content

If the user has updated some PRAM setting by using the control panels, he can update the application PRAM data file in two steps :

* Remove the `PRAM_Data.bin` file located in the application directory.
* Manually run the `PRAM_Loader` application by double-clicking on its icon in the Finder. This will regenerate the `PRAM_Data.bin` file with the updated settings.
