unit TVCSMulView;

interface

uses
Vcl.ExtCtrls, PasLibVlcPlayerUnit, vcl.Forms;

type
  TCamView=class(TPasLibVlcPlayer)

    private
     // FPlayer: TPasLibVlcPlayer;
      bAllocated:Boolean;
      FRTSPUrl:String;
      FRTSPID:String;
      FRTSPPass:String;
      FmediaOptions:array [0..1] of WideString;
      //procedure SetId(id:String);
      //procedure SetPassword(pass:String);
    public
       pos:Integer;
       //constructor Create(Owner:TComponent);override;
       //destructor Destroy;override;
       //procedure PlayView;
       //procedure StopView;
     published
      property Allocated:Boolean read bAllocated write bAllocated;
      property RtspUrl:String  read FRTSPUrl write FRTSPUrl;
    //  property Player:TPasLibVlcPlayer  read FPlayer write FPlayer;
    //  property RtspUser:String  read FRtspID write SetId;
    //  property RtspPass:String  read FRtspPass write SetPassword;

  end;

  TVCSMulViewMain = class(TForm)
    pnMainView: TPanel;


  end;









implementation

end.
