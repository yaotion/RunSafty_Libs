unit ufrmLeaveJlSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, ComCtrls, ExtCtrls, RzTabs, Mask, RzEdit,uTrainmanJiaolu,
  uDutyPlace,uLCNameBoardEx,uTFSystem,uLCDict_TrainmanJiaoLu;

type
  TfrmLeaveJlSelect = class(TForm)
    cbbTMJiaolu: TRzComboBox;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    m_JiaoluArray: TRsTrainmanJiaoluArray;
    m_InputJL: TRsLCBoardInputJL;
    m_LCTrainmanJiaolu: TRsLCTrainmanJiaolu;
    SiteGUID : string;
    procedure InitTMJiaolu();
  public
    { Public declarations }
    class function SelectJL(InputJL: TRsLCBoardInputJL): Boolean;
  end;


implementation
{$R *.dfm}

{ TfrmLeaveJlSelect }

procedure TfrmLeaveJlSelect.Button1Click(Sender: TObject);
begin
  if Assigned(m_InputJL) then
  begin
    m_InputJL.jiaoluID := PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).strTrainmanJiaoluGUID;
    m_InputJL.jiaoluName := PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).strTrainmanJiaoluName;
    m_InputJL.jiaoluType := Ord(PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).nJiaoluType);
   

  end;
  ModalResult := mrOk;
end;

procedure TfrmLeaveJlSelect.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLeaveJlSelect.FormShow(Sender: TObject);
begin
  InitTMJiaolu();
  if cbbTMJiaolu.Items.Count > 0 then
  begin
    cbbTMJiaolu.ItemIndex := 0;
  end;

end;


procedure TfrmLeaveJlSelect.InitTMJiaolu;
var
  I: Integer;
begin
  cbbTMJiaolu.Clear;

  m_LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(SiteGUID,'',m_JiaoluArray);

  for I := 0 to Length(m_JiaoluArray) - 1 do
  begin
    cbbTMJiaolu.Items.AddObject(m_JiaoluArray[i].strTrainmanJiaoluName,TObject(@m_JiaoluArray[i]));
  end;
  

end;


class function TfrmLeaveJlSelect.SelectJL(InputJL: TRsLCBoardInputJL): Boolean;
var
  frmLeaveJlSelect: TfrmLeaveJlSelect;
begin
  frmLeaveJlSelect := TfrmLeaveJlSelect.Create(nil);
  try
    frmLeaveJlSelect.m_InputJL := InputJL;
    Result := frmLeaveJlSelect.ShowModal = mrok;
  finally
    frmLeaveJlSelect.Free;
  end;
end;

end.
