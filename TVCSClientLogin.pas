unit TVCSClientLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlassButton, Vcl.StdCtrls,Registry,tvcsAPI,tvcsProtocol,vcl.Themes,
  Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    edServer: TEdit;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edUser: TEdit;
    edPass: TEdit;
    chkSave: TCheckBox;
    chkAutoLogin: TCheckBox;
    btnLogin: TAdvGlassButton;
    Label4: TLabel;
    Label5: TLabel;
    tmStarter: TTimer;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure tmStarterTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
     userName,userPass:String;
     userServer: String;
     bSaved:Boolean;
     Fapi:TTVCSAPI;
     Procedure LoadSettings;
     Procedure SaveSettings;

  public
     isLogged:Boolean;
     LoginRes:integer;

  published
    property api:ttvcsAPI read Fapi write Fapi;

  end;

var
  frmLogin: TfrmLogin;
  Globalapi:TTVCSAPI;
  const PrgKey='Software\TVCSClient\Settings';

implementation

{$R *.dfm}

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
 info:TVCSLogin;

begin
  // Login API
  Gapi := TTVCSAPI.Create;
  Gapi.SetUrl(edServer.Text);

  //Globalapi.SetUrl(edServer.Text);
  LoginRes:=Gapi.login(edUser.text,edPass.Text);
//
  if LoginRes = 200 then
  begin

    SaveSettings;
    isLogged:=true;
    ModalResult := mrOK;

    Exit
  end
  else if LoginRes = 401 then
    //ShowMessage('잘못된 아이디나 패스워드 입니다.');
  begin
    ShowMessage('     사용자 아이디 또는 비밀번호가 정확하지 않습니다.     ' + #13 +             '                      다시 확인하시기 바랍니다.              ');
    //ModalResult:=mrClose;
  end
  else if LoginRes=0 then
  begin
    // GetAPI에서 이미 에러 메시지를 표시했으므로 여기서는 처리 안함
    ShowMessage('영상처리 서버 IP를 다시 확인하시기 바랍니다.');

  end



end;

procedure TfrmLogin.FormCreate(Sender: TObject);
var
  appPath : string;
begin
  isLogged := False;
  edServer.Text := '';
  edUser.Text := '';
  edPass.Text := '';

  LoadSettings;

  appPath := ExtractFilePath(ParamStr(0));
  TStyleManager.LoadFromFile(appPath+'\icon-img\Style.vsf');
  TStyleManager.TrySetStyle('Onyx Blue2');

  // 자동 로그인을 타이머로 약간 지연시켜 실행 (폼이 완전히 로드된 후)
  if chkAutoLogin.Checked then
    tmStarter.Enabled := True;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin

   if (api<>nil) then
      FreeAndNil(api);

end;

procedure TfrmLogin.LoadSettings;
var
  Registry: TRegIniFile;
begin
  Registry := TRegIniFile.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey(PrgKey, True);

    // 서버 주소 로드 추가

    userName := Registry.ReadString('user', 'username', edUser.Text);
    userPass := Registry.ReadString('user', 'userpass', edPass.Text);
    bSaved := Registry.ReadBool('user', 'saveuser', chkSave.Checked);
    chkAutoLogin.checked := Registry.ReadBool('user', 'autologin', False);
    chkSave.Checked := bSaved;

    if (bSaved) then begin
      edUser.Text := userName;
      edPass.Text := userPass;
      edServer.Text := Registry.ReadString('user', 'server', '');

    end;

    // 자동 로그인은 FormCreate와 tmStarterTimer에서 처리하므로 여기서 제거
    // if chkAutoLogin.checked then
    //  btnLoginClick(self);

    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure TfrmLogin.SaveSettings;
var
  Registry: TRegIniFile;
begin
  Registry := TRegIniFile.Create(KEY_WRITE);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey(PrgKey, True);

    // 서버 주소 저장 추가
    Registry.WriteString('user', 'server', edServer.Text);

    Registry.WriteString('user', 'username', edUser.Text);
    Registry.WriteString('user', 'userpass', edPass.Text);
    Registry.WriteBool('user', 'saveuser', chkSave.Checked);
    Registry.WriteBool('user', 'autologin', chkAutoLogin.Checked);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure TfrmLogin.tmStarterTimer(Sender: TObject);
begin
  tmStarter.Enabled := False;

  // 자동 로그인 처리
  if chkAutoLogin.Checked then
    btnLoginClick(Sender);
end;

end.
