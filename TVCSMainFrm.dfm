object frmTVCSMain: TfrmTVCSMain
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #50689#49345#54364#52636' '#53364#46972#51060#50616#53944
  ClientHeight = 880
  ClientWidth = 1696
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 325
    Top = 41
    Height = 631
    ExplicitLeft = 191
    ExplicitTop = 35
    ExplicitHeight = 817
  end
  object pnLeftTrain: TPanel
    Left = 0
    Top = 41
    Width = 325
    Height = 631
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lstTrainSched: TAdvStringGrid
      Left = 0
      Top = 0
      Width = 325
      Height = 631
      Align = alClient
      DrawingStyle = gdsClassic
      FixedColor = clWhite
      FixedCols = 0
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goFixedRowDefAlign]
      ParentFont = False
      TabOrder = 0
      OnSelectCell = lstTrainSchedSelectCell
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
      FixedFont.Height = -16
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
      Version = '9.1.3.0'
    end
  end
  object pnCamView: TPanel
    Left = 328
    Top = 41
    Width = 1368
    Height = 631
    Align = alClient
    BevelOuter = bvNone
    Color = clBackground
    ParentBackground = False
    TabOrder = 1
  end
  object pnTopmenu: TPanel
    Left = 0
    Top = 0
    Width = 1696
    Height = 41
    Align = alTop
    Color = 2251774
    ParentBackground = False
    ShowCaption = False
    TabOrder = 2
    object AdvMetroButton1: TAdvMetroButton
      Left = 1
      Top = 1
      Width = 33
      Height = 39
      Align = alLeft
      Appearance.PictureColor = clWhite
      Caption = ''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlightText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Picture.Data = {
        89504E470D0A1A0A0000000D49484452000000210000002008060000009CB811
        CA000000097048597300000B1200000B1201D2DD7EFC00000170494441545885
        ED97C175824010863FF372C7124C05D24128C154205EFEB3A524D7B9042B0825
        588276400958811EB28348782F3CB3510ECE697758D8EFEDFCFC0C93E3F1C8BD
        E3E9DE003012886700339B0205300DF91AC825D5378300B6C0BC736D0BA43E31
        B305B08EB8F7BBA4B20DD105B8C899590A7C4504007835B31749D5504D4C7F5F
        7255CC60B83077C02132C05ED216CEE558019F9D452B1F48AACD6C06E4C43995
        0A287D3271B30A756FDE0E49BB089B0D8AC9C331438C02C21D33E5DB9C92903F
        00D9AD74D176CCA4954F42AE7913CCAC009611F7DE48CAE15C8EA467519333B3
        2C3200C03254601C9A70883E376C72C1D93691F7FE70CDB926327A84D9BE23D4
        2F8F0C023CCCEA1CA380704DDCFF036666393D9F7249854F421FBA2034227F8C
        0A28BD87F593E80278AE680154F49BDAB5B126F4B04335914606009807271E0C
        514506B878AE9763CFCF8E7BEF03499599BD11BFE5BF80C8E8F9F969DF11FE11
        4AFE211E8EE9310A8813AB277BCB5665C5160000000049454E44AE426082}
      ParentFont = False
      PopupMenu = popupMain
      TabOrder = 0
      Version = '1.2.0.0'
    end
    object pnTitle: TPanel
      Left = 34
      Top = 1
      Width = 297
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      Caption = #50689#49345' '#54364#52636' '#53364#46972#51060#50616#53944
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object pnWindowMenu: TPanel
      Left = 1547
      Top = 1
      Width = 148
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      Caption = 'pnWindowMenu'
      ShowCaption = False
      TabOrder = 2
      object toolBtnMinimize: TAdvMetroToolButton
        Left = 16
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC00000059494441545885
          EDD6B111C0300C024094CBA04EC3506AEC4D49A5154C03953AFE8E462509CE3C
          D6F60002082080000200F0CED1DD0BC0BAD47B481E00284953BE2F954F3E92C7
          3E41CD43629DC019FB0401041040000104F003BAC31B338E79F4140000000049
          454E44AE426082}
        Version = '1.2.0.0'
        OnClick = toolBtnMinimizeClick
      end
      object toolBtnMax: TAdvMetroToolButton
        Left = 55
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC0000008A494441545885
          EDD7B10DC3300C44D1EF40BD57D106D1345C237B701A8EE0553281DCB8B00303
          762333C55D2736F70036D4D47B273305C0DD1BD01EEE0E338BB23D1AF0791800
          10AF84D243CAC9EC0B2C83FA2A305F0116336B23DADD3D80F77E96BE02010410
          40000104104000010438BB8AEB76BD8E48BD0398F9399D47E66F561009DD0130
          657FCF575BE4189167B506060000000049454E44AE426082}
        Version = '1.2.0.0'
        OnClick = toolBtnMaxClick
      end
      object ToolbtnClose: TAdvMetroToolButton
        Left = 94
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC00000137494441545885
          C5D6C191C2201480E1DF9D2DC04E4C07A6035BF0C4794BD96B38A5144B583BB1
          03BCA04B9400EFF1323293997830FF2749C05D08814F8EAF8FD681EFC789F7FE
          1718801B7076CEDD2C43DEFB3D30037BE0CF39F703CB1918802370022EF10B96
          F14BBCF631B67805A4BFF8608548E2875C2B059C81AB2562257E8DAD2520DEF3
          D10A51888FE9F3B5780BAC10ADF13780054212CF027A10D2F82A4083D0C48B00
          09421B07D8B5EC05A5403C57C59B011504DAB8085040A4431407E16EB8F24CA8
          E362C0164304A8DC02D5B2DD0C283C845DCB7613A0F21A8E3D882AA0B6C8F4EE
          1D4540EB0AD78358054897572D220BD0AEED1AC41BA06763D1201680DEB806F1
          0458C5A588740666AB780362CE01D2A9E98E5710D91978C4CCE205C4FFB54308
          CF639AA621FDBCC5F1DA10FD21D962DC01B63770CEAA56A9CD0000000049454E
          44AE426082}
        Version = '1.2.0.0'
        OnClick = ToolbtnCloseClick
      end
    end
    object pnSplit: TPanel
      Left = 331
      Top = 1
      Width = 158
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnSplit'
      ShowCaption = False
      TabOrder = 3
      object btnSplit16: TAdvMetroToolButton
        Left = 6
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC00000116494441545885
          ED57C19183301013991440297410D28CDEE9209490B79A39D301A5D001F99889
          BD36DC2793E5C17E3C58785760092FCDB22CF08C8B6BF52310B8DA094903803E
          997A909C24057B2FC93EAEA962923A00AF643A901C3609C4E24F93AB8DE3ADF6
          04FF60ADC16E929092B05BD0EF14F9566435DC35E04EC08AF081CF9EAF31C5F1
          BE93670B9B2AD89C5E34DE1F22EB828052D177924152C1946413D75531493D80
          3F038DAB7D810368E024E04EC0DD05EE6FE0B4E149C09D80BB0DAD0B3A548E63
          927354741624435C57C524B5003A03CD24D723BEE8075EA8D810404069270068
          E2B88575156C44D296B96BE07004C20F6A6635320D901C240179EBBCF670E34E
          D22D6C3658F163E26EC3C369E0E7F10666F8740E4F06B8A70000000049454E44
          AE426082}
        Version = '1.2.0.0'
      end
      object btnSplit9: TAdvMetroToolButton
        Left = 38
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC000000D7494441545885
          ED57C10D833010335507E92664145E5EA3CCE15746099BB0097D04A990E60442
          15C923F73905597716B12DA55B960525EB51747B0D049EE90749230097C17A92
          5ED2006030E61D6102C9D124B02E7F1BC3C3DA5F00FA8B985E12B624D22B70C6
          E07FD66E47710D3402C509A436F4F82A39AD90F4AB98797BE84A47719A0303A2
          8773154806490EB65DCF6066923E4B0031BDAC9001E2AF75B0C3EA0C6642BC6A
          001588B01168045A10B5202A2EC246A03A02E1869DBB1D3B17901C2501790BCD
          9B3E19C38F303F0F93E241549D066EAF0F6A6863BD7E9CFC6F0000000049454E
          44AE426082}
        Version = '1.2.0.0'
      end
      object btnSplit4: TAdvMetroToolButton
        Left = 77
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC000000A6494441545885
          ED974B0E80200C4447E381BC81B7E9568FE27A4EC58D70E342EA27051735B1B3
          2284691F8130A1CB39C353BD6BF72F000C7A82E40A60347893882CAD9E4B80BD
          D06C28A43502980CEB26923842E823B0ECE2AD8A1EEE772000022000DC01F453
          9C2ABCE9665CE343F7FB38BE0A236B1EB4A461E13B01C09E6A5AAD3EFF230880
          000880CF01D4844AAB8A1EC54B28220B49C0F8C9B82BFAE4D11F93484377800D
          139031FC49A54E7A0000000049454E44AE426082}
        Version = '1.2.0.0'
      end
      object btnSplit1: TAdvMetroToolButton
        Left = 116
        Top = 1
        Width = 33
        Height = 33
        Appearance.PictureColor = clWhite
        Caption = ''
        Picture.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F4000000097048597300000B1200000B1201D2DD7EFC0000006F494441545885
          EDD7B10DC030084451883298A7618D386B308D37234D226152635C1C25CD7F92
          69CC6646957394D677009C71A1AA9D885A526F8848F70BF637F0C6AFA4F837B7
          47C42768C9F15FA3FC060000000000000000000000002002C682E6D4E0F8372C
          FD9854CC7637B07C1E00BF1D337E1785650000000049454E44AE426082}
        Version = '1.2.0.0'
      end
    end
  end
  object pnTrainInfo: TPanel
    Left = 0
    Top = 672
    Width = 1696
    Height = 208
    Align = alBottom
    Caption = 'pnTrainInfo'
    ShowCaption = False
    TabOrder = 3
    object pgRoute: TPageControl
      Left = 1
      Top = 1
      Width = 1694
      Height = 206
      Align = alClient
      TabOrder = 0
    end
  end
  object ImageCollection1: TImageCollection
    Images = <
      item
        Name = 'icon-close'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC00000137494441545885
              C5D6C191C2201480E1DF9D2DC04E4C07A6035BF0C4794BD96B38A5144B583BB1
              03BCA04B9400EFF1323293997830FF2749C05D08814F8EAF8FD681EFC789F7FE
              1718801B7076CEDD2C43DEFB3D30037BE0CF39F703CB1918802370022EF10B96
              F14BBCF631B67805A4BFF8608548E2875C2B059C81AB2562257E8DAD2520DEF3
              D10A51888FE9F3B5780BAC10ADF13780054212CF027A10D2F82A4083D0C48B00
              09421B07D8B5EC05A5403C57C59B011504DAB8085040A4431407E16EB8F24CA8
              E362C0164304A8DC02D5B2DD0C283C845DCB7613A0F21A8E3D882AA0B6C8F4EE
              1D4540EB0AD78358054897572D220BD0AEED1AC41BA06763D1201680DEB806F1
              0458C5A588740666AB780362CE01D2A9E98E5710D91978C4CCE205C4FFB54308
              CF639AA621FDBCC5F1DA10FD21D962DC01B63770CEAA56A9CD0000000049454E
              44AE426082}
          end>
      end
      item
        Name = 'icon-close_gray'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000210000002008060000009CB811
              CA000000097048597300000B1200000B1201D2DD7EFC00000141494441545885
              C5D7C155C3300C80E1BFBC0EC0088C5026682F9A83B201A3940948E7D001D880
              51C204E19294A6891D4B565E758A73D1972891EC4DD775DC3B1EEE0D00D80E17
              22B2034EFDB251D5263A99889C805DBF7C53D59F11027804F6FDF55E44888488
              4803BCDCE403F2E5F81091E34A0080768250D52FE01C0D49005E87528C103DE4
              1809C9009AEB1B937244414A01B3880888059044D440AC802CC203F100161116
              881750842881D400003696019648F6CD7FA73503CC880CC40D00C7144D94C60D
              7021D6083362A11CAE166F42643ECC2A483122F31B1EA89C354588A53E503B6B
              1611A58DA8069245583BA1179244785BB107328BA89D0556C804510BF0404688
              2880157219602272003EA300D79178B8E761C79DFB3B4200907C23B3879FE130
              F21B09B881BCCFE41BEF2744E4096855B565A598CB61DED4AC117F3674016984
              ED62CD0000000049454E44AE426082}
          end>
      end
      item
        Name = 'icon'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC00000116494441545885
              ED57C19183301013991440297410D28CDEE9209490B79A39D301A5D001F99889
              BD36DC2793E5C17E3C58785760092FCDB22CF08C8B6BF52310B8DA094903803E
              997A909C24057B2FC93EAEA962923A00AF643A901C3609C4E24F93AB8DE3ADF6
              04FF60ADC16E929092B05BD0EF14F9566435DC35E04EC08AF081CF9EAF31C5F1
              BE93670B9B2AD89C5E34DE1F22EB828052D177924152C1946413D75531493D80
              3F038DAB7D810368E024E04EC0DD05EE6FE0B4E149C09D80BB0DAD0B3A548E63
              927354741624435C57C524B5003A03CD24D723BEE8075EA8D810404069270068
              E2B88575156C44D296B96BE07004C20F6A6635320D901C240179EBBCF670E34E
              D22D6C3658F163E26EC3C369E0E7F10666F8740E4F06B8A70000000049454E44
              AE426082}
          end>
      end
      item
        Name = 'icon-list'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000210000002008060000009CB811
              CA000000097048597300000B1200000B1201D2DD7EFC00000170494441545885
              ED97C175824010863FF372C7124C05D24128C154205EFEB3A524D7B9042B0825
              588276400958811EB28348782F3CB3510ECE697758D8EFEDFCFC0C93E3F1C8BD
              E3E9DE003012886700339B0205300DF91AC825D5378300B6C0BC736D0BA43E31
              B305B08EB8F7BBA4B20DD105B8C899590A7C4504007835B31749D5504D4C7F5F
              7255CC60B83077C02132C05ED216CEE558019F9D452B1F48AACD6C06E4C43995
              0A287D3271B30A756FDE0E49BB089B0D8AC9C331438C02C21D33E5DB9C92903F
              00D9AD74D176CCA4954F42AE7913CCAC009611F7DE48CAE15C8EA467519333B3
              2C3200C03254601C9A70883E376C72C1D93691F7FE70CDB926327A84D9BE23D4
              2F8F0C023CCCEA1CA380704DDCFF036666393D9F7249854F421FBA2034227F8C
              0A28BD87F593E80278AE680154F49BDAB5B126F4B04335914606009807271E0C
              514506B878AE9763CFCF8E7BEF03499599BD11BFE5BF80C8E8F9F969DF11FE11
              4AFE211E8EE9310A8813AB277BCB5665C5160000000049454E44AE426082}
          end>
      end
      item
        Name = 'icon-max'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC0000008A494441545885
              EDD7B10DC3300C44D1EF40BD57D106D1345C237B701A8EE0553281DCB8B00303
              762333C55D2736F70036D4D47B273305C0DD1BD01EEE0E338BB23D1AF0791800
              10AF84D243CAC9EC0B2C83FA2A305F0116336B23DADD3D80F77E96BE02010410
              40000104104000010438BB8AEB76BD8E48BD0398F9399D47E66F561009DD0130
              657FCF575BE4189167B506060000000049454E44AE426082}
          end>
      end
      item
        Name = 'icon-min'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC00000059494441545885
              EDD6B111C0300C024094CBA04EC3506AEC4D49A5154C03953AFE8E462509CE3C
              D6F60002082080000200F0CED1DD0BC0BAD47B481E00284953BE2F954F3E92C7
              3E41CD43629DC019FB0401041040000104F003BAC31B338E79F4140000000049
              454E44AE426082}
          end>
      end
      item
        Name = 'icon-layout4'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC000000A6494441545885
              ED974B0E80200C4447E381BC81B7E9568FE27A4EC58D70E342EA27051735B1B3
              2284691F8130A1CB39C353BD6BF72F000C7A82E40A60347893882CAD9E4B80BD
              D06C28A43502980CEB26923842E823B0ECE2AD8A1EEE772000022000DC01F453
              9C2ABCE9665CE343F7FB38BE0A236B1EB4A461E13B01C09E6A5AAD3EFF230880
              000880CF01D4844AAB8A1EC54B28220B49C0F8C9B82BFAE4D11F93484377800D
              139031FC49A54E7A0000000049454E44AE426082}
          end>
      end
      item
        Name = 'icon-layout9'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC000000D7494441545885
              ED57C10D833010335507E92664145E5EA3CCE15746099BB0097D04A990E60442
              15C923F73905597716B12DA55B960525EB51747B0D049EE90749230097C17A92
              5ED2006030E61D6102C9D124B02E7F1BC3C3DA5F00FA8B985E12B624D22B70C6
              E07FD66E47710D3402C509A436F4F82A39AD90F4AB98797BE84A47719A0303A2
              8773154806490EB65DCF6066923E4B0031BDAC9001E2AF75B0C3EA0C6642BC6A
              001588B01168045A10B5202A2EC246A03A02E1869DBB1D3B17901C2501790BCD
              9B3E19C38F303F0F93E241549D066EAF0F6A6863BD7E9CFC6F0000000049454E
              44AE426082}
          end>
      end
      item
        Name = 'icon-layout1'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
              F4000000097048597300000B1200000B1201D2DD7EFC0000006F494441545885
              EDD7B10DC030084451883298A7618D386B308D37234D226152635C1C25CD7F92
              69CC6646957394D677009C71A1AA9D885A526F8848F70BF637F0C6AFA4F837B7
              47C42768C9F15FA3FC060000000000000000000000002002C682E6D4E0F8372C
              FD9854CC7637B07C1E00BF1D337E1785650000000049454E44AE426082}
          end>
      end>
    Left = 1312
    Top = 104
  end
  object VirtualImageList1: TVirtualImageList
    DisabledGrayscale = False
    DisabledSuffix = '_Disabled'
    Images = <
      item
        CollectionIndex = 2
        CollectionName = 'icon'
        Disabled = False
        Name = 'icon'
      end
      item
        CollectionIndex = 7
        CollectionName = 'icon-layout9'
        Disabled = False
        Name = 'icon-layout9'
      end
      item
        CollectionIndex = 6
        CollectionName = 'icon-layout4'
        Disabled = False
        Name = 'icon-layout4'
      end
      item
        CollectionIndex = 8
        CollectionName = 'icon-layout1'
        Disabled = False
        Name = 'icon-layout1'
      end>
    ImageCollection = ImageCollection1
    Left = 1232
    Top = 104
  end
  object popupMain: TAdvPopupMenu
    Version = '2.7.1.12'
    UIStyle = tsOffice2019White
    Left = 531
    Top = 250
    object mnuStations: TMenuItem
      Action = actStations
    end
    object mnuTrain: TMenuItem
      Action = actTrain
    end
    object mnuLayout: TMenuItem
      Action = actLayouts
    end
    object mnuDevice: TMenuItem
      Action = actDevice
    end
    object mnuSystem: TMenuItem
      Action = actSystem
    end
    object mnuUsers: TMenuItem
      Action = actUsers
    end
    object mnuExit: TMenuItem
      Action = actExit
    end
  end
  object actMain: TActionList
    Left = 568
    Top = 312
    object actStations: TAction
      Caption = #50669#49324'  '#51221#48372' '#44288#47532
      OnExecute = actStationsExecute
    end
    object actTrain: TAction
      Caption = #50676#52264' '#51221#48372' '#44288#47532
      OnExecute = actTrainExecute
    end
    object actLayouts: TAction
      Caption = #45796#51473' '#50689#49345' '#44288#47532
      OnExecute = actLayoutsExecute
    end
    object actDevice: TAction
      Caption = #51109#52824' '#44288#47532
      OnExecute = actDeviceExecute
    end
    object actSystem: TAction
      Caption = #49884#49828#53596' '#49444#51221
      OnExecute = actSystemExecute
    end
    object actUsers: TAction
      Caption = #49324#50857#51088' '#44288#47532
      OnExecute = actUsersExecute
    end
    object actExit: TAction
      Caption = #51333#47308
    end
  end
end
