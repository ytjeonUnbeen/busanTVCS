unit TVCSSystemSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.DBCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  TVCSPopupView;

type
  TfrmSystem = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lblTitle: TLabel;
    lbConViewSetTitle: TLabel;
    lbConViewSetMenu: TLabel;
    chkConViewSet: TCheckBox;
    lbAutoSetTitle: TLabel;
    lbAutoSetMenu: TLabel;
    speAutoSetCnt: TSpinEdit;
    lbAutoSetCnt: TLabel;
    lbVideoFormTitle: TLabel;
    lbVideoFormResol: TLabel;
    lbVideoFormFrm: TLabel;
    cboxVideoResol: TDBComboBox;
    cboxVideoFrm: TDBComboBox;
    lbFrm: TLabel;
    lbEventPopTitle: TLabel;
    lbEventPopMenu: TLabel;
    btnEvtRadio1: TRadioButton;
    btnEvtRadio2: TRadioButton;
    speEventPop: TSpinEdit;
    cbxEventPop: TDBComboBox;
    lbLicenseTitle: TLabel;
    lbCamLicense: TLabel;
    lbAutoLoginTitle: TLabel;
    lbAutoLoginMenu: TLabel;
    grdCamLicense: TAdvStringGrid;
    groupEvent: TGroupBox;
    groupAutoLogin: TGroupBox;
    btnLoginRadio1: TRadioButton;
    btnLoginRadio2: TRadioButton;
    btnAddCamLicense: TButton;
    lbCliPcLicense: TLabel;
    grdCliLocense: TAdvStringGrid;
    btnAddCliLicense: TButton;
    btnCancel: TButton;
    btnSave: TButton;
    btnDlgClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);






  private
    { Private declarations }

    procedure loadCamLicenseList();

  public
    { Public declarations }
  end;

var
  frmSystem: TfrmSystem;

implementation

{$R *.dfm}


procedure TfrmSystem.btnCancelClick(Sender: TObject);
var
  popView: TfrmPopupView;
begin
  popView:= TfrmPopupView.Create(Self);
  popView.Label1.Caption := '변경 사항이 존재합니다.' + sLineBreak + sLineBreak +' 저장 없이 창을 닫으시겠습니까? ';
  popView.btnAgree.Caption := '닫기';
  popView.ShowModal;

  ModalResult:=mrCancel;
  FreeAndNil(popView);
end;

procedure TfrmSystem.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmSystem.btnSaveClick(Sender: TObject);
begin

  ModalResult:=mrOk;
end;

procedure TfrmSystem.FormCreate(Sender: TObject);
begin
  cboxVideoResol.ItemIndex := 0;
  cboxVideoFrm.ItemIndex := 1;
  cbxEventPop.ItemIndex := 0;

  loadCamLicenseList;


end;

procedure TfrmSystem.loadCamLicenseList();
begin
  var
    TotalWidth: Integer;

  with grdCamLicense do
  begin

    TotalWidth := ClientWidth;
    RowCount := 3;
    ColCount := 3;
    ColWidths[0]:=Round(TotalWidth * 0.2);
    ColWidths[1]:=Round(TotalWidth * 0.6);
    ColWidths[2]:=Round(TotalWidth * 0.2);

    Cells[0,0]:='카메라 수';
    Cells[1,0]:='라이선스 키';
    Cells[2,0]:='상태';


  end;

  with grdCliLocense do
  begin

    TotalWidth := ClientWidth;
    RowCount := 2;
    ColCount := 3;
    ColWidths[0]:=Round(TotalWidth * 0.2);
    ColWidths[1]:=Round(TotalWidth * 0.6);
    ColWidths[2]:=Round(TotalWidth * 0.2);

    Cells[0,0]:='장치 수';
    Cells[1,0]:='라이선스 키';
    Cells[2,0]:='상태';

  end;

end;


end.

