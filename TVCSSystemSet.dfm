object frmSystem: TfrmSystem
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #49884#49828#53596' '#44288#47532
  ClientHeight = 757
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 687
    Align = alClient
    TabOrder = 0
    object lblTitle: TLabel
      Left = 376
      Top = 8
      Width = 91
      Height = 23
      Caption = #49884#49828#53596' '#44288#47532
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbConViewSetTitle: TLabel
      Left = 40
      Top = 80
      Width = 168
      Height = 16
      Caption = #9679' '#49688#46041' '#54868#47732' '#39#54868#47732#54364#52636' '#50689#50669#39' '#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbConViewSetMenu: TLabel
      Left = 67
      Top = 110
      Width = 119
      Height = 16
      Caption = #50689#50669' '#44256#51221' ('#52395#48264#51704' '#49472') :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbAutoSetTitle: TLabel
      Left = 40
      Top = 144
      Width = 86
      Height = 16
      Caption = #9679' '#51088#46041' '#54868#47732' '#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbAutoSetMenu: TLabel
      Left = 67
      Top = 176
      Width = 156
      Height = 16
      Caption = #50676#52264#48324' '#45796#51473#50689#49345' Set '#54364#52636' '#44036#44201
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbAutoSetCnt: TLabel
      Left = 319
      Top = 176
      Width = 11
      Height = 16
      Caption = #52488
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbVideoFormTitle: TLabel
      Left = 40
      Top = 208
      Width = 86
      Height = 16
      Caption = #9679' '#50689#49345' '#54252#47607' '#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbVideoFormResol: TLabel
      Left = 67
      Top = 240
      Width = 81
      Height = 16
      Caption = #49828#53944#47532#48141' '#54644#49345#46020
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbVideoFormFrm: TLabel
      Left = 67
      Top = 272
      Width = 33
      Height = 16
      Caption = #54532#47112#51076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbFrm: TLabel
      Left = 319
      Top = 272
      Width = 17
      Height = 16
      Caption = 'fps'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbEventPopTitle: TLabel
      Left = 40
      Top = 304
      Width = 97
      Height = 16
      Caption = #9679' '#51060#48292#53944' '#54045#50629' '#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbEventPopMenu: TLabel
      Left = 67
      Top = 336
      Width = 111
      Height = 16
      Caption = #51473#48373' '#51060#48292#53944' '#46041#51089' '#44036#44201
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbLicenseTitle: TLabel
      Left = 40
      Top = 376
      Width = 82
      Height = 16
      Caption = #9679' '#46972#51060#49440#49828' '#44288#47532
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbCamLicense: TLabel
      Left = 67
      Top = 408
      Width = 81
      Height = 16
      Caption = #52852#47700#46972' '#46972#51060#49440#49828
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbAutoLoginTitle: TLabel
      Left = 40
      Top = 624
      Width = 71
      Height = 16
      Caption = #9679' '#47196#44536#51064' '#49444#51221
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbAutoLoginMenu: TLabel
      Left = 67
      Top = 656
      Width = 96
      Height = 16
      Caption = #49884#49828#53596' '#51088#46041' '#47196#44536#51064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbCliPcLicense: TLabel
      Left = 67
      Top = 519
      Width = 154
      Height = 16
      Caption = #51109#52824' '#46972#51060#49440#49828'('#53364#46972#51060#50616#53944' PC)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object chkConViewSet: TCheckBox
      Left = 192
      Top = 111
      Width = 16
      Height = 17
      TabOrder = 0
    end
    object speAutoSetCnt: TSpinEdit
      Left = 240
      Top = 175
      Width = 73
      Height = 22
      MaxValue = 60
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object cboxVideoResol: TDBComboBox
      Left = 192
      Top = 239
      Width = 121
      Height = 21
      Items.Strings = (
        '1920 * 1080'
        '1280 * 720')
      TabOrder = 2
    end
    object cboxVideoFrm: TDBComboBox
      Left = 192
      Top = 271
      Width = 121
      Height = 21
      Items.Strings = (
        '15'
        '30'
        '60'
        '')
      TabOrder = 3
    end
    object speEventPop: TSpinEdit
      Left = 399
      Top = 335
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 30
    end
    object cbxEventPop: TDBComboBox
      Left = 488
      Top = 335
      Width = 65
      Height = 21
      Items.Strings = (
        #52488
        #48516
        #49884#44036)
      TabOrder = 5
    end
    object grdCamLicense: TAdvStringGrid
      Left = 67
      Top = 430
      Width = 694
      Height = 67
      ColCount = 3
      DrawingStyle = gdsClassic
      FixedColor = clWhite
      RowCount = 3
      TabOrder = 6
      GridLineColor = 13948116
      GridFixedLineColor = 11250603
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = 4474440
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ActiveCellColor = 11565130
      ActiveCellColorTo = 11565130
      BorderColor = 11250603
      ControlLook.FixedGradientFrom = clWhite
      ControlLook.FixedGradientTo = clWhite
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientHoverMirrorFrom = clWhite
      ControlLook.FixedGradientHoverMirrorTo = clWhite
      ControlLook.FixedGradientHoverBorder = 11645361
      ControlLook.FixedGradientDownFrom = clWhite
      ControlLook.FixedGradientDownTo = clWhite
      ControlLook.FixedGradientDownMirrorFrom = clWhite
      ControlLook.FixedGradientDownMirrorTo = clWhite
      ControlLook.FixedGradientDownBorder = 11250603
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
      ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
      ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
      ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
      ControlLook.ToggleSwitch.CaptionFont.Height = -11
      ControlLook.ToggleSwitch.CaptionFont.Name = 'Tahoma'
      ControlLook.ToggleSwitch.CaptionFont.Style = []
      ControlLook.ToggleSwitch.Shadow = False
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = 3881787
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      Look = glCustom
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.ColorTo = clNone
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      SearchFooter.ResultFormat = '(%d of %d)'
      SelectionColor = 13744549
      SortSettings.HeaderColor = clWhite
      SortSettings.HeaderColorTo = clWhite
      SortSettings.HeaderMirrorColor = clWhite
      SortSettings.HeaderMirrorColorTo = clWhite
      Version = '9.0.0.6'
      ColWidths = (
        64
        18
        18)
    end
    object groupEvent: TGroupBox
      Left = 200
      Top = 333
      Width = 169
      Height = 24
      TabOrder = 7
      object btnEvtRadio1: TRadioButton
        Left = 22
        Top = 4
        Width = 64
        Height = 17
        Caption = #48120#51201#50857
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object btnEvtRadio2: TRadioButton
        Left = 107
        Top = 3
        Width = 64
        Height = 17
        Caption = #51201#50857
        TabOrder = 1
      end
    end
    object groupAutoLogin: TGroupBox
      Left = 200
      Top = 656
      Width = 169
      Height = 24
      TabOrder = 8
      object btnLoginRadio1: TRadioButton
        Left = 22
        Top = 3
        Width = 64
        Height = 17
        Caption = #54728#50857
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object btnLoginRadio2: TRadioButton
        Left = 107
        Top = 3
        Width = 64
        Height = 17
        Caption = #52264#45800
        TabOrder = 1
      end
    end
    object btnAddCamLicense: TButton
      Left = 686
      Top = 399
      Width = 75
      Height = 25
      Caption = '+ '#49888#44508' '#52628#44032
      TabOrder = 9
    end
    object grdCliLocense: TAdvStringGrid
      Left = 67
      Top = 541
      Width = 694
      Height = 69
      DrawingStyle = gdsClassic
      FixedColor = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      GridLineColor = 13948116
      GridFixedLineColor = 11250603
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = 4474440
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ActiveCellColor = 11565130
      ActiveCellColorTo = 11565130
      BorderColor = 11250603
      ControlLook.FixedGradientFrom = clWhite
      ControlLook.FixedGradientTo = clWhite
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientHoverMirrorFrom = clWhite
      ControlLook.FixedGradientHoverMirrorTo = clWhite
      ControlLook.FixedGradientHoverBorder = 11645361
      ControlLook.FixedGradientDownFrom = clWhite
      ControlLook.FixedGradientDownTo = clWhite
      ControlLook.FixedGradientDownMirrorFrom = clWhite
      ControlLook.FixedGradientDownMirrorTo = clWhite
      ControlLook.FixedGradientDownBorder = 11250603
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      ControlLook.ToggleSwitch.BackgroundBorderWidth = 1.000000000000000000
      ControlLook.ToggleSwitch.ButtonBorderWidth = 1.000000000000000000
      ControlLook.ToggleSwitch.CaptionFont.Charset = DEFAULT_CHARSET
      ControlLook.ToggleSwitch.CaptionFont.Color = clWindowText
      ControlLook.ToggleSwitch.CaptionFont.Height = -11
      ControlLook.ToggleSwitch.CaptionFont.Name = 'Tahoma'
      ControlLook.ToggleSwitch.CaptionFont.Style = []
      ControlLook.ToggleSwitch.Shadow = False
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDown.TextChecked = 'Checked'
      FilterDropDown.TextUnChecked = 'Unchecked'
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Larger than'
        'Smaller than'
        'Clear')
      FixedRowHeight = 22
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = 3881787
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HTMLSettings.ImageFolder = 'images'
      HTMLSettings.ImageBaseName = 'img'
      Look = glCustom
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'Tahoma'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'Tahoma'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'Tahoma'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'Tahoma'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      SearchFooter.ColorTo = clNone
      SearchFooter.FindNextCaption = 'Find &next'
      SearchFooter.FindPrevCaption = 'Find &previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'Tahoma'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurrence'
      SearchFooter.HintFindPrev = 'Find previous occurrence'
      SearchFooter.HintHighlight = 'Highlight occurrences'
      SearchFooter.MatchCaseCaption = 'Match case'
      SearchFooter.ResultFormat = '(%d of %d)'
      SelectionColor = 13744549
      SortSettings.HeaderColor = clWhite
      SortSettings.HeaderColorTo = clWhite
      SortSettings.HeaderMirrorColor = clWhite
      SortSettings.HeaderMirrorColorTo = clWhite
      Version = '9.0.0.6'
    end
    object btnAddCliLicense: TButton
      Left = 686
      Top = 510
      Width = 75
      Height = 25
      Caption = '+ '#49888#44508' '#52628#44032
      TabOrder = 11
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 687
    Width = 852
    Height = 70
    Align = alBottom
    TabOrder = 1
    object btnCancel: TButton
      Left = 640
      Top = 24
      Width = 59
      Height = 25
      Caption = #52712#49548
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnSave: TButton
      Left = 702
      Top = 24
      Width = 59
      Height = 25
      Caption = #51200#51109
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object btnDlgClose: TButton
      Left = 25
      Top = 24
      Width = 56
      Height = 25
      Caption = #45803#44592
      TabOrder = 2
      OnClick = btnDlgCloseClick
    end
  end
end
