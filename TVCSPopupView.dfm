object frmPopupView: TfrmPopupView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 284
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 456
    Height = 231
    Align = alClient
    Alignment = taCenter
    Caption = 'Label1'
    Layout = tlCenter
    ExplicitLeft = 224
    ExplicitTop = 64
    ExplicitWidth = 31
    ExplicitHeight = 13
  end
  object Panel1: TPanel
    Left = 0
    Top = 231
    Width = 456
    Height = 53
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 336
    ExplicitWidth = 730
    object btnCancel: TButton
      Left = 96
      Top = 16
      Width = 75
      Height = 25
      Caption = #52712#49548
      TabOrder = 0
    end
    object btnAgree: TButton
      Left = 280
      Top = 16
      Width = 75
      Height = 25
      Caption = #54869#51064
      TabOrder = 1
    end
  end
end
