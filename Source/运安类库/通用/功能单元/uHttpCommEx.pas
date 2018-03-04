//************************Http����ͨ����****************************************
//*********��װ���ṩͬ��Post���첽Post��ͬ�������ļ����첽�����ļ�����*********
unit uHttpCommEx;

interface

uses
  Classes, Dialogs,Windows, SysUtils, IdBaseComponent, IdComponent,
  IdTCPConnection,IdTCPClient, IdHTTP,Messages,
  uTFSystem,uThreadTask,uwiniNet;

const
  //HTTP�ӿڴ���ҳ������·��
  BAST_PAGENAME = '/AshxService/QueryProcess.ashx';
  
type
  //�ύҳ����Ϣ
  RHttpAddress = record
    //������ַ
    Host : string;
    //�˿ں�
    Port : integer;
    //�ύҳ������Url
    OffsetUrl : string;
    //ת��Ϊ�ַ�����ʽ
    function ToString() : string;
  end;

  //�ύ�����¼�֪ͨ
  TOnPostCompleteEvent = procedure(HttpAddress : RHttpAddress;
    PostResult : string;Success : boolean) of Object;

  //////////////////////////////////////////////
  ///  ����:THttpPostTask
  ///  ˵��:HTTP�ύ����
  //////////////////////////////////////////////
  THttpPostTask = class(TTask)
  public
    //�ύ����¼�֪ͨ
    OnPostComplete : TOnPostCompleteEvent;
    //�ύʧ��ʱ��֪ͨ
    OnPostFailure : TOnPostCompleteEvent;
    //�ύҳ��ĵ�ַ
    HttpAddress : RHttpAddress;
    //�ύ����
    Params : TStrings;
  protected
    //�ӿڷ��ص�JSON
    m_strPostResult : String;
  protected
    //����:ִ������
    procedure DoTask();override;
    //����:����ִ�����
    procedure Done();override;
  end;

  //////////////////////////////////////////////
  ///  ����:THttpDownloadTask
  ///  ˵��:HTTP�ļ���������
  //////////////////////////////////////////////
  THttpDownloadTask = class(TTask)
  public
    //�ļ���ʼ����
    OnWorkBegin : TWorkBeginEvent;
    //�ļ����ؽ���
    OnWorkEnd : TWorkEndEvent;
    //�ļ����ؽ���
    OnWork : TWorkEvent;
    //�ļ�����ʧ��ʱ��֪ͨ
    OnDownloadFailure : TOnEventByString;
    //�ļ�����ҳ��URL
    HttpAddress : RHttpAddress;
    //����
    Params : TStrings;
    //�ļ���
    SaveName : String;
  protected
    //����:ִ������
    procedure DoTask();override;
    //����:����ִ�����
    procedure Done();override;
  end;

  //////////////////////////////////////////////
  ///  ����:THttpInterface
  ///  ˵��:HTTP�ӿ��ύ��
  //////////////////////////////////////////////
  THttpComm = class
  public
    constructor Create;
    destructor Destroy; override;
  public
    //�첽�ύ���ݿ�ʼ
    OnPostAsyncBegin : TOnEvent;
    //�첽�ύ���ݽ���
    OnPostAsyncEnd : TOnEvent;
  public
    //Post��ʽͬ���ύ����
    function Post(HttpAddress : RHttpAddress;Params : TStrings) : string;overload;
    //Post��ʽ�첽�ύ����{���Դ���2���ص�������һ�����ύ�ɹ���һ�����ύʧ��}
    procedure PostAsync(HttpAddress : RHttpAddress;Params : TStrings;
        OnPostComplete: TOnPostCompleteEvent = nil;
        OnPostFailure: TOnPostCompleteEvent = nil);overload;
    //ͬ�������ļ�
    procedure DownloadFile(HttpAddress : RHttpAddress;Params : TStrings;SaveName : string;
        OnWorkBegin : TWorkBeginEvent = nil;OnWorkEnd : TWorkEndEvent=nil;
        OnWork : TWorkEvent = nil);overload;
     //�첽�����ļ�
    procedure DownloadFileAsync(HttpAddress : RHttpAddress;Params : TStrings;SaveName : string;
        OnDownloadFailure:TOnEventByString;
        OnWorkBegin : TWorkBeginEvent = nil;OnWorkEnd : TWorkEndEvent=nil;
        OnWork : TWorkEvent = nil);overload;
  end;

implementation

//ͨ��HttpPost����
function PostProc(HttpAddress : RHttpAddress;Params: TStrings) : string;
var
  idHttp: TIdHTTP;
  strUrl : string;
begin
  idhttp := TIdHTTP.Create(nil);
  try
    strUrl := HttpAddress.ToString();
    result := idHttp.Post(strUrl, Params);
    //Utf8ת��
    result := Utf8ToAnsi(result);
  finally
    idHttp.free;
  end;
end;
//ͨ��Http�ļ����ط���
procedure DownloadFileProc(HttpAddress: RHttpAddress; Params: TStrings;SaveName : string;
  OnWorkBegin: TWorkBeginEvent; OnWorkEnd: TWorkEndEvent; OnWork: TWorkEvent);
var
  idHttp: TIdHTTP;
  fs : TFileStream;
  strUrl : string;
begin
  idHttp := TIdHttp.Create(nil);
  strUrl := HttpAddress.ToString();
  fs := TFileStream.Create(SaveName,fmCreate);
  try
    idHttp.OnWorkBegin := OnWorkBegin;
    idHttp.OnWorkEnd := OnWorkEnd;
    idHttp.OnWork := OnWork;
    idHttp.Post(strUrl,Params,fs);
  finally
    idHttp.free;
    fs.Free;
  end;
end;



procedure SendPostResult(Msg : Integer;WndHandle : HWND;
    strResult:String;
    OnPostResult: TOnEventByString);
//����:�����ύ���
var
  pBuf: PChar;
begin
  GetMem(pBuf, Length(strResult) + 1);
  ZeroMemory(pBuf, Length(strResult) + 1);
  StrPCopy(pBuf, strResult);

  if Assigned(OnPostResult) then
    PostMessage(WndHandle, Msg, Integer(pBuf), Integer(@OnPostResult))
  else
    PostMessage(WndHandle, Msg, Integer(pBuf), 0);
end;


{ THttpInterface }


constructor THttpComm.Create;
begin
end;

destructor THttpComm.Destroy;
begin
  inherited;
end;

procedure THttpComm.DownloadFileAsync(HttpAddress: RHttpAddress;
  Params: TStrings; SaveName: string; OnDownloadFailure: TOnEventByString;
  OnWorkBegin: TWorkBeginEvent; OnWorkEnd: TWorkEndEvent; OnWork: TWorkEvent);
{����:�첽�����ļ�}
var
  downloadTask  : THttpDownloadTask;
begin
  downloadTask := THttpDownloadTask.Create;
  downloadTask.OnDownloadFailure := OnDownloadFailure;
  downloadTask.HttpAddress := HttpAddress;
  downloadTask.SaveName := SaveName;
  downloadTask.Params := Params;
  downloadTask.OnTaskBeginEvent := OnPostAsyncBegin;
  downloadTask.OnTaskEndEvent := OnPostAsyncEnd;
  downloadTask.OnWorkBegin := OnWorkBegin;
  downloadTask.OnWorkEnd := OnWorkEnd;
  downloadTask.OnWork := OnWork;
  TThreadTask.Create(downloadTask);
end;

procedure THttpComm.DownloadFile(HttpAddress: RHttpAddress; Params: TStrings;SaveName : string;
  OnWorkBegin: TWorkBeginEvent; OnWorkEnd: TWorkEndEvent; OnWork: TWorkEvent);
begin
  DownloadFileProc(HttpAddress,Params,SaveName,OnWorkBegin,OnWorkEnd,OnWork);
end;


procedure THttpComm.PostAsync(HttpAddress: RHttpAddress; Params: TStrings;
  OnPostComplete, OnPostFailure: TOnPostCompleteEvent);
{�첽�ύ�ύ}
var
  postTask  : THttpPostTask;
begin
  postTask := THttpPostTask.Create;
  postTask.OnPostComplete := OnPostComplete;
  postTask.OnPostFailure := OnPostFailure;

  postTask.OnTaskBeginEvent := OnPostAsyncBegin;
  postTask.OnTaskEndEvent := OnPostAsyncEnd;

  postTask.HttpAddress := HttpAddress;
  postTask.Params := Params;
  TThreadTask.Create(postTask);
end;

function THttpComm.Post(HttpAddress : RHttpAddress;Params: TStrings): string;
begin
  result := PostProc(HttpAddress,Params);
end;



{ THttpPostTask }

procedure THttpPostTask.Done;
begin
  if m_bDoTaskResult then
  begin
    if Assigned(OnPostComplete) then
      OnPostComplete(HttpAddress,m_strPostResult,true);
  end
  else
  begin
    if Assigned(OnPostFailure) then
      OnPostFailure(HttpAddress,m_strDoTaskErrorMessage,false);
  end;
end;

procedure THttpPostTask.DoTask;
begin
  inherited;
  m_strPostResult := PostProc(HttpAddress,Params);
end;

{ THttpDownloadTask }

procedure THttpDownloadTask.Done;
begin
  inherited;
  if m_bDoTaskResult = False then
  begin
    if Assigned(OnDownloadFailure) then
      OnDownloadFailure(m_strDoTaskErrorMessage);
  end;
end;

procedure THttpDownloadTask.DoTask;
begin
  inherited;
  DownloadFileProc(HttpAddress,Params,SaveName,OnWorkBegin,OnWorkEnd,OnWork);
end;

{ RHttpAddress }

function RHttpAddress.ToString: string;
begin
  result := Format('http://%s:%d%s',[Host,Port,OffsetUrl]);
end;

end.
