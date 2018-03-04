unit uOrderGroupInTrainView; //���˻����ڵĻ���

interface
uses Windows,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,Contnrs,uViewDefine,
    uScrollView ,uOrderGroupView;

Type 
  /////////////////////////////////////////////////////
  /// ����:TOrderGroupInTrainView
  /// ˵��:��������Ϣ
  /////////////////////////////////////////////////////
  TOrderGroupInTrainView = class(TOrderGroupView)
  private
    m_OrderGroupInTrain : RRsOrderGroupInTrain;
    {����:�����ֳ���Ϣ}
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
