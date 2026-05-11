(*
 * Restore the PRAM content from a file.
 * Author : Adrien RICCIARDI
 * Date : 10/05/2026
 *)
program PRAM_Loader;

uses Errors, OSIntf;

const
	FILE_NAME = 'PRAM_Data.bin';

procedure SavePRAMToFile;
var
	File_PRAM: file of SysParmType;
	Result: integer;
	Pointer_PRAM_Area: SysPPtr;
begin
	(* Create the file *)
	Rewrite(File_PRAM, FILE_NAME);
	Result := IOResult;
	if Result <> 0 then
	begin
		WriteLn('Error while creating the PRAM data file : ', Result);
		Exit(SavePRAMToFile);
	end;

	(* Retrieve the PRAM content *)
	Pointer_PRAM_Area := GetSysPPtr;

	(* Store the PRAM area to the file *)
	Write(File_PRAM, Pointer_PRAM_Area^);
	Result := IOResult;
	Close(File_PRAM);
	if Result <> 0 then
	begin
		WriteLn('Error while creating the PRAM data file : ', Result);
		Exit(SavePRAMToFile);
	end;
end;

procedure LoadPRAMFromFile;
var
	File_PRAM: file of SysParmType;
	Result: integer;
	Local_PRAM_Area: SysParmType;
	Pointer_PRAM_Area: SysPPtr;
begin
	(* Open the file again *)
	Reset(File_PRAM, FILE_NAME);
	Result := IOResult;
	if Result <> 0 then
	begin
		WriteLn('Error while opening the PRAM data file : ', Result);
		Exit(LoadPRAMFromFile);
	end;

	(* Load the content without altering the PRAM in low memory *)
	Read(File_PRAM, Local_PRAM_Area);
	Result := IOResult;
	Close(File_PRAM);
	if Result <> eofErr then
	begin
		WriteLn('Error while reading the PRAM data file content : ', Result);
		Exit(LoadPRAMFromFile);
	end;

	(* Update the PRAM content *)
	Pointer_PRAM_Area := GetSysPPtr;
	MoveLeft(Local_PRAM_Area, Pointer_PRAM_Area^, SizeOf(Local_PRAM_Area));
	Result := WriteParam;
	if Result <> 0 then WriteLn('Error while writing to the PRAM area : ', Result);
end;

var
	File_PRAM: file;
	Result: integer;

begin
	(* Is the PRAM copy file present ? *)
	Reset(File_PRAM, FILE_NAME);
	Result := IOResult;
	Close(File_PRAM);

	(* The file is present *)
	if Result = 0 then LoadPRAMFromFile
	(* The file was not found, create it *)
	else if Result = fnfErr then SavePRAMToFile
	else WriteLn('Could not determine whether the PRAM data file is present : ', Result);
end.
