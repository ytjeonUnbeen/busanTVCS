object frmEvent: TfrmEvent
  Left = 0
  Top = 0
  ClientHeight = 465
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object eventPlayer: TPasLibVlcPlayer
    Left = 0
    Top = 0
    Width = 844
    Height = 465
    Align = alClient
    SnapShotFmt = 'png'
    MouseEventsHandler = mehComponent
  end
end
