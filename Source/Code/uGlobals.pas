//---------------------------------------------------------------------------
// This unit is part of the Gexoblock System, http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------

(*! Global types, variables and constants *)

unit uGlobals;

interface

uses
  System.SysUtils,
  System.IniFiles;

const
  crSelectCursor = 0; //crDefault
  crPenCursor    = 1;
  crPanCursor    = 2;
  crScrollCursor = 3;
  crZoomCursor   = 4;
  crCrossCursor  = 5;

type
  TShowType    = (stMap, stTable, stGraph, stReport);
  TViewType    = (vtTop, vtBottom, vtLeft, vtRight, vtFront, vtBack,
    vtPerspective);
  TPolygonType = (ptNone, ptPoint, ptPolyline, ptPolygon, ptRect, ptRoundRect,
    ptEllipse, ptArc, ptSymbol, ptText);

const
  //ModelTypes as FileModels.PageIndex
  mtUnknown  = -1;
  mtFirst    = 0;
  mtDholes   = 0;      // Drillholes
  mtPoints2D = 1;      // 2D points  - XYZG
  mtPoints3D = 2;      // 3D points  - XYZG
  mtPolygons = 3;      // TPolygonTypes
  mtTin      = 4;      // 2D Triangulated Irregular Network
  mtSolids   = 5;      // Solids or shells of orebodies
  mtGrid2D   = 6;      // 2D Grid
  mtGrid3D   = 7;      // 3D Grid
  mtMesh2D   = 8;      // 2D Finite Difference Elements
  mtMesh3D   = 9;      // 3D Finite Difference Elements
  mtDrawings = 10;     // Drawings of objects
  mtPolylines = 11;    // TPolylineTypes - not implemented yet
  mtLast     = 11;

  //Image Datatypes BMP, PCX, JPEG, GIF
  mtImage = 12;
  mtAll   = 13;

const
  CR   = #$0D;
  LF   = #$0A;
  CRLF = CR + LF;
  LFCR = LF + CR;
  Epsilon:   double = 0.00001;
  Seed:      integer = 1000;

const
  RegGexoblock = '\SOFTWARE\Gexoblock\';

var
  GeneralSection: string = '\SOFTWARE\Gexoblock\General';
  // That must not be declared as const
  DBext:     string = '.sqlite';
  PrjExt:    string = '.prj';
  ParExt:    string = '.par';
  TextExt:   string = '.txt';
  PlugExt:   string = '*.gpl';
  CurLang:   string = 'ru';  //Current default is 'en', localized is 'ru' etc.
  LangID: integer;


var
  //Paths for Gexoblock
  PathApp:  TFileName = '';  //..\Gexoblock\
  PathExe:  TFileName = '';  //..\Gexoblock\bin\

  PathDataBase: TFileName = '';

  PathDataAssets: TFileName = '';
  PathDataReference: TFileName = '';

  DirProjects: TFileName = 'Data'+ PathDelim;

  DirDataBase:    TFileName = 'Data'+ PathDelim + 'Base' + PathDelim;

  DirAssets:   TFileName = 'Data'+ PathDelim + 'Assets' + PathDelim;

  DirReference: TFileName = 'Data'+ PathDelim + 'Reference' + PathDelim;
  DirReports:  TFileName = 'Data'+ PathDelim + 'Reports' + PathDelim;
  DirFiles: TFileName = 'Data'+ PathDelim + 'Files' + PathDelim;
  DirLegends: TFileName = 'Data'+ PathDelim + 'Legends' + PathDelim;
  DirDataSQL:   TFileName = 'Data'+ PathDelim + 'Sql' + PathDelim;

  //Reports Directory
  DirPicture: TFileName = 'Reports' + PathDelim + 'Picture' + PathDelim;
  DirGraph:   TFileName = 'Reports' + PathDelim + 'Graph' + PathDelim;
  DirVideo:   TFileName = 'Reports' + PathDelim + 'Video' + PathDelim;

  //GeoStatistical Directory
  DirExpVar: TFileName = 'GeoStat' + PathDelim + 'ExpVar' + PathDelim;
  DirFitVar: TFileName = 'GeoStat' + PathDelim + 'FitVar' + PathDelim;
  DirHisto:  TFileName = 'GeoStat' + PathDelim + 'Histo' + PathDelim;

  //Plugins and execs
  DirPlugins: TFileName = 'Plugins' + PathDelim;

// Vars for tables
var
  //Tables
  tblAssays:      string = 'Assays';
  tblCollars:     string = 'Collars';
  tblInclins:     string = 'Inclins';
  tblDictionary:  string = 'Dictionary';
  tblSettings:    string = 'Settings';
  tblFramework:   string = 'Framework';
  tblLevels:      string = 'Default';
  tblMaterial:    string = 'Default';
  tblHoleMat:     string = 'Default';
  tblPolyMat:     string = 'Polytype';
  tblPoints2DMat: string = 'Pointtype';
  tblPoint3DMat:  string = 'Point3DType';

// FieldType Mappings
  fldAREA:   string = 'AREA';           //ftFloat
  fldAREADIF: string = 'AREADIF';       //ftFloat
  fldATTRIBUTE: string = 'ATTRIBUTE';   //ftString
  fldAZIMUTH: string = 'AZIMUTH';       //ftFloat
  fldC:   string = 'C';                 //ftWord
  fldCATEGORY: string = 'CATEGORY';     //ftInteger
  fldCODE:   string = 'CODE';           //ftInteger
  fldCOMMENT: string = 'COMMENT';       //ftString
  fldCOMPONENT: string = 'COMPONENT';   //ftFloat
  fldCORE:   string = 'CORE';           //ftFloat
  fldCORE_PERCENT: string = 'CORE_PERCENT'; //ftFloat
  fldDENSITY: string = 'DENSITY';       //ftFloat
  fldDEPTH:  string = 'DEPTH';          //ftFloat
  fldDIP:    string = 'DIP';            //ftFloat
  fldDISTANCE: string = 'DISTANCE';     //ftFloat
  fldEASTING: string = 'EASTING';       //ftFloat
  fldELEMENT: string = 'ELEMENT';       //ftFloat
  fldELEVATION: string = 'ELEVATION';   //ftFloat
  fldENGLISH: string = 'ENGLISH';       //ftString
  fldFACIT:  string = 'FACET';          //ftInteger
  fldFACTOR: string = 'FACTOR';         //ftFloat
  fldFINISH: string = 'FINISH';         //ftDate
  fldFORMULA: string = 'FORMULA';       //ftString
  fldFRENCH: string = 'FRENCH';         //ftString
  fldFROM:   string = 'FROM';           //ftFloat
  fldG:      string = 'G';              //ftFloat
  fldGERMAN: string = 'GERMAN';         //ftString
  fldGRADE:  string = 'GRADE';          //ftFloat
  fldGRAINSIZE: string = 'GRAINSIZE';   //ftFloat
  fldDHOLE:  string = 'DHOLE';          //ftString
  fldHORIZON: string = 'HORIZON';       //ftInteger
  fldID:     string = 'ID';             //ftAutoenctiment
  fldID_BODY: string = 'ID_BODY';       //ftInteger
  fldID_ELEMENT: string = 'ID_ELEMENT'; //ftInteger
  fldID_FACET: string = 'ID_FACET';     //ftInteger
  fldID_MATRIX: string = 'ID_MATRIX';   //ftInteger
  fldID_NO:  string = 'ID_NO';          //ftInteger
  fldID_NODE: string = 'ID_NODE';       //ftInteger
  fldID_POLY: string = 'ID_POLY';       //ftInteger
  fldID_TRIANGLE: string = 'ID_TRIANGLE'; //ftInteger
  fldID_TYPE: string = 'ID_TYPE';       //ftInteger
  fldID_VERTEX: string = 'ID_VERTEX';   //ftInteger
  fldIMAGE:  string = 'IMAGE';
  fldINCLINATION: string = 'INCLINATION'; //ftFloat
  fldINTERVAL: string = 'INTERVAL'; //ftFloat
  fldITEM:   string = 'ITEM';
  fldLABEL:  string = 'LABEL';     //ftString
  fldLENGTH: string = 'LENGTH';    //ftFloat
  fldMATERIAL: string = 'MATERIAL';
  fldMOISTURE: string = 'MOISTURE'; //ftFloat
  fldN1:     string = 'N1';         //ftInteger
  fldN2:     string = 'N2';         //ftInteger
  fldN3:     string = 'N3';         //ftInteger
  fldNAME:   string = 'NAME';       //ftString
  fldNO:     string = 'NO';             //ftInteger
  fldNORTHING: string = 'NORTHING'; //ftFloat
  fldORESORT: string = 'ORESORT';   //ftInteger
  fldOREKIND: string = 'OREKIND';   //ftInteger
  fldORETYPE: string = 'ORETYPE';   //ftInteger
  fldOREBODY: string = 'OREBODY';
  fldOREBLOCK: string = 'OREBLOCK'; //ftInteger
  fldPARAMETER: string = 'PARAMETER';
  fldPATTERN: string = 'PATTERN';
  fldPROFILE: string = 'PROFILE';   //ftString
  fldRECOVERY: string = 'RECOVERY'; //ftFloat
  fldRESERVE: string = 'RESERVE';   //ftFloat
  fldRHYTHM: string = 'RHYTHM';
  fldROCKTYPE: string = 'ROCKTYPE'; //ftInteger
  fldRUSSIAN: string = 'RUSSIAN';   //ftString
  fldSAMPLE: string = 'SAMPLE';     //ftString
  fldSEQUENCE: string = 'SEQUENCE'; //ftInteger
  fldSHORT:  string = 'SHORT';      //ftString
  fldSLOPE:  string = 'SLOPE';      //ftFloat
  fldSPANISH: string = 'SPANISH';   //ftString
  fldSTART:  string = 'START';      //ftDate
  fldSUBBLOCK: string = 'SUBBLOCK'; //ftFloat
  fldSYMBOL: string = 'SYMBOL';
  fldTEXTURE: string = 'TEXTURE';
  fldTHICKNESS: string = 'THICKNESS'; //ftFloat
  fldTO:     string = 'TO';           //ftFloat
  fldVALUE:  string = 'VALUE';        //ftFloat
  fldVARIANT: string = 'VARIANT';     //ftInteger
  fldVERTEX: string = 'VERTEX';       //ftInteger
  fldVISIBLE: string = 'VISIBLE';
  fldVOLUME: string = 'VOLUME'; //ftFloat
  fldV1:     string = 'V1'; //ftInteger
  fldV2:     string = 'V2'; //ftInteger
  fldV3:     string = 'V3'; //ftInteger
  fldX:      string = 'X'; //ftFloat
  fldY:      string = 'Y'; //ftFloat
  fldYIELD:  string = 'YIELD'; //ftFloat
  fldZ:      string = 'Z'; //ftFloat
  // Fields for Variograms
  fldVarID:  string = 'VAR_ID';  // ftIntege
  fldVarType: string = 'VAR_TYPE';  // ftInteger
  fldDim3D:  string = 'DIM_3D';  // ftBoolean
  fldAzimuthAngle: string = 'AZIMUTH_ANGLE';  // ftFloat
  fldAzimuthTolerance: string = 'AZIMUTH_TOLERANCE';  // ftFloat
  fldAzimuthBandwidth: string = 'AZIMUTH_BANDWIDTH';  // ftFloat
  fldDipAngle: string = 'DIP_ANGLE';  // ftFloat
  fldDipTolerance: string = 'DIP_TOLERANCE';  // ftFloat
  fldDipBandwidth: string = 'DIP_BANDWIDTH';  // ftFloat
  fldLagsN:  string = 'LAGS';  // ftInteger
  fldLagDistance: string = 'LAG_DISTANCE';  // ftFloat
  fldLagTolerance: string = 'LAG_TOLERANCE';  // ftFloat
  fldAvgSeparationDistance: string = 'SEPARATION_DISTANCE';  // ftFloat
  fldLagPairsNum: string = 'PAIRS_IN_LAG';  // ftFloat
  fldMeanTail: string = 'TAIL_MEAN';  // ftFloat
  fldMeanHead: string = 'HEAD_MEAN';  // ftFloat
  fldVarianceTail: string = 'TAIL_VARIANCE';  // ftFloat
  fldVarianceHead: string = 'HEAD_VARIANCE';  // ftFloat
  fldModelFunctionID: string = 'MODEL_FUNCTION_ID';  // ftInteger
  fldNugget: string = 'NUGGET';  // ftFloat
  fldContribution: string = 'CONTRIBUTION';  // ftFloat
  fldRange:  string = 'RANGE';  // ftFloat
  fldAnis1:  string = 'ANIS1';  // ftFloat
  fldAnis2:  string = 'ANIS2';  // ftFloat
  fldPlungeAngle: string = 'PLUNGE_ANGLE';  // ftFloat

var
  IniFile:  TIniFile;
  Precision: integer = -2;

function SlashSep(const Path, S: string): string;
function ExpandPath(Path: TFileName): TFileName;


//=========================================================================
implementation
//=========================================================================


function SlashSep(const Path, S: string): string;
begin
  if (Path <> '') and (S <> '') then
    Result := Path + S
  else
    Result := Path + PathDelim + S;
end;

//================================================================\\
function ExpandPath(Path: TFileName): TFileName;
begin
  if PathApp = '' then
    Exit;
  Result := Path;
  if Pos('Gexoblock', Result) <> 0 then
    Result := PathApp
  else if Pos(DirPlugins, Result) <> 0 then
    Result := SlashSep(PathApp, DirPlugins)

  else if Pos(DirProjects, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirProjects)
  else if Pos(DirFiles, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirFiles)
  else if Pos(DirLegends, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirLegends)
  else if Pos(DirDataSQL, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirDataSQL)
  else if Pos(DirPicture, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirPicture)
  else if Pos(DirAssets, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirAssets)
  else if Pos(DirReports, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirReports)
  else if Pos(DirExpVar, Result) <> 0 then
 //Geostat Directories
    Result := SlashSep(PathDataBase, DirExpVar)
  else if Pos(DirFitVar, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirFitVar)
  else if Pos(DirHisto, Result) <> 0 then
    Result := SlashSep(PathDataBase, DirHisto)
  //Reference Directory
  else if Pos(DirReference, Result) <> 0 then
    Result := PathDataReference;

  try
    if not DirectoryExists(Result) then
      ForceDirectories(Result);
  finally
  end;
end;


//===========================================
initialization
//===========================================

  FormatSettings.DecimalSeparator := '.';
  FormatSettings.TwoDigitYearCenturyWindow := 60;
  //Converts a date from two digits to interval (CurrentYear-60 .. CurrentYear+40)
end.
