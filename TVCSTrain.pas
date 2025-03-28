unit TVCSTrain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,StrUtils,
  TvcsApi, tvcsProtocol, TVCSButtonStyle, TVCSPreview, System.ImageList, Vcl.ImgList, TVCSCheckDialog,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  tmsAdvGridExcel, System.Generics.Collections, Vcl.Mask, AdvEdit, AdvIPEdit,
  AdvCombo, AdvToolTip;

type
  TfrmTrain = class(TForm)
    pnBottom: TPanel;
    btnCancel: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    pnMainFrame: TPanel;
    lblInfoTitle: TLabel;
    lblTitle: TLabel;
    lblTotal: TLabel;
    pnTrainCameraInfo: TPanel;
    pnDefTrains: TPanel;
    lbscNo: TLabel;
    lblTrainNo: TLabel;
    edscNo: TEdit;
    edTrainNo: TEdit;
    pnNvrRTSP: TPanel;
    lblNvrRTSP: TLabel;
    pnCamInfos: TPanel;
    lblCamInfo: TLabel;
    lblCamCnt: TLabel;
    btnAddCams: TAdvGlowButton;
    grdTrains: TAdvStringGrid;
    btnAddTrain: TAdvGlowButton;
    btnDownloadTrainCameras: TAdvGlowButton;
    btnUploadTrainCameras: TAdvGlowButton;
    grdTrainCams: TAdvStringGrid;
    lblTrainCnt: TLabel;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    AdvGridExcelIO1: TAdvGridExcelIO;
    cbSearch: TComboBox;
    edSearchText: TEdit;
    btnSearch: TAdvGlowButton;
    edNvrRTSP: TAdvIPEdit;
    cmbTrainCnt: TAdvComboBox;
    ValidTooltip: TAdvToolTip;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);




    procedure FormCreate(Sender: TObject);
    procedure btnAddTrainClick(Sender: TObject);
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);

    procedure btnAddCamsClick(Sender: TObject);
    procedure grdTrainCamsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure btnUploadTrainCamerasClick(Sender: TObject);
    procedure btnDownloadTrainCamerasClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure edscNoExit(Sender: TObject);
    procedure edTrainNoExit(Sender: TObject);
    procedure edscNoEnter(Sender: TObject);
    procedure edTrainNoEnter(Sender: TObject);
    procedure edNvrRTSPEnter(Sender: TObject);
    procedure edNvrRTSPExit(Sender: TObject);
    procedure grdTrainsCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure grdTrainsEditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    procedure grdTrainsEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure grdTrainCamsGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdTrainCamsIsPasswordCell(Sender: TObject; ARow, ACol: Integer;
      var IsPassword: Boolean);
    procedure grdTrainsSelectCell(Sender: TObject; ACol, ARow: LongInt;
      var CanSelect: Boolean);


  private
    { Private declarations }
    isNeedUpdate:Boolean;
    GridBuf: TAdvStringGrid;
    BufTrainCams: TArray<TVCSTrainCamera>;
    trains: TArray<tvcsProtocol.TVCSTrain>;
    trainCams: TArray<TVCSTrainCamera>;
    SelTrain: tvcsProtocol.TVCSTrain;

    // 앞쪽 private,public 등이 아닌영역에 넣으면 form  이벤트라 삭제 관리됨
    procedure LoadTrainList(trainNo: string='');
    procedure SetTrainCamListHeader;
    procedure LoadTrainCamList(trainId: Integer =-1);

    procedure AddTrainsList;
    procedure UpdateTrainList(camCount:Integer);

    function Validator:Boolean;

  public
    { Public declarations }
  end;

var
  frmTrain: TfrmTrain;

implementation

{$R *.dfm}
uses TVCSIPcMsg;

procedure TfrmTrain.btnAddCamsClick(Sender: TObject);
begin

  if (grdTrains.Cells[8,1]='new') then    begin

   if (ShowTVCSCheck('열차정보','신규로 추가된 열차입니다.'#13#10'저장후 진핼할까요?')) then begin

       AddTrainsList;
       grdTrains.Cells[8,1]:='old';
   end
   else Exit;

  end;
  


  with grdTrainCams do
  begin
    InsertChildRow(0);
    Cells[0,1] := edTrainNo.Text;
    Cells[1,1] := '10';  // position의 기본값 설정
    Cells[2,1] := '';
    Cells[3,1] := '';
    Cells[4,1] := '80';
    Cells[5,1] := '';
    Cells[6,1] := '';
    Cells[7,1] := '';
    Cells[8,1] := '';
    AddImageIdx(9, 1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
    AddImageIdx(10, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
  end;
end;

procedure TfrmTrain.btnAddTrainClick(Sender: TObject);
begin

  if (grdTrains.Cells[8,1]='new') then Exit;

  with grdTrains do
  begin
    InsertRows(1,1);
    Cells[0,1] := '0';
    Cells[1,1] := '';
    Cells[2,1] := '';
    AddImageIdx(3, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
//    SelectCells(0,grdTrains.RowCount,0,grdTrains.RowCount);
//    FocusCell(1,1);
    Cells[4,1]:='-1';
    Cells[5,1]:=IntToStr(defTrainCarridgeCount);
    Cells[6,1]:='카메라이름';
    Cells[7,1]:='0.0.0.0';
    Cells[8,1]:='new'; // new flag

  end;

  edscNo.Enabled := true;
  cmbTrainCnt.Enabled := true;
  edTrainNo.Enabled := true;
  edNvrRTSP.Enabled := true;
  btnAddCams.Enabled := true;

  edscNo.Text := '';
  edTrainNo.Text := '';
  edNvrRTSP.IPAddress := '0.0.0.0';
  grdTRains.SelectRows(1,1);
  edscNo.SetFocus;
  LoadTrainCamList(-1);

end;

procedure TfrmTrain.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmTrain.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;


function TfrmTrain.Validator: Boolean;
begin
  Result:=True;
   if (edscNo.Text = '') then
    begin
      ShowValidator(edscNo,'편성번호를 입력',ValidTooltip);
        Result:=false;
    end;
    if (edTrainNo.Text = '') then
    begin
          ShowValidator(edTrainNo,'열차번호를 입력',ValidTooltip);
          Result:=false;
    end;
    if (cmbTrainCnt.Text = '') then
    begin
      ShowValidator(edTrainNo,'객차수를  입력',ValidTooltip);
      Result:=false;
    end;
    if (edNvrRTSP.IPAddress = '0.0.0.0') then
    begin
      ShowValidator(edNvrRTSP,'TVCS 주소 입력',ValidTooltip);
      Result:=false;
    end;


end;

procedure TfrmTrain.btnSaveClick(Sender: TObject);
var

  trainCamPos: TArray<TVCSTrainCameraInPost>;
  trainCamPatch: TVCSTrainCameraInPatch;
  trainCamRes: TVCSTrainCamera;
  allSuccess, isModified: Boolean;
  existingTrains: TArray<tvcsProtocol.TVCSTrain>;
  existingCams: TArray<TVCSTrainCamera>;
  i, j, size: integer;
  trainIdMap: TDictionary<String, Integer>;
begin
  if ShowTVCSCheck(mcModify) then
  begin

     if (not Validator) then Exit;

    size := grdTrainCams.RowCount - 1;


    try

        SetLength(trainCamPos, size);

        for i := 1 to size do
        begin
          trainCamPos[i-1] := TVCSTrainCameraInPost.Create;
          with trainCamPos[i-1] do
          begin
            ftrainNo := edTrainNo.Text;
            fposition := StrToInt(grdTrainCams.Cells[1,i]);  // 위치 정보 추가
            fname := grdTrainCams.Cells[2,i];
            fipaddr := grdTrainCams.Cells[3,i];
            fport := StrToInt(grdTrainCams.Cells[4,i]);
            frtsp := grdTrainCams.Cells[5,i];
            frtsp2 := grdTrainCams.Cells[6,i];
            fuserId := grdTrainCams.Cells[7,i];
            fuserPwd := grdTrainCams.Cells[8,i];
          end;
        end;

        try
          for i := 0 to Length(trainCamPos) - 1 do
          begin
            trainCamRes := gapi.AddTrainCamera(trainCamPos[i]);
            if trainCamRes = nil then
            begin
              allSuccess := False;
              Break;
            end;
          end;
        finally
          // 생성된 카메라 객체들 해제
          for i := 0 to Length(trainCamPos) - 1 do
          begin
            if Assigned(trainCamPos[i]) then
              FreeAndNil(trainCamPos[i]);
          end;
        end;



        for i := 1 to grdTrainCams.RowCount - 1 do
        begin
          isModified := False;


          j := 0;
          if (j >= 0) and (j < Length(trainCams)) then
          begin
            trainCamPatch := TVCSTrainCameraInPatch.Create;
            try
              trainCamPatch.fid := trainCams[j].fid;
              trainCamPatch.ftrainId := SelTrain.fid;
              trainCamPatch.fposition := StrToInt(grdTrainCams.Cells[1,i]);  // 위치 정보 추가
              trainCamPatch.fname := grdTrainCams.Cells[2,i];
              trainCamPatch.fipaddr := grdTrainCams.Cells[3,i];
              trainCamPatch.fport := StrToInt(grdTrainCams.Cells[4,i]);
              trainCamPatch.frtsp := grdTrainCams.Cells[5,i];
              trainCamPatch.frtsp2 := grdTrainCams.Cells[6,i];
              trainCamPatch.fuserId := grdTrainCams.Cells[7,i];
              trainCamPatch.fuserPwd := grdTrainCams.Cells[8,i];

              if nil = gapi.UpdateTrainCamera(trainCamPatch) then
                allSuccess := False;
            finally
              FreeAndNil(trainCamPatch);
            end;
          end;
        end;

         ShowTVCSMessage('처리가 완료되었습니다.');
         LoadTrainList;
         IpcMsgSend('LOADTRAIN');

      finally

      end;


  end;


  //ModalResult:=mrOk;
end;




procedure TfrmTrain.btnSearchClick(Sender: TObject);
var
  searchText: string;
  searchMode: integer;
  i: integer;
  found: boolean;
begin
  searchText := edSearchText.Text;
  if searchText = '' then Exit;

  searchMode := cbSearch.ItemIndex;
  found := false;

  for i := 1 to grdTrains.RowCount - 1 do
  begin
    case searchMode of
      0: // 전체 검색
        if  grdTrains.Cells[1,i] = searchText then  // 역사명에서 찾은 경우
        begin
          grdTrains.SelectCells(1,i,1,i);
          grdTrainsClickCell(grdTrains, i, 1);
          found := true;
          Break;
        end
        else if grdTrains.Cells[2,i] = searchText then  // 편성명에서 찾은 경우
        begin
          grdTrains.SelectCells(2,i,2,i);
          grdTrainsClickCell(grdTrains, i, 2);
          found := true;
          Break;
        end;
      1: // 편성 검색
        if grdTrains.Cells[1,i] = searchText then  // 역사명에서 찾은 경우
        begin
          grdTrains.SelectCells(1,i,1,i);
          grdTrainsClickCell(grdTrains, i, 1);
          found := true;
          Break;
        end;
      2: // 열차 번호 검색
         if grdTrains.Cells[2,i] = searchText then
        begin
          grdTrains.SelectCells(2,i,2,i);
          grdTrainsClickCell(grdTrains, i, 2);
          found := true;
          Break;
        end;
      3: // 열차 번호 검색
         if grdTrains.Cells[3,i] = searchText then
        begin
          grdTrains.SelectCells(3,i,3,i);
          grdTrainsClickCell(grdTrains, i, 3);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('검색 결과가 없습니다.');
end;

procedure TfrmTrain.btnDownloadTrainCamerasClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExcelGrid: TAdvStringGrid;
  i, j, currentRow: Integer;
  train: tvcsProtocol.TVCSTrain;
  trainCameras: TArray<TVCSTrainCamera>;
begin
  SaveDialog := TSaveDialog.Create(nil);
  ExcelGrid := TAdvStringGrid.Create(nil);
  try
    SaveDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel (*.xls)|*.xls';
    SaveDialog.DefaultExt := 'xls';
    SaveDialog.FilterIndex := 2;
    if SaveDialog.Execute then
    begin
      // 엑셀 그리드 초기 설정

      with ExcelGrid do
      begin
        ColCount := 14;  // 전체 컬럼 수
        RowCount := 1;   // 헤더 row
        // 헤더 설정
        Cells[1,1] := '편성번호';
        Cells[2,1] := '열차번호';
        Cells[3,1] := '객차수';
        Cells[4,1] := '카메라수';
        Cells[5,1] := 'TVCSIP';
        Cells[6,1] := '설치위치';
        Cells[7,1] := '카메라이름';
        Cells[8,1] := '카메라ip주소';
        Cells[9,1] := '포트번호';
        Cells[10,1] := 'RTSP주소(main)';
        Cells[11,1] := 'RTSP주소(sub)';
        Cells[12,1] := '카메라ID';
        Cells[13,1] := '카메라PW';
      end;
      currentRow := 2;
      // 각 열차별로 처리
      for i := 0 to Length(trains) - 1 do
      begin
        train := trains[i];
        // 해당 열차의 카메라 정보 가져오기
        trainCameras := gapi.GetTrainCamera(train.fid);

        // 카메라가 0개인 경우에도 열차 정보는 한 번 추가
        if Length(trainCameras) = 0 then
        begin
          ExcelGrid.RowCount := currentRow + 1;
          // 열차 정보만 입력
          ExcelGrid.Cells[1,currentRow] := IntToStr(train.fformatNo);
          ExcelGrid.Cells[2,currentRow] := train.ftrainNo;
          ExcelGrid.Cells[3,currentRow] := IntToStr(train.fcarriageNum);
          ExcelGrid.Cells[4,currentRow] := IntToStr(train.fcameraNum);
          ExcelGrid.Cells[5,currentRow] := train.ftvcsIpaddr;
          // 카메라 정보는 비워둠
          Inc(currentRow);
        end
        else
        begin
          // 카메라가 있는 경우 각 카메라별로 row 추가
          for j := 0 to Length(trainCameras) - 1 do
          begin
            ExcelGrid.RowCount := currentRow + 1;
            // 열차 정보
            ExcelGrid.Cells[1,currentRow] := IntToStr(train.fformatNo);
            ExcelGrid.Cells[2,currentRow] := train.ftrainNo;
            ExcelGrid.Cells[3,currentRow] := IntToStr(train.fcarriageNum);
            ExcelGrid.Cells[4,currentRow] := IntToStr(train.fcameraNum);
            ExcelGrid.Cells[5,currentRow] := train.ftvcsIpaddr;
            // 카메라 정보
            ExcelGrid.Cells[6,currentRow] := IntToStr(trainCameras[j].fposition);
            ExcelGrid.Cells[7,currentRow] := trainCameras[j].fname;
            ExcelGrid.Cells[8,currentRow] := trainCameras[j].fipaddr;
            ExcelGrid.Cells[9,currentRow] := IntToStr(trainCameras[j].fport);
            ExcelGrid.Cells[10,currentRow] := trainCameras[j].frtsp;
            ExcelGrid.Cells[11,currentRow] := trainCameras[j].frtsp2;
            ExcelGrid.Cells[12,currentRow] := trainCameras[j].fuserId;
            ExcelGrid.Cells[13,currentRow] := trainCameras[j].fuserPwd;
            Inc(currentRow);
          end;
        end;
      end;
      // 엑셀로 저장
      AdvGridExcelIO1.AdvStringGrid := ExcelGrid;
      AdvGridExcelIO1.XLSExport(SaveDialog.FileName);
      ShowTVCSMessage('엑셀 파일이 저장되었습니다.');
    end;
  finally
    SaveDialog.Free;
    ExcelGrid.Free;
  end;
end;

procedure TfrmTrain.btnUploadTrainCamerasClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  actualRowCount, i, j: Integer;
  hasEmptyCells: Boolean;
  emptyCellRows: string;
  requiredColumnsFilled, anyOptionalColumnFilled: Boolean;
begin
  if ShowTVCSCheck(mcExcelUpload) then
  begin
    OpenDialog := TOpenDialog.Create(nil);
    try
      OpenDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls|All Files (*.*)|*.*';
      OpenDialog.FilterIndex := 2;
      if OpenDialog.Execute then
      begin

        GridBuf := TAdvStringGrid.Create(self);
        AdvGridExcelIO1.AdvStringGrid := GridBuf;
        AdvGridExcelIO1.XLSImport(OpenDialog.FileName, 0);

        // 실제 데이터가 있는 행 수 계산
        actualRowCount := 1; // 헤더 행은 항상 포함
        hasEmptyCells := False;
        emptyCellRows := '';

        for i := 1 to GridBuf.RowCount - 1 do
        begin
          // 행이 완전히 비어있는지 확인
          var rowIsEmpty := True;
          for j := 0 to GridBuf.ColCount - 1 do
          begin
            if Trim(GridBuf.Cells[j, i]) <> '' then
            begin
              rowIsEmpty := False;
              Break;
            end;
          end;

          if rowIsEmpty then
          begin
            // 완전히 빈 행을 만나면 종료
            Break;
          end
          else
          begin
            // 필수 항목(편성번호, 열차번호, 객차수, 카메라수, TVCSIP) 확인
            requiredColumnsFilled := True;
            for j := 1 to 5 do // 필수 열 인덱스 0~4
            begin
              if Trim(GridBuf.Cells[j, i]) = '' then
              begin
                requiredColumnsFilled := False;
                Break;
              end;
            end;

            // 선택 항목이 하나라도 있는지 확인
            anyOptionalColumnFilled := False;
            for j := 6 to GridBuf.ColCount - 1 do // 선택 열 인덱스 5~마지막
            begin
              if Trim(GridBuf.Cells[j, i]) <> '' then
              begin
                anyOptionalColumnFilled := True;
                Break;
              end;
            end;

            // 필수 항목이 모두 채워져 있고, 선택 항목 중 하나라도 있는데 모두 채워져 있지 않은 경우
            if requiredColumnsFilled and anyOptionalColumnFilled then
            begin
              // 선택 항목이 모두 채워져 있는지 확인
              var allOptionalColumnsFilled := True;
              for j := 6 to GridBuf.ColCount - 1 do
              begin
                if Trim(GridBuf.Cells[j, i]) = '' then
                begin
                  allOptionalColumnsFilled := False;
                  Break;
                end;
              end;

              if not allOptionalColumnsFilled then
              begin
                hasEmptyCells := True;
                if emptyCellRows <> '' then
                  emptyCellRows := emptyCellRows + ', ';
                emptyCellRows := emptyCellRows + IntToStr(i+1); // 엑셀 행 번호는 1부터 시작
              end;
            end;

            Inc(actualRowCount);
          end;
        end;

        // 실제 사용할 행 수로 그리드 크기 조정
        GridBuf.RowCount := actualRowCount;

        if hasEmptyCells then
        begin
          ShowTVCSMessage('입력되지 않은 항목이 있습니다. 엑셀데이터의 다음 행을 확인하세요: ' + emptyCellRows);
        end
        else
        begin
          ShowMessage('로드된 데이터 행 수: ' + IntToStr(actualRowCount));
        end;
      end;
    finally
      OpenDialog.Free;
      //LoadTrainList;
    end;
  end;
end;


procedure TfrmTrain.edNvrRTSPEnter(Sender: TObject);
begin
        HideValidator(edNvrRTSP);
end;

procedure TfrmTrain.edNvrRTSPExit(Sender: TObject);
begin
        if (edNvrRTSP.IPAddress='0.0.0.0') then ShowValidator(edNvrRTSP,'유효하지 않은 주소',ValidTooltip);
end;

procedure TfrmTrain.edscNoEnter(Sender: TObject);
begin
       HideValidator(edscNo);

end;

procedure TfrmTrain.edscNoExit(Sender: TObject);
var
 selCount,i,selRow:Integer;
begin
selCount:=grdTrains.SelectedRowCount;
if (selCount<>1) then  Exit;
if (Trim(edscNo.Text)='') then ShowValidator(edscNo,'편성번호를 입력',ValidToolTip);
selRow:=grdTRains.SelectedRow[0];

if (grdTrains.Cells[1,selRow]<>Trim(edscNo.Text)) then grdTrains.Cells[1,selRow]:=edscNo.Text;











//grdTrains.Cells[1,1]:=edscNo.Text;
//edScNo.Color:=clWhite;
end;

procedure TfrmTrain.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearchClick(Sender);
end;

procedure TfrmTrain.edTrainNoEnter(Sender: TObject);
begin
  //edTrainNo.Color:=clyellow;
//  edTrainNo.StyleElements:=[seBorder];
  HideValidator(edTrainNo);
end;

procedure TfrmTrain.edTrainNoExit(Sender: TObject);
var
 selCount,i,selRow:Integer;
begin
selCount:=grdTrains.SelectedRowCount;
if (selCount<>1) then  Exit;
//if (grdTrains.SelectedRow[1] and grdTrains.Cells[1,1]='') then
//  grdTrains.Cells[1,1]:=edTrainNo.Text;
  //edTrainNo.StyleElements:=[seBorder,seFont,seClient];

    if (edTrainNo.Text='') then ShowValidator(edTrainNo,'열차번호를  입력.',ValidTooltip);
    selRow:=grdTRains.SelectedRow[0];
    if (grdTrains.Cells[2,selRow]<>Trim(edTrainNo.Text)) then grdTrains.Cells[2,selRow]:=edTrainNo.Text;

end;

procedure TfrmTrain.FormCreate(Sender: TObject);
begin

  
  LoadTrainList;
  SetTrainCamListHeader;

  //버튼
  TButtonStyler.ApplyGlobalStyle(Self);

  grdTrains.OnClickCell := grdTrainsClickCell;
  lblTitle.Caption := '편성 카메라 관리 ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'호선)';
  isNeedUpdate:=false;
  grdTrainsClickCell(Sender,1,1); //첫번째 셀 선택
  grdTrains.SelectRows(1,1);



end;

procedure TfrmTrain.UpdateTrainList(camCount:Integer);
var
  trainPos: TVCSTrainInPost;
  trainPat: TVCSTrainInPatch;
  trainRes: tvcsProtocol.TVCSTrain;
begin
  try
        trainPat := TVCSTrainInPatch.Create;
        trainPat.fid := SelTrain.fid;

        trainPat.fformatNo := StrtoInt(edscNo.Text);
        trainPat.fcarriageNum := StrtoInt(cmbTrainCnt.Text);
        trainPat.fcameraNum :=camCount;
        trainPat.ftvcsIpaddr := edNvrRTSP.Text;
        trainRes := gapi.UpdateTrain(trainPat);
        if trainRes = nil then
        begin
          ShowTVCSMessage('열차정보 수정이 실패하였습니다.');
          Exit;
        end;

  finally
     FreeAndNil(trainPat);
  end;

end;

procedure TfrmTrain.AddTrainsList;
var
  trainPos: TVCSTrainInPost;
  trainPat: TVCSTrainInPatch;
  trainRes: tvcsProtocol.TVCSTrain;

begin

  try
   if (not Validator) then begin
      ShowTVCSMessage('잘못된 값이 있습니다. 확인해주세요');
      Exit;
   end;

    trainPos := TVCSTrainInPost.Create;
    trainPos.ftrainNo := edTrainNo.Text;
    trainPos.fformatNo := StrtoInt(edscNo.Text);
    trainPos.fcarriageNum := StrToInt(cmbTrainCnt.Text);
    trainPos.fcameraNum  :=0;
    trainPos.ftvcsIpaddr := edNvrRTSP.text;
    trainRes := gapi.AddTrain(trainPos);
    if trainRes = nil then
    begin
      ShowTVCSMessage('열차정보 추가가 실패하였습니다.');
      Exit;
    end;
  finally
    if(trainPos<>nil) then
      FreeAndNil(trainPos);
  end;


end;


procedure TfrmTrain.LoadTrainList(trainNo: string='');
var
  size, i, k: integer;
  delBtn: TButton;
  uniqueValues: TStringList;
  uniqueCount: integer;
begin

  trains := gapi.GetTrain(-1);
  size := Length(trains);
  lblTotal.Caption := '총 :' + IntToStr(size) +'개';
  delBtn := TButton.Create(self);
  delBtn.Caption := '삭제';

  with grdTrains do
  begin
    RowCount :=1;
    ColCount:=9;         //include hidden cell
    ColWidths[0]:=60;
    ColWidths[1]:=90;
    ColWidths[2]:=90;
    ColWidths[3]:=60;

    Cells[0,0]:='No.';
    Cells[1,0]:='편성번호';
    Cells[2,0]:='열차번호';
    Cells[3,0]:='삭제';
    for I := 4 to 8  do begin
      HideColumn(i);
    end;
  end;

  for i := 0 to size -1 do
  with grdTrains do
  begin
    AddRow;
    Cells[0,i+1] := inttostr(i+1);
    Cells[1,i+1] := inttostr(trains[i].fformatNo);
    Cells[2,i+1] := trains[i].ftrainNo;
    AddImageIdx(3, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

    //hidden cell 정보관리
    Cells[4,i+1]:=IntTostr(trains[i].fid);
    Cells[5,i+1]:=IntTostr(trains[i].fcarriageNum);
    Cells[6,i+1]:=IntTostr(trains[i].fcameraNum);
    Cells[7,i+1]:=trains[i].ftvcsIpaddr;
    Cells[8,i+1]:='old';
  end;


end;


procedure TfrmTrain.SetTrainCamListHeader;
var
 i:Integer;
begin

  with grdTrainCams do
  begin
    RowCount:=1;
    ColCount:=13;
    //760
    ColWidths[0] := 60;   // 객차번호
    ColWidths[1] := 40;  // 호위치
    ColWidths[2] := 90;  // 카메라이름
    ColWidths[3] := 100;   // IP
    ColWidths[4] := 40;  // Port
    ColWidths[5] := 150;  // RTSP High

    ColWidths[6] := 150;  // RTSP Low
    ColWidths[7] := 65;   // Password
    ColWidths[8] := 82;   // 미리보기 버튼
    ColWidths[9] := 65;   // 삭제 버튼
    ColWidths[10] := 45;

    Cells[0,0]:='열차번호';
    Cells[1,0]:='위치';

    Cells[2,0]:='카메라명';
    Cells[3,0]:='IP Addr';
    Cells[4,0]:= 'Port';
    Cells[5,0]:='RTSP 주소1 ';
    Cells[6,0]:='RTSP 주소2 ';

    Cells[7,0]:='ID';
    Cells[8,0]:='Password';
    Cells[9,0]:='미리보기';
    Cells[10,0]:='삭제';

    FixedRows := 0;
    FixedCols := 0;


    for i := 0 to 8 do
      begin
        ReadOnly[i,0] := True;
      end;

    HideColumn(3);HideColumn(4);
    for i:=11 to 12 do HideColumn(i);

  end;


end;


procedure TfrmTrain.LoadTrainCamList(trainId: Integer =-1);
var
  i, j, count: integer;
  filteredCams: TArray<TVCSTrainCamera>;

begin
  //
  lblCamCnt.Caption := '총:0개';

  grdTrainCams.RowCount:=1;

  if trainId <> -1 then
  begin
    trainCams := Gapi.GetTrainCamera(trainId);
    count := length(trainCams);
    lblCamCnt.Caption := '총:' + IntToStr(count) + '개';

    if count > 0 then
    begin
      for i := 0 to count-1 do
         with grdTrainCams do
         begin
           AddRow;

           Cells[0,i+1] := InttoStr(trainCams[i].ftrainNo);
           Cells[1,i+1] := IntToStr(trainCams[i].fposition);

           Cells[2,i+1] := trainCams[i].fname;
           Cells[3,i+1] := trainCams[i].fipaddr;
           Cells[4,i+1] := IntToStr(trainCams[i].fport);
           Cells[5,i+1] := trainCams[i].frtsp;
           Cells[6,i+1] := trainCams[i].frtsp2;

           Cells[7,i+1] := trainCams[i].fuserId;
           Cells[8,i+1] := trainCams[i].fuserPwd;

           AddImageIdx(9, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
           AddImageIdx(10, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
           //hidden cell
           Cells[11,i+1]:=IntToStr(trainCams[i].fid);
           Cells[12,i+1]:=trainCams[i].ftvcsRtsp;

         end;

    end;
    grdTrainCams.SelectRows(1,1);
  end;

end;

//열차 선택/삭제
procedure TfrmTrain.grdTrainsCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  // 새로 삽입된 cell만
  if (grdTrains.cells[8,Arow]='new') then CanEdit:=true else canEdit:=false;
end;

procedure TfrmTrain.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  fid : integer;

//  isNewRow: Boolean;
begin
//
{  if ARow = 0 then
  begin
    edscNo.Text := '';
    cmbTrainCnt.ItemIndex:=2;
    //edTrainCnt.Text := '';
    edTrainNo.Text := '';
    edNvrRTSP.IPAddress := '0.0.0.0';

    edscNo.Enabled := False;
//    edTrainCnt.Enabled := False;
    cmbTrainCnt.Enabled:=false;
    edTrainNo.Enabled := False;
    edNvrRTSP.Enabled := False;
    btnAddCams.Enabled := False;

    LoadTrainCamList();
    Exit;
  end;
 }

  edscNo.Enabled := true;
  cmbTrainCnt.Enabled:=true;
  edTrainNo.Enabled := true;
  edNvrRTSP.Enabled := true;
  btnAddCams.Enabled := true;

// if(ARow=0) then grdTrains.UnSelectRows(0,1);





  if ARow > 0 then
  begin
      grdTrains.SelectRows(ARow,1);
      if Acol =3 then
      begin

        try
        if ShowTVCSCheck(mcDelete) then
          begin
          // 삭제
            gapi.DeleteTrain(StrToInt(grdTrains.Cells[4,Arow]));
            grdTrains.RemoveRows(ARow, 1);
            ShowTVCSMessage('삭제 되었습니다. ');
            grdTrainsClickCell(Sender,1,1);
          end;
        finally

        end;

      end else
      begin
          fid :=strToInt(grdTrains.Cells[4,Arow]); // 편성열차이 fid
          edscNo.Text := grdTrains.Cells[1,Arow];
          if (edscNo.Text<>'') then HideValidator(edscNo);

          edTrainNo.Text := grdTrains.Cells[2,Arow];
          if (edscNo.Text<>'') then HideValidator(edscNo);

          cmbTrainCnt.Text := grdTrains.Cells[5,Arow];
          if (cmbTrainCnt.Text<>'') then HideValidator(cmbTrainCnt);

          edNvrRTSP.IPAddress:= grdTrains.Cells[7,Arow];
          if (edNvrRTSP.Text<>'0.0.0.0') then HideValidator(edNvrRTSP);

          LoadTrainCamList(fid);
      end;
  end;

end;

procedure TfrmTrain.grdTrainsEditCellDone(Sender: TObject; ACol, ARow: Integer);
begin
if (ACol=1) then
  edscNo.Text:=grdTrains.Cells[aCol,Arow];
if (ACol=2) then
  edTrainNo.Text:=grdTrains.Cells[aCol,Arow];
end;

procedure TfrmTrain.grdTrainsEditChange(Sender: TObject; ACol, ARow: Integer;
  Value: string);
begin
if (ACol=1) then edscNo.Text:=Value
else if (Acol=2) then edTrainNo.Text:=Value;

end;

procedure TfrmTrain.grdTrainsSelectCell(Sender: TObject; ACol, ARow: LongInt;
  var CanSelect: Boolean);
begin
if (ARow=0) then CanSelect:=false
else CanSelect:=true;
end;

procedure TfrmTrain.grdTrainCamsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  ShowPreview: TFrmPreview;

begin
//
if ARow > 0 then
  begin
    if ACol = 10 then
      begin
        if ShowTVCSCheck(mcDelete) then
        begin

          gapi.DeleteTrainCamera(StrToInt(grdTrainCams.Cells[ARow,11]));
          grdTrainCams.RemoveRows(ARow, 1);
    //      LoadTrainCamList(SelTrain.fid);
          ShowTVCSMessage('삭제 되었습니다. ');
        end;
      end;

    // 미리보기
    if ACol = 9 then
      begin
        ShowPreview := TfrmPreview.Create(self);
        ShowPreview.SetRtspUrl(grdTrainCams.Cells[ARow,12]);
        //ShowMessage(trainCams[ARow-1 -addTrCnt].ftvcsRtsp);
        //ShowPreview.SetRtspID(trainCams[ARow-1 -addTrCnt].fuserId);
        //ShowPreview.SetRtspPw(trainCams[ARow-1 -addTrCnt].fuserPwd);
        ShowPreview.StartPreview;
        ShowPreview.ShowModal;
      end;
    //ShowMessage('ACol: '+ IntToStr(ACol) +' ARow:' +IntToStr(ARow));

  end;

end;

procedure TfrmTrain.grdTrainCamsGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
if (ACol=8) then AEditor:=edPassword; // 패스워드 ***


end;

procedure TfrmTrain.grdTrainCamsIsPasswordCell(Sender: TObject; ARow,
  ACol: Integer; var IsPassword: Boolean);
begin
if (ARow>0) and (Acol=8) then IsPassword:=true;

end;

end.
