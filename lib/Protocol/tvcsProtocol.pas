unit tvcsProtocol;

interface
//13
type

  TvcsUser=class
      ffirstName:String;
      flastName:String;
      femail:String;
      fisStaff:Integer;
      fisSuperUser:boolean;
      fActive:boolean;
      flastLogin:String;
      fdateJoined:String;
      fversion:String;
  end;

  TvcsUserIn=class
      fuserId:String;
      fpassword:String;
      ffirstName:String;
      flastName:String;
      femail:String;
      fisStaff:Boolean;
      fisActive:Boolean;
  end;

  TvcsUserPatch=class
      fuserId:string;
      fpassword:string;
      ffirstName:string;
      flastName:string;
      femail:string;
      fisStaff:boolean;
      fisActive:boolean;
  end;

  TvcsSystem=class
     fdisplayInterval:Integer;
     fresolution:String;
     fframe:Integer;
     fisEventInterval:boolean;
     feventIntervalSec:Integer;
     fline:Integer;
  end;

  TvcsSystemPatch=class
      fdisplayInterval:Integer;
      fresolution:String;
      fframe:Integer;
      fisEventInterval:boolean;
      feventIntervalSec:Integer;
  end;

  TvcsStation=class
    fcode:String;
    //fline:Integer;
    fname:String;
    fdepartDelay:Integer;
    farriveDelay:Integer;
    fprevCode:String;
    fprevName:String;
    fnextCode:String;
    fnextName:String;
    ftvcsIpaddr:string;
  end;


  TvcsStationInPost=class
    fcode:String;
    fname:String;
    fdepartDelay:Integer;
    farriveDelaay:Integer;
    fprevCode:String;
    fnextCode:String;
    ftvcsIpaddr:string;
    //fline:Integer;
  end;

  TVCSTrain=class
    fid:Integer;
    ftrainNo:Integer;
    fformatNo:Integer;
    fcarriageNum:Integer;
    fcameraNum:Integer;
    ftvcsIpaddr:String;
    //fmergeRtsp:String;
    //fline:Integer;
  end;

  TVCSTrainInPost=class
    ftrainNo:Integer;
    fformatNo:Integer;
    fcarriageNum:Integer;
    fcameraNum:Integer;
    ftvcsIpaddr:string;
    //ftrainId:Integer;
    //fline:Integer;
  end;

  TVCSTrainInPatch=class
    fid:Integer;
    ftrainNo:Integer;
    fformatNo:Integer;
    fcarriageNum:Integer;
    fcameraNum:Integer;
    ftvcsIpaddr:string;
    //fline:Integer;
  end;

  TVCSTrainServiceIn=class
    ftrainId:Integer;
    fstationCode:String;
  end;

 TVCSTrainService=class
    ftrainId:Integer;
    ftrainNo:Integer;
    fformatNo:Integer;
    fstationCode:String;
    fstationName:String;
    fprevStationCode:String;
    fprevStationName:String;
    fnextStationCode:String;
    fnextStationName:String;
    fStatus:Integer;
    fdistance:Integer;
    ftcms:Tobject;
  end;


  //Station Camera
  TVCSStationCamera=class
    fid:Integer;
    fstationCode:String;
    fdivision:Integer;
    fname:String;
    fipaddr:String;
    fport:Integer;
    frtsp:String;
    ftvcsRtsp:String;
    fuserId:String;
    fuserPwd:String;
    fresource:Tobject;
  end;

  TVCSStationCameraPost=class
    fstationCode:String;
    fdivision:Integer;
    fname:String;
    fipaddr:String;
    fport:Integer;
    frtsp:String;
    fuserId:String;
    fuserPwd:String;
  end;

  TVCSStationCameraPatch=class
    fid:Integer;
    fstationCode:String;
    fdivision:Integer;
    fname:String;
    fipaddr:String;
    fport:Integer;
    frtsp:String;
    fuserId:String;
    fuserPwd:String;
  end;


  // TrainCamera
  TVCSTrainCamera=class
    fid:Integer;
    ftrainId:Integer;
    fpostition:Integer;
    fname:String;
    fipaddr:String;
    fport:Integer;
    frtsp:String;
    ftvcsRtsp:string;
    fuserId:string;
    fuserPwd:string;
    fresource:Tobject;
  end;

  TVCSTrainCameraInPost=class
    ftrainId:Integer;
    fposition:Integer;
    fname:string;
    fipaddr:string;
    fport:Integer;
    frtsp:string;
    fuserId:string;
    fuserPwd:string;
  end;

  TVCSTrainCameraInPatch=class
    fid:Integer;
    ftrainId:Integer;
    fposition:Integer;
    fname:string;
    fipaddr:string;
    fport:Integer;
    frtsp:string;
    fuserId:string;
    fuserPwd:string;
  end;

  fmergeCamInfo = class
    fid: Integer;
    ftrainId: Integer;
    fcameraid: Integer;
    fposition: Integer;
    fname: String;
    fipaddr: string;
    fport: Integer;
    frtsp : String;
    ftvcsRtsp: String;
    fpositionX: Integer;
    fpositionY: Integer;
  end;


  TVCSTrainCameraMerge=class
    fname: String;
    ftvcsRtsp: String;
    fwidth : Integer;
    fheight: Integer;
    fitem: array of fmergeCamInfo;
  end;

  TVCSTrainCameraMergePost=class
    ftrainId:Integer;
    fname:string;
    fcameraId:Integer;
    fpositionX:Integer;
    fpositionY:Integer;
  end;

  TVCSTrainCameraMergePatch=class
    fid:Integer;
    ftrainId:Integer;
    fname:string;
    fcameraId:Integer;
    fpositionX:Integer;
    fpositionY:Integer;
  end;

  TVCSCameraLicense=class
    fcameraNum:Integer;
    flicenseKey:String;
    fisConfirm:Boolean;
  end;

  TVCSClientLicense=class
    fclientNum:Integer;
    flicenseKey:String;
    fisConfirm:Boolean;
  end;

  TVCSLicensePost=class
    fcameraLicenseLey:string;
    fclientLicenseLey:string;
  end;

  TVCSLicense=class
    fcameraLicense:array of TVCSCameraLicense;
    fclientLicense:array of TVCSClientLicense;
  end;

  TVCSLogin=class
    ffirstName:String;
    flastName:String;
    femail:String;
    fisStaff:Boolean;
    fisSuperuser:Boolean;
    flastLogin:String;
    fdateJoined:String;
    fversion:String;
    fsystem:TVCSSystem;
    fcameraLicense:array of TVCSCameraLicense;
    fclientLicense:array of TVCSClientLicense;
  end;

  TVCSApilist=class
    fname:string;
    fmethod:string;
    furi:string;
    finJson:TObject;
  end;

  TCMSData=class
    ftrainNo: string;
    fformatNo: Integer;
    fopCode: string;
    ftrainDir: string;
    fstationCode: string;
    fstationName: string;
    fprevStationCode: string;
    fprevStationName: string;
    fnextStationCode: string;
    fnextStationName: string;
    ffireWarning: boolean;
    ffirebreak: boolean;
    finterphone1: boolean;
    finterphone2: boolean;
  end;






implementation

end.


