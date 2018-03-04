unit uFrameNWQ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameNamePlate,uTrainman, ExtCtrls, RzPanel,Menus,uScrollView,uViewGroup;

type
  TFrameNWQ = class(TFrameNamePlate)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function Search(Tm: PTm): Boolean;override;
    procedure RefreshViews();override;
    procedure ExportPlates(const FileName: string);override;
  end;

implementation
uses
  uGlobal,
  uWebApiCollection,
  uTrainmanView,
  uNamePlatesExporter;
{$R *.dfm}

{ TFrameUnrun }

constructor TFrameNWQ.Create(AOwner: TComponent);
begin
  inherited;
  m_ScrollView.DragEnable := False;
end;

procedure TFrameNWQ.ExportPlates(const FileName: string);
begin
  inherited;

end;

procedure TFrameNWQ.RefreshViews;
var
  TmArray: TRsTrainmanLeaveArray;
  View: TViewGroup;
  TmView: TTrainmanView;
  I: Integer;
  jlid: string;
  function GetViewGrp(LeaveType: string): TViewGroup;
  var
    i: integer;
  begin
    if LeaveType = '' then
      LeaveType := '������';
      
    Result := nil;
    for I := 0 to m_ScrollView.Views.Count - 1 do
    begin
      if (m_ScrollView.Views[i] as TViewGroup).Title.Caption = LeaveType then
      begin
        Result := m_ScrollView.Views[i] as TViewGroup;
        Break;
      end;
    end;

    if Result = nil then
    begin
      Result := TViewGroup.Create;
      Result.Color := $0057544F;
      Result.BorderColor := $00CECEC6;
      Result.Title.Caption := LeaveType;
      Result.Title.Font.Size := 12;
      Result.Title.Font.Style := [fsBold];
      Result.Title.Color := $0087827A; 
      Result.Margin.Top := 0;
      Result.Margin.Bottom := 1;

      m_ScrollView.Views.AddView(Result);
    end;
  end;
begin
  //LCWebAPI.LCNameBoardEx.Trainman.GetPersion(GlobalDM.WorkShop.ID,PostID,TmArray);

  m_ScrollView.Views.BeginUpdate;
  try
    m_ScrollView.Views.Clear;
    for I := 0 to Length(TmArray) - 1 do
    begin
      View := GetViewGrp(TmArray[i].strLeaveTypeName);
      TmView := TTrainmanView.Create;
      TmView.Trainman := TmArray[i].Trainman;
      TMView.LeaveAlart := false;
      if (TMArray[i].dEndTime > StrToDateTime('2001-01-01')) then
      begin
        if (TmArray[i].dEndTime < Now ) then
        begin
          TMView.LeaveAlart := true;
        end;
      end;
      
      View.Items.AddView(TmView)
    end;
    
  finally
    m_ScrollView.Views.EndUpdate;
  end;
end;

function TFrameNWQ.Search(Tm: PTm): Boolean;
begin

end;

end.
