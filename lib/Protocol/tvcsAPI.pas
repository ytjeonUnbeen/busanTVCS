unit tvcsAPI;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,System.JSON,Rest.JSON,IDUri, IdSSL, IdSSLOpenSSL,IdAuthenticationDigest,IdAuthentication,
  IdTCPClient, IdHTTP, Registry,Types,strutils,tvcsProtocol,
  OverbyteIcsHttpProt, OverbyteIcsWSocket, OverbyteIcsWndControl, OverbyteIcsTypes, Soap.EncdDecd;

const
   api_login='/tvcs/login';
   api_user='/tvcs/user';
   api_station='/tvcs/station';
   api_train='/tvcs/train';
   api_train_service='/tvcs/trainService';
   api_station_camera='/tvcs/stationCamera';
   api_train_camera='/tvcs/trainCamera';
   api_train_camera_merge='/tvcs/trainCameraMerge';
   api_license='/tvcs/license';
   api_system='/tvcs/system';
   api_list='/tvcs/apilist';
   api_device='/tvcs/device';
   api_deviceMsg='/tvcs/deviceMsg';


type

  TTvcsAPIMethod=(
                TVCS_GET,
                TVCS_POST,
                TVCS_PATCH,
                TVCS_DELETE
   );
  TTvcsAuthMethod=(
                tvcsBasic,
                tvcsDigest,
                tvcsBearer);




  TTvcsAPIBase=class(TObject)
   private
          IdHTTP: TIdHTTP;
          sslIOHandler : TIdSSLIOHandlerSocketOpenSSL;
          FURI:TIDUri;  //URL 객체
          FHostAddr:String;
          FUserId,FUserPass:String;
          FuseSSL:boolean;
          FConnected:Boolean;
          FAuthMethod:TTvcsAuthMethod;
          FResponseCode:Integer;
          FResponseText:String;
          DebugMemo:TMemo;


          function  GetHost:String;
          function  GetPort:Integer;
          function  GetPath:String;
          procedure OnAuthRequested(Sender: TObject; Authentication: TIdAuthentication; var Handled: Boolean);
    public
         destructor  Destroy;override;
         constructor Create;overload;
         constructor Create(url:String);overload;
         constructor Create(Url,userid,userpass:String);overload;
         procedure SetHostUrl(url:String);
         procedure SetAuthMethod(method:TTvcsAuthMethod);
         procedure SetUser(username,password:String);
         procedure SetDebugMemo(memdebug:TMemo);
         procedure DisplayLog(str:String);

         function DeleteAPI(APathURL: string;params:String=''):String;overload;
         function DeleteAPI(APathURL:String;Parameters:TJSONObject):TJSONObject;overload;

         function PatchAPI(APathURL:String;ReqObj:TJSONObject): TJsonObject; overload;
         procedure PutAPI(APathURL:String;ReqObj:TJSONObject);
         function  GetAPI(APathURL:String;Parameters:String=''):String;overload;
         function  GetAPI(APathURL:String;Parameters:TJSONObject):TJSONObject;overload;
         function  PostAPI(APathURL:String;Params:String=''):String;overload;
         function  PostAPI(APathURL:String;Params:TJSonObject):TJSONObject;overload;
    published
         property Connected:Boolean read FConnected;
         property IsUseSSL:Boolean read FuseSSL;
         property UrlHost:String read GetHost;
         property UrlPort:Integer read GetPort;
         property UrlPath:String read GetPath;
         property ResponseCode:Integer read FResponseCode;
         property ResponseText:String read FResponseText;
         property UserId:String read FUserId;
         property UserPass:String read FUserPass;
         property HostAddr:String  read FHostAddr;
  end;

  TListAPI=record
      name:String;
      method:String;
      Uri:String;
      Data:TJSONObject;
  end;

  TReceiveDataEvent = procedure(const Data: string) of object;

  TReceiveThread = class(TThread)
  private
    FWSocket: TWSocket;
    FOnReceiveData: TReceiveDataEvent;
    FStopFlag: Boolean;
    FReceiveDataMethod: TFunc<string>;
  protected
    procedure Execute; override;
  public
    constructor Create(ASocket: TWSocket; AReceiveDataMethod: TFunc<string>);
    procedure Stop;
    property OnReceiveData: TReceiveDataEvent read FOnReceiveData write FOnReceiveData;
  end;




  TTVCSAPI= class(TObject)
     private
         FAPIBase:TTvcsAPIBase;
         FListAPI:TArray<TListAPI>;
         FResponseCode:Integer;
         FResponsetext:String;
         FErrorCode:Integer;
         FErrorMsg:String;
         Flogin:Boolean;
         FDebugMemo:TMemo;
         FLoginInfo:TVCSLogin;

         WSocket: TWSocket;
         FStopReceiving: Boolean;
         FReceiveThread: TReceiveThread;
         FOnReceiveData: TReceiveDataEvent;

         procedure ThreadReceiveData(const Data: string);
         procedure LoadAPIList(AAPIList:TJSONArray);
         function InternalReceiveData: string;

     public

         destructor  Destroy;override;
         constructor Create;overload;
         constructor Create(url:String);overload;
         procedure SetUrl(url:String);
         property GetLoinInfo:TVCSLogin read FLoginInfo;

         function Login(userid,password:String):Boolean;
         Procedure LogOut;
         function CheckError(body:TJsonObject;var errmsg:String):Integer; //return errorcode

         //user
         function  GetUsers(userid:String=''):TArray<TvcsUser>;
         function  AddUser(userinfo:TvcsUserIn):TvcsUser;
         function UpdateUser(Userpatch:TvcsUserPatch):TvcsUser;
         function DeleteUser(userid:String):string;

         //station
         function GetStation(code:String=''; line:Integer=0):TArray<TvcsStation>;
         function AddStation(stationinfo:TvcsStationInPost):TvcsStation;
         function UpdateStation(stationinfo:TvcsStationInPatch):TvcsStation;
         function DeleteStation(code:String=''):string;

         //train
         function GetTrain(trainNo:integer=-1):TArray<TvcsTrain>;
         function AddTrain(traininfo:TVCSTrainInPost):TvcsTrain;
         function UpdateTrain(traininfo:TVCSTrainInPatch):TvcsTrain;
         function DeleteTrain(trainId:integer):string;

         //trainService
         function GetTrainService(trainId:string =''; stationCode:string =''):TArray<TvcsTrainService>;

         //stationCamera
         function GetStationCamera(stationCode:string=''):TArray<TVCSStationCamera>;
         function AddStationCamera(stationCamerainfo:TVCSStationCameraPost):TVCSStationCamera;
         function UpdateStationCamera(stationCamerainfo:TVCSStationCameraPatch):TVCSStationCamera;
         function DeleteStationCamera(fid:integer):string;

         //trainCamera
         function GetTrainCamera(trainId:integer=-1):TArray<TVCSTrainCamera>;
         function AddTrainCamera(trainCameraInfo:TVCSTrainCameraInPost):TVCSTrainCamera;
         function UpdateTrainCamera(trainCameraInfo:TVCSTrainCameraInPatch):TVCSTrainCamera;
         function DeleteTrainCamera(fid:integer):string;

         //trainCameraMerge
         function GetTrainCameraMerge(trainId:integer=-1):TArray<TVCSTrainCameraMerge>;
         function AddTrainCameraMerge(trainCameraMergeInfo:TVCSTrainCameraMergePost):TVCSTrainCameraMerge;
         function UpdateTrainCameraMerge(trainCameraMergeInfo:TVCSTrainCameraMergePatch):TVCSTrainCameraMerge;
         function DeleteTrainCameraMerge(trinId: Integer; fname:string):string;

         //licsense
         function GetLicense():TArray<TVCSLicense>;
         function AddLicense(licenseInfo:TVCSLicensePost):TVCSLicense;

         //system
         function UpdateSystem(SystemInfo:TvcsSystem):TVCSSystem;

         //apilist
         function GetApiList():TArray<TVCSApilist>;

         //tcmsdata
         function ConnectTCMS(const IPAddress, Port: string; out ErrorMsg: string; line: string): boolean;
         procedure DisconnectTCMS(out ErrorMsg: string);
         function ReceiveData(): string;

         //device

         function GetDevice(ftype:integer=-1):TArray<TVCSDevice>;
         function AddDevice(deviceInfo:TVCSDevicePost):TVCSDevice;
         function UpdateDevice(deviceInfo:TVCSDevice):TVCSDevice;
         function DeleteDevice(deviceId: Integer):string;

         //deviceMsg

         function GetDeviceMsg(fdeviceId:integer=-1; ftype:string=''; fyy: string=''; fmm: string=''):TArray<TVCSDeviceMsg>;
         function AddDeviceMsg(deviceMsgInfo:TVCSDeviceMsgPost):TVCSDeviceMsg;

         //TCMS 쓰레드
         property OnReceiveData: TReceiveDataEvent read FOnReceiveData write FOnReceiveData;



         procedure DisplayDebug(str:String);
         function GetParamter(apiname:String;var params:TJSONObject):Integer;
         procedure CallAPI(apidx:Integer;params:TJSONObject;var retParams:TJSONObject);overload;
         procedure CallAPI(apiname: String;method:TTvcsAPIMethod; params: String; var retParams: String);overload;
         procedure CallAPI(apiname:String;method:TTvcsAPIMethod;params:TJSONObject;var retParams:TJSONObject);overload;
      published

         property APIBase:TTvcsAPIBase read FAPIBase write FAPIBase;
         property ListAPI:TArray<TListAPI> read FListAPI write FListAPI;
         property ResoponseCode:Integer read FResponseCode write FResponsecode;
         property ResoponseText:String read FResponseText write FResponseText;
         property ErrorCode:Integer read FErrorCode write FErrorCode;
         property ErrorMsg:String read FErrorMsg write FErrorMsg;
         property DebugMemo:TMemo read FDebugMemo write FDebugMemo;
         property isLogin:Boolean read FLogin;



  end;

var
  Gapi: TTVCSAPI;


implementation

constructor TTVCSAPI.Create;
begin
 inherited Create;
 FErrorCode:=0;
 FErrorMsg:='';
 FLogin:=False;
 FStopReceiving:=False;
 WSocket := TWSocket.Create(nil);
 FAPIBase:=TTvcsAPIBase.Create;
end;

constructor TTVCSAPI.Create(url:String);
begin
 inherited Create;
  FErrorCode:=0;
  FErrorMsg:='';
  FLogin:=False;
  FStopReceiving:=False;
  WSocket := TWSocket.Create(nil);

 FAPIBase:=TTvcsAPIBase.Create(url);
end;

destructor TTVCSAPI.Destroy;
begin
  if (FAPIBase<>nil) then
    FreeAndNil(FAPIBase);


  FErrorCode:=0;
  FErrorMsg:='';
  FLogin:=False;
  WSocket.Free;

  inherited Destroy;
end;

procedure TTVCSAPI.SetUrl(url:String);
begin
 FAPIBase.SetHostUrl(url);
end;

procedure TTVCSAPI.DisplayDebug(str: string);
begin
 if (FDebugMemo<>nil) then begin

    if (FDebugMemo.lines.count >10000) then
        FDebugMemo.Lines.Clear;

     FDebugMemo.lines.Add(str);

 end;

end;
Procedure TTVCSAPI.LogOut;
begin
  FLogin:=false;
end;


function TTVCSAPI.Login(userid,password:String):Boolean;
var
 response:String;
 resObject,resAPI,reply:TJSONObject;
 resApiList:TJSONArray;
begin
     if (FAPIBase.UrlHost='') then  begin
         Result:=false;
         Exit;
     end;

     FAPIBase.SetUser(userid,password);
     DisplayDebug('userid= '+userid+','+'password='+password);
     FAPIBase.SetAuthMethod(tvcsBasic);
     response:=FAPIBase.GetAPI(api_login);
     FResponseText:=FAPIBase.ResponseText;
     FResponseCode:=FAPIBase.ResponseCode;


      if (FResponseCode=200) then
      begin
        resObject:=TJSONObject.ParseJsonValue(response) as TJSONObject;
        reply:=resObject.GetValue<TJSONObject>('reply'); //reply 공통
        FLoginInfo:=TJSON.JsonToObject<TVCSLogin>(reply);
        FLogin:=True;
        Result:=true;
      end
      else Result:=false;
end;



procedure TTVCSAPI.LoadAPIList(AAPIList: TJSONArray);
var
 index:Integer;
 apidef:TJSONObject;
begin

  SetLength(FListAPI,AAPIList.count);
  for index := 0 to AAPIList.count-1 do begin
      apidef:=AAPIList.Get(index) AS TJSONObject ;
      FListAPI[index].name:=apidef.GetValue<String>('name');
      FListAPI[index].method:=apidef.GetValue<String>('method');
      FListAPI[index].uri:=apidef.GetValue<String>('url');
      FListAPI[index].Data:=apidef.GetValue<TJSONObject>('inJson');
  end;
end;

function TTVCSAPI.GetParamter(apiname: string;var params: TJSONObject): Integer;
var
 idx:Integer;
begin
  for idx := Low(FListAPI) to High(FLIstAPI) do begin
    if (ListAPI[idx].name=apiname) then begin
        params:=ListAPI[idx].Data;
        Result:=idx;
    end;
  end;
  Result:=-1;
end;

procedure TTVCSAPI.CallAPI(apiname:String;method:TTvcsAPIMethod;params:TJSONObject;var retParams:TJSONObject);
begin
  case method of
    TVCS_GET:
       begin
        retParams:=FAPIBase.GetAPI(apiname,params);
       end;
    TVCS_POST:
      begin
        retParams:=FAPIBase.PostAPI(apiname,params);
      end;

    TVCS_PATCH:
      begin
        FAPIBase.PatchAPI(apiname,params);
      end;

    TVCS_DELETE:
       begin
        FAPIBase.DeleteAPI(apiname,params.ToString);
      end;
  end;
end;

procedure TTVCSAPI.CallAPI(apiname: String;method:TTvcsAPIMethod; params: String; var retParams: String);
begin
   case method of
    TVCS_GET:
       begin
        retParams:=FAPIBase.GetAPI(apiname,params);
       end;
    TVCS_POST:
      begin
        retParams:=FAPIBase.PostAPI(apiname,params);
      end;

    TVCS_PATCH:
      begin
       // FAPIBase.PatchAPI(apiname,params);
      end;

    TVCS_DELETE:
       begin
        FAPIBase.DeleteAPI(apiname,params);
      end;
  end;

end;


procedure TTVCSAPI.CallAPI(apidx:Integer;params:TJSONObject;var retParams:TJSONObject);

begin
  if (UpperCase(FListAPI[apidx].method)='GET') then begin
       retParams:=FAPIBase.GetAPI(FListAPI[apidx].Uri,params);
  end;
  if (UpperCase(FListAPI[apidx].method)='POST') then begin
       retParams:=FAPIBase.PostAPI(FListAPI[apidx].Uri,params);
  end;
  if (UpperCase(FListAPI[apidx].method)='PATCH') then begin
       FAPIBase.PatchAPI(FListAPI[apidx].Uri,params);
  end;
  if (UpperCase(FListAPI[apidx].method)='DELETE') then begin
       retParams:=FAPIBase.DeleteAPI(FListAPI[apidx].Uri,params);
  end;

end;

function TTVCSAPI.CheckError(body:TJsonObject;var errmsg:String):Integer;
var
 errcode:String;
begin
   errcode:=body.GetValue<String>('error');
   errMsg:=body.GetValue<String>('errorString');
   Result:=StrToInt(errcode);

   FErrorCode:=Result;
   FErrorMsg:=errMsg;

end;

//user
// User related functions
function TTVCSAPI.GetUsers(UserId: string): TArray<TvcsUser>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  UsersJson: TJSONValue;
  Users: TArray<TvcsUser>;
  I: Integer;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  User: TvcsUser;
begin
  try
    // Parameter 설정
    if UserId <> '' then
      UserId := 'userId=' + UserId;

    // API 호출
    ResponseStr := FAPIBase.GetAPI(API_USER, UserId);
    FResponseText := FAPIBase.ResponseText;
    FResponseCode := FAPIBase.ResponseCode;

    // JSON 파싱
    ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit(nil);

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit(nil);

    UsersJson := ResponseJson.GetValue('reply');
    if UsersJson is TJSONArray then
    begin
      SetLength(Users, TJSONArray(UsersJson).Count);
      for I := 0 to TJSONArray(UsersJson).Count - 1 do
      begin
        JsonObj := TJSONArray(UsersJson).Items[I] as TJSONObject;
        User := TvcsUser.Create;

        // 각 필드별 명시적 파싱
        if JsonObj.TryGetValue('userId', JsonValue) and (not JsonValue.Null) then
          User.fuserId := JsonValue.AsType<string>
        else
          User.fuserId := '';

        if JsonObj.TryGetValue('firstName', JsonValue) and (not JsonValue.Null) then
          User.ffirstName := JsonValue.AsType<string>
        else
          User.ffirstName := '';

        if JsonObj.TryGetValue('lastName', JsonValue) and (not JsonValue.Null) then
          User.flastName := JsonValue.AsType<string>
        else
          User.flastName := '';

        if JsonObj.TryGetValue('email', JsonValue) and (not JsonValue.Null) then
          User.femail := JsonValue.AsType<string>
        else
          User.femail := '';

        if JsonObj.TryGetValue('isStaff', JsonValue) and (not JsonValue.Null) then
          User.fisStaff := JsonValue.AsType<Integer>
        else
          User.fisStaff := 0;

        if JsonObj.TryGetValue('isSuperUser', JsonValue) and (not JsonValue.Null) then
          User.fisSuperUser := JsonValue.AsType<Boolean>
        else
          User.fisSuperUser := False;

        if JsonObj.TryGetValue('isActive', JsonValue) and (not JsonValue.Null) then
          User.fisActive := JsonValue.AsType<Boolean>
        else
          User.fisActive := False;

        if JsonObj.TryGetValue('lastLogin', JsonValue) and (not JsonValue.Null) then
          User.flastLogin := JsonValue.AsType<string>
        else
          User.flastLogin := '';

        if JsonObj.TryGetValue('dateJoined', JsonValue) and (not JsonValue.Null) then
          User.fdateJoined := JsonValue.AsType<string>
        else
          User.fdateJoined := '';

        if JsonObj.TryGetValue('version', JsonValue) and (not JsonValue.Null) then
          User.fversion := JsonValue.AsType<string>
        else
          User.fversion := '';

        Users[I] := User;
      end;
      Result := Users;
    end
    else
      Result := nil;
  except
    Result := nil;
  end;
end;

function TTVCSAPI.AddUser(UserInfo: TvcsUserIn): TvcsUser;
var
  RequestJson, ResponseJson: TJSONObject;
  UserJson: TJSONValue;
  ResultUser: TvcsUser;
  ErrorMsg: string;
begin
  RequestJson := TJSON.ObjectToJsonObject(UserInfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_USER, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      UserJson := ResponseJson.GetValue('reply');
      ResultUser := TJSON.JsonToObject<TvcsUser>(UserJson.ToString);
      Result := ResultUser;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateUser(Userpatch:TvcsUserPatch):TvcsUser;
var
  RequestJson, ResponseJson: TJSONObject;
  UserJson: TJSONValue;
  ResultUser: TvcsUser;
  ErrorMsg: string;

begin
  RequestJson := TJSON.ObjectToJsonObject(Userpatch);
  ResponseJson := FAPIBase.PatchAPI(API_USER, RequestJson);

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit(nil);
  end;

  UserJson := ResponseJson.GetValue('reply');
  ResultUser := TJSON.JsonToObject<TvcsUser>(UserJson.ToString);
  Result := ResultUser;
end;

function TTVCSAPI.DeleteUser(UserId: string): string;
var
  ResponseStr: string;
  ResponseJson: TJSONObject;
  ErrorMsg: string;
begin
  ResponseStr := FAPIBase.DeleteAPI(API_USER, 'userId=' + UserId);
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;

  Result := ResponseStr;
end;

// Station related functions
function TTVCSAPI.GetStation(Code: string; Line: Integer): TArray<TvcsStation>;
var
  ResponseStr, ErrorMsg, ParamStr: string;
  ResponseJson: TJSONObject;
  StationsJson: TJSONValue;
  Stations: TArray<TvcsStation>;
  I: Integer;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  Station: TvcsStation;
begin
  try
    // Parameter 설정
    if Code <> '' then
      ParamStr := 'code=' + Code + '&line=' + IntToStr(Line)
    else
      ParamStr := 'line=' + IntToStr(Line);

    // API 호출
    ResponseStr := FAPIBase.GetAPI(API_STATION, ParamStr);
    FResponseText := FAPIBase.ResponseText;
    FResponseCode := FAPIBase.ResponseCode;

    // JSON 파싱
    ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit(nil);

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit(nil);

    StationsJson := ResponseJson.GetValue('reply');
    if StationsJson is TJSONArray then
    begin
      SetLength(Stations, TJSONArray(StationsJson).Count);
      for I := 0 to TJSONArray(StationsJson).Count - 1 do
      begin
        JsonObj := TJSONArray(StationsJson).Items[I] as TJSONObject;
        Station := TvcsStation.Create;

        // 각 필드별 명시적 파싱
        if JsonObj.TryGetValue('code', JsonValue) and (not JsonValue.Null) then
          Station.fcode := JsonValue.AsType<string>
        else
          Station.fcode := '';

        if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
          Station.fname := JsonValue.AsType<string>
        else
          Station.fname := '';

        if JsonObj.TryGetValue('upDepartDelay', JsonValue) and (not JsonValue.Null) then
          Station.fupDepartDelay := JsonValue.AsType<Integer>
        else
          Station.fupDepartDelay := 0;

        if JsonObj.TryGetValue('dnDepartDelay', JsonValue) and (not JsonValue.Null) then
          Station.fdnDepartDelay := JsonValue.AsType<Integer>
        else
          Station.fdnDepartDelay := 0;

        if JsonObj.TryGetValue('upApprTcode', JsonValue) and (not JsonValue.Null) then
          Station.fupApprTcode := JsonValue.AsType<string>
        else
          Station.fupApprTcode := '';

        if JsonObj.TryGetValue('upArrvTcode', JsonValue) and (not JsonValue.Null) then
          Station.fupArrvTcode := JsonValue.AsType<string>
        else
          Station.fupArrvTcode := '';

        if JsonObj.TryGetValue('upLeavTcode', JsonValue) and (not JsonValue.Null) then
          Station.fupLeavTcode := JsonValue.AsType<string>
        else
          Station.fupLeavTcode := '';

        if JsonObj.TryGetValue('dnApprTcode', JsonValue) and (not JsonValue.Null) then
          Station.fdnApprTcode := JsonValue.AsType<string>
        else
          Station.fdnApprTcode := '';

        if JsonObj.TryGetValue('dnArrvTcode', JsonValue) and (not JsonValue.Null) then
          Station.fdnArrvTcode := JsonValue.AsType<string>
        else
          Station.fdnArrvTcode := '';

        if JsonObj.TryGetValue('dnLeavTcode', JsonValue) and (not JsonValue.Null) then
          Station.fdnLeavTcode := JsonValue.AsType<string>
        else
          Station.fdnLeavTcode := '';

        if JsonObj.TryGetValue('prevCode', JsonValue) and (not JsonValue.Null) then
          Station.fprevCode := JsonValue.AsType<string>
        else
          Station.fprevCode := '';

        if JsonObj.TryGetValue('prevName', JsonValue) and (not JsonValue.Null) then
          Station.fprevName := JsonValue.AsType<string>
        else
          Station.fprevName := '';

        if JsonObj.TryGetValue('nextCode', JsonValue) and (not JsonValue.Null) then
          Station.fnextCode := JsonValue.AsType<string>
        else
          Station.fnextCode := '';

        if JsonObj.TryGetValue('nextName', JsonValue) and (not JsonValue.Null) then
          Station.fnextName := JsonValue.AsType<string>
        else
          Station.fnextName := '';

        if JsonObj.TryGetValue('upRtsp', JsonValue) and (not JsonValue.Null) then
          Station.fupRtsp := JsonValue.AsType<string>
        else
          Station.fupRtsp := '';

        if JsonObj.TryGetValue('dnRtsp', JsonValue) and (not JsonValue.Null) then
          Station.fdnRtsp := JsonValue.AsType<string>
        else
          Station.fdnRtsp := '';
        if JsonObj.TryGetValue('upView', JsonValue) and (not JsonValue.Null) then
          Station.fupView := JsonValue.AsType<string>
        else
          Station.fupView := '';

        if JsonObj.TryGetValue('dnView', JsonValue) and (not JsonValue.Null) then
          Station.fdnView := JsonValue.AsType<string>
        else
          Station.fdnView := '';

        Stations[I] := Station;
      end;
      Result := Stations;
    end
    else
      Result := nil;
  except
    Result := nil;
  end;
end;

function TTVCSAPI.AddStation(StationInfo: TvcsStationInPost): TvcsStation;
var
  RequestJson, ResponseJson: TJSONObject;
  StationJson: TJSONValue;
  ResultStation: TvcsStation;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(StationInfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_STATION, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      StationJson := ResponseJson.GetValue('reply');
      ResultStation := TJson.JsonToObject<TvcsStation>(StationJson.ToString);
      Result := ResultStation;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateStation(stationinfo: TvcsStationInPatch):TvcsStation;
var
 RequestJson, ResponseJson: TJSONObject;
 StationJson: TJSONValue;
 ResultStation: TvcsStation;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(StationInfo);

  try
    ResponseJson := FAPIBase.PatchAPI(API_STATION, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    StationJson := ResponseJson.GetValue('reply');
    ResultStation := TJSON.JsonToObject<TvcsStation>(StationJson.ToString);
    Result := ResultStation;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteStation(code:String=''):string;
var
  ResponseStr : string;
  ResponseJson : TJSONObject;
  ErrorMsg : string;
begin
  ResponseStr := FAPIBase.DeleteAPI(API_STATION,'code='+code);
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;
  Result := ResponseStr;
end;

//Train
function TTVCSAPI.GetTrain(trainNo:integer=-1):TArray<TvcsTrain>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  TrainsJson: TJSONValue;
  Trains: TArray<TvcsTrain>;
  I: Integer;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  train : TVCSTrain;
begin
  if trainNo <> -1 then
    ResponseStr := FAPIBase.GetAPI(API_TRAIN, 'trainNo=' + IntToStr(trainNo))
  else
  begin
    ResponseStr := FAPIBase.GetAPI(API_TRAIN);
  end;

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;

  // 잘못된 JSON 형식 수정 (carriageNum: 뒤의 쉼표 처리)
  ResponseStr := StringReplace(ResponseStr, '"carriageNum":,', '"carriageNum":null,', [rfReplaceAll]);

  try
    ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit(nil);

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit(nil);

    TrainsJson := ResponseJson.GetValue('reply');
    if TrainsJson is TJSONArray then
    begin
      SetLength(Trains, TJSONArray(TrainsJson).Count);
      for I := 0 to TJSONArray(TrainsJson).Count - 1 do
      begin
        JsonObj := TJSONArray(TrainsJson).Items[I] as TJSONObject;
        Train := TvcsTrain.Create;

        // id는 JSON에서 'id'로 되어있지만 객체는 'fid'를 사용
        if JsonObj.TryGetValue('id', JsonValue) and (not JsonValue.Null) then
          Train.fid := JsonValue.AsType<Integer>
        else
          Train.fid := 0;

        if JsonObj.TryGetValue('trainNo', JsonValue) and (not JsonValue.Null) then
          Train.ftrainNo := JsonValue.AsType<String>
        else
          Train.ftrainNo := '';

        if JsonObj.TryGetValue('formatNo', JsonValue) and (not JsonValue.Null) then
          Train.fformatNo := JsonValue.AsType<Integer>
        else
          Train.fformatNo := 0;

        if JsonObj.TryGetValue('carriageNum', JsonValue) and (not JsonValue.Null) then
          Train.fcarriageNum := JsonValue.AsType<Integer>
        else
          Train.fcarriageNum := 0;

        if JsonObj.TryGetValue('cameraNum', JsonValue) and (not JsonValue.Null) then
          Train.fcameraNum := JsonValue.AsType<Integer>
        else
          Train.fcameraNum := 0;

        if JsonObj.TryGetValue('tvcsIpaddr', JsonValue) and (not JsonValue.Null) then
          Train.ftvcsIpaddr := JsonValue.AsType<string>
        else
          Train.ftvcsIpaddr := '';

        Trains[I] := Train;
      end;
      Result := Trains;
    end
    else
      Result := nil;
  except
    Result := nil;
  end;
end;

function TTVCSAPI.AddTrain(traininfo:TVCSTrainInPost):TvcsTrain;
var
  RequestJson, ResponseJson: TJSONObject;
  TrainJson: TJSONValue;
  ResultTrain: TvcsTrain;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(traininfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_TRAIN, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      TrainJson := ResponseJson.GetValue('reply');
      ResultTrain := TJson.JsonToObject<TvcsTrain>(TrainJson.ToString);
      Result := ResultTrain;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateTrain(traininfo:TVCSTrainInPatch):TvcsTrain;
var
 RequestJson, ResponseJson: TJSONObject;
 TrainJson: TJSONValue;
 ResultStation: TvcsTrain;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(TrainInfo);

  try
    ResponseJson := FAPIBase.PatchAPI(API_TRAIN, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    TrainJson := ResponseJson.GetValue('reply');
    ResultStation := TJSON.JsonToObject<TvcsTrain>(TrainJson.ToString);
    Result := ResultStation;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteTrain(trainId:integer):string;
var
  ResponseStr : string;
  ResponseJson : TJSONObject;
  ErrorMsg : string;
begin
  ResponseStr := FAPIBase.DeleteAPI(API_TRAIN,'id='+IntToStr(trainId));
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;
  Result := ResponseStr;
end;

//trainServcie
function TTVCSAPI.GetTrainService(trainId:string =''; stationCode:string =''):TArray<TvcsTrainService>;
var
  ResponseStr, ErrorMsg, ParamStr: string;
  ResponseJson: TJSONObject;
  TrainServiceJson: TJSONValue;
  TrainServices: TArray<TvcsTrainService>;
  I: Integer;
begin
  if trainId <> '' then
    ParamStr := 'trainId=' + trainId + '&stationCode=' + stationCode
  else
    ParamStr := '';

  ResponseStr := FAPIBase.GetAPI(API_TRAIN_SERVICE, ParamStr);
  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  TrainServiceJson := ResponseJson.GetValue('reply');
  if TrainServiceJson is TJSONArray then
  begin
    SetLength(TrainServices, TJSONArray(TrainServiceJson).Count);
    for I := 0 to TJSONArray(TrainServiceJson).Count - 1 do
      TrainServices[I] := TJSON.JsonToObject<TvcsTrainService>(TJSONArray(TrainServiceJson).Items[I] as TJSONObject);
    Result := TrainServices;
  end
  else
    Result := nil;
end;

//stationCamera
function TTVCSAPI.GetStationCamera(stationCode:string=''):TArray<TVCSStationCamera>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  StationCameraJson: TJSONValue;
  StationCameras: TArray<TVCSStationCamera>;
  I: Integer;
begin
  if stationCode <> '' then
    stationCode := 'stationCode=' + stationCode;

  ResponseStr := FAPIBase.GetAPI(API_STATION_CAMERA, stationCode);
  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  StationCameraJson := ResponseJson.GetValue('reply');
  if StationCameraJson is TJSONArray then
  begin
    SetLength(StationCameras, TJSONArray(StationCameraJson).Count);
    for I := 0 to TJSONArray(StationCameraJson).Count - 1 do
      StationCameras[I] := TJSON.JsonToObject<TVCSStationCamera>(TJSONArray(StationCameraJson).Items[I] as TJSONObject);
    Result := StationCameras;
  end
  else
    Result := nil;
end;

function TTVCSAPI.AddStationCamera(stationCamerainfo:TVCSStationCameraPost):TVCSStationCamera;
var
  RequestJson, ResponseJson: TJSONObject;
  StationCameraJson: TJSONValue;
  ResultStationCamera: TVCSStationCamera;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(stationCamerainfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_STATION_CAMERA, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      StationCameraJson := ResponseJson.GetValue('reply');
      ResultStationCamera := TJson.JsonToObject<TVCSStationCamera>(StationCameraJson.ToString);
      Result := ResultStationCamera;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateStationCamera(stationCamerainfo:TVCSStationCameraPatch):TVCSStationCamera;
var
 RequestJson, ResponseJson: TJSONObject;
 StationCameraJson: TJSONValue;
 ResultStationCamera: TVCSStationCamera;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(stationCamerainfo);

  try
    ResponseJson := FAPIBase.PatchAPI(API_STATION_CAMERA, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    StationCameraJson := ResponseJson.GetValue('reply');
    ResultStationCamera := TJSON.JsonToObject<TVCSStationCamera>(StationCameraJson.ToString);
    Result := ResultStationCamera;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteStationCamera(fid:integer):string;
var
  ResponseStr : string;
  ResponseJson : TJSONObject;
  ErrorMsg : string;
begin
  ResponseStr := FAPIBase.DeleteAPI(API_STATION_CAMERA,'id='+IntToStr(fid));
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;
  Result := ResponseStr;
end;

//trainCamera
function TTVCSAPI.GetTrainCamera(trainId:integer=-1):TArray<TVCSTrainCamera>;
var
 ResponseStr, ErrorMsg: string;
 ResponseJson: TJSONObject;
 TrainCamerasJson: TJSONValue;
 TrainCameras: TArray<TVCSTrainCamera>;
 I: Integer;
 JsonObj: TJSONObject;
 JsonValue: TJSONValue;
 Camera: TVCSTrainCamera;
begin
 if trainId <> -1 then
   ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA, 'trainId=' + IntToStr(trainId))
 else
 begin
   ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA);
 end;

 FResponseText := FAPIBase.ResponseText;
 FResponseCode := FAPIBase.ResponseCode;

 ResponseStr := StringReplace(ResponseStr, '":,', '":null,', [rfReplaceAll]);  // 빈 값 처리

 try
   ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;
   if ResponseJson = nil then
     Exit(nil);

   if CheckError(ResponseJson, ErrorMsg) <> 0 then
     Exit(nil);

   TrainCamerasJson := ResponseJson.GetValue('reply');
   if TrainCamerasJson is TJSONArray then
   begin
     SetLength(TrainCameras, TJSONArray(TrainCamerasJson).Count);
     for I := 0 to TJSONArray(TrainCamerasJson).Count - 1 do
     begin
       JsonObj := TJSONArray(TrainCamerasJson).Items[I] as TJSONObject;
       Camera := TVCSTrainCamera.Create;

       if JsonObj.TryGetValue('id', JsonValue) and (not JsonValue.Null) then
         Camera.fid := JsonValue.AsType<Integer>
       else
         Camera.fid := 0;

       if JsonObj.TryGetValue('trainNo', JsonValue) and (not JsonValue.Null) then
         Camera.ftrainNo := JsonValue.AsType<Integer>
       else
         Camera.ftrainNo := 0;

       if JsonObj.TryGetValue('position', JsonValue) and (not JsonValue.Null) then
         Camera.fposition := JsonValue.AsType<Integer>
       else
         Camera.fposition := 0;

       if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
         Camera.fname := JsonValue.AsType<string>
       else
         Camera.fname := '';

       if JsonObj.TryGetValue('ipaddr', JsonValue) and (not JsonValue.Null) then
         Camera.fipaddr := JsonValue.AsType<string>
       else
         Camera.fipaddr := '';

       if JsonObj.TryGetValue('port', JsonValue) and (not JsonValue.Null) then
         Camera.fport := JsonValue.AsType<Integer>
       else
         Camera.fport := 0;

       if JsonObj.TryGetValue('rtsp', JsonValue) and (not JsonValue.Null) then
         Camera.frtsp := JsonValue.AsType<string>
       else
         Camera.frtsp := '';

       if JsonObj.TryGetValue('rtsp2', JsonValue) and (not JsonValue.Null) then
         Camera.frtsp2 := JsonValue.AsType<string>
       else
         Camera.frtsp2 := '';

       if JsonObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
         Camera.ftvcsRtsp := JsonValue.AsType<string>
       else
         Camera.ftvcsRtsp := '';

       if JsonObj.TryGetValue('userId', JsonValue) and (not JsonValue.Null) then
         Camera.fuserId := JsonValue.AsType<string>
       else
         Camera.fuserId := '';

       if JsonObj.TryGetValue('userPwd', JsonValue) and (not JsonValue.Null) then
         Camera.fuserPwd := JsonValue.AsType<string>
       else
         Camera.fuserPwd := '';



       Camera.fresource := nil;  // 객체는 기본적으로 nil로 초기화

       TrainCameras[I] := Camera;
     end;
     Result := TrainCameras;
   end
   else
     Result := nil;
 except
   Result := nil;
 end;
end;

function TTVCSAPI.AddTrainCamera(trainCameraInfo:TVCSTrainCameraInPost):TVCSTrainCamera;
var
  RequestJson, ResponseJson: TJSONObject;
  TrainCamerasJson: TJSONValue;
  ResultTrainCamera: TVCSTrainCamera;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(trainCameraInfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_TRAIN_CAMERA, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      TrainCamerasJson := ResponseJson.GetValue('reply');
      ResultTrainCamera := TJson.JsonToObject<TVCSTrainCamera>(TrainCamerasJson.ToString);
      Result := ResultTrainCamera;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateTrainCamera(trainCameraInfo:TVCSTrainCameraInPatch):TVCSTrainCamera;
var
 RequestJson, ResponseJson: TJSONObject;
 TrainCameraJson: TJSONValue;
 ResultTrainCamera: TVCSTrainCamera;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(trainCameraInfo);

  try
    ResponseJson := FAPIBase.PatchAPI(API_TRAIN_CAMERA, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    TrainCameraJson := ResponseJson.GetValue('reply');
    ResultTrainCamera := TJSON.JsonToObject<TVCSTrainCamera>(TrainCameraJson.ToString);
    Result := ResultTrainCamera;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteTrainCamera(fid:integer):string;
var
  ResponseStr : string;
  ResponseJson : TJSONObject;
  ErrorMsg : string;
begin
  ResponseStr := FAPIBase.DeleteAPI(API_TRAIN_CAMERA,'id='+IntToStr(fid));
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;
  Result := ResponseStr;
end;

//TrainCameraMerge
//TrainCameraMerge
function TTVCSAPI.GetTrainCameraMerge(trainId:integer=-1):TArray<TVCSTrainCameraMerge>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  TrainCameraMergesJson: TJSONValue;
  TrainCameraMerges: TArray<TVCSTrainCameraMerge>;
  I, J: Integer;
  JsonObj, ItemObj: TJSONObject;
  JsonValue, ItemsValue: TJSONValue;
  MergeCamera: TVCSTrainCameraMerge;
  MergeInfo: fmergeCamInfo;
begin
  Result := nil;
  if trainId <> -1 then
    ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA_MERGE, 'trainId=' + IntToStr(trainId))
  else
    ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA_MERGE);

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseStr := StringReplace(ResponseStr, '":,', '":null,', [rfReplaceAll]);

  try
    ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit;

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit;

    TrainCameraMergesJson := ResponseJson.GetValue('reply');
    if not (TrainCameraMergesJson is TJSONArray) then
      Exit;

    SetLength(TrainCameraMerges, TJSONArray(TrainCameraMergesJson).Count);

    for I := 0 to TJSONArray(TrainCameraMergesJson).Count - 1 do
    begin
      JsonObj := TJSONArray(TrainCameraMergesJson).Items[I] as TJSONObject;
      MergeCamera := TVCSTrainCameraMerge.Create;
      try
        // Parse basic fields
        if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
          MergeCamera.fname := JsonValue.AsType<string>
        else
          MergeCamera.fname := '';

        if JsonObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
          MergeCamera.ftvcsRtsp := JsonValue.AsType<string>
        else
          MergeCamera.ftvcsRtsp := '';

        if JsonObj.TryGetValue('width', JsonValue) and (not JsonValue.Null) then
          MergeCamera.fwidth := JsonValue.AsType<Integer>
        else
          MergeCamera.fwidth := 0;

        if JsonObj.TryGetValue('height', JsonValue) and (not JsonValue.Null) then
          MergeCamera.fheight := JsonValue.AsType<Integer>
        else
          MergeCamera.fheight := 0;

        if JsonObj.TryGetValue('divNum', JsonValue) and (not JsonValue.Null) then
          MergeCamera.fdivNum := JsonValue.AsType<Integer>
        else
          MergeCamera.fdivNum := 0;

        // Parse items array
        if JsonObj.TryGetValue('item', ItemsValue) and (ItemsValue is TJSONArray) then
        begin
          SetLength(MergeCamera.fitem, TJSONArray(ItemsValue).Count);
          for J := 0 to TJSONArray(ItemsValue).Count - 1 do
          begin
            ItemObj := TJSONArray(ItemsValue).Items[J] as TJSONObject;
            MergeInfo := fmergeCamInfo.Create;

            if ItemObj.TryGetValue('id', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fid := JsonValue.AsType<Integer>;

            if ItemObj.TryGetValue('trainId', JsonValue) and (not JsonValue.Null) then
              MergeInfo.ftrainId := JsonValue.AsType<Integer>;

            if ItemObj.TryGetValue('cameraId', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fcameraId := JsonValue.AsType<Integer>;

            if ItemObj.TryGetValue('position', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fposition := JsonValue.AsType<Integer>;

            if ItemObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fname := JsonValue.AsType<string>;

            if ItemObj.TryGetValue('ipaddr', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fipaddr := JsonValue.AsType<string>;

            if ItemObj.TryGetValue('port', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fport := JsonValue.AsType<Integer>;

            if ItemObj.TryGetValue('rtsp', JsonValue) and (not JsonValue.Null) then
              MergeInfo.frtsp := JsonValue.AsType<string>;

            if ItemObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
              MergeInfo.ftvcsRtsp := JsonValue.AsType<string>;

            if ItemObj.TryGetValue('userId', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fuserid := JsonValue.AsType<string>;

            if ItemObj.TryGetValue('userPwd', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fuserPwd := JsonValue.AsType<string>;

            if ItemObj.TryGetValue('positionX', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fpositionX := JsonValue.AsType<Integer>;

            if ItemObj.TryGetValue('positionY', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fpositionY := JsonValue.AsType<Integer>;

            MergeCamera.fitem[J] := MergeInfo;
          end;
        end;

        TrainCameraMerges[I] := MergeCamera;
      except
        FreeAndNil(MergeCamera);
        raise;
      end;
    end;

    Result := TrainCameraMerges;
  except
    if Length(TrainCameraMerges) > 0 then
      for I := 0 to Length(TrainCameraMerges) - 1 do
        FreeAndNil(TrainCameraMerges[I]);
    SetLength(TrainCameraMerges, 0);
    Result := nil;
  end;
end;

function TTVCSAPI.AddTrainCameraMerge(trainCameraMergeInfo:TVCSTrainCameraMergePost):TVCSTrainCameraMerge;
var
  RequestJson, ResponseJson: TJSONObject;
  TrainCamerasMergeJson: TJSONValue;
  ResultTrainCameraMerge: TVCSTrainCameraMerge;
  ErrorMsg: string;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  I: Integer;
  ItemArray: TJSONArray;
  ItemObject: TJSONObject;
  ItemInfo: fmergePostInfo;
begin
  Result := nil;
  RequestJson := TJSONObject.Create;
  try
    // Create request JSON
    RequestJson.AddPair('trainId', TJSONNumber.Create(trainCameraMergeInfo.ftrainId));
    RequestJson.AddPair('name', trainCameraMergeInfo.fname);
    RequestJson.AddPair('divNum', TJSONNumber.Create(trainCameraMergeInfo.fdivNum));
    RequestJson.AddPair('width', TJSONNumber.Create(trainCameraMergeInfo.fwidth));
    RequestJson.AddPair('height', TJSONNumber.Create(trainCameraMergeInfo.fheight));

    // Create items array
    ItemArray := TJSONArray.Create;
    for ItemInfo in trainCameraMergeInfo.fitem do
    begin
      ItemObject := TJSONObject.Create;
      ItemObject.AddPair('cameraId', TJSONNumber.Create(ItemInfo.fcameraId));
      ItemObject.AddPair('positionX', TJSONNumber.Create(ItemInfo.fPositionX));
      ItemObject.AddPair('positionY', TJSONNumber.Create(ItemInfo.fPositionY));
      ItemArray.AddElement(ItemObject);
    end;
    RequestJson.AddPair('item', ItemArray);

    ResponseJson := FAPIBase.PostAPI(API_TRAIN_CAMERA_MERGE, RequestJson);
    try
      if ResponseJson = nil then
        Exit;

      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit;
      end;

      TrainCamerasMergeJson := ResponseJson.GetValue('reply');
      if TrainCamerasMergeJson = nil then
        Exit;

      try
        ResultTrainCameraMerge := TVCSTrainCameraMerge.Create;
        JsonObj := TrainCamerasMergeJson as TJSONObject;

        if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fname := JsonValue.AsType<string>;

        if JsonObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.ftvcsRtsp := JsonValue.AsType<string>;

        if JsonObj.TryGetValue('width', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fwidth := JsonValue.AsType<Integer>;

        if JsonObj.TryGetValue('height', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fheight := JsonValue.AsType<Integer>;

        if JsonObj.TryGetValue('divNum', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fdivNum := JsonValue.AsType<Integer>;

        // Parse item array
        if JsonObj.TryGetValue('item', JsonValue) and (JsonValue is TJSONArray) then
        begin
          SetLength(ResultTrainCameraMerge.fitem, TJSONArray(JsonValue).Count);
          for I := 0 to TJSONArray(JsonValue).Count - 1 do
          begin
            var MergeInfo := fmergeCamInfo.Create;
            JsonObj := TJSONArray(JsonValue).Items[I] as TJSONObject;

            if JsonObj.TryGetValue('id', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fid := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('trainId', JsonValue) and (not JsonValue.Null) then
              MergeInfo.ftrainId := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('cameraid', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fcameraid := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('position', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fposition := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fname := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('ipaddr', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fipaddr := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('port', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fport := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('rtsp', JsonValue) and (not JsonValue.Null) then
              MergeInfo.frtsp := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
              MergeInfo.ftvcsRtsp := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('userid', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fuserid := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('userPwd', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fuserPwd := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('positionX', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fpositionX := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('positionY', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fpositionY := JsonValue.AsType<Integer>;

            ResultTrainCameraMerge.fitem[I] := MergeInfo;
          end;
        end;

        Result := ResultTrainCameraMerge;
      except
        FreeAndNil(ResultTrainCameraMerge);
        raise;
      end;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateTrainCameraMerge(trainCameraMergeInfo:TVCSTrainCameraMergePatch):TVCSTrainCameraMerge;
var
  RequestJson, ResponseJson: TJSONObject;
  trainCameraMergeJson: TJSONValue;
  ResultTrainCameraMerge: TVCSTrainCameraMerge;
  ErrorMsg: string;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  I: Integer;
  MergeInfo: fmergeCamInfo;
begin
  Result := nil;
  RequestJson := TJson.ObjectToJsonObject(trainCameraMergeInfo);
  try
    ResponseJson := FAPIBase.PatchAPI(API_TRAIN_CAMERA_MERGE, RequestJson);
    try
      if ResponseJson = nil then
        Exit;

      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit;
      end;

      trainCameraMergeJson := ResponseJson.GetValue('reply');
      if trainCameraMergeJson = nil then
        Exit;

      try
        ResultTrainCameraMerge := TVCSTrainCameraMerge.Create;
        JsonObj := trainCameraMergeJson as TJSONObject;

        // Parse basic fields
        if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fname := JsonValue.AsType<string>
        else
          ResultTrainCameraMerge.fname := '';

        if JsonObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.ftvcsRtsp := JsonValue.AsType<string>
        else
          ResultTrainCameraMerge.ftvcsRtsp := '';

        if JsonObj.TryGetValue('width', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fwidth := JsonValue.AsType<Integer>
        else
          ResultTrainCameraMerge.fwidth := 0;

        if JsonObj.TryGetValue('height', JsonValue) and (not JsonValue.Null) then
          ResultTrainCameraMerge.fheight := JsonValue.AsType<Integer>
        else
          ResultTrainCameraMerge.fheight := 0;

        // Parse item array
        if JsonObj.TryGetValue('item', JsonValue) and (JsonValue is TJSONArray) then
        begin
          SetLength(ResultTrainCameraMerge.fitem, TJSONArray(JsonValue).Count);
          for I := 0 to TJSONArray(JsonValue).Count - 1 do
          begin
            MergeInfo := fmergeCamInfo.Create;
            JsonObj := TJSONArray(JsonValue).Items[I] as TJSONObject;

            if JsonObj.TryGetValue('id', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fid := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('trainId', JsonValue) and (not JsonValue.Null) then
              MergeInfo.ftrainId := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('cameraid', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fcameraid := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('name', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fname := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('ipaddr', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fipaddr := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('port', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fport := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('rtsp', JsonValue) and (not JsonValue.Null) then
              MergeInfo.frtsp := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('tvcsRtsp', JsonValue) and (not JsonValue.Null) then
              MergeInfo.ftvcsRtsp := JsonValue.AsType<string>;

            if JsonObj.TryGetValue('positionX', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fpositionX := JsonValue.AsType<Integer>;

            if JsonObj.TryGetValue('positionY', JsonValue) and (not JsonValue.Null) then
              MergeInfo.fpositionY := JsonValue.AsType<Integer>;

            ResultTrainCameraMerge.fitem[I] := MergeInfo;
          end;
        end;

        Result := ResultTrainCameraMerge;
      except
        FreeAndNil(ResultTrainCameraMerge);
        raise;
      end;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteTrainCameraMerge(trinId: Integer; fname:string):string;
var
  ResponseStr : string;
  ResponseJson : TJSONObject;
  ErrorMsg : string;
begin
  ResponseStr := FAPIBase.DeleteAPI(API_TRAIN_CAMERA_MERGE,'trinId='+IntToStr(trinId)+'&name='+fname);
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;
  Result := ResponseStr;
end;

//license
function TTVCSAPI.GetLicense():TArray<TVCSLicense>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  LicenseJson, CameraJson, ClientJson: TJSONValue;
  Licenses: TArray<TVCSLicense>;
  License: TVCSLicense;
  CameraLicense: TVCSCameraLicense;
  ClientLicense: TVCSClientLicense;
  I, J: Integer;
  JsonObj, CamObj, ClientObj: TJSONObject;
  JsonValue: TJSONValue;
begin
  Result := nil;
  ResponseStr := FAPIBase.GetAPI(API_LICENSE);
  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;

  try
    ResponseStr := StringReplace(ResponseStr, '":,', '":null,', [rfReplaceAll]);
    ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit;

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit;

    LicenseJson := ResponseJson.GetValue('reply');
    if not (LicenseJson is TJSONArray) then
      Exit;

    SetLength(Licenses, TJSONArray(LicenseJson).Count);

    for I := 0 to TJSONArray(LicenseJson).Count - 1 do
    begin
      JsonObj := TJSONArray(LicenseJson).Items[I] as TJSONObject;
      License := TVCSLicense.Create;
      try
        // Camera License 파싱
        if JsonObj.TryGetValue('cameraLicense', CameraJson) and (CameraJson is TJSONArray) then
        begin
          SetLength(License.fcameraLicense, TJSONArray(CameraJson).Count);
          for J := 0 to TJSONArray(CameraJson).Count - 1 do
          begin
            CamObj := TJSONArray(CameraJson).Items[J] as TJSONObject;
            CameraLicense := TVCSCameraLicense.Create;

            if CamObj.TryGetValue('cameraNum', JsonValue) and (not JsonValue.Null) then
              CameraLicense.fcameraNum := JsonValue.AsType<Integer>
            else
              CameraLicense.fcameraNum := 0;

            if CamObj.TryGetValue('licenseKey', JsonValue) and (not JsonValue.Null) then
              CameraLicense.flicenseKey := JsonValue.AsType<string>
            else
              CameraLicense.flicenseKey := '';

            if CamObj.TryGetValue('isConfirm', JsonValue) and (not JsonValue.Null) then
              CameraLicense.fisConfirm := JsonValue.AsType<Boolean>
            else
              CameraLicense.fisConfirm := False;

            License.fcameraLicense[J] := CameraLicense;
          end;
        end;

        // Client License 파싱
        if JsonObj.TryGetValue('clientLicense', ClientJson) and (ClientJson is TJSONArray) then
        begin
          SetLength(License.fclientLicense, TJSONArray(ClientJson).Count);
          for J := 0 to TJSONArray(ClientJson).Count - 1 do
          begin
            ClientObj := TJSONArray(ClientJson).Items[J] as TJSONObject;
            ClientLicense := TVCSClientLicense.Create;

            if ClientObj.TryGetValue('clientNum', JsonValue) and (not JsonValue.Null) then
              ClientLicense.fclientNum := JsonValue.AsType<Integer>
            else
              ClientLicense.fclientNum := 0;

            if ClientObj.TryGetValue('licenseKey', JsonValue) and (not JsonValue.Null) then
              ClientLicense.flicenseKey := JsonValue.AsType<string>
            else
              ClientLicense.flicenseKey := '';

            if ClientObj.TryGetValue('isConfirm', JsonValue) and (not JsonValue.Null) then
              ClientLicense.fisConfirm := JsonValue.AsType<Boolean>
            else
              ClientLicense.fisConfirm := False;

            License.fclientLicense[J] := ClientLicense;
          end;
        end;

        Licenses[I] := License;
      except
        FreeAndNil(License);
        raise;
      end;
    end;

    Result := Licenses;

  except
    // 메모리 해제
    if Length(Licenses) > 0 then
    begin
      for I := 0 to Length(Licenses) - 1 do
      begin
        if Assigned(Licenses[I]) then
        begin
          // Camera License 메모리 해제
          if Length(Licenses[I].fcameraLicense) > 0 then
          begin
            for J := 0 to Length(Licenses[I].fcameraLicense) - 1 do
              FreeAndNil(Licenses[I].fcameraLicense[J]);
            SetLength(Licenses[I].fcameraLicense, 0);
          end;

          // Client License 메모리 해제
          if Length(Licenses[I].fclientLicense) > 0 then
          begin
            for J := 0 to Length(Licenses[I].fclientLicense) - 1 do
              FreeAndNil(Licenses[I].fclientLicense[J]);
            SetLength(Licenses[I].fclientLicense, 0);
          end;

          FreeAndNil(Licenses[I]);
        end;
      end;
      SetLength(Licenses, 0);
    end;
    Result := nil;
  end;
end;

function TTVCSAPI.GetDevice(ftype:integer=-1):TArray<TVCSDevice>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  DeviceJSson: TJSONValue;
  Devices: TArray<TVCSDevice>;
  I: Integer;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  Device : TVCSDevice;
begin
  if ftype <> -1 then
    ResponseStr := FAPIBase.GetAPI(api_device, 'type=' + IntToStr(ftype))
  else
  begin
    ResponseStr := FAPIBase.GetAPI(api_device);
  end;

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;

  try
    ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit(nil);

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit(nil);

    DeviceJSson := ResponseJson.GetValue('reply');
    if DeviceJSson is TJSONArray then
    begin
      SetLength(Devices, TJSONArray(DeviceJSson).Count);
      for I := 0 to TJSONArray(DeviceJSson).Count - 1 do
      begin
        JsonObj := TJSONArray(DeviceJSson).Items[I] as TJSONObject;
        Device := TVCSDevice.Create;

        // id는 JSON에서 'id'로 되어있지만 객체는 'fid'를 사용
        if JsonObj.TryGetValue('id', JsonValue) and (not JsonValue.Null) then
          Device.fid := JsonValue.AsType<Integer>
        else
          Device.fid := 0;

        if JsonObj.TryGetValue('type', JsonValue) and (not JsonValue.Null) then
          Device.ftype := JsonValue.AsType<String>
        else
          Device.ftype := '';

        if JsonObj.TryGetValue('stationCode', JsonValue) and (not JsonValue.Null) then
          Device.fstationCode := JsonValue.AsType<integer>
        else
          Device.fstationCode := 0;

        if JsonObj.TryGetValue('trainNo', JsonValue) and (not JsonValue.Null) then
          Device.ftrainNo := JsonValue.AsType<Integer>
        else
          Device.ftrainNo := 0;

        if JsonObj.TryGetValue('ipAddr', JsonValue) and (not JsonValue.Null) then
          Device.fipAddr := JsonValue.AsType<String>
        else
          Device.fipAddr := '';

        if JsonObj.TryGetValue('port', JsonValue) and (not JsonValue.Null) then
          Device.fport := JsonValue.AsType<Integer>
        else
          Device.fport := 0;

        if JsonObj.TryGetValue('memo', JsonValue) and (not JsonValue.Null) then
          Device.fmemo := JsonValue.AsType<string>
        else
          Device.fmemo := '';

        if JsonObj.TryGetValue('loginId', JsonValue) and (not JsonValue.Null) then
          Device.floginId := JsonValue.AsType<string>
        else
          Device.floginId := '';

        if JsonObj.TryGetValue('loginPwd', JsonValue) and (not JsonValue.Null) then
          Device.floginPwd := JsonValue.AsType<string>
        else
          Device.floginPwd := '';


        Devices[I] := Device;
      end;
      Result := Devices;
    end
    else
      Result := nil;
  except
    Result := nil;
  end;
end;

function TTVCSAPI.AddDevice(deviceInfo:TVCSDevicePost):TVCSDevice;
var
  RequestJson, ResponseJson: TJSONObject;
  DeviceJson: TJSONValue;
  ResultDevice: TVCSDevice;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(deviceInfo);
  try
    ResponseJson := FAPIBase.PostAPI(api_device, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      DeviceJson := ResponseJson.GetValue('reply');
      ResultDevice := TJson.JsonToObject<TVCSDevice>(DeviceJson.ToString);
      Result := ResultDevice;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.UpdateDevice(deviceInfo:TVCSDevice):TVCSDevice;
var
 RequestJson, ResponseJson: TJSONObject;
 DeviceJson: TJSONValue;
 ResultDevice: TVCSDevice;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(deviceInfo);

  try
    ResponseJson := FAPIBase.PatchAPI(api_device, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    DeviceJson := ResponseJson.GetValue('reply');
    ResultDevice := TJSON.JsonToObject<TVCSDevice>(DeviceJson.ToString);
    Result := ResultDevice;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteDevice(deviceId: Integer):string;
var
  ResponseStr : string;
  ResponseJson : TJSONObject;
  ErrorMsg : string;
begin
  ResponseStr := FAPIBase.DeleteAPI(api_device,'id='+IntToStr(deviceId));
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
  begin
    ShowMessage(FErrorMsg);
    Exit('');
  end;
  Result := ResponseStr;
end;

function TTVCSAPI.AddLicense(licenseinfo:TVCSLicensePost):TVCSLicense;
var
  RequestJson, ResponseJson: TJSONObject;
  LicenseJson: TJSONValue;
  ResultLicense: TVCSLicense;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(licenseinfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_LICENSE, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      LicenseJson := ResponseJson.GetValue('reply');
      ResultLicense := TJson.JsonToObject<TVCSLicense>(LicenseJson.ToString);
      Result := ResultLicense;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.GetDeviceMsg(fdeviceId:integer=-1; ftype:string=''; fyy: string=''; fmm: string=''):TArray<TVCSDeviceMsg>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  DeviceMsgJSson: TJSONValue;
  DeviceMsgs: TArray<TVCSDeviceMsg>;
  I: Integer;
  JsonObj: TJSONObject;
  JsonValue: TJSONValue;
  DeviceMsg : TVCSDeviceMsg;
begin
  if fdeviceId <> -1 then
    ResponseStr := FAPIBase.GetAPI(api_deviceMsg, 'deviceId=' + IntToStr(fdeviceId)+'&type='+ftype+'&yy='+fyy+'&mm='+fmm)
  else
  begin
    ResponseStr := FAPIBase.GetAPI(api_deviceMsg);
  end;

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;

  try
    ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;
    if ResponseJson = nil then
      Exit(nil);

    if CheckError(ResponseJson, ErrorMsg) <> 0 then
      Exit(nil);

    DeviceMsgJSson := ResponseJson.GetValue('reply');
    if DeviceMsgJSson is TJSONArray then
    begin
      SetLength(DeviceMsgs, TJSONArray(DeviceMsgJSson).Count);
      for I := 0 to TJSONArray(DeviceMsgJSson).Count - 1 do
      begin
        JsonObj := TJSONArray(DeviceMsgJSson).Items[I] as TJSONObject;
        DeviceMsg := TVCSDeviceMsg.Create;

        // id는 JSON에서 'id'로 되어있지만 객체는 'fid'를 사용
        if JsonObj.TryGetValue('DeviceMsg', JsonValue) and (not JsonValue.Null) then
          DeviceMsg.fdeviceId := JsonValue.AsType<Integer>
        else
          DeviceMsg.fdeviceId := 0;

        if JsonObj.TryGetValue('type', JsonValue) and (not JsonValue.Null) then
          DeviceMsg.ftype := JsonValue.AsType<String>
        else
          DeviceMsg.ftype := '';

        if JsonObj.TryGetValue('msg', JsonValue) and (not JsonValue.Null) then
          DeviceMsg.fmsg := JsonValue.AsType<String>
        else
          DeviceMsg.fmsg := '';

        if JsonObj.TryGetValue('dttm', JsonValue) and (not JsonValue.Null) then
          DeviceMsg.fdttm := JsonValue.AsType<string>
        else
          DeviceMsg.fdttm := '';
        DeviceMsgs[I] := DeviceMsg;
      end;
      Result := DeviceMsgs;
    end
    else
      Result := nil;
  except
    Result := nil;
  end;
end;

function TTVCSAPI.AddDeviceMsg(deviceMsgInfo:TVCSDeviceMsgPost):TVCSDeviceMsg;
var
  RequestJson, ResponseJson: TJSONObject;
  DeviceMsgJson: TJSONValue;
  ResultDeviceMsg: TVCSDeviceMsg;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(deviceMsgInfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_LICENSE, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      DeviceMsgJson := ResponseJson.GetValue('reply');
      ResultDeviceMsg := TJson.JsonToObject<TVCSDeviceMsg>(DeviceMsgJson.ToString);
      Result := ResultDeviceMsg;
    finally
      ResponseJson.Free;
    end;
  finally
    RequestJson.Free;
  end;
end;


//system
function TTVCSAPI.UpdateSystem(SystemInfo:TvcsSystem):TVCSSystem;
var
 RequestJson, ResponseJson: TJSONObject;
 SystemJson: TJSONValue;
 ResulttSystem: TVCSSystem;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(SystemInfo);

  try
    ResponseJson := FAPIBase.PatchAPI(API_SYSTEM, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    SystemJson := ResponseJson.GetValue('reply');
    ResulttSystem := TJSON.JsonToObject<TVCSSystem>(SystemJson.ToString);
    Result := ResulttSystem;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;


function TTVCSAPI.GetApiList():TArray<TVCSApilist>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  ApiListJson: TJSONValue;
  ApiLists: TArray<TVCSApilist>;
  I: Integer;
begin

  ResponseStr := FAPIBase.GetAPI(API_LIST);

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  ApiListJson := ResponseJson.GetValue('reply');
  if ApiListJson is TJSONArray then
  begin
    SetLength(ApiLists, TJSONArray(ApiListJson).Count);
    for I := 0 to TJSONArray(ApiListJson).Count - 1 do
      ApiLists[I] := TJSON.JsonToObject<TVCSApilist>(TJSONArray(ApiListJson).Items[I] as TJSONObject);
    Result := ApiLists;
  end
  else
    Result := nil;
end;

constructor TReceiveThread.Create(ASocket: TWSocket; AReceiveDataMethod: TFunc<string>);
begin
  inherited Create(True);
  FWSocket := ASocket;
  FReceiveDataMethod := AReceiveDataMethod;
  FStopFlag := False;
  FreeOnTerminate := True;
end;

procedure TReceiveThread.Execute;
var
  Data: string;
begin
  OutputDebugString('Receive thread started');
  while not Terminated and not FStopFlag do
  //OutputDebugString('0');
  begin
    if Assigned(FReceiveDataMethod) then
    OutputDebugString('1');
    begin
      Data := FReceiveDataMethod();
      OutputDebugString(PChar('Raw received data: ' + Data));


      if Data <> '' then
      OutputDebugString('2');
      begin
        if Assigned(FOnReceiveData) then
          OutputDebugString('3');
          TThread.Synchronize(nil, procedure
          begin
            OutputDebugString(PChar('4 Data: '+Data));
            FOnReceiveData(Data);
          end);
      end;
    end;
    OutputDebugString('Receive thread loop');
    //Sleep(3000);
  end;
  OutputDebugString('Receive thread ended');

end;

procedure TReceiveThread.Stop;
begin
  FStopFlag := True;
end;


function TTVCSAPI.ConnectTCMS(const IPAddress, Port: string; out ErrorMsg: string; line: string): Boolean;
var
  ConnectTimeout: Integer;
  AuthStr, LineStr, SendStr: string;
begin
  WSocket.Proto := 'tcp';
  WSocket.Addr := IPAddress;
  WSocket.Port := Port;
  ConnectTimeout := 0;
  WSocket.Connect;
  while (WSocket.State <> wsConnected) and (ConnectTimeout < 50) do
  begin
    Application.ProcessMessages;
    Sleep(100);
    Inc(ConnectTimeout);
  end;

  if WSocket.State = wsConnected then
  begin
    AuthStr := EncodeString('admin:qwe123!@#');
    LineStr := line;
    SendStr := Format('auth=%s&line=%s'#10, [AuthStr, LineStr]);
    WSocket.SendStr(SendStr);


    // Start receive thread
    FReceiveThread := TReceiveThread.Create(WSocket, InternalReceiveData);
    FReceiveThread.OnReceiveData := ThreadReceiveData;
    FReceiveThread.Start;

    Result := True;
  end
  else
  begin
    ErrorMsg := 'Connection failed';
    Result := False;
  end;
end;

function TTVCSAPI.InternalReceiveData: string;
begin
  Result := ReceiveData;
end;

function TTVCSAPI.ReceiveData: string;
var
  Buffer: array[0..1023] of Byte;
  BytesRead: Integer;
  TotalBuffer: TBytes;
begin
  Result := '';
  if not Assigned(WSocket) then Exit;

  SetLength(TotalBuffer, 0);
  BytesRead := WSocket.Receive(@Buffer, SizeOf(Buffer));
  if BytesRead > 0 then
  begin
    SetLength(TotalBuffer, BytesRead);
    Move(Buffer[0], TotalBuffer[0], BytesRead);
    Result := TEncoding.UTF8.GetString(TotalBuffer);
  end;
end;

procedure TTVCSAPI.DisconnectTCMS(out ErrorMsg: string);
begin
  ErrorMsg := '';
  try
    if Assigned(FReceiveThread) then
    begin
      FReceiveThread.Stop;
      FReceiveThread.Terminate;
      FReceiveThread := nil;
    end;
    if Assigned(WSocket) and (WSocket.State = wsConnected) then
    begin
      WSocket.Close;
    end;
  except
    on E: Exception do
    begin
      ErrorMsg := 'Exception in DisconnectTCMS: ' + E.Message;
    end;
  end;
end;

procedure TTVCSAPI.ThreadReceiveData(const Data: string);
begin
  if Assigned(FOnReceiveData) then
    FOnReceiveData(Data);
end;

constructor TTvcsAPIBase.Create;
begin
   idHttp:=TIdHTTP.Create(nil);
   FuseSSL:=False;
   FURI:=nil;
   FConnected:=false;
   DebugMemo:=nil;
   inherited;
end;

constructor TTvcsAPIBase.Create(url:String);
begin
   inherited Create;
   self.FHostAddr:=url;
   FURI:=TidURI.create(url);
   if (LowerCase(FURI.Protocol)='https') then
       FuseSSL:=True
   else
       FuseSSL:=false;

end;

constructor TTvcsAPIBase.Create(url,userid,userpass:String);
begin
   inherited Create;
   Create(url);
   self.FUserId:=userid;
   self.FUserPass:=userpass;


end;

procedure TTVCSAPIBase.SetHostUrl(url: string);
begin

    self.FHostAddr:=url;
    if (FURI<>nil) then FreeAndNil(FURI);
    FURI:=TidURI.create(url);
    if (LowerCase(FURI.Protocol)='https') then
         FuseSSL:=True
     else
       FuseSSL:=false;


end;

function TTvcsAPIBase.GetHost: string;
begin
  if (FUrI<>nil) then
    Result:=FURI.Host
  else
    Result:='';
end;

function TTvcsAPIBase.GetPort: Integer;
begin

  if (FUrI<>nil) then
    Result:=StrToInt(FURI.Port)
  else
    Result:=0;
end;

function TTvcsAPIBase.GetPath:String;
begin
  if (FUrI<>nil) then
    Result:=FURI.Path
  else
    Result:='';

end;


procedure TTvcsAPIBase.OnAuthRequested(Sender: TObject; Authentication: TIdAuthentication; var Handled: Boolean);
begin

   Authentication.Username := FUserId; // new username
   Authentication.Password := FuserPass; // new password
   Handled := True;

end;
procedure TTVCSAPIBase.SetUser(username: string; password: string);
begin
     FUserId:=username;
     FUserPass:=password;

end;

procedure TTvcsAPIBase.SetAuthMethod(method: TTvcsAuthMethod);
var
 token:String;
begin
 if (method=tvcsBasic) then begin
   IDHttp.Request.BasicAuthentication:=true;
   IdHttp.Request.Username:=FUserId;
   IdHttp.Request.Password:=FUserPass;
 end
 else if (method=tvcsDigest) then begin
   IDHttp.Request.BasicAuthentication:=false;
   IdHttp.Request.Username:=FUserId;
   IdHttp.Request.Password:=FUserPass;
   idHttp.HTTPOptions := idHttp.HTTPOptions + [hoInProcessAuth];
   idHttp.OnAuthorization:=OnAuthRequested;


 end
 else if (method=tvcsBearer) then begin
      token:='';
      IDHttp.Request.BasicAuthentication:=false;
      IdHttp.Request.CustomHeaders.FoldLines:=false;
      IdHttp.Request.CustomHeaders.Add('Authorization:Bearer '+token);
 end
 else begin

    // error
 end;


end;

procedure TTvcsAPIBase.SetDebugMemo(memdebug: TMemo);
begin
  DebugMemo:=memdebug;
end;


procedure TTvcsAPIBase.DisplayLog(str:String);
begin
  if (DebugMemo<>nil) then begin
    if (DebugMemo.lines.Count >1000) then
       DebugMemo.Lines.Clear;

      DebugMemo.Lines.Add(str);
  end;

end;


destructor TTvcsAPIBase.Destroy;
begin

  if (idHttp<>nil) then begin
     idHttp.Free;
  end;
  if (sslIOHandler<>nil) then FreeAndNil(sslIOHandler);
  if (FURI<>nil) then FreeAndNil(FURI);


  inherited;
end;


function TTvcsAPIBase.DeleteAPI(APathURL: string;params:String):String;
var
 Response:TStringStream;
 AUrl:String;
begin
  if (params<>'') then
    AUrl:=FHostAddr+APathUrl+'?'+params
  else
    AUrl:=FHostAddr+APathUrl;
  try
    try
      Response := TStringStream.Create('', TEncoding.UTF8);
      IdHttp.Delete(AUrl,ResPonse);

    except
      Result:='';
    end;
  finally
    Result:=Response.DataString;
    FreeAndNil(Response);
  end;

end;

function TTvcsAPIBase.DeleteAPI(APathURL:String;Parameters:TJSONObject):TJsonObject;
var
  resObject:TJSONObject;
  pairs:TJSONPair;
  response:String;
  ParamStr:String;
  AUrl:String;
  idx:Integer;
begin
try
  try

   if (Parameters=nil) then
   begin
      response:=DeleteAPI(APathUrl);
   end
   else begin
     ParamStr:='';

     for  idx:= 0 to Parameters.Count-2 do begin
         pairs:=Parameters.Get(idx);
         ParamStr:=ParamStr+pairs.JsonString.ToString+'='+pairs.JsonValue.ToString+'&' ;
     end;
     pairs:=Parameters.Get(idx);
     ParamStr:=ParamStr+pairs.JsonString.ToString+'='+pairs.JsonValue.ToString;
     response:=DeleteAPI(APathUrl,ParamStr);
   end;
   Result:=TJSONObject.ParseJSONValue(response) as TJSONObject;


  except
      Result:=nil;
  end;
finally

end;
end;


function TTvcsAPIBase.PatchAPI(APathURL: string; ReqObj: TJSONObject): TJSONObject;
var
  Response: TStringStream;
  Source: TStringStream;
  AUrl: string;
  ResStr: string;
begin
  Result := nil;
  Response := nil;
  Source := nil;
  AUrl := FHostAddr + APathUrl;

  try
    try
      Response := TStringStream.Create('', TEncoding.UTF8);
      Source := TStringStream.Create(ReqObj.ToJSON, TEncoding.UTF8);

      IdHttp.Request.Accept := 'application/json';
      IdHttp.Request.ContentType := 'application/json; charset=utf-8';
      IdHttp.Request.CharSet := 'utf-8';
      IdHttp.Patch(AUrl, Source, Response);
      Response.Position := 0;  // Reset stream position
      ResStr := TEncoding.UTF8.GetString(Response.Bytes, 0, Response.Size);

      Result := TJSONObject.ParseJSONValue(ResStr) as TJSONObject;
    except
      on E: Exception do
      begin
        Result := nil;
      end;
    end;
  finally
    if Assigned(Response) then
      FreeAndNil(Response);
    if Assigned(Source) then
      FreeAndNil(Source);
  end;
end;

procedure TTvcsAPIBase.PutAPI(APathURL: string;ReqObj:TJSONObject);
var
 Response:TStringStream;
 Source:TSTringStream;
 AUrl:String;
begin
  AUrl:=FHostAddr+APathUrl;
  try
    try
      Response:=TStringStream.Create;
      Source:=TStringStream.Create(ReqObj.toJson);
      IdHttp.Put(Aurl,Source,ResPonse);
    except

    end;
  finally
    FreeAndNil(Response);
  end;
end;


function TTvcsAPIBase.GetAPI(APathURL,Parameters:String):String;
var
 errCode:Integer;
 errStr:String;
 AUrl:String;
 resStream:TStringStream;
 retJson:TJSONObject;
begin
    AUrl:=FHostAddr+APathUrl;
    if (Parameters<>'') then begin

       AUrl:=Aurl+'?'+Parameters;
    end;

    try
       try
         resStream:=TStringStream.Create('',TEncoding.UTF8);
         DisplayLog(AUrl);
         idHttp.Request.CharSet:='utf-8';
         idHttp.Get(AUrl,resStream);
       finally

         Result:=resStream.DataString;
         FResponseCode:=idHttp.ResponseCode;
         idHttp.Disconnect;
         FreeAndNil(resStream);
       end;
    except
      Result:='{}';
    end;
end;


function TTvcsAPIBase.GetAPI(APathURL:String;Parameters:TJSONObject):TJSONObject;
var
  resObject:TJSONObject;
  pairs:TJSONPair;
  response:String;
  ParamStr:String;
  AUrl:String;
  idx:Integer;
begin
try
  try
   if (Parameters=nil) then
   begin
      response:=GetAPI(APathUrl);
   end
   else begin
     ParamStr:='';

     for  idx:= 0 to Parameters.Count-2 do begin
         pairs:=Parameters.Get(idx);
         ParamStr:=ParamStr+pairs.JsonString.ToString+'='+pairs.JsonValue.ToString+'&' ;
     end;
     pairs:=Parameters.Get(idx);
     ParamStr:=ParamStr+pairs.JsonString.ToString+'='+pairs.JsonValue.ToString;
     response:=GetAPI(APathUrl,ParamStr);
   end;
  except
      Result:=nil;
  end;
finally

end;


end;


function TTvcsAPIBase.PostAPI(APathURL:String;Params:String):String;
var
 ret:TJSONObject;
 retJson:TJSONObject;
 inPutStream:TStringStream;
 resStream:TStringStream;
 resData:String;
 errCode:Integer;
 errStr:String;
 AUrl:String;

begin
  AUrl:=FHostAddr+APathUrl;
  try
    try
      inPutStream:=TStringStream.Create(Params);
      resStream:=TStringStream.Create('',TEncoding.UTF8);
      IdHTTP.Request.Accept := 'application/json';
      IdHTTP.Request.ContentType := 'application/json';
      idHttp.Request.CharSet:='utf-8';
      idHttp.Post(AUrl,inputStream,resStream);
      Result:=resStream.DataString;

    except
      Result:='{}';
    end;
  finally
     FreeAndNil(inputStream);
     FreeAndNil(resStream);
  end;
end;



function TTvcsAPIBase.PostAPI(APathURL:String;Params:TJSONObject):TJSONObject;
var
 retJson:string;
begin
   retJson:=PostAPI(APathUrl,Params.ToJson);

   if (retJson='{}') then
      Result:=nil
   else
     Result:=TJSONObject.ParseJsonValue(retJson) as TJSONObject;
end;


{
initialization
  gapi := TTVCSAPI.Create;

finalization
  if Assigned(gapi) then
    gapi.Free;
}



end.


