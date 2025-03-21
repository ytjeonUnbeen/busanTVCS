unit TVCSTrain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  TvcsApi, tvcsProtocol, TVCSButtonStyle, TVCSPreview, System.ImageList, Vcl.ImgList, TVCSCheckDialog,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  tmsAdvGridExcel, System.Generics.Collections;

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
    pnCamStationInfo: TPanel;
    pnDefStation: TPanel;
    lbscNo: TLabel;
    lblTrainNo: TLabel;
    edscNo: TEdit;
    edTrainNo: TEdit;
    pnNvrRTSP: TPanel;
    lblNvrRTSP: TLabel;
    edNvrRTSP: TEdit;
    pnCamInfos: TPanel;
    lblCamInfo: TLabel;
    lblCamCnt: TLabel;
    btnAddCams: TAdvGlowButton;
    grdTrains: TAdvStringGrid;
    btnAddTrain: TAdvGlowButton;
    btnStationDownload: TAdvGlowButton;
    btnUploadStations: TAdvGlowButton;
    grdTrainCams: TAdvStringGrid;
    lblTrainCnt: TLabel;
    edTrainCnt: TEdit;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    AdvGridExcelIO1: TAdvGridExcelIO;
    cbSearch: TComboBox;
    edSearchText: TEdit;
    btnSearch: TAdvGlowButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);

    procedure LoadTrainList(trainNo: string='');
    procedure LoadTrainCamList(trainId: Integer =-1);
    procedure FormCreate(Sender: TObject);
    procedure btnAddTrainClick(Sender: TObject);
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);

    procedure btnAddCamsClick(Sender: TObject);
    procedure grdTrainCamsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure btnUploadStationsClick(Sender: TObject);
    procedure btnStationDownloadClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure edOnlyInputNum(Sender: TObject; var Key: Char);


  private
    { Private declarations }
    addTrCnt, addTrCamCnt: integer;
    CheckExcel: Boolean;
    GridBuf: TAdvStringGrid;
    BufTrainCams: TArray<TVCSTrainCamera>;
    trains: TArray<tvcsProtocol.TVCSTrain>;
    trainCams: TArray<TVCSTrainCamera>;
    SelTrain: tvcsProtocol.TVCSTrain;
  public
    { Public declarations }
  end;

var
  frmTrain: TfrmTrain;

implementation

{$R *.dfm}

procedure TfrmTrain.btnAddCamsClick(Sender: TObject);
begin
  addTrCamCnt := addTrCamCnt +1;
  with grdTrainCams do
  begin
    InsertChildRow(0);
    Cells[0,1] := edTrainNo.Text;
    Cells[1,1] := '0';  // position의 기본값 설정
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
//
  addTrCnt := addTrCnt + 1;
  with grdTrains do
  begin
    InsertChildRow(0);
    Cells[0,1] := '0';
    Cells[1,1] := 'NULL';
    Cells[2,1] := 'NULL';
    AddImageIdx(3, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
    SelectCells(0,1,0,1);
    FocusCell(1,1);
    TopRow := 0;
  end;

  edscNo.Enabled := true;
  edTrainCnt.Enabled := true;
  edTrainNo.Enabled := true;
  edNvrRTSP.Enabled := true;
  btnAddCams.Enabled := true;

  edscNo.Text := '';
  edTrainNo.Text := '';
  edTrainCnt.Text := '';
  edNvrRTSP.text := '';
  edscNo.SetFocus;
  LoadTrainCamList;
end;

procedure TfrmTrain.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmTrain.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmTrain.btnSaveClick(Sender: TObject);
var
  trainPos: TVCSTrainInPost;
  trainPat: TVCSTrainInPatch;
  trainRes: tvcsProtocol.TVCSTrain;
  trainCamPos: TArray<TVCSTrainCameraInPost>;
  trainCamPatch: TVCSTrainCameraInPatch;
  trainCamRes: TVCSTrainCamera;
  allSuccess, isModified: Boolean;
  existingTrains: TArray<tvcsProtocol.TVCSTrain>;
  existingCams: TArray<TVCSTrainCamera>;
  i, j, size: integer;
  trainIdMap: TDictionary<String, Integer>;
begin
  if ShowTVCSCheck(0) then
  begin


    if CheckExcel then
    begin
      allSuccess := True;

      try
        // 1. 기존 데이터 삭제
        existingTrains := gapi.GetTrain(-1);
        for i := 0 to Length(existingTrains)-1 do
        begin
          // 각 열차의 카메라 정보 삭제
          existingCams := gapi.GetTrainCamera(existingTrains[i].fid);
          for j := 0 to Length(existingCams)-1 do
          begin
            if gapi.DeleteTrainCamera(existingCams[j].fid) = '' then
            begin
              allSuccess := False;
              ShowTVCSMessage('카메라 정보 삭제 중 오류가 발생했습니다.');
              Exit;
            end;
          end;

          // 열차 정보 삭제
          if gapi.DeleteTrain(existingTrains[i].fid) = '' then
          begin
            allSuccess := False;
            ShowTVCSMessage('열차 정보 삭제 중 오류가 발생했습니다.');
            Exit;
          end;
        end;

        // 2. 엑셀 데이터 추가
        // 2-1. 열차 정보 추
         trainIdMap := TDictionary<String, Integer>.Create;
         for i := 0 to Length(trains)-1 do
         begin
           trainPos := TVCSTrainInPost.Create;
           try
             trainPos.ftrainNo := trains[i].ftrainNo;
             trainPos.fformatNo := trains[i].fformatNo;
             trainPos.fcarriageNum := trains[i].fcarriageNum;
             trainPos.ftvcsIpaddr := trains[i].ftvcsIpaddr;
             trainRes := gapi.AddTrain(trainPos);
             if trainRes = nil then
             begin
               allSuccess := False;
               ShowTVCSMessage(Format('열차 정보 추가 중 오류가 발생했습니다. (열차번호: %s)', [trains[i].ftrainNo]));
               Exit;
             end;
           finally
             FreeAndNil(trainPos);
           end;
         end;

        // 2-3. 카메라 정보 추가
         SetLength(trainCamPos, Length(BufTrainCams));
         try
           for i := 0 to Length(BufTrainCams)-1 do
           begin
             trainCamPos[i] := TVCSTrainCameraInPost.Create;
             with trainCamPos[i] do
             begin
               ftrainNo := IntToStr(BufTrainCams[i].ftrainNo);
               fposition := BufTrainCams[i].fposition;
               fname := BufTrainCams[i].fname;
               fipaddr := BufTrainCams[i].fipaddr;
               fport := BufTrainCams[i].fport;
               frtsp := BufTrainCams[i].frtsp;
               frtsp2 := BufTrainCams[i].frtsp2;
               fuserId := BufTrainCams[i].fuserId;
               fuserPwd := BufTrainCams[i].fuserPwd;
             end;

             trainCamRes := gapi.AddTrainCamera(trainCamPos[i]);
             if trainCamRes = nil then
             begin
               allSuccess := False;
               ShowTVCSMessage(Format('카메라 정보 추가 중 오류가 발생했습니다. (열차번호: %s, 카메라명: %s)',
                 [BufTrainCams[i].ftrainNo, BufTrainCams[i].fname]));
               Exit;
             end;
           end;
         finally
           for i := 0 to Length(trainCamPos)-1 do
           begin
             if Assigned(trainCamPos[i]) then
               FreeAndNil(trainCamPos[i]);
           end;
         end;

        if allSuccess then
        begin
          ShowTVCSMessage('엑셀 데이터 업로드가 완료되었습니다.');
          CheckExcel := False;
          LoadTrainList;
          
        end;
      except
        on E: Exception do
          ShowTVCSMessage('처리 중 오류가 발생했습니다: ' + E.Message);
      end;
    end
    else
    begin

    if (edscNo.Text = '') and (edTrainNo.Text = '') and (edTrainCnt.Text = '') and (edTrainCnt.Text = '') then
            begin
              ShowTVCSMessage('수정할 정보가 없습니다.');
              Exit;
            end;

    if (edscNo.Text = '') then
    begin
      ShowTVCSMessage('편성번호를 입력해주세요.');
      Exit;
    end;
    if (edTrainNo.Text = '') then
    begin
      ShowTVCSMessage('열차번호를 입력해주세요.');
      Exit;
    end;
    if (edTrainCnt.Text = '') then
    begin
      ShowTVCSMessage('차량객차 수를 입력해주세요.');
      Exit;
    end;
    if (edNvrRTSP.Text = '') then
    begin
      ShowTVCSMessage('TVCS 주소를 입력해주세요.');
      Exit;
    end;


      size := grdTrainCams.RowCount - 1;
    trainPos := TVCSTrainInPost.Create;
    //ShowTVCSMessage(inttostr(size));

    try
      allSuccess := True;

      // 열차추가
      if addTrCnt > 0 then
      begin

        trainPos.ftrainNo := edTrainNo.Text;
        trainPos.fformatNo := StrtoInt(edscNo.Text);
        trainPos.fcarriageNum := StrToInt(edTrainCnt.Text);
        trainPos.fcameraNum  := size;
        trainPos.ftvcsIpaddr := edNvrRTSP.text;
        trainRes := gapi.AddTrain(trainPos);
        if trainRes = nil then
        begin
          ShowTVCSMessage('열차정보 추가가 실패하였습니다.');
          Exit;
        end;
      end
      // 열차수정
      else
      begin
        trainPat := TVCSTrainInPatch.Create;
        trainPat.fid := SelTrain.fid;
        trainPat.ftrainNo := edTrainNo.Text;
        trainPat.fformatNo := StrtoInt(edscNo.Text);
        trainPat.fcarriageNum := StrtoInt(edTrainCnt.Text);
        trainPat.fcameraNum := size;
        trainPat.ftvcsIpaddr := edNvrRTSP.Text;
        trainRes := gapi.UpdateTrain(trainPat);
        if trainRes = nil then
        begin
          ShowTVCSMessage('열차정보 수정이 실패하였습니다.');
          Exit;
        end;
      end;

      // 열차캠추
      if addTrCamCnt > 0 then
      begin
        SetLength(trainCamPos, addTrCamCnt);

        for i := 1 to addTrCamCnt do
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
      end;


        for i := 1 to grdTrainCams.RowCount - 1 do
        begin
          isModified := False;

          if i <= addTrCamCnt then
            Continue;

          j := i - addTrCamCnt - 1;
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

        if allSuccess then
          begin
            ShowTVCSMessage('처리가 완료되었습니다.');
            LoadTrainList;
          end
        else
          ShowTVCSMessage('일부 처리가 실패하였습니다.');

        addTrCnt := 0;


      finally
        FreeAndNil(trainPos);
      end;

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
      2: // 역사명 검색
         if grdTrains.Cells[2,i] = searchText then
        begin
          grdTrains.SelectCells(2,i,2,i);
          grdTrainsClickCell(grdTrains, i, 2);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('검색 결과가 없습니다.');
end;

procedure TfrmTrain.btnStationDownloadClick(Sender: TObject);
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
    SaveDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls';
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

        // 각 카메라별로 row 추가
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

procedure TfrmTrain.btnUploadStationsClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  if ShowTVCSCheck(2) then
  begin
    OpenDialog := TOpenDialog.Create(nil);
    try
      OpenDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls|All Files (*.*)|*.*';
      OpenDialog.FilterIndex := 2;

      if OpenDialog.Execute then
      begin
        CheckExcel := True;
        GridBuf := TAdvStringGrid.Create(self);
        AdvGridExcelIO1.AdvStringGrid := GridBuf;
        AdvGridExcelIO1.XLSImport(OpenDialog.FileName, 0);
      end;
    finally
      OpenDialog.Free;
      LoadTrainList;
    end;
  end;
end;


procedure TfrmTrain.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearchClick(Sender);
end;

procedure TfrmTrain.FormCreate(Sender: TObject);
begin

  addTrCnt := 0;
  addTrCamCnt := 0;

  LoadTrainList;
  LoadTrainCamList;

  //버튼
  TButtonStyler.ApplyGlobalStyle(Self);

  grdTrains.OnClickCell := grdTrainsClickCell;
  lblTitle.Caption := '열차 정보 관리 ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'호선)'

end;

procedure TfrmTrain.LoadTrainList(trainNo: string='');
var
  size, i, k: integer;
  delBtn: TButton;
  uniqueValues: TStringList;
  uniqueCount: integer;
begin
  if CheckExcel then
  begin
    uniqueValues := TStringList.Create;
    try
      uniqueValues.Sorted := True;
      uniqueValues.Duplicates := dupIgnore;
      for i := 2 to GridBuf.RowCount do
      begin
        if GridBuf.Cells[1, i].Trim <> '' then
          uniqueValues.Add(GridBuf.Cells[2, i]);
      end;

      uniqueCount := uniqueValues.Count;
      SetLength(trains, uniqueCount);

      for i := 0 to uniqueCount - 1 do
      begin
        trains[i] := tvcsProtocol.TVCSTrain.Create;
        trains[i].ftrainNo := uniqueValues[i];

        // GridBuf에서 해당 열차의 정보 찾기 (마지막 데이터)
        for k := GridBuf.RowCount downto 2 do
        begin
          if GridBuf.Cells[2, k] = trains[i].ftrainNo then
          begin
            trains[i].fformatNo := StrToInt(GridBuf.Cells[1, k]);
            trains[i].fcarriageNum := StrToInt(GridBuf.Cells[3, k]);
            trains[i].fcameraNum := StrToInt(GridBuf.Cells[4, k]);
            trains[i].ftvcsIpaddr := GridBuf.Cells[5, k];

            Break;
          end;
        end;
      end;
    finally
      uniqueValues.Free;
    end;
  end
  else
  begin
    trains := gapi.GetTrain(-1);
  end;

  size := Length(trains);
  lblTotal.Caption := '총 :' + IntToStr(size) +'개';
  delBtn := TButton.Create(self);
  delBtn.Caption := '삭제';

  with grdTrains do
  begin
    RowCount :=1;
    ColCount:=4;
    ColWidths[0]:=60;
    ColWidths[1]:=90;
    ColWidths[2]:=90;
    ColWidths[3]:=60;

    Cells[0,0]:='No.';
    Cells[1,0]:='편성번호';
    Cells[2,0]:='열차번호';
    Cells[3,0]:='삭제';
  end;

  for i := 0 to size -1 do
  with grdTrains do
  begin
    AddRow;
    Cells[0,i+1] := inttostr(i+1);
    Cells[1,i+1] := inttostr(trains[i].fformatNo);
    Cells[2,i+1] := trains[i].ftrainNo;
    AddImageIdx(3, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);


  end;


end;

procedure TfrmTrain.LoadTrainCamList(trainId: Integer =-1);
var
  i, j, size: integer;
  filteredCams: TArray<TVCSTrainCamera>;

begin
  //
  with grdTrainCams do
  begin
    RowCount:=1;
    ColCount:=11;
    //760
    ColWidths[0] := 60;   // 객차번호
    ColWidths[1] := 40;  // 호위치
    ColWidths[2] := 90;  // 카메라이름
    ColWidths[3] := 100;   // IP
    ColWidths[4] := 40;  // Port
    ColWidths[5] := 100;  // RTSP High

    ColWidths[6] := 100;  // RTSP Low
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

  end;
  lblCamCnt.Caption := '총:0개';

  //ShowTVCSMessage(intTostr(trainId));
  if trainId <> -1 then
  begin
    if CheckExcel then
    begin
      // 모든 데이터를 BufTrainCams에 저장
      SetLength(BufTrainCams, GridBuf.rowcount - 2);
      for i := 0 to Length(BufTrainCams) - 1 do
      begin
        BufTrainCams[i] := TVCSTrainCamera.Create;
        BufTrainCams[i].ftrainNo := StrToInt(GridBuf.Cells[2,i+2]);
        BufTrainCams[i].fposition := StrToInt(GridBuf.Cells[6,i+2]);
        BufTrainCams[i].fname := GridBuf.Cells[7,i+2];
        BufTrainCams[i].fipaddr := GridBuf.Cells[8,i+2];
        BufTrainCams[i].fport := StrToInt(GridBuf.Cells[9,i+2]);
        BufTrainCams[i].frtsp := GridBuf.Cells[10,i+2];
        BufTrainCams[i].frtsp2 := GridBuf.Cells[11,i+2];
        BufTrainCams[i].fuserId := GridBuf.Cells[12,i+2];
        BufTrainCams[i].fuserPwd := GridBuf.Cells[13,i+2];
      end;

      // trainId에 해당하는 카메라만 필터링
      j := 0;
      SetLength(filteredCams, 0);
      for i := 0 to Length(BufTrainCams) - 1 do
      begin
        if BufTrainCams[i].ftrainNo = trainId then
        begin
          SetLength(filteredCams, Length(filteredCams) + 1);
          filteredCams[j] := BufTrainCams[i];
          Inc(j);
        end;
      end;

      trainCams := filteredCams;
    end
    else
    begin
      trainCams := Gapi.GetTrainCamera(trainId);
    end;

    size := length(trainCams);
    lblCamCnt.Caption := '총:' + IntToStr(size) + '개';

    if size > 0 then
    begin
      for i := 0 to size-1 do
       with grdTrainCams do
       begin
         AddRow;

         Cells[0,i+1] := SelTrain.ftrainNo;
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

       end;

    end;
  end;
end;

//열차 선택/삭제
procedure TfrmTrain.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  ftrainNo : integer;
  isNewRow: Boolean;
begin
//
  if ARow = 0 then
  begin
    edscNo.Text := '';
    edTrainCnt.Text := '';
    edTrainNo.Text := '';
    edNvrRTSP.Text := '';

    edscNo.Enabled := False;
    edTrainCnt.Enabled := False;
    edTrainNo.Enabled := False;
    edNvrRTSP.Enabled := False;
    btnAddCams.Enabled := False;

    LoadTrainCamList();
    Exit;
  end;

  isNewRow := (ARow <= addTrCnt);

  edscNo.Enabled := true;
  edTrainCnt.Enabled := true;
  edTrainNo.Enabled := true;
  edNvrRTSP.Enabled := true;
  btnAddCams.Enabled := true;

  if ARow > 0 then
  begin
      if Acol =3 then
      begin
        try
        if ShowTVCSCheck(1) then
          begin
          // 삭제
            if ARow-1 -addTrCnt >= 0  then
              gapi.DeleteTrain(trains[ARow-1 -addTrCnt].fid);

            grdTrains.RemoveRows(ARow, 1);
            edscNo.Text := '';
            edTrainNo.Text := '';
            edTrainCnt.Text := '';
            edNvrRTSP.Text := '';
            ShowTVCSMessage('삭제 되었습니다. ');
            LoadTrainList;
          end;

        finally

        end;

      end else
      begin
        try
          SelTrain := trains[ARow - 1 - addTrCnt];
          ftrainNo := SelTrain.fid;
          edscNo.Text := IntToStr(SelTrain.fformatNo);
          edTrainNo.Text := SelTrain.ftrainNo;
          edTrainCnt.Text := IntToStr(SelTrain.fcarriageNum);
          edNvrRTSP.text := SelTrain.ftvcsIpaddr;

          if CheckExcel then
            LoadTrainCamList(StrToInt(SelTrain.ftrainNo))
          else
            LoadTrainCamList(ftrainNo);


        except
          edscNo.Text := '';
          edTrainNo.Text := '';
          edTrainCnt.Text := '';
          edNvrRTSP.text := '';
          LoadTrainCamList;

        end;
      end;
  end;

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
        if ShowTVCSCheck(1) then
        begin
          gapi.DeleteTrainCamera(trainCams[ARow-1 -addTrCnt].fid);
          grdTrainCams.RemoveRows(ARow, 1);
          LoadTrainCamList(SelTrain.fid);
          addTrCamCnt := 0;
          ShowTVCSMessage('삭제 되었습니다. ');
        end;
      end;

    // 미리보기
    if ACol = 9 then
      begin
        ShowPreview := TfrmPreview.Create(self);
        ShowPreview.SetRtspUrl(trainCams[ARow-1 -addTrCnt].frtsp);
        ShowPreview.SetRtspID(trainCams[ARow-1 -addTrCnt].fuserId);
        ShowPreview.SetRtspPw(trainCams[ARow-1 -addTrCnt].fuserPwd);
        ShowPreview.StartPreview;
        ShowPreview.ShowModal;
      end;
    //ShowMessage('ACol: '+ IntToStr(ACol) +' ARow:' +IntToStr(ARow));

  end;

end;

procedure TfrmTrain.edOnlyInputNum(Sender: TObject; var Key: Char);
begin
  // 숫자나 백스페이스가 아닌 경우
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;  // 입력 취소
    ShowTVCSMessage('숫자만 입력가능합니다.');
  end;
end;

end.
