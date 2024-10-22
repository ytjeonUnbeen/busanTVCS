unit TVCSMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.TitleBarCtrls, AdvMetroButton, AdvPageControl,GDIPicture,
  AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,Direct2D, PasLibVlcPlayerUnit,PasLibVlcClassUnit,
  System.Actions, Vcl.ActnList, Vcl.Menus, AdvMenus;
const
  GLOBAL_FONT_NAME = '돋 움';
  GLOBAL_FONT_SIZE = 10;
  GLOBAL_FONT_COLOR = clWhite;
  GLOBAL_FONT_STYLE = [fsBold];

type
 TStation=record
    stcode:Integer;
    stname:String;
  end;
  TTrainForm=record
    findex:Integer;
    fNo:String;
    fState:String;
    fSationCode:String;
  end;
  TStationRange=record
    startIdx:Integer;
    endIdx:integer;
  end;
  TCamUrl=record
    Url:String;
    id:String;
    password:String;
  end;

  TCamView=class(TPasLibVlcPlayer)
    private
     // FPlayer: TPasLibVlcPlayer;
      bAllocated:Boolean;
      FRTSPUrl:String;
      FRTSPID:String;
      FRTSPPass:String;
      FmediaOptions:array [0..1] of WideString;
      procedure SetId(id:String);
      procedure SetPassword(pass:String);

    public
       pos:Integer;
       constructor Create(Owner:TComponent);override;
       destructor Destroy;override;
       procedure PlayView;
       procedure StopView;
    published
      property Allocated:Boolean read bAllocated write bAllocated;
      property RtspUrl:String  read FRTSPUrl write FRTSPUrl;
    //  property Player:TPasLibVlcPlayer  read FPlayer write FPlayer;
      property RtspUser:String  read FRtspID write SetId;
      property RtspPass:String  read FRtspPass write SetPassword;

  end;

  TfrmTVCSMain = class(TForm)
    Splitter1: TSplitter;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    pnLeftTrain: TPanel;
    pnCamView: TPanel;
    pnTopmenu: TPanel;
    AdvMetroButton1: TAdvMetroButton;
    pnTitle: TPanel;
    pnWindowMenu: TPanel;
    pnSplit: TPanel;
    btnSplit16: TAdvMetroToolButton;
    btnSplit9: TAdvMetroToolButton;
    btnSplit4: TAdvMetroToolButton;
    btnSplit1: TAdvMetroToolButton;
    toolBtnMinimize: TAdvMetroToolButton;
    toolBtnMax: TAdvMetroToolButton;
    ToolbtnClose: TAdvMetroToolButton;
    pnTrainInfo: TPanel;
    lstTrainSched: TAdvStringGrid;
    popupMain: TAdvPopupMenu;
    mnuStations: TMenuItem;
    mnuTrain: TMenuItem;
    mnuLayout: TMenuItem;
    mnuDevice: TMenuItem;
    mnuSystem: TMenuItem;
    mnuUsers: TMenuItem;
    mnuExit: TMenuItem;
    actMain: TActionList;
    actStations: TAction;
    actTrain: TAction;
    actLayouts: TAction;
    actDevice: TAction;
    actSystem: TAction;
    actUsers: TAction;
    actExit: TAction;
    pgRoute: TAdvPageControl;
    procedure ToolbtnCloseClick(Sender: TObject);
    procedure toolBtnMaxClick(Sender: TObject);
    procedure toolBtnMinimizeClick(Sender: TObject);
    procedure actStationsExecute(Sender: TObject);
    procedure actTrainExecute(Sender: TObject);
    procedure actLayoutsExecute(Sender: TObject);
    procedure actDeviceExecute(Sender: TObject);
    procedure actSystemExecute(Sender: TObject);
    procedure actUsersExecute(Sender: TObject);
    procedure CamViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstTrainSchedSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure pnTopmenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnTopmenuDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    curTabCount:Integer;
    FTrainBitMap:TBitMap;
    MultiCams:array of TCamView;
    curSplit,lastUseNo:Integer;
    Stations:array of TStation;
    UseStations:array of Integer;
    Trains:Array of TTrainForm;
    TrainTabList:TList<TAdvTabSheet>;
    StationRange:Array of TStationRange;

    procedure TrainTabResize(Sender: TObject);
    procedure TrainTabClose(Sender: TObject);
    procedure LoadSampleRTSP;
    procedure LoadSchedPanel;
    procedure LoadTrain;
    function GetRandomStation:String;
    procedure MakeRouteTab;

    procedure AddTrainTab(idrow:Integer);

    procedure SplitView(count:Integer);

    procedure ClearSplitView;
    procedure DoResize;

    procedure InitStations;
  protected
    procedure WMNCHitTest(var message: TWMNCHitTest); message WM_NCHITTEST;
     procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  frmTVCSMain: TfrmTVCSMain;
 // LastPt: TPointF;
 // Dragging: Boolean = False;


   const max_stations_per_tab=10;
        Edge = 5;
        CamSample:array[0..15] of TCamUrl =
        (
          (url:'rtsp://192.168.1.201:554/ISAPI/Streaming/channels/101';id:'admin';password:'Admin12#$'),
          (url:'rtsp://192.168.1.203:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif';id:'admin';password:'Admin12#$'),
          (url:'rtsp://192.168.1.206:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif';id:'admin';password:'Admin12#$'),
          (url:'rtsp://192.168.1.205:554/0/profile4/media.smp';id:'admin';password:'Admin12#$'),
          (url:'rtsp://192.168.1.202:554/0/profile4/media.smp';id:'admin';password:'Admin12#$'),
          (url:'rtsp://192.168.1.37:7001/f05d9052-71d3-f06d-d5f5-e0eef3eaa038?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/200acc6c-0f8f-77b1-1127-3f67a43fbffe?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/71ebf309-3d9f-50af-c0e3-416563e5dc0d?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/867db882-21d5-018e-54f9-84884b36fc80?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/5a2994a0-6888-66c8-b9f2-aedf604fafec?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/f05d9052-71d3-f06d-d5f5-e0eef3eaa038?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/200acc6c-0f8f-77b1-1127-3f67a43fbffe?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/71ebf309-3d9f-50af-c0e3-416563e5dc0d?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/867db882-21d5-018e-54f9-84884b36fc80?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/5a2994a0-6888-66c8-b9f2-aedf604fafec?stream=-1';id:'admin';password:'admin12!@'),
          (url:'rtsp://192.168.1.37:7001/f05d9052-71d3-f06d-d5f5-e0eef3eaa038?stream=-1';id:'admin';password:'admin12!@')
           );
implementation

{$R *.dfm}
uses TVCSStation,TVCSSystemSet,TVCSTrain,TVCSUsers,TVCSViewControl,TVCSDevices, TVCSLayouts, TVCSAutoView,GDIPAPI, GDIPOBJ, GDIPUTIL ;



constructor TCamView.Create(Owner:TComponent);
begin
  inherited Create(Owner);

  //self.FPlayer:=TPasLibVlcPlayer.Create(self);
end;


destructor TCamView.Destroy;
begin
 // if (self.FPlayer<>nil) then begin
 //   self.FPlayer.stop;
  //  FreeAndNil(self.FPlayer);
  //end;
  inherited Destroy;
end;


procedure TCamView.SetId(id:String);
begin
   FmediaOptions[0]:='rtsp-user='+id;
   FRTSPID:=id;


end;
procedure TCamView.SetPassword(pass:String);
begin
   FmediaOptions[1]:='rtsp-pwd='+pass;
   FRTSPPass:=pass;
end;

procedure TCamView.PlayView;
begin

   Play(RTSPUrl,FMediaOptions);
   VideoOutput:=voDirectX;
   AlignwithMargins:=true;
   Margins.left:=10;
   Margins.top:=10;
   Margins.Right:=10;
   Margins.Bottom:=10;
   SetAudioMute(true);



end;

procedure TCamView.StopView;
begin
   Stop;

end;

procedure TfrmTVCSMain.LoadSampleRTSP;
var
 i:Integer;
begin
 for i := Low(CamSample) to High(CamSample)  do
 begin



 end;


end;

procedure TfrmTVCSMain.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
begin
  inherited;

  P := ScreenToClient(Message.Pos);

  with Message do
  begin
    if Result = htClient then Exit;

    Result := htCaption;

    if P.Y < Edge then
    begin
      if P.X < Edge then
        Result := htTopLeft
      else if P.X > ClientWidth - Edge then
        Result := htTopRight
      else
        Result := htTop;
    end
    else if P.Y > ClientHeight - Edge then
    begin
      if P.X < Edge then
        Result := htBottomLeft
      else if P.X > ClientWidth - Edge then
        Result := htBottomRight
      else
        Result := htBottom;
    end
    else
    begin
      if P.X < Edge then
        Result := htLeft
      else if P.X > ClientWidth - Edge then
        Result := htRight
    end;
  end;
end;

procedure TfrmTVCSMain.LoadSchedPanel;
var
  i:Integer;
  item:TListItem;
begin
  InitStations;
  LoadTrain;

  lstTrainSched.BeginUpdate;
//  lstTrainSched.Clear;
  lstTrainSched.ColCount:=4;
  lstTrainSched.RowCount:=Length(Trains)+1;

with lstTrainSched do begin
    Cells[0,0]:='편성';
    Cells[1,0]:='열차번호';
    Cells[2,0]:='상태';
    Cells[3,0]:='역명';



  end;

  with lstTrainSched do begin
     ColWidths[0]:=60;
     ColWidths[1]:=100;
     ColWidths[2]:=80;
     ColWidths[3]:=200;
  end;
  lstTrainSched.RowColor[0]:=clBlack;
  lstTrainSched.RowFontColor[0]:=clWhite;


  with lstTrainSched do begin
    for i :=0 to Length(Trains)-1 do begin

      Cells[0,i+1]:=IntToStr(Trains[i].findex);
      Cells[1,i+1]:=Trains[i].fNo;
      Cells[2,i+1]:=Trains[i].fState;
      Cells[3,i+1]:=Trains[i].fSationCode;
      if odd(i+1) then begin
         lstTrainSched.RowColor[i+1]:=clLtGray;
      end
      else begin

        lstTrainSched.RowColor[i+1]:=clWhite;
      end;
    end;
  end;
  lstTrainSched.EndUpdate;
end;
procedure TfrmTVCSMain.ClearSplitView;
var
 i:integer;
begin
  if (MultiCams=nil) then Exit;

  for I :=0  to Length(Multicams)-1 do begin
        FreeAndNil(MultiCams[i]);
  end;

end;
procedure TfrmTVCSMain.CamViewClick(Sender: TObject);
var
  Cam: TCamView;
  CamIdx, GridIdx: Integer;
  CamWidth, CamHeight: Integer;
  ColWidth, RowHeight: Integer;
  Col, Row: Integer;
  P: TPoint;
begin
  Cam := Sender as TCamView;
  CamIdx := Cam.Tag;
  CamWidth := Cam.Width;
  CamHeight := Cam.Height;

  P := Mouse.CursorPos;
  P := Cam.ScreenToClient(P);

  ColWidth := CamWidth div 3;
  RowHeight := CamHeight div 3;

  Col := P.X div ColWidth;
  Row := P.Y div RowHeight;

  GridIdx := Row * 3 + Col + 1;

end;


procedure TfrmTVCSMain.AddTrainTab(idrow:Integer);
var
  trainNo:String;
  idx:Integer;
  tmpTabSheet,tabSheet:TAdvTabSheet;
begin
  trainNo:=lstTrainSched.Cells[1,idrow];

  for idx :=0  to TrainTabList.Count-1 do begin
     tmpTabSheet:=TrainTabList[idx];
     if (tmpTabSheet.Tag=StrToInt(trainNo)) then begin
       pgRoute.ActivePage:=tmpTabSheet;
       Exit;
     end;

  end;
  //SetLength(TrainTabSheet,curTabCount);
  tabSheet:=TAdvTabSheet.Create(pgRoute);
  tabSheet.AdvPageControl:=pgRoute;
  tabSheet.OnResize:=TrainTabResize;
  tabSheet.Tag:=StrToInt(trainNo);

  tabSheet.ImageIndex:=2;
  tabSheet.Caption:=trainNo;
//  tabSheet.ShowClose:=true;
  //tabSheet.ShowOnClose:=TrainTabClose;
  TrainTabList.Add(tabSheet);

end;

procedure TfrmTVCSMain.TrainTabClose(Sender: TObject);
var
 tabSheet:TAdvTabSheet;
 idx:Integer;
begin
 tabSheet:=(Sender) As TAdvTAbSheet;
 idx:=TrainTabList.Indexof(tabSheet);
 TrainTabList.Delete(idx);
 TrainTabList.TrimExcess;

end;

procedure TfrmTVCSMain.TrainTabResize(Sender: TObject);
begin

  TTabSheet(Sender).Repaint;
end;

procedure TFrmTVCSMain.MakeRouteTab;
var
 idx,curstidx,tabCount,tabRemain:Integer;
 tabTrainSheet:TAdvTabSheet;


begin
  tabCount:=Length(Stations) div max_stations_per_tab;
  tabRemain:=Length(Stations) mod max_stations_per_tab;
  if (tabRemain >0) then inc(TabCount);
  SetLength(StationRange,tabCount);
  curstidx:=0;
  curTabCount:=tabCount;

  TrainTabList:=TList<TAdvTabSheet>.Create();


  for idx := 0 to tabCount-1 do begin

    tabTrainSheet:=TAdvTabSheet.Create(pgRoute);

    tabTrainSheet.AdvPageControl:=pgRoute;
    tabTrainSheet.OnResize:=TrainTabResize;
    tabTrainSheet.Tag:=idx;
    tabTrainSheet.ImageIndex:=1;
    StationRange[idx].startIdx:=curstidx;
    if (curstidx+(max_stations_per_tab-1) >(Length(Stations)-1)) then begin
      StationRange[idx].endIdx:=Length(Stations)-1;
    end
    else begin
      StationRange[idx].endIdx:=curstidx+(max_stations_per_tab-1);
      inc(curstidx,max_stations_per_tab);
    end;



    tabTrainSheet.Caption:=Format('%s~%s',[Stations[StationRange[idx].startIdx].stname,Stations[StationRange[idx].endIdx].stname]);
    TrainTabList.Add(tabTrainSheet);

  end;


end;

procedure TfrmTVCSMain.pnTopmenuDblClick(Sender: TObject);
begin
WindowState:=TWindowState.wsNormal;
end;

procedure TfrmTVCSMain.pnTopmenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;

end;

procedure TfrmTVCSMain.DoResize();
var
 i,row,col:Integer;
 FCamWidth,FCamHeight:Integer;
 rowCount,colCount:Integer;

begin
if (MultiCams=nil) then Exit;
if (curSplit=0) then exit;

  col:=0;row:=0;
  rowCount:=trunc(sqrt(curSplit));
  colCount:=trunc(sqrt(curSplit));
  FCamWidth:=pnCamView.Width div colCount;;
  FCamHeight:=pnCamView.Height div rowCount;;


 for i:=  0 to length(Multicams)-1 do begin
       MultiCams[i].Left:=col*FCamWidth;
       MultiCams[i].top:=row*FCamHeight;
       MultiCams[i].width:=FCamWidth;
       MultiCams[i].Height:=FCamHeight;
       MultiCams[i].Repaint;
       MultiCams[i].Tag := i;
       MultiCams[i].OnClick := CamViewClick;
       inc(col);
       if (col >=colCount)then begin
          inc(row);
          col:=0;
       end;
 end;


end;

procedure TfrmTVCSMain.FormCreate(Sender: TObject);
begin
 LoadSchedPanel;
 curSplit:=0;
end;

procedure TfrmTVCSMain.FormDestroy(Sender: TObject);
var
 i:Integer;
begin
  if (MultiCams<>nil) then begin
    for i:= 0 to Length(Multicams)-1 do
      FreeAndNil(Multicams[i]);
  end;
if (TrainTabList<>nil) then
   TrainTabList.Free;

end;

procedure TfrmTVCSMain.CreateParams(var Params: TCreateParams);
begin
  BorderStyle := bsNone;

  inherited;

  Params.WndParent := 0;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TfrmTVCSMain.FormResize(Sender: TObject);
var
  WindowRgn, HoleRgn : HRgn;
begin
  WindowRgn := 0;
  GetWindowRgn(Handle, WindowRgn);
  DeleteObject(WindowRgn);
  WindowRgn := CreateRectRgn(0, 0, Width, Height);
  HoleRgn := CreateRectRgn(Edge, Edge+self.Height+Edge, Width-Edge, Height-Edge);
  CombineRgn(WindowRgn, WindowRgn, HoleRgn, RGN_DIFF);
  SetWindowRgn(Handle, WindowRgn, TRUE);
  DeleteObject(HoleRgn);

end;

procedure TfrmTVCSMain.SplitView(count: Integer);
var
 i,row,col:Integer;
 FCamWidth,FCamHeight:Integer;
 rowCount,colCount:Integer;

begin
     ClearSplitView;
     SetLength(MultiCams,count);
     rowCount:=trunc(sqrt(count));
     colCount:=trunc(sqrt(count));
     FCamWidth:=pnCamView.Width div colCount;;
     FCamHeight:=pnCamView.Height div rowCount;;


     row:=0;
     col:=0;
     for i := 0 to count-1 do begin
       MultiCams[i]:=TCamView.Create(pnCamView);
       MultiCams[i].Left:=col*FCamWidth;
       MultiCams[i].top:=row*FCamHeight;
       MultiCams[i].width:=FCamWidth;
       MultiCams[i].Height:=FCamHeight;
       MultiCams[i].Parent:=pnCamView;

       MultiCams[i].Tag := i;
       MultiCams[i].OnClick := CamViewClick;


       inc(col);
       if (col >=colCount)then begin
          inc(row);
          col:=0;
       end;
     end;

end;
procedure TfrmTVCSMain.InitStations;
var
 i:Integer;
begin
// api call

SetLength(Stations,44);
SetLength(UseStations,44);
Stations[0].stcode := 201; Stations[0].stname := '장산';
Stations[1].stcode := 202; Stations[1].stname := '중동';
Stations[2].stcode := 203; Stations[2].stname := '해운대';
Stations[3].stcode := 204; Stations[3].stname := '동백';
Stations[4].stcode := 205; Stations[4].stname := '벡스코 (시립미술관)';
Stations[5].stcode := 206; Stations[5].stname := '센텀시티';
Stations[6].stcode := 207; Stations[6].stname := '민락';
Stations[7].stcode := 208; Stations[7].stname := '수영';
Stations[8].stcode := 209; Stations[8].stname := '광안';
Stations[9].stcode := 210; Stations[9].stname := '금련산';
Stations[10].stcode := 211; Stations[10].stname := '남천';
Stations[11].stcode := 212; Stations[11].stname := '경성대·부경대';
Stations[12].stcode := 213; Stations[12].stname := '대연';
Stations[13].stcode := 214; Stations[13].stname := '못골';
Stations[14].stcode := 215; Stations[14].stname := '지게골';
Stations[15].stcode := 216; Stations[15].stname := '문현';
Stations[16].stcode := 217; Stations[16].stname := '국제금융센터';
Stations[17].stcode := 218; Stations[17].stname := '전포';
Stations[18].stcode := 219; Stations[18].stname := '서면';
Stations[19].stcode := 220; Stations[19].stname := '부암';
Stations[20].stcode := 221; Stations[20].stname := '가야';
Stations[21].stcode := 222; Stations[21].stname := '동의대';
Stations[22].stcode := 223; Stations[22].stname := '개금';
Stations[23].stcode := 224; Stations[23].stname := '냉정';
Stations[24].stcode := 225; Stations[24].stname := '주례';
Stations[25].stcode := 226; Stations[25].stname := '감전';
Stations[26].stcode := 227; Stations[26].stname := '사상';
Stations[27].stcode := 228; Stations[27].stname := '덕포';
Stations[28].stcode := 229; Stations[28].stname := '모덕';
Stations[29].stcode := 230; Stations[29].stname := '모라';
Stations[30].stcode := 231; Stations[30].stname := '구남';
Stations[31].stcode := 232; Stations[31].stname := '구명';
Stations[32].stcode := 233; Stations[32].stname := '덕천';
Stations[33].stcode := 234; Stations[33].stname := '수정';
Stations[34].stcode := 235; Stations[34].stname := '화명';
Stations[35].stcode := 236; Stations[35].stname := '율리';
Stations[36].stcode := 237; Stations[36].stname := '동원';
Stations[37].stcode := 238; Stations[37].stname := '금곡';
Stations[38].stcode := 239; Stations[38].stname := '호포';
Stations[39].stcode := 240; Stations[39].stname := '증산';
Stations[40].stcode := 241; Stations[40].stname := '부산대양산캠퍼스';
Stations[41].stcode := 242; Stations[41].stname := '남양산 (범어)';
Stations[42].stcode := 243; Stations[42].stname := '양산';
Stations[43].stcode := 244; Stations[43].stname := '양산종합운동장';
for i := 0 to 43 do
  UseStations[i]:=-1;

 lastUseNo:=-1;
 MakeRouteTab;

end;
function TfrmTVCSMain.GetRandomStation: string;
var
 i:Integer;
 idx:Integer;
 isFound:Boolean;

begin
 idx:=Random(44);
 if (lastUseNo>43) then
 begin

    Result:='-';
    Exit;
 end;
 if (lastUseNo=-1) then begin

   Result:=Stations[idx].stname;
   inc(lastUseNo);
   Exit;
 end;

 Repeat
   idx:=Random(44);
   isFound:=False;
   for i := 0 to  lastUseNo do begin
      if (idx=UseStations[i]) then
          break;

   end;
   if (not isFound) then begin
     Result:=Stations[idx].stname;
     inc(lastUseNo);
     Exit;
   end;
   Sleep(1);
until not isFound;



 Result:='-';
end;

procedure TfrmTVCSMain.LoadTrain;
var
 idx:Integer;
 stateCode:Integer;
begin
Randomize;
SetLength(Trains,80);
for idx :=0 to Length(Trains)-1 do begin
    Trains[idx].findex:=idx+1;
    Trains[idx].fNo:=format('%.4d',[idx+Random(2000)]);
    stateCode:=Random(3);
    case stateCode of
        0:
        begin
         Trains[idx].fState:='출발';

        end;
        1:
        begin
         Trains[idx].fState:='도착';

        end;
        2:
        begin
        Trains[idx].fState:='접근';

        end;
        3: //운행안함
        begin
        Trains[idx].fState:='-';

        end;
    end;
    if (statecode<>0) then
       Trains[idx].fSationCode:=GetRandomStation()
    else
      Trains[idx].fSationCode:='';
end;




end;


procedure TfrmTVCSMain.lstTrainSchedSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 CanSelect:=false;

end;

procedure TfrmTVCSMain.actDeviceExecute(Sender: TObject);

var
  frmDevices: TfrmDevices;

begin
  //
  try
    frmDevices:=TFrmDevices.Create(Self);
    frmDevices.showModal;
  finally
    FreeAndNil(frmDevices);

  end;

end;

procedure TfrmTVCSMain.actLayoutsExecute(Sender: TObject);
var
    frmLayouts : TfrmLayouts;

begin
      //
      try
         frmLayouts := TfrmLayouts.Create(self);
         frmLayouts.ShowModal;
      finally
          FreeAndNil(frmLayouts);


      end;


end;

procedure TfrmTVCSMain.actStationsExecute(Sender: TObject);
var
 fm:TfrmStation;
begin
//
  try
    fm:=TfrmStation.CReate(Self);
    fm.ShowModal;
  finally
    FreeAndNil(fm);
 end;
end;

procedure TfrmTVCSMain.actSystemExecute(Sender: TObject);
var
  frmSystem: TfrmSystem;
begin
  //
  try
    frmSystem:= TfrmSystem.Create(self);
    frmSystem.ShowModal;
  finally
    FreeAndNil(frmSystem);
  end;
end;

procedure TfrmTVCSMain.actTrainExecute(Sender: TObject);
var
    frmTrain: TfrmTrain;
begin
    try
      frmTrain:= TfrmTrain.Create(self);
      frmTrain.ShowModal;

    finally
      FreeAndNil(frmTrain);

    end;


end;

procedure TfrmTVCSMain.actUsersExecute(Sender: TObject);
var
  frmUsers: TfrmUsers;

begin
  try
    frmUsers:= TfrmUsers.Create(self);
    frmUsers.ShowModal;
  finally
    FreeAndNil(frmUsers);
  end;

end;

procedure TfrmTVCSMain.ToolbtnCloseClick(Sender: TObject);
begin
Close;
end;

procedure TfrmTVCSMain.toolBtnMaxClick(Sender: TObject);
begin
self.WindowState:=TWindowState.wsMaximized;
end;

procedure TfrmTVCSMain.toolBtnMinimizeClick(Sender: TObject);
begin
   self.WindowState:=TWindowState.wsMinimized;
end;

end.
