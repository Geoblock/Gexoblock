//---------------------------------------------------------------------------
// This unit is part of the Gexoblock System, http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------

unit fHelpAbout;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Math.Vectors,
  System.ImageList,
  FMX.ImgList,
  FMX.Menus,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Types3D,
  FMX.Layers3D,
  FMX.Controls3D,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,

  fInitialDialog,
  uGlobals;

type
  TfmHelpAbout = class(TfmInitialDialog)
    TextTitle: TText;
    LabelSF: TLabel;
    Label4: TLabel;
    Image3D1: TImage3D;
    Image: TImage;
    LabelDataAnalysis: TLabel;
    LabelModelVisualization: TLabel;
    LabelMineralReserveEstimation: TLabel;
    Langs: TLang;
    LabelOS: TLabel;
    LabelArchitecture: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmHelpAbout: TfmHelpAbout;

//==================================================================
implementation
//==================================================================

{$R *.fmx}

procedure TfmHelpAbout.FormShow(Sender: TObject);
var
  S: String;
begin
  inherited;
  Langs.Lang := CurLang;
  Caption := TransManually(Caption, Langs);
  TextTitle.Text := TransManually(TextTitle.Text, Langs);
  //-------------------- OS ------------------------------
  LabelOS.Text := TOSVersion.ToString;
  //-------------------- CPU ------------------------------
  case TOSVersion.Architecture of
    arIntelX86 : S := 'IntelX86';
    arIntelX64 : S := 'IntelX64';
    arARM32 : S := 'ARM32';
    arARM64 : S := 'ARM64';
  else S := 'Unknown';
  end;
  LabelArchitecture.Text := LabelArchitecture.Text + ' ' + S +
    ' ' + TThread.ProcessorCount.ToString + ' Cores';
end;

end.
