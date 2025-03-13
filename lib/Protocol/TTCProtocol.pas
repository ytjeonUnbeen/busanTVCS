unit TTCProtocol;

interface
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,StrUtils,system.DateUtils,convertHex;

  const
  HexToBinMap: array[0..15] of string = (
    '0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',
    '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111'
  );

  Line4StationName: array[0..14] of string = (
    '미남', '동래', '수안', '낙민', '충렬사', '명장', '서동', '금사',
    '반여농산물시장', '석대', '영산대', '동부산대학', '고촌', '안평', '입출고 선'
  );

  Line4DestStationName: array[0..2] of string = (
    '미남','금사','안평'
  );

  // 4호선 접근 코드 목록
  Line4ApproachCodes: array[0..27] of string = (
  '401_0113T', '402_0125T', '403_0133T', '404_0507T', '405_0515T',
  '406_0523T', '407_0533T', '408_0813T', '409_0823T', '410_0835T',
  '411_1113T', '412_1123T', '413_1131T', '414_27LT1', '401_204T',
  '402_0124T', '403_0130T', '404_0502T', '405_0512T', '406_0518T',
  '407_0528T', '408_0808T', '409_0816T', '410_0826T', '411_1110T',
  '412_1120T', '413_1128T', '414_201AT'
  );

  // 4호선 도착 코드 목록
  Line4ArriveCodes: array[0..27] of string = (
    '401_1LT1', '402_0123T', '403_0131T', '404_0505T', '405_0513T',
    '406_0521T', '407_0531T', '408_1LT', '409_0821T', '410_0833T',
    '411_1111T', '412_1121T', '413_1129T', '414_23LT1', '401_30LT2',
    '402_0126T', '403_0132T', '404_0504T', '405_0514T', '406_0520T',
    '407_0530T', '408_24LT2', '409_0818T', '410_0828T', '411_1112T',
    '412_1122T', '413_1130T', '414_26RT'
  );

  // 4호선 출발 코드 목록
  Line4DepartCodes: array[0..27] of string = (
    '401_203T', '402_0121T', '403_0129T', '404_0503T', '405_0511T',
    '406_0519T', '407_0529T', '408_3LT', '409_0819T', '410_0831T',
    '411_1109T', '412_1119T', '413_1127T', '414_201BT', '401_2RT',
    '402_0128T', '403_0134T', '404_0506T', '405_0516T', '406_0522T',
    '407_0532T', '408_6RT', '409_0820T', '410_0830T', '411_1114T',
    '412_1124T', '413_1132T', '414_1412T'
  );


  Line4ApproachThresholds: array[401..414] of string = (
    '0113T',  // 401 미남
    '0125T',  // 402 동래
    '0133T',  // 403 수안
    '0507T',  // 404 낙민
    '0515T',  // 405 충렬사
    '0523T',  // 406 명장
    '0533T',  // 407 서동
    '0813T',  // 408 금사
    '0823T',  // 409 반여농산물시장
    '0835T',  // 410 석대
    '1113T', // 411 영산대
    '1123T', // 412 동부산대학
    '1131T', // 413 고촌
    '27LT1'   // 414 안평
  );



  Line3StationName: array [0..16] of string = (
    '수영','망미','배산','문만골','연산','거제','종합운동장','사직','미남','만덕',
    '남산정','숙등','덕천','구포','강서구청','체육공원','대저'
  );

  Line2StationName: array [0..42] of string = (
    '장산','중동','해운대','동백','벡스코','센텀시티','민락','수영','광안','금련산','남천','경성대부경대',
    '대연','못골','지게골','문현','국제금융센터부산은행','전포','서면','부암','가야','동의대','개금','냉정',
    '주례','감전','사상','덕포','모덕','모라','구남','구명','덕천','수정','화명','율리','동원','금곡','호포',
    '증산','부산대양산캠퍼스','남양산','양산'
  );



  PKT_STX=$02;
  PKT_LINE2_STX=$ED;
  PKT_ETX=$03;

  PKT_LINE1_DEPART=$B1;
  PKT_LINE1_APPROACH=$B3;
  PKT_LINE1_ARRIVE=$B2;

  //2호선
  PKT_LINE2_DEPART=$85;
  PKT_LINE2_APPROACH=$89;
  PKT_LINE2_ARRIVE=$88;

  PKT_LINE3_DEPART=$85;
  PKT_LINE3_APPROACH=$86;
  PKT_LINE3_ARRIVE=$87;




  PKT_LINE5_ALLOC=$07;


 type
  
    TPktDateTime= packed record
       dYear :byte;
       dMonth:byte;
       dDay:byte;
       dHour:byte;
       dMinute:byte;
       dSecond:byte;
    end;


    TTTCProtocol=class(TObject)
        FPktBuf:TBytes;
        FPacketSize:Integer;
        FLineNo:Integer;
        FStx:Byte;

        {
         4호선 Only
        AC: Polling
        07: 열차 점유정보 -->이것만 사용
        17: 당일스케쥴종류전송
        08: 스케쥴전송시작
        09: 스케쥴헤더
        0A: 스케쥴전송종료
        22: 마스터스케줄body
        23: 실시간스케줄헤더
        24: 마스터스케줄bod
      }
        FOpCode:Byte;
        FSeq:Byte;
        FDataLen:Word;
       // FPktDate:TTTCPktDate;           //
        FPktDate:TDateTime;           //

        FArriveStationNo:Word;
//        FArriveStationName:String;
        FTrainDirection:Byte;

        FThisDestStationNo:Word;
        FNextDestStationNo:Word;

        FThisTraionNo:Word;
        FNextTraionNo:Word;

        FThisTrainType:Byte;
        FNextTrainType:Byte;

        FFormingNo:Word;
        FTCode:String;
        FStopTime:Byte;


        FCrcValue:Word;
        FEtx:Byte;
        FBcc:Byte;


     public
       constructor Create;overload;
       constructor Create(lineno:Integer);overload;
       function ReadPacket(Pkt:TBytes;size:Integer):Integer;
       procedure InitPacket(aOpCode,aSeq,aDirection,aArrStNo,aFormNo:Byte);
       procedure SetThisTrainInfo(aDestStNo,aTrainNo:Word;aTrainType:Byte);
       procedure SetNextTrainInfo(aDestStNo,aTrainNo:Word;aTrainType:Byte);
       procedure SetTCode(aCode:String);
       procedure MakePacket;

     published
       property LineNo:Integer read FLineNo;
       property Opcode:Byte Read FOpCode;
       property Seq:Byte Read FSeq;
       property DataLen:Word Read FDataLen;
       property StopTime:Byte read FStopTime Write FStopTime;
       property PktDate:TDateTime Read FPktDate;
       property Direction:Byte Read FTrainDirection;
       property ArrStationNo:Word Read FArriveStationNo;
       property ThisDestStationNo:Word Read FThisDestStationNo;
       property NextDestStationNo:Word Read FNextDestStationNo;
       property ThisTrainNo:Word Read FThisTraionNo;
       property NextTraionNo:Word Read FNextTraionNo;
       property ThisTrainType:Byte Read FThisTrainType;
       property NextTrainType:Byte Read FNextTrainType;
       property CrcValue:Word Read FCrcValue;
       property BCC:byte Read FBcc;
       property FormingNo:Word Read FFormingNo;
       property TCode:String Read FTcode;
       property PacketSize:integer Read FPacketSize;
       property PacketBuf:TBytes Read FPktBuf;


  end;




function ProcessStationName(const Value: Byte; Line: Integer): string;
function ProcessTrainDirection(const Value: Byte; line: integer): string;
implementation




constructor TTTCProtocol.Create;
begin
       inherited;
       FLineNo:=2;   //default
end;
constructor TTTCProtocol.Create(lineno:Integer);
begin
    inherited Create;

    FLineNo:=lineno;   //
    FPacketsize:=0;
    FEtx:=$3;

end;
procedure TTTCProtocol.InitPacket(aOpCode,aSeq,aDirection,aArrStNo,aFormNo:Byte);
begin
    if (FLineNo=2) then begin
       FStx:=PKT_LINE2_STX
    end
    else begin
        FStx:=PKT_STX;
    end;
    FOpCode:=aOpCode;
    FSeq:=aSeq;
    FTrainDirection:=aDirection;
    FArriveStationNo:=aArrStno;
    FFormingNo:=aFormNo;
end;

procedure TTTCProtocol.SetThisTrainInfo(aDestStNo,aTrainNo:Word;aTrainType:Byte);
begin
    FThisDestStationNo:=aDestStNo;
    FThisTraionNo:=aTrainNo;
    FThisTrainType:=aTrainType;

end;
procedure  TTTCProtocol.SetNextTrainInfo(aDestStNo,aTrainNo:Word;aTrainType:Byte);
begin
    FNextDestStationNo:=aDestStNo;
    FNextTraionNo:=aTrainNo;
    FNextTrainType:=aTrainType;
end;

procedure TTTCProtocol.SetTCode(aCode:String);
begin
   FTcode:=aCode;
end;

procedure TTTCProtocol.MakePacket;
var
 templen,pos:Integer;
 strNo:AnsiString;
 crcval:Word;
begin
   case FLineNo of
    1:
     begin
       if (FOpcode=$B2) then begin
          FPacketSize:=26;
          FDataLen:=$14;
         end
       else begin
          FPacketSize:=25;
          FDataLen:=$13;
       end;
        FPktDate:=Now;
     end;
    2:
     begin
         if (FOpcode=$85) then  begin
           FPacketSize:=18;
           FDataLen:=$0E;
         end
         else begin
           FPacketSize:=13;
           FDataLen:=$09;
         end;
     end;
    3:
     begin
           FPacketSize:=20;
     end;
    4:
     begin
         FPacketSize:=26;
     end;
   end;
   SetLength(FPktBuf,FPacketSize);

   FPktBuf[0]:=FStx;
   if (FLineNo=1) then begin
      FPktBuf[1]:=LoByte(FDataLen);
      FPktBuf[2]:=HiByte(FDataLen);
      FPktBuf[3]:=FSeq;
      FPktBuf[4]:=FOpCode;
      FPktBuf[5]:=$0; //spare
      FPktbuf[6]:=Yearof(FPktDate);FPktbuf[7]:=Monthof(FPktDate);FPktbuf[8]:=Dayof(FPktDate);
      FPktbuf[9]:=Hourof(FPktDate);FPktbuf[10]:=Minuteof(FPktDate);FPktbuf[11]:=Secondof(FPktDate);
      FPktBuf[12]:=FArriveStationNo;
      FPktBuf[13]:=FTrainDirection;FPktBuf[14]:=FThisDestStationNo;
      FPktBuf[15]:=FNextDestStationNo;
      strNo:=Format('%.4d',[FThisTraionNo]);
      FPktbuf[16]:=StrToInt('$'+MidStr(strNo,1,2));
      FPktbuf[17]:=StrToInt('$'+MidStr(strNo,3,2));
      strNo:=Format('%.4d',[FNextTraionNo]);
      FPktbuf[18]:=StrToInt('$'+MidStr(strNo,1,2));
      FPktbuf[19]:=StrToInt('$'+MidStr(strNo,3,2));
      FPktBuf[20]:=FThisTrainType;FPktBuf[21]:=FNextTrainType;
      if (FOpCode=$B2) then begin
        FPktBuf[21]:=FStopTime;
        crcval:=crc16cal(crcval,PByte(FPktBuf),22); // crc 전까지
        FPktBuf[23]:=LoByte(crcval);FPktBuf[24]:=HiByte(crcval);
        FPktBuf[25]:=FEtx;
      end
      else begin
        crcval:=crc16cal(crcval,PByte(FPktBuf),21); // crc 전까지
        FPktBuf[22]:=LoByte(crcval);FPktBuf[23]:=HiByte(crcval);
        FPktBuf[24]:=FEtx;
      end;
   end;

   // 2-4호선 작성 필요

end;




function TTTCProtocol.ReadPacket(Pkt:TBytes;size:Integer):Integer;
var
 pktdate:TPktDateTime;
begin


    if (FLineNo=2) then begin
     if (Pkt[0]<>PKT_LINE2_STX) then begin
        Result:=-1;
        exit;
     end;
    end
    else begin
     if (Pkt[0]<>PKT_STX) then begin
        Result:=-1;
        exit;
     end;

    end;




    case FLineNo of
     1:
      begin

         FDataLen:=MakeWord(Pkt[2],Pkt[1]);
         if not ((FDataLen<>$13) or (FDataLen<>$14))  then begin       //check
            Result:=-1;
            exit;


         end;

         FOpCode:=Pkt[4];
         if not ((FOpCode=PKT_LINE1_DEPART) or (FOpCode=PKT_LINE1_APPROACH) or (FOpCode=PKT_LINE1_ARRIVE)) then
         begin
             Result:=-1;
             exit;

         end;
         FSeq:=Pkt[3];
         CopyMemory(@pktdate,@Pkt[6],6);
         FPktDate:=EncodeDateTime(pktdate.dYear,pktdate.dMonth,pktdate.dDay,
                                  pktdate.dHour,pktdate.dMinute,pktdate.dSecond,0);
         //12
         FArriveStationNo:=Pkt[12];
         FTrainDirection:=Pkt[13];
         FThisDestStationNo:=Pkt[14];
         FNextDestStationNo:=Pkt[15];
         FThisTraionNo:=HexMerge(Pkt,16,17);
         FNextTraionNo:=hexMerge(Pkt,18,19);
         FThisTrainType:=Pkt[20];
         FNextTrainType:=Pkt[21];
         if (FOpCode=$B2) then begin
           FStopTime:=Pkt[22];
           FCrcValue:=MakeWord(Pkt[24],Pkt[23]);
         end
         else begin

           FCrcValue:=MakeWord(Pkt[23],Pkt[22]);
         end;
      end;
     2:
      begin
        FDataLen:=Pkt[1];
         if not ((FDataLen=$0E) or (FDataLen=$09)) then begin
            Result:=-1;
            exit;


         end;
        FSeq:=Pkt[2];
        FOpCode:=Pkt[3]; // 85 88 89
        if not ((FOpCode=PKT_LINE2_DEPART) or (FOpCode=PKT_LINE2_APPROACH) or (FOpCode=PKT_LINE2_ARRIVE)) then
         begin
             Result:=-1;
             exit;

         end;

        FArriveStationNo:=200+Pkt[4];
        FTrainDirection:=Pkt[5]; // 00,01
        FThisDestStationNo:=200+Pkt[6];
        if (FOpCode=PKT_LINE2_DEPART) then begin
          FNextDestStationNo:=200+Pkt[7];
          FThisTraionNo:=StrToInt(ByteArrToStr(Pkt,8,11));
          FNextTraionNo:=StrToInt(ByteArrToStr(Pkt,12,15));
          FBcc:=Pkt[17];
        end
        else begin
         FThisTraionNo:=StrToInt(ByteArrToStr(Pkt,7,10));
         FNextDestStationNo:= FThisDestStationNo;
         FNextTraionNo:=0;


         FBcc:=Pkt[12];

        end;

      end;
     3:
      begin

        FOpCode:=Pkt[1];
        if not ((FOpCode=PKT_LINE3_DEPART) or (FOpCode=PKT_LINE3_APPROACH) or (FOpCode=PKT_LINE3_ARRIVE)) then
         begin
             Result:=-1;
             exit;

         end;


        FSeq:=Pkt[2];
        FDataLen:=Pkt[3];
        if (FDataLen<>$8E) then begin
            Result:=-1;
            exit;


         end;

        FArriveStationNo:=252+Pkt[4];  // 3A  -> 300+Ord($A) 계산 필요 하지만 Base 31:301 31->301-49=252 일렬증가
        FTrainDirection:=Pkt[5];
        FThisDestStationNo:=252+Pkt[6];
        FNextDestStationNo:=252+Pkt[7];
        FThisTraionNo:=StrToInt(ByteArrToStr(Pkt,8,11));
        FNextTraionNo:=StrToInt(ByteArrToStr(Pkt,12,15));
        FThisTrainType:=Pkt[16];
        FNextTrainType:=Pkt[17];
        FBcc:=Pkt[18];

      end;
     4:
      begin
        FDataLen:=Pkt[1];
       if (FDataLen<>$13) then begin
            Result:=-1;
            exit;
        end;
        FSeq:=Pkt[2];
        FOpCode:=Pkt[3]; // 07 고정
        if (FOpCode<>PKT_LINE5_ALLOC) then begin
            Result:=-1;
            exit;
        end;
        FArriveStationNo:=400+Pkt[4];
        FTrainDirection:=Pkt[5]; //01:상행 ,02:하행
        FThisDestStationNo:=400+Pkt[6];
        FFormingNo:=StrToInt(ByteArrToStr(Pkt,7,8));
        FThisTraionNo:=StrToInt(ByteArrToStr(Pkt,9,12));
        FTCode:=ByteArrToStr(Pkt,13,22);
        FCrcValue:=MakeWord(Pkt[24],Pkt[23]);
      end;
    end;
    FPacketsize:=size;
    FPktBuf:=Pkt;

    Result:=FDataLen;

end;





function ProcessStationName(const Value: Byte; Line: Integer): string;
begin
  if Line = 2 then
  begin
    if (value-1) >length( Line2StationName) then
    begin
      Result:='';
    end;

    Result := Line2StationName[Value-1];
  end
  else if Line = 3 then
  begin
    if (value-1) >length( Line3StationName) then
    begin
      Result:='';
    end;

    Result := Line3StationName[Value-1]
  end
  else begin
    if (value-1) >length( Line4StationName) then
    begin
      Result:='';
    end;
      Result := Line4StationName[Value-1];
  end;

end;

function ProcessTrainDirection(const Value: Byte; line : integer): string;
begin

  if (line = 2) or (line = 3)then
  begin
    case Value of
        0: Result := '상행';
        1: Result := '하행';
        else Result := IntToHex(Value, 2) + ': Unknown';
    end;
  end
  else begin
    case Value of
        1: Result := '상행';
        2: Result := '하행';
        else Result := IntToHex(Value, 2) + ': Unknown';
    end;
  end;
end;



end.
