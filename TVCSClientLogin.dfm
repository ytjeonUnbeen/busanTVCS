object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 247
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 40
    Top = 88
    Width = 79
    Height = 13
    Caption = #50689#49345#52376#47532#49436#48260' IP'
  end
  object Label1: TLabel
    Left = 64
    Top = 115
    Width = 33
    Height = 13
    Caption = #50500#51060#46356
  end
  object Label2: TLabel
    Left = 64
    Top = 142
    Width = 44
    Height = 13
    Caption = #48708#48128#48264#54840
  end
  object Label4: TLabel
    Left = 112
    Top = 8
    Width = 151
    Height = 25
    Caption = #50689#49345#54364#52636' '#53364#46972#51060#50616#53944
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label5: TLabel
    Left = 152
    Top = 39
    Width = 48
    Height = 25
    Caption = #47196#44536#51064
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label6: TLabel
    Left = 56
    Top = 226
    Width = 314
    Height = 13
    Caption = #47928#51032' '#49324#54637#51008' '#44033' '#54840#49440' '#53685#49888#52376' '#45812#45817#51088#50640#44172' '#47928#51032' '#54644#51452#49884#44592' '#48148#46989#45768#45796'.'
  end
  object edServer: TEdit
    Left = 125
    Top = 85
    Width = 220
    Height = 21
    TabOrder = 0
    Text = 'http://192.168.1.37:7003'
  end
  object edUser: TEdit
    Left = 128
    Top = 112
    Width = 153
    Height = 21
    TabOrder = 1
    Text = 'admin'
  end
  object edPass: TEdit
    Left = 128
    Top = 139
    Width = 153
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Text = 'qwe123!@#'
  end
  object chkSave: TCheckBox
    Left = 128
    Top = 176
    Width = 153
    Height = 17
    Caption = 'IP/'#50500#51060#46356'/'#48708#48128#48264#54840' '#51200#51109
    TabOrder = 3
  end
  object chkAutoLogin: TCheckBox
    Left = 128
    Top = 199
    Width = 153
    Height = 17
    Caption = #51088#46041#47196#44536#51064
    TabOrder = 4
  end
  object btnLogin: TAdvGlassButton
    Left = 287
    Top = 112
    Width = 58
    Height = 48
    BackColor = clBlue
    Caption = #47196#44536#51064
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ForeColor = clBlue
    GlowColor = clBlue
    ImageIndex = -1
    InnerBorderColor = clBlack
    OuterBorderColor = clWhite
    ParentFont = False
    ShineColor = clBlue
    TabOrder = 5
    Version = '1.3.3.1'
    OnClick = btnLoginClick
  end
  object tmStarter: TTimer
    OnTimer = tmStarterTimer
    Left = 24
    Top = 184
  end
end