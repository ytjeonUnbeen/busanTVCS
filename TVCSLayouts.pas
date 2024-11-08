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
    rbtnCheckPartition: TAdvOfficeRadioGroup;
    pnPartition: TAdvPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    AdvMetroButton1: TAdvMetroButton;
    lbmergeName: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddCamClick(Sender: TObject);
    procedure btnAddTabClick(Sender: TObject);
    procedure btnDeleteTabClick(Sender: TObject);

    procedure rbtnCheckPartitionRadioButtonClick(Sender: TObject);

    procedure btnRemoveCamClick(Sender: TObject);
    procedure tabMergeChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure pnPartitionClose(Sender: TObject);
    procedure RemoveCameraFromPanel(panel: TAdvPanel);
    procedure AdvMetroButton1Click(Sender: TObject);
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure grdTrainCamsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdTrainCamsDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure grdTrainCamsCanClickCell(Sender: TObject; ARow, ACol: Integer;
      var Allow: Boolean);
    procedure edCamMerNameExit(Sender: TObject);
    procedure edCamMerNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdTrainCamsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure grdTrainCamsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    
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
  i, j, k, tag, cameraId, posX, posY: Integer;
  trainCameraMergePost: TVCSTrainCameraMergePost;
  mergePostInfo: fmergePostInfo;
  currentTabIndex: Integer;
begin
  if ShowTVCSCheck(0) then
  begin
    try
      // 현재 선택된 탭 저장
      currentTabIndex := tabMerge.TabIndex;
      
      // 모든 기존 머지 삭제
      for i := 0 to tabMerge.AdvTabs.Count - 1 do
      begin
        gapi.DeleteTrainCameraMerge(selTrain.fid, tabMerge.AdvTabs.Items[i].Caption);
      end;

      // 모든 탭의 머지 다시 추가
      for i := 0 to tabMerge.AdvTabs.Count - 1 do
      begin
        // 탭 변경하여 각 탭의 패널 정보 가져오기
        tabMerge.TabIndex := i;
        
        trainCameraMergePost := TVCSTrainCameraMergePost.Create;
        try
          trainCameraMergePost.ftrainId := selTrain.fid;
          trainCameraMergePost.fname := tabMerge.AdvTabs.Items[i].Caption;
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

          // 현재 탭의 패널 정보 저장
          for j := 0 to Length(partitionPanels) - 1 do
          begin
            tag := partitionPanels[j].Tag;
            cameraId := tag mod 10000;

            if cameraId > 0 then
            begin
              posX := (tag mod 10000000) div 1000000;
              posY := (tag mod 1000000) div 100000;

              mergePostInfo := fmergePostInfo.Create;
              mergePostInfo.fcameraId := cameraId;
              mergePostInfo.fPositionX := posX;
              mergePostInfo.fPositionY := posY;

              k := Length(trainCameraMergePost.fitem);
              SetLength(trainCameraMergePost.fitem, k + 1);
              trainCameraMergePost.fitem[k] := mergePostInfo;
            end;
          end;

          // 서버에 머지 추가
          gapi.AddTrainCameraMerge(trainCameraMergePost);
        finally
          trainCameraMergePost.Free;
        end;
      end;

      // 원래 선택된 탭으로 복귀
      tabMerge.TabIndex := currentTabIndex;
      ShowMessage('저장이 완료되었습니다.');
      
      // 변경사항 반영을 위해 데이터 다시 로드
      LoadMergeList(selTrain.fid);
      LoadTrainCamList(selTrain.fid);
      
    except
      on E: Exception do
        ShowMessage('저장 중 오류가 발생했습니다: ' + E.Message);
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
      gapi.DeleteTrainCameraMerge(selTrain.fid, tabMerge.AdvTabs.Items[tabMerge.TabIndex].Caption);
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

  // 9분할 -> 4분할 변경 시
  if (rbtnCheckPartition.ItemIndex = 1) then
  begin
    // 현재 카메라가 설정된 패널 정보만 저장
    SetLength(saveData, 9);
    cameraCnt := 0;
    for i := 0 to Length(partitionPanels) - 1 do
    begin
      if ((partitionPanels[i].Tag mod 100000) div 10000) = 1 then  // 카메라가 설정된 패널만
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

    // 4분할로 변경하기 전에 5번째 이후 패널의 카메라들 처리
    if cameraCnt > 4 then
    begin
      // 5번째부터 마지막까지의 카메라들을 LoadMerge에서 제거
      for i := 4 to cameraCnt - 1 do
      begin
        if saveData[i].cameraId > 0 then
        begin
          // 해당 패널에서 카메라 제거
          for var j := 0 to Length(partitionPanels) - 1 do
          begin
            if (partitionPanels[j].Tag mod 10000) = saveData[i].cameraId then
            begin
              RemoveCameraFromPanel(partitionPanels[j]);
              Break;
            end;
          end;
        end;
      end;
    end;

    // 4분할로 변경
    selPartition := 4;
    rbtnCheckPartition.ItemIndex := 1;
    CreatePartitionPanels(4, False);

    // 저장했던 데이터로 앞에서부터 순서대로 4개 패널 업데이트
    for i := 0 to Min(cameraCnt-1, 3) do  // 최대 4개까지만
    begin
      var row := i div 2;       // 0,0,1,1
      var col := i mod 2;       // 0,1,0,1
      var panelNo := i + 1;     // 1,2,3,4

      partitionPanels[i].Tag := CreatePanelTag(panelNo, 4, col, row, saveData[i].cameraId);
      partitionPanels[i].Text := 
        '<FONT color="#FFFFFF">' + CamIdToCamName(saveData[i].cameraId) + 
        ' tag: ' + IntToStr(partitionPanels[i].Tag) + '</FONT>';
      partitionPanels[i].Background.LoadFromFile('../../icon-img/merCamOn.jpg');
      partitionPanels[i].OnMouseMove := pnPartitionMouseMove;
      partitionPanels[i].OnMouseLeave := pnPartitionMouseLeave;
    end;

    // 그리드 갱신하여 제거된 카메라들이 표시되도록 함
    if selTrain <> nil then
    begin
      LoadTrainCamList(selTrain.fid);
      grdTrainCams.Row := 0;
    end;
  end
  // 4분할 -> 9분할 변경
  else if (rbtnCheckPartition.ItemIndex = 0) then
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
  i, j, k, size : integer;
  isUsedCamera: Boolean;
  temp: TVCSTrainCamera;
begin
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

    size := Length(trainCams);

    if size > 0 then
    begin
      // position으로 정렬
      for i := 0 to size-2 do
        for j := i+1 to size-1 do
          if trainCams[i].fposition > trainCams[j].fposition then
          begin
            temp := trainCams[i];
            trainCams[i] := trainCams[j];
            trainCams[j] := temp;
          end;

      for i := 0 to size-1 do
      begin
        isUsedCamera := False;
        
        // LoadMerge에서 사용중인지 확인 (서버 데이터 기준)
        if Assigned(LoadMerge) then 
        begin
          for j := 0 to Length(LoadMerge) - 1 do
          begin
            if Assigned(LoadMerge[j].fitem) then
            begin
              for k := 0 to Length(LoadMerge[j].fitem) - 1 do
              begin
                if LoadMerge[j].fitem[k].fcameraId = trainCams[i].fid then
                begin
                  isUsedCamera := True;
                  Break;
                end;
              end;
            end;
            if isUsedCamera then Break;
          end;
        end;

        // 현재 작업중인 패널의 카메라도 체크
        if not isUsedCamera and Assigned(partitionPanels) then
        begin
          for j := 0 to Length(partitionPanels) - 1 do
          begin
            // 현재 패널에 추가된 카메라만 체크 (close된 카메라는 체크하지 않음)
            if ((partitionPanels[j].Tag mod 100000) div 10000) = 1 then
            begin
              if (partitionPanels[j].Tag mod 10000) = trainCams[i].fid then
              begin
                isUsedCamera := True;
                Break;
              end;
            end;
          end;
        end;

        // 사용중이지 않은 카메라만 그리드에 추가
        if not isUsedCamera then
        begin
          with grdTrainCams do
          begin
            AddRow;
            Cells[0, RowCount-1] := IntToStr(trainCams[i].fposition);
            Cells[1, RowCount-1] := trainCams[i].fname;
            AddImageIdx(2, RowCount-1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
          end;
        end;
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
      CreatePartitionPanels(selMerge.fdivNum);

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
  i, size: Integer;
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

  size := length(LoadMerge);
  setLength(LoadMerge,size+1);
  LoadMerge[length(LoadMerge)-1] := selMerge;
  

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
begin
  if Assigned(LoadMerge) and (NewTab >= 0) and (NewTab < Length(LoadMerge)) then
  begin
    TabAddCnt := 0;  // 기존 탭 선택
    // 새로 추가한 탭

    edCamMerName.Text := LoadMerge[NewTab].fname;
    EdRtspIP.Text := LoadMerge[NewTab].ftvcsRtsp;
    selMerge := LoadMerge[NewTab];
    CreatePartitionPanels(selMerge.fdivNum);
    
    // 그리드 갱신
    if selTrain <> nil then
      LoadTrainCamList(selTrain.fid);
  end
  else
  begin
    InitializeMergeTab(False);
  end;

  AllowChange := True;
end;


function TfrmLayouts.CamIdToCamName(cameraId: integer): String;
var
  i, j: Integer;
begin
  Result := '';

  // 1. trainCams에서 먼저 찾기
  if Assigned(trainCams) then
  begin
    for i := 0 to Length(trainCams) - 1 do
    begin
      if trainCams[i].fid = cameraId then
      begin
        Result := trainCams[i].fname;
        Exit;  // 찾았으면 종료
      end;
    end;
  end;

  // 2. LoadMerge의 fitem에서 찾기
  if (Result = '') and Assigned(LoadMerge) then
  begin
    for i := 0 to Length(LoadMerge) - 1 do
    begin
      if Assigned(LoadMerge[i].fitem) then
      begin
        for j := 0 to Length(LoadMerge[i].fitem) - 1 do
        begin
          if LoadMerge[i].fitem[j].fcameraId = cameraId then
          begin
            Result := LoadMerge[i].fitem[j].fname;
            Exit;
          end;
        end;
      end;
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

procedure TfrmLayouts.edCamMerNameExit(Sender: TObject);
begin
   tabMerge.AdvTabs.Items[tabMerge.TabIndex].Caption := edCamMerName.Text;
end;

procedure TfrmLayouts.edCamMerNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   tabMerge.AdvTabs.Items[tabMerge.TabIndex].Caption := edCamMerName.Text;
end;

procedure TfrmLayouts.grdTrainCamsCanClickCell(Sender: TObject; ARow,
  ACol: Integer; var Allow: Boolean);
begin
 if ARow > 0 then
  begin
    selTrainCam := trainCams[ARow-1];
  end;
end;

procedure TfrmLayouts.grdTrainCamsDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
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

procedure TfrmLayouts.grdTrainCamsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  sourcePanel: TAdvPanel;
begin
  if Source is TAdvPanel then
  begin
    sourcePanel := Source as TAdvPanel;
    
    // 패널에 카메라가 있는 경우에만 처리
    if ((sourcePanel.Tag mod 100000) div 10000) = 1 then
    begin
      // 패널에서 카메라 제거
      RemoveCameraFromPanel(sourcePanel);
      
      // 그리드 리로드 및 선택 해제
      if selTrain <> nil then
      begin
        LoadTrainCamList(selTrain.fid);
        grdTrainCams.Row := 0;
      end;
    end;
  end;
end;

procedure TfrmLayouts.grdTrainCamsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
   if Source is TAdvPanel then
    accept := true;
end;

procedure TfrmLayouts.grdTrainCamsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  grdTrainCams.MouseToCell(X, Y, ACol, ARow);
  
  if (ARow > 0) and (ACol = 1) then // 1번 열을 클릭했을 때만
  begin
    // 현재 선택된 셀의 카메라 이름으로 trainCams에서 찾기
    var camName := grdTrainCams.Cells[1, ARow];
    for var i := 0 to Length(trainCams) - 1 do
      if trainCams[i].fname = camName then
      begin
        selTrainCam := trainCams[i];
        Break;
      end;

    if (Button = mbLeft) then
      (Sender as TAdvStringGrid).BeginDrag(true);
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
begin
  if ARow <= 0 then Exit;

  selTrain := trains[ARow -1];
  
  // 먼저 trainCams와 LoadMerge를 한번에 로드
  trainCams := gapi.GetTrainCamera(selTrain.fid);
  LoadMerge := gapi.GetTrainCameraMerge(selTrain.fid);

  // UI 세팅 (LoadMerge 기반으로 탭과 패널 생성)
  tabMerge.AdvTabs.Clear;
  edCamMerName.Text := '';
  EdRtspIP.Text := '';

  if Assigned(LoadMerge) and (Length(LoadMerge) > 0) then
  begin
    selMerge := LoadMerge[0];
    selPartition := selMerge.fdivNum;
    if selPartition = 4 then
      rbtnCheckPartition.ItemIndex := 1
    else
      rbtnCheckPartition.ItemIndex := 0;

    SetLength(panelData, selMerge.fdivNum);

    for var i := 0 to Length(LoadMerge) - 1 do
    begin
      with tabMerge do
      begin
        AdvTabs.Add;
        AdvTabs[i].Caption := LoadMerge[i].fname;
      end;
    end;

    tabMerge.TabIndex := 0;
    CreatePartitionPanels(selMerge.fdivNum);
  end
  else
  begin
    InitializeMergeTab;
    CreatePartitionPanels(selMerge.fdivNum);
  end;

  // 마지막으로 그리드에 사용 가능한 카메라 표시
  LoadTrainCamList(selTrain.fid);
 
  edCamMerName.Enabled := true;
  Combobox1.Enabled := true;
  rbtnCheckPartition.Enabled := true;
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
  targetPanel := Sender as TAdvPanel;
  
  // 패널 간 드래그/드롭
  if Source is TAdvPanel then
  begin
    sourcePanel := Source as TAdvPanel;
    sourceTag := sourcePanel.Tag;
    targetTag := targetPanel.Tag;

    // 기존 tag에서 정보 추출
    sourcePanelNo := sourceTag div 100000000;
    sourceDivType := (sourceTag mod 100000000) div 10000000;
    sourceX := (sourceTag mod 10000000) div 1000000;
    sourceY := (sourceTag mod 1000000) div 100000;
    sourceHasCamera := ((sourceTag mod 100000) div 10000) = 1;
    if sourceHasCamera then 
      sourceCamId := sourceTag mod 10000
    else 
      sourceCamId := -1;

    targetPanelNo := targetTag div 100000000;
    targetDivType := (targetTag mod 100000000) div 10000000;
    targetX := (targetTag mod 10000000) div 1000000;
    targetY := (targetTag mod 1000000) div 100000;
    targetHasCamera := ((targetTag mod 100000) div 10000) = 1;
    if targetHasCamera then 
      targetCamId := targetTag mod 10000
    else 
      targetCamId := -1;

    // 새 tag 생성 및 설정
    sourcePanel.Tag := CreatePanelTag(sourcePanelNo, sourceDivType, sourceX, sourceY, targetCamId);
    targetPanel.Tag := CreatePanelTag(targetPanelNo, targetDivType, targetX, targetY, sourceCamId);

    // UI 업데이트
    if sourceHasCamera then
    begin
      targetPanel.Text := '<FONT color="#FFFFFF">' + CamIdToCamName(sourceCamId) + 
        ' tag: ' + IntToStr(targetPanel.Tag) + '</FONT>';
      targetPanel.Background.LoadFromFile('../../icon-img/merCamOn.jpg');
      targetPanel.OnMouseMove := pnPartitionMouseMove;
      targetPanel.OnMouseLeave := pnPartitionMouseLeave;
    end
    else
    begin
      targetPanel.Text := '<FONT color="#FFFFFF">카메라 없음' + 
        ' tag: ' + IntToStr(targetPanel.Tag) + '</FONT>';
      targetPanel.Background.LoadFromFile('../../icon-img/merCamOff.jpg');
      targetPanel.OnMouseMove := nil;
      targetPanel.OnMouseLeave := nil;
    end;

    if targetHasCamera then
    begin
      sourcePanel.Text := '<FONT color="#FFFFFF">' + CamIdToCamName(targetCamId) + 
        ' tag: ' + IntToStr(sourcePanel.Tag) + '</FONT>';
      sourcePanel.Background.LoadFromFile('../../icon-img/merCamOn.jpg');
      sourcePanel.OnMouseMove := pnPartitionMouseMove;
      sourcePanel.OnMouseLeave := pnPartitionMouseLeave;
    end
    else
    begin
      sourcePanel.Text := '<FONT color="#FFFFFF">카메라 없음' + 
        ' tag: ' + IntToStr(sourcePanel.Tag) + '</FONT>';
      sourcePanel.Background.LoadFromFile('../../icon-img/merCamOff.jpg');
      sourcePanel.OnMouseMove := nil;
      sourcePanel.OnMouseLeave := nil;
    end;
   // 그리드 갱신 및 선택 해제
    if selTrain <> nil then
    begin
      LoadTrainCamList(selTrain.fid);
      grdTrainCams.Row := 0;
    end;
  end
  // 그리드에서 패널로 드래그/드롭
  else if Source = grdTrainCams then
  begin
    targetTag := targetPanel.Tag;
    
    // 기존 tag에서 정보 추출
    targetPanelNo := targetTag div 100000000;
    targetDivType := (targetTag mod 100000000) div 10000000;
    targetX := (targetTag mod 10000000) div 1000000;
    targetY := (targetTag mod 1000000) div 100000;
    targetHasCamera := ((targetTag mod 100000) div 10000) = 1;
    
    // 대상 패널에 이미 카메라가 있는 경우
    if targetHasCamera then
    begin                                                                      
      ShowTVCSMessage('이미 카메라가 배치되어 있습니다.');
      Exit;
    end;
    
    // 새 태그 설정
    targetPanel.Tag := CreatePanelTag(targetPanelNo, targetDivType, targetX, targetY, selTrainCam.fid);
    
    // 패널 UI 업데이트
    targetPanel.Text := '<FONT color="#FFFFFF">' + selTrainCam.fname + 
      ' tag: ' + IntToStr(targetPanel.Tag) + '</FONT>';
    targetPanel.Background.LoadFromFile('../../icon-img/merCamOn.jpg');
    targetPanel.OnMouseMove := pnPartitionMouseMove;
    targetPanel.OnMouseLeave := pnPartitionMouseLeave;

    setLength(LoadMerge[tabMerge.TabIndex].fitem,Length(LoadMerge[tabMerge.TabIndex].fitem)+1);
    LoadMerge[tabMerge.TabIndex].fitem[length(LoadMerge[tabMerge.TabIndex].fitem)-1] := fmergeCamInfo.Create;
    LoadMerge[tabMerge.TabIndex].fitem[length(LoadMerge[tabMerge.TabIndex].fitem)-1].fcameraId := selTrainCam.fid;
    LoadMerge[tabMerge.TabIndex].fitem[length(LoadMerge[tabMerge.TabIndex].fitem)-1].fpositionX := targetX;
    LoadMerge[tabMerge.TabIndex].fitem[length(LoadMerge[tabMerge.TabIndex].fitem)-1].fpositionY := targetY;
    
    
    // 그리드 리로드 및 선택 해제
    if selTrain <> nil then
    begin
      LoadTrainCamList(selTrain.fid);
      grdTrainCams.Row := 0;
    end;
  end;
end;

// 패널 이동관련
procedure TfrmLayouts.pnVideoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  currentPanelCount: Integer;
  i: Integer;
begin
  Accept := False;
  
  // 패널간 드래그인 경우
  if (Source is TAdvPanel) and (Sender is TAdvPanel) then
    Accept := True
  // 그리드에서 패널로 드래그하는 경우
  else if (Source = grdTrainCams) and (Sender is TAdvPanel) then
  begin
    // 현재 카메라가 설정된 패널 수 계산
    currentPanelCount := 0;
    for i := 0 to Length(partitionPanels) - 1 do
    begin
      if ((partitionPanels[i].Tag mod 100000) div 10000) = 1 then
        Inc(currentPanelCount);
    end;
    
    // 분할 방식에 따른 최대 패널 수 체크
    if (selPartition = 4) and (currentPanelCount < 4) then
      Accept := True
    else if (selPartition = 9) and (currentPanelCount < 8) then
      Accept := True;
  end;
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


//캡션 설정
procedure TfrmLayouts.pnPartitionMouseLeave(Sender: TObject);
begin
  (Sender as TAdvPanel).Caption.CloseButton := false;
end;

procedure TfrmLayouts.pnPartitionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  (Sender as TAdvPanel).Caption.CloseButton := true;
end;

procedure TfrmLayouts.RemoveCameraFromPanel(panel: TAdvPanel);
var
  tag: Integer;
  panelNo, divType, posX, posY: Integer;
  cameraId: Integer;
  i, j: Integer;
begin
  tag := panel.Tag;
  
  // 제거되는 카메라 ID 저장
  cameraId := tag mod 10000;

  // LoadMerge의 현재 탭에서 카메라 제거
  if Assigned(LoadMerge) and (tabMerge.TabIndex >= 0) and 
     (tabMerge.TabIndex < Length(LoadMerge)) and 
     Assigned(LoadMerge[tabMerge.TabIndex].fitem) then
  begin
    for i := Length(LoadMerge[tabMerge.TabIndex].fitem) - 1 downto 0 do
    begin
      if LoadMerge[tabMerge.TabIndex].fitem[i].fcameraId = cameraId then
      begin
        // 해당 카메라 항목 제거
        for j := i to Length(LoadMerge[tabMerge.TabIndex].fitem) - 2 do
          LoadMerge[tabMerge.TabIndex].fitem[j] := LoadMerge[tabMerge.TabIndex].fitem[j + 1];
        SetLength(LoadMerge[tabMerge.TabIndex].fitem, Length(LoadMerge[tabMerge.TabIndex].fitem) - 1);
        Break;
      end;
    end;
  end;

  // 기존 tag에서 정보 추출
  panelNo := tag div 100000000;
  divType := (tag mod 100000000) div 10000000;
  posX := (tag mod 10000000) div 1000000;
  posY := (tag mod 1000000) div 100000;

  // 카메라 ID 제거
  panel.Tag := CreatePanelTag(panelNo, divType, posX, posY);

  // UI 업데이트
  panel.Text := '<FONT color="#FFFFFF">카메라 없음' + 
    ' tag: ' + IntToStr(panel.Tag) + '</FONT>';
  panel.Background.LoadFromFile('../../icon-img/merCamOff.jpg');
  panel.OnMouseMove := nil;
  panel.OnMouseLeave := nil;
  panel.Caption.CloseButton := false;
  panel.Visible := true;
end;

procedure TfrmLayouts.pnPartitionClose(Sender: TObject);
begin
  RemoveCameraFromPanel(Sender as TAdvPanel);
  
  // 그리드 리로드 및 선택 해제
  if selTrain <> nil then
  begin
    LoadTrainCamList(selTrain.fid);
    grdTrainCams.Row := 0;
  end;
end;





end.
