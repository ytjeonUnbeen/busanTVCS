unit TVCSButtonStyle;

interface

uses
  Vcl.Forms, System.Classes, AdvGlowButton, Vcl.Graphics, System.SysUtils;

type
  TButtonStyler = class
  public
    class procedure ApplyGlobalStyle(Form: TForm);
    class procedure StyleButton(Button: TAdvGlowButton);
    class procedure NeedApplyButton(Button: TAdvGlowButton);
  end;


implementation



class procedure TButtonStyler.NeedApplyButton(Button: TAdvGlowButton);
begin
  with Button do
  begin
    // 기본 설정
    //Font.Name := '맑은 고딕';
    Font.Size := 12;

    Font.Color := clWhite;
    //ont.Style := [fsBold];

    //width := 60;
    Height := 30;

    with Appearance do
    begin
      // 버튼 색상
      Color := clRed;
      ColorMirror :=clRed;
      BorderColor := clRed;

      // 마우스 호버 그라데이션 없애기
      ColorCheckedTo := clNone;
      ColorDisabledTo := clNone;
      ColorDownTo := clNone;
      colorHotTo := clNone;
      ColorMirrorCheckedTo := clNone;
      ColorMirrorDisabledTo := clNone;
      ColorMirrorDownTo := clnone;


      // 그라데이션 없애기
      ColorMirrorHotTo := clNone;
      ColorMirrorTo := clNone;
      ColorTo := clNone;

      //Appearance.Gradient := g;
      //Appearance.GradientHot := ggVertical;
      //Appearance.Gradient := gg

      //Round;

    end;
  end;
end;


class procedure TButtonStyler.StyleButton(Button: TAdvGlowButton);
begin
  with Button do
  begin
    // 기본 설정
    //Font.Name := '맑은 고딕';
    Font.Size := 12;

    Font.Color := clWhite;
    //ont.Style := [fsBold];

    //width := 60;
    Height := 30;

    with Appearance do
    begin
      // 버튼 색상
      Color := $964315;
      ColorMirror := $964315;
      BorderColor := $964315;

      // 마우스 호버 그라데이션 없애기
      ColorCheckedTo := clNone;
      ColorDisabledTo := clNone;
      ColorDownTo := clNone;
      colorHotTo := clNone;
      ColorMirrorCheckedTo := clNone;
      ColorMirrorDisabledTo := clNone;
      ColorMirrorDownTo := clnone;


      // 그라데이션 없애기
      ColorMirrorHotTo := clNone;
      ColorMirrorTo := clNone;
      ColorTo := clNone;


      //Appearance.Gradient := g;
      //Appearance.GradientHot := ggVertical;
      //Appearance.Gradient := gg

      //Round;

    end;




  end;
end;

class procedure TButtonStyler.ApplyGlobalStyle(Form: TForm);
var
  i: Integer;
  Component: TComponent;
begin
  for i := 0 to Form.ComponentCount - 1 do
  begin
    Component := Form.Components[i];
    if Component is TAdvGlowButton then
      StyleButton(TAdvGlowButton(Component));
  end;
end;

end.
