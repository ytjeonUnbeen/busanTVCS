unit CustomPageControl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Themes,
  Winapi.GDIPOBJ, Winapi.GDIPAPI, Math;

type
  TCustomPageControl = class(TPageControl)
  private
    FTabSpacing: Integer;
    FActiveTabColor: TColor;
    FInactiveTabColor: TColor;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    function GetTabRect(Index: Integer): TRect;
  protected
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); virtual;
    procedure Resize; override;
    procedure PaintWindow(DC: HDC); override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); override;
    property TabSpacing: Integer read FTabSpacing write FTabSpacing;
    property ActiveTabColor: TColor read FActiveTabColor write FActiveTabColor;
    property InactiveTabColor: TColor read FInactiveTabColor write FInactiveTabColor;
  end;

implementation

constructor TCustomPageControl.Create(AOwner: TComponent);
begin
  inherited;
  DoubleBuffered := True;
  FTabSpacing := 10;
  FActiveTabColor := $D0C0FF;
  FInactiveTabColor := $D0C0BF;

  // Set initial size and invalidate
  Width := 500;  // 예시 크기, 필요에 따라 조정
  Height := 300; // 예시 크기, 필요에 따라 조정
  Invalidate;
end;

procedure TCustomPageControl.Change;
var
  TabRect: TRect;
  ColorStr: string;
begin
  inherited;

  if ActivePageIndex >= 0 then
  begin
    TabRect := GetTabRect(ActivePageIndex);
    ColorStr := Format('$%.6x', [ColorToRGB(FActiveTabColor)]);

    ShowMessage(Format('Active Tab: %d'#13#10 +
                       'Color: %s'#13#10 +
                       'Tab Rect: (%d, %d, %d, %d)',
                       [ActivePageIndex, ColorStr,
                        TabRect.Left, TabRect.Top, TabRect.Right, TabRect.Bottom]));
  end;
end;

procedure TCustomPageControl.WMPaint(var Message: TWMPaint);
begin
  ControlState := ControlState + [csCustomPaint];
  inherited;
  ControlState := ControlState - [csCustomPaint];
end;

function TCustomPageControl.GetTabRect(Index: Integer): TRect;
var
  X: Integer;
begin
  X := Index * (TabWidth + FTabSpacing);
  Result := Rect(X, 0, X + TabWidth, TabHeight);
end;

procedure TCustomPageControl.PaintWindow(DC: HDC);
var
  I: Integer;
  R: TRect;
begin
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    try
      // 전체 배경을 지우고 다시 그리기
      Canvas.Brush.Color := Color;
      Canvas.FillRect(ClientRect);

      for I := 0 to PageCount - 1 do
      begin
        R := GetTabRect(I);
        DrawTab(I, R, I = TabIndex);
      end;
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TCustomPageControl.DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  Graphics: TGPGraphics;
  Path: TGPGraphicsPath;
  Brush: TGPSolidBrush;
  StringFormat: TGPStringFormat;
  GDIFont: TFont;
  GPFont: TGPFont;
  GPRect: TGPRectF;
  LColor: TColor;
  CornerRadius: Single;
  DrawRect: TRect;
begin
  Graphics := TGPGraphics.Create(Canvas.Handle);
  Path := TGPGraphicsPath.Create;
  Brush := TGPSolidBrush.Create(0);
  StringFormat := TGPStringFormat.Create;
  GDIFont := TFont.Create;
  try
    Graphics.SetSmoothingMode(SmoothingModeAntiAlias);
    Graphics.SetTextRenderingHint(TextRenderingHintAntiAlias);

    CornerRadius := 5;
    DrawRect := Rect;

    // Create path for the tab shape
    Path.AddLine(DrawRect.Left, DrawRect.Bottom, DrawRect.Left, DrawRect.Top + CornerRadius);
    Path.AddArc(DrawRect.Left, DrawRect.Top, CornerRadius * 2, CornerRadius * 2, 180, 90);
    Path.AddLine(DrawRect.Left + CornerRadius, DrawRect.Top, DrawRect.Right - CornerRadius, DrawRect.Top);
    Path.AddArc(DrawRect.Right - CornerRadius * 2, DrawRect.Top, CornerRadius * 2, CornerRadius * 2, 270, 90);
    Path.AddLine(DrawRect.Right, DrawRect.Top + CornerRadius, DrawRect.Right, DrawRect.Bottom);
    Path.CloseFigure;

    if Active then
      LColor := FActiveTabColor
    else
      LColor := FInactiveTabColor;

    Brush.SetColor(ColorRefToARGB(ColorToRGB(LColor)));
    Graphics.FillPath(Brush, Path);

    // Draw the tab text
    StringFormat.SetAlignment(StringAlignmentCenter);
    StringFormat.SetLineAlignment(StringAlignmentCenter);
    GDIFont.Assign(Self.Font);
    GPFont := TGPFont.Create(Canvas.Handle, GDIFont.Handle);
    Brush.SetColor(ColorRefToARGB(ColorToRGB(clBlack)));
    GPRect.X := DrawRect.Left;
    GPRect.Y := DrawRect.Top;
    GPRect.Width := DrawRect.Right - DrawRect.Left;
    GPRect.Height := DrawRect.Bottom - DrawRect.Top;
    Graphics.DrawString(PChar(Pages[TabIndex].Caption), -1, GPFont, GPRect, StringFormat, Brush);
  finally
    GDIFont.Free;
    StringFormat.Free;
    Brush.Free;
    Path.Free;
    Graphics.Free;
  end;
end;

procedure TCustomPageControl.Resize;
begin
  inherited;
  // 크기가 변경될 때마다 모든 탭의 위치와 크기를 재계산
  Realign;
  Invalidate;
end;

procedure TCustomPageControl.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  Inc(Rect.Top, TabHeight);
end;

procedure TCustomPageControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  R: TRect;
begin
  for I := 0 to PageCount - 1 do
  begin
    R := GetTabRect(I);
    if PtInRect(R, Point(X, Y)) then
    begin
      TabIndex := I;
      Break;
    end;
  end;
  inherited;
end;

end.
