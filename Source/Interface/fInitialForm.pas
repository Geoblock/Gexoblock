// ---------------------------------------------------------------------------
// This unit is part of the Geoblock Project, http://sourceforge.net/projects/geoblock
// ---------------------------------------------------------------------------
{ ! InitialForm is a parent for all inherited fmx forms }

unit fInitialForm;

interface

uses
  System.Win.Registry,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.ImgList,
  FMX.Menus,
  FMX.Edit,
  FMX.Memo;


type
  TfmInitialForm = class(TForm)
  private
    { Private declarations }
  public
    procedure ReadIniFile; virtual;
    procedure WriteIniFile; virtual;
    { translate a text,which is not in the autotranslation process of TLang}
    function TransManually(sOriginal: string; aLang: TLang): string; virtual;
    procedure LoadTranslationsFromFile(aLangCode: string; aFileName: string;
      aLang: TLang); virtual;
  end;

var
  fmInitialForm: TfmInitialForm;

// ===================================================================
implementation
// ===================================================================

{$R *.fmx}

function TfmInitialForm.TransManually(sOriginal: string; aLang: TLang): string;
begin
  // first check, if the selected language has a mapping
  if aLang.Resources.IndexOf(aLang.Lang) >= 0 then
  begin
    // get the resource stringlist of the current language and get the translation
    result := aLang.LangStr[aLang.Lang].Values[sOriginal];
    if result = '' then
    begin
      // text not found in mapping - keep original text
      result := sOriginal;
    end;
  end
  else
  begin // language not found: must be the default language
    result := sOriginal;
  end;
end;

procedure TfmInitialForm.LoadTranslationsFromFile(aLangCode: string;
  aFileName: string; aLang: TLang);
var
  TranStrings: TStrings;
begin
  if (aLangCode <> '') and (FileExists(aFileName)) and (Assigned(aLang))
  then
  begin
    TranStrings := TStringList.Create;
    TranStrings.LoadFromFile(aFileName);
    aLang.Resources.AddObject(aLangCode, TranStrings);
  end;
end;

{ TfmInitialForm }

procedure TfmInitialForm.ReadIniFile;
begin
  //
end;

procedure TfmInitialForm.WriteIniFile;
begin
  //
end;

initialization

end.
