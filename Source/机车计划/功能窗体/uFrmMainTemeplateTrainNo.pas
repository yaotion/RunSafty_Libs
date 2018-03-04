unit uFrmMainTemeplateTrainNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, Grids, AdvObj, BaseGrid, AdvGrid,
  ExtCtrls, RzPanel, RzTabs, Buttons, PngSpeedButton,DateUtils,uTrainJiaolu,
  uTFMessageDefine,uTFMessageComponent,uRunSaftyMessageDefine,uLCTrainnos,
  uTemplateDayPlan,uTFSystem, RzCmboBx, RzStatus, ActnList,
  Menus, AdvSplitter,uTrainPlan,uSaftyEnum,uLCTrainPlan,uLCDayPlan,
  uLCDict_TrainJiaoLu,RsGlobal_TLB,uHttpWebAPI;


const

  DAY_NIGHT_START = 18 ;        //ҹ�࿪ʼʱ��
  DAY_NIGHT_END = 8 ;           //ҹ���ֹʱ��


  COL_TRAIN_STATE = 1;              //״̬
  COL_TRAIN_TRAINNO1_INDEX =2 ;     //����1
  COL_TRAIN_INFO_INDEX = 3 ;        //������Ϣ
  COL_TRAIN_TYPE_INDEX = 4 ;        //����
  COL_TRAIN_NUMBER_INDEX = 5 ;      //����
  COL_TRAIN_TRAINNO2_INDEX  = 6 ;   //����2
  COL_TRAIN_TRAINNO_INDEX = 7  ;    //�ɰ೵��
  COL_TRAIN_REMARK_INDEX  = 8 ;     //��ע

  COL_TRIAN_DAWEN_CHEXING = 2 ;     //���³���1
  COL_TRIAN_DAWEN_CHEHAO1 = 3 ;     //���³���1
  COL_TRIAN_DAWEN_CHEHAO2 = 4 ;     //���³���2
  COL_TRIAN_DAWEN_CHEHAO3 = 5 ;     //���³���3


type
  TFrmMainTemeplateTrainNo = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    dtpPlanStartDate: TRzDateTimePicker;
    RzPanel3: TRzPanel;
    btnLoadPlan: TPngSpeedButton;
    btnRefreshPaln: TPngSpeedButton;
    Label1: TLabel;
    cmbDayPlanType: TRzComboBox;
    btnAddPlan: TPngSpeedButton;
    btnDeletePlan: TPngSpeedButton;
    Panel2: TPanel;
    btnImportPlan: TPngSpeedButton;
    SaveDialog: TSaveDialog;
    RzStatusBar1: TRzStatusBar;
    statuspanelSum: TRzStatusPane;
    RzStatusPane1: TRzStatusPane;
    ProgressStatus1: TRzProgressStatus;
    RzPanel5: TRzPanel;
    RzPanel6: TRzPanel;
    Label4: TLabel;
    lstGroup: TListBox;
    RzPanel1: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    RzPanel2: TRzPanel;
    Label3: TLabel;
    btnSendPlan: TPngSpeedButton;
    strGridDaWen: TAdvStringGrid;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    actCopyCell: TAction;
    actPasteCell: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    actInsert: TAction;
    actRemove: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    AdvSplitter1: TAdvSplitter;
    procedure FormDestroy(Sender: TObject);
    procedure btnSendPlanClick(Sender: TObject);
    procedure btnLoadPlanClick(Sender: TObject);
    procedure strGridTrainPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure strGridTrainPlanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridTrainPlanCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure strGridTrainPlanEditCellDone(Sender: TObject; ACol,
      ARow: Integer);
    procedure strGridTrainPlanKeyPress(Sender: TObject; var Key: Char);
    procedure btnDeletePlanClick(Sender: TObject);
    procedure btnAddPlanClick(Sender: TObject);
    procedure btnImportPlanClick(Sender: TObject);
    procedure lstGroupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstGroupDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure strGridDaWenCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure strGridDaWenCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure strGridDaWenGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridDaWenEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure strGridTrainPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure strGridDaWenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actCopyCellExecute(Sender: TObject);
    procedure actPasteCellExecute(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actRemoveExecute(Sender: TObject);
    procedure strGridTrainPlanGetEditorType(Sender: TObject; ACol,
      ARow: Integer; var AEditor: TEditorType);
    procedure AdvSplitter1Moved(Sender: TObject);
    procedure lstGroupMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure cmbDayPlanTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure strGridDaWenGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);

  private
    { Private declarations }
    //��ʼ��
    procedure InitData(IsReadOnly:Boolean);
    //��ʼ������
    procedure InitUI(IsReadOnly:Boolean) ;
    //��ʼ��ʱ��
    procedure InitDateTime();
    //��ʼ��ָ���ļƻ��İ���������
    procedure InitGroup();
    //��ռ��ع��ļƻ�
    procedure ClearPlan();
    //�Ƿ��Ѿ����ع��ƻ�
    function IsLoadedPlan():Boolean;
    //��ʼ����ǰ���εļƻ�
    procedure ShowTrainPlan(GroupID,GroupType:Integer);
    //��ʼ���ƻ�
    procedure InitTrainPlan();
    //��ȡѡ�еļƻ����
    function GetSelDayPlanType : Integer ;
    //��ȡѡ�е����ε�ID
    function GetSelGroupID:Integer;
    //��ȡѡ�����ε�����
    function GetSelGroupType:Integer ;
    //��ȡ��ǰ�����ͺ�����
    procedure GetDayPlanDate(out DayOrNight : Integer ; out dtBeginTime,dtEndTime : TDateTime);
    //��һ��ָ�������ƻ��ṹ����ӵ�ָ����GRID������
    procedure AddPlanToControl(DayPlanInfo:RsDayPlanInfo;nRow: Integer);
    //�����ƻ�
    procedure PublistPlan();
    //�޸ļƻ�Ϊ����״̬
    procedure SendPlan();
    //�·��ƻ�
    function  SendPlanMessage(PlanList:TStrings):Boolean;
    //���������б���Ϣ
    procedure PostWaiQinMessages(AType:Integer);
    //����������Ϣ
    procedure PostWaiQinMessage(MsgType:Integer;PlanGUID:string);
    //grid����
    procedure NextFocus();
    //���¼ƻ�
    procedure UpdateTrainPlan(nRow,nCol: Integer);
    //���´��¼ƻ�
    procedure UpdateDaWenPlan(nRow,nCol: Integer);
    //�޸ļƻ�
    procedure ModifyTrainPlan(PlanID:string;nRow,nCol: Integer);
    //�޸Ĵ��¼ƻ�
    procedure ModifyDaWenPlan(PlanID:string;nRow,nCol: Integer);
    //�����ƻ�
    function  CancelPlan(PlanList:TStrings):Boolean;
    //��ʽ������
    function FormatCX(SourceString : string) : string ;
    //��ʽ������
    function FormatCH(SourceString : string) : string ;
    //��ȡѡ�мƻ�
    procedure GetSelPlan(PlanList:TStrings);
    //���ݳ����ͻ�ȡ�̳���
    function GetTrainTypeName(LongName:string):string;
    //�����Ϣ
    procedure FillMessageWithPlan(TFMessage: TTFMessage;Plan: RRsTrainPlan);
      //�·���Ϣ
    procedure PostPlanMessage(TFMessageList: TTFMessageList);
  private
  //�Ƿ��޸�CELLS��ֵ
    m_bModifyedTrainPlan : Boolean;
    m_bModifyedDanWenPlan : Boolean ;
    //�г��ƻ�
    m_webTrainPlan : TRsLCTrainPlan ;
    //���еĳ�����Ϣ
    m_ArrayShortTrain: TRsShortTrainArray  ;
    //��ǰ�����Ƶĵ�Ԫ�������
    m_strCopyCellData : string ;
    //ͼ������
    m_webTrainnos : TRsLCTrainnos;
    m_nDayPlanID:Integer ;                      //���ܼƻ�
    m_dtStartDate:TDateTime ;                   //��ʼʱ��
    m_RsLCDayTemplate: TRsLCDayTemplate;
    m_DayPlan : TRsDayPlan ;                    //�����ƻ���Ϣ
    m_DayPlanInfoArray:RsDayPlanInfoArray;      //�����б�
    m_nSelectCol : Integer ;                  //��ǰѡ�е�ʵ����
    m_nSelectColDaWen : Integer;              //��ǰѡ�е�ʵ�ʴ���
    m_bIsReadOnly:Boolean;                  //�Ƿ���ֻ��
    m_LCTrainJiaolu : TRsLCTrainJiaolu;
    function FindLongTrainName(shortName: string): string;
    function GetWebUrl: string;
  public
    webAPIUtils : TWebAPIUtils;
  public
    { Public declarations }
    class procedure ManagerTemeplateTrainNo(IsReadOnly:Boolean = False );
  end;

var
  FrmMainTemeplateTrainNo: TFrmMainTemeplateTrainNo;

implementation
uses
  uDialogsLib, uDayPlanExportToXls, uGlobal;

{$R *.dfm}

{ TFrmMainTemeplateTrainNo }

procedure TFrmMainTemeplateTrainNo.actCopyCellExecute(Sender: TObject);
var
  selectCol : integer;
  selectRow : Integer ;
begin
  //��ȡѡ�еĵ�Ԫ��
  if strGridDaWen.Visible then
  begin

    if strGridDaWen.Row > Length(m_DayPlanInfoArray) then
      Exit;

    selectCol := strGridDaWen.RealColIndex(strGridDaWen.Col);
    selectRow := strGridDaWen.RealRowIndex(strGridDaWen.Row);
    m_strCopyCellData :=  strGridDaWen.Cells[selectCol,selectRow];
  end
  else
  begin
    if strGridTrainPlan.Row > Length(m_DayPlanInfoArray) then
      Exit;

    selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
    selectRow := strGridTrainPlan.RealRowIndex(strGridTrainPlan.Row);
    m_strCopyCellData :=  strGridTrainPlan.Cells[selectCol,selectRow];
  end;
end;

procedure TFrmMainTemeplateTrainNo.actInsertExecute(Sender: TObject);
begin
  btnAddPlanClick(Sender) ;
end;

procedure TFrmMainTemeplateTrainNo.actPasteCellExecute(Sender: TObject);
var
  selectCol : integer;
  selectRow : Integer ;
  bVaild : Boolean ;
begin
  //����ӿ���ʱ����
  Exit ;
  //��ȡѡ�еĵ�Ԫ��
  if strGridDaWen.Visible then
  begin

    if strGridDaWen.Row > Length(m_DayPlanInfoArray) then
      Exit;

    selectCol := strGridDaWen.RealColIndex(strGridDaWen.Col);
    selectRow := strGridDaWen.RealRowIndex(strGridDaWen.Row);
    strGridDaWen.Cells[selectCol,selectRow] := m_strCopyCellData ;

    bVaild := True ;
    strGridDaWenCellValidate(Self,selectCol,selectRow,m_strCopyCellData,bVaild);
    strGridDaWenEditCellDone(Self,selectCol,selectCol);
  end
  else
  begin
    if strGridTrainPlan.Row > Length(m_DayPlanInfoArray) then
      Exit;

    selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
    selectRow := strGridTrainPlan.RealRowIndex(strGridTrainPlan.Row);
    strGridTrainPlan.Cells[selectCol,selectRow] := m_strCopyCellData ;


    bVaild := True ;
    strGridTrainPlanCellValidate(Self,selectCol,selectRow,m_strCopyCellData,bVaild);
    strGridTrainPlanEditCellDone(Self,selectCol,selectCol);
  end;
end;

procedure TFrmMainTemeplateTrainNo.actRemoveExecute(Sender: TObject);
begin
  btnDeletePlanClick(Sender);  
end;


procedure TFrmMainTemeplateTrainNo.AddPlanToControl(DayPlanInfo: RsDayPlanInfo;
  nRow: Integer);
begin
 with strGridTrainPlan do
  begin
    Cells[0, nRow + 1] := IntToStr( nRow + 1 ) ;  //���
    Cells[COL_TRAIN_STATE, nRow + 1] := TRsPlanStateNameAry[DayPlanInfo.nPlanState];
    Cells[COL_TRAIN_TRAINNO1_INDEX, nRow + 1] := DayPlanInfo.strTrainNo1 ;
    Cells[COL_TRAIN_INFO_INDEX, nRow + 1] := DayPlanInfo.strTrainInfo ;
    Cells[COL_TRAIN_TYPE_INDEX, nRow + 1] := DayPlanInfo.strTrainTypeName ;
    Cells[COL_TRAIN_NUMBER_INDEX, nRow + 1] := DayPlanInfo.strTrainNumber ;
    Cells[COL_TRAIN_TRAINNO2_INDEX, nRow + 1] := DayPlanInfo.strTrainNo2 ;
    Cells[COL_TRAIN_TRAINNO_INDEX, nRow + 1] := DayPlanInfo.strTrainNo ;
    Cells[COL_TRAIN_REMARK_INDEX, nRow + 1] := DayPlanInfo.strRemark ;
    Cells[99, nRow + 1] := DayPlanInfo.strDayPlanGUID ;  //����GUID
  end;
end;

procedure TFrmMainTemeplateTrainNo.AdvSplitter1Moved(Sender: TObject);
begin
  lstGroup.Repaint ;
end;

procedure TFrmMainTemeplateTrainNo.btnAddPlanClick(Sender: TObject);
var
  dtBeginDate,dtEndDate : TDateTime ;
  nSelGroupID:Integer;
  DayOrNight : Integer ;
  DayPlanInfo:RsDayPlanInfo;
  DayPlanLog : RsDayPlanLog ;
begin

  GetDayPlanDate(DayOrNight,dtBeginDate,dtEndDate);

  nSelGroupID := GetSelGroupID ;
  if nSelGroupID < 0 then
    exit ;
  with DayPlanInfo do
  begin
    strDayPlanGUID:= NewGUID;  //�ƻ�ID
    nPlanState := psEdit ;     //�ƻ�״̬
    dtBeginTime:= dtBeginDate ;  //��ʼʱ��
    dtEndTime:= dtEndDate ;    //����ʱ��
    dtCreateTime:= GlobalDM.Now ;  //�����¼�
    strTrainNo1:= '' ;     //����1
    strTrainInfo:= '' ;    //������Ϣ
    strTrainNo2:= '';      //����2
    strTrainNo:= '' ;      //�����ĳ�����Ϣ
    strTrainTypeName:= ''; //����
    strTrainNumber:= '';  //����           //
    bIsTomorrow := 0 ;;  //�Ƿ��Ǵ���
    strRemark:= '' ;       //��ע
    //����ר��
    strDaWenCheXing := '' ;         //���³���
    strDaWenCheHao1 := '' ;         //���³���1
    strDaWenCheHao2 := '' ;         //���³���2
    strDaWenCheHao3 := '' ;         //���³���3
    nDayPlanID := m_nDayPlanID ;   //�ƻ���ID
    bIsSend := 0 ;                  //�Ƿ���
    nQuDuanID := nSelGroupID;      //������Ϣ
    strTrainPlanGUID := '';        //��Ӧ�Ļ����ƻ�
    nPlanID := -1 ;;              //��Ӧ�������ƻ�
  end;

    //�����޸���־
  with DayPlanLog do
  begin
    strLogGUID:= NewGUID;
    strlogType := 'Insert';
    strDayPlanGUID:= DayPlanInfo.strDayPlanGUID;  //�ƻ�ID
    strTrainNo1:= DayPlanInfo.strTrainNo1 ;     //����1
    strTrainInfo:= DayPlanInfo.strTrainInfo ;    //������Ϣ
    strTrainNo2:= DayPlanInfo.strTrainNo2 ;      //����2
    strRemark:= DayPlanInfo.strRemark ;       //��ע
    dtChangeTime:= GlobalDM.Now; //
  end;

  m_RsLCDayTemplate.LCPlan.AddDayPlan(DayPlanInfo,DayPlanLog);



  //���Ӽƻ���Ϣ
  if DayPlanInfo.bIsSend > 0 then
    PostWaiQinMessage(TFM_PLAN_WAIQIN_INSERT,DayPlanInfo.strDayPlanGUID) ;

  InitTrainPlan;
end;

procedure TFrmMainTemeplateTrainNo.btnDeletePlanClick(Sender: TObject);
var
  planList : TStringList;
begin
  planList := TStringList.Create;
  //��ȡҪɾ��������
  GetSelPlan(planList);
  
  //����Ƿ�û��ѡ��һ��
  if planList.Count = 0 then
  begin
    Application.MessageBox('û��Ҫɾ���ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox('��ȷ��Ҫɾ���˻����ƻ���', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  strGridTrainPlan.BeginUpdate;
  strGridDaWen.BeginUpdate ;
  //��ʼɾ��
  try
    try
      if CancelPlan(planList) then
        Application.MessageBox('ɾ���ƻ��ɹ���', '��ʾ', MB_OK + MB_ICONINFORMATION)
      else
        Application.MessageBox('ɾ���ƻ�ʧ�ܣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);

      InitTrainPlan;
    except
    on e: exception do
      begin
        Box(PChar(Format('ɾ��ʧ��,������Ϣ:%s��', [e.Message])));
      end;
    end;
  finally
    FreeAndNil(planList);
    strGridDaWen.EndUpdate ;
    strGridTrainPlan.EndUpdate;
  end;
end;

procedure TFrmMainTemeplateTrainNo.btnImportPlanClick(Sender: TObject);
  function GetPlanTitle(BeginDate, EndDate: TDateTime;
    DayOrNight: integer): string;
  var
    strTtitle : string ;
    strDateBegin : string ;
    strDateEnd : string ;
    strPlan : string;
  begin
    strDateBegin := FormatDateTime('yyyy-MM-dd',BeginDate) ;
    strDateEnd :=  FormatDateTime('yyyy-MM-dd',IncDay(BeginDate,1)) ;
    case DayOrNight  of
    ord(dptDay) :
      begin
        strPlan := ' �װ�ƻ�';
        strTtitle :=strDateBegin + strPlan ;
      end;
    ord(dptNight) :
      begin
        strPlan := ' ҹ��ƻ�';
        strTtitle := strDateBegin + strPlan ;
      end;
    ord(dtpAll) :
      begin
        strPlan := ' ȫ��ƻ�';
        strTtitle := strDateBegin + strPlan;
      end;
    else
      begin
        ;
      end;
    end;
    Result := strTtitle ;
  end;
var
  strFileName:string;
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
  DayPlanXls: TDayPlanXls;
  ExportData: TRsDayPlanExportData;
begin
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);
  SaveDialog.FileName := GetPlanTitle(dtBeginTime,dtEndTime,DayOrNight);
  if not SaveDialog.Execute(Self.Handle)  then
    exit ;
  strFileName := SaveDialog.FileName ;

  DayPlanXls := TDayPlanXls.Create;
  ExportData := TRsDayPlanExportData.Create;
  try
    m_RsLCDayTemplate.LCPlan.ExportPlan(dtBeginTime,dtEndTime,m_nDayPlanID,DayOrNight,ExportData);
    DayPlanXls.ExportToXls(dtBeginTime,dtEndTime,DayOrNight,ExportData,SaveDialog.FileName);
    TNoFocusBox.ShowBox('�������!',1000);
  finally
    DayPlanXls.Free;
    ExportData.Free;
  end;


end;

procedure TFrmMainTemeplateTrainNo.btnLoadPlanClick(Sender: TObject);
var
  dtBeginTime,DayPlanDate, dtEndTime: TDateTime;
  DayOrNight :Integer ;
  strMsg: string;
  NoFocusHint: TNoFocusHint;
begin
  DayPlanDate :=  dtpPlanStartDate.DateTime ;
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);
  if DayOrNight = Ord(dptDay) then  //�װ�
  begin
    strMsg := format('ȷ��Ҫ���� [%s-�װ�] �ƻ���?',[FormatDateTime('yyyy-MM-dd',DayPlanDate)]);
  end
  else if DayOrNight = Ord(dptNight)  then  //ҹ��
  begin
    strMsg := format('ȷ��Ҫ���� [%s-ҹ��] �ƻ���?',[FormatDateTime('yyyy-MM-dd',DayPlanDate)]);
  end
  else                            //ȫ��
  begin
    strMsg := format('ȷ��Ҫ���� [%s-ȫ��] �ƻ���?',[FormatDateTime('yyyy-MM-dd',DayPlanDate)]);
  end;


  if IsLoadedPlan then
  begin
    if not TBox('�Ƿ�ȷ���ٴμ���?')then
      Exit ;
    //��ռ��ع��ļƻ�
    ClearPlan;
    InitTrainPlan;
  end;

  NoFocusHint := TNoFocusHint.Create;
  NoFocusHint.Hint('���ڴ�ģ������ƻ����м��ؼƻ�,���Ե�...');
  try
    try
      m_RsLCDayTemplate.LCPlan.Load(dtBeginTime,dtEndTime,DayOrNight,m_nDayPlanID);
//      //���ؼƻ�
      InitTrainPlan;
    except on e: exception do
      begin
        Box(Format('��ģ������ƻ����м��ؼƻ�����%s', [e.Message]));
      end;
    end;
  finally
    NoFocusHint.Free;
  end;
end;

procedure TFrmMainTemeplateTrainNo.btnRefreshPalnClick(Sender: TObject);
begin
  InitTrainPlan;
end;

procedure TFrmMainTemeplateTrainNo.btnSendPlanClick(Sender: TObject);
begin
  //���ͼƻ�
  PublistPlan();
end;

function TFrmMainTemeplateTrainNo.CancelPlan(PlanList: TStrings): Boolean;
const
  MAIN_PLAN  = 1 ;
var
  i: integer;
  planGUID: string;
  DayPlanInfo:RsDayPlanInfo;
  trainPlan: RRsTrainPlan;
  TFMessageList: TTFMessageList;
  CancelPlanList: TStrings;
  TFMessage: TTFMessage;
  strError : string;
  DayPlanLog : RsDayPlanLog;
begin
  Result := false ;
  TFMessageList := TTFMessageList.Create;
  CancelPlanList := TStringList.Create ;
  try
    for i := 0 to PlanList.Count - 1 do
    begin
      planGUID := PlanList[i];
      if planGUID = '' then
        continue;


      //���ƻ��Ƿ����
      if not m_RsLCDayTemplate.LCPlan.GetPlan(planGUID, DayPlanInfo) then
        Continue  ;

      //ɾ���˰��ļƻ�
      if DayPlanInfo.strTrainPlanGUID <> '' then
      begin

        if m_webTrainPlan.GetTrainPlanByID(DayPlanInfo.strTrainPlanGUID, trainPlan) then
        begin
          if trainPlan.nPlanState >= pssent then
          begin
            TFMessage := TTFMessage.Create;
            TFMessage.msg := TFM_PLAN_TRAIN_CANCEL;
            FillMessageWithPlan(TFMessage,trainPlan);
            TFMessageList.Add(TFMessage);
            CancelPlanList.Add(DayPlanInfo.strTrainPlanGUID) ;
          end;
        end;
      end;

      //�����޸���־
      with DayPlanLog do
      begin
        strLogGUID:= NewGUID;
        strlogType := 'Delete';
        strDayPlanGUID:= planGUID;  //�ƻ�ID
        strTrainNo1:= DayPlanInfo.strTrainNo1 ;     //����1
        strTrainInfo:= DayPlanInfo.strTrainInfo ;    //������Ϣ
        strTrainNo2:= DayPlanInfo.strTrainNo2 ;      //����2
        strRemark:= DayPlanInfo.strRemark ;       //��ע
        dtChangeTime:= GlobalDM.Now; //
      end;

      
      //ɾ���üƻ�
      if not m_RsLCDayTemplate.LCPlan.DeleteDayPlan(planGUID,DayPlanLog) then
        Continue ;

      //����ɾ���ƻ���Ϣ
      if DayPlanInfo.bIsSend > 0 then
        PostWaiQinMessage(TFM_PLAN_WAIQIN_DELETE,DayPlanInfo.strDayPlanGUID) ;
    end;

    //������Ϣ
    if TFMessageList.Count > 0 then
      PostPlanMessage(TFMessageList);

    if CancelPlanList.Count > 0 then
    begin
      if not m_webTrainPlan.CancelTrainPlan(CancelPlanList, GlobalDM.User.ID,MAIN_PLAN,strError) then
      begin
        Box(strError);
        exit;
      end
    end ;

    Result := True ;
  finally
    CancelPlanList.Free ;
    TFMessageList.Free ;
  end;
end;

procedure TFrmMainTemeplateTrainNo.ClearPlan;
var
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
begin
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);
  m_RsLCDayTemplate.LCPlan.ClearDayPlan(dtBeginTime,dtEndTime,m_nDayPlanID);
end;

procedure TFrmMainTemeplateTrainNo.cmbDayPlanTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  ;
end;


procedure TFrmMainTemeplateTrainNo.FillMessageWithPlan(TFMessage: TTFMessage;
  Plan: RRsTrainPlan);
begin
  TFMessage.StrField['GUID'] := Plan.strTrainPlanGUID;
  TFMessage.dtField['dtStartTime'] := Plan.dtStartTime;
  TFMessage.StrField['strTrainTypeName'] := Plan.strTrainTypeName;
  TFMessage.StrField['strTrainNumber'] := Plan.strTrainNumber;
  TFMessage.StrField['strTrainNo'] := Plan.strTrainNo;
  TFMessage.StrField['siteName'] := GlobalDM.Site.Name;
  TFMessage.StrField['jiaoLuName'] := Plan.strTrainJiaoluName;
  TFMessage.StrField['jiaoLuGUID'] := Plan.strTrainJiaoluGUID;
end;

function TFrmMainTemeplateTrainNo.FindLongTrainName(shortName: string): string;
var
  I: Integer;
begin
  Result := 'δ�ҵ�';
  for I := 0 to length(m_ArrayShortTrain) - 1 do
  begin
    if SameText(m_ArrayShortTrain[i].strShortName,shortName) then
    begin
      Result := m_ArrayShortTrain[i].strLongName;
      Break;
    end;
  end;
end;

function TFrmMainTemeplateTrainNo.FormatCH(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  result := '';
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9'] then
    begin
      b := i;
      break;
    end;
  end;

  if b > 0 then
  begin
    e := b;
    for i := b + 1 to length(SourceString) do
    begin
      if (SourceString[i] in ['0'..'9','+','-']) then
      begin
         e := i;
      end else begin
        break;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  if length(result) = 1 then
    result := '000' + result;
   if length(result) = 2 then
    result := '00' + result;
  if length(result) = 3 then
    result := '0' + result;
end;

function TFrmMainTemeplateTrainNo.FormatCX(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  result := '';
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-'] then
    begin
      b := i;
      break;
    end;
  end;

  if b > 0 then
  begin
    e := b - 1;
    if SourceString[b] in ['A'..'Z','a'..'z'] then
    begin
      for i := b  to length(SourceString) do
      begin
        if (SourceString[i] in ['A'..'Z','a'..'z']) then
        begin
          e := i;
        end else begin
          break;
        end;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);

  IF SourceString <> '' then
  begin
    Result := FindLongTrainName(result) ;
  end;
end;

procedure TFrmMainTemeplateTrainNo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree ;
  FrmMainTemeplateTrainNo := nil ;
end;

procedure TFrmMainTemeplateTrainNo.FormDestroy(Sender: TObject);
begin
  m_webTrainnos.Free ;

  m_DayPlan.Free ;
  m_webTrainPlan.Free ;
  m_RsLCDayTemplate.Free;
  if m_LCTrainJiaolu <> nil then
    m_LCTrainJiaolu.Free;
end;

procedure TFrmMainTemeplateTrainNo.GetDayPlanDate(out DayOrNight: Integer;
  out dtBeginTime, dtEndTime: TDateTime);
var
  DayPlanDate : TDateTime ;
  str1,str2:string;
begin
  DayOrNight := GetSelDayPlanType ;
  DayPlanDate :=  dtpPlanStartDate.DateTime ;

  if DayOrNight = Ord(dptDay) then  //�װ�
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),8);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
  end
  else if DayOrNight = Ord(dptNight)  then  //ҹ��
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),18);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
  end
  else                            //ȫ��
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),18);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,18),-1);
  end;

  str1 := FormatDateTime('yyyy-MM-dd hh:mm:ss',dtBeginTime) ;
  str2 := FormatDateTime('yyyy-MM-dd hh:mm:ss',dtEndTime) ;
end;

function TFrmMainTemeplateTrainNo.GetSelDayPlanType: Integer;
begin
  Result := cmbDayPlanType.ItemIndex ;
end;

procedure TFrmMainTemeplateTrainNo.GetSelPlan(PlanList: TStrings);
var
  i : Integer;
  index :Integer ;
  planGUID : string;
begin
  if GetSelGroupType = 0 then
  begin
    for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
    begin
      index := strGridTrainPlan.SelectedRow[i];
      planGUID := strGridTrainPlan.Cells[99, index];
      if planGUID = '' then
        continue;
      PlanList.Add(planGUID);
    end;
  end
  else
  begin
    for i := 0 to strGridDaWen.SelectedRowCount - 1 do
    begin
      index := strGridDaWen.SelectedRow[i];
      planGUID := strGridDaWen.Cells[99, index];
      if planGUID = '' then
        continue;
      PlanList.Add(planGUID);
    end;
  end;
end;

function TFrmMainTemeplateTrainNo.GetSelGroupType: Integer;
var
  nIndex : Integer ;
begin
  Result := -1 ;
  nIndex := lstGroup.ItemIndex ;
  if nIndex < 0 then
    Exit ;
  Result :=  m_DayPlan.GoupList.Items[nIndex].IsDaWen ;
end;

function TFrmMainTemeplateTrainNo.GetTrainTypeName(LongName: string): string;
var
  I: Integer;
begin
  for I := 0 to Length(m_ArrayShortTrain) - 1 do
  begin
    if m_ArrayShortTrain[i].strLongName = LongName then
    begin
      Result := m_ArrayShortTrain[i].strShortName ;
      Break;
    end;
  end;
end;

function TFrmMainTemeplateTrainNo.GetWebUrl: string;
var
  strUrl : string;
begin
  strUrl := GlobalDM.WebAPI.URL;
  Result := strUrl ;

end;

function TFrmMainTemeplateTrainNo.GetSelGroupID: Integer;
var
  nIndex : Integer ;
begin
  Result := -1 ;
  nIndex := lstGroup.ItemIndex ;
  if nIndex < 0 then
    Exit ;
  Result :=  m_DayPlan.GoupList.Items[nIndex].ID ;
end;

procedure TFrmMainTemeplateTrainNo.InitData(IsReadOnly:Boolean);
var
  strDutyPlaceID : string ;
begin
  m_bModifyedTrainPlan := False ;
  m_bModifyedDanWenPlan := False ;
  m_dtStartDate := GlobalDM.Now;

  lstGroup.Style := lbOwnerDrawVariable ;
  lstGroup.ItemHeight := 30 ;

  strGridTrainPlan.Visible := True ;
  strGridDaWen.Visible := False ;
  m_LCTrainJiaolu := TRsLCTrainJiaolu.Create(GetWebUrl,GlobalDM.Site.Number,
    GlobalDM.Site.ID);
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=GlobalDM.WebAPI.Host;
  webAPIUtils.Port := GlobalDM.WebAPI.Port;
  webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';
  
  m_webTrainnos := TRsLCTrainnos.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webTrainPlan := TRsLCTrainPlan.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_RsLCDayTemplate := TRsLCDayTemplate.Create(webAPIUtils);
  m_DayPlan := TRsDayPlan.Create();
  //��ȡ���ڵ�
  strDutyPlaceID := GlobalDM.PlaceID ;
  if strDutyPlaceID = '' then
    raise Exception.Create('�ö����ܼƻ�Ϊ��,��������!');

  m_nDayPlanID := StrToInt(strDutyPlaceID)  ;
  InitDateTime ;
  InitGroup ;


  m_bIsReadOnly :=  IsReadOnly ;
  InitUI(IsReadOnly);

  SetLength(m_ArrayShortTrain,0);
  m_RsLCDayTemplate.LCSystem.GetTrainTypes(m_ArrayShortTrain);

end;

procedure TFrmMainTemeplateTrainNo.InitDateTime;
var
  nHour : Word ;
begin
  dtpPlanStartDate.DateTime := m_dtStartDate ;
  nHour := HourOf(Now) ;
    //�Ƿ���ҹ��
  //���쵼��ҹ��ļƻ�
  //ҹ�������ļƻ�
  if ( nHour >= DAY_NIGHT_END )  and ( nHour < DAY_NIGHT_START  ) then
  begin
    cmbDayPlanType.ItemIndex := 1 ;
  end
  else if ( nHour >= DAY_NIGHT_START )  or ( nHour < DAY_NIGHT_END ) then
  begin
    cmbDayPlanType.ItemIndex := 0 ;
  end;
end;

procedure TFrmMainTemeplateTrainNo.ShowTrainPlan(GroupID,GroupType: Integer);
var
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
  i,index  : Integer ;
begin
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);

  SetLength(m_DayPlanInfoArray,0);


  if not m_bIsReadOnly then
    m_RsLCDayTemplate.LCPlan.QueryPlans(dtBeginTime,dtEndTime,GroupID,m_DayPlanInfoArray)
  else
      m_RsLCDayTemplate.LCPlan.QueryPublishPlans(dtBeginTime,dtEndTime,GroupID,m_DayPlanInfoArray);
  if GroupType = 0 then
  begin
    strGridTrainPlan.Visible := True ;
    strGridDaWen.Visible := False ;
    with strGridTrainPlan do
    begin
      ClearRows(1, 10000);

      if length(m_DayPlanInfoArray) > 0 then
        RowCount := length(m_DayPlanInfoArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(m_DayPlanInfoArray) - 1 do
      begin
        AddPlanToControl(m_DayPlanInfoArray[i], i);
      end;

      strGridTrainPlan.Repaint();
    end;
  end
  else
  begin
    strGridTrainPlan.Visible := False ;
    strGridDaWen.Visible := True ;
    with strGridDaWen do
    begin
      ClearRows(1, 10000);

      if length(m_DayPlanInfoArray) > 0 then
        RowCount := length(m_DayPlanInfoArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(m_DayPlanInfoArray) - 1 do
      begin
          index := 0 ;
          Cells[index, i + 1] := IntToStr(i + 1);
          Inc(index);

          with  m_DayPlanInfoArray[i] do
          begin

            Cells[index, i + 1] := TRsPlanStateNameAry[nPlanState];;
            Inc(index);

            Cells[index, i + 1] := strDaWenCheXing;
            Inc(index);

            Cells[index, i + 1] :=  strDaWenCheHao1;
            Inc(index);

            Cells[index, i + 1] :=  strDaWenCheHao2;
            Inc(index);

            Cells[index, i + 1] :=  strDaWenCheHao3;

            Cells[99, i + 1] := m_DayPlanInfoArray[i].strDayPlanGUID;
          end;
      end;

      strGridDaWen.Repaint();
    end;
  end;
end;

procedure TFrmMainTemeplateTrainNo.InitGroup();
var
  DayPlanID: Integer  ;
  i : Integer ;
begin

  DayPlanID :=  m_nDayPlanID ;
  m_DayPlan.GoupList.Clear ;
  m_RsLCDayTemplate.LCPlanGroup.QueryGroups(DayPlanID,m_DayPlan.GoupList);

  lstGroup.Clear ;
  for I := 0 to m_DayPlan.GoupList.Count - 1 do
  begin
    lstGroup.AddItem(m_DayPlan.GoupList.Items[i].Name,m_DayPlan.GoupList.Items[i]);
  end;
end;

procedure TFrmMainTemeplateTrainNo.InitTrainPlan;
var
  nSelGroupId,nSelGroupType: Integer ;
begin
  nSelGroupId := GetSelGroupID ;
  if nSelGroupId < 0 then
    Exit ;
  nSelGroupType := GetSelGroupType ;
  ShowTrainPlan(nSelGroupId,nSelGroupType);
end;

procedure TFrmMainTemeplateTrainNo.InitUI(IsReadOnly: Boolean);
var
  bIsVisible : Boolean ;
begin
  bIsVisible :=   not IsReadOnly ;
  btnLoadPlan.Visible := bIsVisible ;
  btnAddPlan.Visible := bIsVisible ;
  btnDeletePlan.Visible := bIsVisible ;
  btnSendPlan.Visible := bIsVisible ;

  //��GRID���������ʱ���ڱ༭״̬
  strGridDaWen.MouseActions.DirectEdit := not IsReadOnly ;
  strGridTrainPlan.MouseActions.DirectEdit := not IsReadOnly ;

end;

function TFrmMainTemeplateTrainNo.IsLoadedPlan: Boolean;
var
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
begin
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);

  Result := m_RsLCDayTemplate.LCPlan.IsLoadedPlan(dtBeginTime,dtEndTime,m_nDayPlanID,DayOrNight);
end;

procedure TFrmMainTemeplateTrainNo.lstGroupClick(Sender: TObject);
var
  nSelGroupID,nSenGroupType: Integer ;
begin
  nSelGroupID := GetSelGroupID ;
  if nSelGroupID < 0 then
    Exit ;
  nSenGroupType := GetSelGroupType ;
  ShowTrainPlan(nSelGroupID,nSenGroupType);
end;

procedure TFrmMainTemeplateTrainNo.lstGroupDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  strTemp: String;
  rectText : TRect ;
begin
  //�ֱ���������
  strTemp :=   m_DayPlan.GoupList.Items[Index].Name;
  with lstGroup do
  begin
    //���ñ�����ɫ����䱳��
    lstGroup.Canvas.Brush.Color := clWhite;
    lstGroup.Canvas.FillRect (Rect);

    //����Բ�Ǿ�����ɫ������Բ�Ǿ���
    lstGroup.Canvas.Brush.Color := TColor($00FFF7F7);
    lstGroup.Canvas.Pen.Color := TColor($00131315);

    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 2, Rect.Bottom - 2, 8, 8);
    //�Բ�ͬ�Ŀ�Ⱥ͸߶��ٻ�һ�Σ�ʵ������Ч��
    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //������ɫ
    lstGroup.Canvas.Font.Color := clBlack;
    //lstQuDuan.Canvas.Font.Style := lstQuDuan.Canvas.Font.Style - [fsBold];
    CopyRect(rectText,Rect);
    //����ǵ�ǰѡ����
    if(odSelected in State) then
    begin
      //�Բ�ͬ�ı���ɫ����ѡ�����Բ�Ǿ���
      lstGroup.Canvas.Brush.Color := TColor($00FFB2B5);
      lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
      //ѡ�����������ɫ
      lstGroup.Canvas.Font.Color := clBlue;
      //lstQuDuan.Canvas.Font.Style := lstQuDuan.Canvas.Font.Style + [fsBold];
      //�����ǰ��ӵ�н��㣬��������򣬵�ϵͳ�ٻ���ʱ���XOR����Ӷ��ﵽ������������Ŀ��
      if(odFocused in State) then
      begin
        DrawFocusRect(lstGroup.Canvas.Handle, Rect);
        OffsetRect(rectText,0,1);
      end;
    end;


    //lstGroup.Canvas.TextOut(rectText.Left+10,rectText.Top+6,strTemp);
    lstGroup.Canvas.TextRect(rectText,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
  end;
end;

procedure TFrmMainTemeplateTrainNo.lstGroupMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Exit ;
  Height := 50 ;
end;

class procedure TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo(IsReadOnly:Boolean);
begin
  FrmMainTemeplateTrainNo := TFrmMainTemeplateTrainNo.Create(nil);
  try
    FrmMainTemeplateTrainNo.InitData(IsReadOnly);
    FrmMainTemeplateTrainNo.ShowModal ;
  finally
    FrmMainTemeplateTrainNo.Free;
  end;
end;



procedure TFrmMainTemeplateTrainNo.ModifyDaWenPlan(PlanID: string; nRow,
  nCol: Integer);
var
  DayPlanInfo: RsDayPlanInfo ;
  DayPlanLog:RsDayPlanLog ;
begin
  m_RsLCDayTemplate.LCPlan.GetPlan(PlanID,DayPlanInfo);
  With strGridDaWen do
  begin
    DayPlanInfo.strDayPlanGUID := PlanID ;
    DayPlanInfo.strDaWenCheXing :=  Cells[COL_TRIAN_DAWEN_CHEXING, nRow ]  ;
    DayPlanInfo.strDaWenCheHao1 := Cells[COL_TRIAN_DAWEN_CHEHAO1, nRow ] ;
    DayPlanInfo.strDaWenCheHao2 := Cells[COL_TRIAN_DAWEN_CHEHAO2, nRow ] ;
    DayPlanInfo.strDaWenCheHao3 := Cells[COL_TRIAN_DAWEN_CHEHAO3, nRow ] ;
  end;

    //�����޸���־
  with DayPlanLog do
  begin
    strLogGUID:= NewGUID;
    strlogType := 'Update';
    strDayPlanGUID:= PlanID;  //�ƻ�ID
    strTrainNo1:= DayPlanInfo.strDaWenCheXing ;     //����1
    strTrainInfo:= DayPlanInfo.strDaWenCheHao1 ;    //������Ϣ
    strTrainNo2:= DayPlanInfo.strDaWenCheHao2 ;      //����2
    strRemark:= DayPlanInfo.strDaWenCheHao3 ;       //��ע
    dtChangeTime:= GlobalDM.Now; //
  end;

  m_RsLCDayTemplate.LCPlan.UpdateDayPlan(DayPlanInfo,DayPlanLog,
  GlobalDM.Site.ID,GlobalDM.User.ID);
  //����ƻ������·�״̬��
  if DayPlanInfo.bIsSend > 0  then
    PostWaiQinMessage(TFM_PLAN_WAIQIN_UPDATE,PlanID);
end;

procedure TFrmMainTemeplateTrainNo.ModifyTrainPlan(PlanID: string; nRow,
  nCol: Integer);
  function IsNewPlan(DayPlanInfo: RsDayPlanInfo):Boolean ;
  begin
    Result := False ;
    if DayPlanInfo.nPlanID = -1 then
      Result := True;
  end;
var
  DayPlanInfo: RsDayPlanInfo ;
  DayPlanLog:RsDayPlanLog ;
  TFMessage : TTFMessage  ;
  sourcePlan : RRsTrainPlan ;
begin
  m_RsLCDayTemplate.LCPlan.GetPlan(PlanID,DayPlanInfo);

  With strGridTrainPlan do
  begin
    DayPlanInfo.strDayPlanGUID := PlanID ;
    DayPlanInfo.strTrainNo1 :=  Cells[COL_TRAIN_TRAINNO1_INDEX, nRow ]  ;
    DayPlanInfo.strTrainInfo := Cells[COL_TRAIN_INFO_INDEX, nRow ] ;
    DayPlanInfo.strTrainTypeName := Cells[COL_TRAIN_TYPE_INDEX, nRow ] ;
    DayPlanInfo.strTrainNumber := Cells[COL_TRAIN_NUMBER_INDEX, nRow ] ;
    DayPlanInfo.strTrainNo2 := Cells[COL_TRAIN_TRAINNO2_INDEX, nRow ] ;
    DayPlanInfo.strTrainNo :=  Cells[COL_TRAIN_TRAINNO_INDEX, nRow ] ;
    //����üƻ��������ӵļƻ�
    if ( IsNewPlan(DayPlanInfo) )   and
        ( DayPlanInfo.strTrainNo <> '' ) and
       ( DayPlanInfo.strTrainPlanGUID = '' )
    then
    begin
        DayPlanInfo.strTrainPlanGUID := NewGUID ;
    end;

    DayPlanInfo.strRemark := Cells[COL_TRAIN_REMARK_INDEX, nRow ] ;
  end;

  //�����޸���־
  with DayPlanLog do
  begin
    strLogGUID:= NewGUID;
    strlogType := 'Update';
    strDayPlanGUID:= PlanID;  //�ƻ�ID
    strTrainNo1:= DayPlanInfo.strTrainNo1 ;     //����1
    strTrainInfo:= DayPlanInfo.strTrainInfo ;    //������Ϣ
    strTrainNo2:= DayPlanInfo.strTrainNo2 ;      //����2
    strRemark:= DayPlanInfo.strRemark ;       //��ע
    dtChangeTime:= GlobalDM.Now; //
  end;

  m_RsLCDayTemplate.LCPlan.UpdateDayPlan(DayPlanInfo,DayPlanLog,
    GlobalDM.Site.ID,GlobalDM.User.ID);

    //����ǰ����˰������ƻ��򷢲������ƻ��޸���Ϣ
  if DayPlanInfo.strTrainPlanGUID <> '' then
  begin
    TFMessage := TTFMessage.Create;
    try
      //�˴�������������޸�ֵ������
      if m_webTrainPlan.GetTrainPlanByID(DayPlanInfo.strTrainPlanGUID,sourcePlan) then
      begin
        if sourcePlan.nPlanState >= psSent then
        begin
          TFMessage.msg := TFM_PLAN_TRAIN_UPDATE;
          FillMessageWithPlan(TFMessage,sourcePlan);
          //GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
//          Global.
          {$message '�˴���Ҫ��������'}
        end;
      end;
    finally
      TFMessage.Free;
    end;
  end;

    //����ƻ������·�״̬��
  if DayPlanInfo.bIsSend > 0  then
    PostWaiQinMessage(TFM_PLAN_WAIQIN_UPDATE,PlanID);
end;

procedure TFrmMainTemeplateTrainNo.NextFocus;
begin


end;


procedure TFrmMainTemeplateTrainNo.PostPlanMessage(TFMessageList: TTFMessageList);
var
  i : Integer ;
begin
  for I := 0 to TFMessageList.Count - 1 do
  begin
    //GlobalDM.TFMessageCompnent.PostMessage(TFMessageList.Items[i]);
    {$message '�˴���Ҫ��������'}
  end;
end;

procedure TFrmMainTemeplateTrainNo.PostWaiQinMessage(MsgType: Integer;
  PlanGUID: string);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := MsgType ;
    TFMessage.StrField['GUID'] := NewGUID ;
    TFMessage.IntField['DayPlanID'] := m_nDayPlanID;
    TFMessage.IntField['GroupID'] := GetSelGroupID ;
    TFMessage.StrField['PlanGUID'] := PlanGUID ;
    //GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
    {$message '�˴���Ҫ��������'}
  finally
    TFMessage.Free;
  end;
end;

procedure TFrmMainTemeplateTrainNo.PostWaiQinMessages(AType: Integer);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := TFM_PLAN_WAIQIN_PUBLISH ;
    TFMessage.StrField['GUID'] := NewGUID ;
    TFMessage.IntField['DayPlanID'] := m_nDayPlanID;
    TFMessage.StrField['strStartDate'] := FormatDateTime('yyyy-MM-dd',m_dtStartDate) ;
    TFMessage.IntField['nType'] := AType;
    //GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
    {$message '�˴���Ҫ��������'}
  finally
    TFMessage.Free;
  end;
end;


procedure TFrmMainTemeplateTrainNo.PublistPlan;
var
  strError:string;
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
  //�г���������
  TrainjiaoluArray : TRsTrainJiaoluArray;
  i : Integer ;
begin
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);

  //�޸ļƻ��޸�Ϊ���·�
  m_RsLCDayTemplate.LCPlan.SendDayPlan(dtBeginTime,dtEndTime,m_nDayPlanID);

  //��ȡ�ͻ��˹�Ͻ���г����β�����/�·�ͼ������
  SetLength(TrainjiaoluArray,0);
  m_LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.Site.ID,TrainjiaoluArray);

  for I := 0 to Length(TrainjiaoluArray) - 1 do
  begin
    if not m_webTrainnos.LoadAndSend(TrainjiaoluArray[i].strTrainJiaoluGUID,dtBeginTime,dtEndTime,strError) then
    begin
      Continue ;
    end;
  end;

  //�����·��ƻ���Ϣ
  SendPlan;

  //ˢ�½��� 
  InitTrainPlan ;
  TNoFocusBox.ShowBox('�·��ɹ�!',1000);
end;
//
//function TFrmMainTemeplateTrainNo.SelectDayPlan(StringGrid:TAdvStringGrid;DayPlanGUID: string):Boolean;
//var
//  i : Integer ;
//begin
//  Result := False ;
//  for I := 1 to StringGrid.RowCount - 1 do
//  begin
//    if StringGrid.Cells[99,i] = DayPlanGUID then
//    begin
//      Result := True ;
//      StringGrid.Col := 0;   
//      StringGrid.row := i;
//      Break;
//    end;
//  end;
//end;
//
//procedure TFrmMainTemeplateTrainNo.SelectGroup(GroupID: Integer);
//var
//  i : Integer;
//begin
//  for I := 0 to lstGroup.Count - 1 do
//  begin
//    if True then
//    begin
//      lstGroup.ItemIndex := i;
//      InitTrainPlan;
//      Break ;
//    end;
//  end;
//end;

function TFrmMainTemeplateTrainNo.SendPlanMessage(PlanList: TStrings): Boolean;
var
  i: integer;
  planGUID: string;
  trainPlan: RRsTrainPlan;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
begin
  TFMessageList := TTFMessageList.Create;
  try
    //����Ƿ���Ҫ�����Ϣ
    for i := 0 to PlanList.Count - 1 do
    begin
      planGUID := PlanList[i];
      trainPlan.strTrainPlanGUID := planGUID;
      if m_webTrainPlan.GetTrainPlanByID(planGUID, trainPlan) then
      begin

        if trainPlan.strTrainNo = '' then
          Continue;

        TFMessage := TTFMessage.Create;
        TFMessage.msg := TFM_PLAN_TRAIN_PUBLISH;
        FillMessageWithPlan(TFMessage,trainPlan);
        TFMessageList.Add(TFMessage);
      end;
    end;

    if TFMessageList.Count > 0 then
      PostPlanMessage(TFMessageList);

  finally
    TFMessageList.Free;
  end;
  Result := True ;
end;

procedure TFrmMainTemeplateTrainNo.strGridDaWenCanEditCell(Sender: TObject;
  ARow, ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if m_bIsReadOnly then
    Exit ;
  if (Length(m_DayPlanInfoArray) = 0) or (ARow = 0) then
    Exit;

  if ACol= COL_TRAIN_STATE then
    Exit ;

  CanEdit := True ;
end;

procedure TFrmMainTemeplateTrainNo.strGridDaWenCellValidate(Sender: TObject;
  ACol, ARow: Integer; var Value: string; var Valid: Boolean);
begin

  if (Length(m_DayPlanInfoArray) = 0)  then Exit;

  m_bModifyedDanWenPlan := True ;
  m_nSelectColDaWen := ACol ;
end;

procedure TFrmMainTemeplateTrainNo.strGridDaWenEditCellDone(Sender: TObject;
  ACol, ARow: Integer);
var
  nRealCol:Integer ;
begin
  if m_nSelectColDaWen <= 0  then
  begin
   m_nSelectColDaWen := ACol ;
  end;
  nRealCol := m_nSelectColDaWen ;

  if not m_bModifyedDanWenPlan then exit;
  UpdateDaWenPlan(ARow,nRealCol);
  m_bModifyedDanWenPlan := False ;
end;

procedure TFrmMainTemeplateTrainNo.strGridDaWenGetAlignment(Sender: TObject;
  ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TFrmMainTemeplateTrainNo.strGridDaWenGetCellColor(Sender: TObject;
  ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = COL_TRAIN_STATE then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if strGridTrainPlan.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        Break;
      end;
    end;
  end;
end;

procedure TFrmMainTemeplateTrainNo.strGridDaWenMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col,row : integer;
  pt : TPoint;
begin
  if Button = mbRight then
  begin
    strGridTrainPlan.MouseToCell(X,Y,col,row);
    if Row = 0 then
    begin
      pt := Point(X,Y);
      pt := strGridTrainPlan.ClientToScreen(pt);
    end
    else
    begin
      if (strGridTrainPlan.Row > 0)  and (Length(m_DayPlanInfoArray) > 0)then
      begin
        pt := Point(X,Y);
        pt := strGridTrainPlan.ClientToScreen(pt);
        PopupMenu1.Popup(pt.X,pt.Y);
      end;
    end;
  end;
end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanCanEditCell(Sender: TObject;
  ARow, ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if m_bIsReadOnly then
    Exit ;
  if (Length(m_DayPlanInfoArray) = 0) or (ARow = 0) then
    Exit;

  //״̬�в��ܱ��޸�
  if ACol = COL_TRAIN_STATE then
    Exit;

  CanEdit := True ;
end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanCellValidate(Sender: TObject;
  ACol, ARow: Integer; var Value: string; var Valid: Boolean);
      //�Բ�������(4)���ȵ�ǰ�油��0��ȱ�������伸��
    function FormatTrainNumber(TrainNumber: string): string;
    begin
      Result := Trim(TrainNumber);
      if length(Result) = 3 then
        Result := '0' + Result;
      if length(Result) = 2 then
        Result := '00' + Result;
      if length(Result) = 1 then
        Result := '000' + Result;
    end;
var
  strText : string ;
  strTypeName:string;
  strNumber:string;
begin

  if (Length(m_DayPlanInfoArray) = 0)  then Exit;

  m_nSelectCol := ACol ;

  //������Ϣ
  if (ACol = COL_TRAIN_INFO_INDEX) then
  begin
    Value := UpperCase(Value);
    strText := Value ;
    strGridTrainPlan.Cells[COL_TRAIN_TYPE_INDEX,ARow] := FormatCX(strText) ;
    strGridTrainPlan.Cells[COL_TRAIN_NUMBER_INDEX,ARow] := FormatCH(strText) ;
  end

  //������Ϣ
  else if ( ACol = COL_TRAIN_TYPE_INDEX ) then
  begin
    strTypeName := GetTrainTypeName(Value) ;
    strNumber := strGridTrainPlan.Cells[COL_TRAIN_NUMBER_INDEX,ARow] ;
    strText := strTypeName +  strNumber ;
    strGridTrainPlan.Cells[COL_TRAIN_INFO_INDEX,ARow] := strText ;
  end
  //������Ϣ
  else if ( ACol = COL_TRAIN_NUMBER_INDEX ) then
  begin
    strTypeName :=  strGridTrainPlan.Cells[COL_TRAIN_TYPE_INDEX,ARow] ;
    strTypeName := GetTrainTypeName(strTypeName) ;
    Value := FormatTrainNumber(Value) ;
    strNumber := Value ;
    strText := strTypeName +  strNumber ;
    strGridTrainPlan.Cells[COL_TRAIN_INFO_INDEX,ARow] := strText ;
  end;

  m_bModifyedTrainPlan := True ;

end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanEditCellDone(Sender: TObject;
  ACol, ARow: Integer);
var
  nRealCol:Integer ;
begin
  if m_nSelectCol <= 0  then
  begin
   m_nSelectCol := ACol ;
  end;
  nRealCol := m_nSelectCol ;
  if not m_bModifyedTrainPlan then exit;

  UpdateTrainPlan(ARow,nRealCol);

  m_bModifyedTrainPlan := False ;
end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanGetAlignment(Sender: TObject;
  ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanGetCellColor(Sender: TObject;
  ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = COL_TRAIN_STATE then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if strGridTrainPlan.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        Break;
      end;
    end;
  end;
end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanGetEditorType(
  Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
var
  i : Integer ;
begin
  case ACol of
    COL_TRAIN_TYPE_INDEX :
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for I := 0 to Length(m_ArrayShortTrain) - 1 do
      begin
        TAdvStringGrid(Sender).AddComboString(m_ArrayShortTrain[i].strLongName);
      end;
    end;
  end;
end;

procedure TFrmMainTemeplateTrainNo.strGridTrainPlanKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    NextFocus();
  end;
end;



procedure TFrmMainTemeplateTrainNo.strGridTrainPlanMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col,row : integer;
  pt : TPoint;
begin
  if Button = mbRight then
  begin
    strGridTrainPlan.MouseToCell(X,Y,col,row);
    if Row = 0 then
    begin
      pt := Point(X,Y);
      pt := strGridTrainPlan.ClientToScreen(pt);
    end
    else
    begin
      if (strGridTrainPlan.Row > 0)  and (Length(m_DayPlanInfoArray) > 0)then
      begin
        pt := Point(X,Y);
        pt := strGridTrainPlan.ClientToScreen(pt);
        PopupMenu1.Popup(pt.X,pt.Y);
      end;
    end;
  end;
end;

procedure TFrmMainTemeplateTrainNo.UpdateDaWenPlan(nRow, nCol: Integer);
begin
  if nRow > strGridDaWen.RowCount - 1 then
    Exit;

  if  Length(m_DayPlanInfoArray) = 0 then
    Exit ;

  ModifyDaWenPlan(m_DayPlanInfoArray[nRow - 1].strDayPlanGUID,nRow,nCol);
end;

procedure TFrmMainTemeplateTrainNo.UpdateTrainPlan(nRow, nCol: Integer);
begin
  if nRow > strGridTrainPlan.RowCount - 1 then
    Exit;

  if  Length(m_DayPlanInfoArray) = 0 then
    Exit ;

  ModifyTrainPlan(m_DayPlanInfoArray[nRow - 1].strDayPlanGUID,nRow,nCol);
end;

procedure TFrmMainTemeplateTrainNo.SendPlan;
var
  planList : TStrings;
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
begin
  planList := TStringList.Create;
  try
    GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);
    m_RsLCDayTemplate.LCPlan.SetSended(dtBeginTime,dtEndTime,m_nDayPlanID,planList);
    //������Ϣ
    SendPlanMessage(planList);
    //����������Ϣ
    PostWaiQinMessages(cmbDayPlanType.ItemIndex);
  finally
    planList.Free;
  end;
end;


end.
