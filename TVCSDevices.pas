unit TVCSDevices;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls,
  AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvGlowButton;

type
  TfrmDevices = class(TForm)
    pnMainFrame: TPanel;
    pnBottom: TPanel;
    lblTitle: TLabel;
    lblSubLine: TLabel;
    cbxSearch: TDBComboBox;
    edtSerch: TEdit;
    btnSerch: TButton;
    lblDeviceCnt: TLabel;
    grdDeviceList: TAdvStringGrid;
    lblDeviceInfo: TLabel;
    lglLegend: TLabel;
    btnAddDevice: TButton;
    btnDeviceUpload: TAdvGlowButton;
    btnDeviceDownload: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);







  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadDeviceList;


  end;

var
  frmDevices: TfrmDevices;

implementation

{$R *.dfm}

procedure TfrmDevices.btnCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;

end;

procedure TfrmDevices.btnDlgCloseClick(Sender: TObject);
begin
    ModalResult := mrAbort;

end;

procedure TfrmDevices.btnSaveClick(Sender: TObject);
begin
     ModalResult := mrOk;
end;

procedure TfrmDevices.FormCreate(Sender: TObject);

begin


    LoadDeviceList;

end;

procedure TfrmDevices.LoadDeviceList;
begin
     with grdDeviceList do begin
        RowCount:=1;
        ColCount:=8;
        ColWidths[0]:=40;
        ColWidths[1]:=200;
        ColWidths[2]:=90;
        ColWidths[3]:=120;
        ColWidths[4]:=60;
        ColWidths[5]:=60;
        ColWidths[6]:=90;
        ColWidths[7]:=50;

        Cells[0,0]:='No.';
        Cells[1,0]:='열차 번호';
        Cells[2,0]:='장치 구분';
        Cells[3,0]:='IP';
        Cells[4,0]:='ID';
        Cells[5,0]:='PW';
        Cells[6,0]:='상태';
        Cells[7,0]:='삭제';
     end;

   end;


end.
