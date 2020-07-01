unit frShowScene;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Math.Vectors,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Types3D,
  FMX.Objects3D,
  FMX.Controls3D,
  FMX.Viewport3D,
  FMX.MaterialSources,

  uGlobals,
  uSceneModels, FMX.Controls.Presentation;

type
  TFrameShowScene = class(TFrame)
    ColorMaterialSource: TColorMaterialSource;
    LightMaterialSource: TLightMaterialSource;
    TextureMaterialSource: TTextureMaterialSource;
    Viewport3D: TViewport3D;
    DummyY: TDummy;
    DummyX: TDummy;
    Camera: TCamera;
    Light1: TLight;
    Grid3D: TGrid3D;
    Light2: TLight;
    ToolBarScene: TToolBar;
    sbSelect: TSpeedButton;
    sbCenter: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    procedure Viewport3DPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure Viewport3DMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Viewport3DMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Viewport3DMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
  private
    Mouse : Boolean;
    Down : TPointF;
  public
    PointModel: TxPointModel;
    WireModel: TxWireModel;
    FaceModel: TxFaceModel;
  end;


//===================================================
implementation
//===================================================

{$R *.fmx}


procedure TFrameShowScene.Viewport3DPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  FileName : TFileName;
begin
  PointModel := TxPointModel.Create(Self);
  WireModel := TxWireModel.Create(Self);
  FaceModel := TxFaceModel.Create(Self);

  PointModel.Parent := Viewport3D;
  PointModel.Material := ColorMaterialSource;
  PointModel.HitTest := False;

  WireModel.Parent := Viewport3D;
  WireModel.Material := TextureMaterialSource;
  WireModel.HitTest := False;

  FaceModel.Parent := Viewport3D;
  FaceModel.Material := LightMaterialSource;
  FaceModel.HitTest := False;
  FaceModel.TwoSide := True;

  PathExe := ExtractFilePath(ParamStr(0));
  Delete(PathExe, Length(PathExe) - 4, 4);
  FileName := PathExe + 'Data' + PathDelim + 'Assets' + PathDelim + 'CubeMaps';
  SetCurrentDir(FileName);
  LightMaterialSource.Texture.LoadFromFile('desert_negx.png');
  FileName := PathExe + 'Data' + PathDelim + 'Assets' + PathDelim + 'Textures';
  SetCurrentDir(FileName);
  TextureMaterialSource.Texture.LoadFromFile('Rainbow.png');
///  ColorMaterialSource.Color() := RandSeed;
end;


procedure TFrameShowScene.FrameMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  Camera.Position.Z := Camera.Position.Z + ((WheelDelta / 120) * 0.3);
end;

procedure TFrameShowScene.Viewport3DMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Mouse := True;
  Down := PointF(X,Y);
end;

procedure TFrameShowScene.Viewport3DMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
var
  P: TPointF;
begin
  if (ssLeft in Shift) and Mouse then
  begin
    DummyX.RotationAngle.X := DummyX.RotationAngle.X - (Y - Down.Y)* 0.3 ;
    DummyY.RotationAngle.Y := DummyY.RotationAngle.Y + (X - Down.X)* 0.3 ;
    Down.X := X;
    Down.Y := Y;
  end;

end;

procedure TFrameShowScene.Viewport3DMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Mouse := False;
end;

end.
