unit TVCSTrain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid;

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

    lblSubLine: TLabel;
    lblTrainCnt: TLabel;
    edTrainCnt: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTrain: TfrmTrain;

implementation

{$R *.dfm}

  procedure TfrmTrain.btnCancelClick(Sender: TObject);
  begin
    ModalResult:=mrCancel;
  end;

  procedure TfrmTrain.btnDlgCloseClick(Sender: TObject);
  begin
    ModalResult:=mrAbort;
  end;

  procedure TfrmTrain.btnSaveClick(Sender: TObject);
  begin
    ModalResult:=mrOk;
  end;




end.
