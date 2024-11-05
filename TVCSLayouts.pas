unit TVCSLayouts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.StdCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvGlowButton, Vcl.ExtCtrls, Vcl.ComCtrls,
  AdvPageControl, TVCSButtonStyle, tvcsProtocol, tvcsAPI, TVCSCheckDialog, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Buttons, AdvMetroButton, AdvTabSet, AdvEdit,
  AdvGroupBox, AdvOfficeButtons, AdvLabel, AdvPanel, advimage, Vcl.WinXPanels, Math;


type
  TfrmLayouts = class(TForm)
    pnMainFrame: TPanel;
    lblInfoTitle: TLabel;
    lblTitle: TLabel;
    lblSubLine: TLabel;
    pnCamStationInfo: TPanel;
    btnSearch: TAdvGlowButton;
    cmbStation: TComboBox;
    edSearchText: TEdit;
    grdTrains: TAdvStringGrid;
    pnBottom: TPanel;
    btnCancel: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    lbTrainCamInfo: TLabel;
    grdTrainCams: TAdvStringGrid;
    btnAddTab: TAdvGlowButton;
    btnDeleteTab: TAdvGlowButton;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    btnAddCam: TAdvMetroButton;
    btnRemoveCam: TAdvMetroButton;
    Panel1: TPanel;
    Panel2: TPanel;
    tabMerge: TAdvTabSet;
    edCamMerName: TAdvEdit;
    EdRtspIP: TAdvEdit;
    lbCamMergeName: TAdvLabel;
    lbRtspIp: TAdvLabel;
    lbCheckPartition: TAdvLabel;
    rbtnCheckPartition: TAdvOfficeRadioGroup;
    pnPartition: TAdvPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddCamClick(Sender: TObject);
    procedure btnAddTabClick(Sender: TObject);
    procedure btnDeleteTabClick(Sender: TObject);

    procedure rbtnCheckPartitionRadioButtonClick(Sender: TObject);
    procedure grdTrainCamsCanClickCell(Sender: TObject; ARow, ACol: Integer;
      var Allow: Boolean);
    procedure btnRemoveCamClick(Sender: TObject);
    procedure tabMergeChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
    { Private declarations }

    TabAddCnt : integer;
    selPartition : integer;
    trains : TArray<TVCSTrain>;
    trainCams : TArray<TVCSTrainCamera>;

    partitionPanels: array of TAdvPanel;
    currentTabIndex: Integer;
    isNewTab: Boolean;


    selTrain : TVCSTrain;
    selTrainCam : TVCSTrainCamera;
    selMerge : TVCSTrainCameraMerge;

    panelData : TArray<TVCSTrainCameraMergePatch>;
    addMerge : TArray<TVCSTrainCameraMergePost>;
    LoadMerge : TArray<TVCSTrainCameraMerge>;


    procedure LoadTrainList(trainNo: string='');
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure LoadTrainCamList(trainId: Integer =-1);
    procedure LoadMergeList(trainId: Integer =-1);
    procedure InitTabSet;
    procedure UpdatePanelsData(newPanelData: TArray<TVCSTrainCameraMergePatch>);
    procedure CreatePartitionPanels(panelCount : integer);
    function ConvertToMergePatch(mergeInfo: array of fmergeCamInfo): TArray<TVCSTrainCameraMergePatch>;
    function GetPanelIndex(posX, posY: Integer): Integer;
    procedure GetPanelPosition(index: Integer; var posX, posY: Integer);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SwapPanelData(sourceIndex, targetIndex: Integer);
    procedure MovePanelData(sourceIndex, targetIndex: Integer);


  public
    { Public declarations }
  end;

var
  frmLayouts: TfrmLayouts;

implementation

{$R *.dfm}

procedure TfrmLayouts.btnAddCamClick(Sender: TObject);
var
  i, emptyIndex, maxPanels: Integer;
  currentPanelCount: Integer;
  posX, posY: Integer;
  tempPanelData: TArray<TVCSTrainCameraMergePatch>;
begin
  if not (grdTrainCams.Row > 0) then
    Exit;


  if (TabAddCnt <= 0) and (tabMerge.AdvTabs.Count = 0) then
  begin
    ShowTVCSMessage('탭을 먼저 추가해주세요.');
    Exit;
  end;

  // 현재 사용중인 패널 수 계산
  currentPanelCount := 0;
  for i := 0 to Length(panelData) - 1 do
  begin
    if Assigned(panelData[i]) then
      Inc(currentPanelCount);
  end;

  // 분할 방식에 따른 최대 패널 수 설정
  case selPartition of
    4: maxPanels := 4;  // 4분할
    9: maxPanels := 8;  // 9분할 (가운데 패널 제외)
    else Exit;
  end;

  // 최대 패널 수 체크
  if currentPanelCount >= maxPanels then
  begin
    ShowMessage('더 이상 카메라를 추가할 수 없습니다.');
    Exit;
  end;

  // 기존 데이터 임시 저장
  SetLength(tempPanelData, Length(panelData));
  for i := 0 to Length(panelData) - 1 do
  begin
    if Assigned(panelData[i]) then
    begin
      tempPanelData[i] := TVCSTrainCameraMergePatch.Create;
      with tempPanelData[i] do
      begin
        fid := panelData[i].fid;
        ftrainId := panelData[i].ftrainId;
        fcameraId := panelData[i].fcameraId;
        fname := panelData[i].fname;
        fpositionX := panelData[i].fpositionX;
        fpositionY := panelData[i].fpositionY;
      end;
    end
    else
      tempPanelData[i] := nil;
  end;

  // 빈 패널 위치 찾기
  emptyIndex := -1;
  for i := 0 to selPartition - 1 do
  begin
    if not Assigned(tempPanelData[i]) then
    begin
      emptyIndex := i;
      Break;
    end;
  end;

  if emptyIndex = -1 then
  begin
    ShowMessage('더 이상 카메라를 추가할 수 없습니다.');
    Exit;
  end;

  // 새 패널 데이터 생성
  tempPanelData[emptyIndex] := TVCSTrainCameraMergePatch.Create;
  with tempPanelData[emptyIndex] do
  begin
    fid := 0;
    ftrainId := selTrain.fid;
    fcameraId := selTrainCam.fid;
    fname := selTrainCam.fname;

    GetPanelPosition(emptyIndex, posX, posY);
    fpositionX := posX;
    fpositionY := posY;
  end;

  // 패널 업데이트
  UpdatePanelsData(tempPanelData);

  // 임시 데이터 해제
  for i := 0 to Length(tempPanelData) - 1 do
    if Assigned(tempPanelData[i]) then
      tempPanelData[i].Free;
end;


procedure TfrmLayouts.btnAddTabClick(Sender: TObject);
begin
  TabAddCnt := TabAddCnt + 1;
  with tabMerge do
  begin

    AdvTabs.Add;
    AdvTabs[AdvTabs.Count-1].Caption := '새 다중영상 ' + IntToStr(AdvTabs.Count);
    TabIndex := AdvTabs.Count-1;  // 또는


    edCamMerName.Text := '';

    rbtnCheckPartition.ItemIndex := 0;
    selPartition := 9;



  end;
end;

procedure TfrmLayouts.InitTabSet;
begin
  tabMerge.SelectedColor:=clRed;
  tabMerge.UnSelectedColor:=clBlack;
  tabMerge.Font.Color:=clWhite;
  tabMerge.Font.size:=12;
  tabMerge.TextColor:=clWhite;
  tabMerge.ActiveFont.Color:=clWhite;
  tabMerge.ActiveFont.size:=12;
  tabMerge.TabBorderColor:= clNone;
  //tabMerge.Sele


end;


procedure TfrmLayouts.btnCancelClick(Sender: TObject);
begin
    ModalResult:=mrCancel;

end;

procedure TfrmLayouts.btnDlgCloseClick(Sender: TObject);
begin
     ModalResult:=mrAbort;
end;

procedure TfrmLayouts.btnRemoveCamClick(Sender: TObject);
begin
//


end;

procedure TfrmLayouts.btnSaveClick(Sender: TObject);
var
  i : integer;
begin


    for i := 0 to Length(addMerge) -1 do
    begin
      if addMerge[i] <> nil then
      begin
        gapi.AddTrainCameraMerge(addMerge[i]);

      end;

    end;
     ModalResult:=mrOk;
end;

procedure TfrmLayouts.btnDeleteTabClick(Sender: TObject);
var
  i : integer;

begin
  //
  //ShowMessage(IntToStr(Length(mergeCam))));
  for i := 0 to Length(LoadMerge) -1 do



end;

procedure TfrmLayouts.FormCreate(Sender: TObject);
begin
//
  TButtonStyler.ApplyGlobalStyle(Self);
  // 열차/카메라 리스트
  LoadTrainList;
  LoadTrainCamList;
  InitTabSet;

  // 머지영상 리스트
  //LoadMergeList;


  grdTrains.OnClickCell := grdTrainsClickCell;

end;

procedure TfrmLayouts.LoadTrainList(trainNo: string='');
var
  i, size : integer;

begin
  trains := gapi.GetTrain;
  with grdTrains do
  begin
    RowCount :=1;
    ColCount:=3;
    ColWidths[0]:=20;
    ColWidths[1]:=90;
    ColWidths[2]:=90;

    Cells[0,0]:='No.';
    Cells[1,0]:='편성번호';
    Cells[2,0]:='열차번호';
  end;

  size := Length(trains);
  for i := 0 to size -1 do
  with grdTrains do
  begin
    AddRow;
    Cells[0,i+1] := inttostr(i+1);
    Cells[1,i+1] := inttostr(trains[i].fformatNo);
    Cells[2,i+1] := trains[i].ftrainNo;

  end;
end;

procedure TfrmLayouts.rbtnCheckPartitionRadioButtonClick(Sender: TObject);
var
  i: Integer;
  oldPartition: Integer;
  tempPanelData: TArray<TVCSTrainCameraMergePatch>;
begin

  if ShowTVCSCheck(3) then
  begin
      oldPartition := selPartition;

  // 새로운 분할 방식 설정
  if rbtnCheckPartition.ItemIndex = 0 then
    selPartition := 9
  else
    selPartition := 4;

  // 기존 데이터 백업
  SetLength(tempPanelData, Length(panelData));
  for i := 0 to Length(panelData) - 1 do
  begin
    if Assigned(panelData[i]) then
    begin
      tempPanelData[i] := TVCSTrainCameraMergePatch.Create;
      with tempPanelData[i] do
      begin
        fid := panelData[i].fid;
        ftrainId := panelData[i].ftrainId;
        fcameraId := panelData[i].fcameraId;
        fname := panelData[i].fname;
        fpositionX := panelData[i].fpositionX;
        fpositionY := panelData[i].fpositionY;
      end;
    end
    else
      tempPanelData[i] := nil;
  end;

  // 데이터 재배치를 위한 새 배열
  var newData: TArray<TVCSTrainCameraMergePatch>;
  SetLength(newData, selPartition);
  for i := 0 to selPartition - 1 do
    newData[i] := nil;

  // 기존 데이터 새로운 위치에 배치
  for i := 0 to Min(4, Length(tempPanelData)) - 1 do  // 처음 4개만 처리
  begin
    if Assigned(tempPanelData[i]) then
    begin
      newData[i] := TVCSTrainCameraMergePatch.Create;
      with newData[i] do
      begin
        fid := tempPanelData[i].fid;
        ftrainId := tempPanelData[i].ftrainId;
        fcameraId := tempPanelData[i].fcameraId;
        fname := tempPanelData[i].fname;
      end;
      // 새 위치 계산
      GetPanelPosition(i, newData[i].fpositionX, newData[i].fpositionY);
    end;
  end;

  // 패널 업데이트
  UpdatePanelsData(newData);

  // 임시 데이터 해제
  for i := 0 to Length(tempPanelData) - 1 do
    if Assigned(tempPanelData[i]) then
      tempPanelData[i].Free;
  for i := 0 to Length(newData) - 1 do
    if Assigned(newData[i]) then
      newData[i].Free;

  end
  else
  begin
    // No를 선택한 경우 라디오 버튼을 이전 상태로 복원
    if selPartition = 9 then
      rbtnCheckPartition.ItemIndex := 0
    else
      rbtnCheckPartition.ItemIndex := 1;
  end;


end;

procedure TfrmLayouts.tabMergeChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  convertedData: TArray<TVCSTrainCameraMergePatch>;
begin
  if Assigned(LoadMerge) and (NewTab >= 0) and (NewTab < Length(LoadMerge)) then
  begin
    TabAddCnt := 0;  // 기존 탭 선택
    edCamMerName.Text := LoadMerge[NewTab].fname;
    EdRtspIP.Text := LoadMerge[NewTab].ftvcsRtsp;

    // 데이터 변환 및 업데이트
    convertedData := ConvertToMergePatch(LoadMerge[NewTab].fitem);
    try
      UpdatePanelsData(convertedData);
    finally
      // 변환된 데이터 해제
      for var i := 0 to Length(convertedData) - 1 do
        if Assigned(convertedData[i]) then
          convertedData[i].Free;
    end;
  end
  else
  begin
    edCamMerName.Text := '';
    EdRtspIP.Text := '';
    UpdatePanelsData(nil);
  end;

  AllowChange := True;
end;

function TfrmLayouts.ConvertToMergePatch(mergeInfo: array of fmergeCamInfo): TArray<TVCSTrainCameraMergePatch>;
var
  i: Integer;
begin
  SetLength(Result, Length(mergeInfo));
  for i := 0 to Length(mergeInfo) - 1 do
  begin
    Result[i] := TVCSTrainCameraMergePatch.Create;
    with Result[i] do
    begin
      fid := mergeInfo[i].fid;
      ftrainId := mergeInfo[i].ftrainId;
      fcameraId := mergeInfo[i].fcameraid;
      fname := mergeInfo[i].fname;
      fpositionX := mergeInfo[i].fpositionX;
      fpositionY := mergeInfo[i].fpositionY;
    end;
  end;
end;


procedure TfrmLayouts.LoadTrainCamList(trainId: Integer =-1);
var
  i, size : integer;

begin
//
  with grdTrainCams do
  begin
    RowCount := 1;
    ColCount := 3;

    ColWidths[0]:=20;
    ColWidths[1]:=80;
    ColWidths[2]:=80;

    Cells[0,0]:='No.';
    Cells[1,0]:='카메라명';
    Cells[2,0]:='미리보기';

  end;


  if trainId <> -1 then
  begin
    trainCams := gapi.GetTrainCamera(trainId);
    size := length(trainCams);

    if size > 0 then
      begin
        for i := 0 to size-1 do
         with grdTrainCams do
         begin
           AddRow;
           Cells[0,i+1] := IntToStr(i+1);
           Cells[1,i+1] := trainCams[i].fname;
           AddImageIdx(2, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
         end;
      end;
    end;
end;

procedure TfrmLayouts.LoadMergeList(trainId: Integer = -1);
var
  i: integer;
begin
  // 기존 panelData 해제
  for i := 0 to Length(panelData) - 1 do
  begin
    if Assigned(panelData[i]) then
    begin
      panelData[i].Free;
      panelData[i] := nil;
    end;
  end;
  SetLength(panelData, 0);

  if trainId <> -1 then
  begin
    LoadMerge := gapi.GetTrainCameraMerge(trainId);
    tabMerge.AdvTabs.Clear;
    edCamMerName.Text := '';
    EdRtspIP.Text := '';

    if Assigned(LoadMerge) then
    begin
      for i := 0 to Length(LoadMerge) - 1 do
      begin
        with tabMerge do
        begin
          AdvTabs.Add;
          AdvTabs[i].Caption := LoadMerge[i].fname;
        end;
      end;

      if Length(LoadMerge) > 0 then
      begin
        tabMerge.TabIndex := 0;
        // 첫 번째 탭의 데이터로 패널 초기화
        var convertedData := ConvertToMergePatch(LoadMerge[0].fitem);
        UpdatePanelsData(convertedData);
      end;
    end
    else
    begin
      // LoadMerge가 없을 때 새 탭 자동 추가
      TabAddCnt := TabAddCnt + 1;
      with tabMerge do
      begin
        AdvTabs.Add;
        AdvTabs[AdvTabs.Count-1].Caption := '새 다중영상 ' + IntToStr(AdvTabs.Count);
        TabIndex := AdvTabs.Count-1;
      end;

      // 기본값 설정
      edCamMerName.Text := '';
      selPartition := 9;
      rbtnCheckPartition.ItemIndex := 0;
      UpdatePanelsData(nil);
    end;
  end;
end;
//실시간으로 패널 데이터 업데이트 분할변경, 카메라추가/제거,  열차클릭, 탭변경시 호출
procedure TfrmLayouts.UpdatePanelsData(newPanelData: TArray<TVCSTrainCameraMergePatch>);
var
  i, idx, cameraCount: Integer;
begin
  // 기존 패널 데이터 해제
  for i := 0 to Length(panelData) - 1 do
  begin
    if Assigned(panelData[i]) then
      panelData[i].Free;
  end;

  // 패널 크기 설정
  if rbtnCheckPartition.ItemIndex = 0 then
    selPartition := 9
  else
    selPartition := 4;

  // 새 패널 데이터 배열 초기화
  SetLength(panelData, selPartition);
  for i := 0 to selPartition - 1 do
    panelData[i] := nil;

  // 새로운 데이터가 있을 경우만 데이터 복사
  if Assigned(newPanelData) then
  begin
    // 기존 데이터의 위치값에 따라 적절한 인덱스에 할당
    for i := 0 to Length(newPanelData) - 1 do
    begin
      if Assigned(newPanelData[i]) then
      begin
        idx := GetPanelIndex(newPanelData[i].fpositionX, newPanelData[i].fpositionY);
        if (idx >= 0) and (idx < selPartition) then
        begin
          panelData[idx] := TVCSTrainCameraMergePatch.Create;
          with panelData[idx] do
          begin
            fid := newPanelData[i].fid;
            ftrainId := newPanelData[i].ftrainId;
            fcameraId := newPanelData[i].fcameraId;
            fname := newPanelData[i].fname;
            fpositionX := newPanelData[i].fpositionX;
            fpositionY := newPanelData[i].fpositionY;
          end;
        end;
      end;
    end;
  end;

  // 패널 UI 생성 및 업데이트
  CreatePartitionPanels(selPartition);

  // 패널에 데이터 표시
  for i := 0 to Length(partitionPanels) - 1 do
  begin
    if Assigned(partitionPanels[i]) then
    begin
      if Assigned(panelData[i]) then
      begin
        partitionPanels[i].Text := '<FONT color="#FFFFFF">'+panelData[i].fname+'</FONT>';
        partitionPanels[i].Background.LoadFromFile('../../icon-img/merCamOn.jpg');
        partitionPanels[i].BackgroundPosition := bpStretched;
        partitionPanels[i].Caption.CloseButton := true;
        partitionPanels[i].Caption.CloseButtonColor := clWhite;
        partitionPanels[i].Caption.CloseColor := clbtnface;
      end
      else
      begin
        partitionPanels[i].Text := '<FONT color="#FFFFFF">빈 패널</FONT>';
        partitionPanels[i].Background.LoadFromFile('../../icon-img/merCamNone.jpg');
        partitionPanels[i].BackgroundPosition := bpStretched;
      end;
    end;
  end;
end;

function TfrmLayouts.GetPanelIndex(posX, posY: Integer): Integer;
begin
  Result := -1;
  case selPartition of
    4: begin  // 2x2 배치
      if (posX = 0) and (posY = 0) then Result := 0         // 좌상단
      else if (posX = 960) and (posY = 0) then Result := 1  // 우상단
      else if (posX = 0) and (posY = 540) then Result := 2  // 좌하단
      else if (posX = 960) and (posY = 540) then Result := 3;  // 우하단
    end;
    9: begin  // 3x3 배치
      if (posX = 0) and (posY = 0) then Result := 0         // 좌상단
      else if (posX = 640) and (posY = 0) then Result := 1  // 중상단
      else if (posX = 1280) and (posY = 0) then Result := 2 // 우상단
      else if (posX = 0) and (posY = 360) then Result := 3  // 좌중단
      else if (posX = 640) and (posY = 360) then Result := 4 // 중앙
      else if (posX = 1280) and (posY = 360) then Result := 5 // 우중단
      else if (posX = 0) and (posY = 720) then Result := 6  // 좌하단
      else if (posX = 640) and (posY = 720) then Result := 7 // 중하단
      else if (posX = 1280) and (posY = 720) then Result := 8; // 우하단
    end;
  end;
end;

// 패널 인덱스에 따른 위치값 반환
procedure TfrmLayouts.GetPanelPosition(index: Integer; var posX, posY: Integer);
begin
  case selPartition of
    4: begin  // 2x2 배치 (각 패널 960x540)
      case index of
        0: begin posX := 0; posY := 0; end;          // 좌상단
        1: begin posX := 960; posY := 0; end;        // 우상단
        2: begin posX := 0; posY := 540; end;        // 좌하단
        3: begin posX := 960; posY := 540; end;      // 우하단
      end;
    end;
    9: begin  // 3x3 배치 (각 패널 640x360)
      case index of
        0: begin posX := 0; posY := 0; end;          // 좌상단
        1: begin posX := 640; posY := 0; end;        // 중상단
        2: begin posX := 1280; posY := 0; end;       // 우상단
        3: begin posX := 0; posY := 360; end;        // 좌중단
        4: begin posX := 640; posY := 360; end;
        5: begin posX := 1280; posY := 360; end;     // 우중단
        6: begin posX := 0; posY := 720; end;        // 좌하단
        7: begin posX := 640; posY := 720; end;      // 중하단
        8: begin posX := 1280; posY := 720; end;     // 우하단
      end;
    end;
  end;
end;

procedure TfrmLayouts.CreatePartitionPanels(panelCount : integer);
var
  i : integer;
  newPanel: TAdvPanel;
  panelWidth, panelHeight: Integer;
begin
//
  for i := 0 to Length(partitionPanels) - 1 do
  begin
    if Assigned(partitionPanels[i]) then
      partitionPanels[i].Free;
  end;

  SetLength(partitionPanels, panelCount);

  // 패널 크기 계산
  if panelCount <= 4 then
  begin
    panelWidth := pnPartition.Width div 2;
    panelHeight := pnPartition.Height div 2;
  end
  else
  begin
    panelWidth := pnPartition.Width div 3;
    panelHeight := pnPartition.Height div 3;
  end;

  // 패널 생성
  for i := 0 to panelCount - 1 do
  begin
    newPanel := TAdvPanel.Create(pnPartition);
    newPanel.Parent := pnPartition;
    newPanel.HoverColor := clBlue;

    // 패널 위치 설정
    if panelCount <= 4 then
    begin
      newPanel.Left := (i mod 2) * panelWidth;
      newPanel.Top := (i div 2) * panelHeight;
    end
    else
    begin
      newPanel.Left := (i mod 3) * panelWidth;
      newPanel.Top := (i div 3) * panelHeight;
    end;

    newPanel.Width := panelWidth;
    newPanel.Height := panelHeight;
    newPanel.Text := '';
    newPanel.Background.LoadFromFile('../../icon-img/logo.jpg');
    newPanel.BackgroundPosition := bpStretched;
    newPanel.BorderWidth := 1;

    newPanel.BorderColor := clWhite;
    partitionPanels[i] := newPanel;

    newPanel.DragMode := dmManual;
    newPanel.OnMouseDown := PanelMouseDown;
    newPanel.OnDragOver := PanelDragOver;
    newPanel.OnDragDrop := PanelDragDrop;
  end;


end;




procedure TfrmLayouts.grdTrainCamsCanClickCell(Sender: TObject; ARow,
  ACol: Integer; var Allow: Boolean);
begin
//
  if ARow > 0 then
  begin
    selTrainCam := trainCams[ARow-1];
  end;

end;

procedure TfrmLayouts.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
begin
//
  if ARow > 0 then
  begin
    selTrain := trains[ARow -1];
    //ShowMessage(IntToStr(selTrain.fid));
    LoadTrainCamList(selTrain.fid);
    LoadMergeList(selTrain.fid);
  end;
end;

// 패널 드래그 관련
procedure TfrmLayouts.PanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    (Sender as TAdvPanel).BeginDrag(true);
end;

procedure TfrmLayouts.PanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TAdvPanel) and (Sender is TAdvPanel);
end;

procedure TfrmLayouts.PanelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  sourcePanel, targetPanel: TAdvPanel;
  sourceIdx, targetIdx: Integer;
  i: Integer;
begin
  sourcePanel := Source as TAdvPanel;
  targetPanel := Sender as TAdvPanel;

  // 패널의 인덱스 찾기
  sourceIdx := -1;
  targetIdx := -1;
  for i := 0 to Length(partitionPanels) - 1 do
  begin
    if partitionPanels[i] = sourcePanel then
      sourceIdx := i;
    if partitionPanels[i] = targetPanel then
      targetIdx := i;
  end;

  if (sourceIdx >= 0) and (targetIdx >= 0) then
  begin
    // 이동 정보 표시
    {
    if Assigned(panelData[targetIdx]) and Assigned(panelData[sourceIdx]) then
      ShowMessage(Format('패널 교환: %d번 패널 <-> %d번 패널', [sourceIdx + 1, targetIdx + 1]))
    else if Assigned(panelData[sourceIdx]) then
      ShowMessage(Format('패널 이동: %d번 패널 -> %d번 패널', [sourceIdx + 1, targetIdx + 1]))
    else if Assigned(panelData[targetIdx]) then
      ShowMessage(Format('패널 이동: %d번 패널 -> %d번 패널', [targetIdx + 1, sourceIdx + 1]));
    }
    // 데이터 교환/이동 전 위치 정보 저장
    var sourceX, sourceY, targetX, targetY: Integer;
    if Assigned(panelData[sourceIdx]) then
    begin
      sourceX := panelData[sourceIdx].fpositionX;
      sourceY := panelData[sourceIdx].fpositionY;
    end;
    if Assigned(panelData[targetIdx]) then
    begin
      targetX := panelData[targetIdx].fpositionX;
      targetY := panelData[targetIdx].fpositionY;
    end;

    // 데이터 교환/이동
    if Assigned(panelData[sourceIdx]) and Assigned(panelData[targetIdx]) then
    begin
      var temp := panelData[sourceIdx];
      panelData[sourceIdx] := panelData[targetIdx];
      panelData[targetIdx] := temp;

      // 위치 정보 교환
      if Assigned(panelData[sourceIdx]) then
      begin
        panelData[sourceIdx].fpositionX := sourceX;
        panelData[sourceIdx].fpositionY := sourceY;
      end;
      if Assigned(panelData[targetIdx]) then
      begin
        panelData[targetIdx].fpositionX := targetX;
        panelData[targetIdx].fpositionY := targetY;
      end;
    end
    else if Assigned(panelData[sourceIdx]) then
    begin
      panelData[targetIdx] := panelData[sourceIdx];
      panelData[sourceIdx] := nil;

      // 새 위치 정보 설정
      GetPanelPosition(targetIdx, panelData[targetIdx].fpositionX, panelData[targetIdx].fpositionY);
    end
    else if Assigned(panelData[targetIdx]) then
    begin
      panelData[sourceIdx] := panelData[targetIdx];
      panelData[targetIdx] := nil;

      // 새 위치 정보 설정
      GetPanelPosition(sourceIdx, panelData[sourceIdx].fpositionX, panelData[sourceIdx].fpositionY);
    end;

    // UI 업데이트 (패널 데이터 복사 없이 직접 업데이트)
    CreatePartitionPanels(selPartition);
    for i := 0 to Length(partitionPanels) - 1 do
    begin
      if Assigned(partitionPanels[i]) then
      begin
        if Assigned(panelData[i]) then
        begin
          partitionPanels[i].Text := '<FONT color="#FFFFFF">' + panelData[i].fname + '</FONT>';
          partitionPanels[i].Background.LoadFromFile('../../icon-img/merCamOn.jpg');
          partitionPanels[i].BackgroundPosition := bpStretched;
          partitionPanels[i].Caption.CloseButton := true;
          partitionPanels[i].Caption.CloseButtonColor := clWhite;
          partitionPanels[i].Caption.CloseColor := clbtnface;


        end
        else
        begin
          partitionPanels[i].Text := '<FONT color="#FFFFFF">빈 패널</FONT>';
          partitionPanels[i].Background.LoadFromFile('../../icon-img/merCamNone.jpg');
          partitionPanels[i].BackgroundPosition := bpStretched;
        end;
      end;
    end;
  end;
end;

procedure TfrmLayouts.SwapPanelData(sourceIndex, targetIndex: Integer);
var
  tempData: TVCSTrainCameraMergePatch;
begin
  tempData := panelData[sourceIndex];
  panelData[sourceIndex] := panelData[targetIndex];
  panelData[targetIndex] := tempData;

  // 위치 정보 업데이트
  if Assigned(panelData[sourceIndex]) then
    GetPanelPosition(sourceIndex, panelData[sourceIndex].fpositionX, panelData[sourceIndex].fpositionY);
  if Assigned(panelData[targetIndex]) then
    GetPanelPosition(targetIndex, panelData[targetIndex].fpositionX, panelData[targetIndex].fpositionY);
end;

// 패널 데이터 이동
procedure TfrmLayouts.MovePanelData(sourceIndex, targetIndex: Integer);
begin
  panelData[targetIndex] := panelData[sourceIndex];
  panelData[sourceIndex] := nil;

  // 새 위치 정보 업데이트
  if Assigned(panelData[targetIndex]) then
    GetPanelPosition(targetIndex, panelData[targetIndex].fpositionX, panelData[targetIndex].fpositionY);
end;

end.
