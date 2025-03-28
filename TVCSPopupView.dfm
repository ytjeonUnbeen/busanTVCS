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
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 13
  object SinglePlayer: TPasLibVlcPlayer
    Left = 0
    Top = 0
    Width = 543
    Height = 404
    Align = alClient
    SnapShotFmt = 'png'
    MouseEventsHandler = mehComponent
    ExplicitHeight = 368
  end
end
