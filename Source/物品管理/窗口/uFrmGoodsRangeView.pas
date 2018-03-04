unit uFrmGoodsRangeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,uGoodsRange,uLendingDefine,utfsystem,
  ExtCtrls,uLCGoodsMgr;

type
  TFrmGoodsRangeView = class(TForm)
    cmbGoodsType: TRzComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtStartCode: TEdit;
    edtEndCode: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtStartCodeKeyPress(Sender: TObject; var Key: Char);
    procedure edtEndCodeKeyPress(Sender: TObject; var Key: Char);
  private
    //初始化物品类型
    procedure InitGoodsType();
    //检查输入条件是否合格
    function CheckInput():Boolean;
  private
    { Private declarations }
    //物品编码范围
    m_GoodsRange : RRsGoodsRange ;
    //物品管理接口
    m_RsLCGoodsMgr: TRsLCGoodsMgr;
    //物品类型列表
    m_LendingTypeList: TRsLendingTypeList ;
    //是修改还是 添加
    m_strActType:string;
  public
    { Public declarations }
    //初始化
    procedure InitData(ActType:string;GoodsRange : RRsGoodsRange);
    class function ShowFrom(ActType:string;var GoodsRange : RRsGoodsRange):Boolean;
  end;

var
  FrmGoodsRangeView: TFrmGoodsRangeView;

implementation

uses
  uGlobal ;

{$R *.dfm}

procedure TFrmGoodsRangeView.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel  ;
end;

procedure TFrmGoodsRangeView.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then
    Exit ;

  with m_GoodsRange do
  begin
    nLendingTypeID := StrToInt( cmbGoodsType.Value );
    nStartCode := StrToInt( edtStartCode.Text ) ;
    nStopCode := StrToInt( edtEndCode.Text );
    //strExceptCodes := mmoExceptCodes.Text ;
  end;

  ModalResult := mrOk ;
end;

function TFrmGoodsRangeView.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtStartCode.Text) = '' then
  begin
    BoxErr('起始编号不能为空!');
    Exit ;
  end;

  if Trim(edtEndCode.Text) = '' then
  begin
    BoxErr('截止编号不能为空!');
    Exit ;
  end;

  if StrToInt(edtStartCode.Text) >= StrToInt(edtEndCode.Text) then
  begin
    BoxErr('起始编号不能大于截止编号!');
    Exit ;
  end;
  Result := True ;
end;

procedure TFrmGoodsRangeView.edtEndCodeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then key := #0;
end;

procedure TFrmGoodsRangeView.edtStartCodeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then key := #0;
end;

procedure TFrmGoodsRangeView.FormCreate(Sender: TObject);
begin
  m_RsLCGoodsMgr := TRsLCGoodsMgr.Create(g_WebAPIUtils);
  m_LendingTypeList := TRsLendingTypeList.Create;
end;

procedure TFrmGoodsRangeView.FormDestroy(Sender: TObject);
begin
  m_LendingTypeList.Free ;
  m_RsLCGoodsMgr.Free;
end;

procedure TFrmGoodsRangeView.InitData(ActType: string;
  GoodsRange: RRsGoodsRange);
begin
  m_strActType := ActType ;
  Caption := Caption + Format('[ %s ]',[ActType]) ;
  m_GoodsRange := GoodsRange ;
  InitGoodsType ;

  if m_strActType = '修改' then
  begin
    edtStartCode.Text := IntToStr( m_GoodsRange.nStartCode );
    edtEndCode.Text := IntToStr( m_GoodsRange.nStopCode ) ;
    //mmoExceptCodes.Text := m_GoodsRange.strExceptCodes ;
  end;
end;

procedure TFrmGoodsRangeView.InitGoodsType;
var
  i : Integer ;
begin
  m_LendingTypeList.Clear ;
  m_RsLCGoodsMgr.GetGoodType(m_LendingTypeList);
  cmbGoodsType.Items.Clear;
  for I := 0 to m_LendingTypeList.Count - 1 do
  begin
    cmbGoodsType.AddItemValue(m_LendingTypeList.Items[i].strLendingTypeName,
      IntToStr(m_LendingTypeList.Items[i].nLendingTypeID));
  end;

  cmbGoodsType.Value :=  IntToStr( m_GoodsRange.nLendingTypeID );

end;

class function TFrmGoodsRangeView.ShowFrom(ActType:string;var GoodsRange : RRsGoodsRange): Boolean;
var
  frm : TFrmGoodsRangeView ;
begin
  frm := TFrmGoodsRangeView.Create(nil);
  try
    frm.InitData(ActType,GoodsRange);
    if frm.ShowModal = mrCancel then
      Result := False
    else
    begin
      GoodsRange := frm.m_GoodsRange ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

end.
