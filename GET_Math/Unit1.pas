unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, bcStrings, shellapi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ListBox1: TListBox;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function ReplaseString(InStr,FindStr,ReplaseStr: String) : string;
var
  id  : integer;
  str : string;
begin
  Result := InStr;
  id     := pos(LowerCase(FindStr), LowerCase(InStr));
  str    := InStr;
  Delete(str,id,length(FindStr));
  Insert(ReplaseStr,str,id);
  Result := str;
end;

function ReplaseAllString(Line, Prefix, Return: String) : String;
var
  tmp  : string;
begin
  tmp := Line;
  while pos(Prefix,tmp) > 0 do
    tmp := ReplaseString(tmp,prefix,return);

  Result := tmp;
end;

procedure GetWordsList(Line: String; List : TStrings);
var
  tmp : String;
begin
  tmp := Line;
  tmp := ReplaseAllString(tmp,' ',#13#10);
  List.Text := tmp;
end;

function CalculateExpression(Expression: String) : integer;
const
  Minus   = '-';
  Plus    = '+';
  Divider = '\';
  Mplying = '*';
var
  Temp    : String;
  sList   : TStringList;
  sResult : integer;
  sCalc   : integer;
  i       : integer;
begin
  sResult := 0;
  sList   := TStringList.Create;
  try
  {}
  Temp  := '';
  for i := 1 to Length(Expression) do
    if (Expression[i] = Minus) or (Expression[i] = Plus) or (Expression[i] = Divider) or (Expression[i] = Mplying) then
    begin
      sList.Add(Temp);
      sList.Add(Expression[i]);
      Temp := '';
    end else
    Temp := Temp + Expression[i];
  sList.Add(Temp);
  {}
  sCalc   := 0;
  sResult := 0;
  i       := 0;
  while i < sList.Count-1 do begin
    if (sList[i] <> Minus) and (sList[i] <> Plus) and (sList[i] <> Divider) and (sList[i] <> Mplying) then begin
      sCalc := strtoint(sList[i]);
    end
    else begin
      if sList[i] = Minus then
        sCalc := (sCalc -   strtoint(sList[i+1]));
      if sList[i] = Plus then
        sCalc := (sCalc +   strtoint(sList[i+1]));
      if sList[i] = Divider then
        sCalc := (sCalc div strtoint(sList[i+1]));
      if sList[i] = Mplying then
        sCalc := (sCalc *   strtoint(sList[i+1]));
      sResult := sCalc;
      inc(i);
    end;
    inc(i);
  end;
  {}
  finally
    Result := sResult;
    sList.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i : integer;
  l : TStringList;
begin
  ListBox1.Clear;
  l := TStringList.Create;
  GetWordsList(Memo1.Text,l);
  {}
  for i := 0 to l.Count-1 do
    if (pos('-',l[i])<>0) or (pos('+',l[i])<>0) or (pos('*',l[i])<>0) or (pos('\',l[i])<>0) then
    begin
      try
        ListBox1.Items.Add(l[i]+'='+inttostr(CalculateExpression(l[i])));
      except
      end;
    end;
  {}
  l.Free;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
ShellExecute(0,'open','http://coffee-cup.3dn.ru/','','',1);
end;

end.
