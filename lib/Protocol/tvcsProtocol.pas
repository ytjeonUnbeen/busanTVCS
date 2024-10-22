unit tvcsProtocol;

interface

type

  TvcsUser=class
      fuserId:string;
      ffirstName:String;
      flastName:String;
      femail:String;
      fisStaff:Integer;
      fisSuperUser:boolean;
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
  end;

  TvcsUserPatch=class
      fuserId:string;
      fpassword:string;
      ffirstName:string;
      flastName:string;
      femail:string;
      fisStaff:boolean;
  end;

  TvcsSystem=class
     fdisplayInterval:Integer;
     fresolution:String;
     fframe:Integer;
     fisEventInterval:boolean;
     feventIntervalSec:Integer;
  end;

  TvcsStation=class
    fcode:String;
    fline:Integer;
    fname:String;
    fdepartDelay:Integer;
    farriveDelay:Integer;
    fprevCode:String;
    fprevName:String;
    fnextCode:String;
    fnextName:String;
  end;


  TvcsStationInPost=class
    fcode:String;
    fline:Integer;
    fname:String;
    fdepartDelay:Integer;
    farriveDelaay:Integer;
    fprevCode:String;
    fnextCode:String;
  end;

  TVCSTrain=class
    fid:Integer;
    ftrainNo:Integer;
    fformatNo:Integer;
    fcarriageNum:Integer;
    fcameraNum:Integer;
    fmergeRtsp:String;
  end;

  TVCSTrainInPost=class
    ftrainNo:String;
    fformatNo:Integer;
    fcarriageNum:Integer;
    fcameraNum:Integer;
  end;

  TVCSTrainInPatch=class
    fid:Integer;
    ftrainNo:String;
    fformatNo:Integer;
    fcarriageNum:Integer;
    fcameraNum:Integer;
  end;

  TVCSTrainServiceIn=class
    ftrainId:Integer;
    fstationCode:String;
  end;

 TVCSTrainService=class
    ftrainId:Integer;
    ftrainNo:String;
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
    fid:string;
    ftrainId:Integer;
    fposition:Integer;
    fname:string;
    fipaddr:string;
    fport:Integer;
    frtsp:string;
    fuserId:string;
    fuserPwd:string;
  end;


  TVCSTrainCameraMerge=class
    ftrainId:Integer;
    fcameraId:Integer;
    fpostition:Integer;
    fname:String;
    fipaddr:String;
    fport:Integer;
    frtsp:String;
    ftvcsRtsp:String;
  end;

  TVCSTrainCameraMergePost=class
    ftrainId:Integer;
    fcameraId:Integer;
  end;

  TVCSTrainCameraMergePatch=class
    fid:Integer;
    ftrainId:Integer;
    fcameraId:Integer;
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






implementation

end.
