unit TVCSPreview;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PasLibVlcPlayerUnit, PasLibVlcClassUnit,
  Vcl.ExtCtrls, Vcl.StdCtrls, AdvMetroButton, AdvGlassButton;
type
  TCamView = class(TPasLibVlcPlayer)
    private
      bAllocated: Boolean;
      FRTSPUrl: String;
      FRTSPID: String;
      FRTSPPass: String;
      FmediaOptions: array [0..1] of WideString;
      procedure SetId(id: String);
      procedure SetPassword(pass: String);
    public
      pos: Integer;
      constructor Create(Owner: TComponent); override;
      destructor Destroy; override;
      procedure PlayView;
      procedure StopView;
    published
      property Allocated: Boolean read bAllocated write bAllocated;
      property RtspUrl: String read FRTSPUrl write FRTSPUrl;
      property RtspUser: String read FRtspID write SetId;
      property RtspPass: String read FRtspPass write SetPassword;
  end;

  TfrmPreview = class(TForm)
    pnlPreview: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    preview: TCamView;
    FURL: string;
    FID: string;
    FPassword: string;
    procedure InitializePreview;
  public
    procedure StartPreview;
    procedure StopPreview;
    procedure SetRtspUrl(const URL: string);
    procedure SetRtspID(const ID: string);
    procedure SetRtspPw(const Password: string);
  end;

var
  frmPreview: TfrmPreview;

const
  DEFAULT_RTSP_URL = 'rtsp://192.168.1.96:8554/merge/merge1';
  DEFAULT_USERNAME = 'admin';
  DEFAULT_PASSWORD = 'Admin12#$';

implementation

{$R *.dfm}


constructor TCamView.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  bAllocated := False;
end;
destructor TCamView.Destroy;
begin
  StopView;
  inherited Destroy;
end;
procedure TCamView.SetId(id: String);
begin
  FmediaOptions[0] := 'rtsp-user=' + id;
  FRTSPID := id;
end;
procedure TCamView.SetPassword(pass: String);
begin
  FmediaOptions[1] := 'rtsp-pwd=' + pass;
  FRTSPPass := pass;
end;

procedure TCamView.PlayView;
begin
  if not bAllocated then
  begin
    Play(RtspUrl, FMediaOptions);
    VideoOutput := voDirectX;
    AlignWithMargins := True;
    Margins.Left := 10;
    Margins.Top := 10;
    Margins.Right := 10;
    Margins.Bottom := 10;
    SetAudioMute(True);
    bAllocated := True;
  end;
end;

procedure TCamView.StopView;
begin
  if bAllocated then
  begin
    Stop;
    bAllocated := False;
  end;
end;

procedure TfrmPreview.FormCreate(Sender: TObject);
begin
  InitializePreview;
end;

procedure TfrmPreview.InitializePreview;
begin
  preview := TCamView.Create(pnlPreview);
  with preview do
  begin
    Parent := pnlPreview;
    Align := alClient;
    Left := 0;
    Top := 0;
    Width := pnlPreview.Width;
    Height := pnlPreview.Height;
  end;
end;

procedure TfrmPreview.SetRtspUrl(const URL: string);
begin
  FURL := URL;
  if Assigned(preview) then
    preview.RtspUrl := URL;
end;

procedure TfrmPreview.SetRtspID(const ID: string);
begin
  FID := ID;
  if Assigned(preview) then
    preview.RtspUser := ID;
end;

procedure TfrmPreview.SetRtspPw(const Password: string);
begin
  FPassword := Password;
  if Assigned(preview) then
    preview.RtspPass := Password;
end;

procedure TfrmPreview.StartPreview;
begin
  if Assigned(preview) then
  begin
    if FURL <> '' then preview.RtspUrl := FURL;
    if FID <> '' then preview.RtspUser := FID;
    if FPassword <> '' then preview.RtspPass := FPassword;

    preview.PlayView;
  end;
end;

procedure TfrmPreview.StopPreview;
begin
  if Assigned(preview) then
    preview.StopView;
end;

procedure TfrmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopPreview;
end;

procedure TfrmPreview.FormDestroy(Sender: TObject);
begin
  if Assigned(preview) then
    FreeAndNil(preview);
end;

end.
