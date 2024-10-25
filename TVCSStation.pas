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
    Cells[0,1] := '����';
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
  if (ACol = 0) and (ARow <> 0)then  // ù��° ���� �޺��ڽ� ǥ��
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
      AddComboString('����');
      AddComboString('����');
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

// ����
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
      // ���� �⺻���� ����
      stationPos.fname := edStname.Text;
      stationPos.fcode := edStcode.Text;
      stationPos.fdepartDelay := StrToInt(edT1DepDownDelay.Text);
      stationPos.farriveDelaay := StrToInt(edT1DepUpDelay.Text);
      stationPos.ftvcsIpaddr := edTvcsIpaddr.Text;

      allSuccess := True;

      // 1. ���� ���� �߰� �Ǵ� ����
      if addStCnt > 0 then  // ���� ���� �߰�
      begin
        station := gapi.AddStation(stationPos);
        if station = nil then
        begin
          ShowTVCSMessage('�������� �߰��� �����Ͽ����ϴ�.');
          Exit;
        end;
      end
      else  // ���� ���� ����
      begin
        if nil = gapi.UpdateStation(stationPos) then
        begin
          ShowTVCSMessage('�������� ������ �����Ͽ����ϴ�.');
          Exit;
        end;
      end;

      // 2. ���� �߰��� ī�޶� ���� ó��
      if addCamCnt > 0 then
      begin
        SetLength(stationCamsPos, addCamCnt);

        // ���� �߰��� �����͸� ó�� (1�� �ο���� addCamCnt�� ��ŭ)
        for i := 1 to addCamCnt do
        begin
          stationCamsPos[i-1] := TVCSStationCameraPost.Create;
          with stationCamsPos[i-1] do
          begin
            fstationCode := edStcode.Text;
            if grdStationCams.Cells[0,i] = '����' then
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
          // ���� �߰��� ī�޶� ���� �߰�
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
          // ������ ī�޶� ��ü�� ����
          for i := 0 to Length(stationCamsPos) - 1 do
          begin
            if Assigned(stationCamsPos[i]) then
              FreeAndNil(stationCamsPos[i]);
          end;
        end;
      end;

      // 3. ���� ī�޶� ���� ���� ó��
      for i := 1 to grdStationCams.RowCount - 1 do
      begin
        isModified := False;

        if i <= addCamCnt then
          Continue;

        j := i - addCamCnt - 1;
        if (j >= 0) and (j < Length(stationCams)) then
        begin
          // ������ ������ ������Ʈ
          stationCamPatch := TVCSStationCameraPatch.Create;
          try
            stationCamPatch.fid := stationCams[j].fid;
            stationCamPatch.fstationCode := edStcode.Text;
            if grdStationCams.Cells[0,i] = '����' then
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
        ShowTVCSMessage('ó���� �Ϸ�Ǿ����ϴ�.')
      else
        ShowTVCSMessage('�Ϻ� ó���� �����Ͽ����ϴ�.');

      addStCnt := 0;  // ó�� �Ϸ� �� ī��Ʈ �ʱ�ȭ

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
    lblTotal.Caption := '��:' + IntTostr(size) + '��';
    delBtn := Tbutton.Create(self);
    delBtn.Caption := '����';

    with grdStations do
    begin
        RowCount:=1;
        ColCount:=4;
        ColWidths[0]:=60;
        ColWidths[1]:=80;
        ColWidths[2]:=120;
        ColWidths[3]:=60;
        Cells[0,0]:='No.';
        Cells[1,0]:='����ȣ';
        Cells[2,0]:='�����';
        Cells[3,0]:='����';
   end;

   for i := 0 to size-1 do
   with grdStations do
   begin
    AddRow;
    Cells[0,i+1] := inttostr(i+1);
    Cells[1,i+1] := stations[i].fcode;
    Cells[2,i+1] := stations[i].fname;

    //AddButton(3, i+1, grdStations.ColWidths[3]-5, 20, '����', haCenter, vaCenter);
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
        ColWidths[0] := 60;   // ����
        ColWidths[1] := 120;  // ī�޶��
        ColWidths[2] := 120;  // IP Addr
        ColWidths[3] := 60;   // Port
        ColWidths[4] := 120;  // RTSP High
        //ColWidths[5] := 120;  // RTSP Low

        ColWidths[5] := 72;   // ID
        ColWidths[6] := 82;   // Password
        ColWidths[7] := 45;   // �̸����� ��ư
        ColWidths[8] := 45;   // ���� ��ư

        Cells[0,0]:='����.';
        Cells[1,0]:='ī�޶��';
        Cells[2,0]:='IP Addr';
        Cells[3,0]:= 'Port';
        Cells[4,0]:='RTSP �ּ� ';
        Cells[5,0]:='ID';
        Cells[6,0]:='Password';
        Cells[7,0]:='�̸�����';
        Cells[8,0]:='����';
        FixedRows := 0;
        FixedCols := 0;
        AddComboString('����');
        AddComboString('����');

        for i := 0 to 8 do
          begin
            ReadOnly[i,0] := True;
          end;

    end;

    if stationCode <> '' then
    begin
      stationCams := gapi.GetStationCamera(stationCode);

      size := Length(stationCams);
      lbStCamCnt.Caption := '��: '+ IntToStr(size) + '��';
      if size > 0 then
        begin
          for i := 0 to size-1 do
           with grdStationCams do
           begin
             AddRow;

             if stationCams[i].fdivision = 1 then
              division := '����'
             else
              division := '����';

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

// �������� Ȯ�� or ����
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
                  ShowTVCSMessage('���� �Ǿ����ϴ�. ');
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


// ����ī�޶� �̸����� or ����
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
          ShowTVCSMessage('���� �Ǿ����ϴ�. ');
        end;
      end;

    // �̸�����
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
