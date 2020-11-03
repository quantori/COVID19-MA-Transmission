// © Koniukhovskii V. Forecast of COVID infection in MA. (konvlad@gmail.com, May 12, 2020).

unit UnCOVID;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, OleCtrls, SHDocVw, GMClasses, GMMap, GMMapVCL, StdCtrls, Menus, ComCtrls, ImgList,
  ToolWin, ExtCtrls, PNGImage, Math, Grids, UnTypesCOVID, TeEngine, TeeProcs, Chart, Series, TeeExport, TeePNG;

type
  TPat = record  {RU: Пациент} {EN: Patient}
    Coord: TIntegerPoint2D;  {RU: Координаты в м}  {EN: Coordinates in m}
    EpiIndex: Integer;  {RU: Индекс эпицентра, из которого возникла инфекция} {EN: The ifection origin epicenter index}
    InfectTime, Stage1, Stage2, Detect: Integer;  {RU: Время заражения, Длительность 1 стадии, Длительность 2 стадии, Длительность инкубационного периода} 
                                                  {EN: Infection time, Stages 1 and 2 duration, lenght of the incubation period.}
    Age: Integer;   {RU: Возрастной пациента} {EN: Age of the patient}
    AvrgRadDist: Integer;  {RU: Среднее для показательного распределения по расстоянию до зараженного в m. По окружности распределение равномерное.}
                           {EN: Average distance to infected patient in meteters. The distribution on the circumference is uniform.}  
    Contacts: TIntegerPoint2D;  {RU: Параметры нормального распределения (Mean, StDev) для количества контактов в единицу времени (день)}
                                {EN: Parameters of the normal distribution (Mean, StDev) for the number of contacts in the unit time (day)}
    ContProb: Double;  {RU: Вероятность контакта втечение одного дня}  {EN: The contact probability during a single day}
    R0: Double;   {RU: Среднее количество пациентов, инфицированных aSource за все времч инфицированности } {EN: The averaged number of cases infected by aSource while he/she is infectious.}
    DisForm: Integer;  {RU: Степень тяжести болезни: 0 - летальная, 1 - тяжелая, 2 - легкая.} {EN: Disease severity:  0 - lethal, 1 - severe, 2 - mild.}  
    DiseaseDur: Integer; {RU: Продолжительность болези в днях} {EN: Disease duration in days}
    Status: Integer;  {RU: 0 - зарегистрированный (исходные данные); 1 - инфицированный; 2 - на лечении (детектированный); 3 - выздоровевший; 4 - умерший; (-1) - не определен}
                      {EN: 0 - detected based on the external sources (input data); 1 - infected; 2 - infected and detected as such; 3 - recovered; 4 - deceased; (-1) - not definded}
  end;
  TPatList = array of TPat;

  TEpicenter = record
    Center: TIntegerPoint2D;  // RU: Центральная точка области EN: Center of the region 
    Radius: Integer;  // RU: Средний радиус для симулирования экземпляров пациентов (в m) EN: Average radius to simulate the infected patients (in meters)  
    County: String;   // RU: Название округа  EN: Name of the region
  end;
  TEpicenters = array of TEpicenter;  // RU: Массив эпицентров EN: The array of epicenters

  TAgeHist = record {RU: Гистограмма }  {EN: Histogramm}
    HistValArr: array[0..9] of Integer;  {RU: Массив ненормированных частот с интервалом 10 лет: [0; 10], [10; 20], ..., [90; 100]} 
                                         {RU: Array of non-normalized frequences for 10 year incremented intervals: [0; 10], [10; 20], ..., [90; 100]}
    Sum: Integer;
    Mean, StdDev: Double;
    SimulTime: Integer;   {RU: Время вычисления гистограммы} {EN: Time of the histogram computation}
  end;
  TAgeHistArr = array of TAgeHist;

  THist = record {RU: Гистограмма }  {EN: Histogramm }
    MinMaxVal: TIntegerPoint2D; {RU: Наименьшее и наибольшее значения в гистограмме: (MinMaxVal[0], MinMaxVal[1])} {EN: The smallest and the largest values in histogram: (MinMaxVal[0], MinMaxVal[1])}
    IntervCount, HistStep: Integer;   {RU: Количество интервалов и шаг гистограммы}  {EN: The number of intervals and the step of the histogram}
    HistVal: array of Integer;  {RU: Массив ненормированных частот по интервалам}  {EN: The array of unnormalized frequencies for histogram intervals}
    Sum: Integer;
    //Mean, StdDev: Double;
  end;
  THistStatus = array [0..3] of THist; // RU: Массив гистограмм для 0 - Infected, 1 - Hospital, 2 - Dead, 3 - Mild на каждый период прогноза 
                                       // EN: The array of histograms for 0 - Infected, 1 - Hospital, 2 - Dead, 3 - Mild for every prediction period 
  THistStatusArr = array of THistStatus;  // RU: Массив гистограмм типа THistStatus для всех периодов прогноза  EN: The array of histograms of type THistStatus for all prediction periods 

  TRealHist = record {RU: Гистограмма для вещественной выборки} {EN: histogram for the real-valued sample}
    MinMaxVal: TDoublePoint2D; {RU: Наименьшее и наибольшее значения в гистограмме: (MinMaxVal[0], MinMaxVal[1]) } {EN: The smaleest and the largest values in the histogram: (MinMaxVal[0], MinMaxVal[1]) }
    IntervCount : Integer;   {RU: Количество интервалов} {EN: The number of intervals}
    HistStep: Double;  {RU: Шаг гистограммы} {EN: The step of the histogram}
    HistVal: array of Integer;  {RU: Массив ненормированных частот по интервалам} {EN: The array of non-normalized frequencies for histogram intervals}
    Sum: Integer;   // RU: Объем выборки EN: The sample size
    Mean, StdDev, Median, Quant_05, Quant_95: Double;
  end;

  TAgeHist9 = record {RU:  Гистограмма } {EN: Histogram}
    //MinVal, MaxVal: Double; {RU:  Наименьшее и наибольшее значения в гистограмме } {EN:  The samllest and the largest values in histogram }
    HistValArr: array[0..8] of Integer;  {RU:  Массив ненормированных частот с интервалом 10 лет: [0; 10], [10; 20], ..., [80; 90]} 
                                         {EN:  The array of non-normalized frequences for 10 year slots: [0; 10], [10; 20], ..., [80; 90]}
    //Sum: Integer;
    //Mean, StdDev: Double;
    SimulTime: Integer;   {RU: Время вычисления гистограммы} {EN: The time of the histogram computation}
  end;
  TStatusAgeHist = array[0..2] of TAgeHist9;  // RU: Гистограммы распредения по возрасту для статусов: 0 - Infected, 1 - Treated, 2- Dead
                                              // EN: Distribution histograms by age for statuses: 0 - Infected, 1 - Treated, 2- Dead
  TStatusAgeHistArr = array of TStatusAgeHist;

  TDiseaseForm = array[0..2] of TDoublePoint3D;  // RU: 0- летальная, 1 - тяжелая, 2 - легкая в %. DiseaseForm[i,j] - возрастная группа (младшая, средняя, старшая)
                                                 // EN: 0- lethal, 1 - severe, 2 - mild in %. DiseaseForm[i,j] - age group (young midlle age, old)
  TDiseaseDuration = array[0..2] of TDoublePoint2D;  // RU: Проджительность болезни (Mean, StdDev). 0- летальная, 1 - тяжелая, 2 - легкая в днях.
                                                     // EN: The disease duration (Mean, StdDev). 0- lethal, 1 - severe, 2 - mild in days.
  TStatus = array[0..6] of Integer;  // RU: [0] - время, [1] - инфицированные, [2] - лечатся, [3] - здоровые, [4] - умершие, [5] - легко больные, [6] - число случаев инфекции
                                     // EN: [0] - time,  [1] - infected,       [2] - in treatment, [3] - not infected, [4] - deceased, [5] - mildly infected, [6] - the number of infected cases
  TStatusArr = array of TStatus;
  TStatusArrArr = array of TStatusArr;   // RU: Массив массивов типа TStatusArr EN: The array of arrays of type TStatusArr

  TStatusStrArr = array[0..2] of TStringArr;   // RU: Массив массивов строк с координатами пациентов для статусов: 0 - Status = 1; 1 - Status = 2; 2 - Status = 4
                                               // EN: The arrays of arrays of strings with patient coordinates or statuses: 0 - Status = 1; 1 - Status = 2; 2 - Status = 4

  TNodes = array of array of TIntPoint3D;  // RU: Двумерный массив узлов на карте для сохранения статусов пациентов: Node = (0 - Status = 1; 1 - Status = 2; 2 - Status = 4)
                                           // EN: Two dimensional array of knots on the map to store the status: Node = (0 - Status = 1; 1 - Status = 2; 2 - Status = 4)
  TNodesArr = array of TNodes;

  TSamples = array[0..4] of TIntArray;  // RU: Массив выборок для 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases  на каждый период прогноза
                                        // EN: The array or samples for 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases for each prediction period
  TSamplesArr = array of TSamples;   // RU: Массив выборок TSamples на все периоды прогноза
                                     // EN: The array of samples TSamples for all prediction periods

  TForecast = record  // RU: Данные для заполнения прогноза за период  EN: Variable to save predictions during a period 
    Period: TIntPoint2D;  // RU: Период прогноза EN: The prediction period
    PointEstim: array[0..4] of Integer;  // RU: Точечный прогноз 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases на каждый период Period
                                         // EN: Point prediction 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases for every period saved in Period
    Quantiles: array[0..4] of TIntArray;  // RU: Квантили для распределения статусов (список квантилей: QuantList) EN: Qunatiles for the status distribution (the list of qunatiles: QuantList)
    Histogram: array[0..4] of THist;   // RU: Гистограммы распределения статусов на период Period EN: Distribution histograms for the period Period.
    DistrFunc: array[0..4] of TDoublePoint2DArr; // RU: Функции распределения статусов на период Period EN: The distribution function of statuses for the period Period
  end;
  TForecastArr = array of TForecast;  // RU: Массив данных для прогноза по всем периодам EN: The array of data for prediction across all periods

  TDeathSamples = array[0..1] of TIntArray;  // RU: Массив итеративных выборок (0 - Increment Deaths, 1 - Cumulative Deaths) на один период прогноза
                                             // EN: The array of interactive samples (0 - Increment Deaths, 1 - Cumulative Deaths) during a single prediction period
  TDeathSamplesArr = array of TDeathSamples;   // RU: Массив выборок TDeathSamples на все периоды прогноза EN: The array of sample TDeathSamples for all prediction periods

  TDeathForecast = record  // RU: Данные для заполнения прогноза по смерти за период Period EN: Data container to be filled with the deceased predcitions during the period Period
    Period: TIntPoint2D;  // RU: Период прогноза EN: Period for the prediction
    PointEstim: TIntPoint2D;  // RU: Точечный прогноз 0 - Increment Deaths, 1 - Cumulative Deaths EN: Point prediction 0 - Increment Deaths, 1 - Cumulative Deaths
    Quantiles: array[0..1] of TIntArray;  // RU: Квантили для распределения Inc и Cumul (список квантилей: QuantList) EN: Distribution qunatiles for Inc and Cumul (the list of qunatiles: QuantList)
    Histogram: array[0..1] of THist;   // RU: Гистограммы распределения статусов Inc и Cumul на период Period EN: Historgrams for the statuses distribution Inc and Cumul during Period
    DistrFunc: array[0..1] of TDoublePoint2DArr; // RU: Функции распределения статусов Inc и Cumul на период Period EN: The distribution functions of statuses Inc and Cumul during Period
  end;
  TDeathForecastArr = array of TDeathForecast;  // RU: Массив данных типа TDeathForecast для прогноза по всем периодам EN: The array of dataof type TDeathForecast for predictions across all periods

  TMainForm = class(TForm)
    MainToolBar: TToolBar;
    ImageList: TImageList;
    MainStatusBar: TStatusBar;
    MainMenu: TMainMenu;
    LeftPanel: TPanel;
    SimulPageControl: TPageControl;
    PatParamTabSheet: TTabSheet;
    StatTabSheet: TTabSheet;
    LeftBottomPanel: TPanel;
    LeftTopPanel: TPanel;
    SaveDialog: TSaveDialog;
    ContRadEdit: TLabeledEdit;
    ContRadUpDown: TUpDown;
    ContCenterEdit: TEdit;
    AddContCircleButton: TButton;
    ContCirclesGrid: TStringGrid;
    TimePanel: TPanel;
    MaxSimulTimeEdit: TLabeledEdit;
    MaxSimulTimeUpDown: TUpDown;
    PatPanel: TPanel;
    NewPatButton: TButton;
    AddPatButton: TButton;
    PatGroupBox: TGroupBox;
    CoordXEdit: TLabeledEdit;
    HistThreshEdit: TLabeledEdit;
    CoordYEdit: TLabeledEdit;
    CoordXUpDown: TUpDown;
    CoordYUpDown: TUpDown;
    InfecttTimeEdit: TLabeledEdit;
    InitTimeUpDown: TUpDown;
    Stage1Edit: TLabeledEdit;
    Stage2Edit: TLabeledEdit;
    DetectEdit: TLabeledEdit;
    Stage1UpDown: TUpDown;
    Stage2UpDown: TUpDown;
    DetectUpDown: TUpDown;
    AgeEdit: TLabeledEdit;
    AgeUpDown: TUpDown;
    DistEdit: TLabeledEdit;
    DistUpDown: TUpDown;
    StatusEdit: TLabeledEdit;
    StatusUpDown: TUpDown;
    ContactsEdit: TLabeledEdit;
    SDContactsEdit: TLabeledEdit;
    SDContactsUpDown: TUpDown;
    ContactsUpDown: TUpDown;
    ContProbEdit: TLabeledEdit;
    ContProbUpDown: TUpDown;
    DetListPanel: TPanel;
    DetPatStrGrid: TStringGrid;
    RightBottomPanel: TPanel;
    InfectStrGrid: TStringGrid;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    InitSimulButton: TToolButton;
    OptimParamslButton: TToolButton;
    SimulStepButton: TToolButton;
    SimulTimeEdit: TLabeledEdit;
    SimulChart: TChart;
    InfPatSeries: TLineSeries;
    LethalSeries: TLineSeries;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    FileMenu: TMenuItem;
    ExitMenu: TMenuItem;
    OptionsMenu: TMenuItem;
    AutoSizeMenu: TMenuItem;
    ShowSimulProgrMenu: TMenuItem;
    AgeHistChart: TChart;
    FullSimlButton: TToolButton;
    ToolButton3: TToolButton;
    EpiCentrsGrid: TStringGrid;
    DetDayEdit: TLabeledEdit;
    DetDayUpDown: TUpDown;
    Splitter3: TSplitter;
    MapScrollBox: TScrollBox;
    MapPaintBox: TPaintBox;
    Splitter4: TSplitter;
    Chart1: TChart;
    TreatSimulSeries: TLineSeries;
    TreatReallSeries: TLineSeries;
    PanelOptTime: TPanel;
    OptTimeGroupBox: TGroupBox;
    InitOptEdit: TLabeledEdit;
    TermOptEdit: TLabeledEdit;
    InitOptUpDown: TUpDown;
    TermOptUpDown: TUpDown;
    AutoSizelButton: TToolButton;
    RealIsolSeries: TLineSeries;
    ShowEpicentersMenu: TMenuItem;
    ParamPageControl: TPageControl;
    SimulParamTabSheet: TTabSheet;
    SimulGroupBox: TGroupBox;
    ContProbGroupBox: TGroupBox;
    InitContProbEdit: TLabeledEdit;
    InitContProbUpDown: TUpDown;
    IsolContProbEdit: TLabeledEdit;
    IsolContProbUpDown: TUpDown;
    TimeIsolEdit: TLabeledEdit;
    TimeIsolUpDown: TUpDown;
    ParamDistrStrGrid: TStringGrid;
    ParamRadioGroup: TRadioGroup;
    TreatmTabSheet: TTabSheet;
    LeapYearMenu: TMenuItem;
    LogNormalMenu: TMenuItem;
    LabeledEdit1: TLabeledEdit;
    ParamUpDown: TUpDown;
    DiseaeseStaticText: TStaticText;
    DiseaseFormStrGrid: TStringGrid;
    DurationStrGrid: TStringGrid;
    DurationStaticText: TStaticText;
    DurParamUpDown: TUpDown;
    TreatSeries: TLineSeries;
    NormalDistrAgeMenu: TMenuItem;
    InfHistSeries: TLineSeries;
    TreatHistSeries: TLineSeries;
    LethalHistSeries: TLineSeries;
    ToolButton4: TToolButton;
    DrawInfectMenu: TMenuItem;
    ParamStrGrid: TStringGrid;
    CmdLineLabel: TLabel;
    DensLabel: TLabel;
    EpiLabel: TLabel;
    PatLabel: TLabel;
    DetPatLabel: TLabel;
    DetectPatLabel: TLabel;
    CDCReportButton: TToolButton;
    ForeDayEdit: TLabeledEdit;
    ForeDayUpDown: TUpDown;
    ForecastChart: TChart;
    CaseSeries: TLineSeries;
    SimulTimeUpDown: TUpDown;
    CaseMSEEdit: TLabeledEdit;
    TermUpEdit: TEdit;
    DailyForeButton: TToolButton;
    ToolButton5: TToolButton;
    RestartlButton: TToolButton;
    ForeSeries: TLineSeries;
    Splitter5: TSplitter;
    LowSeries: TLineSeries;
    HighSeries: TLineSeries;
    RealSeries: TLineSeries;
    ForePanel: TPanel;
    ForeIterEdit: TLabeledEdit;
    ForeIterUpDown: TUpDown;
    SimTypeRadioGroup: TRadioGroup;
    CopyChartMenu: TPopupMenu;
    CopyToClipMenu: TMenuItem;
    CopyToFileMenu: TMenuItem;
    RealLethalSeries: TLineSeries;
    ReaHospSeries: TLineSeries;
    ShowValLabel: TLabel;
    R0Chart: TChart;
    PreR0Series: TLineSeries;
    PostR0Series: TLineSeries;
    DistrPreR0Series: TLineSeries;
    DistrPostR0Series: TLineSeries;
    RedR0HistMenu: TMenuItem;
    R0DistrCheckBox: TCheckBox;
    R0StrGrid: TStringGrid;
    R0StatLabel: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    PosEdit: TLabeledEdit;
    WeeklyGroupBox: TGroupBox;
    WeekIterEdit: TLabeledEdit;
    WeekIterUpDown: TUpDown;
    WeekCountEdit: TLabeledEdit;
    WeekCountUpDown: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure MapPaintBoxPaint(Sender: TObject);
    procedure MapPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MapPaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MaxSimulTimeUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AddPatButtonClick(Sender: TObject);
    procedure DetPatStrGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure ContRadUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AddContCircleButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ContProbUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure NewPatButtonClick(Sender: TObject);
    procedure ContCirclesGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure InitContProbUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure IsolContProbUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TimeIsolUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InitContProbUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IsolContProbUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InitSimulButtonClick(Sender: TObject);
    procedure SimulStepButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure OptimParamslButtonClick(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure FullSimlButtonClick(Sender: TObject);
    procedure SimulChartClickLegend(Sender: TCustomChart; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SimulTimeUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SimulTimeUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure SimulTimeUpDownChanging(Sender: TObject; var AllowChange: Boolean);
    procedure LeftBottomPanelResize(Sender: TObject);
    procedure EpiCentrsGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ContCirclesGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EpiCentrsGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DetListPanelResize(Sender: TObject);
    procedure DetDayUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DetDayUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MapPaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShowSimulProgrMenuClick(Sender: TObject);
    procedure ParamDistrStrGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaxSimulTimeUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure InitOptUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TermOptUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AutoSizeMenuClick(Sender: TObject);
    procedure AutoSizelButtonClick(Sender: TObject);
    procedure ParamRadioGroupClick(Sender: TObject);
    procedure ShowEpicentersMenuClick(Sender: TObject);
    procedure LogNormalMenuClick(Sender: TObject);
    procedure DiseaseFormStrGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure ParamUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ParamUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DiseaseFormStrGridExit(Sender: TObject);
    procedure DurationStrGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure DurationStrGridExit(Sender: TObject);
    procedure DurParamUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DurParamUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NormalDistrAgeMenuClick(Sender: TObject);
    procedure ParamDistrStrGridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure TimeIsolUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DrawInfectMenuClick(Sender: TObject);
    procedure InitContProbEditChange(Sender: TObject);
    procedure IsolContProbEditChange(Sender: TObject);
    procedure CDCReportButtonClick(Sender: TObject);
    procedure ForeDayUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ForeDayUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SimulChartResize(Sender: TObject);
    procedure InitOptUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TermOptUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DailyForeButtonClick(Sender: TObject);
    procedure RestartlButtonClick(Sender: TObject);
    procedure ForecastChartBeforeDrawAxes(Sender: TObject);
    procedure SimTypeRadioGroupClick(Sender: TObject);
    procedure CopyToClipMenuClick(Sender: TObject);
    procedure CopyToFileMenuClick(Sender: TObject);
    procedure ForecastChartAfterDraw(Sender: TObject);
    procedure ForecastChartMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure R0DistrCheckBoxClick(Sender: TObject);
    procedure RedR0HistMenuClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ForecastChartMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure R0ChartMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    function OpenCurrMap: Boolean;
    function PatFromParam: TPat;
    procedure PatToParam(aPat: TPat);
    procedure FillSessionList;
    procedure SetOptions;
    procedure SaveSessionList;
    function LoadSessionFile(const aSessionFileName: String): Boolean;
    procedure NewPatParams(const aHiperParam: TDoublePoint2DArr);
    procedure SimulationStep(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double);
    procedure ShowEpicentrsEval(X, Y: Integer);
    procedure DrawMap;
    procedure InitModel(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aCurrDetDay: Integer);
    procedure SetFormSize;
    procedure HandleCmdLine;
    procedure FullSimlation;
    procedure SetForeDay;
    procedure ShowSimulTab(aTabInd: Integer);
    procedure CopyChart(const aChart: TChart);
    procedure CopyChartToFile(const aChart: TChart; const aSaveDialog: TSaveDialog);
    procedure SetForeChartTitle;
    procedure EvaluateR0;
    procedure HaltProgram(aMsgStr: String);
  public
    { Public declarations }
  end;

const
  MapFileName = 'Data\MassMap.png';
  InitialTime = 0;   // RU: Время, в которое вводятся исходные данные о выявленных заболевших EN: Time, when the initial cases are introduced into the model
  GeoLeftTop: TDoublePoint2D = (-73.260462, 42.745496);    {RU: Координаты на поверхности (Long; Lat в градусах) левой верхней точки (Williemstown) }
                                                           {EN: Surface coordinates (Long; Lat in degrees) of the top left point (Williemstown) }
  GeoRightBottom: TDoublePoint2D = (-70.008509, 41.535820);    {RU: Координаты на поверхности (Long; Lat в градусах) правой нижней точки (Chatham)}
                                                               {EN: Surface coordinates (Long; Lat in degrees) o the bottom right point (Chatham)}
  MapLeftTop: TIntegerPoint2D = (96, 91);  {RU: Координаты на карте (X, Y) левой верхней точки (Williemstown)} {EN: Coordinates on the map (X, Y) of the top left point (Williemstown)}
  MapRightBottom: TIntegerPoint2D = (1047, 564);  {RU: Координаты на карте (X, Y) правой нижней точки (Chatham)} {EN: Coordinates on the map (X, Y) of the bottom right point (Chatham)}
  EarthRad = 6371210;
  MinDetect = 2;  {RU: Минимальная длительность инкубационного периода} {EN: The shortest incubation period duration}
  MaxDetect = 15; {RU: Максимальная длительность инкубационного периода} {EN: The longest incubation perido duration}
  //DetectDistrParam: TDoublePoint2D = (10, 3);
  //AgeDistrParam: TDoublePoint2D = (45, 20);
  CSVExt = '.csv';
  COVIDSessionFileName = 'Data\COVIDSession.txt';
  MaxPatCount = 800000;   // RU: Максимальное количество симулированных пациентов EN: The larges amount of the simulated infections
  //WaterRGB: TRGB = (170, 218, 255);
  WaterRGB: TRGB = (224, 232, 235);
  MonthName: array[0..11] of String = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
  MonthDaysLeap: array[0..11] of Integer = (31,29,31,30,31,30,31,31,30,31,30,31);     // RU: Високосный EN: Leap year
  MonthDays: array[0..11] of Integer = (31,28,31,30,31,30,31,31,30,31,30,31);
  MonthNum: array[0..11] of String = ('01','02','03','04','05','06','07','08','09','10','11','12');
  AgeLevel: TIntegerPoint2D = (20, 50);  // RU: Границы возрастных групп: [1-20], [20-50], [50-100], EN: Age group boundaries: [1-20], [20-50], [50-100],
  DisFormStr: array[0..2] of String = ('Lethal','Severe','Mild');
  MAAgeHistogram: array[0..18] of Integer = (362,369,397,461,493,498,465,414,420,460,496,481,433,349,263,177,134, 55, 20);  // RU: По возрастам с шагом 5 0т 0 до 90 EN: By age with 5y increments from 5 to 90.
  DetectCountFileName = 'Data\MA DetectCount.csv';
  EpicentersFileName = 'Data\MA Epicenters.csv';
  StatusArrFileName = 'StatusMA.csv';
  StatusStrArrFileName = 'CoordStatusMA.csv';
  ForecastFileName = 'ForecastMA.csv';
  DailyForecastFileName = 'DailyForecastMA.csv';
  FullDataFileName = 'Data\MA FullData.csv';
  COVID_Death_MAFileName = 'Data\COVID Death MA.csv';
  EndOfFirstEpiWeek = 3;  // RU: Индекс последнего дня первой EpiWeek в 2020 году: Jan-4.  EN: The index of the last day of the first EpiWeek in 2020 i.e. Jan-4. 
  //ForeWeekCount = 6;  // RU: Количество недель для прогноза после завершения ежедневного прогноза EN: The number of weeks to predict
  ZeroPat: TPat = (Coord: (0,0); EpiIndex: -1; InfectTime: 0; Stage1: 0; Stage2: 0; Detect: 0; Age: 0; AvrgRadDist: 0; Contacts: (0,0); ContProb: 0;
                   R0: 0; DisForm: -1; DiseaseDur: 0; Status: -1);
  MaxPatCont = 20;  // RU: Максимально возможное количество эффективных контактов инфицированного пациента EN: The max possible number of efective contacts by the infected patient.
  ZeroRealHist: TRealHist = (MinMaxVal: (0,0); IntervCount: 0; HistStep: 0; HistVal: nil; Sum: 0; Mean: 0; StdDev: 0; Median: 0);

var
  MainForm: TMainForm;
  MapBitMap, BuffBitMap: TBitMap; {RU:  Для рисования карты на MapPaintBox } {EN:  For map drwawing on MapPaintBox }
  WaterMask: TImgMaskSection;  // RU: Маска, отмечающая точки воды. Если точка [i, j] на карте обозначает воду, то WaterMask[i, j] = True 
                               // EN: Mask that is used to specify water. If the point [i, j] on the map corresponds to water then WaterMask[i, j] = True
  CurrMap: TPNGImage;
  CurrentDirectory: String;
  CurrMapSize: TIntegerPoint2D;  // RU: Размеры карты X, Y   EN: map Dimensions X, Y
  CurrMapScale: Double;   // RU: Усредненный масштаб в m/pixel   EN: Averaged scale in m/pixel 
  CoordMapScale: TDoublePoint2D;  // RU: Покоординатный масштаб  EN: Coordinatewise scale
  AngleScale: TDoublePoint2D;
  MaxSimulTime, CurrMinInfTime, CurrSimulTime, MaxDetDuration: Integer;    // RU: Максимальное время для симуляции, минимальное время инфицирования и момент симулирования 
                                                                           // EN: Maximul simulation time, minimum time of the infection and the moment of the simulation 
  PointTime: Integer;   // RU: Момент визуализации результата EN: Visualization time
  PatList: TPatList;  // RU: Список инфицированных пациентов EN: The list of infected patinets.
  DetPatList: TPatList;  // RU: Список установленных инфицированных пациентов (Входные данные) EN: The list of cases used for the model input. 
  DetPatCount, PatCount: Integer;  // RU: Количество первоначально зарегистрированных и обработанны пауиентов в списке PatList EN: The number of initialy registered and processed patients in the list PatList.
  PatientsFileName: String;
  ContCenter: TIntegerPoint2D;  // RU: Центр области для задания плотности контактов EN: The center of the area that is used to to define the density of contacts. 
  ContRad: Integer;   // RU: Радиус области для задания плотности контактов EN: The radius of the area that is used to to define the density of contacts.
  ContCircles: TIntegerPoint3DArr;  // RU: Массив кругов для задания плотности контактов (0 - CenterX; 1 - CenterY; 2 - Radius) EN: The array of circles to define the dense of contacts (0 - CenterX; 1 - CenterY; 2 - Radius)
  COVIDSessionList: TStringList;
  DetListChanged: Boolean;
  InitContProb, IsolContProb, CurrInitContProb, CurrIsolContProb: Double;  // RU: Вероятность контакта в текущий момент при обычном режиме и режиме изоляции 
                                                                           // EN: The probability of contact at the given moment during quarnatine and non-quarantine time. 
  OptInitContProbArr, OptIsolContProbArr: TDoubleArray;  // RU: Массивы параметров InitContProb, IsolContProb EN: The arrays of parameters InitContProb, IsolContProb
  IsolTime: Integer;  // Момент начала изоляции
  InfectedPat, IsolatedPat: TIntegerPoint2DArr;  // RU: Массивы количества инфицированных и изолированных пациентов во времени. 0 время, 1 - количество
                                                 // EN: The arrays of infected and detected patients over time. 0 time, 1 - qunatitity
  StatusArr: TStatusArr;  // RU: Массив количеств пациентов в моменты времени StatusArr[i] = (0 - время, 1 - инфицированные, 2 - на лечении, 3 - здоровые, 4- умершие, 5 - легко больные, 6 = cases))
                          // EN: The array of the number of patients at time  StatusArr[i] = (0 - time,  1 - infected , 2 - detected/treated, 3 - uninfected, 4- deceases, 5 - mild symptoms, 6 = cases))
  AgeHistArr: TAgeHistArr;    // RU: Массив возрастных гистограмм для различных моментов симуляции EN: The array of age histograms for different time points of the simulation
  StopEvaluation: Boolean;   // RU: Останоака вычислений EN: Comptuation stop variable
  Epicenters: TEpicenters;   // RU: Массив эпицентров распространения инфекции EN: The array of the epicenters of the infection spread.
  SelEpiInd: Integer;   // RU: Индекс текущего эпицентра EN: The index of the current epicenter.
  DetectECCounts: TIntArrayArr;  // RU: Массив: DetectECCounts[i] - массив, количеств детектированных пациентов по округам а каждый день i.
                                 // EN:  Array: DetectECCounts[i] - array that stores the number of detected patients by regions at every day i.
  SumDetectECCounts: TIntArray;  // RU: Массив SumDetectECCounts[i] - суммарных количеств детектированных пациентов в каждый день i. 
                                //  EN: Array SumDetectECCounts[i] array that stores the cummulative number of detected patinets at every day i.
  DetectDays: TStringList;  // RU: Список дней с известным количеством детектированных пациентов EN: The list of days with the know number of detected patients.
  CurrDetDay, PrevDetDay: Integer;  // RU: Выбранный и предыдущий день для детектированных пациентов (считается началом отсчета дней)
                                    // EN: Selected and previous day for detected patients (it is assumed to be the starting point for days)
  OptimPeriod: TIntegerPoint2D;   // RU: Начальный и конечный дни периода оптимизации EN: The start and the end days of the optimization period
  HiperParam, CurrHiperParam: TDoublePoint2DArr;  // RU: Параметры модели: EN: Model Parameters 0 - Detection; 1 - Age; 2 - Distance; 3- Contact Usual;  4 - Contact Dence. (Mean, StdDev)
  OptHiperParamArr: TDoublePoint2DArrArr;  // RU: Массив параметров модели типа HiperParam EN: The array of parameters HiperParam
  AvrgOptHiperParam: TDoublePoint2DArr;
  AvrgOptInitContProb, AvrgOptIsolContProb: Double;
  CurrContrTime: Integer;  // RU: Момент, до которого проводятся симуляции в симплекс-методе EN: Time up to which simplex method is used.
  CurrSimulIter: Integer;  // RU: Количество итераций при симуляции в симплекс-методе EN: The number of iterations for the simplex method.
  CurraRealIsolated: TIntArray;  // RU: Массив суммарных количеств детектированных пациентов за период [aCurrDetDay, aContrTime]} 
                                 // EN: The arrray of total quantities of detected patients during the period [aCurrDetDay, aContrTime]}
  SimulIter: Integer;   // RU: Количество итераций при симулировании в симплекс-методк EN: The amount of iterations in simplex method.
  CurrSimulIsolated: TIntArray;  // RU: Массив прогнозируемых изолированных пациентов по оптимальным параметрам EN; The array of predicted isolated patients produced with optimized parameters.
  YearDays: TStringList;  // RU: Список дней в году EN: The amount of days on a year.
  DetectDayInd: Integer;  // RU: Индекс выбранного дня детектирования CurrDetDay в списке дней года YearDays EN. The selected day index CurrDetDay in the list of days of the year YearDays 
  ShowEpicenters: Boolean;  // RU: Отображение эпицентрров в виде кругов EN: Depiction of epicenters as circles.
  LogNorm: Boolean;  // RU: Если LogNorm = True, то распределение Detect считается логарифмически нормальным EN: If LogNorm = True, then the distribution of Detect is log-normal
  SelParamCell, SelDurParamCell: TIntegerPoint2D;  // RU: Выбранная ячейка в таблице (aCol, aRow) EN: The selected cell int the table (aCol, aRow)
  DiseaseForm: TDiseaseForm;  // RU: Список форм болезней: DiseaseForm[i,j] - i-форма для j-возрастной группы. EN:  The list of disease forms: DiseaseForm[i,j] - i-th form for j-th age group.
  DiseaseDuration: TDiseaseDuration;  // RU: Проджительность болезни (Mean, StdDev). 0- летальная, 1 - тяжелая, 2 - легкая в днях. EN: The disease diration (Mean, StdDev). 0- lethal, 1 - severe, 2 - mild (in days).
  LargeStep: Boolean;
  MAAgeDistrFunc: TDoublePoint2DArr;
  NormalDistrAge: Boolean;   // RU: Использование нормального распределения для возраста инфицированных EN: Normal distribution for the age of infected
  StatusAgeHistArr: TStatusAgeHistArr;    // RU: Массив гистограмм распределения пациентов по возрасту и статусу EN: The array of histograms for the distribution of cases by age and status.  
  DrawInfected: Boolean;  // RU: Рисование на карте инфицированных пациентов EN: Plotting the infected cases on the map.
  CurrParamCount: Integer;  // RU: Количество параметров в ParamStr EN: The number of parameters in ParamStr 
  CurrParamStr: TStringArr;  // RU: Массив входных параметров в виде строк EN: The array of input parameters as strings. 
  Console: Boolean;   // RU: Используется консольная версия EN: Console version usage
  FormClose: Boolean;  // RU: Флаг закрытия формы EN: The flag that thells whether the form is closed or not.
  MeshStep: Integer;  // RU: Шаг сетки из узло для локализации пациентов на карте EN: The step of the grid for cases poitioning on the map.
  StatusStrArr: TStatusStrArr;  // // RU: Массив массивов строк с координатами пациентов для статусов: EN: the array of arrays with coordinates of cases with statuses: 0 - Status = 1; 1 - Status = 2; 2 - Status = 4
  SamplesArr: TSamplesArr;  // // RU: Массив троек выборок на все дни симулирования EN: The array of tri-samples for all days of the simulations.
  ForeSchedule: TIntPoint2DArr;  // RU: Расписание прозноза: ForeSchedule[i] = (Period[0]; Period[1]) - начальный и конечный день прогноза 
                                 // EN: Prediction schedule: ForeSchedule[i] = (Period[0]; Period[1]) - the first and the ast day of the predictions
  ForecastDay: Integer;  // RU: Начальный день прогноза (отсчитывается от CurrDetDay) EN: The first day of the prediction (counted from CurrDetDay)
  HistStatusArr: THistStatusArr;  // RU: Массив гистограмм для различных периодов прогноза EN: Array of histograms for different prediction periods.
  LevelList: TDoubleArray;
  Forecast, DailyForecast: TForecastArr;  // RU: Массив параметров прогноза для всех периодов и ежедневный EN: The array of prediction parameters for all periods and daily. 
  DeathForecast: TDeathForecastArr;  //  RU: Массив параметров прогноза по смерти для всех периодов EN: The array of parameters for predictions of deceased individuals for all periods. 
  FullSimMode: Boolean;
  LenEC: Integer;  // RU: Количество эпицентров EN: The number of epicenters 
  DetDaysCount: Integer;  // RU: Количество дней с известными значениями cases EN: The number of days with the know number of cases. 
  FullDataArr: TIntArrayArr;  // RU: Массив сданными о пациентах по дням (0 - идекс дня в году, 1 - общее число случаев (Cases), 2 - Hospital, 3 - Dead)
                              // EN: Array with data about cases daily (0 - day index within a year, 1 - the total number of cases (Cases), 2 - Hospital, 3 - Dead)
  HospitalArr, FatalArr, FatalArr_1: TIntArray;   // RU: Массивы количества пациентов типа Hospital, Fatal (FatalArr_1 - альтернативный массив из DeathMA) 
                                                  // EN: The array of the number of patients of type Hospital, Fatal (FatalArr_1 - the alternative array from DeathMA)
  ShowTreat: Boolean;  // RU: Если True, товыводить общее количество лечащихся, иначе только госпитализированных  EN: If True, the total number of treated is presented, o/w only hospitalized.
  PreR0Hist, PostR0Hist: TRealHist;  // RU: Гистограммы распределения значений R0 до и после карантина EN: Histograms of values for R0 before and after the quarantine
  DeathMA: TIntegerPoint2DArr;  // RU: Массив суммарных количеств умерших по дням года  EN: The array of total quantities of deceased individuald by days of the year.
  MonthNameList: TStringList;  // RU: Список месяцев в году EN: The list of month within a year.
  IsLoadDeathMA: Boolean;  // RU: Загружен файл DeathMA  EN: The file DeathMA is loaded. 
  ChartForCopy: TChart;

function LoadCurrMap: Boolean;
procedure HandleUpDownClick(Button: TUDBtnType; aEditContr: TLabeledEdit; aDefValue, aStep, aMinValue, aMaxValue: Double); overload;
procedure HandleUpDownClick(Button: TUDBtnType; aEditContr: TLabeledEdit; aDefValue, aStep, aMinValue, aMaxValue: Double; aFormatStr: String); overload;
procedure HandleUpDownClick(Button: TUDBtnType; var aText: String; aDefValue, aStep, aMinValue, aMaxValue: Double; aFormatStr: String); overload;
procedure InitImgBitMap(const aBitMap: TBitMap);
function AngleDistance(aPoint1, aPoint2: TDoublePoint2D): Double;
function GetDetectParam(aDetectDistrParam: TDoublePoint2D): Integer;
function GetStageParam(aDetectParam: Integer): TIntegerPoint2D;
function GetStatusParam(aInfectTime, aDetect: Integer): Integer;
procedure AddPatientToList(const aPat: TPat; var aPatList: TPatList; var aPatCount: Integer);
function PatListToCSVList(const aPatList: TPatList; aPatCount: Integer; aDelim: String): TStringList;
function LoadPatByName(const aPatFileName: String; var aPatList: TPatList; var aPatCount: Integer): Boolean;
procedure FillDetPatStrGrid(const aPatList: TPatList; aPatCount, aMaxHeight: Integer; const aStrGrid: TStringGrid);
procedure DrawPatList(const aPatList: TPatList; aPatCount: Integer; const aMapPaintBox: TPaintBox);
procedure DrawContCircles(const aContCircles: TIntegerPoint3DArr; const aBitMap: TBitMap; aPenColor: TColor);
procedure FillContCirclesGrid(const aContCircles: TIntegerPoint3DArr; aMaxHeight: Integer; const aStrGrid: TStringGrid);
procedure DeleteContCircle(aInd: Integer; var aContCircles: TIntegerPoint3DArr);
function SelCircleInd(aX, aY: Integer; const aContCircles: TIntegerPoint3DArr): Integer;
function GetContParam(aCoord: TIntegerPoint2D; aAge: Integer; const aContCircles: TIntegerPoint3DArr; const aHiperParam: TDoublePoint2DArr): TIntegerPoint2D;
function GetContProbParam(aProbParam: Double; aAge: Integer): Double;
function GetAvrgRadDistParam(const aHiperParam: TDoublePoint2DArr; aAge: Integer): Integer;
procedure DeletePat(aInd: Integer; var aDetPatList: TPatList; var aDetPatCount: Integer);
function MapScale(aGeoLeftTop, aGeoRightBottom: TDoublePoint2D; aMapLeftTop, aMapRightBottom: TIntegerPoint2D): TDoublePoint2D;
function Infected(const aSource: TPat; aInfTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPat;
function SelDetPatInd(aX, aY: Integer; const aPatList: TPatList; const aPatCount: Integer): Integer;
procedure InitPatList(const aDetPatList: TPatList; aDetPatCount, aInitTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer);
procedure ExpandPatListAtTime(aCurrTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer);
procedure FillInfectStrGrid(const aPatList: TPatList; aPatCount, aDetPatCount: Integer; const aStrGrid: TStringGrid); overload;
procedure FillInfectStrGrid(const aStatusArr: TStatusArr; aSimulTime: Integer; const aStrGrid: TStringGrid); overload;
procedure SetZeroArray(const aArray: TIntegerPoint2DArr); overload;
procedure SetZeroArray(const aArray: TAgeHistArr); overload;
function ObjFunction(aIter: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aOptimPeriod: TIntegerPoint2D;
         var aPatList: TPatList; var aPatCount: Integer): Double;
procedure SetOptimalParamsArr(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aOptimPeriod: TIntegerPoint2D; aNumIterArr: Integer;
          const aStatusBar: TStatusBar; var aOptHiperParamArr: TDoublePoint2DArrArr; const aTreatSimulSeries, aTreatReallSeries: TLineSeries;
          var aOptInitContProbArr, aOptIsolContProbArr: TDoubleArray);
procedure SetAvrgOptimalParams(const aOptHiperParamArr: TDoublePoint2DArrArr; const aOptInitContProbArr, aOptIsolContProbArr: TDoubleArray;
          var aAvrgOptHiperParam: TDoublePoint2DArr; var aAvrgOptInitContProb, aAvrgOptIsolContProb: Double);
function R0forPat(const aSource: TPat; aNumIter: Integer): Double;
//function R0forDetPat(const aSource: TPat; aInfPeriod: TIntegerPoint2D; aNumIter: Integer): Double; overload;
function EmptyHiperParam(const aHiperParam: TDoublePoint2DArr): Boolean;
procedure UpdateStatusArr(const aPatList: TPatList; aPatCount, aCurrTime: Integer; const aStrGrid: TStringGrid; var aStatusArr: TStatusArr);
//procedure UpdateStatusArr_1(const aDetPatList, aPatList: TPatList; aDetPatCount, aPatCount, aCurrTime: Integer; var aStatusArr: TStatusArr);
function RandomAge(const aAgeDistrFunc: TDoublePoint2DArr; aRandVal: Double): Integer;
function GetAgeParam(aAgeDistrParam: TDoublePoint2D): Integer;
procedure SetZeroStatusAgeHistArr(var aStatusAgeHistArr: TStatusAgeHistArr);
function SimulCases(aSimulPeriod: TIntegerPoint2D; aIter: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
         var aPatList: TPatList; var aPatCount: Integer): TIntArray;
procedure CheckStatusArr(const aStatusArr: TStatusArr);
function InitNodes: TNodes;
function InitNodesArr(aSize: Integer): TNodesArr;
procedure UpdateNodes(const aPatList: TPatList; aPatCount: Integer; var aNodes: TNodes);
procedure SetStatusStrDay(const aNodes: TNodes; aStrInd: Integer; var aStatusStrArr: TStatusStrArr);
//function EpiCases(const aPatList, aDetPatList: TPatList; aPatCount, aDetPatCount: Integer): TIntArray;
function PatContacts(const aPat: TPat; aCurrTime: Integer): Integer;
procedure SetInitPatList(const aDetectECCounts: TIntArrayArr; aCurrDetDay: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer; var aStatusArr: TStatusArr);
procedure UpdatePatListStatus(aCheckTime, aPatCount: Integer; const aPatList: TPatList; var aChange: Integer);
procedure UpdateStatusArrEpi(const aPatList: TPatList; aPatCount, aCurrTime: Integer; var aStatusArr: TStatusArr);
procedure DrawCases(aIter: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; const aTreatSimulSeries, aTreatReallSeries: TLineSeries);
function MeanRealHist(const aRealHist: TRealHist): Double; overload;
function MeanRealHist(const aR0Arr: TDoubleArray): Double; overload;
function StdDevRealHist(const aRealHist: TRealHist; aMean: Double): Double; overload;
function StdDevRealHist(const aR0Arr: TDoubleArray; aMean: Double): Double; overload;

implementation

{$R *.dfm}

uses UnPKSimplex;

function Rad(aDeg: Double): Double;
  {RU: Возвращает значение географической широты и долготы в радианах, соответствующее значению в градусах aDeg.}
  {EN: Returns the value of the geographic lattitude and longitude in radians which corresponds to the value in degrees aDeg.}
begin
  Result:= Pi*aDeg/180;
end;  {LatRad}

function Deg(aRad: Double): Double;
  {RU: Возвращает значение географической широты и долготы в градусах, соответствующее значению в радианах aRad.}
  {EN: Returns the value of the geographic lattitude and longitude in degrees which corresponds to the value in radians aRad.}
begin
  Result:= 180*aRad/Pi;
end;

function LoadCurrMap: Boolean;
  {RU: Загрузка карты штата EN: The map loading}
begin
  Result:= False;
  if FileExists(MapFileName) then
    CurrMap.LoadFromFile(MapFileName)
  else
    Exit;
  Result:= CurrMap <> nil;
  if not Result then
    Exit;
  BuffBitMap.Assign(CurrMap);
  InitImgBitMap(MapBitMap);
  CurrMapSize:= IntegerPoint2D(CurrMap.Width, CurrMap.Height);
  CoordMapScale:= MapScale(GeoLeftTop, GeoRightBottom, MapLeftTop, MapRightBottom);
  CurrMapScale:= 0.5*(CoordMapScale[0] + CoordMapScale[1]);
end;

procedure ClearStrGrid(const aStrGrid: TStringGrid);
 { Clearing aStrGrid table }
var i, j: Integer;
begin
  for i:= 0 to aStrGrid.RowCount - 1 do
    for j:= 0 to aStrGrid.ColCount - 1 do
      aStrGrid.Cells[j, i]:= '';
  aStrGrid.RowCount:= 2;
end;

procedure ClearStrGridCont(const aStrGrid: TStringGrid);
 { Clearing Content of aStrGrid table }
var i, j: Integer;
begin
  for i:= 1 to aStrGrid.RowCount - 1 do
    for j:= 1 to aStrGrid.ColCount - 1 do
      aStrGrid.Cells[j, i]:= '';
end;

procedure ClearChart(const aChart: TChart);
var i: Integer;
begin
  for i:= 0 to aChart.SeriesList.Count - 1 do
    aChart.Series[i].Clear;
end;

procedure DeselectStrGrid(const aStrGrid: TStringGrid);
var aRect: TGridRect;
begin
  aRect.Left:= -1;
  aRect.Top:= -1;
  aRect.Bottom:= -1;
  aRect.Right:= -1;
  aStrGrid.Selection:= aRect;
end;

procedure SetStrGridHeight(const aStrGrid: TStringGrid; aMaxHeight: Integer);
var aHeight: Integer;
begin
  aHeight:= aStrGrid.RowCount * (aStrGrid.DefaultRowHeight + 1) + 1;
  aHeight:= Min(aHeight, aMaxHeight);
  aStrGrid.Height:= aHeight;
end;

procedure SetStatusText(const aStatusBar: TStatusBar; PanelInd: Integer; aStatusText: String);
begin
  if aStatusBar = nil then Exit;
  if PanelInd > aStatusBar.Panels.Count - 1 then Exit;
  if Trim(aStatusText) = '' then
    aStatusBar.Panels[PanelInd].Width:= 50
  else
    aStatusBar.Panels[PanelInd].Width:= aStatusBar.Canvas.TextWidth(aStatusText) + 30;
  aStatusBar.Panels[PanelInd].Text:= aStatusText;
end;

function YearDayText(aCurrTime: Integer): String;
  {RU: Возвращает текст с датой, соответствующей моменту aCurrTime относительно начального дня модели (CurrDeyDay с aCurrTime = 0) с дополнительным номером}
  {EN: Returns text with the date, which correspnds to the moment aCurrTime in relation to the initial moment for the model (CurrDeyDay with aCurrTime = 0) with an addiitonal number}
begin
  Result:= YearDays[aCurrTime + DetectDayInd] + ' (' + IntToStr(aCurrTime) + ')';
end;

function YearDayCalend(aCurrTime: Integer): String;
  {RU: Возвращает текст с датой, соответствующей моменту aCurrTime относительно начального дня модели (CurrDeyDay с aCurrTime = 0)}
  {EN: Returns the text with the date which corresponds to aCurrTime in relation to the initial time for the model (CurrDeyDay with aCurrTime = 0)}  
begin
  Result:= YearDays[aCurrTime + DetectDayInd];
end;

function ZeroStatus(const aStatus: TStatus): Boolean;
var i: Integer;
begin
  Result:= True;
  for i:= 0 to 6 do
    if aStatus[i] > 0 then begin
      Result:= False;
      Exit;;
    end;
end;

procedure PosParamUpDown(aSelParamCell: TIntegerPoint2D; const aParamUpDown: TUpDown; aMaxRow: Integer; const aStrGrid: TStringGrid);
var i, aX, aY, aCellVal: Integer;
begin
  aParamUpDown.Visible:= False;
  if (aSelParamCell[0] < 1)or(aSelParamCell[1] < 1)or(aSelParamCell[1] > aMaxRow) then Exit;
  aX:= 1;
  for i:= 0 to aSelParamCell[0] do
    aX:= aX + aStrGrid.ColWidths[i] + 1;
  aX:= aX - aParamUpDown.Width + aStrGrid.Left;
  aY:= 1;
  for i:= 0 to aSelParamCell[1] do
    aY:= aY + aStrGrid.RowHeights[i] + 1;
  aY:= aY - aParamUpDown.Height + aStrGrid.Top + 1;
  aParamUpDown.Left:= aX - 1;
  aParamUpDown.Top:= aY - 1;
  aCellVal:= StrToIntDef(aStrGrid.Cells[aSelParamCell[0], aSelParamCell[1]], 0);
  aParamUpDown.Position:= aCellVal;
  aParamUpDown.Visible:= True;
end;

procedure HandleUpDownClick(Button: TUDBtnType; aEditContr: TLabeledEdit; aDefValue, aStep, aMinValue, aMaxValue: Double);
{ Processing OnClick event for UpDown element }
var aCurrValue: Single;
begin
  aCurrValue:= StrToFloatDef(aEditContr.Text, aDefValue);
  case Button of
    btNext:
      aCurrValue:= aCurrValue + aStep;
    btPrev:
      aCurrValue:= aCurrValue - aStep;
  end; { case }
  aCurrValue:= Max(aMinValue, Min(aMaxValue, aCurrValue));
  aEditContr.Text:= FloatToStr(aCurrValue);
end;

procedure HandleUpDownClick(Button: TUDBtnType; aEditContr: TLabeledEdit; aDefValue, aStep, aMinValue, aMaxValue: Double; aFormatStr: String);
{ Processing OnClick event for UpDown element }
var aCurrValue: Single;
begin
  aCurrValue:= StrToFloatDef(aEditContr.Text, aDefValue);
  case Button of
    btNext:
      aCurrValue:= aCurrValue + aStep;
    btPrev:
      aCurrValue:= aCurrValue - aStep;
  end; { case }
  aCurrValue:= Max(aMinValue, Min(aMaxValue, aCurrValue));
  aEditContr.Text:= Format(aFormatStr, [aCurrValue]);
end;

procedure HandleUpDownClick(Button: TUDBtnType; var aText: String; aDefValue, aStep, aMinValue, aMaxValue: Double; aFormatStr: String);
{ Processing OnClick event for UpDown element }
var aCurrValue: Single;
begin
  aCurrValue:= StrToFloatDef(aText, aDefValue);
  case Button of
    btNext:
      aCurrValue:= aCurrValue + aStep;
    btPrev:
      aCurrValue:= aCurrValue - aStep;
  end; { case }
  aCurrValue:= Max(aMinValue, Min(aMaxValue, aCurrValue));
  aText:= Format(aFormatStr, [aCurrValue]);
end;

procedure SetLabeledEditOptions(const aSessionList: TStringList; const aEdit: TLabeledEdit; aIndText, aDefText: String);
begin
  aEdit.Text:= aSessionList.Values[aIndText];
  if aEdit.Text = '' then
    aEdit.Text:= aDefText;
end;

procedure InitImgBitMap(const aBitMap: TBitMap);
var aRect: TRect;
begin
  if aBitMap = nil then
    Exit;
  aBitMap.Height:= BuffBitMap.Height;
  aBitMap.Width:= BuffBitMap.Width;
  aRect.TopLeft:= Point(0, 0);
  aRect.BottomRight:= Point(BuffBitMap.Width - 1, BuffBitMap.Height - 1);
  aBitMap.Canvas.CopyRect(aRect, BuffBitMap.Canvas, aRect);
end;

procedure DrawAddPatPoint(const aBitMap: TBitMap; aCenter: TIntegerPoint2D; aRad: Integer; aColor: TColor);
var aRect: TRect;
begin
  aBitMap.Canvas.Brush.Color:= aColor;
  if aBitMap.Canvas.Brush.Bitmap <> nil then begin
    aBitMap.Canvas.Brush.Bitmap.TransparentMode:= tmAuto;
    aBitMap.Canvas.Brush.Bitmap.Transparent:= True;
  end;
  aBitMap.Canvas.Pen.Width:= 1;
  aBitMap.Canvas.Pen.Color:= aColor;
  aRect.TopLeft:= Point(aCenter[0] - aRad, aCenter[1] - aRad);
  aRect.BottomRight:= Point(aCenter[0] + aRad, aCenter[1] + aRad);
  aBitMap.Canvas.Ellipse(aRect);
end;

procedure DrawPatPoint(const aBitMap: TBitMap; aCenter: TIntegerPoint2D; aRad: Integer; aColor: TColor);
begin
  InitImgBitMap(aBitMap);
  DrawAddPatPoint(aBitMap, aCenter, aRad, aColor);
end;

function AngleDistance(aPoint1, aPoint2: TDoublePoint2D): Double;
  {RU: Возвращает угловое расстояние в радианах между географическими точками aPoint1, aPoint2 = (Long; Lat - в градусах)}
  {EN: Returns the distance in radians between the geographic points aPoint1, aPoint2 = (Long; Lat - in degrees)}
var aRadPoint1, aRadPoint2: TDoublePoint2D;
    aCos: Double;
begin
  aRadPoint1:= DoublePoint2D(Rad(aPoint1[0]), Rad(aPoint1[1]));
  aRadPoint2:= DoublePoint2D(Rad(aPoint2[0]), Rad(aPoint2[1]));
  aCos:= Cos(aRadPoint1[1])*Cos(aRadPoint2[1])*Cos(aRadPoint1[0] - aRadPoint2[0]) + Sin(aRadPoint1[1])*Sin(aRadPoint2[1]);
  aCos:= Min(1, aCos);
  Result:= ArcCos(aCos);
end;

function MapScale(aGeoLeftTop, aGeoRightBottom: TDoublePoint2D; aMapLeftTop, aMapRightBottom: TIntegerPoint2D): TDoublePoint2D;
  {RU: Возвращает масштаб текущей карты (в m/pixel) - (aHorScale, aVertScale). aGeoLeftTop, aGeoRightBottom - координаты на поверхности (Long; Lat - в градусах);
   aMapLeftTop, MapRightBottom - координаты на карте (X, Y  в пикселях)}
  {EN: Returns the scale of the currrent map (in m/pixel) - (aHorScale, aVertScale). aGeoLeftTop, aGeoRightBottom - coordinates on the surface (Long; Lat - in degrees);
   aMapLeftTop, MapRightBottom - coordinates on the map (X, Y  in pixels)}
var aHorScale1, aHorScale2, aVertScale, aAngle: Double;
    aMapDist: Integer;
begin
  aAngle:= Rad(aGeoRightBottom[0] - aGeoLeftTop[0]);
  aMapDist:= MapRightBottom[0] - aMapLeftTop[0];
  if aMapDist > 0 then begin
    aHorScale1:= (aAngle*EarthRad*Cos(Rad(aGeoLeftTop[1]))) / aMapDist;
    aHorScale2:= (aAngle*EarthRad*Cos(Rad(aGeoRightBottom[1]))) / aMapDist;
  end
  else begin
    aHorScale1:= 0;
    aHorScale2:= 0;
  end;
  aAngle:= Rad(aGeoLeftTop[1] - aGeoRightBottom[1]);
  aMapDist:= aMapRightBottom[1] - aMapLeftTop[1];
  if aMapDist > 0 then
    aVertScale:= (aAngle*EarthRad) / aMapDist
  else
    aVertScale:= 0;
  Result:= DoublePoint2D(0.5*(aHorScale1 + aHorScale2), aVertScale);
end;

function AngleMapScale(aGeoLeftTop, aGeoRightBottom: TDoublePoint2D; aMapLeftTop, aMapRightBottom: TIntegerPoint2D): TDoublePoint2D;
  {RU: Возвращает угловой масштаб текущей карты (в pixel/Grad) - (aHorAngleScale, aVertAngleScale). aGeoLeftTop, aGeoRightBottom - координаты на поверхности (Long; Lat - в градусах);
   aMapLeftTop, MapRightBottom - координаты на карте (X, Y  в пикселях)}
  {EN: Retursn the angle scale of the current map (in pixel/Grad) - (aHorAngleScale, aVertAngleScale). aGeoLeftTop, aGeoRightBottom - surface coordiantes (Long; Lat - в градусах);
   aMapLeftTop, MapRightBottom - coordinates on the map (X, Y  in pixels)}
var aAngle: Double;
    aMapDist: Integer;
begin
  aAngle:= aGeoRightBottom[0] - aGeoLeftTop[0];  // RU: Угол по долготе EN: Longitude angel
  aMapDist:= MapRightBottom[0] - aMapLeftTop[0];  // RU: Горизонтальное расстояние по карте EN: Horizontal distance on the map
  Result[0]:= aMapDist/aAngle;
  aAngle:= aGeoLeftTop[1] - aGeoRightBottom[1];
  aMapDist:= aMapRightBottom[1] - aMapLeftTop[1];
  Result[1]:= aMapDist/aAngle;
end;

function GetDetectParam(aDetectDistrParam: TDoublePoint2D): Integer;
  {RU: Возвращает случайное значения длительности инкубационного периода по aDetectParam (Mean, StdDev)}
  {EN: Returns the random value of the duration of the incubation period according to aDetectParam (Mean, StdDev)}
var aMean, aStdDev: Double;
begin
  if LogNorm then begin
    aStdDev:= Ln(1 + Sqr(aDetectDistrParam[1]/aDetectDistrParam[0]));  // RU: Квадрат En: Square aStdDev
    aMean:= Ln(aDetectDistrParam[0]) - 0.5*aStdDev;
    aStdDev:= Sqrt(aStdDev);
    Result:= Round(Exp(RandG(aMean, aStdDev)));
  end
  else
    Result:= Round(RandG(aDetectDistrParam[0], aDetectDistrParam[1]));
  Result:= Max(MinDetect, Min(MaxDetect, Result));
end;

function GetStageParam(aDetectParam: Integer): TIntegerPoint2D;
  {RU: Возвращает случайные значения длительности первой и второй стадий заболевания по aDetectParam (длительности инкубационногопериода)}
  {EN: Returns the random value of the duration for the first and the second stage of the disease accrding to aDetectParam (duration of the incubation period)}
var aStdDev, aStage, aVar: Double;
begin
  aStage:= 0.4*aDetectParam;   // RU: Номинальное значение Stage1 EN: Nominal value for Stage1
  aStdDev:= 0.2*aStage;
  aVar:= RandG(0, aStdDev);
  Result[0]:= Round(aStage + aVar);
  Result[0]:= Max(0, Result[0]);
  aStage:= 0.4*(aDetectParam - aStage);
  aStdDev:= 0.2*aStage;
  aVar:= RandG(0, aStdDev);
  Result[1]:= Round(aStage + aVar);
  Result[1]:= Max(0, Result[1]);
end;

function GetAgeParam(aAgeDistrParam: TDoublePoint2D): Integer;
  {RU: Возвращает случайное значения возраста пациента по aAgeDistrParam (Mean, StdDev)}
  {EN: Returns the random value of the patients age according to aAgeDistrParam (Mean, StdDev)}
var aRandVal: Double;
begin
  if NormalDistrAge then begin
    Result:= Round(RandG(aAgeDistrParam[0], aAgeDistrParam[1]));
    Result:= Max(1, Min(98, Result));
  end
  else begin
    aRandVal:= Random;
    Result:= RandomAge(MAAgeDistrFunc, aRandVal);
  end;
end;

function GetStatusParam(aInfectTime, aDetect: Integer): Integer;
  {RU: Возвращает статус (в виде индекса) по aInfectTime, aDetect}
  {EN: Retursn the status (as index) according to aInfectTime, aDetect}
var aOverlap: Integer;
begin
  Result:= -1;
  aOverlap:= CurrSimulTime - aInfectTime;   // RU: Время от начала инфекции до текущего момена. EN: Time from the infection onset to the current moment.
  if aOverlap <= 0 then Exit;   // RU: Время инфицирования в будущем EN: Time of the inection in the future.
  Result:= 0;   // RU: Зарегистрированный пациент EN: Registered patient/case
  if aInfectTime <= InitialTime then Exit;   // RU: Инфицирование до начала наблюдений - зарегистриргвнный ипациент EN: Infection before the study period - detected patient/case
  if aOverlap <= aDetect then
    Result:= 1    // RU: Инфицированный EN: Infected
  else
    Result:= 2;   // RU: Выявленный En: Detected
end;

function GetContParam(aCoord: TIntegerPoint2D; aAge: Integer; const aContCircles: TIntegerPoint3DArr; const aHiperParam: TDoublePoint2DArr): TIntegerPoint2D;
  {RU: Возвращает случайное значения параметров распределения (Mean, StdDev) для параметра Contacts в зависимости от координат пациента и возраста.}
  {EN: Returns the rnamdom values for parameters (Mean, StdDev) for the Contacts depending of the coordinates and age of the individual.}
var aSelCircleInd: Integer;
    aMeanSD, aStdDevSD: Double; // aMean, aHighMean, aMeanStdDev, aHighMeanStdDev,
    aTempMeanDistr: TDoublePoint2D;
begin
  //aMean:= 5;
  //aMeanStdDev:= 3;
  //aHighMean:= 10;
  //aHighMeanStdDev:= 4;
  aSelCircleInd:= SelCircleInd(aCoord[0], aCoord[1], aContCircles);
  if aSelCircleInd < 0 then
    aTempMeanDistr:= DoublePoint2D(aHiperParam[3, 0], aHiperParam[3, 1])
  else
    aTempMeanDistr:= DoublePoint2D(aHiperParam[4, 0], aHiperParam[4, 1]);
  if aAge < 10 then
    aTempMeanDistr[0]:= 0.7*aTempMeanDistr[0];
  if aAge > 60 then
    aTempMeanDistr[0]:= 0.5*aTempMeanDistr[0];
  Result[0]:= Round(RandG(aTempMeanDistr[0], aTempMeanDistr[1]));  // RU: Случайное значение параметра Contacts[0] EN: The random value of parameter Contacts[0]
  aMeanSD:= 0.4*aTempMeanDistr[0];
  aStdDevSD:= 0.4*aMeanSD;
  Result[1]:= Round(RandG(aMeanSD, aStdDevSD));   // RU: Случайное значение параметра Contacts[1] EN: The random value of parameter Contacts[1]
  Result[0]:= Max(0, Result[0]);
  Result[1]:= Max(1, Result[1]);
end;

function GetContProbParam(aProbParam: Double; aAge: Integer): Double;
  {RU: Возвращает случайное значения параметра ContProb в зависимости от aLambda - средней вероятности налчия контактов (в день) и возраста.}
  {EN: Returns the random value of parameter ContProb based on the value of aLambda - averaged probability of contacts per days and the age.}
var aMean, aStdDev: Double;   // , aRatio
begin
  aStdDev:= 0.05;
  aProbParam:= Max(0.05, aProbParam);
  aMean:= Ln(aProbParam) - 0.5*aStdDev*aStdDev;
  //aStdDev:= Sqrt(aStdDev);
  Result:= Exp(RandG(aMean, aStdDev));
  if aAge < 10 then
    Result:= 0.8*Result;
  if aAge > 60 then
    Result:= 0.6*Result;
  Result:= RoundTo(Result, -3);
  Result:= Min(1, Result);
end;

function GetAvrgRadDistParam(const aHiperParam: TDoublePoint2DArr; aAge: Integer): Integer;
  {RU: Возвращает случайное значения параметра AvrgRadDist (m) в зависимости от возраста.}
  {EN: Retursn the random value of parameter AvrgRadDist (m) based on the age.}
var aVal: Double;
begin
  aVal:= Max(0, RandG(aHiperParam[2, 0], aHiperParam[2, 1]));
  if aAge < 10 then
    aVal:= 0.7*aVal;
  if aAge > 60 then
    aVal:= 0.6*aVal;
  Result:= Round(aVal);
end;

function GetDisFormParam(const aDiseaseForm: TDiseaseForm; aAge: Integer): Integer;
  {RU: Возвращает случайное значение тяжести болезни пациента в зависимости от возраста по aDiseaseForm - вероятности формы болезни. 0- летальная, 1 - тяжелая, 2 - легкая}
  {EN: Возвращает случайное значение тяжести болезни пациента в зависимости от возраста по aDiseaseForm - вероятности формы болезни. 0- летальная, 1 - тяжелая, 2 - легкая}
var aAgeInd: Integer;
    aRandVal: Double;
begin
  aAgeInd:= 0;    // Индекс тяжести болезни в зависимости от возраста
  if aAge >= AgeLevel[1] then
    aAgeInd:= 2
  else
    if aAge >= AgeLevel[0] then
      aAgeInd:= 1;
  Result:= 2;
  aRandVal:= Random;
  if aRandVal < 0.01*aDiseaseForm[0, aAgeInd] then
    Result:= 0
   else
     if aRandVal < 0.01*(aDiseaseForm[0, aAgeInd] + aDiseaseForm[1, aAgeInd]) then
    Result:= 1;
end;

function GetDiseaseDuration(const aDiseaseDuration: TDiseaseDuration; aDisForm: Integer): Integer;
  {RU: Возвращает случайное значение длительности болезни в зависимости от тяжести (0- летальная, 1 - тяжелая, 2 - легкая) по aDiseaseDuration - параметров длительности болезни.}
  {EN: Returns the random duration of the disease based on severity (0- lethal, 1 - severe, 2 - mild) based on aDiseaseDuration - parameters of disease duration.}
var aMean, aStdDev: Double;
begin
  aMean:= aDiseaseDuration[aDisForm, 0];
  aStdDev:= aDiseaseDuration[aDisForm, 1];
  Result:= Round(RandG(aMean, aStdDev));
  Result:= Max(3, Result);
end;

procedure AddPatientToList(const aPat: TPat; var aPatList: TPatList; var aPatCount: Integer);
  {RU: Добавление пациента aPat в конец списка aPatList}
  {EN: The individual aPat is added to the end of the list aPatList}
var aLen: Integer;
begin
  if aPat.Status <> 0 then begin
    MessageDlg('The Patient is not Detected', mtInformation, [mbOk], 0);
    Exit;
  end;
  aLen:= Length(aPatList);
  if aLen <= aPatCount then begin
    Inc(aLen, 20000);
    SetLength(aPatList, aLen);
  end;
  aPatList[aPatCount]:= aPat;
  Inc(aPatCount);
end;

function PatToCSVStr(const aPat: TPat; aDelim: String): String;
  {RU: Возвращает параметры пациента в виде csv-строки (с разделителем aDelim)}
  {EN: Returns the indiivdual parameters as csv-string (with dividor aDelim)}
begin
  Result:= IntToStr(aPat.Coord[0]) + aDelim + IntToStr(aPat.Coord[1]) + aDelim;
  Result:= Result + IntToStr(aPat.EpiIndex) + aDelim;
  Result:= Result + IntToStr(aPat.InfectTime) + aDelim + IntToStr(aPat.Stage1) + aDelim + IntToStr(aPat.Stage2) + aDelim + IntToStr(aPat.Detect) + aDelim;
  Result:= Result + IntToStr(aPat.Age) + aDelim + IntToStr(aPat.AvrgRadDist) + aDelim + IntToStr(aPat.Contacts[0]) + aDelim + IntToStr(aPat.Contacts[1]) + aDelim;
  Result:= Result + Format('%4.2f', [aPat.ContProb]) + aDelim + IntToStr(aPat.Status);
end;

function PatListToCSVList(const aPatList: TPatList; aPatCount: Integer; aDelim: String): TStringList;
  {RU: Возвращает список типа TStringList с параметрами пациентов из aPatList}
  {EN: Returns the list of type TStringList with parameters from the list aPatList}
var i: Integer;
    aHeader, aStr: String;
begin
  Result:= TStringList.Create;
  aHeader:= 'Coord X' + aDelim + 'Coord Y' + aDelim + 'Epicenter' + aDelim + 'InfectTime' + aDelim + 'Stage 1' + aDelim + 'Stage 2' + aDelim + 'Detect' + aDelim;
  aHeader:= aHeader +  'Age' + aDelim + 'AvrgRadDist' + aDelim;      // 'DetectParam M' + aDelim + 'DetectParam SD' + aDelim +
  aHeader:= aHeader + 'Contacts M' + aDelim + 'Contacts SD' + aDelim + 'Cont Prob' + aDelim + 'Status';
  Result.Add(aHeader);
  for i:= 0 to aPatCount - 1 do begin
    aStr:= PatToCSVStr(aPatList[i], aDelim);
    Result.Add(aStr);
  end;
end;

procedure SavePatList(const aPatList: TPatList; aPatCount: Integer; const aSaveDialog: TSaveDialog);
var aPatStrList: TStringList;
    aDelim: String;
begin
  if aPatList = nil then begin
    MessageDlg('The Patient List is Empty', mtInformation, [mbOk], 0);
    Exit;
  end;
  aSaveDialog.Title:= 'Save Patients';
  aSaveDialog.Filter := 'CSV files (*.csv)|*.csv|Common files (*.*)|*.*';
  aSaveDialog.DefaultExt:= 'csv';
  aSaveDialog.FileName:= 'Detected Patients';
  if aSaveDialog.Execute then begin
    PatientsFileName:= aSaveDialog.FileName;
    aDelim:= ',';
    aPatStrList:= PatListToCSVList(aPatList, aPatCount, aDelim);
    aPatStrList.SaveToFile(PatientsFileName);
  end;
end;

function GetDelim(aStr: String): String;
  {RU: Возвращает разделитель, содержащийся в строке. Если разделитель не найден, то Result = ''.}
  {EN: Returns the delimiter from the string. If not found then то Result = ''.}
begin
  Result:= '';
  if Pos(',', aStr) > 0 then
    Result:= ','
  else
    if Pos(';', aStr) > 0 then
      Result:= ';'
    else
      if Pos(' ', aStr) > 0 then
        Result:= ' ';
end;

function GetDelimDate(aStr: String): String;
  {RU: Возвращает разделитель, содержащийся в строке с датой. Если разделитель не найден, то Result = ''.}
  {EN: Returns the delimiter from the string with the date. If not found then то Result = ''.}
begin
  Result:= '';
  if Pos('.', aStr) > 0 then
    Result:= '.'
  else
    if Pos('/', aStr) > 0 then
      Result:= '/'
    else
      if Pos('-', aStr) > 0 then
      Result:= '-';
end;

procedure SetIntPatParam(var aPatParam: Integer; var aStr: String; aDelim: String);
  {RU: Устанавливает очередное значение целого параметра aPatParam по текущей строке aStr}
  {EN: Returns the next value of the integer valued parameter aPatParam based on the current value from aStr}
var aDataStr: String;
    aInd: Integer;
begin
  aInd:= Pos(aDelim, aStr);
  if aInd = 0 then
    aDataStr:= aStr
  else
    aDataStr:= Copy(aStr, 1, aInd - 1);
  aPatParam:= StrToIntDef(aDataStr, 0);
  Delete(aStr, 1, aInd);
end;

procedure SetFloatPatParam(var aPatParam: Double; var aStr: String; aDelim: String);
  {RU: Устанавливает очередное знаение вещественного параметра aPatParam по текущей строке aStr}
  {EN: Returns the next value of the real valued parameter aPatParam based on the current value from aStr}
var aDataStr: String;
    aInd: Integer;
begin
  aInd:= Pos(aDelim, aStr);
  if aInd = 0 then
    aDataStr:= aStr
  else
    aDataStr:= Copy(aStr, 1, aInd - 1);
  aPatParam:= StrToFloatDef(aDataStr, 0);
  Delete(aStr, 1, aInd);
end;

function CSVStrToPat(const aPatStr: String; aDelim: String): TPat;
  {RU: Возвращает параметры пациента по csv-строке aPatStr (с разделителем aDelim)}
  {EN: Returns the parameters of the individual based on csv-sting aPatStr (with dividor aDelim)}
var aStr: String;
begin
  aStr:= Trim(aPatStr);
  SetIntPatParam(Result.Coord[0], aStr, aDelim);
  SetIntPatParam(Result.Coord[1], aStr, aDelim);
  SetIntPatParam(Result.EpiIndex, aStr, aDelim);
  SetIntPatParam(Result.InfectTime, aStr, aDelim);
  SetIntPatParam(Result.Stage1, aStr, aDelim);
  SetIntPatParam(Result.Stage2, aStr, aDelim);
  SetIntPatParam(Result.Detect, aStr, aDelim);
  SetIntPatParam(Result.Age, aStr, aDelim);
  SetIntPatParam(Result.AvrgRadDist, aStr, aDelim);
  SetIntPatParam(Result.Contacts[0], aStr, aDelim);
  SetIntPatParam(Result.Contacts[1], aStr, aDelim);
  SetFloatPatParam(Result.ContProb, aStr, aDelim);
  SetIntPatParam(Result.Status, aStr, aDelim);
end;

function LoadPatByName(const aPatFileName: String; var aPatList: TPatList; var aPatCount: Integer): Boolean;
  {RU: Загрузка csv-файла aPatFileName с данными о пациентах в список пациентов aPatList. Если файл найден, то Result = True.}
  {EN: Loads the csv-file aPatFileName with the data about patients inthe list aPatList. If file not found, then Result = True.}
var i: Integer;
    aPatDataList: TStringList;
    aHeadStr, aDelim, aPatStr: String;
    aPat: TPat;
begin
  Result:= False;
  if not FileExists(aPatFileName) then Exit;
  aPatDataList:= TStringList.Create;
  aPatDataList.LoadFromFile(aPatFileName);
  aPatCount:= aPatDataList.Count - 1;
  if aPatCount < 1 then Exit;
  aHeadStr:= aPatDataList[0];
  aDelim:= GetDelim(aHeadStr);
  if aDelim = '' then Exit;
  if Pos('InfectTime', aHeadStr) < 1 then begin
    MessageDlg('This is not the Patients Parameters file', mtInformation, [mbOk], 0);
    Exit;
  end;
  for i:= 0 to aPatCount - 1 do begin
    aPatStr:= aPatDataList[i + 1];
    aPat:= CSVStrToPat(aPatStr, aDelim);
    aPatList[i]:= aPat;
  end;
  Result:= True;
  DetListChanged:= False;
end;

procedure LoadDefaultDetPat(var aDetPatList: TPatList; var aPatCount: Integer);
  {RU: Загрузка списка выявленных пациентов из файла по умолчанию}
  {EN: Loading o the list of detected individuals from file by default}
var aPatFileName: String;
begin
  aPatFileName:= CurrentDirectory +  '\Data\Detected Patients.csv';
  LoadPatByName(aPatFileName, aDetPatList, aPatCount);
end;

procedure FillDetPatStrGrid(const aPatList: TPatList; aPatCount, aMaxHeight: Integer; const aStrGrid: TStringGrid);
var i: Integer;
    aPat: TPat;
begin
  ClearStrGrid(aStrGrid);
  if aPatCount < 1 then Exit;
  aStrGrid.RowCount:= aPatCount + 1;
  if aPatList = nil then Exit;
  aStrGrid.Cells[0, 0]:= 'No.';
  aStrGrid.Cells[1, 0]:= ' X';
  aStrGrid.Cells[2, 0]:= ' Y';
  aStrGrid.Cells[3, 0]:= 'Infect';
  aStrGrid.Cells[4, 0]:= ' Age';
  //aStrGrid.Cells[5, 0]:= ' R0';
  aStrGrid.Cells[5, 0]:= ' Form';
  aStrGrid.Cells[6, 0]:= ' Treat';
  aStrGrid.Cells[7, 0]:= 'Status';
  for i:= 0 to aPatCount - 1 do begin // Row
    aPat:= aPatList[i];
    aStrGrid.Cells[0, i + 1]:= IntToStr(i + 1);   // No.
    aStrGrid.Cells[1, i + 1]:= IntToStr(aPat.Coord[0]);   // X
    aStrGrid.Cells[2, i + 1]:= IntToStr(aPat.Coord[1]);   // Y
    aStrGrid.Cells[3, i + 1]:= IntToStr(aPat.InfectTime);   // Infect
    aStrGrid.Cells[4, i + 1]:= IntToStr(aPat.Age);   // Age
    //aStrGrid.Cells[5, i + 1]:= Format('%4.2f', [aPat.R0]);   // R0
    aStrGrid.Cells[5, i + 1]:= DisFormStr[aPat.DisForm];   // DiseaseForm
    aStrGrid.Cells[6, i + 1]:= IntToStr(aPat.DiseaseDur);   // DiseaseDuration
    aStrGrid.Cells[7, i + 1]:= IntToStr(aPat.Status);   // Status
  end;
  SetStrGridHeight(aStrGrid, aMaxHeight);
end;

function CurrDetPatCount(const aDetPatList: TPatList; aDetPatCount, aCurrSimulTime: Integer): Integer;
  {RU: Возвращает количество детектированных пациентов, инфицированных не позднее aCurrSimulTime}
  {EN: Returns the amount of detected individuals, that were infected no later then aCurrSimulTime}
var i: Integer;
begin
  Result:= 0;
  for i:= 0 to aDetPatCount - 1 do
    if aDetPatList[i].InfectTime <= aCurrSimulTime then
      Inc(Result);
end;

procedure FillInfectStrGrid(const aPatList: TPatList; aPatCount, aDetPatCount: Integer; const aStrGrid: TStringGrid);
  {RU: Отображает количество пациентов с различным статусом}
  {EN: Returns the number of individuals with different statuses}
var i, aInfCount, aIsoolCount: Integer;
begin
  aStrGrid.Cells[0, 0]:= 'Status';
  aStrGrid.Cells[0, 1]:= 'Detected';
  aStrGrid.Cells[0, 2]:= 'Infected';
  aStrGrid.Cells[0, 3]:= 'Isolated';
  aStrGrid.Cells[0, 4]:= 'Sum';
  aStrGrid.Cells[1, 0]:= 'Count';
  aStrGrid.Cells[1, 1]:= IntToStr(aDetPatCount);
  aInfCount:= 0;
  aIsoolCount:= 0;
  for i:= 0 to aPatCount - 1 do begin
    if aPatList[i].Status = 1 then
      Inc(aInfCount)
    else
      if aPatList[i].Status = 2 then
        Inc(aIsoolCount);
  end;
  aStrGrid.Cells[1, 2]:= IntToStr(aInfCount);
  aStrGrid.Cells[1, 3]:= IntToStr(aIsoolCount);
  aStrGrid.Cells[1, 4]:= IntToStr(aIsoolCount + aInfCount);
  DeselectStrGrid(aStrGrid);
end;

procedure FillInfectStrGrid(const aStatusArr: TStatusArr; aSimulTime: Integer; const aStrGrid: TStringGrid);
  {RU: Отображает количество пациентов с различным статусом: 0 - инфицированные, 1 - изолированные}
  {EN: Displays the number of patients with diferent statuses: 0 - infected, 1 - isolated}
var i: Integer;
begin
  aStrGrid.Cells[0, 0]:= 'Status';
  aStrGrid.Cells[0, 1]:= 'Infected';
  aStrGrid.Cells[0, 2]:= 'Treated';
  aStrGrid.Cells[0, 3]:= 'Recovered';
  aStrGrid.Cells[0, 4]:= 'Dead';
  aStrGrid.Cells[0, 5]:= 'Cases';
  aStrGrid.Cells[1, 0]:= 'Count';
  for i:= 1 to 4 do
    aStrGrid.Cells[1, i]:= IntToStr(aStatusArr[aSimulTime, i]);
  aStrGrid.Cells[1, 5]:= IntToStr(aStatusArr[aSimulTime, 6]);
  DeselectStrGrid(aStrGrid);
end;

procedure DrawPatList(const aPatList: TPatList; aPatCount: Integer; const aMapPaintBox: TPaintBox);
var i, aStatus: Integer;
    aColor: TColor;
begin
  if not DrawInfected then Exit;
  for i:= 0 to aPatCount - 1 do begin
    aStatus:= aPatList[i].Status;
    if aStatus <> 1 then Continue;
    aColor:= $00D78CD7;
    //case aStatus of
      //1: aColor:= $00D78CD7;
      //2: aColor:= clRed;
      //4: aColor:= clBlue;
    //else
    //  Continue;
    //end;
    DrawAddPatPoint(MapBitMap, aPatList[i].Coord, 2, aColor);
  end;
end;

procedure DrawDetPatList(const aDetPatList: TPatList; aDetPatCount: Integer; aCurrSimulTime, aRad: Integer; aColor: TColor; const aMapPaintBox: TPaintBox);
var i: Integer;
begin
  for i:= 0 to aDetPatCount - 1 do
      DrawAddPatPoint(MapBitMap, aDetPatList[i].Coord, aRad, aColor);
end;

procedure DrawContCircle(const aBitMap: TBitMap; aCenter: TIntegerPoint2D; aRad: Integer; aColor: TColor);
var aRect: TRect;
begin
  aBitMap.Canvas.Brush.Style:= bsClear;
  aBitMap.Canvas.Pen.Width:= 1;
  aBitMap.Canvas.Pen.Color:= aColor;
  aRect.TopLeft:= Point(aCenter[0] - aRad, aCenter[1] - aRad);
  aRect.BottomRight:= Point(aCenter[0] + aRad, aCenter[1] + aRad);
  aBitMap.Canvas.Ellipse(aRect);
end;

procedure DrawContCircles(const aContCircles: TIntegerPoint3DArr; const aBitMap: TBitMap; aPenColor: TColor);
var aRect: TRect;
    i, aRad: Integer;
    aPoint: TIntegerPoint3D;
begin
  aBitMap.Canvas.Brush.Color:= aPenColor;
  aBitMap.Canvas.Brush.Style:= bsClear;
  aBitMap.Canvas.Pen.Width:= 1;
  aBitMap.Canvas.Pen.Color:= aPenColor;
  aBitMap.Canvas.Pen.Style:= psSolid;
  for i:= 0 to Length(aContCircles) - 1 do begin
    aPoint:= aContCircles[i];
    aRad:= aPoint[2];
    aRect.TopLeft:= Point(aPoint[0] - aRad, aPoint[1] - aRad);
    aRect.BottomRight:= Point(aPoint[0] + aRad, aPoint[1] + aRad);
    aBitMap.Canvas.Ellipse(aRect);
  end;
end;

procedure AddContCirclesToSession(const aContCircles: TIntegerPoint3DArr; const aSessionList: TStringList);
var i, aLen: Integer;
    aPrefix, aStr, aDelim: String;
    aPoint: TIntegerPoint3D;
begin
  aLen:= Length(aContCircles);
  aDelim:= ',';
  aSessionList.Add('ContCirclesCount=' + IntToStr(aLen));
  for i:= 0 to aLen - 1 do begin
    aPoint:= aContCircles[i];
    aPrefix:= 'ContCirc_' + IntToStr(i) + '=';
    aStr:= IntToStr(aPoint[0]) + aDelim + IntToStr(aPoint[1]) + aDelim + IntToStr(aPoint[2]) + aDelim;
    aSessionList.Add(aPrefix + aStr);
  end;
end;

procedure AddHiperParamToSession(const aHiperParam: TDoublePoint2DArr; const aSessionList: TStringList);
var i, aLen: Integer;
    aPrefix, aStr, aDelim: String;
    aParam: TDoublePoint2D;
begin
  aLen:= Length(aHiperParam);
  aDelim:= ',';
  aSessionList.Add('HiperParamCount=' + IntToStr(aLen));
  for i:= 0 to aLen - 1 do begin
    aParam:= aHiperParam[i];
    aPrefix:= 'HiperParam_' + IntToStr(i) + '=';
    aStr:= Format('%4.2f', [aParam[0]]) + aDelim + Format('%4.2f', [aParam[1]]);
    aSessionList.Add(aPrefix + aStr);
  end;
end;

function ContCirclesFromList(const aSessionList: TStringList): TIntegerPoint3DArr;
var i, j, aLen: Integer;
    aPrefix, aStr, aDelim: String;
    aPoint: TIntegerPoint3D;
begin
  Result:= nil;
  if aSessionList = nil then
    Exit;
  aDelim:= ',';
  aLen:= StrToIntDef(aSessionList.Values['ContCirclesCount'], 0);
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do begin
    aPrefix:= 'ContCirc_' + IntToStr(i);
    aStr:= aSessionList.Values[aPrefix];
    for j:= 0 to 2 do
      SetIntPatParam(aPoint[j], aStr, aDelim);
    Result[i]:= aPoint;
  end;
end;

function HiperParamFromList(const aSessionList: TStringList): TDoublePoint2DArr;
var i, j, aLen: Integer;
    aPrefix, aStr, aDelim: String;
begin
  Result:= nil;
  if aSessionList = nil then
    Exit;
  aDelim:= ',';
  aLen:= StrToIntDef(aSessionList.Values['HiperParamCount'], 0);
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do begin
    aPrefix:= 'HiperParam_' + IntToStr(i);
    aStr:= aSessionList.Values[aPrefix];
    for j:= 0 to 1 do
      SetFloatPatParam(Result[i, j], aStr, aDelim);
  end;
end;

procedure FillContCirclesGrid(const aContCircles: TIntegerPoint3DArr; aMaxHeight: Integer; const aStrGrid: TStringGrid);
var i, aLen: Integer;
    aPoint: TIntegerPoint3D;
begin
  ClearStrGrid(aStrGrid);
  if aContCircles = nil then Exit;
  aLen:= Length(aContCircles);
  aStrGrid.RowCount:= aLen + 1;
  aStrGrid.Cells[0, 0]:= 'No.';
  aStrGrid.Cells[1, 0]:= ' X';
  aStrGrid.Cells[2, 0]:= ' Y';
  aStrGrid.Cells[3, 0]:= 'Rad';
  for i:= 0 to aLen - 1 do begin
    aPoint:= aContCircles[i];
    aStrGrid.Cells[0, i + 1]:= IntToStr(i + 1);   // No.
    aStrGrid.Cells[1, i + 1]:= IntToStr(aPoint[0]);   // X
    aStrGrid.Cells[2, i + 1]:= IntToStr(aPoint[1]);   // Y
    aStrGrid.Cells[3, i + 1]:= IntToStr(aPoint[2]);   // Rad
  end;
  SetStrGridHeight(aStrGrid, aMaxHeight);
end;

procedure DeleteContCircle(aInd: Integer; var aContCircles: TIntegerPoint3DArr);
  {RU: Удаление элемента aInd из aContCircles}
var i, aLen: Integer;
begin
  aLen:= Length(aContCircles);
  for i:= aInd to aLen - 2 do
    aContCircles[i]:= aContCircles[i + 1];
  SetLength(aContCircles, aLen - 1);
end;

function SelCircleInd(aX, aY: Integer; const aContCircles: TIntegerPoint3DArr): Integer;
  {RU: Возвращает индекс элемента массива aContCircles по координатам точки (aX, aY) внутри круга. Если круг не найден, то Result = -1.}
  {EN: Returns index of the element from array aContCircles based on coordinates of a point (aX, aY) inside circle. If the circle is not found then Result = -1.}
var i: Integer;
    aContCircle: TIntegerPoint3D;
    aCenter, aPoint: TIntegerPoint2D;
    aDist, aMinDist: Double;
begin
  Result:= -1;
  aPoint:= IntegerPoint2D(aX, aY);
  aMinDist:= 1000;
  for i:= 0 to Length(aContCircles) - 1 do begin
    aContCircle:= aContCircles[i];
    aCenter:= IntegerPoint2D(aContCircle[0], aContCircle[1]);
    aDist:= DistPoints(aCenter, aPoint);
    if (aDist <= aContCircle[2])and(aDist <= aMinDist) then begin
      Result:= i;
      aMinDist:= aDist;
    end;
  end;
end;

function SelECInd(aX, aY: Integer; const aEpicenters: TEpicenters): Integer;
  {RU: Возвращает индекс элемента массива aEpicenters по координатам точки (aX, aY) внутри круга. Если круг не найден, то Result = -1.}
  {EN: Returns index of the element from array aEpicenters based on coordinates of a point (aX, aY) inside circle. If the circle is not found then Result = -1.}
var i: Integer;
    aPoint: TIntegerPoint2D;
    aDist, aMinDist: Double;
    aEpicenter: TEpicenter;
begin
  Result:= -1;
  aPoint:= IntegerPoint2D(aX, aY);
  aMinDist:= 1000;
  for i:= 0 to LenEC - 1 do begin
    aEpicenter:= aEpicenters[i];
    aDist:= DistPoints(aPoint, aEpicenter.Center);
    if (aDist <= aEpicenter.Radius)and(aDist <= aMinDist) then begin
      Result:= i;
      aMinDist:= aDist;
    end;
  end;
end;

function SelDetPatInd(aX, aY: Integer; const aPatList: TPatList; const aPatCount: Integer): Integer;
  {RU: Возвращает индекс пациента из массива aDetPatList по координатам точки (aX, aY). Если пациен не найден, то Result = -1.}
  {EN: Returns index of the individual from array aDetPatList based on coordinates of a point (aX, aY) inside circle. If the individual is not found then Result = -1.}
var i, aRad: Integer;
    aPatCoord, aPoint: TIntegerPoint2D;
    aDist: Double;
begin
  Result:= -1;
  aPoint:= IntegerPoint2D(aX, aY);
  aRad:= 4;
  for i:= 0 to aPatCount - 1 do begin
    aPatCoord:= aPatList[i].Coord;
    aDist:= DistPoints(aPatCoord, aPoint);
    if aDist <= aRad then begin
      Result:= i;
      Exit;
    end;
  end;
end;

function InfectCood(const aSource: TPat): TIntegerPoint2D;
  {RU: Возвращает координаты инфицированного пациента, зараженного пациентом  aSource}
  {EN: Returns the coordinates of the infecte individual, which was infected by individual aSource}
var aRad, aAngle, aRandVal: Double;
    var i: Integer;
begin
  for i:= 0 to 1000 do begin
    aRandVal:= Random;
    aRandVal:= Min(0.998, aRandVal);
    aRad:= -aSource.AvrgRadDist*Ln(1 - aRandVal);   // RU: Симуляция показательного распределения со средним AvrgRadDist в m EN: Simulaton of the display distribution with an average AvrgRadDist in m
    aRad:= aRad/CurrMapScale;  // RU: В пикселях  EN: In pixels.
    aAngle:= 2*Pi*Random;  // RU: Угол равномерно распределен на [0; 2*Pi]  EN: The angle of the uniform distribution on [0; 2*Pi]
    Result[0]:= Round(aRad*Cos(aAngle));
    Result[1]:= Round(aRad*Sin(aAngle));
    Result[0]:= Result[0] + aSource.Coord[0];
    Result[1]:= Result[1] + aSource.Coord[1];
    if (Result[0] >= 0)and(Result[0] < CurrMapSize[0])and(Result[1] >= 0)and(Result[1] < CurrMapSize[1])and(not WaterMask[Result[0], Result[1]]) then Exit;
  end;
end;

function Infected(const aSource: TPat; aInfTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPat;
  {RU: Возвращает инфицированного пациента, зараженного пациентом  aSource в момент aInfTime}
  {EN: Returns the infected individual, whiich was infected by aSource at time aInfTime}
var aDetectParam: Integer;
    aStageParam: TIntegerPoint2D;
    aLambda, aRandom: Double;
begin
  Result:= ZeroPat;
  if aSource.InfectTime >= aInfTime then Exit;   // RU: Пациент еще не инфицирует других (в день своего инфицирования aSource не заразен) EN: The idnividual is not infecting others (not infectious at first day aSource)
  if (aSource.InfectTime + aSource.Detect) <= aInfTime then Exit;   // RU: Пациент изолирован и не инфицирует других (в день детекции aSource не заразен) 
                                                                    // EN: The individual is isolated and not infecting the others (not infectious at first day aSource)
  aRandom:= Random;
  if (aRandom > aSource.ContProb) then Exit;   // RU: В этот день контактов нет EN: Not contacts at a given day
  Result.Status:= 1;  // RU: Инфицированный EN: Infected
  Result.Coord:= InfectCood(aSource);
  Result.EpiIndex:= aSource.EpiIndex;
  Result.InfectTime:= aInfTime;
  aDetectParam:= GetDetectParam(aHiperParam[0]);
  Result.Detect:= aDetectParam;
  aStageParam:= GetStageParam(aDetectParam);
  Result.Stage1:= aStageParam[0];
  Result.Stage2:= aStageParam[1];
  Result.Age:= GetAgeParam(aHiperParam[1]);
  Result.AvrgRadDist:= GetAvrgRadDistParam(aHiperParam, Result.Age);
  Result.Contacts:= GetContParam(Result.Coord, Result.Age, ContCircles, aHiperParam); // RU: Количество контактов пациента Result EN: The amount of contacts of the individual Result
  if aInfTime < IsolTime then
    aLambda:= aInitContProb
  else
    aLambda:= aIsolContProb;
  Result.ContProb:= GetContProbParam(aLambda, Result.Age);
  Result.DisForm:= GetDisFormParam(DiseaseForm, Result.Age);
  Result.DiseaseDur:= GetDiseaseDuration(DiseaseDuration, Result.DisForm);
  Result.R0:= 0;
end;

function SpreadInfection(const aSource: TPat): Boolean;
    {RU: Если  aSource распространил инфекцию, то Result = True}
var aRandom: Double;
begin
  aRandom:= Random;
  Result:= aRandom < aSource.ContProb;   // RU: В этот день есть контакт EN: There is a contact on the given day. 
end;

procedure DeletePat(aInd: Integer; var aDetPatList: TPatList; var aDetPatCount: Integer);
  {RU: Удаление элемента aInd из aDetPatList}
  {EN: Deletion of the element aInd from aDetPatList}
var i: Integer;
begin
  if aDetPatCount < 1 then Exit;
  if aInd >= aDetPatCount then Exit;
  for i:= aInd to aDetPatCount - 1 do
    aDetPatList[i]:= aDetPatList[i + 1];
  Dec(aDetPatCount);
end;

procedure AddInfectForPat(const aSource: TPat; aInfTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer);
  {RU: Добавление к списку aPatList пациентов, инфицированных пациентом aSource, в aInfTime. aPatCount - текущее количество инфицированных пациентов.}
  {EN: Adding new individuals to the list aPatList  which were infected by aSource in aInfTime. aPatCount - the current qunatity of infected individuals.}
var i, aContacts, aLen: Integer;
    aPat: TPat;
    aContVal: Double;
begin
  aLen:= Length(aPatList);
  if aPatCount >= aLen - 1 then begin
    aLen:= aLen + 200000;
    SetLength(aPatList, aLen);
  end;
  aContVal:= RandG(aSource.Contacts[0], aSource.Contacts[1]);  // RU: Количество контактов пациента aSource EN: The amount of contacts of the individual aSource
  if (aInfTime < aSource.InfectTime)or(aInfTime > (aSource.InfectTime + aSource.Detect)) then Exit;
  if aInfTime < (aSource.InfectTime + aSource.Stage1) then   // RU: Первая стадия заражения EN: The first infection stage
    aContVal:= 0.2*aContVal;
  if aInfTime >= (aSource.InfectTime + aSource.Stage2) then   // RU: Третья стадия заражения EN: The third stage of infection
    aContVal:= 1.5*aContVal;
  aContacts:= Max(0, Round(aContVal));
  for i:= 0 to aContacts - 1 do begin
    aPat:= Infected(aSource, aInfTime, aHiperParam, aInitContProb, aIsolContProb);
    if (aPat.Status = 1)and((aInfTime + aPat.Detect) >= CurrSimulTime) then begin
      aPatList[aPatCount]:= aPat;
      Inc(aPatCount);
    end;
  end;
end;

procedure UpdateDetPatList(const aDetPatList: TPatList; aDetPatCount, aCurrTime: Integer; var aCasesCount: Integer);
  {RU: Обновление статуса пациентов из aDetPatList в момент aCurrTime}
  {EN: The status change for individuals aDetPatList at time aCurrTime}
var i, aInitStatus: Integer;
    aDetPat: TPat;
begin
  aCasesCount:= 0;
  for i:= 0 to aDetPatCount - 1 do begin
    aDetPat:= aDetPatList[i];
    aInitStatus:= aDetPat.Status;
    if aCurrTime < aDetPat.InfectTime then Continue;   // RU: Пациент еще не заражен EN: Individual is not infected
    if aCurrTime <= (aDetPat.InfectTime + aDetPat.Detect) then  // RU: Пациент инфицирован EN: The individual is infected
      aDetPatList[i].Status:= 1
    else
      if aCurrTime <= (aDetPat.InfectTime + aDetPat.Detect + aDetPat.DiseaseDur) then begin  // RU: Пациент на лечении EN: Individual is treated
        aDetPatList[i].Status:= 2;
        if aInitStatus = 1 then
          Inc(aCasesCount);
      end
      else begin   // RU: Лечение закончилось EN: Treatment is over
        if aDetPatList[i].DisForm = 0 then
          aDetPatList[i].Status:= 4   // RU: Пациент умер EN: Individual deceased
        else
          aDetPatList[i].Status:= 3;  // RU: Пациент здоров EN: Individual recovered
    end;
  end;
end;

procedure UpdateDetPatList_2(const aDetPatList: TPatList; aDetPatCount, aCurrTime: Integer; var aChangeStatus: Integer);
  {RU: Обновление статуса пациентов из aDetPatList в момент aCurrTime. aInfDetCount - количество инфицированных пациентов (Status = 1),
   перешедших в детектированные (Status = 2) в каждом эпицентре. Предполагается, что aInfDetCount инициирован.}
  {EN: Update of individual's statuses from aDetPatList at time aCurrTime. aInfDetCount - the number of infected individuals (Status = 1),
   which have been moved to detected (Status = 2) at each epicenter. It is assumed that aInfDetCount is infected.}
var i, aInitStatus: Integer;
    aDetPat: TPat;
begin
  aChangeStatus:= 0;
  for i:= 0 to aDetPatCount - 1 do begin
    aDetPat:= aDetPatList[i];
    aInitStatus:= aDetPat.Status;
    if aCurrTime < aDetPat.InfectTime then Continue;   // RU: Пациент еще не заражен EN: Individual is not inected yet.
    if aCurrTime < (aDetPat.InfectTime + aDetPat.Detect) then  // RU: Пациент инфицирован, но не детектирован EN: Individual is infected but not yet detected as such.
      aDetPatList[i].Status:= 1
    else
      if aCurrTime <= (aDetPat.InfectTime + aDetPat.Detect + aDetPat.DiseaseDur) then begin  // RU: Пациент детектирован и на лечении EN: The individual is detected and is treated.
        aDetPatList[i].Status:= 2;
      end
      else begin   // RU: Лечение закончилось EN: Treatment is over
        if aDetPatList[i].DisForm = 0 then
          aDetPatList[i].Status:= 4   // RU: Пациент умер EN: Individual deceased
        else
          aDetPatList[i].Status:= 3;  // RU: Пациент здоров EN: Individual recovered
    end;
    if aDetPatList[i].Status <> aInitStatus then
      Inc(aChangeStatus);
  end;
end;

function PatStatusCounts(const aPatList: TPatList; aPatCount: Integer): TIntegerPoint2D;
  {RU: Возвращает количества пациентов со статусом 1 - инфицированные, 2 - изолированные}
  {EN: Returns the number of individuals with statuses 1 - infected, 2 - isolated}
var i, aStatus: Integer;
begin
  Result:= ZeroIntegerPoint2D;
  for i:= 0 to aPatCount - 1 do begin
    aStatus:= aPatList[i].Status;
    if aStatus = 1 then
      Inc(Result[0]);
    if aStatus = 2 then
      Inc(Result[1]);
  end;
end;

function AgeHist(const aPatList: TPatList; aPatCount, aSimulTime: Integer): TAgeHist;
  {RU: Возвращает гистограмму распределения возрастов в массиве aPatList}
  {EN: Returns the histogram of the ditributin of the ages in array aPatList}
var i, aIntervCount, aInd, aSum, aAge: Integer;
begin
  aIntervCount:= 10;
  aSum:= 0;
  for i:= 0 to aIntervCount - 1 do
    Result.HistValArr[i]:= 0;
  for i:= 0 to aPatCount - 1 do begin
    if aPatList[i].Status <> 1 then Continue;
    aAge:= aPatList[i].Age;
    aInd:= aAge div aIntervCount;
    aInd:= Min(9, aInd);
    Inc(Result.HistValArr[aInd]);
    Inc(aSum);
  end;
  Result.Sum:= aSum;
  Result.Mean:= 0;
  Result.StdDev:= 0;
  Result.SimulTime:= aSimulTime;
end;

function StatusAgeHist(const aPatList: TPatList; aPatCount, aSimulTime: Integer): TStatusAgeHist;
  {RU: Возвращает гистограмму распределения возрастов по статусам в массиве aPatList. }
  {EN: Returns the histogram of the ditributin of the ages by status in array aPatList}
var i, j, aIntervCount, aInd, aAge: Integer;

  procedure UpdateHistValArr(const aCurrPatList: TPatList; aCurrPatCount: Integer);
    {RU: Обновление Result[j].HistValArr[i] по списку aCurrPatList}
    {EN: Updates  Result[j].HistValArr[i] according to list aCurrPatList}
  var i, aStatusInd, aPatStatus: Integer;
  begin
    for i:= 0 to aCurrPatCount - 1 do begin
      aPatStatus:= aCurrPatList[i].Status;
      if (aPatStatus = 0)or(aPatStatus = 3) then Continue;
      aStatusInd:= aPatStatus - 1;
      if aPatStatus = 4 then
        aStatusInd:= aStatusInd - 1;
      aAge:= aCurrPatList[i].Age;
      aInd:= aAge div 10;
      aInd:= Min(8, aInd);
      Inc(Result[aStatusInd].HistValArr[aInd]);
    end;
  end;

begin
  aIntervCount:= 9;
  for j:= 0 to 2 do
    for i:= 0 to aIntervCount - 1 do
      Result[j].HistValArr[i]:= 0;
  UpdateHistValArr(aPatList, aPatCount);
  for j:= 0 to 2 do
    Result[j].SimulTime:= aSimulTime;
end;

procedure AddInfectForPatList(const aSoursePatList: TPatList; aSoursePatCount, aInfTime: Integer; const aHiperParam: TDoublePoint2DArr;
          aInitContProb, aIsolContProb: Double; var aPatList: TPatList; var aPatCount: Integer);
  {RU: Добавление к списку aPatList пациентов, инфицированных всеми пациентами из aSoursePatList, в aInfTime. aPatCount - текущее количество инфицированных пациентов.}
  {EN: Adding to list aPatList those individuals that are infected by individuals from the list aSoursePatList, at aInfTime. aPatCount - the current number of infected.}
var i, aInd: Integer;
    aPatStatusCounts: TIntegerPoint2D;
begin
  for i:= 0 to aSoursePatCount - 1 do
    AddInfectForPat(aSoursePatList[i], aInfTime, aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount);
  aPatStatusCounts:= PatStatusCounts(PatList, PatCount);
  aInd:= aInfTime - CurrMinInfTime;
  InfectedPat[aInd]:= IntegerPoint2D(aInfTime, aPatStatusCounts[0]);
  IsolatedPat[aInd]:= IntegerPoint2D(aInfTime, aPatStatusCounts[1]);
  AgeHistArr[aInd]:= AgeHist(PatList, PatCount, aInfTime);
end;

procedure ClearPatList(const aPatList: TPatList; var aPatCount: Integer);
  {RU: Очистка сиска aPatList}
var i, aLen: Integer;
begin
  aLen:= Length(aPatList);
  for i:= 0 to aLen - 1 do
    aPatList[i]:= ZeroPat;
  aPatCount:= 0;
end;

procedure ClearPatListPart(const aPatList: TPatList; var aPatCount: Integer);
  {RU: Очистка сиска aPatList}
var i: Integer;
begin
  if aPatList = nil then Exit;
  for i:= 0 to aPatCount - 1 do
    aPatList[i]:= ZeroPat;
  aPatCount:= 0;
end;

function MaxDurationTime(const aPatList: TPatList; aPatCount: Integer): Integer;
  {RU: Возвращает наибольшее значение времени лечения для пациентов из aPatList}
  {EN: Returns the lasgest time to treat for individuals from aPatList}
var i: Integer;
begin
  Result:= 0;  // RU: Нереальное значение EN: Impossible value
  if aPatList = nil then Exit;
  Result:= aPatList[0].DiseaseDur;
  for i:= 1 to aPatCount - 1 do
    Result:= Max(Result, aPatList[i].DiseaseDur);
end;

procedure InitPatList(const aDetPatList: TPatList; aDetPatCount, aInitTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer);
var i: Integer;
begin
  ClearPatList(aPatList, aPatCount);
  for i:= CurrMinInfTime to aInitTime do
    AddInfectForPatList(aDetPatList, aDetPatCount, i, aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount);
end;

procedure ExpandPatListAtTime(aCurrTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; var aPatList: TPatList; var aPatCount: Integer);
  {RU: Расширяет aPatList за счет имеющихся инфицированных пациентов в момент aCurrTime}
  {EN: Expands aPatList from on the infected individuals at time aCurrTime}
var i, j, aInitPatCount, aLen, aContacts: Integer;
    aSourcePat, aInfPat: TPat;
begin
  if aPatCount > MaxPatCount then begin
    MessageDlg('The amount of patients is too large', mtError, [mbOK], 0);
    StopEvaluation:= True;
    Exit;
  end;
  aLen:= Length(aPatList);
  aInitPatCount:= aPatCount;  // RU: Начальное количество пациентов EN: The initial number of individuals.
  for i:= 0 to aInitPatCount - 1 do begin
    aSourcePat:= aPatList[i];
    aContacts:= PatContacts(aSourcePat, aCurrTime);
    for j:= 0 to aContacts - 1 do begin
      aInfPat:= Infected(aSourcePat, aCurrTime, aHiperParam, aInitContProb, aIsolContProb);
      if aInfPat.Status = 1 then begin
        if aPatCount >= aLen - 1 then begin
          aLen:= aLen + 200000;
          SetLength(aPatList, aLen);
        end;
        aPatList[aPatCount]:= aInfPat;
        Inc(aPatCount);
      end;
    end;
  end;
end;

procedure ExpandPatListAtTimePeriod(aInitTime, aTermTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer);
  {RU: Расширяет aPatList за счет имеющихся инфицированных пациентов в период [aInitTime, aTermTime]}
  {EN: Expands aPatList from the infected individuals during time [aInitTime, aTermTime]}
var i: Integer;
begin
  if StopEvaluation then Exit;
  for i:= aInitTime to aTermTime do begin
    ExpandPatListAtTime(i, aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount);
    if StopEvaluation then Break;
  end;
end;

procedure DrawInfPat(const aInfectedPat: TIntegerPoint2DArr; aCurrTime: Integer; const aInfPatSeries: TLineSeries);
var i: Integer;
    aDayText: String;
begin
  aInfPatSeries.Clear;
  if aInfectedPat = nil then Exit;
  for i:= 0 to aCurrTime - CurrMinInfTime do begin
    aDayText:= YearDays[i + DetectDayInd + CurrMinInfTime];
    aInfPatSeries.AddXY(aInfectedPat[i, 0], aInfectedPat[i, 1], aDayText, clRed);
  end;
end;

procedure DrawIsolPat(const aIsolatedPat: TIntegerPoint2DArr; aCurrTime: Integer; const aIsolPatSeries: TLineSeries);
var i: Integer;
begin
  aIsolPatSeries.Clear;
  if aIsolatedPat = nil then Exit;
  for i:= 0 to aCurrTime - CurrMinInfTime do
    aIsolPatSeries.AddXY(aIsolatedPat[i, 0], aIsolatedPat[i, 1]);
end;

procedure DrawRealIsolPat(const aSumDetectECCounts, aFatalArr: TIntArray; aCurrTime: Integer; const aRealIsolSeries, aRealLethalSeries, aReaHospSeries: TLineSeries);
  {RU: Рисование графика реальных изолированных пациентов. aCurrTime - текущее время симуляции. aSumDetectECCounts - количество изолированных пациентов, начиная с }
  {EN: Drawing the graph of isolated individuals. aCurrTime - the current simulation time. aSumDetectECCounts - the number of isolated individuals starting from }
var i: Integer;
begin
  aRealIsolSeries.Clear;
  aRealLethalSeries.Clear;
  if aCurrTime < 0 then Exit;
  if aSumDetectECCounts <> nil then begin
    aCurrTime:= Min(aCurrTime, Length(SumDetectECCounts) - CurrDetDay - 1);
    for i:= 0 to aCurrTime - CurrMinInfTime do
      if aSumDetectECCounts[i] > 0 then
        aRealIsolSeries.AddXY(i + CurrMinInfTime, aSumDetectECCounts[i]);
  end;
  if aFatalArr <> nil then begin
    aCurrTime:= Min(aCurrTime, Length(aFatalArr) - CurrDetDay - 1);
    for i:= 0 to aCurrTime - CurrMinInfTime do
      if aFatalArr[i] > 0 then
        aRealLethalSeries.AddXY(i + CurrMinInfTime, aFatalArr[i]);
  end;
  if HospitalArr <> nil then begin
    aCurrTime:= Min(aCurrTime, Length(FatalArr) - CurrDetDay - 1);
    for i:= 0 to aCurrTime - CurrMinInfTime do
      if HospitalArr[i] > 0 then
        aReaHospSeries.AddXY(i + CurrMinInfTime, HospitalArr[i]);
  end;
end;

procedure DrawStatus(const aStatusArr: TStatusArr; aCurrTime: Integer; const aInfPatSeries, aTreatSeries, aLethalSeries, aRealIsolSeries, aCaseSeries,
          aRealLethalSeries, aReaHospSeries: TLineSeries);
var i, aDay, aMaxDay: Integer;
    aStatus: TStatus;
    aDayText: String;
begin
  ClearChart(TChart(aInfPatSeries.ParentChart));
  if aStatusArr = nil then Exit;
  aMaxDay:= Length(SumDetectECCounts) - CurrDetDay - 1;
  if ShowTreat then
    aTreatSeries.Title:= 'Treat '
  else
    aTreatSeries.Title:= 'Hospital ';
  for i:= 0 to aCurrTime - CurrMinInfTime do begin
    aStatus:= aStatusArr[i];
    if ZeroStatus(aStatus) then Continue;
    aDay:= aStatus[0];
    aDayText:= YearDays[i + DetectDayInd + CurrMinInfTime];
    aInfPatSeries.AddXY(aDay, aStatus[1], aDayText);
    if ShowTreat then
      aTreatSeries.AddXY(aDay, aStatus[2])
    else
      aTreatSeries.AddXY(aDay, aStatus[2] - aStatus[5]);
    aLethalSeries.AddXY(aDay, aStatus[4]);
    if aDay <= aMaxDay then
      aCaseSeries.AddXY(aDay, aStatus[6]);
  end;
  //DrawRealIsolPat(SumDetectECCounts, FatalArr, aCurrTime, aRealIsolSeries, aRealLethalSeries, aReaHospSeries);
  DrawRealIsolPat(SumDetectECCounts, FatalArr_1, aCurrTime, aRealIsolSeries, aRealLethalSeries, aReaHospSeries);
  TChart(aInfPatSeries.ParentChart).Title.Caption:= 'Patient Status Simulation ' + YearDayText(CurrSimulTime);
end;

procedure DrawAgeHist(const aAgeHist: TAgeHist; const aAgeHistSeries: TBarSeries);
var i: Integer;
begin
  aAgeHistSeries.Clear;
  for i:= 0 to 9 do
    aAgeHistSeries.AddXY(5 + i*10, aAgeHist.HistValArr[i]);
  TChart(aAgeHistSeries.ParentChart).Title.Caption:= 'Infected Patients Age Histogram ' + YearDayText(aAgeHist.SimulTime);
end;

procedure DrawStatusAgeHist(const aStatusAgeHist: TStatusAgeHist; const aInfHistSeries, aTreatHistSeries, aLethalHistSeries: TLineSeries);
var i: Integer;
    aChart: TChart;
begin
  aChart:= TChart(aInfHistSeries.ParentChart);
  ClearChart(aChart);
  for i:= 0 to 8 do begin
    aInfHistSeries.AddXY((i + 1)*10, aStatusAgeHist[0].HistValArr[i]);
    aTreatHistSeries.AddXY((i + 1)*10, aStatusAgeHist[1].HistValArr[i]);
    aLethalHistSeries.AddXY((i + 1)*10, aStatusAgeHist[2].HistValArr[i]);
  end;
  aChart.Title.Caption:= 'Patients Age Histogram ' + YearDayText(aStatusAgeHist[0].SimulTime);
end;

procedure InitInfIsolPat;
var aLen: Integer;
begin
  aLen:= MaxSimulTime - CurrMinInfTime;
  SetLength(InfectedPat, aLen);
  SetLength(IsolatedPat, aLen);
  SetLength(AgeHistArr, aLen);
  SetZeroArray(InfectedPat);
  SetZeroArray(IsolatedPat);
  SetZeroArray(AgeHistArr);
end;

procedure LenStatusArr;
var i, aLen: Integer;
begin
  aLen:= MaxSimulTime - CurrMinInfTime;
  SetLength(StatusArr, aLen);
  SetLength(AgeHistArr, aLen);
  SetLength(StatusAgeHistArr, aLen);
  for i:= 0 to 2 do
    SetLength(StatusStrArr[i], aLen);
end;

procedure InitStatusArr;
var i, j, aLen: Integer;
begin
  aLen:= MaxSimulTime - CurrMinInfTime;
  LenStatusArr;
  for i:= 0 to aLen - 1 do begin
    StatusArr[i, 0]:= i + CurrMinInfTime;
    for j:= 1 to 6 do
      StatusArr[i, j]:= 0;
  end;
  SetZeroArray(AgeHistArr);
  SetZeroStatusAgeHistArr(StatusAgeHistArr);
  for i:= 0 to aLen - 1 do
    for j:= 0 to 2 do
      StatusStrArr[j, i]:= YearDays[i + CurrMinInfTime + DetectDayInd];
end;

procedure InitStatusArr_1;
var i, j, aLen: Integer;
begin
  aLen:= MaxSimulTime - CurrMinInfTime;
  LenStatusArr;
  for i:= 0 to aLen - 1 do begin
    StatusArr[i, 0]:= i + CurrMinInfTime;
    for j:= 1 to 6 do
      StatusArr[i, j]:= 0;
  end;
end;

procedure SetZeroArray(const aArray: TIntegerPoint2DArr);
  {RU: Устанавливает нулевые значения для элементов массива aArray}
  {EN: Sets zero values for the elements of the array aArray}
var i: Integer;
begin
  for i:= 0 to Length(aArray) - 1 do
    aArray[i]:= ZeroIntegerPoint2D;
end;

procedure SetZeroArray(const aArray: TAgeHistArr);
  {RU: Устанавливает нулевые значения для элементов массива aArray}
  {EN: Sets zero values for the elements of the array aArray}
var i, j: Integer;
begin
  for i:= 0 to Length(aArray) - 1 do begin
    for j:= 0 to 9 do
      aArray[i].HistValArr[j]:= 0;
    aArray[i].SimulTime:= 0;
  end;
end;

procedure SetZeroStatusAgeHist(var aStatusAgeHist: TStatusAgeHist);
  {RU: Устанавливает нулевые значения для элементов массива aStatusAgeHist}
  {EN: Sets zero values for the elements of the array aStatusAgeHist}
var i, j: Integer;
begin
  for i:= 0 to 2 do begin
    for j:= 0 to 8 do
      aStatusAgeHist[i].HistValArr[j]:= 0;
    aStatusAgeHist[i].SimulTime:= 0;
  end;
end;

procedure SetZeroStatusAgeHistArr(var aStatusAgeHistArr: TStatusAgeHistArr);
  {RU: Устанавливает нулевые значения для элементов массива aStatusAgeHistArr}
  {EN: Sets zero values for the elements of the array aStatusAgeHistArr}
var i: Integer;
begin
  for i:= 0 to Length(aStatusAgeHistArr) - 1 do
    SetZeroStatusAgeHist(aStatusAgeHistArr[i]);
end;

function AgeHistIsEmpty(const aAgeHist: TAgeHist): Boolean;
  {RU: Если гистограмма aAgeHist пустая, то Result = True}
  {EN: If the histogram aAgeHist is empty then, то Result = True}
var i: Integer;
begin
  Result:= True;
  for i:= 0 to 9 do
    if aAgeHist.HistValArr[i] > 0 then begin
      Result:= False;
      Exit;
    end;
end;

function GeoToMapCoord(aGeoCoord, aAngleMapScale: TDoublePoint2D): TIntegerPoint2D;
  {RU: Возвращает координаты точки (X, Y) на MapBitMap по географическим координатам (Long, Lat). aAngleMapScale - угловой масштаб в pixel/Grad}
  {EN: Returns the coordinates of the point (X, Y) on MapBitMap based on the geographic coordinates (Long, Lat). aAngleMapScale - angle scale in pixel/Grad}
var aGeoShift: TDoublePoint2D;
    aMapShift: TIntegerPoint2D;
begin
  aGeoShift[0]:= aGeoCoord[0] - GeoLeftTop[0];  // RU: Географический сдвиг по долготе относительно GeoLeftTop EN: Geographic longitude shift in relation to GeoLeftTop
  aGeoShift[1]:= GeoLeftTop[1] - aGeoCoord[1];  // RU: Географический сдвиг по широте относительно GeoLeftTop  EN: Geographic lattitude shift in relation to GeoLeftTop
  aMapShift[0]:= Round(aGeoShift[0]*aAngleMapScale[0]);
  aMapShift[1]:= Round(aGeoShift[1]*aAngleMapScale[1]);
  Result:= SummTwoPoints(MapLeftTop, aMapShift);
end;

function MapToGeoCoord(aMapCoord: TIntegerPoint2D; aAngleMapScale: TDoublePoint2D): TDoublePoint2D;
  {RU: Возвращает географическим координаты (Long, Lat) точки по координатам (X, Y) на MapBitMap в пикселях. aAngleMapScale - угловой масштаб в pixel/Grad}
  {EN: Retursn the geographic coordianates (Long, Lat) of the point based on coordinates of (X, Y) on MapBitMap in pixels. aAngleMapScale - angle scale in pixel/Grad}
var aGeoShift: TDoublePoint2D;
    aMapShift: TIntegerPoint2D;
begin
  aMapShift[0]:= aMapCoord[0] - MapLeftTop[0];  // RU: Сдвиг по горизонтали относительно MapLeftTop в пикселях EN: Horizontal shift in relation to MapLeftTop in pixels
  aMapShift[1]:= aMapCoord[1] - MapLeftTop[1];  // RU: Сдвиг по вертикали относительно MapLeftTop в пикселях EN: Vertical shift in relation to MapLeftTop in pixels.
  aGeoShift[0]:= aMapShift[0]/aAngleMapScale[0];  // RU: Географический сдвиг в градусах по долготе относительно MapLeftTop EN: Geographic shift in degrees by longitude in relation to MapLeftTop
  aGeoShift[1]:= -aMapShift[1]/aAngleMapScale[1];  // RU: Географический сдвиг в градусах по широте относительно MapLeftTop EN: Geographic shit in degrees by lattitude in relation to MapLeftTop
  Result:= SummTwoPoints(GeoLeftTop, aGeoShift);
end;

procedure FillEpiCentrsGrid(const aEpicenters: TEpicenters; const aCounts: TIntArray; aMaxHeight: Integer; const aStrGrid: TStringGrid; const aEpiLabel: TLabel);
var i, aSum: Integer;
    aEpicenter: TEpicenter;
begin
  ClearStrGrid(aStrGrid);
  if aEpicenters = nil then Exit;
  aStrGrid.RowCount:= LenEC + 1;
  aStrGrid.Cells[0, 0]:= 'Ind';
  aStrGrid.Cells[1, 0]:= 'County';
  aStrGrid.Cells[2, 0]:= 'Num';
  aSum:= 0;
  for i:= 0 to LenEC - 1 do begin // Row
    aEpicenter:= aEpicenters[i];
    aStrGrid.Cells[0, i + 1]:= IntToStr(i);   // Ind
    aStrGrid.Cells[3, i + 1]:= IntToStr(aEpicenter.Radius);   // Rad
    aStrGrid.Cells[1, i + 1]:= aEpicenter.County;    // County
    aStrGrid.Cells[2, i + 1]:= IntToStr(aCounts[i]);
    aSum:= aSum + aCounts[i];
  end;
  SetStrGridHeight(aStrGrid, aMaxHeight);
  aEpiLabel.Caption:= 'Epicenters (' + IntToStr(aSum) + ' Patients)';
end;

procedure FillParamDistrStrGrid(const aHiperParam: TDoublePoint2DArr; const aStrGrid: TStringGrid);
var i, j: Integer;
begin
  aStrGrid.Cells[0, 0]:= 'Parameter';
  aStrGrid.Cells[0, 1]:= 'Detection Day';
  aStrGrid.Cells[0, 2]:= 'Age';
  aStrGrid.Cells[0, 3]:= 'Distance (m)';
  aStrGrid.Cells[0, 4]:= 'Usual Contact';
  aStrGrid.Cells[0, 5]:= 'Dense Contact';
  aStrGrid.Cells[1, 0]:= ' Mean';
  aStrGrid.Cells[2, 0]:= ' StdDev';
  for i:= 0 to Length(aHiperParam) - 1 do
    for j:= 0 to 1 do
      aStrGrid.Cells[j + 1, i + 1]:= Format('%5.3f', [aHiperParam[i, j]]);
end;

function CSVStrToEpicenter(aDataStr, aDelim: String): TEpicenter;
  {RU: Возвращает параметры эпицентра по csv-строке aDataStr (с разделителем aDelim)}
  {EN: Retursn the parameters of the epicented based on csv-string aDataStr (with the dividor aDelim)}
var aStr: String;
    aLong, aLat, aRadLong, aRadLat: Double;
    aGeoCentr, aGeoRad: TDoublePoint2D;
    aMapRad: TIntegerPoint2D;
begin
  aStr:= Trim(aDataStr);
  SetFloatPatParam(aLong, aStr, aDelim);
  SetFloatPatParam(aLat, aStr, aDelim);
  SetFloatPatParam(aRadLong, aStr, aDelim);
  SetFloatPatParam(aRadLat, aStr, aDelim);
  aGeoCentr:= DoublePoint2D(aLong, aLat);
  aGeoRad:= DoublePoint2D(aRadLong, aRadLat);
  Result.Center:= GeoToMapCoord(aGeoCentr, AngleScale);
  aMapRad:= GeoToMapCoord(aGeoRad, AngleScale);
  Result.Radius:= Round(DistPoints(Result.Center, aMapRad));
  Result.County:= aStr;
end;

function LoadEpicenters(aFileName: String; var aEpicenters: TEpicenters): Boolean;
  {RU: Формирование массива aEpicenters по данным csv-файла aFileName. Если файл найден, то Result = True.}
  {EN: Creation of the array aEpicenters based on data from csv-file aFileName. IF the file is not ound then Result = True.}
var i, aLen: Integer;
    aDataList: TStringList;
    aHeadStr, aDelim, aDataStr: String;
begin
  Result:= False;
  aEpicenters:= nil;
  if not FileExists(aFileName) then Exit;
  aDataList:= TStringList.Create;
  aDataList.LoadFromFile(aFileName);
  aLen:= aDataList.Count - 1;
  if aLen < 1 then Exit;
  aHeadStr:= aDataList[0];
  aDelim:= GetDelim(aHeadStr);
  if aDelim = '' then Exit;
  if Pos('Long', aHeadStr) < 1 then begin
    MessageDlg('This is not the Epicenters file', mtInformation, [mbOk], 0);
    Exit;
  end;
  SetLength(aEpicenters, aLen);
  for i:= 0 to aLen - 1 do begin
    aDataStr:= aDataList[i + 1];
    aEpicenters[i]:= CSVStrToEpicenter(aDataStr, aDelim);
  end;
  Result:= True;
end;

procedure DrawEpicenters(const aEpicenters: TEpicenters; const aBitMap: TBitMap; aPenColor: TColor);
var aRect: TRect;
    i, aRad: Integer;
    aPoint: TIntegerPoint2D;
begin
  if not ShowEpicenters then Exit;
  aBitMap.Canvas.Brush.Color:= aPenColor;
  aBitMap.Canvas.Brush.Style:= bsClear;
  aBitMap.Canvas.Pen.Width:= 1;
  aBitMap.Canvas.Pen.Color:= aPenColor;
  aBitMap.Canvas.Pen.Style:= psSolid;
  for i:= 0 to LenEC - 1 do begin
    aPoint:= aEpicenters[i].Center;
    aRad:= aEpicenters[i].Radius;
    aRect.TopLeft:= Point(aPoint[0] - aRad, aPoint[1] - aRad);
    aRect.BottomRight:= Point(aPoint[0] + aRad, aPoint[1] + aRad);
    aBitMap.Canvas.Ellipse(aRect);
  end;
end;

function NewPatCood(const aEpicenter: TEpicenter): TIntegerPoint2D;
  {RU: Возвращает координаты симулированного пациента, по параметрам aEpicenter}
  {EN: Returns coordinates of the simulated individual based on parameters aEpicenter}
var aRad, aAngle, aRandVal, aReduce, aReduceRad: Double;
    i: Integer;
begin
  aReduce:= 0.8;
  aReduceRad:= aReduce*aEpicenter.Radius;
  for i:= 0 to 300 do begin
    aRandVal:= Random;
    aRandVal:= Min(0.998, aRandVal);
    aRad:= -aReduceRad*Ln(1 - aRandVal);   // RU: Симуляция показательного распределения со средним aEpicenter.Radius в пикселях EN: Simulaiton of the dispay distriution with an average aEpicenter.Radius in pixels.
    aAngle:= 2*Pi*Random;  // Угол равномерно распределен на [0; 2*Pi]
    Result[0]:= Round(aRad*Cos(aAngle));
    Result[1]:= Round(aRad*Sin(aAngle));
    Result[0]:= Result[0] + aEpicenter.Center[0];
    Result[1]:= Result[1] + aEpicenter.Center[1];
    if (Result[0] >= 0)and(Result[0] < CurrMapSize[0])and(Result[1] >= 0)and(Result[1] < CurrMapSize[1])and(not WaterMask[Result[0], Result[1]]) then Exit;
  end;
end;

function NewDetPat(aCurrDetDay: Integer; aEpiIndex: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPat;
  {RU: Возвращает симулированного детектированного пациента по параметрам эпицентра aEpiIndex. aCurrDetDay - день детектирования}
  {EN: Returns the simulated detected individual based on parameters of the epicenter aEpiIndex. aCurrDetDay - detection day}
var aDetectParam, aAgeParam: Integer;
    aStageParam, aCoord: TIntegerPoint2D;
    aLambda: Double;
    aDetectDistrParam, aAgeDistrParam: TDoublePoint2D;
    aEpicenter: TEpicenter;
begin
  aEpicenter:= Epicenters[aEpiIndex];
  aDetectDistrParam:= aHiperParam[0];
  aDetectParam:= GetDetectParam(aDetectDistrParam);
  aStageParam:= GetStageParam(aDetectParam);
  aAgeDistrParam:= aHiperParam[1];
  aAgeParam:= GetAgeParam(aAgeDistrParam);
  aCoord:= NewPatCood(aEpicenter);
  Result.Coord:= aCoord;
  Result.EpiIndex:= aEpiIndex;
  Result.InfectTime:= aCurrDetDay - aDetectParam;
  Result.Stage1:= aStageParam[0];
  Result.Stage2:= aStageParam[1];
  Result.Detect:= aDetectParam;
  Result.Age:= aAgeParam;
  Result.AvrgRadDist:= GetAvrgRadDistParam(aHiperParam, aAgeParam);
  Result.Contacts:= GetContParam(aCoord, aAgeParam, ContCircles, aHiperParam);
  aLambda:= aInitContProb;
  Result.ContProb:= GetContProbParam(aLambda, aAgeParam);
  Result.R0:= 0;
  Result.DisForm:= GetDisFormParam(DiseaseForm, Result.Age);
  Result.DiseaseDur:= GetDiseaseDuration(DiseaseDuration, Result.DisForm);
  Result.Status:= 0;
end;

function DetPatForEC(aCurrDetDay: Integer; aEpiIndex: Integer; aPatCountEC: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPatList;
  {RU: Возвращает симулированный список детектированных пациентов для эпицентрв aEpicenter. aCurrDetDay - день детектирования}
  {En: Returns the simulated list of detected individuals for epicenters aEpicenter. aCurrDetDay - detection day}
var i: Integer;
begin
  SetLength(Result, aPatCountEC);
  for i:= 0 to aPatCountEC - 1 do
    Result[i]:= NewDetPat(aCurrDetDay, aEpiIndex, aHiperParam, aInitContProb, aIsolContProb);
end;

procedure CSVtoStrList(aDataStr, aDelim: String; var aStrList: TStringList; var aElemCount: Integer);
  {RU: Формирование списка aStrList по aDataStr, с разделителем aDelim.}
var aInd: Integer;
    aCurrStr, aStr: String;
begin
  aStr:= aDataStr;  // RU: Обрабатываемая входная строка EN: Processed input string
  aElemCount:= 0;
  aInd:= Pos(aDelim, aStr);
  while aInd > 0 do begin
    aCurrStr:= Copy(aStr, 1, aInd - 1);
    aStrList.Add(aCurrStr);
    Inc(aElemCount);
    Delete(aStr, 1, aInd);
    aInd:= Pos(aDelim, aStr);
  end;
  if Trim(aStr) <> '' then begin
    aStrList.Add(aStr);
    Inc(aElemCount);
  end;
end;

function CSVstringLen(aDataStr, aDelim: String): Integer;
  {RU: Возвращает количество записей в строке, разделенных aDelim.}
  {EN: Returns the number of records in a string separated by aDelim.}
var aInd: Integer;
begin
  Result:= 0;
  aInd:= Pos(aDelim, aDataStr);
  while aInd > 0 do begin
    Inc(Result);
    Delete(aDataStr, 1, aInd);
    aInd:= Pos(aDelim, aDataStr);
  end;
  if Trim(aDataStr) <> '' then
    Inc(Result);
end;

function LoadDetectECCounts(aFileName: String; var aDetectECCounts: TIntArrayArr; var aDetectDays: TStringList): Boolean;
  {RU: Формирование массива aDetectECCounts (количество детектированных пациентов в каждом округе в день i) по данным csv-файла aFileName. Если файл найден, то Result = True.}
  {EN: Forming of array aDetectECCounts (the number of detected individuals in each region in a day i) based on data from csv-файла aFileName. If not found then Result = True.}
var i, j, aLen, aDayCount: Integer;
    aDataList: TStringList;
    aHeadStr, aDelim, aDataStr: String;
begin
  Result:= False;
  aDetectECCounts:= nil;
  aDetectDays:= nil;
  if not FileExists(aFileName) then Exit;
  aDetectDays:= TStringList.Create;
  aDataList:= TStringList.Create;
  aDataList.LoadFromFile(aFileName);
  aLen:= aDataList.Count - 1;
  if aLen < 1 then Exit;
  aHeadStr:= aDataList[0];
  aDelim:= GetDelim(aHeadStr);
  if aDelim = '' then Exit;
  if Pos('-', aHeadStr) < 1 then begin
    MessageDlg('This is not the DetectedEC Counts file', mtInformation, [mbOk], 0);
    Exit;
  end;
  CSVtoStrList(aHeadStr, aDelim, aDetectDays, aDayCount);
  SetLength(aDetectECCounts, aDayCount, aLen);   // RU: Количество дней наблюдения EN: Number of observation days
  for i:= 0 to aLen - 1 do begin   // RU: Индекс округа EN: index of a region
    aDataStr:= aDataList[i + 1];
    for j:= 0 to aDayCount - 1 do  // RU: Индекс дня EN: Index of a day
      SetIntPatParam(aDetectECCounts[j, i], aDataStr, aDelim);
  end;
  Result:= True;
end;

function DistRGB(const aPoint1, aPoint2: TRGB): Double;
  {RU: Возвращает расстояние между RGB точками aPoint1, aPoint2}
  {EN: Returns the distance between RGB points aPoint1, aPoint2}
begin
  Result:= Max(Abs(aPoint1[0] - aPoint2[0]), Abs(aPoint1[1] - aPoint2[1]));
  Result:= Max(Result, Abs(aPoint1[2] - aPoint2[2]));
end;

function GetWaterMask(const aBuffBitMap: TBitMap): TImgMaskSection;
var i, j, aWidth, aHeight: Integer;
    aMapColor: TColor;
    aMapRGB: TRGB;
begin
  aWidth:= aBuffBitMap.Width;
  aHeight:= aBuffBitMap.Height;
  SetLength(Result, aWidth, aHeight);
  for i:= 0 to aWidth - 1 do
    for j:= 0 to aHeight - 1 do begin
      aMapColor:= aBuffBitMap.Canvas.Pixels[i, j];
      aMapRGB:= ColorToRGB(aMapColor);
      if DistRGB(aMapRGB, WaterRGB) < 20 then
        Result[i, j]:= True
      else
        Result[i, j]:= False;
    end;
end;

procedure DrawWater;
var i, j, aWidth, aHeight: Integer;
begin
  InitImgBitMap(MapBitMap);
  aWidth:= BuffBitMap.Width;
  aHeight:= BuffBitMap.Height;
  for i:= 0 to aWidth - 1 do
    for j:= 0 to aHeight - 1 do
      if WaterMask[i, j] then
        MapBitMap.Canvas.Pixels[i, j]:= clRed;
end;

function HiperParamFromTable(const aStrGrid: TStringGrid): TDoublePoint2DArr;
  {RU: Возвращает массив параметров из таблицы }
  {EN: Returns the array of parameters from the table }
var i, j, aLen: Integer;
begin
  aLen:= aStrGrid.RowCount - 1;
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do
    for j:= 0 to 1 do
      Result[i, j]:= StrToFloatDef(aStrGrid.Cells[j + 1, i + 1], 0);
end;

procedure UpdateInfIsolPat_1;
var aPatStatusCounts: TIntegerPoint2D;
    aInd: Integer;
begin
  aPatStatusCounts:= PatStatusCounts(PatList, PatCount);
  aInd:= CurrSimulTime - CurrMinInfTime;
  InfectedPat[aInd]:= IntegerPoint2D(CurrSimulTime, aPatStatusCounts[0]);
  IsolatedPat[aInd]:= IntegerPoint2D(CurrSimulTime, aPatStatusCounts[1]);
  if aInd >= (-CurrMinInfTime) then
    IsolatedPat[aInd, 1]:= IsolatedPat[aInd, 1] + DetPatCount;
  AgeHistArr[aInd]:= AgeHist(PatList, PatCount, CurrSimulTime);
end;

procedure InitModel_1(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aCurrDetDay: Integer; var aPatList: TPatList; var aPatCount: Integer);
begin
  CurrMinInfTime:= -aCurrDetDay;
  CurrSimulTime:= 0;
  InitStatusArr_1;
  SetInitPatList(DetectECCounts, aCurrDetDay, aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount, StatusArr);
end;

procedure SimulationStep_1(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; var aPatList: TPatList; var aPatCount: Integer;
          var aStatusArr: TStatusArr);
var aChange: Integer;
begin
  Inc(CurrSimulTime);
  UpdatePatListStatus(CurrSimulTime, aPatCount, aPatList, aChange);
  ExpandPatListAtTime(CurrSimulTime, aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount);
  UpdateStatusArrEpi(aPatList, aPatCount, CurrSimulTime, aStatusArr);
end;

function SimulCases(aSimulPeriod: TIntegerPoint2D; aIter: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
         var aPatList: TPatList; var aPatCount: Integer): TIntArray;
  {RU: Возвращает массив средних количеств случаев заражения от aSimulPeriod[0] до момента aSimulPeriod[1]. aIter - количество итераций при симулировании.}
  {En: Returns the array of the averaged numbers of infected from time aSimulPeriod[0] to time aSimulPeriod[1]. aIter - the number of iterations of the simulation.}
var i, j, aInd, aLen: Integer;
begin
  aLen:= aSimulPeriod[1] - aSimulPeriod[0] + 1;
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do
    Result[i]:= 0;
  aInd:= aSimulPeriod[0];
  for j:= 0 to aIter - 1 do begin  // Итерация симуляции
    try
      ClearPatList(aPatList, aPatCount);
      aPatCount:= BuffPatCount;
      for i:= 0 to BuffPatCount - 1 do
        aPatList[i]:= BuffPatList[i];
      CurrSimulTime:= 0;
      InitStatusArr_1;
      for i:= 0 to aSimulPeriod[1] - CurrDetDay - 1 do
        SimulationStep_1(aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount, StatusArr);
      for i:= 0 to aLen - 1 do
        Result[i]:= Result[i] + StatusArr[aInd + i, 2] + StatusArr[aInd + i, 3] + StatusArr[aInd + i, 4];
    except
      on Exception do begin
        MainForm.PosEdit.Text:= IntToStr(j);
      end;
    end;
  end;
  for i:= 0 to aLen - 1 do
    Result[i]:= Round(Result[i]/aIter);
end;

function SumDetected(const aDetectECCounts: TIntArrayArr; aCurrDetDay, aContrTime: Integer): TIntArray;
  {RU: Возвращает массив суммарных количеств детектированных пациентов за период [aCurrDetDay, aContrTime]}
  {EN: Returns the array of the total qunatities of the detected individuals during a period [aCurrDetDay, aContrTime]}
var i, j, aLen, aLen1: Integer;
begin
  Result:= nil;
  if aDetectECCounts = nil then Exit;
  aLen:= aContrTime - aCurrDetDay + 1;
  SetLength(Result, aLen);
  aLen1:= Length(aDetectECCounts[0]);
  for i:= 0 to aLen - 1 do
    Result[i]:= 0;
  for i:= 0 to aLen - 1 do
    for j:= 0 to aLen1 - 1 do
      Result[i]:= Result[i] + aDetectECCounts[i + aCurrDetDay, j];
end;

function ObjFunction(aIter: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aOptimPeriod: TIntegerPoint2D;
         var aPatList: TPatList; var aPatCount: Integer): Double;
  {RU: Возвращает среднеквадратичное отклонение симулированного массива изолированных пациентов от исходных данных aIsolContProb за период aOptimPeriod[aInitDay, aTermDay]}
  {EN: Returns the standard deviation of the simulated array of isolated individuals from the source day aIsolContProb during the period aOptimPeriod[aInitDay, aTermDay]}
var i, aLen, aCounter, aRealVal: Integer;
    aSimulCases: TIntArray;
    aMinMax: TIntegerPoint2D;
begin
  aOptimPeriod[0]:= Max(1, aOptimPeriod[0]);
  aSimulCases:= SimulCases(aOptimPeriod, aIter, aHiperParam, aInitContProb, aIsolContProb, aPatList, aPatCount);
  aMinMax:= MinMaxForArray(aSimulCases);
  //if aMinMax[0] < 1 then begin
  //  MainForm.PosEdit.Text:= IntToStr(aMinMax[0]);
  //end;
  Result:= 0;
  aLen:= Length(aSimulCases);
  aCounter:= 0;
  for i:= 0 to aLen - 1 do begin
    aRealVal:= SumDetectECCounts[i + aOptimPeriod[0] - 1];
    if aRealVal > 0 then begin
      Result:= Result + Sqr(aSimulCases[i] - aRealVal);
      Inc(aCounter);
    end;
  end;
  if aCounter > 0 then
    Result:= Sqrt(Result/aCounter);
end;

procedure SetOptimalParams(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aOptimPeriod: TIntegerPoint2D; const aSimplexParam: TSimplexParam;
          const aBasicSumulParams: TSimulParams; var aOptHiperParam: TDoublePoint2DArr; var aOptInitContProb, aOptIsolContProb: Double);
  {RU: Формирование оптимальных параетров модели. aHiperParamб aInitContProb, aIsolContProb - начальные параметры. aBasicSumulParams - начальные параметры модели.}
  {EN: Forming of the optimal modle parameters. aHiperParamб aInitContProb, aIsolContProb - initial parameters. aBasicSumulParams - initial model parameters.}
var aOptSumulParams: TSimulParams;
    aInitSimplex: TSimplex;
    aMaxAbsErr, aMinFuncValue, aFuncStndErr, aInitVal: Double;
    i, aSimplexNumIter, aLen: Integer;
    aInitSimplexVert, aOptimSimplexVert: TSimplexVert;
begin
  aInitVal:= 0.12;
  for i:= 0 to LenVert - 1 do
    aInitSimplexVert[i]:= 0;
  aInitSimplex:= GetInitSimplex(aInitSimplexVert, aInitVal);
  aMaxAbsErr:= 2.0;
  aSimplexNumIter:= 30;
  InitModel_1(aHiperParam, aInitContProb, aIsolContProb, CurrDetDay, PatList, PatCount);
  aLen:= 20* PatCount;
  SetLength(SimPatList, aLen);
  ClearPatList(SimPatList, SimPatCount);
  BuffPatCount:= PatCount;
  SetLength(BuffPatList, BuffPatCount);
  for i:= 0 to BuffPatCount - 1 do begin
    BuffPatList[i]:= PatList[i];
    SimPatList[i]:= BuffPatList[i];
  end;
  aOptimSimplexVert:= SimulSimplexMethod(aSimplexParam, aBasicSumulParams, aOptimPeriod, aInitSimplex, aMaxAbsErr, aSimplexNumIter, aMinFuncValue, aFuncStndErr);
  aOptSumulParams:= SimplexVertToSimulParam(aOptimSimplexVert, aBasicSumulParams);
  SetHiperParam(aOptSumulParams, aOptHiperParam, aOptInitContProb, aOptIsolContProb);
end;

procedure SetOptimalParamsArr(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aOptimPeriod: TIntegerPoint2D; aNumIterArr: Integer;
          const aStatusBar: TStatusBar; var aOptHiperParamArr: TDoublePoint2DArrArr; const aTreatSimulSeries, aTreatReallSeries: TLineSeries;
          var aOptInitContProbArr, aOptIsolContProbArr: TDoubleArray);
  {RU: Формирование оптимальных параетров модели при итерациях aNumIterArr. aHiperParamб aInitContProb, aIsolContProb - начальные параметры.}
  {EN: Forming of the optimal parameters of the model during iterations aNumIterArr. aHiperParamб aInitContProb, aIsolContProb - initial parameter values.}
var i, aIter: Integer;
    aStatusText: String;
    aBasicSumulParams: TSimulParams;
    aSimplexParam: TSimplexParam;
begin
  SetLength(aOptHiperParamArr, aNumIterArr);
  SetLength(aOptInitContProbArr, aNumIterArr);
  SetLength(aOptIsolContProbArr, aNumIterArr);
  SetDefaultSimplexParam(aSimplexParam);
  aBasicSumulParams:= HiperParamToSimulParam(aHiperParam, aInitContProb, aIsolContProb);
  for i:= 0 to aNumIterArr - 1 do begin
    aStatusText:= 'Model Optimization Progress: Iteration ' + IntToStr(i + 1) + ' (Up to ' + IntToStr(aNumIterArr) +  ')   ';
    SetStatusText(aStatusBar, 0, aStatusText);
    Application.ProcessMessages;
    SetOptimalParams(aHiperParam, aInitContProb, aIsolContProb, aOptimPeriod, aSimplexParam, aBasicSumulParams, aOptHiperParamArr[i], aOptInitContProbArr[i], aOptIsolContProbArr[i]);
    aIter:= 5;
    DrawCases(aIter, aOptHiperParamArr[i], aOptInitContProbArr[i], aOptIsolContProbArr[i], aTreatSimulSeries, aTreatReallSeries);
    Application.ProcessMessages;
    if StopEvaluation then begin
      SetStatusText(MainForm.MainStatusBar, 0, 'Interruption of Evaluation');
      SetStatusText(MainForm.MainStatusBar, 1, '');
      Application.ProcessMessages;
      Exit;
    end;
  end;
  SetStatusText(aStatusBar, 0, '');
end;

function AvrgHiperParams(const aOptHiperParamArr: TDoublePoint2DArrArr): TDoublePoint2DArr;
var i, j, aLen, aLenHiper, aCounter: Integer;
    aCoeff: Double;
begin
  aLenHiper:= Length(HiperParam);
  SetLength(Result, aLenHiper);
  for i:= 0 to aLenHiper - 1 do
    Result[i]:= ZeroDoublePoint2D;
  if aOptHiperParamArr = nil then Exit;
  aLen:= Length(aOptHiperParamArr);  // Количество реализаций
  aCounter:= 0;
  for i:= 0 to aLen - 1 do
    if not EmptyHiperParam(aOptHiperParamArr[i]) then begin
      for j:= 0 to aLenHiper - 1 do
        Result[j]:= SummTwoPoints(Result[j], aOptHiperParamArr[i, j]);
      Inc(aCounter);
    end;
  if aCounter > 0 then begin
    aCoeff:= 1/aCounter;
    for i:= 0 to aLenHiper - 1 do
      Result[i]:= ProdNumPoint(aCoeff, Result[i]);
  end;
end;

function AvrgDoubleArray(const aDoubleArray: TDoubleArray): Double;
var i, aLen, aCounter: Integer;
begin
  Result:= 0;
  if aDoubleArray = nil then Exit;
  aLen:= Length(aDoubleArray);
  aCounter:= 0;
  for i:= 0 to aLen - 1 do
    if aDoubleArray[i] > 0 then begin
      Result:= Result + aDoubleArray[i];
      Inc(aCounter);
    end;
  if aCounter > 0 then
    Result:= Result/aCounter;
end;

procedure SetAvrgOptimalParams(const aOptHiperParamArr: TDoublePoint2DArrArr; const aOptInitContProbArr, aOptIsolContProbArr: TDoubleArray;
          var aAvrgOptHiperParam: TDoublePoint2DArr; var aAvrgOptInitContProb, aAvrgOptIsolContProb: Double);
  {RU: Формирование средних оптимальных параетров модели при итерациях aNumIterArr. aHiperParamб aInitContProb, aIsolContProb - начальные параметры.}
  {EN: Forming of the averaged optimal parameters of the model during the iterations aNumIterArr. aHiperParamб aInitContProb, aIsolContProb - initial parameters.}
begin
  aAvrgOptHiperParam:= AvrgHiperParams(aOptHiperParamArr);
  aAvrgOptInitContProb:= AvrgDoubleArray(aOptInitContProbArr);
  aAvrgOptIsolContProb:= AvrgDoubleArray(aOptIsolContProbArr);
end;

procedure DrawCases(aIter: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; const aTreatSimulSeries, aTreatReallSeries: TLineSeries);
var i, aLen, aRealVal: Integer;
    aSimulICases: TIntArray;
    aSimulPeriod: TIntegerPoint2D;
    aDayText: String;
begin
  aTreatSimulSeries.Clear;
  aTreatReallSeries.Clear;
  if EmptyHiperParam(aHiperParam) then Exit;
  aLen:= Length(SumDetectECCounts);
  aSimulPeriod:= IntegerPoint2D(0, aLen - 1);
  aSimulICases:= SimulCases(aSimulPeriod, aIter, aHiperParam, aInitContProb, aIsolContProb, PatList, PatCount);
  for i:= 1 to aLen - 1 do begin
    if aSimulICases[i] > 0 then begin
      aDayText:= YearDayCalend(i + CurrMinInfTime - 1);
      aTreatSimulSeries.AddXY(i, aSimulICases[i], aDayText);
    end;
    aRealVal:= SumDetectECCounts[i - 1];
    if aRealVal > 0 then
      aTreatReallSeries.AddXY(i, aRealVal);
  end;
end;

procedure SetYearDays(aLeap: Boolean);
var i, j: Integer;
    aMonth: String;
begin
  YearDays:= TStringList.Create;
  for i:= 0 to 11 do begin
    aMonth:= MonthName[i];
    if aLeap then begin
      for j:= 1 to MonthDaysLeap[i] do
        YearDays.Add(aMonth + '-' + IntToStr(j));
    end
    else begin
      for j:= 1 to MonthDays[i] do
        YearDays.Add(aMonth + '-' + IntToStr(j));
    end;
  end;
end;

function SumDetECCounts(const aDetectECCounts: TIntArrayArr): TIntArray;
  {RU: Возвращает массив SumDetectECCounts[i] - суммарных количеств детектированных пациентов в каждый день i.}
  {EN: Returns the array SumDetectECCounts[i] - summed quantities of the detected individuals in each day i.}
var i, j, aLen, aLen1: Integer;
begin
  Result:= nil;
  if aDetectECCounts = nil then Exit;
  aLen:= Length(aDetectECCounts);  // Количество дней
  aLen1:= Length(aDetectECCounts[0]);  // Количество округов
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do
    Result[i]:= 0;
  for i:= 0 to aLen - 1 do
    for j:= 0 to aLen1 - 1 do
      Result[i]:= Result[i] + aDetectECCounts[i, j];
end;

function EmptyParam(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): Boolean;
var i: Integer;
begin
  Result:= True;
  for i:= 0 to Length(aHiperParam) - 1 do
    if aHiperParam[i, 0] = 0 then Exit;
  if (aInitContProb = 0)or(aIsolContProb = 0) then Exit;
  Result:= False;
end;

function EmptyHiperParam(const aHiperParam: TDoublePoint2DArr): Boolean;
var i: Integer;
begin
  Result:= True;
  if aHiperParam = nil then Exit;
  for i:= 0 to Length(aHiperParam) - 1 do
    if aHiperParam[i, 0] = 0 then Exit;
  Result:= False;
end;

procedure SetHiperParamManual(aManual: Boolean);
begin
  HiperParam:= CurrHiperParam;
  InitContProb:= CurrInitContProb;
  IsolContProb:= CurrIsolContProb;
  if (not aManual)and(not EmptyParam(AvrgOptHiperParam, AvrgOptInitContProb, AvrgOptIsolContProb)) then begin
    HiperParam:= AvrgOptHiperParam;
    InitContProb:= AvrgOptInitContProb;
    IsolContProb:= AvrgOptIsolContProb;
  end;
end;

function SimulInfected(const aSource: TPat): Integer;
  {RU: Возвращает симулированное количество пациентов, инфицированных aSource за все время инфицированности}
  {EN: Retursn the simulated amount of individuals infected by aSource during the time if inectiousness}
var i, j, aContacts: Integer;
begin
  Result:= 0;
  for i:= 0 to aSource.Detect - 2 do begin  // RU: Количество дней, в которые может распространяться инфекция EN: The amount of days when infecton can spread.
    aContacts:= Round(RandG(aSource.Contacts[0], aSource.Contacts[1]));  // RU: Количество контактов пациента aSource EN: The number of contacts of individual aSource
    aContacts:= Max(0, aContacts);
    for j:= 0 to aContacts - 1 do
      if SpreadInfection(aSource) then
        Inc(Result);
  end;
end;

function R0forPat(const aSource: TPat; aNumIter: Integer): Double;
  {RU: Возвращает симулированное значение R0 - среднее количество пациентов, инфицированных aSource за все время инфицированности}
  {EN: Returns the simulated value for R0 - the average number of infected caused by aSource when he/she is infectious}
var i: Integer;
    aMaxVal: Double;
begin
  aMaxVal:= RandG(15, 3);
  Result:= 0;
  for i:= 0 to aNumIter - 1 do
    Result:= Result + SimulInfected(aSource);
  Result:= Result/aNumIter;
  Result:= Min(aMaxVal, Result);
end;

procedure DiseaseFormFromTable(var aDiseaseForm: TDiseaseForm; const aStrGrid: TStringGrid);
var i, j: Integer;
begin
  for i:= 0 to 2 do
    for j:= 0 to 2 do
      aDiseaseForm[i, j]:= StrToFloatDef(aStrGrid.Cells[j + 1, i + 1], 0);
end;

procedure DiseaseDurationFromTable(var aDiseaseDuration: TDiseaseDuration; const aStrGrid: TStringGrid);
var i, j: Integer;
begin
  for i:= 0 to 2 do
    for j:= 0 to 1 do
      aDiseaseDuration[i, j]:= StrToFloatDef(aStrGrid.Cells[j + 1, i + 1], 0);
end;

procedure DiseaseFormToSession(const aDiseaseForm: TDiseaseForm; const aSessionList: TStringList);
var i: Integer;
    aPrefix, aStr, aDelim: String;
begin
  aDelim:= ',';
  for i:= 0 to 2 do begin
    aPrefix:= 'DiseaseForm_' + IntToStr(i) + '=';
    aStr:= Format('%4.1f', [aDiseaseForm[i, 0]]) + aDelim + Format('%4.1f', [aDiseaseForm[i, 1]]) + aDelim + Format('%4.1f', [aDiseaseForm[i, 2]]);
    aSessionList.Add(aPrefix + aStr);
  end;
end;

procedure DiseaseFormFromList(const aSessionList: TStringList; var aDiseaseForm: TDiseaseForm);
var i, j: Integer;
    aPrefix, aStr, aDelim: String;
begin
  for i:= 0 to 2 do
    for j:= 0 to 2 do
      aDiseaseForm[i, j]:= 0;
  if aSessionList = nil then
    Exit;
  aDelim:= ',';
  for i:= 0 to 2 do begin
    aPrefix:= 'DiseaseForm_' + IntToStr(i);
    aStr:= aSessionList.Values[aPrefix];
    for j:= 0 to 2 do
      SetFloatPatParam(aDiseaseForm[i, j], aStr, aDelim);
  end;
end;

procedure FillDiseaseFormStrGrid(const aDiseaseForm: TDiseaseForm; const aStrGrid: TStringGrid);
var i, j: Integer;
begin
  aStrGrid.Cells[0, 0]:= 'Age';
  aStrGrid.Cells[0, 1]:= 'Lethal';
  aStrGrid.Cells[0, 2]:= 'Severe Form';
  aStrGrid.Cells[0, 3]:= 'Mild Form';
  aStrGrid.Cells[1, 0]:= ' ' + IntToStr(AgeLevel[0]) + '-';
  aStrGrid.Cells[2, 0]:= ' ' + IntToStr(AgeLevel[0]) + ' - ' + IntToStr(AgeLevel[1]);
  aStrGrid.Cells[3, 0]:= ' ' + IntToStr(AgeLevel[1]) + '+';
  for i:= 0 to 2 do
    for j:= 0 to 2 do
      aStrGrid.Cells[j + 1, i + 1]:= Format('%4.1f', [aDiseaseForm[i, j]]);
  DeselectStrGrid(aStrGrid);
end;

procedure DiseaseDurationToSession(const aDiseaseDuration: TDiseaseDuration; const aSessionList: TStringList);
var i: Integer;
    aPrefix, aStr, aDelim: String;
begin
  aDelim:= ',';
  for i:= 0 to 2 do begin
    aPrefix:= 'DiseaseDuration_' + IntToStr(i) + '=';
    aStr:= Format('%4.1f', [aDiseaseDuration[i, 0]]) + aDelim + Format('%4.1f', [aDiseaseDuration[i, 1]]);
    aSessionList.Add(aPrefix + aStr);
  end;
end;

procedure DiseaseDurationFromList(const aSessionList: TStringList; var aDiseaseDuration: TDiseaseDuration);
var i, j: Integer;
    aPrefix, aStr, aDelim: String;
begin
  for i:= 0 to 2 do
    for j:= 0 to 2 do
      aDiseaseDuration[i, j]:= 0;
  if aSessionList = nil then
    Exit;
  aDelim:= ',';
  for i:= 0 to 2 do begin
    aPrefix:= 'DiseaseDuration_' + IntToStr(i);
    aStr:= aSessionList.Values[aPrefix];
    for j:= 0 to 1 do
      SetFloatPatParam(aDiseaseDuration[i, j], aStr, aDelim);
  end;
end;

procedure FillDurationStrGrid(const aDiseaseDuration: TDiseaseDuration; const aStrGrid: TStringGrid);
var i, j: Integer;
begin
  aStrGrid.Cells[0, 0]:= 'Parameters';
  aStrGrid.Cells[0, 1]:= 'Lethal';
  aStrGrid.Cells[0, 2]:= 'Severe Form';
  aStrGrid.Cells[0, 3]:= 'Mild Form';
  aStrGrid.Cells[1, 0]:= ' Mean ';
  aStrGrid.Cells[2, 0]:= ' StdDev';
  for i:= 0 to 2 do
    for j:= 0 to 1 do
      aStrGrid.Cells[j + 1, i + 1]:= Format('%4.1f', [aDiseaseDuration[i, j]]);
  DeselectStrGrid(aStrGrid);
end;

procedure UpdateStatusArr(const aPatList: TPatList; aPatCount, aCurrTime: Integer; const aStrGrid: TStringGrid; var aStatusArr: TStatusArr);
  {RU: Обновление массива статусов aStatusArr пациентов из aDetPatList, aPatList в момент aCurrTime}
  {EN: Update of the array of the statuses aStatusArr of individuals from aDetPatList, aPatList at time aCurrTime}
var i, aInd: Integer;
    aPat: TPat;
begin
  aInd:= aCurrTime - CurrMinInfTime;   // RU: Индекс в массиве aStatusArr EN: Index in array aStatusArr
  for i:= 0 to aPatCount - 1 do begin
    aPat:= aPatList[i];
    Inc(aStatusArr[aInd, aPat.Status]);
    if (aPat.Status = 2)and(aPat.DisForm = 2) then
      Inc(aStatusArr[aInd, 5]);
    aStatusArr[aInd, 6]:= aStatusArr[aInd, 2] + aStatusArr[aInd, 3] + aStatusArr[aInd, 4];
  end;
  StatusAgeHistArr[aInd]:= StatusAgeHist(aPatList, aPatCount, aCurrTime);
  AgeHistArr[aInd]:= AgeHist(PatList, PatCount, aCurrTime);
  if aStrGrid <> nil then
    FillInfectStrGrid(aStatusArr, aInd, aStrGrid);
end;

procedure UpdateStatusArrEpi(const aPatList: TPatList; aPatCount, aCurrTime: Integer; var aStatusArr: TStatusArr);
  {RU: Обновление массива статусов aStatusArr пациентов из aPatList для эпицентра в момент aCurrTime}
  {EN: The update of the array of statuses aStatusArr of individuals from aPatList for epicenter at the moment aCurrTime}
var i, aInd: Integer;
    aPat: TPat;
begin
  aInd:= aCurrTime - CurrMinInfTime;   // RU: Индекс в массиве aStatusArr EN: Index in the array
  if Length(aStatusArr) > (MaxSimulTime - CurrMinInfTime) then
    MainForm.PosEdit.Text:= IntToStr(aInd);
  for i:= 0 to aPatCount - 1 do begin
    aPat:= aPatList[i];
    Inc(aStatusArr[aInd, aPat.Status]);
    if (aPat.Status = 2)and(aPat.DisForm = 2) then
      Inc(aStatusArr[aInd, 5]);
    aStatusArr[aInd, 6]:= aStatusArr[aInd, 2] + aStatusArr[aInd, 3] + aStatusArr[aInd, 4];
  end;
end;

function AgeDistrFunc: TDoublePoint2DArr;
  {RU: Возвращает массив точек (Age, FuncValue) с шагом 5 по возрасту на основе MAAgeHistogram}
  {EN: Returns the array of points (Age, FuncValue) with the 5 year increments based on MAAgeHistogram}
var i, aLen, aStep: Integer;
    aCoeff: Double;
begin
  aLen:= 20;
  aStep:= 5;
  SetLength(Result, aLen);
  Result[0]:= ZeroDoublePoint2D;
  for i:= 0 to aLen - 2 do
    Result[i + 1]:= DoublePoint2D(aStep*(i + 1), Result[i, 1] + MAAgeHistogram[i]);
  aCoeff:= 1/Result[aLen - 1, 1];
  for i:= 1 to aLen - 1 do
    Result[i, 1]:= aCoeff*Result[i, 1];
end;

function RandomAge(const aAgeDistrFunc: TDoublePoint2DArr; aRandVal: Double): Integer;
  {RU: Возвращает случайное значение возраста по aRandVal - равномерно распределенному на [0; 1]}
  {EN: Returns the random value of age for aRandVal - uniformly distributed in [0; 1]}
var i, aInd, aLen, aStep: Integer;
    aLambda: Double;
begin
  aLen:= Length(aAgeDistrFunc);
  aStep:= 5;
  aInd:= 0;
  for i:= 0 to aLen - 2 do
    if aRandVal < aAgeDistrFunc[i + 1, 1] then begin
      aInd:= i;
      Break;
    end;
  aLambda:= (aRandVal - aAgeDistrFunc[aInd, 1])/(aAgeDistrFunc[aInd + 1, 1] - aAgeDistrFunc[aInd, 1]);
  Result:= Round(aStep*(aInd + aLambda));
end;

procedure FillParamStrGrid(const aStrGrid: TStringGrid);
var i, aParamCount: Integer;
begin
  aParamCount:= ParamCount;
  if aParamCount < 0 then Exit;
  aStrGrid.Cells[0, 0]:= 'Param #';
  aStrGrid.Cells[1, 0]:= 'Param Value';
  aStrGrid.RowCount:= ParamCount + 2;
  for i:= 0 to ParamCount do begin
    aStrGrid.Cells[0, i + 1]:= IntToStr(i);
    aStrGrid.Cells[1, i + 1]:= ParamStr(i);
  end;
  SetStrGridHeight(aStrGrid, 100);
  DeselectStrGrid(aStrGrid);
end;

function StatusArrToCSVList(const aStatusArr: TStatusArr; const aSumDetectECCounts: TIntArray; aDelim: String): TStringList;
  {RU: Возвращает список типа TStringList с параметрами пациентов из aStatusArr}
  {EN: Returns the list of type TStringList with individual's parameters from aStatusArr}
var i, j, aInitInd, aTotal, aLenSumDetect: Integer;
    aHeader, aStr: String;
begin
  Result:= TStringList.Create;
  aLenSumDetect:= Length(aSumDetectECCounts);
  aHeader:= 'Day' + aDelim + 'Hiden' + aDelim + 'Under treatment' + aDelim + 'Recovered' + aDelim + 'Fatalities' + aDelim + 'Mild' + aDelim + 'Diagnosed' + aDelim + 'Total cases';
  Result.Add(aHeader);
  aInitInd:= DetectDayInd - CurrDetDay;
  for i:= 0 to Length(aStatusArr) - 1 do begin
    aStr:= YearDays[i + aInitInd];
    for j:= 1 to 5 do
      aStr:= aStr + aDelim + IntToStr(aStatusArr[i, j]);
    if i < aLenSumDetect then
      aStr:= aStr + aDelim + IntToStr(aSumDetectECCounts[i])
    else
      aStr:= aStr + aDelim;
    aTotal:= aStatusArr[i, 2] + aStatusArr[i, 3] + aStatusArr[i, 4];
    aStr:= aStr + aDelim + IntToStr(aTotal);
    Result.Add(aStr);
  end;
end;

procedure SaveStatusArr(const aStatusArr: TStatusArr; const aSumDetectECCounts: TIntArray; aFileName: String);
var aDelim: String;
    aStatusStrList: TStringList;
begin
  if aStatusArr = nil then begin
    MessageDlg('The aStatus Array is Empty', mtInformation, [mbOk], 0);
    Exit;
  end;
  aDelim:= ',';
  aStatusStrList:= StatusArrToCSVList(aStatusArr, aSumDetectECCounts, aDelim);
  aStatusStrList.SaveToFile(aFileName);
end;

function StatusStrArrToCSVList(const aStatusStrArr: TStatusStrArr; aDelim: String): TStringList;
  {RU: Возвращает список типа TStringList с параметрами пациентов из aStatusStrArr}
  {EN: Returns hte list of type TStringList with individual's parameters from aStatusStrArr}
var i, j, k, aLen, aPos, aCounter, aLenStr, aInd: Integer;
    aHeader, aStr, aStatusStr, aDayStr, aDateStr, aLat, aLong, Quant: String;
    aPosArr: TIntArray;

const StatusName: array[0..2] of String = ('Hiden','Under treatment','Fatalities');

begin
  Result:= TStringList.Create;
  aLen:= Length(aStatusStrArr[0]);
  aHeader:= 'Id' + aDelim + 'Latitude' + aDelim + 'Longitude' + aDelim + 'Quantity' + aDelim + 'Date' + aDelim + 'Status';
  Result.Add(aHeader);
  for i:= 0 to 2 do begin   // RU: Заполнение по статусу EN: Filling based on status
    aStatusStr:= StatusName[i];
    for j:= 0 to aLen - 1 do begin  // RU: Заполнение по дням EN: Filling day by day
      aDayStr:= aStatusStrArr[i, j];   // RU: Данные для дня j (со статусом i) EN: Data for day j (with the status i)
      aPos:= Pos(aDelim, aDayStr);
      aDateStr:= Copy(aDayStr, 1, aPos - 1);
      Delete(aDayStr, 1, aPos);
      aLenStr:= Length(aDayStr);
      SetLength(aPosArr, aLenStr div 4);
      aPosArr[0]:= 0;
      aCounter:= 1;
      for k:= 1 to aLenStr do
        if aDayStr[k] = aDelim then begin
          aPosArr[aCounter]:= k;
          Inc(aCounter);
        end;
      aPosArr[aCounter]:= aLenStr + 1;
      Inc(aCounter);
      SetLength(aPosArr, aCounter);
      aInd:= 0;
      repeat
        aLat:= Copy(aDayStr, aPosArr[aInd] + 1, aPosArr[aInd + 1] - aPosArr[aInd] - 1);
        aLong:= Copy(aDayStr, aPosArr[aInd + 1] + 1, aPosArr[aInd + 2] - aPosArr[aInd + 1] - 1);
        Quant:= Copy(aDayStr, aPosArr[aInd + 2] + 1, aPosArr[aInd + 3] - aPosArr[aInd + 2] - 1);
        aStr:= aLat + '-' + aLong + aDelim +  aLat + aDelim + aLong + aDelim + Quant + aDelim + aDateStr + aDelim + aStatusStr;
        Result.Add(aStr);
        Inc(aInd, 3);
      until (aInd >= aCounter - 1);
    end;
  end;
end;

procedure SaveStatusStrArr(const aStatusStrArr: TStatusStrArr; aFileName: String);
var aDelim: String;
    aStatusStrList: TStringList;
begin
  if aStatusStrArr[0] = nil then begin
    MessageDlg('The Patient Status Coordinate Array is Empty', mtInformation, [mbOk], 0);
    Exit;
  end;
  aDelim:= ',';
  aStatusStrList:= StatusStrArrToCSVList(aStatusStrArr, aDelim);
  aStatusStrList.SaveToFile(aFileName);
end;

procedure CheckStatusArr(const aStatusArr: TStatusArr);
var aSumStatus: TStatus;
    i, j: Integer;
begin
  if aStatusArr = nil then Exit;
  aSumStatus[0]:= 0;
  for i:= 1 to 5 do
    aSumStatus[i]:= aStatusArr[0, i];
  for j:= 1 to Length(aStatusArr) - 1 do
    for i:= 1 to 5 do
      Inc(aSumStatus[i], aStatusArr[j, i] - aStatusArr[j - 1, i]);
end;

function InitNodes: TNodes;
  {RU: Возвращает двумерный массив узлов на карте с шагом MeshStep.}
  {EN: Returns two-dimensional array of knots on the mau with step MeshStep.}
var i, j, aLenX, aLenY: Integer;
begin
  aLenX:= Ceil(CurrMapSize[0]/MeshStep);
  aLenY:= Ceil(CurrMapSize[1]/MeshStep);
  SetLength(Result, aLenX, aLenY);
  for i:= 0 to aLenX - 1 do
    for j:= 0 to aLenY - 1 do
      Result[i, j]:= ZeroIntPoint3D;
end;

function InitNodesArr(aSize: Integer): TNodesArr;
var i: Integer;
begin
  SetLength(Result, aSize);
  for i:= 0 to aSize - 1 do
    Result[i]:= InitNodes;
end;

procedure UpdateNodes(const aPatList: TPatList; aPatCount: Integer; var aNodes: TNodes);
  {RU: Обновление узлов на карте aNodes по данным aPatList}
  {EN: Updates the knots on the map aNodes based on data aPatList}
var i, aStatus, aIndX, aIndY: Integer;
    aPat: TPat;
begin
  for i:= 0 to aPatCount - 1 do begin
    aPat:= aPatList[i];
    aStatus:= aPat.Status;
    if aStatus <> 3 then begin   // RU: Пациент не выздоровевший EN: Individual is not recovered
      aIndX:= Round(aPat.Coord[0]/MeshStep);
      aIndY:= Round(aPat.Coord[1]/MeshStep);
      if aStatus < 3 then  // RU: Инфицированный или лечащийсч EN: Infected or treated
        Inc(aNodes[aIndX, aIndY, aStatus - 1])
      else
        Inc(aNodes[aIndX, aIndY, aStatus - 2]);  // RU: Умерший EN: Deceased
    end;
  end;
end;

function NotZeroNode(aPoint: TIntPoint3D): Boolean;
begin
  Result:= (aPoint[0] > 0)or(aPoint[1] > 0)or(aPoint[2] > 0);
end;

procedure SetStatusStrDay(const aNodes: TNodes; aStrInd: Integer; var aStatusStrArr: TStatusStrArr);
  {RU: Заполнение трех строк с координатами и количеством пациентов (Long, Lat, Count) для разных статусов: 0 - Status = 1; 1 - Status = 2; 2 - Status = 4.
   aStrInd - индекс строки в массивах aStatusStrArr[i], i = 0,1,2.}
  {EN: Filling the three strings with the coordinates and the number of infected (Long, Lat, Count) for different statuses: 0 - Status = 1; 1 - Status = 2; 2 - Status = 4.
   aStrInd - index of the string in arrays aStatusStrArr[i], i = 0,1,2.}
var i, j, k, aLen: Integer;
    aStr, aDelim: String;
    aGeoNodeCoord: TDoublePoint2D;
    aNode: TIntPoint3D;
begin
  if aNodes = nil then Exit;
  aDelim:= ',';
  aLen:= Length(aNodes[0]);
  for i:= 0 to Length(aNodes) - 1 do
    for j:= 0 to aLen - 1 do begin
      aNode:= aNodes[i, j];
      if NotZeroNode(aNode) then begin
        aGeoNodeCoord:= MapToGeoCoord(IntegerPoint2D(i*MeshStep, j*MeshStep), AngleScale);
        for k:= 0 to 2 do
          if aNode[k] > 0 then begin
            aStr:= Format('%6.3f', [aGeoNodeCoord[1]]) + aDelim + Format('%6.3f', [aGeoNodeCoord[0]]) + aDelim + IntToStr(aNode[k]);
            aStatusStrArr[k, aStrInd]:= aStatusStrArr[k, aStrInd] + aDelim + aStr;
          end;
      end;
    end;
end;

function InitSamplesArr(aPeriodCount, aIterCount: Integer): TSamplesArr;
  {RU: Возвращает массив троек выборок на все периоды прогнозирования aPeriodCount. aIterCount - количество симуляций в методе МонтехКарло.
   Выборка для одного периода содержит 4 массива: 0 - инфицированные, 1 - госпиталь, 2 - умершие, 3 - легкие.}
  {EN: Returns the array of triplet samples for all periods of predictions aPeriodCount. aIterCount - the number o simulations in the MonteCarlo method.
   The sampple for a single period contains four arrays: 0 - infected, 1 - hospitalized, 2 - deceased, 3 - mild.}
var i, j: Integer;
begin
  SetLength(Result, aPeriodCount);
  for i:= 0 to aPeriodCount - 1 do
    for j:= 0 to 4 do
      SetLength(Result[i, j], aIterCount);
end;

procedure SetSamplesArrPeriod(const aStatusArr: TStatusArr; aTimePeriod: TIntPoint2D; aPeriodInd, aIterInd: Integer; var aSamplesArr: TSamplesArr);
  {RU: Заполнение данными четверок выборок в aSamplesArr для итерации aIterInd по aStatusArr для данной итерации. aTimePeriod определяет интервал в aStatusArr.
   Предполагается, что размер aSamplesArr согласован с aTimePeriod.}
  {EN: Filling with data four samples in aSamplesArr for iteration aIterInd according to aStatusArr for a given iteration. aTimePeriod defines the interval in aStatusArr.
   It is assumed that the size aSamplesArr is in agreement with aTimePeriod.}
var aInitInd, aTermInd: Integer;
begin
  aInitInd:= aTimePeriod[0] - CurrMinInfTime;  // RU: Начальный индекс в aStatusArr EN: Beginning inxed in aStatusArr
  aTermInd:= aTimePeriod[1] - CurrMinInfTime;  // RU: Конечный индекс в aStatusArr EN: Ending index in aStatusArr
  aSamplesArr[aPeriodInd, 0, aIterInd]:= aStatusArr[aTermInd, 1] - aStatusArr[aInitInd - 1, 1];   // RU: Приращение Infected EN: Increase in Infected
  aSamplesArr[aPeriodInd, 2, aIterInd]:= aStatusArr[aTermInd, 4] - aStatusArr[aInitInd - 1, 4];  // RU: Приращение Dead EN: Increase in Dead
  aSamplesArr[aPeriodInd, 3, aIterInd]:= aStatusArr[aTermInd, 5] - aStatusArr[aInitInd - 1, 5];  // RU: Приращение Mild EN: Increase in Mild
  aSamplesArr[aPeriodInd, 1, aIterInd]:= aStatusArr[aTermInd, 2] - aStatusArr[aInitInd - 1, 2] - aSamplesArr[aPeriodInd, 3, aIterInd];  // RU: Приращение Hospital EN: Increase in Hospital
end;

function SamplesArray(const aForeсcastSchedule: TIntPoint2DArr; aIterCount: Integer; const aStatusBar: TStatusBar): TSamplesArr;
  {RU: Заполнение данными четверок выборок в aSamplesArr.}
  {EN: Filling with data four samples in aSamplesArr.}
var i, j, aPeriodCount, aMaxDay: Integer;
    aStatusText: String;
begin
  Result:= nil;
  if aForeсcastSchedule = nil then Exit;
  aPeriodCount:= Length(aForeсcastSchedule);
  Result:= InitSamplesArr(aPeriodCount, aIterCount);
  aMaxDay:= aForeсcastSchedule[aPeriodCount - 1, 1] + 1;
  for i:= 0 to aIterCount - 1 do begin  // Итерации симуляций
    if (i mod 5) = 0 then begin
      aStatusText:= 'Forecast Evaluation Progress: Iteration ' + IntToStr(i) + ' (Up to ' + IntToStr(aIterCount) +  ')   ';
      SetStatusText(aStatusBar, 0, aStatusText);
    end;
    Application.ProcessMessages;
    InitModel_1(HiperParam, InitContProb, IsolContProb, CurrDetDay, PatList, PatCount);
    for j:= 0 to aMaxDay - 1 do
      SimulationStep_1(HiperParam, InitContProb, IsolContProb, PatList, PatCount, StatusArr);
    for j:= 0 to aPeriodCount - 1 do
      SetSamplesArrPeriod(StatusArr, aForeсcastSchedule[j], j, i, Result);
  end;
  SetStatusText(aStatusBar, 0, '');
end;

function StatusHist(const aSamples: TIntArray; aIntervCount: Integer): THist;
  {RU: Возвращает гистограмму распределения по выборке aSamples. aIntervCount - количество интервалов гистограммы. }
  {EN: Returns the histogram of the distribution according to aSamples. aIntervCount - the number of the intervals in the histogram. }
var i, aInd, aLen, aHistStep: Integer;
    aMinMax: TIntegerPoint2D;
begin
  Result.HistVal:= nil;
  if aSamples = nil then Exit;
  aLen:= Length(aSamples);  // Количество симуляций
  Result.IntervCount:= aIntervCount;
  aMinMax:= MinMaxForArray(aSamples);
  aHistStep:= Ceil((aMinMax[1] - aMinMax[0])/aIntervCount);
  Result.HistStep:= aHistStep;
  Result.MinMaxVal:= IntegerPoint2D(aMinMax[0], aMinMax[0] + aIntervCount*aHistStep);
  SetLength(Result.HistVal, aIntervCount);
  for i:= 0 to aIntervCount - 1 do
    Result.HistVal[i]:= 0;
  for i:= 0 to aLen - 1 do begin
    aInd:= (aSamples[i] - aMinMax[0]) div aHistStep;
    Inc(Result.HistVal[aInd]);
  end;
  Result.Sum:= aLen;
end;

function StatusDistr(const aHist: THist): TDoublePoint2DArr;
  {RU: Возвращает функцию распределения, соответствующую гистограмме aHist}
  {EN: Returns the distribution function which corresponds to histogram aHist}
var i, aLen: Integer;
    aCoeff: Double;
begin
  Result:= nil;
  if aHist.HistVal = nil then Exit;
  aLen:= aHist.IntervCount + 1;
  SetLength(Result, aLen);
  Result[0]:= DoublePoint2D(aHist.MinMaxVal[0], 0);
  for i:= 0 to aLen - 2 do
    Result[i + 1]:= DoublePoint2D(Result[i, 0] + aHist.HistStep, Result[i, 1] + aHist.HistVal[i]);
  aCoeff:= 1/Result[aLen - 1, 1];
  for i:= 1 to aLen - 1 do
    Result[i, 1]:= Result[i, 1]*aCoeff;
end;

function Quantile(const aDistrFunc: TDoublePoint2DArr; aLevel: Double): Integer;
  {RU: Возвращает квантиль уровня aLevel для кусочно-линейной функции распределения aDistrFunc}
  {EN: Returns the qunatile of the level aLevel for the partially-linear dictribution function aDistrFunc}
var i, aInd, aLen: Integer;
    aLambda, aStep: Double;
begin
  aLen:= Length(aDistrFunc);
  aStep:= aDistrFunc[1, 0] - aDistrFunc[0, 0];
  aInd:= 0;
  for i:= 0 to aLen - 2 do
    if aLevel < aDistrFunc[i + 1, 1] then begin
      aInd:= i;
      Break;
    end;
  aLambda:= (aLevel - aDistrFunc[aInd, 1])/(aDistrFunc[aInd + 1, 1] - aDistrFunc[aInd, 1]);
  Result:= Round(aDistrFunc[0, 0] + aStep*(aInd + aLambda));
end;

function R0Distr(const aRealHist: TRealHist): TDoublePoint2DArr;
  {RU: Возвращает функцию распределения, соответствующую гистограмме aHist}
  {EN: Returns the distribution function that corresponds to histogram aHist}
var i, aLen: Integer;
    aCoeff: Double;
begin
  Result:= nil;
  if aRealHist.HistVal = nil then Exit;
  aLen:= aRealHist.IntervCount + 1;
  SetLength(Result, aLen);
  Result[0]:= DoublePoint2D(aRealHist.MinMaxVal[0], 0);
  for i:= 0 to aLen - 2 do
    Result[i + 1]:= DoublePoint2D(Result[i, 0] + aRealHist.HistStep, Result[i, 1] + aRealHist.HistVal[i]);
  aCoeff:= 1/Result[aLen - 1, 1];
  for i:= 1 to aLen - 1 do
    Result[i, 1]:= Result[i, 1]*aCoeff;
end;

function R0Quantile(const aR0Distr: TDoublePoint2DArr; aLevel: Double): Double;
  {RU: Возвращает квантиль уровня aLevel для кусочно-линейной функции распределения aR0Distr}
  {EN: Returns the qunatile for aLevel for the partially-linear distribution function aR0Distr}
var i, aInd, aLen: Integer;
    aLambda, aStep: Double;
begin
  aLen:= Length(aR0Distr);
  aStep:= aR0Distr[1, 0] - aR0Distr[0, 0];
  aInd:= 0;
  for i:= 0 to aLen - 2 do
    if aLevel < aR0Distr[i + 1, 1] then begin
      aInd:= i;
      Break;
    end;
  aLambda:= (aLevel - aR0Distr[aInd, 1])/(aR0Distr[aInd + 1, 1] - aR0Distr[aInd, 1]);
  Result:= aR0Distr[0, 0] + aStep*(aInd + aLambda);
end;

function EpiWeek(aWeekInd, aDetectDayInd: Integer): TIntPoint2D;
  {RU: Возвращает EpiWeek в виде (Period[0], Period[1]) по годовому индексу aWeekInd (на 1 меньше номера). Period - день относительно aCurrDetDay}
  {EN: Returns EpiWeek as (Period[0], Period[1]) based on the annual index aWeekInd (- 1 the actual number). Period - day in realtion to aCurrDetDay}
var aDay0, aDay1: String;
begin
  Result:= ZeroIntPoint2D;
  if aWeekInd < 0 then Exit;
  if aWeekInd = 0 then
    Result:= Point2D(0, EndOfFirstEpiWeek)
  else begin
    Result[0]:= (aWeekInd - 1)*7 - aDetectDayInd + EndOfFirstEpiWeek + 1;
    Result[1]:= Result[0] + 6;
  end;
  aDay0:= YearDays[Result[0] + aDetectDayInd];
  aDay1:= YearDays[Result[1] + aDetectDayInd];
end;

function ForeWeekInd(aCurrDay, aDetectDayInd: Integer): Integer;
  {RU: Возвращает индекс EpiWeek, на который приходится aCurrDay.}
  {EN: Retunrs the index EpiWeek, for the aCurrDay.}
var aCurrDayInd: Integer;
begin
  aCurrDayInd:= aCurrDay + aDetectDayInd;
  if aCurrDayInd <= EndOfFirstEpiWeek then
    Result:= 0
  else
    Result:= ((aCurrDayInd - EndOfFirstEpiWeek - 1) div 7) + 1;
  EpiWeek(Result, DetectDayInd);
end;

function ForeсcastSchedule(aForeDay, aWeekCount, aDetectDayInd: Smallint): TIntPoint2DArr;
  {RU: Возвращает расписание прогнозов, начиная с aForeDay (отсчитываемый от CurrDetDay). Первые прогнозы - по дням (до конца первой EpuWeek),
   затем - по неделям (EpiWeeks). aWeekCount - количество недель для прогноза после ежедневного прогноза.}
  {EN: Returns the schedule of predictions starting from aForeDay (counted from CurrDetDay). The first prediction - daily (дup the the first EpuWeek),
   then - weekly (EpiWeeks). aWeekCount - the number of weeks for prediction after the daily prediction.}
var i, aForeWeekInd, aForeDays, aLen: Smallint;
    aEpiWeek: TIntPoint2D;
    aResStr: TStringArr;
begin
  aForeWeekInd:= ForeWeekInd(aForeDay, aDetectDayInd);  // RU: Индекс EpiWeek, на который приходится aForeDay EN: Index EpiWeek that corresponds to aForeDay 
  aEpiWeek:= EpiWeek(aForeWeekInd, aDetectDayInd);  // RU: Начало и конец недели (относительно aDetectDayInd), на который приходится aForeDay 
                                                    // EN: The beginning and the end of the week (in relation to aDetectDayInd) which correspond to aForeDay
  aForeDays:= aEpiWeek[1] - aForeDay;
  if aForeDays = 0 then begin  // RU: aForeDays выпало на субботу  EN: aForeDays is Saturday
    aForeWeekInd:= aForeWeekInd + 1;
    aForeDays:= 7;
  end;
  aLen:= aWeekCount + aForeDays;
  SetLength(Result, aLen);
  SetLength(aResStr, aLen);
  for i:= 0 to aForeDays - 1 do begin
    Result[i, 0]:= aForeDay + i + 1;
    Result[i, 1]:= Result[i, 0];
    aResStr[i]:= YearDays[Result[i, 0] + aDetectDayInd] +'-' + YearDays[Result[i, 1] + aDetectDayInd];
  end;
  if aForeDays < 6 then
    Inc(aForeWeekInd);
  for i:= 0 to aWeekCount - 1 do begin
    Result[aForeDays + i]:= EpiWeek(aForeWeekInd + i, DetectDayInd);
    aResStr[aForeDays + i]:= YearDays[Result[aForeDays + i, 0] + aDetectDayInd] +'-' + YearDays[Result[aForeDays + i, 1] + aDetectDayInd];
  end;
end;

function HistStatusArray(const aSamplesArray: TSamplesArr; aIntervCount: Integer): THistStatusArr;
  {RU: Формирование массива гистограмм различных статусов для всех периодов прогнозирования}
  {EN: The creation of the array of histograms of diferent statuses for all prediction periods}
var i, j, aLen: Integer;
begin
  Result:= nil;
  if aSamplesArray = nil then Exit;
  aLen:= Length(aSamplesArray);
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do
    for j:= 0 to 3 do
      Result[i, j]:= StatusHist(aSamplesArray[i, j], aIntervCount);
end;

function GetLevelList: TDoubleArray;
  {RU: Возвращает стандартный список квантилей}
  {EN: Returns the standard list of quantiles}
var i: Integer;
begin
  SetLength(Result, 23);
  Result[0]:= 0.01;
  Result[1]:= 0.025;
  for i:= 0 to 18 do
    Result[i + 2]:= 0.05*(i + 1);
  Result[21]:= 0.975;
  Result[22]:= 0.99;
end;

function GetDailyLevelList: TDoubleArray;
  {RU: Возвращает стандартный список квантилей для ежедневного прогноза}
  {EN: Returns the standad list of quantiles for each prognosis}
begin
  SetLength(Result, 3);
  Result[0]:= 0.05;
  Result[1]:= 0.5;
  Result[2]:= 0.95;
end;

function StatusQuantiles(const aStatusDistr: TDoublePoint2DArr; const aLevelList: TDoubleArray): TIntArray;
  {RU: Возвращает массив квантилей, соответствующих списку уровней для распределения с aHist}
  {EN: Returns the array of quantiles which correspond to the list of levels for distribution aHist}
var i, aLen, aInd: Integer;
    aStep, aLambda, aLevel: Double;
begin
  Result:= nil;
  if aStatusDistr = nil then Exit;
  aLen:= Length(aLevelList);
  SetLength(Result, aLen);
  aStep:= aStatusDistr[1, 0] - aStatusDistr[0, 0];
  aInd:= 0;
  for i:= 0 to aLen - 1 do begin
    aLevel:= aLevelList[i];  // RU: Текущий уровень вероятности EN: The current distribution
    while aLevel > aStatusDistr[aInd + 1, 1] do
      Inc(aInd);
    aLambda:= (aLevel - aStatusDistr[aInd, 1])/(aStatusDistr[aInd + 1, 1] - aStatusDistr[aInd, 1]);
    Result[i]:= Round(aStatusDistr[0, 0] + aStep*(aInd + aLambda));
  end;
end;

function ForecastArr(aForeDay, aWeekCount, aDetectDayInd: Smallint; aIterCount, aHistIntervCount: Integer; const aLevelList: TDoubleArray;
         const aStatusBar: TStatusBar): TForecastArr;
  {RU: Возвращает массив параметров прогноза для множества периодов прогнозирования, задаваемого (aForeDay, aWeekCount) и уровней значимости aLevelList}
  {EN: Returns the array of parameters for prognosos for multiple prediciton periods deined by (aForeDay, aWeekCount) and levels aLevelList}
var aForeсcastSchedule: TIntPoint2DArr;
    aSamplesArray: TSamplesArr;
    i, j, aLen, aEstimInd: Integer;
begin
  Result:= nil;
  if aLevelList = nil then Exit;
  aForeсcastSchedule:= ForeсcastSchedule(aForeDay, aWeekCount, aDetectDayInd);
  if aForeсcastSchedule = nil then Exit;
  aLen:= Length(aForeсcastSchedule);  // RU: Количество периодов прогноза EN: The number of prediction periods
  SetLength(Result, aLen);
  aSamplesArray:= SamplesArray(aForeсcastSchedule, aIterCount, aStatusBar);
  if aSamplesArray = nil then Exit;
  aEstimInd:= (Length(aLevelList) - 1) div 2;
  for i:= 0 to aLen - 1 do begin
    Result[i].Period:= aForeсcastSchedule[i];
    for j:= 0 to 3 do begin
      Result[i].Histogram[j]:= StatusHist(aSamplesArray[i, j], aHistIntervCount);
      Result[i].DistrFunc[j]:= StatusDistr(Result[i].Histogram[j]);
      Result[i].Quantiles[j]:= StatusQuantiles(Result[i].DistrFunc[j], aLevelList);
      Result[i].PointEstim[j]:= Result[i].Quantiles[j, aEstimInd];
    end;
  end;
end;

function ForecastArrToCSVList(const aForecastArr: TForecastArr; aDelim: String): TStringList;
  {RU: Возвращает список типа TStringList с параметрами прогноза из aForecastArr}
  {EN: Retursn the list of type TStringList with prediction parameters from aForecastArr}
var i, j, aLen, aLenQuant: Integer;
    aStr, aHeader, aLocation, aPrefix: String;
    aForecast: TForecast;
begin
  Result:= TStringList.Create;
  aLen:= Length(aForecastArr);  // RU: Количество периодов прогноза EN: The number of prediction periods
  aLenQuant:= Length(LevelList);
  aLocation:= '25';
  aHeader:= 'Forecast Period' + aDelim + 'Location' + aDelim + 'Type' + aDelim + 'Quantile' + aDelim + 'Inc Death';
  Result.Add(aHeader);
  for i:= 0 to aLen - 1 do begin   // RU: Для периода прогнозирования EN: For prediction period
    aForecast:= aForecastArr[i];
    aPrefix:= YearDayCalend(aForecast.Period[0]);
    if aForecast.Period[1] > aForecast.Period[0] then
    aPrefix:= aPrefix + ' - ' + YearDayCalend(aForecast.Period[1]);
    aPrefix:= aPrefix + aDelim + aLocation;  // RU: Период прогноза EN: Prediction period
    aStr:= aPrefix + aDelim + 'point' + aDelim + 'NA' + aDelim + IntToStr(aForecast.PointEstim[2]);
    Result.Add(aStr);
    for j:= 0 to aLenQuant - 1 do begin
      aStr:= aPrefix + aDelim + 'quantile' + aDelim + FloatToStr(LevelList[j]) + aDelim + IntToStr(aForecast.Quantiles[2, j]);
      Result.Add(aStr);
    end;
  end;
end;

procedure SaveForecastArr(const aForecastArr: TForecastArr; aFileName: String);
var aDelim: String;
    aForecastStrList: TStringList;
begin
  if aForecastArr = nil then begin
    MessageDlg('The Forecast Array is Empty', mtInformation, [mbOk], 0);
    Exit;
  end;
  aDelim:= ',';
  aForecastStrList:= ForecastArrToCSVList(aForecastArr, aDelim);
  aForecastStrList.SaveToFile(aFileName);
end;

procedure SetDailySamplesArr(const aStatusArr: TStatusArr; aPeriodInd, aIterInd, aStatusInd: Integer; var aSamplesArr: TSamplesArr);
  {RU: Заполнение данными четверок выборок в aSamplesArr для итерации aIterInd по aStatusArr для данной итерации.
   Предполагается, что размер aSamplesArr согласован с aTimePeriod.}
  {EN: Fills with data four samples in aSamplesArr for iteration aIterInd according to aStatusArr for given iteration.
   It is assumed that the size aSamplesArr is in agreement with aTimePeriod.}
begin
  aSamplesArr[aPeriodInd, 0, aIterInd]:= aStatusArr[aStatusInd, 1];   // RU: Количество Infected в момент aPeriodInd EN: The number of infected at aPeriodInd
  aSamplesArr[aPeriodInd, 1, aIterInd]:= aStatusArr[aStatusInd, 2] - aStatusArr[aStatusInd, 5];  // RU: Количество Hospitalized в момент aPeriodInd EN: The number of Hospitalized at aPeriodInd
  aSamplesArr[aPeriodInd, 2, aIterInd]:= aStatusArr[aStatusInd, 4];   // RU: Количество Dead в момент aPeriodInd  EN: The amount of Dead  at the moment aPeriodInd 
  aSamplesArr[aPeriodInd, 3, aIterInd]:= aStatusArr[aStatusInd, 5];   // RU: Количество Mild в момент aPeriodInd  EN: The amount of Mild  at the moment aPeriodInd
  aSamplesArr[aPeriodInd, 4, aIterInd]:= aStatusArr[aStatusInd, 6];   // RU: Количество Cases в момент aPeriodInd EN: The amount of Cases at the moment aPeriodInd
end;

function DailySamplesArray(aForePeriod: TIntPoint2D; aIterCount: Integer; const aStatusBar: TStatusBar): TSamplesArr;
  {RU: Заполнение данными пятерок выборок в aSamplesArr. aForePeriod определяет интервал в aStatusArr.}
  {EN: Filling five sample in aSamplesArr. aForePeriod defines the interval in aStatusArr.}
var i, j, aPeriodCount, aStatusInd: Integer;
    aStatusText: String;
begin
  Result:= nil;
  aPeriodCount:= aForePeriod[1] - aForePeriod[0] + 1;
  Result:= InitSamplesArr(aPeriodCount, aIterCount);
  for i:= 0 to aIterCount - 1 do begin  // RU: Итерации симуляций EN: Simulation iterations
    if (i mod 5) = 0 then begin
      aStatusText:= 'Forecast Evaluation Progress: Iteration ' + IntToStr(i) + ' (Up to ' + IntToStr(aIterCount) +  ')   ';
      SetStatusText(aStatusBar, 0, aStatusText);
    end;
    Application.ProcessMessages;
    InitModel_1(HiperParam, InitContProb, IsolContProb, CurrDetDay, PatList, PatCount);
    for j:= 0 to aForePeriod[1] - 2 do
      SimulationStep_1(HiperParam, InitContProb, IsolContProb, PatList, PatCount, StatusArr);
    for j:= 0 to aPeriodCount - 1 do begin
      aStatusInd:= aForePeriod[0] + j - CurrMinInfTime;  // Ru: Индекс в aStatusArr EN: Index in aStatusArr 
      SetDailySamplesArr(StatusArr, j, i, aStatusInd, Result);
    end;
  end;
  SetStatusText(aStatusBar, 0, '');
end;

function DailyForecastArr(aForePeriod: TIntPoint2D; aDetectDayInd: Smallint; aIterCount, aHistIntervCount: Integer; const aLevelList: TDoubleArray;
         const aStatusBar: TStatusBar): TForecastArr;
  {RU: Возвращает массив параметров ежедневного прогноза для периода прогнозирования aForePeriod, задаваемого aLevelList, и уровней значимости aLevelList}
  {EN: Returns the array of parameters for daily predictions for the period aForePeriod, defined by aLevelList, and levels aLevelList}
var aSamplesArray: TSamplesArr;
    i, j, aLen, aEstimInd: Integer;
    aDayInd: Smallint;
begin
  Result:= nil;
  if aLevelList = nil then Exit;
  aLen:= aForePeriod[1] - aForePeriod[0];  // RU: Количество дней прогноза EN: The number of prediction days
  SetLength(Result, aLen);
  aSamplesArray:= DailySamplesArray(aForePeriod, aIterCount, aStatusBar);
  if aSamplesArray = nil then Exit;
  aEstimInd:= (Length(aLevelList) - 1) div 2;
  for i:= 0 to aLen - 1 do begin
    aDayInd:= aForePeriod[0] + i;
    Result[i].Period:= Point2D(aDayInd, aDayInd);
    for j:= 0 to 4 do begin
      Result[i].Histogram[j]:= StatusHist(aSamplesArray[i, j], aHistIntervCount);
      Result[i].DistrFunc[j]:= StatusDistr(Result[i].Histogram[j]);
      Result[i].Quantiles[j]:= StatusQuantiles(Result[i].DistrFunc[j], aLevelList);
      Result[i].PointEstim[j]:= Result[i].Quantiles[j, aEstimInd];
    end;
  end;
end;

function DailyForeArrToCSVList(const aForeArr: TForecastArr; aDelim: String): TStringList;
  {RU: Возвращает список типа TStringList с параметрами прогноза из aForeArr для ежедневного прогноза}
  {EN: Returns the list of type TStringList with prediction parameters from aForeArr for daily predictions}
var i, j, k, aLen, aLenQuant: Integer;
    aStr, aHeader, aPrefix: String;
    aForecast: TForecast;
    aLevelList: TDoubleArray;
begin
  Result:= TStringList.Create;
  aLen:= Length(aForeArr);  // RU: Количество дней прогноза EN: The number of prediction days
  aLevelList:= GetDailyLevelList;
  aLenQuant:= Length(aLevelList);
  aHeader:= 'Forecast Day' + aDelim + 'Quantile' + aDelim + 'Hidden' + aDelim + 'Hospital' + aDelim + 'Fatality' + aDelim + 'Mild' + aDelim + 'Cases';
  Result.Add(aHeader);
  for i:= 0 to aLen - 1 do begin   // RU: Для периода прогнозирования RU: For prediction period
    aForecast:= aForeArr[i];
    aPrefix:= YearDayCalend(aForecast.Period[0]);
    for j:= 0 to aLenQuant - 1 do begin
      aStr:= aPrefix + aDelim + FloatToStr(aLevelList[j]);
      for k:= 0 to 4 do
        aStr:= aStr + aDelim + IntToStr(aForecast.Quantiles[k, j]);
      Result.Add(aStr);
    end;
  end;
end;

procedure SaveDailyForecastArr(const aForeArr: TForecastArr; aFileName: String);
var aDelim: String;
    aForecastStrList: TStringList;
begin
  if aForeArr = nil then begin
    MessageDlg('The Daily Forecast Array is Empty', mtInformation, [mbOk], 0);
    Exit;
  end;
  aDelim:= ',';
  aForecastStrList:= DailyForeArrToCSVList(aForeArr, aDelim);
  aForecastStrList.SaveToFile(aFileName);
end;

function InitDeathSamplesArr(aPeriodCount, aIterCount: Integer): TDeathSamplesArr;
  {RU: Возвращает массив выборок (Inc, Cum) на все периоды прогнозирования aPeriodCount. aIterCount - количество симуляций в методе МонтехКарло.
   Выборка для одного периода содержит 2 массива: 0 - прирост количества умерших, 1 - общее количество умерших.}
  {EN: Returns the array of samples (Inc, Cum) for all prediction periods aPeriodCount. aIterCount - the number of simulation in the MonteCarlo method.
   The sample for a single period contains 2 arrays: 0 - increase in the number of deseased, 1 - the total number of diceased.}
var i, j: Integer;
begin
  SetLength(Result, aPeriodCount);
  for i:= 0 to aPeriodCount - 1 do
    for j:= 0 to 1 do
      SetLength(Result[i, j], aIterCount);
end;

procedure SetDeathSamplesArrPeriod(const aStatusArr: TStatusArr; aTimePeriod: TIntPoint2D; aPeriodInd, aIterInd, aShift: Integer; var aDeathSamplesArr: TDeathSamplesArr);
  {RU: Заполнение данными (Inc, Cum) выборок в DeathSamplesArr для итерации aIterInd по aStatusArr для данной итерации aIterInd. aTimePeriod определяет интервал в aStatusArr.
   Предполагается, что размер aSamplesArr согласован с aTimePeriod.}
  {EN: Filling with data (Inc, Cum) of smaples from DeathSamplesArr for iteration aIterInd according to aStatusArr for a given iteration aIterInd. aTimePeriod defines the interval in aStatusArr.
   It is assumed that the size aSamplesArr is in agreement with с aTimePeriod.}
var aInitInd, aTermInd: Integer;
begin
  aInitInd:= aTimePeriod[0] - CurrMinInfTime;  // RU: Начальный индекс в aStatusArr EN: Initial index in aStatusArr
  aTermInd:= aTimePeriod[1] - CurrMinInfTime;  // RU: Конечный индекс в aStatusArr  EN: Final index in aStatusArr
  aDeathSamplesArr[aPeriodInd, 0, aIterInd]:= aStatusArr[aTermInd, 4] - aStatusArr[aInitInd - 1, 4];   // RU: Приращение Inc EN: Increase Inc
  aDeathSamplesArr[aPeriodInd, 1, aIterInd]:= aStatusArr[aTermInd, 4] - aShift;  // RU: Общее количество Dead EN: The totla number of Dead
end;

function DeathSamplesArray(const aForeсcastSchedule: TIntPoint2DArr; aIterCount: Integer; const aStatusBar: TStatusBar): TDeathSamplesArr;
  {RU: Заполнение данными (Inc, Cum) выборок по периодам в DeathSamplesArr.}
  {EN: Filling wiht data (Inc, Cum) of samples according to periods DeathSamplesArr.}
var i, j, aPeriodCount, aMaxDay, aShift, aInitInd: Integer;
    aStatusText, aCalendDay, aCalendDay1: String;
begin
  Result:= nil;
  if aForeсcastSchedule = nil then Exit;
  aPeriodCount:= Length(aForeсcastSchedule);
  Result:= InitDeathSamplesArr(aPeriodCount, aIterCount);
  aMaxDay:= aForeсcastSchedule[aPeriodCount - 1, 1] + 1;
  aCalendDay:= YearDayCalend(aForeсcastSchedule[0, 0]);
  aInitInd:= aForeсcastSchedule[0, 0] - CurrMinInfTime - 1;  // RU: Начальный индекс в aStatusArr EN: Initial index in aStatusArr
  aCalendDay1:= YearDays[DeathMA[0, 0]];
  aCalendDay:= YearDayCalend(StatusArr[aInitInd, 0]);
  StopEvaluation:= False;
  for i:= 0 to aIterCount - 1 do begin  // RU: Итерации симуляций EN: Simulation iterations
    if StopEvaluation then begin
      SetStatusText(aStatusBar, 0, 'Interruption of Deaths Forecast Evaluation');
      SetStatusText(aStatusBar, 1, '');
      Application.ProcessMessages;
      Exit;
    end;
    if (i mod 5) = 0 then begin
      aStatusText:= 'Weekly Deaths Forecast Evaluation Progress: Iteration ' + IntToStr(i) + ' (Up to ' + IntToStr(aIterCount) +  ')   ';
      SetStatusText(aStatusBar, 0, aStatusText);
      SetStatusText(aStatusBar, 1, 'Press ESC to terminate');
    end;
    Application.ProcessMessages;
    InitModel_1(HiperParam, InitContProb, IsolContProb, CurrDetDay, PatList, PatCount);
    for j:= 0 to aMaxDay - 1 do
      SimulationStep_1(HiperParam, InitContProb, IsolContProb, PatList, PatCount, StatusArr);
    //aCalendDay1:= YearDays[DeathMA[aInitInd, 0]];
    //aCalendDay:= YearDayCalend(StatusArr[aInitInd, 0]);
    if aInitInd >= Length(DeathMA) then
      aInitInd:= Length(DeathMA) - 1;
    aShift:= StatusArr[aInitInd, 4] - DeathMA[aInitInd, 1];
    for j:= 0 to aPeriodCount - 1 do
      SetDeathSamplesArrPeriod(StatusArr, aForeсcastSchedule[j], j, i, aShift, Result);
  end;
  SetStatusText(aStatusBar, 0, '');
end;

function DeathForecastArr(aForeDay, aWeekCount, aDetectDayInd: Smallint; aIterCount, aHistIntervCount: Integer; const aLevelList: TDoubleArray;
         const aStatusBar: TStatusBar): TDeathForecastArr;
  {RU: Возвращает массив прогноза количества смертей (Inc and Cum) для множества периодов прогнозирования, задаваемого (aForeDay, aWeekCount) и уровней значимости aLevelList}
  {EN: Retursn the prediction array of death (Inc and Cum) or multiple prediction periods defined by (aForeDay, aWeekCount) and level aLevelList}
var aForeсcastSchedule: TIntPoint2DArr;
    aDeathSamplesArr: TDeathSamplesArr;
    i, j, aLen, aEstimInd: Integer;
begin
  Result:= nil;
  if aLevelList = nil then Exit;
  aForeсcastSchedule:= ForeсcastSchedule(aForeDay, aWeekCount, aDetectDayInd);
  if aForeсcastSchedule = nil then Exit;
  aLen:= Length(aForeсcastSchedule);  // RU: Количество периодов прогноза EN: The number of prediction periods.
  SetLength(Result, aLen);
  aDeathSamplesArr:= DeathSamplesArray(aForeсcastSchedule, aIterCount, aStatusBar);
  if aDeathSamplesArr = nil then Exit;
  aEstimInd:= (Length(aLevelList) - 1) div 2;
  for i:= 0 to aLen - 1 do begin
    Result[i].Period:= aForeсcastSchedule[i];
    for j:= 0 to 1 do begin
      Result[i].Histogram[j]:= StatusHist(aDeathSamplesArr[i, j], aHistIntervCount);
      Result[i].DistrFunc[j]:= StatusDistr(Result[i].Histogram[j]);
      Result[i].Quantiles[j]:= StatusQuantiles(Result[i].DistrFunc[j], aLevelList);
      Result[i].PointEstim[j]:= Result[i].Quantiles[j, aEstimInd];
    end;
  end;
end;

function DayIndToDateStr(aDayInd: Integer; aDelim, aDateDelim, aYearStr: String): String;
  {RU: Возвращает строку даты в формате YYYY-MM-DD по индексу дня в году (0 - Jan-1). aDelim - разделитель в исходной дате, aDateDelim - разделитель в выходной дате}
  {EN: Returns the strig in the format YYYY-MM-DD by the day index in a year (0 - Jan-1). aDelim - delimiter of the initial data, aDateDelim - delmiter in the final date}
var aDate, aMonth: String;
    aPos, aMonthNum, aDay: Integer;
begin
  aDate:= YearDays[aDayInd];
  aPos:= Pos(aDelim, aDate);
  aMonth:= Copy(aDate, 1, aPos - 1);
  aMonthNum:= MonthNameList.IndexOf(aMonth);
  Delete(aDate, 1, aPos);
  if Length(aDate) < 2 then
    aDate:= '0' + aDate;
  Result:= aYearStr + aDateDelim + MonthNum[aMonthNum] + aDateDelim + aDate;
end;

function DeathForecastArrToCSVList(const aDeathForecastArr: TDeathForecastArr; aDelim: String): TStringList;
  {RU: Возвращает список типа TStringList с параметрами прогноза из aForecastArr. aDelim - разделитель csv-файла}
  {EN: Returns the list of type TStringList with prediction parameters from aForecastArr. aDelim - is the delimiter in csv-file}
var i, j, k, aLen, aLenQuant, aForeDayInd, aDayCounter, aWeekCounter: Integer;
    aStr, aHeader, aLocationInd, aLocationName, aPrefix_0, aPrefix, aDateDelim, aForeInitDate: String;
    aDeathForecast: TDeathForecast;
    aDayForecast: Boolean;
const IncCum: array[0..1] of String = ('inc','cum');
      YearStr = '2020';
begin
  Result:= TStringList.Create;
  aLen:= Length(aDeathForecastArr);  // RU: Количество периодов прогноза EN: The number of prediction periods.
  aLenQuant:= Length(LevelList);
  aLocationInd:= '25';
  aLocationName:= 'Massachusetts';
  aDateDelim:= '-';
  aHeader:= 'forecast_date' + aDelim + 'target' + aDelim + 'target_end_date' + aDelim + 'location' + aDelim + 'location_name' + aDelim + 'type' +
            aDelim + 'quantile' + aDelim + 'value';
  Result.Add(aHeader);
  aForeDayInd:= aDeathForecastArr[0].Period[0] + DetectDayInd - 1;
  aForeInitDate:= DayIndToDateStr(aForeDayInd, aDateDelim, aDateDelim, YearStr);
  aDayCounter:= 0;
  aWeekCounter:= 0;
  for i:= 0 to aLen - 1 do begin   // RU: Для периода прогнозирования EN: For prediction period
    aDeathForecast:= aDeathForecastArr[i];
    aDayForecast:= (aDeathForecast.Period[1] - aDeathForecast.Period[0] = 0);
    aPrefix_0:= aForeInitDate + aDelim;
    if aDayForecast then begin
      Inc(aDayCounter);
      aPrefix_0:= aPrefix_0 + IntToStr(aDayCounter) + ' day ahead ';
    end
    else begin
      Inc(aWeekCounter);
      aPrefix_0:= aPrefix_0 + IntToStr(aWeekCounter) + ' wk ahead ';
    end;
    for j:= 0 to 1 do begin  // Данные для 0: Inc и 1: Cum
      aPrefix:= aPrefix_0 + IncCum[j] + ' death' + aDelim + DayIndToDateStr(aDeathForecastArr[i].Period[1] + DetectDayInd, aDateDelim, aDateDelim, YearStr) +
                aDelim + aLocationInd + aDelim + aLocationName;
      aStr:= aPrefix + aDelim + 'point' + aDelim + 'NA' + aDelim + IntToStr(aDeathForecast.PointEstim[j]);
      Result.Add(aStr);
      for k:= 0 to aLenQuant - 1 do begin
        aStr:= aPrefix + aDelim + 'quantile' + aDelim + Format('%5.3f', [LevelList[k]]) + aDelim + IntToStr(aDeathForecast.Quantiles[j, k]);
        Result.Add(aStr);
      end;
    end;
  end;
end;

procedure SaveDeathForecastArr(const aDeathForecastArr: TDeathForecastArr; aFileName: String);
var aDelim: String;
    aDeathForecastStrList: TStringList;
begin
  if aDeathForecastArr = nil then begin
    MessageDlg('The Weekly Deaths Forecast Array is Empty', mtInformation, [mbOk], 0);
    Exit;
  end;
  aDelim:= ',';
  aDeathForecastStrList:= DeathForecastArrToCSVList(aDeathForecastArr, aDelim);
  aDeathForecastStrList.SaveToFile(aFileName);
end;

function CasesRootMSE(const aStatusArr: TStatusArr; const aSumDetectECCounts: TIntArray; aTimePeriod: TIntPoint2D; aCurrSimulTime: Integer): Double;
  {RU: Возвращает среднеквадратичное отклонение общего количества детектированных пациентов при симуляции от реального количества за период aTimePeriod.
   Время в aTimePeriod отсчитывается от начальной даты в aSumDetectECCounts.}
  {EN: Returns the standard deviation of the totanl number of detected individuals during the simulation of the total number during the period aTimePeriod.
   The time aTimePeriod is counted from the date aSumDetectECCounts.}
var i, aMaxStatusInd, aCounter: Integer;
begin
  Result:= 0;
  if aStatusArr = nil then Exit;
  aMaxStatusInd:= aCurrSimulTime - CurrMinInfTime;
  if aMaxStatusInd > aTimePeriod[1] then Exit;
  aCounter:= 0;
  for i:= Max(1, aTimePeriod[0]) to aMaxStatusInd do begin
    if aSumDetectECCounts[i - 1] = 0 then Continue;
      Result:= Result + Sqr(aStatusArr[i, 6] - aSumDetectECCounts[i - 1]);
      Inc(aCounter);
  end;
  if aCounter > 0 then
    Result:= Sqrt(Result/aCounter);
end;

function EmptyDetDay(aDayDetECCounts: TIntArray): Boolean;
var i: Integer;
begin
  Result:= True;
  for i:= 0 to Length(aDayDetECCounts) - 1 do
    if aDayDetECCounts[i] > 0 then begin
      Result:= False;
      Exit;;
    end;
end;

procedure Correct(const aDetectECCounts: TIntArrayArr);
  {RU: Корректировка массива выявленных случаев (для исключения убывания)}
  {EN: The correction of the array of the detected cases (to exclude decrease)}
var i, j, aLen: Integer;
begin
  aLen:= Length(aDetectECCounts[0]);
  for i:= 0 to Length(aDetectECCounts) - 2 do
    for j:= 0 to aLen - 1 do
      aDetectECCounts[i + 1, j]:= Max(aDetectECCounts[i, j], aDetectECCounts[i + 1, j]);
end;

function PatStatus(const aPat: TPat; aCheckTime: Integer): Integer;
  {RU: Возвращает статус пациента aPat в момент aCheckTime - отсчитывается от CurrDetDay}
  {EN: Retursn the status of the individual aPat at time aCheckTime - which is counted from CurrDetDay}
var aTemp: Integer;
begin
  Result:= aPat.Status;
  if aCheckTime < aPat.InfectTime then Exit;  // RU: Пациент еще не был инфицирован EN: The individual has not been infected
  if aCheckTime < aPat.InfectTime + aPat.Detect then  // RU: Пациент инфицирован EN: The individual is infected 
    aTemp:= 1
  else
    if aCheckTime < aPat.InfectTime + aPat.Detect + aPat.DiseaseDur then  // RU: Пациент лечится EN: The individuals is treated
      aTemp:= 2
    else begin  // Лечение закончилось
      if aPat.DisForm = 0 then
        aTemp:= 4   // Пациент умер
      else
        aTemp:= 3;  // Пациент здоров
    end;
  if aTemp > Result then
    Result:= aTemp;
end;

procedure UpdatePatListStatus(aCheckTime, aPatCount: Integer; const aPatList: TPatList; var aChange: Integer);
  {RU: Обновление статусов пациентов из aPatList в момент aCheckTime}
  {EN: Update of the statuses of the individuals from aPatList at the moment aCheckTime}
var i, aStatus: Integer;
begin
  aChange:= 0;
  for i:= 0 to aPatCount - 1 do begin
    aStatus:= PatStatus(aPatList[i], aCheckTime);
    if aPatList[i].Status <> aStatus then begin
      Inc(aChange);
      aPatList[i].Status:= aStatus;
    end;
  end;
end;

procedure ExpandEpiPatList(aCurrTime: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; var aCurrPatList: TPatList; var aCurrPatCount: Integer);
  {RU: Расширяет aPatList за счет имеющихся инфицированных пациентов в момент aCurrTime}
  {En: Extends the aPatList based on the avaiable infecgted individuals at moment aCurrTime}
var i, j, aInitPatCount, aLen, aContacts: Integer;
    aSourcePat, aInfPat: TPat;
begin
  aInitPatCount:= aCurrPatCount;  // RU: Начальное количество инфицированных пациентов EN: The initial amount of infected
  aLen:= aInitPatCount*MaxPatCont;
  if Length(aCurrPatList) < aLen then
    SetLength(aCurrPatList, aLen);
  for i:= 0 to aInitPatCount - 1 do begin
    aSourcePat:= aCurrPatList[i];  // RU: Пациент из списка EN: Individual from the list
    if aSourcePat.Status <> 1 then Continue;
    aContacts:= PatContacts(aSourcePat, aCurrTime);
    for j:= 0 to aContacts - 1 do begin
      aInfPat:= Infected(aSourcePat, aCurrTime, aHiperParam, aInitContProb, aIsolContProb);
      if aInfPat.Status > 0 then begin
        aCurrPatList[aCurrPatCount]:= aInfPat;
        Inc(aCurrPatCount);
      end;
    end;
  end;
  SetLength(aCurrPatList, aCurrPatCount);
end;

function EpiDetChildList(aAddDay, aEpiIndex: Integer; aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPatList;
  {RU: Возвращает список пациентов, порожденных новым пациентом, детектированным в момент aAddDay в эпицентре aEpiInd.}
  {EN: Returns the list of individuals infected by the individual who was identified as auch at time AddDay in the loca epicenter aEpiInd.}
var k, aCurrPatCount, aDetInfTime, aChange: Integer;
    aNewDetPat: TPat;
begin
  SetLength(Result, 1);
  aCurrPatCount:= 0;
  aNewDetPat:= NewDetPat(aAddDay, aEpiIndex, aHiperParam, aInitContProb, aIsolContProb);
  Result[0]:= aNewDetPat;   // RU: Первый элемент списка EN: The first element of the list
  aCurrPatCount:= 1;
  aDetInfTime:= aNewDetPat.InfectTime;  // RU: Момент инфицирования aNewDetPat EN: The moment of infection aNewDetPat
  for k:= aDetInfTime + 1 to 0 do begin
    UpdatePatListStatus(k, aCurrPatCount, Result, aChange);
    ExpandEpiPatList(k, aHiperParam, aInitContProb, aIsolContProb, Result, aCurrPatCount);
  end;
  SetLength(Result, aCurrPatCount);
end;

function EpiDetArrChildList(aDetPatCount, aAddDay, aEpiIndex: Integer; aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPatList;
  {RU: Возвращает список пациентов, порожденных несколькими новыми пациентами aDetPatCount, детектированным в момент aAddDay в эпицентре aEpiInd.}
  {EN: Retunrs the list of individuals infected by the newly infected aDetPatCount, which were identified as such at the moment aAddDay in epicenter aEpiInd.}
var i, j, aCurrPatCount, aInitLen, aChildListLen, aLen, aChange: Integer;
    aDetChildList: TPatList;
begin
  aInitLen:= 100*aDetPatCount;
  SetLength(Result, aInitLen);
  ClearPatList(Result, aCurrPatCount);
  for i:= 0 to aDetPatCount - 1 do begin  // RU: Расширение списка EN: The list expansion
    aDetChildList:= EpiDetChildList(aAddDay, aEpiIndex, aHiperParam, aInitContProb, aIsolContProb);
    aLen:= Length(Result);
    aChildListLen:= Length(aDetChildList);
    if aLen < (aCurrPatCount + aChildListLen) then
      SetLength(Result, aLen + aChildListLen);
    for j:= 0 to aChildListLen - 1 do
      Result[aCurrPatCount + j]:= aDetChildList[j];
    Inc(aCurrPatCount, aChildListLen);
  end;
  SetLength(Result, aCurrPatCount);
  UpdatePatListStatus(aAddDay, aCurrPatCount, Result, aChange);
end;

function CasesInPatList(const aPatList: TPatList): Integer;
  {RU: Возвращает количество пациентов в aPatList со статусом больше 1.}
  {EN: Returns the number of individuals in в aPatList with the status above 1.}
var i: Integer;
begin
  Result:= 0;
  for i:= 0 to Length(aPatList) - 1 do
    if aPatList[i].Status > 1 then
      Inc(Result);
end;

function FitEpiDetArrChildList(aDetPatCount, aAddDay, aEpiIndex: Integer; aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TPatList;
  {RU: Возвращает список пациентов, порожденных несколькими новыми пациентами aDetPatCount, детектированным в момент aAddDay в эпицентре aEpiInd.
   Количество пациентов со статусом больше 1 в результирующем списке подгоняется так, чтобы оно мало отличалось от aDetPatCount.}
  {EN: Retursn the list of individuals infected by the newly infected aDetPatCount, and detected as such at the moment aAddDay in the eicenter aEpiInd.
   The number of individuals with the status bigger than 1 in the resulting list is adjusted to be aligned with aDetPatCount.}
var aCaseCount, aDiffCases, aThresh, aIter, aMaxIter, aCurrPatCount: Integer;
begin
  aCurrPatCount:= aDetPatCount;
  aThresh:= Max(1, Round(0.03*aDetPatCount));
  aMaxIter:= 30;
  aIter:= 0;
  repeat
    Inc(aIter);
    Result:= EpiDetArrChildList(aCurrPatCount, aAddDay, aEpiIndex, aHiperParam, aInitContProb, aIsolContProb);
    aCaseCount:= CasesInPatList(Result);
    aDiffCases:= aCaseCount - aDetPatCount;
    aCurrPatCount:= Max(aCurrPatCount - Round(0.5*aDiffCases), 0);
  until (Abs(aDiffCases) <= aThresh)or(aIter >= aMaxIter);
end;

procedure AddToPatList(const aAddPatList: TPatList; var aCurrPatList: TPatList; var aCurrPatCount: Integer);
   {RU: Добавление к списку aCurrPatList списка aAddPatList. Предполагается, что размер aCurrPatList инициализирован.}
   {EN: Addign to the list aCurrPatList of the list aAddPatList. It is assumed that the size of aCurrPatList is initialized.}
var i, aLen: Integer;
begin
  if aAddPatList = nil then Exit;
  aLen:= Length(aAddPatList);
  for i:= 0 to aLen - 1 do
    aCurrPatList[aCurrPatCount + i]:= aAddPatList[i];
  Inc(aCurrPatCount, aLen);
end;

function EpiPeriodChildList(const aDetectECCounts: TIntArrayArr; aCurrDetDay, aEpiIndex: Integer; aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
         var aStatusArr: TStatusArr): TPatList;
  {RU: Возвращает список пациентов, порожденных всеми детектированнымии пациентами за промежуток времени [-aCurrDetDay; 0] в эпицентре aEpiInd.
   aDetectECCounts - внешний список выявленных случает на очередной день, начиная с (-aCurrDetDay) в эпицентрах. aDiffCases - массив отличий симулированных и реальных cases.}
  {EN: Returns the list of individuals, introduced by all identified infectd individuals during the time interval [-aCurrDetDay; 0] in the epicenter aEpiInd.
   aDetectECCounts - externals list of detected cases for the next days starting from (-aCurrDetDay) in epicenters. aDiffCases - the array of differences of reported and simulated cases.}
var i, k, aInitLen, aLen, aCurrPatCount, aAddDay, aCaseCount, aAddDet, aChange: Integer;
    aDetectEpiCounts: TIntArray;
    aChildList: TPatList;
begin
  Result:= nil;
  if aHiperParam = nil then Exit;
  aLen:= aCurrDetDay + 1;
  SetLength(aDetectEpiCounts, aLen);
  for i:= 0 to aLen - 1 do
    aDetectEpiCounts[i]:= aDetectECCounts[i, aEpiIndex];
  aInitLen:= 20*aDetectEpiCounts[aLen - 1];
  SetLength(Result, aInitLen);
  ClearPatList(Result, aCurrPatCount);
  aAddDay:= -aCurrDetDay;
  aChildList:= FitEpiDetArrChildList(aDetectEpiCounts[0], aAddDay, aEpiIndex, aHiperParam, aInitContProb, aIsolContProb);  // RU: Список в начальный день EN: The list in the first day
  AddToPatList(aChildList, Result, aCurrPatCount);
  UpdateStatusArrEpi(Result, aCurrPatCount, aAddDay, aStatusArr);
  for k:= 1 to aCurrDetDay do begin   // RU: Добавление пациентов за день EN: Adding individuals durign the day
    aAddDay:= k - aCurrDetDay;  // RU: Текущий день для добавления EN: Current day for adding new cases
    UpdatePatListStatus(aAddDay, aCurrPatCount, Result, aChange);
    aCaseCount:= CasesInPatList(Result);
    aAddDet:= Max(0, aDetectEpiCounts[k] - aCaseCount);
    aChildList:= FitEpiDetArrChildList(aAddDet, aAddDay, aEpiIndex, aHiperParam, aInitContProb, aIsolContProb);  // RU: Добавочный список в  день aAddDay EN: The extended list for the day aAddDay
    AddToPatList(aChildList, Result, aCurrPatCount);
    UpdateStatusArrEpi(Result, aCurrPatCount, aAddDay, aStatusArr);
  end;
  SetLength(Result, aCurrPatCount);
end;

procedure SetInitPatList(const aDetectECCounts: TIntArrayArr; aCurrDetDay: Integer; const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double;
          var aPatList: TPatList; var aPatCount: Integer; var aStatusArr: TStatusArr);
  {RU: Формирование списа пациентов, порожденных всеми детектированнымии пациентами за промежуток времени [-aCurrDetDay; 0] во всех эпицентрах.
   aDetectECCounts - список выявленных случает на очередной день, начиная с (-aCurrDetDay) в эпицентрах. aDiffCases - массив отличий симулированных и реальных cases.
   Предполагается, что aPatList инициирован.}
  {EN: The creation of the infected list generated by the detected individuals during [-aCurrDetDay; 0] in all epicenters.
   aDetectECCounts - the list of detected infections for the next day starting from (-aCurrDetDay) in local epicenters. aDiffCases - the arrya of differences between siulated and reported cases.
   It is assumed that the list aPatList is initialized.}

var i, aLen: Integer;      // aAddDay,  aChange
    aPeriodChildList: TPatList;
    aDiffSumEC: TIntArray;
begin
  ClearPatList(aPatList, aPatCount);
  if EmptyHiperParam(aHiperParam) then Exit;
  aLen:= aCurrDetDay + 1;
  SetLength(aDiffSumEC, aLen);
  for i:= 0 to LenEC - 1 do begin
    aPeriodChildList:= EpiPeriodChildList(aDetectECCounts, aCurrDetDay, i, aHiperParam, aInitContProb, aIsolContProb, aStatusArr);
    AddToPatList(aPeriodChildList, aPatList, aPatCount);
  end;
  for i:= 0 to aLen - 1 do
    aDiffSumEC[i]:= aStatusArr[i, 6] - SumDetectECCounts[i];
end;

function PatContacts(const aPat: TPat; aCurrTime: Integer): Integer;
  {RU: Возвращает количество эффективных контактов инфицированного пациента в момент aCurrTime.}
  {EN: Returns the number of the transmission contacts of the infected individual at the moment aCurrTime.}
var aContVal, aStdDev: Double;
begin
  aStdDev:= Min(aPat.Contacts[1], 0.5*aPat.Contacts[0]);
  aContVal:= RandG(aPat.Contacts[0], aStdDev);  // RU: Количество контактов пациента aSourcePat EN: The number of contacts for aSourcePat
  if aCurrTime < (aPat.InfectTime + aPat.Stage1) then   // RU: Первая стадия заражения EN: The first state of infection
    aContVal:= 0.15*aContVal;
  if aCurrTime >= (aPat.InfectTime + aPat.Stage2) then   // RU: Третья стадия заражения EN: The third state of infection 
    aContVal:= 1.3*aContVal;
  Result:= Min(MaxPatCont, Max(0, Round(aContVal)));
end;

function LoadDailyForecast(aFileName: String; var aDailyForecast: TForecastArr): Boolean;
  {RU: Формирование массива aDailyForecast по данным csv-файла aFileName. Если файл найден, то Result = True.}
  {EN: Creation of the array aDailyForecast based on data from csv-file aFileName. If the file is not found then Result = True.}
var i, j, k, aLen, aInd, aPos: Integer;
    aDayInd: Smallint;
    aForecastList: TStringList;
    aHeadStr, aDelim, aDataStr, aCurrStr: String;
begin
  Result:= False;
  aDailyForecast:= nil;
  if not FileExists(aFileName) then Exit;
  aForecastList:= TStringList.Create;
  aForecastList.LoadFromFile(aFileName);
  aLen:= (aForecastList.Count - 1) div 3;
  if aLen < 1 then Exit;
  aHeadStr:= aForecastList[0];
  aDelim:= GetDelim(aHeadStr);
  if aDelim = '' then Exit;
  if Pos('Quantile', aHeadStr) < 1 then begin
    MessageDlg('This is not the Daily Forecast file', mtInformation, [mbOk], 0);
    Exit;
  end;
  SetLength(aDailyForecast, aLen);   // RU: Количество дней наблюдения EN: The number of days under ubservation
  for i:= 0 to aLen - 1 do
    for j:= 0 to 2 do
      for k:= 0 to 4 do
        SetLength(aDailyForecast[i].Quantiles[k], 3);
  for i:= 0 to aLen - 1 do begin   // RU: Индекс округа EN: Index of the region.
    aInd:= 3*i;   // RU: Начальный индекс в aForecastList для формирования aDailyForecast[i] EN: The initial index in aForecastList to form aDailyForecast[i]
    for j:= 0 to 2 do begin   // RU: Заполнение квантили j EN: Filling qunatile j
      aCurrStr:= aForecastList[aInd + j + 1];
      aPos:= Pos(aDelim, aCurrStr);
      if j = 0 then begin
        aDataStr:= Copy(aCurrStr, 1, aPos - 1);
        aDayInd:= YearDays.IndexOf(aDataStr) - DetectDayInd;
        aDailyForecast[i].Period:= Point2D(aDayInd, aDayInd);
      end;
      Delete(aCurrStr, 1, aPos);
      aPos:= Pos(aDelim, aCurrStr);
      Delete(aCurrStr, 1, aPos);
      for k:= 0 to 4 do begin   // RU: Заполнение параметра k  EN: Filling parameter k
        aPos:= Pos(aDelim, aCurrStr);
        if aPos > 0 then
          aDataStr:= Copy(aCurrStr, 1, aPos - 1)
        else
          aDataStr:= aCurrStr;
        aDailyForecast[i].Quantiles[k, j]:= StrToIntDef(aDataStr, 0);
        if j = 1 then
          aDailyForecast[i].PointEstim[k]:= aDailyForecast[i].Quantiles[k, j];
        Delete(aCurrStr, 1, aPos);
      end;
    end;
  end;
  Result:= True;
end;

procedure DrawForecast(const aDailyForecast: TForecastArr;  aParamInd: Integer; const aForeSeries, aLowSeries, aHighSeries, aRealSeries: TLineSeries);
  {RU: Рисование графиков прогноза для параметра aParamInd: 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases}
  {EN: Drawing of the prediction graphs for parameter aParamInd: 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases}
var i, aLen, aInitDay, aInitRealDay: Integer;
    aDayText: String;
    aRealData: TIntArray;
begin
  ClearChart(TChart(aForeSeries.ParentChart));
  if aDailyForecast = nil then Exit;
  aRealData:= nil;
  case aParamInd of
  0: aRealData:= nil;
  1: aRealData:= HospitalArr;
  2: aRealData:= FatalArr_1;
  4: aRealData:= SumDetectECCounts;
  end;
  aInitDay:= aDailyForecast[0].Period[0];
  aLen:= Length(aDailyForecast);
  for i:= 0 to aLen - 1 do begin
    aDayText:= YearDayCalend(aInitDay + i);
    aForeSeries.AddXY(i, aDailyForecast[i].PointEstim[aParamInd], aDayText);
    aLowSeries.AddXY(i, aDailyForecast[i].Quantiles[aParamInd, 0]);
    aHighSeries.AddXY(i, aDailyForecast[i].Quantiles[aParamInd, 2]);
  end;
  if aRealData = nil then Exit;
  aInitRealDay:= CurrDetDay + aInitDay;
  aLen:= Length(aRealData) - aInitRealDay;
  for i:= 0 to aLen - 1 do
    if aRealData[i + aInitRealDay] > 0 then
      aRealSeries.AddXY(i, aRealData[i + aInitRealDay]);
end;

procedure DrawConfStrip(const aDailyForecast: TForecastArr; aParamInd: Integer; aColor: TColor; const aChart: TChart);
  {RU: Формирует массив точек, последовательно лежащих на нижней и верхней границах доверительной полосы aConfBounds.
   Предполагается, что массивы aConnfBounds[0] и aConfBounds[1] имеют одинаковую длину. По найденным точкам рисуется полигон.}
  {EN: Generate the array of points, that lie on the lowe and upper boundary of the confidence band aConfBounds.
   It is assumed that arrays aConnfBounds[0] and aConfBounds[1] have the same lenght. The polygon is drawn based on those points.}
var i, aLen, aMinVal: Integer;
    aConfBorder: array of TPoint;
begin
  if aDailyForecast = nil then Exit;
  aChart.Canvas.Brush.Color:= aColor;
  aLen:= Length(aDailyForecast);
  SetLength(aConfBorder, 2*aLen);
  aMinVal:= aChart.LeftAxis.CalcPosValue(0);
  for i:= 0 to aLen - 1 do begin
    aConfBorder[i].X:= aChart.BottomAxis.CalcPosValue(i);   {RU: Нижняя граница}  {EN: Lower boundary}
    aConfBorder[i].Y:= Min(aMinVal, aChart.LeftAxis.CalcPosValue(aDailyForecast[i].Quantiles[aParamInd, 0]));
    aConfBorder[2*aLen - i - 1].X:= aChart.BottomAxis.CalcPosValue(i);  {RU: Верхняя граница}
    aConfBorder[2*aLen - i - 1].Y:= Min(aMinVal, aChart.LeftAxis.CalcPosValue(aDailyForecast[i].Quantiles[aParamInd, 2]));
  end;
  aConfBorder[aLen - 1].X:= aConfBorder[aLen - 1].X - 1;
  aConfBorder[aLen].X:= aConfBorder[aLen].X - 1;
  aChart.Canvas.Polygon(aConfBorder);
end;

function ParamInd(aRadioItemInd: Integer): Integer;
  {RU: Возвращает индекс параметра в DailyForecast по ItemInd в SimTypeRadioGroup}
  {EN: Returns the index of the parameter in DailyForecast by ItemInd in SimTypeRadioGroup}
begin
  Result:= 0;
  case aRadioItemInd of  // 0 - Hidden, 1 - Hospital, 2 - Fatality, 3 - Mild, 4 - Cases
  0: Result:= 4;  // Cases
  1: Result:= 0;  // Hidden
  2: Result:= 1;  // Hospital
  3: Result:= 2;  // Fatality
  end;
end;

function DayYearInd(aDateStr, aDelimDate: String): Integer;
  {RU: Возвращает индекс дня в году по строке даты aDateStr}
  {EN: Returns the index of the day in a year based on a string date aDateStr}
var aPos, aDay, aMonthNum: Integer;
    aStr, aMonth, aDate: String;
begin
  aPos:= Pos(aDelimDate, aDateStr);
  aStr:= Copy(aDateStr, 1, aPos - 1);
  aDay:= StrToInt(aStr);
  Delete(aDateStr, 1, aPos);
  aPos:= Pos(aDelimDate, aDateStr);
  aStr:= Copy(aDateStr, 1, aPos - 1);
  aMonthNum:= StrToInt(aStr);
  aMonth:= MonthName[aMonthNum - 1];
  aDate:= aMonth + '-' + IntToStr(aDay);
  Result:= YearDays.IndexOf(aDate);
end;

function LoadFullData(aFileName: String; var aFullDataArr: TIntArrayArr): Boolean;
  {RU: Формирование массива aFullDataArr по данным csv-файла aFileName. Если файл найден, то Result = True.
   Result[i,0] - идекс дня в году, Result[i,1] - общее число случаев (Cases), Result[i,2] - Hospital, Result[i,3] - Dead}
  {EN: Forming the array aFullDataArr based on csv-file aFileName. If the file does not exist then Result = True.
   Result[i,0] - index of a day in a year, Result[i,1] - the total number of (Cases), Result[i,2] - Hospital, Result[i,3] - Dead}
var i, j, aLen, aPos: Integer;
    aFullDataList: TStringList;
    aHeadStr, aDelim, aDelimDate, aDateStr, aCurrStr, aNumStr: String;
begin
  Result:= False;
  aFullDataArr:= nil;
  if not FileExists(aFileName) then Exit;
  aFullDataList:= TStringList.Create;
  aFullDataList.LoadFromFile(aFileName);
  aLen:= aFullDataList.Count - 1;
  if aLen < 1 then Exit;
  aHeadStr:= aFullDataList[0];
  aDelim:= GetDelim(aHeadStr);
  if aDelim = '' then Exit;
  if Pos('Total', aHeadStr) < 1 then begin
    MessageDlg('This is not the Full Data file', mtInformation, [mbOk], 0);
    Exit;
  end;
  aDelimDate:= GetDelimDate(aFullDataList[1]);
  SetLength(aFullDataArr, aLen, 4);
  for i:= 0 to aLen - 1 do begin   // RU: Дни наблюдения EN: Observation days
    aCurrStr:= aFullDataList[i + 1];
    aPos:= Pos(aDelim, aCurrStr);
    aDateStr:= Copy(aCurrStr, 1, aPos - 1);
    aFullDataArr[i, 0]:= DayYearInd(aDateStr, aDelimDate);
    Delete(aCurrStr, 1, aPos);
    aPos:= Pos(aDelim, aCurrStr);  // RU: Пропуск поля County EN: Skip of the field County
    Delete(aCurrStr, 1, aPos);
    for j:= 1 to 3 do begin
      aPos:= Pos(aDelim, aCurrStr);
      if aPos > 0 then
        aNumStr:= Copy(aCurrStr, 1, aPos - 1)
      else
        aNumStr:= aCurrStr;
      aFullDataArr[i, j]:= StrToIntDef(aNumStr, 0);
      Delete(aCurrStr, 1, aPos);
    end;
  end;
  Result:= True;
end;

function SummFullData(aFileName: String): TIntArrayArr;
  {RU: Возвращает массив суммарных (по датам) записей вида:
   Result[i,0] - идекс дня в году, Result[i,1] - общее число случаев (Cases), Result[i,2] - Hospital, Result[i,3] - Dead}
  {EN: Returns the array of the all records (by dates):
   Result[i,0] - index of a day in a year, Result[i,1] - the total number of (Cases), Result[i,2] - Hospital, Result[i,3] - Dead}
var i, j, aLen, aInitDay, aTermDay, aResLen, aInd: Integer;
    aFullDataArr: TIntArrayArr;
begin
  Result:= nil;
  if not LoadFullData(aFileName, aFullDataArr) then Exit;
  aLen:= Length(aFullDataArr);
  aInitDay:= aFullDataArr[0, 0];
  aTermDay:= aFullDataArr[aLen - 1, 0];
  aResLen:= aTermDay - aInitDay + 1;
  SetLength(Result, aResLen, 4);
  for i:= 0 to aResLen - 1 do begin
    Result[i, 0]:= i + aInitDay;
    for j:= 1 to 3 do
      Result[i, j]:= 0;
  end;
  for i:= 0 to aLen - 1 do begin
    aInd:= aFullDataArr[i, 0] - aInitDay;
    for j:= 1 to 3 do
      Inc(Result[aInd, j], aFullDataArr[i, j]);
  end;
end;

procedure SetHospitDeadCount(aFileName: String;  var aHospitalArr, aFatalArr: TIntArray);
  {RU: Формирование массивов aHospitalArr, aFatalArr по дням на промежутке [DetectDayInd - CurrDetDay; ...].}       //DetectDayInd
  {EN: Forming of the array aHospitalArr, aFatalArr daily on the interval  [DetectDayInd - CurrDetDay; ...].}       //DetectDayInd
var i, aInitInd, aLen, aResLen: Integer;
    aSummFullData: TIntArrayArr;
begin
  aHospitalArr:= nil;
  aFatalArr:= nil;
  aSummFullData:= SummFullData(aFileName);
  if aSummFullData = nil then Exit;
  aInitInd:= DetectDayInd - CurrDetDay - aSummFullData[0, 0];
  aLen:= Length(aSummFullData);
  aResLen:= aLen - aInitInd;
  SetLength(aHospitalArr, aResLen);
  SetLength(aFatalArr, aResLen);
  for i:= 0 to aResLen - 1 do begin
    aHospitalArr[i]:= aSummFullData[i + aInitInd, 2];
    aFatalArr[i]:= aSummFullData[i + aInitInd, 3];
  end;
end;

procedure DrawTimeStrip(aInitTime, aTermStep: Double; aColor: TColor; const aChart: TChart);
  {RU: Рисует прямоугольник на участке изменения времени [aInitTime; aTermStep]. Высота прямоугольника = высоте графика.}
  {EN: Draws the rectange on the segment of time change [aInitTime; aTermStep]. The rectange height  = height of the graph.}
var aMinVal, aMaxVal: Integer;
    aRect: TRect;
begin
  aChart.Canvas.Brush.Color:= aColor;
  aChart.Canvas.Pen.Color:= aChart.Canvas.Brush.Color;
  aMinVal:= aChart.LeftAxis.CalcPosValue(0);
  aMaxVal:= aChart.LeftAxis.CalcPosValue(aChart.LeftAxis.Maximum*0.99);
  aRect.Left:= aChart.BottomAxis.CalcPosValue(aInitTime);
  aRect.Top:= aMaxVal;
  aRect.Right:= aChart.BottomAxis.CalcPosValue(aTermStep);
  aRect.Bottom:= aMinVal;
  aChart.Canvas.Rectangle(aRect);
end;

procedure DrawTimeLines(aInitTime, aTermStep: Integer; aColor: TColor; const aChart: TChart);
  {RU: Рисует вертикальные прямые на границах участке изменения времени [aInitTime; aInitTime + aTimeStep]. Высота прямых = высоте графика.}
  {EN: Draws vertical lines on the boundaries for the time measuremnt interval [aInitTime; aInitTime + aTimeStep]. The height of the lines = height of the graph.}
var aMinVal, aMaxVal, aLeft, aRight, aWidth, aTextX, aTextY: Integer;
    aText: String;
begin
  aChart.Canvas.Pen.Color:= aColor;
  aMinVal:= aChart.LeftAxis.CalcPosValue(0);
  aMaxVal:= aChart.LeftAxis.CalcPosValue(aChart.LeftAxis.Maximum*0.99);
  aLeft:= aChart.BottomAxis.CalcPosValue(aInitTime);   // RU: Левая прямая EN: Right lines
  aChart.Canvas.MoveTo(aLeft, aMinVal);
  aChart.Canvas.LineTo(aLeft, aMaxVal);
  aRight:= aChart.BottomAxis.CalcPosValue(aTermStep);  // RU: Правая прямая En: Right line
  aChart.Canvas.MoveTo(aRight, aMinVal);
  aChart.Canvas.LineTo(aRight, aMaxVal);
  aText:= 'Calibration';
  aWidth:= aChart.Canvas.TextWidth(aText);
  aTextX:= (aLeft + aRight - aWidth) div 2;
  aTextY:= aMaxVal + 3;
  aChart.Canvas.TextOut(aTextX, aTextY, aText);
end;

function R0forPatList(const aPatList: TPatList; aInfPeriod: TIntegerPoint2D; aPatCount, aNumIter: Integer): Double;
  {RU: Возвращает среднее значение параметра R0 для множества из пациентов из aPatList}
  {EN: Returns the averaged value of the parameter R0 for the set of infected individuals from aPatList}
var i: Integer;
begin
  Result:= 0;
  if aPatList = nil then Exit;
  for i:= 0 to aPatCount - 1 do
    Result:= Result + R0forPat(aPatList[i], aNumIter);
  Result:= Result/aPatCount;
end;

procedure R0ArrforPatList(const aPatList: TPatList; aPatCount, aIsolTime, aNumIter: Integer; var aPreR0Arr, aPostR0Arr: TDoubleArray);
  {RU: Возвращает массивы значений параметра R0 для пациентов с моментом инфицирования до aIsolTime (aPreR0Arr) и после aIsolTime (aPostR0Arr)}
  {EN: Retunrs the array of values for the parameter R0 for infected individuals from the time of the infection untill the time aIsolTime (aPreR0Arr) and after aIsolTime (aPostR0Arr)}
var i, aPreCounter, aPostCounter, aMaxCounter: Integer;
    aVal: Double;
    aPat: TPat;
begin
  aPreR0Arr:= nil;
  aPostR0Arr:= nil;
  if aPatList = nil then Exit;
  SetLength(aPreR0Arr, aPatCount);
  SetLength(aPostR0Arr, aPatCount);
  aPreCounter:= 0;
  aPostCounter:= 0;
  aMaxCounter:= 30000;
  for i:= 0 to aPatCount - 1 do begin
    aPat:= aPatList[i];
    aVal:= R0forPat(aPat, aNumIter);
    if aPat.InfectTime <= aIsolTime then begin
      if aPreCounter < aMaxCounter then begin
        aPreR0Arr[aPreCounter]:= aVal;
        Inc(aPreCounter);
      end
    end
    else begin
      if aPostCounter < aMaxCounter then begin
        aPostR0Arr[aPostCounter]:= aVal;
        Inc(aPostCounter);
      end;
    end;
    if (aPreCounter >= aMaxCounter)and(aPostCounter >= aMaxCounter) then Break;
  end;
  SetLength(aPreR0Arr, aPreCounter);
  SetLength(aPostR0Arr, aPostCounter);
end;

function MeanRealHist(const aRealHist: TRealHist): Double;
  {RU: Возвращает выборочное среднее для aRealHist}
  {EN: Returns the sample average for aRealHist}
var i, aSum: Integer;
    aHistStep, aInitVal, aCoeff: Double;
begin
  Result:= 0;
  if aRealHist.HistVal = nil then Exit;
  aSum:= aRealHist.Sum;
  aCoeff:= 1/aSum;
  aHistStep:= aRealHist.HistStep;
  aInitVal:= aRealHist.MinMaxVal[0] + 0.5*aHistStep;
  for i:= 0 to aRealHist.IntervCount - 1 do
    Result:= Result + (aInitVal + i*aHistStep)*aRealHist.HistVal[i];
  Result:= Result*aCoeff;
end;

function StdDevRealHist(const aRealHist: TRealHist; aMean: Double): Double;
  {RU: Возвращает выборочное среднее для aRealHist}
  {EN: Returs the sample everage for aRealHist}
var i, aSum: Integer;
    aHistStep, aInitVal, aCoeff: Double;
begin
  Result:= 0;
  aSum:= aRealHist.Sum;
  if aSum < 2 then Exit;
  aCoeff:= 1/(aSum - 1);
  aHistStep:= aRealHist.HistStep;
  aInitVal:= aRealHist.MinMaxVal[0] + 0.5*aHistStep;
  for i:= 0 to aRealHist.IntervCount - 1 do
    Result:= Result + Sqr(aInitVal + i*aHistStep - aMean)* aRealHist.HistVal[i];
  Result:= Sqrt(Result*aCoeff);
end;

function MeanRealHist(const aR0Arr: TDoubleArray): Double;
  {RU: Возвращает выборочное среднее для aRealHist}
  {EN: Returns the sample everage for aRealHist}
var i: Integer;
begin
  Result:= 0;
  if aR0Arr = nil then Exit;
  for i:= 0 to Length(aR0Arr) - 1 do
    Result:= Result + aR0Arr[i];
  Result:= Result/Length(aR0Arr);
end;

function StdDevRealHist(const aR0Arr: TDoubleArray; aMean: Double): Double;
  {RU: Возвращает выборочное среднее для aRealHist}
  {EN: Returns the sample everage for aRealHist}
var i, aLen: Integer;
begin
  Result:= 0;
  aLen:= Length(aR0Arr);
  if aLen < 2 then Exit;
  for i:= 0 to aLen - 1 do
    Result:= Result + Sqr(aR0Arr[i] - aMean);
  Result:= Sqrt(Result/(aLen - 1));
end;

function MedianRealHist(const aRealHist: TRealHist): Double;
  {RU: Возвращает медиану для aRealHist}
  {EN: Returns the median for aRealHist}
var i, aInd: Integer;
    aHistStep, aLambda, aLevel, aSum, aPrevSum: Double;
begin
  Result:= 0;
  if aRealHist.HistVal = nil then Exit;
  aHistStep:= aRealHist.HistStep;
  aLevel:= 0.5*aRealHist.Sum;  // RU: Уровень значимости для медианы EN: The level of importance for the median
  aInd:= 0;
  aSum:= 0;
  for i:= 0 to Length(aRealHist.HistVal) - 1 do begin
    aSum:= aSum + aRealHist.HistVal[i];
    if aSum >= aLevel then begin
      aInd:= i;
      Break;
    end;
  end;
  aPrevSum:= aSum - aRealHist.HistVal[aInd];  // RU: Предыдущее значение суммы (функции распредления) EN: The previous value of the sum (distribution fucntion)
  aLambda:= (aLevel - aPrevSum)/(aSum - aPrevSum);
  Result:= aRealHist.MinMaxVal[0] + (aInd + aLambda)*aHistStep;
end;

function R0Histogram(const aR0Arr: TDoubleArray): TRealHist;
  {RU: Возвращает гистограмму распределения R0 по выборке aR0Arr.}
  {EN: Returns the histogram of the distribution of R0 for the sample aR0Arr.}
var i, aInd, aLen, aIntervCount: Integer;     // aSum,
    aMinMax: TDoublePoint2D;
    aHistStep: Double;
begin
  Result:= ZeroRealHist;
  if aR0Arr = nil then Exit;
  aLen:= Length(aR0Arr);  // RU: Количество симуляций EN: The number o simulations
  aIntervCount:= 1 + Ceil(Log2(aLen));  // RU: Формула Стэрджеса EN: Sturges formula
  Result.IntervCount:= aIntervCount;
  aMinMax:= MinMaxForArray(aR0Arr);
  aHistStep:= (aMinMax[1] - aMinMax[0])/aIntervCount;
  Result.HistStep:= aHistStep;
  Result.MinMaxVal:= DoublePoint2D(aMinMax[0], aMinMax[0] + aIntervCount*aHistStep);
  SetLength(Result.HistVal, aIntervCount);
  for i:= 0 to aIntervCount - 1 do
    Result.HistVal[i]:= 0;
  for i:= 0 to aLen - 1 do begin
    aInd:= Floor((aR0Arr[i] - aMinMax[0])/aHistStep);
    aInd:= Min(aInd, aIntervCount - 1);
    Inc(Result.HistVal[aInd]);
  end;
  Result.Sum:= aLen;
  Result.Mean:= MeanRealHist(Result);
  Result.StdDev:= StdDevRealHist(Result, Result.Mean);
  Result.Median:= MedianRealHist(Result);
end;

function R0RedHistogram(const aR0Arr: TDoubleArray): TRealHist;
  {RU: Возвращает усеченную гистограмму распределения R0 по выборке aR0Arr. Из выборки удаляются значения с малой частотой.}
  {EN: Returns the truncated histogram of the distribution of R0 for the sample aR0Arr. The low frequency values are deleted from the sample.}
var i, aInd, aLen, aIntervCount, aRedInd, aCounter: Integer;     // aSum,
    aMinMax: TDoublePoint2D;
    aHistStep, aThresh, aMaxVal, aVal: Double;
    aPrevHist: TRealHist;
begin
  Result:= ZeroRealHist;
  if aR0Arr = nil then Exit;
  aLen:= Length(aR0Arr);  // RU: Количество симуляций EN: The number o simulations
  aIntervCount:= 1 + Ceil(Log2(aLen));  // RU: Формула Стэрджеса EN: Sturges formula
  aMinMax:= MinMaxForArray(aR0Arr);
  aHistStep:= (aMinMax[1] - aMinMax[0])/aIntervCount;
  SetLength(aPrevHist.HistVal, aIntervCount);
  for i:= 0 to aIntervCount - 1 do
    aPrevHist.HistVal[i]:= 0;
  for i:= 0 to aLen - 1 do begin
    aInd:= Floor((aR0Arr[i] - aMinMax[0])/aHistStep);
    aInd:= Min(aInd, aIntervCount - 1);
    Inc(aPrevHist.HistVal[aInd]);
  end;
  aThresh:= 0.005*aLen;   // RU: Нижний порог значений для элементов гистограммы (0.5%) EN: The lower threshold for histogram values (0.5%)
  aIntervCount:= Round(0.75*aIntervCount);
  Result.IntervCount:= aIntervCount;
  aRedInd:= aIntervCount - 1;
  for i:= aIntervCount - 1 downto 0 do    // RU: Индекс отсечения гистограммы EN: Index of the histogram truncation
    if aPrevHist.HistVal[i] >= aThresh then begin
      aRedInd:= i;
      Break;
    end;
  aMinMax[1]:= aMinMax[0] + aRedInd*aHistStep;
  aHistStep:= (aMinMax[1] - aMinMax[0])/aIntervCount;
  Result.MinMaxVal:= aMinMax;
  Result.HistStep:= aHistStep;
  aMaxVal:= aMinMax[1];
  SetLength(Result.HistVal, aIntervCount);
  for i:= 0 to aIntervCount - 1 do
    Result.HistVal[i]:= 0;
  aCounter:= 0;
  for i:= 0 to aLen - 1 do begin
    aVal:= aR0Arr[i];
    if aVal >= aMaxVal then Continue;
    aInd:= Floor((aR0Arr[i] - aMinMax[0])/aHistStep);
    aInd:= Min(aInd, aIntervCount - 1);
    Inc(Result.HistVal[aInd]);
    Inc(aCounter);
  end;
  Result.Sum:= aCounter;
  Result.Mean:= MeanRealHist(Result);
  Result.StdDev:= StdDevRealHist(Result, Result.Mean);
end;

procedure DrawRealHist(const aRealHist: TRealHist; aDrawDistr: Boolean; const aHistSeries, aDistrSeries: TLineSeries);
var i: Integer;
    aInitVal, aHistStep, aCoeff, aSum, aX: Double;
begin
  aHistSeries.Clear;
  aDistrSeries.Clear;
  aDistrSeries.Visible:= aDrawDistr;
  aHistStep:= aRealHist.HistStep;
  aX:= aRealHist.MinMaxVal[0];
  aInitVal:= aRealHist.MinMaxVal[0] + 0.5*aHistStep;
  aCoeff:= 1/aRealHist.Sum;
  aSum:= 0;
  aDistrSeries.AddXY(aX, aSum);
  for i:= 0 to aRealHist.IntervCount - 1 do begin
    aHistSeries.AddXY(aInitVal + i*aHistStep, (aCoeff*aRealHist.HistVal[i])/aHistStep);
    aX:= aX + aHistStep;
    aSum:= aSum + aCoeff*aRealHist.HistVal[i];
    aDistrSeries.AddXY(aX, aSum);     //R0DistrCheckBox
  end;
end;

procedure FillR0StrGrid(const aPreR0Hist, aPostR0Hist: TRealHist; const aStrGrid: TStringGrid);
begin
  aStrGrid.Cells[0, 0]:= 'R0';
  aStrGrid.Cells[0, 1]:= 'Median';
  aStrGrid.Cells[0, 2]:= 'Mean';
  aStrGrid.Cells[0, 3]:= 'StdDev';
  aStrGrid.Cells[0, 4]:= 'Conf 90%';
  aStrGrid.Cells[1, 0]:= ' Pre Q';
  aStrGrid.Cells[2, 0]:= ' Post Q';

  aStrGrid.Cells[1, 1]:= Format('%6.3f', [aPreR0Hist.Median]);
  aStrGrid.Cells[1, 2]:= Format('%6.3f', [aPreR0Hist.Mean]);
  aStrGrid.Cells[1, 3]:= Format('%6.3f', [aPreR0Hist.StdDev]);
  aStrGrid.Cells[1, 4]:= '[' + Format('%4.2f', [aPreR0Hist.Quant_05]) + '; ' + Format('%4.2f', [aPreR0Hist.Quant_95]) + ']';

  aStrGrid.Cells[2, 1]:= Format('%6.3f', [aPostR0Hist.Median]);
  aStrGrid.Cells[2, 2]:= Format('%6.3f', [aPostR0Hist.Mean]);
  aStrGrid.Cells[2, 3]:= Format('%6.3f', [aPostR0Hist.StdDev]);
  aStrGrid.Cells[2, 4]:= '[' + Format('%4.2f', [aPostR0Hist.Quant_05]) + '; ' + Format('%4.2f', [aPostR0Hist.Quant_95]) + ']';
  DeselectStrGrid(aStrGrid);
end;

function LoadDeathMA(aFileName: String; var aDeathMA: TIntegerPoint2DArr): Boolean;
  {RU: Формирование массива aDeathMA по данным csv-файла aFileName. Если файл найден, то Result = True.
   Result[i,0] - идекс дня в году, Result[i,1] - общее число Dead на данный день}
  {EN: Forming of the array aDeathMA based on data from the csv-file aFileName. If the file is not found then Result = True.
   Result[i,0] - index of a day in a year and Result[i,1] - the total numbe of Dead for a given day}
var i, j, aLen, aPos: Integer;
    aDeathMAList: TStringList;
    aDelim, aDelimDate, aDateStr, aCurrStr, aNumStr: String;
begin
  Result:= False;
  aDeathMA:= nil;
  if not FileExists(aFileName) then Exit;
  aDeathMAList:= TStringList.Create;
  aDeathMAList.LoadFromFile(aFileName);
  aLen:= aDeathMAList.Count;
  if aLen < 1 then Exit;
  aDelim:= GetDelim(aDeathMAList[0]);
  if aDelim = '' then Exit;
  aDelimDate:= GetDelimDate(aDeathMAList[0]);
  SetLength(aDeathMA, aLen);
  for i:= 0 to aLen - 1 do begin   // RU: Дни наблюдения EN: Observation days
    aCurrStr:= aDeathMAList[i];
    aPos:= Pos(aDelim, aCurrStr);
    aDateStr:= Copy(aCurrStr, 1, aPos - 1);
    aDeathMA[i, 0]:= DayYearInd(aDateStr, aDelimDate);
    Delete(aCurrStr, 1, aPos);
    aDeathMA[i, 1]:= StrToIntDef(aCurrStr, 0);
  end;
  Result:= True;
end;

procedure SetMonthNameList;
var i: Integer;
begin
  MonthNameList:= TStringList.Create;
  for i:= 0 to 11 do
    MonthNameList.Add(MonthName[i]);
end;

function GetFatalArr(const aDeathMA: TIntegerPoint2DArr): TIntArray;
  {RU: Возвращает массив количества умерших по дням, начинач с 72 дня (13 марта) по массиву aDeathMA (индекс дня, количество)}
  {EN: Returns the array of the number of deceased by day starting from day 72  (i.e. March 13) for the array aDeathMA (day index, the number)}
var i, aLen: Integer;
begin
  Result:= nil;
  if aDeathMA = nil then Exit;
  aLen:= Length(aDeathMA);
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do
    Result[i]:= aDeathMA[i, 1];
end;

  {*******************************************************************************************}

procedure TMainForm.AddContCircleButtonClick(Sender: TObject);
var aLen, aMaxHeight: Integer;
begin
  aLen:= Length(ContCircles);
  SetLength(ContCircles, aLen + 1);
  ContCircles[aLen]:= IntegerPoint3D(ContCenter[0], ContCenter[1], ContRadUpDown.Position);
  DrawContCircles(ContCircles, MapBitMap, clBlue);
  if CurrSimulTime <= 0 then
    DrawDetPatList(DetPatList, DetPatCount, CurrSimulTime, 2, clRed, MapPaintBox);
  MapPaintBox.Invalidate;
  aMaxHeight:= LeftBottomPanel.Height - ContCirclesGrid.Top - 10;
  FillContCirclesGrid(ContCircles, aMaxHeight, ContCirclesGrid);
  ContCirclesGrid.Row:= aLen + 1;
end;

procedure TMainForm.AddPatButtonClick(Sender: TObject);
var aPat: TPat;
    aMaxHeight: Integer;
begin
  aPat:= PatFromParam;
  AddPatientToList(aPat, DetPatList, DetPatCount);
  aMaxHeight:= DetListPanel.Height - DetPatStrGrid.Top - 10;
  FillDetPatStrGrid(PatList, PatCount, aMaxHeight, DetPatStrGrid);
  DetListChanged:= True;
end;

procedure TMainForm.AutoSizelButtonClick(Sender: TObject);
begin
  SetFormSize;
end;

procedure TMainForm.AutoSizeMenuClick(Sender: TObject);
begin
  if AutoSizeMenu.Checked then
    SetFormSize;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  LoadDeathMA(COVID_Death_MAFileName, DeathMA);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  DayIndToDateStr(44 + DetectDayInd, '-', '-', '2020');
end;

procedure TMainForm.CDCReportButtonClick(Sender: TObject);
var aIterCount, aHistIntervCount, aForeWeekCount: Integer;
    aMsgStr: String;
begin
  if not IsLoadDeathMA then begin
    aMsgStr:= 'The file ' + COVID_Death_MAFileName + ' is not found';
    MessageDlg(aMsgStr, mtError, [mbOK], 0);
    Exit;
  end;
  //aIterCount:= 15;
  aIterCount:= WeekIterUpDown.Position;
  //aHistIntervCount:= 8;
  aHistIntervCount:= Max(8, 1 + Ceil(Log2(aIterCount)));  // RU: Формула Стэрджеса EN: Sturges formula
  aForeWeekCount:= WeekCountUpDown.Position;
  Screen.Cursor:= crHourGlass;
  DeathForecast:= DeathForecastArr(ForecastDay, aForeWeekCount, DetectDayInd, aIterCount, aHistIntervCount, LevelList, MainStatusBar);
  SaveDeathForecastArr(DeathForecast, ForecastFileName);
  Screen.Cursor:= crDefault;
end;

procedure TMainForm.ContCirclesGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var aInd, aMaxHeight: Integer;
begin
  if Key = VK_DELETE then begin
    aInd:= ContCirclesGrid.Row - 1;
    DeleteContCircle(aInd, ContCircles);
    InitImgBitMap(MapBitMap);
    DrawContCircles(ContCircles, MapBitMap, clBlue);
    if CurrSimulTime <= 0 then
      DrawDetPatList(DetPatList, DetPatCount, CurrSimulTime, 2, clRed, MapPaintBox);
    MapPaintBox.Invalidate;
    aMaxHeight:= LeftBottomPanel.Height - ContCirclesGrid.Top - 10;
    FillContCirclesGrid(ContCircles, aMaxHeight, ContCirclesGrid);
  end;
end;

procedure TMainForm.ContCirclesGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aSelCircle: TIntegerPoint3D;
    aCenter: TIntegerPoint2D;
    aRad, aRow, aCol: Integer;
begin
  if ContCircles <> nil then begin
    ContCirclesGrid.MouseToCell(X, Y, aRow, aCol);
    aSelCircle:= ContCircles[aRow - 1];
    aCenter:= IntegerPoint2D(aSelCircle[0], aSelCircle[1]);
    aRad:= aSelCircle[2];
    DrawContCircles(ContCircles, MapBitMap, clBlack);
    DrawContCircle(MapBitMap, aCenter, aRad, clRed);
    MapPaintBox.Invalidate;
  end;
end;

procedure TMainForm.ContProbUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  HandleUpDownClick(Button, ContProbEdit, 0.5, 0.01, 0, 1.0, '%4.2f');
end;

procedure TMainForm.ContRadUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  InitImgBitMap(MapBitMap);
  DrawContCircle(MapBitMap, ContCenter, ContRadUpDown.Position, clRed);
  DrawContCircles(ContCircles, MapBitMap, clBlack);
  MapPaintBox.Invalidate;
end;

procedure TMainForm.CopyChart(const aChart: TChart);
var TmpPNG: TPNGExportFormat;
begin
  TmpPNG:= TPNGExportFormat.Create;
  With TmpPNG do begin
    Panel:= aChart;
    CopyToClipboard;
  end;
end;

procedure TMainForm.CopyChartToFile(const aChart: TChart; const aSaveDialog: TSaveDialog);
var aFileName: String;
    TmpPNG: TPNGExportFormat;
begin
  aSaveDialog.Title:= 'Save Chart ' + aChart.Title.Caption;
  aSaveDialog.Filter := 'PNG files (*.png)|*.png|Common files (*.*)|*.*';
  aSaveDialog.DefaultExt:= 'png';
  aSaveDialog.FileName:= 'Chart_' + SimTypeRadioGroup.Items[SimTypeRadioGroup.ItemIndex];
  if aSaveDialog.Execute then begin
    aFileName:= aSaveDialog.FileName;
    TmpPNG:= TPNGExportFormat.Create;
    TmpPNG.Panel:= aChart;
    TmpPNG.SaveToFile(aFileName);
  end;
end;

procedure TMainForm.CopyToClipMenuClick(Sender: TObject);
begin
  CopyChart(ChartForCopy);
end;

procedure TMainForm.CopyToFileMenuClick(Sender: TObject);
begin
  CopyChartToFile(ChartForCopy, SaveDialog);
end;

procedure TMainForm.MaxSimulTimeUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  MaxSimulTimeEdit.Text:= YearDayText(MaxSimulTimeUpDown.Position);
end;

procedure TMainForm.MaxSimulTimeUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MaxSimulTimeUpDown.Position <= (CurrSimulTime + 1) then
    MaxSimulTimeUpDown.Position:= CurrSimulTime + 1;
  MaxSimulTime:= MaxSimulTimeUpDown.Position;
  MaxSimulTimeEdit.Text:= YearDayText(MaxSimulTime);
  LenStatusArr;
end;

procedure TMainForm.DiseaseFormStrGridExit(Sender: TObject);
begin
  ParamUpDown.Visible:= False;
  DeselectStrGrid(DiseaseFormStrGrid);
end;

procedure TMainForm.DiseaseFormStrGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  SelParamCell:= IntegerPoint2D(aCol, aRow);
  PosParamUpDown(SelParamCell, ParamUpDown, 2, DiseaseFormStrGrid);
end;

procedure TMainForm.DailyForeButtonClick(Sender: TObject);
var aIterCount, aHistIntervCount: Integer;
    aLevelList: TDoubleArray;
    aForePeriod: TIntPoint2D;
    aDayText: String;
begin
  aIterCount:= ForeIterUpDown.Position;
  aHistIntervCount:= 1 + Ceil(Log2(aIterCount));  // RU: Формула Стэрджеса EN: Sturges formula
  aLevelList:= GetDailyLevelList;
  aForePeriod[0]:= 0;
  aForePeriod[1]:= MaxSimulTime;
  aDayText:= YearDayText(aForePeriod[0]);
  aDayText:= YearDayText(aForePeriod[1]);
  Screen.Cursor:= crHourGlass;
  DailyForecast:= DailyForecastArr(aForePeriod, DetectDayInd, aIterCount, aHistIntervCount, aLevelList, MainStatusBar);
  SaveDailyForecastArr(DailyForecast, DailyForecastFileName);
  Screen.Cursor:= crDefault;
end;

procedure TMainForm.DetDayUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  DetDayEdit.Text:= DetectDays[DetDayUpDown.Position];
  DetectDayInd:= YearDays.IndexOf(DetDayEdit.Text);
end;

procedure TMainForm.DetDayUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aMaxHeight: Integer;
begin
  CurrDetDay:= DetDayUpDown.Position;
  if CurrDetDay = PrevDetDay then Exit;
  PrevDetDay:= CurrDetDay;
  DetDayEdit.Text:= DetectDays[CurrDetDay];
  aMaxHeight:= LeftBottomPanel.Height - EpiCentrsGrid.Top - 10;
  FillEpiCentrsGrid(Epicenters, DetectECCounts[CurrDetDay], aMaxHeight, EpiCentrsGrid, EpiLabel);
  InitModel(HiperParam, InitContProb, IsolContProb, DetDayUpDown.Position);
  DrawMap;
  DetectDayInd:= YearDays.IndexOf(DetDayEdit.Text);
  InitOptEdit.Text:= YearDayText(InitOptUpDown.Position);
  TermOptUpDown.Min:= InitOptUpDown.Position + 1;
  TermOptUpDown.Max:= DetDaysCount - CurrDetDay;
  TermOptUpDown.Position:= Max(TermOptUpDown.Min, Min(TermOptUpDown.Max, TermOptUpDown.Position));
  TermOptEdit.Text:= YearDayText(TermOptUpDown.Position);
  TermUpEdit.Text:= 'Up to ' + YearDayText(TermOptUpDown.Max);
end;

procedure TMainForm.DetListPanelResize(Sender: TObject);
var aMaxHeight: Integer;
begin
  aMaxHeight:= DetListPanel.Height - DetPatStrGrid.Top - 10;
  FillDetPatStrGrid(PatList, PatCount, aMaxHeight, DetPatStrGrid);
end;

procedure TMainForm.DetPatStrGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  PatToParam(PatList[ARow - 1]);
  DetectPatLabel.Caption:= 'Detected Patient #' + IntToStr(ARow);
end;

procedure TMainForm.DrawInfectMenuClick(Sender: TObject);
begin
  DrawInfected:= DrawInfectMenu.Checked;
  DrawMap;
end;

procedure TMainForm.DrawMap;
begin
  if Console then Exit;
  InitImgBitMap(MapBitMap);
  DrawPatList(PatList, PatCount, MapPaintBox);
  DrawEpicenters(Epicenters, MapBitMap, clBlue);
  MapPaintBox.Invalidate;
end;

procedure TMainForm.DurationStrGridExit(Sender: TObject);
begin
  DurParamUpDown.Visible:= False;
  DeselectStrGrid(DurationStrGrid);
end;

procedure TMainForm.DurationStrGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  SelDurParamCell:= IntegerPoint2D(aCol, aRow);
  PosParamUpDown(SelDurParamCell, DurParamUpDown, 3, DurationStrGrid);
end;

procedure TMainForm.DurParamUpDownClick(Sender: TObject; Button: TUDBtnType);
var aText: String;
    aStep: Double;
begin
  aText:= DurationStrGrid.Cells[SelDurParamCell[0], SelDurParamCell[1]];
  if LargeStep then
    aStep:= 1.0
  else
    aStep:= 0.1;
  HandleUpDownClick(Button, aText, 10, aStep, 0, 100, '%4.1f');
  DurationStrGrid.Cells[SelDurParamCell[0], SelDurParamCell[1]]:= aText;
end;

procedure TMainForm.DurParamUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DiseaseDurationFromTable(DiseaseDuration, DurationStrGrid);
end;

procedure TMainForm.OptimParamslButtonClick(Sender: TObject);
var aIter: Integer;
begin
  SimulIter:= 5;
  StopEvaluation:= False;
  SetStatusText(MainStatusBar, 0, '');
  SetStatusText(MainStatusBar, 2, 'Press ESC to terminate');         //const aTreatSimulSeries, aTreatReallSeries: TLineSeries;
  SetOptimalParamsArr(HiperParam, InitContProb, IsolContProb, OptimPeriod, SimulIter, MainStatusBar, OptHiperParamArr, TreatSimulSeries, TreatReallSeries,
                      OptInitContProbArr, OptIsolContProbArr);
  SetAvrgOptimalParams(OptHiperParamArr, OptInitContProbArr, OptIsolContProbArr, AvrgOptHiperParam, AvrgOptInitContProb, AvrgOptIsolContProb);
  aIter:= 20;
  DrawCases(aIter, AvrgOptHiperParam, AvrgOptInitContProb, AvrgOptIsolContProb, TreatSimulSeries, TreatReallSeries);
  SetStatusText(MainStatusBar, 2, '');
end;

procedure TMainForm.EpiCentrsGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssDouble in Shift then begin
    ShowEpicenters:= not ShowEpicenters;
    ShowEpicentrsEval(X, Y);
    DrawMap;
    ShowEpicentersMenu.Checked:= ShowEpicenters;
  end;
end;

procedure TMainForm.EpiCentrsGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowEpicentrsEval(X, Y);
end;

procedure TMainForm.EvaluateR0;
var aPreR0Arr, aPostR0Arr: TDoubleArray;
    aR0PreDistr, aR0PostDistr: TDoublePoint2DArr;
begin
  if PatCount = 0 then Exit;
  R0ArrforPatList(PatList, PatCount, IsolTime, 20, aPreR0Arr, aPostR0Arr);
  if RedR0HistMenu.Checked then begin
    PreR0Hist:= R0RedHistogram(aPreR0Arr);
    PostR0Hist:= R0RedHistogram(aPostR0Arr);
  end
  else begin
    PreR0Hist:= R0Histogram(aPreR0Arr);
    PostR0Hist:= R0Histogram(aPostR0Arr);
  end;
  aR0PreDistr:= R0Distr(PreR0Hist);
  aR0PostDistr:= R0Distr(PostR0Hist);
  PreR0Hist.Quant_05:= R0Quantile(aR0PreDistr, 0.05);
  PreR0Hist.Quant_95:= R0Quantile(aR0PreDistr, 0.95);
  PreR0Hist.Median:= R0Quantile(aR0PreDistr, 0.5);
  PostR0Hist.Quant_05:= R0Quantile(aR0PostDistr, 0.05);
  PostR0Hist.Quant_95:= R0Quantile(aR0PostDistr, 0.95);
  PostR0Hist.Median:= R0Quantile(aR0PostDistr, 0.5);
  DrawRealHist(PreR0Hist, R0DistrCheckBox.Checked, PreR0Series, DistrPreR0Series);
  DrawRealHist(PostR0Hist, R0DistrCheckBox.Checked, PostR0Series, DistrPostR0Series);
  FillR0StrGrid(PreR0Hist, PostR0Hist, R0StrGrid);
end;

procedure TMainForm.ExitMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FillSessionList;
var aHiperParam: TDoublePoint2DArr;
begin
  COVIDSessionList.Clear;
  aHiperParam:= HiperParamFromTable(ParamDistrStrGrid);
  if EmptyHiperParam(aHiperParam) then Exit;

  COVIDSessionList.Add('InitContProb=' + InitContProbEdit.Text);
  COVIDSessionList.Add('IsolContProb=' + IsolContProbEdit.Text);

  COVIDSessionList.Add('ShowSimulProgr=' + IntToStr(Integer(ShowSimulProgrMenu.Checked)));
  COVIDSessionList.Add('AutoSize=' + IntToStr(Integer(AutoSizeMenu.Checked)));
  COVIDSessionList.Add('ShowEpicenters=' + IntToStr(Integer(ShowEpicentersMenu.Checked)));
  COVIDSessionList.Add('LeapYear=' + IntToStr(Integer(LeapYearMenu.Checked)));
  COVIDSessionList.Add('LogNormal=' + IntToStr(Integer(LogNormalMenu.Checked)));
  COVIDSessionList.Add('NormalDistrAge=' + IntToStr(Integer(NormalDistrAgeMenu.Checked)));
  COVIDSessionList.Add('DrawInfect=' + IntToStr(Integer(DrawInfectMenu.Checked)));
  COVIDSessionList.Add('RedR0Hist=' + IntToStr(Integer(RedR0HistMenu.Checked)));
  COVIDSessionList.Add('R0DistrFunc=' + IntToStr(Integer(R0DistrCheckBox.Checked)));

  COVIDSessionList.Add('TimeIsol=' + IntToStr(TimeIsolUpDown.Position));
  COVIDSessionList.Add('MaxSimulTime=' + IntToStr(MaxSimulTimeUpDown.Position));
  COVIDSessionList.Add('DetDay=' + IntToStr(DetDayUpDown.Position));
  COVIDSessionList.Add('InitOpt=' + IntToStr(InitOptUpDown.Position));
  COVIDSessionList.Add('TermOpt=' + IntToStr(TermOptUpDown.Position));
  COVIDSessionList.Add('ForeDay=' + IntToStr(ForeDayUpDown.Position));
  COVIDSessionList.Add('ForeIter=' + IntToStr(ForeIterUpDown.Position));
  COVIDSessionList.Add('SimType=' + IntToStr(SimTypeRadioGroup.ItemIndex));
  COVIDSessionList.Add('WeekIter=' + IntToStr(WeekIterUpDown.Position));
  COVIDSessionList.Add('WeekCount=' + IntToStr(WeekCountUpDown.Position));

  AddContCirclesToSession(ContCircles, COVIDSessionList);
  //aHiperParam:= HiperParamFromTable(ParamDistrStrGrid);
  AddHiperParamToSession(aHiperParam, COVIDSessionList);
  DiseaseFormToSession(DiseaseForm, COVIDSessionList);
  DiseaseDurationToSession(DiseaseDuration, COVIDSessionList);
end;

procedure TMainForm.SetOptions;
var aInitOptimDay, aTermOptimDay: Integer;
begin
  //if COVIDSessionList = nil then Exit;
  SetLabeledEditOptions(COVIDSessionList, InitContProbEdit, 'InitContProb', '0.2');
  InitContProb:= StrToFloatDef(InitContProbEdit.Text, 0);
  SetLabeledEditOptions(COVIDSessionList, IsolContProbEdit, 'IsolContProb', '0.08');
  IsolContProb:= StrToFloatDef(IsolContProbEdit.Text, 0);

  ShowSimulProgrMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['ShowSimulProgr'], 0));
  AutoSizeMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['AutoSize'], 0));
  ShowEpicentersMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['ShowEpicenters'], 0));
  ShowEpicenters:= ShowEpicentersMenu.Checked;
  LeapYearMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['LeapYear'], 1));
  LogNormalMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['LogNormal'], 1));
  LogNorm:= LogNormalMenu.Checked;
  NormalDistrAgeMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['NormalDistrAge'], 1));
  NormalDistrAge:= NormalDistrAgeMenu.Checked;
  DrawInfectMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['DrawInfect'], 1));
  DrawInfected:= DrawInfectMenu.Checked;
  RedR0HistMenu.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['RedR0Hist'], 1));
  R0DistrCheckBox.Checked:= Boolean(StrToIntDef(COVIDSessionList.Values['R0DistrFunc'], 1));

  DetDayUpDown.Position:= Max(0, StrToIntDef(COVIDSessionList.Values['DetDay'], 0));
  CurrDetDay:= DetDayUpDown.Position;
  TimeIsolUpDown.Position:= StrToIntDef(COVIDSessionList.Values['TimeIsol'], 0);
  IsolTime:= TimeIsolUpDown.Position;
  MaxSimulTimeUpDown.Position:= StrToIntDef(COVIDSessionList.Values['MaxSimulTime'], 0);
  MaxSimulTimeUpDown.Position:= Max(MaxSimulTimeUpDown.Position, DetDayUpDown.Position + 1);
  MaxSimulTime:= MaxSimulTimeUpDown.Position;
  SimulTimeUpDown.Max:= MaxSimulTime;
  InitOptUpDown.Position:= StrToIntDef(COVIDSessionList.Values['InitOpt'], 0);
  TermOptUpDown.Position:= StrToIntDef(COVIDSessionList.Values['TermOpt'], 0);
  aInitOptimDay:= InitOptUpDown.Position;
  aTermOptimDay:= TermOptUpDown.Position;
  OptimPeriod:= IntegerPoint2D(aInitOptimDay, aTermOptimDay);
  ForeDayUpDown.Position:= StrToIntDef(COVIDSessionList.Values['ForeDay'], 1);
  ForeIterUpDown.Position:= StrToIntDef(COVIDSessionList.Values['ForeIter'], 200);
  SimTypeRadioGroup.ItemIndex:= StrToIntDef(COVIDSessionList.Values['SimType'], 0);
  WeekIterUpDown.Position:= StrToIntDef(COVIDSessionList.Values['WeekIter'], 50);
  WeekCountUpDown.Position:= StrToIntDef(COVIDSessionList.Values['WeekCount'], 6);

  ContCircles:= ContCirclesFromList(COVIDSessionList);
  HiperParam:= HiperParamFromList(COVIDSessionList);
  FillParamDistrStrGrid(HiperParam, ParamDistrStrGrid);
  DiseaseFormFromList(COVIDSessionList, DiseaseForm);
  FillDiseaseFormStrGrid(DiseaseForm, DiseaseFormStrGrid);
  DiseaseDurationFromList(COVIDSessionList, DiseaseDuration);
  FillDurationStrGrid(DiseaseDuration, DurationStrGrid);
end;

procedure TMainForm.SetForeChartTitle;
begin
  case SimTypeRadioGroup.ItemIndex of
  0: ForecastChart.Title.Caption:= 'Forecast of common infection cases';
  1: ForecastChart.Title.Caption:= 'Forecast of hidden patients count';
  2: ForecastChart.Title.Caption:= 'Forecast of hospitalized patients count';
  3: ForecastChart.Title.Caption:= 'Forecast of fatality patients count';
  end;
end;

procedure TMainForm.SetForeDay;
begin
  if ForeDayUpDown.Position <= 1 then
    ForeDayUpDown.Position:= 1;
  ForecastDay:= ForeDayUpDown.Position;
  ForeDayEdit.Text:= YearDayText(ForecastDay);
end;

procedure TMainForm.SetFormSize;
var aDiff: Integer;
begin
  if MapScrollBox.Width <> MapPaintBox.Width then begin
    aDiff:= MapPaintBox.Width - MapScrollBox.Width;
    MainForm.Width:= MainForm.Width + aDiff + 1;
  end;
  if MapScrollBox.Height <> MapPaintBox.Height then begin
    aDiff:= MapPaintBox.Height - MapScrollBox.Height;
    MainForm.Height:= MainForm.Height + aDiff + 1;
  end;
end;

procedure TMainForm.ShowEpicentersMenuClick(Sender: TObject);
begin
  ShowEpicenters:= ShowEpicentersMenu.Checked;
  DrawMap;
end;

procedure TMainForm.ShowEpicentrsEval(X, Y: Integer);
var aEpicenter: TEpicenter;
    aCol, aRow: Integer;
begin
  if not ShowEpicenters then begin
    InitImgBitMap(MapBitMap);
    DrawPatList(PatList, PatCount, MapPaintBox);
    Exit;
  end;
  if aRow < 1 then Exit;
  if Epicenters <> nil then begin
    EpiCentrsGrid.MouseToCell(X, Y, aCol, aRow);
    aEpicenter:= Epicenters[aRow - 1];
    DrawEpicenters(Epicenters, MapBitMap, clBlue);
    DrawContCircle(MapBitMap, aEpicenter.Center, aEpicenter.Radius, clRed);
    MapPaintBox.Invalidate;
  end;
end;

procedure TMainForm.ShowSimulProgrMenuClick(Sender: TObject);
begin
  if not ShowSimulProgrMenu.Checked then begin
    ClearChart(SimulChart);
  end
  else begin
    DrawStatus(StatusArr, CurrSimulTime, InfPatSeries, TreatSeries, LethalSeries, RealIsolSeries, CaseSeries, RealLethalSeries, ReaHospSeries);
    DrawStatusAgeHist(StatusAgeHistArr[CurrSimulTime - CurrMinInfTime], InfHistSeries, TreatHistSeries, LethalHistSeries);
  end;
end;

procedure TMainForm.ShowSimulTab(aTabInd: Integer);
begin
  SimulPageControl.TabIndex:= aTabInd;
  Application.ProcessMessages;
end;

procedure TMainForm.ForecastChartAfterDraw(Sender: TObject);
begin
  DrawTimeLines(OptimPeriod[0], OptimPeriod[1], clGreen, ForecastChart);
end;

procedure TMainForm.ForecastChartBeforeDrawAxes(Sender: TObject);
begin
  DrawTimeStrip(OptimPeriod[0], OptimPeriod[1], $00E4E996, ForecastChart);
  DrawConfStrip(DailyForecast, ParamInd(SimTypeRadioGroup.ItemIndex), $00E5E5E5, ForecastChart);
end;

procedure TMainForm.ForecastChartMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ChartForCopy:= ForecastChart;
end;

procedure TMainForm.ForecastChartMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var aInd, aValueY, aTextWidth: Integer;
    aCenter: TPoint;
begin
  Screen.Cursor:= crDefault;
  aValueY:= 0;
  aInd:= ForeSeries.Clicked(X, Y);
  if aInd >= 0 then begin
    Screen.Cursor:= crHandPoint;
    aValueY:= Round(ForeSeries.YValues[aInd]);
  end
  else begin
    aInd:= RealSeries.Clicked(X, Y);
    if aInd >= 0 then begin
      Screen.Cursor:= crHandPoint;
      aValueY:= Round(RealSeries.YValues[aInd]);
    end
    else begin
      aInd:= LowSeries.Clicked(X, Y);
      if aInd >= 0 then begin
        Screen.Cursor:= crHandPoint;
        aValueY:= Round(LowSeries.YValues[aInd]);
      end
      else begin
        aInd:= HighSeries.Clicked(X, Y);
        if aInd >= 0 then begin
          Screen.Cursor:= crHandPoint;
          aValueY:= Round(HighSeries.YValues[aInd]);
        end;
      end;
    end;
  end;
  aTextWidth:= 0;
  if aValueY > 0 then begin
    ShowValLabel.Caption:= IntToStr(aValueY);
    aTextWidth:= ShowValLabel.Canvas.TextWidth(ShowValLabel.Caption);
  end
  else
    ShowValLabel.Caption:= '';
  aCenter:= Point(Round(0.8*ForecastChart.Width), Round(0.6*ForecastChart.Height));
  ShowValLabel.Visible:= aInd >= 0;
  if X < aCenter.X then
    ShowValLabel.Left:= X + 18
  else
    ShowValLabel.Left:= X - aTextWidth - 10;

  if Y < aCenter.Y then
    ShowValLabel.Top:= Y + 5
  else begin
    ShowValLabel.Top:= Y - 15;
    if X < aCenter.X then
      ShowValLabel.Left:= X + 8
    else
      ShowValLabel.Left:= X - aTextWidth - 5;
  end;
end;

procedure TMainForm.ForeDayUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  ForeDayEdit.Text:= YearDayText(ForeDayUpDown.Position);
end;

procedure TMainForm.ForeDayUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetForeDay;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  SimulTimeEdit.SetFocus;
  if AutoSizeMenu.Checked then
    SetFormSize;
  TimeIsolEdit.Text:= YearDayText(TimeIsolUpDown.Position);
  FillParamStrGrid(ParamStrGrid);
  MainForm.Width:= MainForm.Width + 1;
  MainForm.Width:= MainForm.Width - 1;
  //HandleCmdLine;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    SaveSessionList;
  finally
    CanClose:= True;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var aPatLen, aDetPatLen, aMaxHeight: Integer;
    aMsgStr: String;
begin
  DecimalSeparator:= '.';
  CurrentDirectory:= ExtractFileDir(Application.ExeName);
  COVIDSessionList:= TStringList.Create;
  if not LoadSessionFile(COVIDSessionFileName) then begin
    aMsgStr:= 'The Session file ' + COVIDSessionFileName + ' is not found';
    MessageDlg(aMsgStr, mtError, [mbOK], 0);
  end;
  SetOptions;
  CurrMap:= TPNGImage.Create;
  BuffBitMap:= TBitMap.Create;
  MapBitMap:= TBitMap.Create;
  if not OpenCurrMap then begin
    aMsgStr:= 'The file ' + MapFileName + ' is not found';
    HaltProgram(aMsgStr);
  end;
  AngleScale:= AngleMapScale(GeoLeftTop, GeoRightBottom, MapLeftTop, MapRightBottom);
  WaterMask:= GetWaterMask(BuffBitMap);
  aMaxHeight:= LeftBottomPanel.Height - ContCirclesGrid.Top - 10;
  FillContCirclesGrid(ContCircles, aMaxHeight, ContCirclesGrid);
  aPatLen:= 800000;
  SetLength(PatList, aPatLen);
  PatCount:= 0;
  aDetPatLen:= 80000;
  SetLength(DetPatList, aDetPatLen);
  StopEvaluation:= False;
  if not LoadDetectECCounts(CurrentDirectory + '\' + DetectCountFileName, DetectECCounts, DetectDays) then begin
    aMsgStr:= 'The file ' + DetectCountFileName + ' is not found';
    HaltProgram(aMsgStr);
  end;
  Correct(DetectECCounts);
  DetDaysCount:= DetectDays.Count;
  SumDetectECCounts:= SumDetECCounts(DetectECCounts);
  if not LoadEpicenters(CurrentDirectory +  '\' + EpicentersFileName, Epicenters) then begin
    aMsgStr:= 'The file ' + EpicentersFileName + ' is not found';
    HaltProgram(aMsgStr);
  end;
  LenEC:= Length(Epicenters);
  MAAgeDistrFunc:= AgeDistrFunc;
  SetYearDays(LeapYearMenu.Checked);
  SetMonthNameList;
  DetDayUpDown.Max:= DetectDays.Count - 1;
  PrevDetDay:= -1;
  LenHiperParam:= Length(HiperParam);
  DetDayEdit.Text:= DetectDays[CurrDetDay];
  DetectDayInd:= YearDays.IndexOf(DetDayEdit.Text);
  InitOptEdit.Text:= YearDayText(InitOptUpDown.Position);
  TermOptEdit.Text:= YearDayText(TermOptUpDown.Position);
  TermOptUpDown.Max:= DetDaysCount - CurrDetDay;
  TermUpEdit.Text:= 'Up to ' + YearDayText(TermOptUpDown.Max);
  FatalArr_1:= nil;
  if LoadDeathMA(COVID_Death_MAFileName, DeathMA) then begin
    IsLoadDeathMA:= True;
    FatalArr_1:= GetFatalArr(DeathMA);
  end
  else
    IsLoadDeathMA:= False;
  LoadDailyForecast(CurrentDirectory + '\' + DailyForecastFileName, DailyForecast);
  SetHospitDeadCount(FullDataFileName, HospitalArr, FatalArr);
  DrawForecast(DailyForecast, ParamInd(SimTypeRadioGroup.ItemIndex), ForeSeries, LowSeries, HighSeries, RealSeries);
  SetForeChartTitle;
  MeshStep:= 6;
  InitModel(HiperParam, InitContProb, IsolContProb, CurrDetDay);
  DrawMap;
  MaxSimulTimeEdit.Text:= YearDays[MaxSimulTimeUpDown.Position + DetectDayInd] + ' (' + IntToStr(MaxSimulTimeUpDown.Position) + ')';
  ForeDayEdit.Text:= YearDays[ForeDayUpDown.Position + DetectDayInd] + ' (' + IntToStr(ForeDayUpDown.Position) + ')';
  LargeStep:= False;
  FormClose:= False;
  FullSimMode:= False;
  LevelList:= GetLevelList;
  SetForeDay;
  HandleCmdLine;
  if FormClose then
    Halt;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then begin
    SimulTimeEdit.SetFocus;
    SimulationStep(HiperParam, InitContProb, IsolContProb);
  end;
  if Key = VK_ESCAPE then begin
    StopEvaluation:= True;
    Application.ProcessMessages;
  end;
  if Key = VK_CONTROL then begin
    LargeStep:= True;
    Application.ProcessMessages;
  end;
  if ssCtrl in Shift then
    if Key = Ord('T') then begin
      ShowTreat:= not ShowTreat;
      DrawStatus(StatusArr, CurrSimulTime, InfPatSeries, TreatSeries, LethalSeries, RealIsolSeries, CaseSeries, RealLethalSeries, ReaHospSeries);
    end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LargeStep:= False;
end;

procedure TMainForm.FullSimlation;
var i: Integer;
begin
  for i:= CurrSimulTime to MaxSimulTime - 2 do begin
    FullSimMode:= True;
    if (not StopEvaluation) then
      SimulationStep(HiperParam, InitContProb, IsolContProb)
    else begin
      FullSimMode:= False;
      Break;
    end;
  end;
  EvaluateR0;
  FullSimMode:= False;
  Screen.Cursor:= crDefault;
end;

procedure TMainForm.FullSimlButtonClick(Sender: TObject);
begin
  ShowSimulTab(0);
  FullSimlation;
end;

procedure TMainForm.HaltProgram(aMsgStr: String);
begin
  MessageDlg(aMsgStr, mtError, [mbOK], 0);
  Halt;
end;

procedure TMainForm.HandleCmdLine;
var i, aDetectDayInd: Integer;
    aMsgStr: String;
begin
  CurrParamCount:= ParamCount;  // RU: Количество параметров в ParamStr EN: The number of parameters in ParamStr
  if CurrParamCount < 1 then Exit;
  Console:= CurrParamCount > 0;
  SetLength(CurrParamStr, CurrParamCount + 1);
  for i:= 0 to CurrParamCount do
    CurrParamStr[i]:= ParamStr(i);
  aDetectDayInd:= DetectDays.IndexOf(CurrParamStr[1]);  // RU; Индекс в списка дат входных данных EN: The index in the list of dates of the input data
  if aDetectDayInd < 0 then begin
    aMsgStr:= 'The initial date out of an acceptable range (' + DetectDays[0] + ' ~ ' + DetectDays[DetectDays.Count - 1] + ')';
    MessageDlg(aMsgStr, mtError, [mbOK], 0);
    Exit;
  end;
  CurrDetDay:= aDetectDayInd;
  DetDayUpDown.Position:= CurrDetDay;
  DetectDayInd:= YearDays.IndexOf(CurrParamStr[1]);
  MaxSimulTime:= YearDays.IndexOf(CurrParamStr[2]) - DetectDayInd;  // RU: Индекс MaxSimulTime в списке YearDays - aDetectDayYearInd EN: Index MaxSimulTime in list YearDays - aDetectDayYearInd
  MaxSimulTimeUpDown.Position:= MaxSimulTime;
  MaxSimulTimeEdit.Text:= YearDayText(MaxSimulTime);
  Screen.Cursor:= crHourGlass;
  InitModel(HiperParam, InitContProb, IsolContProb, CurrDetDay);
  FullSimlation;
  SaveStatusArr(StatusArr, SumDetectECCounts, StatusArrFileName);
  SaveStatusStrArr(StatusStrArr, StatusStrArrFileName);
  Screen.Cursor:= crDefault;
  Console:= False;
  DrawMap;
  FormClose:= True;
  if CurrParamCount >= 3 then
    if (CurrParamStr[3] = 'nc') then
      FormClose:= False;
end;

procedure TMainForm.InitContProbEditChange(Sender: TObject);
begin
  InitContProb:= StrToFloatDef(InitContProbEdit.Text, 0);
end;

procedure TMainForm.InitContProbUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  HandleUpDownClick(Button, InitContProbEdit, 0.2, 0.001, 0.001, 1.0, '%5.3f');
end;

procedure TMainForm.InitContProbUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  InitContProb:= StrToFloatDef(InitContProbEdit.Text, 0);
end;

procedure TMainForm.InitModel(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double; aCurrDetDay: Integer);
var aMaxHeight: Integer;
begin
  DetDayEdit.Text:= DetectDays[aCurrDetDay];
  aMaxHeight:= LeftBottomPanel.Height - EpiCentrsGrid.Top - 10;
  FillEpiCentrsGrid(Epicenters, DetectECCounts[aCurrDetDay], aMaxHeight, EpiCentrsGrid, EpiLabel);
  CurrMinInfTime:= -aCurrDetDay;
  CurrSimulTime:= 0;
  PointTime:= CurrSimulTime;
  MaxSimulTimeUpDown.Min:= CurrMinInfTime;
  SimulTimeUpDown.Min:= CurrMinInfTime;
  SimulTimeUpDown.Position:= CurrSimulTime;
  InitStatusArr;
  SetInitPatList(DetectECCounts, CurrDetDay, HiperParam, InitContProb, IsolContProb, PatList, PatCount, StatusArr);
  aMaxHeight:= DetListPanel.Height - DetPatStrGrid.Top - 10;
  FillDetPatStrGrid(PatList, PatCount, aMaxHeight, DetPatStrGrid);
  FillInfectStrGrid(StatusArr, aCurrDetDay, InfectStrGrid);
  DetPatLabel.Caption:= 'Initial Patients (' + IntToStr(PatCount) + ')';
  MaxDetDuration:= MaxDurationTime(DetPatList, DetPatCount);
  PatLabel.Caption:= 'Patients ' + YearDayText(CurrSimulTime);
  if MainForm.Active then
    SimulTimeEdit.SetFocus;
  SimulTimeEdit.Text:= YearDayText(CurrSimulTime);
  StopEvaluation:= False;
  StatusAgeHistArr[CurrSimulTime - CurrMinInfTime]:= StatusAgeHist(PatList, PatCount, CurrSimulTime);
  if ShowSimulProgrMenu.Checked then begin
    DrawStatus(StatusArr, CurrSimulTime, InfPatSeries, TreatSeries, LethalSeries, RealIsolSeries, CaseSeries, RealLethalSeries, ReaHospSeries);
    DrawStatusAgeHist(StatusAgeHistArr[CurrSimulTime - CurrMinInfTime], InfHistSeries, TreatHistSeries, LethalHistSeries);
  end;
  CaseMSEEdit.Text:= '';
  PreR0Hist:= ZeroRealHist;
  PostR0Hist:= ZeroRealHist;
  ClearStrGridCont(R0StrGrid);
end;

procedure TMainForm.InitOptUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  InitOptEdit.Text:= YearDayText(InitOptUpDown.Position);
end;

procedure TMainForm.InitOptUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  OptimPeriod[0]:= InitOptUpDown.Position;
  InitOptEdit.Text:= YearDayText(InitOptUpDown.Position);
end;

procedure TMainForm.InitSimulButtonClick(Sender: TObject);
begin
  ShowSimulTab(0);
  InitModel(HiperParam, InitContProb, IsolContProb, DetDayUpDown.Position);
  DrawMap;
end;

procedure TMainForm.IsolContProbEditChange(Sender: TObject);
begin
  IsolContProb:= StrToFloatDef(IsolContProbEdit.Text, 0);
end;

procedure TMainForm.IsolContProbUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  HandleUpDownClick(Button, IsolContProbEdit, 0.08, 0.001, 0.001, 1.0, '%5.3f');
end;

procedure TMainForm.IsolContProbUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsolContProb:= StrToFloatDef(IsolContProbEdit.Text, 0);
end;

procedure TMainForm.LeftBottomPanelResize(Sender: TObject);
var aMaxHeight: Integer;
begin
  aMaxHeight:= LeftBottomPanel.Height - EpiCentrsGrid.Top - 10;
  FillEpiCentrsGrid(Epicenters, DetectECCounts[CurrDetDay], aMaxHeight, EpiCentrsGrid, EpiLabel);
  aMaxHeight:= LeftBottomPanel.Height - ContCirclesGrid.Top - 10;
  FillContCirclesGrid(ContCircles, aMaxHeight, ContCirclesGrid);
end;

function TMainForm.LoadSessionFile(const aSessionFileName: String): Boolean;
var aTempFileName: String;
begin
  aTempFileName:= CurrentDirectory + '\' + aSessionFileName;
  if FileExists(aTempFileName) then begin
    COVIDSessionList.LoadFromFile(aTempFileName);
    Result:= True;
  end
  else
    Result:= False;
end;

procedure TMainForm.LogNormalMenuClick(Sender: TObject);
begin
  LogNorm:= LogNormalMenu.Checked;
end;

procedure TMainForm.MapPaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aSelCircleInd, aSelDetPatInd: Integer;
    aContCircle: TIntegerPoint3D;
begin
  if ssCtrl in Shift then begin
    CoordXUpDown.Position:= X;
    CoordYUpDown.Position:= Y;
  end;
  if ssShift in Shift then begin
    ContCenter[0]:= X;
    ContCenter[1]:= Y;
    ContCenterEdit.Text:= 'X: ' + IntToStr(X) + '; Y: ' + IntToStr(Y);
  end;
  aSelCircleInd:= SelCircleInd(X, Y, ContCircles);
  if aSelCircleInd >= 0 then begin
    ContCirclesGrid.Row:= aSelCircleInd + 1;
    aContCircle:= ContCircles[aSelCircleInd];
    ContCenterEdit.Text:= 'X: ' + IntToStr(aContCircle[0]) + '; Y: ' + IntToStr(aContCircle[1]);
    ContRadUpDown.Position:= aContCircle[2];
  end;
  SelEpiInd:= SelECInd(X, Y, Epicenters);
  if SelEpiInd >= 0 then begin
    EpiCentrsGrid.Row:= SelEpiInd + 1;
    DrawEpicenters(Epicenters, MapBitMap, clBlue);
    DrawContCircle(MapBitMap, Epicenters[SelEpiInd].Center, Epicenters[SelEpiInd].Radius, clRed);
    MapPaintBox.Invalidate;
  end;
  aSelDetPatInd:= SelDetPatInd(X, Y, PatList, PatCount);
  if (aSelDetPatInd >= 0)and(aSelDetPatInd < DetPatStrGrid.RowCount) then
    DetPatStrGrid.Row:= aSelDetPatInd + 1;
end;

procedure TMainForm.MapPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var aSelDetPatInd: Integer;
begin
  Edit1.Text:= 'X: ' + IntToStr(X) + '; Y: ' + IntToStr(Y);
  if (not Console) and (Screen.Cursor <> crHourGlass) then
    Screen.Cursor:= crDefault;
  aSelDetPatInd:= SelDetPatInd(X, Y, PatList, PatCount);
  if (not Console) and (aSelDetPatInd >= 0) and (aSelDetPatInd < DetPatStrGrid.RowCount) and  (Screen.Cursor <> crHourGlass) then
    Screen.Cursor:= crHandPoint;
end;

procedure TMainForm.MapPaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aRGB: TRGB;
    aPixelColor: TColor;
    aWater: Boolean;
    aDist: Integer;
begin
  aPixelColor:= BuffBitMap.Canvas.Pixels[X, Y];
  aRGB:= ColorToRGB(aPixelColor);
  aDist:= Round(DistRGB(aRGB, WaterRGB));
  PosEdit.Text:= IntToStr(aRGB[0]) + '; ' + IntToStr(aRGB[1]) + '; ' + IntToStr(aRGB[2]) + ' ' + IntToStr(aDist);
  aWater:= WaterMask[X, Y];
  if aWater then
    CaseMSEEdit.Text:= 'Water'
  else
    CaseMSEEdit.Text:= 'Land'
end;

procedure TMainForm.MapPaintBoxPaint(Sender: TObject);
begin
  MapPaintBox.Canvas.StretchDraw(MapPaintBox.ClientRect, MapBitMap)
end;

procedure TMainForm.NewPatButtonClick(Sender: TObject);
begin
  NewPatParams(HiperParam);
end;

procedure TMainForm.NewPatParams(const aHiperParam: TDoublePoint2DArr);
var aDetectParam, aAgeParam, aStatus, aInfectTime, aAvrgRadDistParam: Integer;
    aStageParam, aContactsParam, aCoord: TIntegerPoint2D;
    aContProbParam, aLambda: Double;
    aDetectDistrParam, aAgeDistrParam: TDoublePoint2D;
begin
  aDetectDistrParam:= aHiperParam[0];
  aDetectParam:= GetDetectParam(aDetectDistrParam);
  aStageParam:= GetStageParam(aDetectParam);
  aAgeDistrParam:= aHiperParam[1];
  aAgeParam:= GetAgeParam(aAgeDistrParam);
  aInfectTime:= -aDetectParam;
  InitTimeUpDown.Position:= aInfectTime;
  aStatus:= 0;
  StatusUpDown.Position:= aStatus;
  DetectUpDown.Position:= aDetectParam;
  aStageParam:= GetStageParam(aDetectParam);
  aCoord:= IntegerPoint2D(CoordXUpDown.Position, CoordYUpDown.Position);
  aContactsParam:= GetContParam(aCoord, aAgeParam, ContCircles, aHiperParam);
  if aInfectTime < IsolTime then
    aLambda:= InitContProb
  else
    aLambda:= IsolContProb;
  aContProbParam:= GetContProbParam(aLambda, aAgeParam);
  aAvrgRadDistParam:= GetAvrgRadDistParam(aHiperParam, aAgeParam);
  Stage1UpDown.Position:= aStageParam[0];
  Stage2UpDown.Position:= aStageParam[1];
  AgeUpDown.Position:= aAgeParam;
  ContactsUpDown.Position:= aContactsParam[0];
  SDContactsUpDown.Position:= aContactsParam[1];
  ContProbEdit.Text:= Format('%4.2f', [aContProbParam]);
  DistUpDown.Position:= aAvrgRadDistParam;
end;

procedure TMainForm.NormalDistrAgeMenuClick(Sender: TObject);
begin
  NormalDistrAge:= NormalDistrAgeMenu.Checked;
end;

function TMainForm.OpenCurrMap: Boolean;
begin
  Result:= LoadCurrMap;
  MapPaintBox.Width:= CurrMapSize[0];
  MapPaintBox.Height:= CurrMapSize[1];
  MapPaintBox.Invalidate;
end;

procedure TMainForm.ParamDistrStrGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    HiperParam:= HiperParamFromTable(ParamDistrStrGrid);
end;

procedure TMainForm.ParamDistrStrGridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  HiperParam:= HiperParamFromTable(ParamDistrStrGrid);
end;

procedure TMainForm.ParamRadioGroupClick(Sender: TObject);
begin
  if (ParamRadioGroup.ItemIndex = 1) and EmptyParam(AvrgOptHiperParam, AvrgOptInitContProb, AvrgOptIsolContProb) then begin  //optimum parameters are not determined
    MessageDlg('The Optimal Parameters are not Defined', mtInformation, [mbOk], 0);
    ParamRadioGroup.ItemIndex:= 0;
    Exit;
  end;
  if (ParamRadioGroup.ItemIndex = 1) then begin
    CurrHiperParam:= HiperParam;
    CurrInitContProb:= InitContProb;
    CurrIsolContProb:= IsolContProb;
  end;
  SetHiperParamManual(ParamRadioGroup.ItemIndex = 0);
  FillParamDistrStrGrid(HiperParam, ParamDistrStrGrid);
  InitContProbEdit.Text:= Format('%5.3f', [InitContProb]);
  IsolContProbEdit.Text:= Format('%5.3f', [IsolContProb]);
end;

procedure TMainForm.ParamUpDownClick(Sender: TObject; Button: TUDBtnType);
var aText: String;
    aMaxValue, aValue1, aValue2, aValue3, aStep: Double;
    aRow: Integer;
begin
  aText:= DiseaseFormStrGrid.Cells[SelParamCell[0], SelParamCell[1]];
  aRow:= 3 - SelParamCell[1];
  aValue1:= StrToFloatDef(DiseaseFormStrGrid.Cells[SelParamCell[0], aRow], 0);
  aMaxValue:= 100 - aValue1;
  if LargeStep then
    aStep:= 1.0
  else
    aStep:= 0.1;
  HandleUpDownClick(Button, aText, 0, aStep, 0, aMaxValue, '%4.1f');
  DiseaseFormStrGrid.Cells[SelParamCell[0], SelParamCell[1]]:= aText;
  aValue2:= StrToFloatDef(aText, 0);
  aValue3:= 100 - aValue1 - aValue2;
  DiseaseFormStrGrid.Cells[SelParamCell[0], 3]:= Format('%4.1f', [aValue3]);
end;

procedure TMainForm.ParamUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DiseaseFormFromTable(DiseaseForm, DiseaseFormStrGrid);
end;

function TMainForm.PatFromParam: TPat;
  {RU: Возвращает данные для пациента по текущим значениям в PatGroupBox}
  {EN: Returns the data for the individual bases on the current values in PatGroupBox}
begin
  Result.Coord:= IntegerPoint2D(CoordXUpDown.Position, CoordYUpDown.Position);
  Result.InfectTime:= InitTimeUpDown.Position;
  Result.Stage1:= Stage1UpDown.Position;
  Result.Stage2:= Stage2UpDown.Position;
  Result.Detect:= DetectUpDown.Position;
  Result.Age:= AgeUpDown.Position;
  Result.AvrgRadDist:= DistUpDown.Position;
  Result.Contacts:= IntegerPoint2D(ContactsUpDown.Position, SDContactsUpDown.Position);
  Result.ContProb:= StrToFloatDef(ContProbEdit.Text, 0);
  Result.Status:= StatusUpDown.Position;
end;

procedure TMainForm.PatToParam(aPat: TPat);
begin
  if (aPat.Coord[0] = 0)and(aPat.Coord[1] = 0) then Exit;
  CoordXUpDown.Position:= aPat.Coord[0];
  CoordYUpDown.Position:= aPat.Coord[1];
  InitTimeUpDown.Position:= aPat.InfectTime;
  Stage1UpDown.Position:= aPat.Stage1;
  Stage2UpDown.Position:= aPat.Stage2;
  DetectUpDown.Position:= aPat.Detect;
  DistUpDown.Position:= aPat.AvrgRadDist;
  AgeUpDown.Position:= aPat.Age;
  ContactsUpDown.Position:= aPat.Contacts[0];
  SDContactsUpDown.Position:= aPat.Contacts[1];
  ContProbEdit.Text:= Format('%4.2f', [aPat.ContProb]);
  StatusUpDown.Position:= aPat.Status;
end;

procedure TMainForm.R0ChartMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ChartForCopy:= R0Chart;
end;

procedure TMainForm.R0DistrCheckBoxClick(Sender: TObject);
begin
  DrawRealHist(PreR0Hist, R0DistrCheckBox.Checked, PreR0Series, DistrPreR0Series);
  DrawRealHist(PostR0Hist, R0DistrCheckBox.Checked, PostR0Series, DistrPostR0Series);
end;

procedure TMainForm.RedR0HistMenuClick(Sender: TObject);
begin
  Screen.Cursor:= crHourGlass;
  EvaluateR0;
  Screen.Cursor:= crDefault;
end;

procedure TMainForm.RestartlButtonClick(Sender: TObject);
begin
  ShowSimulTab(0);
  InitModel(HiperParam, InitContProb, IsolContProb, DetDayUpDown.Position);
  FullSimlation;
end;

procedure TMainForm.SaveSessionList;
var aTempFileName: String;
begin
  if COVIDSessionList <> nil then begin
    FillSessionList;
    if COVIDSessionList.Count = 0 then Exit;
    aTempFileName:= CurrentDirectory + '\' + COVIDSessionFileName;
    COVIDSessionList.SaveToFile(aTempFileName);
  end;
end;

procedure TMainForm.SimTypeRadioGroupClick(Sender: TObject);
begin
  DrawForecast(DailyForecast, ParamInd(SimTypeRadioGroup.ItemIndex), ForeSeries, LowSeries, HighSeries, RealSeries);
  SetForeChartTitle;
end;

procedure TMainForm.SimulationStep(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double);
  {RU: Формирование aInfectedPat, aIsolatedPatб aAgeHistArr по параметрам aHiperParam, aInitContProb, aIsolContProb}
  {EN: Forming of aInfectedPat, aIsolatedPatб aAgeHistArr based on parameters aHiperParam, aInitContProb, aIsolContProb}
var aChange: Integer;
    aNodes: TNodes;  // RU: Карта узлов для сохранения пациентов с разными статусами. aNode = (0 - Stat = 1; 1 - Stat = 2; 2 - Stat = 4)
                     // EN: The map of the knots for saving individuals with different statuses. aNode = (0 - Stat = 1; 1 - Stat = 2; 2 - Stat = 4)
    aCasesRootMSE: Double;
begin
  if StopEvaluation then Exit;
  if CurrSimulTime >= MaxSimulTime - 1 then begin
    DrawStatus(StatusArr, CurrSimulTime, InfPatSeries, TreatSeries, LethalSeries, RealIsolSeries, CaseSeries, RealLethalSeries, ReaHospSeries);
    Exit;
  end;
  Inc(CurrSimulTime);
  PointTime:= CurrSimulTime;
  SimulTimeUpDown.Position:= CurrSimulTime;
  SimulTimeEdit.Text:= YearDayText(CurrSimulTime);
  if not Console then
    Screen.Cursor:= crHourGlass;
  aNodes:= InitNodes;
  UpdatePatListStatus(CurrSimulTime, PatCount, PatList, aChange);
  ExpandPatListAtTime(CurrSimulTime, aHiperParam, aInitContProb, aIsolContProb, PatList, PatCount);
  UpdateStatusArr(PatList, PatCount, CurrSimulTime, InfectStrGrid, StatusArr);
  UpdateNodes(PatList, PatCount, aNodes);
  SetStatusStrDay(aNodes, CurrDetDay + CurrSimulTime, StatusStrArr);
  PatLabel.Caption:= 'Patients ' + YearDayText(CurrSimulTime);
  if ShowSimulProgrMenu.Checked then begin
    DrawStatus(StatusArr, CurrSimulTime, InfPatSeries, TreatSeries, LethalSeries, RealIsolSeries, CaseSeries, RealLethalSeries, ReaHospSeries);
    DrawStatusAgeHist(StatusAgeHistArr[CurrSimulTime - CurrMinInfTime], InfHistSeries, TreatHistSeries, LethalHistSeries);
  end;
  DrawMap;
  if (not Console)and(not FullSimMode) then
    Screen.Cursor:= crDefault;
  Application.ProcessMessages;
  aCasesRootMSE:= CasesRootMSE(StatusArr, SumDetectECCounts, Point2D(9, 26), CurrSimulTime);
  if aCasesRootMSE > 0 then
    CaseMSEEdit.Text:= Format('%4.0f', [aCasesRootMSE]);
end;

procedure TMainForm.SimulChartClickLegend(Sender: TCustomChart; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aLeftVisible: Boolean;
begin
  aLeftVisible:= InfPatSeries.Visible or TreatSeries.Visible or RealIsolSeries.Visible;
  if (not aLeftVisible) then
    SimulChart.RightAxis.Grid.Visible:= True
  else
    SimulChart.RightAxis.Grid.Visible:= False;
  RealLethalSeries.Visible:= LethalSeries.Visible;
  CaseSeries.Visible:= RealIsolSeries.Visible;
end;

procedure TMainForm.SimulChartResize(Sender: TObject);
begin
  CaseMSEEdit.Left:= SimulChart.Width - 56;
end;

procedure TMainForm.SimulStepButtonClick(Sender: TObject);
begin
  ShowSimulTab(0);
  SimulationStep(HiperParam, InitContProb, IsolContProb);
end;

procedure TMainForm.SimulTimeUpDownChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange:= (SimulTimeUpDown.Position >= CurrMinInfTime)and(SimulTimeUpDown.Position <= MaxSimulTime);
end;

procedure TMainForm.SimulTimeUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if (SimulTimeUpDown.Position >= CurrMinInfTime)and(SimulTimeUpDown.Position <= CurrSimulTime) then begin
    AgeHistChart.Title.Caption:= 'Patients Age Histogram ' + YearDayText(SimulTimeUpDown.Position);
    PatLabel.Caption:= 'Patients ' + YearDayText(SimulTimeUpDown.Position);
    SimulChart.Title.Caption:= 'Patient Status Simulation ' + YearDayText(SimulTimeUpDown.Position);
  end;
end;

procedure TMainForm.SimulTimeUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aInd: Integer;
begin
  aInd:= SimulTimeUpDown.Position - CurrMinInfTime;
  DrawStatusAgeHist(StatusAgeHistArr[aInd], InfHistSeries, TreatHistSeries, LethalHistSeries);
  DrawStatus(StatusArr, SimulTimeUpDown.Position, InfPatSeries, TreatSeries, LethalSeries, RealIsolSeries, CaseSeries, RealLethalSeries, ReaHospSeries);
  FillInfectStrGrid(StatusArr, SimulTimeUpDown.Position, InfectStrGrid);
  PatLabel.Caption:= 'Patients ' + YearDayText(SimulTimeUpDown.Position);
  SimulChart.Title.Caption:= 'Patient Status Simulation ' + YearDayText(SimulTimeUpDown.Position);
  AgeHistChart.Title.Caption:= 'Patients Age Histogram ' + YearDayText(SimulTimeUpDown.Position);
end;

procedure TMainForm.TermOptUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  TermOptEdit.Text:= YearDayText(TermOptUpDown.Position);
end;

procedure TMainForm.TermOptUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  OptimPeriod[1]:= TermOptUpDown.Position;
  TermOptEdit.Text:= YearDayText(TermOptUpDown.Position);
end;

procedure TMainForm.TimeIsolUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  TimeIsolEdit.Text:= YearDayText(TimeIsolUpDown.Position);
end;

procedure TMainForm.TimeIsolUpDownMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsolTime:= TimeIsolUpDown.Position;
  TimeIsolEdit.Text:= YearDayText(TimeIsolUpDown.Position);
end;

end.
