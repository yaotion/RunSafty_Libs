unit uFrmAPITrainman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,RsUtilsLib_TLB,RsAPITrainmanLib_TLB,
  ComCtrls,uTFComObject,RsFingerLib_TLB,uTFVariantUtils;

type
  TfrmRsAPITrainman = class(TForm)
    Panel2: TPanel;
    PageControl1: TPageControl;
    tabAPI: TTabSheet;
    tabUI: TTabSheet;
    memoResponse: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtHost: TEdit;
    edtPort: TEdit;
    edtOffsetUrl: TEdit;
    Panel3: TPanel;
    btnRequest: TButton;
    Memo1: TMemo;
    Panel4: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure btnRequestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    m_APITrainman : IRsAPITrainman;
    m_UITrainman : IRsUITrainman;
    m_FingerUtils : IRsFinger;
    function GetIF(DLLPath : WideString;IFGUID : TGUID) : IUnknown;
  public
    { Public declarations }
    class procedure ShowForm;
  end;



implementation

uses uGlobalDM;
var
  frmRsAPITrainman: TfrmRsAPITrainman;
{$R *.dfm}

procedure TfrmRsAPITrainman.btnRequestClick(Sender: TObject);
var
  query : RRsQueryTrainman;
  totalCount : Integer;
  trainmans : IRsTrainmanArray;
begin
  m_APITrainman.QueryTrainmans_blobFlag(query,1,trainmans,totalCount);
  ShowMessage(Format('共获取%d跳记录',[totalCount]));
end;

procedure TfrmRsAPITrainman.Button1Click(Sender: TObject);
var
  inputtm : IRsTrainman;
  inputText : string;
begin
  if (m_UITrainman.InputTrainman('3b50bf66-dabb-48c0-8b6d-05db80591090',inputtm)) then
  begin
    inputText := Format('您选择了人员:【%s】%s',[(inputtm as irsTrainman).strTrainmanNumber,
      (inputtm as irsTrainman).strTrainmanName]);
    ShowMessage(inputText);
  end;
end;

procedure TfrmRsAPITrainman.Button2Click(Sender: TObject);
var
  tm : IRsTrainman;
  verify : Integer;
begin
 if M_UITrainman.IDTrainman('','','','','',tm,verify) then
  begin
    ShowMessage(Format('找到人员[%s]%s,验证方式为:%d',[tm.strTrainmanNumber,tm.strTrainmanName,verify]));
  end;
end;

procedure TfrmRsAPITrainman.FormCreate(Sender: TObject);
var
  RsUtils: IWebAPI;
  dllRoot : string;
  tm : IRsTrainman;
  verify : Integer;
  ms : TMemoryStream;
  ATemplate : OleVariant;
  fdata : array of OleVariant;
begin
  dllRoot :=ExtractFilePath(Application.ExeName) + 'libs\';

  ms := TMemoryStream.Create;
  try
    ms.LoadFromFile(ExtractFilePath(Application.ExeName) + 'tmp.finger');
    ATemplate := TTFVariantUtils.StreamToTemplateOleVariant(ms);
  finally
    ms.Free;
  end;
  SetLength(fdata,1);
  fdata[0] := ATemplate;  
  m_FingerUtils :=GetIF(dllRoot + 'RsFingerLib.dll',CLASS_RsFinger) as IRsFinger;

  m_FingerUtils.Open;
  m_FingerUtils.AddFinger(12345,fdata);
  RsUtils := GetIF(dllRoot + 'RsUtilsLib.dll',CLASS_WebAPI) as IWebAPI;
  RsUtils.Host := edtHost.Text;
  RsUtils.Port := strToInt(edtPort.Text);
  RsUtils.OffsetUrl := edtOffsetUrl.Text;

  m_APITrainman := GetIF(dllRoot + 'RsAPITrainmanLib.dll',CLASS_RsAPITrainman)
    as IRsAPITrainman;
  m_APITrainman.WebAPI :=  RsUtils;

  m_UITrainman := GetIF(dllRoot + 'RsAPITrainmanLib',CLASS_RsUITrainman)
    as IRsUITrainman;
  m_UITrainman.APITrainman :=  m_APITrainman;
  tm := GetIF(dllRoot + 'RsAPITrainmanLib',CLASS_RsTrainman) AS IRsTrainman;
  tm.nID := 12345;
  tm.strTrainmanName := '张三丰';
  tm.strTrainmanNumber := '23012345';
  tm.FingerPrint1 := ATemplate;
  M_UITrainman.CacheTrainmans.Add(tm);
  m_UITrainman.CacheVerify := true;
  M_UITrainman.FingerUtils := m_FingerUtils;


end;

procedure TfrmRsAPITrainman.FormDestroy(Sender: TObject);
begin
  
  m_UITrainman := nil;
  m_APITrainman := nil;
end;

function TfrmRsAPITrainman.GetIF(DLLPath: WideString; IFGUID: TGUID): IUnknown;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(DLLPath,IFGUID,IUnKnown);
    result := ifObj.DefaultInterface;
  finally
    ifObj.Free;
  end;
end;

class procedure TfrmRsAPITrainman.ShowForm;
begin
  frmRsAPITrainman:= TfrmRsAPITrainman.Create(nil);
  try
    frmRsAPITrainman.ShowModal;
  finally
    frmRsAPITrainman.Free;
  end;
end;

end.
