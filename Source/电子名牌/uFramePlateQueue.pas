unit uFramePlateQueue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, RzPanel, StdCtrls, RzLstBox,uScrollView,uTrainmanView,
  uTrainmanOrderView,uTogetherTrainView,uOrderGroupView,uOrderGroupInTrainView,
  uNamedGroupView, RzCommon, Menus,DateUtils;

type
  TFramePlateQueue = class(TFrame)
    lstBox: TRzListBox;
    RzPanel1: TRzPanel;
    RzFrameController1: TRzFrameController;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Label1: TLabel;
    lblTm: TLabel;
    Label3: TLabel;
    lblDuty: TLabel;
    Label5: TLabel;
    lblTel: TLabel;
    Label7: TLabel;
    lblEndWorkTime: TLabel;
    procedure lstBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lstBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure lstBoxClick(Sender: TObject);
    procedure lstBoxStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure lstBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenuPopup(Sender: TObject);
  private
    { Private declarations }
    m_ScrollView: TScrollView;
    procedure OnDblView(View: TView);
    procedure AddView(View: TView);
    procedure ScrollViewDropComplete(src,dest: TView);
    procedure OnClickView(View: TView);
  public
    { Public declarations }
    procedure ClearQueue();
    procedure BindScrollView(ScrollView: TScrollView);
  end;

implementation

uses uFrameNamePlate,uTrainman;
type
  TViewPainter = class
  private
    class procedure DrawTitle(Bitmap: TBitmap;Title: string);
    class procedure DrawTmViews(Bitmap: TBitmap;Views: TViews);
  public
    class procedure Draw(Bitmap: TBitmap;View: TTrainmanView);overload;
    class procedure Draw(Bitmap: TBitmap;View: TTrainmanOrderView);overload;
    class procedure Draw(Bitmap: TBitmap;View: TTogetherTrainView);overload;
    class procedure Draw(Bitmap: TBitmap;View: TOrderGroupView);overload;
    class procedure Draw(Bitmap: TBitmap;View: TOrderGroupInTrainView);overload;
    class procedure Draw(Bitmap: TBitmap;View: TNamedGroupView);overload;
  end;


var
_SupportClass: TList;  
function SupportClass(AClass: TClass): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to _SupportClass.Count - 1 do
  begin
    Result := _SupportClass[i] = AClass;
    if Result then Break;
  end;
end;
{$R *.dfm}

procedure TFramePlateQueue.AddView(View: TView);
var
  I: Integer;
begin
  if not SupportClass(View.ClassType) then Exit;

  if TNullViewChecker.IsNull(View) then Exit;

  for I := 0 to lstBox.Items.Count - 1 do
  begin
    if lstBox.Items.Objects[i] = View then
    begin
      Exit;
    end;
  end;

  lstBox.Items.AddObject(View.Desp,View);
  lstBox.ItemIndex := lstBox.Items.Count - 1;  
end;

procedure TFramePlateQueue.BindScrollView(ScrollView: TScrollView);
begin
  if m_ScrollView <> nil then
  begin
    m_ScrollView.OnDblView := nil;
    m_ScrollView.OnDropComplete := nil;
    m_ScrollView.OnClickView := nil;
  end;


  m_ScrollView := ScrollView;

  if m_ScrollView <> nil then
  begin
    m_ScrollView.OnDblView := OnDblView;
    m_ScrollView.OnDropComplete := ScrollViewDropComplete;
    m_ScrollView.OnClickView := OnClickView;
  end;
end;

procedure TFramePlateQueue.ClearQueue;
begin
  lstBox.Clear;
end;

procedure TFramePlateQueue.lstBoxClick(Sender: TObject);
begin
  if lstBox.ItemIndex < 0 then Exit;
  if m_ScrollView = nil then Exit;


  m_ScrollView.Selected := TView(lstBox.Items.Objects[lstBox.ItemIndex]);
//  m_ScrollView.MakeVisible(TView(lstBox.Items.Objects[lstBox.ItemIndex]));
end;

procedure TFramePlateQueue.lstBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if (Source as TScrollView).Selected = nil then Exit;
  
  with (Source as TScrollView) do
  begin
    AddView(Selected);
  end;

end;

procedure TFramePlateQueue.lstBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TScrollView;
end;




procedure TFramePlateQueue.lstBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  r: TRect;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Rect.Right - Rect.Left;
    Bitmap.Height := Rect.Bottom - Rect.Top;
    r := Bitmap.Canvas.ClipRect;

    //绘制背景
    if odSelected in State then
    begin
      Bitmap.Canvas.Brush.Color := clHighlight;
      Bitmap.Canvas.Font.Color := clHighlightText;
      Bitmap.Canvas.Pen.Color := clHighlightText;
    end
    else
    begin
      Bitmap.Canvas.Brush.Color := clWindow;
      Bitmap.Canvas.Font.Color := clBlack;
      Bitmap.Canvas.Pen.Color := clBlack;
    end;
    Bitmap.Canvas.FillRect(r);


    with TRzListBox(Control).Items do
    begin
      if Objects[Index] is TTrainmanView then
        TViewPainter.Draw(Bitmap,Objects[Index] as TTrainmanView)
      else
      if Objects[Index] is TTrainmanOrderView then
        TViewPainter.Draw(Bitmap,Objects[Index] as TTrainmanOrderView)
      else
      if Objects[Index] is TTogetherTrainView then
        TViewPainter.Draw(Bitmap,Objects[Index] as TTogetherTrainView)
      else
      if Objects[Index] is TOrderGroupView then
        TViewPainter.Draw(Bitmap,Objects[Index] as TOrderGroupView)
      else
      if Objects[Index] is TOrderGroupInTrainView then
        TViewPainter.Draw(Bitmap,Objects[Index] as TOrderGroupInTrainView)
      else
      if Objects[Index] is TNamedGroupView then
        TViewPainter.Draw(Bitmap,Objects[Index] as TNamedGroupView);
    end;


    if not (odSelected in State) then
    begin
      Bitmap.Canvas.Pen.Style := psDash;
      Bitmap.Canvas.MoveTo(3,r.Bottom-1);
      Bitmap.Canvas.LineTo(r.Right - 3,r.Bottom-1);

    end;

    TRzListBox(Control).Canvas.Draw(Rect.Left,Rect.Top,Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TFramePlateQueue.lstBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  index: integer;
begin
  if Button = mbRight then
  begin
    index := lstBox.ItemAtPos(Point(x,y),true);
    if index <> -1 then
      lstBox.ItemIndex := index;
  end;
  
end;

procedure TFramePlateQueue.lstBoxStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if lstBox.ItemIndex = -1 then Exit;
  m_ScrollView.DraggingView := TView(lstBox.Items.Objects[lstBox.ItemIndex]);
end;

procedure TFramePlateQueue.N1Click(Sender: TObject);
begin
  lstBox.Clear;
end;

procedure TFramePlateQueue.N2Click(Sender: TObject);
begin
  if lstBox.ItemIndex <> -1 then
  begin
    lstBox.DeleteSelected;
  end;
end;

type TViewClass = class of TView;

procedure TFramePlateQueue.OnClickView(View: TView);
var
  tmView : TTrainmanView;
begin
  if View is TTrainmanView then
  begin
   tmView := (View as TTrainmanView);

    with (View as TTrainmanView) do
    begin
      lblTm.Caption := Format('[%s]%s',[tmView.Trainman.strTrainmanNumber,tmView.Trainman.strTrainmanName]);
      lblDuty.Caption := TRsPostNameAry[tmView.Trainman.nPostID];
        
      if tmView.Trainman.strTelNumber <> '' then
        lblTel.Caption := tmView.Trainman.strTelNumber
      else
        lblTel.Caption := '-';

      if tmView.Trainman.dtLastEndworkTime > IncYear(now,-10) then
        lblEndWorkTime.Caption := FormatDateTime('mm-dd hh:nn',tmView.Trainman.dtLastEndworkTime)
      else
        lblEndWorkTime.Caption := '-';

    end;
  end;
end;

procedure TFramePlateQueue.OnDblView(View: TView);
begin
  AddView(View);
end;

procedure TFramePlateQueue.PopupMenuPopup(Sender: TObject);
begin
  N2.Enabled := lstBox.ItemIndex <> -1;
end;

procedure TFramePlateQueue.ScrollViewDropComplete(src,dest: TView);
begin
  if lstBox.ItemIndex = -1 then Exit;
  if lstBox.Items.Objects[lstBox.ItemIndex] = src then
    lstBox.DeleteSelected;

end;

{ TViewPainter }
class procedure TViewPainter.Draw(Bitmap: TBitmap;View: TTogetherTrainView);
begin
  DrawTitle(Bitmap,'机车');  
end;

class procedure TViewPainter.Draw(Bitmap: TBitmap;View: TTrainmanOrderView);
var
  s: string;
  r: TRect;
begin
  DrawTitle(Bitmap,'人员');

  s := Format('[%s]%s',[View.TmView.Trainman.strTrainmanNumber,View.TmView.Trainman.strTrainmanName]);

  r := Bitmap.Canvas.ClipRect;
  r.Left := r.Left + 35;

  Bitmap.Canvas.TextRect(r,s,[tfVerticalCenter,tfSingleLine]);
end;
class procedure TViewPainter.Draw(Bitmap: TBitmap;View: TTrainmanView);
var
  s: string;
  r: TRect;
begin
  DrawTitle(Bitmap,'人员');

  s := Format('[%s]%s',[View.Trainman.strTrainmanNumber,View.Trainman.strTrainmanName]);

  r := Bitmap.Canvas.ClipRect;
  r.Left := r.Left + 35;

  Bitmap.Canvas.TextRect(r,s,[tfVerticalCenter,tfSingleLine]);
end;

class procedure TViewPainter.Draw(Bitmap: TBitmap;View: TNamedGroupView);
begin
  DrawTitle(Bitmap,'机组');

  DrawTmViews(Bitmap,View.Items);
end;

class procedure TViewPainter.DrawTitle(Bitmap: TBitmap; Title: string);
var
  s: string;
  r: TRect;
begin
  s := Title;
  r := Bitmap.Canvas.ClipRect;
  Bitmap.Canvas.Font.Style := [fsBold];
  Bitmap.Canvas.TextRect(r,s,[tfVerticalCenter,tfSingleLine]);
  Bitmap.Canvas.Font.Style := [];
  Bitmap.Canvas.MoveTo(30,3);
  Bitmap.Canvas.Pen.Style := psDot;

  Bitmap.Canvas.LineTo(30,r.Bottom - 3);
end;

class procedure TViewPainter.DrawTmViews(Bitmap: TBitmap;Views: TViews);
var
  s: string;
  r: TRect;
begin
  DrawTitle(Bitmap,'机组');

  with (Views[0] as TTrainmanView).Trainman do
  begin
    s := Format('[%s]%s',[strTrainmanNumber,strTrainmanName]);
    r := Bitmap.Canvas.ClipRect;
    r.Left := r.Left + 35;
    r.Bottom := r.Bottom div 2;

    Bitmap.Canvas.TextRect(r,s,[tfVerticalCenter,tfSingleLine]);
  end;



  with (Views[1] as TTrainmanView).Trainman do
  begin
    s := Format('[%s]%s',[strTrainmanNumber,strTrainmanName]);
    r := Bitmap.Canvas.ClipRect;
    r.Left := r.Left + 35;
    r.Top := r.Bottom div 2;

    Bitmap.Canvas.TextRect(r,s,[tfVerticalCenter,tfSingleLine]);
  end;


end;

class procedure TViewPainter.Draw(Bitmap: TBitmap;View: TOrderGroupInTrainView);
begin
    DrawTitle(Bitmap,'机组');

  DrawTmViews(Bitmap,View.Items);
end;

class procedure TViewPainter.Draw(Bitmap: TBitmap;View: TOrderGroupView);
begin
  DrawTitle(Bitmap,'机组');

  DrawTmViews(Bitmap,View.Items);
end;



initialization
  _SupportClass := TList.Create;
  _SupportClass.Add(TTrainmanView);
  _SupportClass.Add(TOrderGroupView);
  _SupportClass.Add(TOrderGroupInTrainView);
  _SupportClass.Add(TNamedGroupView);
finalization
  _SupportClass.Free;
end.
