unit TVCSSystemSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.DBCtrls, Vcl.Grids, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  TVCSPopupView, TVCSButtonStyle, tvcsAPI, tvcsProtocol, AdvGlowButton, Registry, TVCSCheckDialog,
  AdvCombo;

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
    cboxVideoResol: TAdvComboBox;
    cboxVideoFrm: TAdvComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddCamLicenseClick(Sender: TObject);
    procedure btnAddCliLicenseClick(Sender: TObject);






  private
    { Private declarations }
    ttcpip : string;
    ttcpport : string;
    ttcsip : string;
    ttcsport : string;
    addCamLiCnt : integer;
    addSysLiCnt : integer;
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


procedure TfrmSystem.btnAddCamLicenseClick(Sender: TObject);
begin
//
  addCamLiCnt := addCamLiCnt +1;
  with grdCamLicense do
  begin
    InsertChildRow(0);
    Cells[0,1] := '0';
    Cells[1,1] := 'NULL';
    Cells[2,1] := 'NULL';
  end;

end;

procedure TfrmSystem.btnAddCliLicenseClick(Sender: TObject);
begin
  addSysLiCnt := addSysLiCnt +1;
  with grdCliLocense do
  begin
    InsertChildRow(0);
    Cells[0,1] := '0';
    Cells[1,1] := 'NULL';
    Cells[2,1] := 'NULL';
  end;

end;

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
  addLicense : TVCSLicensePost;
  i : integer;
  size: integer;
  AutoLoginState: Boolean;
  PatchSystem: TvcsSystemPatch;
  ResulttSystem: TVCSSystem;

begin
  // 올바른 생성 방식  ]

  if btnLoginRadio1.Checked then
    AutoLoginState := true
  else
    AutoLoginState := false;


  if ShowTVCSCheck(mcModify) then
  begin
    Registry := TRegIniFile.Create(PrgKey);
    try
      Registry.WriteString('user', 'ttcpip', edttcpip.Text);
      Registry.WriteString('user', 'ttcsip', edttcsip.Text);
      Registry.WriteString('user', 'ttcpport', edttcpport.Text);
      Registry.WriteString('user', 'ttcsport', edttcsport.Text);

      Registry.WriteBool('user','autologin',AutoLoginState);


    finally
      Registry.Free;
    end;
    ModalResult := mrOk;
  end;

  if (addCamLiCnt > 0) or (addSysLiCnt > 0) then
  begin
    if addCamLiCnt > addSysLiCnt then
      size := addCamLiCnt
    else
      size := addSysLiCnt;

    for i := 0 to size-1 do
    begin
      addLicense := TVCSLicensePost.Create;
      // 카메라 라이센스 설정
      if i < addCamLiCnt then
        addLicense.fcameraLicenseKey := grdCamLicense.Cells[1,i+1]
      else
        addLicense.fcameraLicenseKey := '';

      // 클라이언트 라이센스 설정
      if i < addSysLiCnt then
        addLicense.fclientLicenseKey := grdCliLocense.Cells[1,i+1]
      else
        addLicense.fclientLicenseKey := '';

      gapi.AddLicense(addLicense);
    end;
  end;

  PatchSystem := TvcsSystemPatch.Create;
  PatchSystem.fdisplayInterval := StrToInt(speAutoSetCnt.Text);
  PatchSystem.fresolution := cboxVideoResol.Text;
  PatchSystem.fframe := StrToInt(cboxVideoFrm.Text);

  if btnEvtRadio1.Checked then
    PatchSystem.fIsEventInterval := True
  else
    PatchSystem.fIsEventInterval := False;

  PatchSystem.feventIntervalSec := StrToInt(speEventPop.Text);

    ResulttSystem := gapi.UpdateSystem(PatchSystem);
    if ResulttSystem <> nil then
      ShowMessage('수정완료');


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
  AutoLoginState: Boolean;

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

    AutoLoginState := Registry.ReadBool('user','autologin',false);

    if AutoLoginState then
    begin
      btnLoginRadio1.Checked := true;
      btnLoginRadio2.Checked := false;
    end else
    begin
      btnLoginRadio1.Checked := false;
      btnLoginRadio2.Checked := true;
    end;




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

    if fresolution = '1920 * 1080' then
      cboxVideoResol.ItemIndex := 0
    else
      cboxVideoResol.ItemIndex := 1;

    if fframe = StrToInt('15') then
      cboxVideoFrm.ItemIndex := 0
    else if fframe = StrToInt('30') then
      cboxVideoFrm.ItemIndex := 1
    else if fframe = StrToInt('60') then
      cboxVideoFrm.ItemIndex := 2;


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
    //RowCount := 3;
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
    //RowCount := 2;
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

