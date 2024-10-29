unit TVCSTrain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  TvcsApi, tvcsProtocol, TVCSButtonStyle, System.ImageList, Vcl.ImgList, TVCSCheckDialog,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

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
    btnSearch: TAdvGlowButton;
    btnStationDownload: TAdvGlowButton;
    btnUploadStations: TAdvGlowButton;
    cmbStation: TComboBox;
    edSearchText: TEdit;
    grdTrainCams: TAdvStringGrid;
    lblTrainCnt: TLabel;
    edTrainCnt: TEdit;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);

    procedure LoadTrainList(trainNo: string='');
    procedure LoadTrainCamList(trainId: Integer =-1);
    procedure FormCreate(Sender: TObject);
    procedure btnAddTrainClick(Sender: TObject);
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure btnAddCamsClick(Sender: TObject);


  private
    { Private declarations }
    addTrCnt, addTrCamCnt: integer;

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
//
  addTrCamCnt := addTrCamCnt +1;
  with grdTrainCams do
  begin
    InsertChildRow(0);
    Cells[0,1] := '';
    Cells[1,1] := '';
    Cells[2,1] := '';
    Cells[3,1] := '80';
    Cells[4,1] := '';
    Cells[5,1] := '';
    Cells[6,1] := '';
    AddImageIdx(7, 1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
    AddImageIdx(8, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
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

  end;

  edscNo.Text := '';
  edTrainNo.Text := '';
  edTrainCnt.Text := '0';
  edNvrRTSP.text := '';
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

  i, j: integer;
  size: integer;
begin
  if ShowTVCSCheck(0) then
  begin
    size := grdTrainCams.RowCount - 1;
    //ShowTVCSMessage(inttostr(size));

    try
      allSuccess := True;

      // 열차추가
      if addTrCnt > 0 then
      begin
        trainPos := TVCSTrainInPost.Create;
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
            ftrainId := StrToInt(edTrainNo.Text);
            fname := grdTrainCams.Cells[1,i];
            fipaddr := grdTrainCams.Cells[2,i];
            fport := StrToInt(grdTrainCams.Cells[3,i]);
            frtsp := grdTrainCams.Cells[4,i];
            fuserId := grdTrainCams.Cells[5,i];
            fuserPwd := grdTrainCams.Cells[6,i];

            fposition := 0;
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

        if i <= addTrCamCnt then
          Continue;

        j := i - addTrCamCnt - 1;
        if (j >= 0) and (j < Length(trainCams)) then
        begin
          // 수정된 데이터 업데이트
          trainCamPatch := TVCSTrainCameraInPatch.Create;
          try
            trainCamPatch.fid := trainCams[j].fid;
            trainCamPatch.ftrainId := StrToInt(edTrainNo.Text);
            trainCamPatch.fname := grdTrainCams.Cells[1,i];
            trainCamPatch.fipaddr := grdTrainCams.Cells[2,i];
            trainCamPatch.fport := StrToInt(grdTrainCams.Cells[3,i]);
            trainCamPatch.frtsp := grdTrainCams.Cells[4,i];
            trainCamPatch.fuserId := grdTrainCams.Cells[5,i];
            trainCamPatch.fuserPwd := grdTrainCams.Cells[6,i];

            if nil = gapi.UpdateTrainCamera(trainCamPatch) then
              allSuccess := False;
          finally
            FreeAndNil(trainCamPatch);
          end;
        end;
      end;

      if allSuccess then
        ShowTVCSMessage('처리가 완료되었습니다.')
      else
        ShowTVCSMessage('일부 처리가 실패하였습니다.');

      addTrCnt := 0;

      end;
    finally
      FreeAndNil(trainPos);
    end;

  end;


  ModalResult:=mrOk;
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
end;

procedure TfrmTrain.LoadTrainList(trainNo: string='');
var
  size, i : integer;
  delBtn : TButton;

begin
  //
  trains := gapi.GetTrain(-1);
  size := Length(trains);
  lblTotal.Caption := '총 :' + IntToStr(size) +'개';
  delBtn := TButton.Create(self);
  delBtn.Caption := '삭제';

  with grdTrains do
  begin
    RowCount :=1;
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
  i, size : integer;

begin
  //
  with grdTrainCams do
  begin
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

    Cells[0,0]:='객차번호';
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

    for i := 0 to 8 do
      begin
        ReadOnly[i,0] := True;
      end;

  end;


  //ShowTVCSMessage(intTostr(trainId));
  if trainId <> -1 then
  begin
    trainCams := Gapi.GetTrainCamera(trainId);
    size := length(trainCams);
    lblCamCnt.Caption := '총:' + IntToStr(size) + '개';

    if size > 0 then
    begin
      for i := 0 to size-1 do
       with grdTrainCams do
       begin
         AddRow;

         Cells[0,i+1] := IntToStr(trainCams[i].ftrainId);
         Cells[1,i+1] := trainCams[i].fname;
         Cells[2,i+1] := trainCams[i].fipaddr;
         Cells[3,i+1] := IntToStr(trainCams[i].fport);
         Cells[4,i+1] := trainCams[i].frtsp;
         Cells[5,i+1] := trainCams[i].fuserId;
         Cells[6,i+1] := trainCams[i].fuserPwd;

         AddImageIdx(7, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
         AddImageIdx(8, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

       end;

    end;
  end;
end;

procedure TfrmTrain.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  trainId : integer;
begin
//
  if ARow > 0 then
  begin
      if Acol =3 then
      begin
        try
        if ShowTVCSCheck(1) then
          begin
          // 삭제
            gapi.DeleteTrain(Trains[ARow-1 - addTrCnt].fid);
            grdTrains.RemoveRows(ARow, 1);
            edscNo.Text := '';
            edTrainNo.Text := '';
            edTrainCnt.Text := '0';
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
          trainId := SelTrain.fid;
          edscNo.Text := IntToStr(SelTrain.fformatNo);
          edTrainNo.Text := SelTrain.ftrainNo;
          edTrainCnt.Text := IntToStr(SelTrain.fcarriageNum);
          edNvrRTSP.text := SelTrain.ftvcsIpaddr;
          LoadTrainCamList(SelTrain.fid);
        except
          edscNo.Text := '';
          edTrainNo.Text := '';
          edTrainCnt.Text := '0';
          edNvrRTSP.text := '';
          LoadTrainCamList;

        end;
      end;
  end;

end;



end.
