unit TVCSPopupView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  PasLibVlcPlayerUnit,PasLibVlcClassUnit;

type
  TfrmPopupView = class(TForm)
    Panel1: TPanel;
    SinglePlayer: TPasLibVlcPlayer;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
  private
    FRTSPUrl:String;
    FRTSPUser:String;
    FRTSPPass:String;
    FmediaOptions:array [0..1] of WideString;
  public
     procedure PlayView;
  published
    property RTSPUrl:String Read FRTSPUrl Write FRTSPUrl;
    property RTSPUser:String Read FRTSPUser Write FRTSPUser;
    property RTSPPass:String Read FRTSPPass Write FRTSPPass;   { Public declarations }
  end;

var
  frmPopupView: TfrmPopupView;

implementation

{$R *.dfm}

procedure TfrmPopupView.FormShow(Sender: TObject);
begin
Application.ProcessMessages;
end;

procedure TfrmPopupView.PlayView;
begin
  // FRTSPUser:='admin';
   FmediaOptions[0]:='rtsp-user='+FRTSPUser;
   FmediaOptions[1]:='rtsp-pwd='+FRTSPPass;
   SinglePlayer.VideoOutput:=voDirectX;
   SinglePlayer.SetAudioMute(true);
   Panel1.Caption:=RTSPUrl;
   //label1.Caption:= FRTSPUser;
   //label2.Caption:=FRTSPPass;
   SinglePlayer.Play(RTSPUrl,FMediaOptions);


end;

end.
