unit TVCSEvent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, PasLibVlcPlayerUnit;

type
  TfrmEvent = class(TForm)
    eventPlayer: TPasLibVlcPlayer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEvent: TfrmEvent;

implementation

{$R *.dfm}

end.
