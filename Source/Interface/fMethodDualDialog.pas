unit fMethodDualDialog;

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

  fMethodDialog;

type
  TfmMethodDualDialog = class(TfmMethodDialog)
    Panel1: TPanel;
    LabelInputB: TLabel;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    Panel2: TPanel;
    LabelAttributesB: TLabel;
    ListBoxAttributesB: TListBox;
    Panel3: TPanel;
    LabelModelsB: TLabel;
    ListBoxModelsB: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMethodDualDialog: TfmMethodDualDialog;

//==================================================================
implementation
//==================================================================

{$R *.fmx}

end.
