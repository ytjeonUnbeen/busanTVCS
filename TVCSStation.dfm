object frmStation: TfrmStation
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 691
  ClientWidth = 1274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 641
    Width = 1274
    Height = 50
    Align = alBottom
    Caption = 'pnBottom'
    ShowCaption = False
    TabOrder = 0
    object btnCancel: TAdvGlowButton
      Left = 544
      Top = 6
      Width = 75
      Height = 24
      Caption = #52712#49548
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 2
      OnClick = btnCancelClick
      Appearance.BorderColor = clNavy
      Appearance.BorderColorHot = 11565130
      Appearance.BorderColorCheckedHot = 11565130
      Appearance.BorderColorDown = 11565130
      Appearance.BorderColorChecked = 13744549
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clWhite
      Appearance.ColorTo = clNone
      Appearance.ColorChecked = 13744549
      Appearance.ColorCheckedTo = 13744549
      Appearance.ColorDisabled = clWhite
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 11565130
      Appearance.ColorDownTo = 11565130
      Appearance.ColorHot = 16444643
      Appearance.ColorHotTo = clNone
      Appearance.ColorMirror = clWhite
      Appearance.ColorMirrorTo = clNone
      Appearance.ColorMirrorHot = 16444643
      Appearance.ColorMirrorHotTo = clNone
      Appearance.ColorMirrorDown = 11565130
      Appearance.ColorMirrorDownTo = clNone
      Appearance.ColorMirrorChecked = 13744549
      Appearance.ColorMirrorCheckedTo = clNone
      Appearance.ColorMirrorDisabled = clWhite
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.Gradient = ggRadial
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 3750459
      Appearance.TextColorDown = 2303013
      Appearance.TextColorHot = 2303013
      Appearance.TextColorDisabled = 13948116
    end
    object btnDlgClose: TAdvGlowButton
      Left = 60
      Top = 15
      Width = 40
      Height = 24
      Caption = #45803#44592
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 0
      OnClick = btnDlgCloseClick
      Appearance.BorderColor = 11382963
      Appearance.BorderColorHot = 11565130
      Appearance.BorderColorCheckedHot = 11565130
      Appearance.BorderColorDown = 11565130
      Appearance.BorderColorChecked = 13744549
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clWhite
      Appearance.ColorTo = clNone
      Appearance.ColorChecked = 13744549
      Appearance.ColorCheckedTo = 13744549
      Appearance.ColorDisabled = clWhite
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 11565130
      Appearance.ColorDownTo = 11565130
      Appearance.ColorHot = 16444643
      Appearance.ColorHotTo = 16444643
      Appearance.ColorMirror = clWhite
      Appearance.ColorMirrorTo = clNone
      Appearance.ColorMirrorHot = 16444643
      Appearance.ColorMirrorHotTo = clNone
      Appearance.ColorMirrorDown = 11565130
      Appearance.ColorMirrorDownTo = 11565130
      Appearance.ColorMirrorChecked = 13744549
      Appearance.ColorMirrorCheckedTo = 13744549
      Appearance.ColorMirrorDisabled = clWhite
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 3750459
      Appearance.TextColorDown = 2303013
      Appearance.TextColorHot = 2303013
      Appearance.TextColorDisabled = 13948116
    end
    object btnSave: TAdvGlowButton
      Left = 688
      Top = 6
      Width = 75
      Height = 24
      Caption = #51200#51109
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 1
      OnClick = btnSaveClick
      Appearance.BorderColor = clNavy
      Appearance.BorderColorHot = 11565130
      Appearance.BorderColorCheckedHot = 11565130
      Appearance.BorderColorDown = 11565130
      Appearance.BorderColorChecked = 13744549
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clWhite
      Appearance.ColorTo = clWhite
      Appearance.ColorChecked = 13744549
      Appearance.ColorCheckedTo = 13744549
      Appearance.ColorDisabled = clWhite
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 11565130
      Appearance.ColorDownTo = 11565130
      Appearance.ColorHot = 16444643
      Appearance.ColorHotTo = 16444643
      Appearance.ColorMirror = clWhite
      Appearance.ColorMirrorTo = clWhite
      Appearance.ColorMirrorHot = 16444643
      Appearance.ColorMirrorHotTo = 16444643
      Appearance.ColorMirrorDown = 11565130
      Appearance.ColorMirrorDownTo = 11565130
      Appearance.ColorMirrorChecked = 13744549
      Appearance.ColorMirrorCheckedTo = 13744549
      Appearance.ColorMirrorDisabled = clWhite
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 3750459
      Appearance.TextColorDown = 2303013
      Appearance.TextColorHot = 2303013
      Appearance.TextColorDisabled = 13948116
    end
  end
  object pnMainFrame: TPanel
    Left = 0
    Top = 0
    Width = 1274
    Height = 641
    Align = alClient
    Caption = 'pnMainFrame'
    ShowCaption = False
    TabOrder = 1
    object lblInfoTitle: TLabel
      Left = 450
      Top = 80
      Width = 112
      Height = 18
      Caption = #49849#44053#44592' '#52852#47700#46972' '#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTitle: TLabel
      Left = 328
      Top = 4
      Width = 148
      Height = 19
      Caption = #50669#49324' '#51221#48372' '#44288#47532
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #46027#50880#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotal: TLabel
      Left = 65
      Top = 85
      Width = 35
      Height = 13
      Caption = #52509': 0'#44060
    end
    object pnCamStationInfo: TPanel
      Left = 408
      Top = 104
      Width = 842
      Height = 481
      BevelEdges = []
      BevelOuter = bvNone
      Caption = 'edit'
      ShowCaption = False
      TabOrder = 0
      object pnDefStation: TPanel
        Left = 0
        Top = 0
        Width = 842
        Height = 49
        Align = alTop
        Caption = 'pnDefStation'
        ShowCaption = False
        TabOrder = 0
        object lblstCode: TLabel
          Left = 10
          Top = 20
          Width = 33
          Height = 16
          Caption = #50669#48264#54840
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblStname: TLabel
          Left = 152
          Top = 20
          Width = 33
          Height = 16
          Caption = #50669#49324#47749
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbTvcsIpaddr: TLabel
          Left = 312
          Top = 24
          Width = 62
          Height = 13
          Caption = 'TVCSIP'#51452#49548
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edStcode: TEdit
          Left = 49
          Top = 18
          Width = 71
          Height = 21
          TabOrder = 0
        end
        object edStname: TEdit
          Left = 191
          Top = 18
          Width = 81
          Height = 21
          TabOrder = 1
        end
        object edTvcsIpaddr: TEdit
          Left = 380
          Top = 18
          Width = 93
          Height = 21
          TabOrder = 2
        end
      end
      object pnT1Delay: TPanel
        Left = 0
        Top = 49
        Width = 842
        Height = 95
        Align = alTop
        Caption = 'pnT1Delay'
        ShowCaption = False
        TabOrder = 1
        object lblT1Delay: TLabel
          Left = 9
          Top = 6
          Width = 175
          Height = 16
          Caption = #50689#49345' '#49892#54665' '#51648#50672' '#49884#44036' '#49444#51221'('#45800#50948' '#52488')'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblT1UpDep: TLabel
          Left = 10
          Top = 38
          Width = 68
          Height = 13
          Caption = #49345#54665' '#52636#48156#49884' : '
        end
        object lblT1DownDep: TLabel
          Left = 209
          Top = 38
          Width = 65
          Height = 13
          Caption = #54616#54665' '#52636#48156#49884' :'
        end
        object lblT1UpArr: TLabel
          Left = 35
          Top = 68
          Width = 43
          Height = 13
          Caption = #46020#52265' '#49884' :'
        end
        object lblT1DownArr: TLabel
          Left = 231
          Top = 68
          Width = 43
          Height = 13
          Caption = #46020#52265' '#49884' :'
        end
        object edT1DepDownDelay: TEdit
          Left = 84
          Top = 28
          Width = 50
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object edT1DepUpDelay: TEdit
          Left = 280
          Top = 33
          Width = 50
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object edT1DownArrDelay: TEdit
          Left = 84
          Top = 67
          Width = 50
          Height = 21
          TabOrder = 2
          Text = '0'
        end
        object edT1UpArrDelay: TEdit
          Left = 280
          Top = 61
          Width = 50
          Height = 21
          TabOrder = 3
          Text = '0'
        end
      end
      object pnCamInfos: TPanel
        Left = 0
        Top = 144
        Width = 842
        Height = 337
        Align = alClient
        Caption = 'pnCamInfos'
        ShowCaption = False
        TabOrder = 2
        object Label2: TLabel
          Left = 10
          Top = 6
          Width = 96
          Height = 16
          Caption = #49849#44053#44592' '#52852#47700#46972' '#51221#48372
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbStCamCnt: TLabel
          Left = 18
          Top = 29
          Width = 35
          Height = 13
          Caption = #52509': 0'#44060
        end
        object btnAddCams: TAdvGlowButton
          Left = 712
          Top = 10
          Width = 113
          Height = 24
          Caption = #52852#47700#46972' '#52628#44032
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          NotesFont.Charset = DEFAULT_CHARSET
          NotesFont.Color = clWindowText
          NotesFont.Height = -11
          NotesFont.Name = 'Tahoma'
          NotesFont.Style = []
          ParentFont = False
          Rounded = True
          TabOrder = 0
          OnClick = btnAddCamsClick
          Appearance.BorderColor = 11382963
          Appearance.BorderColorHot = 11565130
          Appearance.BorderColorCheckedHot = 11565130
          Appearance.BorderColorDown = 11565130
          Appearance.BorderColorChecked = 13744549
          Appearance.BorderColorDisabled = 13948116
          Appearance.Color = clWhite
          Appearance.ColorTo = clWhite
          Appearance.ColorChecked = 13744549
          Appearance.ColorCheckedTo = 13744549
          Appearance.ColorDisabled = clWhite
          Appearance.ColorDisabledTo = clNone
          Appearance.ColorDown = 11565130
          Appearance.ColorDownTo = 11565130
          Appearance.ColorHot = 16444643
          Appearance.ColorHotTo = 16444643
          Appearance.ColorMirror = clWhite
          Appearance.ColorMirrorTo = clWhite
          Appearance.ColorMirrorHot = 16444643
          Appearance.ColorMirrorHotTo = 16444643
          Appearance.ColorMirrorDown = 11565130
          Appearance.ColorMirrorDownTo = 11565130
          Appearance.ColorMirrorChecked = 13744549
          Appearance.ColorMirrorCheckedTo = 13744549
          Appearance.ColorMirrorDisabled = clWhite
          Appearance.ColorMirrorDisabledTo = clNone
          Appearance.GradientHot = ggVertical
          Appearance.GradientMirrorHot = ggVertical
          Appearance.GradientDown = ggVertical
          Appearance.GradientMirrorDown = ggVertical
          Appearance.GradientChecked = ggVertical
          Appearance.TextColorChecked = 3750459
          Appearance.TextColorDown = 2303013
          Appearance.TextColorHot = 2303013
          Appearance.TextColorDisabled = 13948116
        end
        object grdStationCams: TAdvStringGrid
          Left = 18
          Top = 48
          Width = 807
          Height = 273
          DefaultRowHeight = 25
          DrawingStyle = gdsClassic
          FixedColor = clWhite
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
          TabOrder = 1
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = 4474440
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ActiveCellColor = 11565130
          ActiveCellColorTo = 11565130
          BorderColor = 11250603
          ControlLook.ButtonPrefix = True
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
          ControlLook.DropDownAlwaysVisible = True
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
          FixedRowHeight = 25
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          GridImages = VirtualImageList1
          HoverButtons.Buttons = <>
          HTMLSettings.ImageFolder = 'images'
          HTMLSettings.ImageBaseName = 'img'
          Look = glCustom
          MouseActions.DirectComboDrop = True
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
          SortSettings.HeaderColor = clWhite
          SortSettings.HeaderColorTo = clWhite
          SortSettings.HeaderMirrorColor = clWhite
          SortSettings.HeaderMirrorColorTo = clWhite
          Version = '9.1.3.0'
          RowHeights = (
            25
            25
            25
            25
            25
            25
            25
            25
            25
            25)
        end
      end
    end
    object btnAddStation: TAdvGlowButton
      Left = 282
      Top = 74
      Width = 104
      Height = 24
      Caption = #50669#49324' '#52628#44032
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 1
      OnClick = btnAddStationClick
      Appearance.BorderColor = clNavy
      Appearance.BorderColorHot = 15917525
      Appearance.BorderColorCheckedHot = 14925219
      Appearance.BorderColorDown = 14925219
      Appearance.BorderColorChecked = 15914434
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clWhite
      Appearance.ColorTo = clNone
      Appearance.ColorChecked = 15914434
      Appearance.ColorCheckedTo = clNone
      Appearance.ColorDisabled = clWhite
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 14925219
      Appearance.ColorDownTo = clNone
      Appearance.ColorHot = 15917525
      Appearance.ColorHotTo = clNone
      Appearance.ColorMirror = clWhite
      Appearance.ColorMirrorTo = clNone
      Appearance.ColorMirrorHot = 15917525
      Appearance.ColorMirrorHotTo = clNone
      Appearance.ColorMirrorDown = 14925219
      Appearance.ColorMirrorDownTo = clNone
      Appearance.ColorMirrorChecked = 15914434
      Appearance.ColorMirrorCheckedTo = clNone
      Appearance.ColorMirrorDisabled = clWhite
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.Gradient = ggRadial
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 5263440
      Appearance.TextColorDown = 5263440
      Appearance.TextColorHot = 5263440
      Appearance.TextColorDisabled = 13948116
    end
    object btnSearch: TAdvGlowButton
      Left = 769
      Top = 40
      Width = 50
      Height = 24
      Caption = #44160#49353
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 2
      Appearance.BorderColor = clBlue
      Appearance.BorderColorHot = 11565130
      Appearance.BorderColorCheckedHot = 11565130
      Appearance.BorderColorDown = 11565130
      Appearance.BorderColorChecked = 13744549
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clBlue
      Appearance.ColorTo = clBlue
      Appearance.ColorChecked = 13744549
      Appearance.ColorCheckedTo = 13744549
      Appearance.ColorDisabled = clBlue
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 11565130
      Appearance.ColorDownTo = 11565130
      Appearance.ColorHot = 16444643
      Appearance.ColorHotTo = 16444643
      Appearance.ColorMirror = clBlue
      Appearance.ColorMirrorTo = clBlue
      Appearance.ColorMirrorHot = 16444643
      Appearance.ColorMirrorHotTo = 16444643
      Appearance.ColorMirrorDown = 11565130
      Appearance.ColorMirrorDownTo = 11565130
      Appearance.ColorMirrorChecked = 13744549
      Appearance.ColorMirrorCheckedTo = 13744549
      Appearance.ColorMirrorDisabled = clBlue
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 3750459
      Appearance.TextColorDown = 2303013
      Appearance.TextColorHot = 2303013
      Appearance.TextColorDisabled = 13948116
    end
    object btnStationDownload: TAdvGlowButton
      Left = 1072
      Top = 599
      Width = 175
      Height = 24
      Caption = #50669#49324' '#51221#48372' '#51068#44292' '#45236#47140#48155#44592
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 3
      OnClick = btnStationDownloadClick
      Appearance.BorderColor = 11382963
      Appearance.BorderColorHot = 11565130
      Appearance.BorderColorCheckedHot = 11565130
      Appearance.BorderColorDown = 11565130
      Appearance.BorderColorChecked = 13744549
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clWhite
      Appearance.ColorTo = clWhite
      Appearance.ColorChecked = 13744549
      Appearance.ColorCheckedTo = 13744549
      Appearance.ColorDisabled = clWhite
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 11565130
      Appearance.ColorDownTo = 11565130
      Appearance.ColorHot = 16444643
      Appearance.ColorHotTo = 16444643
      Appearance.ColorMirror = clWhite
      Appearance.ColorMirrorTo = clWhite
      Appearance.ColorMirrorHot = 16444643
      Appearance.ColorMirrorHotTo = 16444643
      Appearance.ColorMirrorDown = 11565130
      Appearance.ColorMirrorDownTo = 11565130
      Appearance.ColorMirrorChecked = 13744549
      Appearance.ColorMirrorCheckedTo = 13744549
      Appearance.ColorMirrorDisabled = clWhite
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 3750459
      Appearance.TextColorDown = 2303013
      Appearance.TextColorHot = 2303013
      Appearance.TextColorDisabled = 13948116
    end
    object btnUploadStations: TAdvGlowButton
      Left = 888
      Top = 599
      Width = 175
      Height = 24
      Caption = #50669#49324' '#51221#48372' '#51068#44292' '#46321#47197
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      ParentFont = False
      Rounded = True
      TabOrder = 4
      OnClick = btnUploadStationsClick
      Appearance.BorderColor = 11382963
      Appearance.BorderColorHot = 11565130
      Appearance.BorderColorCheckedHot = 11565130
      Appearance.BorderColorDown = 11565130
      Appearance.BorderColorChecked = 13744549
      Appearance.BorderColorDisabled = 13948116
      Appearance.Color = clWhite
      Appearance.ColorTo = clWhite
      Appearance.ColorChecked = 13744549
      Appearance.ColorCheckedTo = 13744549
      Appearance.ColorDisabled = clWhite
      Appearance.ColorDisabledTo = clNone
      Appearance.ColorDown = 11565130
      Appearance.ColorDownTo = 11565130
      Appearance.ColorHot = 16444643
      Appearance.ColorHotTo = 16444643
      Appearance.ColorMirror = clWhite
      Appearance.ColorMirrorTo = clWhite
      Appearance.ColorMirrorHot = 16444643
      Appearance.ColorMirrorHotTo = 16444643
      Appearance.ColorMirrorDown = 11565130
      Appearance.ColorMirrorDownTo = 11565130
      Appearance.ColorMirrorChecked = 13744549
      Appearance.ColorMirrorCheckedTo = 13744549
      Appearance.ColorMirrorDisabled = clWhite
      Appearance.ColorMirrorDisabledTo = clNone
      Appearance.GradientHot = ggVertical
      Appearance.GradientMirrorHot = ggVertical
      Appearance.GradientDown = ggVertical
      Appearance.GradientMirrorDown = ggVertical
      Appearance.GradientChecked = ggVertical
      Appearance.TextColorChecked = 3750459
      Appearance.TextColorDown = 2303013
      Appearance.TextColorHot = 2303013
      Appearance.TextColorDisabled = 13948116
    end
    object cmbStation: TComboBox
      Left = 474
      Top = 43
      Width = 97
      Height = 21
      ItemIndex = 0
      TabOrder = 5
      Text = '== '#51204#52404' =='
      Items.Strings = (
        '== '#51204#52404' =='
        #50669#49324#47749
        #50669#48264#54840)
    end
    object edSearchText: TEdit
      Left = 577
      Top = 43
      Width = 186
      Height = 21
      TabOrder = 6
    end
    object grdStations: TAdvStringGrid
      Left = 65
      Top = 104
      Width = 321
      Height = 481
      DrawingStyle = gdsClassic
      FixedColor = clSkyBlue
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goFixedRowDefAlign]
      TabOrder = 7
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
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      GridImages = VirtualImageList1
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
      SortSettings.HeaderColor = clWhite
      SortSettings.HeaderColorTo = clWhite
      SortSettings.HeaderMirrorColor = clWhite
      SortSettings.HeaderMirrorColorTo = clWhite
      Version = '9.1.3.0'
    end
  end
  object ImageList1: TImageList
    Height = 33
    Width = 33
    Left = 144
    Top = 592
    Bitmap = {
      494C010102000800040021002100FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000840000002100000001002000000000001044
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000262626404D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D80262626400000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003A3A3A60999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007D7D7DD0999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF909090F000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A0A0A104D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D803030305000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FF999999FF999999FF9999
      99FF999999FF999999FF909090F0999999FF999999FF999999FF999999FF9090
      90F0999999FF999999FF999999FF999999FF999999FF999999FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001D1D1D30909090F0999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000999999FF999999FF999999FF999999FF999999FF606060A01D1D1D309999
      99FF999999FF999999FF999999FF1D1D1D3056565690999999FF999999FF9999
      99FF999999FF999999FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000A0A
      0A10868686E0999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF3A3A3A600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000999999FF999999FF999999FF9999
      99FF999999FF4D4D4D8000000000999999FF999999FF999999FF999999FF0000
      00003A3A3A60999999FF999999FF999999FF999999FF999999FF131313200000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004D4D4D80999999FF999999FF9999
      99FF999999FF999999FF999999FF909090F00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001313
      1320999999FF999999FF999999FF999999FF999999FF3A3A3A600A0A0A109999
      99FF999999FF999999FF999999FF2626264026262640999999FF999999FF9999
      99FF999999FF999999FF26262640000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000A0A0A102626264026262640262626402626264026262640262626402626
      264043434370999999FF999999FF999999FF999999FF999999FF999999FF7D7D
      7DD0262626402626264026262640262626402626264026262640262626400A0A
      0A10000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000026262640999999FF999999FF999999FF9999
      99FF999999FF2626264026262640999999FF999999FF999999FF999999FF2626
      264026262640999999FF999999FF999999FF999999FF999999FF262626400000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003A3A3A60909090F0999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF909090F04343437000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002626
      2640999999FF999999FF999999FF999999FF999999FF26262640262626409999
      99FF999999FF999999FF999999FF2626264026262640999999FF999999FF9999
      99FF999999FF999999FF26262640000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009090
      90F0999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF909090F06A6A6AB0999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF4343437000000000000000000000000000000000000000000000
      000000000000000000000000000026262640999999FF999999FF999999FF9999
      99FF999999FF2626264026262640999999FF999999FF999999FF999999FF3030
      305013131320999999FF999999FF999999FF999999FF999999FF434343700000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF6A6A
      6AB03A3A3A60999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000004D4D
      4D80999999FF999999FF999999FF999999FF999999FF0A0A0A103A3A3A609999
      99FF999999FF999999FF999999FF4D4D4D8000000000999999FF999999FF9999
      99FF999999FF999999FF4D4D4D80000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      00000000000000000000000000004D4D4D80999999FF999999FF999999FF9999
      99FF999999FF000000004D4D4D80999999FF999999FF999999FF999999FF4D4D
      4D8000000000999999FF999999FF999999FF999999FF999999FF4D4D4D800000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF6A6A6AB04D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D80999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000004D4D
      4D80999999FF999999FF999999FF999999FF999999FF000000004D4D4D809999
      99FF999999FF999999FF999999FF4D4D4D8000000000999999FF999999FF9999
      99FF999999FF999999FF56565690000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF2626264000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      000000000000000000000000000056565690999999FF999999FF999999FF9999
      99FF999999FF000000004D4D4D80999999FF999999FF999999FF999999FF6060
      60A0000000007D7D7DD0999999FF999999FF999999FF999999FF737373C00000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF26262640000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000007373
      73C0999999FF999999FF999999FF999999FF737373C000000000606060A09999
      99FF999999FF999999FF999999FF737373C000000000737373C0999999FF9999
      99FF999999FF999999FF737373C0000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF2626264000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      0000000000000000000000000000737373C0999999FF999999FF999999FF9999
      99FF737373C000000000737373C0999999FF999999FF999999FF999999FF7373
      73C000000000737373C0999999FF999999FF999999FF999999FF737373C00000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF26262640000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000007373
      73C0999999FF999999FF999999FF999999FF737373C000000000737373C09999
      99FF999999FF999999FF999999FF737373C000000000737373C0999999FF9999
      99FF999999FF999999FF868686E0000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF2626264000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      0000000000000000000000000000909090F0999999FF999999FF999999FF9999
      99FF737373C0000000007D7D7DD0999999FF999999FF999999FF999999FF9090
      90F00000000056565690999999FF999999FF999999FF999999FF999999FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF26262640000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF999999FF999999FF999999FF999999FF737373C0999999FF9999
      99FF999999FF999999FF999999FF999999FF737373C0999999FF999999FF9999
      99FF999999FF999999FF999999FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF2626264000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF26262640000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000009090
      90F0999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF909090F0131313200000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF2626264000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      00000000000000000000000000001D1D1D304D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D80262626400000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF26262640000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF2626264000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      0000000000000000000000000000737373C0999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF7D7D7DD00000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF26262640000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000999999FF999999FF4D4D4D80000000000000
      0000000000000000000000000000000000000000000000000000000000008686
      86E0999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF868686E0000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      99FF999999FF6A6A6AB04D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D
      4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D804D4D4D809999
      99FF999999FF4D4D4D8000000000000000000000000000000000000000000000
      000000000000000000000000000026262640999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF303030500000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000868686E0999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF3A3A3A60000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000026262640868686E0999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF868686E03030305000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001313
      13204D4D4D80909090F0999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF9999
      99FF999999FF999999FF999999FF999999FF999999FF999999FF999999FF8686
      86E0565656900000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000131313202626
      264026262640999999FF999999FF434343702626264026262640303030509999
      99FF999999FF30303050262626401D1D1D300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000868686E0999999FF8686
      86E026262640262626407D7D7DD0999999FF909090F000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000030303050999999FF999999FF999999FF999999FF999999FF9999
      99FF434343700000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000303030507373
      73C0737373C0737373C0737373C03A3A3A600000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424D3E000000000000003E00000028000000840000002100000001000100
      00000000940200000000000000000000000000000000000000000000FFFFFF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000}
  end
  object VirtualImageList1: TVirtualImageList
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'icon-'#48120#47532#48372#44592
        Disabled = False
        Name = 'preview'
      end
      item
        CollectionIndex = 1
        CollectionName = 'icon-'#49325#51228
        Disabled = False
        Name = 'delete'
      end>
    ImageCollection = ImageCollection1
    Left = 408
    Top = 600
  end
  object ImageCollection1: TImageCollection
    Images = <
      item
        Name = 'icon-'#48120#47532#48372#44592
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D494844520000002100000021080600000057E4C2
              6F000000097048597300000B1200000B1201D2DD7EFC0000011E494441545885
              ED97C16D83301486BF54B9930D9A1118211B74057A79D7D209E806E5FC5FBA42
              B3414648374837081390436D815C20A10925077F12427E58F6C7B3851F8BBAAE
              999B87B905204A342CDB0D496B200372209960BE6FE0D3CCF27630CCC40E2826
              120078045E2465EDE0B2A313C016D84F2051B8FB7A48C2539AD9EED606928AAE
              F85D6CCC28E189129E28E189129E28E1E93B3B72499BB9259EDCF52F5CBB1C5B
              E0F95A89301315E30A9ACD1FE73DB61B61267227722909E396AD025ECDAC6C07
              17E17F87A415900E0C9402EF3DCFBEF879913EF666760C83BF24CE21E98DA64C
              0BA9CC6C356A40466E4C97A56CA04B1216B13795909402079A62B88F0F97AD8B
              E9FB4E747100CA739D1CA32AF5D17B620AEEE2EC88129E134206413F0DBB1BF5
              0000000049454E44AE426082}
          end>
      end
      item
        Name = 'icon-'#49325#51228
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D494844520000002100000021080600000057E4C2
              6F000000097048597300000B1200000B1201D2DD7EFC00000192494441545885
              CD97C171C23010451F99DCA183B883B883900EA082DCF60C1DA484E4BA277790
              7480D301E9003A301590CB7A3C10698D3482E4CF780CBBD6EA495E4BABC9F178
              E4AF759FD3485517C0EACCDC884893136F923A1306F01171AF45E42D15E22EB5
              01D077B2079EEDFA36DB6B46BCCB6642552BA0B2BF1BBBAF81ADFD9E31CCCE12
              E8804E447A7F3E84AACE810678B82458407B6025229F591006B0093AD3B5F440
              BC9C680A01C09047C910BB82109DE74CFE44AFA1E862A5AA35B028D44F2B226D
              CCE92566074C0B411C805A447621A79713A50000A63180318898BE327D517910
              87502722326758A64F9E37DF7B49086FC90D7D72FDF375C0B7CF8528A9DD3520
              DCA0A94A7D1D4F0E446F9B958470975A07E231E073B7F45BE5843BA06408559D
              71C39C6823F63A02B1B50A2CA4B233E1A8632801CFF52F72C2554E51533132B2
              6210CEAE5789C8AF776CF5421569138BE54338AAACE03991D942FB86372020EF
              18F842B8E26AC9AC41C66622B46513E92C06102A09922092CF95393146AB6D3B
              04CD3301DC02F762885BE8076A178411D89E3AD60000000049454E44AE426082}
          end>
      end>
    Left = 496
    Top = 600
  end
  object AdvFormStyler1: TAdvFormStyler
    AppColor = 14851584
    Left = 728
    Top = 592
  end
  object AdvAppStyler1: TAdvAppStyler
    AppColor = clHighlight
    Metro = True
    MetroColor = clHotLight
    Left = 840
    Top = 592
  end
  object AdvGridExcelIO1: TAdvGridExcelIO
    AdvStringGrid = grdStationCams
    Options.ExportOverwriteMessage = 'File %s already exists'#13'Ok to overwrite ?'
    Options.ExportRawRTF = False
    UseUnicode = True
    Version = '3.14'
    Left = 928
    Top = 641
  end
end
