object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'COVID (MA)'
  ClientHeight = 1051
  ClientWidth = 1573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter3: TSplitter
    Left = 1010
    Top = 30
    Width = 4
    Height = 1002
    Align = alRight
    Color = clActiveBorder
    ParentColor = False
    ExplicitLeft = 999
    ExplicitHeight = 905
  end
  object MainToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 1573
    Height = 30
    Caption = 'MainToolBar'
    EdgeBorders = [ebTop, ebBottom]
    Images = ImageList
    Indent = 2
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 2
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 0
      Visible = False
    end
    object ToolButton2: TToolButton
      Left = 25
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 1
      Style = tbsSeparator
      Visible = False
    end
    object InitSimulButton: TToolButton
      Left = 33
      Top = 0
      Hint = 'Initiallization of Simulation'
      Caption = 'InitSimulButton'
      ImageIndex = 19
      OnClick = InitSimulButtonClick
    end
    object SimulStepButton: TToolButton
      Left = 56
      Top = 0
      Hint = 'Simulation Step (Press SPACE button)'
      Caption = 'SimulStepButton'
      ImageIndex = 15
      OnClick = SimulStepButtonClick
    end
    object FullSimlButton: TToolButton
      Left = 79
      Top = 0
      Hint = 'Full Simulation'
      Caption = 'FullSimlButton'
      ImageIndex = 30
      OnClick = FullSimlButtonClick
    end
    object RestartlButton: TToolButton
      Left = 102
      Top = 0
      Hint = 'Restart Full Simulation'
      Caption = 'RestartlButton'
      ImageIndex = 5
      OnClick = RestartlButtonClick
    end
    object ToolButton3: TToolButton
      Left = 125
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 27
      Style = tbsSeparator
    end
    object TimePanel: TPanel
      Left = 133
      Top = 0
      Width = 696
      Height = 22
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object MaxSimulTimeEdit: TLabeledEdit
        Left = 419
        Top = 2
        Width = 78
        Height = 21
        Ctl3D = True
        EditLabel.Width = 96
        EditLabel.Height = 13
        EditLabel.Caption = 'Max Simulation Time'
        LabelPosition = lpLeft
        ParentCtl3D = False
        TabOrder = 0
        Text = '0'
      end
      object MaxSimulTimeUpDown: TUpDown
        Left = 497
        Top = 2
        Width = 17
        Height = 21
        Max = 1000
        TabOrder = 1
        OnClick = MaxSimulTimeUpDownClick
        OnMouseUp = MaxSimulTimeUpDownMouseUp
      end
      object SimulTimeEdit: TLabeledEdit
        Left = 75
        Top = 1
        Width = 80
        Height = 21
        Ctl3D = True
        EditLabel.Width = 65
        EditLabel.Height = 13
        EditLabel.Caption = 'Simulate Time'
        LabelPosition = lpLeft
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 2
        Text = '0'
      end
      object DetDayEdit: TLabeledEdit
        Left = 240
        Top = 2
        Width = 47
        Height = 21
        Ctl3D = True
        EditLabel.Width = 68
        EditLabel.Height = 13
        EditLabel.Caption = 'Detection Day'
        LabelPosition = lpLeft
        ParentCtl3D = False
        TabOrder = 3
        Text = '0'
      end
      object DetDayUpDown: TUpDown
        Left = 287
        Top = 2
        Width = 17
        Height = 21
        TabOrder = 4
        OnClick = DetDayUpDownClick
        OnMouseUp = DetDayUpDownMouseUp
      end
      object ForeDayEdit: TLabeledEdit
        Left = 593
        Top = 2
        Width = 78
        Height = 21
        Ctl3D = True
        EditLabel.Width = 64
        EditLabel.Height = 13
        EditLabel.Caption = 'Forecast Day'
        LabelPosition = lpLeft
        ParentCtl3D = False
        TabOrder = 5
        Text = '0'
      end
      object ForeDayUpDown: TUpDown
        Left = 671
        Top = 2
        Width = 17
        Height = 21
        Min = 1
        Max = 1000
        TabOrder = 6
        OnClick = ForeDayUpDownClick
        OnMouseUp = ForeDayUpDownMouseUp
      end
    end
    object ToolButton4: TToolButton
      Left = 829
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 13
      Style = tbsSeparator
    end
    object OptimParamslButton: TToolButton
      Left = 837
      Top = 0
      Hint = 'Optimization of Model'
      Caption = 'OptimParamslButton'
      ImageIndex = 26
      OnClick = OptimParamslButtonClick
    end
    object CDCReportButton: TToolButton
      Left = 860
      Top = 0
      Hint = 'Weekly Deaths Forecast Evaluation'
      Caption = 'CDCReportButton'
      ImageIndex = 23
      OnClick = CDCReportButtonClick
    end
    object DailyForeButton: TToolButton
      Left = 883
      Top = 0
      Hint = 'Daily Forecast Evaluation'
      Caption = 'DailyForeButton'
      ImageIndex = 18
      OnClick = DailyForeButtonClick
    end
    object ToolButton5: TToolButton
      Left = 906
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 13
      Style = tbsSeparator
    end
    object AutoSizelButton: TToolButton
      Left = 914
      Top = 0
      Hint = 'Auto Size Form'
      Caption = 'AutoSizelButton'
      ImageIndex = 12
      OnClick = AutoSizelButtonClick
    end
  end
  object MainStatusBar: TStatusBar
    Left = 0
    Top = 1032
    Width = 1573
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object LeftPanel: TPanel
    Left = 0
    Top = 30
    Width = 1010
    Height = 1002
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object LeftBottomPanel: TPanel
      Left = 0
      Top = 672
      Width = 1010
      Height = 330
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = LeftBottomPanelResize
      object CmdLineLabel: TLabel
        Left = 8
        Top = 209
        Width = 142
        Height = 13
        Caption = 'Comand Line Parameters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DensLabel: TLabel
        Left = 129
        Top = 9
        Width = 142
        Height = 13
        Caption = 'Population Density Areas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EpiLabel: TLabel
        Left = 307
        Top = 9
        Width = 59
        Height = 13
        Caption = 'Epicenters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object PatLabel: TLabel
        Left = 473
        Top = 9
        Width = 47
        Height = 13
        Caption = 'Patients'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ContRadEdit: TLabeledEdit
        Left = 58
        Top = 38
        Width = 40
        Height = 21
        EditLabel.Width = 45
        EditLabel.Height = 13
        EditLabel.Caption = 'Cont Rad'
        LabelPosition = lpLeft
        TabOrder = 0
        Text = '0'
      end
      object ContRadUpDown: TUpDown
        Left = 98
        Top = 38
        Width = 16
        Height = 21
        Associate = ContRadEdit
        Max = 300
        TabOrder = 1
        OnMouseUp = ContRadUpDownMouseUp
      end
      object ContCenterEdit: TEdit
        Left = 16
        Top = 10
        Width = 98
        Height = 21
        TabOrder = 2
      end
      object AddContCircleButton: TButton
        Left = 35
        Top = 67
        Width = 79
        Height = 25
        Caption = 'Add Cont Circle'
        TabOrder = 3
        OnClick = AddContCircleButtonClick
      end
      object ContCirclesGrid: TStringGrid
        Left = 129
        Top = 29
        Width = 165
        Height = 92
        ColCount = 4
        Ctl3D = False
        DefaultColWidth = 40
        DefaultRowHeight = 17
        DrawingStyle = gdsGradient
        FixedColor = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GradientEndColor = clActiveCaption
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 4
        OnKeyDown = ContCirclesGridKeyDown
        OnMouseUp = ContCirclesGridMouseUp
        RowHeights = (
          17
          17
          17
          17
          17)
      end
      object InfectStrGrid: TStringGrid
        Left = 473
        Top = 32
        Width = 118
        Height = 109
        ColCount = 2
        Ctl3D = False
        DefaultColWidth = 60
        DefaultRowHeight = 17
        DrawingStyle = gdsGradient
        FixedColor = clMoneyGreen
        RowCount = 6
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GradientEndColor = clActiveCaption
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 5
        ColWidths = (
          60
          55)
        RowHeights = (
          17
          17
          17
          17
          17
          17)
      end
      object EpiCentrsGrid: TStringGrid
        Left = 307
        Top = 29
        Width = 153
        Height = 290
        ColCount = 3
        Ctl3D = False
        DefaultColWidth = 30
        DefaultRowHeight = 17
        DrawingStyle = gdsGradient
        FixedColor = clMoneyGreen
        RowCount = 16
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GradientEndColor = clActiveCaption
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 6
        OnMouseDown = EpiCentrsGridMouseDown
        OnMouseUp = EpiCentrsGridMouseUp
        ColWidths = (
          30
          68
          35)
        RowHeights = (
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17
          17)
      end
      object ParamPageControl: TPageControl
        Left = 646
        Top = 0
        Width = 364
        Height = 330
        ActivePage = SimulParamTabSheet
        Align = alRight
        TabOrder = 7
        object SimulParamTabSheet: TTabSheet
          Caption = 'Infection'
          object SimulGroupBox: TGroupBox
            Left = 8
            Top = 5
            Width = 340
            Height = 259
            Caption = ' Global Simulation Parameters '
            TabOrder = 0
            object ContProbGroupBox: TGroupBox
              Left = 12
              Top = 20
              Width = 215
              Height = 105
              Caption = ' Daily Contact Probability '
              TabOrder = 0
              object InitContProbEdit: TLabeledEdit
                Left = 123
                Top = 22
                Width = 40
                Height = 21
                EditLabel.Width = 108
                EditLabel.Height = 13
                EditLabel.Caption = 'Ordinary Contact Prob'
                LabelPosition = lpLeft
                TabOrder = 0
                Text = '0'
                OnChange = InitContProbEditChange
              end
              object InitContProbUpDown: TUpDown
                Left = 163
                Top = 22
                Width = 17
                Height = 21
                Min = -1000
                Max = 1000
                TabOrder = 1
                OnClick = InitContProbUpDownClick
                OnMouseUp = InitContProbUpDownMouseUp
              end
              object IsolContProbEdit: TLabeledEdit
                Left = 123
                Top = 49
                Width = 40
                Height = 21
                EditLabel.Width = 105
                EditLabel.Height = 13
                EditLabel.Caption = 'Isolated Contact Prob'
                LabelPosition = lpLeft
                TabOrder = 2
                Text = '0'
                OnChange = IsolContProbEditChange
              end
              object IsolContProbUpDown: TUpDown
                Left = 163
                Top = 49
                Width = 17
                Height = 21
                Min = -1000
                Max = 1000
                TabOrder = 3
                OnClick = IsolContProbUpDownClick
                OnMouseUp = IsolContProbUpDownMouseUp
              end
              object TimeIsolEdit: TLabeledEdit
                Left = 123
                Top = 76
                Width = 61
                Height = 21
                EditLabel.Width = 65
                EditLabel.Height = 13
                EditLabel.Caption = 'Quarantine in'
                LabelPosition = lpLeft
                ReadOnly = True
                TabOrder = 4
                Text = '0'
              end
              object TimeIsolUpDown: TUpDown
                Left = 184
                Top = 76
                Width = 17
                Height = 21
                TabOrder = 5
                OnClick = TimeIsolUpDownClick
                OnMouseUp = TimeIsolUpDownMouseUp
              end
            end
            object ParamDistrStrGrid: TStringGrid
              Left = 12
              Top = 137
              Width = 200
              Height = 110
              ColCount = 3
              Ctl3D = False
              DefaultColWidth = 80
              DefaultRowHeight = 17
              DrawingStyle = gdsGradient
              FixedColor = clMoneyGreen
              RowCount = 6
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              GradientEndColor = clActiveCaption
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goThumbTracking]
              ParentCtl3D = False
              ParentFont = False
              ScrollBars = ssVertical
              TabOrder = 1
              OnKeyDown = ParamDistrStrGridKeyDown
              OnSetEditText = ParamDistrStrGridSetEditText
              ColWidths = (
                80
                60
                56)
              RowHeights = (
                17
                17
                17
                17
                17
                17)
            end
            object ParamRadioGroup: TRadioGroup
              Left = 242
              Top = 22
              Width = 83
              Height = 61
              Caption = ' Parameters '
              ItemIndex = 0
              Items.Strings = (
                'Manual'
                'Optimal')
              TabOrder = 2
              OnClick = ParamRadioGroupClick
            end
            object Button1: TButton
              Left = 245
              Top = 137
              Width = 71
              Height = 22
              Caption = 'Button1'
              TabOrder = 3
              Visible = False
              OnClick = Button1Click
            end
            object Button2: TButton
              Left = 241
              Top = 165
              Width = 75
              Height = 25
              Caption = 'Button2'
              TabOrder = 4
              Visible = False
              OnClick = Button2Click
            end
            object Edit1: TEdit
              Left = 240
              Top = 196
              Width = 81
              Height = 21
              TabOrder = 5
              Visible = False
            end
            object PosEdit: TLabeledEdit
              Left = 240
              Top = 223
              Width = 81
              Height = 21
              EditLabel.Width = 17
              EditLabel.Height = 13
              EditLabel.Caption = 'Pos'
              LabelPosition = lpLeft
              TabOrder = 6
              Text = '0'
              Visible = False
            end
          end
        end
        object TreatmTabSheet: TTabSheet
          Caption = 'Treatment'
          ImageIndex = 1
          object DiseaseFormStrGrid: TStringGrid
            Left = 8
            Top = 22
            Width = 242
            Height = 82
            ColCount = 4
            Ctl3D = False
            DefaultColWidth = 75
            DefaultRowHeight = 19
            DrawingStyle = gdsGradient
            FixedColor = clMoneyGreen
            RowCount = 4
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            GradientEndColor = clActiveCaption
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking]
            ParentCtl3D = False
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
            OnExit = DiseaseFormStrGridExit
            OnSelectCell = DiseaseFormStrGridSelectCell
            ColWidths = (
              75
              54
              55
              53)
          end
          object LabeledEdit1: TLabeledEdit
            Left = 75
            Top = 229
            Width = 57
            Height = 21
            EditLabel.Width = 20
            EditLabel.Height = 13
            EditLabel.Caption = 'RGB'
            LabelPosition = lpLeft
            TabOrder = 1
            Text = '0'
          end
          object ParamUpDown: TUpDown
            Left = 121
            Top = 63
            Width = 17
            Height = 19
            Hint = ' Hold CTRL for large step'
            Min = -10000
            Max = 10000
            TabOrder = 2
            Visible = False
            OnClick = ParamUpDownClick
            OnMouseUp = ParamUpDownMouseUp
          end
          object DiseaeseStaticText: TStaticText
            Left = 8
            Top = 3
            Width = 181
            Height = 17
            Caption = 'Probability of disease form (%)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
          end
          object DurationStrGrid: TStringGrid
            Left = 8
            Top = 134
            Width = 189
            Height = 74
            ColCount = 3
            Ctl3D = False
            DefaultColWidth = 75
            DefaultRowHeight = 17
            DrawingStyle = gdsGradient
            FixedColor = clMoneyGreen
            RowCount = 4
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            GradientEndColor = clActiveCaption
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goThumbTracking]
            ParentCtl3D = False
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 4
            OnExit = DurationStrGridExit
            OnSelectCell = DurationStrGridSelectCell
            ColWidths = (
              75
              54
              55)
            RowHeights = (
              17
              17
              17
              17)
          end
          object DurationStaticText: TStaticText
            Left = 8
            Top = 115
            Width = 150
            Height = 17
            Caption = 'Treatment duration (day)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
          end
          object DurParamUpDown: TUpDown
            Left = 121
            Top = 172
            Width = 17
            Height = 19
            Hint = ' Hold CTRL for large step'
            Min = -10000
            Max = 10000
            TabOrder = 6
            Visible = False
            OnClick = DurParamUpDownClick
            OnMouseUp = DurParamUpDownMouseUp
          end
        end
      end
      object ParamStrGrid: TStringGrid
        Left = 8
        Top = 227
        Width = 286
        Height = 37
        ColCount = 2
        Ctl3D = False
        DefaultColWidth = 50
        DefaultRowHeight = 17
        DrawingStyle = gdsGradient
        FixedColor = clMoneyGreen
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GradientEndColor = clActiveCaption
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 8
        ColWidths = (
          50
          233)
        RowHeights = (
          17
          17)
      end
      object WeeklyGroupBox: TGroupBox
        Left = 473
        Top = 158
        Width = 152
        Height = 84
        Caption = ' Weekly Forecast '
        TabOrder = 9
        object WeekIterEdit: TLabeledEdit
          Left = 86
          Top = 22
          Width = 40
          Height = 21
          EditLabel.Width = 74
          EditLabel.Height = 13
          EditLabel.Caption = 'Iteration Count'
          LabelPosition = lpLeft
          TabOrder = 0
          Text = '50'
        end
        object WeekIterUpDown: TUpDown
          Left = 126
          Top = 22
          Width = 16
          Height = 21
          Associate = WeekIterEdit
          Min = 1
          Max = 5000
          Increment = 5
          Position = 50
          TabOrder = 1
        end
        object WeekCountEdit: TLabeledEdit
          Left = 86
          Top = 52
          Width = 40
          Height = 21
          EditLabel.Width = 59
          EditLabel.Height = 13
          EditLabel.Caption = 'Week Count'
          LabelPosition = lpLeft
          TabOrder = 2
          Text = '6'
        end
        object WeekCountUpDown: TUpDown
          Left = 126
          Top = 52
          Width = 16
          Height = 21
          Associate = WeekCountEdit
          Max = 50
          Position = 6
          TabOrder = 3
        end
      end
    end
    object LeftTopPanel: TPanel
      Left = 0
      Top = 0
      Width = 1010
      Height = 672
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object MapScrollBox: TScrollBox
        Left = 0
        Top = 0
        Width = 1010
        Height = 672
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnShadow
        ParentColor = False
        TabOrder = 0
        object MapPaintBox: TPaintBox
          Left = 0
          Top = -2
          Width = 400
          Height = 400
          Color = clYellow
          ParentColor = False
          OnMouseDown = MapPaintBoxMouseDown
          OnMouseMove = MapPaintBoxMouseMove
          OnMouseUp = MapPaintBoxMouseUp
          OnPaint = MapPaintBoxPaint
        end
      end
    end
  end
  object SimulPageControl: TPageControl
    Left = 1014
    Top = 30
    Width = 559
    Height = 1002
    ActivePage = StatTabSheet
    Align = alRight
    HotTrack = True
    TabOrder = 3
    object PatParamTabSheet: TTabSheet
      Caption = 'Patient'
      object Splitter1: TSplitter
        Left = 0
        Top = 369
        Width = 551
        Height = 4
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Color = clActiveBorder
        ParentColor = False
        ExplicitTop = 409
        ExplicitWidth = 436
      end
      object PatPanel: TPanel
        Left = 0
        Top = 0
        Width = 551
        Height = 179
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object DetectPatLabel: TLabel
          Left = 3
          Top = 4
          Width = 96
          Height = 13
          Caption = 'Detected Patient'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object NewPatButton: TButton
          Left = 267
          Top = 1
          Width = 75
          Height = 25
          Caption = 'New Patient'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Visible = False
          OnClick = NewPatButtonClick
        end
        object AddPatButton: TButton
          Left = 356
          Top = 2
          Width = 75
          Height = 25
          Caption = 'Add Patient'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Visible = False
          OnClick = AddPatButtonClick
        end
        object PatGroupBox: TGroupBox
          Left = 3
          Top = 23
          Width = 474
          Height = 149
          Caption = ' Individual Patient Parameters '
          TabOrder = 2
          object CoordXEdit: TLabeledEdit
            Left = 87
            Top = 22
            Width = 40
            Height = 21
            EditLabel.Width = 62
            EditLabel.Height = 13
            EditLabel.Caption = 'Coordinate X'
            LabelPosition = lpLeft
            TabOrder = 0
            Text = '0'
          end
          object HistThreshEdit: TLabeledEdit
            Left = -730
            Top = 742
            Width = 28
            Height = 21
            EditLabel.Width = 54
            EditLabel.Height = 13
            EditLabel.Caption = 'Hist Thresh'
            LabelPosition = lpLeft
            TabOrder = 1
            Text = '1'
          end
          object CoordYEdit: TLabeledEdit
            Left = 249
            Top = 22
            Width = 40
            Height = 21
            EditLabel.Width = 62
            EditLabel.Height = 13
            EditLabel.Caption = 'Coordinate Y'
            LabelPosition = lpLeft
            TabOrder = 2
            Text = '0'
          end
          object CoordXUpDown: TUpDown
            Left = 127
            Top = 22
            Width = 16
            Height = 21
            Associate = CoordXEdit
            Enabled = False
            Max = 1098
            TabOrder = 3
          end
          object CoordYUpDown: TUpDown
            Left = 289
            Top = 22
            Width = 16
            Height = 21
            Associate = CoordYEdit
            Enabled = False
            Max = 710
            TabOrder = 4
          end
          object InfecttTimeEdit: TLabeledEdit
            Left = 402
            Top = 22
            Width = 40
            Height = 21
            EditLabel.Width = 78
            EditLabel.Height = 13
            EditLabel.Caption = 'Day of Infection'
            LabelPosition = lpLeft
            TabOrder = 5
            Text = '0'
          end
          object InitTimeUpDown: TUpDown
            Left = 442
            Top = 22
            Width = 16
            Height = 21
            Associate = InfecttTimeEdit
            Enabled = False
            Min = -50
            Max = 1000
            TabOrder = 6
          end
          object Stage1Edit: TLabeledEdit
            Left = 87
            Top = 52
            Width = 40
            Height = 21
            EditLabel.Width = 64
            EditLabel.Height = 13
            EditLabel.Caption = 'Latent Period'
            LabelPosition = lpLeft
            TabOrder = 7
            Text = '0'
          end
          object Stage2Edit: TLabeledEdit
            Left = 249
            Top = 52
            Width = 40
            Height = 21
            EditLabel.Width = 87
            EditLabel.Height = 13
            EditLabel.Caption = 'Contagious Period'
            LabelPosition = lpLeft
            TabOrder = 8
            Text = '0'
          end
          object DetectEdit: TLabeledEdit
            Left = 402
            Top = 52
            Width = 40
            Height = 21
            EditLabel.Width = 81
            EditLabel.Height = 13
            EditLabel.Caption = 'Day of Detection'
            LabelPosition = lpLeft
            TabOrder = 9
            Text = '0'
          end
          object Stage1UpDown: TUpDown
            Left = 127
            Top = 52
            Width = 16
            Height = 21
            Associate = Stage1Edit
            Enabled = False
            Max = 30
            TabOrder = 10
          end
          object Stage2UpDown: TUpDown
            Left = 289
            Top = 52
            Width = 16
            Height = 21
            Associate = Stage2Edit
            Enabled = False
            Max = 30
            TabOrder = 11
          end
          object DetectUpDown: TUpDown
            Left = 442
            Top = 52
            Width = 16
            Height = 21
            Associate = DetectEdit
            Enabled = False
            Max = 40
            TabOrder = 12
          end
          object AgeEdit: TLabeledEdit
            Left = 87
            Top = 82
            Width = 40
            Height = 21
            EditLabel.Width = 19
            EditLabel.Height = 13
            EditLabel.Caption = 'Age'
            LabelPosition = lpLeft
            TabOrder = 13
            Text = '1'
          end
          object AgeUpDown: TUpDown
            Left = 127
            Top = 82
            Width = 16
            Height = 21
            Associate = AgeEdit
            Enabled = False
            Min = 1
            Max = 110
            Position = 1
            TabOrder = 14
          end
          object DistEdit: TLabeledEdit
            Left = 249
            Top = 82
            Width = 40
            Height = 21
            EditLabel.Width = 80
            EditLabel.Height = 13
            EditLabel.Caption = 'Avrg Distnce (m)'
            LabelPosition = lpLeft
            TabOrder = 15
            Text = '0'
          end
          object DistUpDown: TUpDown
            Left = 289
            Top = 82
            Width = 16
            Height = 21
            Associate = DistEdit
            Enabled = False
            Max = 10000
            TabOrder = 16
          end
          object StatusEdit: TLabeledEdit
            Left = 402
            Top = 82
            Width = 40
            Height = 21
            EditLabel.Width = 31
            EditLabel.Height = 13
            EditLabel.Caption = 'Status'
            LabelPosition = lpLeft
            TabOrder = 17
            Text = '0'
          end
          object StatusUpDown: TUpDown
            Left = 442
            Top = 82
            Width = 16
            Height = 21
            Associate = StatusEdit
            Enabled = False
            Min = -1
            Max = 4
            TabOrder = 18
          end
          object ContactsEdit: TLabeledEdit
            Left = 87
            Top = 111
            Width = 40
            Height = 21
            EditLabel.Width = 77
            EditLabel.Height = 13
            EditLabel.Caption = 'Num ofContacts'
            LabelPosition = lpLeft
            TabOrder = 19
            Text = '0'
          end
          object SDContactsEdit: TLabeledEdit
            Left = 249
            Top = 109
            Width = 40
            Height = 21
            EditLabel.Width = 84
            EditLabel.Height = 13
            EditLabel.Caption = 'SDev of Contacts'
            LabelPosition = lpLeft
            TabOrder = 20
            Text = '0'
          end
          object SDContactsUpDown: TUpDown
            Left = 289
            Top = 109
            Width = 16
            Height = 21
            Associate = SDContactsEdit
            Enabled = False
            Max = 50
            TabOrder = 21
          end
          object ContactsUpDown: TUpDown
            Left = 127
            Top = 111
            Width = 16
            Height = 21
            Associate = ContactsEdit
            Enabled = False
            Max = 300
            TabOrder = 22
          end
          object ContProbEdit: TLabeledEdit
            Left = 402
            Top = 111
            Width = 40
            Height = 21
            EditLabel.Width = 79
            EditLabel.Height = 13
            EditLabel.Caption = 'Contagious Prob'
            LabelPosition = lpLeft
            TabOrder = 23
            Text = '0'
          end
          object ContProbUpDown: TUpDown
            Left = 442
            Top = 111
            Width = 17
            Height = 21
            Enabled = False
            Min = -10000
            Max = 10000
            TabOrder = 24
            OnClick = ContProbUpDownClick
          end
        end
      end
      object DetListPanel: TPanel
        Left = 0
        Top = 179
        Width = 551
        Height = 190
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        OnResize = DetListPanelResize
        object DetPatLabel: TLabel
          Left = 3
          Top = 3
          Width = 89
          Height = 13
          Caption = ' Initial Patients '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object R0StatLabel: TLabel
          Left = 362
          Top = 3
          Width = 90
          Height = 13
          Caption = 'Statistics for Ro'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object DetPatStrGrid: TStringGrid
          Left = 3
          Top = 21
          Width = 346
          Height = 124
          ColCount = 8
          Ctl3D = False
          DefaultColWidth = 40
          DefaultRowHeight = 17
          DrawingStyle = gdsGradient
          FixedColor = clMoneyGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          GradientEndColor = clActiveCaption
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnSelectCell = DetPatStrGridSelectCell
          RowHeights = (
            17
            17
            17
            17
            17)
        end
        object R0StrGrid: TStringGrid
          Left = 362
          Top = 21
          Width = 181
          Height = 92
          ColCount = 3
          Ctl3D = False
          DefaultColWidth = 50
          DefaultRowHeight = 17
          DrawingStyle = gdsGradient
          FixedColor = clMoneyGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          GradientEndColor = clActiveCaption
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          ColWidths = (
            50
            63
            64)
          RowHeights = (
            17
            17
            17
            17
            17)
        end
      end
      object RightBottomPanel: TPanel
        Left = 0
        Top = 373
        Width = 551
        Height = 601
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object Splitter2: TSplitter
          Left = 0
          Top = 337
          Width = 551
          Height = 4
          Cursor = crVSplit
          Align = alTop
          AutoSnap = False
          Color = clActiveBorder
          ParentColor = False
          ExplicitTop = 313
          ExplicitWidth = 436
        end
        object SimulChart: TChart
          Left = 0
          Top = 0
          Width = 551
          Height = 337
          Legend.Alignment = laBottom
          Legend.CheckBoxes = True
          Title.Font.Color = 4194432
          Title.Font.Style = [fsBold]
          Title.Text.Strings = (
            'Patient Status Simulation')
          OnClickLegend = SimulChartClickLegend
          BottomAxis.Grid.Color = clSilver
          BottomAxis.Grid.Style = psSolid
          BottomAxis.MinorTicks.Visible = False
          BottomAxis.TicksInner.Visible = False
          BottomAxis.Title.Caption = 'Time (days)'
          BottomAxis.Title.Font.Color = clOlive
          BottomAxis.Title.Font.Style = [fsBold]
          LeftAxis.Automatic = False
          LeftAxis.AutomaticMinimum = False
          LeftAxis.ExactDateTime = False
          LeftAxis.Grid.Color = clSilver
          LeftAxis.Grid.Style = psSolid
          LeftAxis.LogarithmicBase = 2.718281828459050000
          LeftAxis.MinorTicks.Visible = False
          LeftAxis.TicksInner.Visible = False
          LeftAxis.Title.Caption = 'Infected & Treatment'
          LeftAxis.Title.Font.Color = 4194432
          LeftAxis.Title.Font.Style = [fsBold]
          RightAxis.Grid.Color = clSilver
          RightAxis.Grid.Style = psSolid
          RightAxis.Grid.Visible = False
          RightAxis.MinorTicks.Visible = False
          RightAxis.TicksInner.Visible = False
          RightAxis.Title.Angle = 90
          RightAxis.Title.Caption = 'Dead'
          RightAxis.Title.Font.Color = 16744448
          RightAxis.Title.Font.Style = [fsBold]
          View3D = False
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          OnResize = SimulChartResize
          ColorPaletteIndex = 13
          object SimulTimeUpDown: TUpDown
            Left = 8
            Top = 6
            Width = 37
            Height = 17
            Hint = 'Select Simulation Time'
            Orientation = udHorizontal
            TabOrder = 0
            OnChanging = SimulTimeUpDownChanging
            OnClick = SimulTimeUpDownClick
            OnMouseUp = SimulTimeUpDownMouseUp
          end
          object CaseMSEEdit: TLabeledEdit
            Left = 458
            Top = 10
            Width = 47
            Height = 19
            Ctl3D = False
            EditLabel.Width = 59
            EditLabel.Height = 13
            EditLabel.Caption = 'Cases RMSE'
            LabelPosition = lpLeft
            ParentCtl3D = False
            TabOrder = 1
            Text = '0'
          end
          object RealIsolSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 4707200
            Title = 'Detected '
            LinePen.Color = 9154917
            LinePen.Width = 5
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object InfPatSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Infected '
            LinePen.Color = clRed
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object TreatSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 13261778
            Title = 'Treated  '
            LinePen.Color = 13261778
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object LethalSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 12615680
            Title = 'Dead '
            VertAxis = aRightAxis
            LinePen.Color = 16744448
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object CaseSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 14694545
            Title = 'Cases'
            LinePen.Color = 15366068
            LinePen.Style = psDash
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object RealLethalSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 15823064
            ShowInLegend = False
            Title = 'Real Dead '
            VertAxis = aRightAxis
            LinePen.Color = 16760704
            LinePen.Style = psDash
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object ReaHospSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 5977988
            ShowInLegend = False
            Title = 'Real Hosp '
            LinePen.Color = 16760704
            LinePen.Style = psDash
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loNone
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
        object AgeHistChart: TChart
          Left = 0
          Top = 341
          Width = 551
          Height = 260
          Legend.Alignment = laBottom
          Legend.CheckBoxes = True
          Title.Font.Color = clPurple
          Title.Font.Style = [fsBold]
          Title.Text.Strings = (
            'Patients Age Histogram')
          BottomAxis.ExactDateTime = False
          BottomAxis.Grid.Color = clSilver
          BottomAxis.Grid.Style = psSolid
          BottomAxis.Increment = 10.000000000000000000
          BottomAxis.MinorTicks.Visible = False
          BottomAxis.TicksInner.Visible = False
          BottomAxis.Title.Caption = 'Age (years)'
          BottomAxis.Title.Font.Color = clPurple
          BottomAxis.Title.Font.Style = [fsBold]
          LeftAxis.Automatic = False
          LeftAxis.AutomaticMinimum = False
          LeftAxis.Grid.Color = clSilver
          LeftAxis.Grid.Style = psSolid
          LeftAxis.MinorTicks.Visible = False
          LeftAxis.TicksInner.Visible = False
          LeftAxis.Title.Caption = 'Count'
          LeftAxis.Title.Font.Color = clPurple
          LeftAxis.Title.Font.Style = [fsBold]
          View3D = False
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ColorPaletteIndex = 13
          object InfHistSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Infected  '
            LinePen.Color = clRed
            LinePen.Width = 2
            Pointer.Brush.Color = clWhite
            Pointer.HorizSize = 5
            Pointer.InflateMargins = True
            Pointer.Pen.Color = clRed
            Pointer.Pen.Width = 2
            Pointer.Style = psCircle
            Pointer.VertSize = 5
            Pointer.Visible = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object TreatHistSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 13261778
            Title = 'Treated  '
            LinePen.Color = 13261778
            LinePen.Width = 2
            Pointer.Brush.Color = clWhite
            Pointer.HorizSize = 5
            Pointer.InflateMargins = True
            Pointer.Pen.Color = 13261778
            Pointer.Pen.Width = 2
            Pointer.Style = psCircle
            Pointer.VertSize = 5
            Pointer.Visible = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object LethalHistSeries: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            SeriesColor = 16744448
            Title = 'Dead '
            LinePen.Color = 16744448
            LinePen.Width = 2
            Pointer.Brush.Color = clWhite
            Pointer.HorizSize = 5
            Pointer.InflateMargins = True
            Pointer.Pen.Color = 16744448
            Pointer.Pen.Width = 2
            Pointer.Style = psCircle
            Pointer.VertSize = 5
            Pointer.Visible = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
    end
    object StatTabSheet: TTabSheet
      Caption = 'Statistics'
      ImageIndex = 1
      object Splitter4: TSplitter
        Left = 0
        Top = 246
        Width = 551
        Height = 4
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Color = clActiveBorder
        ParentColor = False
        ExplicitLeft = -2
        ExplicitTop = 444
        ExplicitWidth = 420
      end
      object Splitter5: TSplitter
        Left = 0
        Top = 630
        Width = 551
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clActiveBorder
        ParentColor = False
        ExplicitTop = 667
        ExplicitWidth = 514
      end
      object Chart1: TChart
        Left = 0
        Top = 0
        Width = 551
        Height = 246
        Gradient.EndColor = 13816530
        Gradient.Visible = True
        Legend.Alignment = laBottom
        Legend.CheckBoxes = True
        Title.Font.Color = clPurple
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Detected Patients')
        BottomAxis.Grid.Color = clSilver
        BottomAxis.Grid.Style = psSolid
        BottomAxis.MinorTicks.Visible = False
        BottomAxis.TicksInner.Visible = False
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Grid.Color = clSilver
        LeftAxis.Grid.Style = psSolid
        LeftAxis.MinorTicks.Visible = False
        LeftAxis.TicksInner.Visible = False
        View3D = False
        Align = alTop
        BevelOuter = bvNone
        Color = 14869218
        TabOrder = 0
        ColorPaletteIndex = 13
        object TreatSimulSeries: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = clRed
          Title = 'Detected (Pred)'
          LinePen.Color = 16744448
          LinePen.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object TreatReallSeries: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 16744448
          Title = 'Detected (Actual)'
          LinePen.Color = clRed
          LinePen.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object PanelOptTime: TPanel
        Left = 0
        Top = 250
        Width = 551
        Height = 74
        Align = alTop
        BevelOuter = bvNone
        Color = 15395562
        ParentBackground = False
        TabOrder = 1
        object OptTimeGroupBox: TGroupBox
          Left = 6
          Top = 7
          Width = 480
          Height = 57
          Caption = ' Optimization Priod '
          TabOrder = 0
          object InitOptEdit: TLabeledEdit
            Left = 94
            Top = 22
            Width = 65
            Height = 21
            EditLabel.Width = 72
            EditLabel.Height = 13
            EditLabel.Caption = 'Init Optim Time'
            LabelPosition = lpLeft
            TabOrder = 0
            Text = '0'
          end
          object TermOptEdit: TLabeledEdit
            Left = 277
            Top = 22
            Width = 65
            Height = 21
            EditLabel.Width = 80
            EditLabel.Height = 13
            EditLabel.Caption = 'Term Optim Time'
            LabelPosition = lpLeft
            TabOrder = 1
            Text = '0'
          end
          object InitOptUpDown: TUpDown
            Left = 159
            Top = 22
            Width = 17
            Height = 21
            Max = 1000
            TabOrder = 2
            OnClick = InitOptUpDownClick
            OnMouseUp = InitOptUpDownMouseUp
          end
          object TermOptUpDown: TUpDown
            Left = 342
            Top = 22
            Width = 17
            Height = 21
            Max = 1000
            TabOrder = 3
            OnClick = TermOptUpDownClick
            OnMouseUp = TermOptUpDownMouseUp
          end
          object TermUpEdit: TEdit
            Left = 365
            Top = 23
            Width = 103
            Height = 18
            BevelEdges = []
            BevelInner = bvNone
            BorderStyle = bsNone
            Color = 15395562
            Ctl3D = False
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 4
          end
        end
      end
      object ForecastChart: TChart
        Left = 0
        Top = 324
        Width = 551
        Height = 306
        Legend.Alignment = laBottom
        Legend.CheckBoxes = True
        Title.Font.Color = clPurple
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Forecast of Patient Count')
        BottomAxis.Grid.Color = clSilver
        BottomAxis.Grid.Style = psSolid
        BottomAxis.MinorTicks.Visible = False
        BottomAxis.TicksInner.Visible = False
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Grid.Color = clSilver
        LeftAxis.Grid.Style = psSolid
        LeftAxis.MinorTicks.Visible = False
        LeftAxis.TicksInner.Visible = False
        View3D = False
        OnAfterDraw = ForecastChartAfterDraw
        OnBeforeDrawAxes = ForecastChartBeforeDrawAxes
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = CopyChartMenu
        TabOrder = 2
        OnMouseDown = ForecastChartMouseDown
        OnMouseMove = ForecastChartMouseMove
        ColorPaletteIndex = 13
        object ShowValLabel: TLabel
          Left = 16
          Top = 280
          Width = 77
          Height = 13
          Caption = 'ShowValLabel'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
        end
        object ForeSeries: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 1327315
          Title = 'Forecoast  '
          LinePen.Color = clRed
          LinePen.Width = 3
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object LowSeries: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 1327315
          Title = 'Low Conf '
          LinePen.Color = 8421631
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object HighSeries: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 1327315
          Title = 'High Conf '
          LinePen.Color = 8421631
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object RealSeries: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 16744448
          Title = 'Real '
          LinePen.Color = 16744448
          LinePen.Width = 3
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object ForePanel: TPanel
        Left = 0
        Top = 634
        Width = 551
        Height = 56
        Align = alTop
        BevelOuter = bvNone
        Color = 15395562
        ParentBackground = False
        TabOrder = 3
        object ForeIterEdit: TLabeledEdit
          Left = 388
          Top = 19
          Width = 40
          Height = 21
          EditLabel.Width = 87
          EditLabel.Height = 13
          EditLabel.Caption = 'Forecast Iteration'
          LabelPosition = lpLeft
          TabOrder = 0
          Text = '200'
        end
        object ForeIterUpDown: TUpDown
          Left = 428
          Top = 19
          Width = 16
          Height = 21
          Associate = ForeIterEdit
          Min = 1
          Max = 10000
          Increment = 5
          Position = 200
          TabOrder = 1
        end
        object SimTypeRadioGroup: TRadioGroup
          Left = 9
          Top = 6
          Width = 274
          Height = 40
          Caption = ' Simulation Type '
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'Cases'
            'Hidden'
            'Hospital'
            'Fatality')
          TabOrder = 2
          OnClick = SimTypeRadioGroupClick
        end
      end
      object R0Chart: TChart
        Left = 0
        Top = 690
        Width = 551
        Height = 284
        Legend.Alignment = laBottom
        Legend.CheckBoxes = True
        Title.Font.Color = clPurple
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Ro Histograms')
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.ExactDateTime = False
        BottomAxis.Grid.Color = clSilver
        BottomAxis.Grid.Style = psSolid
        BottomAxis.Increment = 0.500000000000000000
        BottomAxis.MinorTicks.Visible = False
        BottomAxis.TicksInner.Visible = False
        LeftAxis.Grid.Color = clSilver
        LeftAxis.Grid.Style = psSolid
        LeftAxis.MinorTicks.Visible = False
        LeftAxis.TicksInner.Visible = False
        LeftAxis.Title.Caption = 'Probability Density'
        LeftAxis.Title.Font.Color = 4194368
        LeftAxis.Title.Font.Style = [fsBold]
        RightAxis.Grid.Visible = False
        RightAxis.MinorTicks.Visible = False
        RightAxis.TicksInner.Visible = False
        RightAxis.Title.Angle = 90
        RightAxis.Title.Caption = 'Distribution Function'
        RightAxis.Title.Font.Color = 4194368
        RightAxis.Title.Font.Style = [fsBold]
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = CopyChartMenu
        TabOrder = 4
        OnMouseDown = R0ChartMouseDown
        ColorPaletteIndex = 13
        object R0DistrCheckBox: TCheckBox
          Left = 4
          Top = 11
          Width = 70
          Height = 17
          Caption = 'Distr Func'
          TabOrder = 0
          OnClick = R0DistrCheckBoxClick
        end
        object PreR0Series: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = 'Pre Quarantine R0  '
          LinePen.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object PostR0Series: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = 'Post Quarantine R0'
          LinePen.Width = 2
          Pointer.InflateMargins = True
          Pointer.Pen.Color = clRed
          Pointer.Style = psCircle
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object DistrPreR0Series: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 16744448
          ShowInLegend = False
          VertAxis = aRightAxis
          LinePen.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object DistrPostR0Series: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          ShowInLegend = False
          VertAxis = aRightAxis
          LinePen.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
    end
  end
  object ImageList: TImageList
    Left = 934
    Top = 112
    Bitmap = {
      494C010125000C043C0410001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000A0000000010020000000000000A0
      000000000000000000000000000000000000000000000374AB000374AB000374
      AB000374AB000374AB000374AB000374AB000374AB000374AB00046B0B000374
      AB000374AB000374AB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB001788BD0041B5E80065CF
      F4004BBFF2004BBFF2004BBFF2004BBFF2004BBFF2004BBFF200046B0B00046B
      0B002799CD000374AB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0039ADDF002294C80064D1
      F70056C7F60056C7F60056C7F60056C7F60056C7F60056C7F600046B0B00169C
      2B00046B0B0060CFE8000374AB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0059C9F6000374AB0064D1
      F70064D1F700046B0B00046B0B00046B0B00046B0B00046B0B00046B0B001CA8
      3500169C2B00046B0B000374AB00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0064D1F7000F72A300ACAC
      A800B0A49700046B0B0042DB7B003FDA76003AD46A0032C959002ABF4C0023B4
      41001CA83500169C2B00046B0B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0064D1F7004A70870057D4
      C700FAE6D000046B0B0042DB7B0042DB7B003FDA76003AD46A0032C959002ABF
      4C0023B441001CA83500169C2B00046B0B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0064D1F700806E6E001380
      B300FEFCFA00046B0B0042DB7B0042DB7B0042DB7B003FDA76003AD46A0033CB
      5C002ABF4C0021B03C00046B0B000374AB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0064D1F7009D6C6000127C
      AD000374AB00046B0B00046B0B00046B0B00046B0B00046B0B00046B0B003AD4
      6A0032C95900046B0B000374AB000374AB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB0064D1F700AA736000FCE9
      D600FDEEDD00FAE6D000F9E2CC00F6DDC500F6DDC500E7D1BE00046B0B003FDA
      7600046B0B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000374AB00FEFCFA00B47D6500FDF1
      E500FDF5ED00FDEEDD00FDEAD700FAE6D000F9E2CC00F3DAC300046B0B00046B
      0B000473AA000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000374AB00BD876900FDF5
      ED00FEFBF800FDF5ED00FDF1E500FDF1E500FDEFE100F9E2CC00046B0B000374
      AB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C9926C00FDF6
      EF00FEFCFA00FEFBF800FEFBF800DFCCBD00D0C3B700AEA59A00806E6E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CF9E7100FDF7
      F100FEFCFA00FEFCFA00FEFCFA00A06C5E00A06C5E00A06C5E00A06C5E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C99F7900FDF5
      ED00FDFBFA00FDFBFA00FEFCFA00A06C5E00D49A6700D49A6700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C99F7900CB93
      6C00CB936C00CB936C00CB936C00A06C5E00D49A670000000000000000000000
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
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000006600000066
      0000AAAC9C00AAAC9C00AAAC9C00AAAC9C00AAAC9C00AAAC9C00AAAC9C000066
      000000660000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00FFFFFF0000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F00FFFFFF00000000000000000000660000009800000098
      0000E5E1E5000066000000660000E7E6E700E5E4E600E5E1E500CCCCCC000066
      0000007D0000006600000000000000000000FFFF000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF00000000000000000000660000009800000098
      0000E5E1E5000066000000660000E5E1E500E7E6E700E5E1E500CDCCCD000066
      0000007D0000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000007F7F7F00FFFFFF00000000000000000000660000009800000098
      0000E5E4E6000066000000660000E4DCE500E7E6E700E5E4E600CDCCCD000066
      0000007D0000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F00FFFFFF00FFFFFF0000000000000000000000
      0000000000007F7F7F00FFFFFF00000000000000000000660000009800000098
      0000E7E6E700E7E6E700E5E1E500E4DCE500E5E1E500E5E1E500CDCCCD000066
      0000007D0000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F00FFFFFF00FFFFFF000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F00FFFFFF00FFFFFF00000000000000
      0000000000007F7F7F00FFFFFF00000000000000000000660000009800000098
      0000009800000098000000980000009800000098000000980000009800000098
      000000980000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F00FFFFFF00FFFF
      FF00000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF00FFFFFF000000
      0000000000007F7F7F00FFFFFF0000000000000000000066000000980000B4C6
      B000B4C6B000B4C6B000B4C6B000B4C6B000B4C6B000B4C6B000B4C6B000B4C6
      B00000980000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F007F7F7F000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000007F7F7F00FFFFFF0000000000000000000066000000980000F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F80000980000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000007F7F7F007F7F7F00FFFFFF007F7F7F007F7F7F00000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F0000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000000066000000980000F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F80000980000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000007F7F7F007F7F7F00000000007F7F7F0000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000000066000000980000F8F8
      F800CDCCCD00CDCCCD00CDCCCD00CDCCCD00CDCCCD00CDCCCD00CDCCCD00F8F8
      F80000980000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000000066000000980000F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F80000980000006600000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF0000000000000000000066000000980000F8F8
      F800CDCCCD00CDCCCD00CDCCCD00CDCCCD00CDCCCD00CDCCCD00CDCCCD00F8F8
      F80000980000006600000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF000000000000000000007F7F7F00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F00FFFFFF0000000000000000007F7F7F00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F00FFFFFF0000000000000000000066000000980000F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F80000980000006600000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F000000000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F000000000000000000000000000000000000660000F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F80000660000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008543220085432200854322008543220085432200854322000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006E382F006E382F0080412600804126006E382F006E382F000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000053211A0053211A00692A1300692A130053211A0053211A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008543
      220085432200C9660100C9660100C9660100C9660100C9660100C96601008543
      2200854322000000000000000000000000000000000000000000000000007039
      2E0080412600AF591100C3620500CB660200CB660200C3620500B25B10008443
      25006E382F000000000000000000000000000000000000000000000000005823
      1800662914009B400700B2470100BB4B0000BB4B0000B24701009E4107006D2C
      120053211A00000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000000000009A4E1800C662
      0100C9650000C9650000C9650000C9650000C9650000C9660100C9660100C966
      0100C763010085432200000000000000000000000000000000007C3F2800A856
      1500CF6A0400CF6A0400CD680300CA650100CC670300CC670300CE690400CF6A
      0400A85615006E382F000000000000000000000000000000000064281500933C
      0900C2500200C14F0200BF4E0100BB4A0000BD4C0100BD4C0100BF4E0100C250
      0200933C090053211A000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000000000009A4E1800C6620100C763
      0100C6620100C6620100C6620100C6620100C7630100C9640100C9660100C966
      0100C9660100C763010085432200000000000000000084432500AF591100CF6A
      0400CA650100CD6E0F00CD6E0F00CA650100CA650100CB660200CB660200CB66
      0200CF6A0400A85615006E382F000000000000000000692A13009B400700C14F
      0200BB4A0000C04F0200C04F0200BB4A0000BB4A0000BB4B0000BB4B0000BB4B
      0000C2500200933C090053211A0000000000FFFF000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F0000000000FFFF00000000000000000000BD5F0800C6620100C360
      0200C3600200CB741D00D58D4500DB9B5A00DB9B5A00D2863A00C9640100C966
      0100C9660100C9660100854322000000000000000000984E1C00CF6A0400CF6A
      0400CB660200CD680300CE6C0B00CF6A0600CE6B0800CA650100CB660200CB66
      0200CB660200CF6A040080412600000000000000000084360C00C14F0200BF4E
      0100CF6D1F00DA874000C1510400C04F0200C04F0200DA874000F3C29200BB4B
      0000BB4B0000C2500200692A130000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000A7541200C9680600C9680600C968
      0600DB9B5A00FBFAF900FBFAF900FBFAF900FBFAF900E9C39B00C6620100C964
      0100C9660100C9660100C966010085432200A8561500C0610600D2751700D478
      1C00D1731400D57B2100E8BE9300FBEEE400FBEEE400E8BE9300D2751700CA65
      0100CB660200CE690400B45C10006E382F00933C0900B2470100C5590A00C75C
      0D00DA874000FBF4EE00D59D6700C1510400BD4D0100E1A87200FEFEFE00BB4A
      0000BB4B0000BF4E0100A142060053211A00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000AC571100CB701500CB701500CB74
      1D00FBFAF900E9C09600CE7B2800CB741D00CB701500BD5F0800C3600200C763
      0100C9650000C9660100C966010085432200AF591100D4781C00DA842E00DC8A
      3700DA842E00EEC59A00FEFEFD00FEFEFD00FEFEFD00FEFEFD00E8BE9300CB66
      0200CA650100CD680300C66304006E382F009B400700C75C0D00CF6D1F00D272
      2500DE8E4700FEFEFE00FEFEFE00E9B17B00C75C0D00E6A36600FEFEFE00BB4B
      0000BB4A0000BF4E0100B548010053211A00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000AC571100D0813100D0813100CE7B
      2800FBFAF900D2863A00CE7B2800CB701500C9680600E9C39B00C15F0400C662
      0100C9650000C9660100C966010085432200B45C1000DF904000E49C5300E49C
      5300E0944700FCF2EA00FEFEFD00FEFEFD00FEFEFD00FEFEFD00FBEFE400CF6A
      0600CE6C0B00CA650100CB6602006E382F00A1420600D2722500D7803600D780
      3600E39C5B00FDFBF800FEFEFE00FEFEFE00F2E0CE00E6A36600FEFEFE00C04F
      0200C1510400BB4A0000BB4B000053211A00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000AC571100DEA26500D9965200D58D
      4500FBFAF900E5B58300D2863A00CE7B2800CB701500FBFAF900E9C09600C360
      0200C9650000C9660100C966010085432200B55D0F00E8A56100EDB57A00E9AA
      6A00E8A56100FCF4ED00FEFEFD00FEFEFD00FEFEFD00FEFEFD00FBEFE400CF6A
      0600CE6B0800CA650100CB660200743B2C00A6430400DE8E4700E6A16100E195
      5000EAAB7000FEFCFA00FEFEFE00FEFEFE00F2E0CE00E1A87200FEFEFE00C04F
      0200BD4D0100BB4A0000BB4B000058231800FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000AC571100E5B58300E4B17D00D996
      5200F1D5B900FBFAF900F6E5D300F6E5D300F7EADD00FBFAF900FBFAF900EECF
      AF00C9650000C9660100C966010085432200B25B1000E9AA6A00F4CA9D00EEB7
      7D00ECB37700F5D0AA00FEFEFD00FEFEFD00FEFEFD00FEFEFD00ECC29600CA65
      0200CA650100CD680300C66304006E382F009B400700E1924D00F2BC8900E6A1
      6100EEB78200FEFEFE00FEFEFE00F3C29200D4782C00E9B17B00FEFEFE00BB4A
      0000BB4A0000BF4E0100B548010053211A00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000AC571100E4B17D00F1D5B900E4B1
      7D00E0A76D00E9C39B00F1D5B900EECFAF00F4DFC900FBFAF900FBFAF900ECCA
      A700C9650000C9660100C966010085432200B45C1000E1974D00F5D0AA00F4CA
      9D00F0BC8500F1BF8A00F5D0AA00FCF4ED00FCF2EA00F4CEA700DC8A3700CE6C
      0B00CB660200CE690400B25B10006E382F00A1420600D7803600F3C29200F2BC
      8900F3C29200FDFAF700F3C29200DE8E4700D7803600F0BC8900FEFEFE00C151
      0400BD4C0100BF4E01009E41070053211A00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF00000000000000000000B25B1000F2D9C000F2D9
      C000E7B98A00E0A76D00DB9B5A00D58D4500D0813100FBFAF900E8BC8F00CA66
      0200C9650000C9660100854322000000000000000000CD6E0F00F5CEA600FBE4
      E600F4CA9D00F1BF8A00F2C59400EFB98000E8A56100E0944700DA842E00D173
      1400CD680300CF6A04007E4027000000000000000000C0530600F3C29200F2E0
      CE00F3C29200F3C29200EEB78200E8A76B00DE8E4700ECB47E00F5E6D700C559
      0A00BD4D0100C25002006428150000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF00000000000000000000AC571100E5B58300F6E5
      D300F4DFC900E7B98A00DC9E5F00D58D4500D0813100E8BC8F00CB741D00C968
      0600C9660100C7630100854322000000000000000000B85D0C00E0944700FBE4
      E600FBE4E600F5CEA600F4CBA100EEB77D00E6A15A00E1974D00DA842E00D173
      1400CF6A0400A353170070392E000000000000000000A4430500D4782C00F2E0
      CE00F2E0CE00F3BE8B00F3BE8B00E6A16100DE8E4700D7803600CF6D1F00C559
      0A00C25002008E3A0A0056241B0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000AC571100E7B9
      8A00F4DFC900F6E5D300EECFAF00E7B98A00E2AD7700DC9E5F00D58D4500CB70
      1500C76301008E471E0000000000000000000000000000000000B25B1000E094
      4700F5D0AA00FBECE500F5D0AA00F4CA9D00F0BC8500EBB07400E49C5300D77F
      2600A85615007C3F2800000000000000000000000000000000009E410700D478
      2C00F3C29200F2E0CE00F3C29200F0BA8600EAAB7000E39C5B00DA874000CA63
      1400933C0900642815000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF000000000000000000000000000000000000AC57
      1100B25B1000E8BC8F00ECCAA700ECCAA700E8BC8F00DEA26500CE7B2800B25B
      100088442100000000000000000000000000000000000000000000000000B85D
      0C00CE6F1100E8A56100E8BE9300F2CAA100ECC29600E9AA6A00D57B2100984E
      1C007C3F2800000000000000000000000000000000000000000000000000A443
      0500C1550700DA874000EBB07800F0BC8900E9B17B00E1965400C86011007C33
      0E0064281500000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      000000000000AC571100B25B1000B25B1000B25B1000B25B10009A4E18000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AF591100B45C1000B45C1000AC581300AC581300A35317000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009B4007009E4107009E410700973E0800973E08008C390A000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE00128EBB000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F000000000000000000000000007F7F7F00FFFF
      FF0000000000FFFFFF007F7F7F00FFFFFF0000000000FFFFFF007F7F7F00FFFF
      FF0000000000FFFFFF007F7F7F00FFFFFF00000000000000000097433F009743
      3F00C2999900C2999900C2999900C2999900C2999900C2999900C29999009230
      2F0097433F000000000000000000000000000000000000000000078DBE0059C1
      EA00078DBE0096F1FB0060CBEF0064CEF10064CEF10064CEF10064CEF10064CE
      F1005ECAEE0059C1EA0088E8F800078DBE0000000000000000007F7F7F000000
      00007F7F7F00000000007F7F7F00000000007F7F7F00000000007F7F7F000000
      00007F7F7F00000000007F7F7F000000000000000000FFFFFF007F7F7F00FFFF
      FF007F7F7F00FFFFFF007F7F7F00FFFFFF007F7F7F00FFFFFF007F7F7F00FFFF
      FF007F7F7F00FFFFFF007F7F7F00FFFFFF000000000097433F00CD666600C663
      6300E4E0E400922B2B00922B2B00E6E5E700E5E3E500E4E0E400CECACC00922B
      2B009E43410097433F0000000000000000000000000000000000078DBE0059C1
      EA00078DBE00A1F7FC006ED5F50071D7F60071D7F60071D7F60071D7F60073D8
      F7006BD3F30059C1EA008FEAF700078DBE007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000097433F00CD656600C162
      6200E5E3E500922B2B00922B2B00E4E0E400E6E5E700E4E0E400CECBCC00922B
      2B009E43410097433F00000000000000000000000000078DBE00078DBE0059C4
      EA00078DBE00A8FAFE0078DCF8007BDEF8007BDEF8007BDEF8007DE0F9007DE0
      F90075DBF70059C4EA008FEAF700078DBE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000097433F00CD656600C162
      6200E5E3E500922B2B00922B2B00E4E0E400E6E5E700E6E5E700CECBCC00922B
      2B009E43410097433F000000000000000000078DBE0059C1EA00078DBE005ECA
      EE00078DBE00AAFAFE007FE2F90083E5F90083E5F90083E5F90083E5F90085E7
      F9007FE2F9005BC7EC008FEAF700078DBE00000000007F7F7F00000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF00000000007F7F7F007F7F7F007F7F
      7F007F7F7F0000000000FFFFFF00000000000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F000000000097433F00CD656600C162
      6200E6E5E700E6E5E700E4E0E400E4E0E400E4E0E400E4E0E400CECBCC00922B
      2B009E43410097433F000000000000000000078DBE0059C1EA00078DBE0062CD
      EF00078DBE00BFFCFE00BBFBFE00BBFBFE00BEFCFE00BBFBFE00BBFBFE00BFFC
      FE00B6FAFD008FEAF700B6EBEC00078DBE000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000FFFFFF007F7F7F00FFFF
      FF00FFFFFF007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF007F7F7F00FFFFFF00FFFFFF000000000097433F00CD656600C663
      6300C8676700C6717000C6717000C86A6A00C4636300C86C6C00CA666600C463
      6300CD65660097433F000000000000000000078DBE0059C4EA00078DBE006ED5
      F500078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F000000FF007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F000000FF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000097433F00B8646400C47C
      7B00C89E9E00CAA8A800CAA8A800CAA8A800C9A0A000C9A0A000CAA8A800CAA8
      A800CC66660097433F000000000000000000078DBE005ECAEE00078DBE0092EE
      F90092EEF90092EEF90092EEF90092EEF90092EEF90092EEF90092EEF90092EE
      F90092EEF900078DBE0000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      00000000FF0000000000000000000000000000000000000000007F7F7F00FFFF
      FF0000000000000000007F7F7F0000000000FFFFFF0000000000000000000000
      00007F7F7F000000000000000000000000000000000097433F00CC666600F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800CC66660097433F000000000000000000078DBE0062CDEF00078DBE00BFFC
      FE00ADFCFE00ADFCFE00ADFCFE00AFFDFE00AFFDFE00AFFDFE00AFFDFE00B2FD
      FE00A6F9FE00078DBE000000000000000000000000007F7F7F00000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      FF0000000000000000000000000000000000000000007F7F7F007F7F7F00FFFF
      FF000000000000000000000000007F7F7F0000000000FFFFFF00FFFFFF007F7F
      7F00000000000000000000000000000000000000000097433F00CC666600F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800CC66660097433F000000000000000000078DBE006ED5F500078DBE00078D
      BE00BFFCFE00A1F7FC00AFFDFE0062CDEF00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      00000000000000000000000000000000000000000000FFFFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000097433F00CC666600F8F8
      F800CDCBCC00CDCBCC00CDCBCC00CDCBCC00CDCBCC00CDCBCC00CDCBCC00F8F8
      F800CC66660097433F000000000000000000078DBE0092EEF90092EEF90092EE
      F900078DBE00078DBE00078DBE00078DBE0092EEF90092EEF90092EEF900078D
      BE00000000000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000097433F00CC666600F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800CC66660097433F000000000000000000078DBE00BFFCFE00ADFCFE00ADFC
      FE00ADFCFE00AFFDFE00AFFDFE00AFFDFE00AFFDFE00B2FDFE00A6F9FE00078D
      BE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000097433F00CC666600F8F8
      F800CDCBCC00CDCBCC00CDCBCC00CDCBCC00CDCBCC00CDCBCC00CDCBCC00F8F8
      F800CC66660097433F00000000000000000000000000078DBE00BFFCFE00A1F7
      FC00AFFDFE0062CDEF00078DBE00078DBE00078DBE00078DBE00078DBE000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F007F7F7F00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000097433F00CC666600F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800CC66660097433F0000000000000000000000000000000000078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF007F7F7F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000097433F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F80097433F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000000000000000000000000
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
      0000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000CC670100CC670100CC67
      0100CC670100CC670100CC670100CC670100CC670100CC670100CC670100CC67
      0100CC670100CC670100CC670100CC67010000000000B68A7F00A5787300A578
      7300A5787300A5787300A5787300A5787300A5787300A5787300A5787300A578
      7300A5787300986C670000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF007F7F7F0000000000CC670100FEFEFE00FEFE
      FE00FEF9F400FEF5EA00FEE9D100FEE3C400FDDCB600FDDAB200FDDAB200FDDA
      B200FDDAB200FDDAB200FDDAB200CC67010000000000B68A7F00FBF6F100E6E0
      EC00F0D1A600F0D1A600F0D1A600F0D1A600EFCFA400EDCCA100EDCCA100EDCC
      A100F0D1A600986C670000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00000000007F7F7F007F7F7F00FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000FFFFFF007F7F
      7F007F7F7F007F7F7F00000000007F7F7F0000000000CC670100FEFEFE00FEFE
      FE00FEFEFE00FEF9F400FEF5EA00FEE9D100FEE3C400FDDCB600FDDAB200FDDA
      B200FDDAB200FDDAB200FDDAB200CC67010000000000B4837800FBF6F1009833
      000098330000983300009833000098330000983300009833000098330000EDCC
      A100F0D1A600986C67000000000000000000FFFF00000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000FFFFFF00FFFFFF007F7F7F00FFFFFF00FFFF
      FF000000000000000000FFFFFF007F7F7F0000000000CC670100FEFEFE004472
      F4004472F4004472F400FEF9F400AE4B0800AE4B0800AE4B0800FDDCB6001094
      D4001094D4001094D400FDDAB200CC67010000000000B4837800FCF7F1009833
      0000FEFDFC00FEFDFC00FEFDFC008D90DF00E1C6EE00FEFDFC0098330000EECD
      A200F0D1A600986C67000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00000000007F7F7F007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000FFFFFF007F7F7F00000000007F7F7F0000000000CC670100FEFEFE004472
      F4004472F4004472F400FEFEFE00AE4B0800AE4B0800AE4B0800FEE3C4001094
      D4001094D4001094D400FDDAB200CC67010000000000BF948400FEFCFA009833
      0000FEFDFC00FEFDFC008082EA000735FA00576CF900FEFDFC0098330000EFCF
      A400F0D1A600986C67000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000007F7F7F007F7F7F00FFFFFF000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F000000000000000000FFFFFF007F7F7F0000000000CC670100FEFEFE004472
      F4004472F4004472F400FEFEFE00AE4B0800AE4B0800AE4B0800FEE9D1001094
      D4001094D4001094D400FDDAB200CC67010000000000BF948400FEFDFC009833
      0000E6E0EC004F64F9000735FA004F64F9000936FB00E6E0EC0098330000F0D1
      A600F0D1A600986C67000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00000000007F7F7F007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000FFFFFF007F7F7F00000000007F7F7F0000000000CC670100FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEF9F400FEF5EA00FEE9
      D100FEE3C400FDDCB600FDDAB200CC67010000000000CC9A8100FEFDFC009833
      0000576CF9001137FB00E1C6EE00F2F1F7001938FA00576CF90097330200F0D1
      A600F0D1A600986C67000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000007F7F7F007F7F7F00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007F7F
      7F000000000000000000FFFFFF007F7F7F0000000000CC670100FEFEFE00C999
      9800C9999800C9999800FEFEFE00D8740200D8740200D8740200FEF9F4001894
      02001894020018940200FDDCB600CC67010000000000CC9A8100FEFDFC009833
      0000ECEAF400E6E0EC00FEFDFC00FEFDFC0099A2C3000735FA00675B5900F0D1
      A600F0D1A600986C67000000000000000000FFFF000000000000FFFFFF0000FF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00000000007F7F7F007F7F7F00FFFFFF00FFFF
      FF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000007F7F7F00000000007F7F7F0000000000CC670100FEFEFE00C999
      9800C9999800C9999800FEFEFE00D8740200D8740200D8740200FEFEFE001894
      02001894020018940200FEE3C400CC67010000000000DBA98400FEFDFC009833
      0000FEFDFC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00576CF9000735FA00F0D1
      A600F0D1A600986C67000000000000000000000000000000000000000000FFFF
      FF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007F7F7F007F7F7F007F7F7F000000
      0000FFFFFF007F7F7F00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000007F7F7F0000000000CC670100FEFEFE00C999
      9800C9999800C9999800FEFEFE00D8740200D8740200D8740200FEFEFE001894
      02001894020018940200FEE9D100CC67010000000000DBA98400FEFDFC009833
      000098330000983300009833000098330000983300008F330E001C35F8000735
      FA00E3BF9A00986C670000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF007F7F7F0000000000CC670100FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEF9F400FEF5EA00CC67010000000000DFB08C00FEFDFC00FEFD
      FC00FEFDFC00FEFDFC00FEFDFC00FCF9F500FBF6F100E6E0EC00B48378000735
      FA000735FA000735FA0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF007F7F7F007F7F7F007F7F7F00000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F0000000000CC670100CC670100CC67
      0100CC670100CC670100CC670100CC670100CC670100CC670100CC670100CC67
      0100CC670100CC670100CC670100CC67010000000000DFB08C00FEFDFC00FEFD
      FC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00FEFDFB00E4D7EA00B4837800DFB0
      8C00DBA984000735FA0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F00FFFFFF00000000007F7F7F000000000000000000CC670100CC67
      0100CC670100CC670100CC670100CC670100CC670100CC670100CC670100CC67
      0100CC670100CC670100CC6701000000000000000000E6BD9700FEFDFC00FEFD
      FC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00E4D7EA00B4837800ECC7
      9C00C5927E000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F00FFFFFF007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E6BD9700FCF7F100FCF7
      F100FAF6F300FAF6F300FAF6F300FAF6F300FAF6F300E4D7EA00B4837800CC9A
      8100000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E6BD9700D8A68500D8A6
      8500D8A68500D8A68500D8A68500D8A68500D8A68500D8A68500B48378000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      00000000000065383200693A32008242250082422500693A3200673932000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000006640D0006640D0007690F0007690F0006640D0006640D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000066362F006C382E0082422500824225006C382E0066362F000000
      000000000000000000000000000000000000000000000000000000000000693A
      320082422500B0580E00C35F0400CB650200CB650200C5600400B2590D008544
      2400673932000000000000000000000000000000000000000000000000000664
      0D0006640D000A8C170009B0190009B31A0009B31A0009B019000A9717000768
      0E0007680E000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006F39
      2D0080412600B05A1100C3620500CA650100CC660100C3620500B25B10008544
      240068362F00000000000000000000000000000000000000000082422500A754
      1300CF6A0600CF6A0600CD680400CB650200CC660300CD680400CE690400CF6C
      0800A7541300693A32000000000000000000000000000000000007690F00097D
      14000BB41D0009B31A0009B31A0009B0190009B31A0009B31A0009B31A0009B3
      1A00097D140006640D000000000000000000CB660100CB660100CB660100CB66
      0100CB660100CB660100CB660100CB660100CB660100CB660100CB660100CB66
      0100CB660100CB660100CB660100CB66010000000000000000007B3F2800A957
      1400CD670100CD670200CD670200CA650100CD670100CD670100CD670100CD67
      0100A755150068362F0000000000000000000000000082422500B0580E00CF6A
      0600CA640200CD680400CD680400CB650200CA640200CA640200CB650200CC66
      0300CF6A0600A754130065383200000000000000000007690F000A8C170016B3
      2D0012B327000BB41D0009B0190009B0190009B0190009B0190009B0190009B3
      1A0009B31A00097D140006650D0000000000CB660100FEFCF800FEFCF800FEFB
      F700FEFAF400FEF8EF00FEF6EB00FEF4E600FEF2E200FEF1E000FEEEDA00FEEC
      D600FEEAD100FEE7CF00FEE7CF00CB6601000000000082422500B05A1100CD67
      0100CA650100CD6A0900CD6A0900CA650100CA650100CC660100CC660100CC66
      0100CD670100A957140066362F000000000000000000984D1B00CF6A0600CF6A
      0600CF6D0A00CF6D0A00CB650200CB650200CF6F0E00CF6D0A00C9630200CB65
      0200CC660300CF6A060082422500000000000000000007690F0025B5490023B5
      440016B32D000BB41D001EB13600DDF6E700ECFAF1005BCE800009B0190009B0
      190009B31A0009B31A0006650D0000000000CB660100FEFCF800FEFCF800FEFC
      F700FEFAF400FEF8EF00FEF7ED00FEF5E900FEF3E400FEF1E000FEEEDA00FEEC
      D600FEEAD200FEE9D000FEE7CF00CB66010000000000994E1C00CD670200CD6A
      0900CC660100F7D8B700E7A76500CC690800CE6B0900CA650100E19A5300D383
      3200CC660100CD6701008242250000000000AA561100C05E0500CF711200E49E
      5700F5EAE000D98B3F00C7600300C7600300E8AD7300F5EAE000E5A96C00C963
      0200CB650200CE690400B55A0C00693A32000872120020B03B002EBC5C0023B5
      44000EB421000AB41B000EB4210098E0AF00FBFDFC00F6FCF80055CC7B0009B0
      190009B0190009B31A000A97170006640D00CB660100FEFCF800FEFCF800FEFC
      F800FEFAF400FEF9F100FEF7ED00FEF5E900FEF3E400FEF1E000FEEFDC00FEED
      D700FEEBD400FEEAD100FEE9CF00CB660100A9571400C0610600D0721400D278
      1C00D0721400FEFDFC00F0C19100CC690800CE6C0A00ECB37800FDF7F000DF92
      4E00CC660100CD670100B45C0E0068362F00B0580E00CB731B00D0823600E8AD
      7300FEFEFE00FEFEFE00DD924700C7600300E8AD7300FEFEFE00FEFDFC00F1C3
      9500CD721500CD680400C5600400693A3200087212002CBA590033C0640027B7
      4E000EB4210009B31A000BB41D0009B019008DDDA500FBFDFC00F6FCF80055CC
      7B0009B0190009B31A0009AD190006640D00CB66010099340000993400009934
      0000006500009934000099340000993400009934000099340000006500009934
      0000993400009934000099340000CB660100B05A1100D2781C00D6832F00D383
      3200D6822D00FEFDFC00EFBE8B00D2781C00F1C59800FEFDFC00FEFDFC00DE94
      4B00CA650100CD670100C563040068362F00B55A0C00D98B3F00E1984D00F1C3
      9500FEFEFE00FEFEFE00FEFEFE00F3D5B800F3E1CE00FEFCFB00FEFEFE00FEFE
      FE00F3D5B800CB650200CC660300693A3200097D140039C36B0039C36B00CEF1
      DB00C9EFD600C9EFD600C9EFD600C0EDCF00C0EDCF00F9FDFA00FBFDFC00F0FA
      F3006DD38F0009B31A0009B31A0006650D00CB660100FEFCF800FEFBF7000065
      000000650000FEF7ED00FEF5E90000006D00FEF0DF00FEEEDA00006500000065
      0000FEE9CF00FEE7CF00FEE7CF00CB660100B45C0E00DE944B00E19A5300E19A
      5300DE944B00FEFDFC00F0C39400FBE6D000FEFDFC00FEFDFC00FEFBF900DE94
      4B00CE6B0900CA650100CD6702006C382E00B95D0900E6A25D00E8AB6C00F2C9
      9F00FEFEFE00FEFEFE00FEFEFE00F3D5B800F5EAE000FEFCFB00FEFEFE00FEFE
      FD00F3D4B500CB650200CC660300693A32000A8C17005BCE800047C87500FBFD
      FC00FBFDFC00FBFDFC00FBFDFC00FBFDFC00FBFDFC00FBFDFC00FBFDFC00FBFD
      FC00B9EBC9000AB41B0009B31A0007690F00CB660100FEFCF800006500008988
      6D0000650000FEF7ED00FEF5E90000006D00FEF1E000FEEFDC0000650000828D
      7B0000650000FEE7CF00FEE7CF00CB660100B95E0A00E6A36000ECB37800E8A9
      6800E6A36000FEFDFC00F3CA9F00FBE9D600FEFDFC00FEFDFC00FEFBF900DE94
      4B00CC690800CA650100CD670200743B2B00B2590D00E7A86700F1C39500F2CF
      AB00FEFEFE00FEFEFE00E8AD7300D98B3F00F1C39500FEFEFE00FEFDFB00F1C3
      9500CF6F0E00CD680400C5600400673932000A8C17006DD38F0067D18B006DD3
      8F0075D6940075D6940075D6940067D18B008DDDA500FBFDFB00FBFDFC00A3E4
      B80027B74E0012B3270009B0190006640D00CB660100FEFCF800FEFCF8000065
      000000650000FEF8EF00FEF5E90000006D00FEF2E200FEF0DF00006500000065
      0000FEE9D000FEE7CF00FEE7CF00CB660100B05A1100E8A96800F5CCA100EFB8
      7F00ECB37800FEFDFC00F6D2AC00E29D5700F6D0A900FEFDFC00FEFDFC00DE94
      4B00CA650100CD670100C563040068362F00B55A0C00E1984D00F3D1B000F3D1
      B000F9F6F400F1C39500D98B3F00D98B3F00F2CAA100F7F1EC00E8AD7300CA64
      0200CA640200CF6A0600B2590D00693A32000A8C170060CF8400A3E4B8003DC4
      6E0036C268003DC46E003DC46E0075D69400E6F8ED00FBFDFC0098E0AF0025B5
      490022B13D0012B327000AA3180006640D00CB66010099340000993400009934
      0000006500009934000099340000993400009934000099340000006500009934
      0000993400009934000099340000CB660100B45C0E00E0985000F8DBBD00F5CC
      A100EFBB8400FEFDFC00F8DBBD00E6A36000E19A5300F0C39400FDF7F000E098
      5000CC670200CD670100B25B100068362F0000000000CB731B00F2CAA100F3D8
      BD00F2C99F00F2C69900E8AC6F00E6A25D00E6A46000E1984D00CD721500CF6D
      0A00CD680400CF6A060082422500000000000000000020B03B00C0EDCF0085DA
      A00033C0640036C2680055CC7B00F7FBF900FBFDFC0098E0AF0025B5490023B5
      440019B2310016B32D000A8C170000000000CB660100FEFCF800FEFCF800FEFC
      F700FEFAF400FEF9F100FEF6EB00FEF5E900FEF3E400FEF1E000FEEEDA00FEED
      D700FEEAD200FEE9D000FEE7CF00CB66010000000000D0751900F6CFA700FAE3
      CA00F5CCA100FDF7F000F9DFC400EFBB8400E7A76500DF954B00EFBC8800DE94
      4B00CB680600CD6701007D4027000000000000000000B65B0B00DD924700F2DA
      C000F2DAC000F1C39500F1C39500E7A66400E1984D00D98B3F00C6772800CF71
      1200CF6C0800A5531500693A3200000000000000000020B03B006DD38F00D3F3
      E00085DAA00039C36B003DC46E00C0EDCF00ADE7C00033C0640029B9550027B7
      4E0023B5440019B231000A8C170000000000CB660100FEFCF800FEFCF800FEFC
      F700FEFAF400FEF9F100FEF6EB00FEF5E900FEF3E400FEF1E000FEEFDC00FEED
      D700FEEBD400FEE9CF00FEE7CF00CB66010000000000B75D0C00DE944B00F9DF
      C400FBE6D000F6CFA700F5CCA100EEB67C00E6A36000DF954B00D4833100D072
      1400CF6D0C00A45316006F392D00000000000000000000000000B2590D00DD92
      4700F3D1B000F3DBC300F2CDA600F1C39500E8AD7300E7A66400E1984D00CB73
      1B00A7541300824225000000000000000000000000000000000020B03B0085DA
      A000DDF6E700ADE7C0006DD38F0055CC7B0047C875004DCA78004DCA780039C3
      6B0025B54900097D14000000000000000000CB660100FEFCF800FEFCF800FEFB
      F700FEFBF600FEF9F100FEF7ED00FEF5E900FEF3E400FEF0DF00FEEFDC00FEED
      D700FEEBD400FEE9D000FEE7CF00CB6601000000000000000000B45C0E00DE94
      4B00F7D8B700FBE6D000F8DBBD00F3CA9F00EFBC8800EBB07200E29D5700D47B
      2100A75515007B3F28000000000000000000000000000000000000000000B65B
      0B00BD6E2900DEA26500F1C39500F1C79D00F1C39500DEA26500BE7D3A00954E
      22008242250000000000000000000000000000000000000000000000000020B0
      3B0020B03B00ADE7C000D0F2DD00C0EDCF00ADE7C00098E0AF006DD38F002CBA
      59002CBA5900000000000000000000000000CB660100CB660100CB660100CB66
      0100CB660100CB660100CB660100CB660100CB660100CB660100CB660100CB66
      0100CB660100CB660100CB660100CB660100000000000000000000000000B75D
      0C00D0751900E4A05B00F0C19100F3CA9F00F0C39400E7A76500CA823A00994E
      1C007B3F28000000000000000000000000000000000000000000000000000000
      000000000000B0580E00B4662500B4662500AB5F2300AD571000A55315000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000027B74E0020B03B0020B03B0020B03B0020B03B0023B342000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B05A1100B25B1100B25B1100A9571400AC581200A35316000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006E3931006E382F0082422500824225006E382F006E3931000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008E8E8E008E8E
      8E00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD008686
      86008E8E8E00000000000000000000000000BC4C0000BC4C0000BC4C0000BC4C
      0000BC4C0000BC4C0000BC4C0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000723A
      2D007F402600AF591100C2610600CB660100CB660100C4620400B15A10008242
      25006E393100000000000000000000000000CB670100CB670100CB670100CB67
      0100CB670100CB670100CB670100CB670100CB670100CB670100CB670100CB67
      0100CB670100CB670100CB670100CB670100000000008E8E8E00B7B7B700B1B1
      B100EDEDED008383830083838300F0F0F000EEEEEE00E8E8E800D9D9D9007E7E
      7E00929292008E8E8E000000000000000000FEF9F200FEF7ED00FEF0E000FEE9
      D100FEE3C500FEE0C600BC4C0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007C3F2800A855
      1400D0690300D0690300CE680200CA650100CD670100CD670100D0690300D069
      0300A85514006E3931000000000000000000CB670100FEF6EC00FEF4E700FEF3
      E500FEF1E00099340000FEEED90000009700FEEBD30099340000FEE9CE00FEE9
      CE00FEE9CE00FEE9CE00FEE9CE00CB670100000000008E8E8E00B5B5B500B1B1
      B100F0F0F0008383830083838300EDEDED00F0F0F000EDEDED00DCDCDC007F7F
      7F00929292008E8E8E000000000000000000FEF9F200FEF9F200FEF3E500FEEC
      D900FEE6CD00FEE0C600BC4C0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000082422500AF591100D069
      0300CA650100CF711500E7BF9500DD8C3A00C7620300CA650100CB660100CB66
      0100D0690300A85514006E39310000000000CB670100FEF7EE00FEF6EC00FEF4
      E700FEF3E50099340000FEEFDB0000009700FEEDD60099340000FEE9CE00FEE9
      CE00FEE9CE00FEE9CE00FEE9CE00CB670100000000008E8E8E00B5B5B500B1B1
      B100F3F3F3008383830083838300EAEAEA00EEEEEE00EEEEEE00E0E0E0007C7C
      7C00929292008E8E8E000000000000000000FEF9F200FEF9F200FEF7ED00FEF0
      E000FEEAD300FEE3C500BC4C0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000974D1C00D0690300CE68
      0200CA650100CF6E0F00F8E5D200FCF2E900DE924500C7620300CA650100CB66
      0100CB660100D06903008242250000000000CB670100FEF8F000FEF7EE00FEF5
      E900FEF4E70099340000FEF0DE0000009700FEEED90099340000FEEAD100FEEA
      CF00FEE9CE00FEE9CE00FEE9CE00CB670100000000008E8E8E00B5B5B500B1B1
      B100F3F3F300F3F3F300EDEDED00EAEAEA00EDEDED00EDEDED00E0E0E0008585
      8500929292008E8E8E000000000000000000811E0100811E0100811E0100811E
      0100811E0100811E0100BC4C0000000000000000000000000000000000000000
      000000000000000000000000000000000000A8551400BF600800D06D0B00D072
      1700CF701300D2751900F6E0C900FEFDFD00FDF6F000E3A56700CA650100C964
      0200CB660100D0690300B35B0E006E393100CB670100FEFAF400FEF8F0000065
      0000FEF5E90099340000FEF2E20000009700FEEED90099340000FEEBD3000065
      0000FEEACF00FEE9CE00FEE9CE00CB670100000000008E8E8E00B1B1B100B1B1
      B100B2B2B200B7B7B700B6B6B600B1B1B100B1B1B100B5B5B500B2B2B200B1B1
      B100B3B3B3008E8E8E0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000014A000000000000BC4C0000811E
      0100811E0100811E0100811E0100811E0100AF591100D2751900D67E2600D984
      2D00D9842D00D9842D00F7E2CC00FEFDFD00FEFDFD00FEFDFD00E7BF9500CF6E
      0F00C9640200CE680200C46204006E393100CB670100FEFBF500006500000065
      0000FEF6EC0099340000FEF3E50000009700FEF0DE0099340000FEEDD6000065
      000000650000FEE9CE00FEE9CE00CB670100000000008E8E8E00B1B1B100B6B6
      B600CBCBCB00D0D0D000D0D0D000D0D0D000D0D0D000CBCBCB00D0D0D000D6D6
      D600B3B3B3008E8E8E0000000000000000000000000000000000000000000000
      0000000000000000000000000000014A0000014A000000000000BC4C0000FEF7
      ED00FEF0E000FEE9D100FEE3C500FEE0C600B55D0E00DD8A3700DE924500DD8F
      4000DD8F4000DE924500F8E5D200FEFDFD00FEFDFD00FEFDFD00FEFDFD00F5D8
      BC00D0721700CA650100CD6701006E382F00CB67010000650000908869000065
      00000065000000650000FEF4E70000009700FEF1E00000650000006500000065
      00008C8A780000650000FEE9CE00CB670100000000008E8E8E00B3B3B300FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00B3B3B3008E8E8E0000000000000000000000000000000000000000000000
      00000000000000000000014A00008A705E00014A000000000000BC4C0000FEF9
      F200FEF3E500FEECD900FEE6CD00FEE0C600B85E0C00E4A25F00E3A56700E49F
      5900E49F5900E49F5900F9E9D900FEFDFD00FEFDFD00FEFDFD00FEFDFD00F1CD
      A900CF711500CA650100CD670100723A2D00CB670100FEFBF700006500000065
      0000FEF9F20099340000FEF6EC0000009700FEF3E50099340000FEF0DE000065
      000000650000FEEAD100FEEACF00CB670100000000008E8E8E00B3B3B300FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00B3B3B3008E8E8E0000000000000000000000000000000000000000000000
      0000000000000000000000000000014A0000014A000000000000BC4C0000FEF9
      F200FEF7ED00FEF0E000FEEAD300FEE3C500B15A1000E3A56700F0CBA500E3A5
      6700E3A56700E3A56700FAECDD00FEFDFD00FEFDFD00FEFDFD00EDBE8D00C762
      0300C9640200CE680200C46204006E393100CB670100FEFBF700FEFBF7000065
      0000FEFBF50099340000FEF7EE0000009700FEF4E70099340000FEF0DE000065
      0000FEEDD800FEEBD300FEEAD100CB670100000000008E8E8E00B3B3B300FEFE
      FE00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00FEFE
      FE00B3B3B3008E8E8E0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000014A000000000000BC4C0000811E
      0100811E0100811E0100811E0100811E0100B55D0E00E0974D00F6DCC300F1CD
      A900EEBE8D00EEBE8D00FBEEE100FEFDFD00FCF2E900E3A56700CF6A0400CA65
      0100CB660100D0690300B15A10006E393100CB670100FEFBF700FEFBF700FEFB
      F700FEFBF60099340000FEF8F00000009700FEF5E90099340000FEF2E200FEF0
      DE00FEEFDB00FEEDD600FEEBD300CB670100000000008E8E8E00B3B3B300FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00B3B3B3008E8E8E000000000000000000811E0100811E0100811E0100811E
      0100811E0100811E0100BC4C0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CF711500F1CDA900FBEE
      E100F3D4B300EEBF8E00FCF2E900FBEFE300E4A25F00D57A2000D2751900CB66
      0100CA650100D06903007F40260000000000CB670100FEFBF700FEFBF700FEFB
      F700FEFBF70099340000FEF9F20000009700FEF6EC0099340000FEF3E500FEF1
      E000FEF0DE00FEEED900FEEDD600CB670100000000008E8E8E00B3B3B300FEFE
      FE00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDCDC00FEFE
      FE00B3B3B3008E8E8E000000000000000000FEF9F200FEF7ED00FEF0E000FEE9
      D100FEE3C500FEE0C600BC4C0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B85E0C00DE924500F7E2
      CC00FBF1E600F4D6B700F5D8BC00E3A56700DC893500D9842D00D2751900D06B
      0700D0690300A252160070392E0000000000CB670100FEFBF700FEFBF700FEFB
      F700FEFBF70099340000FEFAF40000009700FEF7EE0099340000FEF4E700FEF3
      E500FEF1E000FEF0DE00FEEED900CB670100000000008E8E8E00B3B3B300FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00B3B3B3008E8E8E000000000000000000FEF9F200FEF9F200FEF3E500FEEC
      D900FEE6CD00FEE0C600BC4C0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B35B0E00DE92
      4500F4D6B700FBEEE100F7E2CC00F0CBA500EDBE8D00E3A56700E29C5400D57A
      2000A45315007C3F28000000000000000000CB670100CB670100CB670100CB67
      0100CB670100CB670100CB670100CB670100CB670100CB670100CB670100CB67
      0100CB670100CB670100CB670100CB67010000000000000000008E8E8E00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFE
      FE008E8E8E00000000000000000000000000FEF9F200FEF9F200FEF7ED00FEF0
      E000FEEAD300FEE3C500BC4C0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B35B
      0E00CF711500DAA16700EABE9200F0CBA500EEC29400E0A46700D67E2600974D
      1C007C3F28000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BC4C0000BC4C0000BC4C0000BC4C
      0000BC4C0000BC4C0000BC4C0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AF591100B55D0E00B15A1000A8551400AC581200A45315000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000064707A00BF9E96000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000064707A00BCA2A3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF008080800080808000808080008080800080808000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000078DBE001A9DAA005EC7EB0084E1
      FA0066CDF20066CDF20066CDF20066CDF20066CDF20066CDF20066CDF20066CD
      F20046B8D400078DBE00000000000000000063A8F1003879F40060758800C59D
      9500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006D8EC9001D55F30060758800C6A4
      9F00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000FFFFFF00FFFFFF000000000000000000078DBE004BBBDD0046B8D4009BF1
      FC0072D6F80072D6F8006DD2F60072D6F80072D6F80072D6F80072D6F8006DD2
      F60048B9D90080DEF900078DBE0000000000559FF500559FF5003879F4006075
      8800C59D95000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006FB6F3006FB6F3001D55F3006075
      8800C6A49F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      800080808000FFFFFF0000000000000000000000000000000000808080008080
      800080808000FFFFFF00FFFFFF0000000000078DBE0072D6F800078DBE00ACF7
      FC007BDCFA007BDCFA007BDCFA007BDCFA007BDCFA007BDCFA007BDCFA007BDC
      FA0048B9D900ACF7FC00078DBE000000000000000000559FF500559FF5003879
      F40060758800C59D950000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006FB6F3006FB6F3001D55
      F30060758800CBA69D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      00000000000080808000FFFFFF00000000000000000080808000808080000000
      00008080800080808000FFFFFF0000000000078DBE007BDCFA001396B60099F0
      FC0092EBFB0086E3FB0086E3FB0086E3FB0086E3FB0086E3FB0086E3FB0086E3
      FB0048B9D900B1F7FC00078DBE00000000000000000000000000559FF500559F
      F5003879F40060758800BA9E9600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006FB6F3006FB6
      F3001D55F30060758800BCA2A300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000008080800080808000FFFFFF008080800080808000000000000000
      00000000000080808000FFFFFF00FFFFFF00078DBE0086E3FB0048B9D90058C3
      E700ACF7FC008FE9FB008FE9FB008FE9FB008FE9FB008FE9FB008FE9FB000C84
      18004BBBDD00B6F7FD0066CDF200078DBE00000000000000000000000000559F
      F500559FF5003879F400656F7700000000009F928D00C59F9700D3B5A900CFAA
      9F00000000000000000000000000000000000000000000000000000000006FB6
      F3006FB6F3006A93D500656F77000000000089878900C6A49F00D3B4A800CDA6
      9D00000000000000000000000000000000008080800080808000FFFFFF000000
      0000000000000000000080808000FFFFFF008080800000000000000000000000
      0000000000008080800080808000FFFFFF00078DBE008CE7FB0077DAF9001A9D
      AA00D8F7FB00CAF6FD00CAF6FD00CAF6FD00CAF6FD00CAF6FD000C84180035BC
      73000C841800D8F7FB00D6F6FB00078DBE000000000000000000000000000000
      0000559FF500D0D0D1009F928D00AD9A9200FAEFC800FDF9DA00FDF9DA00FDF9
      DA00F4D6B200D1ADA10000000000000000000000000000000000000000000000
      00006FB6F3009EBBE10089878900BCA2A300EDE7D300FAF4D400FAF4D400FAF4
      D400E2DACC00D2AEA20000000000000000008080800080808000FFFFFF000000
      0000000000000000000000000000808080000000000000000000000000000000
      000000000000000000008080800000000000078DBE0095EEFC0095EEFC001396
      B600078DBE00078DBE00078DBE00078DBE00078DBE000C84180046CC80004BCC
      98003DC374000C841800078DBE00078DBE000000000000000000000000000000
      000000000000CFBDB700D6B9AB00FBEDC400FCF8D700FDF9DA00FDF9DA00FDFA
      DF00FDFAE300F4F1DF00B49C9500000000000000000000000000000000000000
      000000000000D5B9AD00D5B9AD00FCEFC500FAF4D4009EBBE10066A3E700EDE7
      D300F9F5DB00F6F2D90089878900000000008080800080808000FFFFFF000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      000000000000000000000000000000000000078DBE009EF4FD009FF6FD009FF6
      FD009EF4FD009FF6FD009FF6FD009EF4FD000C84180046CC800049CD890049CD
      89004BCC98003DC374000C841800000000000000000000000000000000000000
      000000000000C59D9500F7E0B200F8E2B200FCF6D400FDF9DA00FDF9E100FDFA
      E300FDFAE300FDFAE300F2D0B400000000000000000000000000000000000000
      000000000000C6A49F00FCE6C200FCE6C200FCF4CB0088B9EC000734FB00DDD5
      CC00F9F5DB00F9F5DB00D8CCC500000000008080800080808000FFFFFF000000
      0000000000008080800080808000FFFFFF0080808000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00078DBE00D8F7FB00A2F7FD00A2F7
      FD00A2F7FD00A2F7FD00A2F7FD000C8418000C8418000C8418000C84180049CD
      890046CC80000C8418000C8418000C8418000000000000000000000000000000
      000000000000D6B9AB00F8E2B200AD9A920063A8F1004584F3004584F3004584
      F3005DA2F200DFE0D700FBF4D100C79F96000000000000000000000000000000
      000000000000D5B9AD00FCECC100B6A9B3006998D8003849F5000734FB0066A3
      E7007FB9F000E8DFCE00F3EED600C6A49F008080800080808000FFFFFF00FFFF
      FF00000000008080800000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000FFFFFF0000000000078DBE00D8F7FB00A5F7
      FC00A5F7FC00A5F7FC00078DBB0048B9D90048B9D90048B9D9000C84180046CC
      800035BC73000C84180000000000000000000000000000000000000000000000
      000000000000F2C9B400F8E2B200356DF7002749FC002749FC002749FC002749
      FC002749FC00CBC8CC00FCF8D700CDA59A000000000000000000000000000000
      000000000000D7BFB200FCECC1006C91D0000734FB000734FB000734FB000734
      FB000734FB009EBBE100FAF4D400C6A49F00000000008080800000000000FFFF
      FF00808080000000000000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000FFFFFF000000000000000000078DBE00078D
      BE00078DBE00078DBE00000000000000000000000000000000000C8418003FC6
      79000C8418000000000000000000000000000000000000000000000000000000
      000000000000D6B9AB00F9E5B700CEA79C00D1B0A50063A8F10063A8F10063A8
      F100D0D0D100F0EFDE00FBF4D100CBA297000000000000000000000000000000
      000000000000D7BFB200FCECC100CEA79D00B6A9B30064A1E2000734FB0096BB
      E600DAD1CB00F6F2D900F6F2D900C6A49F000000000080808000808080000000
      0000FFFFFF00FFFFFF000000000000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000C84180030B8720030B8
      72000C8418000000000000000000000000000000000000000000000000000000
      000000000000C79F9600FBEDC400FBEDC400F4D6B200F2D0B400F9E5B700FCF6
      D400FCF6D400FDF9DA00F4D9B100000000000000000000000000000000000000
      000000000000CBA69D00FCEFC500FCECC100FCE6C2006F88C1000734FB00DAD1
      CB00FAF4D400F9F5DB00E2DACC00000000000000000000000000808080008080
      800000000000FFFFFF0000000000000000000000000000000000808080008080
      8000808080008080800080808000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000C84180030B872000C84
      1800000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6B9AB00FDFAE300FDFAE300F2C9B400F3BFBB00F2D0
      B400F9E5B700FBF3CD00BF9E9600000000000000000000000000000000000000
      00000000000000000000D7BFB200F9F5DB00F9F5DB00D3B4A800BCA2A300D7BF
      B200FCE6C200FCF4CB00BCA2A300000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000000000000000000080808000000000000000000000000000000000000000
      00000000000000000000000000000C8418000C8418000C8418000C8418000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CDBFBD00F4F1DF00FBEDC400F8E2B200F9E5
      B700F5DDB100D1ADA10000000000000000000000000000000000000000000000
      0000000000000000000000000000D7BFB200F6F2D900FCECC100FCECC100FCEC
      C100FCDBC700D0ABA00000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000C8418000C8418000C8418000C84180000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CBA29700CFAA9F00D6B9AB00D6B9
      AB00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CBA69D00D0ABA000D7BFB200D5B9
      AD00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF008080800080808000808080008080800080808000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF008080800080808000808080008080800080808000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000808080008080
      800080808000FFFFFF0000000000000000000000000000000000808080008080
      800080808000FFFFFF00FFFFFF000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000808080008080
      800080808000FFFFFF0000000000000000000000000000000000808080008080
      800080808000FFFFFF00FFFFFF000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000080808000808080000000
      00000000000080808000FFFFFF00000000000000000080808000808080000000
      00008080800080808000FFFFFF0000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000080808000808080000000
      00000000000080808000FFFFFF00000000000000000080808000808080000000
      00008080800080808000FFFFFF0000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000080808000808080000000
      0000000000008080800080808000FFFFFF008080800080808000000000000000
      00000000000080808000FFFFFF00FFFFFF00000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000080808000808080000000
      0000000000008080800080808000FFFFFF008080800080808000000000000000
      00000000000080808000FFFFFF00FFFFFF00000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000008080800080808000FFFFFF000000
      0000000000000000000080808000FFFFFF008080800000000000000000000000
      0000000000008080800080808000FFFFFF000000FF000000FF00000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000FF000000FF00000000008080800080808000FFFFFF000000
      0000000000000000000080808000FFFFFF008080800000000000000000000000
      0000000000008080800080808000FFFFFF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000008080800080808000FFFFFF000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000FF000000FF00000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000FF000000FF00000000008080800080808000FFFFFF000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000FF000000FF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000FF000000FF00000000008080800080808000FFFFFF000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000FF000000FF00000000000000FF000000FF000000000000000000
      0000000000000000000000000000000000008080800080808000FFFFFF000000
      0000000000000000000080808000FFFFFF0080808000FFFFFF00000000000000
      0000000000000000000000000000000000000000FF000000FF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000008080800080808000FFFFFF000000
      0000000000008080800080808000FFFFFF0080808000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF00000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000FFFFFF000000
      0000000000008080800080808000FFFFFF0080808000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000FFFFFF00FFFF
      FF00000000008080800000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000FFFFFF000000FF000000FF00000000000000
      0000000000000000000000000000FF00000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000008080800080808000FFFFFF00FFFF
      FF00000000008080800000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000FFFFFF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF0000000000000000008080800000000000FFFF
      FF00808080000000000000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000FFFFFF00000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF0000000000000000008080800000000000FFFF
      FF00808080000000000000000000000000000000000080808000FFFFFF008080
      8000808080008080800080808000FFFFFF00000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000080808000808080000000
      0000FFFFFF00FFFFFF000000000000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF00000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000080808000808080000000
      0000FFFFFF00FFFFFF000000000000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF00000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000808080008080
      800000000000FFFFFF0000000000000000000000000000000000808080008080
      8000808080008080800080808000FFFFFF0000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000808080008080
      800000000000FFFFFF0000000000000000000000000000000000808080008080
      8000808080008080800080808000FFFFFF0000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000000000000000000080808000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000808080008080
      8000000000000000000080808000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE000000000000000000000000000000000000000000000000000000
      00000000000000000000CD6C0B00D27010009835000000000000000000000000
      00000000000000000000000000000000000000000000078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000078DBE0025A0CD005FC8EE0083E1
      FB0066CDF40066CDF40066CDF40066CDF40066CDF40066CDF40066CDF40066CD
      F4003AAED8001495C40000000000000000000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE006ED3F500078DBE00A5EF
      FB006ED3F5006ED3F5006ED3F5006ED3F5006ED3F5006ED3F5006ED3F5006ED3
      F5003FB2D300ACF1FC00078DBE00000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000078DBE004CBBE30031A8D30095EC
      FB006ED4F9006ED4F9006ED4F9006ED4F9006ED4F9006ED4F9006ED4F9006ED4
      F9003FB1DB00C8F6FB00078DBE00000000000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE006ED3F500078DBE00A6EF
      FB006ED3F5006ED3F5006ED3F5006ED3F5006ED3F5006ED3F5006ED3F5006ED3
      F5003FB2D300B1F2FC00078DBE00000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000000000000000078DBE0072D6F900078DBE00ACF8
      FD007ADBFA007ADBFA007ADBFA007ADBFA007ADBFA007ADBFA007ADBFA007ADB
      FA0043B5DD00C8F6FB00078DBE00000000000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE0073D7F500078DBE00ACF1
      FC0078DBF90078DBF90078DBF90078DBF90078DBF9007BDDFA0078DBF90078DB
      F9004AB9D700B8F3FB00078DBE000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF00000000000000000000000000078DBE007CDDFA001495C40095EC
      FB0092EAFB0086E3FB0083E1FB0083E1FB0086E3FB0083E1FB0083E1FB0086E3
      FB0049B8E000C8F6FB001495C400000000000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE007BDDFA00078DBE00B1F2
      FC0084E4F80031AD67000E831A000E8C1A0031AD670078DBF90084E4F80086E6
      FA004AB9D700B8F3FB00078DBE0000000000000000000000FF000000FF000000
      FF000000000000000000FF000000FF0000000000000000000000000000000000
      FF000000FF000000FF000000000000000000078DBE0083E1FB0043B5DD0059C4
      EA00ACF8FD008FE9FB008FE9FB008FE9FB008FE9FB008FE9FB008FE9FB008FE9
      FB004CBBE300C8F6FB00C8F6FB00078DBE000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE007FE0FA00078DBD00B8F3
      FB008FEBFB008FEBFB0052BEDA0010961D0010961D0031AE5F008CE9FB008FEB
      FB004AB9D700BDF4FB00078DBE0000000000000000000000FF000000FF000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      00000000FF000000FF000000000000000000078DBE008CE7FB0078DAFA0025A0
      CD00E5F8FA00C8F6FB00C8F6FB00C8F6FB00C8F6FB00C8F6FB00C8F6FB00C8F6
      FB0095ECFB00E5F8FA00CFF6FA00078DBE000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE0089E8FB00078DBD00CFF5
      FB00C9F5FC00C9F5FC00C9F5FC0063CED00010961D0010961D0031AE5F00C9F5
      FC0098EEFC00CFF5FB00078DBE00000000000000FF000000FF00000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000FF000000FF0000000000078DBE0096F0FC0096F0FC001495
      C400078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE0093ECFC00078DBE00078D
      BE00078DBE00078DBE00078DBE00159B950010961D0010961D000E831A00078C
      BC00078DBE00078DBE00078DBE00000000000000FF000000FF00000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000FF000000FF0000000000078DBE009CF5FD009AF4FD009AF4
      FD009CF5FD009DF6FD009AF4FD009CF5FD009AF4FD009CF5FD009AF4FD009AF4
      FD00088DBE000000000000000000000000000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE009EF2FD009EF2FD009EF2
      FD009EF2FD009EF2FD009EF2FD0063CED00010961D0010961D0010941C0063CE
      D000078CBC000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000078DBE00E5F8FA00A1F9FE00A1F9
      FE00A1F9FE00A1F9FE00A1F9FE00A1F9FE00A1F9FE00A1F9FE00A1F9FE00A1F9
      FE00088DBE000000000000000000000000000000000000000000000000000000
      00000000000000000000CD6C0B00E7D7A5009835000000000000000000000000
      000000000000000000000000000000000000078DBE00CFF5FB00A0F2FC00A0F2
      FC00A0F2FC00A0F2FC00A0F2FC0084E4F80010961D0036BB5F0010961D0031AD
      6700078CBC000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000078DBE00E5F8FA00A4F9
      FE00A4F9FE00A4F9FE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000993F0800A28D75006C29070000000000000000000000
      00000000000000000000000000000000000000000000078DBE00CFF5FB00A7F1
      FC000E8419000E8419000E8419000E84190031AE5F0038BF600033B65D000E84
      19000E8419000E8419000E841900000000000000FF000000FF00000000000000
      00000000000000000000FF000000FF00000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000166990001669900016699000166990001669900000000000000
      0000000000000000000000000000000000000000000000000000078DBE00078D
      BE00078CBC000E84190010951C003CC463003CC463003CC4630038BF600033B6
      5D0010961D000E8419000000000000000000000000000000FF000000FF000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009835000098350000983500009835
      00009835000001669900CBE0F9001798C6001798C600016699006C2907009835
      0000983500009835000098350000983500000000000000000000000000000000
      000000000000000000000E84190031AE5F005ECCD1003CC463003CC4630033B6
      5D000E841900000000000000000000000000000000000000FF000000FF000000
      FF000000000000000000FF000000FF0000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D2701000E7D7A500E7D7A500E7D7
      A500E7D7A50001669900CFF0F800CBE0F9001798C60001669900A28D7500E7D7
      A500E7D7A500E7D7A500E7D7A500D27010000000000000000000000000000000
      00000000000000000000000000000E84190038BF600063CED0003CC463000E84
      19000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CD6C0B00CD6C0B00CD6C0B00CD6C
      0B00CD6C0B0001669900E7F0F300CFF0F800CBE0F90001669900993F0800CD6C
      0B00CD6C0B00CD6C0B00CD6C0B00CD6C0B000000000000000000000000000000
      0000000000000000000000000000000000000E8419003CC463000E8419000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000166990001669900016699000166990001669900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000E841900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000A00000000100010000000000000500000000000000000000
      000000000000000000000000FFFFFF0080030000000000000003000000000000
      0001000000000000000100000000000000010000000000000000000000000000
      0000000000000000000000000000000000070000000000000007000000000000
      800F000000000000C01F000000000000C01F000000000000C03F000000000000
      C07F000000000000FFFF000000000000FFFFFFFFFFFFFFFF0001C001C001C007
      000180018001800300019FF99FF980031FF19FF99EF980031FF19CB99C798003
      197198199C398003193198099C198003191198199C398003193198399C798003
      197199799CF980031FF19FF99DF980031FF19FF99FF980030001800180018003
      000180038003C0070001FFFFFFFFFFFFF81FF81FF81FFFFFE007E007E0070001
      C003C003C003000180018001800100018001800180011FF10000000000001DF1
      0000000000001CF10000000000001C710000000000001C310000000000001C71
      0000000000001CF18001800180011DF18001800180011FF1C003C003C0030001
      E007E007E0070001F81FF81FF81F0001FFFFE001DDDDC888C007C000D5558000
      8003C0000000000080038000DFFFC3FE8003000087FC85FC80030000DBFB8000
      800300000000000080030003DDF7CD77800300039EEF8E8F80030003DF1F8000
      8003000F000000008003000FDFFFCFFF8003801F9FFF8FFF8003C3FFDFFF8000
      C007FFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFF800F80080008003F8009030
      80008003200000428000800300001E0C8000800300001C128000800300001E0C
      8000800300001C12800080030000180C800080030000001A80008003000011FE
      80008003E000E11880008003F800F83080008003F800F802C0018007F801F801
      FFFF800FF803F803FFFF801FF807F807F81FF81FFFFFF81FE007E007FFFFE007
      C003C0030000C003800180010000800180018001000080010000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000080018001000080018001800100008001C003C0030000C003
      E007E0070000E007F81FF81FFFFFF81FFFFFFFFFFFFFF81FFFFFC00701FFE007
      0000800301FFC0030000800301FF80010000800301FF80010000800301FF0000
      00008003FF40000000008003FE40000000008003FC40000000008003FE400000
      00008003FF4000000000800301FF80010000800301FF80010000800301FFC003
      0000C00701FFE007FFFFFFFF01FFF81FFC1F80039FFF9FFFF00700030FFF0FFF
      E383000107FF07FFC3C1000183FF83FF99910001C1FFC1FF98380000E10FE10F
      1C780000F003F0031EFD0000F801F8011C3F0001F801F80118200000F800F800
      0B808003F800F800A780C3C7F800F80093C0FF87F801F801CBC0FF8FFC01FC01
      E38DFE1FFE03FE03F83FF87FFF0FFF0FFC1FFFFFFC1FFFFFF007F83FF007F83F
      E383E00FE383E00FC3C1C7C7C3C1C7C799918FE399918FE398389FF398389FF3
      1C783EF91C783FF91EFD3EF91EFD00091C3F393F1C3F000F18203EFF18203FFF
      0B803EC10B803FC1A7809FE1A7809FE193C08FF193C08FF1CBC0C7C1CBC0C7C1
      E38DE00DE38DE00DF83FF83FF83FF83F8007FC7F8003FFFF0003FC7F0001F83F
      0001FC7F0001E00F0001FC7F0001C7C70001FC7F00018CE30000FC7F00019CF3
      0000FC7F00013CF90000FC7F00013CF90007FC7F00073CFF0007FC7F00073CFF
      800FFC7F80013CC1C3FFF83FC0039CE1FFFF0000FC078CF1FFFF0000FE0FC7C1
      FFFF0000FF1FE00DFFFFF83FFFBFF83F00000000000000000000000000000000
      000000000000}
  end
  object MainMenu: TMainMenu
    Left = 936
    Top = 176
    object FileMenu: TMenuItem
      Caption = 'File'
      object ExitMenu: TMenuItem
        Caption = 'Exit'
        OnClick = ExitMenuClick
      end
    end
    object OptionsMenu: TMenuItem
      Caption = 'Options'
      object AutoSizeMenu: TMenuItem
        AutoCheck = True
        Caption = 'Auto Size'
        OnClick = AutoSizeMenuClick
      end
      object ShowSimulProgrMenu: TMenuItem
        AutoCheck = True
        Caption = 'Show Simulation Progress'
        OnClick = ShowSimulProgrMenuClick
      end
      object ShowEpicentersMenu: TMenuItem
        AutoCheck = True
        Caption = 'Show Epicenters'
        OnClick = ShowEpicentersMenuClick
      end
      object LeapYearMenu: TMenuItem
        Caption = 'Leap Year'
      end
      object LogNormalMenu: TMenuItem
        AutoCheck = True
        Caption = 'Detection is LogNormal'
        OnClick = LogNormalMenuClick
      end
      object NormalDistrAgeMenu: TMenuItem
        AutoCheck = True
        Caption = 'Normal Distribution of Age'
        OnClick = NormalDistrAgeMenuClick
      end
      object DrawInfectMenu: TMenuItem
        AutoCheck = True
        Caption = 'Draw Infected on Map'
        OnClick = DrawInfectMenuClick
      end
      object RedR0HistMenu: TMenuItem
        AutoCheck = True
        Caption = 'Reduce R0 Histogram'
        OnClick = RedR0HistMenuClick
      end
    end
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 936
    Top = 232
  end
  object CopyChartMenu: TPopupMenu
    Left = 936
    Top = 293
    object CopyToClipMenu: TMenuItem
      Caption = 'Copy To Clipboard'
      OnClick = CopyToClipMenuClick
    end
    object CopyToFileMenu: TMenuItem
      Caption = 'Copy To File'
      OnClick = CopyToFileMenuClick
    end
  end
end
