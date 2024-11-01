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
    AdvGridExcelIO1: TAdvGridExcelIO;
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
    Cells[7,1] := '';
    AddImageIdx(8, 1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
    AddImageIdx(9, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
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
        // 1. ���� ������ ����
        existingTrains := gapi.GetTrain(-1);
        for i := 0 to Length(existingTrains)-1 do
        begin
          // �� ������ ī�޶� ���� ����
          existingCams := gapi.GetTrainCamera(existingTrains[i].fid);
          for j := 0 to Length(existingCams)-1 do
          begin
            if gapi.DeleteTrainCamera(existingCams[j].fid) = '' then
            begin
              allSuccess := False;
              ShowTVCSMessage('ī�޶� ���� ���� �� ������ �߻��߽��ϴ�.');
              Exit;
            end;
          end;

          // ���� ���� ����
          if gapi.DeleteTrain(existingTrains[i].fid) = '' then
          begin
            allSuccess := False;
            ShowTVCSMessage('���� ���� ���� �� ������ �߻��߽��ϴ�.');
            Exit;
          end;
        end;

        // 2. ���� ������ �߰�
        // 2-1. ���� ���� ��
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
               ShowTVCSMessage(Format('���� ���� �߰� �� ������ �߻��߽��ϴ�. (������ȣ: %s)', [trains[i].ftrainNo]));
               Exit;
             end;
           finally
             FreeAndNil(trainPos);
           end;
         end;

        // 2-3. ī�޶� ���� �߰�
         SetLength(trainCamPos, Length(BufTrainCams));
         try
           for i := 0 to Length(BufTrainCams)-1 do
           begin
             trainCamPos[i] := TVCSTrainCameraInPost.Create;
             with trainCamPos[i] do
             begin
               ftrainNo := IntToStr(BufTrainCams[i].ftrainNo);
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
               ShowTVCSMessage(Format('ī�޶� ���� �߰� �� ������ �߻��߽��ϴ�. (������ȣ: %s, ī�޶��: %s)',
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
          ShowTVCSMessage('���� ������ ���ε尡 �Ϸ�Ǿ����ϴ�.');
          CheckExcel := False;
          LoadTrainList;
          
        end;
      except
        on E: Exception do
          ShowTVCSMessage('ó�� �� ������ �߻��߽��ϴ�: ' + E.Message);
      end;
    end
    else
    begin
      size := grdTrainCams.RowCount - 1;
    trainPos := TVCSTrainInPost.Create;
    //ShowTVCSMessage(inttostr(size));

    try
      allSuccess := True;

      // �����߰�
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
          ShowTVCSMessage('�������� �߰��� �����Ͽ����ϴ�.');
          Exit;
        end;
      end
      // ��������
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
          ShowTVCSMessage('�������� ������ �����Ͽ����ϴ�.');
          Exit;
        end;
      end;

      // ����ķ��
      if addTrCamCnt > 0 then
      begin
        SetLength(trainCamPos, addTrCamCnt);

        for i := 1 to addTrCamCnt do
        begin
          trainCamPos[i-1] := TVCSTrainCameraInPost.Create;
          with trainCamPos[i-1] do
          begin
            ftrainNo := SelTrain.ftrainNo;
            fname := grdTrainCams.Cells[1,i];
            fipaddr := grdTrainCams.Cells[2,i];
            fport := StrToInt(grdTrainCams.Cells[3,i]);
            frtsp := grdTrainCams.Cells[4,i];
            frtsp2 := grdTrainCams.Cells[5,i];

            fuserId := grdTrainCams.Cells[6,i];
            fuserPwd := grdTrainCams.Cells[7,i];

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
          // ������ ī�޶� ��ü�� ����
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
            // ������ ������ ������Ʈ
            trainCamPatch := TVCSTrainCameraInPatch.Create;
            try
              trainCamPatch.fid := trainCams[j].fid;
              trainCamPatch.ftrainId := SelTrain.fid;
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
          ShowTVCSMessage('ó���� �Ϸ�Ǿ����ϴ�.')
        else
          ShowTVCSMessage('�Ϻ� ó���� �����Ͽ����ϴ�.');

        addTrCnt := 0;


      finally
        FreeAndNil(trainPos);
      end;

    end;
  end;


  ModalResult:=mrOk;
end;




procedure TfrmTrain.btnStationDownloadClick(Sender: TObject);
var
  SaveDialog : TSaveDialog;
begin
//
  SaveDialog := TSaveDialog.Create(nil);
  SaveDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls';
  SaveDialog.DefaultExt := 'xls';
  SaveDialog.FilterIndex := 2;

  if SaveDialog.Execute then
  begin
    AdvGridExcelIO1.XLSExport(SaveDialog.FileName);
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


procedure TfrmTrain.FormCreate(Sender: TObject);
begin

  addTrCnt := 0;
  addTrCamCnt := 0;

  LoadTrainList;
  LoadTrainCamList;

  //��ư
  TButtonStyler.ApplyGlobalStyle(Self);

  grdTrains.OnClickCell := grdTrainsClickCell;
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

        // GridBuf���� �ش� ������ ���� ã�� (������ ������)
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
  lblTotal.Caption := '�� :' + IntToStr(size) +'��';
  delBtn := TButton.Create(self);
  delBtn.Caption := '����';

  with grdTrains do
  begin
    RowCount :=1;
    ColCount:=4;
    ColWidths[0]:=60;
    ColWidths[1]:=80;
    ColWidths[2]:=120;
    ColWidths[3]:=60;

    Cells[0,0]:='No.';
    Cells[1,0]:='����ȣ';
    Cells[2,0]:='������ȣ';
    Cells[3,0]:='����';
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
    ColCount:=10;
    //760
    ColWidths[0] := 60;   // ����
    ColWidths[1] := 100;  // ī�޶��
    ColWidths[2] := 120;  // IP Addr
    ColWidths[3] := 60;   // Port
    ColWidths[4] := 120;  // RTSP High
    ColWidths[5] := 120;  // RTSP Low

    ColWidths[6] := 72;   // ID
    ColWidths[7] := 82;   // Password
    ColWidths[8] := 45;   // �̸����� ��ư
    ColWidths[9] := 45;   // ���� ��ư

    Cells[0,0]:='������ȣ';
    Cells[1,0]:='ī�޶��';
    Cells[2,0]:='IP Addr';
    Cells[3,0]:= 'Port';
    Cells[4,0]:='RTSP �ּ�1 ';
    Cells[5,0]:='RTSP �ּ�2 ';

    Cells[6,0]:='ID';
    Cells[7,0]:='Password';
    Cells[8,0]:='�̸�����';
    Cells[9,0]:='����';

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
    if CheckExcel then
    begin
      // ��� �����͸� BufTrainCams�� ����
      SetLength(BufTrainCams, GridBuf.rowcount - 2);
      for i := 0 to Length(BufTrainCams) - 1 do
      begin
        BufTrainCams[i] := TVCSTrainCamera.Create;
        BufTrainCams[i].ftrainNo := StrToInt(GridBuf.Cells[2,i+2]);
        BufTrainCams[i].fname := GridBuf.Cells[7,i+2];
        BufTrainCams[i].fipaddr := GridBuf.Cells[8,i+2];
        BufTrainCams[i].fport := StrToInt(GridBuf.Cells[9,i+2]);
        BufTrainCams[i].frtsp := GridBuf.Cells[10,i+2];
        BufTrainCams[i].frtsp2 := GridBuf.Cells[11,i+2];
        BufTrainCams[i].fuserId := GridBuf.Cells[12,i+2];
        BufTrainCams[i].fuserPwd := GridBuf.Cells[13,i+2];
      end;

      // trainId�� �ش��ϴ� ī�޶� ���͸�
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
    lblCamCnt.Caption := '��:' + IntToStr(size) + '��';

    if size > 0 then
    begin
      for i := 0 to size-1 do
       with grdTrainCams do
       begin
         AddRow;

         Cells[0,i+1] := IntToStr(trainCams[i].ftrainNo);
         Cells[1,i+1] := trainCams[i].fname;
         Cells[2,i+1] := trainCams[i].fipaddr;
         Cells[3,i+1] := IntToStr(trainCams[i].fport);
         Cells[4,i+1] := trainCams[i].frtsp;
         Cells[5,i+1] := trainCams[i].frtsp;

         Cells[6,i+1] := trainCams[i].fuserId;
         Cells[7,i+1] := trainCams[i].fuserPwd;

         AddImageIdx(8, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
         AddImageIdx(9, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

       end;

    end;
  end;
end;

//���� ����/����
procedure TfrmTrain.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  ftrainNo : integer;
begin
//
  if ARow > 0 then
  begin
      if Acol =3 then
      begin
        try
        if ShowTVCSCheck(1) then
          begin
          // ����
            gapi.DeleteTrain(Trains[ARow-1 - addTrCnt].fid);
            grdTrains.RemoveRows(ARow, 1);
            edscNo.Text := '';
            edTrainNo.Text := '';
            edTrainCnt.Text := '0';
            edNvrRTSP.Text := '';
            ShowTVCSMessage('���� �Ǿ����ϴ�. ');
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
          edTrainCnt.Text := '0';
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
    if ACol = 9 then
      begin
        if ShowTVCSCheck(1) then
        begin
          gapi.DeleteTrainCamera(trainCams[ARow-1 -addTrCnt].fid);
          grdTrainCams.RemoveRows(ARow, 1);
          LoadTrainCamList(SelTrain.fid);
          addTrCamCnt := 0;
          ShowTVCSMessage('���� �Ǿ����ϴ�. ');
        end;
      end;

    // �̸�����
    if ACol = 8 then
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

end.
