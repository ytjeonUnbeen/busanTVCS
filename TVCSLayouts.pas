unit TVCSLayouts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.StdCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvGlowButton, Vcl.ExtCtrls, Vcl.ComCtrls,
  AdvPageControl, TVCSButtonStyle, tvcsProtocol, tvcsAPI, System.ImageList,
  Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Buttons, AdvMetroButton, AdvTabSet, AdvEdit,
  AdvGroupBox, AdvOfficeButtons, AdvLabel, AdvPanel, advimage, Vcl.WinXPanels;


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

    checkAddTab : boolean;
    selPartition : integer;
    trains : TArray<TVCSTrain>;
    trainCams : TArray<TVCSTrainCamera>;

    partitionPanels: array of TAdvPanel;


    selTrain : TVCSTrain;
    selTrainCam : TVCSTrainCamera;
    selMerge : TVCSTrainCameraMerge;

    addMerge : TArray<TVCSTrainCameraMergePost>;
    LoadMerge : TArray<TVCSTrainCameraMerge>;

    procedure UpdatePartitionPanels;
    procedure CreatePartitionPanels;
    procedure LoadTrainList(trainNo: string='');
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure LoadTrainCamList(trainId: Integer =-1);
    procedure LoadMergeList(trainId: Integer =-1);
    procedure InitTabSet;
    procedure UpdatePartitionPanelsFromMerge(mergeCam: TVCSTrainCameraMerge);
    function GetPanelIndexFromPosition(posX, posY: Integer; panelCount: Integer): Integer;
  public
    { Public declarations }
  end;

var
  frmLayouts: TfrmLayouts;

implementation

{$R *.dfm}

procedure TransparentPanel(var Target: TAdvPanel);
var
  I: Integer;
  FullRgn, ClientRgn, ControlRgn: THandle;
  Margin, MarginX, MarginY, X, Y: Integer;
begin
  Margin := (Target.Width - Target.ClientWidth) div 2;
  FullRgn := CreateRectRgn(0, 0, Target.Width, Target.Height);

  MarginX := Margin;
  MarginY := Target.Height - Target.ClientHeight - Margin;

  ClientRgn := CreateRectRgn(
    MarginX,
    MarginY,
    MarginX + Target.ClientWidth,
    MarginY + Target.ClientHeight
  );

  CombineRgn(FullRgn, FullRgn, ClientRgn, RGN_DIFF);

  for I := 0 to Target.ControlCount-1 do
  begin
    X := MarginX + Target.Controls[I].Left;
    Y := MarginY + Target.Controls[I].Top;
    ControlRgn := CreateRectRgn(
      X,
      Y,
      X + Target.Controls[I].Width,
      Y + Target.Controls[I].Height
    );
    CombineRgn(FullRgn, FullRgn, ControlRgn, RGN_OR);
  end;

  SetWindowRgn(Target.Handle, FullRgn, True);
end;

procedure TfrmLayouts.CreatePartitionPanels;
var
  i: Integer;
  newPanel: TAdvPanel;
  panelWidth, panelHeight: Integer;
begin
  // 기존 패널들 제거
  for i := 0 to Length(partitionPanels) - 1 do
  begin
    if Assigned(partitionPanels[i]) then
      partitionPanels[i].Free;
  end;
  // 새 패널 배열 크기 설정 (실제 사용할 패널 수)
  case selPartition of
    4: SetLength(partitionPanels, 4);  // 4분할
    9: SetLength(partitionPanels, 8);  // 8분할 (가운데 제외)
  end;
  // 패널 크기 설정
  case selPartition of
    4: begin
      panelWidth := pnPartition.Width div 2;
      panelHeight := pnPartition.Height div 2;
    end;
    9: begin
      panelWidth := pnPartition.Width div 3;
      panelHeight := pnPartition.Height div 3;
    end;
  else
    Exit;
  end;
  // 패널 생성 및 배치
  case selPartition of
    4: begin  // 2x2 그리드
      for i := 0 to 3 do
      begin
        newPanel := TAdvPanel.Create(pnPartition);
        newPanel.Parent := pnPartition;
        newPanel.BorderWidth := 1;
        newPanel.HoverColor := clBlue;
        newPanel.Left := (i mod 2) * panelWidth;
        newPanel.Top := (i div 2) * panelHeight;
        newPanel.Width := panelWidth;
        newPanel.Height := panelHeight;
        newPanel.Text := '';
        partitionPanels[i] := newPanel;
      end;
    end;
    9: begin  // 3x3 그리드 (가운데 제외)
      var panelIndex := 0;
      for i := 0 to 8 do
      begin
        // 가운데 패널(인덱스 4)은 건너뛰기
        if i = 4 then
        begin
          // 가운데 빈 패널 생성 (배열에는 포함하지 않음)
          newPanel := TAdvPanel.Create(pnPartition);
          newPanel.Parent := pnPartition;
          newPanel.BorderWidth := 1;
          //newPanel.Color := clGray;  // 빈 패널 표시
          newPanel.Left := panelWidth;
          newPanel.Top := panelHeight;
          newPanel.Width := panelWidth;
          newPanel.Height := panelHeight;
          newPanel.Text := '';
          newPanel.Enabled := False;
          newPanel.ParentColor := True;
          Continue;
        end;
        newPanel := TAdvPanel.Create(pnPartition);
        newPanel.Parent := pnPartition;
        newPanel.BorderWidth := 1;
        newPanel.HoverColor := clBlue;
        newPanel.Left := (i mod 3) * panelWidth;
        newPanel.Top := (i div 3) * panelHeight;
        newPanel.Width := panelWidth;
        newPanel.Height := panelHeight;
        newPanel.Text := '';
        //newPanel.Background := img;
        partitionPanels[panelIndex] := newPanel;
        Inc(panelIndex);
      end;
    end;
  end;
end;


procedure TfrmLayouts.UpdatePartitionPanels;
var
  i: Integer;
begin
  for i := 0 to Length(partitionPanels) - 1 do
  begin
    if Assigned(partitionPanels[i]) then
    begin
      if Assigned(addMerge[i]) then
      begin
        partitionPanels[i].Text := selTrainCam.fname;
        partitionPanels[i].BorderWidth := 1;

      end


      else
        partitionPanels[i].Text := '';
    end;
  end;
  pnPartition.BorderWidth := 1;
end;

procedure TfrmLayouts.btnAddCamClick(Sender: TObject);
var
  camMergePos: TVCSTrainCameraMergePost;
  i, emptyIndex: Integer;
begin
  // addMerge 배열이 초기화되어 있지 않은 경우 초기화
  if grdTrainCams.Row > 0 then
  begin
    if Length(addMerge) = 0 then
  begin
    SetLength(addMerge, selPartition);
    for i := 0 to Length(addMerge) - 1 do
      addMerge[i] := nil;

    // 패널 생성
    CreatePartitionPanels;
  end;

  // 빈 위치 찾기
  emptyIndex := -1;
  for i := 0 to Length(addMerge) - 1 do
  begin
    if addMerge[i] = nil then
    begin
      emptyIndex := i;
      Break;
    end;
  end;

  if not checkAddTab then
  begin
    ShowMessage('탭을 먼저 추가해주세요.');
    Exit;
  end;

  // 빈 위치가 없으면 종료
  if emptyIndex = -1 then
  begin
    ShowMessage('더 이상 카메라를 추가할 수 없습니다.');
    Exit;
  end;

  camMergePos := TVCSTrainCameraMergePost.Create;
  camMergePos.ftrainId := selTrain.fid;
  camMergePos.fname := edCamMerName.Text;
  camMergePos.fcameraId := selTrainCam.fid;

  // 분할 방식에 따라 좌표 설정 (9분할 기본값)
  case selPartition of
    4: begin  // 4분할
      case emptyIndex of
        0: begin  // 좌상
          camMergePos.fpositionX := 0;
          camMergePos.fpositionY := 0;
        end;
        1: begin  // 우상
          camMergePos.fpositionX := 640;
          camMergePos.fpositionY := 0;
        end;
        2: begin  // 좌하
          camMergePos.fpositionX := 0;
          camMergePos.fpositionY := 360;
        end;
        3: begin  // 우하
          camMergePos.fpositionX := 640;
          camMergePos.fpositionY := 360;
        end;
      end;
    end;
    else begin  // 9분할 (실제 8개 사용)
      case emptyIndex of
        0: begin  // 좌상
          camMergePos.fpositionX := 0;
          camMergePos.fpositionY := 0;
        end;
        1: begin  // 중상
          camMergePos.fpositionX := 640;
          camMergePos.fpositionY := 0;
        end;
        2: begin  // 우상
          camMergePos.fpositionX := 1280;
          camMergePos.fpositionY := 0;
        end;
        3: begin  // 좌중
          camMergePos.fpositionX := 0;
          camMergePos.fpositionY := 360;
        end;
        4: begin  // 우중
          camMergePos.fpositionX := 1280;
          camMergePos.fpositionY := 360;
        end;
        5: begin  // 좌하
          camMergePos.fpositionX := 0;
          camMergePos.fpositionY := 720;
        end;
        6: begin  // 중하
          camMergePos.fpositionX := 640;
          camMergePos.fpositionY := 720;
        end;
        7: begin  // 우하
          camMergePos.fpositionX := 1280;
          camMergePos.fpositionY := 720;
        end;
      end;
    end;
  end;

  // addMerge 배열에 추가
  addMerge[emptyIndex] := camMergePos;

  // 패널 캡션 업데이트
  UpdatePartitionPanels;
  end;



end;

procedure TfrmLayouts.btnAddTabClick(Sender: TObject);
begin
  checkAddTab := true;
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




  selPartition := 9;
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
begin
  if rbtnCheckPartition.ItemIndex = 0 then
    selPartition := 9  // 9분할 (실제 8개 패널)
  else
    selPartition := 4; // 4분할

  // 기존 배열의 객체들 해제
  for i := 0 to Length(addMerge) - 1 do
  begin
    if Assigned(addMerge[i]) then
      addMerge[i].Free;
  end;

  // 실제 사용할 패널 수에 맞게 배열 크기 설정
  if selPartition = 9 then
    setLength(addMerge, 8)  // 8개 패널
  else
    setLength(addMerge, 4); // 4개 패널

  for i := 0 to Length(addMerge) - 1 do
    addMerge[i] := nil;

  CreatePartitionPanels;
end;

procedure TfrmLayouts.tabMergeChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  if Assigned(LoadMerge) and (NewTab >= 0) and (NewTab < Length(LoadMerge)) then
  begin
    edCamMerName.Text := LoadMerge[NewTab].fname;
    EdRtspIP.Text := LoadMerge[NewTab].ftvcsRtsp;
    UpdatePartitionPanelsFromMerge(LoadMerge[NewTab]);
  end
  else
  begin
    edCamMerName.Text := '';
    EdRtspIP.Text := '';
    CreatePartitionPanels; // 빈 패널 생성
  end;

  AllowChange := True;
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
        UpdatePartitionPanelsFromMerge(LoadMerge[0]);
      end;
    end;



  end;
end;

procedure TfrmLayouts.UpdatePartitionPanelsFromMerge(mergeCam: TVCSTrainCameraMerge);
var
  i, panelCount: Integer;
  maxX, maxY: Integer;
begin
  // 패널 개수 결정 (위치 값으로부터 계산)
  maxX := 0;
  maxY := 0;
  for i := 0 to Length(mergeCam.fitem) - 1 do
  begin
    if mergeCam.fitem[i].fpositionX + 640 > maxX then
      maxX := mergeCam.fitem[i].fpositionX + 640;
    if mergeCam.fitem[i].fpositionY + 360 > maxY then
      maxY := mergeCam.fitem[i].fpositionY + 360;
  end;

  // 패널 개수 결정 (9분할 또는 4분할)
  if (maxX <= 1280) and (maxY <= 720) then
    panelCount := 4
  else
    panelCount := 9;

  // 라디오 버튼 상태 업데이트
  if panelCount = 4 then
    rbtnCheckPartition.ItemIndex := 1
  else
    rbtnCheckPartition.ItemIndex := 0;

  selPartition := panelCount;

  // 패널 생성
  CreatePartitionPanels;

  // 패널에 데이터 표시
  for i := 0 to Length(mergeCam.fitem) - 1 do
  begin
    // 패널 인덱스 계산
    var panelIndex := GetPanelIndexFromPosition(mergeCam.fitem[i].fpositionX,
                                              mergeCam.fitem[i].fpositionY,
                                              panelCount);
    if (panelIndex >= 0) and (panelIndex < Length(partitionPanels)) then
    begin
      partitionPanels[panelIndex].Text :=  '<FONT coler="#FFFFFF>"'+ mergeCam.fitem[i].fname + '</FONT>';
      partitionPanels[panelIndex].Tag := mergeCam.fitem[i].fid; // ID 저장
    end;
  end;
end;

function TfrmLayouts.GetPanelIndexFromPosition(posX, posY: Integer; panelCount: Integer): Integer;
begin
  case panelCount of
    4: begin // 2x2
      if (posX = 0) and (posY = 0) then Result := 0
      else if (posX = 640) and (posY = 0) then Result := 1
      else if (posX = 0) and (posY = 360) then Result := 2
      else if (posX = 640) and (posY = 360) then Result := 3
      else Result := -1;
    end;
    9: begin // 3x3
      if (posX = 0) and (posY = 0) then Result := 0
      else if (posX = 640) and (posY = 0) then Result := 1
      else if (posX = 1280) and (posY = 0) then Result := 2
      else if (posX = 0) and (posY = 360) then Result := 3
      else if (posX = 640) and (posY = 360) then Result := 4
      else if (posX = 1280) and (posY = 360) then Result := 5
      else if (posX = 0) and (posY = 720) then Result := 6
      else if (posX = 640) and (posY = 720) then Result := 7
      else if (posX = 1280) and (posY = 720) then Result := 8
      else Result := -1;
    end;
    else Result := -1;
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



end.
