unit frShowTable;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Bindings.Outputs,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  Data.Bind.Controls,
  System.Rtti,
  FMX.Grid.Style,
  Data.Bind.EngExt,
  Fmx.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  FMX.ScrollBox,
  FMX.Grid,
  FMX.Layouts,
  Fmx.Bind.Navigator,
  FMX.Controls.Presentation;

type
  TFrameShowTable = class(TFrame)
    ToolBarTable: TToolBar;
    BindNavigator: TBindNavigator;
    GridTable: TGrid;
    BindingsList: TBindingsList;
    BindExpressionmiFileNew1: TBindExpression;
    BindSourceDB: TBindSourceDB;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
