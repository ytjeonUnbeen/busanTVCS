unit TVCSClientLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlassButton, Vcl.StdCtrls,Registry,tvcsAPI,tvcsProtocol,
  Vcl.ExtCtrls;

{$DEFINE FAKE_RUNNING}
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
     bSaved:Boolean;
     api:TTVCSAPI;
     Procedure LoadSettings;
     Procedure SaveSettings;

  public
     isLogged:Boolean;
  end;

var
  frmLogin: TfrmLogin;
  const PrgKey='Software\TVCSClient\Settings';

implementation

{$R *.dfm}

procedure TfrmLogin.btnLoginClick(Sender: TObject);

begin
 {$IFNDEF FAKE_RUNNING}
  // Login API
    isLogged:=api.login(edUser.text,edPass.Text);
 {$ELSE}
    isLogged:=True;
 {$ENDIF}

  SaveSettings;
  ModalResult := mrOK;

end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
isLogged:=False;
LoadSettings;
{$IFNDEF FAKE_RUNNING}
     api.create;
{$ENDIF}
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
{$IFNDEF FAKE_RUNNING}
   if (api<>nil) then
      FreeAndNil(api);
{$ENDIF}
end;

procedure TfrmLogin.LoadSettings;
var
  Registry: TRegIniFile;
begin
  Registry := TRegIniFile.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;

    Registry.OpenKey(PrgKey, True);
    userName:=Registry.ReadString('user','username',edUser.Text);
    userPass:=Registry.ReadString('user','userpass',edPass.Text);
    bSaved:=Registry.ReadBool('user','saveuser',chkSave.Checked);
    chkAutoLogin.checked:=Registry.ReadBool('user','autologin',false);
    chkSave.Checked:=bSaved;
    if (bSaved) then begin
      edUser.Text:=userName;
      edPass.Text:=userPass;
    end;

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
    Registry.WriteString('user','username',edUser.Text);
    Registry.WriteString('user','userpass',edPass.Text);
    Registry.WriteBool('user','saveuser',chkSave.Checked);
    Registry.WriteBool('user','autologin',chkAutoLogin.Checked);


    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;


procedure TfrmLogin.tmStarterTimer(Sender: TObject);
begin
tmStarter.Enabled:=false;
// 자동로그인 임시로 막음. 테스트 위해서
//if (chkAutoLogin.Checked) then btnLoginClick(Sender);

end;

end.
