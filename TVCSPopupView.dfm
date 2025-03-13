object frmPopupView: TfrmPopupView
  Left = 0
  Top = 0
  ClientHeight = 404
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 368
    Width = 543
    Height = 36
    Align = alBottom
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 344
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
  end
  object SinglePlayer: TPasLibVlcPlayer
    Left = 0
    Top = 0
    Width = 543
    Height = 368
    Align = alClient
    SnapShotFmt = 'png'
    MouseEventsHandler = mehComponent
  end
end
