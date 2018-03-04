unit uDrink;

interface
type
  //测酒信息查询条件
  RRsDrinkQuery = record
    //测酒类型ID
    nWorkTypeID : integer;   
    //乘务员工号
    strTrainmanNumber : string;
    //测酒时间-开始
    dtBeginTime : TDateTime;   
    //测酒时间-结束
    dtEndTime : TDateTime;
  end;
implementation

end.
