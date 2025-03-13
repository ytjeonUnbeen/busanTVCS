unit TVCSMainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.TitleBarCtrls, AdvMetroButton, AdvPageControl,GDIPicture,
  AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,Direct2D, PasLibVlcPlayerUnit,PasLibVlcClassUnit,
  System.Actions, Vcl.ActnList, Vcl.Menus, AdvMenus, AdvTabSet, AdvPanel,
  AdvSplitter, Vcl.StdCtrls, AdvMenuStylers, AdvGlowButton,tvcsAPI,tvcsProtocol,StrUtils,
  OverbyteIcsTypes, OverbyteIcsWndControl, OverbyteIcsWSocket,TVCSDebug,TTCProtocol,TCMSProtocol,TVCSCamView,TVCSAutoView,
  Vcl.Buttons, AdvSmoothButton, AeroButtons, Registry, PasLibVlcUnit;


//{$DEFINE TESTMODE}
type

  TStationRange=record
    startIdx:Integer;
    endIdx:integer;
  end;
  TCamUrl=record
    Url:String;
    id:String;
    password:String;
  end;
  TCamGlowButton=class(TAdvSmoothButton)
    private
      FMergeCams:TVCSTrainCameraMerge;
    public
      camUrl:TCamUrl;
      isMergedCam:Boolean;
      mergeName:String;
      mergeIdx:Integer;
      mergeTrainid:integer;
      camName:string;
    published
       property MergeCams: TVCSTrainCameraMerge read FMergeCams Write FMergeCams;
  end;

  TTrainCameraItem=class(TObject)
    private
      FMergeCams:Tarray <TVCSTrainCameraMerge>;
      FTrainCams:TArray <TVCSTrainCamera>;
      FBtnMultiCams:TArray<TCamGlowButton>;
      FBtnSingleCams:Tarray<TCamGlowButton>;
      FisFirstTrainDraw:Boolean;
      fcarriageCount:Integer;
      FMultiImg:TImagelist;
      FSingleImg:TImageList;
    public
      procedure SetImages(Multi,Singleimg:TImageList);
      procedure CreateMultiButton(len:Integer);
      procedure CreateSingleButton(len:Integer);
      procedure ClearButtons;
      procedure ReloadButtons(OnDblClickMethod: TNotifyEvent);

    published

      property MergeCams: TArray <TVCSTrainCameraMerge> read FMergeCams Write FMergeCams;
      property TrainCams: TArray <TVCSTrainCamera> read FTrainCams Write FTrainCams;
      property BtnMergeCam: TArray<TCamGlowButton> read   FBtnMultiCams write FBtnMultiCams;
      property BtnSingleCam: TArray<TCamGlowButton> read   FBtnSingleCams write FBtnSingleCams;
      property isFirstTrainDraw:Boolean read FisFirstTrainDraw write  FisFirstTrainDraw;
      property CarriageCount:Integer read fcarriageCount write  fcarriageCount;


  end;

  TfrmTVCSMain = class(TForm)
    Splitter1: TSplitter;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    pnLeftTrain: TPanel;
    pnCamView: TPanel;
    pnTopmenu: TPanel;
    btnMainMenu: TAdvMetroButton;
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
    tabRoute: TAdvTabSet;
    pnRoute: TAdvPanel;
    tabImgList: TVirtualImageList;
    cmbStyle: TComboBox;
    EventSock: TWSocket;
    EventSockTimer: TTimer;
    btnAutoView: TAdvMetroToolButton;
    camImages: TVirtualImageList;
    MultiCamImage: TVirtualImageList;
    camPopup: TPopupMenu;
    mnuCamDelete: TMenuItem;
    Image1: TImage;
    ImageListBitmap: TImageList;
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
    procedure pnTopmenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnTopmenuDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnMainMenuClick(Sender: TObject);
    procedure tabRouteTabClose(Sender: TObject; TabIndex: Integer);
    procedure lstTrainSchedDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure pnRoutePaint(Sender: TObject; ACanvas: TCanvas; ARect: TRect);
    procedure cmbStyleChange(Sender: TObject);
    procedure cmbStyleKeyPress(Sender: TObject; var Key: Char);
    procedure lstTrainSchedGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure tabRouteClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure btnSplit16Click(Sender: TObject);
    procedure btnSplit4Click(Sender: TObject);
    procedure btnSplit9Click(Sender: TObject);
    procedure btnSplit1Click(Sender: TObject);
    procedure EventSockDataAvailable(Sender: TObject; ErrCode: Word);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EventSockSocksConnected(Sender: TObject; ErrCode: Word);
    procedure EventSockSocksError(Sender: TObject; Error: Integer; Msg: string);
    procedure EventSockTimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tabRouteChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure pnCamViewCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnAutoViewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuCamDeleteClick(Sender: TObject);

  private
    curTabCount:Integer;
    FTrainBitMap:TBitMap;
    FDebugWin:TfrmDebug;
    FLineNo:Integer;
    FSockConnected:Boolean;
    FMonitorCount:Integer;

    curSplit,lastUseNo:Integer;
    FStations:TArray<TvcsStation>;
    FStationCount:Integer;
    FTrains:TArray<TvcsTrain>;
    MultiCams:array of TCamView;

    StationRange:Array of TStationRange;

    fmAutoCamView:TfrmAutoView;

    procedure OnCamBtnDoubleClick(Sender:TObject);
 
    procedure LoadSampleRTSP;
    procedure LoadSchedPanel;
    procedure LoadTrain;
    procedure OnMultiClick(Sender:TObject);
    procedure OnSingleClick(Sender:TObject);
    procedure MakeRouteTab;
    procedure AddTrainTab(idrow:Integer);
    procedure SplitView(count:Integer);
    procedure ClearSplitView;
    procedure DoResize;
    function  findEmptyView:Integer;

    procedure InitStations;
    procedure DrawRoute(ACanvas: TCanvas;ARect: TRect);
    procedure DrawStations(ACanvas:TCanvas;ARect:TRect;tabidx:Integer);
    procedure DrawTrainIn(ACanvas:TCanvas;ARect:TRect;tabidx:Integer);
    procedure DrawTrain(ACanvas: TCanvas;x,y:Integer;TrainNo:Integer;upDown:Byte);
    procedure DrawCCTV(ACanvas:TCanvas;x,y,camcount:Integer);
    procedure InitEventSocket;
    procedure DisplayTTCPacket(packet:TTTCProtocol);
    function  GetStationIdx(stcode:Integer;var stationIndex:Integer):Integer;
    //procedure DispSchedTrain(trainNo,ArrStno,DestStno:Integer;Direction,OpCode:Byte);
    procedure DispSchedTrain(packet:TTTCProtocol);

    procedure ReDrawRoute;
    procedure CheckMonitor;
    procedure MultiCamClose(Sender:TObject);
    procedure camVideoDragDrop(Sender, Source: TObject; X, Y: Integer);

    procedure camVideoDragOver(Sender, Source: TObject; X, Y: Integer;
     State: TDragState; var Accept: Boolean);
    Procedure camVideoMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);

    Procedure camViewMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    Procedure CreateSplitPanel;
    procedure CopyCamView(var dstcam:TCamView;srccam:TCamView);
    procedure AssignCamView(var dstcam:TCamView;aPos,aCol,ARow,aCamWidth,aCamHeight:Integer);
    function findMultiCam(x,y:Integer):Integer;
    procedure reloadMergeCams;
    function IndexOf(const Arr: array of string; const Value: string): Integer;


  protected
     procedure WMNCHitTest(var message: TWMNCHitTest); message WM_NCHITTEST;
     procedure CreateParams(var Params: TCreateParams); override;
  public
     procedure LoadSettings;
     procedure SaveSettings;
  end;

var
  frmTVCSMain: TfrmTVCSMain;
  icon_image_path: string;
  icon_upbox: string;
  icon_downbox: string;
  icon_station: string;
  //  icon_train_head='icon-train-01.png';
  icon_train_head: string;
  icon_train_body: string;
  icon_train_tail: string;
  // icon_train_body='icon-train-02.png';
  // icon_train_tail='icon-train-03.png';
  icon_multi_cam: string;
  icon_cam_normal: string;
  icon_cam_abnormal: string;
  icon_system_max: string;
  icon_system_restore: string;
  icon_trainbox_down: string;
  icon_trainbox_up: string;


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
          PrgKey = 'Software\TVCSClient\Settings';

          // 서버용
          EventServAddr='192.168.1.49';
          EventservPort=7004;

          // 로컬 테스트
          //EventServAddr='127.0.0.1';
          //EventservPort=9000;

implementation

{$R *.dfm}
 uses TVCSStation,TVCSSystemSet,TVCSTrain,TVCSUsers,TVCSViewControl,TVCSDevices, TVCSLayouts,TVCSDrawCommon,vcl.Themes,
 GDIPAPI, GDIPOBJ, GDIPUTIL,ConvertHex,TVCSFullScreen;



procedure TTrainCameraItem.CreateMultiButton(len: Integer);
begin
   SetLength(FBtnMultiCams,len);
end;

procedure TTrainCameraItem.CreateSingleButton(len: Integer);
begin
   SetLength(FBtnSingleCams,len);
end;
procedure TTrainCameraItem.SetImages(Multi: TImageList; Singleimg: TImageList);
begin
   FMultiImg:=Multi;
   FSingleImg:=SingleImg;
end;


procedure TTrainCameraItem.ClearButtons;
var
  i:Integer;
begin
 for I := Low(FBtnMultiCams) to High(FBtnMultiCams) do
    FreeAndNil(FBtnMultiCams[i]);

 for I := Low(FBtnSingleCams) to High(FBtnSingleCams) do
    FreeAndNil(FBtnSingleCams[i]);

   SetLength(FBtnMultiCams,0);
   SetLength(FBtnSingleCams,0);

end;

procedure TfrmTVCSMain.LoadSampleRTSP;
var
 i:Integer;
begin
 for i := Low(CamSample) to High(CamSample)  do
 begin



 end;

end;
procedure TfrmTVCSMain.LoadSettings;
var
  Registry: TRegIniFile;
  i:Integer;
begin
  Registry := TRegIniFile.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;

    Registry.OpenKey(PrgKey, True);

    curSplit:=Registry.ReadInteger('main','splitSeting',1);

    // 첫 시작시 값이 없으면 기본값 16으로
    if curSplit = 0 then
      curSplit:= 16;

     for I := Low(MultiCams) to High(MultiCams) do begin
        if (Multicams[i]<>nil) then begin
          MultiCams[i].RtspUrl:= Registry.ReadString('cam'+IntToStr(i),'rtspUrl','');
          MultiCams[i].RtspUser:=Registry.ReadString('cam'+IntToStr(i),'rtspUser','');
          MultiCams[i].RtspPass:= Registry.ReadString('cam'+IntToStr(i),'rtspPass','');
          MultiCams[i].pos:= Registry.ReadInteger('cam'+IntToStr(i),'pos',0);
          MultiCams[i].Allocated:= Registry.ReadBool('cam'+IntToStr(i),'pos',false);
          MultiCams[i].isMerged:= Registry.ReadBool('cam'+IntToStr(i),'merged',false);
          MultiCams[i].mergeName:= Registry.ReadString('cam'+IntToStr(i),'mergename','');
          MultiCams[i].mergeIdx:= Registry.ReadInteger('cam'+IntToStr(i),'mergeidx',0);
          MultiCams[i].mergeTrainId:= Registry.ReadInteger('cam'+IntToStr(i),'mergetrain',0);
          MultiCams[i].camName:= Registry.ReadString('cam'+IntToStr(i),'camName','');





        end;
    end;


    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure TfrmTVCSMain.SaveSettings;
var
  Registry: TRegIniFile;
  i:Integer;
begin
  Registry := TRegIniFile.Create(KEY_WRITE);
  try
    Registry.RootKey := HKEY_CURRENT_USER;

    Registry.OpenKey(PrgKey, True);
    Registry.WriteInteger('main','splitSeting',curSplit);
    for I := Low(MultiCams) to High(MultiCams) do begin
      if (Multicams[i]<>nil) then begin
         Registry.WriteString('cam'+IntToStr(i),'rtspUrl',MultiCams[i].RtspUrl);
         Registry.WriteString('cam'+IntToStr(i),'rtspUser',MultiCams[i].RtspUser);
         Registry.WriteString('cam'+IntToStr(i),'rtspPass',MultiCams[i].RtspPass);
         Registry.WriteInteger('cam'+IntToStr(i),'pos',MultiCams[i].pos);
         Registry.WriteBool('cam'+IntToStr(i),'pos',MultiCams[i].Allocated);
         Registry.WriteBool('cam'+IntToStr(i),'merged',MultiCams[i].isMerged);
         Registry.WriteString('cam'+IntToStr(i),'mergename',MultiCams[i].mergeName);
         Registry.WriteInteger('cam'+IntToStr(i),'mergeidx',MultiCams[i].mergeIdx);
         Registry.WriteInteger('cam'+IntToStr(i),'mergetrain',MultiCams[i].mergeTrainId);
         Registry.WriteString('cam'+IntToStr(i),'camName',MultiCams[i].camName);

      end;
    end;


    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;




function TfrmTVCSMain.findEmptyView:integer;
var
 i:Integer;
begin
  for I := Low(Multicams) to High(Multicams) do begin
     if (not MultiCams[i].Allocated) then
     begin
        Result:=i;
        Exit;
     end;

  end;
  Result:=-1;

end;


procedure TfrmTVCSMain.OnCamBtnDoubleClick(Sender: TObject);
var
 btnCam:TCamGlowButton;
 pos:Integer;
begin
     btnCam:=(Sender As TCamGlowButton);
     pos:=findEmptyView;
     if (pos<0) then Exit;
     MultiCams[pos].RtspUrl:=btnCam.camUrl.Url;

     MultiCams[pos].RtspUser:=btnCam.camUrl.id;
     MultiCams[pos].RtspPass:=btnCam.camUrl.password;
     MultiCams[pos].isMerged:=btnCam.isMergedCam;
     MultiCams[pos].camName := btnCam.camName;


     if (MultiCams[pos].isMerged) then begin
         MultiCams[pos].MergeCams:=btnCam.MergeCams;
         MultiCams[pos].mergeName:=btnCam.mergeName;
         MultiCams[pos].mergeIdx:=btnCam.mergeIdx;
         MultiCams[pos].mergeTrainid:=btnCam.mergeTrainid;
         MultiCams[pos].camName:=btnCam.mergeName;
     end;



     MultiCams[pos].Allocated:=true;
     MultiCams[pos].EndDrag(true);
     MultiCams[pos].PlayView;



end;



procedure TfrmTVCSMain.CheckMonitor;
begin
   FMonitorCount:=Screen.MonitorCount;
 {  if (fmAutoCamView=nil) then
     fmAutoCamView:=TfrmAutoView.Create(self);

   if (FMonitorCount=1) then begin
      fmAutoCamView.Left:=Self.Left+10;
      fmAutoCamView.Top:=Self.top+10;
      fmAutoCamView.Width:=Self.Width-100;
      fmAutoCamView.height:=Self.Height-100;
      fmAutoCamView.Position:=poMainFormCenter;
   end
   else begin
       fmAutoCamView.Left:=Screen.Monitors[[1].
   end;
   }
end;


procedure TfrmTVCSMain.camVideoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
 cam:TCamView;
 camsource:TCamGlowButton;
begin
    if Source is TCamGlowButton  then
    begin
     if (Sender is TPasLibVlcPlayer) then
     begin
       cam:=((Sender as TPasLibVlcPlayer).Parent As TCamView);

     end;
     if (Sender is TCamView) then
       cam:=(Sender as TCamView);

     if (cam.Allocated) then
       cam.StopView;

     camsource:=(Source As TCamGlowButton);
     cam.RtspUrl:=camsource.camUrl.Url;
     cam.RtspUser:=camsource.camUrl.id;
     cam.RtspPass:=camsource.camUrl.password;
     cam.isMerged:=camsource.isMergedCam;
     cam.camName:=camsource.camName;


     if (cam.isMerged) then begin
       cam.MergeCams:=camsource.MergeCams;
       cam.mergeName:=camsource.mergeName;
       cam.mergeidx:=camsource.mergeidx;
       cam.mergeTrainId:=camSource.mergeTrainid;
       cam.camName:=camsource.mergeName;
     end;

     cam.Allocated:=true;
     cam.PlayView;

    end;
end;

procedure TfrmTVCSMain.camVideoDragOver(Sender, Source: TObject; X, Y: Integer;
     State: TDragState; var Accept: Boolean);
begin
    if Source is TCamGlowButton then
      accept := true;
end;
Procedure TfrmTVCSMain.camVideoMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
   if (Button=mbLeft) and not (ssDouble in Shift) then
     (Sender as TCamGlowButton).BeginDrag(true);

end;
Procedure TfrmTVCSMain.camViewMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
var
 pnt:TPoint;
 player:TPasLibVlcPlayer;
begin
   if (Button=mbRight) and GetCursorPos(pnt) then begin

      if (Sender is TPasLibVlcPlayer) then begin
          player:=(Sender As TPasLibVlcPlayer);
         if ((player.Parent As TCamView).Allocated) then begin
          camPopup.Popup(pnt.x,pnt.y);
          camPopUp.tag:=(player.Parent As TCamView).pos;
         end;
      end
      else if (Sender is TCamView) then begin
    //      camPopUp.tag:=(Sender As TCamView).pos;

      end;
    //  ShowMessage('cam popup');
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

procedure TfrmTVCSMain.InitEventSocket;
begin
 EventSock.Addr:=EventServAddr;
 EventSock.Port:=IntToStr(EventservPort);
 EventSock.Proto:='tcp';
 EventSock.Connect;

end;

procedure TFrmTVCSMain.DispSchedTrain(packet: TTTCProtocol);
var
  i, idx: Integer;
  rettab, stcode: Integer;
  line4Status: string;
  line4Code: string;
  signalStr: integer;
begin
  idx := lstTrainSched.RowCount;
  for i := 1 to lstTrainSched.RowCount-1 do begin
    if (lstTrainSched.Cells[1,i] = IntToStr(packet.ThisTrainNo)) then begin
      idx := i;
      break;
    end;
  end;

  if (idx >= lstTrainSched.RowCount) then Exit;

  with lstTrainSched do begin
    // 4호선인 경우 TCode 사용
    if (FLineNo = 4) then begin
      if (Packet.TCode <> '') then begin
        line4Code := Trim(Packet.TCode); // 앞뒤 공백 제거

        // 미리 준비된 맵핑 데이터에서 상태 찾기
        if (IndexOf(Line4ApproachCodes, line4Code) >= 0) then
          line4Status := '● 접근'
        else if (IndexOf(Line4ArriveCodes, line4Code) >= 0) then
          line4Status := '● 도착'
        else if (IndexOf(Line4DepartCodes, line4Code) >= 0) then
          line4Status := '● 출발'
        else
          line4Status := Cells[2, idx];



        Cells[2, idx] := line4Status;
      end;
    end
    else begin
      // 기존 2,3호선 처리 방식
      case packet.Opcode of
        PKT_LINE2_DEPART:
          Cells[2, idx] := '● 출발';
        PKT_LINE2_APPROACH:
          Cells[2, idx] := '● 접근';
        PKT_LINE2_ARRIVE:
          Cells[2, idx] := '● 도착';
      end;
    end;

    Cells[3, idx] := ProcessStationName(packet.ArrStationNo-FLineNo*100, FLineNo);
    Cells[4, idx] := InttoStr(packet.ArrStationNo);
    Cells[5, idx] := IntToStr(packet.Direction);

    if (FDebugWin <> nil) then
      FDEbugWin.DisplayAnal(Format('Cells row %d opcode 0x%x stname:%s', [idx, packet.Opcode, Cells[3, idx]]));

    ReDrawRoute;
    rettab := GetStationIdx(packet.ArrStationNo, stcode);
    if (rettab = tabRoute.TabIndex) then begin
      ReDrawRoute;
    end;
  end;
end;

// 4호선열차 그리기용
function TfrmTVCSMain.IndexOf(const Arr: array of string; const Value: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := Low(Arr) to High(Arr) do
    if Arr[i] = Value then
    begin
      Result := i;
      Break;
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
  lstTrainSched.ColCount:=10;
  lstTrainSched.RowCount:=Length(FTrains)+1;
  for I := 4 to lstTrainSched.ColCount-1 do
    lstTrainSched.HideColumn(i);



with lstTrainSched do begin
    Cells[0,0]:='편성';
    Cells[1,0]:='열차번호';
    Cells[2,0]:='상태';
    Cells[3,0]:='역명';

  end;

  with lstTrainSched do begin
     ColWidths[0]:=60;
     ColWidths[1]:=60;
     ColWidths[2]:=50;
     ColWidths[3]:=180;
  end;
  lstTrainSched.RowColor[0]:=clBlack;
  lstTrainSched.RowFontColor[0]:=clWhite;
  lstTrainSched.Options:=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goDrawFocusSelected,goColSizing,goRowSelect];



  with lstTrainSched do begin

       for i :=0 to Length(FTrains)-1 do begin

          Cells[0,i+1]:=InttoStr(FTrains[i].fid);
          Cells[1,i+1]:=FTrains[i].ftrainNo;
          Cells[2,i+1]:='-';
          Cells[3,i+1]:='-';
          Cells[4,i+1]:='0'; //ArrStationNo
          Cells[5,i+1]:='0'; //Direction
          Cells[6,i+1]:=IntToStr(FTrains[i].fcarriageNum);
          Cells[7,i+1]:=InttoStr(FTrains[i].fcameraNum);
          Cells[8,i+1]:=IntToStr(FTrains[i].fformatNo);
          Cells[9,i+1]:=FTrains[i].ftvcsIpaddr;

        {  if odd(i+1) then begin
             lstTrainSched.RowColor[i+1]:=clLtGray;
          end
          else begin

            lstTrainSched.RowColor[i+1]:=clWhite;
          end;}
        end;


  end;
  lstTrainSched.EndUpdate;
end;

procedure TfrmTVCSMain.ClearSplitView;
var
 i,cnt:integer;
begin
  if (MultiCams=nil) then Exit;
  for I :=0  to Length(Multicams)-1 do begin
         FreeAndNil(MultiCams[i]);
  end;

end;
procedure TfrmTVCSMain.cmbStyleChange(Sender: TObject);
begin
    TStyleManager.TrySetStyle(cmbStyle.Text);
end;

procedure TfrmTVCSMain.cmbStyleKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TfrmTVCSMain.CamViewClick(Sender: TObject);
var
 frm:TfrmFullViewer;
 cam:TPasLibVlcPlayer;
 camview:TCamView;
 oldL, oldT, oldW, oldH : Integer;
 oldA : TAlign;
begin
if (Sender is TPasLibVlcPlayer) then begin

  cam:=(Sender as TPasLibVlcPlayer);

  if (cam=nil) then Exit;
  camview:=cam.Parent as TCamView;
end;

if (Sender is TCamView) then begin
     camview:=Sender As TCamView;
end;
if (not camView.Allocated) then Exit;


  {
  oldL := cam.Left;
  oldT := cam.Top;
  oldW := cam.Width;
  oldH := cam.Height;
  oldA := cam.Align;
   }
  frm:=TfrmFullViewer.Create(self);
  frm.SetBounds(Monitor.Left, Monitor.Top, Monitor.Width, Monitor.Height);
  //ShowMessage('camview.RtspUrl:'+camview.RtspUrl);
  frm.RTSPUrl:=camview.RtspUrl;
  frm.RTSPUser:=camView.RtspUser;
  frm.RTSPPass:=camView.RtspPass;
  frm.isMerged:=camview.isMerged;


  if (frm.isMerged) then begin
    frm.MergeCams:=camview.MergeCams;
    frm.mergeName:=camview.mergeName;
    frm.mergeIdx:=camview.mergeIdx;
    frm.mergeTrainId:=camview.mergeTrainId;
  end;

  frm.PlayView;


//  WinApi.Windows.SetParent(cam.Handle, frm.Handle);
 // cam.SetBounds(0, 0, frm.Width, frm.Height);
 // cam.align:=alClient;
//  cam.PlayInWindow(frm.handle);
  frm.ShowModal;
  //cam.SetBounds(oldL, oldT, oldW, oldH);
 // WinApi.Windows.SetParent(cam.Handle, camview.Handle);
  frm.Free;
 // if (oldA <> alNone) then cam.Align := oldA;

end;
procedure TTrainCameraItem.ReloadButtons(OnDblClickMethod: TNotifyEvent);
var
  multiCamCount,camCount,idx:Integer;
begin
   multiCamCount:=Length(FMergeCams);
   camCount:=Length(FTrainCams);

  if (multiCamCount>0) then  begin
     CreateMultiButton(multicamCount);
     for idx := Low(MergeCams) to High(MergeCams) do begin

               BtnMergeCam[idx]:=TCamGlowButton.Create(nil);
               BtnMergeCam[idx].Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_multi_cam);
         //      BtnMergeCam[idx]Images:=FMultiImg;
         //      BtnMergeCam[idx].imageIndex:=0;
               BtnMergeCam[idx].Appearance.PictureAlignment:=taCenter;

               BtnMergeCam[idx].Width:=BtnMergeCam[idx].Picture.Width;
               BtnMergeCam[idx].Height:=BtnMergeCam[idx].Picture.Height;
//               BtnMergeCam[idx].Transparent:=true;
             //  BtnMergeCam[idx].ShowCaption:=false;
               BtnMergeCam[idx].camUrl.Url:=MergeCams[idx].ftvcsRtsp;
               BtnMergeCam[idx].DragMode:=TDragMode.dmManual;

               BtnMergeCam[idx].OnDblClick:=OnDblClickMethod;
               BtnMergeCam[idx].camName := MergeCams[idx].fname;



     end;
  end;
  if (camCount>0) then begin

      CreateSingleButton(camCount);
      for idx := Low(TrainCams) to High(TrainCams) do begin

           BtnSingleCam[idx]:=TCamGlowButton.Create(nil);
           BtnSingleCam[idx].Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_cam_normal);
           BtnSingleCam[idx].Appearance.PictureAlignment:=taCenter;

           BtnSingleCam[idx].Width:=BtnSingleCam[idx].Picture.Width;
           BtnSingleCam[idx].Height:=BtnSingleCam[idx].Picture.Height;
           BtnSingleCam[idx].DragMode:=TDragMode.dmManual;

           BtnSingleCam[idx].camUrl.Url:=FTrainCams[idx].frtsp;
           BtnSingleCam[idx].camUrl.id:=FTrainCams[idx].fuserId;
           BtnSingleCam[idx].camUrl.password:=FTrainCams[idx].fuserPwd;
           BtnSingleCam[idx].camName := FTrainCams[idx].fname;

           BtnSingleCam[idx].OnDblClick:=OnDblClickMethod;



      end;

  end;

end;

procedure TfrmTVCSMain.reloadMergeCams;
var
 idx,iTrain:Integer;
 MergeCams: TArray <TVCSTrainCameraMerge>;
begin

  for idx := low(MultiCams) to High(multiCams) do begin
    if (MultiCams[idx].isMerged) then begin
          if (Multicams[idx].mergeName<>'') then begin
               MergeCams :=gapi.GetTrainCameraMerge(MultiCams[idx].mergeTrainId);
               for iTrain := Low(MergeCams) to High(MergeCams) do begin
                       if (MergeCams[iTrain].fname=Multicams[idx].MergeName) then begin
                                   Multicams[idx].MergeCams:=MergeCams[iTrain];
                                   break;
                       end;

                end;
          end;
     end;
  end;

end;

procedure TfrmTVCSMain.AddTrainTab(idrow:Integer);
var
  trainId,trainNo,trainCount:String;
  idx:Integer;
  camInfo:TVCSTrainCamera;
  fTrainCamItem:TTrainCameraItem;
  camCount,multicamCount:Integer;
  iTrain:Integer;
begin
  trainId:=lstTrainSched.Cells[0,idrow];
  trainNo:=lstTrainSched.Cells[1,idrow];
  trainCount:=lstTrainSched.Cells[6,idrow];



  for idx :=0  to tabRoute.AdvTabs.Count-1 do begin
     if (tabRoute.AdvTabs.Items[idx].Tag=StrToInt(trainId)) then begin
         tabRoute.TabIndex:=idx;
         Exit;
     end;
  end;


  fTrainCamItem:=TTrainCameraItem.Create;
  fTrainCamItem.CarriageCount:=StrtoInt(trainCount);
  fTrainCamItem.TrainCams:=gapi.GetTrainCamera(StrToInt(trainId));
  fTrainCamItem.MergeCams :=gapi.GetTrainCameraMerge(StrToInt(trainId));
  for idx := low(MultiCams) to High(multiCams) do begin
       if (MultiCams[idx].mergeTrainId=StrToInt(trainId)) then begin
          if (Multicams[idx].mergeName<>'') then begin
             if (Multicams[idx].MergeCams=nil) then begin
                 for iTrain := Low(fTrainCamItem.MergeCams) to High(fTrainCamItem.MergeCams) do begin
                       if (fTrainCamItem.MergeCams[iTrain].fname=Multicams[idx].MergeName) then begin
                                   Multicams[idx].MergeCams:=fTrainCamItem.MergeCams[iTrain];
                       end;

                 end;

             end;
          end;
       end;
  end;

  with tabRoute.AdvTabs.Add do begin
        Aobject:=fTrainCamItem;
        ShowClose:=true;
        tag:=StrToInt(trainId);
        Caption:=trainNo+' 열차';

  end;

  multicamCount:=Length(fTrainCamItem.MergeCams);
  camCount:=Length(fTrainCamItem.TrainCams);
  tabRoute.TabIndex:=tabRoute.AdvTabs.Count-1;

  if (multiCamCount>0) then  begin
     fTrainCamItem.CreateMultiButton(multicamCount);
     for idx := Low(fTrainCamItem.MergeCams) to High(fTrainCamItem.MergeCams) do begin
          with  fTrainCamItem do begin
               BtnMergeCam[idx]:=TCamGlowButton.Create(pnRoute);
               BtnMergeCam[idx].Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_multi_cam);
               BtnMergeCam[idx].Appearance.PictureAlignment:=taCenter;
               BtnMergeCam[idx].Width:=BtnMergeCam[idx].Picture.Width;
               BtnMergeCam[idx].Height:=BtnMergeCam[idx].Picture.Height;
               BtnMergeCam[idx].camUrl.Url:=fTrainCamItem.MergeCams[idx].ftvcsRtsp;
               BtnMergeCam[idx].isMergedCam:=true;
               BtnMergeCam[idx].mergeName:=fTrainCamItem.MergeCams[idx].fname;
               BtnMergeCam[idx].mergeidx:=idx;
               BtnMergeCam[idx].mergeTrainid:=StrToInt(trainId);

               BtnMergeCam[idx].MergeCams:=fTrainCamItem.MergeCams[idx];
               BtnMergeCam[idx].camName := fTrainCamItem.MergeCams[idx].fname;

      //         BtnMergeCam[idx]

               BtnMergeCam[idx].OnDblClick:=OnCamBtnDoubleClick;
               BtnMergeCam[idx].onMouseDown:=camVideoMouseDown;
               BtnMergeCam[idx].DragMode:=TDragMode.dmManual;
  

          end;
     end;
  end;


  if (camCount>0) then begin

    fTrainCamItem.CreateSingleButton(camCount);
    for idx := Low(fTrainCamItem.TrainCams) to High(fTrainCamItem.TrainCams) do begin
          with fTrainCamItem do begin
                 BtnSingleCam[idx]:=TCamGlowButton.Create(pnRoute);
                 BtnSingleCam[idx].Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_cam_normal);
                 BtnSingleCam[idx].Width:=BtnSingleCam[idx].Picture.Width;
                 BtnSingleCam[idx].Height:=BtnSingleCam[idx].Picture.Height;
                 BtnSingleCam[idx].Appearance.PictureAlignment:=taCenter;
                 BtnSingleCam[idx].camUrl.Url:=FTrainCams[idx].frtsp;
                 BtnSingleCam[idx].camUrl.id:=FTrainCams[idx].fuserId;
                 BtnSingleCam[idx].camUrl.password:=FTrainCams[idx].fuserPwd;
                 BtnSingleCam[idx].OnDblClick:=OnCamBtnDoubleClick;
                 BtnSingleCam[idx].onMouseDown:=camVideoMouseDown;
                 BtnSingleCam[idx].DragMode:=TDragMode.dmManual;
                 BtnSingleCam[idx].camName := FTrainCams[idx].fname;

          end;

    end;

  end;




end;

procedure TfrmTVCSMain.btnAutoViewClick(Sender: TObject);

begin
 if (frmAutoView=nil) then
   frmAutoView:=TfrmAutoView.Create(self);
   frmAutoView.Show;


end;

procedure TfrmTVCSMain.btnMainMenuClick(Sender: TObject);
begin
  popupMain.PopupAtControl(btnMainMenu);
end;




procedure TfrmTVCSMain.btnSplit16Click(Sender: TObject);
begin
SplitView(16);
end;

procedure TfrmTVCSMain.btnSplit1Click(Sender: TObject);
begin
SplitView(1);
end;

procedure TfrmTVCSMain.btnSplit4Click(Sender: TObject);
begin
SplitView(4);
end;

procedure TfrmTVCSMain.btnSplit9Click(Sender: TObject);
begin
SplitView(9);
end;


procedure TFrmTVCSMain.MakeRouteTab;
var
 idx,curstidx,tabCount,tabRemain:Integer;

begin
  tabCount:=FStationCount div max_stations_per_tab;
  tabRemain:=FStationCount mod max_stations_per_tab;
  if (tabRemain >0) then inc(TabCount);
  SetLength(StationRange,tabCount);
  curstidx:=0;
  curTabCount:=tabCount;

   tabRoute.AdvTabs.Clear;
   with tabRoute do begin
      TabHeight:=30;
      Font.size:=12;
      Font.color:=clWhite;
      TextColor:=clWhite;
      ActiveFont.size:=12;
      ActiveFont.Color:=clWhite;
   end;


  for idx := 0 to tabCount-1 do begin

    StationRange[idx].startIdx:=curstidx;
    if (curstidx+(max_stations_per_tab-1) >(FStationCount-1)) then begin
      StationRange[idx].endIdx:=FStationCount-1;
    end
    else begin
      StationRange[idx].endIdx:=curstidx+(max_stations_per_tab-1);
      inc(curstidx,max_stations_per_tab);
    end;
    with tabRoute.AdvTabs.Add do begin
         tag:=idx;
         Font.Color:=clWhite;
         TextColor:=clWhite;
         Font.Size:=11;
         Caption:=Format('%s~%s',[FStations[StationRange[idx].startIdx].fname,FStations[StationRange[idx].endIdx].fname]);
         AObject:=nil;
    end;

  end;



end;
function TfrmTVCSMain.findMultiCam(x,y:Integer):Integer;
var
 i:Integer;
begin
 for I := Low(MultiCams) to High(Multicams) do begin
 //   if (Multicams[i].Left then


 end;


end;
procedure TfrmTVCSMain.mnuCamDeleteClick(Sender: TObject);

begin
  if (Multicams[camPopup.tag].Allocated) then  begin
    Multicams[camPopup.tag].StopView;
    Multicams[camPopup.tag].Allocated:=false;
    Multicams[camPopup.tag].Player.Visible:=false;
  end;


end;

procedure TfrmTVCSMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTVCSMain.pnCamViewCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
 count:Integer;
 rowCount,colCount:Integer;
 FCamWidth,FCamheight:Integer;
 row,col,i:Integer;
begin
    if (curSplit <=0) then Exit;
     count:=curSplit;
     rowCount:=trunc(sqrt(count));
     colCount:=trunc(sqrt(count));
     FCamWidth:=NewWidth div colCount;;
     FCamHeight:=NewHeight div rowCount;;
     row:=0;
     col:=0;
     for i := 0 to count-1 do begin
       MultiCams[i].Left:=col*FCamWidth;
       MultiCams[i].top:=row*FCamHeight;
       MultiCams[i].width:=FCamWidth;
       MultiCams[i].Height:=FCamHeight;
      // MultiCams[i].Repaint;


       inc(col);
       if (col >=colCount)then begin
          inc(row);
          col:=0;
       end;
     end;
     Resize:=true;

end;

procedure TfrmTVCSMain.pnRoutePaint(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect);
var
   tab:TTabCollectionItem;
begin
  if (tabRoute.TabIndex <0) then Exit;

  tab:=tabRoute.AdvTabs.Items[tabRoute.TabIndex];
  if (tab.ShowClose) then
     DrawTrainIn(ACanvas,ARect,tabRoute.TabIndex)
  else
     DrawRoute(ACanvas,ARect);
end;

procedure TfrmTVCSMain.pnTopmenuDblClick(Sender: TObject);
begin
if (self.WindowState=TWindowState.wsNormal) then begin
  self.WindowState:=TWindowState.wsMaximized;
  toolBtnMax.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_system_restore);
end
else if (self.WindowState=TWindowState.wsMaximized) then begin
  self.WindowState:=TWindowState.wsNormal;
  toolBtnMax.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_system_max);
end;
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
       MultiCams[i].OnDblClick := CamViewClick;
       inc(col);
       if (col >=colCount)then begin
          inc(row);
          col:=0;
       end;
 end;


end;

procedure TfrmTVCSMain.FormActivate(Sender: TObject);
begin
if (fmAutoCamView<>nil) then
  fmAutoCamView.Show;
end;

Procedure TfrmTVCSMain.CreateSplitPanel;
var
 i:Integer;

begin
 SetLength(MultiCams,16); //max 16분힐
 for i := 0 to 15 do
       MultiCams[i]:=TCamView.Create(pnCamView);
end;


procedure TfrmTVCSMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     SaveSettings;
end;

procedure TfrmTVCSMain.FormCreate(Sender: TObject);
var
  StyleName, appPath: string;
  info:TVCSLogin;
  LineNo: string;
  Bitmap: TBitmap;

begin

  LineNo := IntToStr(gapi.GetLoinInfo.fsystem.fline);
  icon_image_path:= '.\icon-img\';
  icon_upbox:='icon-upbox'+LineNo+'.png';
  icon_downbox:='icon-downbox'+LineNo+'.png';
  icon_station:='icon-station'+LineNo+'.png';
//  icon_train_head='icon-train-01.png';

  icon_train_head:='train0'+LineNo+'-left.png';
  icon_train_body:='train0'+LineNo+'-center.png';
  icon_train_tail:='train0'+LineNo+'-right.png';

          // icon_train_body:='icon-train-02.png';
          // icon_train_tail:='icon-train-03.png';
  icon_multi_cam:='multicam.png';
  icon_cam_normal:='camera0'+LineNo+'-on.png';
  icon_cam_abnormal:='icon-camera-02.png';
  icon_system_max:='icon-max.png';
  icon_system_restore:='icon-restore.png';
  icon_trainbox_down:='icon-trainBox0'+LineNo+'-Down.png';
  icon_trainbox_up:='icon-trainBox0'+LineNo+'-Up.png';

  Bitmap := TBitmap.Create;
  ImageListBitmap.GetBitmap(StrToInt(LineNo), Bitmap);
  tabRoute.TabBackGroundSelected := Bitmap;
  Bitmap.Free;


  // TCMS IP 주소
  //EventServAddr:='192.168.1.49';
  //EventservPort:=7004;

  //EventServAddr:='127.0.0.1';
  //EventservPort:=9000;
  //EventServAddr='192.168.1.69';
  //EventservPort=9000;



 pnTopmenu.Color := $1b1511;
 pnCamView.Color := $170e08;
 info:=GApi.GetLoinInfo;
 FLineNo:=info.fsystem.fline;
 LoadSchedPanel;

 curSplit:=0;
 for StyleName in TStyleManager.StyleNames do
    cmbStyle.Items.Add(StyleName);

 cmbStyle.ItemIndex := cmbStyle.Items.IndexOf(TStyleManager.ActiveStyle.Name);

 appPath := ExtractFilePath(ParamStr(0));
 //ShowMessage(appPath);
 //TStyleManager.LoadFromFile(appPath+'\icon-img\Style.vsf');
 //TStyleManager.TrySetStyle('Onyx Blue2');

 TStyleManager.TrySetStyle('Onyx Blue2');


 self.KeyPreview:=true;


 InitEventSocket;
 CheckMonitor;
 CreateSplitPanel;
 LoadSettings;
 reloadMergeCams;
 SplitView(curSplit);


end;

procedure TfrmTVCSMain.FormDestroy(Sender: TObject);
var
 i:Integer;
begin
  if (MultiCams<>nil) then begin
    for i:= 0 to Length(Multicams)-1 do
      FreeAndNil(Multicams[i]);
  end;

end;

procedure TfrmTVCSMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If (GetKeyState(Ord('D'))<0) and (GetKeyState(VK_MENU)<0) and(GetKeyState(VK_SHIFT)<0) and (GetKeyState(VK_CONTROL)<0) then
 begin
 if (FDebugWin=nil) then
   FDebugWin:=TfrmDebug.Create(self);
   FDebugWin.Position:=poOwnerFormCenter;
   FDebugWin.Show;

 end;


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

procedure TfrmTVCSMain.FormShow(Sender: TObject);
begin
Application.ProcessMessages;
end;

procedure TfrmTVCSMain.MultiCamClose(Sender:TObject);
begin

end;

procedure TfrmTVCSMain.CopyCamView(var dstcam:TCamView;srccam:TCamView);
begin
   dstcam.RtspUrl:= srccam.RtspUrl;
   dstcam.RtspUser:= srccam.RtspUser;
   dstcam.RtspPass:= srccam.Rtsppass;
   dstCam.Allocated:=srccam.Allocated;
   dstCam.isMerged:=srcCam.isMerged;
   if (dstCam.isMerged) then begin
     dstcam.mergeName:=srcCam.mergeName;
     dstcam.mergeidx:=srcCam.mergeidx;
     dstcam.MergeCams:=srccam.MergeCams;
     dstcam.mergeTrainId:=srccam.mergeTrainId;
   end;
end;

procedure  TfrmTVCSMain.AssignCamView(var dstcam:TCamView;aPos,aCol,aRow,aCamWidth,aCamHeight:Integer);
begin
       dstcam.Left:=aCol*aCamWidth;
       dstcam.top:=aRow*aCamHeight;
       dstcam.width:=aCamWidth;
       dstcam.Height:=aCamHeight;
       dstcam.Parent:=pnCamView;
       dstcam.ParentColor:=false;
       dstcam.BorderColor:=clWhite;
       dstcam.BorderStyle:=bsSingle;
       dstcam.BevelInner:=bvLowered;
       dstcam.BevelOuter:=bvNone;
       dstcam.BevelWidth:=1;
       dstcam.Caption.Visible:=false;
       dstcam.Caption.Height:=10;
       dstcam.Caption.Flat:=true;
       dstcam.Caption.CloseButton:=false;
       dstcam.onClose:=MultiCamClose;
       dstcam.OnDragOver:=camVideoDragOver;
       dstcam.OnDragDrop:=camVideoDragDrop;
       dstCam.OnMouseDown:=camViewMouseDown;
       //dstcam.PopupMenu:=camPopup;
       dstcam.BasePath:=ExtractFilePath(Application.ExeName);
       dstcam.OnDblClick := CamViewClick;
       dstCam.pos:=aPos;

end;

procedure TfrmTVCSMain.SplitView(count: Integer);
var
 i,row,col,lastcnt:Integer;
 FCamWidth,FCamHeight:Integer;
 rowCount,colCount:Integer;
 oldCamView:array of TCamView;
 allocatedCount:Integer;
begin

     rowCount:=trunc(sqrt(count));
     colCount:=trunc(sqrt(count));
     FCamWidth:=pnCamView.Width div colCount;;
     FCamHeight:=pnCamView.Height div rowCount;;
     row:=0;
     col:=0;
     SetLength(oldCamView,curSplit);
     allocatedCount:=0;
     for i := 0 to curSplit-1 do begin
         if (MultiCams[i].Allocated) then begin
            oldCamView[allocatedCount]:=TCamView.Create(pnCamView);
            CopyCamView(oldCamView[allocatedCount],Multicams[i]);
            Inc(allocatedCount);
         end;
     end;

     ClearSplitView;
     CreateSplitPanel;

     if (allocatedCount >=count) then begin
        for i := 0 to count-1 do begin
            AssignCamView(MultiCams[i],i,col,row,FCamWidth,FCamheight);
            CopyCamView(MultiCams[i],oldCamView[i]);
            MultiCams[i].PlayView;
           inc(col);
           if (col >=colCount)then begin
              inc(row);
              col:=0;
           end;
        end;

     end
     else begin

        for i := 0 to allocatedCount-1 do begin
            AssignCamView(MultiCams[i],i,col,row,FCamWidth,FCamheight);
            CopyCamView(MultiCams[i],oldCamView[i]);
            MultiCams[i].PlayView;
            inc(col);
             if (col >=colCount)then begin
                inc(row);
                col:=0;
             end;
         end;
        if (allocatedCount=0) then
            lastcnt:=0
        else lastcnt:=i;


        for i := lastcnt to count-1 do begin
           AssignCamView(MultiCams[i],i,col,row,FCamWidth,FCamheight);
           MultiCams[i].isMerged:=false;
           MultiCams[i].Allocated:=false;
           inc(col);
           if (col >=colCount)then begin
              inc(row);
              col:=0;
           end;
        end;

     end;



     curSplit:=count;

end;
procedure TfrmTVCSMain.tabRouteChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
 FTrainCameraItem:TTrainCameraItem;
 FNewTrainCameraItem:TTrainCameraItem;
begin
 if tabRoute.TabIndex<0 then Exit;


 FTrainCameraItem:=(tabRoute.AdvTabs.Items[tabRoute.TabIndex].AObject As TTrainCameraItem);


 if (not TabRoute.AdvTabs.Items[NewTab].ShowClose) then
 begin
      if (FTrainCameraItem=nil) then Exit;
       FTrainCameraItem.ClearButtons;
 end
 else begin
     if (FTrainCameraItem<>nil) then
       FTrainCameraItem.ClearButtons;
       FNewTrainCameraItem:=(tabRoute.AdvTabs.Items[NewTab].AObject As TTrainCameraItem);
       if (FNewTrainCameraItem<>nil) then begin      //clearButton???
        FNewTrainCameraItem.ClearButtons;
        FNewTrainCameraItem.ReloadButtons(OnCamBtnDoubleClick);
       end;

 end;


end;

procedure TfrmTVCSMain.tabRouteClick(Sender: TObject);
var
 i:Integer;
begin

pnRoute.Invalidate;

end;

procedure TfrmTVCSMain.tabRouteTabClose(Sender: TObject; TabIndex: Integer);
var
 tabSheet:TAdvTabSheet;
 idx:Integer;

begin
 if (tabRoute.AdvTabs.Items[TabIndex].AObject<>nil) then
   FreeAndNil(tabRoute.AdvTabs.Items[TabIndex].AObject);

 tabRoute.AdvTabs.Delete(TabIndex);
end;

procedure TfrmTVCSMain.InitStations;
var
 i:Integer;
begin
// api call
 FStations:=Gapi.GetStation('',FLineNo);
 FStationCount:=Length(Fstations);

 MakeRouteTab;

end;

procedure TfrmTVCSMain.LoadTrain;
begin
     FTrains:=GApi.GetTrain(-1);
end;


procedure TfrmTVCSMain.lstTrainSchedDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
 if (Arow=0) then exit;

  AddTrainTab(ARow);
end;

procedure TfrmTVCSMain.lstTrainSchedGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
Afont.size:=12;
if (ACol=2) and (ARow >0) then begin
 if (Sender As TAdvStringGrid).Cells[Acol,ARow].Contains('출발') then
   AFont.Color:=ColorFromHex('#F5365C')
 else if (Sender As TAdvStringGrid).Cells[Acol,ARow].Contains('도착') then
    AFont.Color:=ColorFromHex('#2DCE89')
 else if (Sender As TAdvStringGrid).Cells[Acol,ARow].Contains('접근') then
    AFont.Color:=ColorFromHex('#ffa500')

end;
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

procedure TfrmTVCSMain.actExitExecute(Sender: TObject);
begin
   Close;
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

      //


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
if (self.WindowState=TWindowState.wsNormal) then begin
  self.WindowState:=TWindowState.wsMaximized;
  toolBtnMax.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_system_restore);
end
else if (self.WindowState=TWindowState.wsMaximized) then begin
  self.WindowState:=TWindowState.wsNormal;
  toolBtnMax.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_system_max);
end;

end;

procedure TfrmTVCSMain.toolBtnMinimizeClick(Sender: TObject);
begin
   self.WindowState:=TWindowState.wsMinimized;
end;



procedure TfrmTVCSMain.DrawStations(ACanvas:TCanvas;ARect:TRect;tabidx:Integer);
var
 i, idx: Integer;
 StationStartX, StationSpacing, CenterLineY: Integer;
 FPicture: TGDIPPicture;
 FStationNo: Integer;
 TrainDirection: Byte;
 TrainOffsetX: Integer;
begin
 if (length(StationRange) = 0) then Exit;
 CenterLineY := ARect.Height div 2;
 FPicture := TGDIPPicture.Create;
 FPicture.LoadFromFile(ExtractFilePath(Application.ExeName) + icon_image_path + icon_station);
 StationStartX := 150;
 StationSpacing := (ARect.Width - 50 - StationStartX - FPicture.Width) div 9;

 for i := StationRange[tabidx].startIdx to StationRange[tabidx].endIdx do begin
        DrawImage(ACanvas, StationStartX + ((i - StationRange[tabidx].startIdx) * StationSpacing),
                  CenterLineY - 30, FPicture);
        DrawLabel(ACanvas, StationStartX + ((i - StationRange[tabidx].startIdx) * StationSpacing),
                  CenterLineY + 2, FStations[i].fname, clBlack, 12);

        for idx := 1 to lstTrainSched.RowCount - 1 do begin
                FStationNo := StrToInt(lstTrainSched.Cells[4, idx]);
                if (FStationNo = 0) then continue;

                if (FStationNo = StrToInt(FStations[i].fcode)) then begin
                     if (FDebugWin <> nil) then
                         FDebugWin.DisplayAnal(Format('station code %s name %s',[FStations[i].fcode, FStations[i].fname]));

                     // 열차 방향 가져오기 (1:상행, 2:하행)
                     TrainDirection := StrtoInt(lstTrainSched.Cells[5, idx]);

                     // 열차 상태에 따른 X 위치 오프셋 계산 (방향에 따라 다르게)
                     if TrainDirection = 1 then begin
                         // 상행 열차 (오른쪽에서 왼쪽으로)
                         if lstTrainSched.Cells[2, idx].contains('출발') then
                            TrainOffsetX := -70  // 역 왼쪽으로 출발
                         else if lstTrainSched.Cells[2, idx].Contains('도착') then
                            TrainOffsetX := -20   // 역 왼쪽에 도착 (약간 거리)
                         else if lstTrainSched.Cells[2, idx].Contains('접근') then
                            TrainOffsetX := 50;  // 역 오른쪽에서 접근
                     end else begin
                         // 하행 열차 (왼쪽에서 오른쪽으로) - 기존 로직 유지
                         if lstTrainSched.Cells[2, idx].contains('출발') then
                            TrainOffsetX := 50   // 역 오른쪽으로 출발
                         else if lstTrainSched.Cells[2, idx].Contains('도착') then
                            TrainOffsetX := -20   // 역 왼쪽에 도착 (약간 거리)
                         else if lstTrainSched.Cells[2, idx].Contains('접근') then
                            TrainOffsetX := -70; // 역 왼쪽에서 접근
                     end;

                     // 계산된 오프셋으로 열차 그리기
                     DrawTrain(ACanvas,
                               StationStartX + ((i - StationRange[tabidx].startIdx) * StationSpacing) + TrainOffsetX,
                               CenterLineY,
                               StrtoInt(lstTrainSched.Cells[1, idx]),
                               TrainDirection);
                     break;
                end;
         end;
 end;
 FPicture.Free;
end;

procedure TfrmTVCSMain.DrawCCTV(ACanvas: TCanvas; x,y,camcount: Integer);
begin

end;



procedure TfrmTVCSMain.OnMultiClick(Sender:TObject);
var
   Item:TTabCollectionItem;
begin
  item:=TabRoute.AdvTabs.Items[tabRoute.TabIndex];
  // 비어 있는데 찾기
 // MultiCams[0].RTSPUrl:=CurMergeCams[(Sender as TAdvGlowButton).Tag].ftvcsRtsp;
//  MultiCams[0].PlayView;
end;

procedure TfrmTVCSmain.OnSingleClick(Sender: TObject);
begin

   //
end;


// 열차 선택시 그림 헤드/몸통/꼬리/캠/캠머지
procedure TfrmTVCSMain.DrawTrainIn(ACanvas:TCanvas;ARect:TRect;tabidx:Integer);
var
  D2DCanvas:TDirect2DCanvas;
  tag,count,bodycnt,i,camidx,k:Integer;
  FHead,FTail,FBody:TGDIPPicture;
  FTrainCameraItem:TTrainCameraItem;
  Margin,Spacing,trainSize,trainTop,bodySize:Integer;
  AvgCamCountPerTrain, multiidx:Integer;
  CamSpacing,CamTop:Integer;
  trainCamCount,MergeCamCount:Integer;
  posInCar, currentCar: Integer;
  processedCams: array of Boolean; // 처리된 카메라 추적
begin
   FTrainCameraItem := (tabRoute.AdvTabs.Items[tabidx].AObject As TTrainCameraItem);


   AvgCamCountPerTrain := 4;

   trainCamCount := Length(FTrainCameraItem.TrainCams);
   mergeCamCount := Length(FTrainCameraItem.MergeCams);

   // 처리된 카메라 추적 배열 초기화
   SetLength(processedCams, trainCamCount);

   for k := 0 to trainCamCount-1 do
     processedCams[k] := False;

   FHead := TGDIPPicture.Create;
   Ftail := TGDIPPicture.Create;
   FBody := TGDIPPicture.Create;

   FHead.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_train_head);
   FTail.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_train_tail);
   FBody.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_train_body);

   bodycnt := FTrainCameraItem.CarriageCount-2; //tail ,head
   Spacing := 30;

   trainSize := FHead.Width+FTail.Width+bodycnt*FBody.Width+Spacing*(bodycnt+1);
   bodySize := bodycnt*FBody.Width+Spacing*(bodycnt+1);
   Margin := ((ARect.Width-ARect.Left) div 2)-trainSize div 2;    // Left Margin

   TrainTop := ARect.Height div 2-FHead.Height div 2;

   if trainCamCount = 0 then
    CamTop := 18
   else
   begin
    CamTop := FHead.Height div 2-FTrainCameraItem.BtnSingleCam[0].Height div 2 //center
   end;

   CamSpacing := 15;

   // 열차가 1칸이상이면 머리부분 그림
   if FTrainCameraItem.CarriageCount > 0 then
    DrawImage(ACanvas,Margin,TrainTop,FHead);

   multiidx := 0;

   // Head (1호차) 카메라 처리
   currentCar := 1;
   for k := 0 to trainCamCount-1 do begin
     if (FTrainCameraItem.TrainCams[k].fposition div 100 = currentCar) and (not processedCams[k]) then begin
       with FTrainCameraItem do begin
         posInCar := TrainCams[k].fposition mod 100;
         if (posInCar > 0) then begin
           BtnSingleCam[k].Left := Margin + 80 + (posInCar-1)*BtnSingleCam[k].Width + CamSpacing*(posInCar-1);
           BtnSingleCam[k].Top := TrainTop + CamTop - 11;
           BtnSingleCam[k].Parent := pnRoute;
           BtnSingleCam[k].tag := k;
           BtnSingleCam[k].OnDblClick := OnCamBtnDoubleClick;
           processedCams[k] := True;
         end;
       end;
     end;
   end;

   // Head MergeCam 처리
   if (mergeCamCount > 0) then begin
     with FTrainCameraItem do begin
       BtnMergeCam[multiidx].Left := Margin+FHead.Width-(BtnMergeCam[multiidx].Width div 2)+Spacing div 2;
       BtnMergeCam[multiidx].Top := TrainTop-BtnMergeCam[multiidx].Height;
       BtnMergeCam[multiidx].Tag := multiidx;
       BtnMergeCam[multiidx].Parent := pnRoute;
       BtnMergeCam[multiidx].OnDblClick := OnCamBtnDoubleClick;
     end;
     inc(multiidx);
   end;

   //Body
   for I := 0 to bodycnt-1 do begin
     currentCar := i + 2;  // 현재 처리중인 호차 번호

     if (multiidx < mergeCamCount) then begin
       if (odd(i)) then begin
         with FTrainCameraItem do begin
           BtnMergeCam[multiidx].Left := Margin+FHead.Width+Spacing*(i+1)+FBody.Width*(i+1)-(BtnMergeCam[multiidx].Width div 2)+Spacing div 2;
           BtnMergeCam[multiidx].Top := TrainTop-BtnMergeCam[multiidx].Height;
           BtnMergeCam[multiidx].Parent := pnRoute;
           BtnMergeCam[multiidx].Tag := multiidx;
           BtnMergeCam[multiidx].OnDblClick := OnCamBtnDoubleClick;
         end;
         inc(multiidx);
       end;
     end;

     DrawImage(ACanvas,Margin+FHead.Width+Spacing*(i+1)+FBody.Width*i,TrainTop,FBody);

     // Body 카메라 처리
     for k := 0 to trainCamCount-1 do begin
       if (FTrainCameraItem.TrainCams[k].fposition div 100 = currentCar) and (not processedCams[k]) then begin
         with FTrainCameraItem do begin
           posInCar := TrainCams[k].fposition mod 100;
           if (posInCar > 0) then begin
             BtnSingleCam[k].Left := Margin + FHead.Width + Spacing*(i+1) +
               FBody.Width*i + 50 + (posInCar-1)*BtnSingleCam[k].Width +
               CamSpacing*(posInCar-1);
             BtnSingleCam[k].Top := TrainTop + CamTop - 11;
             BtnSingleCam[k].Parent := pnRoute;
             BtnSingleCam[k].tag := k;
             BtnSingleCam[k].OnDblClick := OnCamBtnDoubleClick;
             processedCams[k] := True;
           end;
         end;
       end;
     end;
   end;

   // 열차가 2칸이상이면 ㄱ꼬리그림
   if FTrainCameraItem.CarriageCount > 1 then
    DrawImage(ACanvas,Margin+FHead.Width+bodySize,TrainTop,FTail);

   // Tail (마지막 호차)
   currentCar := bodycnt + 2;
   for k := 0 to trainCamCount-1 do begin
     if (FTrainCameraItem.TrainCams[k].fposition div 100 = currentCar) and (not processedCams[k]) then begin
       with FTrainCameraItem do begin
         posInCar := TrainCams[k].fposition mod 100;
         if (posInCar > 0) then begin
           BtnSingleCam[k].Left := Margin + FHead.Width + bodySize + 40 +
             (posInCar-1)*BtnSingleCam[k].Width + CamSpacing*(posInCar-1);
           BtnSingleCam[k].Top := TrainTop + CamTop - 11;
           BtnSingleCam[k].Parent := pnRoute;
           BtnSingleCam[k].tag := k;
           BtnSingleCam[k].OnDblClick := OnCamBtnDoubleClick;
           processedCams[k] := True;
         end;
       end;
     end;
   end;

   FHead.Free;
   FTail.Free;
   FBody.Free;
   FTrainCameraItem.isFirstTrainDraw := true;
end;

 procedure TfrmTVCSMain.DisplayTTCPacket(packet:TTTCProtocol);
 begin
  if (FDebugWin=nil) then Exit;
    FDebugWin.DisplayAnal(Format('Len: %d DataLen: %d OPcode: 0x%x ArrStation %d Direction %d TrainNo %d',[Packet.PacketSize,Packet.DataLen,Packet.Opcode,
            Packet.ArrStationNo,Packet.Direction,Packet.ThisTrainNo]));;
    FDebugWin.DisplayPkt(ByteArrToHexSpace(Packet.PacketBuf,packet.PacketSize));


 end;

procedure TfrmTVCSMain.EventSockDataAvailable(Sender: TObject; ErrCode: Word);
var
    Len : Integer;
    I ,DataLen  : Integer;
    Packet:TTTCProtocol;
    PktBuf:TBytes;
begin
    SetLength(PktBuf,1024);
    Len := TWSocket(Sender).Receive(PktBuf, 1024);
    if Len <= 0 then
        Exit;
    Packet:=TTTCProtocol.Create(FLineNo);
    DataLen:=Packet.ReadPacket(PktBuf,Len);
    //DrawTrain(Packet.ArrStationNo,packet.ThisTrainNo,Packet.Direction);
    //DispSchedTrain(Packet.ThisTrainNo,Packet.ArrStationNo,packet.ThisDestStationNo,packet.Direction,Packet.Opcode);
    DispSchedTrain(Packet);
    DisplayTTCPacket(Packet);
    FreeAndNil(Packet);
end;

procedure TfrmTVCSMain.EventSockSocksConnected(Sender: TObject; ErrCode: Word);
begin
  FSockConnected:=true;
end;

procedure TfrmTVCSMain.EventSockSocksError(Sender: TObject; Error: Integer;
  Msg: string);
begin
  if (Error>0) then begin
    FSockConnected:=false;
    EventSockTimer.enabled:=True;
  end;
  
end;

procedure TfrmTVCSMain.EventSockTimerTimer(Sender: TObject);
begin
  if (EventSock.State<>wsConnected) then begin
      EventSock.Connect;
  end;
end;

procedure TfrmTVCSMain.DrawTrain(ACanvas: TCanvas;x,y:Integer;TrainNo:Integer;upDown:Byte);
var
  FPicture:TGDIPPicture;

begin

  FPicture:=TGDIPPicture.Create;
  if (UpDown=$01) then begin
     FPicture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_trainbox_up);
     DrawImage(ACanvas,x,y-50,FPicture);
     DrawLabel(ACanvas,x+24,y-45,InttoStr(TrainNo) ,clBlack,8);
  end
  else begin
     FPicture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_trainbox_down);
     DrawImage(ACanvas,x,y+20,FPicture);
     DrawLabel(ACanvas,x+10,y+25,InttoStr(TrainNo) ,clBlack,8);
  end;





  //    DrawLabel(ACanvas,StationStartX + ((i-StationRange[tabidx].startIdx) * StationSpacing),CenterLineY+2, FStations[i].fname,clBlack,12);
  FPicture.Free;

end;

 function  TfrmTVCSMain.GetStationIdx(stcode:Integer;var stationIndex:Integer):Integer;
 var
  i,idx:Integer;
 begin
  for I :=Low(FStations) to High(FStations) do begin
     if (FStations[i].fcode=IntToStr(stcode)) then
     begin
        for idx := Low(StationRange) to High(StationRange) do begin
           if (i >=StationRange[idx].startIdx) and (i<=StationRange[idx].endIdx) then
           begin
                 Result:=idx;
                 stationIndex:=i;
                 Exit;
           end;
        end;
     end;
  end;
  Result:=-1;

 end;
procedure TfrmTVCSMain.ReDrawRoute;   //Current panel만  update
begin

   SendMessage(pnroute.Handle, WM_SETREDRAW, WPARAM(False), 0);
   try
        // Create all your controls here
   finally
        // Make sure updates are re-enabled
        SendMessage(pnroute.Handle, WM_SETREDRAW, WPARAM(True), 0);
        Invalidate;  // Might be required to reflect the changes
   end;

end;

procedure TfrmTVCSMain.DrawRoute(ACanvas: TCanvas;ARect: TRect);
var
  D2DCanvas:TDirect2DCanvas;
  SplitHeight:Integer;
  Rect:TRect;
  FHdc:Thandle;
  FPicture:TGDIPPicture;
  StationStartX, StationSpacing,CenterLineY: Integer;
begin

   SplitHeight:=ARect.Height div 3;
   CenterLineY:=ARect.Height div 2;
   D2DCanvas := TDirect2DCanvas.Create(ACanvas, ARect);

   // 호선에 따라서 색 변경필요
   DrawTrainFill(D2DCanvas, Bounds(0, 0, ARect.Width, ARect.Height),'#6C9DDF');      //전체 색칠
   DrawTrainFill(D2DCanvas,Bounds(0,SplitHeight-30,ARect.Width,SplitHeight+50),'#F5F5F5');
   DrawTrainLine(D2DCanvas,0,SplitHeight+SplitHeight div 2, ARect.Width,3,'#154396');

   FPicture:=TGDIPPicture.Create;

   D2DCanvas.Font.Size := 13;
   D2DCanvas.Font.Color := clWhite;
   D2DCanvas.Brush.Style := bsClear;

   FPicture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_upbox);
   DrawImage(ACanvas,20,CenterLineY-FPicture.Height-5,ExtractFilePath(Application.ExeName)+icon_image_path+icon_upbox);
   DrawLabel(D2DCanvas,20,CenterLineY-FPicture.Height+2,'상행');
   FPicture.LoadFromFile(ExtractFilePath(Application.ExeName)+icon_image_path+icon_downbox);
   DrawImage(ACanvas,20,CenterLineY+5,ExtractFilePath(Application.ExeName)+icon_image_path+icon_downbox);
   DrawLabel(D2DCanvas,20,CenterLineY+15,'하행');
   DrawStations(ACanvas,Arect,tabRoute.TabIndex);
   FPicture.Free;

   D2DCanvas.Free;

end;


end.
