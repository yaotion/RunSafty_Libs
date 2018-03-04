unit uTrainmanOrderView;  //Ԥ����ԱЧ��

interface
uses Windows,uTrainmanView,uScrollView,Graphics,SysUtils,uTrainman,PngImageList,
  uSaftyEnum,uViewDefine;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TrainmanOrderView
  /// ˵��:����Ա��Ϣ,�������
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanOrderView = class(TView)
  public
    constructor Create();
  protected
    procedure DrawContent(Canvas: TCanvas);override;
  public
    Index : Integer;

    function TmView: TTrainmanView;
  end;

implementation

{ TrainmanOrderView }


constructor TTrainmanOrderView.Create();
begin
  inherited;
  Index := 0;
  FWidth := 60;
  FHeight := 135;

  Color := CL_NP_BK_NORMAL;
  Font.Name := '����';
  Font.Size := 10;
  Font.Style := [fsBold];
  Font.Color := NP_FONT_TITLE_NORMAL;

  AutoLocateChilds := False;
  Items.AddView(TTrainmanView.Create);
  Items[0].Margin.SetMargin(0,0,0,0);
  Items[0].Top := 20;
  Items[0].Left := 0;
  Items[0].DragEnable := False;
  Self.DragEnable := False;

end;


procedure TTrainmanOrderView.DrawContent(Canvas: TCanvas);
var
  strText : String;
begin
  Items[0].Font.Color := Font.Color; 
  Canvas.Font.Color := Font.Color;
  Canvas.Pen.Color := NP_FONT_TITLE_NORMAL;
  strText := IntToStr(Index);
  Canvas.TextOut((width - Canvas.TextWidth(strText)) div 2,6,strText);
end;



function TTrainmanOrderView.TmView: TTrainmanView;
begin
  Result := Items[0] as TTrainmanView;
end;

end.

