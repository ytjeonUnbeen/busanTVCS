object frmLayouts: TfrmLayouts
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #54200#49457#48324' '#50689#49345' '#44288#47532
  ClientHeight = 678
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
  PixelsPerInch = 96
  TextHeight = 13
  object pnMainFrame: TPanel
    Left = 0
    Top = 0
    Width = 1274
    Height = 608
    Align = alClient
    Caption = 'pnMainFrame'
    ShowCaption = False
    TabOrder = 0
    object lblInfoTitle: TLabel
      Left = 96
      Top = 106
      Width = 56
      Height = 18
      Caption = #54200#49457' '#51221#48372
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTitle: TLabel
      Left = 583
      Top = 7
      Width = 169
      Height = 19
      Caption = #54200#49457#48324' '#50689#49345' '#44288#47532
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #46027#50880#52404
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubLine: TLabel
      Left = 758
      Top = 8
      Width = 36
      Height = 13
      Caption = '(0'#54840#49440')'
    end
    object pnCamStationInfo: TPanel
      Left = 358
      Top = 82
      Width = 888
      Height = 509
      Caption = 'edit'
      ParentColor = True
      ShowCaption = False
      TabOrder = 0
      object lbTrainCamInfo: TLabel
        Left = 17
        Top = 21
        Width = 108
        Height = 13
        Caption = #50676#52264' '#44061#49892' '#52852#47700#46972' '#51221#48372
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object grdTrainCams: TAdvStringGrid
        Left = 17
        Top = 62
        Width = 200
        Height = 411
        ColCount = 3
        DrawingStyle = gdsClassic
        FixedColor = clWhite
        RowCount = 3
        TabOrder = 0
        OnCanClickCell = grdTrainCamsCanClickCell
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
        ColWidths = (
          64
          40
          38)
      end
      object btnAddTab: TAdvGlowButton
        Left = 784
        Top = 10
        Width = 71
        Height = 24
        Caption = #53485#52628#44032
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
        OnClick = btnAddTabClick
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
      object btnDeleteTab: TAdvGlowButton
        Left = 789
        Top = 471
        Width = 71
        Height = 24
        Caption = #53485#51228#44144
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
        OnClick = btnDeleteTabClick
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
      object btnAddCam: TAdvMetroButton
        Left = 236
        Top = 160
        Width = 30
        Height = 33
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000032000000640806000000C4E863
          5B000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA864000001DB49444154785EED9A89
          4EC330104403FFFFCF852975951627F1B1C7ACBB4FAA409590789919D7486CAB
          F0F5FBBAFD7DFB04EF85E3FBF175CFBB58086A22209CCC914838CE4442A57295
          481899DAA97504F569F6111B7987BA66BD89D0CA8C548B5266742374323363A7
          929911013432B3228042464284022911F7547AAE28ADB85C6534AAE5928ED646
          CC6572EC0D98A6A231F61AEA074056AB13F5D4ADAAB547A56659AD09541AE095
          88B88C67B544653CC65E63FA00C8B1B3C152ADC270C5D812197EA88CD51A9261
          DD48B74C8EDD90A603609944228834352642B5F61CD62C5AB50E1F7A6EC4916A
          2A5113F927136DEC35EE07406E848D1544EED358412437C2C4F3CA1259E4E5DE
          15F173E445A0901B612352B5AA952A4449E454024410B99400EC224D128059A4
          59022C736AB18A74A5011845BA25007E88E5736448A0C092C89404C8B10B329D
          06F0161191009E226212C04B4454027888884B006B1115096029A22601AC4454
          25808588BA04D0163191009A226612404BC45402588D5D1D3C39C9BF47CC9328
          4826E22601A4445C25C0321B9110714F03CC8A504800FC2223A7168D40E1A337
          429706E815A194003D22B412A055845A02B488D04B802B911012E04C248C04E8
          193B354722A1D2D8836B4A947F1CA8B06D3F99A62CBB91515C3F000000004945
          4E44AE426082}
        TabOrder = 3
        Version = '1.2.0.0'
        OnClick = btnAddCamClick
      end
      object btnRemoveCam: TAdvMetroButton
        Left = 236
        Top = 304
        Width = 30
        Height = 33
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000032000000640806000000C4E863
          5B000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA864000001B849444154785EED8F49
          6EC4300C04FDFF4F2770101B339E92AD854B3348017512D56C6EFFE4F375B124
          D7234A1E4247EC96838ED82D051D7058062AFFAA3C549A94874A93D250E196B2
          50D93B25A1A24FCA41257B94820AF62A03951B51022A36AA04546CD474A8D48C
          6950991553A022AB8643252C0C874A58180A15B032045A6C6D08B4D85A7768A9
          876ED0324FDDA0659EBA408BBC35879644680A2D88D2040A8ED6040A8ED6040A
          8E76090ACC721A0ACB740A0ACA76180A5170180A51B01BFAAC6437F459C92EE8
          A39AB7D007559BD0B0B24D6858598406D5FD80862A78428F953CA1C74A9ED063
          257FA0876A9ED063254FE8B1926FD040153FA0A10A36A161659BD0B0B24D6858
          D947E893A25DD04735BBA1CF4A0E41012A0E43210A0E43210A4E4141D94E4361
          992E43A1199A40C1D19A40C1D19A41E1919A420BA234879644E8022DF2D60D5A
          E6A92BB4D04B7768A98721D0626BC3A0E596864205AC0C874A58980215593505
          2AB26A2A5468D674A8D48C1250B15125A062A3CA40E54694820AF62A09157D52
          122AFAA42C54F64E69A8704B79A83459022A7EB50C54FED552D00187E5A02376
          CB4147EC96E4CF1C72F07BC4B67D03B9D92B628B0126C40000000049454E44AE
          426082}
        TabOrder = 4
        Version = '1.2.0.0'
        OnClick = btnRemoveCamClick
      end
      object Panel1: TPanel
        Left = 280
        Top = 54
        Width = 577
        Height = 403
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 5
        object Panel2: TPanel
          Left = 1
          Top = 25
          Width = 575
          Height = 377
          Align = alClient
          Caption = 'Panel2'
          ShowCaption = False
          TabOrder = 0
          object lbCamMergeName: TAdvLabel
            Left = 56
            Top = 19
            Width = 65
            Height = 17
            Text = 
              '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
              ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
              '0\fs16\u45796?\u51473?\u50689?\u49345? \u47749?\f1\par'#13#10'}'#13#10#0
            WordWrap = False
            Version = '1.0.0.4'
          end
          object lbRtspIp: TAdvLabel
            Left = 64
            Top = 50
            Width = 65
            Height = 17
            Text = 
              '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
              ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
              '0\fs16 RTSP \u51452?\u49548?\f1\par'#13#10'}'#13#10#0
            WordWrap = False
            Version = '1.0.0.4'
          end
          object lbCheckPartition: TAdvLabel
            Left = 48
            Top = 73
            Width = 81
            Height = 17
            Text = 
              '{\rtf1\ansi\ansicpg949\deff0{\fonttbl{\f0\fswiss\fcharset0 Arial' +
              ';}{\f1\fnil\fcharset129 Arial;}}'#13#10'\viewkind4\uc1\pard\lang1042\f' +
              '0\fs16\u54868?\u47732? \u48516?\u54624? \u48169?\u49885?\f1\par'#13 +
              #10'}'#13#10#0
            WordWrap = False
            Version = '1.0.0.4'
          end
          object edCamMerName: TAdvEdit
            Left = 152
            Top = 16
            Width = 321
            Height = 21
            EmptyTextStyle = []
            FlatLineColor = 11250603
            FocusColor = clWindow
            FocusFontColor = 3881787
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            Lookup.Font.Charset = DEFAULT_CHARSET
            Lookup.Font.Color = clWindowText
            Lookup.Font.Height = -11
            Lookup.Font.Name = 'Tahoma'
            Lookup.Font.Style = []
            Lookup.Separator = ';'
            Color = clWindow
            TabOrder = 0
            Text = ''
            Visible = True
            Version = '4.0.5.1'
          end
          object EdRtspIP: TAdvEdit
            Left = 152
            Top = 43
            Width = 321
            Height = 21
            EmptyTextStyle = []
            FlatLineColor = 11250603
            FocusColor = clWindow
            FocusFontColor = 3881787
            LabelFont.Charset = DEFAULT_CHARSET
            LabelFont.Color = clWindowText
            LabelFont.Height = -11
            LabelFont.Name = 'Tahoma'
            LabelFont.Style = []
            Lookup.Font.Charset = DEFAULT_CHARSET
            Lookup.Font.Color = clWindowText
            Lookup.Font.Height = -11
            Lookup.Font.Name = 'Tahoma'
            Lookup.Font.Style = []
            Lookup.Separator = ';'
            Color = clWindow
            Enabled = False
            TabOrder = 1
            Text = ''
            Visible = True
            Version = '4.0.5.1'
          end
          object rbtnCheckPartition: TAdvOfficeRadioGroup
            Left = 152
            Top = 70
            Width = 217
            Height = 35
            BorderColor = 12895944
            BorderStyle = bsNone
            CaptionFont.Charset = DEFAULT_CHARSET
            CaptionFont.Color = clWindowText
            CaptionFont.Height = -11
            CaptionFont.Name = 'Tahoma'
            CaptionFont.Style = []
            Version = '1.8.4.1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3881787
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentBackground = False
            ParentCtl3D = True
            ParentFont = False
            TabOrder = 2
            UIStyle = tsOffice2019White
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              '9'#48516#54624
              '4'#48516#54624)
            Ellipsis = False
            OnRadioButtonClick = rbtnCheckPartitionRadioButtonClick
          end
          object pnPartition: TAdvPanel
            Left = 16
            Top = 119
            Width = 540
            Height = 240
            ParentColor = True
            TabOrder = 3
            UseDockManager = True
            Version = '2.7.0.0'
            Background.Data = {
              FFD8FFE000104A46494600010101004800480000FFE1003A4578696600004D4D
              002A000000080003511000010000000101000000511100040000000100000B13
              511200040000000100000B1300000000FFDB0043000201010201010202020202
              020202030503030303030604040305070607070706070708090B0908080A0807
              070A0D0A0A0B0C0C0C0C07090E0F0D0C0E0B0C0C0CFFDB004301020202030303
              060303060C0807080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
              0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0CFFC000110800
              FF01C603012200021101031101FFC4001F000001050101010101010000000000
              0000000102030405060708090A0BFFC400B51000020103030204030505040400
              00017D01020300041105122131410613516107227114328191A1082342B1C115
              52D1F02433627282090A161718191A25262728292A3435363738393A43444546
              4748494A535455565758595A636465666768696A737475767778797A83848586
              8788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2
              C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5
              F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405
              060708090A0BFFC400B511000201020404030407050404000102770001020311
              04052131061241510761711322328108144291A1B1C109233352F0156272D10A
              162434E125F11718191A262728292A35363738393A434445464748494A535455
              565758595A636465666768696A737475767778797A82838485868788898A9293
              9495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8
              C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA00
              0C03010002110311003F00FC4FA28A2BD039C28A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
              28A0028A28A002BD6BE0E7ECBD75E39D3E2D53579A4D3F4F986E86345FDF4EBE
              BCF0AA7B1E49FD6B87F84FE188FC67F11B48D366FF00537138F307F79541661F
              880457DA11C6B0C6AAAAAAAA3000180057DE705F0ED1C73962714AF08BB25DDE
              FAF92D3D4F93E26CE6AE1546850D252576FB2F2F53CF22FD95BC171C6AADA7DC
              48C072C6EE4C9FC8E29DFF000CB3E0AFFA064DFF008172FF00F155E87457E9DF
              D8396FFD03C3FF00015FE47C3FF6B637FE7ECBFF0002679E7FC32CF82BFE8193
              7FE05CBFFC551FF0CB3E0AFF00A064DFF8172FFF00155E87451FD8396FFD03C3
              FF00015FE41FDAD8DFF9FB2FFC09FF0099E79FF0CB3E0AFF00A064DFF8172FFF
              001547FC32CF82BFE81937FE05CBFF00C557A1D147F60E5BFF0040F0FF00C057
              F907F6B637FE7ECBFF00027FE679E7FC32CF82BFE81937FE05CBFF00C551FF00
              0CB3E0AFFA064DFF008172FF00F155E87451FD8396FF00D03C3FF015FE41FDAD
              8DFF009FB2FF00C09FF99E79FF000CB3E0AFFA064DFF008172FF00F1547FC32C
              F82BFE81937FE05CBFFC557A1D147F60E5BFF40F0FFC057F907F6B637FE7ECBF
              F027FE679E7FC32CF82BFE81937FE05CBFFC551FF0CB3E0AFF00A064DFF8172F
              FF00155E87451FD8396FFD03C3FF00015FE41FDAD8DFF9FB2FFC09FF0099E69A
              9FEC9DE0FBDB468E0B6BAB390F4912E5D88FC18915E1FF0018BE05EA3F09AE56
              567FB6E973B6D8AE5576ED3FDD71D8FE87F4AFAEEB1FC7BE18B7F19783F50D36
              E54347730B0048FB8C39561EE0806BC6CEB8470389C3CBEAF0509A5A34ACAFD9
              A5A6BF7A3D2CB788B1542AAF6B2728BDD3D7E699F11D14515F871FA905145140
              0514514005145140051451400514514005145140051451400514514005145140
              0514514005145140051451400514514005145140051451400514514005145140
              0514514005145140051451401DBFECE3FF0025AB42FF00AE927FE8A7AFAF6BE4
              2FD9C7FE4B5685FF005D24FF00D14F5F5ED7EC5E1DFF00C8BEA7F8DFFE9313F3
              8E31FF007B87F857E6C28A28AFBE3E4828A28A0028A28A0028A2B2FC59E33D33
              C0FA535E6A97915A42BC0DC7E673E8A3A93EC2A2A548538B9D46925BB7A22A10
              94E4A30576FA23528AF0BF11FEDA50C374C9A4E8ED3C4A7024B9976161FEE807
              F9D66FFC36BDFF00FD006CFF00F021BFC2BE66A719E510972FB5BFA2935F91EE
              4786B3192BF27E2BFCCFA1A8AF9E7FE1B5EFFF00E80367FF00810DFE147FC36B
              DFFF00D006CFFF00021BFC2A3FD76CA3FE7E3FFC065FE457FAAF98FF0027E2BF
              CCFA1AA3BBFF008F593FDC3FCABE7DFF0086D7BFFF00A00D9FFE0437F85249FB
              6A5F491B2FF60D9FCC08FF008F86FF000A52E36CA1AFE23FFC065FE40B86331B
              FC1F8AFF0033C4A8A28AFC30FD5028A28A0028A28A0028A28A0028A28A0028A2
              8A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A2
              8A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A00EDFF
              00671FF92D5A17FD7493FF00453D7D7B5F217ECE3FF25AB42FFAE927FE8A7AFA
              F6BF62F0EFFE45F53FC6FF00F4989F9C718FFBDC3FC2BF361451457DF1F24145
              1450014515CCFC51F8A3A7FC2CF0F35E5E37993C995B7B753F3CEDFD00EE7B7E
              42B1C46229D0A6EB567CB15AB6CD28D19D59AA74D5DBD90DF8ABF1534FF857E1
              E6BBBA6125CC80ADB5B03F34CDFD147735F26F8EBC7DA97C45D75EFF00529DA5
              91B88D0711C2BFDD51D87F3A6F8E3C71A87C41F10CDA96A3379934870AA3EE44
              BD9547602B2511A575555666638000C926BF0FE24E26AB99D5E485D525B2EFE6
              FCFB2E87EA592E494F050E696B37BBEDE4BFAD46D15ED5F0ABF64AB8D6ADE3BE
              F11C92D8C2F864B48FFD730FF68FF0FD393F4AF5DD23E0578474585522D06C24
              DA31BA74F398FE2D9AE8CB781F30C541549DA9A7B735EFF72FD6C638CE28C1D0
              97246F37E5B7DFFE47C71457DA9FF0AA7C33FF0042FE8FFF008089FE147FC2A9
              F0CFFD0BFA3FFE0227F857A9FF0010E713FF003FA3F73387FD72A3FF003EDFDE
              8F8AE8AFB53FE154F867FE85FD1FFF000113FC29975F0AFC32B6D211E1FD1FEE
              9FF9744F4FA54BF0EB1295FDB47EE61FEB951FF9F6FEF47C5D451457E767D905
              1451400514514005145140051451400514514005145140051451400514514005
              1451400514514005145140051451400514514005145140051451400514514005
              1451400514514005145140051451401DBFECE3FF0025AB42FF00AE927FE8A7AF
              AF6BE42FD9C7FE4B5685FF005D24FF00D14F5F5ED7EC5E1DFF00C8BEA7F8DFFE
              9313F38E31FF007B87F857E6C28A2BCA7F682FDA063F00DB49A4E9322C9AD4AB
              8771CAD983DCFF00B5E83B753EFF006198E63430341E2310EC97DEDF65E67CE6
              0F0757155551A2AEDFE1E6CE93E267C74D0BE180315D4CD757F8CADA4186907A
              6EECA3EBCFB1AF3B3FB6D439E3C3B263B7FA60FF00E22BC16F2F26D42EA49E79
              249A6998B3BBB6E6727A926A3AFC8B1DC779955AAE5876A11E8AC9FDEDA7AFA5
              8FD130BC2B82842D59394BBDDAFB9267BF37EDB51ED38F0EC99C719BC1FF00C4
              578DF8EFC79A87C44F10CBA8EA32EF91F8441F7215ECAA3B01FAD628058F1CD4
              9F639BFE78C9FF007C9AF1330CFB30C7C153C4D4728AD6D6497E095FE67A983C
              A70984939D08D9BEB76FF36475D67C24F1E699F0EB5D6D4AF7476D5AEA3C7D9B
              3308D203DDB1B4E5BD0F6AE5FEC737FCF193FEF9347D8E6FF9E327FDF26BCDC2
              D7A987AAAB52F8A3AABA4FF07747656A50AB074E7B3DF5B7E47BD7FC36D45FF4
              2EC9FF0081A3FF0088A3FE1B6A2FFA1764FF00C0D1FF00C45782FD8E6FF9E327
              FDF268FB1CDFF3C64FFBE4D7D17FAE59CFFCFDFF00C963FE478DFEADE5BFC9FF
              00933FF33DEBFE1B6A2FFA1764FF00C0D1FF00C451FF000DB517FD0BB27FE068
              FF00E22BC17EC737FCF193FEF9347D8E6FF9E327FDF268FF005CB39FF9FBFF00
              92C7FC83FD5BCB7F93FF00267FE67BD7FC36D45FF42EC9FF0081A3FF0088A6CB
              FB6B432C4CBFF08EC8370233F6C1FF00C45783FD8E6FF9E327FDF268FB1CDFF3
              C64FFBE4D1FEB9673FF3F7FF00258FF90FFD5BCB7F93F17FE647451457CA9EF0
              5145140051451400514514005145140051451400514514005145140051451400
              5145140051451400514514005145140051451400514514005145140051451400
              51451400514514005145140051451401DBFECE3FF25AB42FFAE927FE8A7AFAF6
              BE42FD9C7FE4B5685FF5D24FFD14F5EC7FB41FED0B1F81E19347D1E459358906
              D9651CAD983FFB3FB76EB5FA9F06E6543039455C4621D929BF56F963A2F3FEB6
              3E0F8930557159853A3455DB8AF96AF5649FB40FED091F80E09349D2645975A9
              171248395B307D7FDBF41DBA9F4AF996EAEA4BDB99269A47965958B3BB1CB313
              D49349717125DCEF2CAED2492316776396627A926995F0F9E6795F33AFED2AE9
              15F0C7A25FE7DDFE87D465795D2C0D2E486ADEEFBFFC0EC82BD7BE077ECCD278
              DED23D5B5B696D74C9398615F964B91EB9FE15FD4FB75A9FF676FD9E5BC4EF0E
              BBAE43B74D53BEDAD9C73747B337FB1FCFE9D7E8E4458D155542AA8C00070057
              D6F09F082AC96331F1F77ECC5F5F37E5D975F4DFE7F883889D36F0D847EF757D
              BC979F77D3D76C6F0E7C3CD0FC2502C7A7E97656DB7A3088173F563CFEB5B3B1
              7FBA3F2AF33F8B7FB4C69BF0E6FA4D3ECE1FED4D4A3E2450FB6280FA33773EC3
              A7B579D37ED9FAF176C697A505EC30F91FF8F57D862389F28C0CFEAFCC935D22
              B45E5A687CED1C8F31C547DB5B7EADEAFEFD4FA4760F41F951B07A0FCABE6EFF
              0086CED7BFE819A57E4FFF00C551FF000D9DAF7FD0334AFC9FFF008AAE7FF5E7
              29FE67FF0080B35FF55B30FE55F7A3E91D83D07E546C1E83F2AF9BBFE1B3B5EF
              FA06695F93FF00F1547FC3676BDFF40CD2BF27FF00E2A8FF005E729FE67FF80B
              0FF55B30FE55F7A3E91D83D07E546C1E83F2AF9BBFE1B3B5EFFA06695F93FF00
              F1547FC3676BDFF40CD2BF27FF00E2A8FF005E729FE67FF80B0FF55B30FE55F7
              A3E91D83D07E551DDA0FB2C9C0FB87B7B57CE5FF000D9DAF7FD0334AFC9FFF00
              8AA6C9FB65EBD246CA74CD2BE604747FFE2A94B8E329B7C4FF00F01635C2D985
              FE15F7A3C7E8A28AFC40FD4028A28A0028A28A0028A28A0028A28A0028A28A00
              28A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A00
              28A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A00BDE1DF11
              5E7853588AFEC2636F7700611C8064A6E52A48F7C1354E699AE2569246692490
              96666392C4F524D368AAF692E5E4BE9BDBA5DFFC32279573735B50AF63FD9DFF
              006786F153C3AE6B90B2E98A775BDBB0C1BB3FDE6FF63FF42FA754FD9E3F6796
              F15C90EB9ADC2CBA5A9DD6F6EC306ECFA9FF0063F9FD3AFD211A2C48AAAAAAAA
              3000180057E8DC23C25ED6D8EC6AF7778C5F5F37E5D975F4DFE37887883D9DF0
              B857AF57DBC979F7EDEBB11A2C48AAAAAAAA300018005795FED07F1AAEBC2D6F
              268FA0C3712EA72AE26B84898ADAA91D14E3973FA7D6BD5A8AFD2B31C2D6C450
              746854F66DF54AEEDE5AAB3F33E27075E9D1AAAA55873A5D2F657F3D1FDC7C31
              2687A8CD233359DEB331CB31898927D4F149FF0008FDFF00FCF8DE7FDF96FF00
              0AFBA28AF81FF88710FF00A087FF0080FF00F6C7D6FF00AE92FF009F4BFF0002
              FF00807C2FFF0008FDFF00FCF8DE7FDF96FF000A3FE11FBFFF009F1BCFFBF2DF
              E15F745147FC43787FCFF7FF0080FF00F6C3FF005D25FF003EBFF26FF807C2FF
              00F08FDFFF00CF8DE7FDF96FF0A3FE11FBFF00F9F1BCFF00BF2DFE15F745147F
              C43787FCFF007FF80FFF006C1FEBA4BFE7D7FE4DFF0000F85FFE11FBFF00F9F1
              BCFF00BF2DFE147FC23F7FFF003E379FF7E5BFC2BEE8A28FF886F0FF009FEFFF
              0001FF00ED83FD7497FCFAFF00C9BFE01F0BFF00C23F7FFF003E379FF7E5BFC2
              8FEC0BF1FF002E379FF7E5BFC2BEE8A8EECE2D64FF0070FF002A4FC388257F6E
              FF00F01FFED83FD7497FCFAFFC9BFE01F07D14515F961F781451450014514500
              1451450014514500145145001451450014514500145145001451450014514500
              1451450014514500145145001451450014514500145145001451450014514500
              145145001451450015EC3FB3C7ECF2DE2D922D735B85974B43BADEDD860DD9F5
              3FEC7F3FA75E2BE07E8369E27F8ABA3D8DF42B716B34AC648D8F0FB519803ED9
              02BEC68E3586355555555185503000F415F7DC15C3B4B18DE3311AC60ECA3DDD
              93BBF257DBAF5D37F91E26CE2A6192C351D1C95DBECB6D3CFF002FC88E358635
              555555518000C0029D4515FB11F9C85145140051451400514514005145140051
              45140054777FF1EB27FB87F954951DDFFC7A4BFEE1FE5532D98E3B9F07D14515
              FCC27EE614514500145145001451450014514500145145001451450014514500
              1451450014514500145145001451450014514500145145001451450014514500
              14514500145145001451450014514500145145006CFC3CF151F04F8DB4DD536E
              E5B39C3B81DD4F0C3FEF926BED4D33528358D3E1BAB59166B7B841246EA78653
              C835F095775F0AFE3F6B5F0BA3FB2C5B2FB4D2D936D36709EA50F55FA74F6AFB
              4E11E25865D2951C45FD9CB5BAE8FBDBB3EBE87CCF1164B3C6A5568FC71D2DDD
              1F5D515E271FEDA9A6141BB45BE0DDF122114EFF0086D3D2BFE80FA87FDF69FE
              35FA4FFADB947FCFE5F73FF23E2FFD5ECC3FE7DBFBD7F99ED54578AFFC369E95
              FF00407D43FEFB4FF1A3FE1B4F4AFF00A03EA1FF007DA7F8D3FF005B728FF9FC
              BEE7FE41FEAFE61FF3E9FDEBFCCF6AA2BC57FE1B4F4AFF00A03EA1FF007DA7F8
              D1FF000DA7A57FD01F50FF00BED3FC68FF005B728FF9FCBEE7FE41FEAFE61FF3
              E9FDEBFCCF6AA2BC57FE1B4F4AFF00A03EA1FF007DA7F8D1FF000DA7A57FD01F
              50FF00BED3FC68FF005B728FF9FCBEE7FE41FEAFE61FF3E9FDEBFCCF6AA2BC57
              FE1B4F4AFF00A03EA1FF007DA7F8D1FF000DA7A57FD01F50FF00BED3FC68FF00
              5B728FF9FCBEE7FE41FEAFE61FF3E9FDEBFCCF6AA2BC57FE1B4F4AFF00A03EA1
              FF007DA7F8D1FF000DA7A57FD01F50FF00BED3FC68FF005B728FF9FCBEE7FE41
              FEAFE61FF3E9FDEBFCCF6AAE6FE2CF8EADFE1EF816FB509997CCF2CC76E87ACB
              230C281FCCFB035E63A97EDA9662D1BEC7A2DC34F8F97CE940407DF1CD78F7C4
              4F89FAB7C4ED545D6A730658F2228231B62841F41FD4F26BC6CEB8DB074E84A3
              83973CDAB2D1D979BBF6EC7A396F0BE267554B12B962B7EEFCB439EA28A2BF1A
              3F490A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28
              A2800A28A2800A28A2800A28A2800A28A2800A28A2800A28A2803FFFD9}
            BackgroundPosition = bpStretched
            BorderColor = clGrayText
            BorderWidth = 1
            Caption.Color = clWhite
            Caption.ColorTo = clNone
            Caption.Font.Charset = DEFAULT_CHARSET
            Caption.Font.Color = clNone
            Caption.Font.Height = -11
            Caption.Font.Name = 'Tahoma'
            Caption.Font.Style = []
            Caption.GradientDirection = gdVertical
            Caption.Indent = 0
            Caption.ShadeLight = 255
            CollapsColor = clNone
            CollapsDelay = 0
            DoubleBuffered = True
            HoverColor = clHotLight
            Images = VirtualImageList1
            ShadowColor = clBlack
            ShadowOffset = 0
            StatusBar.BorderColor = clNone
            StatusBar.BorderStyle = bsSingle
            StatusBar.Font.Charset = DEFAULT_CHARSET
            StatusBar.Font.Color = 4473924
            StatusBar.Font.Height = -11
            StatusBar.Font.Name = 'Tahoma'
            StatusBar.Font.Style = []
            StatusBar.Color = clWhite
            StatusBar.GradientDirection = gdVertical
            Text = ''
            FullHeight = 240
          end
        end
        object tabMerge: TAdvTabSet
          Left = 1
          Top = 1
          Width = 575
          Height = 24
          Version = '1.7.5.0'
          Align = alTop
          ActiveFont.Charset = DEFAULT_CHARSET
          ActiveFont.Color = clWindowText
          ActiveFont.Height = -11
          ActiveFont.Name = 'Tahoma'
          ActiveFont.Style = []
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          SoftTop = True
          AdvTabs = <
            item
              Caption = 'TabSheet1'
              ShowClose = False
              TabColor = clBtnFace
            end
            item
              Caption = 'TabSheet2'
              ShowClose = False
              TabColor = clBtnFace
            end>
          TabBorderColor = clNone
          GradientDirection = gdVertical
          TabMargin.LeftMargin = 10
          TabMargin.TopMargin = 2
          TabMargin.RightMargin = 10
          TabOverlap = 0
          Images = VirtualImageList1
          ShowScroller = ssAuto
          TabHeight = 30
          TabIndex = 1
          OnChange = tabMergeChange
        end
      end
    end
    object btnSearch: TAdvGlowButton
      Left = 800
      Top = 40
      Width = 50
      Height = 24
      Caption = #44160#49353
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
      Left = 505
      Top = 43
      Width = 97
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = '== '#51204#52404' =='
      Items.Strings = (
        '== '#51204#52404' =='
        #50669#49324#47749
        #50669#48264#54840)
    end
    object edSearchText: TEdit
      Left = 608
      Top = 43
      Width = 186
      Height = 21
      TabOrder = 3
    end
    object grdTrains: TAdvStringGrid
      Left = 96
      Top = 144
      Width = 200
      Height = 400
      DrawingStyle = gdsClassic
      FixedColor = clSkyBlue
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect, goFixedRowDefAlign]
      TabOrder = 4
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
  object pnBottom: TPanel
    Left = 0
    Top = 608
    Width = 1274
    Height = 70
    Align = alBottom
    Caption = 'pnBottom'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 40
    ExplicitTop = 583
    object btnCancel: TAdvGlowButton
      Left = 664
      Top = 23
      Width = 40
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
      TabOrder = 0
      OnClick = btnCancelClick
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
    object btnDlgClose: TAdvGlowButton
      Left = 55
      Top = 31
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
      TabOrder = 1
      OnClick = btnDlgCloseClick
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
    object btnSave: TAdvGlowButton
      Left = 735
      Top = 23
      Width = 40
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
      TabOrder = 2
      OnClick = btnSaveClick
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
  end
  object ImageCollection1: TImageCollection
    Images = <
      item
        Name = 'preview'
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
        Name = 'delete'
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
      end
      item
        Name = 'icon-add'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000032000000640806000000C4E863
              5B000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              00097048597300000EC300000EC301C76FA864000001B849444154785EED8F49
              6EC4300C04FDFF4F2770101B339E92AD854B3348017512D56C6EFFE4F375B124
              D7234A1E4247EC96838ED82D051D7058062AFFAA3C549A94874A93D250E196B2
              50D93B25A1A24FCA41257B94820AF62A03951B51022A36AA04546CD474A8D48C
              6950991553A022AB8643252C0C874A58180A15B032045A6C6D08B4D85A7768A9
              876ED0324FDDA0659EBA408BBC35879644680A2D88D2040A8ED6040A8ED6040A
              8E76090ACC721A0ACB740A0ACA76180A5170180A51B01BFAAC6437F459C92EE8
              A39AB7D007559BD0B0B24D6858598406D5FD80862A78428F953CA1C74A9ED063
              257FA0876A9ED063254FE8B1926FD040153FA0A10A36A161659BD0B0B24D6858
              D947E893A25DD04735BBA1CF4A0E41012A0E43210A0E43210A4E4141D94E4361
              992E43A1199A40C1D19A40C1D19A41E1919A420BA234879644E8022DF2D60D5A
              E6A92BB4D04B7768A98721D0626BC3A0E596864205AC0C874A58980215593505
              2AB26A2A5468D674A8D48C1250B15125A062A3CA40E54694820AF62A09157D52
              122AFAA42C54F64E69A8704B79A83459022A7EB50C54FED552D00187E5A02376
              CB4147EC96E4CF1C72F07BC4B67D03B9D92B628B0126C40000000049454E44AE
              426082}
          end>
      end
      item
        Name = 'icon-remove'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000032000000640806000000C4E863
              5B000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
              00097048597300000EC300000EC301C76FA864000001DB49444154785EED9A89
              4EC330104403FFFFCF852975951627F1B1C7ACBB4FAA409590789919D7486CAB
              F0F5FBBAFD7DFB04EF85E3FBF175CFBB58086A22209CCC914838CE4442A57295
              481899DAA97504F569F6111B7987BA66BD89D0CA8C548B5266742374323363A7
              929911013432B3228042464284022911F7547AAE28ADB85C6534AAE5928ED646
              CC6572EC0D98A6A231F61AEA074056AB13F5D4ADAAB547A56659AD09541AE095
              88B88C67B544653CC65E63FA00C8B1B3C152ADC270C5D812197EA88CD51A9261
              DD48B74C8EDD90A603609944228834352642B5F61CD62C5AB50E1F7A6EC4916A
              2A5113F927136DEC35EE07406E848D1544EED358412437C2C4F3CA1259E4E5DE
              15F173E445A0901B612352B5AA952A4449E454024410B99400EC224D128059A4
              59022C736AB18A74A5011845BA25007E88E5736448A0C092C89404C8B10B329D
              06F0161191009E226212C04B4454027888884B006B1115096029A22601AC4454
              25808588BA04D0163191009A226612404BC45402588D5D1D3C39C9BF47CC9328
              4826E22601A4445C25C0321B9110714F03CC8A504800FC2223A7168D40E1A337
              429706E815A194003D22B412A055845A02B488D04B802B911012E04C248C04E8
              193B354722A1D2D8836B4A947F1CA8B06D3F99A62CBB91515C3F000000004945
              4E44AE426082}
          end>
      end
      item
        Name = 'logo'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000001C6000000FF0802000000E402E1
              AF000000097048597300000B1300000B1301009A9C180000065469545874584D
              4C3A636F6D2E61646F62652E786D7000000000003C3F787061636B6574206265
              67696E3D22EFBBBF222069643D2257354D304D7043656869487A7265537A4E54
              637A6B633964223F3E203C783A786D706D65746120786D6C6E733A783D226164
              6F62653A6E733A6D6574612F2220783A786D70746B3D2241646F626520584D50
              20436F726520352E362D633134382037392E3136343033362C20323031392F30
              382F31332D30313A30363A35372020202020202020223E203C7264663A524446
              20786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F3139
              39392F30322F32322D7264662D73796E7461782D6E7323223E203C7264663A44
              65736372697074696F6E207264663A61626F75743D222220786D6C6E733A786D
              703D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F22
              20786D6C6E733A786D704D4D3D22687474703A2F2F6E732E61646F62652E636F
              6D2F7861702F312E302F6D6D2F2220786D6C6E733A73744576743D2268747470
              3A2F2F6E732E61646F62652E636F6D2F7861702F312E302F73547970652F5265
              736F757263654576656E74232220786D6C6E733A70686F746F73686F703D2268
              7474703A2F2F6E732E61646F62652E636F6D2F70686F746F73686F702F312E30
              2F2220786D6C6E733A64633D22687474703A2F2F7075726C2E6F72672F64632F
              656C656D656E74732F312E312F2220786D703A43726561746F72546F6F6C3D22
              41646F62652050686F746F73686F702032312E31202857696E646F7773292220
              786D703A437265617465446174653D22323032342D31312D30315431313A3132
              3A30322B30393A30302220786D703A4D65746164617461446174653D22323032
              342D31312D30315431313A31323A30322B30393A30302220786D703A4D6F6469
              6679446174653D22323032342D31312D30315431313A31323A30322B30393A30
              302220786D704D4D3A496E7374616E636549443D22786D702E6969643A613763
              30623931642D353235612D636634612D383739632D6331313733393066636333
              362220786D704D4D3A446F63756D656E7449443D2261646F62653A646F636964
              3A70686F746F73686F703A65396536636434612D633231332D356534622D6263
              30382D6461376336626536343336392220786D704D4D3A4F726967696E616C44
              6F63756D656E7449443D22786D702E6469643A39653234323366302D37343536
              2D303034332D613630322D643436346662366263306330222070686F746F7368
              6F703A436F6C6F724D6F64653D2233222064633A666F726D61743D22696D6167
              652F706E67223E203C786D704D4D3A486973746F72793E203C7264663A536571
              3E203C7264663A6C692073744576743A616374696F6E3D226372656174656422
              2073744576743A696E7374616E636549443D22786D702E6969643A3965323432
              3366302D373435362D303034332D613630322D64343634666236626330633022
              2073744576743A7768656E3D22323032342D31312D30315431313A31323A3032
              2B30393A3030222073744576743A736F6674776172654167656E743D2241646F
              62652050686F746F73686F702032312E31202857696E646F777329222F3E203C
              7264663A6C692073744576743A616374696F6E3D227361766564222073744576
              743A696E7374616E636549443D22786D702E6969643A61376330623931642D35
              3235612D636634612D383739632D633131373339306663633336222073744576
              743A7768656E3D22323032342D31312D30315431313A31323A30322B30393A30
              30222073744576743A736F6674776172654167656E743D2241646F6265205068
              6F746F73686F702032312E31202857696E646F777329222073744576743A6368
              616E6765643D222F222F3E203C2F7264663A5365713E203C2F786D704D4D3A48
              6973746F72793E203C70686F746F73686F703A446F63756D656E74416E636573
              746F72733E203C7264663A4261673E203C7264663A6C693E786D702E6469643A
              3934333142454141443231334535313142433742433330414633423630443033
              3C2F7264663A6C693E203C2F7264663A4261673E203C2F70686F746F73686F70
              3A446F63756D656E74416E636573746F72733E203C2F7264663A446573637269
              7074696F6E3E203C2F7264663A5244463E203C2F783A786D706D6574613E203C
              3F787061636B657420656E643D2272223F3EFA71B8EF00000D3549444154789C
              EDDDE9931C751DC7F1DFAFBB677A76AE1CBB9B906C38CBEC91041515A1F48955
              6A959C021665E99FE563FF0008C4A02008C513B454401485EC95A34248369BDD
              EC3199B3A7A70F1F100AC190CCCE7C777E3DD3EFD7E34CF707AAF24ECFF4F68E
              DE3739A50000122CD30300607490540010435201400C49050031241500C49054
              0010435201400C49050031241500C490540010435201400C49050031241500C4
              90540010435201400C49050031241500C490540010435201400C490500312415
              00C490540010435201400C49050031241500C490540010435201400C49050031
              241500C490540010435201400C49050031241500C490540010435201400C4905
              0031241500C490540010435201400C49050031241500C490540010435201400C
              49050031241500C490540010435201400C49050031241500C490540010435201
              400C49050031241500C490540010435201400C49050031241500C49054001043
              5201400C49050031241500C490540010435201400C49050031241500C438A607
              2029B49DB5C7C6B3E3479DF211CB2D69CD3FB77710751A416DD5DF3A1FD456E3
              C0333D0789A0F74D4E99DE00E3B4539E1A3BF24866CF3D965BD2B66B7ACFD088
              C34ED46984F5D5D6CA07FEE6591547A617C130929A7656B690BFFFC7B9430F69
              3B6B7ACB308B237FF36CE3C2DB417DD5F41498648F15CAA637C018A73C553EFE
              4B77724E5BB6E92D434E6B3B3FE14ECE45ED1B6163DDF41A184352D3CB291D2E
              3FF82BA778D0F490D1A11D373B7E34F42A617DCDF41698415253CA72CBE5077F
              ED14264D0F1935DA7232FBEE0F6E5C8EBC8AE92D3080BBBAA9A4EDC2033FE6FA
              749758997C71FA713E9B4E27929A4699F254EED0774DAF18654E692A37F5B0D2
              DAF4100C1A494D1D6D65C6EEFE017FDB775BEEF0F7AC6CD1F40A0C1A494D1D3B
              BF3FB3F75ED32B469F3DB63F3B316B7A05068DA4A64E767CC6CA164CAF187DDA
              72DC8939D32B30682435759C3D772BCD4FA10E82E5964C4FC0A091D4D4E1EFF9
              C070D33F85486AEA682E5107867B80E9435201400C49050031241500C4905400
              10435201400C49050031241500C490540010435201400C4905760F4F4FA50E49
              05768BB633A62760D01CD303805D11B5AB51BB167ADB51BBAA94D2B63BE04B46
              AD9D90AF9F4A1F928A51D3A95C6AAF9F09AA57426F3B6AD74CCF41BA90548C0E
              7FEB82B7F25EA7F269E45352984152310AC2D656F3D29FDB6B1FC781677A0B52
              8DA462C8C5A1B7F651E3C2DB111F5C2201482A86581CB41A17DE6E5D79D7F410
              E026928A61157ADBF5A557FDCD65D343802F90540CA5A07EADB6702AA85D353D
              04F812928AE1D3A95CAA2D9E0A9B9BA687005F455231643A954BD5F993DC8C42
              32F1402A8649505DA92D9DA6A7482C928AA111D4AE56175E0E1BD74D0F01BE16
              6FFC311C82DA6A75FE243D45C291540C81A0BE5A3DF342D8DC103BA2B6B49D55
              7A177F938A563A8E239EE64A1B928AA40BEA6BD53327FBEDA9B6ECFC7866EF7D
              4E7EC2CE8F5BEE1EEDE494FEEC83AF5862E6FF9D50DB6173B3F2AFDFEEC6C191
              582415891634D66BF327C3C67ACF47B0DCB23B319B9D98C9ECBB5FDBAEE0B63B
              8BA3819E0E094052915C61E37A6DFEA5A07EADB797DB63FBDC032772871FB6F3
              E3B2C3BA14C7A191F3C220928A840A5B5BD5F9933D3F1FE51E3891BFEF474EE9
              90EC2AE0F6482A92286C6EF4DC532BB7A7F0C04FDD8327B4C5F79460D0482A12
              276C6E54CFBC10D4567B786D66EFBDC5E9279DD261F1554037482A92E5F3F7FB
              BDF4D49D3C569C79CA72CBE2AB802E91542448E4DDA82DBC1C54577A78AD7BE0
              7869EE39EDE4C45701DDE381542445E4DDA8CEBFD8A95CEAE1B5EEE4317A8A24
              E02A1589107ADBB5F9977AEB69767CA638F76C227BCA254BEA9054EC96380A94
              8A95BAC3439F5AEBB0B9555B38D5A95EEEE12C4EF160F1E86356261F47414F33
              778BD6B68A3AA65760D0482A44C571E86D7BAB1F762A1723BFDECD2BB4D251A7
              D9E51FFE7F61BB5A3DF3621C87BBF45C69CFB4D249AB3C0680A4424CD8DAF2AE
              BCDFBAFA411CB40676D2B8D30A3A833B1D707B241502E2D06F5FFB4FF3D23B61
              6BDBF416C024928A7E855EA571FE4FEDB58F4D0F01CC23A9E84B50BD525BFE43
              6F3F490A8C1E928ADEF99B67EB4B7F083DDEEC03379154F4C8DF58AC2D9E8EFC
              86E92140829054F4C2DF58AE2E9C8AB9D50E7C194F7760C7FCCDB3B5457A0ADC
              0249C5CEF89B676B0B2FF37E1FB825DEF86307FCCDE5DAC2297A0A7C1D928A6E
              F95B17E4EF47694B5B8EB61C6567B51EADF74C5AC751187915D33B305024155D
              F137976B0BA723BF2672342B5BB4F313767EC2291D728A87ECDCFF7E05F488D0
              961334AE6FBFF71BD3433050241577E66F2CD71665DEEF3BE5A9ECFEA3D9F1E9
              CCDE7BFB3F5AC269276B7A02068DA4E20EFC8DC5DAC2EFA24EB3CFE3D885C9B1
              238FBA93C752F4452671647A01068DA4E276FC8D25899F3FD563F7FC70ECC823
              F6D87E9959405291547C2D7F63A9D6774FAD6CB138FD847BE0C4887D540ADC12
              49C5ADB5D7CFD4965EE9B3A7F6D8FED2B15F64F6DE27340A483A928A5B68AF7D
              545B7C250EDBFD1CC472CBA5E3CF67F6DC23B50A483E928AAF6AAF7D5C5B3C1D
              877E3F07B1B285D2ECD3F414694352F125DEB50FEBCBAF09F474EEB9ECC4ACD4
              2A605890547CC15BFD577DF9557A2A873B72A943527193B7F28FFAB9D7FBED69
              265F9A7BB6979EC6611C452A0E95524A6BA574D2BEF174E7F4CDFF1CA4094985
              52377BFAC738ECEB7BE7B5E316677F9E9D98EBFE257114848DF5CEF6C5A0B911
              B56F44EDAA8AE3CF1F4E1DFEA4F6F7FF13C388A442B5AEBCDB38F7469F5F3A6F
              65F2C599A7DD0327BA7F89BF75A1BDFA617B63310EBC7E4E0D2407494DBBD6E5
              BF35CEBFD96F4FB385E2EC33EEE4B12EFF7C1CFACD4FDEF156DEEFFF39572051
              486AAAB52EFFBDFF9E6AC72DCE3EEB4E76FB7E3F8E82FAD2EFBD6BFFEEE7A440
              3291D4F46A7DFAD7FAF937FBBC85A26DB734F75CF73D5551585F7A859E625491
              D4D4D1765629D5FCE49DC685B7FA3F5469EE99EE3F3F8DA34E7DF9556FF5C33E
              CF0B2416494D9D38F45B97FF26D153B734F7AC7BF0C16E5F1085F5E5D7BCABFF
              ECF3BC4092D96385D4FCF24A28A5940A1BD7BDAB1FF479106DBBA5B967DC83DF
              ECF60571583FF7476FE51F7D9E174838AE5253A753F9A4CF23683BBBB3EBD338
              AA2DBFE6ADBCDFE77981E4E38139EC8CB6B3A5B9E776D05315D7CFD253A40557
              A9D8016D6576787D1AD6CFBDD1BAF2DE6E8E021284A4A25BDACE16679FEEFEF3
              D3B8D36A5C78ABC5F529D284A4A22BDA768B334FE6EE7AA8FB97845E250ADBEE
              5DDFD2DADEBD61C9A575DC69B5AF2F98DE818122A9B8B31DDFDF574A29E5140E
              948F3FAF94DEA555C917B56F90D4B421A9B8839B3FCFBFC39E2AA59495CA8BD3
              FF11F3A5D3E9C31D7FDC8EB69CE2CC53BDF4144A29929A3E5CA5E26B693B539C
              7E2A77E83BA687004383A4E2D6B4E3168F3E9E3BFC5DD34380614252710BDACA
              14A79FE4FA14D8293E4BC55769CB29CED053A01724155FF2D9FDA8DCE1EF991E
              020C25928A2FD053A04F7C968A9BB495294E3F414F817E70950AA53EBB3E9D7E
              2237F5B0E921C07023A950CAB28BD34FD253A07FBCF14F3D6D97669EE6FD3E20
              82ABD474D37689FB51801CAE52D34B5B4EE11B3FE3FD3E2088A4A694B69CC2D1
              C7C68E3C6A7A083052486A2A69AB38FD446EEAFBA67700A386A4A68E76728507
              7E424F81DD405253A738F354EEAE6F9B5E018C26EEF8A74EA634657A0230B248
              6AEAC451C7F404606491540010435201400C4905764D6C7A00068EA4A64E1CF2
              59EAA0C4A1E9051834929A3A9157E1F26930F8D72B85486AEAF8958B71C4D5D3
              2084AD2DD31330682435753A5BE7A376D5F48AD11787EDF6DA47A65760D0486A
              EA84EDAABFB16C7AC5E80BEA6BFEF645D32B306824357DA2B075E5DD38F04CEF
              1871AD4FFF1A072DD32B306824358DC2E666F3D29F4DAF1865EDEB0BFEC692E9
              153080A4A653DCBAF26EFBFAA2E919A3296C6E34CEBD1E4781E92130C01E2B94
              4D6F800951D8D9BE98291FB6C7F6999E3252C2E66675FEA5B0B16E7A08CC20A9
              E91587BEBF79DE720B4EF190E92D23A253F9A4B6783AA8AD981E0263486AAAC5
              A1DFD93C177ADB4E7EDCCAE495D6A6170DABC86F342FFDA571EE0D7E1635E5F4
              BE497E7B269495C9670F1C7727669DF2DDDA7694B69422AFB717AB3856511834
              D6FDCDE5F6FA7CD8DC303D09E691547C4E5B56B690D973AF9D1FD74E4E6B6E5D
              DE4E1C4771D889BC1B9DCAC5B07D43F1401A9452241500047125020062482A00
              8821A9002086A4028018920A0062482A008821A9002086A4028018920A006248
              2A008821A9002086A4028018920A0062482A008821A9002086A4028018920A00
              62482A008821A9002086A4028018920A0062482A008821A9002086A402801892
              0A0062482A008821A9002086A4028018920A0062482A008821A9002086A40280
              18920A0062482A008821A9002086A4028018920A0062482A008821A9002086A4
              028018920A0062482A008821A9002086A4028018920A0062482A008821A90020
              86A4028018920A0062482A008821A9002086A4028018920A0062482A008821A9
              002086A4028018920A0062482A008821A9002086A4028018920A0062482A0088
              21A9002086A4028018920A0062FE0B4635D200793705330000000049454E44AE
              426082}
          end>
      end>
    InterpolationMode = icIMModeNearestNeighbor
    Left = 376
    Top = 624
  end
  object VirtualImageList1: TVirtualImageList
    AutoFill = True
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'preview'
        Disabled = False
        Name = 'preview'
      end
      item
        CollectionIndex = 1
        CollectionName = 'delete'
        Disabled = False
        Name = 'delete'
      end
      item
        CollectionIndex = 2
        CollectionName = 'icon-add'
        Disabled = False
        Name = 'icon-add'
      end
      item
        CollectionIndex = 3
        CollectionName = 'icon-remove'
        Disabled = False
        Name = 'icon-remove'
      end
      item
        CollectionIndex = 4
        CollectionName = 'logo'
        Disabled = False
        Name = 'logo'
      end>
    ImageCollection = ImageCollection1
    Width = 30
    Height = 60
    Left = 288
    Top = 624
  end
end
