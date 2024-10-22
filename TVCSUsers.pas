unit TVCSUsers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, AdvUtil,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, Vcl.DBCtrls;

type
  TfrmUsers = class(TForm)
    pnMainFrame: TPanel;
    pnBottom: TPanel;
    lblUsersTitle: TLabel;
    lblSubLine: TLabel;
    cbxSearch: TDBComboBox;
    edtSerch: TEdit;
    btnSerch: TButton;
    lblUsersCnt: TLabel;
    grdUsers: TAdvStringGrid;
    Button1: TButton;
    btnDlgClose: TButton;
    btnCancel: TButton;
    btnSave: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);


  private
    { Private declarations }
    Procedure LoadUsersList;
  public
    { Public declarations }
  end;

var
  frmUsers: TfrmUsers;

implementation

{$R *.dfm}




procedure TfrmUsers.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;

end;

procedure TfrmUsers.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmUsers.btnSaveClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  LoadUsersList;

end;


procedure TfrmUsers.LoadUsersList;
begin
     with grdUsers do begin
        RowCount:=1;
        ColCount:=8;
        ColWidths[0]:=40;
        ColWidths[1]:=200;
        ColWidths[2]:=90;
        ColWidths[3]:=120;
        ColWidths[4]:=60;
        ColWidths[5]:=60;
        ColWidths[6]:=90;
        ColWidths[7]:=50;

        Cells[0,0]:='No.';
        Cells[1,0]:='ID';
        Cells[2,0]:='별명';
        Cells[3,0]:='email';
        Cells[4,0]:='권한';
        Cells[5,0]:='상태';
        Cells[6,0]:='비밀번호';
        Cells[7,0]:='삭제';



   end;


end;

end.
