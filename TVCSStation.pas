unit TVCSStation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, AdvListV,
  AdvGlowButton, Vcl.ExtCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  System.ImageList, Vcl.ImgList; //, tmsAdvGridExcel;

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
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
  private
    Procedure LoadStationInfoList;
    Procedure LoadCamInfoList;
  public
    { Public declarations }
  end;

var
  frmStation: TfrmStation;

implementation

{$R *.dfm}

procedure TfrmStation.btnCancelClick(Sender: TObject);
begin
ModalResult:=mrCancel;
end;

procedure TfrmStation.btnDlgCloseClick(Sender: TObject);
begin
ModalResult:=mrAbort;
end;

procedure TfrmStation.btnSaveClick(Sender: TObject);
begin
ModalResult:=mrOk;
end;

procedure TfrmStation.FormCreate(Sender: TObject);
begin
//
LoadStationInfoList;
LoadCamInfoList;

end;

procedure TfrmStation.LoadStationInfoList;
begin
     with grdStations do begin
        RowCount:=1;
        ColCount:=4;
        ColWidths[0]:=60;
        ColWidths[1]:=120;
        ColWidths[2]:=250;
        ColWidths[3]:=100;
        Cells[0,0]:='No.';
        Cells[1,0]:='역번호';
        Cells[2,0]:='역사명';
        Cells[3,0]:='삭제';
   end;


end;


procedure TfrmStation.LoadCamInfoList;
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

end;

end.
