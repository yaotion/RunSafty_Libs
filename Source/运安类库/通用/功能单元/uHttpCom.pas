unit uHttpCom;

interface

uses
  SysUtils,Classes,IdBaseComponent, IdComponent,IdTCPConnection, IdTCPClient, IdHTTP,IdURI;

type
  //HTTPͨ����
  //�������ݵĽ���
  TRsHttpCom = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //�������ݲ���ȡ����
    //URL:��ַURL
    //Sendstr����������
    function Post(AUrl:string;DataType:string;const SendStr:string;out ErrStr:string):string;
    function PostStringS(URL: string; Values: TStringS;out ErrStr:string): string;
  private
    //���ӳ�ʱ
    m_ConnectTimeOut: Integer;
  public
    //���ӳ�ʱ����
    property ConnectTimeOut:Integer read m_ConnectTimeOut write m_ConnectTimeOut ;
  end;

implementation

{ TRsHttp }

constructor TRsHttpCom.Create;
begin
  //m_ConnectTimeOut := 10 ;
end;


destructor TRsHttpCom.Destroy;
begin

  inherited;
end;


function TRsHttpCom.Post(AUrl: string;DataType:string;const SendStr: string;out ErrStr:string): string;
var
  strResult : string;
  http:TIdHTTP;
  listStr: TStrings;
begin
  Result := '' ;
  listStr := TStringList.Create;
  http := TIdHTTP.Create(nil);
  try
    try
      with http do
      begin
        Request.Pragma := 'no-cache';
        Request.CacheControl := 'no-cache';
        Request.Connection := 'close';
        listStr.Values['DataType'] := DataType ;
        listStr.Values['data'] := AnsiToUtf8(SendStr);
        strResult := http.Post(AUrl,listStr);
        Result := Utf8ToAnsi(strResult) ;
      end;
    except
      on e:Exception do
      begin
        ErrStr := e.Message ;
      end;
    end;
  finally
    listStr.Free;
    http.Free;
  end;
end;

function TRsHttpCom.PostStringS(URL: string; Values: TStringS;
  out ErrStr: string): string;
var
  idHttp: TIdHTTP;
begin
  idHttp := TIdHTTP.Create(nil);
  try
    try
      idHttp.Request.Pragma := 'no-cache';
      idHttp.Request.CacheControl := 'no-cache';
      idHttp.Request.Connection := 'close';

      Result := idHttp.Post(URL, Values);
    except
      on e:Exception do
      begin
        ErrStr := e.Message ;
      end;
    end;
  finally
    idHttp.Free;
  end;

end;

end.
