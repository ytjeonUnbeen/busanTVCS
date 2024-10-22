unit TVCSLayouts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.StdCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, AdvGlowButton, Vcl.ExtCtrls, Vcl.ComCtrls,
  AdvPageControl;

type
  TfrmLayouts = class(TForm)
    pnMainFrame: TPanel;
    lblInfoTitle: TLabel;
    lblTitle: TLabel;
    lblSubLine: TLabel;
    pnCamStationInfo: TPanel;
    btnSearch: TAdvGlowButton;
    cmbStation: TComboBox;
    edSearchText: TEdit;
    grdTrains: TAdvStringGrid;
    pnBottom: TPanel;
    btnCancel: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    lbTrainCamInfo: TLabel;
    AdvStringGrid1: TAdvStringGrid;
    tabTrainNo: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    lbLayoutName: TLabel;
    edLayoutName: TEdit;
    Label1: TLabel;
    edRTSPURL: TEdit;
    Label2: TLabel;
    groupLayout: TGroupBox;
    rdoLayout1: TRadioButton;
    rdoLayout2: TRadioButton;
    btnAddTabs: TButton;
    btnRemoveTabs: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLayouts: TfrmLayouts;

implementation

{$R *.dfm}

procedure TfrmLayouts.btnCancelClick(Sender: TObject);
begin
    ModalResult:=mrCancel;

end;

procedure TfrmLayouts.btnDlgCloseClick(Sender: TObject);
begin
     ModalResult:=mrAbort;
end;

procedure TfrmLayouts.btnSaveClick(Sender: TObject);
begin
     ModalResult:=mrOk;
end;

end.
