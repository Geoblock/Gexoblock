unit fMethodPitOptimization;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  FMX.ImgList,
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,

  fInitialDialog,
  uGlobals;

type
  TfmMethodPitOptimization = class(TfmInitialDialog)
    Langs: TLang;
    Panel1: TPanel;
    LabelMethod: TLabel;
    rbFloatingCone: TRadioButton;
    rbLerchsGrossmann: TRadioButton;
    rbPseudoFlow: TRadioButton;
    rbParticleSwarm: TRadioButton;
    rbNeuralNetwork: TRadioButton;
    rbGeneticAlgorithm: TRadioButton;
    cbOpenCL: TCheckBox;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMethodPitOptimization: TfmMethodPitOptimization;

implementation

{$R *.fmx}

procedure TfmMethodPitOptimization.FormShow(Sender: TObject);
begin
  inherited;
  Langs.Lang := CurLang;
  Caption := TransManually(Caption, Langs);
end;

end.
