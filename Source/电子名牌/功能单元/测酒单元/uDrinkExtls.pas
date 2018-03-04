unit uDrinkExtls;

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
   //测酒信息
  RRsDrinkInfo = record
    //测酒记录GUID
    strGUID:string ;
    //测酒记录ID
    nDrinkInfoID : integer;
    //乘务员GUID
    strTrainmanGUID : string;
    //乘务员工号
    strTrainmanNumber : string;    
    //乘务员姓名
    strTrainmanName: string;
    //测酒结果
    nDrinkResult : integer;
    //测酒时间
    dtCreateTime : TDateTime;
    //识别方式
    nVerifyID : integer;
    //值班员工号
    strDutyNumber : string;
    //测酒类型ID
    nWorkTypeID : integer;
    //测酒照片，不空nil时，有照片
    DrinkImage : OleVariant;
    strPictureURL: string;
    nDelFlag: integer;

    //酒精度(mg/100ml)
    dwAlcoholicity : Integer ;
     //机车类型
    strTrainTypeName : string;
    //机车号
    strTrainNumber : string;
    {车次}
    strTrainNo : String;

  end;
implementation

end.
