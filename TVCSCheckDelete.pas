unit TVCSCheckDelete;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvSmoothMessageDialog;

type
  TfrmCheckDelete = class(TForm)
    md: TAdvSmoothMessageDialog;
    procedure FormCreate(Sender: TObject);
    //function ShowDeleteDialog: Integer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCheckDelete: TfrmCheckDelete;

implementation

{$R *.dfm}

procedure TfrmCheckDelete.FormCreate(Sender: TObject);
begin
  md := TAdvSmoothMessageDialog.Create(Self);
  //md.Caption := '정말 삭제하시겠습니까?';

  with md.Buttons.Add do
  begin
    Caption := '삭제';
    ButtonResult := mrYes;
    //Position := poMainFormCenter



  end;
  with md.Buttons.Add do
  begin
    Caption := '취소';
    ButtonResult := mrNo;
  end;
  md.HTMLText.Text := '정말 삭제하시겠습니까?';
  //md.HTMLText.Location := hlCenterCenter;




  //md.Execute;
end;


end.
