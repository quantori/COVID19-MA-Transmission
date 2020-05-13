unit UnTypesCOVID;

interface

uses SysUtils, Types, Graphics, ComCtrls, OpenGL, Math, TeEngine;

const
  MaxColor = 255; { Максимальная интенсивность серого цвета }

type
  TLongInt = array [0 .. 3] of AnsiChar;
  TSmallInt = array [0 .. 1] of AnsiChar;
  TIntPoint2D = array [0 .. 1] of Smallint;
  TIntPoint2DArr = array of TIntPoint2D;
  TClusters = array of TIntPoint2DArr;
  TRegion2D = array [0 .. 1] of TIntPoint2D;
  TRealPoint2D = array [0 .. 1] of Single;
  TRealRegion2D = array [0 .. 1] of TRealPoint2D;
  TRealPoint2DArr = array of TRealPoint2D;
  TDoublePoint2D = array [0 .. 1] of Double;
  TDoublePoint4D = array [0 .. 3] of Double;
  TDoublePoint2DArr = array of TDoublePoint2D;
  TDoublePoint2DArrArr = array of TDoublePoint2DArr;
  TIntPoint3D = array [0 .. 2] of Smallint;
  TIntegerPoint3D = array [0 .. 2] of Integer;
  TDoublePoint3D = array [0 .. 2] of Double;
  TIntegerPoint2D = array [0 .. 1] of Integer;
  TIntegerPoint2DArr = array of TIntegerPoint2D;
  TIntegerRegion2D = array [0 .. 1] of TIntegerPoint2D;
  TIntegerPoint3DArr = array of TIntegerPoint3D;
  TDoublePoint3DArr = array of TDoublePoint3D;
  TRealPoint3D = array [0 .. 2] of Single;
  TByteArray = array of Byte;
  TBytePair = array [0..1] of Byte;
  TByteArray2 = array[0..1] of TByteArray;
  TByteArray3 = array[0..2] of TByteArray;
  TByteArray2D = array of array of Byte;
  TRealArray = array of Single;
  TRealArrArray = array of TRealArray;
  TRealArray2D = array of array of Single;
  TDoubleArray2D = array of array of Double;
  TDoubleArray2DArr = array of TDoubleArray2D;
  TDoubleArray3D = array of array of array of Double;
  TIntArray = array of Integer;
  TIntArrayArr = array of TIntArray;
  TDoubleArray = array of Double;
  T3DArrDoubleArray = array of array of array of TDoubleArray;
  TDoubleArrayArr = array of TDoubleArray;
  TDoubleArr2D = array of array of TDoubleArray;
  TIntegerArray2D = array of array of Integer;
  TSmallintArray = array of Smallint;
  TSmallintArrayArr = array of TSmallintArray;
  TIntPoint3DArr = array of TIntPoint3D;
  TROIBordersArr = array of TIntPoint3DArr;
  TRealPoint3DArr = array of TRealPoint3D;
  TIntegerArr = array of Integer;
  TIntegerArrArr = array of TIntegerArr;
  TColorMap = array [0 .. MaxColor] of TColor;
  TColorMapArr = array of TColorMap;
  TColorArr = array of TColor;
  TRegion = array [0 .. 1] of TIntegerPoint3D; { Параллелепипед с граничными точками: 0 - Min (X, Y, Z), 1 - Max (X, Y, Z) }
  TImgArray = array of array of array of Smallint;
  { Intensities array for Image }
  // TROIConnectMatr = array of array of Smallint;  {Матрица смежности ROI}
  TIntArray2D = array of array of Smallint;
  TIntArray3D = array of array of array of Integer;
  TNormImgArray = array of array of array of Byte; { Массив нормализованны интенсивностей }
  TImgSection = array of array of Byte; { Массив нормализованны интенсивностей в сечении имиджа }
  TDistMap = array of array of array of Shortint;
  TDistMapSection = array of array of Shortint;
  TImgMask = array of array of array of Boolean; { Массив разметки кубической маски на две компоненты: пространство = False, тело = True }
  TImgMaskSection = array of array of Boolean; { Массив значений маски в сечении имиджа }
  TBoolArray = array of Boolean;
  TRealPoint3DArr2D = array of array of TRealPoint3D; { Двумерный массив вешественных точек }
  TRealPoint3DArr3D = array of array of array of TRealPoint3D; { Трехмерный массив вешественных точек }
  TRGB = array [0 .. 2] of Byte; { Main colors’ intensities: 0 - Red, 1 - Green, 2 - Blue }
  TRGBArray = array of TRGB;
  TVertex = TGLArrayf3; { Точка в OopenGl }
  TVertexArr = array of TVertex;
  TTriangle = array [0 .. 2] of TVertex; { Треугольник - тройка вершин }
  TVector4 = array [0 .. 3] of GLfloat;
  TMatrix4 = array [0 .. 3, 0 .. 3] of GLfloat;
  TMatr3 = array [0 .. 2] of TRealPoint3D; { Матрица = 3 строки (TRealPoint3D) }
  TMatr3Double = array [0 .. 2] of TDoublePoint3D; { Матрица = 3 строки (TDoublePoint3D) }
  TMatr2 = array [0 .. 1] of array [0 .. 1] of Double;
  { Матрица второго порядка }
  TTransform = record
    Shift: TRealPoint3D; { Сдвиг начала координат. }
    Ort: TMatr3;
    { Матрица ортогонального преобразования базиса. aOrt[aInd] - координаты вектора aInd нового базиса }
  end;
  TSingleFunc = function(aArg: Single): Single;
  TDoubleFunc = function(aArg: Double): Double;

  TSimplexVert = array [0 .. 5] of Single;
  { 0..2 - координаты сдвига, 3..5 - углы поворота вокруг осей }
  TSimplex = array of TSimplexVert;
  { Массив вершин симплекса }
  // TMapSimplexVert = array[0..2] of Single;     {0..2 - координаты сдвинутого узла}
  // TMapSimplex = array of TMapSimplexVert;  {Массив вершин симплекса}
  TROIContent = record
    Region: TRegion;
    Center: TIntPoint3D;
    Content: TIntPoint3DArr;
  end;

  TROIContentArr = array of TROIContent;
  TStringArr = array of String;

  THist = record
    MinVal, Step: Double;
    IntervCount: Integer;
    HistArr: TRealArray;
    Mean, StdDev: Single;
  end;

  THistArray = array of THist; { Массив гистограмм для группы ROI }

  TNetParams = record
    OriginPoint: TRealPoint3D; { Начальная точка сетки }
    NetDim: TIntPoint3D;
    { Количество узлов сетки по осям координат: 0: X, 1: Y, 2: Z. }
    NetStep: Smallint;
    { Расстояние между узлами сетки (одинаковое по всем осям) = количеству вокселей между узлами }
  end;

  TMapNet = record
    NetParams: TNetParams; { Параметры сетки }
    NetNodes: TRealPoint3DArr3D; { Узлы сетки }
  end;

  TNet2D = record { Сетка двумерная }
    NetDim: TIntPoint2D; { Размеры сетки: 0 - по оси X, 1 - по оси Y. }
    Net2DNodes: array of array of TPoint; { Узлы двумерной сетки (X, Y) }
  end;
  { TNet2D }
  TInspectROISeries = array of TChartSeries;

  TSegment = array [0 .. 1] of TRealPoint3D; { Отрезок с вещественными концами TSegment[0], TSegment[1] }
  TFacet = array [0 .. 1] of TSegment; { Четырехугольная грань с противоположными ребрами TFacet[0] и TFacet[1] }
  TCube = array [0 .. 1] of TFacet;
  { Шестигранник с противоположными гранями TCube[0] и TCube[1] }
  TNeighborCubes = array [0 .. 7] of TCube;
  TIcosahedronVert = array [0 .. 11] of TRealPoint3D;
  TIcoFaset = array [0 .. 2] of TRealPoint3D; { Треугольник - тройка вершин }
  TIcoFasets = array [0 .. 19] of TIcoFaset; { Треугольные грани икосаэдра }
  TDodecahedronDir = array [0 .. 19] of TRealPoint3D; { Массив векторов, определяемых векшинами додекаэдра }
  TNeighbProbs = array [0 .. 5] of TRealArray; { Вероятнтсти соседних ROI по каждому из 6 направлений: (0, 1) - по X; (2, 3) - по Y; (4, 5) - по Z, }
  TNeighbProbsArr = array of TNeighbProbs; { Массив вероятностей соседних ROI для каждой Inspected ROI. }
  TROIProbArr = array of array of array of TRealArray;
  { Массив вероятностей каждого (Inspected) ROI в каждом вокселе }
  TRGBRegion = array [0 .. 2] of array [0 .. 1] of Byte;  { Границы интенсивностей цветов: 0 - R, 1 - G, 2 - B; [*, 0] - Min, [*, 1] - Max. }

  THeaderKey = record // header key: off + size :
    SizeOfHDR: LongInt; // 0 + 4
    DataType: array [0 .. 9] of AnsiChar; // 4 + 10
    DBName: array [0 .. 17] of AnsiChar; // 14 + 18
    Extents: LongInt; // 32 + 4
    SessionError: Smallint; // 36 + 2
    Regular: AnsiChar; // 38 + 1
    HkeyUn0: AnsiChar; // 39 + 1
  end; // total=40 bytes

  TImageDimension = record // off + size
    Dim: array [0 .. 7] of Smallint; // 0 + 16       Int16
    Unused8: TSmallInt; // 16 + 2       VoxUnits
    Unused9: TSmallInt; // 18 + 2       VoxUnits
    Unused10: TSmallInt; // 20 + 2
    Unused11: TSmallInt; // 22 + 2
    Unused12: TSmallInt; // 24 + 2
    Unused13: TSmallInt; // 26 + 2
    Unused14: Smallint; // 28 + 2
    DataType: Smallint; // 30 + 2
    BitPix: Smallint; // 32 + 2
    DimUn0: Smallint; // 34 + 2
    PixDim: array [0 .. 7] of Single; // 36 + 32

    VoxOffset: Single; // 68 + 4
    Funused1: Single; // 72 + 4
    Funused2: Single; // 76 + 4
    Funused3: Single; // 80 + 4
    CalMax: Single; // 84 + 4
    CalMin: Single; // 88 + 4
    Compressed: Single; // 92 + 4
    Verified: Single; // 96 + 4
    Glmax, Glmin: LongInt; // 100 + 8
  end; // total=108 bytes

  TDataHistory = record // off + size
    Descrip: array [0 .. 79] of AnsiChar; // 0 + 80
    AuxFfile: array [0 .. 23] of AnsiChar; // 80 + 24
    Orient: AnsiChar; // 104 + 1
    Originator: array [0 .. 9] of AnsiChar; // 105 + 10
    Generated: array [0 .. 9] of AnsiChar; // 115 + 10
    Scannum: array [0 .. 9] of AnsiChar; // 125 + 10
    PatientID: array [0 .. 9] of AnsiChar; // 135 + 10
    ExpDate: array [0 .. 9] of AnsiChar; // 145 + 10
    ExpTime: array [0 .. 9] of AnsiChar; // 155 + 10
    HistUn0: array [0 .. 2] of AnsiChar; // 165 + 3
    Views: LongInt; // 168 + 4
    VolsAdded: LongInt; // 172 + 4
    StartField: LongInt; // 176 + 4
    FieldSkip: LongInt; // 180 + 4
    Omax, Omin: LongInt; // 184 + 8
    Smax, Smin: LongInt; // 192 + 8
  end;

  TDsr = record
    Hk: THeaderKey; // 0 + 40
    Dime: TImageDimension; // 40 + 108
    Hist: TDataHistory; // 148 + 200
  end;

const
  { Таблица расположения вершин треугольников на ребрах для кубов различных типоа. Последний элемент
    TriTable[*, 15] = количеству треугольников. }
  TriTable: array [0 .. 255] of array [0 .. 15] of Integer =
    ((-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0),
    (0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (0, 1, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (1, 8, 3, 9, 8, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (0, 8, 3, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (9, 2, 10, 0, 2, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (2, 8, 3, 2, 10, 8, 10, 9, 8, -1, -1, -1, -1, -1, -1, 3),
    (3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (0, 11, 2, 8, 11, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 9, 0, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 11, 2, 1, 9, 11, 9, 8, 11, -1, -1, -1, -1, -1, -1, 3),
    (3, 10, 1, 11, 10, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 10, 1, 0, 8, 10, 8, 11, 10, -1, -1, -1, -1, -1, -1, 3),
    (3, 9, 0, 3, 11, 9, 11, 10, 9, -1, -1, -1, -1, -1, -1, 3),
    (9, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (4, 3, 0, 7, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 1, 9, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 1, 9, 4, 7, 1, 7, 3, 1, -1, -1, -1, -1, -1, -1, 3),
    (1, 2, 10, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (3, 4, 7, 3, 0, 4, 1, 2, 10, -1, -1, -1, -1, -1, -1, 3),
    (9, 2, 10, 9, 0, 2, 8, 4, 7, -1, -1, -1, -1, -1, -1, 3),
    (2, 10, 9, 2, 9, 7, 2, 7, 3, 7, 9, 4, -1, -1, -1, 4),
    (8, 4, 7, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (11, 4, 7, 11, 2, 4, 2, 0, 4, -1, -1, -1, -1, -1, -1, 3),
    (9, 0, 1, 8, 4, 7, 2, 3, 11, -1, -1, -1, -1, -1, -1, 3),
    (4, 7, 11, 9, 4, 11, 9, 11, 2, 9, 2, 1, -1, -1, -1, 4),
    (3, 10, 1, 3, 11, 10, 7, 8, 4, -1, -1, -1, -1, -1, -1, 3),
    (1, 11, 10, 1, 4, 11, 1, 0, 4, 7, 11, 4, -1, -1, -1, 4),
    (4, 7, 8, 9, 0, 11, 9, 11, 10, 11, 0, 3, -1, -1, -1, 4),
    (4, 7, 11, 4, 11, 9, 9, 11, 10, -1, -1, -1, -1, -1, -1, 3),
    (9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (9, 5, 4, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 5, 4, 1, 5, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (8, 5, 4, 8, 3, 5, 3, 1, 5, -1, -1, -1, -1, -1, -1, 3),
    (1, 2, 10, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (3, 0, 8, 1, 2, 10, 4, 9, 5, -1, -1, -1, -1, -1, -1, 3),
    (5, 2, 10, 5, 4, 2, 4, 0, 2, -1, -1, -1, -1, -1, -1, 3),
    (2, 10, 5, 3, 2, 5, 3, 5, 4, 3, 4, 8, -1, -1, -1, 4),
    (9, 5, 4, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 11, 2, 0, 8, 11, 4, 9, 5, -1, -1, -1, -1, -1, -1, 3),
    (0, 5, 4, 0, 1, 5, 2, 3, 11, -1, -1, -1, -1, -1, -1, 3),
    (2, 1, 5, 2, 5, 8, 2, 8, 11, 4, 8, 5, -1, -1, -1, 4),
    (10, 3, 11, 10, 1, 3, 9, 5, 4, -1, -1, -1, -1, -1, -1, 3),
    (4, 9, 5, 0, 8, 1, 8, 10, 1, 8, 11, 10, -1, -1, -1, 4),
    (5, 4, 0, 5, 0, 11, 5, 11, 10, 11, 0, 3, -1, -1, -1, 4),
    (5, 4, 8, 5, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, 3),
    (9, 7, 8, 5, 7, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (9, 3, 0, 9, 5, 3, 5, 7, 3, -1, -1, -1, -1, -1, -1, 3),
    (0, 7, 8, 0, 1, 7, 1, 5, 7, -1, -1, -1, -1, -1, -1, 3),
    (1, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (9, 7, 8, 9, 5, 7, 10, 1, 2, -1, -1, -1, -1, -1, -1, 3),
    (10, 1, 2, 9, 5, 0, 5, 3, 0, 5, 7, 3, -1, -1, -1, 4),
    (8, 0, 2, 8, 2, 5, 8, 5, 7, 10, 5, 2, -1, -1, -1, 4),
    (2, 10, 5, 2, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, 3),
    (7, 9, 5, 7, 8, 9, 3, 11, 2, -1, -1, -1, -1, -1, -1, 3),
    (9, 5, 7, 9, 7, 2, 9, 2, 0, 2, 7, 11, -1, -1, -1, 4),
    (2, 3, 11, 0, 1, 8, 1, 7, 8, 1, 5, 7, -1, -1, -1, 4),
    (11, 2, 1, 11, 1, 7, 7, 1, 5, -1, -1, -1, -1, -1, -1, 3),
    (9, 5, 8, 8, 5, 7, 10, 1, 3, 10, 3, 11, -1, -1, -1, 4),
    (5, 7, 0, 5, 0, 9, 7, 11, 0, 1, 0, 10, 11, 10, 0, 5),
    (11, 10, 0, 11, 0, 3, 10, 5, 0, 8, 0, 7, 5, 7, 0, 5),
    (11, 10, 5, 7, 11, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (0, 8, 3, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (9, 0, 1, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 8, 3, 1, 9, 8, 5, 10, 6, -1, -1, -1, -1, -1, -1, 3),
    (1, 6, 5, 2, 6, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 6, 5, 1, 2, 6, 3, 0, 8, -1, -1, -1, -1, -1, -1, 3),
    (9, 6, 5, 9, 0, 6, 0, 2, 6, -1, -1, -1, -1, -1, -1, 3),
    (5, 9, 8, 5, 8, 2, 5, 2, 6, 3, 2, 8, -1, -1, -1, 4),
    (2, 3, 11, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (11, 0, 8, 11, 2, 0, 10, 6, 5, -1, -1, -1, -1, -1, -1, 3),
    (0, 1, 9, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1, -1, -1, 3),
    (5, 10, 6, 1, 9, 2, 9, 11, 2, 9, 8, 11, -1, -1, -1, 4),
    (6, 3, 11, 6, 5, 3, 5, 1, 3, -1, -1, -1, -1, -1, -1, 3),
    (0, 8, 11, 0, 11, 5, 0, 5, 1, 5, 11, 6, -1, -1, -1, 4),
    (3, 11, 6, 0, 3, 6, 0, 6, 5, 0, 5, 9, -1, -1, -1, 4),
    (6, 5, 9, 6, 9, 11, 11, 9, 8, -1, -1, -1, -1, -1, -1, 3),
    (5, 10, 6, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 3, 0, 4, 7, 3, 6, 5, 10, -1, -1, -1, -1, -1, -1, 3),
    (1, 9, 0, 5, 10, 6, 8, 4, 7, -1, -1, -1, -1, -1, -1, 3),
    (10, 6, 5, 1, 9, 7, 1, 7, 3, 7, 9, 4, -1, -1, -1, 4),
    (6, 1, 2, 6, 5, 1, 4, 7, 8, -1, -1, -1, -1, -1, -1, 3),
    (1, 2, 5, 5, 2, 6, 3, 0, 4, 3, 4, 7, -1, -1, -1, 4),
    (8, 4, 7, 9, 0, 5, 0, 6, 5, 0, 2, 6, -1, -1, -1, 4),
    (7, 3, 9, 7, 9, 4, 3, 2, 9, 5, 9, 6, 2, 6, 9, 5),
    (3, 11, 2, 7, 8, 4, 10, 6, 5, -1, -1, -1, -1, -1, -1, 3),
    (5, 10, 6, 4, 7, 2, 4, 2, 0, 2, 7, 11, -1, -1, -1, 4),
    (0, 1, 9, 4, 7, 8, 2, 3, 11, 5, 10, 6, -1, -1, -1, 4),
    (9, 2, 1, 9, 11, 2, 9, 4, 11, 7, 11, 4, 5, 10, 6, 5),
    (8, 4, 7, 3, 11, 5, 3, 5, 1, 5, 11, 6, -1, -1, -1, 4),
    (5, 1, 11, 5, 11, 6, 1, 0, 11, 7, 11, 4, 0, 4, 11, 5),
    (0, 5, 9, 0, 6, 5, 0, 3, 6, 11, 6, 3, 8, 4, 7, 5),
    (6, 5, 9, 6, 9, 11, 4, 7, 9, 7, 11, 9, -1, -1, -1, 4),
    (10, 4, 9, 6, 4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 10, 6, 4, 9, 10, 0, 8, 3, -1, -1, -1, -1, -1, -1, 3),
    (10, 0, 1, 10, 6, 0, 6, 4, 0, -1, -1, -1, -1, -1, -1, 3),
    (8, 3, 1, 8, 1, 6, 8, 6, 4, 6, 1, 10, -1, -1, -1, 4),
    (1, 4, 9, 1, 2, 4, 2, 6, 4, -1, -1, -1, -1, -1, -1, 3),
    (3, 0, 8, 1, 2, 9, 2, 4, 9, 2, 6, 4, -1, -1, -1, 4),
    (0, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (8, 3, 2, 8, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, 3),
    (10, 4, 9, 10, 6, 4, 11, 2, 3, -1, -1, -1, -1, -1, -1, 3),
    (0, 8, 2, 2, 8, 11, 4, 9, 10, 4, 10, 6, -1, -1, -1, 4),
    (3, 11, 2, 0, 1, 6, 0, 6, 4, 6, 1, 10, -1, -1, -1, 4),
    (6, 4, 1, 6, 1, 10, 4, 8, 1, 2, 1, 11, 8, 11, 1, 5),
    (9, 6, 4, 9, 3, 6, 9, 1, 3, 11, 6, 3, -1, -1, -1, 4),
    (8, 11, 1, 8, 1, 0, 11, 6, 1, 9, 1, 4, 6, 4, 1, 5),
    (3, 11, 6, 3, 6, 0, 0, 6, 4, -1, -1, -1, -1, -1, -1, 3),
    (6, 4, 8, 11, 6, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (7, 10, 6, 7, 8, 10, 8, 9, 10, -1, -1, -1, -1, -1, -1, 3),
    (0, 7, 3, 0, 10, 7, 0, 9, 10, 6, 7, 10, -1, -1, -1, 4),
    (10, 6, 7, 1, 10, 7, 1, 7, 8, 1, 8, 0, -1, -1, -1, 4),
    (10, 6, 7, 10, 7, 1, 1, 7, 3, -1, -1, -1, -1, -1, -1, 3),
    (1, 2, 6, 1, 6, 8, 1, 8, 9, 8, 6, 7, -1, -1, -1, 4),
    (2, 6, 9, 2, 9, 1, 6, 7, 9, 0, 9, 3, 7, 3, 9, 5),
    (7, 8, 0, 7, 0, 6, 6, 0, 2, -1, -1, -1, -1, -1, -1, 3),
    (7, 3, 2, 6, 7, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (2, 3, 11, 10, 6, 8, 10, 8, 9, 8, 6, 7, -1, -1, -1, 4),
    (2, 0, 7, 2, 7, 11, 0, 9, 7, 6, 7, 10, 9, 10, 7, 5),
    (1, 8, 0, 1, 7, 8, 1, 10, 7, 6, 7, 10, 2, 3, 11, 5),
    (11, 2, 1, 11, 1, 7, 10, 6, 1, 6, 7, 1, -1, -1, -1, 4),
    (8, 9, 6, 8, 6, 7, 9, 1, 6, 11, 6, 3, 1, 3, 6, 5),
    (0, 9, 1, 11, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (7, 8, 0, 7, 0, 6, 3, 11, 0, 11, 6, 0, -1, -1, -1, 4),
    (7, 11, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (3, 0, 8, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 1, 9, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (8, 1, 9, 8, 3, 1, 11, 7, 6, -1, -1, -1, -1, -1, -1, 3),
    (10, 1, 2, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 2, 10, 3, 0, 8, 6, 11, 7, -1, -1, -1, -1, -1, -1, 3),
    (2, 9, 0, 2, 10, 9, 6, 11, 7, -1, -1, -1, -1, -1, -1, 3),
    (6, 11, 7, 2, 10, 3, 10, 8, 3, 10, 9, 8, -1, -1, -1, 4),
    (7, 2, 3, 6, 2, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (7, 0, 8, 7, 6, 0, 6, 2, 0, -1, -1, -1, -1, -1, -1, 3),
    (2, 7, 6, 2, 3, 7, 0, 1, 9, -1, -1, -1, -1, -1, -1, 3),
    (1, 6, 2, 1, 8, 6, 1, 9, 8, 8, 7, 6, -1, -1, -1, 4),
    (10, 7, 6, 10, 1, 7, 1, 3, 7, -1, -1, -1, -1, -1, -1, 3),
    (10, 7, 6, 1, 7, 10, 1, 8, 7, 1, 0, 8, -1, -1, -1, 4),
    (0, 3, 7, 0, 7, 10, 0, 10, 9, 6, 10, 7, -1, -1, -1, 4),
    (7, 6, 10, 7, 10, 8, 8, 10, 9, -1, -1, -1, -1, -1, -1, 3),
    (6, 8, 4, 11, 8, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (3, 6, 11, 3, 0, 6, 0, 4, 6, -1, -1, -1, -1, -1, -1, 3),
    (8, 6, 11, 8, 4, 6, 9, 0, 1, -1, -1, -1, -1, -1, -1, 3),
    (9, 4, 6, 9, 6, 3, 9, 3, 1, 11, 3, 6, -1, -1, -1, 4),
    (6, 8, 4, 6, 11, 8, 2, 10, 1, -1, -1, -1, -1, -1, -1, 3),
    (1, 2, 10, 3, 0, 11, 0, 6, 11, 0, 4, 6, -1, -1, -1, 4),
    (4, 11, 8, 4, 6, 11, 0, 2, 9, 2, 10, 9, -1, -1, -1, 4),
    (10, 9, 3, 10, 3, 2, 9, 4, 3, 11, 3, 6, 4, 6, 3, 5),
    (8, 2, 3, 8, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, 3),
    (0, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 9, 0, 2, 3, 4, 2, 4, 6, 4, 3, 8, -1, -1, -1, 4),
    (1, 9, 4, 1, 4, 2, 2, 4, 6, -1, -1, -1, -1, -1, -1, 3),
    (8, 1, 3, 8, 6, 1, 8, 4, 6, 6, 10, 1, -1, -1, -1, 4),
    (10, 1, 0, 10, 0, 6, 6, 0, 4, -1, -1, -1, -1, -1, -1, 3),
    (4, 6, 3, 4, 3, 8, 6, 10, 3, 0, 3, 9, 10, 9, 3, 5),
    (10, 9, 4, 6, 10, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 9, 5, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 8, 3, 4, 9, 5, 11, 7, 6, -1, -1, -1, -1, -1, -1, 3),
    (5, 0, 1, 5, 4, 0, 7, 6, 11, -1, -1, -1, -1, -1, -1, 3),
    (11, 7, 6, 8, 3, 4, 3, 5, 4, 3, 1, 5, -1, -1, -1, 4),
    (9, 5, 4, 10, 1, 2, 7, 6, 11, -1, -1, -1, -1, -1, -1, 3),
    (6, 11, 7, 1, 2, 10, 0, 8, 3, 4, 9, 5, -1, -1, -1, 4),
    (7, 6, 11, 5, 4, 10, 4, 2, 10, 4, 0, 2, -1, -1, -1, 4),
    (3, 4, 8, 3, 5, 4, 3, 2, 5, 10, 5, 2, 11, 7, 6, 5),
    (7, 2, 3, 7, 6, 2, 5, 4, 9, -1, -1, -1, -1, -1, -1, 3),
    (9, 5, 4, 0, 8, 6, 0, 6, 2, 6, 8, 7, -1, -1, -1, 4),
    (3, 6, 2, 3, 7, 6, 1, 5, 0, 5, 4, 0, -1, -1, -1, 4),
    (6, 2, 8, 6, 8, 7, 2, 1, 8, 4, 8, 5, 1, 5, 8, 5),
    (9, 5, 4, 10, 1, 6, 1, 7, 6, 1, 3, 7, -1, -1, -1, 4),
    (1, 6, 10, 1, 7, 6, 1, 0, 7, 8, 7, 0, 9, 5, 4, 5),
    (4, 0, 10, 4, 10, 5, 0, 3, 10, 6, 10, 7, 3, 7, 10, 5),
    (7, 6, 10, 7, 10, 8, 5, 4, 10, 4, 8, 10, -1, -1, -1, 4),
    (6, 9, 5, 6, 11, 9, 11, 8, 9, -1, -1, -1, -1, -1, -1, 3),
    (3, 6, 11, 0, 6, 3, 0, 5, 6, 0, 9, 5, -1, -1, -1, 4),
    (0, 11, 8, 0, 5, 11, 0, 1, 5, 5, 6, 11, -1, -1, -1, 4),
    (6, 11, 3, 6, 3, 5, 5, 3, 1, -1, -1, -1, -1, -1, -1, 3),
    (1, 2, 10, 9, 5, 11, 9, 11, 8, 11, 5, 6, -1, -1, -1, 4),
    (0, 11, 3, 0, 6, 11, 0, 9, 6, 5, 6, 9, 1, 2, 10, 5),
    (11, 8, 5, 11, 5, 6, 8, 0, 5, 10, 5, 2, 0, 2, 5, 5),
    (6, 11, 3, 6, 3, 5, 2, 10, 3, 10, 5, 3, -1, -1, -1, 4),
    (5, 8, 9, 5, 2, 8, 5, 6, 2, 3, 8, 2, -1, -1, -1, 4),
    (9, 5, 6, 9, 6, 0, 0, 6, 2, -1, -1, -1, -1, -1, -1, 3),
    (1, 5, 8, 1, 8, 0, 5, 6, 8, 3, 8, 2, 6, 2, 8, 5),
    (1, 5, 6, 2, 1, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 3, 6, 1, 6, 10, 3, 8, 6, 5, 6, 9, 8, 9, 6, 5),
    (10, 1, 0, 10, 0, 6, 9, 5, 0, 5, 6, 0, -1, -1, -1, 4),
    (0, 3, 8, 5, 6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (10, 5, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (11, 5, 10, 7, 5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (11, 5, 10, 11, 7, 5, 8, 3, 0, -1, -1, -1, -1, -1, -1, 3),
    (5, 11, 7, 5, 10, 11, 1, 9, 0, -1, -1, -1, -1, -1, -1, 3),
    (10, 7, 5, 10, 11, 7, 9, 8, 1, 8, 3, 1, -1, -1, -1, 4),
    (11, 1, 2, 11, 7, 1, 7, 5, 1, -1, -1, -1, -1, -1, -1, 3),
    (0, 8, 3, 1, 2, 7, 1, 7, 5, 7, 2, 11, -1, -1, -1, 4),
    (9, 7, 5, 9, 2, 7, 9, 0, 2, 2, 11, 7, -1, -1, -1, 4),
    (7, 5, 2, 7, 2, 11, 5, 9, 2, 3, 2, 8, 9, 8, 2, 5),
    (2, 5, 10, 2, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, 3),
    (8, 2, 0, 8, 5, 2, 8, 7, 5, 10, 2, 5, -1, -1, -1, 4),
    (9, 0, 1, 5, 10, 3, 5, 3, 7, 3, 10, 2, -1, -1, -1, 4),
    (9, 8, 2, 9, 2, 1, 8, 7, 2, 10, 2, 5, 7, 5, 2, 5),
    (1, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 8, 7, 0, 7, 1, 1, 7, 5, -1, -1, -1, -1, -1, -1, 3),
    (9, 0, 3, 9, 3, 5, 5, 3, 7, -1, -1, -1, -1, -1, -1, 3),
    (9, 8, 7, 5, 9, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (5, 8, 4, 5, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, 3),
    (5, 0, 4, 5, 11, 0, 5, 10, 11, 11, 3, 0, -1, -1, -1, 4),
    (0, 1, 9, 8, 4, 10, 8, 10, 11, 10, 4, 5, -1, -1, -1, 4),
    (10, 11, 4, 10, 4, 5, 11, 3, 4, 9, 4, 1, 3, 1, 4, 5),
    (2, 5, 1, 2, 8, 5, 2, 11, 8, 4, 5, 8, -1, -1, -1, 4),
    (0, 4, 11, 0, 11, 3, 4, 5, 11, 2, 11, 1, 5, 1, 11, 5),
    (0, 2, 5, 0, 5, 9, 2, 11, 5, 4, 5, 8, 11, 8, 5, 5),
    (9, 4, 5, 2, 11, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (2, 5, 10, 3, 5, 2, 3, 4, 5, 3, 8, 4, -1, -1, -1, 4),
    (5, 10, 2, 5, 2, 4, 4, 2, 0, -1, -1, -1, -1, -1, -1, 3),
    (3, 10, 2, 3, 5, 10, 3, 8, 5, 4, 5, 8, 0, 1, 9, 5),
    (5, 10, 2, 5, 2, 4, 1, 9, 2, 9, 4, 2, -1, -1, -1, 4),
    (8, 4, 5, 8, 5, 3, 3, 5, 1, -1, -1, -1, -1, -1, -1, 3),
    (0, 4, 5, 1, 0, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (8, 4, 5, 8, 5, 3, 9, 0, 5, 0, 3, 5, -1, -1, -1, 4),
    (9, 4, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (4, 11, 7, 4, 9, 11, 9, 10, 11, -1, -1, -1, -1, -1, -1, 3),
    (0, 8, 3, 4, 9, 7, 9, 11, 7, 9, 10, 11, -1, -1, -1, 4),
    (1, 10, 11, 1, 11, 4, 1, 4, 0, 7, 4, 11, -1, -1, -1, 4),
    (3, 1, 4, 3, 4, 8, 1, 10, 4, 7, 4, 11, 10, 11, 4, 5),
    (4, 11, 7, 9, 11, 4, 9, 2, 11, 9, 1, 2, -1, -1, -1, 4),
    (9, 7, 4, 9, 11, 7, 9, 1, 11, 2, 11, 1, 0, 8, 3, 5),
    (11, 7, 4, 11, 4, 2, 2, 4, 0, -1, -1, -1, -1, -1, -1, 3),
    (11, 7, 4, 11, 4, 2, 8, 3, 4, 3, 2, 4, -1, -1, -1, 4),
    (2, 9, 10, 2, 7, 9, 2, 3, 7, 7, 4, 9, -1, -1, -1, 4),
    (9, 10, 7, 9, 7, 4, 10, 2, 7, 8, 7, 0, 2, 0, 7, 5),
    (3, 7, 10, 3, 10, 2, 7, 4, 10, 1, 10, 0, 4, 0, 10, 5),
    (1, 10, 2, 8, 7, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 9, 1, 4, 1, 7, 7, 1, 3, -1, -1, -1, -1, -1, -1, 3),
    (4, 9, 1, 4, 1, 7, 0, 8, 1, 8, 7, 1, -1, -1, -1, 4),
    (4, 0, 3, 7, 4, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (4, 8, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (9, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (3, 0, 9, 3, 9, 11, 11, 9, 10, -1, -1, -1, -1, -1, -1, 3),
    (0, 1, 10, 0, 10, 8, 8, 10, 11, -1, -1, -1, -1, -1, -1, 3),
    (3, 1, 10, 11, 3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (1, 2, 11, 1, 11, 9, 9, 11, 8, -1, -1, -1, -1, -1, -1, 3),
    (3, 0, 9, 3, 9, 11, 1, 2, 9, 2, 11, 9, -1, -1, -1, 4),
    (0, 2, 11, 8, 0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (3, 2, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (2, 3, 8, 2, 8, 10, 10, 8, 9, -1, -1, -1, -1, -1, -1, 3),
    (9, 10, 2, 0, 9, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (2, 3, 8, 2, 8, 10, 0, 1, 8, 1, 10, 8, -1, -1, -1, 4),
    (1, 10, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (1, 3, 8, 9, 1, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2),
    (0, 9, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (0, 3, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1),
    (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0));

const
  ZeroIntPoint3D: TIntPoint3D = (0, 0, 0);
  ZeroIntegerPoint3D: TIntegerPoint3D = (0, 0, 0);
  UnitIntPoint3D: TIntPoint3D = (1, 1, 1);
  ZeroIntPoint2D: TIntPoint2D = (0, 0);
  ZeroIntegerPoint2D: TIntegerPoint2D = (0, 0);
  ZeroRealPoint2D: TRealPoint2D = (0, 0);
  ZeroDoublePoint2D: TDoublePoint2D = (0, 0);
  ZeroRealPoint3D: TRealPoint3D = (0, 0, 0);
  ZeroDoublePoint3D: TDoublePoint3D = (0, 0, 0);
  ZeroDoublePoint4D: TDoublePoint4D = (0, 0, 0, 0);
  ZeroTPoint: TPoint = (X: 0; Y: 0);
  ZeroPoint3D: TRealPoint3D = (0, 0, 0);
  ZeroRegion: TRegion = ((0, 0, 0), (0, 0, 0));
  ZeroRegion2D: TRegion2D = ((0, 0), (0, 0));
  ZeroRealRegion2D: TRealRegion2D = ((0, 0), (0, 0));
  ZeroIntegerRegion2D: TIntegerRegion2D = ((0, 0), (0, 0));
  ShiftPoint6: array [0 .. 5] of TIntPoint3D =
    ((-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1));
  ZeroRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
  NegIntPoint2D: TIntPoint2D = (-1, -1);
  ZeroRGB: TRGB = (0, 0, 0);
  ZeroMatrix3: TMatr3 = ((0, 0, 0), (0, 0, 0), (0, 0, 0));

function Point3D(aX, aY, aZ: Smallint): TIntPoint3D; overload;
function Point3D(aPoint: TRealPoint3D): TIntPoint3D; overload;
function Point3D(aPoint: TDoublePoint3D): TRealPoint3D; overload;
function IntegerPoint3D(aX, aY, aZ: Integer): TIntegerPoint3D;
function RGBPoint(aRed, aGreen, aBlue: Byte): TRGB;
function DoublePoint3D(aX, aY, aZ: Double): TDoublePoint3D;
function DoublePoint2D(aX, aY: Double): TDoublePoint2D;
function IntegerPoint2D(aX, aY: Integer): TIntegerPoint2D;
function RealPoint3D(aX, aY, aZ: Single): TRealPoint3D; overload;
function RealPoint3D(aPoint: TIntPoint3D): TRealPoint3D; overload;
function MiddlePoint3D(aPoint1, aPoint2: TIntPoint3D): TIntPoint3D; overload;
function MiddlePoint3D(aPoint1, aPoint2: TRealPoint3D): TRealPoint3D; overload;
function Point2D(aX, aY: Smallint): TIntPoint2D; overload;
function Point2D(aX, aY: Integer): TIntegerPoint2D; overload;
function RealPoint2D(aX, aY: Single): TRealPoint2D;
function EqualIntPoint3D(const aPoint1, aPoint2: TIntPoint3D): Boolean; overload;
function EqualIntPoint3D(const aPoint1, aPoint2: TIntegerPoint3D): Boolean; overload;
function EqualPoint(const aPoint1, aPoint2: TVertex): Boolean; overload;
function EqualPoint(const aPoint1, aPoint2: TRealPoint3D): Boolean; overload;
function EqualPoint(const aPoint1, aPoint2: TIntPoint2D): Boolean; overload;
function IsZeroPoint(aPoint: TIntPoint3D): Boolean; overload;
function IsZeroPoint(aPoint: TIntegerPoint3D): Boolean; overload;
function IsZeroPoint(aPoint: TRealPoint3D): Boolean; overload;
function DiffTwoPoints(const aPoint1, aPoint2: TIntPoint3D): TIntPoint3D; overload;
function DiffTwoPoints(const aPoint1, aPoint2: TIntegerPoint3D): TIntegerPoint3D; overload;
function DiffTwoPoints(const aPoint1, aPoint2: TRealPoint3D): TRealPoint3D; overload;
function DiffTwoPoints(const aPoint1, aPoint2: TRealPoint2D): TRealPoint2D; overload;
function DiffTwoPoints(const aPoint1, aPoint2: TDoublePoint3D): TDoublePoint3D; overload;
function DiffTwoPoints(const aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D; overload;
function IsZeroRegion(const aRegion: TRegion): Boolean;
function SummTwoPoints(const aPoint1, aPoint2: TIntPoint3D): TIntPoint3D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TRealPoint3D): TRealPoint3D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TIntegerPoint3D): TIntegerPoint3D; overload;
function SummTwoPoints(const aPoint1: TIntPoint3D; aPoint2: TIntegerPoint3D): TIntegerPoint3D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TIntPoint2D): TIntPoint2D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TRealPoint2D): TRealPoint2D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TDoublePoint3D): TDoublePoint3D; overload;
function SummTwoPoints(const aPoint1, aPoint2: TDoublePoint2D): TDoublePoint2D; overload;
//function Region(aMinPoint, aMaxPoint: TIntPoint3D): TRegion; overload;
function Region(aMinPoint, aMaxPoint: TIntegerPoint3D): TRegion;
function ProdNumToColor(aLevel: Double; aColor: TColor): TColor;
function ProdNumToRGB(aLevel: Double; aRGB: TRGB): TRGB;
function RGBToColor(aRGB: TRGB): TColor;
function ColorToRGB(aColor: TColor): TRGB;
procedure SetStatusText(const aStatusBar: TStatusBar; PanelInd: Integer; aStatusText: String);
function PointInRect(aPoint: TPoint; aRect: TRect): Boolean;
function BlueRedColor(Value, MinValue, MaxValue: Single): TColor;
function ProdNumPoint(aNum: Single; const aPoint: TRealPoint3D): TRealPoint3D; overload;
function ProdNumPoint(aNum: Double; const aPoint: TDoublePoint3D): TDoublePoint3D; overload;
function ProdNumPoint(aNum: Single; const aPoint: TIntegerPoint3D): TRealPoint3D; overload;
function ProdNumPoint(aNum: Single; const aPoint: TRealPoint2D): TRealPoint2D; overload;
function ProdNumPoint(aNum: Double;  const aPoint: TDoublePoint2D): TDoublePoint2D; overload;
function NumInArray(aNum: Integer; const aArray: TIntArray): Boolean;
function DistPoints(const aPoint1, aPoint2: TIntPoint3D): Single; overload;
function DistPoints(const aPoint1, aPoint2: TRealPoint3D): Single; overload;
function DistPoints(const aPoint1, aPoint2: TIntPoint2D): Single; overload;
function DistPoints(const aPoint1, aPoint2: TIntegerPoint2D): Single; overload;
function MultMatr3(const aMatr1, aMatr2: TMatr3): TMatr3; overload;
function MultMatr3(const aMatr1, aMatr2: TMatr3Double): TMatr3Double; overload;
function MultMatr3Vect(const aMatr: TMatr3; const aVect: TRealPoint3D): TRealPoint3D; overload;
function MultMatr3Vect(const aMatr: TMatr3; const aVect: TDoublePoint3D): TRealPoint3D; overload;
function MultMatr3Vect(const aMatr: TMatr3Double; const aVect: TDoublePoint3D): TDoublePoint3D; overload;
function DivIntPoint(const aPoint: TIntPoint3D; aNum: Single): TIntPoint3D; overload;
function DivIntPoint(aPoint: TIntegerPoint3D; aNum: Single): TIntPoint3D; overload;
function RoundRealPoint3D(const aRealPoint: TRealPoint3D; aImgDim: TIntPoint3D): TIntPoint3D; overload;
function RoundRealPoint3D(const aRealPoint: TRealPoint3D): TIntPoint3D; overload;
function MinMaxForArray(const aArray: TRealArray): TDoublePoint2D; overload;
function MinMaxForArray(const aArray: TImgArray): TDoublePoint2D; overload;
function MinMaxForArray(const aArray: TByteArray): TIntPoint2D; overload;
function MinMaxForArray(const aArray: TIntArray): TIntegerPoint2D; overload;
function MinMaxForArray(const aArray: TDoubleArray): TDoublePoint2D; overload;
function MinMaxForDoubleArray(const aArray: TDoubleArray2D): TDoublePoint2D;
function DimOfArray(const aArray: TImgArray): TIntPoint3D; overload;
// function DimOfArray(const aArray: TNormImgArray): TIntPoint3D; overload;
function ReducedHue(aVal: Single): Single;
function HSVToRGB(aHue, aSatur, aBright: Single): TRGB;
function HSVToColor(aHue, aSatur, aBright: Single): TColor;
function MinPoint(aPoint1, aPoint2: TIntPoint3D): TIntPoint3D; overload;
function MinPoint(aPoint1, aPoint2: TIntPoint2D): TIntPoint2D; overload;
function MinPoint(aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D; overload;
function MaxPoint(aPoint1, aPoint2: TIntPoint3D): TIntPoint3D; overload;
function MaxPoint(aPoint1, aPoint2: TIntPoint2D): TIntPoint2D; overload;
function MaxPoint(aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D; overload;
function SqDistPoints(const aPoint1, aPoint2: TIntPoint3D): Single; overload;
function SqDistPoints(const aPoint1, aPoint2: TIntegerPoint2D): Single; overload;
function SqDistRGB(const aPoint1, aPoint2: TRGB): Double;
function GaussDistr(X, aMean, aStdDev: Single): Double;
function GaussDensity(aMean, aStdDev: Single): TRealArray;
function IcosahedronVert: TIcosahedronVert;
function IcosahedronFasets: TIcoFasets;
procedure NormalizeVect(var aVect: TRealPoint3D);
function NormVect(const aVect: TRealPoint3D): Single; overload;
function NormVect(const aVect: TDoublePoint3D): Double; overload;
function NormVect(const aVect: TDoubleArray): Double; overload;
function NormVect(const aVect: TDoublePoint2D): Double; overload;
function NormVect(const aVect: TRealPoint2D): Single; overload;
function DodecahedronDir: TDodecahedronDir;
function InspectRegion(const aRegion: TRegion; aBonus: Smallint; aImgDim: TIntPoint3D): TRegion;
function MaxArrayValue(const aArray: TRealArray2D): Single; overload;
function MaxArrayValue(const aArray: TRealArray): Single; overload;
function MaxArrayValue(const aArray: TDoubleArray): Double; overload;
function MinRealPoint(aPoint1, aPoint2: TRealPoint2D): TRealPoint2D;
function MaxRealPoint(aPoint1, aPoint2: TRealPoint2D): TRealPoint2D;
function ArgGaussDistr(aVal, aMean, aStdDev: Single): Double;
function ScalarProd3D(aVect1, aVect2: TRealPoint3D): Single;
function ScalarProdVect(aVect1, aVect2: TDoubleArray): Double;
function VectProd(const Vect1, Vect2: TRealPoint3D): TRealPoint3D; overload;
function VectProd(const Vect1, Vect2: TDoublePoint3D): TDoublePoint3D; overload;
function Det2(a11, a12, a21, a22: Double): Double;
function DetMatr2D(const aMatr: TMatr2): Double;
function Det3(const aMatrix: TMatr3): Double;
function TransposedMatrix(const aMatrix: TMatr3): TMatr3; overload;
function TransposedMatrix(const aMatrix: TMatr3Double): TMatr3Double; overload;
function TransposedMatrix(const aMatrix: TDoubleArray2D): TDoubleArray2D; overload;
function TransposedMatrix(const aMatrix: TDoubleArrayArr): TDoubleArrayArr; overload;
function SimpsonIntegral(const aFunc: TDoubleFunc; aInit, aTerm, aStep: Double; aNmin: Integer): Double;
function MultMatr(const aMatr1, aMatr2: TDoubleArray2D): TDoubleArray2D; overload;
function MultMatr(const aMatr1, aMatr2: TDoubleArrayArr): TDoubleArrayArr; overload;
function MultMatrColumn(const aMatr: TDoubleArray2D; const aColumn: TDoubleArray): TDoubleArray;
function SVD(var aMatr: TDoubleArrayArr; m, n: Integer; var W: TDoubleArray; var V: TDoubleArrayArr): Boolean;
function AssignMatrix(const aSource: TDoubleArray2D): TDoubleArray2D;
function CMult(aCNum1, aCNum2: TDoublePoint2D): TDoublePoint2D;
function CSum(aCNum1, aCNum2: TDoublePoint2D): TDoublePoint2D;
function CDiff(aCNum1, aCNum2: TDoublePoint2D): TDoublePoint2D;
function RCMult(aRNum: Double; aCNum: TDoublePoint2D): TDoublePoint2D;
function NCMult(aNum: Integer; aCNum: TDoublePoint2D): TDoublePoint2D;
function CNum(aX, aY: Double): TDoublePoint2D;
function CMod(aCNum: TDoublePoint2D): Double;

implementation

function Point3D(aX, aY, aZ: Smallint): TIntPoint3D;
begin
  Result[0] := aX;
  Result[1] := aY;
  Result[2] := aZ;
end; { Point3D }

function Point3D(aPoint: TRealPoint3D): TIntPoint3D;
var i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := Round(aPoint[i]);
end; { Point3D }

function Point3D(aPoint: TDoublePoint3D): TRealPoint3D;
var i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint[i];
end; { Point3D }

function IntegerPoint3D(aX, aY, aZ: Integer): TIntegerPoint3D;
begin
  Result[0] := aX;
  Result[1] := aY;
  Result[2] := aZ;
end; { IntegerPoint3D }

function RGBPoint(aRed, aGreen, aBlue: Byte): TRGB;
begin
  Result[0] := aRed;
  Result[1] := aGreen;
  Result[2] := aBlue;
end; { RGBPoint }

function DoublePoint3D(aX, aY, aZ: Double): TDoublePoint3D;
begin
  Result[0] := aX;
  Result[1] := aY;
  Result[2] := aZ;
end; { DoublePoint3D }

function DoublePoint2D(aX, aY: Double): TDoublePoint2D;
begin
  Result[0] := aX;
  Result[1] := aY;
end; { DoublePoint2D }

function IntegerPoint2D(aX, aY: Integer): TIntegerPoint2D;
begin
  Result[0] := aX;
  Result[1] := aY;
end; { Point2D }

function RealPoint3D(aX, aY, aZ: Single): TRealPoint3D;
begin
  Result[0] := aX;
  Result[1] := aY;
  Result[2] := aZ;
end; { RealPoint3D }

function RealPoint3D(aPoint: TIntPoint3D): TRealPoint3D;
begin
  Result[0] := aPoint[0];
  Result[1] := aPoint[1];
  Result[2] := aPoint[2];
end; { RealPoint3D }

function MiddlePoint3D(aPoint1, aPoint2: TIntPoint3D): TIntPoint3D;
{ Возвращает среднюю точку между aPoint1 и aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := (aPoint1[i] + aPoint2[i]) div 2;
end; { MiddlePoint3D }

function MiddlePoint3D(aPoint1, aPoint2: TRealPoint3D): TRealPoint3D;
{ Возвращает среднюю точку между aPoint1 и aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := 0.5 * (aPoint1[i] + aPoint2[i]);
end; { MiddlePoint3D }

function Point2D(aX, aY: Smallint): TIntPoint2D;
begin
  Result[0] := aX;
  Result[1] := aY;
end; { Point2D }

function Point2D(aX, aY: Integer): TIntegerPoint2D;
begin
  Result[0] := aX;
  Result[1] := aY;
end; { Point2D }

function RealPoint2D(aX, aY: Single): TRealPoint2D;
begin
  Result[0] := aX;
  Result[1] := aY;
end; { RealPoint2D }

function EqualIntPoint3D(const aPoint1, aPoint2: TIntPoint3D): Boolean;
{ Если aPoint1 = aPoint2, то Result = True }
var
  i: Integer;
begin
  Result := True;
  for i := 0 to 2 do
    if aPoint1[i] <> aPoint2[i] then
    begin
      Result := False;
      exit;
    end;
end; { EqualIntPoint3D }

function EqualIntPoint3D(const aPoint1, aPoint2: TIntegerPoint3D): Boolean;
{ Если aPoint1 = aPoint2, то Result = True }
var
  i: Integer;
begin
  Result := True;
  for i := 0 to 2 do
    if aPoint1[i] <> aPoint2[i] then
    begin
      Result := False;
      exit;
    end;
end; { EqualIntPoint3D }

function EqualPoint(const aPoint1, aPoint2: TVertex): Boolean;
{ Если aPoint1 = aPoint2, то Result = True }
var
  i: Integer;
begin
  Result := True;
  for i := 0 to 2 do
    if Abs(aPoint1[i] - aPoint2[i]) > 1E-6 then
    begin
      Result := False;
      exit;
    end;
end; { EqualPoint }

function EqualPoint(const aPoint1, aPoint2: TRealPoint3D): Boolean;
{ Если aPoint1 = aPoint2, то Result = True }
var
  i: Integer;
begin
  Result := True;
  for i := 0 to 2 do
    if Abs(aPoint1[i] - aPoint2[i]) > 1E-6 then
    begin
      Result := False;
      exit;
    end;
end; { EqualPoint }

function EqualPoint(const aPoint1, aPoint2: TIntPoint2D): Boolean;
{ Если aPoint1 = aPoint2, то Result = True }
begin
  Result := (aPoint1[0] = aPoint2[0]) and (aPoint1[1] = aPoint2[1]);
end; { EqualPoint }

function IsZeroPoint(aPoint: TIntPoint3D): Boolean;
{ Если aPoint = ZeroIntPoint3D, то Result = True }
begin
  Result := EqualIntPoint3D(aPoint, ZeroIntPoint3D);
end; { IsZeroRegion }

function IsZeroPoint(aPoint: TIntegerPoint3D): Boolean;
{ Если aPoint = ZeroIntPoint3D, то Result = True }
begin
  Result := EqualIntPoint3D(aPoint, ZeroIntegerPoint3D);
end; { IsZeroRegion }

function IsZeroPoint(aPoint: TRealPoint3D): Boolean;
begin
  Result := EqualPoint(aPoint, ZeroRealPoint3D);
end; { IsZeroPoint }

function DiffTwoPoints(const aPoint1, aPoint2: TIntPoint3D): TIntPoint3D;
{ Returns a difference of two real points: aPoint1 - aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] - aPoint2[i];
end; { DiffTwoPoints }

function DiffTwoPoints(const aPoint1, aPoint2: TIntegerPoint3D): TIntegerPoint3D;
{ Returns a difference of two real points: aPoint1 - aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] - aPoint2[i];
end; { DiffTwoPoints }

function DiffTwoPoints(const aPoint1, aPoint2: TRealPoint3D): TRealPoint3D;
{ Returns a difference of two real points: aPoint1 - aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] - aPoint2[i];
end; { DiffTwoPoints }

function DiffTwoPoints(const aPoint1, aPoint2: TDoublePoint3D): TDoublePoint3D;
{ Returns a difference of two real points: aPoint1 - aPoint2 }
var i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] - aPoint2[i];
end; { DiffTwoPoints }

function DiffTwoPoints(const aPoint1, aPoint2: TRealPoint2D): TRealPoint2D;
{ Returns a difference of two real points: aPoint1 - aPoint2 }
begin
  Result[0] := aPoint1[0] - aPoint2[0];
  Result[1] := aPoint1[1] - aPoint2[1];
end; { DiffTwoPoints }

function DiffTwoPoints(const aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D;
{ Returns a difference of two real points: aPoint1 - aPoint2 }
begin
  Result[0] := aPoint1[0] - aPoint2[0];
  Result[1] := aPoint1[1] - aPoint2[1];
end; { DiffTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TIntPoint3D): TIntPoint3D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] + aPoint2[i];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TRealPoint3D): TRealPoint3D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] + aPoint2[i];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TDoublePoint3D): TDoublePoint3D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
var i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] + aPoint2[i];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TIntegerPoint3D): TIntegerPoint3D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] + aPoint2[i];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1: TIntPoint3D; aPoint2: TIntegerPoint3D): TIntegerPoint3D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := aPoint1[i] + aPoint2[i];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TIntPoint2D): TIntPoint2D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
begin
  Result[0] := aPoint1[0] + aPoint2[0];
  Result[1] := aPoint1[1] + aPoint2[1];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
begin
  Result[0] := aPoint1[0] + aPoint2[0];
  Result[1] := aPoint1[1] + aPoint2[1];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TRealPoint2D): TRealPoint2D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
begin
  Result[0] := aPoint1[0] + aPoint2[0];
  Result[1] := aPoint1[1] + aPoint2[1];
end; { SummTwoPoints }

function SummTwoPoints(const aPoint1, aPoint2: TDoublePoint2D): TDoublePoint2D;
{ Returns a sum of two points: aPoint1 and aPoint2 }
begin
  Result[0] := aPoint1[0] + aPoint2[0];
  Result[1] := aPoint1[1] + aPoint2[1];
end; { SummTwoPoints }

function IsZeroRegion(const aRegion: TRegion): Boolean;
{ Если aRegion[0] = aRegion[1], то Result = True }
var aDiffPoint: TIntegerPoint3D;
begin
  aDiffPoint := DiffTwoPoints(aRegion[1], aRegion[0]);
  Result := IsZeroPoint(aDiffPoint);
end; { IsZeroRegion }

{function Region(aMinPoint, aMaxPoint: TIntPoint3D): TRegion;
begin
  Result[0] := aMinPoint;
  Result[1] := aMaxPoint;
end; { { Region }

function Region(aMinPoint, aMaxPoint: TIntegerPoint3D): TRegion;
begin
  Result[0] := aMinPoint;
  Result[1] := aMaxPoint;
end; { Region }

function ProdNumToColor(aLevel: Double; aColor: TColor): TColor;
{ Returns the result of multiplying Level by Color }
begin
  Result := RGBToColor(ProdNumToRGB(aLevel, ColorToRGB(aColor)));
end; { ProdNumToColor }

function ProdNumToRGB(aLevel: Double; aRGB: TRGB): TRGB;
{ Returns the result of multiplying Level by RGB vector }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := Max(0, Min($FF, Round(aLevel * aRGB[i])));
end; { ProdNumToRGB }

function RGBToColor(aRGB: TRGB): TColor;
{ Returns colors that have main components from RGB intensity }
begin
  Result := aRGB[0] + aRGB[1] * $100 + aRGB[2] * $10000;
end; { RGBToColor }

function ColorToRGB(aColor: TColor): TRGB;
{ Returns intensities of main color components Color }
begin
  Result[0] := aColor mod $100; { Intensity of red }
  Result[1] := (aColor div $100) mod $100; { Intensity of green }
  Result[2] := aColor div $10000; { intensity of blue }
end; { ColorToRGB }

procedure SetStatusText(const aStatusBar: TStatusBar; PanelInd: Integer; aStatusText: String);
begin
  if aStatusBar = nil then
    exit;
  if PanelInd > aStatusBar.Panels.Count - 1 then
    exit;
  if Trim(aStatusText) = '' then
    aStatusBar.Panels[PanelInd].Width := 50
  else
    aStatusBar.Panels[PanelInd].Width := aStatusBar.Canvas.TextWidth
      (aStatusText) + 20;
  aStatusBar.Panels[PanelInd].Text := aStatusText;
end; { SetStatusText }

function PointInRect(aPoint: TPoint; aRect: TRect): Boolean;
{ Если точка aPoint внутри прямоугольника aRect, то Result = True }
begin
  Result := (aPoint.X > aRect.Left + 1) and (aPoint.X < aRect.Right - 1) and
    (aPoint.Y > aRect.Top + 1) and (aPoint.Y < aRect.Bottom - 1);
end; { PointInRect }

function BlueRedColor(Value, MinValue, MaxValue: Single): TColor;
{ Возвращает цвет "тепловой" карты, соответствующий значению Value, заключенному между MinValue и MaxValue.
  Цвет вычисляется путем линейной интерполяции между Blue (минимальным) и Red (максимальным) со средним - White }
var
  MidValue, Coeff: Real;
begin
  Result := clWhite;
  MidValue := 0.5 * (MinValue + MaxValue);
  if (MaxValue - MinValue) < Max(0.000001 * MidValue, 0.0001) then
    exit;
  Value := Min(Max(Value, MinValue), MaxValue);
  if Value < MidValue then
  begin { Оттенок синего: }
    Coeff := (Value - MinValue) / (MidValue - MinValue);
    // Result:= $FF0000 + Round(Coeff * $FF) + Round(Coeff * $FF)*$100;
    Result := $FF0000 + Round(Coeff * $FF) * $101;
  end
  else
  begin { Оттенок красного: }
    Coeff := (MaxValue - Value) / (MaxValue - MidValue);
    // Result:= $FF + Round(Coeff * $FF)*$100 + Round(Coeff * $FF)*$10000;
    Result := $FF + Round(Coeff * $FF) * $10100;
  end;
end; { BlueRedColor }

function ProdNumPoint(aNum: Single; const aPoint: TRealPoint3D): TRealPoint3D;
{ Возвращает произведение точки aPoint на число aNum. }
var
  i: Byte;
begin
  for i := 0 to 2 do
    Result[i] := aNum * aPoint[i];
end; { ProdNumPoint }

function ProdNumPoint(aNum: Double; const aPoint: TDoublePoint3D): TDoublePoint3D;
{ Возвращает произведение точки aPoint на число aNum. }
var
  i: Byte;
begin
  for i := 0 to 2 do
    Result[i] := aNum * aPoint[i];
end; { ProdNumPoint }

function ProdNumPoint(aNum: Single; const aPoint: TIntegerPoint3D)
  : TRealPoint3D;
{ Возвращает произведение точки aPoint на число aNum. }
var
  i: Byte;
begin
  for i := 0 to 2 do
    Result[i] := aNum * aPoint[i];
end; { ProdNumPoint }

function ProdNumPoint(aNum: Double;  const aPoint: TDoublePoint2D): TDoublePoint2D;
{ Возвращает произведение точки aPoint на число aNum. }
begin
  Result[0] := aNum * aPoint[0];
  Result[1] := aNum * aPoint[1];
end; { ProdNumPoint }

function ProdNumPoint(aNum: Single; const aPoint: TRealPoint2D): TRealPoint2D;
{ Возвращает произведение точки aPoint на число aNum. }
begin
  Result[0] := aNum * aPoint[0];
  Result[1] := aNum * aPoint[1];
end; { ProdNumPoint }

function DivIntPoint(const aPoint: TIntPoint3D; aNum: Single): TIntPoint3D;
{ Возвращает произведение точки aPoint на число 1/aNum. }
var
  i: Byte;
begin
  for i := 0 to 2 do
    Result[i] := Round(aPoint[i] / aNum);
end; { ProdNumPoint }

function DivIntPoint(aPoint: TIntegerPoint3D; aNum: Single): TIntPoint3D;
{ Возвращает произведение точки aPoint на число 1/aNum. }
var
  i: Byte;
begin
  for i := 0 to 2 do
    Result[i] := Round(aPoint[i] / aNum);
end; { ProdNumPoint }

function NumInArray(aNum: Integer; const aArray: TIntArray): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to Length(aArray) - 1 do
    if aNum = aArray[i] then  begin
      Result := True;
      exit;
    end;
end; { NumInArray }

function DistPoints(const aPoint1, aPoint2: TIntPoint3D): Single;
{ Возвращает расстояние между точками aPoint1, aPoint2 }
var
  i: Integer;
  aTemp: Double;
begin
  Result := 0;
  for i := 0 to 2 do
  begin
    aTemp := aPoint1[i] - aPoint2[i];
    Result := Result + aTemp * aTemp;
  end;
  Result := Sqrt(Result);
end; { DistPoints }

function DistPoints(const aPoint1, aPoint2: TRealPoint3D): Single;
{ Возвращает расстояние между точками aPoint1, aPoint2 }
var
  i: Integer;
  aTemp: Double;
begin
  Result := 0;
  for i := 0 to 2 do
  begin
    aTemp := aPoint1[i] - aPoint2[i];
    Result := Result + aTemp * aTemp;
  end;
  Result := Sqrt(Result);
end; { DistPoints }

function DistPoints(const aPoint1, aPoint2: TIntPoint2D): Single;
{ Возвращает расстояние между точками aPoint1, aPoint2 }
var
  i: Integer;
  aTemp: Single;
begin
  Result := 0;
  for i := 0 to 1 do
  begin
    aTemp := aPoint1[i] - aPoint2[i];
    Result := Result + aTemp * aTemp;
  end;
  Result := Sqrt(Result);
end; { DistPoints }

function DistPoints(const aPoint1, aPoint2: TIntegerPoint2D): Single;
 { Возвращает расстояние между точками aPoint1, aPoint2 }
var i: Integer;
    aTemp: Single;
begin
  Result := 0;
  for i := 0 to 1 do begin
    aTemp := aPoint1[i] - aPoint2[i];
    Result := Result + aTemp * aTemp;
  end;
  Result := Sqrt(Result);
end; { DistPoints }

function SqDistPoints(const aPoint1, aPoint2: TIntPoint3D): Single;
{ Возвращает квадрат расстояния между точками aPoint1, aPoint2 }
var
  i: Integer;
  aTemp: Double;
begin
  Result := 0;
  for i := 0 to 2 do
  begin
    aTemp := aPoint1[i] - aPoint2[i];
    Result := Result + aTemp * aTemp;
  end;
end; { SqDistPoints }

function SqDistPoints(const aPoint1, aPoint2: TIntegerPoint2D): Single;
{ Возвращает квадрат расстояния между точками aPoint1, aPoint2 }
var i: Integer;
    aTemp: Double;
begin
  Result := 0;
  for i := 0 to 1 do begin
    aTemp := aPoint1[i] - aPoint2[i];
    Result := Result + aTemp * aTemp;
  end;
end; { SqDistPoints }

function SqDistRGB(const aPoint1, aPoint2: TRGB): Double;
{ Возвращает квадрат расстояния между точками aPoint1, aPoint2 }
var i: Integer;
    aTemp: Double;
begin
  Result:= 0;
  for i:= 0 to 2 do begin
    aTemp:= aPoint1[i] - aPoint2[i];
    Result:= Result + aTemp * aTemp;
  end;
end; { SqDistPoints }

function MultMatr3(const aMatr1, aMatr2: TMatr3): TMatr3;
{ Возвращает произведение матриц aMatr1*aMatr2 }
var
  i, j, k: Integer;
  Temp: Double;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do
    begin
      Temp := 0;
      for k := 0 to 2 do
        Temp := Temp + aMatr1[i, k] * aMatr2[k, j];
      Result[i, j] := Temp;
    end;
end; { MultMatr3 }

function MultMatr3(const aMatr1, aMatr2: TMatr3Double): TMatr3Double;
{ Возвращает произведение матриц aMatr1*aMatr2 }
var i, j, k: Integer;
    Temp: Double;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do begin
      Temp := 0;
      for k := 0 to 2 do
        Temp := Temp + aMatr1[i, k] * aMatr2[k, j];
      Result[i, j] := Temp;
    end;
end; { MultMatr3 }

function MultMatr3Vect(const aMatr: TMatr3; const aVect: TRealPoint3D): TRealPoint3D;
{ Returns multiplication of matrix aMatr by point aVect }
var
  i, j: Integer;
  Temp: Double;
begin
  for i := 0 to 2 do
  begin
    Temp := 0;
    for j := 0 to 2 do
      Temp := Temp + aMatr[i, j] * aVect[j];
    Result[i] := Temp;
  end;
end; { MultMatr3Point }

function MultMatr3Vect(const aMatr: TMatr3; const aVect: TDoublePoint3D): TRealPoint3D;
{ Returns multiplication of matrix aMatr by point aVect }
var i, j: Integer;
  Temp: Double;
begin
  for i := 0 to 2 do
  begin
    Temp := 0;
    for j := 0 to 2 do
      Temp := Temp + aMatr[i, j] * aVect[j];
    Result[i] := Temp;
  end;
end; { MultMatr3Point }

function MultMatr3Vect(const aMatr: TMatr3Double; const aVect: TDoublePoint3D): TDoublePoint3D;
{ Returns multiplication of matrix aMatr by point aVect }
var i, j: Integer;
    Temp: Double;
begin
  for i := 0 to 2 do
  begin
    Temp := 0;
    for j := 0 to 2 do
      Temp := Temp + aMatr[i, j] * aVect[j];
    Result[i] := Temp;
  end;
end; { MultMatr3Point }

function RoundRealPoint3D(const aRealPoint: TRealPoint3D; aImgDim: TIntPoint3D): TIntPoint3D;
{ Конвертирует вещественную точку в целую с проверкой границ }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := Min(aImgDim[i] - 1, Max(0, Round(aRealPoint[i])));
end; { RoundRealPoint3D }

function RoundRealPoint3D(const aRealPoint: TRealPoint3D): TIntPoint3D;
{ Конвертирует вещественную точку в целую с проверкой границ }
var
  i: Integer;
begin
  for i := 0 to 2 do
    Result[i] := Round(aRealPoint[i]);
end; { RoundRealPoint3D }

function MinMaxForArray(const aArray: TRealArray): TDoublePoint2D;
{ Возвращает минимальное и максимальное значения в массиве aArray. Result[0]: Min, Result[1]: Max }
var
  i, aLen: Integer;
  aTemp: Single;
begin
  Result := ZeroDoublePoint2D;
  if aArray = nil then
    exit;
  aLen := Length(aArray);
  Result[0] := aArray[0];
  Result[1] := Result[0];
  for i := 1 to aLen - 1 do
  begin
    aTemp := aArray[i];
    Result[0] := Min(aTemp, Result[0]);
    Result[1] := Max(aTemp, Result[1]);
  end;
end; { MinMaxForArray }

function MinMaxForArray(const aArray: TImgArray): TDoublePoint2D;
{ Возвращает минимальное и максимальное значения в массиве aArray. Result[0]: Min, Result[1]: Max }
var
  i, j, k: Integer;
  aTemp: Single;
  aImgDim: TIntPoint3D;
begin
  Result := ZeroDoublePoint2D;
  if aArray = nil then
    exit;
  aImgDim := DimOfArray(aArray);
  Result[0] := aArray[0, 0, 0];
  Result[1] := Result[0];
  for k := 0 to aImgDim[2] - 1 do
    for j := 0 to aImgDim[1] - 1 do
      for i := 0 to aImgDim[0] - 1 do
      begin
        aTemp := aArray[k, j, i];
        Result[0] := Min(aTemp, Result[0]);
        Result[1] := Max(aTemp, Result[1]);
      end;
end; { MinMaxForArray }

function MinMaxForDoubleArray(const aArray: TDoubleArray2D): TDoublePoint2D;
{ Возвращает минимальное и максимальное значения в массиве aArray. Result[0]: Min, Result[1]: Max }
var i, j: Integer;
    aTemp: Double;
begin
  Result := ZeroDoublePoint2D;
  if aArray = nil then
    Exit;
  Result[0] := aArray[0, 0];
  Result[1] := Result[0];
  for i:= 0 to Length(aArray) - 1 do
    for j := 0 to Length(aArray[0]) - 1 do begin
      aTemp := aArray[i, j];
      Result[0]:= Min(aTemp, Result[0]);
      Result[1]:= Max(aTemp, Result[1]);
    end;
end; { MinMaxForDoubleArray }

function MinMaxForArray(const aArray: TIntArray): TIntegerPoint2D;
{ Возвращает минимальное и максимальное значения в массиве aArray. Result[0]: Min, Result[1]: Max }
var i, aTemp: Integer;
begin
  Result := ZeroIntegerPoint2D;
  if aArray = nil then Exit;
  Result[0] := aArray[0];
  Result[1] := Result[0];
  for i := 1 to Length(aArray) - 1 do begin
    aTemp := aArray[i];
    Result[0] := Min(aTemp, Result[0]);
    Result[1] := Max(aTemp, Result[1]);
  end;
end; { MinMaxForArray }

function MinMaxForArray(const aArray: TDoubleArray): TDoublePoint2D;
{ Возвращает минимальное и максимальное значения в массиве aArray. Result[0]: Min, Result[1]: Max }
var i: Integer;
    aTemp: Double;
begin
  Result:= ZeroDoublePoint2D;
  if aArray = nil then Exit;
  Result[0]:= aArray[0];
  Result[1]:= Result[0];
  for i:= 1 to Length(aArray) - 1 do begin
    aTemp:= aArray[i];
    Result[0]:= Min(aTemp, Result[0]);
    Result[1]:= Max(aTemp, Result[1]);
  end;
end;

function MinMaxForArray(const aArray: TByteArray): TIntPoint2D;
{ Возвращает минимальное и максимальное значения в массиве aArray. Result[0]: Min, Result[1]: Max }
var
  i: Integer;
  aTemp: Byte;
begin
  Result := ZeroIntPoint2D;
  if aArray = nil then
    exit;
  Result[0] := aArray[0];
  Result[1] := Result[0];
  for i := 1 to Length(aArray) - 1 do begin
    aTemp := aArray[i];
    Result[0] := Min(aTemp, Result[0]);
    Result[1] := Max(aTemp, Result[1]);
  end;
end; { MinMaxForArray }

function DimOfArray(const aArray: TImgArray): TIntPoint3D;
begin
  Result := ZeroIntPoint3D;
  if aArray = nil then
    exit;
  Result[2] := Length(aArray);
  Result[1] := Length(aArray[0]);
  Result[0] := Length(aArray[0, 0]);
end; { DimOfArray }

{ function DimOfArray(const aArray: TNormImgArray): TIntPoint3D;
  begin
  Result:= ZeroIntPoint3D;
  if aArray = nil then exit;
  Result[2]:= Length(aArray);
  Result[1]:= Length(aArray[0]);
  Result[0]:= Length(aArray[0, 0]);
  end; } { DimOfArray }

function ReducedHue(aVal: Single): Single;
{ Возвращает значение, принадлежещее интервалу [-3; 3] и равное aVal по модулю aPeriod }
var
  aCoeff, aPeriod, aHalfPeriod: Integer;
begin
  aPeriod := 6;
  aHalfPeriod := aPeriod div 2;
  aCoeff := Floor((aVal + aHalfPeriod) / aPeriod);
  Result := aVal - aCoeff * aPeriod;
end; { ReducedHue }

function BasicColorFactor(aVal: Single): Single;
{ Возвращает значение функции, определенной на [0; 3] и имеющей трапецеидальную форму. Result(0) = 1. }
begin
  Result := 1;
  if aVal > 2 then
    Result := 0
  else if aVal > 1 then
    Result := 2 - aVal;
end; { BasicColorFactor }

function ExtBasicColorFactor(aVal: Single): Single;
{ Возвращает четную функцию, совпадающую с BasicColor при положительных аргументах. }
begin
  if aVal >= 0 then
    Result := BasicColorFactor(aVal)
  else
    Result := BasicColorFactor(-aVal);
end; { ExtBasicColorFactor }

function HSVToRGB(aHue, aSatur, aBright: Single): TRGB;
{ Возвращает цвет в формате RGB по набору HSV (aHue, aSaturation, aBrightness). 0 <= aHue < 6; 0 <= aSatur, aBright < 1. }
var
  i: Integer;

  function ShiftColorFactor(aHueVal, aShift: Single): Single;
  { Возвращает цветовой коэффиуиент для сдвинутой на aShift функции ExtBasicColorFactor }
  begin
    aHueVal := aHueVal - aShift;
    aHueVal := ReducedHue(aHueVal);
    Result := ExtBasicColorFactor(aHueVal);
    Result := aBright * (1 - aSatur * (1 - Result));
  end; { ShiftColorFactor }

const
  aColorShift: TIntPoint3D = (0, 2, 4);

begin
  for i := 0 to 2 do
    Result[i] := Round(MaxColor * ShiftColorFactor(aHue, aColorShift[i]));
end; { HSVToRGB }

function HSVToColor(aHue, aSatur, aBright: Single): TColor;
{ Возвращает цвет в формате TColor по набору HSV (aHue, aSaturation, aBrightness). 0 <= aHue < 6; 0 <= aSatur, aBright < 1. }
begin
  Result := RGBToColor(HSVToRGB(aHue, aSatur, aBright));
end; { HSVToColor }

function MinPoint(aPoint1, aPoint2: TIntPoint3D): TIntPoint3D;
begin
  Result[0] := Min(aPoint1[0], aPoint2[0]);
  Result[1] := Min(aPoint1[1], aPoint2[1]);
  Result[2] := Min(aPoint1[2], aPoint2[2]);
end; { MinPoint }

function MinPoint(aPoint1, aPoint2: TIntPoint2D): TIntPoint2D;
begin
  Result[0] := Min(aPoint1[0], aPoint2[0]);
  Result[1] := Min(aPoint1[1], aPoint2[1]);
end; { MinPoint }

function MinPoint(aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D;
begin
  Result[0] := Min(aPoint1[0], aPoint2[0]);
  Result[1] := Min(aPoint1[1], aPoint2[1]);
end; { MinPoint }

function MinRealPoint(aPoint1, aPoint2: TRealPoint2D): TRealPoint2D;
begin
  Result[0] := Min(aPoint1[0], aPoint2[0]);
  Result[1] := Min(aPoint1[1], aPoint2[1]);
end; { MinRealPoint }

function MaxRealPoint(aPoint1, aPoint2: TRealPoint2D): TRealPoint2D;
begin
  Result[0] := Max(aPoint1[0], aPoint2[0]);
  Result[1] := Max(aPoint1[1], aPoint2[1]);
end; { MaxRealPoint }

function MaxPoint(aPoint1, aPoint2: TIntPoint3D): TIntPoint3D;
begin
  Result[0] := Max(aPoint1[0], aPoint2[0]);
  Result[1] := Max(aPoint1[1], aPoint2[1]);
  Result[2] := Max(aPoint1[2], aPoint2[2]);
end; { MaxPoint }

function MaxPoint(aPoint1, aPoint2: TIntPoint2D): TIntPoint2D;
begin
  Result[0] := Max(aPoint1[0], aPoint2[0]);
  Result[1] := Max(aPoint1[1], aPoint2[1]);
end; { MaxPoint }

function MaxPoint(aPoint1, aPoint2: TIntegerPoint2D): TIntegerPoint2D;
begin
  Result[0] := Max(aPoint1[0], aPoint2[0]);
  Result[1] := Max(aPoint1[1], aPoint2[1]);
end; { MaxPoint }

function GaussDistr(X, aMean, aStdDev: Single): Double;
{ Возвращает значение нормального распределения с параметрами aMean, aStdDev в точке x }
begin
  Result := 0;
  if aStdDev < 0.0001 then
    exit;
  Result := exp(-0.5 * Sqr((X - aMean) / aStdDev)) / (Sqrt(2 * Pi) * aStdDev);
end; { GaussDistr }

function ArgGaussDistr(aVal, aMean, aStdDev: Single): Double;
{ Возвращает большее значение аргумента, для которого GaussDistr = aVal }
begin
  Result := aMean - Sqrt(2) * aStdDev * Ln(Sqrt(2 * Pi) * aStdDev * aVal);
end; { ArgGaussDistr }

function GaussDensity(aMean, aStdDev: Single): TRealArray;
{ Возвращает плотности нормального распределения с параметрами aMean, aStdDev в точках [0..MaxColor] }
var
  i: Integer;
begin
  SetLength(Result, MaxColor + 1);
  for i := 0 to MaxColor do
    Result[i] := GaussDistr(i, aMean, aStdDev);
end; { GaussDensity }

function IcosahedronVert: TIcosahedronVert;
{ Возвращает массив вершин икосаэдра. Вершины нумеруются снизу вверх (по оси Z). В плоскостях Z = +-0.5 - в положительном
  направлении (против стрелки, если смотреть сверху).
  0 - нижняя вершина; 1..5 - в плоскости Z = -0.5; 6..10 - в плоскости Z = 0.5; 11 -верхняя вершина. }
var
  i: Integer;
  aDelPhi, aPhi, aPhi0: Single;
begin
  Result[0] := RealPoint3D(0, 0, -Sqrt(5) / 2);
  aPhi0 := Pi / 5;
  aDelPhi := 2 * aPhi0;
  for i := 0 to 4 do
  begin
    aPhi := i * aDelPhi;
    Result[i + 1] := RealPoint3D(Cos(aPhi), Sin(aPhi), -0.5);
    aPhi := aPhi + aPhi0;
    Result[i + 6] := RealPoint3D(Cos(aPhi), Sin(aPhi), 0.5);
  end;
  Result[11] := RealPoint3D(0, 0, Sqrt(5) / 2);
end; { IcosahedronVert }

function IcosahedronFasets: TIcoFasets;
{ Возвращает массив граней икосаэдра. Грани нумеруются снизу вверх (по оси Z). }
var
  i, j: Integer;
  aIcoVert: TIcosahedronVert;
  aIcoFasetInd: array [0 .. 19] of TIntPoint3D;
begin
  for i := 0 to 4 do
  begin
    aIcoFasetInd[i] := Point3D(0, i + 1, ((i + 1) mod 5) + 1);
    aIcoFasetInd[i + 5] := Point3D(i + 1, i + 5, i + 6);
    aIcoFasetInd[i + 10] := Point3D(i + 6, i + 1, ((i + 1) mod 5) + 1);
    aIcoFasetInd[i + 15] := Point3D(11, i + 6, ((i + 1) mod 5) + 6);
  end;
  aIcoFasetInd[5, 1] := 10;
  aIcoVert := IcosahedronVert;
  for i := 0 to 19 do
    for j := 0 to 2 do
      Result[i, j] := aIcoVert[aIcoFasetInd[i, j]];
end; { IcosahedronFasets }

function CenterFaset(aIcoFaset: TIcoFaset): TRealPoint3D;
var
  i: Integer;
begin
  Result := ZeroRealPoint3D;
  for i := 0 to 2 do
    Result := SummTwoPoints(Result, aIcoFaset[i]);
  Result := ProdNumPoint(1 / 3, Result);
end; { CenterFaset }

function DodecahedronDir: TDodecahedronDir;
{ Возвращает массив единичных векторов, определяемых вершинами додекаэдра }
var
  i: Integer;
  aIcoFasets: TIcoFasets;
begin
  aIcoFasets := IcosahedronFasets;
  for i := 0 to 19 do
  begin
    Result[i] := CenterFaset(aIcoFasets[i]);
    NormalizeVect(Result[i]);
  end;
end; { DodecahedronDir }

procedure NormalizeVect(var aVect: TRealPoint3D);
{ Vector normalization Vect }
var
  aNorm: Single;
  i: Integer;
begin
  aNorm := Sqrt(aVect[0] * aVect[0] + aVect[1] * aVect[1] + aVect[2] * aVect[2]);
  if aNorm > 0 then
    for i := 0 to 2 do
      aVect[i] := aVect[i] / aNorm;
end; { NormalizeVect }

function NormVect(const aVect: TRealPoint3D): Single;
begin
  Result:= Sqrt(aVect[0] * aVect[0] + aVect[1] * aVect[1] + aVect[2] * aVect[2]);
end;

function NormVect(const aVect: TDoublePoint3D): Double;
begin
  Result:= Sqrt(aVect[0] * aVect[0] + aVect[1] * aVect[1] + aVect[2] * aVect[2]);
end;

function NormVect(const aVect: TDoublePoint2D): Double;
begin
  Result:= Sqrt(aVect[0] * aVect[0] + aVect[1] * aVect[1]);
end;

function NormVect(const aVect: TRealPoint2D): Single;
begin
  Result:= Sqrt(aVect[0] * aVect[0] + aVect[1] * aVect[1]);
end;

function NormVect(const aVect: TDoubleArray): Double;
var i: Integer;
begin
  Result:= 0;
  for i:= 0 to Length(aVect) - 1 do
    Result:= Result + aVect[i]*aVect[i];
  Result:= Sqrt(Result);
end;

function InspectRegion(const aRegion: TRegion; aBonus: Smallint;
  aImgDim: TIntPoint3D): TRegion;
{ Возвращает прямоугольную область, охватывающую aRegion с запасом aBonus. }
var
  i: Integer;
begin
  for i := 0 to 2 do
  begin
    Result[0, i] := Max(0, aRegion[0, i] - aBonus);
    Result[1, i] := Min(aImgDim[i] - 1, aRegion[1, i] + aBonus);
  end;
end; { InspectRegion }

function MaxArrayValue(const aArray: TRealArray2D): Single;
{ Возвращает наибольшее значение двумерного массива aArray. }
var
  i, j, aLen: Integer;
begin
  Result := 0;
  if aArray = nil then
    exit;
  aLen := Length(aArray[0]);
  Result := aArray[0, 0];
  for i := 0 to Length(aArray) - 1 do
    for j := 0 to aLen - 1 do
      Result := Max(Result, aArray[i, j]);
end; { MaxArrayValue }

function MaxArrayValue(const aArray: TRealArray): Single;
{ Возвращает наибольшее значение одномерного массива aArray. }
var
  i: Integer;
begin
  Result := 0;
  if aArray = nil then
    exit;
  Result := aArray[0];
  for i := 1 to Length(aArray) - 1 do
    Result := Max(Result, aArray[i]);
end; { MaxArrayValue }

function MaxArrayValue(const aArray: TDoubleArray): Double;
{ Возвращает наибольшее значение одномерного массива aArray. }
var
  i: Integer;
begin
  Result := 0;
  if aArray = nil then
    exit;
  Result := aArray[0];
  for i := 1 to Length(aArray) - 1 do
    Result := Max(Result, aArray[i]);
end; { MaxArrayValue }

function ScalarProd3D(aVect1, aVect2: TRealPoint3D): Single;
  {Возвращает скалярное произведение векторов aVect1, aVect2}
begin
  Result:= aVect1[0]*aVect2[0] + aVect1[1]*aVect2[1] + aVect1[2]*aVect2[2];
end;

function ScalarProdVect(aVect1, aVect2: TDoubleArray): Double;
  {Возвращает скалярное произведение векторов aVect1, aVect2 одинакового размера}
var i, aLen: Integer;
begin
  Result:= 0;
  aLen:= Length(aVect1);
  if Length(aVect2) <> aLen then Exit;
  for i:= 0 to aLen - 1 do
    Result:= Result + aVect1[i]*aVect2[i];
end;

function VectProd(const Vect1, Vect2: TRealPoint3D): TRealPoint3D;
  {Returns vector multiplication Result = Vect1 x Vect2}
begin
  Result[0]:= Vect1[1]*Vect2[2] - Vect1[2]*Vect2[1];
  Result[1]:= Vect1[2]*Vect2[0] - Vect1[0]*Vect2[2];
  Result[2]:= Vect1[0]*Vect2[1] - Vect1[1]*Vect2[0];
end;  {VectProd}

function VectProd(const Vect1, Vect2: TDoublePoint3D): TDoublePoint3D;
  {Returns vector multiplication Result = Vect1 x Vect2}
begin
  Result[0]:= Vect1[1]*Vect2[2] - Vect1[2]*Vect2[1];
  Result[1]:= Vect1[2]*Vect2[0] - Vect1[0]*Vect2[2];
  Result[2]:= Vect1[0]*Vect2[1] - Vect1[1]*Vect2[0];
end;  {VectProd}

function Det2(a11, a12, a21, a22: Double): Double;
  {Возвращает детерминант матрицы 2 порядка (a11, a12)(a21, a22)}
begin
  Result:= a11*a22 - a12*a21;
end;

function DetMatr2D(const aMatr: TMatr2): Double;
  {Возвращает детерминант матрицы 2 порядка aMatr}
begin
  Result:= aMatr[0, 0]*aMatr[1, 1] - aMatr[0, 1]*aMatr[1, 0];
end;

function Det3(const aMatrix: TMatr3): Double;
  {Возвращает детерминант матрицы 3 порядка aMatrix}
begin
  Result:= aMatrix[0, 0]*Det2(aMatrix[1, 1], aMatrix[1, 2], aMatrix[2, 1], aMatrix[2, 2]) -
           aMatrix[1, 0]*Det2(aMatrix[0, 1], aMatrix[0, 2], aMatrix[2, 1], aMatrix[2, 2]) +
           aMatrix[2, 0]*Det2(aMatrix[0, 1], aMatrix[0, 2], aMatrix[1, 1], aMatrix[1, 2]);
end;  {Det3}

function TransposedMatrix(const aMatrix: TMatr3): TMatr3;
  {Возвращает транспонированную матрицу aMatrix.}
var i, j: Integer;
begin
  for i:= 0 to 2 do
    for j:= 0 to 2 do
      Result[i, j]:= aMatrix[j, i];
end;  {TransposedMatrix}

function TransposedMatrix(const aMatrix: TMatr3Double): TMatr3Double;
  {Возвращает транспонированную матрицу aMatrix.}
var i, j: Integer;
begin
  for i:= 0 to 2 do
    for j:= 0 to 2 do
      Result[i, j]:= aMatrix[j, i];
end;  {TransposedMatrix}

function TransposedMatrix(const aMatrix: TDoubleArray2D): TDoubleArray2D;
  {Возвращает транспонированную матрицу aMatrix.}
var i, j, aLen1, aLen2: Integer;
begin
  aLen1:= Length(aMatrix);
  aLen2:= Length(aMatrix[0]);
  SetLength(Result, aLen2, aLen1);
  for i:= 0 to aLen2 - 1 do
    for j:= 0 to aLen1 - 1 do
      Result[i, j]:= aMatrix[j, i];
end;  {TransposedMatrix}

function TransposedMatrix(const aMatrix: TDoubleArrayArr): TDoubleArrayArr;
  {Возвращает транспонированную матрицу aMatrix.}
var i, j, aLen1, aLen2: Integer;
begin
  aLen1:= Length(aMatrix);
  aLen2:= Length(aMatrix[0]);
  SetLength(Result, aLen2, aLen1);
  for i:= 0 to aLen2 - 1 do
    for j:= 0 to aLen1 - 1 do
      Result[i, j]:= aMatrix[j, i];
end;  {TransposedMatrix}

function SimpsonIntegral(const aFunc: TDoubleFunc; aInit, aTerm, aStep: Double; aNmin: Integer): Double;
  {Возвращает значение интеграла от функции aFunc по промежутку [aInit, aTerm], вычисленное по методу Симпсона с шагом aStep.
   aNmin - минимальное количество двойных промежутков.}
var aS0, aS1, aS2, aLen, aArg, aStep2: Double;
    i, aN, aM: Integer;
begin
  Result:= 0;
  aLen:= aTerm - aInit;
  if aLen < 1e-5 then Exit;
  aN:= Ceil(aLen/(2*aStep));    {Количество двойных интервалов}
  aN:= Max(aN, aNmin);
  aM:= 2*aN;              {Количество интервалов}
  aStep:= aLen/aM    ;          {Шаг интегрирования}
  aS0:= aFunc(aInit) + aFunc(aTerm);
  aS1:= 0;
  aS2:= 0;
  aStep2:= 2*aStep;
  aArg:= aInit + aStep;
  for i:= 1 to aN do begin
    aS1:= aS1 + aFunc(aArg);
    aArg:= aArg + aStep2;
  end;
  aArg:= aInit + aStep2;
  for i:= 1 to aN - 1 do begin
    aS2:= aS2 + aFunc(aArg);
    aArg:= aArg + aStep2;
  end;
  Result:= aStep*(aS0 + 4*aS1 + 2*aS2) / 3;
end;

function MultMatr(const aMatr1, aMatr2: TDoubleArray2D): TDoubleArray2D;
{ Возвращает произведение матриц aMatr1[aLen1 x aLen2]*aMatr2[aLen2 x aLen3] = aMatr1xaMatr2[aLen1 x aLen3]}
var i, j, k, aLen1, aLen2, aLen3: Integer;
    aTemp: Double;
begin
  Result:= nil;
  if (aMatr1 = nil)or(aMatr2 = nil) then Exit;
  aLen1:= Length(aMatr1);
  aLen2:= Length(aMatr1[0]);
  if Length(aMatr2) <> aLen2 then Exit;
  aLen3:= Length(aMatr2[0]);
  SetLength(Result, aLen1, aLen3);
  for i := 0 to aLen1 - 1 do
    for j := 0 to aLen3 - 1 do begin
      aTemp := 0;
      for k := 0 to aLen2 - 1 do
        aTemp := aTemp + aMatr1[i, k] * aMatr2[k, j];
      Result[i, j] := aTemp;
    end;
end; {MultMatr}

function MultMatr(const aMatr1, aMatr2: TDoubleArrayArr): TDoubleArrayArr;
{ Возвращает произведение матриц aMatr1[aLen1 x aLen2]*aMatr2[aLen2 x aLen3] = aMatr1xaMatr2[aLen1 x aLen3]}
var i, j, k, aLen1, aLen2, aLen3: Integer;
    aTemp: Double;
begin
  Result:= nil;
  if (aMatr1 = nil)or(aMatr2 = nil) then Exit;
  aLen1:= Length(aMatr1);
  aLen2:= Length(aMatr1[0]);
  if Length(aMatr2) <> aLen2 then Exit;
  aLen3:= Length(aMatr2[0]);
  SetLength(Result, aLen1, aLen3);
  for i := 0 to aLen1 - 1 do
    for j := 0 to aLen3 - 1 do begin
      aTemp := 0;
      for k := 0 to aLen2 - 1 do
        aTemp := aTemp + aMatr1[i, k] * aMatr2[k, j];
      Result[i, j] := aTemp;
    end;
end; {MultMatr}

function MultMatrColumn(const aMatr: TDoubleArray2D; const aColumn: TDoubleArray): TDoubleArray;
{ Возвращает произведение матрицы aMatr[aLen1 x aLen2]*aColumn[aLen2 x 1] = aColumn[aLen1 x 1]}
var i, j, aLen1, aLen2: Integer;
    aTemp: Double;
begin
  Result:= nil;
  if (aMatr = nil)or(aColumn = nil) then Exit;
  aLen1:= Length(aMatr);
  aLen2:= Length(aMatr[0]);
  if Length(aColumn) <> aLen2 then Exit;
  SetLength(Result, aLen1);
  for i := 0 to aLen1 - 1 do begin
    aTemp := 0;
    for j := 0 to aLen2 - 1 do
      aTemp := aTemp + aMatr[i, j] * aColumn[j];
    Result[i] := aTemp;
  end;
end; {MultMatrColumn}

function SqrtSS(a, b: Double): Double;
  {Computes Sqrt(a*a + b*b) without destructive underflow or overflow.}
var absa, absb: Double;
begin
  absa:= Abs(a);
  absb:= Abs(b);
  if (absa > absb) then
    Result:= absa*Sqrt(1 + Sqr(absb/absa))
  else
    if (absb < 1E-20) then Result:= 0
      else Result:= absb*Sqrt(1 + Sqr(absa/absb));
end;

function SVD(var aMatr: TDoubleArrayArr; m, n: Integer; var W: TDoubleArray; var V: TDoubleArrayArr): Boolean;
  {Given a matrix a[1..m][1..n], this routine computes its Singular Value Decomposition,
   A = U·W·V' (V' is the transposed V).
   The matrix U replaces A on output.
   The diagonal matrix of singular values W is output as a vector W[1..n].
   The matrix V (not the transpose V') is output as V[1..n][1..n].}
var flag, i, its, j, jj, k, l, nm, imin: Integer;
    anorm, c, f, g, h, s, scale, x, y, z: Double;
    rv1: array of Real;
begin
  Result:=True;
  SetLength(rv1, n+1);
  g:= 0.0;
  scale:= 0.0;
  anorm:= 0.0;   {Householder reduction to bidiagonal form.}
  l:= 1;     //Для компилятора
  for i:= 1 to n do begin
    l:= i+1;
    rv1[i]:= scale*g;
    g:= 0.0;
    s:= 0.0;
    scale:= 0.0;
    if (i <= m) then begin
      for k:= i to m do
        scale:= scale + Abs(aMatr[k][i]);
      if (scale <> 0) then begin
        for k:= i to m do begin
          aMatr[k][i]:= aMatr[k][i] / scale;
          s:= s + aMatr[k][i]*aMatr[k][i];
        end;   {for k}
        f:= aMatr[i][i];
        if (f >= 0) then
          g:= -Sqrt(s)
        else
          g := Sqrt(s);
        h:= f*g - s;
        aMatr[i][i]:= f - g;
        for j:= l to n do begin
          s:=0.0;
          for k:= i to m do
            s:= s + aMatr[k][i]*aMatr[k][j];
          f:= s/h;
          for k:=i to m do
            aMatr[k][j]:= aMatr[k][j] + f*aMatr[k][i];
        end;   {for j}
        for k:=i to m do
          aMatr[k][i]:= aMatr[k][i] * scale;
      end;  {if (scale <> 0)}
    end;   {if (i <= m)}
    w[i]:= scale*g;
    g:= 0.0;
    s:= 0.0;
    scale:= 0.0;
    if ((i <= m) and (i <> n)) then begin
      for k:= l to n do
        scale := scale + Abs(aMatr[i][k]);
      if (scale <> 0) then begin
        for k:=l to n do begin
           aMatr[i][k]:= aMatr[i][k] / scale;
           s:= s + aMatr[i][k]*aMatr[i][k];
        end;    {for k}
        f:= aMatr[i][l];
        if (f>=0) then g := -Sqrt(s) else g := Sqrt(s);
        h:= f*g-s;
        aMatr[i][l]:= f-g;
        for k:=l to n do rv1[k]:=aMatr[i][k]/h;
        for j:=l to m do begin
          s:=0.0;
          for k:=l to n do s:= s + aMatr[j][k]*aMatr[i][k];
          for k:=l to n do aMatr[j][k]:= aMatr[j][k] + s*rv1[k];
        end;  {for j}
        for k:=l to n do aMatr[i][k]:= aMatr[i][k] * scale;
      end;   {if (scale <> 0)}
    end;   {if ((i <= m) and (i <> n))}
    if (anorm < (Abs(w[i]) + Abs(rv1[i]))) then
      anorm:= (Abs(w[i]) + Abs(rv1[i]));
  end;   {for i:= 1 to n}
  for i:= n downto 1 do begin {Accumulation of right-hand transformations.}
    if (i < n) then begin
      if (g <> 0) then begin
        for j:=l to n do {Double division to avoid possible underflow.}
          v[j][i]:= (aMatr[i][j]/aMatr[i][l])/g;
        for j:=l to n do begin
          s:= 0.0;
          for k:=l to n do
            s:= s + aMatr[i][k]*v[k][j];
          for k:=l to n do
            v[k][j]:= v[k][j] + s*v[k][i];
        end;  {for j}
      end;  {if (g <> 0)}
      for j:=l to n do begin
        v[i][j]:= 0.0;
        v[j][i]:= 0.0;
      end;   {for j}
    end;   {if (i < n)}
    v[i][i]:=1.0;
    g:=rv1[i];
    l:=i;
  end;   {for i:= n downto 1}
  imin:= Min(m, n);
  for i:= imin downto 1 do begin{ Accumulation of left-hand transformations.}
    l:= i + 1;
    g:= w[i];
    for j:=l to n do
      aMatr[i][j]:=0.0;
    if (g <> 0) then begin
      g:= 1.0/g;
      for j:= l to n do begin
        s:= 0.0;
        for k:= l to m do
          s:= s + aMatr[k][i]*aMatr[k][j];
        f:= (s/aMatr[i][i])*g;
        for k:=i to m do
          aMatr[k][j]:= aMatr[k][j] + f*aMatr[k][i];
      end;  {for j}
      for j:=i to m do
        aMatr[j][i]:= aMatr[j][i] * g;
    end   {if (g <> 0)}
    else
      for j:= i to m do
        aMatr[j][i]:= 0.0;
    aMatr[i][i]:= aMatr[i][i] + 1;
  end;   {for i}
  nm:= 1;    //Для компилятора
  for k:= n downto 1 do begin { Diagonalization of the bidiagonal form: Loop over singular values, and over allowed iterations}
    for its:= 1 to 30 do begin
      flag:= 1;
      for l:= k downto 1 do begin   {Test for splitting.}
        nm:= l - 1;   {Note that rv1[1] is always zero.}
        if ((Abs(rv1[l])+anorm) = anorm) then begin
          flag:= 0;
          Break;
        end;
        if ((Abs(w[nm]) + anorm) = anorm) then Break;
      end;   {for l}
      if (flag <> 0) then begin
        c:= 0.0; {Cancellation of rv1[l], if l > 1.}
        s:= 1.0;
        for i:=l to k do begin
          f:= s*rv1[i];
          rv1[i]:= c*rv1[i];
          if ((Abs(f) + anorm) = anorm) then Break;
          g:= w[i];
          h:= SqrtSS(f,g);
          w[i]:= h;
          h:= 1.0/h;
          c:= g*h;
          s:= -f*h;
          for j:= 1 to m do begin
            y:= aMatr[j][nm];
            z:= aMatr[j][i];
            aMatr[j][nm]:= y*c + z*s;
            aMatr[j][i]:= z*c - y*s;
          end;   {for j}
        end;   {for i}
      end;   {if (flag <> 0)}
      z:= w[k];
      if (l = k) then begin {Convergence.}
        if (z < 0.0) then  begin {Singular value is made nonnegative.}
          w[k]:= -z;
          for j:= 1 to n do
            v[j][k]:= -v[j][k];
        end;  {if (z < 0.0) }
        Break;
      end;   {if (l = k)}
      if (its = 30) then begin
        //Application.MessageBox('No convergence in 30 svd iterations.','Error');
        Result:=False;
        Finalize (rv1);
        Exit;
      end;    {if (its = 30)}
      x:= w[l]; {Shift from bottom 2-by-2 minor.}
      nm:= k-1;
      y:= w[nm];
      g:= rv1[nm];
      h:= rv1[k];
      f:= ((y-z)*(y+z)+(g-h)*(g+h))/(2.0*h*y);
      g:= SqrtSS(f, 1.0);
      if (f >= 0) then
        f:= ((x-z)*(x+z)+h*((y/(f+Abs(g)))-h))/x
      else
        f:=((x-z)*(x+z)+h*((y/(f-Abs(g)))-h))/x;
      c:= 1.0;
      s:= 1.0; {Next QR transformation:}
      for j:= l to nm do begin
        i:= j+1;
        g:= rv1[i];
        y:= w[i];
        h:= s*g;
        g:= c*g;
        z:= SqrtSS(f,h);
        //z:= Max(1e-14, z);
        rv1[j]:= z;
        if z = 0 then begin
          Result:= False;
          exit;
        end;
        c:= f/z;
        s:= h/z;
        f:= x*c+g*s;
        g:= g*c-x*s;
        h:= y*s;
        y:= y*c;
        for jj:= 1 to n do begin
          x:= v[jj][j];
          z:= v[jj][i];
          v[jj][j]:= x*c+z*s;
          v[jj][i]:= z*c-x*s;
        end;   {for jj}
        z:= SqrtSS(f,h);
        w[j]:= z; {Rotation can be arbitrary if z = 0.}
        if (z <> 0) then begin
          z:= 1.0/z;
          c:= f*z;
          s:= h*z;
        end;   {if (z <> 0)}
        f:= c*g+s*y;
        x:= c*y-s*g;
        for jj:= 1 to m do begin
          y:= aMatr[jj][j];
          z:= aMatr[jj][i];
          aMatr[jj][j]:= y*c+z*s;
          aMatr[jj][i]:= z*c-y*s;
        end;    {for jj}
      end;   {for j}
      rv1[l]:= 0.0;
      rv1[k]:= f;
      w[k]:= x;
    end;   {for its}
  end;    {for k}
end;

function AssignMatrix(const aSource: TDoubleArray2D): TDoubleArray2D;
  {Возвращает копию aSource}
var i, j, aLen1, aLen2: Integer;
begin
  Result:= nil;
  if aSource = nil then Exit;
  aLen1:= Length(aSource);
  aLen2:= Length(aSource[0]);
  SetLength(Result, aLen1, aLen2);
  for i:= 0 to aLen1 - 1 do
    for j:= 0 to aLen2 - 1 do
      Result[i, j]:= aSource[i, j];
end;

function CMult(aCNum1, aCNum2: TDoublePoint2D): TDoublePoint2D;
  {Возвращает произведение двух комплексных чисел aCNum1, aCNum2}
begin
  Result[0]:= aCNum1[0]*aCNum2[0] - aCNum1[1]*aCNum2[1];
  Result[1]:= aCNum1[0]*aCNum2[1] + aCNum1[1]*aCNum2[0];
end;

function CSum(aCNum1, aCNum2: TDoublePoint2D): TDoublePoint2D;
  {Возвращает сумму двух комплексных чисел aCNum1, aCNum2}
begin
  Result[0]:= aCNum1[0] + aCNum2[0];
  Result[1]:= aCNum1[1] + aCNum2[1];
end;

function CDiff(aCNum1, aCNum2: TDoublePoint2D): TDoublePoint2D;
  {Возвращает разность двух комплексных чисел aCNum1 - aCNum2}
begin
  Result[0]:= aCNum1[0] - aCNum2[0];
  Result[1]:= aCNum1[1] - aCNum2[1];
end;

function RCMult(aRNum: Double; aCNum: TDoublePoint2D): TDoublePoint2D;
  {Возвращает произведение вещественного числа aRNum на комплексное число aCNum}
begin
  Result[0]:= aRNum*aCNum[0];
  Result[1]:= aRNum*aCNum[1];
end;

function NCMult(aNum: Integer; aCNum: TDoublePoint2D): TDoublePoint2D;
  {Возвращает произведение целого числа aNum на комплексное число aCNum}
begin
  Result[0]:= aNum*aCNum[0];
  Result[1]:= aNum*aCNum[1];
end;

function CNum(aX, aY: Double): TDoublePoint2D;
begin
  Result[0]:= aX;
  Result[1]:= aY;
end;

function CMod(aCNum: TDoublePoint2D): Double;
  {Возвращает модуль комплексного числа aCNum}
begin
  Result:= Sqrt(aCNum[0]*aCNum[0] + aCNum[1]*aCNum[1]);
end;

end.
