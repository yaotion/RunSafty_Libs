unit uTemplateDayPlan;

interface

uses
  SysUtils,Contnrs,uSaftyEnum ;
type


  TDayPlanType = (dptDay=0,dptNight=1,dtpAll);  //白班，夜班,全天

  //机车计划 -项
  TRsDayPlanItem = class
  public
     constructor Create();
     destructor Destroy();override;
  public
    procedure CopyFrom(DayPlanItem:TRsDayPlanItem) ;
  private
    m_nID :Integer;
    m_nDayPlanType : TDayPlanType ;  //属于白班还是夜班
    m_strTrainNo1:string;   //车次1
    m_strTrainInfo:string;    //机车信息****
    m_strTrainNo2 :string;   //车次2
    m_strTrainNo:string;    //派班车次
    m_strRemark :string;    //备注
    m_bIsTomorrow :Integer;  //是否是次日

    //打温专用
    m_strDaWenCheXing : string ;   //车型
    m_strDaWenCheHao1 : string ;      //车号1
    m_strDaWenCheHao2 : string ;    //车号 2
    m_strDaWenCheHao3 : string ;    //车号 3
    //打温专用

    m_nGroupID :Integer;     //机组ID
  public
    property ID :Integer  read m_nID write m_nID;
    property DayPlanType:TDayPlanType read  m_nDayPlanType write m_nDayPlanType ;
    property TrainNo1:string  read m_strTrainNo1 write m_strTrainNo1;
    property TrainInfo:string  read m_strTrainInfo write m_strTrainInfo;
    property TrainNo2 :string  read m_strTrainNo2 write m_strTrainNo2;
    property TrainNo :string  read m_strTrainNo write m_strTrainNo;
    property Remark :string  read m_strRemark write m_strRemark;
    property IsTomorrow :Integer  read m_bIsTomorrow write m_bIsTomorrow;
    //打温
    property DaWenCheXing:string  read m_strDaWenCheXing write m_strDaWenCheXing;
    property DaWenCheHao1:string  read m_strDaWenCheHao1 write m_strDaWenCheHao1;
    property DaWenCheHao2 :string  read m_strDaWenCheHao2 write m_strDaWenCheHao2;
    property DaWenCheHao3 :string  read m_strDaWenCheHao3 write m_strDaWenCheHao3;

    property GroupID :Integer  read m_nGroupID write m_nGroupID;
  end;

  TRsDayPlanItemList = class(TObjectList)
  public
    function GetItem(Index: Integer): TRsDayPlanItem;
    procedure SetItem(Index: Integer; AObject: TRsDayPlanItem);
    function Add(AObject: TRsDayPlanItem): Integer;
  public
    property Items[Index: Integer]: TRsDayPlanItem read GetItem write SetItem;
  end;

  //真实的计划信息
  RsDayPlanInfo = record
    strDayPlanGUID:string;  //计划ID
    nPlanState : TRsPlanState; //计划状态
    dtBeginTime:TDateTime;  //开始时间
    dtEndTime:TDateTime;    //结束时间
    dtCreateTime:TDateTime;  //产生事件
    strTrainNo1:string;     //车次1
    strTrainInfo:string;    //机车信息
    strTrainNo2:string;      //车次2
    strTrainNo:string;      //真正的车次信息
    strTrainTypeName:string; //车型
    strTrainNumber:string;  //车号
    nid:Integer;            //
    bIsTomorrow :Integer;  //是否是次日
    strRemark:string;       //备注
    bIsSend : Integer;      //是否已经下发

    //打温专用
    strDaWenCheXing:string;
    strDaWenCheHao1:string;
    strDaWenCheHao2:string;
    strDaWenCheHao3:string;


    nDayPlanID:Integer;       //对应的调度台
    nQuDuanID:Integer;        //区段信息
    nPlanID:Integer;          //对应的那条计划
    strTrainPlanGUID:string;  //对应的机车计划
  end;

  RsDayPlanInfoArray = array of RsDayPlanInfo ;


    //日志LOG
  RsDayPlanLog = record
    strLogGUID:string;
    strlogType:string;      //计划类型
    strDayPlanGUID:string;  //计划ID
    strTrainNo1:string;     //车次1
    strTrainInfo:string;    //机车信息
    strTrainNo2:string;      //车次2
    strRemark:string;       //备注
    dtChangeTime:TDateTime; //

  end;

  RsDayPlanLogArray = array of RsDayPlanLog ;



  //组信息
  TRsDayPlanItemGroup = class
  public
     constructor Create();
     destructor Destroy();override;
  public
    procedure CopyFrom(DayPlanItemGroup:TRsDayPlanItemGroup) ;
  private
    m_nID:Integer;         //id
    m_strName:string;       //名字
    m_bIsDaWen : Integer;   //是否打温
    m_nDayPlanID:Integer;   //所属车间
    m_nExcelSide:Integer;    //在EXCEL那边 左右
    m_nExcelPos:Integer;    //EXCEL位置
  public
    ItemList : TRsDayPlanItemList ;  //包含的ITEM
  public
    property ID :Integer  read m_nID write m_nID;
    property Name:string  read m_strName write m_strName;
    property IsDaWen : Integer read m_bIsDaWen write m_bIsDaWen ;
    property DayPlanID:Integer  read m_nDayPlanID write m_nDayPlanID;
    property ExcelSide : Integer read m_nExcelSide write m_nExcelSide ;
    property ExcelPos :Integer read  m_nExcelPos write m_nExcelPos ;
  end;


  TRsDayPlanItemGroupList = class(TObjectList)
  public
    function GetItem(Index: Integer): TRsDayPlanItemGroup;
    procedure SetItem(Index: Integer; AObject: TRsDayPlanItemGroup);
    function Add(AObject: TRsDayPlanItemGroup): Integer;
  public
    property Items[Index: Integer]: TRsDayPlanItemGroup read GetItem write SetItem;
  end;



  //机车计划结构体
  TRsDayPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    m_nID:Integer;        //ID
    m_strName:string ;   //名字
  public
    GoupList : TRsDayPlanItemGroupList ;  //包含的ITEM
  public
    property ID:Integer  read m_nID write m_nID;
    property Name:string read m_strName write m_strName;
  end;


  TRsDayPlanList = class(TObjectList)
  public
    function GetItem(Index: Integer): TRsDayPlan;
    procedure SetItem(Index: Integer; AObject: TRsDayPlan);
    function Add(AObject: TRsDayPlan): Integer;
  public
    property Items[Index: Integer]: TRsDayPlan read GetItem write SetItem;
  end;


  RRsShortTrain  = record
    nID:Integer;
    strShortName:string;  //缩写
    strLongName:string;    //全写
  end;

  TRsShortTrainArray = array of  RRsShortTrain ;



implementation

{ TRsDayPlan }

constructor TRsDayPlan.Create;
begin
  GoupList := TRsDayPlanItemGroupList.Create ;
end;

destructor TRsDayPlan.Destroy;
begin
  GoupList.Free ;
end;

{ TRsDayPlanItemList }

function TRsDayPlanItemList.Add(AObject: TRsDayPlanItem): Integer;
begin
  Result := inherited Add(AObject)  ;
end;

function TRsDayPlanItemList.GetItem(Index: Integer): TRsDayPlanItem;
begin
  Result := TRsDayPlanItem (inherited GetItem(Index)) ;
end;

procedure TRsDayPlanItemList.SetItem(Index: Integer; AObject: TRsDayPlanItem);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsDayPlanItemGroup }

procedure TRsDayPlanItemGroup.CopyFrom(DayPlanItemGroup: TRsDayPlanItemGroup);
begin
  m_nID :=  DayPlanItemGroup.ID ;
  m_strName := DayPlanItemGroup.Name ;
  m_bIsDaWen := DayPlanItemGroup.IsDaWen;
  m_nDayPlanID := DayPlanItemGroup.DayPlanID ;
  m_nExcelSide := DayPlanItemGroup.ExcelSide ;
  m_nExcelPos := DayPlanItemGroup.ExcelPos ;
end;

constructor TRsDayPlanItemGroup.Create;
begin
  ItemList := TRsDayPlanItemList.Create;
end;

destructor TRsDayPlanItemGroup.Destroy;
begin
  ItemList.Free ;
  inherited;
end;

{ TRsDayPlanItemGroupList }

function TRsDayPlanItemGroupList.Add(AObject: TRsDayPlanItemGroup): Integer;
begin
  Result := inherited Add(AObject)  ;
end;

function TRsDayPlanItemGroupList.GetItem(Index: Integer): TRsDayPlanItemGroup;
begin
  Result := TRsDayPlanItemGroup (inherited GetItem(Index)) ;
end;

procedure TRsDayPlanItemGroupList.SetItem(Index: Integer;
  AObject: TRsDayPlanItemGroup);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsDayPlanItem }

procedure TRsDayPlanItem.CopyFrom(DayPlanItem: TRsDayPlanItem);
begin
  m_nID := DayPlanItem.ID ;
  m_nDayPlanType := DayPlanItem.DayPlanType  ;  //属于白班还是夜班
  m_strTrainNo1:= DayPlanItem.TrainNo1 ;   //车次
  m_strTrainInfo:= DayPlanItem.m_strTrainInfo ;    //机车信息****
  m_strTrainNo2 := DayPlanItem.TrainNo2;   //车次
  m_strRemark := DayPlanItem.Remark ;    //备注
  m_bIsTomorrow := DayPlanItem.IsTomorrow;  //是否是次日
  m_nGroupID := DayPlanItem.GroupID;     //机组ID

  //打温专用
  m_strDaWenCheXing := DayPlanItem.DaWenCheXing ;
  m_strDaWenCheHao1 := DayPlanItem.DaWenCheHao1 ;
  m_strDaWenCheHao2 := DayPlanItem.DaWenCheHao2 ;
  m_strDaWenCheHao3 := DayPlanItem.DaWenCheHao3 ;
end;

constructor TRsDayPlanItem.Create;
begin
  ;
end;

destructor TRsDayPlanItem.Destroy;
begin
  ;
  inherited;
end;

{ TRsDayPlanList }

function TRsDayPlanList.Add(AObject: TRsDayPlan): Integer;
begin
  Result := inherited Add(AObject)  ;
end;

function TRsDayPlanList.GetItem(Index: Integer): TRsDayPlan;
begin
  Result := TRsDayPlan (inherited GetItem(Index)) ;
end;

procedure TRsDayPlanList.SetItem(Index: Integer; AObject: TRsDayPlan);
begin
  inherited SetItem(Index,AObject);
end;

end.
