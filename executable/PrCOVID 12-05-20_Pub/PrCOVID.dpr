program PrCOVID;

uses
  Forms,
  UnCOVID in 'UnCOVID.pas' {MainForm},
  UnTypesCOVID in 'UnTypesCOVID.pas',
  UnPKSimplex in 'UnPKSimplex.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
