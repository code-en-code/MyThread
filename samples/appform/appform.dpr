program appform;

uses
  System.StartUpCopy,
  FMX.Forms,
  index in 'index.pas' {IndexView},
  mythread in '..\..\src\mythread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TIndexView, IndexView);
  Application.Run;
end.
