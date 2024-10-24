program TVCSClient;



uses
  Vcl.Forms,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Registry,
  Vcl.Dialogs,
  TVCSClientLogin in 'TVCSClientLogin.pas' {frmLogin},
  Vcl.Themes,
  Vcl.Styles,
  TVCSPopupView in 'TVCSPopupView.pas' {frmPopupView},
  TVCSEvent in 'TVCSEvent.pas' {frmEvent},
  TVCSStation in 'TVCSStation.pas' {frmStation},
  TVCSTrain in 'TVCSTrain.pas' {frmTrain},
  TVCSViewControl in 'TVCSViewControl.pas' {frmViewControl},
  TVCSDevices in 'TVCSDevices.pas' {frmDevices},
  TVCSSystemSet in 'TVCSSystemSet.pas' {frmSystem},
  TVCSUsers in 'TVCSUsers.pas' {frmUsers},
  TVCSAutoView in 'TVCSAutoView.pas' {frmAutoView},
  TVCSLayouts in 'TVCSLayouts.pas' {frmLayouts},
  TVCSCheckSave in 'TVCSCheckSave.pas' {frmCheckSave},
  tvcsAPI in 'lib\Protocol\tvcsAPI.pas',
  tvcsProtocol in 'lib\Protocol\tvcsProtocol.pas',
  TVCSMainFrm in 'TVCSMainFrm.pas' {frmTVCSMain},
  CustomPageControl in 'CustomPageControl.pas',
  TVCSMulView in 'TVCSMulView.pas',
  TVCSCheckDelete in 'TVCSCheckDelete.pas' {frmCheckDelete},
  TVCSCheckDialog in 'TVCSCheckDialog.pas';

{$R *.res}
var
 Registry:TRegIniFile;
 iSelect:Integer;
 frmLogin:TfrmLogin;
 const PrgKey='Software\TVCSClient\Settings';

begin
  Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Registry := TRegIniFile.Create(KEY_READ);
  try
            //Application.CreateForm(TfrmRBTLogin, frmRBTLogin);
   //  Application.CreateForm(TfrmLogin, frmLogin);
     frmLogin:=TfrmLogin.Create(Application);
     frmLogin.ShowModal;
     if (frmLogin.isLogged) then
             Application.CreateForm(TfrmTVCSMain, frmTVCSMain);

  FreeAndNil(frmLogin);


  Application.Run;
//  FreeAndNil(frmTVCSMain);


    Registry.CloseKey;
  finally
    Registry.Free;
  end;



end.
