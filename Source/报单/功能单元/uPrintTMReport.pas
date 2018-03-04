unit uPrintTMReport;

interface
uses
  frxClass,Classes,SysUtils,uTrainPlan,StrUtils,uFrmTMRptSelect,uTFSystem;
type
  //打印司机报单
  TPrintTMReport = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    //人员计划
    //m_TMPlan:RRsChuQinPlan;
    //fastReport
    //机务段
    m_strJWDNumber:string;
    //打印对象
    m_frt:TfrxReport;
  private
    function print(strJWDNumber:string; ChuQinPlan1,ChuQinPlan2:RRsChuQinPlan;var strErr:string):Boolean;
   //缩略工号
   function MinNumber(strNumber:string):string;
  public
    class function PrintRpt(strJWDNumber:string; ChuQinPlan1,ChuQinPlan2:RRsChuQinPlan;var strErr:string):Boolean;
  end;

implementation
uses
  uSaftyEnum;
{ TPrintTMReport }

constructor TPrintTMReport.Create;
begin
  m_frt:=TfrxReport.Create(nil);
end;



destructor TPrintTMReport.Destroy;
begin
  m_frt.Free;
  inherited;
end;

function TPrintTMReport.MinNumber(strNumber: string): string;
begin
  result := strNumber;
  if m_strJWDNumber = '69' then      //天津机务段去掉工号前3位
  begin
    result := RightStr(strNumber,Length(strNumber)-3);
  end;
end;

function TPrintTMReport.print(strJWDNumber: string;
  ChuQinPlan1,ChuQinPlan2:RRsChuQinPlan;var strErr:string): Boolean;
var
  mmo : tfrxmemoview;
  filePathName : string;
begin
  result := False;
  m_strJWDNumber := strJWDNumber;

  if not TfrmTMRptSelect.Select(filePathName) then
  begin
    result := true;
    exit;
  end;


  if SysUtils.FileExists(filePathName) = False then
  begin
    Box('未找到模板文件！');
    Exit;
  end;
  if m_frt.LoadFromFile(filePathName,False) = False then
  begin
    Box('加载模板文件失败！');
  end;

  
  //车次
  mmo := tfrxmemoview(m_frt.FindObject('mm_TrainNo'))  ;
  if mmo <> nil then
    mmo.Text := ChuQinPlan1.TrainPlan.strTrainNo;


  //站接、库接
  mmo := tfrxmemoview(m_frt.FindObject('mm_RemarkType'))  ;
  if mmo <> nil then
    mmo.Text := TRsPlanRemarkTypeName[ChuQinPlan1.TrainPlan.nRemarkType];

  //车型
  mmo := tfrxmemoview(m_frt.FindObject('mm_xing'))  ;
  if mmo <> nil then
    mmo.Text := ChuQinPlan1.TrainPlan.strTrainTypeName;

  //车号
  mmo := tfrxmemoview(m_frt.FindObject('mm_hao'))  ;
  if mmo <> nil then
    mmo.Text := ChuQinPlan1.TrainPlan.strTrainNumber;

  //年
  mmo := tfrxmemoview(m_frt.FindObject('mm_Year'))  ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('yyyy',ChuQinPlan1.TrainPlan.dtStartTime);

  //月
  mmo := tfrxmemoview(m_frt.FindObject('mm_Month'))  ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('mm',ChuQinPlan1.TrainPlan.dtStartTime);

  //日
  mmo := tfrxmemoview(m_frt.FindObject('mm_Day'))  ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('dd',ChuQinPlan1.TrainPlan.dtStartTime);

    
  //司机1工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum1'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanNumber) ;

  //司机1姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName1'))  ;
  if ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
    if mmo <> nil then
      mmo.Text := ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanName;

  //司机2工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum2'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text := MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanNumber) ;

  //司机2姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName2'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanName;

  //司机3工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum3'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanNumber) ;

  //司机3姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName3'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanName;

  //司机4工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum4'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanNumber) ;

  //司机4姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName4'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanName;


  //第二组司机1工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum5'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
      mmo.Text := MinNumber(ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanNumber) ;

  //第二组司机1姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName5'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanName;

  //第二组司机2工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum6'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber( ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanNumber) ;

  //第二组司机2姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName6'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanName;

  //第二组司机3工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum7'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text := MinNumber(ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanNumber) ;
      
  //第二组司机3姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName7'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanName;
      
  //第二组司机4工号
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum8'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanNumber) ;

  //第二组司机4姓名
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName8'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanName;
      

  //出勤时分
  mmo := tfrxmemoview(m_frt.FindObject('mm_ChuQinTime')) ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('HH',ChuQinPlan1.TrainPlan.dtStartTime)+ '时' + FormatDateTime('nn',ChuQinPlan1.TrainPlan.dtStartTime)+ '分';

  m_frt.PrepareReport();
  m_frt.PrintOptions.ShowDialog := False;

  m_frt.Print;
  
  Result := True;
end;

class function TPrintTMReport.PrintRpt(strJWDNumber: string;
  ChuQinPlan1,ChuQinPlan2: RRsChuQinPlan; var strErr: string): Boolean;
var
  ptReport: TPrintTMReport;
begin
  result := False;
  ptReport:= TPrintTMReport.Create;
  try    
    if ptReport.print(strJWDNumber,ChuQinPlan1,ChuQinPlan2,strErr)= False then Exit;
    result := True;
  finally
    ptReport.Free;
  end;
end;

end.
