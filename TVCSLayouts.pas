unit TVCSLayouts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.StdCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvGlowButton, Vcl.ExtCtrls, Vcl.ComCtrls,
  AdvPageControl, TVCSButtonStyle, tvcsProtocol, tvcsAPI, TVCSCheckDialog, TVCSPreview, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Buttons, AdvMetroButton, AdvTabSet, AdvEdit,
  AdvGroupBox, AdvOfficeButtons, AdvLabel, AdvPanel, advimage, Vcl.WinXPanels, Math;


type
  pnData = record
    fcameraId: integer;
    fpositionX: integer;
    fpositionY: integer;
  end;




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
    Label1: TLabel;
    ComboBox1: TComboBox;
    AdvMetroButton1: TAdvMetroButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddCamClick(Sender: TObject);
    procedure btnAddTabClick(Sender: TObject);
    procedure btnDeleteTabClick(Sender: TObject);

    procedure rbtnCheckPartitionRadioButtonClick(Sender: TObject);
    procedure grdTrainCamsCanClickCell(Sender: TObject; ARow, ACol: Integer;
      var Allow: Boolean);
    procedure btnRemoveCamClick(Sender: TObject);
    procedure tabMergeChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure pnPartitionClose(Sender: TObject);
    procedure AdvMetroButton1Click(Sender: TObject);
  private
    { Private declarations }

    TabAddCnt : integer;
    selPartition : integer;
    trains : TArray<TVCSTrain>;
    trainCams : TArray<TVCSTrainCamera>;
    CamOnImg : TAdvImage;
    CamOffImg : TAdvImage;

    partitionPanels: array of TAdvPanel;
    currentTabIndex: Integer;
    isNewTab: Boolean;


    selTrain : TVCSTrain;
    selTrainCam : TVCSTrainCamera;
    selMerge : TVCSTrainCameraMerge;

    panelData : TArray<pnData>;
    addMerge : TArray<TVCSTrainCameraMergePost>;
    LoadMerge : TArray<TVCSTrainCameraMerge>;


    procedure LoadTrainList(trainNo: string='');
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure LoadTrainCamList(trainId: Integer =-1);
    procedure LoadMergeList(trainId: Integer =-1);
    procedure InitTabSet;
    procedure CreatePartitionPanels(selPartition: integer; useSelMerge: Boolean = True);
    function GetPanelPosition(panelIndex: Integer): pnData;
    function CamIdToCamName(cameraId: integer):String;
    function CreatePanelTag(panelNo, divType, posX, posY: Integer; cameraId: Integer = -1): Integer;
    procedure InitializeMergeTab(isNewTab: Boolean = True);
    
    procedure pnVideoDragDrop(Sender, Source: TObject; X, Y: Integer);

    procedure pnVideoDragOver(Sender, Source: TObject; X, Y: Integer;
     State: TDragState; var Accept: Boolean);
    Procedure pnVideoMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure pnPartitionMouseLeave(Sender: TObject);
    procedure pnPartitionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);

  public
    { Public declarations }
  end;

var
  frmLayouts: TfrmLayouts;

implementation

{$R *.dfm}

procedure TfrmLayouts.AdvMetroButton1Click(Sender: TObject);
var
  ShowPreview : TFrmPreview;

begin
  ShowPreview := TfrmPreview.Create(self);
  ShowPreview.SetRtspUrl(LoadMerge[tabMerge.TabIndex].ftvcsRtsp);
  //ShowPreview.SetRtspID(LoadMerge[tabMerge.].ftvcsRtsp);
  //ShowPreview.SetRtspPw(trainCams[ARow-1 -addTrCnt].fuserPwd);
  ShowPreview.StartPreview;
  ShowPreview.ShowModal;

end;

procedure TfrmLayouts.btnAddCamClick(Sender: TObject);
var
  i, emptyPanelNo: Integer;
  maxPanels, row, col, currentPanelCount: Integer;
  hasEmptyPanel: Boolean;
begin
  // 선택된 카메라가 없는 경우
  if grdTrainCams.Row = 0 then
  begin
    ShowTVCSMessage('카메라를 선택해주세요.');
    Exit;
  end;

  // 탭이 없는 경우
  if (TabAddCnt <= 0) and (tabMerge.AdvTabs.Count = 0) then
  begin
    ShowTVCSMessage('탭을 먼저 추가해주세요.');
    Exit;
  end;

  // 분할 방식에 따른 최대 패널 수 설정
  maxPanels := 4;
  if selPartition = 9 then
    maxPanels := 8;  // 9분할은 8개까지만 (한 패널은 빈 상태 유지)

  // 빈 패널 찾기
  hasEmptyPanel := False;
  emptyPanelNo := -1;
  currentPanelCount := 0;

  for i := 0 to Length(partitionPanels) - 1 do
  begin
    // 현재 카메라가 있는 패널 수 카운트
    if ((partitionPanels[i].Tag mod 100000) div 10000) = 1 then
      Inc(currentPanelCount);
  end;

  // maxPanels 체크
  if currentPanelCount >= maxPanels then
  begin
    ShowTVCSMessage('더 이상 카메라를 추가할 수 없습니다.');
    Exit;
  end;

  // 빈 패널 찾기 (카메라가 있는 패널 수가 maxPanels 미만일 때만)
  for i := 0 to Length(partitionPanels) - 1 do
  begin
    if ((partitionPanels[i].Tag mod 100000) div 10000) = 0 then
    begin
      hasEmptyPanel := True;
      emptyPanelNo := i + 1;
      Break;
    end;
  end;

  // x, y 좌표 계산
  if selPartition = 4 then
  begin
    col := (emptyPanelNo - 1) mod 2;
    row := (emptyPanelNo - 1) div 2;
  end
  else
  begin
    col := (emptyPanelNo - 1) mod 3;
    row := (emptyPanelNo - 1) div 3;
  end;

  // 패널에 카메라 정보 설정
  partitionPanels[emptyPanelNo-1].Tag := CreatePanelTag(emptyPanelNo, selPartition, 
    col, row, selTrainCam.fid);
    
  // UI 업데이트
  partitionPanels[emptyPanelNo-1].Text := '<FONT color="#FFFFFF">' + 
    CamIdToCamName(selTrainCam.fid) + ' tag: ' + 
    IntToStr(partitionPanels[emptyPanelNo-1].Tag) + '</FONT>';
  partitionPanels[emptyPanelNo-1].Background.LoadFromFile('../../icon-img/merCamOn.jpg');

  partitionPanels[emptyPanelNo-1].OnMouseMove := pnPartitionMouseMove;
  partitionPanels[emptyPanelNo-1].OnMouseLeave := pnPartitionMouseLeave;
  
end;


procedure TfrmLayouts.btnAddTabClick(Sender: TObject);
begin
  
  // 탭이 없는 경우
  if (TabAddCnt <= 0) and (tabMerge.AdvTabs.Count = 0) then
  begin
    ShowTVCSMessage('탭을 먼저 추가해주세요.');
    Exit;
  end;

  TabAddCnt := TabAddCnt + 1;
  InitializeMergeTab;
  CreatePartitionPanels(selMerge.fdivNum);
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
  i, j, tag, cameraId, posX, posY: Integer;
  trainCameraMergePost: TVCSTrainCameraMergePost;
  mergePostInfo: fmergePostInfo;
begin
  if ShowTVCSCheck(1) then
  begin
      trainCameraMergePost := TVCSTrainCameraMergePost.Create;
    try
      trainCameraMergePost.ftrainId := selTrain.fid;
      trainCameraMergePost.fname := edCamMerName.Text;
      trainCameraMergePost.fdivNum := selPartition;

      if rbtnCheckPartition.ItemIndex = 0 then
      begin
        trainCameraMergePost.fwidth := 1920;
        trainCameraMergePost.fheight := 1080;
      end
      else
      begin
        trainCameraMergePost.fwidth := 1280;
        trainCameraMergePost.fheight := 720;
      end;

      SetLength(trainCameraMergePost.fitem, 0);

      for i := 0 to Length(partitionPanels) - 1 do
      begin
        tag := partitionPanels[i].Tag;
        cameraId := tag mod 10000;

        if cameraId > 0 then
        begin
          posX := (tag mod 10000000) div 1000000;
          posY := (tag mod 1000000) div 100000;

          mergePostInfo := fmergePostInfo.Create;
          mergePostInfo.fcameraId := cameraId;
          mergePostInfo.fPositionX := posX;
          mergePostInfo.fPositionY := posY;

          j := Length(trainCameraMergePost.fitem);
          SetLength(trainCameraMergePost.fitem, j + 1);
          trainCameraMergePost.fitem[j] := mergePostInfo;
        end;
      end;

    
      // TODO: trainCameraMergePost 객체를 서버로 전송하는 코드 추가
      gapi.DeleteTrainCameraMerge(tabMerge.AdvTabs.Items[tabMerge.TabIndex].Caption);
      gapi.AddTrainCameraMerge(trainCameraMergePost);
      ShowMessage(tabMerge.AdvTabs.Items[tabMerge.TabIndex].Caption);
    finally
      trainCameraMergePost.Free;
    end;
  end;
  
  
end;

procedure TfrmLayouts.btnDeleteTabClick(Sender: TObject);
var
  i : integer;
begin
//if  
  if ShowTVCSCheck(1) then
    begin
      gapi.DeleteTrainCameraMerge(tabMerge.AdvTabs.Items[tabMerge.TabIndex].Caption);
      LoadMergeList(selTrain.fid);
    end;
end;

procedure TfrmLayouts.FormCreate(Sender: TObject);
begin
//
  TButtonStyler.ApplyGlobalStyle(Self);
  // 열차/카메라 리스트
  LoadTrainList;
  LoadTrainCamList;
  InitTabSet;
  CamOnImg := TAdvImage.Create;
  CamOnImg.LoadFromFile('../../icon-img/merCamOn.jpg');
  CamOffImg := TAdvImage.Create;
  CamOffImg.LoadFromFile('../../icon-img/merCamOff.jpg');

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
  hasMoreThan4Cameras: Boolean;
  cameraCnt: Integer;
  saveData: array of record
    panelNo: Integer;
    cameraId: Integer;
  end;
begin
  oldPartition := selPartition;

  // 9분할 -> 4분할 변경 시
  if (oldPartition = 9) and (rbtnCheckPartition.ItemIndex = 1) then
  begin
    // 현재 패널 정보 저장
    SetLength(saveData, 9);
    cameraCnt := 0;
    for i := 0 to Length(partitionPanels) - 1 do
    begin
      if ((partitionPanels[i].Tag mod 100000) div 10000) = 1 then
      begin
        saveData[cameraCnt].panelNo := partitionPanels[i].Tag div 100000000;
        saveData[cameraCnt].cameraId := partitionPanels[i].Tag mod 10000;
        Inc(cameraCnt);
      end;
    end;

    hasMoreThan4Cameras := cameraCnt > 4;
    if hasMoreThan4Cameras and not ShowTVCSCheck(3) then
    begin
      rbtnCheckPartition.ItemIndex := 0;
      Exit;
    end;

    // 분할 변경 및 새 패널 생성 (selMerge 사용 안함)
    selPartition := 4;
    rbtnCheckPartition.ItemIndex := 1;
    CreatePartitionPanels(4, False); // False로 selMerge 사용하지 않음

    // 저장했던 데이터로 패널 업데이트
    for i := 0 to cameraCnt - 1 do
    begin
      if saveData[i].panelNo <= 4 then
      begin
        var row := (saveData[i].panelNo - 1) div 2;
        var col := (saveData[i].panelNo - 1) mod 2;
        partitionPanels[saveData[i].panelNo-1].Tag := 
          CreatePanelTag(saveData[i].panelNo, 4, col, row, saveData[i].cameraId);

        partitionPanels[saveData[i].panelNo-1].Text := 
          '<FONT color="#FFFFFF">' + CamIdToCamName(saveData[i].cameraId) + 
          ' tag: ' + IntToStr(partitionPanels[saveData[i].panelNo-1].Tag) + '</FONT>';
        partitionPanels[saveData[i].panelNo-1].Background.LoadFromFile('../../icon-img/merCamOn.jpg');
        partitionPanels[saveData[i].panelNo-1].OnMouseMove := pnPartitionMouseMove;
        partitionPanels[saveData[i].panelNo-1].OnMouseLeave := pnPartitionMouseLeave;
      end;
    end;
  end
  // 4분할 -> 9분할 변경
  else if (oldPartition = 4) and (rbtnCheckPartition.ItemIndex = 0) then
  begin
    // 현재 패널 정보 저장
    SetLength(saveData, 4);
    cameraCnt := 0;
    for i := 0 to Length(partitionPanels) - 1 do
    begin
      if ((partitionPanels[i].Tag mod 100000) div 10000) = 1 then
      begin
        saveData[cameraCnt].panelNo := partitionPanels[i].Tag div 100000000;
        saveData[cameraCnt].cameraId := partitionPanels[i].Tag mod 10000;
        Inc(cameraCnt);
      end;
    end;

    // 분할 변경 및 새 패널 생성 (selMerge 사용 안함)
    selPartition := 9;
    rbtnCheckPartition.ItemIndex := 0;
    CreatePartitionPanels(9, False); // False로 selMerge 사용하지 않음

    // 저장했던 데이터로 패널 업데이트
    for i := 0 to cameraCnt - 1 do
    begin
      var row := (saveData[i].panelNo - 1) div 3;
      var col := (saveData[i].panelNo - 1) mod 3;
      partitionPanels[saveData[i].panelNo-1].Tag := 
        CreatePanelTag(saveData[i].panelNo, 9, col, row, saveData[i].cameraId);

      partitionPanels[saveData[i].panelNo-1].Text := 
        '<FONT color="#FFFFFF">' + CamIdToCamName(saveData[i].cameraId) + 
        ' tag: ' + IntToStr(partitionPanels[saveData[i].panelNo-1].Tag) + '</FONT>';
      partitionPanels[saveData[i].panelNo-1].Background.LoadFromFile('../../icon-img/merCamOn.jpg');
      partitionPanels[saveData[i].panelNo-1].OnMouseMove := pnPartitionMouseMove;
      partitionPanels[saveData[i].panelNo-1].OnMouseLeave := pnPartitionMouseLeave;
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

    ColWidths[0]:=30;
    ColWidths[1]:=100;
    ColWidths[2]:=60;

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


// 열차번호로 머지영상 조회
// LoadMergeList 수정
procedure TfrmLayouts.LoadMergeList(trainId: Integer = -1);
var
  i: Integer;
begin
  if trainId <> -1 then
  begin
    LoadMerge := gapi.GetTrainCameraMerge(trainId);
    tabMerge.AdvTabs.Clear;
    edCamMerName.Text := '';
    EdRtspIP.Text := '';

    
    if Assigned(LoadMerge) and (Length(LoadMerge) > 0) then
    begin
      // 기존 머지 데이터 로드
      selMerge := LoadMerge[0];
      selPartition := selMerge.fdivNum;
      if selPartition = 4 then
        rbtnCheckPartition.ItemIndex := 1
      else
        rbtnCheckPartition.ItemIndex := 0;

      // panelData 초기화 및 크기 설정
      SetLength(panelData, selMerge.fdivNum);

      for i := 0 to Length(LoadMerge) - 1 do
      begin
        with tabMerge do
        begin
          AdvTabs.Add;
          AdvTabs[i].Caption := LoadMerge[i].fname;
        end;
      end;

      tabMerge.TabIndex := 0;

      // LoadMerge의 fitem 데이터를 panelData로 변환
      //panelData := ConvertToMergePatch(LoadMerge[0].fitem);

      CreatePartitionPanels(selMerge.fdivNum);
      //UpdatePanelsData(panelData);
    end
    else
    begin
      InitializeMergeTab;
      CreatePartitionPanels(selMerge.fdivNum);

    end;
  end;
end;

function TfrmLayouts.GetPanelPosition(panelIndex: Integer): pnData;
begin
  Result.fcameraId := -1;
  // 3x3 그리드에서의 x, y 좌표 계산
  Result.fpositionX := panelIndex mod 3;  // 0,1,2 순환
  Result.fpositionY := panelIndex div 3;  // 각 행마다 증가
end;

procedure TfrmLayouts.InitializeMergeTab(isNewTab: Boolean = True);
var
  i: Integer;
  newPanelData: TArray<pnData>;
begin
  // 새 탭 초기화
  edCamMerName.Text := '';
  rbtnCheckPartition.ItemIndex := 0;

  // 기본 Merge 설정
  selMerge := TVCSTrainCameraMerge.Create;
  selMerge.fname := '';
  selMerge.ftvcsRtsp := '';
  selMerge.fwidth := 1920;
  selMerge.fheight := 1080;
  selMerge.fdivNum := 9;
  selPartition := 9;

  // 새 패널 데이터 초기화
  SetLength(newPanelData, 9);
  for i := 0 to Length(newPanelData) - 1 do
  begin
    newPanelData[i] := GetPanelPosition(i);
  end;
  //UpdatePanelsData(newPanelData);

  if isNewTab then
  begin
    TabAddCnt := TabAddCnt + 1;
    with tabMerge do
    begin
      AdvTabs.Add;
      AdvTabs[AdvTabs.Count-1].Caption := '새 다중영상 ' + IntToStr(AdvTabs.Count);
      TabIndex := AdvTabs.Count-1;
    end;
  end;
end;

// tabMergeChange 수정
procedure TfrmLayouts.tabMergeChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
var
  convertedData: TArray<fmergePostInfo>;
begin
  if Assigned(LoadMerge) and (NewTab >= 0) and (NewTab < Length(LoadMerge)) then
  begin
    TabAddCnt := 0;  // 기존 탭 선택
    edCamMerName.Text := LoadMerge[NewTab].fname;
    EdRtspIP.Text := LoadMerge[NewTab].ftvcsRtsp;
    selMerge := LoadMerge[NewTab];
    CreatePartitionPanels(selMerge.fdivNum);

    // 기존 데이터로 패널 업데이트
    //UpdatePanelsData(ConvertToMergePatch(LoadMerge[NewTab].fitem));
  end
  else
  begin
    // 새 탭 초기화
    InitializeMergeTab(False);
  end;

  AllowChange := True;
end;


function TfrmLayouts.CamIdToCamName(cameraId: integer): String;
var
  i: Integer;
begin
  Result := '';  // 기본값 설정

  if not Assigned(trainCams) then
    Exit;

  // trainCams 배열을 순회하면서 일치하는 ID 검색
  for i := 0 to Length(trainCams) - 1 do
  begin
    if trainCams[i].fid = cameraId then
    begin
      Result := trainCams[i].fname;
      Break;  // 찾았으면 반복문 종료
    end;
  end;
end;



procedure TfrmLayouts.CreatePartitionPanels(selPartition: integer; useSelMerge: Boolean = True);

const
 MARGIN = 1;
 OUTER_MARGIN = 2;
var
 i, row, col, panelNo: integer;
 newPanel: TAdvPanel;
 panelWidth, panelHeight: Integer;
 totalWidth, totalHeight: Integer;
 tag: Integer;
 cameraId: Integer;
begin
 // 기존 패널 해제
 for i := 0 to Length(partitionPanels) - 1 do
 begin
   if Assigned(partitionPanels[i]) then
   begin
     partitionPanels[i].Free;
     partitionPanels[i] := nil;
   end;
 end;
 if selPartition = 9 then
  rbtnCheckPartition.ItemIndex := 0
 else
  rbtnCheckPartition.ItemIndex := 1;
  
 SetLength(partitionPanels, selPartition);
 totalWidth := pnPartition.Width - (2 * OUTER_MARGIN);
 totalHeight := pnPartition.Height - (2 * OUTER_MARGIN);

 // 패널 크기 계산
 if selPartition = 4 then
 begin
   panelWidth := (totalWidth - MARGIN) div 2;
   panelHeight := (totalHeight - MARGIN) div 2;
 end
 else
 begin
   panelWidth := (totalWidth - (2 * MARGIN)) div 3;
   panelHeight := (totalHeight - (2 * MARGIN)) div 3;
 end;

 // 패널 생성
 for i := 0 to selPartition - 1 do
 begin
   newPanel := TAdvPanel.Create(pnPartition);
   newPanel.Parent := pnPartition;
   newPanel.HoverColor := clBlue;

   panelNo := i + 1;

   // x, y 좌표 계산
   if selPartition = 4 then
   begin
     col := (panelNo - 1) mod 2;
     row := (panelNo - 1) div 2;
   end
   else
   begin
     col := (panelNo - 1) mod 3;
     row := (panelNo - 1) div 3;
   end;

   // 카메라 ID 찾기
   cameraId := -1;
    if useSelMerge and Assigned(selMerge) and Assigned(selMerge.fitem) then
    begin
      for var j := 0 to Length(selMerge.fitem) - 1 do
      begin
        if (selMerge.fitem[j].fpositionX = col) and
           (selMerge.fitem[j].fpositionY = row) then
        begin
          cameraId := selMerge.fitem[j].fcameraId;
          Break;
        end;
      end;
    end;


   newPanel.Tag := CreatePanelTag(panelNo, selPartition, col, row, cameraId);
   newPanel.Text := '<FONT color="#FFFFFF">' + IntToStr(tag) + '</FONT>';  // tag 값 확인용

   // 패널 위치 설정
   newPanel.Left := OUTER_MARGIN + col * (panelWidth + MARGIN);
   newPanel.Top := OUTER_MARGIN + row * (panelHeight + MARGIN);
   newPanel.Width := panelWidth;
   newPanel.Height := panelHeight;
                                                                                        
   // 패널 텍스트 및 배경 설정
   if cameraId > 0 then
   begin
     newPanel.Text := '<FONT color="#FFFFFF">' + CamIdToCamName(cameraId) +' tag: ' + IntToStr(newPanel.tag)+ '</FONT>';
     newPanel.Background := CamOnImg;
     newPanel.OnMouseMove := pnPartitionMouseMove;
     newPanel.OnMouseLeave := pnPartitionMouseLeave;
   end
   else
   begin
     newPanel.Text := '<FONT color="#FFFFFF">카메라 없음'+' tag: ' + IntToStr(newPanel.tag)+ '</FONT>';
     newPanel.Background := CamOffImg;
   end;

   // 기타 패널 속성 설정
   newPanel.BackgroundPosition := bpStretched;
   newPanel.BorderWidth := 1;
   newPanel.BorderColor := clWhite;
   newPanel.DragMode := dmManual;
   //newPanel.Caption.CloseButton := true;
   newPanel.Caption.Visible := true;
   newPanel.Caption.Height := 20;
   newPanel.Caption.CloseButtonHoverColor := clBlue;
   newPanel.Caption.CloseButtonColor := clWhite;
   newPanel.Caption.CloseColor := clbtnface;
   newPanel.Caption.Color := $1C1512;
   //newPanel.CanMove := true;
   newPanel.OnMouseDown := pnVideoMouseDown;
   newPanel.OnDragOver := pnVideoDragOver;
   newPanel.OnDragDrop := pnVideoDragDrop;
   newPanel.OnClose := pnPartitionClose;

   partitionPanels[i] := newPanel;
 end;
end;


procedure TfrmLayouts.grdTrainCamsCanClickCell(Sender: TObject; ARow,
  ACol: Integer; var Allow: Boolean);
var
ShowPreview : TfrmPreview;

begin
//
  if ARow > 0 then
  begin
    selTrainCam := trainCams[ARow-1];
    if ACol = 2 then
      begin
        ShowPreview := TfrmPreview.Create(self);
        ShowPreview.SetRtspUrl(selTrainCam.frtsp);
        ShowPreview.SetRtspID(selTrainCam.fuserId);
        ShowPreview.SetRtspPw(selTrainCam.fuserPwd);
        ShowPreview.StartPreview;
        ShowPreview.ShowModal;
      end;
    
  end;

end;

function TfrmLayouts.CreatePanelTag(panelNo, divType, posX, posY: Integer; cameraId: Integer = -1): Integer;
begin
 if cameraId > 0 then
   Result := panelNo * 100000000 + divType * 10000000 + posX * 1000000 +
     posY * 100000 + 10000 + (cameraId mod 10000)
 else
   Result := panelNo * 100000000 + divType * 10000000 + posX * 1000000 +
     posY * 100000;
end;

procedure TfrmLayouts.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  i : integer;
begin
  if ARow <= 0 then Exit;

  // 기존 데이터 정리

  selTrain := trains[ARow -1];

  // 카메라 목록 로드 (항상 필요)
  LoadTrainCamList(selTrain.fid);
  LoadMergeList(selTrain.fid);
  edCamMerName.Enabled := true;
  Combobox1.Enabled := true;
  rbtnCheckPartition.Enabled := true;


  
  // 기존 panelData 초기화
  {
  SetLength(panelData, 0);
  if Assigned(LoadMerge) then
  begin
    for i := 0 to Length(LoadMerge) - 1 do
      LoadMerge[i].Free;
    SetLength(LoadMerge, 0);
  end;
  }
  // 새로운 머지 데이터 로드

end;

procedure TfrmLayouts.pnVideoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
 sourcePanel, targetPanel: TAdvPanel;
 sourceTag, targetTag: Integer;
 sourcePanelNo, targetPanelNo: Integer;
 sourceDivType, targetDivType: Integer;
 sourceX, sourceY, targetX, targetY: Integer;
 sourceHasCamera, targetHasCamera: Boolean;
 sourceCamId, targetCamId: Integer;
begin
 sourcePanel := Source as TAdvPanel;
 targetPanel := Sender as TAdvPanel;

 sourceTag := sourcePanel.Tag;
 targetTag := targetPanel.Tag;

 // 기존 tag에서 정보 추출
 sourcePanelNo := sourceTag div 100000000;
 sourceDivType := (sourceTag mod 100000000) div 10000000;
 sourceX := (sourceTag mod 10000000) div 1000000;
 sourceY := (sourceTag mod 1000000) div 100000;
 sourceHasCamera := ((sourceTag mod 100000) div 10000) = 1;
 if sourceHasCamera then sourceCamId := sourceTag mod 10000
 else sourceCamId := -1;

 targetPanelNo := targetTag div 100000000;
 targetDivType := (targetTag mod 100000000) div 10000000;
 targetX := (targetTag mod 10000000) div 1000000;
 targetY := (targetTag mod 1000000) div 100000;
 targetHasCamera := ((targetTag mod 100000) div 10000) = 1;
 if targetHasCamera then targetCamId := targetTag mod 10000
 else targetCamId := -1;

 // 새 tag 생성 및 설정
 sourcePanel.Tag := CreatePanelTag(sourcePanelNo, sourceDivType, sourceX, sourceY, targetCamId);
 targetPanel.Tag := CreatePanelTag(targetPanelNo, targetDivType, targetX, targetY, sourceCamId);

 // UI 업데이트
 if sourceHasCamera then
 begin
   targetPanel.Text := '<FONT color="#FFFFFF">' + CamIdToCamName(sourceCamId) +' tag: ' + IntToStr(targetPanel.tag)+ '</FONT>';
   targetPanel.Background.LoadFromFile('../../icon-img/merCamOn.jpg');
   targetPanel.OnMouseMove := pnPartitionMouseMove;
   targetPanel.OnMouseLeave := pnPartitionMouseLeave;
 end
 else
 begin
   targetPanel.Text := '<FONT color="#FFFFFF">카메라 없음'+' tag: ' + IntToStr(targetPanel.tag)+'</FONT>';
   targetPanel.Background.LoadFromFile('../../icon-img/merCamOff.jpg');
   targetPanel.OnMouseMove := nil;
   targetPanel.OnMouseLeave := nil;
 end;

 if targetHasCamera then
 begin
   sourcePanel.Text := '<FONT color="#FFFFFF">' + CamIdToCamName(targetCamId) +' tag: ' + IntToStr(sourcePanel.tag)+ '</FONT>';
   sourcePanel.Background.LoadFromFile('../../icon-img/merCamOn.jpg');
   sourcePanel.OnMouseMove := pnPartitionMouseMove;
   sourcePanel.OnMouseLeave := pnPartitionMouseLeave;
 end
 else
 begin
   sourcePanel.Text := '<FONT color="#FFFFFF">카메라 없음'+' tag: ' + IntToStr(sourcePanel.tag)+'</FONT>';
   sourcePanel.Background.LoadFromFile('../../icon-img/merCamOff.jpg');
   sourcePanel.OnMouseMove := nil;
   sourcePanel.OnMouseLeave := nil;
 end;
end;




procedure TfrmLayouts.pnVideoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Sender is TAdvPanel) and (Source is TAdvPanel) then
    Accept := true
  else
    Accept := false;
end;

Procedure TfrmLayouts.pnVideoMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
  if y > 20 then
  begin
    if (Button=mbLeft) then
     (Sender as TAdvPanel).BeginDrag(true);
  end;
  
end;

procedure TfrmLayouts.pnPartitionMouseLeave(Sender: TObject);
begin
  (Sender as TAdvPanel).Caption.CloseButton := false;
end;

procedure TfrmLayouts.pnPartitionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  (Sender as TAdvPanel).Caption.CloseButton := true;
end;



procedure TfrmLayouts.pnPartitionClose(Sender: TObject);
var
  closedPanel: TAdvPanel;
  tag: Integer;
  panelNo, divType, posX, posY: Integer;
begin
  closedPanel := Sender as TAdvPanel;

  // 기존 tag에서 정보 추출
  tag := closedPanel.Tag;
  panelNo := tag div 100000000;
  divType := (tag mod 100000000) div 10000000;
  posX := (tag mod 10000000) div 1000000;
  posY := (tag mod 1000000) div 100000;

  // 카메라 ID 제거 (0으로 설정)
  closedPanel.Tag := CreatePanelTag(panelNo, divType, posX, posY, 0);

  // UI 업데이트
  closedPanel.Text := '<FONT color="#FFFFFF">카메라 없음' + ' tag: ' + IntToStr(closedPanel.Tag) + '</FONT>';
  closedPanel.Background.LoadFromFile('../../icon-img/merCamOff.jpg');
  closedPanel.OnMouseMove := nil;
  closedPanel.OnMouseLeave := nil;
  closedPanel.Visible := true;
end;






end.
