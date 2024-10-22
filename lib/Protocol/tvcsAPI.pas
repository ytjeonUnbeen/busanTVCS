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
         function UpdateStation(stationinfo:TvcsStationInPost):TvcsStation;
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
         function DeleteTrainCameraMerge(fid:integer):string;

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
begin
  if UserId <> '' then
    UserId := 'userId=' + UserId;

  ResponseStr := FAPIBase.GetAPI(API_USER, UserId);
  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  UsersJson := ResponseJson.GetValue('reply');
  if UsersJson is TJSONArray then
  begin
    SetLength(Users, TJSONArray(UsersJson).Count);
    for I := 0 to TJSONArray(UsersJson).Count - 1 do
      Users[I] := TJSON.JsonToObject<TvcsUser>(TJSONArray(UsersJson).Items[I] as TJSONObject);
    Result := Users;
  end
  else
    Result := nil;
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
begin
  if Code <> '' then
    ParamStr := 'code=' + Code + '&line=' + IntToStr(Line)
  else
    ParamStr := 'line=' + IntToStr(Line);

  ResponseStr := FAPIBase.GetAPI(API_STATION, ParamStr);
  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJSONValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  StationsJson := ResponseJson.GetValue('reply');
  if StationsJson is TJSONArray then
  begin
    SetLength(Stations, TJSONArray(StationsJson).Count);
    for I := 0 to TJSONArray(StationsJson).Count - 1 do
      Stations[I] := TJSON.JsonToObject<TvcsStation>(TJSONArray(StationsJson).Items[I] as TJSONObject);
    Result := Stations;
  end
  else
    Result := nil;
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

function TTVCSAPI.UpdateStation(stationinfo: TvcsStationInPost):TvcsStation;
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
begin
  if trainNo <> -1 then
    ResponseStr := FAPIBase.GetAPI(API_TRAIN, 'trainNo=' + IntToStr(trainNo))
  else
  begin
    ResponseStr := FAPIBase.GetAPI(API_TRAIN);
  end;

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  TrainsJson := ResponseJson.GetValue('reply');
  if TrainsJson is TJSONArray then
  begin
    SetLength(Trains, TJSONArray(TrainsJson).Count);
    for I := 0 to TJSONArray(TrainsJson).Count - 1 do
      Trains[I] := TJSON.JsonToObject<TvcsTrain>(TJSONArray(TrainsJson).Items[I] as TJSONObject);
    Result := Trains;
  end
  else
    Result := nil;
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
begin
  if trainId <> -1 then
    ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA, 'trainId=' + IntToStr(trainId))
  else
  begin
    ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA);
  end;

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  TrainCamerasJson := ResponseJson.GetValue('reply');
  if TrainCamerasJson is TJSONArray then
  begin
    SetLength(TrainCameras, TJSONArray(TrainCamerasJson).Count);
    for I := 0 to TJSONArray(TrainCamerasJson).Count - 1 do
      TrainCameras[I] := TJSON.JsonToObject<TVCSTrainCamera>(TJSONArray(TrainCamerasJson).Items[I] as TJSONObject);
    Result := TrainCameras;
  end
  else
    Result := nil;
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
function TTVCSAPI.GetTrainCameraMerge(trainId:integer=-1):TArray<TVCSTrainCameraMerge>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  TrainCameraMergesJson: TJSONValue;
  TrainCameraMerges: TArray<TVCSTrainCameraMerge>;
  I: Integer;
begin
  if trainId <> -1 then
    ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA_MERGE, 'trainId=' + IntToStr(trainId))
  else
  begin
    ResponseStr := FAPIBase.GetAPI(API_TRAIN_CAMERA_MERGE);
  end;

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  TrainCameraMergesJson := ResponseJson.GetValue('reply');
  if TrainCameraMergesJson is TJSONArray then
  begin
    SetLength(TrainCameraMerges, TJSONArray(TrainCameraMergesJson).Count);
    for I := 0 to TJSONArray(TrainCameraMergesJson).Count - 1 do
      TrainCameraMerges[I] := TJSON.JsonToObject<TVCSTrainCameraMerge>(TJSONArray(TrainCameraMergesJson).Items[I] as TJSONObject);
    Result := TrainCameraMerges;
  end
  else
    Result := nil;
end;

function TTVCSAPI.AddTrainCameraMerge(trainCameraMergeInfo:TVCSTrainCameraMergePost):TVCSTrainCameraMerge;
var
  RequestJson, ResponseJson: TJSONObject;
  TrainCamerasMergeJson: TJSONValue;
  ResultTrainCameraMerge: TVCSTrainCameraMerge;
  ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(trainCameraMergeInfo);
  try
    ResponseJson := FAPIBase.PostAPI(API_TRAIN_CAMERA_MERGE, RequestJson);
    try
      if CheckError(ResponseJson, ErrorMsg) <> 0 then
      begin
        ShowMessage(FErrorMsg);
        Exit(nil);
      end;

      TrainCamerasMergeJson := ResponseJson.GetValue('reply');
      ResultTrainCameraMerge := TJson.JsonToObject<TVCSTrainCameraMerge>(TrainCamerasMergeJson.ToString);
      Result := ResultTrainCameraMerge;
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
 ResulttTainCameraMerge: TVCSTrainCameraMerge;
 ErrorMsg: string;
begin
  RequestJson := TJson.ObjectToJsonObject(trainCameraMergeInfo);

  try
    ResponseJson := FAPIBase.PatchAPI(API_TRAIN_CAMERA_MERGE, RequestJson);

    try
    if CheckError(ResponseJson, ErrorMsg)<> 0 then
    begin
      ShowMessage(FErrorMsg);
      Exit(nil);
    end;

    trainCameraMergeJson := ResponseJson.GetValue('reply');
    ResulttTainCameraMerge := TJSON.JsonToObject<TVCSTrainCameraMerge>(trainCameraMergeJson.ToString);
    Result := ResulttTainCameraMerge;

    finally
    ResponseJson.Free;

    end;
  finally
    RequestJson.Free;
  end;
end;

function TTVCSAPI.DeleteTrainCameraMerge(fid:integer):string;
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

//license
function TTVCSAPI.GetLicense():TArray<TVCSLicense>;
var
  ResponseStr, ErrorMsg: string;
  ResponseJson: TJSONObject;
  LicenseJson: TJSONValue;
  Licenses: TArray<TVCSLicense>;
  I: Integer;
begin

  ResponseStr := FAPIBase.GetAPI(API_LICENSE);

  FResponseText := FAPIBase.ResponseText;
  FResponseCode := FAPIBase.ResponseCode;
  ResponseJson := TJSONObject.ParseJsonValue(ResponseStr) as TJSONObject;

  if CheckError(ResponseJson, ErrorMsg) <> 0 then
    Exit(nil);

  LicenseJson := ResponseJson.GetValue('reply');
  if LicenseJson is TJSONArray then
  begin
    SetLength(Licenses, TJSONArray(LicenseJson).Count);
    for I := 0 to TJSONArray(LicenseJson).Count - 1 do
      Licenses[I] := TJSON.JsonToObject<TVCSLicense>(TJSONArray(LicenseJson).Items[I] as TJSONObject);
    Result := Licenses;
  end
  else
    Result := nil;
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


