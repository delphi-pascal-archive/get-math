(* ************************************************************************** *)
(*  Модуль для работы со строками.                                            *)
(*  Автор: BlackCash - BlackCash2006@Yandex.ru                                *)
(* ************************************************************************** *)
unit bcStrings;

interface

uses SysUtils, Windows, Classes;

  type
  TBMTable = array [0..255] of Integer;

  type
  TDoubleParam = Record
    pName  : String;
    pParam : String;        
  end;

  const
  HEXTable : array [0..255] of String[2]  = (
   '00','01','02','03','04','05','06','07','08','09','0A','0B','0C','0D','0E','0F'
  ,'10','11','12','13','14','15','16','17','18','19','1A','1B','1C','1D','1E','1F'
  ,'20','21','22','23','24','25','26','27','28','29','2A','2B','2C','2D','2E','2F'
  ,'30','31','32','33','34','35','36','37','38','39','3A','3B','3C','3D','3E','3F'
  ,'40','41','42','43','44','45','46','47','48','49','4A','4B','4C','4D','4E','4F'
  ,'50','51','52','53','54','55','56','57','58','59','5A','5B','5C','5D','5E','5F'
  ,'60','61','62','63','64','65','66','67','68','69','6A','6B','6C','6D','6E','6F'
  ,'70','71','72','73','74','75','76','77','78','79','7A','7B','7C','7D','7E','7F'
  ,'80','81','82','83','84','85','86','87','88','89','8A','8B','8C','8D','8E','8F'
  ,'90','91','92','93','94','95','96','97','98','99','9A','9B','9C','9D','9E','9F'
  ,'A0','A1','A2','A3','A4','A5','A6','A7','A8','A9','AA','AB','AC','AD','AE','AF'
  ,'B0','B1','B2','B3','B4','B5','B6','B7','B8','B9','BA','BB','BC','BD','BE','BF'
  ,'C0','C1','C2','C3','C4','C5','C6','C7','C8','C9','CA','CB','CC','CD','CE','CF'
  ,'D0','D1','D2','D3','D4','D5','D6','D7','D8','D9','DA','DB','DC','DD','DE','DF'
  ,'E0','E1','E2','E3','E4','E5','E6','E7','E8','E9','EA','EB','EC','ED','EE','EF'
  ,'F0','F1','F2','F3','F4','F5','F6','F7','F8','F9','FA','FB','FC','FD','FE','FF');

function ReplaseString(InStr,FindStr,ReplaseStr: String) : string;
function ReplaseAllString(Line, Prefix, Return: String) : String;
function DeleteSpaces(Line: String) : String;

function CompareStringPercent(const s1,s2: string): integer;
procedure GetWordsList(Line: String; List : TStrings);

function BufferToHex(Buffer: Pointer; nSize: DWORD): String;

procedure MakeBMTable( var BMT : TBMTable; const P : String);
function BMSearch( StartPos : Integer; const S, P : String; const BMT : TBMTable) : Integer;
function SearchStringBM(StartPos : Integer; const SourceStr, SearchStr : String) : integer;

function FormatStringToParams(KeyLine: String; Suffix : Char): TDoubleParam;

implementation

function FormatStringToParams(KeyLine: String; Suffix : Char): TDoubleParam;
var
  tmp,tmp2 : String;
  i : integer;
begin
  tmp   := '';
  tmp2  := '';
  for i := 1 to Length(KeyLine) do
    if KeyLine[i] <> Suffix then
    tmp := tmp + KeyLine[i] else
    Break;

  for i := i+1 to Length(KeyLine) do
    tmp2 := tmp2 + KeyLine[i];

  Result.pName := tmp;
  Result.pParam:= tmp2;
end;

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

function DeleteSpaces(Line: String) : String;
var
  tmp  : string;
begin
  tmp := Line;
  while pos(' ',tmp) > 0 do
    tmp := ReplaseString(tmp,' ','');
  Result := tmp;
end;

function CompareStringPercent(const s1,s2: string): integer;
var
  pro,i: integer;
begin
  try
  pro:=0;
  for i := 1 to Length(s1) do
    if s1[i] = s2[i] then pro := pro+1;
  result := (100 div Length(s1))*pro;
  except
    Result := 0;
  end;
end;

procedure GetWordsList(Line: String; List : TStrings);
var
  tmp : String;
begin
  tmp := Line;
  tmp := ReplaseAllString(tmp,' ',#13#10);
  List.Text := tmp;
end;

function BufferToHex(Buffer: Pointer; nSize: DWORD): String;
var
  i: DWORD;
  h: String;
begin
  SetString(Result, nil, nSize*2);
  for i:= 0 to (nSize-1) do
  begin
    h := HEXTable[BYTE(Pointer(DWORD(Buffer) + i)^)];
    Result[(i+1)*2-1] := h[1];
    Result[(i+1)*2] := h[2];
  end;
end;

procedure MakeBMTable( var BMT : TBMTable; const P : String);
var
  i : Integer;
begin
  for i := 0 to 255 do BMT[i] := Length(P);
  for i := Length(P) downto 1 do
    if BMT[Byte(P[i])] = Length(P) then
      BMT[Byte(P[i])] := Length(P) - i;
end;

function BMSearch(StartPos : Integer; const S, P : String; const BMT : TBMTable) : Integer;
var
  Pos, lp, i : Integer;
begin
  lp := Length(P);
  Pos := StartPos + lp - 1;
  while Pos < Length(S) do
    if P[lp] <> S[Pos] then Pos := Pos + BMT[Byte(S[Pos])] else
    for i := lp - 1 downto 1 do
      if P[i] <> S[Pos - lp + i] then
      begin
        Inc(Pos);
        Break;
      end
      else if i = 1 then
      begin
        Result := Pos - lp + 1;
        Exit;
      end;
  Result := 0;
end;

function SearchStringBM(StartPos : Integer; const SourceStr, SearchStr : String) : integer;
var
  BMT : TBMTable;
begin
  MakeBMTable(BMT,SearchStr);
  Result := BMSearch(StartPos,SourceStr,SearchStr,BMT);
end;

end.
