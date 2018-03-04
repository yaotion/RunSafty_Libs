unit uFrameTxGrp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameNamePlate,uTrainmanJiaolu,uScrollView, Menus,uTFSystem,
  uLCNameBoardEx,uTrainmanView,uOrderGroupView,uWebApiCollection, ExtCtrls,
  RzPanel;

type
  TMenuActions = class;

  TFrameTxGrp = class(TFrameNamePlate)
    PopupMenu_View: TPopupMenu;
    procedure PopupMenu_ViewPopup(Sender: TObject);
  private
    { Private declarations }
    m_MenuActions: TMenuActions;
  protected
    procedure OnDragViewOver(src,dest: TView;var Accept: Boolean);override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function Search(Tm: PTm): Boolean;override;
    procedure RefreshViews();override;
    procedure ExportPlates(const FileName: string);override;
  end;


  TMenuActions = class(TComponent)
  public
    constructor NewCreate(Frame: TFrameTxGrp);
    destructor Destroy;override;
  protected
    m_Frame: TFrameTxGrp;

    m_InputJl: TRsLCBoardInputJL;

    m_InputDuty: TRsLCBoardInputDuty;
    procedure ReOrderGrps();
  public
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);virtual;
    procedure EndTx(Sender: TObject);
  end;



implementation

uses
  uTrainman,
  uDialogsLib,
  uSaftyEnum,
  DateUtils,
  uGlobal,
  uNamePlatesExporter,
  uViewGroup;



{$R *.dfm}

{ TFrameTxGrp }

constructor TFrameTxGrp.Create(AOwner: TComponent);
begin
  inherited;
  m_ScrollView.ViewPopMenue := PopupMenu_View;
  m_MenuActions := TMenuActions.NewCreate(self);
end;

procedure TFrameTxGrp.ExportPlates(const FileName: string);
var
  LessThanOneDay, MoreThanOneDay: TNpOrderList;
  NpOrder: TNpOrder;
  procedure ViewsToOrderLst(Views: TViews;NpList: TNpOrderList);
  var
    i: integer;
    OrderGroup: RRsOrderGroup;
  begin
    for I := 0 to Views.Count - 1 do
    begin
      OrderGroup := (Views[i] as TOrderGroupView).OrderGroup;

      NpOrder := TNpOrder.Create;
      NpList.Add(NpOrder);

      NpOrder.Grp.Tm1.Number := OrderGroup.Group.Trainman1.strTrainmanNumber;
      NpOrder.Grp.Tm1.Name := OrderGroup.Group.Trainman1.strTrainmanName;
      NpOrder.Grp.Tm2.Number := OrderGroup.Group.Trainman2.strTrainmanNumber;
      NpOrder.Grp.Tm2.Name := OrderGroup.Group.Trainman2.strTrainmanName;
      NpOrder.Grp.Tm3.Number := OrderGroup.Group.Trainman3.strTrainmanNumber;
      NpOrder.Grp.Tm3.Name := OrderGroup.Group.Trainman3.strTrainmanName;
    end;
  end;
begin
  LessThanOneDay := TNpOrderList.Create;
  MoreThanOneDay := TNpOrderList.Create;
  try

    ViewsToOrderLst(m_ScrollView.Views[0].Items,LessThanOneDay);
    ViewsToOrderLst(m_ScrollView.Views[1].Items,MoreThanOneDay);

    
    TNamePlatesExport.ExportPlates(FileName,TmJl.Name,LessThanOneDay,MoreThanOneDay);
  finally
    LessThanOneDay.Free;
    MoreThanOneDay.Free;
  end;
end;

procedure TFrameTxGrp.OnDragViewOver(src, dest: TView; var Accept: Boolean);
begin
  Accept := False;
end;



procedure TFrameTxGrp.PopupMenu_ViewPopup(Sender: TObject);
begin
  if m_ScrollView.PopupView is TOrderGroupView then
    m_MenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View);
end;

procedure TFrameTxGrp.RefreshViews;
var
  GrpArray: TRsGroupArray;
  OrderGroup: RRsOrderGroup;
  View: TOrderGroupView;
  ViewGrp1, ViewGrp2: TViewGroup;
  I: Integer;

  function CreateViewGrp(Caption: string): TViewGroup;
  begin
    Result := TViewGroup.Create;
    Result.Color := $0057544F;
    Result.BorderColor := $00CECEC6;
    Result.Title.Caption := Caption;
    Result.Title.Font.Size := 12;
    Result.Title.Font.Style := [fsBold];
    Result.Title.Color := $0087827A;
    Result.Margin.Top := 0;
    Result.Margin.Bottom := 1;
  end;
begin
  LCWebAPI.LCNameBoardEx.Group.GroupTX.Get(m_TmJl.ID,GrpArray);

  m_ScrollView.Views.BeginUpdate;
  try
    m_ScrollView.Views.Clear;
    ViewGrp1 := CreateViewGrp('持续1天');
    ViewGrp2 := CreateViewGrp('持续2天'); 
    m_ScrollView.Views.AddView(ViewGrp1);
    m_ScrollView.Views.AddView(ViewGrp2);
    
    for i := 0 to length(GrpArray) - 1 do
    begin
      OrderGroup.Group := GrpArray[i];

      OrderGroup.nOrder := 0;
      View := TOrderGroupView.Create();
      View.OrderGroup := OrderGroup;

      if GrpArray[i].dtTXBeginTime > StartOfTheDay(Now) then
      begin
        ViewGrp1.Items.AddView(View);
      end
      else
      begin
        ViewGrp2.Items.AddView(View);      
      end;
    end;
  finally
    m_ScrollView.Views.EndUpdate;
  end;

end;


function TFrameTxGrp.Search(Tm: PTm): Boolean;
var
  i,j,k: Integer;
begin
  Result := False;
  for i := 0 to m_ScrollView.Views.Count - 1 do
  begin
    if m_ScrollView.Views[i] is TViewGroup then
    begin
      for j := 0 to m_ScrollView.Views[i].Items.Count - 1 do
      begin
        for k := 0 to m_ScrollView.Views[i].Items[j].Items.Count - 1 do
        begin
          if (m_ScrollView.Views[i].Items[j].Items[k] as TTrainmanView).Trainman.strTrainmanNumber = Tm.strTrainmanNumber then
          begin
            Result := True;
            m_ScrollView.MakeVisible(m_ScrollView.Views[i].Items[j],true);
            Exit;
          end;
        end;

      end;
    end;
  end;

end;

{ TShareActions }
destructor TMenuActions.Destroy;
begin
  m_InputJl.Free;
  m_InputDuty.Free;
  inherited;
end;

constructor TMenuActions.NewCreate(Frame: TFrameTxGrp);
begin
  Inherited Create(Frame);
  m_InputJl := TRsLCBoardInputJL.Create;
  m_InputDuty := TRsLCBoardInputDuty.Create;  
  m_Frame := Frame;
end;




procedure TMenuActions.ReOrderGrps;
var
  I,J: Integer;
begin
  with m_Frame.m_ScrollView do
  begin
    Views.BeginUpdate;


    for I := 0 to Views.Count - 1 do
    begin
      for J := 0 to Views[i].Items.Count - 1 do
      begin
        (Views[i].Items[j] as TOrderGroupView).SetOrder(j + 1);
      end;
    end;

    Invalidate;
    
    Views.EndUpdate;
  end;

end;

procedure TMenuActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;

  with View as TOrderGroupView do
  begin
    AddMenuItem('结束调休',EndTx,PopMenu);
  end;
end;

procedure TMenuActions.EndTx(Sender: TObject);
var
  View: TOrderGroupView;
begin
  m_Frame.DoFillParam(m_InputJl,m_InputDuty);
  
  with m_Frame.m_ScrollView do
  begin
    View := PopupView as TOrderGroupView;

    LCWebAPI.LCNameBoardEx.Group.GroupTX.Del(m_InputJL,m_InputDuty,View.OrderGroup.Group.strGroupGUID);

    PopupView.Owner.Remove(PopupView);
  end;


  ReOrderGrps();
end;




end.
