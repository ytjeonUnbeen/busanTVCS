unit TVCSStation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, AdvListV,
  AdvGlowButton, Vcl.ExtCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  System.ImageList, Vcl.ImgList ,tvcsAPI, tvcsProtocol, TVCSCheckDialog; //, tmsAdvGridExcel;

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
    Str: TLabel;
    pnBottom: TPanel;
    pnMainFrame: TPanel;
    grdStations: TAdvStringGrid;
    grdStationCams: TAdvStringGrid;
    ImageList1: TImageList;
    lbTvcsIpaddr: TLabel;
    edTvcsIpaddr: TEdit;


    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnAddStationClick(Sender: TObject);
  private
    //fapi:TTVCSAPI;
    addStCnt: integer;
    station : tvcsProtocol.TvcsStation;
    stations : TArray<tvcsProtocol.TvcsStation>;

    stationCam : TVCSStationCamera;
    stationCams : TArray<TVCSStationCamera>;

    Procedure LoadStationInfoList;
    Procedure LoadCamInfoList(stationCode: string = '');
    Procedure grdStationsClickCell(Sender: TObject; ARow, ACol: Integer);

  public
    { Public declarations }

  published
    //property api:ttvcsAPI read Fapi write Fapi;

  end;

var
  frmStation: TfrmStation;

implementation

{$R *.dfm}

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
end;

procedure TfrmStation.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TfrmStation.btnDlgCloseClick(Sender: TObject);
begin
ModalResult:=mrAbort;
end;

procedure TfrmStation.btnSaveClick(Sender: TObject);
var
  stationPos : TvcsStationInPost;
  station : tvcsProtocol.TvcsStation;

begin
  stationPos := TvcsStationInPost.Create;
  stationPos.fname := edStname.Text;
  stationPos.fcode := edStcode.Text;
  stationPos.fdepartDelay := StrToInt(edT1DepDownDelay.Text);
  stationPos.farriveDelaay := StrToInt(edT1DepUpDelay.Text);
  stationPos.ftvcsIpaddr := edTvcsIpaddr.Text;

  try
    station := gapi.AddStation(stationPos);
    if station <> nil then
      ShowTVCSMessage('역사정보가 추가되었습니다.')
    else
      ShowTVCSMessage('역사정보 추가가 실패하였습니다.');
  finally
    FreeAndNil(stationPos);
  end;


ModalResult:=mrOk;
end;

procedure TfrmStation.FormCreate(Sender: TObject);
begin
LoadStationInfoList;
LoadCamInfoList;
grdStations.OnClickCell := grdStationsClickCell;


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
    lblTotal.Caption := '총:' + IntTostr(size);
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
    AddButton(3, i+1, grdStations.ColWidths[3]-5, 20, '삭제', haCenter, vaCenter);

   end;
end;


procedure TfrmStation.LoadCamInfoList(stationCode: string);
begin
    with grdStationCams do begin
        RowCount:=1;
        ColCount:=7;
        ColWidths[0]:=120;ColWidths[1]:=250;ColWidths[2]:=150;
        ColWidths[3]:=450;ColWidths[4]:=150;ColWidths[5]:=150;ColWidths[6]:=100;
        Cells[0,0]:='구분.';
        Cells[1,0]:='카메라명';
        Cells[2,0]:='IP Addr';
        Cells[3,0]:='RTSP 주소 ';
        Cells[4,0]:='ID';
        Cells[5,0]:='Password';
        Cells[6,0]:='삭제';
    end;

    if stationCode <> '' then
    begin
      stationCams := gapi.GetStationCamera(stationCode);
    end;



end;

procedure TfrmStation.grdStationsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  station: tvcsProtocol.TvcsStation;
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
          station:= stations[ARow-1 -addStCnt];
          stationcode := station.fcode;
          edStcode.Text := station.fcode;
          edStname.Text := station.fname;
          edT1DepDownDelay.Text := intTostr(station.fdepartDelay);
          edT1DepUpDelay.Text := intToStr(station.farriveDelay);
          edTvcsIpaddr.Text := station.ftvcsIpaddr;


          LoadCamInfoList(station.fcode);



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

end.
