unit UnPKSimplex;

interface

uses SysUtils, Grids, Math, Forms, UnCOVID, UnTypesCOVID;

const
  LenVert = 5;

type
  TSimplexVert = array[0..LenVert - 1] of Double;  {Нормированные параметры в вершинах: 0 - Detect, 1 - Dist, 2 - InitCont, 3 - IsolCont, 4 - Daily1, 5 - Daily2}
  TSimplex = array of TSimplexVert;  {Массив вершин симплекса}
  TSimplexParam = record
    aReflCoeff, aExpandCoeff, aContractCoeff, aShrinkCoeff: Double;
  end;
  TSimulParams = array[0..LenVert - 1] of Double;  {Параметры для симулирования: 0 - Detect, 1 - InitCont, 2 - IsolCont, 3 - Daily1, 4 - Daily2}

function SimulSimplexMethod(const aSimplexParam: TSimplexParam; const aBasicSumulParams: TSimulParams; aOptimPeriod: TIntegerPoint2D;
         var aInitSimplex: TSimplex; aMaxAbsErr: Double; var aNumIter: Integer; var aMinFuncValue, aFuncStndErr: Double): TSimplexVert;
function ScoreForSimplex(const aSimplex: TSimplex; const aBasicSumulParams: TSimulParams; aOptimPeriod: TIntegerPoint2D): TRealArray;
function ScoreForSimplexVert(const aSimplexVert: TSimplexVert; const aBasicSumulParams: TSimulParams; aOptimPeriod: TIntegerPoint2D): Double;
procedure GetMinMaxVertexInd(const aScoreOnSimpl: TRealArray; var aMinIndex, aMaxIndex, aPreMaxIndex: Integer);
function AverageVect(const aSimplex: TSimplex; aIgnoreInd: Integer): TSimplexVert;
function LinearTransSimplexVert(const aOrigSimplexVert, aDirectSimplexVert: TSimplexVert; aCoeff: Double): TSimplexVert;
procedure ShrinkSimplex(const aSimplex: TSimplex; aShrinkCoeff: Double; aMinIndex: Integer);
function SimplexScoreSE(const aScoreOnSimpl: TRealArray): Double;
function GetInitSimplex(aInitSimplexVert: TSimplexVert; aInitVal: Double; aVarIndex: Integer): TSimplex; overload;
function GetInitSimplex(aInitSimplexVert: TSimplexVert; aInitVal: Double): TSimplex; overload;
function SimplexVertToSimulParam(const aSimplexVert: TSimplexVert; const aBasicSumulParams: TSimulParams): TSimulParams;
function SimulParamToSimplexVert(const aSimulParams: TSimulParams; const aBasicSumulParams: TSimulParams): TSimplexVert;
function FullSimulSimplexMethod(const aSimplexParam: TSimplexParam; aInitSimplexVert: TSimplexVert; aInitVal: Double; aMaxNumIter: Integer;
         aMaxAbsErr: Double; var aNumIterations: TIntArray; var aMinFuncValues, aFuncStndErrors: TRealArray): TSimplex;
function AssignSimplex(const aSourceSimplex: TSimplex): TSimplex;
procedure FillOptResStrGrid(const aOptEtas: TSimplex; const aNumIterations: TIntArray;
          const aMinFuncValues, aFuncStndErrors: TRealArray; aThreshExp: Integer; const aStrGrid: TStringGrid);
procedure SetDefaultSimplexParam(var aSimplexParam: TSimplexParam);
function HiperParamToSimulParam(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TSimulParams;
procedure SetHiperParam(const aSimulParam: TSimulParams; var aHiperParam: TDoublePoint2DArr; var aInitContProb, aIsolContProb: Double);

const
  ZeroSimplexVert: TSimplexVert = (0, 0, 0, 0, 0);

var PKParamStdDev: TRealPoint3DArr;
    PKCorr, CurrDose: Double;
    CorrControlPoints: TRealPoint2DArr;
    PointCount, SimPatCount, BuffPatCount: Integer;
    LenHiperParam: Integer;  // Количество элементов в HiperParam
    SimPatList, BuffPatList: TPatList;

implementation

procedure SetDefaultSimplexParam(var aSimplexParam: TSimplexParam);
   {Установка aSimplexParam по умолчанию}
begin
  aSimplexParam.aReflCoeff:= 1.6;
  aSimplexParam.aExpandCoeff:= 1.6;
  aSimplexParam.aContractCoeff:= 0.6;
  aSimplexParam.aShrinkCoeff:= 0.6;
end;

function SimulSimplexMethod(const aSimplexParam: TSimplexParam; const aBasicSumulParams: TSimulParams; aOptimPeriod: TIntegerPoint2D;
         var aInitSimplex: TSimplex; aMaxAbsErr: Double; var aNumIter: Integer; var aMinFuncValue, aFuncStndErr: Double): TSimplexVert;
  {Возвращает вектор оптимальных параметров типа TSimplexVert (Result = (Detect, Dist, InitCont, IsolCont, Daily1, Daily2)).
   Входные данные:
   aSimplexParam = (aReflCoeff, aExpandCoeff, aContractCoeff, aShrinkCoeff) - параметры преобразований симплекс-метода,
   aBasicSumulParams - начальные значения параметров симуляции,
   aNumIter - максимальное число итераций (заменяется на фактическое число итереций),
   aInitSimplex - начальный симплекс параметров, заменяется на оптимальный.
   aMaxAbsErr - максимальная абсолютная погрешность для оптимизируемой функции
   aMinFuncValue - полученное минимальное значение Score.
   aFuncStndErr - среднеквадратичное отклонение Score в вершинах симплекса.}
var
  aAverageVert,  aReflectVert, aExpandVert, aContractVert: TSimplexVert;
  aScoreOnSimpl: TRealArray;
  aReflectValue, aExpandValue, aContractValue: Double;
  aMinInd, aMaxInd, aPreMaxInd, aIterCount: Integer;
  aStatusText: String;
  aSimulParam: TSimulParams;
  aHiperParam: TDoublePoint2DArr;
  aInitContProb, aIsolContProb: Double;
begin
  Result:= ZeroSimplexVert;
  aExpandVert:= ZeroSimplexVert;
  aContractVert:= ZeroSimplexVert;
  //SetModelParam;
  aScoreOnSimpl:= ScoreForSimplex(aInitSimplex, aBasicSumulParams, aOptimPeriod);
  if aScoreOnSimpl = nil then exit;
  {Main cycle in programm}
  aIterCount:= 0;
  repeat
    if StopEvaluation then begin
      SetStatusText(MainForm.MainStatusBar, 0, 'Interruption of Evaluation');
      SetStatusText(MainForm.MainStatusBar, 1, '');
      GetMinMaxVertexInd(aScoreOnSimpl, aMinInd, aMaxInd, aPreMaxInd);
      Result:= aInitSimplex[aMinInd];
      Application.ProcessMessages;
      Exit;
    end;
    {Вычисление индексов вершин с минимальным, максимальным и предмаксимальным значениями:}
    GetMinMaxVertexInd(aScoreOnSimpl, aMinInd, aMaxInd, aPreMaxInd);
    aAverageVert:= AverageVect(aInitSimplex, aMaxInd);  {Средний вектор с исключенным максимальным}
    aReflectVert:= LinearTransSimplexVert(aAverageVert, aInitSimplex[aMaxInd], -aSimplexParam.aReflCoeff); {Отраженный максимальный вектор}
    aReflectValue:= ScoreForSimplexVert(aReflectVert, aBasicSumulParams, aOptimPeriod);
    if aReflectValue < aScoreOnSimpl[aMinInd] then begin  {Отраженное значение меньше минимального:}
      aExpandVert:= LinearTransSimplexVert(aAverageVert, aReflectVert, aSimplexParam.aExpandCoeff);  {Удлинненый отраженный векторð}
      aExpandValue:= ScoreForSimplexVert(aExpandVert, aBasicSumulParams, aOptimPeriod);
      if aExpandValue < aReflectValue then
        aInitSimplex[aMaxInd]:= aExpandVert
      else
        aInitSimplex[aMaxInd]:= aReflectVert;
    end
    else begin  {Отраженное значение не меньше минимального: aReflectValue >= aScoreOnSimpl[aMinInd]}
      if aReflectValue < aScoreOnSimpl[aPreMaxInd] then  {Отраженное значение меньше предмаксимального}
        aInitSimplex[aMaxInd]:= aReflectVert
      else begin  {Отраженное значение не меньше предмаксимального}
        if aReflectValue < aScoreOnSimpl[aMaxInd] then begin {Отраженное значение меньше максимального}
          aContractVert:= LinearTransSimplexVert(aAverageVert, aReflectVert, aSimplexParam.aContractCoeff); {Внешний сжатый средний вектор}
          aContractValue:= ScoreForSimplexVert(aContractVert, aBasicSumulParams, aOptimPeriod); {Значение оценки для aContractVert}
          if aContractValue < aReflectValue then
            aInitSimplex[aMaxInd]:= aContractVert
          else
            aInitSimplex[aMaxInd]:= aReflectVert;
        end
        else begin
          aContractVert:= LinearTransSimplexVert(aAverageVert, aInitSimplex[aMaxInd], aSimplexParam.aContractCoeff);  {Внутренний сжатый средний вектор}
          aContractValue:= ScoreForSimplexVert(aContractVert, aBasicSumulParams, aOptimPeriod);
          if aContractValue < aScoreOnSimpl[aMaxInd] then
            aInitSimplex[aMaxInd]:= aContractVert
          else
            ShrinkSimplex(aInitSimplex, aSimplexParam.aShrinkCoeff, aMinInd);
        end;
      end;
    end;
    aScoreOnSimpl[aMaxInd]:= ScoreForSimplexVert(aInitSimplex[aMaxInd], aBasicSumulParams, aOptimPeriod);
    Inc(aIterCount);
    aFuncStndErr:= SimplexScoreSE(aScoreOnSimpl);
    if (aIterCount mod 5) = 0 then begin
      aStatusText:= 'Simplex Iteration: ' + IntToStr(aIterCount);
      SetStatusText(MainForm.MainStatusBar, 1, aStatusText);
      aSimulParam:= SimplexVertToSimulParam(aInitSimplex[aMinInd], aBasicSumulParams);
      SetHiperParam(aSimulParam, aHiperParam, aInitContProb, aIsolContProb);
      DrawCases(5, aHiperParam, aInitContProb, aIsolContProb, MainForm.TreatSimulSeries, MainForm.TreatReallSeries);
      Application.ProcessMessages;
    end;
  until (aIterCount >= aNumIter)or(aFuncStndErr < aMaxAbsErr);
  SetStatusText(MainForm.MainStatusBar, 1, '');
  Result:= aInitSimplex[aMinInd];
  aMinFuncValue:= ScoreForSimplexVert(Result, aBasicSumulParams, aOptimPeriod);
  aNumIter:= aIterCount;
end;  {SimplexMethod}

function ScoreForSimplex(const aSimplex: TSimplex; const aBasicSumulParams: TSimulParams; aOptimPeriod: TIntegerPoint2D): TRealArray;
  {Возвращает массив значений целевой функции в вершинах симплекса aSimplex}
var i: Integer;
begin
  Result:= nil;
  SetLength(Result, LenVert + 1);
  for i:= 0 to LenVert do
    Result[i]:= ScoreForSimplexVert(aSimplex[i], aBasicSumulParams, aOptimPeriod);
end;  {ScoreForSimplex}

procedure SetHiperParam(const aSimulParam: TSimulParams; var aHiperParam: TDoublePoint2DArr; var aInitContProb, aIsolContProb: Double);
  {Формирование aHiperParam, aInitContProb, aIsolContProb по aSimulParam}
var i: Integer;
begin
  SetLength(aHiperParam, LenHiperParam);
  aHiperParam[0]:= DoublePoint2D(aSimulParam[0], HiperParam[0, 1]);
  aHiperParam[1]:= HiperParam[1];
  aHiperParam[2]:= HiperParam[2];
  for i:= 3 to LenHiperParam - 1 do
    aHiperParam[i]:= DoublePoint2D(aSimulParam[i - 2], HiperParam[i, 1]);
  aInitContProb:= aSimulParam[LenVert - 2];
  aIsolContProb:= aSimulParam[LenVert - 1];
end;

function ScoreForSimplexVert(const aSimplexVert: TSimplexVert; const aBasicSumulParams: TSimulParams; aOptimPeriod: TIntegerPoint2D): Double;
var aSimulParam: TSimulParams;
    aHiperParam: TDoublePoint2DArr;
    aInitContProb, aIsolContProb: Double;
begin
  aSimulParam:= SimplexVertToSimulParam(aSimplexVert, aBasicSumulParams);
  SetHiperParam(aSimulParam, aHiperParam, aInitContProb, aIsolContProb);
  Result:= ObjFunction(3, aHiperParam, aInitContProb, aIsolContProb, aOptimPeriod, SimPatList, SimPatCount);
end;  {ScoreForSimplexVert}

procedure GetMinMaxVertexInd(const aScoreOnSimpl: TRealArray; var aMinIndex, aMaxIndex, aPreMaxIndex: Integer);
  {aMinIndex, aMaxIndex - индексы вершин, на которых достигается наименьшее и наибольшее значения целевой функции aScoreOnSimpl.}
var aCurrValue, aMinValue, aMaxValue, aPreMaxValue: Double;
    i, aLen: Integer;
begin
  aMinIndex:= 0;
  aMaxIndex:= aMinIndex;
  aMinValue:= aScoreOnSimpl[0];
  aMaxValue:= aMinValue;
  aLen:= Length(aScoreOnSimpl);
  if aLen < 2 then exit;
  for i:= 1 to aLen - 1 do begin
    aCurrValue:= aScoreOnSimpl[i];
    if (aCurrValue < aMinValue) then begin
      aMinValue:= aCurrValue;
      aMinIndex:= i;
    end
    else
      if (aCurrValue > aMaxValue) then begin
        aMaxValue:= aCurrValue;
        aMaxIndex:= i;
      end;
  end;
  aPreMaxIndex:= aMinIndex;
  aPreMaxValue:= aMinValue;
  for i:= 0 to aLen - 1 do begin
    if i = aMaxIndex then Continue;
    aCurrValue:= aScoreOnSimpl[i];
    if (aCurrValue <= aMaxValue)and(aCurrValue > aPreMaxValue) then begin
      aPreMaxValue:= aCurrValue;
      aPreMaxIndex:= i;
    end;
  end;
end;  {GetMinMaxVertexInd}

function AverageVect(const aSimplex: TSimplex; aIgnoreInd: Integer): TSimplexVert;
  {Возвращает средний вектор для вершин aSimplex за исключением вершины с индексом aIgnoreInd}
var i, j: Integer;
begin
  Result:= ZeroSimplexVert;
  for i:= 0 to LenVert do begin
    if (i = aIgnoreInd) then Continue;
    for j:= 0 to LenVert - 1 do
      Result[j]:= Result[j] + aSimplex[i, j];
  end;
  for j:= 0 to LenVert - 1 do
    Result[j]:= Result[j]/LenVert;
end;  {AverageVect}

function LinearTransSimplexVert(const aOrigSimplexVert, aDirectSimplexVert: TSimplexVert; aCoeff: Double): TSimplexVert;
  {Возвращает вершину симплекса, равную смещенной вершине aDirectSimplexVert в направлении центральной вершины aOrigSimplexVert на коэффициент aCoeff.}
var i: Integer;
begin
  for i:= 0 to LenVert - 1 do
    Result[i]:= aOrigSimplexVert[i] + aCoeff*(aDirectSimplexVert[i] - aOrigSimplexVert[i]);
end;  {LinearTransSimplexVert}

procedure ShrinkSimplex(const aSimplex: TSimplex; aShrinkCoeff: Double; aMinIndex: Integer);
  {Сжатие симплекса aSimplex в направлении вершиныс индексомì aMinIndex (с коэффициентом сжатия aShrinkCoeff)}
var i: Integer;
begin
  for i:= 0 to Length(aSimplex) - 1 do
    if i <> aMinIndex then
      aSimplex[i]:= LinearTransSimplexVert(aSimplex[aMinIndex], aSimplex[i], aShrinkCoeff);
end;  {ShrinkSimplex}

function SimplexScoreSE(const aScoreOnSimpl: TRealArray): Double;
  {Возвращает StndErr для массива aScoreOnSimpl}
var i, aLen: Integer;
    aAvrgVal: Double;
begin
  Result:= 0;
  aLen:= Length(aScoreOnSimpl);
  if aLen < 2 then exit;
  aAvrgVal:= 0;
  for i:= 0 to aLen - 1 do
    aAvrgVal:= aAvrgVal + aScoreOnSimpl[i];
  aAvrgVal:= aAvrgVal/aLen;
  for i:= 0 to aLen - 1 do
    Result:= Result + Sqr(aScoreOnSimpl[i] - aAvrgVal);
  Result:= Sqrt(Result/(aLen - 1));
end;  {SimplexScoreSE}

function GetInitSimplex(aInitSimplexVert: TSimplexVert; aInitVal: Double): TSimplex;
  {Возвращает начальный симплекс. aInitVal - абсолютная вкличина координат сдвига.}
var i: Integer;
    aShiftSimpl: TSimplexVert;
begin
  SetLength(Result, LenVert + 1);
  for i:= 0 to LenVert do
    Result[i]:= aInitSimplexVert;
  for i:= 0 to LenVert - 1 do
    aShiftSimpl[i]:= aInitVal;
  for i:= 0 to LenVert - 1 do
    if Result[i, i] >= 0 then
      Result[i, i]:= Result[i, i] + aShiftSimpl[i]
    else
      Result[i, i]:= Result[i, i] - aShiftSimpl[i];
end;  {GetInitSimplex}

function GetInitSimplex(aInitSimplexVert: TSimplexVert; aInitVal: Double; aVarIndex: Integer): TSimplex;
  {Возвращает начальный симплекс. aInitVal - абсолютная вкличина координат сдвига.
   aVarIndex - двоичная кодировка знаков начальных значений по каждому направлению (0 - положительное значение, 1 - отрицательное значение)}
var i: Integer;
    aSignArr: array[0..LenVert - 1] of Integer;
    aShiftSimpl: TSimplexVert;
begin
  SetLength(Result, LenVert + 1);
  for i:= 0 to LenVert do
    Result[i]:= aInitSimplexVert;
  for i:= 0 to LenVert - 1 do
    aShiftSimpl[i]:= aInitVal;
  for i:= 0 to LenVert - 1 do begin
    aSignArr[i]:= aVarIndex mod 2;
    aVarIndex:= aVarIndex div 2;
  end;
  for i:= 0 to LenVert - 1 do
    if aSignArr[i] > 0 then
      Result[i, i]:= Result[i, i] - aShiftSimpl[i]
    else
      Result[i, i]:= Result[i, i] + aShiftSimpl[i];
end;  {GetInitSimplex}

function SimplexVertToSimulParam(const aSimplexVert: TSimplexVert; const aBasicSumulParams: TSimulParams): TSimulParams;
var i: Integer;
begin
  for i:= 0 to LenVert - 1 do
    Result[i]:= Max(0.05, aBasicSumulParams[i]*(1 + aSimplexVert[i]));
  Result[0]:= Max(MinDetect, Result[0]);
end;  {SimplexVertToSimulParam}

function SimulParamToSimplexVert(const aSimulParams: TSimulParams; const aBasicSumulParams: TSimulParams): TSimplexVert;
var i: Integer;
begin
  for i:= 0 to LenVert - 1 do
    if aBasicSumulParams[i] <> 0 then
      Result[i]:= (aSimulParams[i] - aBasicSumulParams[i])/aBasicSumulParams[i]
    else
      Result[i]:= 0;
end;  {SimulParamToSimplexVert}

function HiperParamToSimulParam(const aHiperParam: TDoublePoint2DArr; aInitContProb, aIsolContProb: Double): TSimulParams;
  {Возвращает массив TSimulParams по aHiperParam, aInitContProb, aIsolContProb}
var i: Integer;
begin
  Result[0]:= aHiperParam[0, 0];
  for i:= 3 to LenHiperParam - 1 do
    Result[i - 2]:= aHiperParam[i, 0];
  Result[LenVert - 2]:= aInitContProb;
  Result[LenVert - 1]:= aIsolContProb;
end;

function FullSimulSimplexMethod(const aSimplexParam: TSimplexParam; aInitSimplexVert: TSimplexVert; aInitVal: Double; aMaxNumIter: Integer;
         aMaxAbsErr: Double; var aNumIterations: TIntArray; var aMinFuncValues, aFuncStndErrors: TRealArray): TSimplex;
  {Возвращает результаты использования симплекс-метода для всевозможных начальных симплексов.
   Result = массив оптимальных вершин (Etas).
   aMaxNumIter - максимальное число итераций.
   aNumIterations - фактическое число итераций.
   aMinFuncValues - массив минимальных значений целевой функции.
   aFuncStndErrors - среднеквадратичное отклонение значений целевой функции в вершинах оптимального симплпкса.}
var i, aLen: Integer;
    aCurrInitSimplex: TSimplex;
begin
  aLen:= Round(IntPower(2, LenVert));
  SetLength(Result, aLen);
  SetLength(aNumIterations, aLen);
  SetLength(aMinFuncValues, aLen);
  SetLength(aFuncStndErrors, aLen);
  for i:= 0 to aLen - 1 do begin
    aNumIterations[i]:= aMaxNumIter;
    aCurrInitSimplex:= GetInitSimplex(aInitSimplexVert, aInitVal, i);
    //Result[i]:= PKSimplexMethod(aSimplexParam, aCurrInitSimplex, aMaxAbsErr, aNumIterations[i], aMinFuncValues[i], aFuncStndErrors[i]);
  end;
end;  {PKFullSimplexMethod}

function AssignSimplex(const aSourceSimplex: TSimplex): TSimplex;
var i, aLen: Integer;
begin
  Result:= nil;
  if aSourceSimplex = nil then exit;
  aLen:= Length(aSourceSimplex);
  SetLength(Result, aLen);
  for i:= 0 to aLen - 1 do
    Result[i]:= aSourceSimplex[i];
end;  {AssignSimplex}

procedure FillOptResStrGrid(const aOptEtas: TSimplex; const aNumIterations: TIntArray;
          const aMinFuncValues, aFuncStndErrors: TRealArray; aThreshExp: Integer; const aStrGrid: TStringGrid);
var i, aLen: Integer;
    aScale: Double;

  function EtaStr(aEtas: TSimplexVert): String;
  var i: Integer;
  begin
    Result:= '';
    for i:= 0 to LenVert - 2 do
      Result:= Result + Format('%5.3f', [aEtas[i]]) + ';';
    Result:= Result + Format('%5.3f', [aEtas[LenVert - 1]]);
  end;  {EtaStr}

begin
  //ClearStrGrid(aStrGrid);
  aStrGrid.Cells[0, 0]:= 'No.';
  aStrGrid.Cells[1, 0]:= 'Optimal Etas';
  aStrGrid.Cells[2, 0]:= 'Obj Func';
  aStrGrid.Cells[3, 0]:= 'Iter';
  aStrGrid.Cells[4, 0]:= 'SE*e' + IntToStr(aThreshExp);
  aLen:= Length(aOptEtas);
  aStrGrid.RowCount:= aLen + 1;
  aScale:= IntPower(10, aThreshExp);
  for i:= 0 to aLen - 1 do begin
    aStrGrid.Cells[0, i + 1]:= IntToStr(i + 1);
    aStrGrid.Cells[1, i + 1]:= EtaStr(aOptEtas[i]);
    aStrGrid.Cells[2, i + 1]:= Format('%8.6f', [aMinFuncValues[i]]);
    aStrGrid.Cells[3, i + 1]:= IntToStr(aNumIterations[i]);
    aStrGrid.Cells[4, i + 1]:= Format('%6.3f', [aFuncStndErrors[i]*aScale]);
  end;
end;

end.
