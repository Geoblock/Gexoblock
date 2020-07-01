//---------------------------------------------------------------------------
// This unit is part of the Gexoblock System, http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------
{! InitialDialog is the parent dialog for all dialogs}

unit fInitialDialog;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Menus,

  fInitialForm;

type
  TfmInitialDialog = class(TfmInitialForm)
    PanelTop: TPanel;
    PanelMiddle: TPanel;
    PanelBottom: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ButtonHelp: TButton;
    procedure ButtonHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: boolean; virtual;
  end;

var
  fmInitialDialog: TfmInitialDialog;

//========================================================================
implementation
//========================================================================

{$R *.fmx}

procedure TfmInitialDialog.ButtonHelpClick(Sender: TObject);
begin
  inherited;
  //in VCL Application.HelpContext(HelpContext);
  ButtonHelp.HelpContext := 0; //??? HelpContext;
end;

function TfmInitialDialog.Execute: boolean;
begin
  Result := ShowModal = mrOk;
end;

end.
