unit uFrmTrainmanManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, PngSpeedButton, ExtCtrls, StdCtrls,
   RzCmboBx,uArea, uTrainman, PngCustomButton, RzPanel,
  RzStatus,uTFSystem,uWorkShop,uGuideGroup,
  uTrainJiaoLU,uSaftyEnum, Grids, AdvObj, BaseGrid,uGlobalDM, AdvGrid,
  Mask, RzEdit,uJWD,StrUtils,uLCBaseDict,uLCTrainmanMgr;

type
  TfrmTrainmanManage = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    comboWorkShop: TRzComboBox;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    comboTrainmanJiaolu: TRzComboBox;
    Label5: TLabel;
    comboGuideGroup: TRzComboBox;
    Label6: TLabel;
    btnAppendTrainman: TPngSpeedButton;
    btnModifyTrainman: TPngSpeedButton;
    btnQuery: TPngSpeedButton;
    btnDeleteTrainman: TPngSpeedButton;
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    btnImport: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    RzPanel1: TRzPanel;
    strGridTrainman: TAdvStringGrid;
    edtTrainmanNumber: TRzEdit;
    edtTrainmanName: TRzEdit;
    comboPhoto: TRzComboBox;
    comboFingerCount: TRzComboBox;
    dlgOpen1: TOpenDialog;
    rzpnl1: TRzPanel;
    btnPrePage: TButton;
    btnNextPage: TButton;
    edtGoPage: TEdit;
    btn3: TButton;
    lbl1: TLabel;
    lbl_PageIndex: TLabel;
    lbl_TotalPages: TLabel;
    lblRecordCount: TLabel;
    lbl2: TLabel;
    Label7: TLabel;
    comboArea: TRzComboBox;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteTrainmanClick(Sender: TObject);
    procedure btnAppendTrainmanClick(Sender: TObject);
    procedure btnModifyTrainmanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comboWorkShopChange(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtTrainmanNumberKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrePageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure comboAreaChange(Sender: TObject);
    procedure edtTrainmanNumberExit(Sender: TObject);
  private
    /// <summary>是否为查找乘务员的窗口</summary>
    m_bIsQueryForm:Boolean;
    /// <summary>当前选中的人员</summary>
    m_SelectTrainMan:RRsTrainman;

    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //人员列表    
    m_TrainmanArray : TRsTrainmanArray;
    //人员信息当前页
    m_nCurPage:Integer;
    //人员信息总页数
    m_nTotalPages:Integer;
    //人员信息总个数
    m_nTotalCount:Integer;
    //初始化界面
    procedure Init;
    //查询乘务员信息
    procedure QueryTrainmans;
    //导出人员信息
    procedure ExportTrainmans;
    //导入人员信息
    procedure ImportTrainmans;
    //初始化机务段
    procedure InitJWD();
    //初始化车间
    procedure InitWorkShop();
    //初始化车间
    procedure InitTrainJiaoLu();
    procedure InitGuideGroup();
    {功能:显示分页信息}
    procedure ShowPageInfo();
  public
    //打开乘务员查询窗口
    class procedure OpenTrainmanQuery;
    property bIsQueryForm:Boolean read m_bIsQueryForm write m_bIsQueryForm;
    property SelectTrainMan:RRsTrainman read m_SelectTrainMan;
  end;

implementation
uses
  uFrmUserInfoEdit,ComObj,uFrmProgressEx;
var
  trainmanManage :  TfrmTrainmanManage;  
{$R *.dfm}

procedure TfrmTrainmanManage.btnPrePageClick(Sender: TObject);
begin
  m_nCurPage := m_nCurPage -1;
  QueryTrainmans();

end;
procedure TfrmTrainmanManage.btn3Click(Sender: TObject);
var
  nPage:Integer;
begin
  if Trim(edtGoPage.Text) = '' then
  begin
    Box('页面号不能为空!');
    Exit;
  end;
  if TryStrToInt(Trim(edtGoPage.Text),nPage) = False then
  begin
    Box('页面号必须是数字!');
    Exit;
  end;

  if not( (nPage >= 1) and (nPage <= m_nTotalPages)) then
  begin
    Box('页面号必须为1到最大页面数之间的数字');
    Exit;
  end;
  m_nCurPage := nPage;
  QueryTrainmans();
end;

procedure TfrmTrainmanManage.btnAppendTrainmanClick(Sender: TObject);
begin
  if not AppendTrainmanInfo then
  begin
    exit;
  end;
  //btnQuery.Click;
end;

procedure TfrmTrainmanManage.btnCloseClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfrmTrainmanManage.btnDeleteTrainmanClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
  if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('没有可操作的司机','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0)  then
    exit;
  if Application.MessageBox('您确定要删除选中的司机吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];

  try
    m_RsLCTrainmanMgr.DeleteTrainman(strTrainmanGUID);
    btnQuery.Click;
    exit;
  except on e : exception do
    begin
      Box('删除失败：' + e.Message);
    end;
  end;
end;

procedure TfrmTrainmanManage.btnExportClick(Sender: TObject);
begin
  ExportTrainmans;
end;

procedure TfrmTrainmanManage.btnImportClick(Sender: TObject);
begin
  ImportTrainmans;
end;

procedure TfrmTrainmanManage.btnModifyTrainmanClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
    if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('没有可操作的司机','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0) then
    exit;

  if (strGridTrainman.Row > length(m_TrainmanArray))  then
    Exit;
  
  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];
  if not ModifyTrainmanInfo(strTrainmanGUID) then
  begin
    exit;
  end;
  //btnQuery.Click;
end;


procedure TfrmTrainmanManage.btnNextPageClick(Sender: TObject);
begin

  m_nCurPage := m_nCurPage +1;
  QueryTrainmans();
end;

procedure TfrmTrainmanManage.btnQueryClick(Sender: TObject);
begin
  m_nCurPage := 1;
  QueryTrainmans;
end;

procedure TfrmTrainmanManage.comboAreaChange(Sender: TObject);
begin
  InitWorkshop();
end;

procedure TfrmTrainmanManage.comboWorkShopChange(Sender: TObject);
begin
  InitGuideGroup();
  InitTrainJiaoLu();
end;

procedure TfrmTrainmanManage.edtTrainmanNumberExit(Sender: TObject);
var
  strJwd : string ;
  TrainmanNumber : string ;
  i : Integer ;
begin
  TrainmanNumber := edtTrainmanNumber.Text ;
  strJwd :=  LeftStr(TrainmanNumber,2) ;
  for I := 0 to comboArea.Items.Count - 1 do
  begin
    if comboArea.Values[i] =  strJwd  then
    begin
      comboArea.ItemIndex := i ;
      comboAreaChange(nil);
      Break ;
    end;
  end;
end;

procedure TfrmTrainmanManage.edtTrainmanNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btnQueryClick(nil);
end;

procedure TfrmTrainmanManage.ExportTrainmans;
var
  excelFile,trainmanGUID : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  trainman : RRsTrainman;
  i: Integer;
  strFinger2 :string;
begin
  if length(m_TrainmanArray) = 0 then
  begin
    Box('请先查询出您要导出的司机信息！');
    exit;
  end;
  if not GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    if not TBox('当前指纹仪未成功连接，将无法导出司机指纹信息，您还要继续吗？') then exit;
  end;
  if not dlgOpen1.Execute then exit;
  excelFile := dlgOpen1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(excelFile) then
    begin
      excelApp.workBooks.Open(excelFile);
       excelApp.Worksheets[1].activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end; 
    m_nIndex := 1;

    excelApp.Cells[m_nIndex,1].Value := '所属车间';
    excelApp.Cells[m_nIndex,2].Value := '所在区段';
    excelApp.Cells[m_nIndex,3].Value := '指导队';
    excelApp.Cells[m_nIndex,4].Value := '工号';
    excelApp.Cells[m_nIndex,5].Value := '姓名';

    excelApp.Cells[m_nIndex,6].Value := '职位';
    excelApp.Cells[m_nIndex,7].Value := '司机等级';
    excelApp.Cells[m_nIndex,8].Value := '驾驶工种';
    excelApp.Cells[m_nIndex,9].Value := '客货';
    excelApp.Cells[m_nIndex,10].Value := '关键人';
    excelApp.Cells[m_nIndex,11].Value := 'ABCD';
    excelApp.Cells[m_nIndex,12].Value := '电话';
    excelApp.Cells[m_nIndex,13].Value := '手机';
    excelApp.Cells[m_nIndex,14].Value := '地址';
    excelApp.Cells[m_nIndex,15].Value := '入职日期';
    excelApp.Cells[m_nIndex,16].Value := '就职日期';

    excelApp.Cells[m_nIndex,17].Value := '指纹1';
    excelApp.Cells[m_nIndex,18].Value := '指纹2';
    
    Inc(m_nIndex);
    for i := 0 to Length(m_TrainmanArray) - 1 do
    begin
      trainmanGUID :=  m_TrainmanArray[i].strTrainmanGUID;
      m_RsLCTrainmanMgr.GetTrainman(trainmanGUID,trainman);
      if trainman.strTrainmanGUID <> '' then
      begin
        excelApp.Cells[m_nIndex,1].Value := trainman.strWorkShopName;
        excelApp.Cells[m_nIndex,2].Value := trainman.strTrainJiaoluName;
        excelApp.Cells[m_nIndex,3].Value := trainman.strGuideGroupName;
        excelApp.Cells[m_nIndex,4].Value := trainman.strTrainmanNumber;
        excelApp.Cells[m_nIndex,5].Value := trainman.strTrainmanName;

        excelApp.Cells[m_nIndex,6].Value := TRsPostNameAry[trainman.nPostID];
        excelApp.Cells[m_nIndex,7].Value := IntToStr(trainman.nDriverLevel);
        excelApp.Cells[m_nIndex,8].Value := TRsDriverTypeNameArray[trainman.nDriverType];
        excelApp.Cells[m_nIndex,9].Value := TRsKeHuoNameArray[trainman.nKeHuoID];
        excelApp.Cells[m_nIndex,10].Value := '';
        if trainman.bIsKey > 0 then
          excelApp.Cells[m_nIndex,10].Value := '√';
        excelApp.Cells[m_nIndex,11].Value := trainman.strABCD;
        excelApp.Cells[m_nIndex,12].Value := trainman.strTelNumber;
        excelApp.Cells[m_nIndex,13].Value := trainman.strMobileNumber;
        excelApp.Cells[m_nIndex,14].Value := trainman.strAdddress;
        excelApp.Cells[m_nIndex,15].Value := FormatDateTime('yyyy-MM-dd',trainman.dtRuZhiTime);
        excelApp.Cells[m_nIndex,16].Value := FormatDateTime('yyyy-MM-dd',trainman.dtJiuZhiTime);
        if GlobalDM.FingerPrintCtl.InitSuccess then
        begin
          if not (VarIsEmpty(trainman.FingerPrint1) or VarIsNull(trainman.FingerPrint1)) then
          begin
            strFinger2 := GlobalDM.FingerPrintCtl.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint1);
            excelApp.Cells[m_nIndex,17].Value := strFinger2;
          end;
          if not (VarIsEmpty(trainman.FingerPrint2) or VarIsNull(trainman.FingerPrint2)) then
          begin
            strFinger2 := GlobalDM.FingerPrintCtl.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint2);
            excelApp.Cells[m_nIndex,18].Value := strFinger2;
          end;
        end;
      end;
      TfrmProgressEx.ShowProgress('正在导出司机信息，请稍后',i + 1,length(m_TrainmanArray));
      Inc(m_nIndex);
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('导出完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmTrainmanManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  trainmanManage := nil;
end;

procedure TfrmTrainmanManage.FormCreate(Sender: TObject);
begin
  m_bIsQueryForm := False;
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);


  //机务段
  m_nCurPage := 1;
  m_nTotalCount := 0;
  m_nTotalPages := 0;
end;

procedure TfrmTrainmanManage.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
end;

procedure TfrmTrainmanManage.FormShow(Sender: TObject);
begin
  FillChar(m_SelectTrainMan,SizeOf(m_SelectTrainMan),0);
  m_SelectTrainMan.strTrainmanGUID := '';
  btnAppendTrainman.Visible := not m_bIsQueryForm;
  btnModifyTrainman.Visible := not m_bIsQueryForm;
  btnDeleteTrainman.Visible := not m_bIsQueryForm;
  btnQueryClick(nil);
end;

procedure TfrmTrainmanManage.ImportTrainmans;
var
  excelApp: Variant;
  nIndex,nTotalCount : integer;
  strTrainmanNumber :string;
  trainman : RRsTrainman;
  trainmanOld : RRsTrainman;
  strFinger2 : string;
  kehuo : TRsKehuo;
  post : TRsPost;
  driverType : TRsDriverType;
begin
  if not GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    if not TBox('当前指纹仪未成功连接，将无法导出司机指纹信息，您还要继续吗？') then exit;
  end;

  if not dlgOpen1.Execute then exit;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(dlgOpen1.FileName);
    excelApp.Worksheets[1].activate;
    nIndex := 2;
    nTotalCount := 0;
    while true do
    begin
      strTrainmanNumber := excelApp.Cells[nIndex,4].Value;
      if strTrainmanNumber = '' then break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;
    if nTotalCount = 0 then
    begin
       Application.MessageBox('没有可导入的乘务员信息！','提示',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    nIndex := 2;

    for nIndex := 2 to nTotalCount + 1 do      
    begin
      trainman.strTrainmanGUID := NewGUID;

      trainman.nTrainmanState := tsNil;
      trainman.dtCreateTime := GlobalDM.GetNow;

      trainman.strWorkShopGUID := RsLCBaseDict.LCWorkShop.GetWorkShopGUIDByName(excelApp.Cells[nIndex,1].Value);
      trainman.strTrainJiaoluGUID := RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluGUIDByName(excelApp.Cells[nIndex,2].Value);
      trainman.strGuideGroupGUID := RsLCBaseDict.LCGuideGroup.GetGuideGroupGUIDByName(excelApp.Cells[nIndex,3].Value);

      trainman.strTrainmanNumber := excelApp.Cells[nIndex,4].Value;
      trainman.strTrainmanName := excelApp.Cells[nIndex,5].Value;

      for post := low(TRsPost) to high(TRsPost) do
      begin
        if TRsPostNameAry[post] = excelApp.Cells[nIndex,6].Value then
          trainman.nPostID := post;        
      end;
      trainman.nDriverLevel := StrToInt(excelApp.Cells[nIndex,7].Value);

      for driverType := low(TRsDriverType) to high(TRsDriverType) do
      begin
        if TRsDriverTypeNameArray[driverType] =  excelApp.Cells[nIndex,8].Value then
           trainman.nDriverType := driverType;
      end;
      
      for kehuo := low(TRsKehuo) to high(TRsKehuo) do
      begin
        if TRsKeHuoNameArray[kehuo] = excelApp.Cells[nIndex,9].Value then
          trainman.nKeHuoID := kehuo;
      end;

      trainman.bIsKey  := 0;
      if excelApp.Cells[nIndex,10].Value <> '' then
        trainman.bIsKey := 1;
      trainman.strABCD := excelApp.Cells[nIndex,11].Value;
      trainman.strTelNumber := excelApp.Cells[nIndex,12].Value;
      trainman.strMobileNumber := excelApp.Cells[nIndex,13].Value;
      trainman.strAdddress := excelApp.Cells[nIndex,14].Value;
      trainman.dtRuZhiTime := StrToDate(excelApp.Cells[nIndex,15].Value);
      trainman.dtJiuZhiTime := StrToDate(excelApp.Cells[nIndex,16].Value);
      trainman.strJP := GlobalDM.GetHzPy(excelApp.Cells[nIndex,5].Value);
      if GlobalDM.FingerPrintCtl.InitSuccess then
      begin
        if not (VarIsEmpty(trainman.FingerPrint1) or VarIsNull(trainman.FingerPrint1)) then
        begin
          strFinger2 := GlobalDM.FingerPrintCtl.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint1);
          excelApp.Cells[nIndex,17].Value := strFinger2;
        end;
        if not (VarIsEmpty(trainman.FingerPrint2) or VarIsNull(trainman.FingerPrint2)) then
        begin
          strFinger2 := GlobalDM.FingerPrintCtl.ZKFPEngX.EncodeTemplate1(trainman.FingerPrint2);
          excelApp.Cells[nIndex,18].Value := strFinger2;
        end;
      end;
      if not m_RsLCTrainmanMgr.ExistNumber('',trainman.strTrainmanNumber) then
        m_RsLCTrainmanMgr.AddTrainman(trainman)
      else
      begin
        //如果工号存在就仅修改电话号码
        m_RsLCTrainmanMgr.GetTrainmanByNumber(trainman.strTrainmanNumber,trainmanOld);
        trainman.strTrainmanGUID :=  trainmanOld.strTrainmanGUID ;
        m_RsLCTrainmanMgr.UpdateTrainmanTel(trainmanOld.strTrainmanGUID,trainman.strTelNumber,
          trainman.strMobileNumber,trainmanOld.strAdddress,trainmanOld.strRemark)  ;
      end;
      TfrmProgressEx.ShowProgress('正在导入司机信息，请稍后',nIndex - 1,nTotalCount);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('导入完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmTrainmanManage.InitJWD();
var
  i:Integer;
  JWDArray:TRsJWDArray;
  strError : string;
begin
  if not (RsLCBaseDict.LCJwd.GetAllJwdList(JWDArray,strError)) then
  begin
    box(strError);
    exit;
  end;
  comboArea.Items.Clear;
  comboArea.Values.Clear;
  comboArea.AddItemValue('全部人员','');
  for i := 0 to length(JWDArray) - 1 do
  begin
    comboArea.AddItemValue(JWDArray[i].strName,JWDArray[i].strUserCode);
  end;
  comboArea.ItemIndex := comboArea.Values.IndexOf(LeftStr(GlobalDM.SiteInfo.strSiteIP,2));
end;
//初始化车间
procedure TfrmTrainmanManage.InitWorkShop();
var
  i:integer;
  workshopArray : TRsWorkShopArray;
  strAreaGUID:string;
  Error: string;
begin
  if leftStr(GlobalDM.SiteInfo.strSiteIP,2) = comboArea.Values[comboArea.ItemIndex] then
    strAreaGUID := GlobalDM.SiteInfo.strAreaGUID
  else
    strAreaGUID := comboArea.Values[comboArea.ItemIndex];
  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,workshopArray,Error) then
  begin
    Box(Error);
  end;
  comboWorkShop.Items.Clear;
  comboWorkShop.Values.Clear;
  comboWorkShop.AddItemValue('全部车间','');
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  if comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID) >0 then
    comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID)
  else
    comboWorkShop.ItemIndex := 0;

  comboWorkShopChange(nil);

end;
procedure TfrmTrainmanManage.Init;
begin
  InitJWD();
  InitWorkShop();
  //InitGuideGroup();
  //InitTrainJiaoLu();
end;

procedure TfrmTrainmanManage.InitGuideGroup;
var
  guideGroupArray : TRsGuideGroupArray;
  i: Integer;
  workShopGUID : string;
begin
  comboGuideGroup.Items.Clear;
  comboGuideGroup.Values.Clear;
  comboGuideGroup.AddItemValue('全部指导队','');
  comboGuideGroup.ItemIndex := 0;

  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //添加指导队信息
    RsLCBaseDict.LCGuideGroup.GetGuideGroupOfWorkShop(workShopGUID,guideGroupArray);
    for i := 0 to length(guideGroupArray) - 1 do
    begin
      comboGuideGroup.AddItemValue(guideGroupArray[i].strGuideGroupName,
          guideGroupArray[i].strGuideGroupGUID);
    end;
  end;
end;


procedure TfrmTrainmanManage.InitTrainJiaoLu;
var
  trainJiaoluArray : TRsTrainJiaoluArray;
  i: Integer;
  workShopGUID : string;
begin
  comboTrainmanJiaolu.Items.Clear;
  comboTrainmanJiaolu.Values.Clear;
  comboTrainmanJiaolu.AddItemValue('全部区段','');
  comboTrainmanJiaolu.ItemIndex := 0;

  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //添加区段信息
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(workShopGUID,trainJiaoluArray);
    for i := 0 to length(trainJiaoluArray) - 1 do
    begin
      comboTrainmanJiaolu.AddItemValue(trainJiaoluArray[i].strTrainJiaoluName,
          trainJiaoluArray[i].strTrainJiaoluGUID);
    end;
  end;
end;


class procedure TfrmTrainmanManage.OpenTrainmanQuery;
begin
  if trainmanManage = nil then
  begin
    trainmanManage :=  TfrmTrainmanManage.Create(nil);
    trainmanManage.Init;
    trainmanManage.Show;
  end
  else
  begin
    trainmanManage.Show;
    trainmanManage.WindowState := wsMaximized;
  end;
end;

procedure TfrmTrainmanManage.QueryTrainmans;
var
  QueryTrainman : RRsQueryTrainman;
  i: Integer;
  strTemp : string;

begin
  //当前查询结果共有0人
  QueryTrainman.strTrainmanNumber := Trim(edtTrainmanNumber.Text);
  QueryTrainman.strTrainmanName := Trim(edtTrainmanName.Text);

  QueryTrainman.strAreaGUID := comboArea.Values[comboArea.ItemIndex];
  //如果是本段人员才进行交路和车间的选择
  if QueryTrainman.strAreaGUID = LeftStr(GlobalDM.SiteInfo.strSiteIP,2) then
  begin
    QueryTrainman.strWorkShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
    QueryTrainman.strTrainJiaoluGUID := comboTrainmanJiaolu.Values[comboTrainmanJiaolu.ItemIndex];
    QueryTrainman.strGuideGroupGUID := comboGuideGroup.Values[comboGuideGroup.ItemIndex];
  end;

  QueryTrainman.nFingerCount := comboFingerCount.ItemIndex - 1;
  QueryTrainman.nPhotoCount := comboPhoto.ItemIndex - 1;
  strGridTrainman.BeginUpdate;
  try
    try

      m_RsLCTrainmanMgr.QueryTrainmans_blobFlag(QueryTrainman,m_nCurPage,m_TrainmanArray,m_nTotalCount);
      statusSum.Caption := Format('当前查询结果共有%d人！',[length(m_TrainmanArray)]);
      strGridTrainman.ClearRows(1,9999);
      if length(m_TrainmanArray) = 0  then
        strGridTrainman.RowCount := 2
      else
        strGridTrainman.RowCount := Length(m_TrainmanArray) + 1;
      for i := 0 to Length(m_TrainmanArray) - 1 do
      begin
        with strGridTrainman do
        begin
          Cells[0,i + 1] := IntToStr(i+1);
          Cells[1,i + 1] := m_TrainmanArray[i].strWorkShopName;
          Cells[2,i + 1] := m_TrainmanArray[i].strTrainJiaoluName;
          Cells[3,i + 1] := m_TrainmanArray[i].strGuideGroupName;
          Cells[4,i + 1] := m_TrainmanArray[i].strTrainmanName;
          Cells[5,i + 1] := m_TrainmanArray[i].strTrainmanNumber;
          Cells[6,i + 1] := TRsPostNameAry[m_TrainmanArray[i].nPostID];
          Cells[7,i + 1] := TRsDriverTypeNameArray[m_TrainmanArray[i].nDriverType];
          Cells[8,i + 1] := TRsKeHuoNameArray[m_TrainmanArray[i].nKeHuoID];
          strTemp := '';
          if m_TrainmanArray[i].bIsKey <> 0 then
            strTemp := '是';
          Cells[9,i + 1] := strTemp;
          Cells[10,i + 1] := m_TrainmanArray[i].strABCD;
          Cells[11,i + 1] := m_TrainmanArray[i].strTelNumber;
          Cells[12,i + 1] := m_TrainmanArray[i].strMobileNumber;
          Cells[13,i + 1] := m_TrainmanArray[i].strAdddress;
          Cells[14,i + 1] := TRsTrainmanStateNameAry[m_TrainmanArray[i].nTrainmanState];
          Cells[15,i + 1] := FormatDateTime('yy-MM-dd',m_TrainmanArray[i].dtRuZhiTime);
          Cells[16,i + 1] := FormatDateTime('yy-MM-dd',m_TrainmanArray[i].dtJiuZhiTime);
          strTemp := '√';

          if (m_TrainmanArray[i].nFingerPrint1_Null = 0) then
            strTemp := '空';
          Cells[17,i + 1] := strTemp;
           strTemp := '√';
          if (m_TrainmanArray[i].nFingerPrint2_Null = 0) then
            strTemp := '空';
          Cells[18,i + 1] := strTemp;
          strTemp := '√';
          if (m_TrainmanArray[i].nPicture_Null = 0) then
            strTemp := '空';
          Cells[19,i + 1] := strTemp;
          
          Cells[99,i + 1] := m_TrainmanArray[i].strTrainmanGUID;
        end;
      end;
      ShowPageInfo();
    except on e : exception do
      begin
        Box('查询失败：' + e.Message);
      end;
    end;
  finally
    strGridTrainman.EndUpdate;
  end;
end;

procedure TfrmTrainmanManage.ShowPageInfo;
begin
  lbl_PageIndex.Caption := Format('第%d页',[m_nCurPage]);
  m_nTotalPages := m_nTotalCount div 100 + 1;
  lbl_TotalPages.Caption := Format('共%d页',[m_nTotalPages]);
  lblRecordCount.Caption := Format('共%d条记录',[m_nTotalCount]);
  
  if m_nCurPage = 1 then
    btnPrePage.Enabled := False
  else
    btnPrePage.Enabled := True;
  if m_nCurPage >= m_nTotalPages  then
    btnNextPage.Enabled := False
  else
    btnNextPage.Enabled := True;
end;

end.
