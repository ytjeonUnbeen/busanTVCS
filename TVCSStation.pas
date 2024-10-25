unit TVCSStation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, AdvListV,
  AdvGlowButton, Vcl.ExtCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  System.ImageList, Vcl.ImgList ,tvcsAPI, tvcsProtocol, TVCSCheckDialog, TVCSPreview,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList,
  AdvStyleIF, AdvAppStyler; //, tmsAdvGridExcel;

type
  TfrmStation = class(TForm)
    cmbStation: TComboBox;
    edSearchText: TEdit;
    btnSearch: TAdvGlowButton;
    btnAddStation: TAdvGlowButton;
    pnCamStationInfo: TPanel;
    edStcode: TEdit;
    edStname: TEdit;
    edT1DepUpDelay: TEdit;
    edT1DepDownDelay: TEdit;
    edT1UpArrDelay: TEdit;
    edT1DownArrDelay: TEdit;
    btnAddCams: TAdvGlowButton;
    btnUploadStations: TAdvGlowButton;
    btnStationDownload: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    lblTitle: TLabel;
    pnDefStation: TPanel;
    pnT1Delay: TPanel;
    pnCamInfos: TPanel;
    lblTotal: TLabel;
    lblstCode: TLabel;
    lblStname: TLabel;
    lblT1Delay: TLabel;
    lblT1UpDep: TLabel;
    lblT1DownDep: TLabel;
    lblT1UpArr: TLabel;
    lblT1DownArr: TLabel;
    lblInfoTitle: TLabel;
    Label2: TLabel;
    lbStCamCnt: TLabel;
    pnBottom: TPanel;
    pnMainFrame: TPanel;
    grdStations: TAdvStringGrid;
    grdStationCams: TAdvStringGrid;
    ImageList1: TImageList;
    lbTvcsIpaddr: TLabel;
    edTvcsIpaddr: TEdit;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    AdvFormStyler1: TAdvFormStyler;
    AdvAppStyler1: TAdvAppStyler;


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


  private
    //fapi:TTVCSAPI;

    addStCnt: integer;
    addCamCnt: integer;

    SelectStation : tvcsProtocol.TvcsStation;
    stations : TArray<tvcsProtocol.TvcsStation>;

    stationCam : TVCSStationCamera;
    stationCams : TArray<TVCSStationCamera>;
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

  addStCnt := addStCnt + 1;
  with grdStations do
  begin
    InsertChildRow(0);
    Cells[0,1] := '0';
    Cells[1,1] := 'NULL';
    Cells[2,1] := 'NULL';
  end;

  edStcode.Text := '';
  edStname.Text := '';
  edT1DepDownDelay.Text := '0';
  edT1DepUpDelay.Text := '0';
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
  station: tvcsProtocol.TvcsStation;
  stationCamsPos: TArray<TVCSStationCameraPost>;
  stationCamPatch: TVCSStationCameraPatch;
  stationCam: TVCSStationCamera;
  i, j: Integer;
  allSuccess: Boolean;
  isModified: Boolean;
begin
  if ShowTVCSCheck(0) then
  begin
    stationPos := TvcsStationInPost.Create;
    try
      // 역사 기본정보 설정
      stationPos.fname := edStname.Text;
      stationPos.fcode := edStcode.Text;
      stationPos.fdepartDelay := StrToInt(edT1DepDownDelay.Text);
      stationPos.farriveDelaay := StrToInt(edT1DepUpDelay.Text);
      stationPos.ftvcsIpaddr := edTvcsIpaddr.Text;

      allSuccess := True;

      // 1. 역사 정보 추가 또는 수정
      if addStCnt > 0 then  // 역사 정보 추가
      begin
        station := gapi.AddStation(stationPos);
        if station = nil then
        begin
          ShowTVCSMessage('역사정보 추가가 실패하였습니다.');
          Exit;
        end;
      end
      else  // 역사 정보 수정
      begin
        if nil = gapi.UpdateStation(stationPos) then
        begin
          ShowTVCSMessage('역사정보 수정이 실패하였습니다.');
          Exit;
        end;
      end;

      // 2. 새로 추가된 카메라 정보 처리
      if addCamCnt > 0 then
      begin
        SetLength(stationCamsPos, addCamCnt);

        // 새로 추가된 데이터만 처리 (1번 로우부터 addCamCnt개 만큼)
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
            fuserId := grdStationCams.Cells[5,i];
            fuserPwd := grdStationCams.Cells[6,i];
          end;
        end;

        try
          // 새로 추가된 카메라 정보 추가
          for i := 0 to Length(stationCamsPos) - 1 do
          begin
            stationCam := gapi.AddStationCamera(stationCamsPos[i]);
            if stationCam = nil then
            begin
              allSuccess := False;
              Break;
            end;
          end;
        finally
          // 생성된 카메라 객체들 해제
          for i := 0 to Length(stationCamsPos) - 1 do
          begin
            if Assigned(stationCamsPos[i]) then
              FreeAndNil(stationCamsPos[i]);
          end;
        end;
      end;

      // 3. 기존 카메라 정보 수정 처리
      for i := 1 to grdStationCams.RowCount - 1 do
      begin
        isModified := False;

        if i <= addCamCnt then
          Continue;

        j := i - addCamCnt - 1;
        if (j >= 0) and (j < Length(stationCams)) then
        begin
          // 수정된 데이터 업데이트
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
            stationCamPatch.fuserId := grdStationCams.Cells[5,i];
            stationCamPatch.fuserPwd := grdStationCams.Cells[6,i];

            if nil = gapi.UpdateStationCamera(stationCamPatch) then
              allSuccess := False;
          finally
            FreeAndNil(stationCamPatch);
          end;
        end;
      end;

      if allSuccess then
        ShowTVCSMessage('처리가 완료되었습니다.')
      else
        ShowTVCSMessage('일부 처리가 실패하였습니다.');

      addStCnt := 0;  // 처리 완료 후 카운트 초기화

    finally
      FreeAndNil(stationPos);
    end;
  end;

  ShowTVCSMessage(IntToStr(addCamCnt));
  ModalResult := mrOk;
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

  AdvAppStyler1.Style := tsOffice2003Blue;
  //AdvAppStyler1.AppColor := clHighlight;
  AdvFormStyler1.AppStyle := AdvAppStyler1;


end;

procedure TfrmStation.FormDestroy(Sender: TObject);
begin
//
end;

procedure TfrmStation.LoadStationInfoList;
var
    str : string;
    size: integer;
    i : integer;
    delBtn : TButton;

begin
    str := gapi.GetLoinInfo.ffirstName;
    stations := gapi.GetStation('',gapi.GetLoinInfo.fsystem.fline);
    size := Length(stations);
    lblTotal.Caption := '총:' + IntTostr(size) + '개';
    delBtn := Tbutton.Create(self);
    delBtn.Caption := '삭제';

    with grdStations do
    begin
        RowCount:=1;
        ColCount:=4;
        ColWidths[0]:=60;
        ColWidths[1]:=80;
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
  i : integer;
  size : integer;
  division : string;


begin

    with grdStationCams do begin
        RowCount:=1;
        ColCount:=9;
        //760
        ColWidths[0] := 60;   // 구분
        ColWidths[1] := 120;  // 카메라명
        ColWidths[2] := 120;  // IP Addr
        ColWidths[3] := 60;   // Port
        ColWidths[4] := 120;  // RTSP High
        //ColWidths[5] := 120;  // RTSP Low

        ColWidths[5] := 72;   // ID
        ColWidths[6] := 82;   // Password
        ColWidths[7] := 45;   // 미리보기 버튼
        ColWidths[8] := 45;   // 삭제 버튼

        Cells[0,0]:='구분.';
        Cells[1,0]:='카메라명';
        Cells[2,0]:='IP Addr';
        Cells[3,0]:= 'Port';
        Cells[4,0]:='RTSP 주소 ';
        Cells[5,0]:='ID';
        Cells[6,0]:='Password';
        Cells[7,0]:='미리보기';
        Cells[8,0]:='삭제';
        FixedRows := 0;
        FixedCols := 0;
        AddComboString('상행');
        AddComboString('하행');

        for i := 0 to 8 do
          begin
            ReadOnly[i,0] := True;
          end;

    end;

    if stationCode <> '' then
    begin
      stationCams := gapi.GetStationCamera(stationCode);

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
             Cells[5,i+1] := stationCams[i].fuserId;
             Cells[6,i+1] := stationCams[i].fuserPwd;

             //bitbutton bitmap
             //AddBitButton(7,i+1, 25, 25, '', preImg, haCenter, vaCenter);
             //AddBitButton(8,i+1, 25, 25, '', delImg, haCenter, vaCenter);


             AddImageIdx(7, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
             AddImageIdx(8, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

             //AddBitButton(8,i+1, 35, 35, '', imagecollection1.GetBitmap(1,33,33), haCenter, vaCenter);
             //TCellType.ctBitButton

             //VirtualImageList1.get

             //AddImageIdx(7, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
             //AddImageIdx(8, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
             //ReadOnly[7,  i+1] := true;

           end;

        end;
    end;
end;

// 역사정보 확인 or 삭제
procedure TfrmStation.grdStationsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  //station: tvcsProtocol.TvcsStation;
  stationCam: TVCSStationCamera;
  i, size: integer;
  stationcode : string;

begin
  if ARow > 0 then
  begin
      if Acol = 3 then
      begin
          try
             if ShowTVCSCheck(1) then
              begin
                  gapi.DeleteStation(stations[ARow-1 -addStCnt].fcode);
                  grdStations.RemoveRows(ARow, 1);
                  LoadStationInfoList;
                  edStcode.Text := '';
                  edStname.Text := '';
                  edT1DepDownDelay.Text := '0';
                  edT1DepUpDelay.Text := '0';
                  edTvcsIpaddr.Text := '';
                  ShowTVCSMessage('삭제 되었습니다. ');
              end;
          finally
          end;

      end else
      begin
        try
          SelectStation:= stations[ARow-1 -addStCnt];
          stationcode := SelectStation.fcode;
          edStcode.Text := SelectStation.fcode;
          edStname.Text := SelectStation.fname;
          edT1DepDownDelay.Text := intTostr(SelectStation.fdepartDelay);
          edT1DepUpDelay.Text := intToStr(SelectStation.farriveDelay);
          edTvcsIpaddr.Text := SelectStation.ftvcsIpaddr;
          LoadCamInfoList(SelectStation.fcode);
        except
          edStcode.Text := '';
          edStname.Text := '';
          edT1DepDownDelay.Text := '0';
          edT1DepUpDelay.Text := '0';
          edTvcsIpaddr.Text := '';
        end;
      end;
  end;
end;


// 역사카메라 미리보기 or 삭제
Procedure TfrmStation.grdStationsCamsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  ShowPreview: TfrmPreview;

begin
//
if ARow > 0 then
  begin
    if ACol = 8 then
      begin
        if ShowTVCSCheck(1) then
        begin
          gapi.DeleteStationCamera(stationCams[ARow-1 -addStCnt].fid);
          grdStationCams.RemoveRows(ARow, 1);
          LoadCamInfoList(SelectStation.fcode);
          addCamCnt := 0;
          ShowTVCSMessage('삭제 되었습니다. ');
        end;
      end;

    // 미리보기
    if ACol = 7 then
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
