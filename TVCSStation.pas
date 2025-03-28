unit TVCSStation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, AdvListV,
  AdvGlowButton, Vcl.ExtCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  System.ImageList, Vcl.ImgList ,tvcsAPI, tvcsProtocol, TVCSCheckDialog, TVCSPreview,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList, TVCSButtonStyle,
  AdvStyleIF, AdvAppStyler, tmsAdvGridExcel, AdvEdit, AdvGroupBox,
  AdvOfficeButtons, ToolPanels, AdvOfficeTabSet; //, tmsAdvGridExcel;

type
  TfrmStation = class(TForm)
    cbSearch: TComboBox;
    edSearchText: TEdit;
    btnSearch: TAdvGlowButton;
    btnAddStation: TAdvGlowButton;
    pnCamStationInfo: TPanel;
    edStname: TEdit;
    edupLeavTcode: TEdit;
    edupArrvTcode: TEdit;
    btnAddCams: TAdvGlowButton;
    btnUploadStations: TAdvGlowButton;
    btnStationDownload: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    lblTitle: TLabel;
    pnDefStation: TPanel;
    pnT1Delay: TPanel;
    pnCamInfos: TPanel;
    lblTotal: TLabel;
    lblstCode: TLabel;
    lblStname: TLabel;
    lblT1UpDep: TLabel;
    lblT1UpArr: TLabel;
    lblT1DownArr: TLabel;
    lblInfoTitle: TLabel;
    lbStCamCnt: TLabel;
    pnBottom: TPanel;
    pnMainFrame: TPanel;
    grdStations: TAdvStringGrid;
    grdStationCams: TAdvStringGrid;
    ImageList1: TImageList;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    AdvFormStyler1: TAdvFormStyler;
    AdvAppStyler1: TAdvAppStyler;
    Label1: TLabel;
    edupApprTcode: TEdit;
    btnSave: TAdvGlowButton;
    edStcode: TEdit;
    Label2: TLabel;
    AdvGridExcelIO1: TAdvGridExcelIO;
    AdvOfficeTabSet1: TAdvOfficeTabSet;
    pnUp: TPanel;
    Label7: TLabel;
    pnDn: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    eddnLeavTcode: TEdit;
    eddnDepartDelay: TEdit;
    eddnArrvTcode: TEdit;
    eddnApprTcode: TEdit;
    eddnRtsp: TEdit;
    AdvOfficeRadioGroup2: TAdvOfficeRadioGroup;
    AdvOfficeRadioGroup1: TAdvOfficeRadioGroup;
    edupRtsp: TEdit;
    edupDepartDelay: TEdit;


    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnAddStationClick(Sender: TObject);
    procedure btnAddCamsClick(Sender: TObject);
    procedure grdStationCamsHasComboBox(Sender: TObject; ACol, ARow: Integer;
  var HasComboBox: Boolean);
    procedure grdStationCamsGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
    procedure grdStationCamsGetEditorProp(Sender: TObject; ACol, ARow: Integer;
  AEditLink: TEditLink);
    procedure FormDestroy(Sender: TObject);
    procedure btnUploadStationsClick(Sender: TObject);
    procedure btnStationDownloadClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure edStcodeKeyPress(Sender: TObject; var Key: Char);
    procedure edStcodeChange(Sender: TObject);
    procedure edStnameChange(Sender: TObject);
    procedure lblT1UpDepClick(Sender: TObject);
    procedure AdvOfficeTabSet1Change(Sender: TObject);
    procedure grdStationsEditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    

  private
    //fapi:TTVCSAPI;

    addStCnt: integer;
    addCamCnt: integer;
    //엑셀업로드 체크용
    CheckExcel: Boolean;
    GridBuf: TAdvStringGrid;
    BufstationCams : TArray<TVCSStationCamera>;

    SelectStation : tvcsProtocol.TvcsStation;
    stations : TArray<tvcsProtocol.TvcsStation>;

    stationCam : TVCSStationCamera;
    stationCams : TArray<TVCSStationCamera>;
    staionAdd: TvcsStationInPost;
    Procedure LoadStationInfoList;
    Procedure LoadCamInfoList(stationCode: string = '');
    Procedure grdStationsClickCell(Sender: TObject; ARow, ACol: Integer);
    Procedure grdStationsCamsClickCell(Sender: TObject; ARow, ACol: Integer);



  public
    { Public declarations }

  published
    //property api:ttvcsAPI read Fapi write Fapi;

  end;

var
  frmStation: TfrmStation;

implementation

{$R *.dfm}

procedure TfrmStation.AdvOfficeTabSet1Change(Sender: TObject);
begin
  if advofficetabset1.ActiveTabIndex  = 0 then
    begin
      pnUp.Visible := true;
      pnDn.Visible := false;
    end
  else
    begin
      pnUp.Visible := false;
      pnDn.Visible := true;
    end;


end;



procedure TfrmStation.btnAddCamsClick(Sender: TObject);
begin
//



  addCamCnt := addCamCnt + 1;
  with  grdStationCams do
  begin
    InsertChildRow(0);
    Cells[0,1] := '상행';
    Cells[1,1] := '';
    Cells[2,1] := '';
    Cells[3,1] := '80';
    Cells[4,1] := '';
    Cells[5,1] := '';
    Cells[6,1] := '';
    Cells[7,1] := '';
    Cells[8,1] := '';
    AddImageIdx(7, 1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
    AddImageIdx(8, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

  end;
end;

procedure TfrmStation.grdStationCamsHasComboBox(Sender: TObject; ACol, ARow: Integer;
  var HasComboBox: Boolean);
begin
  if (ACol = 0) and (ARow <> 0)then  // 첫번째 열에 콤보박스 표시
    HasComboBox := True;
end;

procedure TfrmStation.grdStationCamsGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
begin
  if (ACol = 0) then
    AEditor := edComboList;
end;

procedure TfrmStation.grdStationCamsGetEditorProp(Sender: TObject; ACol, ARow: Integer;
  AEditLink: TEditLink);
begin
  if (ACol = 0) then
  begin
    with grdStationCams do
    begin
      ClearComboString;
      AddComboString('상행');
      AddComboString('하행');
    end;
  end;
end;

procedure TfrmStation.btnAddStationClick(Sender: TObject);
begin
//ShowMessage('test');
  if addStCnt > 0 then
  begin
    ShowMessage('한번에 하나의 역사만 추가가능합니다.');
    exit;
  end;
  

  staionAdd := TvcsStationInPost.Create;
  addStCnt := addStCnt + 1;
  with grdStations do
  begin
    InsertChildRow(0);
    Cells[0,1] := '0';
    Cells[1,1] := '';
    Cells[2,1] := '';


    AddImageIdx(3, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
    SelectCells(0,1,0,1);
    FocusCell(1,1);
    EditCell(1,1);

    TopRow := 0;

  end;
  //edStcode.Enabled := true;
  //edStName.Enabled := true;
  eddnApprTcode.Enabled := true;
  eddnArrvTcode.Enabled := true;
  eddnDepartDelay.Enabled := true;
  eddnLeavTcode.Enabled := true;
  edupApprTcode.Enabled := true;
  edupArrvTcode.Enabled := true;
  edupDepartDelay.Enabled := true;
  edupLeavTcode.Enabled := true;
  btnAddCams.Enabled := true;

  edupRtsp.Enabled := true;
  eddnRtsp.Enabled := true;
  AdvOfficeRadioGroup1.Enabled := true;
  AdvOfficeRadioGroup2.Enabled := true;


  edStcode.Text := 'NULL';
  edStname.Text := 'NULL';
  edupDepartDelay.Text := '0';
  eddnDepartDelay.Text := '0';
  eddnApprTcode.Text := '';
  edupArrvTcode.Text := '';
  edupLeavTcode.Text := '';

  eddnApprTcode.Text := '';
  eddnArrvTcode.Text := '';
  eddnLeavTcode.Text := '';

  eddnRtsp.text := '';
  edupRtsp.Text := '';

  //edStcode.SetFocus;


  LoadCamInfoList;
end;

procedure TfrmStation.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;


procedure TfrmStation.btnDlgCloseClick(Sender: TObject);
begin
ModalResult:=mrAbort;
end;

// 저장
procedure TfrmStation.btnSaveClick(Sender: TObject);
var
  stationPos: TvcsStationInPost;
  stationPatch: TvcsStationInPatch;
  station: tvcsProtocol.TvcsStation;
  stationCamsPos: TArray<TVCSStationCameraPost>;
  stationCamPatch: TVCSStationCameraPatch;
  stationCam: TVCSStationCamera;
  i, j: Integer;
  allSuccess: Boolean;
  isModified: Boolean;
  existingStations: TArray<tvcsProtocol.TvcsStation>;
  existingCams: TArray<TVCSStationCamera>;
  StationNames: array of string;
  lineInfo: integer;
begin
  if not ShowTVCSCheck(mcModify) then Exit;

  allSuccess := True;
  // 라인정보 설정
  lineInfo := gapi.GetLoinInfo.fsystem.fline;
  case lineInfo of
    2: begin
         SetLength(StationNames, Length(Line2StationName));
         for i := Low(Line2StationName) to High(Line2StationName) do
           StationNames[i] := Line2StationName[i];
       end;
    3: begin
         SetLength(StationNames, Length(Line3StationName));
         for i := Low(Line3StationName) to High(Line3StationName) do
           StationNames[i] := Line3StationName[i];
       end;
    4: begin
         SetLength(StationNames, Length(Line4StationName));
         for i := Low(Line4StationName) to High(Line4StationName) do
           StationNames[i] := Line4StationName[i];
       end;
  end;

  try
    if CheckExcel then
    begin
      // 엑셀 업로드 처리
      try
        // 1. 기존 데이터 삭제
        existingStations := gapi.GetStation('', gapi.GetLoinInfo.fsystem.fline);
        for i := 0 to Length(existingStations)-1 do
        begin
          // 카메라 정보 삭제
          existingCams := gapi.GetStationCamera('');
          for j := 0 to Length(existingCams)-1 do
            if gapi.DeleteStationCamera(existingCams[j].fid) = '' then
            begin
              allSuccess := False;
              ShowTVCSMessage('카메라 정보 삭제 중 오류가 발생했습니다.');
              Exit;
            end;

          // 역사 정보 삭제
          if gapi.DeleteStation(existingStations[i].fcode) = '' then
          begin
            allSuccess := False;
            ShowTVCSMessage('역사 정보 삭제 중 오류가 발생했습니다.');
            Exit;
          end;
        end;

        // 2. 역사 정보 추가
        for i := 0 to Length(stations)-1 do
        begin
          stationPos := TvcsStationInPost.Create;
          try
            stationPos.fname := stations[i].fname;
            stationPos.fcode := stations[i].fcode;
            stationPos.fupDepartDelay := stations[i].fupDepartDelay;
            stationPos.fdnDepartDelay := stations[i].fdnDepartDelay;
            stationPos.fupApprTcode := stations[i].fupApprTcode;
            stationPos.fupArrvTcode := stations[i].fupArrvTcode;
            stationPos.fupLeavTcode := stations[i].fupLeavTcode;
            stationPos.fdnApprTcode := stations[i].fdnApprTcode;
            stationPos.fdnArrvTcode := stations[i].fdnArrvTcode;
            stationPos.fdnLeavTcode := stations[i].fdnLeavTcode;
            stationPos.fprevCode := stations[i].fprevCode;
            stationPos.fnextCode := stations[i].fnextCode;

            station := gapi.AddStation(stationPos);
            if station = nil then
            begin
              allSuccess := False;
              ShowTVCSMessage(Format('역사 정보 추가 중 오류가 발생했습니다. (역사코드: %s)', [stations[i].fcode]));
              Exit;
            end;
          finally
            FreeAndNil(stationPos);
          end;
        end;

        // 3. 카메라 정보 추가
        SetLength(stationCamsPos, Length(BufstationCams));
        try
          for i := 0 to Length(BufstationCams)-1 do
          begin
            stationCamsPos[i] := TVCSStationCameraPost.Create;
            with stationCamsPos[i] do
            begin
              fstationCode := BufstationCams[i].fstationCode;
              fdivision := BufstationCams[i].fdivision;
              fname := BufstationCams[i].fname;
              fipaddr := BufstationCams[i].fipaddr;
              fport := BufstationCams[i].fport;
              frtsp := BufstationCams[i].frtsp;
              frtsp2 := BufstationCams[i].frtsp2;
              fuserId := BufstationCams[i].fuserId;
              fuserPwd := BufstationCams[i].fuserPwd;
            end;

            stationCam := gapi.AddStationCamera(stationCamsPos[i]);
            if stationCam = nil then
            begin
              allSuccess := False;
              ShowTVCSMessage(Format('카메라 정보 추가 중 오류가 발생했습니다. (역사코드: %s, 카메라명: %s)',
                [BufstationCams[i].fstationCode, BufstationCams[i].fname]));
              Exit;
            end;
          end;
        finally
          for i := 0 to Length(stationCamsPos)-1 do
            if Assigned(stationCamsPos[i]) then
              FreeAndNil(stationCamsPos[i]);
        end;
      except
        on E: Exception do
        begin
          allSuccess := False;
          ShowTVCSMessage('처리 중 오류가 발생했습니다: ' + E.Message);
        end;
      end;
    end
    else
    begin
      // 일반 저장 처리
      if (edStcode.Text = '') and (edStname.Text = '') and (addStCnt = 0) then
            begin
              ShowTVCSMessage('수정할 역사 정보가 없습니다.');
              Exit;
            end;

      if (edStcode.Text = '') then
            begin
              ShowTVCSMessage('역 번호를 입력해주세요.');
              Exit;
            end;
            
      if (edStname.Text = '') then
            begin
              ShowTVCSMessage('역사명을 입력해주세요.');
              Exit;
            end;

      

      try
        // 1. 역사 정보 추가 또는 수정
        if addStCnt > 0 then // 추가
        begin
           stationPos := TvcsStationInPost.Create;
          try
            // 기본 정보 설정
            if lineInfo <> StrToInt(edStcode.Text) div 100  then
              begin
                ShowTVCSMessage('올바른 역 코드를 입력해주세요.');
                Exit;
              end;


            stationPos.fname := edStname.Text;
            stationPos.fcode := edStcode.Text;
            stationPos.fupDepartDelay := StrtoInt(edupDepartDelay.Text);
            stationPos.fdnDepartDelay := StrtoInt(edupDepartDelay.Text);
            stationPos.fupApprTcode := edupApprTcode.Text;
            stationPos.fupArrvTcode := edupArrvTcode.Text;
            stationPos.fupLeavTcode := edupLeavTcode.Text;
            stationPos.fdnApprTcode := eddnApprTcode.Text;
            stationPos.fdnArrvTcode := eddnArrvTcode.Text;
            stationPos.fdnLeavTcode := eddnLeavTcode.Text;

            // 이전/다음 역 코드 설정
            try
              if StrToInt(stationPos.fcode) > 0 then
              begin
                stationPos.fprevCode := IntToStr(StrToInt(stationPos.fcode) - 1);
                stationPos.fnextCode := IntToStr(StrToInt(stationPos.fcode) + 1);
              end;
            except
              ShowTVCSMessage('올바른 역 코드를 입력해주세요.');
              Exit;
            end;

            station := gapi.AddStation(stationPos);
            if station = nil then
            begin
              ShowTVCSMessage('역사정보 추가가 실패하였습니다.');
              Exit;
            end;
          finally
            FreeAndNil(stationPos);
          end;
        end
        else // 수정
        begin
          stationPatch := TvcsStationInPatch.Create;
          try


            // 기본 정보 설정
            stationPatch.fname := edStname.Text;
            stationPatch.fcode := edStcode.Text;
            stationPatch.fupDepartDelay := StrtoInt(edupDepartDelay.Text);
            stationPatch.fdnDepartDelay := StrtoInt(edupDepartDelay.Text);
            stationPatch.fupApprTcode := edupApprTcode.Text;
            stationPatch.fupArrvTcode := edupArrvTcode.Text;
            stationPatch.fupLeavTcode := edupLeavTcode.Text;
            stationPatch.fdnApprTcode := eddnApprTcode.Text;
            stationPatch.fdnArrvTcode := eddnArrvTcode.Text;
            stationPatch.fdnLeavTcode := eddnLeavTcode.Text;

            // 이전/다음 역 코드 설정
            try
              if StrToInt(stationPatch.fcode) > 0 then
              begin
                stationPatch.fprevCode := IntToStr(StrToInt(stationPatch.fcode) - 1);
                stationPatch.fnextCode := IntToStr(StrToInt(stationPatch.fcode) + 1);
              end;
            except
              ShowTVCSMessage('올바른 역 코드를 입력해주세요.');
              Exit;
            end;

            if nil = gapi.UpdateStation(stationPatch) then
            begin
              ShowTVCSMessage('역사정보 수정이 실패하였습니다.');
              Exit;
            end;
          finally
            FreeAndNil(stationPatch);
          end;
        end;

        // 2. 새로 추가된 카메라 정보 처리
        if addCamCnt > 0 then
        begin
          SetLength(stationCamsPos, addCamCnt);
          try
            for i := 1 to addCamCnt do
            begin
              stationCamsPos[i-1] := TVCSStationCameraPost.Create;
              with stationCamsPos[i-1] do
              begin
                fstationCode := edStcode.Text;
                if grdStationCams.Cells[0,i] = '상행' then
                  fdivision := 1
                else
                  fdivision := 2;
                fname := grdStationCams.Cells[1,i];
                fipaddr := grdStationCams.Cells[2,i];
                fport := StrToInt(grdStationCams.Cells[3,i]);
                frtsp := grdStationCams.Cells[4,i];
                frtsp2 := grdStationCams.Cells[5,i];
                fuserId := grdStationCams.Cells[6,i];
                fuserPwd := grdStationCams.Cells[7,i];
              end;

              stationCam := gapi.AddStationCamera(stationCamsPos[i-1]);
              if stationCam = nil then
              begin
                allSuccess := False;
                Break;
              end;
            end;
          finally
            for i := 0 to Length(stationCamsPos)-1 do
              if Assigned(stationCamsPos[i]) then
                FreeAndNil(stationCamsPos[i]);
          end;
        end;

        // 3. 기존 카메라 정보 수정
        for i := 1 to grdStationCams.RowCount - 1 do
        begin
          if i <= addCamCnt then Continue;

          j := i - addCamCnt - 1;
          if (j >= 0) and (j < Length(stationCams)) then
          begin
            stationCamPatch := TVCSStationCameraPatch.Create;
            try
              stationCamPatch.fid := stationCams[j].fid;
              stationCamPatch.fstationCode := edStcode.Text;
              if grdStationCams.Cells[0,i] = '상행' then
                stationCamPatch.fdivision := 1
              else
                stationCamPatch.fdivision := 2;
              stationCamPatch.fname := grdStationCams.Cells[1,i];
              stationCamPatch.fipaddr := grdStationCams.Cells[2,i];
              stationCamPatch.fport := StrToInt(grdStationCams.Cells[3,i]);
              stationCamPatch.frtsp := grdStationCams.Cells[4,i];
              stationCamPatch.frtsp2 := grdStationCams.Cells[5,i];
              stationCamPatch.fuserId := grdStationCams.Cells[6,i];
              stationCamPatch.fuserPwd := grdStationCams.Cells[7,i];

              if nil = gapi.UpdateStationCamera(stationCamPatch) then
                allSuccess := False;
            finally
              FreeAndNil(stationCamPatch);
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          allSuccess := False;
          ShowTVCSMessage('처리 중 오류가 발생했습니다: ' + E.Message);
        end;
      end;
    end;

    // 처리 결과 표시
    if allSuccess then
    begin
      if CheckExcel then
      begin
        ShowTVCSMessage('엑셀 데이터 업로드가 완료되었습니다.');
        CheckExcel := False;
      end
      else
        ShowTVCSMessage('처리가 완료되었습니다.');

      LoadStationInfoList;
      addStCnt := 0;
      addCamCnt := 0;
    end
    else
      ShowTVCSMessage('일부 처리가 실패하였습니다.');

  finally
    // 추가 정리 작업이 필요하다면 여기에 작성
  end;
end;

procedure TfrmStation.btnSearchClick(Sender: TObject);
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

  for i := 1 to grdStations.RowCount - 1 do
  begin
    case searchMode of
      0: // 전체 검색
        if grdStations.Cells[1,i] = searchText then  // 역번호에서 찾은 경우
        begin
          grdStations.SelectCells(1,i,1,i);
          grdStationsClickCell(grdStations, i, 1);
          found := true;
          Break;
        end
        else if grdStations.Cells[2,i] = searchText then  // 역사명에서 찾은 경우
        begin
          grdStations.SelectCells(2,i,2,i);
          grdStationsClickCell(grdStations, i, 2);
          found := true;
          Break;
        end;
      1: // 역번호 검색
        if grdStations.Cells[1,i] = searchText then
        begin
          grdStations.SelectCells(1,i,1,i);
          grdStationsClickCell(grdStations, i, 1);
          found := true;
          Break;
        end;
      2: // 역사명 검색
        if grdStations.Cells[2,i] = searchText then
        begin
          grdStations.SelectCells(2,i,2,i);
          grdStationsClickCell(grdStations, i, 2);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('검색 결과가 없습니다.');
end;

procedure TfrmStation.btnStationDownloadClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExcelGrid: TAdvStringGrid;
  i, j, k, currentRow: Integer;  // k 변수 추가
  station: tvcsProtocol.TvcsStation;
  stationCameras: TArray<TVCSStationCamera>;
begin
  SaveDialog := TSaveDialog.Create(nil);
  ExcelGrid := TAdvStringGrid.Create(nil);
  try
    SaveDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel(*.xls)|*.xls';
    SaveDialog.DefaultExt := 'xls';
    SaveDialog.FilterIndex := 2;

    if SaveDialog.Execute then
    begin
      // 엑셀 그리드 초기 설정
      with ExcelGrid do
      begin
        ColCount := 20;  // 전체 컬럼 수
        RowCount := 1;   // 헤더 row

        // 헤더 설정
        Cells[1,1] := '역번호';
        Cells[2,1] := '역명';
        Cells[3,1] := '상행영상';
        Cells[4,1] := '하행영상';
        Cells[5,1] := '상행접근';
        Cells[6,1] := '상행도착';
        Cells[7,1] := '상행출발';
        Cells[8,1] := '하행접근';
        Cells[9,1] := '하행도착';
        Cells[10,1] := '하행출발';
        Cells[11,1] := 'TVCS IP주소';
        Cells[12,1] := '방향(상행/하행)';
        Cells[13,1] := '카메라이름';
        Cells[14,1] := '카메라IP주소';
        Cells[15,1] := '포트번호';
        Cells[16,1] := 'RTSP주소(main)';
        Cells[17,1] := 'RTSP주소(sub)';
        Cells[18,1] := '카메라ID';
        Cells[19,1] := '카메라PW';
      end;

      currentRow := 2;

      // 먼저 업로드된 엑셀 파일이 있는지 확인
      if Assigned(GridBuf) and (GridBuf.RowCount > 1) and CheckExcel then
      begin
        // 업로드된 엑셀 파일의 모든 행을 처리
        for i := 2 to GridBuf.RowCount do
        begin
          // 빈 행인지 확인 (역번호가 비어있으면 건너뜀)
          if GridBuf.Cells[1, i].Trim = '' then
            Continue;

          ExcelGrid.RowCount := currentRow + 1;
          
          // 기본 역 정보 복사 (1-10열)
          for j := 1 to 10 do
          begin
            ExcelGrid.Cells[j, currentRow] := GridBuf.Cells[j, i];
          end;
          
          // TVCS IP 비워둠
          ExcelGrid.Cells[11, currentRow] := '';
          
          // 역번호가 있으면 카메라 정보 가져오기 시도
          if GridBuf.Cells[1, i].Trim <> '' then
          begin
            // 카메라 정보 가져오기 시도
            try
              stationCameras := gapi.GetStationCamera(GridBuf.Cells[1, i]);
              
              // 카메라가 있으면 첫 번째 카메라 정보 추가
              if Length(stationCameras) > 0 then
              begin
                // 첫 번째 카메라 정보 추가
                if stationCameras[0].fdivision = 1 then
                  ExcelGrid.Cells[12, currentRow] := '상행'
                else
                  ExcelGrid.Cells[12, currentRow] := '하행';
                  
                ExcelGrid.Cells[13, currentRow] := stationCameras[0].fname;
                ExcelGrid.Cells[14, currentRow] := stationCameras[0].fipaddr;
                ExcelGrid.Cells[15, currentRow] := IntToStr(stationCameras[0].fport);
                ExcelGrid.Cells[16, currentRow] := stationCameras[0].frtsp;
                ExcelGrid.Cells[17, currentRow] := stationCameras[0].frtsp2;
                ExcelGrid.Cells[18, currentRow] := stationCameras[0].fuserId;
                ExcelGrid.Cells[19, currentRow] := stationCameras[0].fuserPwd;
                
                // 추가 카메라가 있으면 새 행에 추가
                for k := 1 to Length(stationCameras) - 1 do  // j 대신 k 사용
                begin
                  Inc(currentRow);
                  ExcelGrid.RowCount := currentRow + 1;
                  
                  // 기본 역 정보 복사
                  for j := 1 to 10 do
                  begin
                    ExcelGrid.Cells[j, currentRow] := GridBuf.Cells[j, i];
                  end;
                  
                  // TVCS IP 비워둠
                  ExcelGrid.Cells[11, currentRow] := '';
                  
                  // 카메라 정보 추가
                  if stationCameras[k].fdivision = 1 then  // j 대신 k 사용
                    ExcelGrid.Cells[12, currentRow] := '상행'
                  else
                    ExcelGrid.Cells[12, currentRow] := '하행';
                    
                  ExcelGrid.Cells[13, currentRow] := stationCameras[k].fname;  // j 대신 k 사용
                  ExcelGrid.Cells[14, currentRow] := stationCameras[k].fipaddr;  // j 대신 k 사용
                  ExcelGrid.Cells[15, currentRow] := IntToStr(stationCameras[k].fport);  // j 대신 k 사용
                  ExcelGrid.Cells[16, currentRow] := stationCameras[k].frtsp;  // j 대신 k 사용
                  ExcelGrid.Cells[17, currentRow] := stationCameras[k].frtsp2;  // j 대신 k 사용
                  ExcelGrid.Cells[18, currentRow] := stationCameras[k].fuserId;  // j 대신 k 사용
                  ExcelGrid.Cells[19, currentRow] := stationCameras[k].fuserPwd;  // j 대신 k 사용
                end;
              end;
            except
              // 카메라 정보 가져오기 실패 시 무시하고 계속 진행
            end;
          end;
          
          Inc(currentRow);
        end;
      end
      else
      begin
        // 기존 stations 배열 사용하는 방식 (여기는 변경 없음)
        for i := 0 to Length(stations) - 1 do
        begin
          station := stations[i];
          // 해당 역사의 카메라 정보 가져오기
          stationCameras := gapi.GetStationCamera(station.fcode);
      
          // 카메라가 0개인 경우에도 역 정보는 한 번 추가
          if Length(stationCameras) = 0 then
          begin
            ExcelGrid.RowCount := currentRow + 1;
            // 역사 정보만 입력
            ExcelGrid.Cells[1, currentRow] := station.fcode;
            ExcelGrid.Cells[2, currentRow] := station.fname;
            ExcelGrid.Cells[3, currentRow] := IntToStr(station.fupDepartDelay);
            ExcelGrid.Cells[4, currentRow] := IntToStr(station.fdnDepartDelay);
            ExcelGrid.Cells[5, currentRow] := station.fupApprTcode;
            ExcelGrid.Cells[6, currentRow] := station.fupArrvTcode;
            ExcelGrid.Cells[7, currentRow] := station.fupLeavTcode;
            ExcelGrid.Cells[8, currentRow] := station.fdnApprTcode;
            ExcelGrid.Cells[9, currentRow] := station.fdnArrvTcode;
            ExcelGrid.Cells[10, currentRow] := station.fdnLeavTcode;
            // TVCS IP 및 카메라 정보는 비워둠
            ExcelGrid.Cells[11, currentRow] := '';
            Inc(currentRow);
          end
          else
          begin
            // 카메라가 있는 경우 각 카메라별로 row 추가
            for j := 0 to Length(stationCameras) - 1 do
            begin
              ExcelGrid.RowCount := currentRow + 1;
              // 역사 정보
              ExcelGrid.Cells[1, currentRow] := station.fcode;
              ExcelGrid.Cells[2, currentRow] := station.fname;
              ExcelGrid.Cells[3, currentRow] := IntToStr(station.fupDepartDelay);
              ExcelGrid.Cells[4, currentRow] := IntToStr(station.fdnDepartDelay);
              ExcelGrid.Cells[5, currentRow] := station.fupApprTcode;
              ExcelGrid.Cells[6, currentRow] := station.fupArrvTcode;
              ExcelGrid.Cells[7, currentRow] := station.fupLeavTcode;
              ExcelGrid.Cells[8, currentRow] := station.fdnApprTcode;
              ExcelGrid.Cells[9, currentRow] := station.fdnArrvTcode;
              ExcelGrid.Cells[10, currentRow] := station.fdnLeavTcode;
              // TVCS IP는 비워둠 (필요시 추가)
              ExcelGrid.Cells[11, currentRow] := '';
              // 카메라 정보
              if stationCameras[j].fdivision = 1 then
                ExcelGrid.Cells[12, currentRow] := '상행'
              else
                ExcelGrid.Cells[12, currentRow] := '하행';
              ExcelGrid.Cells[13, currentRow] := stationCameras[j].fname;
              ExcelGrid.Cells[14, currentRow] := stationCameras[j].fipaddr;
              ExcelGrid.Cells[15, currentRow] := IntToStr(stationCameras[j].fport);
              ExcelGrid.Cells[16, currentRow] := stationCameras[j].frtsp;
              ExcelGrid.Cells[17, currentRow] := stationCameras[j].frtsp2;
              ExcelGrid.Cells[18, currentRow] := stationCameras[j].fuserId;
              ExcelGrid.Cells[19, currentRow] := stationCameras[j].fuserPwd;
              Inc(currentRow);
            end;
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
procedure TfrmStation.btnUploadStationsClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  isValidFormat: Boolean;
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

        // 엑셀 양식 체크
        isValidFormat := (GridBuf.Cells[1,1] = '역번호') and
                        (GridBuf.Cells[2,1] = '역명') and
                        (GridBuf.Cells[3,1] = '상행영상') and
                        (GridBuf.Cells[4,1] = '하행영상') and
                        (GridBuf.Cells[5,1] = '상행접근') and
                        (GridBuf.Cells[6,1] = '상행도착') and
                        (GridBuf.Cells[7,1] = '상행출발') and
                        (GridBuf.Cells[8,1] = '하행접근') and
                        (GridBuf.Cells[9,1] = '하행도착') and
                        (GridBuf.Cells[10,1] = '하행출발');

        if isValidFormat then
        begin
          CheckExcel := True;
          LoadStationInfoList;
        end
        else
        begin
          ShowTVCSMessage('엑셀양식이 올바르지 않습니다.');
          FreeAndNil(GridBuf);  // 잘못된 엑셀 데이터 해제
        end;
      end;

    finally
      OpenDialog.Free;
    end;
  end;
end;

procedure TfrmStation.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearchClick(Sender);
end;

procedure TfrmStation.edStcodeChange(Sender: TObject);
begin
  if edStcode.Text = 'NULL' then
    edStcode.Text := '';
end;

procedure TfrmStation.edStcodeKeyPress(Sender: TObject; var Key: Char);
begin
  // 숫자나 백스페이스가 아닌 경우
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;  // 입력 취소
    ShowTVCSMessage('숫자만 입력가능합니다.');
  end;
end;

procedure TfrmStation.edStnameChange(Sender: TObject);
begin
  if edStname.Text = 'NULL' then
    edStname.Text := '';
end;

procedure TfrmStation.FormCreate(Sender: TObject);
begin
  LoadStationInfoList;
  LoadCamInfoList;
  grdStations.OnClickCell := grdStationsClickCell;

  grdStationCams.OnGetEditorType := grdStationCamsGetEditorType;
  grdStationCams.OnGetEditorProp := grdStationCamsGetEditorProp;
  grdStationCams.OnHasComboBox := grdStationCamsHasComboBox;
  grdStationCams.OnClickCell := grdStationsCamsClickCell;

  TButtonStyler.ApplyGlobalStyle(Self);
  lblTitle.Caption := '승강장 카메라 관리 ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'호선)';

end;

procedure TfrmStation.FormDestroy(Sender: TObject);
begin
//
end;

procedure TfrmStation.LoadStationInfoList;
var
    size, i, j, k,  addline: integer;
    delBtn : TButton;
    uniqueValues : TStringList;
    uniqueCount : integer;
    lineInfo : integer;
    StationNames: array of string;
    validCount: integer;  // 유효한 데이터 카운트를 위한 변수 추가
begin

    lineInfo := gapi.GetLoinInfo.fsystem.fline;
    // 엑셀 업로드 하는경우
    if CheckExcel then
    begin
      // lineInfo에 따라 적절한 배열 선택
      case lineInfo of
        2: begin
             SetLength(StationNames, Length(Line2StationName));
             for i := Low(Line2StationName) to High(Line2StationName) do
               StationNames[i] := Line2StationName[i];
           end;
        3: begin
             SetLength(StationNames, Length(Line3StationName));
             for i := Low(Line3StationName) to High(Line3StationName) do
               StationNames[i] := Line3StationName[i];
           end;
        4: begin
             SetLength(StationNames, Length(Line4StationName));
             for i := Low(Line4StationName) to High(Line4StationName) do
               StationNames[i] := Line4StationName[i];
           end;
      end;
      uniqueValues := TStringList.Create;
      try
        uniqueValues.Sorted := True;
        uniqueValues.Duplicates := dupIgnore;
         validCount := 0;  // 유효한 데이터 카운트 초기화

        for i := 2 to GridBuf.RowCount do
        begin
          // 해당 행의 모든 필수 데이터가 있는지 확인
          if (GridBuf.Cells[1,i].Trim <> '') and     // 역번호
             (GridBuf.Cells[2,i].Trim <> '') and     // 역명
             (GridBuf.Cells[3,i].Trim <> '') and     // 상행영상
             (GridBuf.Cells[4,i].Trim <> '') and     // 하행영상
             (GridBuf.Cells[5,i].Trim <> '') and     // 상행접근
             (GridBuf.Cells[6,i].Trim <> '') and     // 상행도착
             (GridBuf.Cells[7,i].Trim <> '') and     // 상행출발
             (GridBuf.Cells[8,i].Trim <> '') and     // 하행접근
             (GridBuf.Cells[9,i].Trim <> '') and     // 하행도착
             (GridBuf.Cells[10,i].Trim <> '') then   // 하행출발
          begin
            Inc(validCount);
            uniqueValues.Add(GridBuf.Cells[1,i]);  // 유효한 역번호만 추가
          end;
        end;

        uniqueCount := uniqueValues.Count;
        SetLength(stations, uniqueCount);
        for i := 0 to uniqueCount - 1 do
        begin
          stations[i] := tvcsProtocol.TvcsStation.Create;
          stations[i].fcode := uniqueValues[i];

          // GridBuf에서 해당 역의 정보 찾기 (마지막 데이터)
          for k := GridBuf.RowCount downto 2 do
          begin
            if GridBuf.Cells[1, k] = stations[i].fcode then
            begin
              stations[i].fname := GridBuf.Cells[2, k];
              stations[i].fupDepartDelay := StrToInt(GridBuf.Cells[3, k]);
              stations[i].fdnDepartDelay := StrToInt(GridBuf.Cells[4, k]);

              stations[i].fupApprTcode := GridBuf.Cells[5, k];
              stations[i].fupArrvTcode := GridBuf.Cells[6, k];
              stations[i].fupLeavTcode := GridBuf.Cells[7, k];

              stations[i].fdnApprTcode := GridBuf.Cells[8, k];
              stations[i].fdnArrvTcode := GridBuf.Cells[9, k];
              stations[i].fdnLeavTcode := GridBuf.Cells[10, k];


              // 필요한 다른 필드들도 여기에 추가
              Break;
            end;
          end;

          // 현재 역의 이름을 찾기
          for j := Low(StationNames) to High(StationNames) do
          begin
            try
              if stations[i].fcode = Format('%d%0.2d', [lineInfo, j+1]) then
              begin
                // 이전역 설정
                if j = 0 then
                begin
                  stations[i].fprevCode := '';
                  stations[i].fprevName := '';
                end
                else
                begin
                  stations[i].fprevCode := Format('%d%0.2d', [lineInfo, j]);
                  stations[i].fprevName := StationNames[j-1];
                end;
                // 다음역 설정
                if j = High(StationNames) then
                begin
                  stations[i].fnextCode := '';
                  stations[i].fnextName := '';
                end
                else
                begin
                  stations[i].fnextCode := Format('%d%0.2d', [lineInfo, j+2]);
                  stations[i].fnextName := StationNames[j+1];
                end;
                Break;
              end;
            except
              ShowTVCSMessage('역 정보가 올바르지 않습니다.');
            end;
          end;
        end;
      finally
        uniqueValues.Free;
      end;
    end
    else
    // api로리스트 호출하는 경우
    begin
      stations := gapi.GetStation('',gapi.GetLoinInfo.fsystem.fline);
    end;

    //ShowTVCSMessage(inttostr(uniqueCount));
    size := Length(stations);
    lblTotal.Caption := '총:' + IntTostr(size) + '개';
    delBtn := Tbutton.Create(self);
    delBtn.Caption := '삭제';

    with grdStations do
    begin
        RowCount:=1;
        ColCount:=4;
        ColWidths[0]:=60;
        ColWidths[1]:=60;
        ColWidths[2]:=120;
        ColWidths[3]:=60;
        Cells[0,0]:='No.';
        Cells[1,0]:='역번호';
        Cells[2,0]:='역사명';
        Cells[3,0]:='삭제';
   end;

   for i := 0 to size-1 do
   with grdStations do
   begin
    AddRow;
    Cells[0,i+1] := inttostr(i+1);
    Cells[1,i+1] := stations[i].fcode;
    Cells[2,i+1] := stations[i].fname;

    //AddButton(3, i+1, grdStations.ColWidths[3]-5, 20, '삭제', haCenter, vaCenter);
    AddImageIdx(3, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

   end;


end;


procedure TfrmStation.LoadCamInfoList(stationCode: string = '');
var
  i, j : integer;
  size : integer;
  division : string;
  filteredCams: Tarray<TVCSStationCamera>;

begin

    with grdStationCams do begin
        RowCount:=1;
        ColCount:=10;
        //760
        ColWidths[0] := 60;   // 구분
        ColWidths[1] := 80;  // 카메라명
        ColWidths[2] := 80;  // IP Addr
        ColWidths[3] := 50;   // Port
        ColWidths[4] := 120;  // RTSP High
        ColWidths[5] := 120;  // RTSP Low

        ColWidths[6] := 72;   // ID
        ColWidths[7] := 82;   // Password
        ColWidths[8] := 60;   // 미리보기 버튼
        ColWidths[9] := 45;   // 삭제 버튼

        Cells[0,0]:='구분';
        Cells[1,0]:='카메라명';
        Cells[2,0]:='IP Addr';
        Cells[3,0]:= 'Port';
        Cells[4,0]:='RTSP 주소 ';
        Cells[5,0]:='RTSP 주소 ';
        Cells[6,0]:='ID';
        Cells[7,0]:='Password';
        Cells[8,0]:='미리보기';
        Cells[9,0]:='삭제';
        FixedRows := 0;
        FixedCols := 0;
        AddComboString('상행');
        AddComboString('하행');

        for i := 0 to 9 do
          begin
            ReadOnly[i,0] := True;
          end;

    end;

    lbStCamCnt.Caption := '총: 0 개';



     if stationCode <> '' then
    begin
      // 엑셀 업로드
      if CheckExcel then
      begin
        // 우선 모든 데이터를 BufstationCams에 저장
        SetLength(BufstationCams, GridBuf.rowcount - 2);
        for i := 0 to Length(BufstationCams) -2 do
        begin

          BufstationCams[i] := TVCSStationCamera.Create;
          BufstationCams[i].fstationCode := GridBuf.Cells[1,i+2];
          if GridBuf.Cells[12,i +2] = '상행' then
              BufstationCams[i].fdivision := 1
          else
              BufstationCams[i].fdivision := 2;
          BufstationCams[i].fname := GridBuf.Cells[13,i+2];
          BufstationCams[i].fipaddr := GridBuf.Cells[14,i+2];
          BufstationCams[i].fport := StrToInt(GridBuf.Cells[15,i+2]);
          BufstationCams[i].frtsp := GridBuf.Cells[16,i+2];
          BufstationCams[i].frtsp2 := GridBuf.Cells[17,i+2];
          BufstationCams[i].fuserId := GridBuf.Cells[18,i+2];
          BufstationCams[i].fuserPwd := GridBuf.Cells[19,i+2];
        end;

        // stationCode에 해당하는 카메라만 필터링
        j := 0;
        SetLength(filteredCams, 0);
        for i := 0 to Length(BufstationCams) - 1 do
        begin
          if BufstationCams[i].fstationCode = stationCode then
          begin
            SetLength(filteredCams, Length(filteredCams) + 1);
            filteredCams[j] := BufstationCams[i];
            Inc(j);
          end;
        end;

        stationCams := filteredCams;  // 필터링된 데이터를 stationCams에 할당
      end
      else
      begin
         stationCams := gapi.GetStationCamera(stationCode);
      end;

      size := Length(stationCams);
      lbStCamCnt.Caption := '총: '+ IntToStr(size) + '개';
      if size > 0 then
        begin
          for i := 0 to size-1 do
           with grdStationCams do
           begin
             AddRow;

             if stationCams[i].fdivision = 1 then
              division := '상행'
             else
              division := '하행';

             Cells[0,i+1] := division;
             Cells[1,i+1] := stationCams[i].fname;
             Cells[2,i+1] := stationCams[i].fipaddr;
             Cells[3,i+1] := IntToStr(stationCams[i].fport);
             Cells[4,i+1] := stationCams[i].frtsp;
             Cells[5,i+1] := stationCams[i].frtsp2;

             Cells[6,i+1] := stationCams[i].fuserId;
             Cells[7,i+1] := stationCams[i].fuserPwd;

             AddImageIdx(8, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
             AddImageIdx(9, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

           end;

        end;
    end;

end;

// 역사정보 확인 or 삭제
procedure TfrmStation.grdStationsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  stationCam: TVCSStationCamera;
  i, size: integer;
  stationcode : string;
  isNewRow: Boolean;
  
  
begin                                                      

  
  //staionAdd := TvcsStationInPost.Create; 
  // 헤더 행(0번째 행) 클릭 시
  if ARow = 0 then
  begin
    edStcode.Text := '';
    edStname.Text := '';
    edupDepartDelay.Text := '0';
    eddnDepartDelay.Text := '0';
    eddnApprTcode.Text := '';
    edupArrvTcode.Text := '';
    edupLeavTcode.Text := '';
    eddnApprTcode.Text := '';
    eddnArrvTcode.Text := '';
    eddnLeavTcode.Text := '';
    eddnRtsp.Text := '';
    edupRtsp.Text := '';


    edStcode.Enabled := False;
    edStName.Enabled := False;
    eddnApprTcode.Enabled := False;
    eddnArrvTcode.Enabled := False;
    eddnDepartDelay.Enabled := False;
    eddnLeavTcode.Enabled := False;
    edupApprTcode.Enabled := False;
    edupArrvTcode.Enabled := False;
    edupDepartDelay.Enabled := False;
    edupLeavTcode.Enabled := False;
    btnAddCams.Enabled := False;
    edupRtsp.Enabled := False;
    eddnRtsp.Enabled := False;
    AdvOfficeRadioGroup1.Enabled := False;
    AdvOfficeRadioGroup2.Enabled := False;
    grdStations.Options := grdStations.Options - [goEditing];

    LoadCamInfoList();
    Exit;
  end;


  // 새로 추가된 행인지 확인
  isNewRow := (ARow <= addStCnt);

  // 새로 추가 하는 행이 아닌경우
  if (addStCnt > 0) and (ARow <> 1) then
    begin 
      ShowTVCSMessage('아직 저장되지 않은 역사정보가 있습니다. 저장 또는 삭제를 진행해주세요');
          
        
          isNewRow  := true;
          grdStations.EditCell(1,1);
          staionAdd.fdnRtsp := eddnRtsp.text;
          staionAdd.fupRtsp := edupRtsp.Text;
        
          staionAdd.fupDepartDelay := StrtoInt(edupDepartDelay.text);
          staionAdd.fdnDepartDelay := StrtoInt(eddnDepartDelay.text);  
          
          staionAdd.fupLeavTcode := edupLeavTcode.text;  
          staionAdd.fdnLeavTcode := eddnLeavTcode.text;  
          
          staionAdd.fupArrvTcode := edupArrvTcode.text;  
          staionAdd.fdnArrvTcode := eddnArrvTcode.text; 

          staionAdd.fupApprTcode := edupArrvTcode.Text;
          staionAdd.fdnApprTcode := eddnApprTcode.Text;      


          if AdvOfficeRadioGroup1.ItemIndex = 0 then
            begin
              staionAdd.fupView := 'single';
              staionAdd.fdnView := 'single';
            end
            
          else
            begin
               staionAdd.fupView := 'merge'; 
               staionAdd.fdnView := 'merge'; 
            end;
           


          
          if advofficetabset1.ActiveTabIndex  = 0 then
          begin
            pnUp.Visible := true;
            pnDn.Visible := false;
          end
          else
          begin
            pnUp.Visible := false;
            pnDn.Visible := true;
          end;
          


          
          ARow := 1;
          ACol := 1;
        
       
        

      
    end;
  
  
  // 데이터 행 클릭 시 (헤더 제외)
  //edStcode.Enabled := true;
  //edStName.Enabled := true;
  eddnApprTcode.Enabled := true;
  eddnArrvTcode.Enabled := true;
  eddnDepartDelay.Enabled := true;
  eddnLeavTcode.Enabled := true;
  edupApprTcode.Enabled := true;
  edupArrvTcode.Enabled := true;
  edupDepartDelay.Enabled := true;
  edupLeavTcode.Enabled := true;
  btnAddCams.Enabled := true;

  edupRtsp.Enabled := true;
  eddnRtsp.Enabled := true;
  AdvOfficeRadioGroup1.Enabled := true;
  AdvOfficeRadioGroup2.Enabled := true;

  grdStations.Options := grdStations.Options + [goEditing];


  if Acol = 3 then  // 삭제 버튼 클릭
  begin
    try
      if ShowTVCSCheck(mcDelete) then
      begin
        try
          // 새로 추가된 행이 아닌 경우만 API 호출
          if not isNewRow and (ARow-1 - addStCnt >= 0) then
            gapi.DeleteStation(stations[ARow-1 - addStCnt].fcode);

        finally
          LoadStationInfoList;
          // 에디트 박스 초기화
          edStcode.Text := '';
          edStname.Text := '';
          edupDepartDelay.Text := '0';
          eddnDepartDelay.Text := '0';
          eddnApprTcode.Text := '0';
          edupArrvTcode.Text := '0';
          edupLeavTcode.Text := '0';
          eddnApprTcode.Text := '0';
          eddnArrvTcode.Text := '0';
          eddnLeavTcode.Text := '0';
          edupRtsp.Text := '';
          eddnRtsp.Text := '';
          AdvOfficeRadioGroup1.ItemIndex := 0;
          AdvOfficeRadioGroup2.ItemIndex := 0;
          addStCnt := 0 ;
          ShowTVCSMessage('삭제 되었습니다. ');
        end;
      end;
    finally
    end;
  end
  else  // 일반 셀 클릭
  begin
    try
      if not isNewRow then  // 기존 데이터 행
      begin
        SelectStation := stations[ARow-1 - addStCnt];
        if SelectStation <> nil then
        begin
        stationcode := SelectStation.fcode;
        edStcode.Text := SelectStation.fcode;
        edStname.Text := SelectStation.fname;
        edupDepartDelay.Text := intTostr(SelectStation.fupDepartDelay);
        eddnDepartDelay.Text := intTostr(SelectStation.fdnDepartDelay);
        edupApprTcode.Text := SelectStation.fupApprTcode;
        edupArrvTcode.Text := SelectStation.fupArrvTcode;
        edupLeavTcode.Text := SelectStation.fupLeavTcode;
        eddnApprTcode.Text := SelectStation.fdnApprTcode;
        eddnArrvTcode.Text := SelectStation.fdnArrvTcode;
        eddnLeavTcode.Text := SelectStation.fdnLeavTcode;

        edupRtsp.Text := SelectStation.fupRtsp;
        eddnRtsp.Text := SelectStation.fdnRtsp;

        if SelectStation.fupView = 'merge' then
          AdvOfficeRadioGroup2.ItemIndex := 1
        else
          AdvOfficeRadioGroup2.ItemIndex := 0;

        if SelectStation.fdnView = 'merge' then
          AdvOfficeRadioGroup1.ItemIndex := 1
        else
          AdvOfficeRadioGroup1.ItemIndex := 0;


        end;
        //ShowMessage(SelectStation.fupApprTcode + SelectStation.fupArrvTcode);

        LoadCamInfoList(SelectStation.fcode);
      end
      else  // 새로 추가된 행
      begin
        // 현재 그리드의 데이터 표시
        edStcode.Text := grdStations.Cells[1, ARow];
        edStname.Text := grdStations.Cells[2, ARow];

        edupDepartDelay.Text := IntToStr(staionAdd.fupDepartDelay);          
        eddnDepartDelay.Text := IntToStr(staionAdd.fdnDepartDelay);
        eddnApprTcode.Text := staionAdd.fdnApprTcode;
        edupArrvTcode.Text := staionAdd.fupArrvTcode;
        edupLeavTcode.Text := staionAdd.fupLeavTcode;
        eddnApprTcode.Text := staionAdd.fdnApprTcode;
        eddnArrvTcode.Text := staionAdd.fdnArrvTcode;
        eddnLeavTcode.Text := staionAdd.fdnLeavTcode;

        edupRtsp.Text := staionAdd.fupRtsp;
        eddnRtsp.Text := staionAdd.fdnRtsp;

        if staionAdd.fupView = 'single' then
          AdvOfficeRadioGroup1.ItemIndex := 0
        else
          AdvOfficeRadioGroup2.ItemIndex := 1;
        
        // 나머지 필드는 기본값 유지
        LoadCamInfoList;  // 빈 카메라 리스트 로드
      end;
    except
      edStcode.Text := '';
      edStname.Text := '';
      edupDepartDelay.Text := '0';
      eddnDepartDelay.Text := '0';
      eddnApprTcode.Text := '';
      edupArrvTcode.Text := '';
      edupLeavTcode.Text := '';
      eddnApprTcode.Text := '';
      eddnArrvTcode.Text := '';
      eddnLeavTcode.Text := '';

      edupRtsp.Text := '';
      eddnRtsp.Text := '';
      AdvOfficeRadioGroup1.ItemIndex := 0;
      AdvOfficeRadioGroup2.ItemIndex := 0;

      LoadCamInfoList;
    end;
  end;
end;


procedure TfrmStation.grdStationsEditChange(Sender: TObject; ACol,
  ARow: Integer; Value: string);
begin
  if ACol = 1 then
    edStcode.Text := Value

  else if ACol = 2 then
    edStname.Text := Value;


end;

procedure TfrmStation.lblT1UpDepClick(Sender: TObject);
begin

end;

// 역사카메라 미리보기 or 삭제
Procedure TfrmStation.grdStationsCamsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  ShowPreview: TfrmPreview;

begin
//
if ARow > 0 then
  begin
    if ACol = 9 then
      begin
        if ShowTVCSCheck(mcDelete) then
        begin
          gapi.DeleteStationCamera(stationCams[ARow-1 -addStCnt].fid);
          grdStationCams.RemoveRows(ARow, 1);
          LoadCamInfoList(SelectStation.fcode);
          addCamCnt := 0;
          ShowTVCSMessage('삭제 되었습니다. ');
        end;
      end;

    // 미리보기
    if ACol = 8 then
      begin
        ShowPreview := TfrmPreview.Create(self);
        ShowPreview.SetRtspUrl(stationCams[ARow-1 -addStCnt].frtsp);
        ShowPreview.SetRtspID(stationCams[ARow-1 -addStCnt].fuserId);
        ShowPreview.SetRtspPw(stationCams[ARow-1 -addStCnt].fuserPwd);
        ShowPreview.StartPreview;
        ShowPreview.ShowModal;
      end;
    //ShowMessage('ACol: '+ IntToStr(ACol) +' ARow:' +IntToStr(ARow));

  end;

end;

end.
