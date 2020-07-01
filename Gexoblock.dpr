{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
program Gexoblock;

{$R 'Gexoblock.res' 'Gexoblock.rc'}

uses
  FMX.Forms,
  System.SysUtils,
  System.IOUtils,
  fInitialForm in 'Source\Interface\fInitialForm.pas' {fmInitialForm},
  fInitialDialog in 'Source\Interface\fInitialDialog.pas' {fmInitialDialog},
  fHelpAbout in 'Source\Interface\fHelpAbout.pas' {fmHelpAbout},
  fToolsOptions in 'Source\Interface\fToolsOptions.pas' {fmToolsOptions},
  dBase in 'Source\Interface\dBase.pas' {dmBase: TDataModule},
  dDialogs in 'Source\Interface\dDialogs.pas' {dmDialogs: TDataModule},
  uResStrings in 'Source\Code\uResStrings.pas',
  uGlobals in 'Source\Code\uGlobals.pas',
  uDiscoCore in 'Source\Code\uDiscoCore.pas',
  uDiscoMetric in 'Source\Code\uDiscoMetric.pas',
  uDiscoPoly in 'Source\Code\uDiscoPoly.pas',
  uInterpol in 'Source\Code\uInterpol.pas',
  uObjects3D in 'Source\Code\uObjects3D.pas',
  uProfuns in 'Source\Code\uProfuns.pas',
  uRandomAM in 'Source\Code\uRandomAM.pas',
  uSorting in 'Source\Code\uSorting.pas',
  uSuperblock in 'Source\Code\uSuperblock.pas',
  uDelaunay3D in 'Source\Code\uDelaunay3D.pas',
  uInverseDistance in 'Source\Code\uInverseDistance.pas',
  fFileDataBrowser in 'Source\Interface\fFileDataBrowser.pas' {fmFileDataBrowser},
  fMethodDialog in 'Source\Interface\fMethodDialog.pas' {fmMethodDialog},
  fMethodDualDialog in 'Source\Interface\fMethodDualDialog.pas' {fmMethodDualDialog},
  fMethodInterpolation in 'Source\Interface\fMethodInterpolation.pas' {fmMethodInterpolation},
  fGexoblock in 'Source\Interface\fGexoblock.pas' {fmGexoblock},
  fMethodGridGeneration in 'Source\Interface\fMethodGridGeneration.pas' {fmMethodGridGeneration},
  uCommon in 'Source\Code\uCommon.pas',
  dImages in 'Source\Interface\dImages.pas' {dmImages: TDataModule},
  fMethodAssayGeneration in 'Source\Interface\fMethodAssayGeneration.pas' {fmMethodAssayGeneration},
  fMethodPitOptimization in 'Source\Interface\fMethodPitOptimization.pas' {fmMethodPitOptimization},
  frShowScene in 'Source\Interface\frShowScene.pas' {FrameShowScene: TFrame},
  uSceneModels in 'Source\Code\uSceneModels.pas',
  frFileDataBrowser in 'Source\Interface\frFileDataBrowser.pas' {FrameDataBrowser: TFrame},
  frShowTable in 'Source\Interface\frShowTable.pas' {FrameShowTable: TFrame};

{$R *.res}

type
  TAppExcept = class(TObject)
  private
    procedure ExceptionsControl(Sender: TObject; E: Exception);
  end;

procedure TAppExcept.ExceptionsControl(Sender: TObject; E: Exception);
var
  S: String;
begin
  S:= Format('%S'+#9+'%S',[DateTimeToStr(Now),E.Message]);
  TFile.AppendAllText('Errors.log', S+#10#13);
  Application.ShowException(E);
end;

var
  AppExcept: TAppExcept;

begin
  Application.Initialize;
  AppExcept := TAppExcept.Create;
  Application.OnException:= AppExcept.ExceptionsControl;
  Application.CreateForm(TdmBase, dmBase);
  Application.CreateForm(TdmDialogs, dmDialogs);
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TfmGexoblock, fmGexoblock);
  Application.CreateForm(TfmFileDataBrowser, fmFileDataBrowser);
  Application.Run;
end.
