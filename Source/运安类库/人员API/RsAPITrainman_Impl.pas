unit RsAPITrainman_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Classes,ComObj, ActiveX,  StdVcl,RsUtilsLib_TLB,RsAPITrainmanLib_TLB,SuperObject;

type
  TRsAPITrainman = class(TAutoObject, IRsAPITrainman)
  private
    m_WebAPI : IWebAPI;
  private
    function RsQueryTrainmanToJson(const QueryTrainman: RRsQueryTrainman): ISuperObject;
    procedure JsonToTrainman(Trainman : IRsTrainman ;ijson: ISuperObject);
  protected
    function Get_WebAPI: IDispatch; safecall;
    procedure Set_WebAPI(const Value: IDispatch); safecall;
    procedure QueryTrainmans_blobFlag(QueryTrainman: RRsQueryTrainman;
      PageIndex: Integer; out TrainmanArray: IRsTrainmanArray;
      out nTotalCount: Integer); safecall;
    procedure DeleteTrainman(const TrainmanGUID: WideString); safecall;
    function GetTrainman(const TrainmanGUID: WideString; Option: Integer;
      out Trainman: IRsTrainman): WordBool; safecall;
    function GetTrainmanByNumber(const TrainmanNumber: WideString; Option: Integer;
      var Trainman: IRsTrainman): WordBool; safecall;
    function ExistNumber(const TrainmanGUID, TrainmanNumber: WideString): WordBool;
      safecall;
    procedure AddTrainman(const Trainman: IRsTrainman); safecall;
    procedure UpdateTrainmanTel(const TrainmanGUID, TrainmanTel, TrainmanMobile,
      TrainmanAddress, TrainmanBrief: WideString); safecall;
    function GetPopupTrainmans(const WorkShopGUID, KeyName: WideString;
      PageIndex: Integer; out TrainmanArray: IRsTrainmanArray): Integer;
      safecall;
  end;
  TRsTrainmanArray = class(TAutoObject, IRsTrainmanArray)
  protected
    procedure Add(const Trainman: IRsTrainman); safecall;
    function Get_Count: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure GetItem(Index: Integer; out Result: IRsTrainman); safecall;
  private
    m_Trainmans : IInterfaceList;
  public
    procedure Initialize; override;
  end;
  TRsTrainman = class(TAutoObject, IRsTrainman)
  protected
    function Get_bIsKey: Integer; safecall;
    function Get_dtCreateTime: TDateTime; safecall;
    function Get_dtJiuZhiTime: TDateTime; safecall;
    function Get_dtLastEndworkTime: TDateTime; safecall;
    function Get_dtLastInRoomTime: TDateTime; safecall;
    function Get_dtLastOutRoomTime: TDateTime; safecall;
    function Get_dtRuZhiTime: TDateTime; safecall;
    function Get_eFixGroupType: TFixedGroupType; safecall;
    function Get_FingerPrint1: OleVariant; safecall;
    function Get_FingerPrint2: OleVariant; safecall;
    function Get_nCallWorkState: TRsCallWorkState; safecall;
    function Get_nDriverLevel: Integer; safecall;
    function Get_nDriverType: TRsDriverType; safecall;
    function Get_nFingerPrint1_Null: Integer; safecall;
    function Get_nFingerPrint2_Null: Integer; safecall;
    function Get_nFixedGroupIndex: Integer; safecall;
    function Get_nID: Integer; safecall;
    function Get_nKeHuoID: TRsKehuo; safecall;
    function Get_nPicture_Null: Integer; safecall;
    function Get_nPostID: TRsPost; safecall;
    function Get_nTrainmanState: TRsTrainmanState; safecall;
    function Get_Picture: OleVariant; safecall;
    function Get_strABCD: WideString; safecall;
    function Get_strAdddress: WideString; safecall;
    function Get_strAreaGUID: WideString; safecall;
    function Get_strCallWorkGUID: WideString; safecall;
    function Get_strDriverTypeName: WideString; safecall;
    function Get_strFixedGroupGUID: WideString; safecall;
    function Get_strFixedGroupName: WideString; safecall;
    function Get_strGuideGroupGUID: WideString; safecall;
    function Get_strGuideGroupName: WideString; safecall;
    function Get_strJP: WideString; safecall;
    function Get_strKeHuoName: WideString; safecall;
    function Get_strMobileNumber: WideString; safecall;
    function Get_strPostName: WideString; safecall;
    function Get_strRemark: WideString; safecall;
    function Get_strTelNumber: WideString; safecall;
    function Get_strTrainJiaoluGUID: WideString; safecall;
    function Get_strTrainJiaoluName: WideString; safecall;
    function Get_strTrainmanGUID: WideString; safecall;
    function Get_strTrainmanJiaoluGUID: WideString; safecall;
    function Get_strTrainmanName: WideString; safecall;
    function Get_strTrainmanNumber: WideString; safecall;
    function Get_strWorkShopGUID: WideString; safecall;
    function Get_strWorkShopName: WideString; safecall;
    procedure AssignTo(const Trainman: IRsTrainman); safecall;
    procedure Set_bIsKey(Value: Integer); safecall;
    procedure Set_dtCreateTime(Value: TDateTime); safecall;
    procedure Set_dtJiuZhiTime(Value: TDateTime); safecall;
    procedure Set_dtLastEndworkTime(Value: TDateTime); safecall;
    procedure Set_dtLastInRoomTime(Value: TDateTime); safecall;
    procedure Set_dtLastOutRoomTime(Value: TDateTime); safecall;
    procedure Set_dtRuZhiTime(Value: TDateTime); safecall;
    procedure Set_eFixGroupType(Value: TFixedGroupType); safecall;
    procedure Set_FingerPrint1(Value: OleVariant); safecall;
    procedure Set_FingerPrint2(Value: OleVariant); safecall;
    procedure Set_nCallWorkState(Value: TRsCallWorkState); safecall;
    procedure Set_nDriverLevel(Value: Integer); safecall;
    procedure Set_nDriverType(Value: TRsDriverType); safecall;
    procedure Set_nFingerPrint1_Null(Value: Integer); safecall;
    procedure Set_nFingerPrint2_Null(Value: Integer); safecall;
    procedure Set_nFixedGroupIndex(Value: Integer); safecall;
    procedure Set_nID(Value: Integer); safecall;
    procedure Set_nKeHuoID(Value: TRsKehuo); safecall;
    procedure Set_nPicture_Null(Value: Integer); safecall;
    procedure Set_nPostID(Value: TRsPost); safecall;
    procedure Set_nTrainmanState(Value: TRsTrainmanState); safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    procedure Set_strABCD(const Value: WideString); safecall;
    procedure Set_strAdddress(const Value: WideString); safecall;
    procedure Set_strAreaGUID(const Value: WideString); safecall;
    procedure Set_strCallWorkGUID(const Value: WideString); safecall;
    procedure Set_strDriverTypeName(const Value: WideString); safecall;
    procedure Set_strFixedGroupGUID(const Value: WideString); safecall;
    procedure Set_strFixedGroupName(const Value: WideString); safecall;
    procedure Set_strGuideGroupGUID(const Value: WideString); safecall;
    procedure Set_strGuideGroupName(const Value: WideString); safecall;
    procedure Set_strJP(const Value: WideString); safecall;
    procedure Set_strKeHuoName(const Value: WideString); safecall;
    procedure Set_strMobileNumber(const Value: WideString); safecall;
    procedure Set_strPostName(const Value: WideString); safecall;
    procedure Set_strRemark(const Value: WideString); safecall;
    procedure Set_strTelNumber(const Value: WideString); safecall;
    procedure Set_strTrainJiaoluGUID(const Value: WideString); safecall;
    procedure Set_strTrainJiaoluName(const Value: WideString); safecall;
    procedure Set_strTrainmanGUID(const Value: WideString); safecall;
    procedure Set_strTrainmanJiaoluGUID(const Value: WideString); safecall;
    procedure Set_strTrainmanName(const Value: WideString); safecall;
    procedure Set_strTrainmanNumber(const Value: WideString); safecall;
    procedure Set_strWorkShopGUID(const Value: WideString); safecall;
    procedure Set_strWorkShopName(const Value: WideString); safecall;

  private
    //司机GUID
    strTrainmanGUID: string;
    //司机姓名
    strTrainmanName: string;
    //司机工号
    strTrainmanNumber: string;
    //职位
    nPostID: TRsPost;
    //职位名称
    strPostName : string;
    //所属车间GUID
    strWorkShopGUID : string;
    //所属车间名称
    strWorkShopName  :string;
   {指纹1}
    FingerPrint1 : OleVariant;
     {指纹1空标志,空位0,不空为1}
    nFingerPrint1_Null:Integer;


    {指纹2}
    FingerPrint2 : OleVariant;
    {指纹2空标志,空位0,不空为1}
    nFingerPrint2_Null:Integer;


    //测酒照片
    Picture : OleVariant;
    //照片空标志,空位0,不空为1
    nPicture_Null:Integer;
    
    //指导组GUID
    strGuideGroupGUID : string;
    //指导组名称
    strGuideGroupName : string;
    //联系电话
    strTelNumber: string;
    //手机号
    strMobileNumber : string;
    //家庭住址
    strAdddress  :string;
    //驾驶工种
    nDriverType : TRsDriverType;
    strDriverTypeName:string;
    //叫班状态
    nCallWorkState :TRsCallWorkState ;
    //叫班时间
    strCallWorkGUID:string;
    //关键人(0,1)
    bIsKey : integer;
    //入职日期
    dtRuZhiTime : TDateTime;
    //就职日期
    dtJiuZhiTime : TDateTime;
    //1、2、3
    nDriverLevel : integer;
    //ABCD
    strABCD : string;
    //备注
    strRemark : string;
    //客货ID
    nKeHuoID : TRsKehuo;
    //客货名称
    strKeHuoName : string;
    //所属区段
    strTrainJiaoluGUID : string;
    //所属人员交路
    strTrainmanJiaoluGUID:string;
    //区段名称
    strTrainJiaoluName  :string;
    //最后退勤时间
    dtLastEndworkTime : TDateTime;
    //机务段编号
    strAreaGUID : string ;
    //自增编号
    nID : Integer;
    //创建时间
    dtCreateTime : TDateTime;
    //状态
    nTrainmanState: TRsTrainmanState;
    //姓名简拼
    strJP : string;
    //最后入寓时间
    dtLastInRoomTime:TDateTime ;
    //最后离寓时间
    dtLastOutRoomTime : TDateTime ;

    //固定班guid
    strFixedGroupGUID:string;
    //固定班序号
    nFixedGroupIndex:integer;
    //固定班名称
    strFixedGroupName:string;
    //固定班类型
    eFixGroupType:TFixedGroupType;
  end;

  function CreateInterface(CSIDL : TGUID) : IUnknown;
implementation

uses ComServ,SysUtils;

function CreateInterface(CSIDL : TGUID) : IUnknown;
var
  hr : HRESULT;
  Factory : IClassFactory;
begin
  hr := DllGetClassObject(CSIDL, IClassFactory, Factory);
  if hr <> S_OK then
  begin
    raise exception.Create(Format('查询%s接口失败：%d',[GUIDToString(CSIDL),hr]));
  end;
  try
    hr := Factory.CreateInstance(nil, IUnknown, result);
    if hr<> S_OK then begin
      raise exception.Create(Format('创建对象%s失败：%d',[GUIDToString(CSIDL),hr]));
    end;
  except on e :Exception do
    begin
      raise exception.Create(Format('创建对象%s异常：%s',[GUIDToString(CSIDL),e.Message]));
    end;
  end;
end;


function TRsAPITrainman.Get_WebAPI: IDispatch;
begin
  result := m_WebAPI;
end;

procedure TRsAPITrainman.Set_WebAPI(const Value: IDispatch);
begin
  m_WebAPI := Value as IWebAPI;
end;

procedure TRsAPITrainman.JsonToTrainman(Trainman: IRsTrainman;
  ijson: ISuperObject);
begin
   //司机GUID
  Trainman.strTrainmanGUID := iJson.S['strTrainmanGUID'];
  //司机姓名
  Trainman.strTrainmanName := iJson.S['strTrainmanName'];
  //司机工号
  Trainman.strTrainmanNumber := iJson.S['strTrainmanNumber'];

  Trainman.nPostID := TRsPost(iJson.I['nPostID']);
  //职位名称
  Trainman.strPostName := iJson.S['strPostName'];
  //所属车间GUID
  Trainman.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //所属车间名称
  Trainman.strWorkShopName := iJson.S['strWorkShopName'];
  {指纹1}
  //Trainman.FingerPrint1 := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['FingerPrint1']);

  if iJson.O['nFingerPrint1_Null'] <> nil then
    Trainman.nFingerPrint1_Null := iJson.I['nFingerPrint1_Null']
  else
  begin
    if Length(iJson.S['FingerPrint1']) = 0 then
      {指纹1空标志,空位0,不空为1}
      Trainman.nFingerPrint1_Null := 0
    else
      Trainman.nFingerPrint1_Null := 1;
  end;


  
  {指纹2}
  //Trainman.FingerPrint2 := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['FingerPrint2']);

  if iJson.O['nFingerPrint2_Null'] <> nil then
    Trainman.nFingerPrint2_Null := iJson.I['nFingerPrint2_Null']
  else
  begin
    if Length(iJson.S['FingerPrint2']) = 0 then
      {指纹2空标志,空位0,不空为1}
      Trainman.nFingerPrint2_Null := 0
    else
      Trainman.nFingerPrint2_Null := 1;
  end;
  


  //测酒照片
  //Trainman.Picture := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['Picture']);

  if iJson.O['nPicture_Null'] <> nil then
    Trainman.nPicture_Null := iJson.I['nPicture_Null']
  else
  begin
    if Length(iJson.S['Picture']) = 0 then
      //照片空标志,空位0,不空为1
      Trainman.nPicture_Null := 0
    else
      Trainman.nPicture_Null := 1;
  end;

  
  //指导组GUID
  Trainman.strGuideGroupGUID := iJson.S['strGuideGroupGUID'];
  //指导组名称
  Trainman.strGuideGroupName := iJson.S['strGuideGroupName'];
  //联系电话
  Trainman.strTelNumber := iJson.S['strTelNumber'];
  //手机号
  Trainman.strMobileNumber := iJson.S['strMobileNumber'];
  //家庭住址
  Trainman.strAdddress := iJson.S['strAdddress'];
  //驾驶工种
  Trainman.nDriverType := TRsDriverType(iJson.I['nDriverType']);                                 


  Trainman.strDriverTypeName := iJson.S['strDriverTypeName'];

  //叫班状态
  Trainman.nCallWorkState := TRsCallWorkState(iJson.I['nCallWorkState']);

  //叫班时间
  Trainman.strCallWorkGUID := iJson.S['strCallWorkGUID'];
  //关键人(0,1)
  Trainman.bIsKey := iJson.I['bIsKey'];
  //入职日期
  Trainman.dtRuZhiTime := StrToDateTimeDef(iJson.S['dtRuZhiTime'],0);
  //就职日期
  Trainman.dtJiuZhiTime := StrToDateTimeDef(iJson.S['dtJiuZhiTime'],0);
  //1、2、3
  Trainman.nDriverLevel := iJson.I['nDriverLevel'];
  //ABCD
  Trainman.strABCD := iJson.S['strABCD'];
  //备注
  Trainman.strRemark := iJson.S['strRemark'];

  //客货ID
  Trainman.nKeHuoID := TRsKehuo(iJson.I['nKeHuoID']);
  
  //客货名称
  Trainman.strKeHuoName := iJson.S['strKeHuoName'];
  //所属区段
  Trainman.strTrainJiaoluGUID := iJson.S['strTrainJiaoluGUID'];
  //所属人员交路
  Trainman.strTrainmanJiaoluGUID := iJson.S['strTrainmanJiaoluGUID'];
  //区段名称
  Trainman.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
  //最后退勤时间
  Trainman.dtLastEndworkTime := StrToDateTimeDef(iJson.S['dtLastEndworkTime'],0);
  //机务段编号
  Trainman.strAreaGUID := iJson.S['strareaguid'];
  //自增编号
  Trainman.nID := iJson.I['nID'];
  //创建时间
  Trainman.dtCreateTime := StrToDateTimeDef(iJson.S['dtCreateTime'],0);

  //状态
  Trainman.nTrainmanState := iJson.I['nTrainmanState'];
  //TCF_Enum.SetEnumValue(@Trainman.nTrainmanState,SizeOf(Trainman.nTrainmanState),iJson.I['nTrainmanState']);
  //姓名简拼
  Trainman.strJP := iJson.S['strJP'];
  //最后入寓时间
  Trainman.dtLastInRoomTime := StrToDateTimeDef(iJson.S['dtLastInRoomTime'],0);
  //最后离寓时间
  Trainman.dtLastOutRoomTime := StrToDateTimeDef(iJson.S['dtLastOutRoomTime'],0);
end;

procedure TRsAPITrainman.QueryTrainmans_blobFlag(
  QueryTrainman: RRsQueryTrainman; PageIndex: Integer;
  out TrainmanArray: IRsTrainmanArray; out nTotalCount: Integer);
var
  json: ISuperObject;
  strOutputData,strResultText : WideString ;
  Trainman : IRsTrainman;
  I: Integer;
begin
  if m_WebAPI = nil then
  begin
    raise exception.Create('使用了未赋值的接口连接信息');
  end;

  json := SO;
  json.I['PageIndex'] := PageIndex;
  json.O['QueryTrainman'] := RsQueryTrainmanToJson(QueryTrainman);

  strOutputData := m_WebAPI.Post('TF.RunSafty.LCTrainmanMgr.QueryTrainmans_blobFlag',json.AsString);
  if m_WebAPI.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  json := m_WebAPI.GetHttpDataJson(strOutputData) as ISuperObject;
  nTotalCount := json.I['nTotalCount'];
  json := json.O['trainmanArray'];
  TrainmanArray :=  CreateInterface(CLASS_RsTrainmanArray) as IRsTrainmanArray;
  for I := 0 to json.AsArray.Length - 1 do
  begin
    Trainman := CreateInterface(CLASS_RsTrainman) as IRsTrainman;
    JsonToTrainman(Trainman,json.AsArray[i]);
    TrainmanArray.Add(Trainman);
  end;
end;

function TRsAPITrainman.RsQueryTrainmanToJson(
  const QueryTrainman: RRsQueryTrainman): ISuperObject;
begin
   Result := SO();
  //工号，空为所有
  Result.S['strTrainmanNumber'] := QueryTrainman.strTrainmanNumber;
  //姓名，空为所有
  Result.S['strTrainmanName'] := QueryTrainman.strTrainmanName;
  //机务段编号
  Result.S['strAreaGUID'] := QueryTrainman.strAreaGUID;
  //所属车间，空为所有
  Result.S['strWorkShopGUID'] := QueryTrainman.strWorkShopGUID;
  //区段信息
  Result.S['strTrainJiaoluGUID'] := QueryTrainman.strTrainJiaoluGUID;
  //指导组
  Result.S['strGuideGroupGUID'] := QueryTrainman.strGuideGroupGUID;
  //已登记指纹数量，-1为所有
  Result.I['nFingerCount'] := QueryTrainman.nFingerCount;
  //是否有照片，-1为所有
  Result.I['nPhotoCount'] := QueryTrainman.nPhotoCount;  
end;

{ TRsTrainmanArray }

procedure TRsTrainmanArray.Add(const Trainman: IRsTrainman);
begin
  m_Trainmans.Add(Trainman);
end;

procedure TRsTrainmanArray.Initialize;
begin
  inherited;
  m_Trainmans := TInterfaceList.Create;
end;

function TRsTrainmanArray.Get_Count: Integer;
begin
  result := m_Trainmans.Count;
end;

procedure TRsTrainmanArray.Delete(Index: Integer);
begin
  m_Trainmans.Delete(Index);
end;

procedure TRsTrainmanArray.GetItem(Index: Integer; out Result: IRsTrainman);
begin
  result := m_Trainmans[Index] as IRsTrainman;
end;


function TRsTrainman.Get_bIsKey: Integer;
begin
  result := bIsKey;
end;

function TRsTrainman.Get_dtCreateTime: TDateTime;
begin
  result := dtCreateTime;
end;

function TRsTrainman.Get_dtJiuZhiTime: TDateTime;
begin
  result := dtJiuZhiTime;
end;

function TRsTrainman.Get_dtLastEndworkTime: TDateTime;
begin
  result := dtLastEndworkTime;
end;

function TRsTrainman.Get_dtLastInRoomTime: TDateTime;
begin
  result := dtLastInRoomTime;
end;

function TRsTrainman.Get_dtLastOutRoomTime: TDateTime;
begin
  result := dtLastOutRoomTime;
end;

function TRsTrainman.Get_dtRuZhiTime: TDateTime;
begin
  result := dtRuZhiTime;
end;

function TRsTrainman.Get_eFixGroupType: TFixedGroupType;
begin
  result := eFixGroupType;
end;

function TRsTrainman.Get_FingerPrint1: OleVariant;
begin
  result := FingerPrint1;
end;

function TRsTrainman.Get_FingerPrint2: OleVariant;
begin
 result := FingerPrint2;
end;

function TRsTrainman.Get_nCallWorkState: TRsCallWorkState;
begin
  result := nCallWorkState;
end;

function TRsTrainman.Get_nDriverLevel: Integer;
begin
  result := nDriverLevel;
end;

function TRsTrainman.Get_nDriverType: TRsDriverType;
begin
  result := nDriverType;
end;

function TRsTrainman.Get_nFingerPrint1_Null: Integer;
begin
 result := nFingerPrint1_Null;
end;

function TRsTrainman.Get_nFingerPrint2_Null: Integer;
begin
 result := nFingerPrint2_Null;
end;

function TRsTrainman.Get_nFixedGroupIndex: Integer;
begin
 result := nFixedGroupIndex;
end;

function TRsTrainman.Get_nID: Integer;
begin
  result := nID;
end;

function TRsTrainman.Get_nKeHuoID: TRsKehuo;
begin
  result := nKeHuoID;
end;

function TRsTrainman.Get_nPicture_Null: Integer;
begin
  result := nPicture_Null;
end;

function TRsTrainman.Get_nPostID: TRsPost;
begin
  result := nPostID;
end;

function TRsTrainman.Get_nTrainmanState: TRsTrainmanState;
begin
  result := nTrainmanState;
end;

function TRsTrainman.Get_Picture: OleVariant;
begin
  result := Picture;
end;

function TRsTrainman.Get_strABCD: WideString;
begin
  result := strABCD;
end;

function TRsTrainman.Get_strAdddress: WideString;
begin
  result := strAdddress;
end;

function TRsTrainman.Get_strAreaGUID: WideString;
begin
   result := strAreaGUID;
end;

function TRsTrainman.Get_strCallWorkGUID: WideString;
begin
   result := strCallWorkGUID;
end;

function TRsTrainman.Get_strDriverTypeName: WideString;
begin
  result := strDriverTypeName;
end;

function TRsTrainman.Get_strFixedGroupGUID: WideString;
begin
  result := strFixedGroupGUID;
end;

function TRsTrainman.Get_strFixedGroupName: WideString;
begin
   result := strFixedGroupName;
end;

function TRsTrainman.Get_strGuideGroupGUID: WideString;
begin
   result := strGuideGroupGUID;
end;

function TRsTrainman.Get_strGuideGroupName: WideString;
begin
  result := strGuideGroupName;
end;

function TRsTrainman.Get_strJP: WideString;
begin
  result := strJP;
end;

function TRsTrainman.Get_strKeHuoName: WideString;
begin
  result := strKeHuoName;
end;

function TRsTrainman.Get_strMobileNumber: WideString;
begin
  result := strMobileNumber;
end;

function TRsTrainman.Get_strPostName: WideString;
begin
  result := strPostName;
end;

function TRsTrainman.Get_strRemark: WideString;
begin
  result := strRemark;
end;

function TRsTrainman.Get_strTelNumber: WideString;
begin
  result := strTelNumber;
end;

function TRsTrainman.Get_strTrainJiaoluGUID: WideString;
begin
  result := strTrainJiaoluGUID;
end;

function TRsTrainman.Get_strTrainJiaoluName: WideString;
begin
   result := strTrainJiaoluName;
end;

function TRsTrainman.Get_strTrainmanGUID: WideString;
begin
  result := strTrainmanGUID;
end;

function TRsTrainman.Get_strTrainmanJiaoluGUID: WideString;
begin
  result := strTrainmanJiaoluGUID;
end;

function TRsTrainman.Get_strTrainmanName: WideString;
begin
  result := strTrainmanName;
end;

function TRsTrainman.Get_strTrainmanNumber: WideString;
begin
  result := strTrainmanNumber;
end;

function TRsTrainman.Get_strWorkShopGUID: WideString;
begin
  result := strWorkShopGUID;
end;

function TRsTrainman.Get_strWorkShopName: WideString;
begin
  result := strWorkShopName;
end;

procedure TRsTrainman.AssignTo(const Trainman: IRsTrainman);
begin
  IRsTrainman(Self).strTrainmanGUID := Trainman.strTrainmanGUID;
  IRsTrainman(Self).strTrainmanName := Trainman.strTrainmanName;
  IRsTrainman(Self).strTrainmanNumber := Trainman.strTrainmanNumber;
  IRsTrainman(Self).nPostID := Trainman.nPostID;
  IRsTrainman(Self).strPostName := Trainman.strPostName;
  IRsTrainman(Self).strWorkShopGUID := Trainman.strWorkShopGUID;
  IRsTrainman(Self).strWorkShopName := Trainman.strWorkShopName;
  IRsTrainman(Self).FingerPrint1 := Trainman.FingerPrint1;
  IRsTrainman(Self).nFingerPrint1_Null := Trainman.nFingerPrint1_Null;
  IRsTrainman(Self).FingerPrint2 := Trainman.FingerPrint2;
  IRsTrainman(Self).nFingerPrint2_Null := Trainman.nFingerPrint2_Null;
  IRsTrainman(Self).Picture := Trainman.Picture;
  IRsTrainman(Self).nPicture_Null := Trainman.nPicture_Null;
  IRsTrainman(Self).strGuideGroupGUID := Trainman.strGuideGroupGUID;
  IRsTrainman(Self).strGuideGroupName := Trainman.strGuideGroupName;
  IRsTrainman(Self).strTelNumber := Trainman.strTelNumber;
  IRsTrainman(Self).strMobileNumber := Trainman.strMobileNumber;
  IRsTrainman(Self).strAdddress := Trainman.strAdddress;
  IRsTrainman(Self).nDriverType := Trainman.nDriverType;
  IRsTrainman(Self).strDriverTypeName := Trainman.strDriverTypeName;
  IRsTrainman(Self).nCallWorkState := Trainman.nCallWorkState;
  IRsTrainman(Self).strCallWorkGUID := Trainman.strCallWorkGUID;
  IRsTrainman(Self).bIsKey := Trainman.bIsKey;
  IRsTrainman(Self).dtRuZhiTime := Trainman.dtRuZhiTime;


  IRsTrainman(Self).dtRuZhiTime := Trainman.dtRuZhiTime;
  IRsTrainman(Self).dtJiuZhiTime := Trainman.dtJiuZhiTime;
  IRsTrainman(Self).nDriverLevel := Trainman.nDriverLevel;
  IRsTrainman(Self).strABCD := Trainman.strABCD;
  IRsTrainman(Self).strRemark := Trainman.strRemark;

  IRsTrainman(Self).nKeHuoID := Trainman.nKeHuoID;
  IRsTrainman(Self).strKeHuoName := Trainman.strKeHuoName;
  IRsTrainman(Self).strTrainJiaoluGUID := Trainman.strTrainJiaoluGUID;
  IRsTrainman(Self).strTrainmanJiaoluGUID := Trainman.strTrainmanJiaoluGUID;
  IRsTrainman(Self).strTrainJiaoluName := Trainman.strTrainJiaoluName;
  IRsTrainman(Self).dtLastEndworkTime := Trainman.dtLastEndworkTime;
  IRsTrainman(Self).strAreaGUID := Trainman.strAreaGUID;
  IRsTrainman(Self).nID := Trainman.nID;
  IRsTrainman(Self).dtCreateTime := Trainman.dtCreateTime;
  IRsTrainman(Self).nTrainmanState := Trainman.nTrainmanState;
  IRsTrainman(Self).strJP := Trainman.strJP;
  IRsTrainman(Self).dtLastInRoomTime := Trainman.dtLastInRoomTime;
  IRsTrainman(Self).dtLastOutRoomTime := Trainman.dtLastOutRoomTime;
  IRsTrainman(Self).strFixedGroupGUID := Trainman.strFixedGroupGUID;
  IRsTrainman(Self).nFixedGroupIndex := Trainman.nFixedGroupIndex;
  IRsTrainman(Self).strFixedGroupName := Trainman.strFixedGroupName;
  IRsTrainman(Self).eFixGroupType := Trainman.eFixGroupType;

end;

procedure TRsTrainman.Set_bIsKey(Value: Integer);
begin
 bIsKey := Value;
end;

procedure TRsTrainman.Set_dtCreateTime(Value: TDateTime);
begin
  dtCreateTime := Value;
end;

procedure TRsTrainman.Set_dtJiuZhiTime(Value: TDateTime);
begin
 dtJiuZhiTime  := Value;
end;

procedure TRsTrainman.Set_dtLastEndworkTime(Value: TDateTime);
begin
  dtLastEndworkTime  := Value;
end;

procedure TRsTrainman.Set_dtLastInRoomTime(Value: TDateTime);
begin
  dtLastInRoomTime  := Value;
end;

procedure TRsTrainman.Set_dtLastOutRoomTime(Value: TDateTime);
begin
  dtLastOutRoomTime  := Value;
end;

procedure TRsTrainman.Set_dtRuZhiTime(Value: TDateTime);
begin
  dtRuZhiTime  := Value;
end;

procedure TRsTrainman.Set_eFixGroupType(Value: TFixedGroupType);
begin
  eFixGroupType  := Value;
end;

procedure TRsTrainman.Set_FingerPrint1(Value: OleVariant);
begin
  FingerPrint1  := Value;
end;

procedure TRsTrainman.Set_FingerPrint2(Value: OleVariant);
begin
  FingerPrint2  := Value;
end;

procedure TRsTrainman.Set_nCallWorkState(Value: TRsCallWorkState);
begin
  nCallWorkState  := Value;
end;

procedure TRsTrainman.Set_nDriverLevel(Value: Integer);
begin
  nDriverLevel  := Value;
end;

procedure TRsTrainman.Set_nDriverType(Value: TRsDriverType);
begin
  nDriverType  := Value;
end;

procedure TRsTrainman.Set_nFingerPrint1_Null(Value: Integer);
begin
  nFingerPrint1_Null  := Value;
end;

procedure TRsTrainman.Set_nFingerPrint2_Null(Value: Integer);
begin
 nFingerPrint2_Null  := Value;
end;

procedure TRsTrainman.Set_nFixedGroupIndex(Value: Integer);
begin
  nFixedGroupIndex  := Value;
end;

procedure TRsTrainman.Set_nID(Value: Integer);
begin
  nid  := Value;
end;

procedure TRsTrainman.Set_nKeHuoID(Value: TRsKehuo);
begin
  nKeHuoID  := Value;
end;

procedure TRsTrainman.Set_nPicture_Null(Value: Integer);
begin
 nPicture_Null  := Value;
end;

procedure TRsTrainman.Set_nPostID(Value: TRsPost);
begin
  nPostID  := Value;
end;

procedure TRsTrainman.Set_nTrainmanState(Value: TRsTrainmanState);
begin
  nTrainmanState  := Value;
end;

procedure TRsTrainman.Set_Picture(Value: OleVariant);
begin
  Picture := Value;
end;

procedure TRsTrainman.Set_strABCD(const Value: WideString);
begin
  strABCD  := Value;
end;

procedure TRsTrainman.Set_strAdddress(const Value: WideString);
begin
  strAdddress := Value;
end;

procedure TRsTrainman.Set_strAreaGUID(const Value: WideString);
begin
 strAreaGUID  := Value;
end;

procedure TRsTrainman.Set_strCallWorkGUID(const Value: WideString);
begin
  strCallWorkGUID  := Value;
end;

procedure TRsTrainman.Set_strDriverTypeName(const Value: WideString);
begin
  strDriverTypeName := Value;
end;

procedure TRsTrainman.Set_strFixedGroupGUID(const Value: WideString);
begin
  strFixedGroupGUID := Value;
end;

procedure TRsTrainman.Set_strFixedGroupName(const Value: WideString);
begin
  strFixedGroupName  := Value;
end;

procedure TRsTrainman.Set_strGuideGroupGUID(const Value: WideString);
begin
  strGuideGroupGUID := Value;
end;

procedure TRsTrainman.Set_strGuideGroupName(const Value: WideString);
begin
 strGuideGroupName := Value;
end;

procedure TRsTrainman.Set_strJP(const Value: WideString);
begin
  strJP := Value;
end;

procedure TRsTrainman.Set_strKeHuoName(const Value: WideString);
begin
  strKeHuoName  := Value;
end;

procedure TRsTrainman.Set_strMobileNumber(const Value: WideString);
begin
  strMobileNumber := Value;
end;

procedure TRsTrainman.Set_strPostName(const Value: WideString);
begin
 strPostName := Value;
end;

procedure TRsTrainman.Set_strRemark(const Value: WideString);
begin
 strRemark := Value;
end;

procedure TRsTrainman.Set_strTelNumber(const Value: WideString);
begin
  strTelNumber := Value;
end;

procedure TRsTrainman.Set_strTrainJiaoluGUID(const Value: WideString);
begin
  strTrainmanJiaoluGUID := Value;
end;

procedure TRsTrainman.Set_strTrainJiaoluName(const Value: WideString);
begin
  strTrainJiaoluName := Value;
end;

procedure TRsTrainman.Set_strTrainmanGUID(const Value: WideString);
begin
 strTrainmanGUID  := Value;
end;

procedure TRsTrainman.Set_strTrainmanJiaoluGUID(const Value: WideString);
begin
  strTrainmanJiaoluGUID := Value;
end;

procedure TRsTrainman.Set_strTrainmanName(const Value: WideString);
begin
  strTrainmanName := Value;
end;

procedure TRsTrainman.Set_strTrainmanNumber(const Value: WideString);
begin
  strTrainmanNumber  := Value;
end;

procedure TRsTrainman.Set_strWorkShopGUID(const Value: WideString);
begin
 strWorkShopGUID  := Value;
end;

procedure TRsTrainman.Set_strWorkShopName(const Value: WideString);
begin
 strWorkShopName  := Value;
end;



procedure TRsAPITrainman.DeleteTrainman(const TrainmanGUID: WideString);
begin

end;

function TRsAPITrainman.GetTrainman(const TrainmanGUID: WideString;
  Option: Integer; out Trainman: IRsTrainman): WordBool;
var
  strOutputData,strResultText : WideString;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.I['option'] := option;
  strOutputData := m_WebAPI.Post('TF.RunSafty.LCTrainmanMgr.GetTrainman',json.AsString);
  if m_WebAPI.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := (m_WebAPI.GetHttpDataJson(strOutputData) as iSuperObject).O['trainmanArray'];
  
  result := json.AsArray.Length > 0;

  if Result then
  begin
    Trainman :=  (CreateInterface(CLASS_RsTrainman) as IRsTrainman);
    JsonToTrainman(Trainman,json.AsArray[0]);
  end;
end;

function TRsAPITrainman.GetTrainmanByNumber(const TrainmanNumber: WideString;
  Option: Integer; var Trainman: IRsTrainman): WordBool;
begin

end;

function TRsAPITrainman.ExistNumber(const TrainmanGUID,
  TrainmanNumber: WideString): WordBool;
begin

end;

procedure TRsAPITrainman.AddTrainman(const Trainman: IRsTrainman);
begin

end;

procedure TRsAPITrainman.UpdateTrainmanTel(const TrainmanGUID, TrainmanTel,
  TrainmanMobile, TrainmanAddress, TrainmanBrief: WideString);
begin

end;

function TRsAPITrainman.GetPopupTrainmans(const WorkShopGUID,
  KeyName: WideString; PageIndex: Integer;
  out TrainmanArray: IRsTrainmanArray): Integer;
var
  strOutputData,strResultText : WideString;
  JSON : ISuperObject;
  Trainman : IRsTrainman;
  I: Integer;
begin
  json := SO();
  json.S['WorkShopGUID'] := WorkShopGUID;
  json.S['strKeyName'] := KeyName;
  json.I['PageIndex'] := PageIndex;
 

  strOutputData := m_WebAPI.Post('TF.RunSafty.LCTrainmanMgr.GetPopupTrainmans',json.AsString);
  if m_WebAPI.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  json := m_WebAPI.GetHttpDataJson(strOutputData) as ISuperObject;
  Result := JSON.I['nTotalCount'];
  TrainmanArray := CreateInterface(CLASS_RsTrainmanArray) as IRsTrainmanArray;
  Json := JSON.O['trainmanArray'];
  for I := 0 to json.AsArray.Length - 1 do
  begin
    Trainman :=  CreateInterface(CLASS_RsTrainman) as IRsTrainman;
    JsonToTrainman(Trainman,json.AsArray[i]);
    TrainmanArray.Add(Trainman);
  end;
end;



initialization
  TAutoObjectFactory.Create(ComServer, TRsAPITrainman, Class_RsAPITrainman,
    ciMultiInstance, tmApartment);
  TAutoObjectFactory.Create(ComServer, TRsTrainmanArray, CLASS_RsTrainmanArray,
    ciMultiInstance, tmApartment);
  TAutoObjectFactory.Create(ComServer, TRsTrainman, CLASS_RsTrainman,
    ciMultiInstance, tmApartment);    
end.
