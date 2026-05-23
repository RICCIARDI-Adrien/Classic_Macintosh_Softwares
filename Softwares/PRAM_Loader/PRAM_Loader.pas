(*
 * Restore the PRAM content from a file.
 * Author : Adrien RICCIARDI
 * Date : 10/05/2026
 *)
program PRAM_Loader;

uses Errors, Files, Folders, OSIntf, Script;

const
	FILE_NAME = 'PRAM Loader Preferences';

var
	FSSpec_PRAM_Data: FSSpec;

procedure SavePRAMToFile;
var
	File_Reference_Number, Result: integer;
	Pointer_PRAM_Area: SysPPtr;
	Count: longint;
begin
	(* Create the file *)
	Result := FSpCreate(FSSpec_PRAM_Data, '????', 'pref', smSystemScript);
	if Result <> noErr then
	begin
		WriteLn('Error while creating the PRAM data file in the Preferences directory : ', Result);
		Exit(SavePRAMToFile);
	end;

	(* Open it in write mode *)
	Result := FSpOpenDF(FSSpec_PRAM_Data, fsWrPerm, File_Reference_Number);
	if Result <> noErr then
	begin
		WriteLn('Error while opening the PRAM data file in write mode : ', Result);
		Exit(SavePRAMToFile);
	end;

	(* Retrieve the PRAM content *)
	Pointer_PRAM_Area := GetSysPPtr;

	(* Store the PRAM area content to the file *)
	Count := SizeOf(SysParmType);
	Result := FSWrite(File_Reference_Number, Count, ptr(Pointer_PRAM_Area));
	if Result <> noErr then WriteLn('Error while writing to the PRAM data file : ', Result);

	(* Close the file in all cases *)
	Result := FSClose(File_Reference_Number);
	if Result <> noErr then
	begin
		WriteLn('Error while closing the PRAM data file : ', Result);
		Exit(SavePRAMToFile);
	end;

	(* Ensure that the file's catalog entry is updated *)
	Result := FlushVol(nil, FSSpec_PRAM_Data.vRefNum);
	if Result <> noErr then WriteLn('Error while flushing the volume : ', Result);
end;

procedure LoadPRAMFromFile;
var
	File_Reference_Number, Result: integer;
	Local_PRAM_Area: SysParmType;
	Pointer_PRAM_Area: SysPPtr;
	Count: longint;
	Is_Reading_Failed: boolean;
begin
	(* Open the file in read mode *)
	Result := FSpOpenDF(FSSpec_PRAM_Data, fsRdPerm, File_Reference_Number);
	if Result <> noErr then
	begin
		WriteLn('Error while opening the PRAM data file in read mode : ', Result);
		Exit(LoadPRAMFromFile);
	end;

	(* Load the content without altering the PRAM in low memory *)
	Count := SizeOf(SysParmType);
	Result := FSRead(File_Reference_Number, Count, @Local_PRAM_Area);
	if Result <> noErr then
	begin
		WriteLn('Error while reading from the PRAM data file : ', Result);
		Is_Reading_Failed := true;
	end
	else Is_Reading_Failed := false;

	(* Exit if any error occurred, but make sure that the file is closed first *)
	Result := FSClose(File_Reference_Number);
	if (Result <> noErr) or Is_Reading_Failed then Exit(LoadPRAMFromFile);

	(* Update the PRAM content *)
	Pointer_PRAM_Area := GetSysPPtr;
	MoveLeft(Local_PRAM_Area, Pointer_PRAM_Area^, SizeOf(Local_PRAM_Area));
	Result := WriteParam;
	if Result <> noErr then WriteLn('Error while writing to the PRAM area : ', Result);
end;

var
	Result, Found_Volume_Reference_Number: integer;
	Found_Directory_ID: longint;

begin
	(* The PRAM data file is stored in the system Preferences directory, retrieve its path *)
	Result := FindFolder(kOnSystemDisk, kPreferencesFolderType, kDontCreateFolder, Found_Volume_Reference_Number, Found_Directory_ID);
	if Result <> noErr then
	begin
		WriteLn('Error while retrieving the Preferences folder information : ', Result);
		Halt;
	end;

	(* Is the PRAM copy file present ? *)
	Result := FSMakeFSSpec(Found_Volume_Reference_Number, Found_Directory_ID, FILE_NAME, FSSpec_PRAM_Data);

	(* The file is present *)
	if Result = noErr then LoadPRAMFromFile
	(* The file was not found, create it *)
	else if Result = fnfErr then SavePRAMToFile
	else WriteLn('Could not determine whether the PRAM data file is present : ', Result);
end.
