unit TVCSPasswordDialog;

interface

uses
  AdvSmoothMessageDialog, Vcl.Graphics, System.UITypes, Vcl.Forms, advstyleif, advgdip,
  Vcl.StdCtrls, Vcl.Controls;

// 비밀번호 변경 결과를 위한 레코드
function ShowPasswordChangeDialog(var CurrentPW, NewPW: string): Boolean;

implementation

uses TVCSCheckDialog;

procedure InitializeDialog(Dialog: TAdvSmoothMessageDialog);
begin
  Dialog.SetComponentStyle(tsWindows10);
  Dialog.Fill.Color := clWhite;
  Dialog.Fill.ColorTo := clWhite;
  Dialog.Position := poScreenCenter;
  Dialog.MinimumWidth := 500;
  Dialog.MinimumHeight := 300;
  Dialog.ButtonAreaFill.Color := clWhite;
  Dialog.ButtonAreaFill.ColorTo := clWhite;
  Dialog.HTMLText.Location := hlCenterCenter;
  Dialog.CaptionFill.Color := $964315;
  Dialog.CaptionHeight := 50;
  Dialog.CaptionFill.GradientType := gtSolid;
  Dialog.ButtonAreaFill.GradientType := gtSolid;
  Dialog.Fill.GradientType := gtSolid;
  //Dialog.Fill.GradientMirrorType := gtNone;
end;

function ShowPasswordChangeDialog(var CurrentPW, NewPW: string): Boolean;
var
  Dialog: TAdvSmoothMessageDialog;
  CurrentPasswordEdit, NewPasswordEdit, ConfirmPasswordEdit: TEdit;
  CurrentPasswordLabel, NewPasswordLabel, ConfirmPasswordLabel: TLabel;
const
  CONTROL_LEFT = 100;
  LABEL_TOP_START = 80;
  EDIT_TOP_START = 100;
  VERTICAL_SPACING = 50;
begin
  Result := False;
  Dialog := TAdvSmoothMessageDialog.Create(nil);
  try
    InitializeDialog(Dialog);
    Dialog.Caption := '비밀번호 변경';
    Dialog.MinimumHeight := 400;

    // 현재 비밀번호 라벨
    CurrentPasswordLabel := TLabel.Create(Dialog);
    with CurrentPasswordLabel do
    begin
      Left := CONTROL_LEFT;
      Top := LABEL_TOP_START;
      Caption := '현재 비밀번호';
      Font.Size := 10;
    end;

    // 현재 비밀번호 입력창
    CurrentPasswordEdit := TEdit.Create(Dialog);
    with CurrentPasswordEdit do
    begin
      Parent := Dialog;

      Left := CONTROL_LEFT;
      Top := EDIT_TOP_START;
      Width := 300;
      Height := 25;
      PasswordChar := '●';
      TabOrder := 0;
    end;

    // 새 비밀번호 라벨
    NewPasswordLabel := TLabel.Create(Dialog);
    with NewPasswordLabel do
    begin
      Parent := TWinControl(Dialog);
      Left := CONTROL_LEFT;
      Top := LABEL_TOP_START + VERTICAL_SPACING;
      Caption := '새 비밀번호';
      Font.Size := 10;
    end;

    // 새 비밀번호 입력창
    NewPasswordEdit := TEdit.Create(Dialog);
    with NewPasswordEdit do
    begin
      Parent := TWinControl(Dialog);
      Left := CONTROL_LEFT;
      Top := EDIT_TOP_START + VERTICAL_SPACING;
      Width := 300;
      Height := 25;
      PasswordChar := '●';
      TabOrder := 1;
    end;

    // 새 비밀번호 확인 라벨
    ConfirmPasswordLabel := TLabel.Create(Dialog);
    with ConfirmPasswordLabel do
    begin
      Parent := TWinControl(Dialog);
      Left := CONTROL_LEFT;
      Top := LABEL_TOP_START + (VERTICAL_SPACING * 2);
      Caption := '새 비밀번호 확인';
      Font.Size := 10;
    end;

    // 새 비밀번호 확인 입력창
    ConfirmPasswordEdit := TEdit.Create(Dialog);
    with ConfirmPasswordEdit do
    begin
      Parent := TWinControl(Dialog);
      Left := CONTROL_LEFT;
      Top := EDIT_TOP_START + (VERTICAL_SPACING * 2);
      Width := 300;
      Height := 25;
      PasswordChar := '●';
      TabOrder := 2;
    end;

    // 버튼 설정
    Dialog.Buttons.Clear;

    // 변경 버튼
    with Dialog.Buttons.Add do
    begin
      Caption := '변경';
      ButtonResult := mrYes;
      Color := $81330F;
      ColorFocused := $81330F;
      HoverColor := $6C260A;
    end;

    // 취소 버튼
    with Dialog.Buttons.Add do
    begin
      Caption := '취소';
      ButtonResult := mrNo;
      Color := $DF9D6C;
      ColorFocused := $DF9D6C;
      HoverColor := $F4C7A0;
    end;

    if Dialog.Execute then
    begin
      // 모든 필드가 입력되었는지 확인
      if CurrentPasswordEdit.Text = '' then
      begin
        ShowTVCSMessage('현재 비밀번호를 입력해주세요.');
        Exit;
      end;

      if NewPasswordEdit.Text = '' then
      begin
        ShowTVCSMessage('새 비밀번호를 입력해주세요.');
        Exit;
      end;

      if ConfirmPasswordEdit.Text = '' then
      begin
        ShowTVCSMessage('새 비밀번호 확인을 입력해주세요.');
        Exit;
      end;

      // 새 비밀번호와 확인 비밀번호가 일치하는지 확인
      if NewPasswordEdit.Text <> ConfirmPasswordEdit.Text then
      begin
        ShowTVCSMessage('새 비밀번호가 일치하지 않습니다.');
        Exit;
      end;

      CurrentPW := CurrentPasswordEdit.Text;
      NewPW := NewPasswordEdit.Text;
      Result := True;
    end;
  finally
    Dialog.Free;
  end;
end;

end.
