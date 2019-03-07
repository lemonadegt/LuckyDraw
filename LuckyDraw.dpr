program LuckyDraw;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLuckyDraw, frmLuckyDraw);
  Application.Run;
end.
