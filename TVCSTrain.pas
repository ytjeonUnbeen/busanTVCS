unit TVCSTrain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,StrUtils,
  TvcsApi, tvcsProtocol, TVCSButtonStyle, TVCSPreview, System.ImageList, Vcl.ImgList, TVCSCheckDialog,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  tmsAdvGridExcel, System.Generics.Collections, Vcl.Mask, AdvEdit, AdvIPEdit,
  AdvCombo, AdvToolTip;

type
  TfrmTrain = class(TForm)
    pnBottom: TPanel;
    btnCancel: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    pnMainFrame: TPanel;
    lblInfoTitle: TLabel;
    lblTitle: TLabel;
    lblTotal: TLabel;
    pnTrainCameraInfo: TPanel;
    pnDefTrains: TPanel;
    lbscNo: TLabel;
    lblTrainNo: TLabel;
    edscNo: TEdit;
    edTrainNo: TEdit;
    pnNvrRTSP: TPanel;
    lblNvrRTSP: TLabel;
    pnCamInfos: TPanel;
    lblCamInfo: TLabel;
    lblCamCnt: TLabel;
    btnAddCams: TAdvGlowButton;
    grdTrains: TAdvStringGrid;
    btnAddTrain: TAdvGlowButton;
    btnDownloadTrainCameras: TAdvGlowButton;
    btnUploadTrainCameras: TAdvGlowButton;
    grdTrainCams: TAdvStringGrid;
    lblTrainCnt: TLabel;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    AdvGridExcelIO1: TAdvGridExcelIO;
    cbSearch: TComboBox;
    edSearchText: TEdit;
    btnSearch: TAdvGlowButton;
    edNvrRTSP: TAdvIPEdit;
    cmbTrainCnt: TAdvComboBox;
    ValidTooltip: TAdvToolTip;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);




    procedure FormCreate(Sender: TObject);
    procedure btnAddTrainClick(Sender: TObject);
    procedure grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);

    procedure btnAddCamsClick(Sender: TObject);
    procedure grdTrainCamsClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure btnUploadTrainCamerasClick(Sender: TObject);
    procedure btnDownloadTrainCamerasClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure edscNoExit(Sender: TObject);
    procedure edTrainNoExit(Sender: TObject);
    procedure edscNoEnter(Sender: TObject);
    procedure edTrainNoEnter(Sender: TObject);
    procedure edNvrRTSPEnter(Sender: TObject);
    procedure edNvrRTSPExit(Sender: TObject);
    procedure grdTrainsCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure grdTrainsEditChange(Sender: TObject; ACol, ARow: Integer;
      Value: string);
    procedure grdTrainsEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure grdTrainCamsGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdTrainCamsIsPasswordCell(Sender: TObject; ARow, ACol: Integer;
      var IsPassword: Boolean);
    procedure grdTrainsSelectCell(Sender: TObject; ACol, ARow: LongInt;
      var CanSelect: Boolean);


  private
    { Private declarations }
    isNeedUpdate:Boolean;
    GridBuf: TAdvStringGrid;
    BufTrainCams: TArray<TVCSTrainCamera>;
    trains: TArray<tvcsProtocol.TVCSTrain>;
    trainCams: TArray<TVCSTrainCamera>;
    SelTrain: tvcsProtocol.TVCSTrain;

    // ���� private,public ���� �ƴѿ����� ������ form  �̺�Ʈ�� ���� ������
    procedure LoadTrainList(trainNo: string='');
    procedure SetTrainCamListHeader;
    procedure LoadTrainCamList(trainId: Integer =-1);

    procedure AddTrainsList;
    procedure UpdateTrainList(camCount:Integer);

    function Validator:Boolean;

  public
    { Public declarations }
  end;

var
  frmTrain: TfrmTrain;

implementation

{$R *.dfm}
uses TVCSIPcMsg;

procedure TfrmTrain.btnAddCamsClick(Sender: TObject);
begin

  if (grdTrains.Cells[8,1]='new') then    begin

   if (ShowTVCSCheck('��������','�űԷ� �߰��� �����Դϴ�.'#13#10'������ �����ұ��?')) then begin

       AddTrainsList;
       grdTrains.Cells[8,1]:='old';
   end
   else Exit;

  end;



  with grdTrainCams do
  begin
    InsertChildRow(0);
    Cells[0,1] := edTrainNo.Text;
    Cells[1,1] := '10';  // position�� �⺻�� ����
    Cells[2,1] := '';
    Cells[3,1] := '';
    Cells[4,1] := '80';
    Cells[5,1] := '';
    Cells[6,1] := '';
    Cells[7,1] := '';
    Cells[8,1] := '';
    AddImageIdx(9, 1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
    AddImageIdx(10, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
  end;
end;

procedure TfrmTrain.btnAddTrainClick(Sender: TObject);
begin

  if (grdTrains.Cells[8,1]='new') then Exit;

  with grdTrains do
  begin
    InsertRows(1,1);
    Cells[0,1] := '0';
    Cells[1,1] := '';
    Cells[2,1] := '';
    AddImageIdx(3, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
//    SelectCells(0,grdTrains.RowCount,0,grdTrains.RowCount);
//    FocusCell(1,1);
    Cells[4,1]:='-1';
    Cells[5,1]:=IntToStr(defTrainCarridgeCount);
    Cells[6,1]:='ī�޶��̸�';
    Cells[7,1]:='0.0.0.0';
    Cells[8,1]:='new'; // new flag

  end;

  edscNo.Enabled := true;
  cmbTrainCnt.Enabled := true;
  edTrainNo.Enabled := true;
  edNvrRTSP.Enabled := true;
  btnAddCams.Enabled := true;

  edscNo.Text := '';
  edTrainNo.Text := '';
  edNvrRTSP.IPAddress := '0.0.0.0';
  grdTRains.SelectRows(1,1);
  edscNo.SetFocus;
  LoadTrainCamList(-1);

end;

procedure TfrmTrain.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmTrain.btnDlgCloseClick(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;


function TfrmTrain.Validator: Boolean;
begin
  Result:=True;
   if (edscNo.Text = '') then
    begin
      ShowValidator(edscNo,'������ȣ�� �Է�',ValidTooltip);
        Result:=false;
    end;
    if (edTrainNo.Text = '') then
    begin
          ShowValidator(edTrainNo,'������ȣ�� �Է�',ValidTooltip);
          Result:=false;
    end;
    if (cmbTrainCnt.Text = '') then
    begin
      ShowValidator(edTrainNo,'��������  �Է�',ValidTooltip);
      Result:=false;
    end;
    if (edNvrRTSP.IPAddress = '0.0.0.0') then
    begin
      ShowValidator(edNvrRTSP,'TVCS �ּ� �Է�',ValidTooltip);
      Result:=false;
    end;


end;

procedure TfrmTrain.btnSaveClick(Sender: TObject);
var

  trainCamPos: TArray<TVCSTrainCameraInPost>;
  trainCamPatch: TVCSTrainCameraInPatch;
  trainCamRes: TVCSTrainCamera;
  allSuccess, isModified: Boolean;
  existingTrains: TArray<tvcsProtocol.TVCSTrain>;
  existingCams: TArray<TVCSTrainCamera>;
  i, j, size: integer;
  trainIdMap: TDictionary<String, Integer>;
begin
  if ShowTVCSCheck(mcModify) then
  begin

     if (not Validator) then Exit;

    size := grdTrainCams.RowCount - 1;


    try

        SetLength(trainCamPos, size);

        for i := 1 to size do
        begin
          trainCamPos[i-1] := TVCSTrainCameraInPost.Create;
          with trainCamPos[i-1] do
          begin
            ftrainNo := edTrainNo.Text;
            fposition := StrToInt(grdTrainCams.Cells[1,i]);  // ��ġ ���� �߰�
            fname := grdTrainCams.Cells[2,i];
            fipaddr := grdTrainCams.Cells[3,i];
            fport := StrToInt(grdTrainCams.Cells[4,i]);
            frtsp := grdTrainCams.Cells[5,i];
            frtsp2 := grdTrainCams.Cells[6,i];
            fuserId := grdTrainCams.Cells[7,i];
            fuserPwd := grdTrainCams.Cells[8,i];
          end;
        end;

        try
          for i := 0 to Length(trainCamPos) - 1 do
          begin
            trainCamRes := gapi.AddTrainCamera(trainCamPos[i]);
            if trainCamRes = nil then
            begin
              allSuccess := False;
              Break;
            end;
          end;
        finally
          // ������ ī�޶� ��ü�� ����
          for i := 0 to Length(trainCamPos) - 1 do
          begin
            if Assigned(trainCamPos[i]) then
              FreeAndNil(trainCamPos[i]);
          end;
        end;



        for i := 1 to grdTrainCams.RowCount - 1 do
        begin
          isModified := False;


          j := 0;
          if (j >= 0) and (j < Length(trainCams)) then
          begin
            trainCamPatch := TVCSTrainCameraInPatch.Create;
            try
              trainCamPatch.fid := trainCams[j].fid;
              trainCamPatch.ftrainId := SelTrain.fid;
              trainCamPatch.fposition := StrToInt(grdTrainCams.Cells[1,i]);  // ��ġ ���� �߰�
              trainCamPatch.fname := grdTrainCams.Cells[2,i];
              trainCamPatch.fipaddr := grdTrainCams.Cells[3,i];
              trainCamPatch.fport := StrToInt(grdTrainCams.Cells[4,i]);
              trainCamPatch.frtsp := grdTrainCams.Cells[5,i];
              trainCamPatch.frtsp2 := grdTrainCams.Cells[6,i];
              trainCamPatch.fuserId := grdTrainCams.Cells[7,i];
              trainCamPatch.fuserPwd := grdTrainCams.Cells[8,i];

              if nil = gapi.UpdateTrainCamera(trainCamPatch) then
                allSuccess := False;
            finally
              FreeAndNil(trainCamPatch);
            end;
          end;
        end;

         ShowTVCSMessage('ó���� �Ϸ�Ǿ����ϴ�.');
         LoadTrainList;
         IpcMsgSend('LOADTRAIN');

      finally

      end;


  end;


  //ModalResult:=mrOk;
end;




procedure TfrmTrain.btnSearchClick(Sender: TObject);
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

  for i := 1 to grdTrains.RowCount - 1 do
  begin
    case searchMode of
      0: // ��ü �˻�
        if  grdTrains.Cells[1,i] = searchText then  // ��������� ã�� ���
        begin
          grdTrains.SelectCells(1,i,1,i);
          grdTrainsClickCell(grdTrains, i, 1);
          found := true;
          Break;
        end
        else if grdTrains.Cells[2,i] = searchText then  // ���������� ã�� ���
        begin
          grdTrains.SelectCells(2,i,2,i);
          grdTrainsClickCell(grdTrains, i, 2);
          found := true;
          Break;
        end;
      1: // ���� �˻�
        if grdTrains.Cells[1,i] = searchText then  // ��������� ã�� ���
        begin
          grdTrains.SelectCells(1,i,1,i);
          grdTrainsClickCell(grdTrains, i, 1);
          found := true;
          Break;
        end;
      2: // ���� ��ȣ �˻�
         if grdTrains.Cells[2,i] = searchText then
        begin
          grdTrains.SelectCells(2,i,2,i);
          grdTrainsClickCell(grdTrains, i, 2);
          found := true;
          Break;
        end;
      3: // ���� ��ȣ �˻�
         if grdTrains.Cells[3,i] = searchText then
        begin
          grdTrains.SelectCells(3,i,3,i);
          grdTrainsClickCell(grdTrains, i, 3);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('�˻� ����� �����ϴ�.');
end;

procedure TfrmTrain.btnDownloadTrainCamerasClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExcelGrid: TAdvStringGrid;
  i, j, currentRow: Integer;
  train: tvcsProtocol.TVCSTrain;
  trainCameras: TArray<TVCSTrainCamera>;
begin
  SaveDialog := TSaveDialog.Create(nil);
  ExcelGrid := TAdvStringGrid.Create(nil);
  try
    SaveDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel (*.xls)|*.xls';
    SaveDialog.DefaultExt := 'xls';
    SaveDialog.FilterIndex := 2;
    if SaveDialog.Execute then
    begin
      // ���� �׸��� �ʱ� ����

      with ExcelGrid do
      begin
        ColCount := 14;  // ��ü �÷� ��
        RowCount := 1;   // ��� row
        // ��� ����
        Cells[1,1] := '������ȣ';
        Cells[2,1] := '������ȣ';
        Cells[3,1] := '������';
        Cells[4,1] := 'ī�޶��';
        Cells[5,1] := 'TVCSIP';
        Cells[6,1] := '��ġ��ġ';
        Cells[7,1] := 'ī�޶��̸�';
        Cells[8,1] := 'ī�޶�ip�ּ�';
        Cells[9,1] := '��Ʈ��ȣ';
        Cells[10,1] := 'RTSP�ּ�(main)';
        Cells[11,1] := 'RTSP�ּ�(sub)';
        Cells[12,1] := 'ī�޶�ID';
        Cells[13,1] := 'ī�޶�PW';
      end;
      currentRow := 2;
      // �� �������� ó��
      for i := 0 to Length(trains) - 1 do
      begin
        train := trains[i];
        // �ش� ������ ī�޶� ���� ��������
        trainCameras := gapi.GetTrainCamera(train.fid);

        // ī�޶� 0���� ��쿡�� ���� ������ �� �� �߰�
        if Length(trainCameras) = 0 then
        begin
          ExcelGrid.RowCount := currentRow + 1;
          // ���� ������ �Է�
          ExcelGrid.Cells[1,currentRow] := IntToStr(train.fformatNo);
          ExcelGrid.Cells[2,currentRow] := train.ftrainNo;
          ExcelGrid.Cells[3,currentRow] := IntToStr(train.fcarriageNum);
          ExcelGrid.Cells[4,currentRow] := IntToStr(train.fcameraNum);
          ExcelGrid.Cells[5,currentRow] := train.ftvcsIpaddr;
          // ī�޶� ������ �����
          Inc(currentRow);
        end
        else
        begin
          // ī�޶� �ִ� ��� �� ī�޶󺰷� row �߰�
          for j := 0 to Length(trainCameras) - 1 do
          begin
            ExcelGrid.RowCount := currentRow + 1;
            // ���� ����
            ExcelGrid.Cells[1,currentRow] := IntToStr(train.fformatNo);
            ExcelGrid.Cells[2,currentRow] := train.ftrainNo;
            ExcelGrid.Cells[3,currentRow] := IntToStr(train.fcarriageNum);
            ExcelGrid.Cells[4,currentRow] := IntToStr(train.fcameraNum);
            ExcelGrid.Cells[5,currentRow] := train.ftvcsIpaddr;
            // ī�޶� ����
            ExcelGrid.Cells[6,currentRow] := IntToStr(trainCameras[j].fposition);
            ExcelGrid.Cells[7,currentRow] := trainCameras[j].fname;
            ExcelGrid.Cells[8,currentRow] := trainCameras[j].fipaddr;
            ExcelGrid.Cells[9,currentRow] := IntToStr(trainCameras[j].fport);
            ExcelGrid.Cells[10,currentRow] := trainCameras[j].frtsp;
            ExcelGrid.Cells[11,currentRow] := trainCameras[j].frtsp2;
            ExcelGrid.Cells[12,currentRow] := trainCameras[j].fuserId;
            ExcelGrid.Cells[13,currentRow] := trainCameras[j].fuserPwd;
            Inc(currentRow);
          end;
        end;
      end;
      // ������ ����
      AdvGridExcelIO1.AdvStringGrid := ExcelGrid;
      AdvGridExcelIO1.XLSExport(SaveDialog.FileName);
      ShowTVCSMessage('���� ������ ����Ǿ����ϴ�.');
    end;
  finally
    SaveDialog.Free;
    ExcelGrid.Free;
  end;
end;

procedure TfrmTrain.btnUploadTrainCamerasClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  actualRowCount, i, j: Integer;
  hasEmptyCells: Boolean;
  emptyCellRows: string;
  requiredColumnsFilled, anyOptionalColumnFilled: Boolean;
begin
  if ShowTVCSCheck(mcExcelUpload) then
  begin
    OpenDialog := TOpenDialog.Create(nil);
    try
      OpenDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls|All Files (*.*)|*.*';
      OpenDialog.FilterIndex := 2;
      if OpenDialog.Execute then
      begin

        GridBuf := TAdvStringGrid.Create(self);
        AdvGridExcelIO1.AdvStringGrid := GridBuf;
        AdvGridExcelIO1.XLSImport(OpenDialog.FileName, 0);

        // ���� �����Ͱ� �ִ� �� �� ���
        actualRowCount := 1; // ��� ���� �׻� ����
        hasEmptyCells := False;
        emptyCellRows := '';

        for i := 1 to GridBuf.RowCount - 1 do
        begin
          // ���� ������ ����ִ��� Ȯ��
          var rowIsEmpty := True;
          for j := 0 to GridBuf.ColCount - 1 do
          begin
            if Trim(GridBuf.Cells[j, i]) <> '' then
            begin
              rowIsEmpty := False;
              Break;
            end;
          end;

          if rowIsEmpty then
          begin
            // ������ �� ���� ������ ����
            Break;
          end
          else
          begin
            // �ʼ� �׸�(������ȣ, ������ȣ, ������, ī�޶��, TVCSIP) Ȯ��
            requiredColumnsFilled := True;
            for j := 1 to 5 do // �ʼ� �� �ε��� 0~4
            begin
              if Trim(GridBuf.Cells[j, i]) = '' then
              begin
                requiredColumnsFilled := False;
                Break;
              end;
            end;

            // ���� �׸��� �ϳ��� �ִ��� Ȯ��
            anyOptionalColumnFilled := False;
            for j := 6 to GridBuf.ColCount - 1 do // ���� �� �ε��� 5~������
            begin
              if Trim(GridBuf.Cells[j, i]) <> '' then
              begin
                anyOptionalColumnFilled := True;
                Break;
              end;
            end;

            // �ʼ� �׸��� ��� ä���� �ְ�, ���� �׸� �� �ϳ��� �ִµ� ��� ä���� ���� ���� ���
            if requiredColumnsFilled and anyOptionalColumnFilled then
            begin
              // ���� �׸��� ��� ä���� �ִ��� Ȯ��
              var allOptionalColumnsFilled := True;
              for j := 6 to GridBuf.ColCount - 1 do
              begin
                if Trim(GridBuf.Cells[j, i]) = '' then
                begin
                  allOptionalColumnsFilled := False;
                  Break;
                end;
              end;

              if not allOptionalColumnsFilled then
              begin
                hasEmptyCells := True;
                if emptyCellRows <> '' then
                  emptyCellRows := emptyCellRows + ', ';
                emptyCellRows := emptyCellRows + IntToStr(i+1); // ���� �� ��ȣ�� 1���� ����
              end;
            end;

            Inc(actualRowCount);
          end;
        end;

        // ���� ����� �� ���� �׸��� ũ�� ����
        GridBuf.RowCount := actualRowCount;

        if hasEmptyCells then
        begin
          ShowTVCSMessage('�Էµ��� ���� �׸��� �ֽ��ϴ�. ������������ ���� ���� Ȯ���ϼ���: ' + emptyCellRows);
        end
        else
        begin
          ShowMessage('�ε�� ������ �� ��: ' + IntToStr(actualRowCount));
        end;
      end;
    finally
      OpenDialog.Free;
      //LoadTrainList;
    end;
  end;
end;


procedure TfrmTrain.edNvrRTSPEnter(Sender: TObject);
begin
        HideValidator(edNvrRTSP);
end;

procedure TfrmTrain.edNvrRTSPExit(Sender: TObject);
begin
        if (edNvrRTSP.IPAddress='0.0.0.0') then ShowValidator(edNvrRTSP,'��ȿ���� ���� �ּ�',ValidTooltip);
end;

procedure TfrmTrain.edscNoEnter(Sender: TObject);
begin
       HideValidator(edscNo);

end;

procedure TfrmTrain.edscNoExit(Sender: TObject);
var
 selCount,i,selRow:Integer;
begin
selCount:=grdTrains.SelectedRowCount;
if (selCount<>1) then  Exit;
if (Trim(edscNo.Text)='') then ShowValidator(edscNo,'������ȣ�� �Է�',ValidToolTip);
selRow:=grdTRains.SelectedRow[0];

if (grdTrains.Cells[1,selRow]<>Trim(edscNo.Text)) then grdTrains.Cells[1,selRow]:=edscNo.Text;











//grdTrains.Cells[1,1]:=edscNo.Text;
//edScNo.Color:=clWhite;
end;

procedure TfrmTrain.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearchClick(Sender);
end;

procedure TfrmTrain.edTrainNoEnter(Sender: TObject);
begin
  //edTrainNo.Color:=clyellow;
//  edTrainNo.StyleElements:=[seBorder];
  HideValidator(edTrainNo);
end;

procedure TfrmTrain.edTrainNoExit(Sender: TObject);
var
 selCount,i,selRow:Integer;
begin
selCount:=grdTrains.SelectedRowCount;
if (selCount<>1) then  Exit;
//if (grdTrains.SelectedRow[1] and grdTrains.Cells[1,1]='') then
//  grdTrains.Cells[1,1]:=edTrainNo.Text;
  //edTrainNo.StyleElements:=[seBorder,seFont,seClient];

    if (edTrainNo.Text='') then ShowValidator(edTrainNo,'������ȣ��  �Է�.',ValidTooltip);
    selRow:=grdTRains.SelectedRow[0];
    if (grdTrains.Cells[2,selRow]<>Trim(edTrainNo.Text)) then grdTrains.Cells[2,selRow]:=edTrainNo.Text;

end;

procedure TfrmTrain.FormCreate(Sender: TObject);
begin


  LoadTrainList;
  SetTrainCamListHeader;

  //��ư
  TButtonStyler.ApplyGlobalStyle(Self);

  grdTrains.OnClickCell := grdTrainsClickCell;
  lblTitle.Caption := '���� ī�޶� ���� ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'ȣ��)';
  isNeedUpdate:=false;
  grdTrainsClickCell(Sender,1,1); //ù��° �� ����
  grdTrains.SelectRows(1,1);



end;

procedure TfrmTrain.UpdateTrainList(camCount:Integer);
var
  trainPos: TVCSTrainInPost;
  trainPat: TVCSTrainInPatch;
  trainRes: tvcsProtocol.TVCSTrain;
begin
  try
        trainPat := TVCSTrainInPatch.Create;
        trainPat.fid := SelTrain.fid;

        trainPat.fformatNo := StrtoInt(edscNo.Text);
        trainPat.fcarriageNum := StrtoInt(cmbTrainCnt.Text);
        trainPat.fcameraNum :=camCount;
        trainPat.ftvcsIpaddr := edNvrRTSP.Text;
        trainRes := gapi.UpdateTrain(trainPat);
        if trainRes = nil then
        begin
          ShowTVCSMessage('�������� ������ �����Ͽ����ϴ�.');
          Exit;
        end;

  finally
     FreeAndNil(trainPat);
  end;

end;

procedure TfrmTrain.AddTrainsList;
var
  trainPos: TVCSTrainInPost;
  trainPat: TVCSTrainInPatch;
  trainRes: tvcsProtocol.TVCSTrain;

begin

  try
   if (not Validator) then begin
      ShowTVCSMessage('�߸��� ���� �ֽ��ϴ�. Ȯ�����ּ���');
      Exit;
   end;

    trainPos := TVCSTrainInPost.Create;
    trainPos.ftrainNo := edTrainNo.Text;
    trainPos.fformatNo := StrtoInt(edscNo.Text);
    trainPos.fcarriageNum := StrToInt(cmbTrainCnt.Text);
    trainPos.fcameraNum  :=0;
    trainPos.ftvcsIpaddr := edNvrRTSP.text;
    trainRes := gapi.AddTrain(trainPos);
    if trainRes = nil then
    begin
      ShowTVCSMessage('�������� �߰��� �����Ͽ����ϴ�.');
      Exit;
    end;
  finally
    if(trainPos<>nil) then
      FreeAndNil(trainPos);
  end;


end;


procedure TfrmTrain.LoadTrainList(trainNo: string='');
var
  size, i, k: integer;
  delBtn: TButton;
  uniqueValues: TStringList;
  uniqueCount: integer;
begin

  trains := gapi.GetTrain(-1);
  size := Length(trains);
  lblTotal.Caption := '�� :' + IntToStr(size) +'��';
  delBtn := TButton.Create(self);
  delBtn.Caption := '����';

  with grdTrains do
  begin
    RowCount :=1;
    ColCount:=9;         //include hidden cell
    ColWidths[0]:=60;
    ColWidths[1]:=90;
    ColWidths[2]:=90;
    ColWidths[3]:=60;

    Cells[0,0]:='No.';
    Cells[1,0]:='������ȣ';
    Cells[2,0]:='������ȣ';
    Cells[3,0]:='����';
    for I := 4 to 8  do begin
      HideColumn(i);
    end;
  end;

  for i := 0 to size -1 do
  with grdTrains do
  begin
    AddRow;
    Cells[0,i+1] := inttostr(i+1);
    Cells[1,i+1] := inttostr(trains[i].fformatNo);
    Cells[2,i+1] := trains[i].ftrainNo;
    AddImageIdx(3, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);

    //hidden cell ��������
    Cells[4,i+1]:=IntTostr(trains[i].fid);
    Cells[5,i+1]:=IntTostr(trains[i].fcarriageNum);
    Cells[6,i+1]:=IntTostr(trains[i].fcameraNum);
    Cells[7,i+1]:=trains[i].ftvcsIpaddr;
    Cells[8,i+1]:='old';
  end;


end;


procedure TfrmTrain.SetTrainCamListHeader;
var
 i:Integer;
begin

  with grdTrainCams do
  begin
    RowCount:=1;
    ColCount:=13;
    //760
    ColWidths[0] := 60;   // ������ȣ
    ColWidths[1] := 40;  // ȣ��ġ
    ColWidths[2] := 90;  // ī�޶��̸�
    ColWidths[3] := 100;   // IP
    ColWidths[4] := 40;  // Port
    ColWidths[5] := 150;  // RTSP High

    ColWidths[6] := 150;  // RTSP Low
    ColWidths[7] := 65;   // Password
    ColWidths[8] := 82;   // �̸����� ��ư
    ColWidths[9] := 65;   // ���� ��ư
    ColWidths[10] := 45;

    Cells[0,0]:='������ȣ';
    Cells[1,0]:='��ġ';

    Cells[2,0]:='ī�޶��';
    Cells[3,0]:='IP Addr';
    Cells[4,0]:= 'Port';
    Cells[5,0]:='RTSP �ּ�1 ';
    Cells[6,0]:='RTSP �ּ�2 ';

    Cells[7,0]:='ID';
    Cells[8,0]:='Password';
    Cells[9,0]:='�̸�����';
    Cells[10,0]:='����';

    FixedRows := 0;
    FixedCols := 0;


    for i := 0 to 8 do
      begin
        ReadOnly[i,0] := True;
      end;

    HideColumn(3);HideColumn(4);
    for i:=11 to 12 do HideColumn(i);

  end;


end;


procedure TfrmTrain.LoadTrainCamList(trainId: Integer =-1);
var
  i, j, count: integer;
  filteredCams: TArray<TVCSTrainCamera>;

begin
  //
  lblCamCnt.Caption := '��:0��';

  grdTrainCams.RowCount:=1;

  if trainId <> -1 then
  begin
    trainCams := Gapi.GetTrainCamera(trainId);
    count := length(trainCams);
    lblCamCnt.Caption := '��:' + IntToStr(count) + '��';

    if count > 0 then
    begin
      for i := 0 to count-1 do
         with grdTrainCams do
         begin
           AddRow;

           Cells[0,i+1] := InttoStr(trainCams[i].ftrainNo);
           Cells[1,i+1] := IntToStr(trainCams[i].fposition);

           Cells[2,i+1] := trainCams[i].fname;
           Cells[3,i+1] := trainCams[i].fipaddr;
           Cells[4,i+1] := IntToStr(trainCams[i].fport);
           Cells[5,i+1] := trainCams[i].frtsp;
           Cells[6,i+1] := trainCams[i].frtsp2;

           Cells[7,i+1] := trainCams[i].fuserId;
           Cells[8,i+1] := trainCams[i].fuserPwd;

           AddImageIdx(9, i+1, VirtualImageList1.GetIndexByName('preview'), haCenter, vaCenter);
           AddImageIdx(10, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
           //hidden cell
           Cells[11,i+1]:=IntToStr(trainCams[i].fid);
           Cells[12,i+1]:=trainCams[i].ftvcsRtsp;

         end;

    end;
    grdTrainCams.SelectRows(1,1);
  end;

end;

//���� ����/����
procedure TfrmTrain.grdTrainsCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  // ���� ���Ե� cell��
  if (grdTrains.cells[8,Arow]='new') then CanEdit:=true else canEdit:=false;
end;

procedure TfrmTrain.grdTrainsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  fid : integer;

//  isNewRow: Boolean;
begin
//
{  if ARow = 0 then
  begin
    edscNo.Text := '';
    cmbTrainCnt.ItemIndex:=2;
    //edTrainCnt.Text := '';
    edTrainNo.Text := '';
    edNvrRTSP.IPAddress := '0.0.0.0';

    edscNo.Enabled := False;
//    edTrainCnt.Enabled := False;
    cmbTrainCnt.Enabled:=false;
    edTrainNo.Enabled := False;
    edNvrRTSP.Enabled := False;
    btnAddCams.Enabled := False;

    LoadTrainCamList();
    Exit;
  end;
 }

  edscNo.Enabled := true;
  cmbTrainCnt.Enabled:=true;
  edTrainNo.Enabled := true;
  edNvrRTSP.Enabled := true;
  btnAddCams.Enabled := true;

// if(ARow=0) then grdTrains.UnSelectRows(0,1);





  if ARow > 0 then
  begin
      grdTrains.SelectRows(ARow,1);
      if Acol =3 then
      begin

        try
        if ShowTVCSCheck(mcDelete) then
          begin
          // ����
            gapi.DeleteTrain(StrToInt(grdTrains.Cells[4,Arow]));
            grdTrains.RemoveRows(ARow, 1);
            ShowTVCSMessage('���� �Ǿ����ϴ�. ');
            grdTrainsClickCell(Sender,1,1);
          end;
        finally

        end;

      end else
      begin
          fid :=strToInt(grdTrains.Cells[4,Arow]); // ���������� fid
          edscNo.Text := grdTrains.Cells[1,Arow];
          if (edscNo.Text<>'') then HideValidator(edscNo);

          edTrainNo.Text := grdTrains.Cells[2,Arow];
          if (edscNo.Text<>'') then HideValidator(edscNo);

          cmbTrainCnt.Text := grdTrains.Cells[5,Arow];
          if (cmbTrainCnt.Text<>'') then HideValidator(cmbTrainCnt);

          edNvrRTSP.IPAddress:= grdTrains.Cells[7,Arow];
          if (edNvrRTSP.Text<>'0.0.0.0') then HideValidator(edNvrRTSP);

          LoadTrainCamList(fid);
      end;
  end;

end;

procedure TfrmTrain.grdTrainsEditCellDone(Sender: TObject; ACol, ARow: Integer);
begin
if (ACol=1) then
  edscNo.Text:=grdTrains.Cells[aCol,Arow];
if (ACol=2) then
  edTrainNo.Text:=grdTrains.Cells[aCol,Arow];
end;

procedure TfrmTrain.grdTrainsEditChange(Sender: TObject; ACol, ARow: Integer;
  Value: string);
begin
if (ACol=1) then edscNo.Text:=Value
else if (Acol=2) then edTrainNo.Text:=Value;

end;

procedure TfrmTrain.grdTrainsSelectCell(Sender: TObject; ACol, ARow: LongInt;
  var CanSelect: Boolean);
begin
if (ARow=0) then CanSelect:=false
else CanSelect:=true;
end;

procedure TfrmTrain.grdTrainCamsClickCell(Sender: TObject; ARow, ACol: Integer);
var
  ShowPreview: TFrmPreview;

begin
//
if ARow > 0 then
  begin
    if ACol = 10 then
      begin
        if ShowTVCSCheck(mcDelete) then
        begin

          gapi.DeleteTrainCamera(StrToInt(grdTrainCams.Cells[ARow,11]));
          grdTrainCams.RemoveRows(ARow, 1);
    //      LoadTrainCamList(SelTrain.fid);
          ShowTVCSMessage('���� �Ǿ����ϴ�. ');
        end;
      end;

    // �̸�����
    if ACol = 9 then
      begin
        ShowPreview := TfrmPreview.Create(self);
        ShowPreview.SetRtspUrl(grdTrainCams.Cells[ARow,12]);
        //ShowMessage(trainCams[ARow-1 -addTrCnt].ftvcsRtsp);
        //ShowPreview.SetRtspID(trainCams[ARow-1 -addTrCnt].fuserId);
        //ShowPreview.SetRtspPw(trainCams[ARow-1 -addTrCnt].fuserPwd);
        ShowPreview.StartPreview;
        ShowPreview.ShowModal;
      end;
    //ShowMessage('ACol: '+ IntToStr(ACol) +' ARow:' +IntToStr(ARow));

  end;

end;

procedure TfrmTrain.grdTrainCamsGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
if (ACol=8) then AEditor:=edPassword; // �н����� ***


end;

procedure TfrmTrain.grdTrainCamsIsPasswordCell(Sender: TObject; ARow,
  ACol: Integer; var IsPassword: Boolean);
begin
if (ARow>0) and (Acol=8) then IsPassword:=true;

end;

end.
