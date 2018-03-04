unit UFrmPrintJieShi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzEdit, RAR, frxClass, Buttons, PngCustomButton,
  ExtCtrls, RzPanel,uKDXKCommon,DateUtils,uJieShiDefines,uSection,uDDMLDownload,
  uKDXKInterfaceComponent,superobject,uGlobal,uTFSystem,uTrainPlan,
  uLCWriteCardSection,uTrainman;

type
  TFrmPrintJieShi = class(TForm)
    rzpnl6: TRzPanel;
    btnSelectSection: TPngCustomButton;
    lblQuDuanPageInfo: TLabel;
    UserMasterDS: TfrxUserDataSet;
    UserDetailDS: TfrxUserDataSet;
    rzpnlTop: TRzPanel;
    rzpnlBody: TRzPanel;
    btnPrint: TButton;
    edtJieShi: TRzRichEdit;
    PnlQuDuan: TRzPanel;
    tvQuDuan: TTreeView;
    lbl1: TLabel;
    lblDLUpdateTime: TLabel;
    btnClose: TButton;
    frxrprt1: TfrxReport;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure r1PasswordRequired(Sender: TObject; const HeaderPassword: Boolean;
      const FileName: string; out NewPassword: string; out Cancel: Boolean);
    procedure UserMasterDSCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure UserMasterDSFirst(Sender: TObject);
    procedure UserMasterDSGetValue(const VarName: string; var Value: Variant);
    procedure UserMasterDSNext(Sender: TObject);
    procedure UserMasterDSPrior(Sender: TObject);
    procedure UserDetailDSCheckEOF(Sender: TObject; var Eof: Boolean);
    procedure UserDetailDSFirst(Sender: TObject);
    procedure UserDetailDSGetValue(const VarName: string; var Value: Variant);
    procedure UserDetailDSNext(Sender: TObject);
    procedure UserDetailDSPrior(Sender: TObject);
    procedure frxrprt1BeforePrint(Sender: TfrxReportComponent);
    procedure tvQuDuanClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    {写卡区段列表}
    m_SectionList: TSectionList;
    {交付揭示写卡区段}
    m_MainNo :Integer;
    {交付揭示区段主信息}
    m_MasterNo: Integer;
    {交付揭示明细信息}
    m_DetailNo: Integer;
    {所有分界后的调度命令}
    m_DDMLList:TDDMLList;
    {区段上行交付揭示}
    m_UpDDMLList :TDDMLList;
    {区段下行交付揭示}
    m_DownDDMLList :TDDMLList;
    {跨段写卡组件对象}
    m_KDXKInterfaceComponent:TKDXKInterfaceComponent;
    //人员计划
    m_ChuQinPlan:RRsChuQinPlan;
    //出勤人员
    m_Trainman:RRsTrainman;
    //写卡区段web接口
    m_webWriteCard :TRSLCWriteCardSection;
    //调令更新管理
    m_DlDownload:TDDMLDownload;
  private
    {功能:读取区段信息}
    function ReadQuDuan(strPlanGUID:string):Boolean;
    {功能：获取对应写卡区段的交付揭示}
    procedure GetXKQDJieShi(strDH,strQDH,strXKQDName:string);
    {功能:获取分解后的交付揭示}
    function GetJiaoFuJieShi():Boolean;
    {功能:rtf文本转换为普通文本}
    function rft2Text(strRtf: string): string;
    {功能:获取有效时间}
    function GetValidTime: string;
    function AppPath: string;
  public
      {功能:显示打印交付揭示}
    function ShowPrintJiaoFuJieShi(chuqinPlan:RRsChuQinPlan;Trainman:RRsTrainman): Boolean;
  end;

implementation

{$R *.dfm}




function TFrmPrintJieShi.AppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TFrmPrintJieShi.btnCloseClick(Sender: TObject);
begin
  self.Hide;
end;

procedure TFrmPrintJieShi.btnPrintClick(Sender: TObject);
var
  mmo : tfrxmemoview;
  i:Integer;
  strDH,strQDH,strSecName:String;
begin
  if m_SectionList.Count = 0 then Exit;

  for i := 0 to m_SectionList.Count - 1 do
  begin
    tvQuDuan.Items[i].Selected := True;
    tvQuDuanClick(nil);
    strDH := m_SectionList.Items[i].strDH;
    strQDH := m_SectionList.Items[i].strQDH;
    strSecName := m_SectionList.Items[i].strSectionName;

    m_MainNo := i +1;
    GetXKQDJieShi(strDH,strQDH,strSecName);
    if m_UpDDMLList.Count + m_DownDDMLList.Count = 0 then Continue;
    mmo := tfrxmemoview(frxrprt1.FindObject('mmTitle'))  ;
    mmo.Text := '运 行 揭 示';
    mmo := tfrxmemoview(frxrprt1.FindObject('mmJiaoFuDate'))  ;
    mmo.Text := '交付日期：' + FormatDateTime('yyyy年mm月dd日 HH时nn分',Now()) +
          '  有效时间至 ' + self.GetValidTime();
    mmo := TfrxMemoView(frxrprt1.FindObject('mmDDY'));
    mmo.Text := '调度员：(签章)';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmSiJi'));
    mmo.Text := '司机：(签章)' +  m_Trainman.strTrainmanName;
    mmo := TfrxMemoView(frxrprt1.FindObject('mmJCH'));
    mmo.Text := '机车号：';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmJCH_text'));
    mmo.Text := m_ChuQinPlan.TrainPlan.strTrainNumber;
    mmo := TfrxMemoView(frxrprt1.FindObject('mmCheCi'));
    mmo.Text := '车次：';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmCheCi_text'));
    mmo.Text := m_ChuQinPlan.TrainPlan.strTrainNo;
    mmo := TfrxMemoView(frxrprt1.FindObject('mmJieShouSJ'));
    mmo.Text := '接收揭示时间：';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmPage'));
    mmo.Text := '第            页';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmTotalPage'));
    mmo.Text := '共            页';
    //frxrprt1.ShowReport() ;
    frxrprt1.PrepareReport();
    frxrprt1.PrintOptions.ShowDialog := False;
    frxrprt1.Print;
    //Exit;
  end;

  Application.ProcessMessages;
  Box('交付揭示打印完毕,请核对..');
  Self.ModalResult := mrOk;
end;


function TFrmPrintJieShi.GetValidTime: string;
var
  strList:TStringList;
  strTotalTime:string;
  i:Integer;
  intAry : array[0..4] of Integer;
begin
  strList := TStringList.Create;
  strList.LoadFromFile(AppPath +DDMLFile_DIRName + DDMLFILE_VALIDTIME);
  strTotalTime := strList.Strings[0];
  strList.Clear;
  strList.DelimitedText := strTotalTime;
  strList.Delimiter := ',';
  for i := 0 to strList.Count - 1 do
  begin
    intAry[i] := StrToInt(strList.Strings[i]);
  end;
  result := Format('%.4d年%.2d月%.2d日 %.2d时%.2d分',[intAry[0],intAry[1],
      intAry[2],intAry[3],intAry[4]]) ;
end;

procedure TFrmPrintJieShi.FormCreate(Sender: TObject);
var
  strFilePathName:string;
begin
  m_SectionList := TSectionList.Create;

  m_UpDDMLList :=TDDMLList.Create;
  m_DownDDMLList :=TDDMLList.Create;
  m_DDMLList := TDDMLList.Create;
  m_KDXKInterfaceComponent := TKDXKInterfaceComponent.Create(nil);


  m_webWriteCard :=TRSLCWriteCardSection.Create(GlobalDM.WebAPI.URL,
      GlobalDM.Site.Number,GlobalDM.Site.ID);

  m_DlDownload:=TDDMLDownload.Create;
  strFilePathName := AppPath +DDMLFile_DIRName + 'Ickddds.mdb';
  if FileExists(strFilePathName)= True then
  begin
    GetJiaoFuJieShi();
  end;

  
end;

procedure TFrmPrintJieShi.FormDestroy(Sender: TObject);
begin
  m_SectionList.Free;
  m_DDMLList.Free;
  m_KDXKInterfaceComponent.Free;
  m_UpDDMLList.Free;
  m_DownDDMLList.Free;
  m_webWriteCard.Free;
  m_DlDownload.Free;
end;


procedure TFrmPrintJieShi.frxrprt1BeforePrint(Sender: TfrxReportComponent);
var
  eof :Boolean;
  mmo : tfrxmemoview;
  pagefooter :TfrxPageFooter;
  i:Integer;
begin
  Exit;
  pagefooter := TfrxPageFooter(frxrprt1.FindObject('PageFooter1'));
  UserMasterDSCheckEOF(nil,eof);
  if eof = true then
  begin
    {两种方式得到mmo控件,方式1}
    for i := 0 to  pagefooter.Objects.Count -1 do
    begin
      mmo := TfrxMemoView(pagefooter.Objects.Items[i]) ;
      if mmo.Name = 'mmDDY' then
         mmo.Text := '调度员：(签章)';
      if mmo.Name = 'mmSiJi' then
        mmo.Text := '司机：(签章)';
    end;

  end
  else
  begin
    {两种方式得到mmo控件,方式2}
    mmo := TfrxMemoView(frxrprt1.FindObject('mmDDY'));
    mmo.Text := '';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmSiJi'));
    mmo.Text := '';
  end;

end;

(*
function TFrmPrintJieShi.bCanPrintJieShi(dtPlan: TDateTime): Boolean;
var
  dtStart :TDateTime;
  dtPrint:TDateTime;
begin
  Result := False;
  dtPrint := IncMinute(dtPlan,-10);// 出勤时间 -10分钟,之后就可以打印交付揭示
  if now() > dtPrint  then
  begin
    //if DateUtils.MinutesBetween(dtPlan,Now) < 10 then
    //DateUtils.IncMinute()
    //if DateUtils.SecondsBetween(dtPlan,Now) < 10 * 60 then
      result := True;
  end;
end;  *)


function TFrmPrintJieShi.GetJiaoFuJieShi():Boolean;
var
  strFilePathName :string;
begin
  result := False;

  m_KDXKInterfaceComponent.KDXKType := ktSiWei;
  //ExtractFilePath(Application.Name);
  strFilePathName := AppPath +DDMLFile_DIRName + 'Ickddds.mdb';
  if FileExists(strFilePathName)= False then
  begin
    box('未检测到调度命令数据文件');
    Exit;
  end;
  m_KDXKInterfaceComponent.KDXKDataPath := AppPath + DDMLFile_DIRName ;
  m_KDXKInterfaceComponent.DataBaseType := ktdbAccess;

  try
    m_KDXKInterfaceComponent.GetDDMLList(m_DDMLList);
  except on e:Exception do
    ShowMessage('获取调度命令异常!'+ e.Message);
  end;
  result := True;
end;


procedure TFrmPrintJieShi.GetXKQDJieShi(strDH,strQDH,strXKQDName:string);
var
  i:integer;
  ddmlInfo :RDDMLInfo;
  strDt:string;
  dtEnd :TDateTime;
begin
  m_UpDDMLList.Clear;
  m_DownDDMLList.Clear;
  edtJieShi.Clear;

  for i := 0 to m_DDMLList.Count - 1 do
  begin
    ddmlInfo := m_DDMLList.Items[i];
    //dtEnd.Date := ddmlInfo.dtEndDate ;
    strDt := FormatDateTime('yyyy-mm-dd',ddmlInfo.dtEndDate)+ ' ' + FormatDateTime('hh:mm:ss',ddmlInfo.dtEndTime);
    dtEnd:=StrToDateTime(strDt);
    if dtEnd >= Now then
    begin
      if (ddmlInfo.nJWDID = StrToInt(strDH)) and (IntToStr(ddmlInfo.nYYQDID) = strQDH) then
      begin
        if (ddmlInfo.nUpDown = 0) or (ddmlInfo.nUpDown = 2)then//上行
          m_UpDDMLList.Add(ddmlInfo)
        else
          m_DownDDMLList.Add(ddmlInfo);
      end;
      //lst1.Items.Add(IntToStr(ddmlInfo.nCommandNo) +' ' + IntToStr(ddmlInfo.nJWDID) + ' ' + IntToStr(ddmlInfo.nYYQDID) +'__' + IntToStr(ddmlInfo.nUpDown) + '-撤除1-' + IntToStr(ddmlInfo.isDelete));
    end;
  end;
  if m_UpDDMLList.Count > 0 then
    edtJieShi.Lines.Add(strXKQDName + '(上行)');
  
  for i := 0 to m_UpDDMLList.Count - 1 do
  begin
    ddmlInfo := m_UpDDMLList.Items[i];
    try
      //redt1.Lines.Append('调度命令:'+ IntToStr(ddmlInfo.nCommandNo) + '号:' + rft2Text(ddmlInfo.strOrder));
      edtJieShi.Lines.add(IntToStr(i+1) + ' 调度命令:'+ IntToStr(ddmlInfo.nCommandNo) + '号:   ' + rft2Text(ddmlInfo.strOrder));
      //redt1.Lines.add(ddmlInfo.strOrder);
    except

    end;
  end ;
  if m_DownDDMLList.Count > 0 then
    edtJieShi.Lines.Add(strXKQDName + '(下行)');
    
  for i := 0 to m_DownDDMLList.Count - 1 do
  begin
    ddmlInfo := m_DownDDMLList.Items[i];
    try
      //redt1.Lines.Append('调度命令:'+ IntToStr(ddmlInfo.nCommandNo) + '号:' + rft2Text(ddmlInfo.strOrder));
      edtJieShi.Lines.add(IntToStr(i+1) +  '  调度命令:'+ IntToStr(ddmlInfo.nCommandNo) + '号:   ' + rft2Text(ddmlInfo.strOrder));
    except

    end;
  end ;
  edtJieShi.Lines.Add(#13#10#13#10#13#10#13#10#13#10);
end;



function TFrmPrintJieShi.ShowPrintJiaoFuJieShi(chuqinPlan:RRsChuQinPlan;
            Trainman:RRsTrainman): Boolean;
var
  strErr:string;
  bUpdated:Boolean;
begin
  lblDLUpdateTime.Caption := FormatDateTime('yyyy-mm-dd HH:nn:ss',TPubJsConfig.DlUpdateTime);
  m_ChuQinPlan:=chuqinPlan;
  m_Trainman:=Trainman;
  result := False;
  if ReadQuDuan(m_ChuQinPlan.TrainPlan.strTrainPlanGUID) = False then Exit;
  if m_DlDownload.DoUpdate(bUpdated,strErr) = False then
  begin
    Box(strErr);
    Exit;
  end;
  if bUpdated then
  begin
    if GetJiaoFuJieShi() = False then Exit;
  end;
  lblDLUpdateTime.Caption := FormatDateTime('yyyy-mm-dd HH:nn:ss',TPubJsConfig.DlUpdateTime);
  if tvQuDuan.Items.Count > 0 then
    tvQuDuan.Items[0].Selected := True;
  tvQuDuanClick(nil);
  result := True;
  self.Show;
end;

procedure TFrmPrintJieShi.r1PasswordRequired(Sender: TObject;
  const HeaderPassword: Boolean; const FileName: string;
  out NewPassword: string; out Cancel: Boolean);
begin
  Cancel := False;
  NewPassword := 'thinker';
end;

function TFrmPrintJieShi.ReadQuDuan(strPlanGUID:string):Boolean;
{功能:读取区段信息}
var
  I: Integer;
  node:TTreeNode;
  strError:string;
begin
  result := False;
  m_SectionList.Clear;
  tvQuDuan.Items.Clear;
  if m_webWriteCard.GetWriteCardSectionByPlan(strPlanGUID,m_SectionList,strError) = False then
  begin
    Box(strError);
    Exit;
  end;

  for I := 0 to m_SectionList.Count - 1 do
  begin
    node := tvQuDuan.Items.AddChild(nil,m_SectionList.Items[i].strSectionName);
    node.Data := m_SectionList.Items[i];
  end;
  result := True;
end;


procedure TFrmPrintJieShi.UserDetailDSCheckEOF(Sender: TObject;
  var Eof: Boolean);
begin
  if m_MasterNo = 1 then
  begin
    if m_UpDDMLList.Count > 0 then
      Eof := m_DetailNo > m_UpDDMLList.Count
    else  //如果没有上行记录
      eof := m_DetailNo > m_DownDDMLList.Count
  end
  else
  begin
    Eof := m_DetailNo > m_DownDDMLList.Count ;
  end;
end;

procedure TFrmPrintJieShi.UserDetailDSFirst(Sender: TObject);
begin
  m_DetailNo := 1;
end;

function TFrmPrintJieShi.rft2Text(strRtf: string): string;
var
  richedit :TRichEdit;
begin
  Result := '';
  richedit := TRichEdit.Create(nil);
   richedit.ParentWindow := GetDesktopWindow();
  try
    richedit.SelText := strRtf;
  except
  end;
  try
    result := richedit.Text;
    //ShowMessage(Result);
  finally
    richedit.Free;
  end;
end;

procedure TFrmPrintJieShi.tvQuDuanClick(Sender: TObject);
var
  strDH,strGUID,strQDH,strXKSecName :string;
  node:TTreeNode;
  section:TSection;
begin
  node := tvQuDuan.Selected;
  if node = nil  then Exit;
  section := TSection(node.Data);
  strDH := section.strDH ;
  strQDH := section.strQDH;
  strGUID :=section.strSectionGUID ;
  strXKSecName := section.strSectionName ;

  GetXKQDJieShi(strDH,strQDH,strXKSecName);
end;


procedure TFrmPrintJieShi.UserDetailDSGetValue(const VarName: string;
  var Value: Variant);
var
  ddmlInfo :RDDMLInfo;
begin
  if m_MasterNo = 1 then
  begin
    if m_UpDDMLList.Count > 0 then
      ddmlInfo := m_UpDDMLList.Items[m_DetailNo-1]
    else
      ddmlInfo := m_DownDDMLList.Items[m_DetailNo-1];
    Value := Format('%d、△运行揭示调度命令%d号：%s',[m_DetailNo,ddmlInfo.nCommandNo,rft2Text(ddmlInfo.strOrder)])
  end
  else
  begin
    ddmlInfo := m_DownDDMLList.Items[m_DetailNo-1];
    Value := Format('%d、△运行揭示调度命令%d号：%s',[m_DetailNo,ddmlInfo.nCommandNo,rft2Text(ddmlInfo.strOrder)])
  end;
end;

procedure TFrmPrintJieShi.UserDetailDSNext(Sender: TObject);
begin
  Inc(m_DetailNo);
end;

procedure TFrmPrintJieShi.UserDetailDSPrior(Sender: TObject);
begin
  Dec(m_DetailNo);
end;

procedure TFrmPrintJieShi.UserMasterDSCheckEOF(Sender: TObject;
  var Eof: Boolean);
var
  _count :Integer;
begin
  _count := 0;
  if m_DownDDMLList.Count > 0 then
    Inc(_count);
  if m_UpDDMLList.Count > 0 then
    Inc(_count);
  Eof := m_MasterNo > _count ;
end;


procedure TFrmPrintJieShi.UserMasterDSFirst(Sender: TObject);
begin
  m_MasterNo := 1;

end;


procedure TFrmPrintJieShi.UserMasterDSGetValue(const VarName: string;
  var Value: Variant);
begin
  if m_MasterNo = 1 then
  begin
    if m_UpDDMLList.Count > 0 then
      value := m_SectionList.Items[m_MainNo-1].strSectionName + '(上行)'
    else
      value := m_SectionList.Items[m_MainNo-1].strSectionName + '(下行)'
  end
  else
  begin
    Value := m_SectionList.Items[m_MainNo-1].strSectionName + '(下行)';
  end;
end;


procedure TFrmPrintJieShi.UserMasterDSNext(Sender: TObject);
begin
  Inc(m_MasterNo);
end;

procedure TFrmPrintJieShi.UserMasterDSPrior(Sender: TObject);
begin
  Dec(m_MasterNo);
end;

end.
