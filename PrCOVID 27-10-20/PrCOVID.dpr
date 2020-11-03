program PrCOVID;

uses
  Forms,
  UnTypesCOVID in 'UnTypesCOVID.pas',
  UnPKSimplex in 'UnPKSimplex.pas',
  UnCOVID in 'UnCOVID.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
