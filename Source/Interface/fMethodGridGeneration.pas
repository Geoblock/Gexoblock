unit fMethodGridGeneration;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ImgList,
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Objects,

  fMethodDialog,
  uGlobals;


type
  TfmMethodGridGeneration = class(TfmMethodDialog)
    Langs: TLang;
    gbModelSize: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMethodGridGeneration: TfmMethodGridGeneration;

//======================================================
implementation
//======================================================

{$R *.fmx}

procedure TfmMethodGridGeneration.FormCreate(Sender: TObject);
begin
  inherited;
  Langs.Lang := CurLang;
  Caption := TransManually(Caption, Langs);

end;

end.
