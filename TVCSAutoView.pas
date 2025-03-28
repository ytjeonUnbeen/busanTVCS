unit TVCSAutoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TVCSCamView,Math;

type
  TfrmAutoView = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
  private
    MultiCams:array of TCamView;
    Procedure CreateSplitPanel;
    procedure SplitView(count:Integer);
    procedure ClearSplitView;
    function  findEmptyView:Integer;
    function  findTrainView(aUpDown:Integer;aStation:String):Boolean;
    procedure AssignCamView(var dstcam:TCamView;aPos,aCol,ARow,aCamWidth,aCamHeight:Integer);
  public

    function AddAutoView(aHost,aTrainNo,aStation:String;aUpDown:Integer;stname:String):Integer;
    procedure RemoveAutoView(aUpDown:Integer;aStation:String);
  end;

var
  frmAutoView: TfrmAutoView;


implementation

{$R *.dfm}
Procedure TfrmAutoView.CreateSplitPanel;
var
 i:Integer;

begin
 SetLength(MultiCams,16); //max 16분힐
 for i := 0 to 15 do
       MultiCams[i]:=TCamView.Create(self);
end;

procedure TfrmAutoView.ClearSplitView;
var
 i:integer;
begin
  if (MultiCams=nil) then Exit;
  for I :=0  to Length(Multicams)-1 do begin
         FreeAndNil(MultiCams[i]);
  end;

end;


function  TfrmAutoView.findTrainView(aUpDown:Integer;aStation:String):Boolean;
var
 iPos:Integer;
begin
for ipos := 0 to 15 do begin
 if (Multicams[ipos].UpDown=aUpDown) and  (Multicams[ipos].Station=aStation)  and (Multicams[ipos].Allocated) then
 begin
    Result:=true;
    Exit;
 end;
end;
 Result:=false;

end;

procedure TfrmAutoView.RemoveAutoView(aUpDown:Integer;aStation:String);
var
 ipos:Integer;
begin
  for ipos := 0 to 15 do begin

   if (Multicams[ipos].UpDown=aUpDown) and  (Multicams[ipos].Station=aStation) then
   begin
       Multicams[ipos].StopView;
       Multicams[ipos].Allocated:=false;
       Multicams[ipos].Player.Visible:=false;
   end;

  end;


end;


function TfrmAutoView.AddAutoView(aHost,aTrainNo,aStation:String;aUpDown:Integer;stname:String):Integer;
var
 iView:Integer;

 sUpDown:String;
begin
  Result:=-1;
  if (findTrainView(aUpDown,aStation)) then Exit;



  iView:=findEmptyView;
  if (iview=-1) then begin
    ShowMessage('더이상 표시할 수 없습니다.');
    Exit;
  end;
  Multicams[iview].FTrainID:=StrToInt(aTrainNo);
  if (aupDown=1) then
     sUpDown:='up'
  else
     sUpDown:='down';

  Multicams[iview].RtspUrl:='rtsp://'+aHost+':8554/station/'+sUpDown+'/'+aStation;
  Multicams[iview].Station:=aStation;
  MultiCams[iview].UpDown:=aUpdown;
  MultiCams[iview].FStationName:=stName;
  Multicams[iview].Allocated:=true;
  Multicams[iview].Player.Visible:=true;
  Multicams[iview].DebugOsd:=true;    // debug
  Multicams[iview].PlayView;
  Result:=iView;
end;


function TfrmAutoView.findEmptyView:integer;
var
 i:Integer;
begin
  for I := Low(Multicams) to High(Multicams) do begin
     if (not MultiCams[i].Allocated) then
     begin
        Result:=i;
        Exit;
     end;

  end;
  Result:=-1;

end;


procedure TfrmAutoView.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
 count:Integer;
 rowCount,colCount:Integer;
 FCamWidth,FCamheight:Integer;
 row,col,i:Integer;
begin
     if (Length(Multicams)=0) then Exit;
     
     count:=16;
     rowCount:=trunc(sqrt(count));
     colCount:=trunc(sqrt(count));
     FCamWidth:=NewWidth div colCount;;
     FCamHeight:=NewHeight div rowCount;;
     row:=0;
     col:=0;
     for i := 0 to count-1 do begin
       MultiCams[i].Left:=col*FCamWidth;
       MultiCams[i].top:=row*FCamHeight;
       MultiCams[i].width:=FCamWidth;
       MultiCams[i].Height:=FCamHeight;
       inc(col);
       if (col >=colCount)then begin
          inc(row);
          col:=0;
       end;
     end;
     Resize:=true;

end;


procedure TfrmAutoView.FormCreate(Sender: TObject);
begin
//ArrangeView;
SplitView(16);


end;

procedure TfrmAutoView.SplitView(count: Integer);
var
 i,row,col,lastcnt:Integer;
 FCamWidth,FCamHeight:Integer;
 rowCount,colCount:Integer;

begin

     rowCount:=trunc(sqrt(count));
     colCount:=trunc(sqrt(count));
     FCamWidth:=self.Width div colCount;;
     FCamHeight:=self.Height div rowCount;;
     row:=0;
     col:=0;
   

     ClearSplitView;
     CreateSplitPanel;

      for i := 0 to count-1 do begin
           AssignCamView(MultiCams[i],i,col,row,FCamWidth,FCamheight);
           MultiCams[i].isMerged:=false;
           MultiCams[i].Allocated:=false;
           inc(col);
           if (col >=colCount)then begin
              inc(row);
              col:=0;
           end;
       end;


end;

procedure  TfrmAutoView.AssignCamView(var dstcam:TCamView;aPos,aCol,aRow,aCamWidth,aCamHeight:Integer);
begin
       dstcam.Left:=aCol*aCamWidth;
       dstcam.top:=aRow*aCamHeight;
       dstcam.width:=aCamWidth;
       dstcam.Height:=aCamHeight;
       dstcam.Parent:=self;
       dstcam.ParentColor:=false;
       dstcam.BorderColor:=clWhite;
       dstcam.BorderStyle:=bsSingle;
       dstcam.BevelInner:=bvLowered;
       dstcam.BevelOuter:=bvNone;
       dstcam.BevelWidth:=1;
       dstcam.Caption.Visible:=false;
       dstcam.Caption.Height:=10;
       dstcam.Caption.Flat:=true;
       dstcam.BasePath:=ExtractFilePath(Application.ExeName);
  //     dstcam.OnDblClick := CamViewClick;
       dstCam.pos:=aPos;

end;


end.
