unit fMethodInterpolation;

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
  fMethodDualDialog,
  FMX.ImgList,
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Menus,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  uGlobals,
  fInitialForm,
  dBase,
  uInterpol,


  Import.OpenCL,
  Import.OpenCL_Platform,
  Import.OpenCL_GL;

type
  TfmMethodInterpolation = class(TfmMethodDualDialog)
    Panel4: TPanel;
    LabelMethod: TLabel;
    rbIDW: TRadioButton;
    rbCPI: TRadioButton;
    rbNNI: TRadioButton;
    rbKRI: TRadioButton;
    rbPRI: TRadioButton;
    rbLTIN: TRadioButton;
    ButtonOptions: TButton;
    CheckBoxOpenCL: TCheckBox;
    CheckBoxVariance: TCheckBox;
    Langs: TLang;
    EditExtraValue: TEdit;
    lbExtraValue: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Fields:TFields;           //WorkFields from Scatter Point Table
    ErrCode_Ret: Tcl_int; // error code returned from api calls
    ///platform_devices: array of Tcl_platform_device;
  	Num_Devices_Returned: Tcl_uint;
  	Device_ids: array of Tcl_device_id; // compute device IDs
  	Context: Tcl_context; // compute context
    KrigingParamsSet: boolean;
    procedure Interpolate(TablePoints, TableNodes: TFDTable);
    procedure UpdateAttributeListB;
    procedure ReadGridParameters;
    procedure ReadIniFile;
    procedure WriteIniFile;
  end;

var
  fmMethodInterpolation: TfmMethodInterpolation;

//=========================================================
implementation
//=========================================================

{$R *.fmx}

procedure TfmMethodInterpolation.FormCreate(Sender: TObject);
begin
  inherited;
  ReadIniFile;
  ReadGridParameters;
  KrigingParamsSet := false;
end;

procedure TfmMethodInterpolation.FormShow(Sender: TObject);
begin
  inherited;
  Langs.Lang := CurLang;
  Caption := TransManually(Caption, Langs);
end;


procedure TfmMethodInterpolation.Interpolate(TablePoints, TableNodes: TFDTable);
var
  OldCursor: TCursor;
  // Vars for Points and Nodes
  PointsArr, NodesArr: TCoordinateArray;
  i, j: Integer;
  // vars for triangulatuion for Linear by Tin interpolation
  VertexTableName, TriangleTableName: string;
  TrianglesArr: Variant;
  TableTinVertex, TableTinTriangle: TFDTable;
  //opencl
  OpenCLProgram: Tcl_program;
  OpenCLVectorAdd: Tcl_kernel;
  CommandQueue: Tcl_command_queue;
  Returned_Size: TSize_t;
  // general
  ExtraValue: double;
  FieldName: string;
  Field_Included: boolean;

begin
  ExtraValue := StrToFloat(EditExtraValue.Text);

(*
  OldCursor := Screen.Cursor;
  ActiveAttributeB := ListBoxRealAttributeB.Items[ListBoxRealAttributeB.ItemIndex];
  TablePoints.Open;
  TableNodes.Open;

  ProgressBar.Min   := 1;
  ProgressBar.Max := TableNodes.RecordCount;
  ProgressBar.Position := ProgressBar.Min;
  ProgressBar.Step  := 1;

{
  ProgressBar.Min := Low(Nodes);
  ProgressBar.Max := High(Nodes) + 1;
  ProgressBar.Position := ProgressBar.Min;
  ProgressBar.Step := 1;
}

  try
    Screen.Cursor := crHourGlass;
    {// Get compute devices from platform
	errcode_ret:=clGetDeviceIDs(platform_devices[ListCouple.ItemIndex].platform_id, platform_devices[ListCouple.ItemIndex].device_type, 0, nil, @num_devices_returned);
  SetLength(device_ids, num_devices_returned);
  errcode_ret:=clGetDeviceIDs(platform_devices[ListCouple.ItemIndex].platform_id, platform_devices[ListCouple.ItemIndex].device_type, num_devices_returned, @device_ids[0], @num_devices_returned);
   // Create a compute context
	context:=clCreateContext(nil, num_devices_returned, @device_ids[0], nil, nil, @errcode_ret);
  // End (Init Context)
  }
    case RadioGroupMethod.ItemIndex of
      //_________________Inverse Distance Interpolation________________
      imInverseDistances:
      begin
        // Read TableNodes
        SetLength(NodesArr, TableNodes.RecordCount);
        TableNodes.Open;
        TableNodes.First;
        for I := 0 to TableNodes.RecordCount - 1 do
        begin
          ProgressBar.Position := I;

          NodesArr[i].X := TableNodes.FieldByName(fldX).AsFloat;
          NodesArr[i].Y := TableNodes.FieldByName(fldY).AsFloat;
          if Mode3d then
            NodesArr[i].Z := TableNodes.FieldByName(fldZ).AsFloat
          else
            NodesArr[i].Z := 0;
          TableNodes.Next;
         end;
        TableNodes.Close;

        // Read TablePoints
        SetLength(PointsArr, TablePoints.RecordCount);
        TablePoints.Open;
        TablePoints.First;
        j := 0;
        for I := 0 to TablePoints.RecordCount - 1 do
        begin
          if not TablePoints.FieldByName(ActiveAttributeB).IsNull then
          begin
            PointsArr[j].X := TablePoints.FieldByName(fldX).AsFloat;
            PointsArr[j].Y := TablePoints.FieldByName(fldY).AsFloat;
            if Mode3d then
              PointsArr[j].Z := TablePoints.FieldByName(fldZ).AsFloat
            else
              PointsArr[j].Z := 0;
            PointsArr[j].Value := TablePoints.FieldByName(ActiveAttributeB).AsFloat;
            Inc(j);
          end;
          TablePoints.Next;
        end;
        SetLength(PointsArr, j);
        TablePoints.Close;

        InverseDistanceInterpolation(PointsArr, NodesArr, InvDistPars);

        // Write to TableNodes
        AddTableField(TableNodes.TableName, ActiveAttributeB + '_IDW', ftFloat);
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          TableNodes.Edit;
          TableNodes.FieldByName(ActiveAttributeB + '_IDW').Value :=
            RoundTo(NodesArr[i].Value, Precision);
          TableNodes.Post;
          TableNodes.Next;

          ProgressBar.StepIt;

        end;
        TableNodes.Close;

        // releasing the memory
        SetLength(PointsArr, 0);
        SetLength(NodesArr, 0);
      end;   // end of imInverseDistances case

      //_________________Closest Point Gridding________________
      imClosestPoint:
      begin
        // Read TableNodes
        SetLength(NodesArr, TableNodes.RecordCount);
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          NodesArr[i].X := TableNodes.FieldByName(fldX).AsFloat;
          NodesArr[i].Y := TableNodes.FieldByName(fldY).AsFloat;
          if Mode3d then
            NodesArr[i].Z := TableNodes.FieldByName(fldZ).AsFloat
          else
            NodesArr[i].Z := 0;
          TableNodes.Next;
        end;
        TableNodes.Close;

        // Read TablePoints
        SetLength(PointsArr, TablePoints.RecordCount);
        TablePoints.Open;
        TablePoints.First;
        j := 0;
        for I := 0 to TablePoints.RecordCount - 1 do
        begin
          if not TablePoints.FieldByName(ActiveAttributeB).IsNull then
          begin
            PointsArr[j].ID := TablePoints.FieldByName(fldID).AsInteger;
            PointsArr[j].X   := TablePoints.FieldByName(fldX).AsFloat;
            PointsArr[j].Y   := TablePoints.FieldByName(fldY).AsFloat;
            if Mode3d then
              PointsArr[j].Z := TablePoints.FieldByName(fldZ).AsFloat
            else
              PointsArr[j].Z := 0;
            PointsArr[j].Value := TablePoints.FieldByName(ActiveAttributeB).AsFloat;
            Inc(j);
          end;
          TablePoints.Next;
        end;
        SetLength(PointsArr, j);
        TablePoints.Close;

        ClosestPointGridding(PointsArr, NodesArr, ProgressBar);

        // Write to TableNodes
        AddTableField(TableNodes.TableName, ActiveAttributeB + '_CPI', ftFloat);
        begin
          TableNodes.Open;
          TableNodes.First;
          for i := 0 to TableNodes.RecordCount - 1 do
          begin
            TableNodes.Edit;
            TableNodes.FieldByName(ActiveAttributeB + '_CPI').Value :=
              RoundTo(NodesArr[i].Value, Precision);
            TableNodes.Post;
            TableNodes.Next;
          end;
          TableNodes.Close;
        end;
        // Releasing the memory
        SetLength(PointsArr, 0);
        SetLength(NodesArr, 0);
      end; // of imClosestPoint case

      //_________Linear interpolation by tin_____________
      imLinearByTin:
      begin
        VertexTableName   := ChangeModelTable(DirPoints2D, DirTinVertices, TablePoints.TableName);
        TriangleTableName :=
          ChangeModelTable(DirPoints2D, DirTinFaces, TablePoints.TableName);
        SetLength(NodesArr, TableNodes.RecordCount);
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          NodesArr[i].X := TableNodes.FieldByName(fldX).AsFloat;
          NodesArr[i].Y := TableNodes.FieldByName(fldY).AsFloat;
          if Mode3D then
            NodesArr[i].Z := TableNodes.FieldByName(fldZ).AsFloat
          else
            NodesArr[i].Z := 0;
          TableNodes.Next;
        end;
        TableNodes.Close;

        if not FileExists(VertexTableName + TableExt) or not
          FileExists(TriangleTableName + TableExt) then
        begin
          // Read TablePoints
          SetLength(PointsArr, TablePoints.RecordCount);
          TablePoints.Open;
          TablePoints.First;
          for i := 0 to TablePoints.RecordCount - 1 do
          begin
            PointsArr[i].X     := TablePoints.FieldByName(fldX).AsFloat;
            PointsArr[i].Y     := TablePoints.FieldByName(fldY).AsFloat;
            PointsArr[i].Value := TablePoints.FieldByName(ActiveAttributeB).AsFloat;
            TablePoints.Next;
          end;
          TablePoints.Close;

          Linear2DInterpolation(PointsArr, NodesArr, ExtraValue, ProgressBar);
        end  // if

        else
        begin
          TableTinVertex := TTable.Create(self);
          TableTinTriangle := TTable.Create(self);
          TableTinVertex.TableName := VertexTableName;
          TabletinTriangle.TableName := TriangleTableName;
          with TableTinVertex do
          begin
            Open;
            SetLength(PointsArr, RecordCount);
            First;
            for i := 0 to RecordCount - 1 do
            begin
                PointsArr[i].X := FieldByName(fldX).AsFloat;
                PointsArr[i].Y := FieldByName(fldY).AsFloat;
                PointsArr[i].Value := FieldByName(ActiveAttributeB).AsFloat;
                Next;
            end;
            Close;
          end; // of with

          with TableTinTriangle do
          begin
            // Triangles array line format: [V1,V2,V3,N1,N2,N3]
            Open;
            TrianglesArr := VarArrayCreate([1, RecordCount, 1, 6], varInteger);
            First;
            for I := 1 to RecordCount do
            begin
              TrianglesArr[i, 1] := FieldByName(fldV1).AsInteger;
              TrianglesArr[i, 2] := FieldByName(fldV2).AsInteger;
              TrianglesArr[i, 3] := FieldByName(fldV3).AsInteger;
              TrianglesArr[i, 4] := FieldByName(fldN1).AsInteger;
              TrianglesArr[i, 5] := FieldByName(fldN2).AsInteger;
              TrianglesArr[i, 6] := FieldByName(fldN3).AsInteger;
              Next;
            end;
            Close;
          end;
          TableTinVertex.Free;
          TableTinTriangle.Free;
          Linear2DInterpolation(PointsArr, NodesArr, TrianglesArr, ExtraValue, ProgressBar);
        end; // if

        AddTableField(TableNodes.TableName, ActiveAttributeB + '_TIN', ftFloat);

        //Write TableNodes
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          TableNodes.Edit;
          TableNodes.FieldByName(ActiveAttributeB + '_TIN').Value :=
            RoundTo(NodesArr[i].Value, Precision);
          TableNodes.Post;
          TableNodes.Next;
        end;
        TableNodes.Close;

        SetLength(PointsArr, 0);
        SetLength(NodesArr, 0);
      end; // of imLinearByTin case

      //_________PolynomialRegression_________
      imPolynomialRegression:
      begin
        //Loading Points from DB
        SetLength(PointsArr, TablePoints.RecordCount);
        SetLength(NodesArr, TableNodes.RecordCount);
        if Mode3D then
        begin  // 3D mode
          // Read TablePoints
          SetLength(PointsArr, TablePoints.RecordCount);
          TablePoints.Open;
          TablePoints.First;
          for i := 0 to TablePoints.RecordCount - 1 do
          begin
            PointsArr[I].X := TablePoints.FieldValues[fldX];
            PointsArr[I].Y := TablePoints.FieldValues[fldY];
            PointsArr[I].Z := TablePoints.FieldValues[fldZ];
            if (TablePoints.FieldByName(ActiveAttributeB).AsString <> '') then
              PointsArr[I].Value := TablePoints.FieldValues[ActiveAttributeB]
            else
              PointsArr[I].Value := 0.0;
            TablePoints.Next;
          end;

          // Read TableNodes
          SetLength(NodesArr, TableNodes.RecordCount);
          TableNodes.Open;
          TableNodes.First;
          for i := 0 to TableNodes.RecordCount - 1 do
          begin
            NodesArr[I].X := TableNodes.FieldValues[fldX];
            NodesArr[I].Y := TableNodes.FieldValues[fldY];
            NodesArr[I].Z := TableNodes.FieldValues[fldZ];
            TableNodes.Next;
          end;
          TableNodes.Close;
        end
        else // 2D mode
        begin
          // Read TablePoints
          SetLength(PointsArr, TablePoints.RecordCount);
          TablePoints.Open;
          TablePoints.First;
          for I := 0 to TablePoints.RecordCount - 1 do
          begin
            PointsArr[I].X     := TablePoints.FieldValues[fldX];
            PointsArr[I].Y     := TablePoints.FieldValues[fldY];
            PointsArr[I].Value := TablePoints.FieldValues[ActiveAttributeB];
            TablePoints.Next;
          end;
          TablePoints.Close;

          // Read TableNodes
          SetLength(NodesArr, TableNodes.RecordCount);
          TableNodes.Open;
          TableNodes.First;
          for i := 0 to TableNodes.RecordCount - 1 do
          begin
            NodesArr[I].X := TableNodes.FieldValues[fldX];
            NodesArr[I].Y := TableNodes.FieldValues[fldY];
            TableNodes.Next;
          end;
          TableNodes.Close;
        end;

        // Invoke Trend analysis function
        NodesArr := PolyRegressInterpolation(PointsArr, NodesArr, PolyRegressOrder);

        //Write TableNodes
        AddTableField(TableNodes.TableName, ActiveAttributeB + '_PRI', ftFloat);
        TableNodes.Open;
        TableNodes.First;
        for I := 0 to TableNodes.RecordCount - 1 do
        begin
          try
            TableNodes.Edit;
            //write extrapolation value
            TableNodes.FieldByName(ActiveAttributeB + '_PRI').AsFloat :=
              RoundTo(NodesArr[I].Value, Precision);
          finally
            TableNodes.Post;
          end;
          TableNodes.Next;
        end;
        TableNodes.Close;
      end;

      //_________Kriging interpolation_________
      imKriging:
      begin
        // Read TablePoints
        SetLength(PointsArr, TablePoints.RecordCount);
        TablePoints.Open;
        TablePoints.First;
        j := 0;
        for i := 0 to TablePoints.RecordCount - 1 do
        begin
          if not TablePoints.FieldByName(ActiveAttributeB).IsNull then
          begin
            PointsArr[j].X := TablePoints.FieldByName(fldX).AsFloat;
            PointsArr[j].Y := TablePoints.FieldByName(fldY).AsFloat;
            if Mode3d then
              PointsArr[j].Z := TablePoints.FieldByName(fldZ).AsFloat
            else
              PointsArr[j].Z := 0;
            PointsArr[j].Value := TablePoints.FieldByName(ActiveAttributeB).AsFloat;
            Inc(j);
          end;
          TablePoints.Next;
        end;
        SetLength(PointsArr, j);
        TablePoints.Close;

        // Read TableNodes
        SetLength(NodesArr, TableNodes.RecordCount);
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          NodesArr[i].X := TableNodes.FieldByName(fldX).AsFloat;
          NodesArr[i].Y := TableNodes.FieldByName(fldY).AsFloat;
          if Mode3d then
            NodesArr[i].Z := TableNodes.FieldByName(fldZ).AsFloat
          else
            NodesArr[i].Z := 0;
          TableNodes.Next;
        end;
        TableNodes.Close;

        // Krining Interpolation
        Kt_3d(PointsArr, NodesArr, KrigingParams, ProgressBar);
        //  if Mode3d then kt_3d(PointsArr, NodesArr, KrigingParams, ProgressBar)
        //  else kb_2d(PointsArr, NodesArr, ProgressBar);
        AddTableField(TableNodes.TableName, ActiveAttributeB + '_KRI', ftFloat);
        if CheckBoxVariance.Checked then
          AddTableField(TableNodes.TableName, ActiveAttributeB + '_VAR', ftFloat);

        // Write TableNodes
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
          // for i := 0 to High(NodesArr) do
        begin
          TableNodes.Edit;
          TableNodes.FieldByName(ActiveAttributeB + '_KRI').Value :=
            RoundTo(NodesArr[i].Value, Precision);
          if CheckBoxVariance.Checked then
            TableNodes.FieldByName(ActiveAttributeB + '_VAR').Value :=
              RoundTo(NodesArr[i].Variance, Precision * 2)
          else
          if TableNodes.FindField(ActiveAttributeB + '_VAR') <> nil then
            TableNodes.FieldByName(ActiveAttributeB + '_VAR').Value := 0;
          // FieldByName(ActiveAttributeB + '_KRIGING_ERROR').Value :=
          // RoundTo(NodesArr[i].Error, Precision*2);
          TableNodes.Post;
          TableNodes.Next;
        end;
        TableNodes.Close;

        // release the memory
        SetLength(PointsArr, 0);
        SetLength(NodesArr, 0);
      end;

      //_________Natural Neighbour Interpolation_________
      imNaturalNeighbors:
      begin
        // Read TableNodes
        SetLength(NodesArr, TableNodes.RecordCount);
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          NodesArr[i].X := TableNodes.FieldByName(fldX).AsFloat;
          NodesArr[i].Y := TableNodes.FieldByName(fldY).AsFloat;
          if Mode3d then
            NodesArr[i].Z := TableNodes.FieldByName(fldZ).AsFloat
          else
            NodesArr[i].Z := 0;
          TableNodes.Next;
        end;
        TableNodes.Close;

        // Read TablePoints
        SetLength(PointsArr, TablePoints.RecordCount);
        TablePoints.Open;
        TablePoints.First;
        j := 0;
        for i := 0 to TablePoints.RecordCount - 1 do
        begin
          if not TablePoints.FieldByName(ActiveAttributeB).IsNull then
          begin
            PointsArr[j].X := TablePoints.FieldByName(fldX).AsFloat;
            PointsArr[j].Y := TablePoints.FieldByName(fldY).AsFloat;
            if Mode3d then
              PointsArr[j].Z := TablePoints.FieldByName(fldZ).AsFloat
            else
              PointsArr[j].Z := 0;
            PointsArr[j].Value := TablePoints.FieldByName(ActiveAttributeB).AsFloat;
            Inc(j);
          end;
          TablePoints.Next;
        end;
        SetLength(PointsArr, j);
        TablePoints.Close;

        if Mode3d then
          ShowMessage('3D NNI not implemented yet!')
          // NaturalNeighborsInterpolation3D(PointsArr, NodesArr, ExtraValue, ProgressBar);
        else
          NaturalNeighborsInterpolation2D(PointsArr, NodesArr, ExtraValue, ProgressBar);

        // Write TableNodes
        AddTableField(TableNodes.TableName, ActiveAttributeB + '_NNI', ftFloat);
        TableNodes.Open;
        TableNodes.First;
        for i := 0 to TableNodes.RecordCount - 1 do
        begin
          TableNodes.Edit;
          TableNodes.FieldByName(ActiveAttributeB + '_NNI').Value :=
            RoundTo(NodesArr[i].Value, Precision);
          TableNodes.Post;
          TableNodes.Next;
        end;
        TableNodes.Close;

          // release the memory
          SetLength(PointsArr, 0);
          SetLength(NodesArr, 0);
        end;
    end;
  finally
    TableNodes.Close;
    TablePoints.Close;
  end;
  Screen.Cursor := OldCursor;
*)
end;


procedure TfmMethodInterpolation.ReadGridParameters;
begin

end;

procedure TfmMethodInterpolation.ReadIniFile;
begin

end;

procedure TfmMethodInterpolation.UpdateAttributeListB;
begin

end;

procedure TfmMethodInterpolation.WriteIniFile;
begin

end;

end.
