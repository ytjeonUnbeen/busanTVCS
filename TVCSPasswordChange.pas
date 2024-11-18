unit TVCSPasswordChange;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit, AdvGlowButton, TVCSButtonStyle;

type
  TfrmPasswordChange = class(TForm)
    edNewPassword: TAdvEdit;
    Label2: TLabel;
    Label3: TLabel;
    edNewPasswordCheck: TAdvEdit;
    btnCancel: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    function ValidateNewPassword: Boolean;
  public
    { Public declarations }
    //property NewPassword: string read GetNewPassword;  // 새 프로퍼티 추가
    function GetNewPassword: string;
  end;

var
  frmPasswordChange: TfrmPasswordChange;

implementation

uses TVCSCheckDialog;

{$R *.dfm}

procedure TfrmPasswordChange.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPasswordChange.btnSaveClick(Sender: TObject);
begin
  if ValidateNewPassword then
    ModalResult := mrOk;
end;

procedure TfrmPasswordChange.FormCreate(Sender: TObject);
begin
//
  TButtonStyler.ApplyGlobalStyle(Self);
end;

function TfrmPasswordChange.ValidateNewPassword: Boolean;
begin
  Result := False;

  // 새 비밀번호 입력 확인
  if edNewPassword.Text = '' then
  begin
    ShowTVCSMessage('새 비밀번호를 입력해주세요.');
    edNewPassword.SetFocus;
    Exit;
  end;

  // 새 비밀번호 확인 입력 확인
  if edNewPasswordCheck.Text = '' then
  begin
    ShowTVCSMessage('새 비밀번호 확인을 입력해주세요.');
    edNewPasswordCheck.SetFocus;
    Exit;
  end;

  // 새 비밀번호 일치 확인
  if edNewPassword.Text <> edNewPasswordCheck.Text then
  begin
    ShowTVCSMessage('새 비밀번호가 일치하지 않습니다.');
    edNewPassword.Clear;
    edNewPasswordCheck.Clear;
    edNewPassword.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmPasswordChange.AdvGlowButton1Click(Sender: TObject);
begin
  if ValidateNewPassword then
  begin
    ModalResult := mrOk;
  end;
end;

function TfrmPasswordChange.GetNewPassword: string;
begin
  Result := edNewPassword.Text;
end;

end.
