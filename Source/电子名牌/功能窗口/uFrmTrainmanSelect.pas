unit uFrmTrainmanSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,uTrainmanJiaolu,uTrainman, ExtCtrls, RzLstBox,
  RzChkLst;

type
  TFrmTrainmanSelect = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbGroup: TLabel;
    lstSelTrainman: TCheckListBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lstSelTrainmanClick(Sender: TObject);
  private
    //��ȡ������������ʱ��
    m_dtArriveTime:TDateTime;
    //������Ϣ
    m_Group: RRsGroup;
  private
    { Private declarations }
    //��[NUMBER]NAME����ȡ��NUMBER
    function GetTrainmanNumber(NumberName: String): string;
    //��ʼ��������Ϣ��LISTBOX
    procedure InitData(Group : RRsGroup);
    //�������Ҫ��
    function CheckInput():Boolean;
  public
    { Public declarations }
    class function GetSelTrainman(Group : RRsGroup;var ArriveTime:TDateTime):Boolean;
  end;

var
  FrmTrainmanSelect: TFrmTrainmanSelect;

implementation

{$R *.dfm}

//[Number]Name
//��NUMBER��������
//�ҵ�]������λ�ã��ӵڶ�����ʼ���� 
function TFrmTrainmanSelect.GetTrainmanNumber(NumberName: String): string;
var
  i : Integer ;
begin
  i := Pos(']',NumberName);
  Result := Copy(NumberName,2,i-2);
end;


procedure TFrmTrainmanSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmTrainmanSelect.btnOkClick(Sender: TObject);
var
  nSel:Integer ;
  strNumber:string;
begin
  if not CheckInput then
    Exit;
  nSel := lstSelTrainman.ItemIndex ;
  strNumber :=  GetTrainmanNumber( lstSelTrainman.Items[nSel] );
  if strNumber = m_Group.Trainman1.strTrainmanNumber then
    m_dtArriveTime := m_Group.Trainman1.dtLastEndworkTime
  else if strNumber = m_Group.Trainman2.strTrainmanNumber then
    m_dtArriveTime := m_Group.Trainman2.dtLastEndworkTime
  else if strNumber = m_Group.Trainman3.strTrainmanNumber then
    m_dtArriveTime := m_Group.Trainman3.dtLastEndworkTime
  else
    m_dtArriveTime := m_Group.Trainman4.dtLastEndworkTime ;

  ModalResult := mrOk ;
end;

function TFrmTrainmanSelect.CheckInput: Boolean;
begin
  if lstSelTrainman.ItemIndex = -1  then
    Result := False
  else
    Result := True ;
end;

class function TFrmTrainmanSelect.GetSelTrainman(Group: RRsGroup;
  var ArriveTime:TDateTime): Boolean;
var
  frm : TFrmTrainmanSelect;
begin
  Result := False ;
  frm := TFrmTrainmanSelect.Create(nil);
  try
    frm.InitData(Group);
    if frm.ShowModal = mrOk then
    begin
      ArriveTime := frm.m_dtArriveTime ;
      Result := True ;
    end;
  finally

  end;
end;

procedure TFrmTrainmanSelect.InitData(Group: RRsGroup);
begin
  m_Group := Group ;
  lstSelTrainman.Items.Clear;
  if Group.Trainman1.strTrainmanGUID <> '' then
    lstSelTrainman.Items.Add('[' + Group.Trainman1.strTrainmanNumber + ']' + Group.Trainman1.strTrainmanName);
  if Group.Trainman2.strTrainmanGUID <> '' then
    lstSelTrainman.Items.Add('[' + Group.Trainman2.strTrainmanNumber +  ']'  + Group.Trainman2.strTrainmanName);
  if Group.Trainman3.strTrainmanGUID <> '' then
    lstSelTrainman.Items.Add('[' + Group.Trainman3.strTrainmanNumber +  ']'  + Group.Trainman3.strTrainmanName);
  if Group.Trainman4.strTrainmanGUID <> '' then
    lstSelTrainman.Items.Add('[' + Group.Trainman4.strTrainmanNumber +  ']'  + Group.Trainman4.strTrainmanName);
  lstSelTrainman.ItemIndex := 0 ;
  lstSelTrainman.Checked[0]:= True ;
end;

procedure TFrmTrainmanSelect.lstSelTrainmanClick(Sender: TObject);
var
  i,index:integer;
begin
  //ֻ��ѡ��һ��CHECK
  //��ȡ��ǰѡ�е�INDEX��������INDEX��CHECKED����ΪFALSE
  //��ǰѡ�е�INDEX��CHECKERΪTRUE
  index := lstSelTrainman.ItemIndex;
  if lstSelTrainman.Selected[index] then
  begin
    for i:= 0 to lstSelTrainman.Items.Count - 1 do
    begin
      lstSelTrainman.Checked[i]:= ( i = index );
    end;
  end;
end;

end.
