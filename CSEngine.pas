{csengine.pas

        Checksum general data structures and functions.
        Copyright (c) 1990,96 by Rank Bango Ltd.

}

unit CSEngine;

interface

function SumToByte( fileName: string) : byte;
function SumToWord( fileName: string) : word;
procedure CheckIntegrity;


implementation

uses Crt, IOEngine;

function SumToByte;
var
  f: file;
  numRead, i: word;
  buffer: array[1..2048] of byte;
  result: byte;
  IOError: word;
begin
  result := 0;
  Assign( f, filename);

  {$I-}
    Reset( f, 1);
  {$I+}

  IOError := IOResult;
  if IOError <> 0 then
  begin
    WriteLn(#7#7);
    Write( IOReportError( IOError));
    Halt;
  end
  else
  repeat
    BlockRead( f, buffer, sizeOf( buffer), numRead);
    for i := 1 to numRead do
      result := byte( result + buffer[ i]);
  until numRead <> sizeOf( buffer);

  Close( f);
  SumToByte := result;
end;

function SumToWord;
var
  f: file;
  numRead, i: word;
  buffer: array[1..1024] of word;
  result: word;
  extraByte: byte;
  IOError: word;
begin
  result := 0;
  Assign( f, fileName);

  {$I-}
    Reset( f, 1);
  {$I+}

  IOError := IOResult;
  if IOError <> 0 then
  begin
    WriteLn(#7#7);
    Write( IOReportError( IOError));
    Halt;
  end
  else
  repeat
    BlockRead( f, buffer, sizeOf( buffer), numRead);
    for i := 1 to numRead div 2 do
      result := word( result + Swap( buffer[ i]) );
  until NumRead <> sizeOf( buffer);

  if numRead MOD 2 <> 0 then
  begin
    Seek( f, FilePos( f) - 1);
    BlockRead( f, extraByte, sizeOf( extraByte));
    result := word( result + extraByte * 256);
   end;

   Close( f);
   SumToWord := result;
end;

procedure CheckIntegrity;
begin
  Write(' Please wait while checking program integrity ...');
  if (SumToWord( ParamStr( 0)) = 0) then
    WriteLn(' OK')
  else
  begin
    WriteLn;
    WriteLn(#7#7);
    WriteLn('   Integrity checking error. Call us for a new copy.');
    Halt( 1);
  end;
end;

end.

