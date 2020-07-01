unit dDialogs;

interface

uses
  System.SysUtils,
  System.Classes,
  System.ImageList,
  FMX.Types,
  FMX.Dialogs,
  FMX.Printer,
  FMX.ImgList;

type
  TdmDialogs = class(TDataModule)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    PageSetupDialog: TPageSetupDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDialogs: TdmDialogs;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
