unit TVCSAddUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit, DBAdvEd,
  AdvGlowButton, TVCSButtonStyle, tvcsAPI, tvcsProtocol, TVCSCheckDialog;

type
  TfrmAddUser = class(TForm)
    Label1: TLabel;
    edUserId: TDBAdvEdit;
    Label2: TLabel;
    edUserPwChk: TDBAdvEdit;
    Label3: TLabel;
    edUserName: TDBAdvEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edUserEmail: TDBAdvEdit;
    btnCancel: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    cbisStaff: TComboBox;
    cbState: TComboBox;
    Label8: TLabel;
    edUserPw: TDBAdvEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FUsers: TArray<TvcsUser>;
    function CheckDuplicateID(const ID: string): Boolean;
  public
    { Public declarations }
    property Users: TArray<TvcsUser> read FUsers write FUsers;

  end;

var
  frmAddUser: TfrmAddUser;

implementation

{$R *.dfm}

procedure TfrmAddUser.btnSaveClick(Sender: TObject);
var
  User: TvcsUserIn;
begin
  // 필수 입력 체크
  if edUserId.Text.Trim = '' then
  begin
    ShowTVCSMessage('아이디를 입력해주세요.');
    edUserId.SetFocus;
    Exit;
  end;

  // ID 중복 체크
  if CheckDuplicateID(edUserId.Text) then
  begin
    ShowTVCSMessage('이미 사용중인 아이디입니다.');
    edUserId.SetFocus;
    Exit;
  end;

  // 나머지 필수 입력 체크도 추가
  if edUserPw.Text.Trim = '' then
  begin
    ShowTVCSMessage('비밀번호를 입력해주세요.');
    edUserPw.SetFocus;
    Exit;
  end;

  if edUserPwChk.Text.Trim = '' then
  begin
    ShowTVCSMessage('비밀번호 확인을 입력해주세요.');
    edUserPwChk.SetFocus;
    Exit;
  end;

  if edUserPw.Text <> edUserPwChk.Text then
  begin
    ShowTVCSMessage('비밀번호가 일치하지 않습니다.');
    edUserPw.Clear;
    edUserPwChk.Clear;
    edUserPw.SetFocus;
    Exit;
  end;

  if edUserName.Text.Trim = '' then
  begin
    ShowTVCSMessage('이름을 입력해주세요.');
    edUserName.SetFocus;
    Exit;
  end;

  if edUserEmail.Text.Trim = '' then
  begin
    ShowTVCSMessage('이메일을 입력해주세요.');
    edUserEmail.SetFocus;
    Exit;
  end;

  // 모든 검증을 통과하면 사용자 생성
  User := TvcsUserIn.Create;
  try
    User.fuserId := edUserId.Text;
    User.fpassword := edUserPw.Text;
    User.ffirstName := edUserName.Text;
    User.femail := edUserEmail.Text;

    if cbisStaff.ItemIndex = 0 then
      User.fisStaff := True
    else
      User.fisStaff := False;

    if cbState.ItemIndex = 0 then
      User.fisActive := True
    else
      User.fisActive := False;

    // 여기서 실제 사용자 생성 API 호출
    gapi.AddUser(User);
    ModalResult := mrOk;
  finally
    User.Free;
  end;
end;

procedure TfrmAddUser.FormCreate(Sender: TObject);
begin
//
  TButtonStyler.ApplyGlobalStyle(self);
end;

function TfrmAddUser.CheckDuplicateID(const ID: string): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to Length(FUsers) - 1 do
  begin
    if CompareText(FUsers[i].fuserId, ID) = 0 then  // 대소문자 구분 없이 비교
    begin
      Result := True;
      Break;
    end;
  end;
end;

end.
