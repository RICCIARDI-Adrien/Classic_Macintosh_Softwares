# PRAM Loader

The goal is to restore a saved copy of the [Parameter RAM](https://apple.fandom.com/wiki/Parameter_RAM) during the system boot.  
This allows to keep the PRAM settings even when the backup battery is removed.

This extension has been built for and tested on System 7.5.3.

**Note :** the mouse speed settings seem to be set too late during the system boot, so the correct value is reported by the mouse control panel, but only the default speed is effective.  
For now, just reboot the computer to correctly apply the mouse speed settings.

## How it works

The extension's operation is really simple :

* When loaded during system startup, the extension starts by looking if the `PRAM Loader Preferences` file is present in the system `Preferences` directory.
* If the file is found, the file content is read and replaces the current PRAM content.
* If the file is not found, the application reads the current PRAM content and stores it into the `PRAM Loader Preferences` file.

## Installation

* Extract the archive content to whatever directory.
* Drag and drop the `PRAM Loader` extension into the `System Folder` directory.
* A confirmation message pops, asking for the user confirmation to install the extension into the `Extensions` directory. Click `OK`.

## How to update the PRAM content

If the user has updated some PRAM setting by using the control panels, he can update the extension preferences file in two steps :

* Remove the `PRAM Loader Preferences` file located in the system `Preferences` directory.
* Reboot the computer to regenerate the preferences file during next start.
