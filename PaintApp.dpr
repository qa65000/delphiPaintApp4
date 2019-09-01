program PaintApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.InvertedLandscape];
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
