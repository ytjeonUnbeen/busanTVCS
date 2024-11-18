unit ConvertHex;

interface

uses
  SysUtils, Classes,strutils;

 const
   crc16_table: array[0..255] of Word = (
    $0000, $C0C1, $C181, $0140, $C301, $03C0, $0280, $C241,
    $C601, $06C0, $0780, $C741, $0500, $C5C1, $C481, $0440,
    $CC01, $0CC0, $0D80, $CD41, $0F00, $CFC1, $CE81, $0E40,
    $0A00, $CAC1, $CB81, $0B40, $C901, $09C0, $0880, $C841,
    $D801, $18C0, $1980, $D941, $1B00, $DBC1, $DA81, $1A40,
    $1E00, $DEC1, $DF81, $1F40, $DD01, $1DC0, $1C80, $DC41,
    $1400, $D4C1, $D581, $1540, $D701, $17C0, $1680, $D641,
    $D201, $12C0, $1380, $D341, $1100, $D1C1, $D081, $1040,
    $F001, $30C0, $3180, $F141, $3300, $F3C1, $F281, $3240,
    $3600, $F6C1, $F781, $3740, $F501, $35C0, $3480, $F441,
    $3C00, $FCC1, $FD81, $3D40, $FF01, $3FC0, $3E80, $FE41,
    $FA01, $3AC0, $3B80, $FB41, $3900, $F9C1, $F881, $3840,
    $2800, $E8C1, $E981, $2940, $EB01, $2BC0, $2A80, $EA41,
    $EE01, $2EC0, $2F80, $EF41, $2D00, $EDC1, $EC81, $2C40,
    $E401, $24C0, $2580, $E541, $2700, $E7C1, $E681, $2640,
    $2200, $E2C1, $E381, $2340, $E101, $21C0, $2080, $E041,
    $A001, $60C0, $6180, $A141, $6300, $A3C1, $A281, $6240,
    $6600, $A6C1, $A781, $6740, $A501, $65C0, $6480, $A441,
    $6C00, $ACC1, $AD81, $6D40, $AF01, $6FC0, $6E80, $AE41,
    $AA01, $6AC0, $6B80, $AB41, $6900, $A9C1, $A881, $6840,
    $7800, $B8C1, $B981, $7940, $BB01, $7BC0, $7A80, $BA41,
    $BE01, $7EC0, $7F80, $BF41, $7D00, $BDC1, $BC81, $7C40,
    $B401, $74C0, $7580, $B541, $7700, $B7C1, $B681, $7640,
    $7200, $B2C1, $B381, $7340, $B101, $71C0, $7080, $B041,
    $5000, $90C1, $9181, $5140, $9301, $53C0, $5280, $9241,
    $9601, $56C0, $5780, $9741, $5500, $95C1, $9481, $5440,
    $9C01, $5CC0, $5D80, $9D41, $5F00, $9FC1, $9E81, $5E40,
    $5A00, $9AC1, $9B81, $5B40, $9901, $59C0, $5880, $9841,
    $8801, $48C0, $4980, $8941, $4B00, $8BC1, $8A81, $4A40,
    $4E00, $8EC1, $8F81, $4F40, $8D01, $4DC0, $4C80, $8C41,
    $4400, $84C1, $8581, $4540, $8701, $47C0, $4680, $8641,
    $8201, $42C0, $4380, $8341, $4100, $81C1, $8081, $4040
  );

function HexToByteArr(Hexs: string): Tbytes;
function HexToStr(Hexs: Tbytes): string;
function AnsiStrToHex(const str: string; Len: integer): string; overload;
function AnsiStrToHex(const str: string): string; overload;
function AnsiStrtoByte(const str:AnsiString):Tbytes;

function ByteToAnsiStr(Pkt:Tbytes):AnsiString;overload;
function ByteToAnsiStr(Pkt:array of Byte):AnsiString;overload;
function ByteArrToHex(Hexs: Tbytes): string;overload;
function ByteArrToHex(Hexs: Tbytes;len:Integer): string;overload;

function ByteArrToHexSpace(Hexs: Tbytes): string;overload;
function ByteArrToHexSpace(Hexs: Tbytes;len:Integer): string;overload;
function IsHex(s: string):boolean;

function StringToBytes(const Value : WideString): TBytes;overload;
function BytesToString(const Value: TBytes): WideString;overload;
function StringToBytes(const Value : AnsiString): TBytes;overload;
function StringToAnsiStr(ws:String):AnsiString;


function BytesToString(const Value: TBytes;len:Integer): AnsiString;overload;
function ArrTBytes(Const value:array of byte):Tbytes;

function ByteArrToStr(Bytes:array of Byte;len:Integer):AnsiString;overload;
function ByteArrToStr(Bytes: array of byte;startidx,endidx:Integer): AnsiString;overload;
function ByteArrToStr(Bytes: Tbytes;startidx,endidx:Integer): AnsiString;overload;
function ByteArrToStrLen(Bytes:Tbytes;startidx,len:Integer): AnsiString;
function WideStringAsAnsi(const AValue: WideString): AnsiString;
function WideStringAsBytes(const AValue: WideString): TBytes;

function HexMerge(Hexs:TBytes;startidx,endidx:Integer):Integer;
//
function HexToDec(const HexStr: string): Int64;
function HexToBin(const HexStr: string): string;

function BCD_Byte_To_ASCII(BCD_Byte :BYTE):String;
function BCD_Byte_To_INTEGER(BCD_Byte : BYTE):Integer;
function BCDToStNumber(Data:Byte):String;
function NumStringToBCD(const inStr: string): string;

function SwapEndian32(Value: integer): integer;
function SwapEndian16(Value: Word): Word;
function GetBit(const aValue: Byte; const Bit: Byte): Boolean;
function GetBitStr(const aValue:Byte):String;
function GetRevBitStr(const aValue:Byte):String;
function SetBit(const aValue: Byte; const Bit: Byte): Byte;
function ClearBit(const aValue: Byte; const Bit: Byte): Byte;

function crc16cal(crc: Word; buffer: PByte; len: LongWord): Word;
implementation



function SwapEndian32(Value: integer): integer; register;
asm
  bswap eax
end;

function SwapEndian16(Value: Word): Word; register;
asm
  rol   ax, 8
end;

//set a particular bit as 1
function SetBit(const aValue: Byte; const Bit: Byte): Byte;
begin
  Result := aValue or (1 shl Bit);
end;

//set a particular bit as 0
function ClearBit(const aValue: Byte; const Bit: Byte): Byte;
begin
  Result := aValue and not (1 shl Bit);
end;

function GetBit(const aValue: Byte; const Bit: Byte): Boolean;
begin
  Result := (aValue and (1 shl Bit)) <> 0;
end;

function GetBitStr(const aValue:Byte):String;
var
 i:byte;

begin
  Result:='';
  for I := 0 to 7 do begin
     if (GetBit(aValue,i)) then
         Result:=Result+'1'
     else
         Result:=Result+'0';
  end;

end;
function GetRevBitStr(const aValue:Byte):String;
var
 i:byte;

begin
  Result:='';
  for I := 7 downto 0 do begin
     if (GetBit(aValue,i)) then
         Result:=Result+'1'
     else
         Result:=Result+'0';
  end;

end;




function WideStringAsAnsi(const AValue: WideString): AnsiString;
begin
  SetLength(Result, Length(AValue) * SizeOf(WideChar));
  Move(PWideChar(AValue)^, PAnsiChar(Result)^, Length(Result));
end;

function WideStringAsBytes(const AValue: WideString): TBytes;
begin
  SetLength(Result, Length(AValue) * SizeOf(WideChar));
  Move(PWideChar(AValue)^, PByte(Result)^, Length(Result));
end;
function ArrTbytes(Const value:array of byte):Tbytes;
begin
SetLength(Result,length(value));
if (Length(Result)>0) then
  Move(Value[0],Result[0],length(Result));
end;

function HexToInt(const Value: string): LongWord;
const
  HexStr: String = '0123456789abcdef';
var
  i: Word;
begin
  Result := 0;
  if Value = '' then Exit;
  for i := 1 to Length(Value) do
    Inc(Result, (Pos(Value[i], HexStr) - 1) shl ((Length(Value) - i) shl 2));
end;


function StringToAnsiStr(ws:String):AnsiString;
var
 DataLen:Integer;
 tempStr:String;
 DataBuf:TBytes;
begin
  DataLen:=Length(ws)*2;
  SetLength(DataBuf,DataLen);
  Move(ws[1],DataBuf[0],DataLen);
  Result:=ByteToAnsiStr(DataBuf);
end;

function StringToBytes(const Value : WideString): TBytes;
begin
  SetLength(Result, Length(Value)*SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(Value[1], Result[0], Length(Result));
end;

function BytesToString(const Value: TBytes): WideString;
begin
  SetLength(Result, Length(Value) div SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(Value[0], Result[1], Length(Value));
end;
function StringToBytes(const Value : AnsiString): TBytes;
begin
  SetLength(Result, Length(Value)*SizeOf(AnsiString));
  if Length(Result) > 0 then
    Move(Value[1], Result[0], Length(Result));
end;



function BytesToString(const Value: TBytes;len:Integer): AnsiString;
begin
 Result:=ByteArrToStr(Value,len);
end;


function IsHex(s: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to length(s) do
    if not (char(s[i]) in ['0'..'9']) and not (char(s[i]) in ['A'..'F']) then
    begin
      Result := False;
      exit;
    end;
end;

function ByteToAnsiStr(Pkt:Tbytes):AnsiString;
var
     i: integer;
begin
  Result := '';
  for i := low(Pkt) to high(Pkt) do
    Result := Result + AnsiChar(Pkt[i]);

end;
function ByteToAnsiStr(Pkt:array of byte):AnsiString;
var
     i: integer;
begin
  Result := '';
  for i := low(Pkt) to high(Pkt) do
    Result := Result + AnsiChar(Pkt[i]);

end;


function CharToByte(AChar: Char): byte; //Ascii Code
begin
  if charinset(AChar, ['0' .. '9']) then
    Result := byte(Ord(AChar) - Ord('0'))
  else
    Result := byte(10 + Ord(AChar) - Ord('A'));
end;

function ByteArrToHex(Hexs: Tbytes): string;
var
  i: integer;
begin
  Result := '';
  for i := low(Hexs) to high(Hexs) do
    Result := Result + inttohex(Hexs[i], 2);
end;
function ByteArrToHex(Hexs: Tbytes;len:Integer): string;
var
  i: integer;
begin
  Result := '';
  for i := low(Hexs) to len-1 do
    Result := Result + inttohex(Hexs[i], 2);
end;


function ByteArrToHexSpace(Hexs: Tbytes): string;
var
  i: integer;
begin
  Result := '';
  for i := low(Hexs) to high(Hexs) do
    Result := Result + inttohex(Hexs[i], 2)+' ';

  Result:=Trim(Result);
end;

function ByteArrToHexSpace(Hexs: Tbytes;len:Integer): string;
var
  i: integer;
begin
  Result := '';
  for i := low(Hexs) to len-1 do
    Result := Result + inttohex(Hexs[i], 2)+' ';
  Result:=Trim(Result);

end;

function ByteArrToStr(Bytes: array of byte;len:Integer): AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := 0 to len-1 do
    Result := Result + AnsiChar(Bytes[i]);

end;

function ByteArrToStr(Bytes: array of byte;startidx,endidx:Integer): AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := startidx to endidx do
    Result := Result + AnsiChar(Bytes[i]);
end;

function ByteArrToStr(Bytes:Tbytes;startidx,endidx:Integer): AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := startidx to endidx do
    Result := Result + AnsiChar(Bytes[i]);

end;

function ByteArrToStrLen(Bytes:Tbytes;startidx,len:Integer): AnsiString;
var
  i: integer;
begin
  Result := '';
  for i := startidx to startidx+len-1 do
    Result := Result + AnsiChar(Bytes[i]);


end;



function HexMerge(Hexs:TBytes;startidx,endidx:Integer):Integer;
var
 i:Integer;
 Value:Word;
 HexStr:String;
begin
  HexStr:='';
  for I := startidx to endidx do
  begin
     HexStr:=HexStr+Format('%x',[Hexs[i]]);
  end;

  Result:=StrToInt(HexStr);
end;


function HexToByteArr(Hexs: string): Tbytes; //String Hex -> Byte Array
var
  i: integer;
  byDynamicArray: Tbytes;
begin
  Hexs := stringreplace(Hexs, ' ', '', [rfReplaceAll]); // Space ' ' -> Null
  Hexs := stringreplace(Hexs, '-', '', [rfReplaceAll]); // - ' ' -> Null
  Hexs := UpperCase(Hexs);

  setlength(byDynamicArray, trunc(length(Hexs) / 2));
  fillchar(byDynamicArray[0], sizeof(byDynamicArray), 0);

  for i := 1 to trunc(length(Hexs) / 2) do // Hex -> Byte Arr
  begin
    byDynamicArray[i - 1] := (CharToByte(Hexs[i * 2 - 1]) * 16) + CharToByte(Hexs[i * 2]);
  end;
  Result := byDynamicArray;
end;

function HexToStr(Hexs: Tbytes): string; //Byte Array -> String Hex
var
  i: integer;
  charValue: byte;
  temp: ansistring;

begin
  temp := '';
  for i := Low(Hexs) to High(Hexs) do
  begin
    charValue := Hexs[i];
    temp := temp + ansiChar(charValue);
  end;
  Result := string(temp);

  if pos(#0, Result) <> 0 then
    Result := copy(Result, 1, pos(#0, Result) - 1);
end;


function AnsiStrtoByte(const str:AnsiString):Tbytes;
var
 Hex:String;
begin

    Hex:=AnSiStrToHex(str);
    Result:=HexToByteArr(hex);

end;
function AnsiStrToHex(const str: string; Len: integer): string; overload; //고정 길이 Hex
var
  Index: integer;
  temp: ansistring;

begin
  Result := '';
  temp := ansistring(str);

  for Index := 1 to Len do
    if length(temp) < Index then //문자열 길이를 초과하면 '00' 으로 채움
      Result := Result + '00'
    else
      Result := Result + inttohex(Ord(temp[Index]), 2);
end;

function AnsiStrToHex(const str: string): string; overload;
var
  Index: integer;
  temp: ansistring;

begin
  Result := '';
  temp := ansistring(str);

  for Index := 1 to length(temp) do
    Result := Result + inttohex(Ord(temp[Index]), 2);
end;

function crc16cal(crc: Word; buffer: PByte; len: LongWord): Word;
begin
  while (len <> 0) do
  begin
    crc := Word((crc shr 8) xor crc16_table[(crc xor buffer^) and $FF]);
    Inc(buffer);
    Dec(len);
  end;
  Result := crc;
end;

function CalculateBCC(const Data: array of Byte; StartIndex, Length: Integer): Byte;
var
  i: Integer;
  BCC: Byte;
begin
  BCC := 0;
  for i := StartIndex to StartIndex + Length - 1 do
    BCC := BCC xor Data[i];
  Result := BCC;
end;


function HexToDec(const HexStr: string): Int64;
var
  i: Integer;
  Ch: Char;
begin
  Result := 0;
  for i := 1 to Length(HexStr) do
  begin
    Ch := UpCase(HexStr[i]);
    if CharInSet(Ch, ['0'..'9']) then
      Result := Result * 16 + Ord(Ch) - Ord('0')
    else if CharInSet(Ch, ['A'..'F']) then
      Result := Result * 16 + Ord(Ch) - Ord('A') + 10
    else
      raise Exception.Create('Invalid hexadecimal character: ' + Ch);
  end;
end;

function HexToBin(const HexStr: string): string;
var
  i: Integer;
  Ch: Char;
  Value: Integer;
begin
  Result := '';
  for i := 1 to Length(HexStr) do
  begin
    Ch := UpCase(HexStr[i]);
    if CharInSet(Ch, ['0'..'9']) then
      Value := Ord(Ch) - Ord('0')
    else if CharInSet(Ch, ['A'..'F']) then
      Value := Ord(Ch) - Ord('A') + 10
    else
      raise Exception.Create('Invalid hexadecimal character: ' + Ch);

    //Result := Result + HexToBinMap[Value];
  end;
end;

function BCDToByte(Value: Integer): Integer;
begin
  Result := (Value and $F);
  Result := Result + (((Value shr 4) and $F) * 10);
  Result := Result + (((Value shr 8) and $F) * 100);
  Result := Result + (((Value shr 16) and $F) * 1000);
end;

// Integer to BCD
function ByteToBCD(Value: Integer): Integer;
begin
  Result :=                   Value div 1000 mod 10;
  Result := (Result shl 4) or Value div  100 mod 10;
  Result := (Result shl 4) or Value div   10 mod 10;
  Result := (Result shl 4) or Value          mod 10;
end;

function BCD_Byte_To_ASCII(BCD_Byte : BYTE):String;
BEGIN
    Result :=     CHR( ORD( '0' ) + ( BCD_Byte MOD 16 ) )
                        +  CHR( ORD( '0' ) + ( BCD_Byte DIV 16 ) );
END;
function BCD_Byte_To_INTEGER(BCD_Byte : BYTE):Integer;
BEGIN
    Result :=    ( BCD_Byte MOD 16 ) * 10
                          + ( BCD_Byte DIV 16 );
END;

function BCDToStNumber(Data:Byte):String;
var
  tmp,pos1,pos2:String;
begin
  tmp:=Format('%.2x',[Data]);

 if (MidStr(tmp,1,1)='F') then
   pos1:='0'
 else
   pos1:=MidStr(tmp,1,1);

  if (MidStr(tmp,2,1)='F') then
   pos2:='0'
  else
   pos2:=MidStr(tmp,2,1);

  Result:=pos1+pos2;
end;

 function NumStringToBCD(const inStr: string): string;
  function Pack(ch1, ch2: Char): Char;
  begin
    Assert((ch1 >= '0') and (ch1 <= '9'));
    Assert((ch2 >= '0') and (ch2 <= '9'));
      {Ord('0') is $30, so we can just use the low nybble of the character
       as value.}
    Result := Chr((Ord(ch1) and $F) or ((Ord(ch2) and $F) shl 4))
  end;
var
  i: Integer;
begin
  if Odd(Length(inStr)) then
    Result := NumStringToBCD('0' + instr)
  else begin
    SetLength(Result, Length(inStr) div 2);
    for i := 1 to Length(Result) do
      Result[i] := Pack(inStr[2 * i - 1], inStr[2 * i]);
  end;
end;




end.
