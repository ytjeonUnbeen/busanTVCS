unit TVCSDevices;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls,
  AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvGlowButton,
  TVCSButtonStyle, TVCSCheckDialog, tmsAdvGridExcel, tvcsProtocol, tvcsAPI,
  Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList;

type
  TfrmDevices = class(TForm)
    pnMainFrame: TPanel;
    pnBottom: TPanel;
    lblTitle: TLabel;
    edSearchText: TEdit;
    lblDeviceCnt: TLabel;
    grdDeviceList: TAdvStringGrid;
    lblDeviceInfo: TLabel;
    btnDeviceUpload: TAdvGlowButton;
    btnDeviceDownload: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    AdvGridExcelIO1: TAdvGridExcelIO;
    btnAddDevice: TAdvGlowButton;
    btnSearch: TAdvGlowButton;
    cbSearch: TComboBox;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnDeviceUploadClick(Sender: TObject);
    procedure btnDeviceDownloadClick(Sender: TObject);
    procedure btnAddDeviceClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    addDevCnt : integer;
    CheckExcel : boolean;
    BufDevices: TArray<TVCSDevice>;
    Devices: TArray<TVCSDevice>;
    GridBuf : TAdvStringGrid;
    procedure grdDeviceListHasComboBox(Sender: TObject; ACol, ARow: Integer;
      var HasComboBox: Boolean);
    procedure grdDeviceListGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdDeviceListGetEditorProp(Sender: TObject; ACol, ARow: Integer;
      AEditLink: TEditLink);
    procedure grdDeviceClickCell(Sender: TObject; ARow, ACol: Integer);

  public
    { Public declarations }
    procedure LoadDeviceList;


  end;

var
  frmDevices: TfrmDevices;

implementation

{$R *.dfm}

procedure TfrmDevices.btnAddDeviceClick(Sender: TObject);
begin
  addDevCnt := addDevCnt + 1;
  with grdDeviceList do
  begin
    InsertChildRow(0);
    Cells[0,1] := IntToStr(RowCount-1);  // No
    Cells[1,1] := '';  // 열차번호
    Cells[2,1] := 'TVCS';  // 장치구분 기본값
    Cells[3,1] := '';  // IP
    Cells[4,1] := '';  // ID
    Cells[5,1] := '';  // PW
    Cells[6,1] := '활성';  // 상태
    AddImageIdx(7, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
  end;
end;

procedure TfrmDevices.btnCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;

end;

procedure TfrmDevices.btnDeviceDownloadClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExcelGrid: TAdvStringGrid;
  i, currentRow: Integer;
  deviceTypeStr: string;
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
        ColCount := 7;  // 전체 컬럼 수
        RowCount := 1;  // 헤더 row

        // 헤더 설정
        Cells[1,1] := '장치구분';
        Cells[2,1] := '역코드';
        Cells[3,1] := '열차번호';
        Cells[4,1] := 'IP주소';
        Cells[5,1] := 'ID';
        Cells[6,1] := 'PW';
      end;

      currentRow := 2;

      // 각 장치별로 처리
      for i := 0 to Length(Devices) - 1 do
      begin
        ExcelGrid.RowCount := currentRow + 1;

        // 장치 구분 문자열 변환
        case StrToInt(Devices[i].ftype) of
          0: deviceTypeStr := 'TVCS';
          1: deviceTypeStr := '표출장치';
          2: deviceTypeStr := '대열차 공간 모니터';
        end;

        // 장치 정보 입력
        ExcelGrid.Cells[1,currentRow] := deviceTypeStr;
        ExcelGrid.Cells[2,currentRow] := IntToStr(Devices[i].fstationCode);
        // 열차번호가 0인 경우 '0000' 형식으로 출력
        if Devices[i].ftrainNo = 0 then
          ExcelGrid.Cells[3,currentRow] := '0000'
        else
          ExcelGrid.Cells[3,currentRow] := IntToStr(Devices[i].ftrainNo);
        ExcelGrid.Cells[4,currentRow] := Devices[i].fipAddr;
        ExcelGrid.Cells[5,currentRow] := Devices[i].floginId;
        ExcelGrid.Cells[6,currentRow] := Devices[i].floginPwd;

        Inc(currentRow);
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

procedure TfrmDevices.btnDeviceUploadClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  isValidFormat: Boolean;
begin
  if ShowTVCSCheck(2) then
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
        isValidFormat := (GridBuf.Cells[1,1] = '장치구분') and

                        (GridBuf.Cells[3,1] = '열차번호') and
                        (GridBuf.Cells[4,1] = 'IP주소') and
                        (GridBuf.Cells[5,1] = 'ID') and
                        (GridBuf.Cells[6,1] = 'PW');

        if isValidFormat then
        begin
          CheckExcel := True;
          LoadDeviceList;
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

procedure TfrmDevices.btnDlgCloseClick(Sender: TObject);
begin
    ModalResult := mrAbort;

end;

procedure TfrmDevices.btnSaveClick(Sender: TObject);
var
  devicePost: TVCSDevicePost;
  device: TVCSDevice;
  deviceType: string;
  i: Integer;
  allSuccess: Boolean;
  trainStr: string;
  trainNo: Integer;

begin
  if ShowTVCSCheck(0) then
  begin
    // 엑셀 업로드 처리
    if CheckExcel then
    begin
      allSuccess := True;

      try
        // 1. 기존 데이터 삭제
        for i := 0 to Length(Devices)-1 do
        begin
          if gapi.DeleteDevice(Devices[i].fid) = '' then
          begin
            allSuccess := False;
            ShowTVCSMessage('장치 정보 삭제 중 오류가 발생했습니다.');
            Exit;
          end;
        end;

        // 2. 엑셀 데이터 추가
        for i := 1 to grdDeviceList.RowCount -1 do
        begin
          devicePost := TVCSDevicePost.Create;
          try
            if grdDeviceList.Cells[2,i] = 'TVCS' then
              deviceType := '0'
            else if grdDeviceList.Cells[2,i] = '표출장치' then
              deviceType := '1'
            else
              deviceType := '2';
            devicePost.ftype := deviceType; // 장치구분

            devicePost.fstationCode := 0;  // 역코드

            trainStr := Trim(grdDeviceList.Cells[1,i]);
            if (trainStr = '') or (trainStr = '0000') then
              devicePost.ftrainNo := 0
            else if TryStrToInt(trainStr, trainNo) then
              devicePost.ftrainNo := trainNo;


            devicePost.fipAddr := grdDeviceList.Cells[3,i];  // IP주소
            devicePost.fport := 80;  // 기본 포트
            devicePost.floginId := grdDeviceList.Cells[4, i];
            devicePost.floginPwd := grdDeviceList.Cells[5, i];


            devicePost.fmemo := '';

            device := gapi.AddDevice(devicePost);
            if device = nil then
            begin
              allSuccess := False;
              ShowTVCSMessage(Format('장치 정보 추가 중 오류가 발생했습니다. (열차번호: %s)', [GridBuf.Cells[2,i]]));
              Exit;
            end;
          finally
            FreeAndNil(devicePost);
          end;
        end;

        if allSuccess then
        begin
          ShowTVCSMessage('엑셀 데이터 업로드가 완료되었습니다.');
          CheckExcel := False;
          LoadDeviceList;
        end;

      except
        on E: Exception do
        begin
          ShowTVCSMessage('처리 중 오류가 발생했습니다: ' + E.Message);
        end;
      end;
    end
    else
    begin
      // 일반 저장 처리
      for i := 1 to grdDeviceList.RowCount-1 do
      begin
        // 장치 구분에 따른 type 설정
        if grdDeviceList.Cells[2,i] = 'TVCS' then
          deviceType := '0'
        else if grdDeviceList.Cells[2,i] = '표출장치' then
          deviceType := '1'
        else
          deviceType := '2';

        // 새로 추가된 행인 경우
        if i <= addDevCnt then
        begin
          devicePost := TVCSDevicePost.Create;
          try

            devicePost.ftype := deviceType;
            devicePost.ftrainNo := StrToInt(grdDeviceList.Cells[1,i]);
            devicePost.fipAddr := grdDeviceList.Cells[3,i];
            devicePost.fstationCode := 0;
            devicePost.fport := 80; // 기본 포트
            devicePost.fmemo := '';
            devicePost.floginId := grdDeviceList.Cells[4,i];
            devicePost.floginPwd := grdDeviceList.Cells[5,i];

            device := gapi.AddDevice(devicePost);
            if device = nil then
            begin
              ShowTVCSMessage('장치 정보 추가가 실패하였습니다.');
              Exit;
            end;
          finally
            FreeAndNil(devicePost);
          end;
        end
        else
        begin
          // 기존 데이터 수정
          device := TVCSDevice.Create;
          try
            device.fid := Devices[i-2].fid;  // 기존 id 유지
            device.ftype := deviceType;
            device.ftrainNo := StrToInt(grdDeviceList.Cells[1,i]);
            device.fipAddr := grdDeviceList.Cells[3,i];
            device.fstationCode := 0;
            device.fport := 80;
            device.fmemo := '';
            device.floginId := grdDeviceList.Cells[4,i];
            device.floginPwd := grdDeviceList.Cells[5,i];

            if gapi.UpdateDevice(device) = nil then
            begin
              ShowTVCSMessage('장치 정보 수정이 실패하였습니다.');
              Exit;
            end;
          finally
            FreeAndNil(device);
          end;
        end;
      end;
      ShowTVCSMessage('저장이 완료되었습니다.');
    end;
  end;
  addDevCnt := 0;
  //ModalResult := mrOk;
end;

procedure TfrmDevices.btnSearchClick(Sender: TObject);
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

  for i := 1 to grdDeviceList.RowCount - 1 do
  begin
    case searchMode of
      0: // 전체 검색
        if  grdDeviceList.Cells[1,i] = searchText then  // 열차번호명에서 찾은 경우
        begin
          grdDeviceList.SelectCells(1,i,1,i);
          found := true;
          Break;
        end
        else if grdDeviceList.Cells[2,i] = searchText then  // 장치구분에서 찾은 경우
        begin
          grdDeviceList.SelectCells(2,i,2,i);
          found := true;
          Break;
        end
        else if grdDeviceList.Cells[3,i] = searchText then
        begin
          grdDeviceList.SelectCells(3,i,3,i);
          found := true;
          Break;
        end;
      1: // 편성 검색
        if  grdDeviceList.Cells[1,i] = searchText then  // 열차번호명에서 찾은 경우
        begin
          grdDeviceList.SelectCells(1,i,1,i);
          found := true;
          Break;
        end;
      2: // 역사명 검색
         if grdDeviceList.Cells[2,i] = searchText then  // 장치구분에서 찾은 경우
        begin
          grdDeviceList.SelectCells(2,i,2,i);
          found := true;
          Break;
        end;
      3: // 역사명 검색
         if grdDeviceList.Cells[3,i] = searchText then  // 장치구분에서 찾은 경우
        begin
          grdDeviceList.SelectCells(3,i,3,i);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('검색 결과가 없습니다.');
end;

procedure TfrmDevices.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearchClick(Sender);
end;

procedure TfrmDevices.FormCreate(Sender: TObject);

begin
    addDevCnt := 0;
    TButtonStyler.ApplyGlobalStyle(Self);
    grdDeviceList.OnGetEditorType := grdDeviceListGetEditorType;
    grdDeviceList.OnGetEditorProp := grdDeviceListGetEditorProp;
    grdDeviceList.OnHasComboBox := grdDeviceListHasComboBox;
    grdDeviceList.OnClickCell := grdDeviceClickCell;
    LoadDeviceList;
    lblTitle.Caption := '장치 관리 ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'호선)'


end;

procedure TfrmDevices.LoadDeviceList;
var
  i: Integer;
  typeStr: string;
  validCount : integer;

begin
  // 그리드 헤더 설정
  with grdDeviceList do
  begin
    RowCount := 1;  // 헤더만 남기고 초기화
    ColCount := 8;  // 전체 컬럼 수 설정

    // 컬럼 너비 설정
    ColWidths[0] := 45;   // No.
    ColWidths[1] := 80;  // 열차 번호
    ColWidths[2] := 150;  // 장치 구분
    ColWidths[3] := 130;  // IP
    ColWidths[4] := 100;  // ID
    ColWidths[5] := 100;  // PW
    ColWidths[6] := 70;   // 상태
    ColWidths[7] := 40;   // 삭제

    // 헤더 텍스트 설정
    Cells[0,0] := 'No.';
    Cells[1,0] := '열차 번호';
    Cells[2,0] := '장치 구분';
    Cells[3,0] := 'IP';
    Cells[4,0] := 'ID';
    Cells[5,0] := 'PW';
    Cells[6,0] := '상태';
    Cells[7,0] := '삭제';
  end;
  // 엑셀 업로드인 경우
  if CheckExcel then
     begin
        //SetLength(BufDevices, GridBuf.RowCount -2);

         for i := 1 to GridBuf.RowCount do
         begin
           // 해당 행의 모든 필수 데이터가 있는지 확인
           if (GridBuf.Cells[1,i+1].Trim <> '') and  // 장치구분
              (GridBuf.Cells[3,i+1].Trim <> '') and  // 열차번호
              (GridBuf.Cells[4,i+1].Trim <> '') and  // IP
              (GridBuf.Cells[5,i+1].Trim <> '') and  // ID
              (GridBuf.Cells[6,i+1].Trim <> '') then // PW
           begin
             Inc(validCount);
             grdDeviceList.AddRow;
             grdDeviceList.Cells[0,validCount] := IntToStr(validCount);
             grdDeviceList.Cells[1,validCount] := GridBuf.Cells[3,i+1];
             grdDeviceList.Cells[2,validCount] := GridBuf.Cells[1,i+1];
             grdDeviceList.Cells[3,validCount] := GridBuf.Cells[4,i+1];
             grdDeviceList.Cells[4,validCount] := GridBuf.Cells[5,i+1];
             grdDeviceList.Cells[5,validCount] := GridBuf.Cells[6,i+1];
             grdDeviceList.Cells[6,validCount] := '활성';
             grdDeviceList.AddImageIdx(7, validCount, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
           end;
         end;
         lblDeviceCnt.Caption := '총:' + IntToStr(validCount) + '개';

     end
  else
  begin
    Devices := gapi.GetDevice();
    lblDeviceCnt.Caption := '총:' + IntToStr(Length(Devices)) + '개';


    for i := 0 to Length(Devices)-1 do
    begin
      // type에 따른 장치 구분 표시
      case StrToInt(Devices[i].ftype) of
        0: typeStr := 'TVCS';
        1: typeStr := '표출장치';
        2: typeStr := '대열차공간화상';
      end;

      with grdDeviceList do
      begin
        AddRow;
        Cells[0,i+1] := IntToStr(i+1);
        Cells[1,i+1] := IntToStr(Devices[i].ftrainNo);
        Cells[2,i+1] := typeStr;
        Cells[3,i+1] := Devices[i].fipAddr;
        Cells[4,i+1] := Devices[i].floginId;
        Cells[5,i+1] := Devices[i].floginPwd;


        Cells[6,i+1] := '활성';
        AddImageIdx(7, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
      end;
    end;
  end;
end;

procedure TfrmDevices.grdDeviceListHasComboBox(Sender: TObject; ACol,
  ARow: Integer; var HasComboBox: Boolean);
begin
  if (ACol = 2) and (ARow <> 0) then  // 2번 컬럼(장치 구분)에 콤보박스 표시
    HasComboBox := True;
end;

procedure TfrmDevices.grdDeviceListGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol = 2) then  // 2번 컬럼(장치 구분)
    AEditor := edComboList;
end;

procedure TfrmDevices.grdDeviceListGetEditorProp(Sender: TObject; ACol,
  ARow: Integer; AEditLink: TEditLink);
begin
  if (ACol = 2) then  // 2번 컬럼(장치 구분)
  begin
    with grdDeviceList do
    begin
      ClearComboString;
      AddComboString('TVCS');
      AddComboString('표출장치');
      AddComboString('대열차공간화상');
    end;
  end;
end;

procedure TfrmDevices.grdDeviceClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if (ARow > 0) and (ACol = 7) then  // 삭제 버튼 클릭
  begin
    if ShowTVCSCheck(1) then
    begin
      if ARow <= addDevCnt then  // 새로 추가된 행
        begin
          grdDeviceList.RemoveRows(ARow, 1);
          addDevCnt := addDevCnt - 1;  // 카운트 감소
        end
      else
      begin
        // API 호출하여 삭제
        if gapi.DeleteDevice(Devices[ARow-1].fid) <> '' then
        begin
          grdDeviceList.RemoveRows(ARow, 1);
          LoadDeviceList;
          ShowTVCSMessage('삭제되었습니다.');
        end
        else
          ShowTVCSMessage('삭제 실패하였습니다.');
      end;
    end;
  end;
end;


end.
