unit fMethodDialog;

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
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.ListBox,
  FMX.ImgList,
  FMX.Edit,

  fInitialDialog, FMX.Menus;

type
  TfmMethodDialog = class(TfmInitialDialog)
    ImageListInput: TImageList;
    ToolBar2: TToolBar;
    sbMap: TSpeedButton;
    ImageListOutput: TImageList;
    sbPlot: TSpeedButton;
    sbTable: TSpeedButton;
    LabelEmpty: TLabel;
    EditOutput: TEdit;
    LabelOutput: TLabel;
    ProgressBar: TProgressBar;
    PanelInputA: TPanel;
    LabelInputA: TLabel;
    ToolBarInputA: TToolBar;
    sbDholes: TSpeedButton;
    sbPoints2D: TSpeedButton;
    sbPoints3D: TSpeedButton;
    sbPolygons: TSpeedButton;
    sbTINs: TSpeedButton;
    sbSolids: TSpeedButton;
    sbGrids2D: TSpeedButton;
    sbGrids3D: TSpeedButton;
    sbMeshes2D: TSpeedButton;
    sbMeshes3D: TSpeedButton;
    PanelAttributes: TPanel;
    LabelAttributesA: TLabel;
    ListBoxAttributesA: TListBox;
    PanelModels: TPanel;
    LabelModelsA: TLabel;
    ListBoxInputA: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMethodDialog: TfmMethodDialog;

//============================================================
implementation
//============================================================

{$R *.fmx}

end.
