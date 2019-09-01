unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.EditBox,
{$ifdef Android }
   System.IOUtils,
   Androidapi.JNI.Media ,
{$endif }
  FMX.SpinBox;

type
  { Line��\�����邽�߂̈ʒu�ւ̏�� ssStart = �J�n, ssNext= �p���@, ssEnd =�I�[ }
 TLineStatus = (sStart, sNext, sEnd);

  { Line �`��̈ʒu�AStatus���\���̂Ƃ��Ē�`}
  TLinePoint = record
          Positon : TPointF;
          Status  : TLineStatus;
          Color   : TAlphaColor;      { �F���ǉ�}
        Thickness : Integer;          { ���̑����ǉ�}
  end;
  PLinePoint = ^TLinePoint;

  TMainForm = class(TForm)
    Layout1: TLayout;
    PaintBox1: TPaintBox;
    ColorPalettePanel: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Rectangle8: TRectangle;
    SpinBox1: TSpinBox;
    Label1: TLabel;
    Rectangle9: TRectangle;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure SpinBox1Change(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure ColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    DrawPoints  : TList<TLinePoint>;
    PressStatus : Boolean;
    SelectColor : TAlphaColor;       { �F���ǉ� }
    SelectThickness : Integer;        { ���̑������ǉ�}
    procedure AddPoint(const x, y: single; const Status: TLineStatus; const Color: TAlphaColor ; const Thickness : Integer);          { �F/���̑������ǉ� }
    { private �錾 }
  public
    { public �錾 }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
    DrawPoints  := TList<TLinePoint>.Create;  { �`��p�̓_���X�g�̍\�z }
    SelectColor :=  TAlphaColorRec.Black;     { �����F�����Ƃ��� }
    SelectThickness := SpinBox1.Text.ToInteger;     {�@���̑�����ݒ� }
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DrawPoints.DisposeOf;   { �`��p�̓_���X�g�̔j�� }
end;

procedure TMainForm.addPoint(const x, y: single; const Status: TLineStatus; const Color: TAlphaColor ; const Thickness : Integer);          { �F/���̑������ǉ� }

var
    TLP: TLinePoint;    { ��Line Point }
begin
        if(DrawPoints.Count < 0 ) then exit;   { �}�C�i�X�͂��蓾�Ȃ� }
        TLP.Thickness := Thickness;             { ���̑������ǉ� }
        TLP.Color   := Color;                  { �F�f�[�^�ݒ� }
        TLP.Positon := PointF(x, y);           { �ݒ�f�[�^���쐬 }
        TLP.Status  := Status;
        DrawPoints.Add(TLP);                   { List�ɒǉ� }
        PaintBox1.Repaint;                     { �ĕ`�� }
end;

procedure TMainForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
     if ssLeft in Shift then      { ���{�^�������Ă���H }
     begin
       PressStatus := True;       { ���{�^��������Ԑݒ� }
       AddPoint( x, y ,sStart,SelectColor,SelectThickness);   { �`��p�̓_�ݒ�:�J�n}
     end;
end;


procedure TMainForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
     if ssLeft in Shift then      { ���{�^�������Ă���H }
     begin
       if(PressStatus =  True) then  { �������o�ς�?}
       AddPoint( x, y ,sNext,SelectColor,SelectThickness);   { �`��p�̓_�ݒ�:�p��}
     end;
end;

procedure TMainForm.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    if(PressStatus =  True) then
    begin
       AddPoint( x, y ,sEnd,SelectColor,SelectThickness);   { �`��p�̓_�ݒ�:�I�[}
    end;
    PressStatus := false;       {������Ԃ�����}
end;

procedure TMainForm.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
var
   TLP: TLinePoint;    { ��Line Point }
   StartPoint : TPointF;
begin
        if(DrawPoints.Count < 0 ) then exit;   { �}�C�i�X�͂��蓾�Ȃ� }

        Canvas.Stroke.Kind := TBrushKind.Solid;     {�Ƃ肠�����̃y���F����}
        Canvas.Stroke.Dash := TStrokeDash.Solid;
   //     Canvas.Stroke.Thickness := 2;
   //   Canvas.Stroke.Color := TAlphaColorRec.Black;

        {������������}

        for TLP in DrawPoints do
        begin
             case TLP.Status of
                        sStart : StartPoint := TLP.Positon;
                else
                        begin
                            Canvas.Stroke.Thickness := TLP.Thickness;    {���̑����ݒ�ǉ�}
                            Canvas.Stroke.Color     := TLP.Color;      { �F���ݒ�ǉ� }
                            Canvas.DrawLine(StartPoint, TLP.Positon, 1,  Canvas.Stroke);
                            StartPoint := TLP.Positon;
                        end;
                end;
        end;
end;


procedure TMainForm.SpinBox1Change(Sender: TObject);
begin
    SelectThickness := SpinBox1.Text.ToInteger;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  DrawPoints.Clear;
  PaintBox1.Repaint;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  FPath: string;
  FileName : String;
  PngOut: TBitmap;
  SaveParams: TBitmapCodecSaveParams;
begin
    PngOut := TBitmap.Create;
    try
      PngOut.Assign(PaintBox1.MakeScreenshot);          { SCREEN SHOT�@�쐬 }
      SaveParams.Quality := 100;

      FileName := DateTimeToStr(Now);
      FileName := StringReplace(FileName,' ', '_', [ rfReplaceAll ]);
      FileName := StringReplace(FileName,'/', '_', [ rfReplaceAll ]);
      FileName := StringReplace(FileName,':', '_', [ rfReplaceAll ]);
      FileName := 'DP'+FileName+'.png';
      FPath    := FileName;
{$ifdef Android }
      FPath := System.IOUtils.TPath.GetSharedPicturesPath;
      FPath := System.IOUtils.TPath.Combine(FPath, FileName);
{$Endif}
      PngOut.SaveToFile(FPath, @SaveParams);    { png��Save }
      ShowMessage(FileName+sLineBreak+'Save ����');
    finally
      PngOut.Free;
    end;
end;


procedure TMainForm.ColorClick(Sender: TObject);
begin
  SelectColor := (Sender as  TRectangle).Fill.Color;
end;

end.
