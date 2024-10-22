unit TVCSAutoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TVCSMulView;

type
  TfrmAutoView = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }


  public
    { Public declarations }
  end;

var
  frmAutoView: TfrmAutoView;
  mv: TVCSMulViewMain;

implementation

{$R *.dfm}

procedure TfrmAutoView.FormCreate(Sender: TObject);
begin
  mv.Create(self);
  mv.Align := alClient;

end;

end.
