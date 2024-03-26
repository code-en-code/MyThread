unit index;

interface

uses
  //delphi
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  //fmx
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl,

  //codeencode
  mythread;

type
  TIndexView = class(TForm)
    tbcBody: TTabControl;
    tabMain: TTabItem;
    btnWithoutFail: TButton;
    memValues: TMemo;
    tabFail: TTabItem;
    btnWithFail: TButton;
    aniLoading: TAniIndicator;
    lblFail: TLabel;
    btnBack: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnWithoutFailClick(Sender: TObject);
    procedure btnWithFailClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    FShowFail: TMyThreadCustomFail;
    FWithFail: Boolean;

    procedure SetFailMethod;
    procedure Execute;
    procedure ListValues;
    procedure ShowLoading;
    procedure ShowSuccess;
  public
    { Public declarations }
  end;

var
  IndexView: TIndexView;

implementation

{$R *.fmx}

procedure TIndexView.FormShow(Sender: TObject);
begin
  tbcBody.ActiveTab := tabMain;
  aniLoading.Enabled := False;
  aniLoading.Visible := False;
  SetFailMethod;
end;

procedure TIndexView.btnWithoutFailClick(Sender: TObject);
begin
  FWithFail := False;
  Execute;
end;

procedure TIndexView.btnWithFailClick(Sender: TObject);
begin
  FWithFail := True;
  Execute;
end;

procedure TIndexView.btnBackClick(Sender: TObject);
begin
  aniLoading.Enabled := False;
  aniLoading.Visible := False;
  tbcBody.ActiveTab := tabMain;
end;

procedure TIndexView.SetFailMethod;
begin
  FShowFail := procedure(const AValue: String)
    begin
      aniLoading.Enabled := False;
      aniLoading.Visible := False;
      memValues.Lines.Add(AValue);
      tbcBody.ActiveTab := tabFail;
    end;
end;

procedure TIndexView.Execute;
begin
  TMyThread.Custom(
    ShowLoading,
    ListValues,
    ShowSuccess,
    FShowFail);
end;

procedure TIndexView.ListValues;
var
  LNewValue: Integer;
  LIndex: Integer;
begin
  LNewValue := 0;
  memValues.Lines.Clear;
  for LIndex := 1 to 20 do
  begin
    //simulating a process...
    Sleep(100);
    LNewValue := Random(10) + LIndex;
    TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        memValues.Lines.Add('Process ' + LIndex.ToString + ' - ' +
                            'Value ' + LNewValue.ToString + '.');
      end);
    //simulate fail
    if FWithFail then
      if LIndex = 10 then
        raise Exception.Create('Process ' + LIndex.ToString + ' failure.');
  end;
end;

procedure TIndexView.ShowLoading;
begin
  aniLoading.Visible := True;
  aniLoading.Enabled := True;
end;

procedure TIndexView.ShowSuccess;
begin
  ShowMessage('Success');
  aniLoading.Enabled := False;
  aniLoading.Visible := False;
  tbcBody.ActiveTab := tabMain;
end;

end.
