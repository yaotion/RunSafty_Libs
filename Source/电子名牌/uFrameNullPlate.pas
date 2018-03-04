unit uFrameNullPlate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameNamePlate,uTrainman, ExtCtrls, RzPanel,uScrollView,Menus;

type
  TMenuActions = class;

  TFrameNullPlate = class(TFrameNamePlate)
    PopupMenu_View: TPopupMenu;
    procedure PopupMenu_ViewPopup(Sender: TObject);
  private
    { Private declarations }
     m_MenuActions: TMenuActions;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function Search(Tm: PTm): Boolean;override;
    procedure RefreshViews();override;
    procedure ExportPlates(const FileName: string);override;
 protected
    procedure OnDragViewOver(src,dest: TView;var Accept: Boolean);override;
    procedure OnDropMode(src,dest: TView;X,Y: integer;var Mode: TDropMode);override;
  end;

  TMenuActions = class(TComponent)
  public
    constructor NewCreate(Frame: TFrameNullPlate);
  protected
    m_Frame: TFrameNullPlate;
  public
    procedure ViewTM(Sender: TObject);
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);
  end;

implementation
uses uGlobal,
uWebApiCollection,
uTrainmanView,
uTrainmanOrderView,
uViewGroup,
uNamePlatesExporter,uFrmTrainmanDetail;
{$R *.dfm}

{ TFrameNullPlate }

constructor TFrameNullPlate.Create(AOwner: TComponent);
begin
  inherited;
  m_ScrollView.DragEnable := False;
  m_MenuActions := TMenuActions.NewCreate(self);
  m_ScrollView.ViewPopMenue := PopupMenu_View;
end;

procedure TFrameNullPlate.ExportPlates(const FileName: string);
var
  NpTmList: TNpTmList;
  I: Integer;
  NpTm: TNpTm;
begin
  NpTmList := TNpTmList.Create;
  try
    for I := 0 to m_ScrollView.Views.Count - 1 do
    begin
      NpTm := TNpTm.Create;
      NpTm.Name :=
      (m_ScrollView.Views[i] as TTrainmanOrderView).TmView.Trainman.strTrainmanName;

      NpTm.Number :=
      (m_ScrollView.Views[i] as TTrainmanOrderView).TmView.Trainman.strTrainmanNumber;

      NpTmList.Add(NpTm);
    end;
    TNamePlatesExport.ExportPlates(FileName,NpTmList);
  finally
    NpTmList.Free;
  end;
end;


procedure TFrameNullPlate.OnDragViewOver(src, dest: TView; var Accept: Boolean);
begin
  inherited;
  accept := false;
end;

procedure TFrameNullPlate.OnDropMode(src, dest: TView; X, Y: integer;
  var Mode: TDropMode);
begin
  inherited;

end;

procedure TFrameNullPlate.PopupMenu_ViewPopup(Sender: TObject);
begin
  if m_ScrollView.PopupView is TTrainmanView then
    m_MenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View)
end;

procedure TFrameNullPlate.RefreshViews;
var
  TmArray: TRsTrainmanArray;
  i: integer;
  View: TTrainmanOrderView;
begin
  LCWebAPI.LCNameBoardEx.Trainman.GetNullState(GlobalDM.WorkShop.ID,'',TmArray);

  m_ScrollView.Views.BeginUpdate;
  try
    m_ScrollView.Views.Clear;
    for i := 0 to length(TmArray) - 1 do
    begin
      View := TTrainmanOrderView.Create();
      (View.Items[0] as TTrainmanView).Trainman := TmArray[i];;
      View.Index := i + 1;
      m_ScrollView.Views.AddView(View);
    end;
  finally
    m_ScrollView.Views.EndUpdate;
  end;
end;

function TFrameNullPlate.Search(Tm: PTm): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_ScrollView.Views.Count - 1 do
  begin
    if TTrainmanView(m_ScrollView.Views[i].Items[0]).Trainman.strTrainmanNumber = Tm.strTrainmanNumber then
    begin
      m_ScrollView.MakeVisible(m_ScrollView.Views[i].Items[0],true);
      Result := True;
      Exit;
    end;
  end;
end;

{ TTmMenuActions }

procedure TMenuActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;
  if View is TTrainmanView then
  begin
    with View as TTrainmanView do
    begin
      AddMenuItem('��Ա��Ϣ',ViewTM,PopMenu);
    end;
  end;
end;

constructor TMenuActions.NewCreate(Frame: TFrameNullPlate);
begin
  inherited Create(Frame);
  m_Frame := Frame;
end;

procedure TMenuActions.ViewTM(Sender: TObject);
var
  TMView : TTrainmanView;
begin
  with m_Frame.m_ScrollView do
  begin
    if PopupView is TTrainmanView then
    begin
      TMView := (PopupView as TTrainmanView);
      if (TMView.Trainman.strTrainmanNumber <> '') then
      begin
        TfrmTrainmanDetail.ViewTrainmanDetail(TMVIEW.Trainman.strTrainmanGUID)
      end;
    end;
  end;
end;

end.
