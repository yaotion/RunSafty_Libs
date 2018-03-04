unit uTemplateDayPlan;

interface

uses
  SysUtils,Contnrs,uSaftyEnum ;
type


  TDayPlanType = (dptDay=0,dptNight=1,dtpAll);  //�װ࣬ҹ��,ȫ��

  //�����ƻ� -��
  TRsDayPlanItem = class
  public
     constructor Create();
     destructor Destroy();override;
  public
    procedure CopyFrom(DayPlanItem:TRsDayPlanItem) ;
  private
    m_nID :Integer;
    m_nDayPlanType : TDayPlanType ;  //���ڰװ໹��ҹ��
    m_strTrainNo1:string;   //����1
    m_strTrainInfo:string;    //������Ϣ****
    m_strTrainNo2 :string;   //����2
    m_strTrainNo:string;    //�ɰ೵��
    m_strRemark :string;    //��ע
    m_bIsTomorrow :Integer;  //�Ƿ��Ǵ���

    //����ר��
    m_strDaWenCheXing : string ;   //����
    m_strDaWenCheHao1 : string ;      //����1
    m_strDaWenCheHao2 : string ;    //���� 2
    m_strDaWenCheHao3 : string ;    //���� 3
    //����ר��

    m_nGroupID :Integer;     //����ID
  public
    property ID :Integer  read m_nID write m_nID;
    property DayPlanType:TDayPlanType read  m_nDayPlanType write m_nDayPlanType ;
    property TrainNo1:string  read m_strTrainNo1 write m_strTrainNo1;
    property TrainInfo:string  read m_strTrainInfo write m_strTrainInfo;
    property TrainNo2 :string  read m_strTrainNo2 write m_strTrainNo2;
    property TrainNo :string  read m_strTrainNo write m_strTrainNo;
    property Remark :string  read m_strRemark write m_strRemark;
    property IsTomorrow :Integer  read m_bIsTomorrow write m_bIsTomorrow;
    //����
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

  //��ʵ�ļƻ���Ϣ
  RsDayPlanInfo = record
    strDayPlanGUID:string;  //�ƻ�ID
    nPlanState : TRsPlanState; //�ƻ�״̬
    dtBeginTime:TDateTime;  //��ʼʱ��
    dtEndTime:TDateTime;    //����ʱ��
    dtCreateTime:TDateTime;  //�����¼�
    strTrainNo1:string;     //����1
    strTrainInfo:string;    //������Ϣ
    strTrainNo2:string;      //����2
    strTrainNo:string;      //�����ĳ�����Ϣ
    strTrainTypeName:string; //����
    strTrainNumber:string;  //����
    nid:Integer;            //
    bIsTomorrow :Integer;  //�Ƿ��Ǵ���
    strRemark:string;       //��ע
    bIsSend : Integer;      //�Ƿ��Ѿ��·�

    //����ר��
    strDaWenCheXing:string;
    strDaWenCheHao1:string;
    strDaWenCheHao2:string;
    strDaWenCheHao3:string;


    nDayPlanID:Integer;       //��Ӧ�ĵ���̨
    nQuDuanID:Integer;        //������Ϣ
    nPlanID:Integer;          //��Ӧ�������ƻ�
    strTrainPlanGUID:string;  //��Ӧ�Ļ����ƻ�
  end;

  RsDayPlanInfoArray = array of RsDayPlanInfo ;


    //��־LOG
  RsDayPlanLog = record
    strLogGUID:string;
    strlogType:string;      //�ƻ�����
    strDayPlanGUID:string;  //�ƻ�ID
    strTrainNo1:string;     //����1
    strTrainInfo:string;    //������Ϣ
    strTrainNo2:string;      //����2
    strRemark:string;       //��ע
    dtChangeTime:TDateTime; //

  end;

  RsDayPlanLogArray = array of RsDayPlanLog ;



  //����Ϣ
  TRsDayPlanItemGroup = class
  public
     constructor Create();
     destructor Destroy();override;
  public
    procedure CopyFrom(DayPlanItemGroup:TRsDayPlanItemGroup) ;
  private
    m_nID:Integer;         //id
    m_strName:string;       //����
    m_bIsDaWen : Integer;   //�Ƿ����
    m_nDayPlanID:Integer;   //��������
    m_nExcelSide:Integer;    //��EXCEL�Ǳ� ����
    m_nExcelPos:Integer;    //EXCELλ��
  public
    ItemList : TRsDayPlanItemList ;  //������ITEM
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



  //�����ƻ��ṹ��
  TRsDayPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    m_nID:Integer;        //ID
    m_strName:string ;   //����
  public
    GoupList : TRsDayPlanItemGroupList ;  //������ITEM
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
    strShortName:string;  //��д
    strLongName:string;    //ȫд
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
  m_nDayPlanType := DayPlanItem.DayPlanType  ;  //���ڰװ໹��ҹ��
  m_strTrainNo1:= DayPlanItem.TrainNo1 ;   //����
  m_strTrainInfo:= DayPlanItem.m_strTrainInfo ;    //������Ϣ****
  m_strTrainNo2 := DayPlanItem.TrainNo2;   //����
  m_strRemark := DayPlanItem.Remark ;    //��ע
  m_bIsTomorrow := DayPlanItem.IsTomorrow;  //�Ƿ��Ǵ���
  m_nGroupID := DayPlanItem.GroupID;     //����ID

  //����ר��
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
