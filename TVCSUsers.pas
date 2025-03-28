unit TVCSUsers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, AdvUtil,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, Vcl.DBCtrls, tvcsAPI, TVCSButtonStyle,tvcsProtocol, TVCSCheckDialog,
  TVCSPasswordChange, AdvGlowButton, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection, TVCSAddUser;

type
  TfrmUsers = class(TForm)
    pnMainFrame: TPanel;
    pnBottom: TPanel;
    lblTitle: TLabel;
    edSearchText: TEdit;
    lblUsersCnt: TLabel;
    grdUsers: TAdvStringGrid;
    cbSearch: TComboBox;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnClose: TAdvGlowButton;
    btnAddUser: TAdvGlowButton;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    btnSerch: TAdvGlowButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdUsersButtonClick(Sender: TObject; ACol, ARow: Integer);
    procedure btnAddUserClick(Sender: TObject);
    procedure btnSerchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);


  private
    { Private declarations }
    users: TArray<TvcsUser>;
    saveUsers: TArray<TvcsUserPatch>;
    Procedure LoadUsersList;
    procedure grdStationCamsHasComboBox(Sender: TObject; ACol, ARow: Integer;
  var HasComboBox: Boolean);
    procedure grdStationCamsGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
    procedure grdStationCamsGetEditorProp(Sender: TObject; ACol, ARow: Integer;
  AEditLink: TEditLink);
    
    procedure grdUsersClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure grdUsersSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);



  public
    { Public declarations }
  end;

var
  frmUsers: TfrmUsers;

implementation

{$R *.dfm}




procedure TfrmUsers.btnAddUserClick(Sender: TObject);
var
  AddUserDlg: TfrmAddUser;
begin
  AddUserDlg := TfrmAddUser.Create(nil);
  try
    AddUserDlg.Users := users;  // 현재 사용자 목록 전달
    if AddUserDlg.ShowModal = mrOk then
    begin
      LoadUsersList;  // 사용자 목록 새로고침
      ShowTVCSMessage('사용자가 추가되었습니다.');
    end;
  finally
    AddUserDlg.Free;
  end;
end;


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
  if ShowTVCSCheck(mcModify) then
    begin
      for var I := 0 to Length(saveUsers)-1 do
      begin
        //gapi.UpdateUser(saveUsers[i]);
      end;
    end;

  ModalResult:=mrOk;
end;

procedure TfrmUsers.btnSerchClick(Sender: TObject);
var
  searchText: string;
  searchMode: integer;
  i: integer;
  found: boolean;
begin
  searchText := edSearchText.Text;
  if searchText = '' then Exit;

  searchMode := cbSearch.ItemIndex;
  found := false;

  for i := 1 to grdUsers.RowCount - 1 do
  begin
    case searchMode of
      0: // 전체 검색
        if  grdUsers.Cells[1,i] = searchText then  // id
        begin
          grdUsers.SelectCells(1,i,1,i);
          found := true;
          Break;
        end
        else if grdUsers.Cells[2,i] = searchText then  // 별명
        begin
          grdUsers.SelectCells(2,i,2,i);
          found := true;
          Break;
        end
        else if grdUsers.Cells[3,i] = searchText then //email
        begin
          grdUsers.SelectCells(3,i,3,i);
          found := true;
          Break;
        end;
      1: // 편성 검색
        if  grdUsers.Cells[1,i] = searchText then  // 열차번호명에서 찾은 경우
        begin
          grdUsers.SelectCells(1,i,1,i);
          found := true;
          Break;
        end;
      2: // 역사명 검색
         if grdUsers.Cells[2,i] = searchText then  // 장치구분에서 찾은 경우
        begin
          grdUsers.SelectCells(2,i,2,i);
          found := true;
          Break;
        end;
      3: // 역사명 검색
         if grdUsers.Cells[3,i] = searchText then  // 장치구분에서 찾은 경우
        begin
          grdUsers.SelectCells(3,i,3,i);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('검색 결과가 없습니다.');
end;

procedure TfrmUsers.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSerchClick(Sender);
end;

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  LoadUsersList;
  TButtonStyler.ApplyGlobalStyle(Self);
  
  lblTitle.Caption := '사용자 정보 관리 ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'호선)';
  grdUsers.OnGetEditorType := grdStationCamsGetEditorType;
  grdUsers.OnGetEditorProp := grdStationCamsGetEditorProp;
  grdUsers.OnHasComboBox := grdStationCamsHasComboBox;
  grdUsers.OnClickCell := grdUsersClickCell;  // 추가
  grdUsers.OnSelectCell := grdUsersSelectCell;  // 추가
  //grdUsers. c(1,1,20,20,'',)
  
  


end;

procedure TfrmUsers.grdStationCamsHasComboBox(Sender: TObject; ACol, ARow: Integer;
  var HasComboBox: Boolean);
begin
    if ((ACol = 4) or (ACol = 5)) and (ARow <> 0) then  // 4번과 5번 컬럼에 콤보박스 표시
      HasComboBox := True;
end;

procedure TfrmUsers.grdStationCamsGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
begin
    if (ACol = 4) or (ACol = 5) then  
      AEditor := edComboList;
end;

procedure TfrmUsers.grdStationCamsGetEditorProp(Sender: TObject; ACol, ARow: Integer;
  AEditLink: TEditLink);
begin
  if (ACol = 4) then
  begin
    with grdUsers do
    begin
      ClearComboString;
      AddComboString('관리자');
      AddComboString('운영자');
    end;
  end
  else if (ACol = 5) then
  begin
    with grdUsers do
    begin
      ClearComboString;
      AddComboString('활성');
      AddComboString('중지');
    end;
  end;
end;

procedure TfrmUsers.LoadUsersList;
var
  i : integer;
  CellGraphic : TCellGraphic;
  
begin
  with grdUsers do begin
    RowCount := 1;
    ColCount := 8;
    ColWidths[0] := 40;
    ColWidths[1] := 200;
    ColWidths[2] := 90;
    ColWidths[3] := 120;
    ColWidths[4] := 60;
    ColWidths[5] := 60;
    ColWidths[6] := 90;
    ColWidths[7] := 50;
    Cells[0,0] := 'No.';
    Cells[1,0] := 'ID';
    Cells[2,0] := '별명';
    Cells[3,0] := 'email';
    Cells[4,0] := '권한';
    Cells[5,0] := '상태';
    Cells[6,0] := '비밀번호';
    Cells[7,0] := '삭제';
  end;

  users := Gapi.GetUsers();
  SetLength(saveUsers,Length(users));
  if Length(users) > 0 then
  begin
    for i := 1 to Length(users) do
    begin
      grdUsers.AddRow;   
      grdUsers.Cells[0,i] := IntToStr(i);
      grdUsers.Cells[1,i] := users[i-1].fuserId;
      grdUsers.Cells[2,i] := users[i-1].ffirstName;
      grdUsers.Cells[3,i] := users[i-1].femail;
      
      // 권한 설정 (isStaff 값에 따라)
      case users[i-1].fisStaff of
        1: grdUsers.Cells[4,i] := '관리자';
        0: grdUsers.Cells[4,i] := '운영자';
      end;
      
       if users[i-1].fisActive then
        grdUsers.Cells[5,i] := '활성'
      else
        grdUsers.Cells[5,i] := '중지';

      //grdUsers.AddButton(6, i, 50, 20, '변경', haCenter, vaCenter);
       grdUsers.AddButton(6, i, 50, 20, '변경', haCenter, vaCenter);
       grdUsers.AddImageIdx(7, i, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
       saveUsers[i-1] := TvcsUserPatch.Create;
       saveUsers[i-1].fuserId := users[i-1].fuserId;
       saveUsers[i-1].ffirstName := users[i-1].ffirstName;
       saveUsers[i-1].flastName := users[i-1].flastName;
       saveUsers[i-1].femail := users[i-1].femail;
       if users[i-1].fisStaff = 1 then
        saveUsers[i-1].fisStaff := true
       else
        saveUsers[i-1].fisStaff := false;
       saveUsers[i-1].fisActive := users[i-1].fisActive;
       
    end;
  end;
  
  lblUsersCnt.Caption := '총: ' + IntToStr(Length(users)) + '명';
end;   



procedure TfrmUsers.grdUsersButtonClick(Sender: TObject; ACol, ARow: Integer);
var
    PasswordDlg: TfrmPasswordChange;

begin
//
  PasswordDlg := TfrmPasswordChange.Create(nil);
  if PasswordDlg.ShowModal = mrOk then
  begin
    saveUsers[ARow-1].fpassword := PasswordDlg.edNewPassword.text;
  end;
  //ShowMessage(sender.ClassName);
end;

procedure TfrmUsers.grdUsersClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow > 0 then  // 헤더 row가 아닐 경우
  begin
    if ACol = 7 then  // 삭제 컬럼
    begin
      if ShowTVCSCheck(mcDelete) then  // 확인 메시지 표시
      begin
        // 사용자 삭제 API 호출
        gapi.DeleteUser(users[ARow-1].fuserId);  // API 함수명은 실제 있는 함수로 수정 필요
        grdUsers.RemoveRows(ARow, 1);
        LoadUsersList;  // 목록 새로고침
        ShowTVCSMessage('삭제되었습니다.');
      end;
    end;
  end;
end;

procedure TfrmUsers.grdUsersSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ACol = 6 then  // 비밀번호 변경 버튼 컬럼
    CanSelect := False;  // 선택 불가능하게 설정
end;




end.
