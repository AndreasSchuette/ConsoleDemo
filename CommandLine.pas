unit CommandLine;

interface

function GetCmdLineSwitch(const ASwitch: string; const IgnoreCase: Boolean = True): Boolean;
function GetCmdLineSwitchValue(out AValue: string; const ASwitch: string; const IgnoreCase: Boolean = True): Boolean;

implementation

uses SysUtils;

function GetCmdLineSwitch(const ASwitch: string; const IgnoreCase: Boolean = True): Boolean;
begin
   Result := FindCmdLineSwitch(ASwitch, ['-','/'], IgnoreCase);
end;

function GetCmdLineSwitchValue(out AValue: string; const ASwitch: string; const IgnoreCase: Boolean = True): Boolean;
const
   CompareFunction: array[Boolean] of function(const s1,s2: string): Integer = ( CompareStr, CompareText );
var
   iCmdLine,iSplit: Integer;
   s,sName,sValue: String;
begin
   Result := False;

   for iCmdLine := 1 to ParamCount do
   begin
      s := ParamStr(iCmdLine);


      if not (s[1] in ['-','/']) then
         Continue;

      Delete(s,1,1);
      iSplit := Pos(':',s);
      if iSplit = 0 then
         iSplit := Pos('=',s);

      if iSplit = 0 then
         Continue;

      sName  := Copy(s,1,iSplit-1);
      sValue := Copy(s,iSplit+1,666);

      if CompareFunction[IgnoreCase](ASwitch,sName) = 0 then
      begin
         AValue := sValue;
         Result := True;
         Break;
      end;
   end;
end;

end.
