program ConsoleDemo;

uses
  Forms,
  Types,
  Windows,
  Dialogs,
  SysUtils,
  CommandLine,
  GraphicalUserInterface in 'GraphicalUserInterface.pas' {FrameGraphicalUserInterface},
  TextModeInterface in 'TextModeInterface.pas' {FrameTextModeInterface};

const
  NoOutputError=0;
  Console=1;
  NewConsole=2;
  TextMode=3;
  GUI=4;

{$R *.res}

function AttachConsole(dwProcessId:DWord):Bool;stdcall;external 'kernel32.dll';
const ATTACH_PARENT_PROCESS=DWORD(-1);

procedure SetOutputMode(OutputMode:byte);
begin
 Case OutputMode of
  NoOutPutError: ShowMessage ('Debug: NoOutputError');
  Console,NewConsole:begin
                      {Run Program Begin}
                      writeln ('');
                      writeln ('ConsoleDemo (CLI)');
                      {Run Program End}
                      Keybd_Event(VK_RETURN,0,0,0);
                     end;
  TextMode:begin
            Application.Initialize;
            Application.CreateForm(TFrameTextModeInterface, FrameTextModeInterface);
            Application.Run;
           end;
  GUI:begin
       Application.Initialize;
       Application.CreateForm(TFrameGraphicalUserInterface, FrameGraphicalUserInterface);
       Application.Run;
      end;
 end;
end;

begin
 if ParamCount>0 then
 begin
  if (GetCmdLineSwitch ('TMI')=True) then SetOutputMode (TextMode) else
   if (GetCmdLineSwitch ('GUI')=True) then SetOutputMode (GUI) else
    if (GetStdHandle(STD_INPUT_HANDLE) = 0) or ((GetCmdLineSwitch ('CLI')=True) and (GetStdHandle(STD_INPUT_HANDLE) = 0)) then
    begin
     if (AllocConsole) then
     begin
      SetOutputMode (NewConsole);
     end else begin
               {Handle console creation failure.}
               SetOutputMode (NoOutputError);
              end;
     end else begin
              if AttachConsole(ATTACH_PARENT_PROCESS) then
               begin
                SetOutputMode(Console);
               end else begin
                         {Handle console creation failure.}
                         SetOutputMode (NoOutputError);
                        end;
              end;
    end else begin
              SetOutPutMode (GUI);
             end;
end.
