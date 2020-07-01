//---------------------------------------------------------------------------
// This unit is part of the Gexoblock System, http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------

unit fFileDataBrowser;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.IOUtils,
  System.Classes,
  System.Variants,
  System.StrUtils,
  System.Rtti,
  System.ImageList,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.TreeView,
  FMX.Menus,
  FMX.ListBox,
  Data.Bind.Controls,
  FMX.Grid.Style,
  FMX.ScrollBox,
  FMX.Grid,
  FireDAC.Comp.Client,
  Fmx.Bind.Navigator,
  FMX.TabControl,
  FMX.ImgList,

  fInitialForm,
  uGlobals,
  dBase,
  dDialogs,
  dImages,
  frShowTable;

type
  TfmFileDataBrowser = class(TfmInitialForm)
    TreeView: TTreeView;
    procedure FormCreate(Sender: TObject);
  private
    procedure FillFilesTreeView(const ATreeView: TTreeView; const ADir: string);
    procedure OpenBase(ADatabase, ATable: string);

  public
    slFiles: TStringList;
  end;


var
  fmFileDataBrowser: TfmFileDataBrowser;

//============================================================
implementation
//============================================================

{$R *.fmx}


procedure TfmFileDataBrowser.FillFilesTreeView(const ATreeView: TTreeView;
  const ADir: string);
begin
   // to do
   ///  ReadDBFiles;

(* Get Tables for each DB and add them to SubItems *)

///    for i := 1 to n - 1 do
///      AddChild(TreeView, slFiles.Names[i], i, TreeView);
///      AddChild(Parent: TFMXObject; Text: string; key_val: integer; TreeView: TTreeView);
///      TreeView.Items[k].AddObject(slFiles.Names[i]);

end;

procedure TfmFileDataBrowser.FormCreate(Sender: TObject);

begin
  inherited;
  FillFilesTreeView(TreeView, PathDataBase);
end;

//===========================================================================

procedure TfmFileDataBrowser.OpenBase(ADatabase, ATable: string);
begin
  dmBase.FDConnection.Connected := False;
  dmBase.FDTable.Active := False;
  dmBase.FDConnection.Params.Database := ADatabase;

  dmBase.FDTable.TableName := ATable;

  dmBase.FDConnection.Connected := True;
  dmBase.FDTable.Active := True;
end;

(*
procedure DatabaseToTreeView(AConnection : TFDConnection; ATreeView : TTreeView );

  procedure ProcessConnection;
  var
    List : TStrings;
    //Node : TTreeNode;
    I    : integer;

    procedure ProcessCatalogueName(const ACatalogueName : string; ARoot : TTreeNode );
      var
        List : TStrings;
        //Node : TTreeNode;
        I    : integer;

      procedure ProcessTableName(const ATableName : string; ARoot : TTreeNode );
      var
        List : TStrings;
        // Node : TTreeNode;
        I    : integer;
      begin
        List := TStringList.Create;
        try
          AConnection.GetFieldNames(ACatalogueName, '', ATableName, '', List );
          for I := 0 to List.Count-1 do
            begin
            {Node := }ATreeView.Items.AddChild( ARoot, List[I] );
            // xxxxxxxxxxxxxxxxxxx
            end;
        finally
          List.Free;
        end;
      end;

      begin
        List := TStringList.Create;
        try
          AConnection.GetTableNames(ACatalogueName, '', '', List );
          for I := 0 to List.Count-1 do
            begin
            Node := ATreeView.Items.AddChild(ARoot, List[I] );
            ProcessTableName(List[I], Node );
            end;
        finally
          List.Free;
        end;
      end;

    begin
      List := TStringList.Create;
      try
        AConnection.GetCatalogNames( '', List );

        if List.Count = 0 then
          ProcessCatalogueName('', nil )
         else
          for I := 0 to List.Count-1 do
            begin
            Node := ATreeView.Items.AddChild(nil, List[I] );
            ProcessCatalogueName(List[I], Node );
            end;
      finally
        List.Free;
      end;
    end;
  begin
    ATreeView.Items.Clear;
    ATreeView.Items.BeginUpdate;
    try
      ProcessConnection;
    finally
      ATreeView.Items.EndUpdate;
    end;
  end;

begin
  dmBase.FDConnection.Open;
  dmBase.FDQuery.Active := true;
  DatabaseToTreeView(dmBase.FDConnection, TreeView);
end;
*)

{
procedure FilePathToTreeNode(aTreeView:TTreeView; aRoot:TTreeNode; Path:string; Recurse:boolean);
var
  NewNode : TTreeNode;
  SRec : TSearchRec;
begin
  if FindFirst(Path + '*.*', faAnyFile, SRec) = 0 then
  repeat
    if (sRec.Name = '.') or (sRec.Name = '..') then
      Continue;
    NewNode := aTreeView.Items.AddChild(aRoot, SRec.Name);
    if Recurse and ((srec.Attr and faDirectory) <> 0) then
      FilePathToTreeNode(aTreeView, NewNode, Path + srec.name + '\', True);
  until FindNext(SRec) <> 0;
  FindClose(SRec);
end;

//Call it like this:
FilePathToTreeNode(TreeView1, nil, 'c:\', True);
}

{
procedure TForm1.GetDirectories(Tree: TTreeView; Directory: string;
  Item: TTreeNode; IncludeFiles: Boolean);
var
  SearchRec: TSearchRec;
  ItemTemp: TTreeNode;
begin
  Tree.Items.BeginUpdate;
  if Directory[Length(Directory)] <> '\' then
    Directory := Directory + '\';
  if FindFirst(Directory + '*.*', faDirectory, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory = faDirectory) and
      (SearchRec.Name[1] <> '.') then
      begin
        if (SearchRec.Attr and faDirectory > 0) then
          Item := Tree.Items.AddChild(Item, SearchRec.Name);
        ItemTemp := Item.Parent;
        GetDirectories(Tree, Directory + SearchRec.Name, Item, IncludeFiles);
        Item := ItemTemp;
      end
      else if IncludeFiles then
        if SearchRec.Name[1] <> '.' then
          Tree.Items.AddChild(Item, SearchRec.Name);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
  Tree.Items.EndUpdate;
end;
}

(*
// Probes
procedure TfmFileDataBrowser.TreeViewItem52Click(Sender: TObject);
begin
  OpenBase(PathDataBase+'\Base\Probes'+DBext,'Assays');
end;

//Models
procedure TfmFileDataBrowser.TreeViewItem84Click(Sender: TObject);
begin
  OpenBase(PathDataBase+'\Base\Points2D'+DBext,'civil');
end;

//Reference
procedure TfmFileDataBrowser.TreeViewItem3Click(Sender: TObject);
begin
  OpenBase(PathDataBase+'\Reference\Reference_rus'+DBext,'Chemics');
end;

*)

end.
