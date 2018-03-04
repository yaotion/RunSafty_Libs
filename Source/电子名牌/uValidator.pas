unit uValidator;

interface
uses
  Classes,
  SysUtils,
  uTrainman,
  uTrainPlan,
  uTrainmanJiaolu,
  uScrollView,
  uNamedGroupView,
  uOrderGroupView,
  uOrderGroupInTrainView,
  uWebApiCollection,
  uSaftyEnum;
type
  //对数据进行验证，需要连接服务器
  TValidator = class
  private
    class var m_Reason: string;
    class function CreateReasonString(const Plan: RRsTrainmanPlan): string;static;
  public
    class function IsBusy(const Grp: RRsGroup): Boolean;overload;
    class function IsBusy(const Tm: RRsTrainman): Boolean;overload;
    class function IsBusy(const Train: RRsTogetherTrain): Boolean;overload;
    class property Reason: string read m_Reason;  
  end;


  //只在本地检查，不连接服务器
  TLocalValidator = class
  private
    class var m_Reason: string;
  public
    class function IsBusy(View: TOrderGroupView): Boolean;overload;
    class function IsBusy(View: TNamedGroupView): Boolean;overload;
    class function IsBusy(View: TOrderGroupInTrainView): Boolean;overload;
    class function IsBusy(const Tm: RRsTrainman): Boolean;overload;
    class function IsBusy(const Grp: RRsGroup): Boolean;overload;
    
    class property Reason: string read m_Reason;
  end;
implementation

{ TPlateValidator }

class function TValidator.IsBusy(const Grp: RRsGroup): Boolean;
var
  Plan : RRsTrainmanPlan;
begin
  Result := false;

  if LCWebAPI.LCNameBoardEx.Group.GetPlan(Grp.strGroupGUID,Plan) then
  begin
    Result := true;
    m_Reason := CreateReasonString(Plan);
  end;

end;


class function TValidator.IsBusy(const Tm: RRsTrainman): Boolean;
var
  Plan : RRsTrainmanPlan;
begin
  Result := false;

  if LCWebAPI.LCNameBoardEx.Trainman.GetPlan(Tm.strTrainmanGUID,Plan) then
  begin
    Result := true;
    m_Reason := CreateReasonString(Plan);
  end;

end;

class function TValidator.IsBusy(const Train: RRsTogetherTrain): Boolean;
var
  Plan : RRsTrainmanPlan;
begin
  Result := false;
  if LCWebAPI.LCNameBoardEx.Together.GetTrainPlan(Train.strTrainGUID,Plan) then
  begin
    Result := true;
    m_Reason := CreateReasonString(Plan);
  end;
end;
class function TValidator.CreateReasonString(
  const Plan: RRsTrainmanPlan): string;
begin
  Result := Format('该人员所在的机组正在值乘计划:%s[%s],不能操作',
      [FormatDateTime('yyyy-MM-dd HH:nn:ss',Plan.TrainPlan.dtStartTime),Plan.TrainPlan.strTrainNo]);
end;


{ TLocalValidator }

class function TLocalValidator.IsBusy(View: TOrderGroupView): Boolean;
begin
  Result := IsBusy(View.OrderGroup.Group);
end;

class function TLocalValidator.IsBusy(View: TOrderGroupInTrainView): Boolean;
begin
  Result := IsBusy(View.OrderGroupInTrain.Group);
end;

class function TLocalValidator.IsBusy(View: TNamedGroupView): Boolean;
begin
  Result := IsBusy(View.NamedGroup.Group);
end;

class function TLocalValidator.IsBusy(const Tm: RRsTrainman): Boolean;
begin
  Result := Tm.nTrainmanState = tsUnRuning;
  if Result then
  begin
    m_Reason := '该人员处于请假状态，请销假后再进行名牌操作!';
  end;
end;

class function TLocalValidator.IsBusy(const Grp: RRsGroup): Boolean;
begin
  Result := Grp.GroupState in [tsPlaning,tsUnRuning];
  if Result then
  begin
    m_Reason := '该机组处于计划或出勤状态，不允许操作名牌!';
  end;
end;

end.
