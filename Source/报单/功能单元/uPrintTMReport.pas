unit uPrintTMReport;

interface
uses
  frxClass,Classes,SysUtils,uTrainPlan,StrUtils,uFrmTMRptSelect,uTFSystem;
type
  //��ӡ˾������
  TPrintTMReport = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    //��Ա�ƻ�
    //m_TMPlan:RRsChuQinPlan;
    //fastReport
    //�����
    m_strJWDNumber:string;
    //��ӡ����
    m_frt:TfrxReport;
  private
    function print(strJWDNumber:string; ChuQinPlan1,ChuQinPlan2:RRsChuQinPlan;var strErr:string):Boolean;
   //���Թ���
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
  if m_strJWDNumber = '69' then      //�������ȥ������ǰ3λ
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
    Box('δ�ҵ�ģ���ļ���');
    Exit;
  end;
  if m_frt.LoadFromFile(filePathName,False) = False then
  begin
    Box('����ģ���ļ�ʧ�ܣ�');
  end;

  
  //����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TrainNo'))  ;
  if mmo <> nil then
    mmo.Text := ChuQinPlan1.TrainPlan.strTrainNo;


  //վ�ӡ����
  mmo := tfrxmemoview(m_frt.FindObject('mm_RemarkType'))  ;
  if mmo <> nil then
    mmo.Text := TRsPlanRemarkTypeName[ChuQinPlan1.TrainPlan.nRemarkType];

  //����
  mmo := tfrxmemoview(m_frt.FindObject('mm_xing'))  ;
  if mmo <> nil then
    mmo.Text := ChuQinPlan1.TrainPlan.strTrainTypeName;

  //����
  mmo := tfrxmemoview(m_frt.FindObject('mm_hao'))  ;
  if mmo <> nil then
    mmo.Text := ChuQinPlan1.TrainPlan.strTrainNumber;

  //��
  mmo := tfrxmemoview(m_frt.FindObject('mm_Year'))  ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('yyyy',ChuQinPlan1.TrainPlan.dtStartTime);

  //��
  mmo := tfrxmemoview(m_frt.FindObject('mm_Month'))  ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('mm',ChuQinPlan1.TrainPlan.dtStartTime);

  //��
  mmo := tfrxmemoview(m_frt.FindObject('mm_Day'))  ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('dd',ChuQinPlan1.TrainPlan.dtStartTime);

    
  //˾��1����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum1'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanNumber) ;

  //˾��1����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName1'))  ;
  if ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
    if mmo <> nil then
      mmo.Text := ChuQinPlan1.ChuQinGroup.Group.Trainman1.strTrainmanName;

  //˾��2����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum2'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text := MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanNumber) ;

  //˾��2����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName2'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan1.ChuQinGroup.Group.Trainman2.strTrainmanName;

  //˾��3����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum3'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanNumber) ;

  //˾��3����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName3'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan1.ChuQinGroup.Group.Trainman3.strTrainmanName;

  //˾��4����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum4'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanNumber) ;

  //˾��4����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName4'))  ;
  if mmo <> nil then
    if ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan1.ChuQinGroup.Group.Trainman4.strTrainmanName;


  //�ڶ���˾��1����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum5'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
      mmo.Text := MinNumber(ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanNumber) ;

  //�ڶ���˾��1����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName5'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman1.strTrainmanName;

  //�ڶ���˾��2����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum6'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber( ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanNumber) ;

  //�ڶ���˾��2����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName6'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman2.strTrainmanName;

  //�ڶ���˾��3����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum7'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text := MinNumber(ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanNumber) ;
      
  //�ڶ���˾��3����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName7'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman3.strTrainmanName;
      
  //�ڶ���˾��4����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMNum8'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=MinNumber(ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanNumber) ;

  //�ڶ���˾��4����
  mmo := tfrxmemoview(m_frt.FindObject('mm_TMName8'))  ;
  if mmo <> nil then
    if ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanGUID <> '' then
      mmo.Text :=ChuQinPlan2.ChuQinGroup.Group.Trainman4.strTrainmanName;
      

  //����ʱ��
  mmo := tfrxmemoview(m_frt.FindObject('mm_ChuQinTime')) ;
  if mmo <> nil then
    mmo.Text := FormatDateTime('HH',ChuQinPlan1.TrainPlan.dtStartTime)+ 'ʱ' + FormatDateTime('nn',ChuQinPlan1.TrainPlan.dtStartTime)+ '��';

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
