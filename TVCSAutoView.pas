unit TVCSAutoView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TVCSCamView;

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
    procedure AssignCamView(var dstcam:TCamView;aPos,aCol,ARow,aCamWidth,aCamHeight:Integer);
  public
    { Public declarations }
  end;

var
  frmAutoView: TfrmAutoView;


implementation

{$R *.dfm}
Procedure TfrmAutoView.CreateSplitPanel;
var
 i:Integer;

begin
 SetLength(MultiCams,16); //max 16ºÐÈú
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
