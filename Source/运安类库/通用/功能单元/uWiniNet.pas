unit uWiniNet;

interface
uses
  wininet,Windows,classes,SysUtils;
function WebPagePost(sURL,sPostData:string):string;  
implementation
function WebPagePost(sURL,sPostData:string):string;
const
  RequestMethod = 'POST';
  HTTP_VERSION  = 'HTTP/1.1';  //HTTP版本 我抓包看过 HTTP/1.0 HTTP/1.1。尚未仔细了解其区别。按MSDN来写的。留空默认是1.0
var
  dwSize:DWORD;
  dwBytesRead,dwReserved:DWORD;
  hInte,hConnection,hRequest:HInternet;
  ContentSize:array[1..1024] of Char;
  HostPort:Integer;
  HostName,FileName,sHeader:String;
  pResult: Pointer;
  dwFileSize: Int64;
  procedure ParseURL(URL: string;var HostName,FileName:string;var HostPort:Integer);
  var
    i,p,k: integer;
    function StrToIntDef(const S: string; Default: Integer): Integer;
    var
      E: Integer;
    begin
      Val(S, Result, E);
      if E <> 0 then Result := Default;
    end;
  begin
    if lstrcmpi('http://',PChar(Copy(URL,1,7))) = 0 then System.Delete(URL, 1, 7);
    HostName := URL;
    FileName := '/';
    HostPort := INTERNET_DEFAULT_HTTP_PORT;
    i := Pos('/', URL);
    if i <> 0 then
    begin
      HostName := Copy(URL, 1, i-1);
      FileName := Copy(URL, i, Length(URL) - i + 1);
    end;
    p:=pos(':',HostName);
    if p <> 0 then
    begin
      k:=Length(HostName)-p;
      HostPort:=StrToIntDef(Copy(HostName,p+1,k),INTERNET_DEFAULT_HTTP_PORT);
      Delete(HostName,p,k+1);
    end;
  end;

begin
  Result := '';
  ParseURL(sURL,HostName,FileName,HostPort);
  // 函数原型见 http://technet.microsoft.com/zh-cn/subscriptions/aa385096(v=vs.85).aspx
  hInte := InternetOpen('', //UserAgent
                           INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  if hInte<>nil then
  begin
    hConnection := InternetConnect(hInte,   // 函数原型见 http://technet.microsoft.com/zh-cn/query/ms909418
                                   PChar(HostName),
                                   HostPort,
                                   nil,
                                   nil,
                                   INTERNET_SERVICE_HTTP,
                                   0,
                                   0);
    if hConnection<>nil then
    begin
      hRequest := HttpOpenRequest(hConnection,  // 函数原型见 http://msdn.microsoft.com/zh-cn/library/aa917871
                                  PChar(RequestMethod),
                                  PChar(FileName),
                                  HTTP_VERSION,
                                  '', //Referrer 来路
                                  nil,//AcceptTypes 接受的文件类型 TEXT/HTML */*
                                  INTERNET_FLAG_NO_CACHE_WRITE or
                                  INTERNET_FLAG_RELOAD,
                                  0);
      if hRequest<>nil then
      begin
        sHeader := 'Content-Type: application/x-www-form-urlencoded' + #13#10;
    //    +'CLIENT-IP: 216.13.23.33'+#13#10
    //    'X-FORWARDED-FOR: 216.13.23.33' + #13#10+; 伪造代理IP

        // 函数原型见 http://msdn.microsoft.com/zh-cn/library/aa384227(v=VS.85)
        HttpAddRequestHeaders(hRequest,PChar(sHeader),
                              Length(sHeader),
                              HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE);
        // 函数原型见 http://msdn.microsoft.com/zh-cn/library/windows/desktop/aa384247(v=vs.85).aspx
        if HttpSendRequest(hRequest,nil,0,PChar(sPostData),Length(sPostData)) then
        begin
          dwReserved:=0;
          dwSize:=SizeOf(ContentSize);
          // 函数原型 http://msdn.microsoft.com/zh-cn/subscriptions/downloads/aa384238.aspx
          if HttpQueryInfo(hRequest,HTTP_QUERY_CONTENT_LENGTH,@ContentSize,dwSize,dwReserved) then
          begin
            dwFileSize:=StrToInt(StrPas(@ContentSize));
            GetMem(pResult, dwFileSize + 1);
            try
              ZeroMemory(pResult,dwFileSize + 1);
              InternetReadFile(hRequest,pResult,dwFileSize,dwBytesRead);
              Result := Utf8ToAnsi(StrPas(pResult));
            finally
              Dispose(pResult);
            end;
          end;
        end;
      end;
      InternetCloseHandle(hRequest);
    end;
    InternetCloseHandle(hConnection);
  end;
  InternetCloseHandle(hInte);
end;

end.
