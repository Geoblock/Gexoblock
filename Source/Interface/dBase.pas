unit dBase;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  Data.FMTBcd,
  Data.SqlExpr,
  Datasnap.DBClient,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.PG,
  FireDAC.Comp.UI,
  FireDAC.Comp.BatchMove,
  FireDAC.Phys.SQLiteVDataSet,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TdmBase = class(TDataModule)
    FDTable: TFDTable;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    DataSource: TDataSource;
    SQLQuery: TSQLQuery;
    SQLTable: TSQLTable;
    SQLConnection: TSQLConnection;
    SQLDataSet: TSQLDataSet;
    FDManager: TFDManager;
    FDTransaction: TFDTransaction;
    FDCommand: TFDCommand;
    FDMemTable: TFDMemTable;
    FDLocalSQL: TFDLocalSQL;
    FDTableAdapter: TFDTableAdapter;
    FDBatchMove: TFDBatchMove;
    ClientDataSet: TClientDataSet;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmBase: TdmBase;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
