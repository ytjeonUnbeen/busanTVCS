unit TVCSSystemSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.DBCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  TVCSPopupView, TVCSButtonStyle, tvcsAPI, tvcsProtocol, AdvGlowButton, Registry, TVCSCheckDialog;

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
    edttcpip: TEdit;
    lbttcsip: TLabel;
    btnAddCamLicense: TAdvGlowButton;
    btnAddCliLicense: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    lbttcpport: TLabel;
    edttcsport: TEdit;
    lbttcpip: TLabel;
    edttcsip: TEdit;
    lbttcsprot: TLabel;
    edttcpport: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);






  private
    { Private declarations }
    ttcpip : string;
    ttcpport : string;
    ttcsip : string;
    ttcsport : string;
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
begin
  ModalResult:=mrCancel;
end;

procedure TfrmSystem.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmSystem.btnSaveClick(Sender: TObject);
var
  Registry: TRegIniFile;
begin
  // 올바른 생성 방식  ]
  if ShowTVCSCheck(0) then
  begin
    Registry := TRegIniFile.Create(PrgKey);
    try
      Registry.WriteString('user', 'ttcpip', edttcpip.Text);
      Registry.WriteString('user', 'ttcsip', edttcsip.Text);
      Registry.WriteString('user', 'ttcpport', edttcpport.Text);
      Registry.WriteString('user', 'ttcsport', edttcsport.Text);
    finally
      Registry.Free;
    end;
    ModalResult := mrOk;
  end;

end;

procedure TfrmSystem.FormCreate(Sender: TObject);
begin
  cboxVideoResol.ItemIndex := 0;
  cboxVideoFrm.ItemIndex := 1;
  cbxEventPop.ItemIndex := 0;


  loadCamLicenseList;
  loadSettings;

  TButtonStyler.ApplyGlobalStyle(Self);
  lblTitle.Caption := '시스템 관리 ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'호선)';
  //lblTitle.Left := (Panel1.Width - Label1.Width) div 2;



end;

procedure TfrmSystem.LoadSettings;
var
  Registry: TRegIniFile;
begin
  Registry := TRegIniFile.Create(PrgKey);
  try
    ttcpip := Registry.ReadString('user', 'ttcpip', edttcpip.Text);
    edttcpip.Text := ttcpip;
    ttcpport := Registry.ReadString('user', 'ttcpport', edttcpport.Text);
    edttcpport.Text := ttcpport;

    ttcsip := Registry.ReadString('user', 'ttcsip', edttcsip.Text);
    edttcsip.Text := ttcsip;
    ttcsport := Registry.ReadString('user', 'ttcsport', edttcsport.Text);
    edttcsport.Text := ttcsport;



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

    Cells[0,0]:='카메라 수';
    Cells[1,0]:='라이선스 키';
    Cells[2,0]:='상태';
  end;
  {
  for i := 0 to Length(CamLicense) do
    with grdCamLicense do
    begin
      AddRow;
      Cells[0,i+1] := IntToStr(CamLicense[i].fcameraNum);
      Cells[1,i+1] := CamLicense[i].flicenseKey;
      if CamLicense[i].fisConfirm then
        Cells[2,i+1] := '인증'
      else
        Cells[2,i+1] := '종료';
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

    Cells[0,0]:='장치 수';
    Cells[1,0]:='라이선스 키';
    Cells[2,0]:='상태';

  end;
  {
  for i := 0 to Length(CliLicense) do
    with grdCliLocense do
    begin
      AddRow;
      Cells[0,i+1] := IntToStr(CliLicense[i].fclientNum);
      Cells[1,i+1] := CliLicense[i].flicenseKey;

      if CliLicense[i].fisConfirm then
        Cells[2,i+1] := '인증'
      else
        Cells[2,i+1] := '종료';
    end;
    }
end;


end.

