unit uSceneModels;

interface

uses
  System.Types,
  System.Classes,
  System.SysUtils,
  System.RTLConsts,
  System.Math,
  System.Math.Vectors,
  FMX.Types3D,
  FMX.Controls3D,
  FMX.MaterialSources;

type
  TxPointModel = class(TControl3D)
  private
    procedure MakeModel;
  protected
    fGeometry: TMeshData;
    fMaterial: TMaterialSource;
    fCount: Integer;
    procedure SetCount(const aCount: Integer);
    procedure Render; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    property Material: TMaterialSource read fMaterial write fMaterial;
    property Count: Integer read fCount write SetCount;
  end;

type
  TxWireModel = class(TControl3D)
  private
    procedure MakeModel;
  protected
    fGeometry: TMeshData;
    fMaterial: TMaterialSource;
    fDivN: Integer;
    procedure SetDivN(const aDivN: Integer);
    procedure Render; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    property Material: TMaterialSource read fMaterial write fMaterial;
    property DivN: Integer read fDivN write SetDivN;
  end;

type
  TxFaceModel = class(TControl3D)
  private
    function XYtoI(const aX, aY: Integer): Integer; inline;
    procedure MakeModel;
  protected
    fGeometry: TMeshData;
    fMaterial: TMaterialSource;
    fDivX: Integer;
    fDivY: Integer;
    procedure SetDivX(const aDivX: Integer);
    procedure SetDivY(const aDivY: Integer);
    procedure Render; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    property Material: TMaterialSource read fMaterial write fMaterial;
    property DivX: Integer read fDivX write SetDivX;
    property DivY: Integer read fDivY write SetDivY;
  end;

//=========================================================================
implementation
//=========================================================================


//------------- TxPointModel ------------------\\
procedure TxPointModel.MakeModel;
var
  I: Integer;
begin
  with fGeometry do
  begin
    with VertexBuffer do
    begin
      Length := fCount;
      for I := 0 to fCount - 1 do
      begin
        Vertices[I] := TPoint3D.Create(RandG(0, 0.5), RandG(0, 0.5), RandG(0, 0.5));
        TexCoord0[I] := TPointF.Create(I / (fCount - 1), 0);
      end;
    end;
    with IndexBuffer do
    begin
      Length := fCount;

      for I := 0 to fCount - 1 do
        Indices[I] := I;
    end;
  end;
end;

procedure TxPointModel.SetCount(const aCount: Integer);
begin
  fCount := aCount;
  MakeModel;
end;

procedure TxPointModel.Render;
begin
  Context.SetMatrix(AbsoluteMatrix);
  Context.DrawPoints(fGeometry.VertexBuffer, fGeometry.IndexBuffer,
      TMaterialSource.ValidMaterial(fMaterial), AbsoluteOpacity);
end;

constructor TxPointModel.Create(aOwner: TComponent);
begin
  inherited;
  fGeometry := TMeshData.Create;
  fCount := 4096;
  MakeModel;
end;

destructor TxPointModel.Destroy;
begin
  fGeometry.Free;
  inherited;
end;

//------------- TxWireModel ------------------\\

procedure TxWireModel.MakeModel;
var
  I: Integer;
  T: Single;
begin
  with fGeometry do
  begin
    with VertexBuffer do
    begin
      Length := fDivN { Wire } + 1;
      for I := 0 to fDivN do
      begin
        T := 2 * Pi * I / fDivN;
        Vertices[I] := TPoint3D.Create(Cos(1 * T), Sin(2 * T), Sin(3 * T));
        TexCoord0[I] := TPointF.Create(I / fDivN, 0);
      end;
    end;
    with IndexBuffer do
    begin
      Length := 2 { Point } * fDivN { Wire };
      for I := 0 to fDivN - 1 do
      begin
        Indices[2 * I] := I;
        Indices[2 * I + 1] := I + 1;
      end;
    end;
  end;
end;

procedure TxWireModel.SetDivN(const aDivN: Integer);
begin
  fDivN := aDivN;
  MakeModel;
end;

procedure TxWireModel.Render;
begin
  with Context do
  begin
    SetMatrix(AbsoluteMatrix);
    DrawLines(fGeometry.VertexBuffer, fGeometry.IndexBuffer,
      TMaterialSource.ValidMaterial(fMaterial), AbsoluteOpacity);
  end;
end;

constructor TxWireModel.Create(aOwner: TComponent);
begin
  inherited;
  fGeometry := TMeshData.Create;
  fDivN := 256;
  MakeModel;
end;

destructor TxWireModel.Destroy;
begin
  fGeometry.Free;
  inherited;
end;

//-----------------  TxFaceModel -------------------------\\

function TxFaceModel.XYtoI(const aX, aY: Integer): Integer;
begin
  Result := (fDivX + 1) * aY + aX;
end;

procedure TxFaceModel.MakeModel;
var
  X, Y, I: Integer;
begin
  with fGeometry do
  begin
    with VertexBuffer do
    begin
      Length := (fDivX + 1) * (fDivY + 1);
      for Y := 0 to fDivY do
      begin
        for X := 0 to fDivX do
        begin
          I := XYtoI(X, Y);
          Vertices[I] := TPoint3D.Create(2 * X / fDivX - 1, 2 * Y / fDivY - 1,
            -1).Normalize;
          TexCoord0[I] := TPointF.Create(X / fDivX, Y / fDivY);
        end;
      end;
    end;
    with IndexBuffer do
    begin
      Length := 3 { Point } * 2 { Face } * fDivX * fDivY;
      I := 0;
      for Y := 0 to fDivY - 1 do
      begin
        for X := 0 to fDivX - 1 do
        begin
          // X0      X1
          // Y0┼───┼
          // │＼    │
          // │  ＼  │
          // │    ＼│
          // Y1┼───┼

          Indices[I] := XYtoI(X, Y);
          Inc(I);
          Indices[I] := XYtoI(X + 1, Y);
          Inc(I);
          Indices[I] := XYtoI(X + 1, Y + 1);
          Inc(I);

          Indices[I] := XYtoI(X + 1, Y + 1);
          Inc(I);
          Indices[I] := XYtoI(X, Y + 1);
          Inc(I);
          Indices[I] := XYtoI(X, Y);
          Inc(I);
        end;
      end;
    end;
    CalcSmoothNormals(TCalculateNormalMethod.Fastest);
  end;
end;

procedure TxFaceModel.SetDivX(const aDivX: Integer);
begin
  fDivX := aDivX;
  MakeModel;
end;

procedure TxFaceModel.SetDivY(const aDivY: Integer);
begin
  fDivY := aDivY;
  MakeModel;
end;

procedure TxFaceModel.Render;
begin
  Context.SetMatrix(AbsoluteMatrix);
  fGeometry.Render(Context, TMaterialSource.ValidMaterial(fMaterial),
    AbsoluteOpacity);
end;

constructor TxFaceModel.Create(aOwner: TComponent);
begin
  inherited;
  fGeometry := TMeshData.Create;
  fDivX := 32;
  fDivY := 32;
  MakeModel;
end;

destructor TxFaceModel.Destroy;
begin
  fGeometry.Free;
  inherited;
end;


initialization


finalization

end.
