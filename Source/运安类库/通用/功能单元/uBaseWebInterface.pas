unit uBaseWebInterface;

interface

uses
  SysUtils,Classes,superobject,uHttpCom;

type


  //��վ�ӿڻ���
  TBaseWebInterface = class
  public
    //���캯��
    //AURL �ӿڵ�ַ
    //ClientID�ͻ��˱��
    constructor Create(AUrl:string;ClientID:string;SiteID:string);
    //��������
    destructor  Destroy();override;
  protected
    //����JSON��������
    function  CreateInputJson():ISuperObject;
    //�ύJSON���ݵ�WEB�ӿ� dataType = �ύ����  sendstr ���������   ErrStr  ���������
    function  Post(DataType:string;SendStr:string;out ErrStr:string):string;
    {����:�ύ����,ԭʼ��ʽ}
    function PostStringS(DataType: string; Values: TStringS;out ErrStr:string):string;
    //���JSON�ķ��ؽ��,������JSON����
    function  GetJsonResult(AStr:string;out AJson:ISuperObject;out ErrStr:string):Boolean;
  protected
    //�ͻ��˱��
    m_strClientID:string;
    //��ַ�ӿ�
    m_strUrl:string;
    //SITE_id
    m_strSiteID:string;
  public
    property ClientID:string read m_strClientID ;
    property Url:string read m_strUrl ;
    property SiteID:string read m_strSiteID ;
  end;

implementation

{ TBaseWebInterface }


function TBaseWebInterface.GetJsonResult(AStr: string;
  out AJson: ISuperObject;out ErrStr:string): Boolean;
var
  json: ISuperObject;
begin
  Result := False ;
  try
    if AStr = '' then
    begin
      ErrStr := '��������Ϊ��' ;
      exit ;
    end;
    json := SO(AStr);
    if json = nil then
      Exit ;
    if  json.I['result']  = 0  then
    begin
      if  json.O['data'] <> nil  then
      begin
        AJson :=  json.O['data'] ;
      end;
      Result := True ;
    end
    else
      ErrStr := json.S['resultStr'];
  except
   on e:Exception do
   begin
    ErrStr := e.Message ;
   end;
  end;
end;




constructor TBaseWebInterface.Create(AUrl, ClientID: string;SiteID:string);
begin
  inherited Create();
  m_strClientID := ClientID ;
  m_strUrl := AUrl ;
  m_strSiteID := SiteID ;
end;

function TBaseWebInterface.CreateInputJson: ISuperObject;
var
  json : ISuperObject ;
begin
  json := SO('{}');
  json.S['cid'] := m_strSiteID;//m_strClientID ;
  Result := json ;
end;

destructor TBaseWebInterface.Destroy;
begin
  inherited;
end;


function TBaseWebInterface.Post(DataType, SendStr: string;
  out ErrStr: string): string;
var
  http : TRsHttpCom;
begin
  http := TRsHttpCom.Create;
  try
    Result := http.Post(m_strUrl,DataType,SendStr,ErrStr);
  finally
    http.Free ;
  end;

end;

function TBaseWebInterface.PostStringS(DataType: string; Values: TStringS;
  out ErrStr:string):string;
var
  http : TRsHttpCom;
begin
  Result := '';
  http := TRsHttpCom.Create;
  try
    Result := http.PostStringS(m_strUrl + 'DataType=' + DataType,Values,ErrStr);
  finally
    http.Free ;
  end;
end;

end.
