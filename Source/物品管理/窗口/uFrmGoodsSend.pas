unit uFrmGoodsSend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, RzButton, utfLookupEdit,utfPopTypes,
  uTrainman,uLendingDefine,uTFSystem,uSaftyEnum,
  uDialogsLib,Contnrs,uLCGoodsMgr,uLCTrainmanMgr;

type
  TLendOprType = (lotSend{发放},lotGiveBack{回收});

  TInputControls = class
  public
    constructor Create(Parent: TWinControl);
    destructor Destroy; override;
  private
    m_Lable: TLabel;
    m_nLeft: Integer;
    m_nTop: Integer;
    m_nLendingTypeID: Integer;
    m_Edit: TEdit;
    function GetCaption: string;
    procedure SetCaption(Value: string);

  public
    property LendingTypeID: Integer read m_nLendingTypeID write m_nLendingTypeID;
    property Left: Integer read m_nLeft write m_nLeft;
    property Top: Integer read m_nTop write m_nTop;
    property Lable: TLabel read m_Lable;
    property Caption: string read GetCaption write SetCaption;
    property EditControl: TEdit read m_Edit;
  end;


  
  TfrmGoodsSend = class(TForm)
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    rbtnSend: TRadioButton;
    Label2: TLabel;
    Label4: TLabel;
    edtRemark: TEdit;
    btnOk: TRzBitBtn;
    btnCancel: TRzBitBtn;
    rbtnGiveBack: TRadioButton;
    edtTrainmanName: TEdit;
    edtLenderName: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtTrainmanNameExit(Sender: TObject);
    procedure edtLenderNameExit(Sender: TObject);
    procedure edtTrainmanNameKeyPress(Sender: TObject; var Key: Char);
    procedure rbtnSendClick(Sender: TObject);
  private
    { Private declarations }
    {乘务员数据库操作对象}
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsLCGoodsMgr: TRsLCGoodsMgr;
    {物品类型列表}
    m_LendingTypeList: TRsLendingTypeList;
    {操作方式}
    AutoLendOprType: TLendOprType;
    {出借记录}
    m_LendingInfo: TRsLendingInfo;
    m_SelectLenderGUID: string;
    m_SelectTrainmanGUID: string;
    m_InputControls: TObjectList;
    {功能:检查输入}
    function CheckInput(): Boolean;
    {功能:根据输入字符串生成物品列表}
    procedure CreateLendDetails(strLendingGUID: string;
      LendingDetailList: TRsLendingDetailList);

    function GetOprType(strTrainmanGUID: string): TLendOprType;
    
    procedure SetOprTypeControlState(LendOprType: TLendOprType);

    procedure SendGoods();

    procedure GiveBackGoods();

    procedure FilterDuplacites(Lendings: TStrings);

    function IsNumber(strText: string): Boolean;

    procedure InitInputControls();
    //检查物品是否在发放的范围内
    function  IsGoodInRange(AType:Integer;ACode:Integer):Boolean;
  public
    { Public declarations }
    Verify: TRsRegisterFlag;
    procedure SetTrainman(TrainMan: RRsTrainman;Verify: TRsRegisterFlag);
  end;
function SendLendings(TrainMan: RRsTrainman;Verify: TRsRegisterFlag): Boolean;overload;
function SendLendings(): Boolean;overload;
implementation

uses uGlobal;
function SendLendings(): Boolean;
var
  frmGoodsSend: TfrmGoodsSend;
begin
  frmGoodsSend := TfrmGoodsSend.Create(nil);
  try
    Result := frmGoodsSend.ShowModal  = mrOk;
  finally
    frmGoodsSend.Free;
  end;
end;
function SendLendings(TrainMan: RRsTrainman;Verify: TRsRegisterFlag): Boolean;
var
  frmGoodsSend: TfrmGoodsSend;
begin
  frmGoodsSend := TfrmGoodsSend.Create(nil);
  try
    if TrainMan.strTrainmanGUID <> '' then
    begin
      frmGoodsSend.SetTrainman(TrainMan,Verify);
    end;
    Result := frmGoodsSend.ShowModal  = mrOk;
  finally
    frmGoodsSend.Free;
  end;
end;
{$R *.dfm}

{ TfrmGoodsSend }

procedure TfrmGoodsSend.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmGoodsSend.btnOkClick(Sender: TObject);
begin
  btnOk.Enabled := false;
  try
    if CheckInput() then
    begin
      try
        if rbtnSend.Checked then
        begin
          SendGoods();
          TNoFocusBox.ShowBox('发放成功!');
        end
        else
        begin
          GiveBackGoods();
          TNoFocusBox.ShowBox('回收成功!');
        end;
        ModalResult := mrOk;
      except
        on E: Exception do
          Box(E.Message);
      end;

    end;
  finally
    btnOk.Enabled := true;
  end;

end;

function TfrmGoodsSend.CheckInput: Boolean;
var
  InputLendings: TStringList;
  i,j: Integer;
  TrainMan: RRsTrainman;
  bVerify: Boolean;
begin
  Result := True;
  if Trim(edtTrainmanName.Text) = '' then
  begin
    Result := False;
    Box('人员信息不能为空!');
    Exit;
  end
  else
  begin
    if m_SelectTrainmanGUID = '' then
    begin

      if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(edtTrainmanName.Text),TrainMan) then
        m_SelectTrainmanGUID := TrainMan.strTrainmanGUID
      else
      begin
        Result := False;
        box('未找到工号为:' + Trim(edtTrainmanName.Text) + '的乘务员!');
        exit;
      end;
    end;
    
  end;

  if Trim(edtLenderName.Text) = '' then
  begin
    Result := False;
    Box('办理人信息不能为空!');
    Exit;
  end
  else
  begin
    if m_SelectLenderGUID = '' then
    begin
      if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(edtLenderName.Text),TrainMan) then
        m_SelectLenderGUID := TrainMan.strTrainmanGUID
      else
      begin
        Result := False;      
        box('未找到工号为:' + Trim(edtLenderName.Text) + '的值班员!');
        exit;
      end;
    end;   
  end;
  bVerify := False;
  for I := 0 to m_InputControls.Count - 1 do
  begin
    if TInputControls(m_InputControls[i]).EditControl.Text <> '' then
    begin
      bVerify := True;
      Break;
    end;

  end;
  if not bVerify then  
  begin
    result := False;
    Box('借出物品不能为空!');
    Exit;
  end;


  InputLendings := TStringList.Create;
  try
    for j := 0 to m_InputControls.Count - 1 do
    begin
      InputLendings.Clear;

      SplitLendingString(TInputControls(m_InputControls[j]).EditControl.Text,InputLendings);

      for I := 0 to InputLendings.Count - 1 do
      begin
        if Trim(InputLendings.Strings[i]) = '' then
        begin
          Result := False;
          Box('输入的物品信息格式错误,请重新输入!');
          TInputControls(m_InputControls[j]).EditControl.SetFocus;
          break;
        end;

      end;

    end;
  finally
    InputLendings.Free;
  end;

end;

procedure TfrmGoodsSend.CreateLendDetails(strLendingGUID: string; 
  LendingDetailList: TRsLendingDetailList);
{功能:根据输入字符串生成物品列表}
var
  i,j: Integer;
  LendingDetail: TRsLendingDetail;
  Lendings: TStringList;
begin
  Lendings := TStringList.Create;
  try
    LendingDetailList.Clear;
    for i := 0 to m_InputControls.Count - 1 do
    begin
      Lendings.Clear;
      //拆分字符串
      SplitLendingString(TInputControls(m_InputControls[i]).EditControl.Text,
          Lendings);
          
      //过滤重复数据
      FilterDuplacites(Lendings);

      for j := 0 to Lendings.Count - 1 do
      begin
        LendingDetail := TRsLendingDetail.Create;
        LendingDetail.strGUID := NewGUID;
        LendingDetail.strLendingInfoGUID := strLendingGUID;
        LendingDetail.strTrainmanGUID := m_SelectTrainmanGUID;
        LendingDetail.strGiveBackTrainmanGUID := m_SelectLenderGUID;
        LendingDetail.strLenderGUID := m_SelectLenderGUID;
        LendingDetail.nLendingType := TInputControls(m_InputControls[i]).LendingTypeID;
        LendingDetail.strLendingTypeAlias :=
            m_LendingTypeList.FindAliasByID(LendingDetail.nLendingType);
        LendingDetail.strLendingExInfo := StrToInt(Lendings.Strings[j]);

        LendingDetail.nBorrowVerifyType := Integer(Verify);
        LendingDetail.nGiveBackVerifyType := Integer(Verify);
        LendingDetail.nReturnState := 0;
        LendingDetail.dtBorrwoTime := Now;
        LendingDetail.dtGiveBackTime := Now;
        LendingDetail.dtModifyTime := Now;
        LendingDetailList.Add(LendingDetail);
      end;
    end;

  finally
    Lendings.Free;
  end;

end;


procedure TfrmGoodsSend.edtLenderNameExit(Sender: TObject);
var
  TrainMan: RRsTrainman;
begin
  if Trim(edtLenderName.Text) = '' then
    Exit;

  if not IsNumber(edtLenderName.Text) then
    Exit;
  
    
  if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(edtLenderName.Text),TrainMan) then
  begin
    edtLenderName.Text := Format('%s[%s]',[TrainMan.strTrainmanName,TrainMan.strTrainmanNumber]);
    m_SelectLenderGUID := TrainMan.strTrainmanGUID;
  end
  else
  begin
    m_SelectLenderGUID := '';
    box('未找到工号为:' + Trim(edtLenderName.Text) + '的值班员!');
    edtLenderName.SetFocus;
    exit;
  end;
end;

procedure TfrmGoodsSend.edtTrainmanNameExit(Sender: TObject);
var
  TrainMan: RRsTrainman;
begin
  if Trim(edtTrainmanName.Text) = '' then
    Exit;

  if not IsNumber(edtTrainmanName.Text) then
    Exit;

  if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(edtTrainmanName.Text),TrainMan) then
  begin
    edtTrainmanName.Text := Format('%s[%s]',[TrainMan.strTrainmanName,TrainMan.strTrainmanNumber]);
    m_SelectTrainmanGUID := TrainMan.strTrainmanGUID;
    SetOprTypeControlState(GetOprType(m_SelectTrainmanGUID));
  end
  else
  begin
    m_SelectTrainmanGUID := '';
    box('未找到工号为:' + Trim(edtTrainmanName.Text) + '的乘务员!');
    edtTrainmanName.SetFocus;
    exit;
  end;
end;

procedure TfrmGoodsSend.edtTrainmanNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#8,#43]) then
  begin
    Key := #0;
  end;

  if Key = #13 then
  begin
    Key := #0;
    PostMessage(Self.Handle,WM_NEXTDLGCTL,0,0)
  end;
end;

procedure TfrmGoodsSend.FilterDuplacites(Lendings: TStrings);
var
  i,j: Integer;
begin
  for I := 0 to Lendings.Count - 1 do
  begin
    for j := i + 1 to Lendings.Count - 1 do
    begin
      if Lendings.Strings[i] = Lendings.Strings[j] then
        Lendings.Strings[j] := '';
    end;
      
  end;


  i := 0;
  while i < Lendings.Count do
  begin
    if Lendings.Strings[i] = '' then
      Lendings.Delete(i)
    else
      inc(i);
  end;
  
end;

procedure TfrmGoodsSend.FormCreate(Sender: TObject);
begin
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(g_WebAPIUtils);
  m_RsLCGoodsMgr := TRsLCGoodsMgr.Create(g_WebAPIUtils);
  m_LendingTypeList := TRsLendingTypeList.Create;
  m_InputControls := TObjectList.Create;
  m_LendingInfo := TRsLendingInfo.Create;
  m_RsLCGoodsMgr.GetGoodType(m_LendingTypeList);
  InitInputControls();
end;

procedure TfrmGoodsSend.FormDestroy(Sender: TObject);
begin
  m_LendingTypeList.Free;
  m_LendingInfo.Free;
  m_InputControls.Free;
  m_RsLCTrainmanMgr.Free;
  m_RsLCGoodsMgr.Free;
end;

function TfrmGoodsSend.GetOprType(strTrainmanGUID: string): TLendOprType;
begin
  if m_RsLCGoodsMgr.IsHaveNotReturnGoods(strTrainmanGUID) then
    Result := lotGiveBack
  else
    Result := lotSend;
end;

procedure TfrmGoodsSend.GiveBackGoods;
var
  LendingDetails: TRsLendingDetailList;
  i : Integer ;
begin
  LendingDetails := TRsLendingDetailList.Create;
  try
    CreateLendDetails('',LendingDetails);
    for I := 0 to LendingDetails.Count - 1 do
    begin

      //检查物品是否在发放范围内
      if TConfig.UsesGoodsRange then
      begin
        if not IsGoodInRange(LendingDetails[i].nLendingType,LendingDetails[i].strLendingExInfo) then
          Raise Exception.Create(LendingDetails[i].CombineAliasName + '物品编码不在指定的编码范围内,请检查!');
      end;
    end;


    m_RsLCGoodsMgr.Recieve(m_SelectTrainmanGUID,
      edtRemark.Text,LendingDetails);
  finally
    LendingDetails.Free;
  end;
end;

procedure TfrmGoodsSend.InitInputControls;
const
  LabelLeftPos = 8;
  EditLeftPos = 76;
  LabelTopBase = 77;
  EditTopBase = 74;
var
  InputControls: TInputControls;
  i: Integer;
  Trainman: RRsTrainman;
begin
  Self.Height := Self.Height +  m_LendingTypeList.Count * 33;


  for I := 0 to m_LendingTypeList.Count - 1 do
  begin
    InputControls := TInputControls.Create(self);
    InputControls.LendingTypeID := m_LendingTypeList.Items[i].nLendingTypeID;
    InputControls.Lable.Left := LabelLeftPos;
    InputControls.Lable.Top := LabelTopBase + 33 * i;
    InputControls.Lable.Caption := m_LendingTypeList.Items[i].strLendingTypeName + ':';
    InputControls.EditControl.Top := EditTopBase + 33 * i;
    InputControls.EditControl.Left := EditLeftPos;
    InputControls.EditControl.Width := 237;
    InputControls.EditControl.OnKeyPress := edtTrainmanNameKeyPress;
    InputControls.EditControl.TabOrder  := i + 2;
    
    m_InputControls.Add(InputControls);
  end;



  if GlobalDM.User.Number <> '1' then
  begin
    if m_RsLCTrainmanMgr.GetTrainmanByNumber('230' + GlobalDM.User.Number,Trainman) then
    begin
      m_SelectLenderGUID := Trainman.strTrainmanGUID;

      edtLenderName.Text := Trainman.strTrainmanName + '[' + Trainman.strTrainmanNumber + ']';
      edtLenderName.Enabled := False;
    end;
  end;

end;

function TfrmGoodsSend.IsGoodInRange(AType, ACode: Integer): Boolean;
begin
  Result := True ;
end;

function TfrmGoodsSend.IsNumber(strText: string): Boolean;
var
  i: Integer;
begin
  Result := True;

  if strText = '' then
  begin
    Result := False;
    Exit;
  end;

  for I := 1 to Length(strText) do
  begin
    if not( strText[i] in ['0'..'9']) then
    begin
      Result := False;
      Exit;
    end; 
  end;
    
end;

procedure TfrmGoodsSend.rbtnSendClick(Sender: TObject);
var
  i: Integer;
begin
  if AutoLendOprType = lotGiveBack then
  begin
    for I := 0 to m_InputControls.Count - 1 do
    begin
      TInputControls(m_InputControls[i]).EditControl.Text := '';
    end;
  end;
end;

procedure TfrmGoodsSend.SendGoods;
var
  LendingDetailList: TRsLendingDetailList;
begin
  LendingDetailList := TRsLendingDetailList.Create;
  try
    CreateLendDetails('',LendingDetailList);


    m_RsLCGoodsMgr.Send(m_SelectTrainmanGUID,GlobalDM.WorkShop.ID,
    edtRemark.Text,TConfig.UsesGoodsRange,LendingDetailList);
  finally
    LendingDetailList.Free;
  end;

end;

procedure TfrmGoodsSend.SetOprTypeControlState(LendOprType: TLendOprType);
begin
  Self.AutoLendOprType := LendOprType;
  if LendOprType = lotSend then
  begin
    rbtnSend.Checked := True;
    rbtnGiveBack.Checked := False;
  end
  else
  begin
    rbtnSend.Checked := False;
    rbtnGiveBack.Checked := True;
  end;
end;

procedure TfrmGoodsSend.SetTrainman(TrainMan: RRsTrainman;Verify: TRsRegisterFlag);
var
  LendDetails: TRsLendingDetailList;
  I: Integer;
begin
  Self.Verify := Verify;
  m_SelectTrainmanGUID := TrainMan.strTrainmanGUID;

  LendDetails := TRsLendingDetailList.Create;
  try
    if Verify = rfFingerprint then
    begin
      edtTrainmanName.Enabled := False;
      edtTrainmanName.Text := Format('%s[%s]',[TrainMan.strTrainmanName,TrainMan.strTrainmanNumber]);
    end
    else
      edtTrainmanName.Text := TrainMan.strTrainmanNumber;



    if m_RsLCGoodsMgr.GetTrainmanNotReturnLendingInfo(TrainMan.strTrainmanGUID,LendDetails) then
    begin
      for I := 0 to m_InputControls.Count - 1 do
      begin
        TInputControls(m_InputControls[i]).EditControl.Text :=
          LendDetails.CombineExInfoToString(TInputControls(m_InputControls[i]).LendingTypeID);
      end;

      SetOprTypeControlState(lotGiveBack)
    end
    else
      SetOprTypeControlState(lotSend);
  finally
    LendDetails.Free;
  end;

end;


{ TInputControls }

constructor TInputControls.Create(Parent: TWinControl);
begin
  m_Lable := TLabel.Create(nil);
  m_Lable.Parent := Parent;
  m_Edit := TEdit.Create(nil);
  m_Edit.Parent := Parent;
end;

destructor TInputControls.Destroy;
begin
  m_Lable.Free;
  m_Edit.Free;
  inherited;
end;

function TInputControls.GetCaption: string;
begin
  Result := m_Lable.Caption;
end;

procedure TInputControls.SetCaption(Value: string);
begin
  m_Lable.Caption := Value;
end;

end.
