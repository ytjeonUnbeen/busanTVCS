unit TCMSProtocol;

interface
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,Data.fmtbcd;

type

 //check
  TByteBits = packed record
    Bit0, Bit1, Bit2, Bit3, Bit4, Bit5, Bit6, Bit7: Boolean;
  end;

  TByteEx = packed record
  case Integer of
    0: (ByteAccess: Byte);
    1: (BitAccess: TByteBits);
  end;

  TSDData=packed record
    bFire:array of Byte;
    bInter:array of Byte;
  end;

     //연동 Port : 1호선(19913), 2호선(19923), 3호선(19933), 4호선(19943)
  TTCMSProtocol=class(TObject)
   private
       FPacketbuf:TBytes;
       FPktSize:Integer;
       FStx:Byte; //$02 고정
       FCmdFix:Byte; //$55  고정
       FDid:Byte; // Destnation ID;
       FSid:Byte; // TRCP  전방 0x10 후방 0x11  ->Source ID
       FCmd:Byte; //
       FLen:Word;
       FSeq:Byte;
       FOrgan:Word; // 편성
       FActive:Byte;
       FTrainNo:Word;
       FCellId:array [0..3] of Byte;
       FIMEILen:Byte;
       FIMEI:AnsiString;

       FUSIMLen:Byte;
       FUSIM:AnsiString;

       FMainPTTLen:Byte;
       FMainPTT:AnsiString;

       FTrainPTTLen:Byte;
       FTrainPTT:AnsiString;

       FTrainInOutState:Byte;
       FCommandErr:Byte;
       FTVCSErr:Byte;
       FTICSErr:Byte;
       FAudioErr:Byte;
       FTCMSType:Byte;
       FTCMSLen:Byte;

       FTCMSDData:TBytes;
       FEtx:Byte;
       FCrc:Word;


   public
     constructor Create;overload;
     procedure ReadPacket(pktBuf:TBytes;pktlen:Integer);
     procedure InitPacket(aSid,ADid,aCmd,ASeq:Byte;OrganInfo,TrainNo:Word);
     procedure AddCellInfo(aCellId:Tbytes;aIMEI,aUsim,aMainPtt,aTrainPtt:AnsiString);
     procedure SetErrorCode(aField,aErrCode:Integer);
     procedure SetTrainPosState(poscode:Integer);
     procedure SetSDEventData(evtType,evtTrainNo:Integer);
     function  GetPacketHexBuf:String;
     procedure MakePacket;



   published
     property Did:Byte Read FDid;
     property Cmd:Byte Read Fcmd;
     property sid:Byte Read Fsid;
     property TrainNo:Word Read FTrainNo;
     property FomatNo:Word Read Forgan;
     property IMEINo:AnsiString Read FIMEI;
     property MainPTT:AnsiString Read FMainPTT;
     property TrainPTT:AnsiString Read FTrainPTT;
     property TCMSType:byte Read FTCMSType;
     property PktSize:Integer Read FPktSize;
     property DataLen:Word Read FLen;
     property Seq:Byte Read FSeq;
     property Crc:Word Read FCRc;
     property PacketData:TBytes Read FPacketbuf;
     property TCMSSDData:Tbytes REad FTCMSDData;

 end;
 const PKT_TCMS_STX=$02;
 const EVENT_FIRE=$01;
 const EVENT_CALL=$02;





implementation
uses ConvertHex;

constructor TTCMSProtocol.Create;
var
 i:Integer;
begin
 inherited;
  FStx:=$02;
  FcmdFix:=$55;
  FEtx:=$03;

  FCommandErr:=$0;
  FTVCSErr:=$0;
  FTICSErr:=$0;
  FAudioErr:=$0;
  FTCMSType:=$0;
  FTrainInOutState:=$0;
  SetLength(FTCMSDData,4);
  for I := Low(FTCMSDData) to High(FTCMSDData) do
     FTCMSDData[i]:=$0;
  FPktSize:=0;
end;

procedure TTCMSProtocol.SetSDEventData(evtType,evtTrainNo:Integer);
begin
  if (evtType=EVENT_FIRE) then begin //
       if (evtTrainNo >7) then
          FTCMSDData[1]:=SetBit(FTCMSDData[1],evtTRainNo-8)
       else
          FTCMSDData[0]:=SetBit(FTCMSDData[0],evtTRainNo);
     FTCMSType:=$1;
  end;
  if (evtType=EVENT_CALL) then begin
       if (evtTrainNo >7) then
          FTCMSDData[3]:=SetBit(FTCMSDData[3],evtTRainNo-8)
       else
          FTCMSDData[2]:=SetBit(FTCMSDData[2],evtTRainNo);
     FTCMSType:=$1;
  end;
end;

procedure TTCMSProtocol.SetErrorCode(aField,aErrCode:Integer);
begin
   case aField of
    1:
     begin
       FCommandErr:=aErrCode;
     end;
    2:
     begin
        FTVCSErr:=aErrCode;
     end;
    3:
     begin
       FTICSErr:=aErrCode;

     end;
    4:
     begin
      FAudioErr:=aErrCode;
     end;
   end;

end;

procedure   TTCMSProtocol.SetTrainPosState(poscode: Integer);
begin
  FTrainInOutState:=poscode;
end;

procedure TTCMSProtocol.InitPacket(aSid,aDiD,aCmd,ASeq:Byte;OrganInfo,TrainNo:Word);
var
 bcdval,testbcd:TBcd;
 rebcd:Integer;
 data1,data2:Tbytes;
 msb,lsb,bcdm,bcdl:Byte;
 msbbcd,lsbbcd:TBcd;
 msbint,lsbint:Integer;

begin
     FSid:=aSid;
     FDid:=aDid;
     FCmd:=aCmd;
     FOrgan:=MakeWord(LoByte(organInfo),HiByte(organInfo));
     FTrainNo:=MakeWord(LoByte(TrainNo),HiByte(TrainNo));
     FSeq:=ASeq;
end;

procedure TTCMSProtocol.AddCellInfo(aCellId:Tbytes;aIMEI,aUsim,aMainPtt,aTrainPtt:AnsiString);
begin
  CopyMemory(@FCellId,aCellId,4);
  FIMEILen:=Length(aIMEI);
  FUSIMLen:=Length(aUsim);
  FMainPTTLen:=Length(aMainPtt);
  FTrainPTTLen:=Length(aTrainPtt);
  FIMEI:=aIMEI;
  FUSIM:=aUsim;
  FMainPtt:=aMainPtt;
  FTrainPtt:=aTrainPtt;
end;

function  TTCMSProtocol.GetPacketHexBuf:String;
begin
    if (FPktSize >0) then
      Result:=ByteArrToHexSpace(FPacketbuf)
    else
      Result:='';
end;

procedure  TTCMSProtocol.MakePacket;
var
  templen,temppos:Integer;
  datalen:Integer;

  crcVal:Word;
begin
       templen:=8; // stx<->alive(seq);

       templen:=tempLen+2; //length(FOrgan);
       templen:=tempLen+1; //active
       templen:=templen+2+4; //trainNo+FCellId;

       templen:=tempLen+1+FIMEILen;
       templen:=tempLen+1+FUSIMLen;
       templen:=tempLen+1+FMainPTTLen;
       templen:=tempLen+1+FTrainPTTLen;
       templen:=templen+6;  //tcmstype

       datalen:=9+4+FIMEILen+FUSIMLen+FMainPTTLen+FTrainPTTLen+6;  //FOrgan,FTrain,Active:9 + IEMI..PTT length filed 4+문자열 길이+tcmstyp까지

       if (FTCMSType<>$0) then begin

         templen:=templen+4;  //sd data
         datalen:=datalen+4;
       end;
       templen:=templen+3; //crc;
       FLen:=datalen;
       SetLength(FPacketbuf,templen);

       FPktSize:=templen;

       FPacketbuf[0]:=FStx;
       FPacketbuf[1]:=FCmdFix;
       FPacketbuf[2]:=FDid;
       FPacketbuf[3]:=FSid; //0x10 0x11
       FPacketbuf[4]:=FCmd;  //0x50
       FPacketbuf[5]:=HIByte(FLen);FPacketbuf[6]:=LoByte(FLen);
       FPacketbuf[7]:=FSeq;
     //  FPacketBuf[8]:=HiByte(Forgan);
     //  FPacketBuf[9]:=LoByte(Forgan);
       CopyMemory(@FPacketBuf[8],@Forgan,2);
       FPacketbuf[10]:=FActive;
       CopyMemory(@FPacketBuf[11],@FTrainNo,2);
       CopyMemory(@FPacketBuf[13],@FCellId[0],4);

       temppos:=17;
       FPacketbuf[temppos]:=FIMEILen;
       Move(FIMEI[1],FPacketBuf[temppos+1],FIMEILen);
    //   CopyMemory(@FPacketBuf[temppos+1],@FIMEI,FIMEILen);
       temppos:=temppos+1+FIMEILen;

       FPacketbuf[temppos]:=FUSIMLen;
       Move(FUSIM[1],FPacketBuf[temppos+1],FUSIMLen);
       temppos:=temppos+1+FUSIMLen;


       FPacketbuf[temppos]:=FMainPTTLen;
       Move(FMainPTT[1],FPacketBuf[temppos+1],FMainPTTLen);
       temppos:=temppos+1+FMainPTTLen;

       FPacketbuf[temppos]:=FTrainPTTLen;
       Move(FTrainPTT[1],FPacketBuf[temppos+1],FTrainPTTLen);
       temppos:=temppos+1+FTrainPTTLen;


       FPacketbuf[temppos]:=FTrainInOutState;
       FPacketbuf[temppos+1]:=FCommandErr;
       FPacketbuf[temppos+2]:=FTVCSErr;
       FPacketbuf[temppos+3]:=FTICSErr;
       FPacketbuf[temppos+4]:=FAudioErr;
       FPacketbuf[temppos+5]:=FTCMSType;
       if (FTCMSType=$01) then begin
          CopyMemory(@FPacketBuf[temppos+6],@FTCMSDData[0],4);
          temppos:=temppos+6+4;
       end
       else  temppos:=temppos+6;


       FPacketbuf[temppos]:=FEtx;

       FCrc:=crc16cal(crcVal,PByte(FPacketBuf),temppos+1);
       FPacketBuf[temppos+1]:=HiByte(FCrc);
       FPacketBuf[temppos+2]:=LoByte(FCrc);




end;


procedure TTCMSProtocol.ReadPacket(pktBuf:TBytes;pktlen:Integer);
var
 i,pos:Integer;
begin
    FStx:=pktBuf[0];
    FCmdFix:=PktBuf[1];
    FDid:=PktBuf[2];
    FSid:=PktBuf[3];
    FCmd:=PktBuf[4];
    FLen:=MakeWord(PktBuf[6],PktBuf[5]);
    FSeq:=Pktbuf[7];
    Forgan:=MakeWord(PktBuf[8],PktBuf[9]);
  //  FOrgan:=ConvertHex.BCDToInteger(Forgan);
    FActive:=PktBuf[10];
    FTrainNo:=MakeWord(PktBuf[11],PktBuf[12]);
  //  FOrgan:=ConvertHex.BCDToInteger(FTrainNo);

    for i:=0 to 3 do
        FCellId[i]:=PktBuf[13+i];
    FIMEILen:=Pktbuf[17];

    FIMEI:=ByteArrToStrLen(PktBuf,18,FIMEILen);
    pos:=18+FIMEILen;

    FUSIMLen:=PktBuf[pos];
    FUSIM:=ByteArrToStrLen(PktBuf,pos+1,FUSIMLen);
    pos:=pos+1+FUSIMLen;

    FMainPTTLen:=PktBuf[pos];
    FMainPTT:=ByteArrToStrLen(PktBuf,pos+1,FMainPTTLen);
    pos:=pos+1+FMainPTTLen;

    FTrainPTTLen:=PktBuf[pos];
    FTrainPTT:=ByteArrToStrLen(PktBuf,pos+1,FTrainPTTLen);
    pos:=pos+1+FTrainPTTLen;

    FTrainInOutState:=PktBuf[pos];
    FCommandErr:=PktBuf[pos+1];
    FTVCSErr:=PktBuf[pos+2];
    FTICSErr:=PktBuf[pos+3];
    FAudioErr:=Pktbuf[pos+4];
    FTCMSType:=Pktbuf[pos+5];  //0x00 신호무시 0x01 1 호선 0x04 4호선

     // 7 byte FLen까지  etx+crc16
   // FTCMSLen:=pktlen-7-3-(pos+5);
      if (FTCMSType=1) then begin
         for i := 0 to 3 do begin

             FTCMSDData[i]:=PktBuf[pos+6+i];

          end;
          pos:=pos+9;
     end
     else pos:=pos+6;
     FEtx:=PktBuf[pos+1];
     FCrc:=MakeWord(PktBuf[pos+2],PktBuf[Pos+3]);

     SetLength( FPacketbuf,Pktlen);
     CopyMemory(@FPacketbuf[0],@PktBuf[0],pktlen);
     FPktSize:=pktlen;




end;

end.
