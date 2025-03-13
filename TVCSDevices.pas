unit TVCSDevices;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls,
  AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, AdvGlowButton,
  TVCSButtonStyle, TVCSCheckDialog, tmsAdvGridExcel, tvcsProtocol, tvcsAPI,
  Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList;

type
  TfrmDevices = class(TForm)
    pnMainFrame: TPanel;
    pnBottom: TPanel;
    lblTitle: TLabel;
    edSearchText: TEdit;
    lblDeviceCnt: TLabel;
    grdDeviceList: TAdvStringGrid;
    lblDeviceInfo: TLabel;
    btnDeviceUpload: TAdvGlowButton;
    btnDeviceDownload: TAdvGlowButton;
    btnDlgClose: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnSave: TAdvGlowButton;
    AdvGridExcelIO1: TAdvGridExcelIO;
    btnAddDevice: TAdvGlowButton;
    btnSearch: TAdvGlowButton;
    cbSearch: TComboBox;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDlgCloseClick(Sender: TObject);
    procedure btnDeviceUploadClick(Sender: TObject);
    procedure btnDeviceDownloadClick(Sender: TObject);
    procedure btnAddDeviceClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edSearchTextKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    addDevCnt : integer;
    CheckExcel : boolean;
    BufDevices: TArray<TVCSDevice>;
    Devices: TArray<TVCSDevice>;
    GridBuf : TAdvStringGrid;
    procedure grdDeviceListHasComboBox(Sender: TObject; ACol, ARow: Integer;
      var HasComboBox: Boolean);
    procedure grdDeviceListGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdDeviceListGetEditorProp(Sender: TObject; ACol, ARow: Integer;
      AEditLink: TEditLink);
    procedure grdDeviceClickCell(Sender: TObject; ARow, ACol: Integer);

  public
    { Public declarations }
    procedure LoadDeviceList;


  end;

var
  frmDevices: TfrmDevices;

implementation

{$R *.dfm}

procedure TfrmDevices.btnAddDeviceClick(Sender: TObject);
begin
  addDevCnt := addDevCnt + 1;
  with grdDeviceList do
  begin
    InsertChildRow(0);
    Cells[0,1] := IntToStr(RowCount-1);  // No
    Cells[1,1] := '';  // ������ȣ
    Cells[2,1] := 'TVCS';  // ��ġ���� �⺻��
    Cells[3,1] := '';  // IP
    Cells[4,1] := '';  // ID
    Cells[5,1] := '';  // PW
    Cells[6,1] := 'Ȱ��';  // ����
    AddImageIdx(7, 1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
  end;
end;

procedure TfrmDevices.btnCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;

end;

procedure TfrmDevices.btnDeviceDownloadClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExcelGrid: TAdvStringGrid;
  i, currentRow: Integer;
  deviceTypeStr: string;
begin
  SaveDialog := TSaveDialog.Create(nil);
  ExcelGrid := TAdvStringGrid.Create(nil);
  try
    SaveDialog.Filter := 'Excel Files (*.xlsx)|*.xlsx|Excel 97-2003 (*.xls)|*.xls';
    SaveDialog.DefaultExt := 'xls';
    SaveDialog.FilterIndex := 2;

    if SaveDialog.Execute then
    begin
      // ���� �׸��� �ʱ� ����
      with ExcelGrid do
      begin
        ColCount := 7;  // ��ü �÷� ��
        RowCount := 1;  // ��� row

        // ��� ����
        Cells[1,1] := '��ġ����';
        Cells[2,1] := '���ڵ�';
        Cells[3,1] := '������ȣ';
        Cells[4,1] := 'IP�ּ�';
        Cells[5,1] := 'ID';
        Cells[6,1] := 'PW';
      end;

      currentRow := 2;

      // �� ��ġ���� ó��
      for i := 0 to Length(Devices) - 1 do
      begin
        ExcelGrid.RowCount := currentRow + 1;

        // ��ġ ���� ���ڿ� ��ȯ
        case StrToInt(Devices[i].ftype) of
          0: deviceTypeStr := 'TVCS';
          1: deviceTypeStr := 'ǥ����ġ';
          2: deviceTypeStr := '�뿭�� ���� �����';
        end;

        // ��ġ ���� �Է�
        ExcelGrid.Cells[1,currentRow] := deviceTypeStr;
        ExcelGrid.Cells[2,currentRow] := IntToStr(Devices[i].fstationCode);
        // ������ȣ�� 0�� ��� '0000' �������� ���
        if Devices[i].ftrainNo = 0 then
          ExcelGrid.Cells[3,currentRow] := '0000'
        else
          ExcelGrid.Cells[3,currentRow] := IntToStr(Devices[i].ftrainNo);
        ExcelGrid.Cells[4,currentRow] := Devices[i].fipAddr;
        ExcelGrid.Cells[5,currentRow] := Devices[i].floginId;
        ExcelGrid.Cells[6,currentRow] := Devices[i].floginPwd;

        Inc(currentRow);
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

procedure TfrmDevices.btnDeviceUploadClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  isValidFormat: Boolean;
begin
  if ShowTVCSCheck(2) then
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

        // ���� ��� üũ
        isValidFormat := (GridBuf.Cells[1,1] = '��ġ����') and

                        (GridBuf.Cells[3,1] = '������ȣ') and
                        (GridBuf.Cells[4,1] = 'IP�ּ�') and
                        (GridBuf.Cells[5,1] = 'ID') and
                        (GridBuf.Cells[6,1] = 'PW');

        if isValidFormat then
        begin
          CheckExcel := True;
          LoadDeviceList;
        end
        else
        begin
          ShowTVCSMessage('��������� �ùٸ��� �ʽ��ϴ�.');
          FreeAndNil(GridBuf);  // �߸��� ���� ������ ����
        end;
      end;

    finally
      OpenDialog.Free;
    end;
  end;
end;

procedure TfrmDevices.btnDlgCloseClick(Sender: TObject);
begin
    ModalResult := mrAbort;

end;

procedure TfrmDevices.btnSaveClick(Sender: TObject);
var
  devicePost: TVCSDevicePost;
  device: TVCSDevice;
  deviceType: string;
  i: Integer;
  allSuccess: Boolean;
  trainStr: string;
  trainNo: Integer;

begin
  if ShowTVCSCheck(0) then
  begin
    // ���� ���ε� ó��
    if CheckExcel then
    begin
      allSuccess := True;

      try
        // 1. ���� ������ ����
        for i := 0 to Length(Devices)-1 do
        begin
          if gapi.DeleteDevice(Devices[i].fid) = '' then
          begin
            allSuccess := False;
            ShowTVCSMessage('��ġ ���� ���� �� ������ �߻��߽��ϴ�.');
            Exit;
          end;
        end;

        // 2. ���� ������ �߰�
        for i := 1 to grdDeviceList.RowCount -1 do
        begin
          devicePost := TVCSDevicePost.Create;
          try
            if grdDeviceList.Cells[2,i] = 'TVCS' then
              deviceType := '0'
            else if grdDeviceList.Cells[2,i] = 'ǥ����ġ' then
              deviceType := '1'
            else
              deviceType := '2';
            devicePost.ftype := deviceType; // ��ġ����

            devicePost.fstationCode := 0;  // ���ڵ�

            trainStr := Trim(grdDeviceList.Cells[1,i]);
            if (trainStr = '') or (trainStr = '0000') then
              devicePost.ftrainNo := 0
            else if TryStrToInt(trainStr, trainNo) then
              devicePost.ftrainNo := trainNo;


            devicePost.fipAddr := grdDeviceList.Cells[3,i];  // IP�ּ�
            devicePost.fport := 80;  // �⺻ ��Ʈ
            devicePost.floginId := grdDeviceList.Cells[4, i];
            devicePost.floginPwd := grdDeviceList.Cells[5, i];


            devicePost.fmemo := '';

            device := gapi.AddDevice(devicePost);
            if device = nil then
            begin
              allSuccess := False;
              ShowTVCSMessage(Format('��ġ ���� �߰� �� ������ �߻��߽��ϴ�. (������ȣ: %s)', [GridBuf.Cells[2,i]]));
              Exit;
            end;
          finally
            FreeAndNil(devicePost);
          end;
        end;

        if allSuccess then
        begin
          ShowTVCSMessage('���� ������ ���ε尡 �Ϸ�Ǿ����ϴ�.');
          CheckExcel := False;
          LoadDeviceList;
        end;

      except
        on E: Exception do
        begin
          ShowTVCSMessage('ó�� �� ������ �߻��߽��ϴ�: ' + E.Message);
        end;
      end;
    end
    else
    begin
      // �Ϲ� ���� ó��
      for i := 1 to grdDeviceList.RowCount-1 do
      begin
        // ��ġ ���п� ���� type ����
        if grdDeviceList.Cells[2,i] = 'TVCS' then
          deviceType := '0'
        else if grdDeviceList.Cells[2,i] = 'ǥ����ġ' then
          deviceType := '1'
        else
          deviceType := '2';

        // ���� �߰��� ���� ���
        if i <= addDevCnt then
        begin
          devicePost := TVCSDevicePost.Create;
          try

            devicePost.ftype := deviceType;
            devicePost.ftrainNo := StrToInt(grdDeviceList.Cells[1,i]);
            devicePost.fipAddr := grdDeviceList.Cells[3,i];
            devicePost.fstationCode := 0;
            devicePost.fport := 80; // �⺻ ��Ʈ
            devicePost.fmemo := '';
            devicePost.floginId := grdDeviceList.Cells[4,i];
            devicePost.floginPwd := grdDeviceList.Cells[5,i];

            device := gapi.AddDevice(devicePost);
            if device = nil then
            begin
              ShowTVCSMessage('��ġ ���� �߰��� �����Ͽ����ϴ�.');
              Exit;
            end;
          finally
            FreeAndNil(devicePost);
          end;
        end
        else
        begin
          // ���� ������ ����
          device := TVCSDevice.Create;
          try
            device.fid := Devices[i-2].fid;  // ���� id ����
            device.ftype := deviceType;
            device.ftrainNo := StrToInt(grdDeviceList.Cells[1,i]);
            device.fipAddr := grdDeviceList.Cells[3,i];
            device.fstationCode := 0;
            device.fport := 80;
            device.fmemo := '';
            device.floginId := grdDeviceList.Cells[4,i];
            device.floginPwd := grdDeviceList.Cells[5,i];

            if gapi.UpdateDevice(device) = nil then
            begin
              ShowTVCSMessage('��ġ ���� ������ �����Ͽ����ϴ�.');
              Exit;
            end;
          finally
            FreeAndNil(device);
          end;
        end;
      end;
      ShowTVCSMessage('������ �Ϸ�Ǿ����ϴ�.');
    end;
  end;
  addDevCnt := 0;
  //ModalResult := mrOk;
end;

procedure TfrmDevices.btnSearchClick(Sender: TObject);
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

  for i := 1 to grdDeviceList.RowCount - 1 do
  begin
    case searchMode of
      0: // ��ü �˻�
        if  grdDeviceList.Cells[1,i] = searchText then  // ������ȣ���� ã�� ���
        begin
          grdDeviceList.SelectCells(1,i,1,i);
          found := true;
          Break;
        end
        else if grdDeviceList.Cells[2,i] = searchText then  // ��ġ���п��� ã�� ���
        begin
          grdDeviceList.SelectCells(2,i,2,i);
          found := true;
          Break;
        end
        else if grdDeviceList.Cells[3,i] = searchText then
        begin
          grdDeviceList.SelectCells(3,i,3,i);
          found := true;
          Break;
        end;
      1: // �� �˻�
        if  grdDeviceList.Cells[1,i] = searchText then  // ������ȣ���� ã�� ���
        begin
          grdDeviceList.SelectCells(1,i,1,i);
          found := true;
          Break;
        end;
      2: // ����� �˻�
         if grdDeviceList.Cells[2,i] = searchText then  // ��ġ���п��� ã�� ���
        begin
          grdDeviceList.SelectCells(2,i,2,i);
          found := true;
          Break;
        end;
      3: // ����� �˻�
         if grdDeviceList.Cells[3,i] = searchText then  // ��ġ���п��� ã�� ���
        begin
          grdDeviceList.SelectCells(3,i,3,i);
          found := true;
          Break;
        end;
    end;
  end;

  if not found then
    ShowTVCSMessage('�˻� ����� �����ϴ�.');
end;

procedure TfrmDevices.edSearchTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearchClick(Sender);
end;

procedure TfrmDevices.FormCreate(Sender: TObject);

begin
    addDevCnt := 0;
    TButtonStyler.ApplyGlobalStyle(Self);
    grdDeviceList.OnGetEditorType := grdDeviceListGetEditorType;
    grdDeviceList.OnGetEditorProp := grdDeviceListGetEditorProp;
    grdDeviceList.OnHasComboBox := grdDeviceListHasComboBox;
    grdDeviceList.OnClickCell := grdDeviceClickCell;
    LoadDeviceList;
    lblTitle.Caption := '��ġ ���� ('+IntToStr(gapi.GetLoinInfo.fsystem.fline) +'ȣ��)'


end;

procedure TfrmDevices.LoadDeviceList;
var
  i: Integer;
  typeStr: string;
  validCount : integer;

begin
  // �׸��� ��� ����
  with grdDeviceList do
  begin
    RowCount := 1;  // ����� ����� �ʱ�ȭ
    ColCount := 8;  // ��ü �÷� �� ����

    // �÷� �ʺ� ����
    ColWidths[0] := 45;   // No.
    ColWidths[1] := 80;  // ���� ��ȣ
    ColWidths[2] := 150;  // ��ġ ����
    ColWidths[3] := 130;  // IP
    ColWidths[4] := 100;  // ID
    ColWidths[5] := 100;  // PW
    ColWidths[6] := 70;   // ����
    ColWidths[7] := 40;   // ����

    // ��� �ؽ�Ʈ ����
    Cells[0,0] := 'No.';
    Cells[1,0] := '���� ��ȣ';
    Cells[2,0] := '��ġ ����';
    Cells[3,0] := 'IP';
    Cells[4,0] := 'ID';
    Cells[5,0] := 'PW';
    Cells[6,0] := '����';
    Cells[7,0] := '����';
  end;
  // ���� ���ε��� ���
  if CheckExcel then
     begin
        //SetLength(BufDevices, GridBuf.RowCount -2);

         for i := 1 to GridBuf.RowCount do
         begin
           // �ش� ���� ��� �ʼ� �����Ͱ� �ִ��� Ȯ��
           if (GridBuf.Cells[1,i+1].Trim <> '') and  // ��ġ����
              (GridBuf.Cells[3,i+1].Trim <> '') and  // ������ȣ
              (GridBuf.Cells[4,i+1].Trim <> '') and  // IP
              (GridBuf.Cells[5,i+1].Trim <> '') and  // ID
              (GridBuf.Cells[6,i+1].Trim <> '') then // PW
           begin
             Inc(validCount);
             grdDeviceList.AddRow;
             grdDeviceList.Cells[0,validCount] := IntToStr(validCount);
             grdDeviceList.Cells[1,validCount] := GridBuf.Cells[3,i+1];
             grdDeviceList.Cells[2,validCount] := GridBuf.Cells[1,i+1];
             grdDeviceList.Cells[3,validCount] := GridBuf.Cells[4,i+1];
             grdDeviceList.Cells[4,validCount] := GridBuf.Cells[5,i+1];
             grdDeviceList.Cells[5,validCount] := GridBuf.Cells[6,i+1];
             grdDeviceList.Cells[6,validCount] := 'Ȱ��';
             grdDeviceList.AddImageIdx(7, validCount, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
           end;
         end;
         lblDeviceCnt.Caption := '��:' + IntToStr(validCount) + '��';

     end
  else
  begin
    Devices := gapi.GetDevice();
    lblDeviceCnt.Caption := '��:' + IntToStr(Length(Devices)) + '��';


    for i := 0 to Length(Devices)-1 do
    begin
      // type�� ���� ��ġ ���� ǥ��
      case StrToInt(Devices[i].ftype) of
        0: typeStr := 'TVCS';
        1: typeStr := 'ǥ����ġ';
        2: typeStr := '�뿭������ȭ��';
      end;

      with grdDeviceList do
      begin
        AddRow;
        Cells[0,i+1] := IntToStr(i+1);
        Cells[1,i+1] := IntToStr(Devices[i].ftrainNo);
        Cells[2,i+1] := typeStr;
        Cells[3,i+1] := Devices[i].fipAddr;
        Cells[4,i+1] := Devices[i].floginId;
        Cells[5,i+1] := Devices[i].floginPwd;


        Cells[6,i+1] := 'Ȱ��';
        AddImageIdx(7, i+1, VirtualImageList1.GetIndexByName('delete'), haCenter, vaCenter);
      end;
    end;
  end;
end;

procedure TfrmDevices.grdDeviceListHasComboBox(Sender: TObject; ACol,
  ARow: Integer; var HasComboBox: Boolean);
begin
  if (ACol = 2) and (ARow <> 0) then  // 2�� �÷�(��ġ ����)�� �޺��ڽ� ǥ��
    HasComboBox := True;
end;

procedure TfrmDevices.grdDeviceListGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if (ACol = 2) then  // 2�� �÷�(��ġ ����)
    AEditor := edComboList;
end;

procedure TfrmDevices.grdDeviceListGetEditorProp(Sender: TObject; ACol,
  ARow: Integer; AEditLink: TEditLink);
begin
  if (ACol = 2) then  // 2�� �÷�(��ġ ����)
  begin
    with grdDeviceList do
    begin
      ClearComboString;
      AddComboString('TVCS');
      AddComboString('ǥ����ġ');
      AddComboString('�뿭������ȭ��');
    end;
  end;
end;

procedure TfrmDevices.grdDeviceClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if (ARow > 0) and (ACol = 7) then  // ���� ��ư Ŭ��
  begin
    if ShowTVCSCheck(1) then
    begin
      if ARow <= addDevCnt then  // ���� �߰��� ��
        begin
          grdDeviceList.RemoveRows(ARow, 1);
          addDevCnt := addDevCnt - 1;  // ī��Ʈ ����
        end
      else
      begin
        // API ȣ���Ͽ� ����
        if gapi.DeleteDevice(Devices[ARow-1].fid) <> '' then
        begin
          grdDeviceList.RemoveRows(ARow, 1);
          LoadDeviceList;
          ShowTVCSMessage('�����Ǿ����ϴ�.');
        end
        else
          ShowTVCSMessage('���� �����Ͽ����ϴ�.');
      end;
    end;
  end;
end;


end.
