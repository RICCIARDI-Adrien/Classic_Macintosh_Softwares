(*
 * Restore the PRAM content from a file.
 * Author : Adrien RICCIARDI
 * Date : 10/05/2026
 *)
unit PRAM_Loader;

interface

uses Errors, Files, Folders, OSIntf, Script, SysEqu;

const
	FILE_NAME = 'PRAM Loader Preferences';
	MOUSE_SPEED_SETTINGS_BYTES_COUNT = 8;
	MOUSE_SPEED_SETTINGS_OFFSET = 20;

var
	Pointer_Mouse_Speed_Settings: ^SignedByte; (* The SignedByte is the only type that really refers to a 8-bit byte, Char or Byte are both 2-byte wide *)

procedure EntryPoint;

implementation

function GetPreferenceFileFSSpec(var File_Specifications: FSSpec): OSErr; forward;
procedure SaveDataToFile; forward;
procedure LoadDataFromFile; forward;

(* The first appearing procedure is the entry point *)
procedure EntryPoint;
var
	FSSpec_PRAM_Data: FSSpec;
	Result: integer;
	Pointer_Mickey_Stuff: ^longint;
begin
	Result := GetPreferenceFileFSSpec(FSSpec_PRAM_Data);

	(* The MickeyBytes system global variables points to the mouse settings *)
	Pointer_Mickey_Stuff := Pointer(MickeyBytes);
	Pointer_Mouse_Speed_Settings := Pointer(Ord4(Pointer_Mickey_Stuff^) + MOUSE_SPEED_SETTINGS_OFFSET);

	(* The file is present *)
	if Result = noErr then LoadDataFromFile
	(* The file was not found, create it *)
	else if Result = fnfErr then SaveDataToFile;
end;

function GetPreferenceFileFSSpec(var File_Specifications: FSSpec): OSErr;
var
	Result, Found_Volume_Reference_Number: integer;
	Found_Directory_ID: longint;
begin
	(* The PRAM data file is stored in the system Preferences directory, retrieve its path *)
	Result := FindFolder(kOnSystemDisk, kPreferencesFolderType, kDontCreateFolder, Found_Volume_Reference_Number, Found_Directory_ID);
	if Result <> noErr then
	begin
		GetPreferenceFileFSSpec := Result;
		Exit(GetPreferenceFileFSSpec);
	end;

	(* Is the PRAM copy file present ? *)
	GetPreferenceFileFSSpec := FSMakeFSSpec(Found_Volume_Reference_Number, Found_Directory_ID, FILE_NAME, File_Specifications);
end;

procedure SaveDataToFile;
var
	FSSpec_PRAM_Data: FSSpec;
	File_Reference_Number, Result: integer;
	Pointer_PRAM_Area: SysPPtr;
	Count: longint;
begin
	Result := GetPreferenceFileFSSpec(FSSpec_PRAM_Data);
	(* Ignore the "file not found" error because the file is missing when we enter this procedure *)
	if (Result <> noErr) and (Result <> fnfErr) then Exit(SaveDataToFile);

	(* Create the file *)
	Result := FSpCreate(FSSpec_PRAM_Data, '????', 'pref', smSystemScript);
	if Result <> noErr then Exit(SaveDataToFile);

	(* Open it in write mode *)
	Result := FSpOpenDF(FSSpec_PRAM_Data, fsWrPerm, File_Reference_Number);
	if Result <> noErr then Exit(SaveDataToFile);

	(* Retrieve the PRAM content *)
	Pointer_PRAM_Area := GetSysPPtr;

	(* Store the PRAM area content to the file *)
	Count := SizeOf(SysParmType);
	Result := FSWrite(File_Reference_Number, Count, ptr(Pointer_PRAM_Area));
	if Result <> noErr then
	begin
		Result := FSClose(File_Reference_Number);
		Exit(SaveDataToFile);
	end;

	(* Store the mouse speed settings *)
	Count := MOUSE_SPEED_SETTINGS_BYTES_COUNT;
	Result := FSWrite(File_Reference_Number, Count, Pointer(Pointer_Mouse_Speed_Settings));

	(* Close the file in any case *)
	Result := FSClose(File_Reference_Number);
	if Result <> noErr then Exit(SaveDataToFile);

	(* Ensure that the file's catalog entry is updated *)
	Result := FlushVol(nil, FSSpec_PRAM_Data.vRefNum);
end;

procedure LoadDataFromFile;
var
	FSSpec_PRAM_Data: FSSpec;
	File_Reference_Number, Result: integer;
	Local_PRAM_Area: SysParmType;
	Pointer_PRAM_Area: SysPPtr;
	Count: longint;
begin
	Result := GetPreferenceFileFSSpec(FSSpec_PRAM_Data);
	if Result <> noErr then Exit(LoadDataFromFile);

	(* Open the file in read mode *)
	Result := FSpOpenDF(FSSpec_PRAM_Data, fsRdPerm, File_Reference_Number);
	if Result <> noErr then Exit(LoadDataFromFile);

	(* Load the content without altering the PRAM in low memory *)
	Count := SizeOf(SysParmType);
	Result := FSRead(File_Reference_Number, Count, @Local_PRAM_Area);
	if Result <> noErr then
	begin
		Result := FSClose(File_Reference_Number);
		Exit(LoadDataFromFile);
	end;

	(* Update the PRAM content *)
	Pointer_PRAM_Area := GetSysPPtr;
	BlockMove(@Local_PRAM_Area, Pointer_PRAM_Area, SizeOf(Local_PRAM_Area));
	Result := WriteParam;
	if Result <> noErr then
	begin
		Result := FSClose(File_Reference_Number);
		Exit(LoadDataFromFile);
	end;

	(* Load the mouse speed settings *)
	Count := MOUSE_SPEED_SETTINGS_BYTES_COUNT;
	Result := FSRead(File_Reference_Number, Count, Pointer(Pointer_Mouse_Speed_Settings));

	(* Close the file in any case *)
	Result := FSClose(File_Reference_Number);
end;

end.
