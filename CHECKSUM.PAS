{checksum.pas

                   Copyright (c) November 1992 by Rank Bango


}

uses Crt, Dos, Globals, CSEngine, IOEngine;

type
  Str2 = string[ 2];

var
   AnOption: Str2;

procedure ShowUsage;
begin
  WriteLn;
  WriteLn('  CheckSummer    version 2.0   Copyright (c) 1992 by Rank Bango ');
  WriteLn;
  WriteLn('      Usage:                                                   ');
  WriteLn('         CheckSum   option   filename                          ');
  WriteLn;
  WriteLn('     Options:                                                  ');
  WriteLn('       -s  :  show file''s checksum                             ');
  WriteLn('       -c  :  check if file''s checksum is equal to 0           ');
  WriteLn('       -m  :  make file''s checksum equal to 0                  ');
  Halt;
end;


function GetParams : Str2;

begin
  case ParamCount of
    0: ShowUsage;

    1: begin
         if (ParamStr( 1) = '-s') or (ParamStr( 1) = '-c') or (ParamStr( 1) = '-m') then
         begin
           WriteLn(#7#7);
           WriteLn('Error  :   FileName expected');
           ShowUsage;
         end
         else
         begin
           WriteLn(#7#7);
           WriteLn('Error  :   Incorrect option');
           ShowUsage;
         end;
       end;
    2: begin
         if (ParamStr( 1) = '-s') or (ParamStr( 1) = '-c') or (ParamStr( 1) = '-m') then
           GetParams := ParamStr( 1)
         else
           begin
             WriteLn(#7#7);
             WriteLn('Error  :   Incorrect option');
             ShowUsage;
           end;
       end;
    else
    begin
      WriteLn(#7#7);
      WriteLn('Error  :   Too many parameters');
      ShowUsage;
    end;
  end;
end;

procedure MakeChecking( var option : Str2);

var
  f: file;
  Sum, difference: word;
	size: longInt;
  Answer: char;

begin

  Sum := SumToWord( ParamStr(2));   { Aqui controlo si sumo a byte o a word }

  if option = '-s' then
  begin
    Write( UpCaseStr( ParamStr( 2)),'''s checksum is equal to ',Sum);
    Exit;
  end;

  if option = '-c' then
  begin
    if Sum = 0 then
       Write(UpCaseStr( ParamStr( 2)),'''s integrity is OK')
    else
    begin
       WriteLn('Problems with ',UpCaseStr( ParamStr( 2)),'''s integrity');
       repeat
         Write('Would you like to correct this problem ? (Y/N) ');
         ReadLn(Answer);

         if (Answer = 'Y') or (Answer = 'y') then
            option := '-m';

         if (Answer = 'N') or (Answer = 'n') then
         begin
           Write( UpCaseStr( ParamStr( 2)),'''s checksum is equal to ',Sum);
					 Exit;
         end

         else
         if not ((Answer = 'Y') or (Answer = 'y') or (Answer = 'N') or (Answer = 'n')) then
         begin
           WriteLn(#7#7);
           WriteLn('  Error');
         end;

       until (Answer = 'Y') or (Answer = 'y') or (Answer = 'N') or (Answer = 'n');
    end;
  end;

  if option = '-m' then
  begin
    if Sum <> 0 then
    begin
      Assign( f, ParamStr(2));
      Reset( f, 1);
			size := FileSize( f);
      difference := 65536 - Sum;
			if size MOD 2 = 0 then
      	 difference := Swap( difference); { In order to make it compatible to BlockRead way to places chars in the word }
      Seek( f, size);
      BlockWrite( f, difference, SizeOf( difference));
      Close( f);
      Write('Problems with ',UpCaseStr( ParamStr( 2)),'''s integrity have been fixed')
    end
    else
       Write(UpCaseStr( ParamStr( 2)),'''s integrity is OK')
  end;
end;

begin
  CheckIntegrity;
  AnOption := GetParams;    {  Es necesaria la variable porque luego la paso por dirreccion }
  MakeChecking( AnOption);
end.
