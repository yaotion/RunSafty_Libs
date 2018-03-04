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
    {д�������б�}
    m_SectionList: TSectionList;
    {������ʾд������}
    m_MainNo :Integer;
    {������ʾ��������Ϣ}
    m_MasterNo: Integer;
    {������ʾ��ϸ��Ϣ}
    m_DetailNo: Integer;
    {���зֽ��ĵ�������}
    m_DDMLList:TDDMLList;
    {�������н�����ʾ}
    m_UpDDMLList :TDDMLList;
    {�������н�����ʾ}
    m_DownDDMLList :TDDMLList;
    {���д���������}
    m_KDXKInterfaceComponent:TKDXKInterfaceComponent;
    //��Ա�ƻ�
    m_ChuQinPlan:RRsChuQinPlan;
    //������Ա
    m_Trainman:RRsTrainman;
    //д������web�ӿ�
    m_webWriteCard :TRSLCWriteCardSection;
    //������¹���
    m_DlDownload:TDDMLDownload;
  private
    {����:��ȡ������Ϣ}
    function ReadQuDuan(strPlanGUID:string):Boolean;
    {���ܣ���ȡ��Ӧд�����εĽ�����ʾ}
    procedure GetXKQDJieShi(strDH,strQDH,strXKQDName:string);
    {����:��ȡ�ֽ��Ľ�����ʾ}
    function GetJiaoFuJieShi():Boolean;
    {����:rtf�ı�ת��Ϊ��ͨ�ı�}
    function rft2Text(strRtf: string): string;
    {����:��ȡ��Чʱ��}
    function GetValidTime: string;
    function AppPath: string;
  public
      {����:��ʾ��ӡ������ʾ}
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
    mmo.Text := '�� �� �� ʾ';
    mmo := tfrxmemoview(frxrprt1.FindObject('mmJiaoFuDate'))  ;
    mmo.Text := '�������ڣ�' + FormatDateTime('yyyy��mm��dd�� HHʱnn��',Now()) +
          '  ��Чʱ���� ' + self.GetValidTime();
    mmo := TfrxMemoView(frxrprt1.FindObject('mmDDY'));
    mmo.Text := '����Ա��(ǩ��)';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmSiJi'));
    mmo.Text := '˾����(ǩ��)' +  m_Trainman.strTrainmanName;
    mmo := TfrxMemoView(frxrprt1.FindObject('mmJCH'));
    mmo.Text := '�����ţ�';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmJCH_text'));
    mmo.Text := m_ChuQinPlan.TrainPlan.strTrainNumber;
    mmo := TfrxMemoView(frxrprt1.FindObject('mmCheCi'));
    mmo.Text := '���Σ�';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmCheCi_text'));
    mmo.Text := m_ChuQinPlan.TrainPlan.strTrainNo;
    mmo := TfrxMemoView(frxrprt1.FindObject('mmJieShouSJ'));
    mmo.Text := '���ս�ʾʱ�䣺';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmPage'));
    mmo.Text := '��            ҳ';
    mmo := TfrxMemoView(frxrprt1.FindObject('mmTotalPage'));
    mmo.Text := '��            ҳ';
    //frxrprt1.ShowReport() ;
    frxrprt1.PrepareReport();
    frxrprt1.PrintOptions.ShowDialog := False;
    frxrprt1.Print;
    //Exit;
  end;

  Application.ProcessMessages;
  Box('������ʾ��ӡ���,��˶�..');
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
  result := Format('%.4d��%.2d��%.2d�� %.2dʱ%.2d��',[intAry[0],intAry[1],
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
    {���ַ�ʽ�õ�mmo�ؼ�,��ʽ1}
    for i := 0 to  pagefooter.Objects.Count -1 do
    begin
      mmo := TfrxMemoView(pagefooter.Objects.Items[i]) ;
      if mmo.Name = 'mmDDY' then
         mmo.Text := '����Ա��(ǩ��)';
      if mmo.Name = 'mmSiJi' then
        mmo.Text := '˾����(ǩ��)';
    end;

  end
  else
  begin
    {���ַ�ʽ�õ�mmo�ؼ�,��ʽ2}
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
  dtPrint := IncMinute(dtPlan,-10);// ����ʱ�� -10����,֮��Ϳ��Դ�ӡ������ʾ
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
    box('δ��⵽�������������ļ�');
    Exit;
  end;
  m_KDXKInterfaceComponent.KDXKDataPath := AppPath + DDMLFile_DIRName ;
  m_KDXKInterfaceComponent.DataBaseType := ktdbAccess;

  try
    m_KDXKInterfaceComponent.GetDDMLList(m_DDMLList);
  except on e:Exception do
    ShowMessage('��ȡ���������쳣!'+ e.Message);
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
        if (ddmlInfo.nUpDown = 0) or (ddmlInfo.nUpDown = 2)then//����
          m_UpDDMLList.Add(ddmlInfo)
        else
          m_DownDDMLList.Add(ddmlInfo);
      end;
      //lst1.Items.Add(IntToStr(ddmlInfo.nCommandNo) +' ' + IntToStr(ddmlInfo.nJWDID) + ' ' + IntToStr(ddmlInfo.nYYQDID) +'__' + IntToStr(ddmlInfo.nUpDown) + '-����1-' + IntToStr(ddmlInfo.isDelete));
    end;
  end;
  if m_UpDDMLList.Count > 0 then
    edtJieShi.Lines.Add(strXKQDName + '(����)');
  
  for i := 0 to m_UpDDMLList.Count - 1 do
  begin
    ddmlInfo := m_UpDDMLList.Items[i];
    try
      //redt1.Lines.Append('��������:'+ IntToStr(ddmlInfo.nCommandNo) + '��:' + rft2Text(ddmlInfo.strOrder));
      edtJieShi.Lines.add(IntToStr(i+1) + ' ��������:'+ IntToStr(ddmlInfo.nCommandNo) + '��:   ' + rft2Text(ddmlInfo.strOrder));
      //redt1.Lines.add(ddmlInfo.strOrder);
    except

    end;
  end ;
  if m_DownDDMLList.Count > 0 then
    edtJieShi.Lines.Add(strXKQDName + '(����)');
    
  for i := 0 to m_DownDDMLList.Count - 1 do
  begin
    ddmlInfo := m_DownDDMLList.Items[i];
    try
      //redt1.Lines.Append('��������:'+ IntToStr(ddmlInfo.nCommandNo) + '��:' + rft2Text(ddmlInfo.strOrder));
      edtJieShi.Lines.add(IntToStr(i+1) +  '  ��������:'+ IntToStr(ddmlInfo.nCommandNo) + '��:   ' + rft2Text(ddmlInfo.strOrder));
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
{����:��ȡ������Ϣ}
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
    else  //���û�����м�¼
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
    Value := Format('%d�������н�ʾ��������%d�ţ�%s',[m_DetailNo,ddmlInfo.nCommandNo,rft2Text(ddmlInfo.strOrder)])
  end
  else
  begin
    ddmlInfo := m_DownDDMLList.Items[m_DetailNo-1];
    Value := Format('%d�������н�ʾ��������%d�ţ�%s',[m_DetailNo,ddmlInfo.nCommandNo,rft2Text(ddmlInfo.strOrder)])
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
      value := m_SectionList.Items[m_MainNo-1].strSectionName + '(����)'
    else
      value := m_SectionList.Items[m_MainNo-1].strSectionName + '(����)'
  end
  else
  begin
    Value := m_SectionList.Items[m_MainNo-1].strSectionName + '(����)';
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
