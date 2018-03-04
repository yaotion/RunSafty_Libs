unit uOrderGroupInTrainView; //包乘机车内的机组

interface
uses Windows,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,Contnrs,uViewDefine,
    uScrollView ,uOrderGroupView;

Type 
  /////////////////////////////////////////////////////
  /// 类名:TOrderGroupInTrainView
  /// 说明:包乘组信息
  /////////////////////////////////////////////////////
  TOrderGroupInTrainView = class(TOrderGroupView)
  private
    m_OrderGroupInTrain : RRsOrderGroupInTrain;
    {功能:设置轮乘信息}
    procedure SetOrderGroupInTrain(AOrderGroupInTrain : RRsOrderGroupInTrain);
  public
    property OrderGroupInTrain : RRsOrderGroupInTrain read m_OrderGroupInTrain write SetOrderGroupInTrain;
  end;

implementation

{ TOrderGroupView }
procedure TOrderGroupInTrainView.SetOrderGroupInTrain(AOrderGroupInTrain: RRsOrderGroupInTrain);
begin
  m_OrderGroupInTrain := AOrderGroupInTrain;
  m_OrderGroup.nOrder := m_OrderGroupInTrain.nOrder;
  m_OrderGroup.Group := m_OrderGroupInTrain.Group;
  SetOrderGroup(m_OrderGroup);
end;

end.
