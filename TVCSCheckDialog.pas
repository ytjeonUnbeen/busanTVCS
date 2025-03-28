unit TVCSCheckDialog;

interface

uses
  AdvSmoothMessageDialog, Vcl.Graphics, System.UITypes, Vcl.Forms, advstyleif, advgdip;

 type TTVCSDialogType=(mcModify,mcDelete,mcExcelUpload,mcChangLayout);
// 다이얼로그 결과 리턴을 위한 함수들
function ShowTVCSCheck(DialogType: TTVCSDialogType): Boolean;overload;
function ShowTVCSCheck(Title,Content:String): Boolean;overload;
function ShowTVCSMessage(const Msg: string): Boolean;

implementation

// 내부적으로 사용할 다이얼로그 초기화 함수
procedure InitializeDialog(Dialog: TAdvSmoothMessageDialog);
begin
  Dialog.SetComponentStyle(tsWindows10);
  Dialog.Fill.Color := clWhite;
  Dialog.Fill.ColorTo := clWhite;
  Dialog.Position := poScreenCenter;
  Dialog.fill.Opacity := 255;

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
  Dialog.Fill.GradientMirrorType := gtNone;
  Dialog.Position:=poOwnerFormCenter;
end;



function ShowTVCSCheck(Title,Content:String): Boolean;overload;
var
  Dialog: TAdvSmoothMessageDialog;
begin
  Dialog := TAdvSmoothMessageDialog.Create(nil);
  try
    InitializeDialog(Dialog);
    Dialog.Buttons.Clear;
    Dialog.HTMLText.Text := Content;
    Dialog.Caption :=Title;

        with Dialog.Buttons.Add do
        begin
          Caption := '확인';
          ButtonResult := mrYes;
          Color := $81330F;
          ColorDown := $81330F;      // 클릭했을 때의 색상도 동일하게
          ColorFocused := $81330F;   // 포커스됐을 때의 색상도 동일하게
          HoverColor := $6C260A;
          BorderWidth := 0;          // 테두리 제거
          BorderOpacity := 0;        // 테두리 투명도 0
          Opacity := 255;
        end;
        // 공통 취소 버튼
       with Dialog.Buttons.Add do
       begin
         Caption := '취소';
         ButtonResult := mrNo;
         Color := $DF9D6C;
         ColorFocused := $DF9D6C;
         HoverColor := $F4C7A0;
      end;

      Result := Dialog.Execute;

  finally
    Dialog.Free;
  end;

end;

// 수정/삭제 확인 다이얼로그
function ShowTVCSCheck(DialogType: TTVCSDialogType): Boolean;
var
  Dialog: TAdvSmoothMessageDialog;
begin
  Dialog := TAdvSmoothMessageDialog.Create(nil);
  try
    InitializeDialog(Dialog);
    Dialog.Buttons.Clear;



    case DialogType of
      mcModify:  // 수정
      begin
        Dialog.HTMLText.Text := '데이터가 변경되었습니다 데이터를 저장하시겠습니까?';
        Dialog.Caption := '데이터 수정';

        with Dialog.Buttons.Add do
        begin
          Caption := '확인';
          ButtonResult := mrYes;
          Color := $81330F;
          ColorDown := $81330F;      // 클릭했을 때의 색상도 동일하게
          ColorFocused := $81330F;   // 포커스됐을 때의 색상도 동일하게
          HoverColor := $6C260A;
          BorderWidth := 0;          // 테두리 제거
          BorderOpacity := 0;        // 테두리 투명도 0
          Opacity := 255;
        end;
      end;

      mcDelete:  // 삭제
      begin
        Dialog.Caption := '데이터 삭제';
        Dialog.HTMLText.Text := '<br><br><br><br><br>선택한 데이터가 삭제됩니다.';

        with Dialog.Buttons.Add do
        begin
          Caption := '삭제';
          ButtonResult := mrYes;
          Color := $81330F;
          ColorFocused := $81330F;
          HoverColor := $6C260A;
        end;
      end;

      mcExcelUpload:  // 엑셀업로드
      begin
        Dialog.Caption := '엑셀 업로드';
        Dialog.HTMLText.Text := '<br><br><br><br><br>엑셀 업로드시 기존의 데이터는 모두 사라집니다.';

        with Dialog.Buttons.Add do
        begin
          Caption := '확인';
          ButtonResult := mrYes;
          Color := $81330F;
          ColorFocused := $81330F;
          HoverColor := $6C260A;
        end;
      end;

      mcChangLayout:  // 레이아웃변경
      begin
        Dialog.Caption := '레이아웃 변경';
        Dialog.HTMLText.Text := '<br><br><br><br><br>레이아웃 변경 시 추가된 카메라가 삭제될 수 있습니다.';

        with Dialog.Buttons.Add do
        begin
          Caption := '확인';
          ButtonResult := mrYes;
          Color := $81330F;
          ColorFocused := $81330F;
          HoverColor := $6C260A;
        end;
      end;





    end;

    // 공통 취소 버튼
    with Dialog.Buttons.Add do
    begin
      Caption := '취소';
      ButtonResult := mrNo;
      Color := $DF9D6C;
      ColorFocused := $DF9D6C;
      HoverColor := $F4C7A0;
    end;

    Result := Dialog.Execute;
  finally
    Dialog.Free;
  end;
end;

// 메시지 표시 다이얼로그
function ShowTVCSMessage(const Msg: string): Boolean;
var
  Dialog: TAdvSmoothMessageDialog;
begin
  Dialog := TAdvSmoothMessageDialog.Create(nil);
  try
    InitializeDialog(Dialog);
    Dialog.Buttons.Clear;

    Dialog.Caption := '알림';
    Dialog.HTMLText.Text := '<br><br><br><br><br>' + Msg;

    with Dialog.Buttons.Add do
    begin
      Caption := '확인';
      ButtonResult := mrOk;
      Color := $81330F;
      ColorFocused := $81330F;
      HoverColor := $6C260A;
    end;

    Result := Dialog.Execute;
  finally
    Dialog.Free;
  end;
end;

end.
