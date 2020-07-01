//---------------------------------------------------------------------------
// This unit is part of the Gexoblock System, http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------

unit fGexoblock;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.SysConst,
  System.Bindings.Outputs,
  System.Rtti,
  System.IniFiles,
  System.Math.Vectors,
  System.Actions,
  System.ImageList,
  FMX.Types,
  FMX.StdCtrls,
  FMX.Controls,
  FMX.Controls3D,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Ani,
  FMX.Menus,
  FMX.Bind.DBEngExt,
  FMX.Bind.Editors,
  FMX.Types3D,
  FMX.Layers3D,
  FMX.Controls.Presentation,
  FMX.StdActns,
  FMX.ActnList,
  FMX.ImgList,
  FMX.Layouts,
  FMX.TreeView,
  FMX.Grid.Style,
  FMX.ScrollBox,
  FMX.Grid,
  Fmx.Bind.Navigator,
  FMX.TabControl,
  FMX.Styles.Objects,
  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.Controls,
  Data.Bind.DBScope,
  Data.Bind.Grid,

  dBase,
  dDialogs,
  dImages,
  uGlobals,
  fInitialForm,
  fMethodGridGeneration,
  fMethodInterpolation,
  fMethodPitOptimization,
  frShowScene,
//  fFileDataBrowser,  <- Old form, now frame frFileDataBrowser
  frFileDataBrowser,
  frShowTable;

type
  TfmGexoblock = class(TfmInitialForm)
    Layer3D1: TLayer3D;
    Layout3D1: TLayout3D;
    Light1: TLight;
    StyleBook: TStyleBook;
    acWindowTiles: TAction;
    ActionList: TActionList;
    acFileOpenProject: TAction;
    acFileSave: TAction;
    acFileClose: TAction;
    acWindowClose: TWindowClose;
    acFileExit: TFileExit;
    acSaveAs: TAction;
    acEditUndo: TAction;
    acDrawPoints: TAction;
    acViewMap: TAction;
    acViewScene: TAction;
    acViewGraph: TAction;
    acToolsOptions: TAction;
    acMethodInterpolation: TAction;
    acMethodGridGeneration: TAction;
    acMethodTriangulation: TAction;
    acMethodSetOperations: TAction;
    acMethodPitOptimization: TAction;
    acHelpAbout: TAction;
    acContent: TAction;
    acHelpSep: TAction;

    MainMenu: TMainMenu;
    MenuMethodGridGeneration: TMenuItem;
    MenuItem16: TMenuItem;
    miMethod: TMenuItem;
    miHelp: TMenuItem;
    miHelpGlossary: TMenuItem;
    miFile: TMenuItem;
    miFileSave: TMenuItem;
    miFileOpenProject: TMenuItem;
    miEdit: TMenuItem;
    MenuItem2: TMenuItem;
    miFileSeparator: TMenuItem;
    miFileExit: TMenuItem;
    miHelpContent: TMenuItem;
    MenuItemHelpSep: TMenuItem;
    miHelpAbout: TMenuItem;
    MenuMethodInterpolation: TMenuItem;
    miMethodTriangulation: TMenuItem;
    miView: TMenuItem;
    miDraw: TMenuItem;
    miViewMap: TMenuItem;
    miViewScene: TMenuItem;
    miViewGraph: TMenuItem;
    miAnalyse: TMenuItem;
    miTools: TMenuItem;
    miWindow: TMenuItem;
    miToolsOptions: TMenuItem;
    Langs: TLang;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    acFileImport: TAction;
    miFileImport: TMenuItem;
    MenuItem4: TMenuItem;
    acViewTable: TAction;
    PanelLeft: TPanel;
    SplitterLeft: TSplitter;
    PanelCenter: TPanel;
    SplitterRight: TSplitter;
    PanelRight: TPanel;
    ImageListOutput: TImageList;
    ImageListInput: TImageList;
    ToolBarVertical: TToolBar;
    sbMethodGridgeneration: TSpeedButton;
    sbMethodTriangulation: TSpeedButton;
    sbPitOptimization: TSpeedButton;
    ToolBarData: TToolBar;
    LabelData: TLabel;
    PanelBottom: TPanel;
    StatusBar: TStatusBar;
    PanelTop: TPanel;
    ToolBarMain: TToolBar;
    sbDatabaseBrowser: TSpeedButton;
    SpeedButton1: TSpeedButton;
    ToolBarProject: TToolBar;
    LabelProject: TLabel;
    TreeViewProject: TTreeView;
    TabControlContent: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    SpeedButton9: TSpeedButton;
    FrameDataBrowser: TFrameDataBrowser;
    sbMultiView: TSpeedButton;
    cbMultiView: TCheckBox;
    SplitterCentral: TSplitter;
    FrameShowTable: TFrameShowTable;
    FrameShowScene: TFrameShowScene;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acFileExitCanActionExec(Sender: TCustomAction;
      var CanExec: Boolean);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acMethodInterpolationExecute(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acToolsOptionsExecute(Sender: TObject);
    procedure acMethodGridGenerationExecute(Sender: TObject);
    procedure acMethodPitOptimizationExecute(Sender: TObject);
    procedure sbCenterClick(Sender: TObject);
    procedure sbMultiViewClick(Sender: TObject);
    procedure cbMultiViewChange(Sender: TObject);
  public
    IniFile: TIniFile;
    procedure ReadIniFile; override;
    procedure WriteIniFile; override;
  private
    procedure TranslateMainMenu;
    procedure DefaultLayout;
  end;

var
  fmGexoblock: TfmGexoblock;

//====================================================================
implementation
//====================================================================

{$R *.fmx}

uses
  fHelpAbout,
  fToolsOptions;

procedure TfmGexoblock.DefaultLayout;
begin
  PanelCenter.Visible := True;
  PanelRight.Visible := True;
end;

procedure TfmGexoblock.FormCreate(Sender: TObject);
begin
  inherited;
  ReadIniFile;
  TranslateMainMenu;
  with FrameDataBrowser do
  begin
    ReadDBFiles;
    ///BuildTree(TreeViewData, qTree);
  end;

 /// Application.OnHint      := OnApplicationHint(Sender);
end;

procedure TfmGexoblock.FormShow(Sender: TObject);
begin
  inherited;
  DefaultLayout;
end;

procedure TfmGexoblock.TranslateMainMenu;
var
  I : Integer;
begin
  //LoadLangFromStrings(Langs.LangStr[CurLang]); to switch in runtime
  Langs.Lang := CurLang;
  Caption := Translate(Caption);

  miFile.Text := Translate(miFile.Text);
  for I := 0 to miFile.ItemsCount - 1 do
    miFile.Items[I].Text := Translate(miFile.Items[I].Text);

  miEdit.Text := Translate(miEdit.Text);
  for I := 0 to miEdit.ItemsCount - 1 do
    miEdit.Items[I].Text := Translate(miEdit.Items[I].Text);

  miMethod.Text := Translate(miMethod.Text);
  for I := 0 to miMethod.ItemsCount - 1 do
    miMethod.Items[I].Text := Translate(miMethod.Items[I].Text);

  miDraw.Text := Translate(miDraw.Text);
  for I := 0 to miDraw.ItemsCount - 1 do
    miDraw.Items[I].Text := Translate(miDraw.Items[I].Text);

  miView.Text := Translate(miView.Text);
  for I := 0 to miView.ItemsCount - 1 do
    miView.Items[I].Text := Translate(miView.Items[I].Text);

  miAnalyse.Text := Translate(miAnalyse.Text);
  for I := 0 to miAnalyse.ItemsCount - 1 do
    miAnalyse.Items[I].Text := Translate(miAnalyse.Items[I].Text);

  miTools.Text := Translate(miTools.Text);
  for I := 0 to miTools.ItemsCount - 1 do
    miTools.Items[I].Text := Translate(miTools.Items[I].Text);

  miWindow.Text := Translate(miWindow.Text);
  for I := 0 to miWindow.ItemsCount - 1 do
    miTools.Items[I].Text := Translate(miWindow.Items[I].Text);

  miHelp.Text := Translate(miHelp.Text);
  for I := 0 to miHelp.ItemsCount - 1 do
    miHelp.Items[I].Text := Translate(miHelp.Items[I].Text);
end;


//----------------- Actions ---------------------\\

procedure TfmGexoblock.acFileExitCanActionExec(Sender: TCustomAction;
  var CanExec: Boolean);
begin
  Application.Terminate;
end;

procedure TfmGexoblock.acMethodGridGenerationExecute(Sender: TObject);
begin
  with TfmMethodGridGeneration.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmGexoblock.acMethodInterpolationExecute(Sender: TObject);
begin
  with TfmMethodInterpolation.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmGexoblock.acMethodPitOptimizationExecute(Sender: TObject);
begin
  with TfmMethodPitOptimization.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmGexoblock.acSaveAsExecute(Sender: TObject);
begin
  //Save As
end;

procedure TfmGexoblock.acToolsOptionsExecute(Sender: TObject);
begin
  with TfmToolsOptions.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;


//_______________________ Help ________________________\\

procedure TfmGexoblock.acHelpAboutExecute(Sender: TObject);
begin
  with TfmHelpAbout.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

{
procedure TfmGexoblock.HelpContentsExecute(Sender: TObject);
begin
  Application.HelpShowTableOfContents;
end;

procedure TfmGexoblock.HelpGlossaryExecute(Sender: TObject);
begin
  Application.HelpContext(HelpGlossary.HelpContext);
end;
}


procedure TfmGexoblock.ReadIniFile;
var
  StyleID: integer;
begin
  inherited;
  StyleID := 0;
  PathExe := ExtractFilePath(ParamStr(0));
  SetCurrentDir(PathExe);
  IniFile := TIniFile.Create(PathExe + 'Gexoblock.ini');
  with IniFile do
    try
      Top := ReadInteger(Name, 'Top', 100);
      Left := ReadInteger(Name, 'Left', 200);
      if ReadBool(Name, 'InitMax', False) then
        // WindowState = wsMaximized
      else
        // WindowState = wsNormal;
        StyleID := ReadInteger(Name, 'StyleID', 0);
      if StyleID = 0 then
      begin
        // ActionManager.Style := StandardStyle;
        // ToolsStandardStyle.Checked := True;
      end
      else
      begin
        // ActionManager.Style  := XPStyle;
        // ToolsXPStyle.Checked := True;
      end
    finally
      IniFile.Free;
    end;
end;


procedure TfmGexoblock.sbCenterClick(Sender: TObject);
begin
  FrameShowTable.Visible := not FrameShowTable.Visible;
end;


procedure TfmGexoblock.cbMultiViewChange(Sender: TObject);
begin
  FrameDataBrowser.TreeViewData.ShowCheckboxes := cbMultiView.IsChecked;
end;

procedure TfmGexoblock.sbMultiViewClick(Sender: TObject);
begin
///
end;

procedure TfmGexoblock.WriteIniFile;
begin
  PathExe := ExtractFilePath(ParamStr(0));
  SetCurrentDir(PathExe);
  IniFile := TIniFile.Create(PathExe + 'Gexoblock.ini');
  with IniFile do
    try
      WriteInteger(Name, 'Top', Top);
      WriteInteger(Name, 'Left', Left);
      /// in VCL      WriteBool(Name, 'InitMax', WindowState = wsMaximized);
      {
        if ActionManager.Style = StandardStyle then
        WriteInteger(Name, 'StyleID', 0)
        else
        WriteInteger(Name, 'StyleID', 1);
      }
    finally
      IniFile.Free;
    end;
  inherited;
end;

procedure TfmGexoblock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    //fmViewProjectManager.SaveToFile(ExpandPath(DirProject) + 'Gexoblock.prj');
  except
  end;
  WriteIniFile;
  inherited;
end;

end.
