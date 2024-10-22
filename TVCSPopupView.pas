unit TVCSPopupView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmPopupView = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    btnCancel: TButton;
    btnAgree: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPopupView: TfrmPopupView;

implementation

{$R *.dfm}

end.
