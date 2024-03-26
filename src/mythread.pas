unit mythread;

interface

uses
  //delphi
  System.SysUtils,
  System.Classes;

type
  TMyThreadCustomFail = reference to procedure(const AValue: String);

  TMyThread = class
  private
    { private declarations }
  public
    { public declarations }
    class function Custom(const AOnShow: TProc; const AOnProcess: TProc; const AOnSuccess: TProc; const AOnFail: TMyThreadCustomFail; const ADoSuccessWithFail: Boolean = False): TThread;
  end;

implementation

{ TMyThread }

class function TMyThread.Custom(const AOnShow: TProc; const AOnProcess: TProc; const AOnSuccess: TProc; const AOnFail: TMyThreadCustomFail; const ADoSuccessWithFail: Boolean = False): TThread;
var
  LDoSuccessWithFail: Boolean;
begin
  LDoSuccessWithFail := True;
  Result := nil;
  Result := TThread.CreateAnonymousThread(
    procedure
    begin
      try
        try
          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              if Assigned(AOnShow) then
                AOnShow;
            end);

          if Assigned(AOnProcess) then
            AOnProcess;
        except
          on E: Exception do
          begin
            LDoSuccessWithFail := ADoSuccessWithFail;
            TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                if Assigned(AOnFail) then
                  AOnFail(E.Message);
              end);
          end;
        end;
      finally
        if LDoSuccessWithFail then
        begin
          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              if Assigned(AOnSuccess) then
                AOnSuccess;
            end);
        end;
      end;
    end);
  Result.FreeOnTerminate := True;
  Result.Start;
end;

end.
