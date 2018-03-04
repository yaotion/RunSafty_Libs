//************************Http基本通信类****************************************
//*********封装类提供同步Post、异步Post、同步下载文件、异步下载文件功能*********
unit uHttpCommEx;

interface

uses
  Classes, Dialogs,Windows, SysUtils, IdBaseComponent, IdComponent,
  IdTCPConnection,IdTCPClient, IdHTTP,Messages,
  uTFSystem,uThreadTask,uwiniNet;

const
  //HTTP接口处理页面的相对路径
  BAST_PAGENAME = '/AshxService/QueryProcess.ashx';
  
type
  //提交页面信息
  RHttpAddress = record
    //主机地址
    Host : string;
    //端口号
    Port : integer;
    //提交页面的相对Url
    OffsetUrl : string;
    //转化为字符串格式
    function ToString() : string;
  end;

  //提交结束事件通知
  TOnPostCompleteEvent = procedure(HttpAddress : RHttpAddress;
    PostResult : string;Success : boolean) of Object;

  //////////////////////////////////////////////
  ///  类名:THttpPostTask
  ///  说明:HTTP提交任务
  //////////////////////////////////////////////
  THttpPostTask = class(TTask)
  public
    //提交完毕事件通知
    OnPostComplete : TOnPostCompleteEvent;
    //提交失败时间通知
    OnPostFailure : TOnPostCompleteEvent;
    //提交页面的地址
    HttpAddress : RHttpAddress;
    //提交参数
    Params : TStrings;
  protected
    //接口返回的JSON
    m_strPostResult : String;
  protected
    //功能:执行任务
    procedure DoTask();override;
    //功能:任务执行完毕
    procedure Done();override;
  end;

  //////////////////////////////////////////////
  ///  类名:THttpDownloadTask
  ///  说明:HTTP文件下载任务
  //////////////////////////////////////////////
  THttpDownloadTask = class(TTask)
  public
    //文件开始下载
    OnWorkBegin : TWorkBeginEvent;
    //文件下载结束
    OnWorkEnd : TWorkEndEvent;
    //文件下载进度
    OnWork : TWorkEvent;
    //文件下载失败时间通知
    OnDownloadFailure : TOnEventByString;
    //文件下载页面URL
    HttpAddress : RHttpAddress;
    //参数
    Params : TStrings;
    //文件名
    SaveName : String;
  protected
    //功能:执行任务
    procedure DoTask();override;
    //功能:任务执行完毕
    procedure Done();override;
  end;

  //////////////////////////////////////////////
  ///  类名:THttpInterface
  ///  说明:HTTP接口提交类
  //////////////////////////////////////////////
  THttpComm = class
  public
    constructor Create;
    destructor Destroy; override;
  public
    //异步提交数据开始
    OnPostAsyncBegin : TOnEvent;
    //异步提交数据结束
    OnPostAsyncEnd : TOnEvent;
  public
    //Post方式同步提交数据
    function Post(HttpAddress : RHttpAddress;Params : TStrings) : string;overload;
    //Post方式异步提交数据{可以传递2个回调函数，一个是提交成功，一个是提交失败}
    procedure PostAsync(HttpAddress : RHttpAddress;Params : TStrings;
        OnPostComplete: TOnPostCompleteEvent = nil;
        OnPostFailure: TOnPostCompleteEvent = nil);overload;
    //同步下载文件
    procedure DownloadFile(HttpAddress : RHttpAddress;Params : TStrings;SaveName : string;
        OnWorkBegin : TWorkBeginEvent = nil;OnWorkEnd : TWorkEndEvent=nil;
        OnWork : TWorkEvent = nil);overload;
     //异步下载文件
    procedure DownloadFileAsync(HttpAddress : RHttpAddress;Params : TStrings;SaveName : string;
        OnDownloadFailure:TOnEventByString;
        OnWorkBegin : TWorkBeginEvent = nil;OnWorkEnd : TWorkEndEvent=nil;
        OnWork : TWorkEvent = nil);overload;
  end;

implementation

//通用HttpPost方法
function PostProc(HttpAddress : RHttpAddress;Params: TStrings) : string;
var
  idHttp: TIdHTTP;
  strUrl : string;
begin
  idhttp := TIdHTTP.Create(nil);
  try
    strUrl := HttpAddress.ToString();
    result := idHttp.Post(strUrl, Params);
    //Utf8转码
    result := Utf8ToAnsi(result);
  finally
    idHttp.free;
  end;
end;
//通用Http文件下载方法
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
//功能:发送提交结果
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
{功能:异步下载文件}
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
{异步提交提交}
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
