object frmUsers: TfrmUsers
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #49324#50857#51088' '#44288#47532
  ClientHeight = 700
  ClientWidth = 850
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
  object pnMainFrame: TPanel
    Left = 0
    Top = 0
    Width = 850
    Height = 630
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 70
    object lblUsersTitle: TLabel
      Left = 368
      Top = 15
      Width = 94
      Height = 15
      Caption = #49324#50857#51088' '#44288#47532
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #46027#50880#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubLine: TLabel
      Left = 468
      Top = 17
      Width = 36
      Height = 13
      Caption = '(2'#54840#49440')'
    end
    object lblUsersCnt: TLabel
      Left = 56
      Top = 144
      Width = 38
      Height = 16
      Caption = #52509': 3'#47749
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object cbxSearch: TDBComboBox
      Left = 256
      Top = 80
      Width = 81
      Height = 21
      TabOrder = 0
    end
    object edtSerch: TEdit
      Left = 343
      Top = 80
      Width = 210
      Height = 21
      TabOrder = 1
    end
    object btnSerch: TButton
      Left = 559
      Top = 78
      Width = 58
      Height = 25
      Caption = #44160#49353
      TabOrder = 2
    end
    object grdUsers: TAdvStringGrid
      Left = 62
      Top = 176
      Width = 731
      Height = 129
      DrawingStyle = gdsClassic
      FixedColor = clWhite
      TabOrder = 3
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
      FixedFont.Color = clWindowText
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
      SelectionTextColor = clWindowText
      ShowDesignHelper = False
      SortSettings.HeaderColor = clWhite
      SortSettings.HeaderColorTo = clWhite
      SortSettings.HeaderMirrorColor = clWhite
      SortSettings.HeaderMirrorColorTo = clWhite
      Version = '9.0.0.6'
    end
    object Button1: TButton
      Left = 712
      Top = 145
      Width = 81
      Height = 25
      Caption = '+ '#49324#50857#51088' '#52628#44032
      TabOrder = 4
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 630
    Width = 850
    Height = 70
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 636
    object btnDlgClose: TButton
      Left = 56
      Top = 24
      Width = 75
      Height = 25
      Caption = #45803#44592
      TabOrder = 0
      OnClick = btnDlgCloseClick
    end
    object btnCancel: TButton
      Left = 632
      Top = 24
      Width = 75
      Height = 25
      Caption = #52712#49548
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnSave: TButton
      Left = 718
      Top = 24
      Width = 75
      Height = 25
      Caption = #51200#51109
      TabOrder = 2
      OnClick = btnSaveClick
    end
  end
end
