unit frFileDataBrowser;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.StrUtils,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.TreeView,
  FireDAC.Comp.Client,

  uGlobals,
  dBase;

type
  TFrameDataBrowser = class(TFrame)
    TreeViewData: TTreeView;
    TreeViewItem1: TTreeViewItem;
    TreeViewItem2: TTreeViewItem;
    TreeViewItem3: TTreeViewItem;
  public
    slFiles: TStringList;
    FDQuery: TFDQuery;
    procedure RemoveSubItems(ARoot: TTreeViewItem);
    function GetFileList(aDir: String): integer;
    function GetSelectedItem: String;
    procedure ReadDBFiles;

    function FindItemByText(aVal: String; aTreeView: TTreeView): TTreeViewItem;
    procedure SelectItemByText(const sText: String; aTreeView: TTreeView);
    function GetPathFromTreeViewItem(aItem: TTreeViewItem): String;

    procedure AddChild(Parent: TFMXObject; Text: string; key_val: integer; aTreeView: TTreeView);
    function ItemByTag(aTreeView: TTreeView; id_parent: integer): TTreeViewItem;
    function BuildTree(aTreeView: TTreeView; aFDQuery: TFDQuery): boolean;

    procedure OpenDataBase(ADatabase, ATable: string);
  private
  end;

var
  FrameDataBrowser : TFrameDataBrowser;

//==============================================
implementation
//==============================================

{$R *.fmx}

{ TFrameDataBrowser }

procedure TFrameDataBrowser.AddChild(Parent: TFMXObject; Text: string;
  key_val: integer; aTreeView: TTreeView);
var
 TreeViewItem: TTreeViewItem;
 aLabel: TLabel;
begin
  TreeViewItem := TTreeViewItem.Create(aTreeView);
  TreeViewItem.Name := 'TreeViewItem' + key_val.ToString;
  TreeViewItem.StyleLookup := 'TreeViewItemStyle';

  if not Assigned(Parent) then
    TreeViewItem.Parent := aTreeView
  else
    TreeViewItem.Parent := Parent;

  aLabel := TLabel.create(TreeViewItem);
  aLabel.Parent := TreeViewItem;
  aLabel.Align := TAlignLayout.Right;
  aLabel.TextSettings.HorzAlign := TTextAlign.Trailing;
  aLabel.Text := key_val.ToString;
//  aLabel.Padding.Right := 5;

  TreeViewItem.Text:= text;
  TreeViewItem.Tag := key_val;
end;


procedure TFrameDataBrowser.OpenDataBase(ADatabase, ATable: string);
var
  aList: TStrings;
begin
/// FDQuery.SQL.Text := 'select * from sqlite_master where type = ATable';
///  FDQuery.GetFieldNames(aList);

  dmBase.FDConnection.Connected := False;
  dmBase.FDTable.Active := False;
  dmBase.FDConnection.Params.Database := ADatabase;

{
  dmBase.FDConnection.GetTableNames(const ACatalogName, ASchemaName, APattern: string;
    AList: TStrings; AScopes: TFDPhysObjectScopes = [osMy];
    AKinds: TFDPhysTableKinds = [tkSynonym, tkTable, tkView]; AFullName: Boolean = True);

  dmBase.FDConnection.GetTableNames('NORTHWIND', 'DBO', 'ADQA%', '', ListBox1.Items,
  [osMy, osSystem, osOther], [tkTable, tkView]);
}

///  dmBase.FDConnection.GetTableNames(ADatabase,..)
  dmBase.FDTable.TableName := ATable;

  dmBase.FDConnection.Connected := True;
  dmBase.FDTable.Active := True;
///  TGrid.Title := ATable;
  FrameDataBrowser.Repaint;
end;


function TFrameDataBrowser.BuildTree(aTreeView: TTreeView;
  aFDQuery: TFDQuery): boolean;
var
  TreeViewItem: TTreeViewItem;
begin
  aFDQuery.Close;
  aFDQuery.Open;// select id, parent, name
  if aFDQuery.RecordCount <= 0 then
    Exit(False);
  aFDQuery.First;
  aTreeView.Clear;
  aTreeView.BeginUpdate;
  try
    while not aFDQuery.Eof do
    begin
      if VarIsNull(aFDQuery.Fields[1].Value) then
        AddChild(nil, aFDQuery.Fields[2].Value, aFDQuery.Fields[0].Value, aTreeView)
      else
      begin
        TreeViewItem := ItemByTag(aTreeView, aFDQuery.Fields[1].Value);
        TreeViewItem.Name := 'TreeViewItem' + aFDQuery.Fields[1].AsString;
        TreeViewItem.Height := 40;
        AddChild(TreeViewItem, aFDQuery.Fields[2].Value, aFDQuery.Fields[0].Value, aTreeView);
      end;// else
      aFDQuery.Next;
    end;// while
  finally
    aTreeView.EndUpdate;
  end;
  Result := True;
end;

function TFrameDataBrowser.FindItemByText(aVal: String;
  aTreeView: TTreeView): TTreeViewItem;
var
  aItem: TTreeViewItem;
begin
  aItem := nil;
  aVal := AnsiUpperCase(aVal);
  aTreeView.EnumControls(
    function(Control: TControl): TEnumControlsResult
    begin
      if (Control is TTreeViewItem) then
      begin
        if ContainsText((TTreeViewItem(Control).Text), aVal) then
        begin
          aItem  := TTreeViewItem(Control);
          Result := TEnumControlsResult.Discard;
        end
        else
          Result := TEnumControlsResult.Continue;
      end
      else
        Result := TEnumControlsResult.Continue;
    end);
  Result := AItem;
end;

function TFrameDataBrowser.GetFileList(aDir: String): integer;
var
  fs: TSearchRec;
begin
  Result := 0;
  if FindFirst(aDir + PathDelim +'*.sqlite', faAnyFile - faDirectory - faVolumeID, fs) = 0
  then
    repeat
      slFiles.Add(fs.Name);
      Inc(Result);
    until FindNext(fs) <> 0;
  FindClose(fs);
end;

// If you need a loop on parents then use a ParentItem
function TFrameDataBrowser.GetPathFromTreeViewItem(
  aItem: TTreeViewItem): String;
begin
  if aItem = nil then exit('not selected');
  while Assigned(aItem) and (aItem is TTreeViewItem) do
  begin
    Result := aItem.Text + PathDelim + Result;
    aItem := TTreeViewItem(aItem.ParentItem);
  end;
  Delete(Result, Length(Result), 1);
end;

function TFrameDataBrowser.GetSelectedItem: String;
begin
  if TreeViewData.Selected.ResultingTextSettings <> nil then
    Result := IntToStr(TreeViewData.Selected.GlobalIndex);
end;

function TFrameDataBrowser.ItemByTag(aTreeView: TTreeView;
  id_parent: integer): TTreeViewItem;
var
  aItem: TTreeViewItem;
begin
  aItem := nil;
  aTreeView.EnumControls(
  function(Control: TControl): TEnumControlsResult
  begin
    if (Control is TTreeViewItem) then
    begin
      if TTreeViewItem(Control).Tag = id_parent then
      begin
        aItem  := TTreeViewItem(Control);
        Result := TEnumControlsResult.Discard;
      end
      else
        Result := TEnumControlsResult.Continue;
    end
    else
      Result := TEnumControlsResult.Continue;
  end);
  Result := aItem;

end;

procedure TFrameDataBrowser.ReadDBFiles;
var
  I, n: Integer;
  Bool: Boolean;
  aItem : TTreeViewItem;
begin
  try
    slFiles := TStringList.Create;
    PathExe := GetCurrentDir();
    Delete(PathExe,Length(PathExe) - 2, 3);

    PathDataBase := PathExe + DirDataBase;

    Bool:= SetCurrentDir(PathDataBase);
    n := GetFileList(PathDataBase);

/// to Add a first root node use TreeViewData.Items[0].AddObject(nil) ;
    TreeViewData.BeginUpdate;
    for i := 0 to n-1 do
    begin
      AItem:= TTreeViewItem.Create(nil);
      AItem.Parent := TreeViewData;
      AItem.Text :=  slFiles[i];
      AItem.ImageIndex := i;
    end;
    TreeViewData.EndUpdate;
  finally
    slFiles.Free;
  end;

end;

procedure TFrameDataBrowser.RemoveSubItems(ARoot: TTreeViewItem);
var
  SubItem: TTreeViewItem;
begin
  Assert(ARoot <> nil);
  while ARoot.Count > 0 do
  begin
    SubItem := ARoot.ItemByIndex(0);
    SubItem.Parent := nil;
    FreeAndNil(SubItem);
  end;
end;

procedure TFrameDataBrowser.SelectItemByText(const sText: String;
  aTreeView: TTreeView);
var
 TreeViewItem: TTreeViewItem;
begin
  TreeViewItem := FindItemByText(sText, aTreeView);
  if Assigned(TreeViewItem) then
    TreeViewItem.Select;
end;

end.
