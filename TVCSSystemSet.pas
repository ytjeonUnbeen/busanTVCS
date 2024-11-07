unit TVCSSystemSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.DBCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  TVCSPopupView, TVCSButtonStyle, tvcsAPI, tvcsProtocol, AdvGlowButton, Registry;

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
    lbLicenseTitle: TLabel;
    lbCamLicense: TLabel;
    lbAutoLoginTitle: TLabel;
    lbAutoLoginMenu: TLabel;
    grdCamLicense: TAdvStringGrid;
    groupEvent: TGroupBox;
    groupAutoLogin: TGroupBox;
    btnLoginRadio1: TRadioButton;
    btnLoginRadio2: TRadioButton;
    lbCliPcLicense: TLabel;
    grdCliLocense: TAdvStringGrid;
    cbxEventPop: TDBComboBox;
    Label1: TLabel;
    edTCMSIP: TEdit;
    Label2: TLabel;
    btnAddCamLicense: TAdvGlowButton;
    btnAddCliLicense: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);






  private
    { Private declarations }
    tcmsIP : string;
    procedure loadCamLicenseList();
    procedure LoadSettings;

  public
    { Public declarations }
  end;

var
  frmSystem: TfrmSystem;
  const PrgKey='Software\TVCSClient\Settings';

implementation

{$R *.dfm}


procedure TfrmSystem.btnCancelClick(Sender: TObject);
var
  popView: TfrmPopupView;
begin
  popView:= TfrmPopupView.Create(Self);
  popView.Label1.Caption := '���� ������ �����մϴ�.' + sLineBreak + sLineBreak +' ���� ���� â�� �����ðڽ��ϱ�? ';
  popView.btnAgree.Caption := '�ݱ�';
  popView.ShowModal;

  ModalResult:=mrCancel;
  FreeAndNil(popView);
end;

procedure TfrmSystem.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmSystem.btnSaveClick(Sender: TObject);
var
  Registry: TRegIniFile;
begin
  // �ùٸ� ���� ���
  Registry := TRegIniFile.Create(PrgKey);
  try
    Registry.WriteString('user', 'tcmsip', edTCMSIP.Text);
  finally
    Registry.Free;
  end;

  ModalResult := mrOk;
end;

procedure TfrmSystem.FormCreate(Sender: TObject);
begin
  cboxVideoResol.ItemIndex := 0;
  cboxVideoFrm.ItemIndex := 1;
  cbxEventPop.ItemIndex := 0;


  loadCamLicenseList;
  loadSettings;

  TButtonStyler.ApplyGlobalStyle(Self);


end;

procedure TfrmSystem.LoadSettings;
var
  Registry: TRegIniFile;
begin
  Registry := TRegIniFile.Create(PrgKey);
  try
    tcmsIP := Registry.ReadString('user', 'tcmsip', edTCMSIP.Text);
    edTCMSIP.Text := tcmsIP;
  finally
    Registry.Free;
  end;
end;

procedure TfrmSystem.loadCamLicenseList();
var
  TotalWidth, i: Integer;
  CamLicense: array of TVCSCameraLicense;
  CliLicense: array of TVCSClientLicense;

begin

  with gapi.GetLoinInfo.fsystem do
  begin
    speAutoSetCnt.Text := IntToStr(fdisplayInterval);
    cboxVideoResol.Text := fresolution;
    cboxVideoFrm.Text := IntToStr(fframe);
    if fisEventInterval then
      btnEvtRadio2.Checked
    else
      btnEvtRadio2.Checked;
  end;

  setLength(CamLicense,Length(gapi.GetLoinInfo.fcameraLicense));
  for i := 0 to Length(gapi.GetLoinInfo.fcameraLicense) - 1 do
  begin
    CamLicense[i] := gapi.GetLoinInfo.fcameraLicense[i];
  end;

  setLength(CliLicense,Length(gapi.GetLoinInfo.fclientLicense));
  for i := 0 to Length(gapi.GetLoinInfo.fclientLicense) - 1 do
  begin
    CliLicense[i] := gapi.GetLoinInfo.fclientLicense[i];
  end;


  with grdCamLicense do
  begin
    TotalWidth := ClientWidth;
    RowCount := 3;
    ColCount := 3;
    ColWidths[0]:=Round(TotalWidth * 0.2);
    ColWidths[1]:=Round(TotalWidth * 0.6);
    ColWidths[2]:=Round(TotalWidth * 0.2);

    Cells[0,0]:='ī�޶� ��';
    Cells[1,0]:='���̼��� Ű';
    Cells[2,0]:='����';
  end;
  {
  for i := 0 to Length(CamLicense) do
    with grdCamLicense do
    begin
      AddRow;
      Cells[0,i+1] := IntToStr(CamLicense[i].fcameraNum);
      Cells[1,i+1] := CamLicense[i].flicenseKey;
      if CamLicense[i].fisConfirm then
        Cells[2,i+1] := '����'
      else
        Cells[2,i+1] := '����';
    end;
  }
  with grdCliLocense do
  begin

    TotalWidth := ClientWidth;
    RowCount := 2;
    ColCount := 3;
    ColWidths[0]:=Round(TotalWidth * 0.2);
    ColWidths[1]:=Round(TotalWidth * 0.6);
    ColWidths[2]:=Round(TotalWidth * 0.2);

    Cells[0,0]:='��ġ ��';
    Cells[1,0]:='���̼��� Ű';
    Cells[2,0]:='����';

  end;
  {
  for i := 0 to Length(CliLicense) do
    with grdCliLocense do
    begin
      AddRow;
      Cells[0,i+1] := IntToStr(CliLicense[i].fclientNum);
      Cells[1,i+1] := CliLicense[i].flicenseKey;

      if CliLicense[i].fisConfirm then
        Cells[2,i+1] := '����'
      else
        Cells[2,i+1] := '����';
    end;
    }
end;


end.

