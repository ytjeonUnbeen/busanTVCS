unit Common;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList,Registry,SHFolder,
  ComCtrls,TypInfo,winsock,Math,DateUtils,StrUtils, ExtCtrls,TLhelp32,WinSvc;

  procedure GetLocalIP(ipList:TStringList);
  function GetLocalAppDataPath: string;
  function IsRunningProcess(const ProcName: String) : Boolean;
  function KillProcess(processHandle:LongInt): Boolean;
  procedure RunOnStartupHKCU(const sCmdLine:string;isRun:Boolean) ;
  function RunOnStartupCheck(const sCmdLine:string):boolean;
  function StartProcess(procpath:String;procname:String;params:String):LongInt;
  function GetServiceExecutablePath(strMachine: string; strServiceName: string): String;
 
  
implementation


function GetServiceExecutablePath(strMachine: string; strServiceName: string): String;
var
  hSCManager,hSCService: SC_Handle;
  lpServiceConfig: PQueryServiceConfigA;
  nSize, nBytesNeeded: DWord;
begin
  Result := '';
  {
  hSCManager := OpenSCManager(PChar(strMachine), nil, SC_MANAGER_CONNECT);
  if (hSCManager > 0) then
  begin
    hSCService := OpenService(hSCManager, PChar(strServiceName), SERVICE_QUERY_CONFIG);
    if (hSCService > 0) then
    begin
      QueryServiceConfig(hSCService, nil, 0, nSize);
      lpServiceConfig := AllocMem(nSize);
      try
        if not QueryServiceConfig(
          hSCService, lpServiceConfig, nSize, nBytesNeeded) Then Exit;
          Result := lpServiceConfig^.lpBinaryPathName;
      finally
        Dispose(lpServiceConfig);
      end;
      CloseServiceHandle(hSCService);
    end;
  end;
  }
end;

procedure GetLocalIP(ipList:TStringList);
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
   GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pptr^[i] <> nil do
  begin
    ipList.Add(StrPas(inet_ntoa(pptr^[i]^)));
    Inc(i);
  end;
  WSACleanup;
end;





function GetLocalAppDataPath: string;
var
  Path: array[0..MAX_PATH] of Char;
begin
 
 if (ParamCount=1) then  begin
   if (ParamStr(1)='uselocal') then begin
     Result:=ExtractFilePath(Application.ExeName);
     exit;
   end;
 end;


  if SHGetFolderPath(0, CSIDL_APPDATA, 0, 0, Path) = S_OK then
    Result := IncludeTrailingPathDelimiter(Path)+'/Unbeen/'
  else
    Result :=ExtractFilePath(Application.ExeName);
end;

function IsRunningProcess(const ProcName: String) : Boolean;
var
  Process32: TProcessEntry32;
  SHandle:   THandle;
  Next:      Boolean;

begin
  Result:=False;
 
  Process32.dwSize:=SizeOf(TProcessEntry32);
  SHandle         :=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 
  // 프로세스 리스트를 돌면서 매개변수로 받은 이름과 같은 프로세스가 있을 경우 True를 반환하고 루프종료
  if Process32First(SHandle, Process32) then begin
    repeat
      Next:=Process32Next(SHandle, Process32);
      if AnsiCompareText(Process32.szExeFile, Trim(ProcName))=0 then begin
        Result:=True;
        break;
      end;
    until not Next;
  end;
  CloseHandle(SHandle);
end;


function KillProcess(processHandle:LongInt): Boolean;

begin
  Result:=True;

  if not TerminateProcess(processHandle, 0) then Result:=False;


end;


procedure RunOnStartupHKCU(const sCmdLine:string;isRun:Boolean) ;
       var
       sKey              : string;
       Section           : string;
       ApplicationTitle  : string;
       regFile:TRegistry;
begin
        ApplicationTitle:='NxCapture';
      //  sKey := 'Once'
        Section := 'Software\Microsoft\Windows\CurrentVersion\Run'+#0;

      try
       regFile:=TRegistry.Create(KEY_WRITE);
       regFile.RootKey:=HKEY_CURRENT_USER;
       if (not isRun) then begin
            regFile.DeleteKey(Section+'\\'+ApplicationTitle);

       end
       else begin
          if (regFile.OpenKey(Section,True)) then begin
            regFile.WriteString(ApplicationTitle,cmdLine);
          end;

       end;
     finally
        regFile.CloseKey;
        regFile.Free;
     end;

end;

function RunOnStartupCheck(const sCmdLine:string):boolean;
       var
       sKey              : string;
       Section           : string;
       ApplicationTitle  : string;
       regFile:TRegistry;
begin
        ApplicationTitle:='RobotPass';
        sKey := '';
        Section := 'Software\Microsoft\Windows\CurrentVersion\Run'+#0;

      try
       regFile:=TRegistry.Create(KEY_READ);
       if (regFile.OpenKey(Section,True)) then begin
            sKey:=regFile.ReadString(ApplicationTitle);
       end;
     finally
        regFile.CloseKey;
        regFile.Free;
     end;
     if (sKey='') then Result:=false
     else Result:=true;

end;


function StartProcess(procpath:String;procname:String;params:String):LongInt;
var

  start : TStartUpInfo;
  Rslt:LongBool;
  ProcessInfo : TProcessInformation;
begin
  FillChar(Start,Sizeof(Start),#0) ;
  start.cb := SizeOf(start) ;
  start.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
  start.wShowWindow := SW_HIDE;

  Rslt:=CreateProcess(nil, PChar(procpath+'\'+procname+' '+params), nil, nil, true,
        CREATE_NEW_CONSOLE , nil, Pchar(procpath+'\'), start,ProcessInfo);
  Result:=0;

  if (Rslt) then
  begin
    Result:= ProcessInfo.hProcess;

  end
  else begin
      
  end;


end;


end.
