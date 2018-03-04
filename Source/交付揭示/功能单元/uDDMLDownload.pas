unit uDDMLDownload;

interface
uses
  Windows, Classes, Math, SysUtils, IdHTTP, Contnrs, ADODB, DB,
  uFTPTransportControl,IdFTP,uTFDBAutoConnect,uTFSystem,
  IdFTPList,Dialogs,RAR;
const
  CS_DDMLFILENAME ='��������.RAR';
  DDMLFile_DIRName = 'DDMLDB_FILE\';
  //��Ч�����ļ�
  DDMLFILE_VALIDTIME = 'jstime.txt';  
type
  TDDMLDownload =class
    constructor Create() ;
    destructor Destroy();override;
  private
    {ftp�������}
    FTPTransportControl: TFTPTransportControl;
    unRar :TRAR;
  private
    function testFtpCon(out errmsg:string):Boolean;
    procedure InitFTPConfig();
    function bNeedDownload(out errmsg :string;var dtNewRARFile:TDateTime):Boolean;
    function AppPath: string;
  public
    {����:����˼ά���д�����ݿ�}
    function DoUpdate(out bUpdated:Boolean; out errmsg:string):Boolean;

  private
    {����:����˼ά��������.RAR}
    Function Download(dtNewRarFile:TDatetime;out errmsg:string):Boolean;
    {����:��ѹ˼ά��������.RAR}
    Function JieYaRar():Boolean;
    {����:RAR��ѹ����ص�����}
    procedure OnRarPasswordRequired(Sender: TObject;const HeaderPassword: Boolean;
      const FileName: string; out NewPassword: string; out Cancel: Boolean);
  end;

implementation

uses uGlobal;

{ TDDMLDownload }

function TDDMLDownload.AppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function TDDMLDownload.bNeedDownload(out errmsg :string;var dtNewRARFile:TDateTime): Boolean;
var
  IdFTPListItems:TIdFTPListItems;
  i:integer;
  _str:string;
begin
  Result := False;
  IdFTPListItems :=TIdFTPListItems.Create;
  try
    try
   // if FTPTransportControl.CheckFileExists('','��������.rar') = False then Exit ;
    

    if FTPTransportControl.GetDirectoryListing(FTPTransportControl.FTPConfig.strDir,
      IdFTPListItems)= False then
    begin
      errmsg := '��ȡFTPĿ¼�ļ��б���Ϣ����!';
      Exit;
    end;
    except on e:Exception do
      errmsg :='��ȡFTPĿ¼�ļ��б���Ϣ����!:' + e.Message;
    end;
    //strList := TStringList.Create;
    for I := 0 to IdFTPListItems.Count - 1 do
    begin
     // strList.Add(IdFTPListItems.Items[i].FileName);
      //_str := Utf8ToAnsi(IdFTPListItems.Items[i].FileName);
      _str :=IdFTPListItems.Items[i].FileName;
      if SameText(_str,CS_DDMLFILENAME) then
      begin
        if FormatDateTime('yyyy-mm-dd hh:mm:ss',TPubJsConfig.DlUpdateTime) <>
          FormatDateTime('yyyy-mm-dd hh:mm:ss',IdFTPListItems.Items[i].ModifiedDate) then
        begin
          dtNewRARFile :=IdFTPListItems.Items[i].ModifiedDate;
          Result := True;
          Break;
        end;
      end;
    end;
    //strList.SaveToFile('d:\FileNam.Txt');

  finally
    IdFTPListItems.Free;
  end;

end;

constructor TDDMLDownload.Create();
begin
  FTPTransportControl:= TFTPTransportControl.Create(nil);
  unRar := TRAR.Create(nil);
  unRar.OnPasswordRequired := self.OnRarPasswordRequired;
end;

destructor TDDMLDownload.Destroy;
begin
  FTPTransportControl.Free;
  unRar.Free;
  inherited;
end;

function TDDMLDownload.DoUpdate(out bUpdated:Boolean;out errmsg:string):Boolean;
var
  dtNewRarFile:TDateTime;
begin
  Result := False;
  bUpdated := False;
  errmsg:= '';

  try
    InitFTPConfig();
    if testFtpCon(errmsg) = False then
    begin
      exit;
    end;
    if bNeedDownload(errmsg,dtNewRarFile) = False then
    begin
      result := True;
      Exit;
    end;
    if self.Download(dtNewRarFile,errmsg) = False then Exit;
    if Self.JieYaRar = True then
    begin
      bUpdated := True;
      TPubJsConfig.DlUpdateTime := dtNewRarFile;
      Result := True;
    end;
  except on e: Exception do
    errmsg := '���ص�������ʧ�ܣ�'+e.Message;
  end;
end;

Function TDDMLDownload.Download(dtNewRarFile:TDatetime;out errmsg:string):Boolean;
var
  strServerFileName :string;
begin
  Result := False;
  //ShowMessage('��ʼ��ftp�����ص��������ļ�...') ;
  strServerFileName := AppPath + DDMLFile_DIRName +  CS_DDMLFILENAME;
  if False = FTPTransportControl.Download(CS_DDMLFILENAME,
      strServerFileName,
      FTPTransportControl.FTPConfig.strDir,True) then
  begin
    errmsg := '��ftp�����ص��������ļ�ʧ��!' ;
    Exit;
  end;
  
  Result := True;
  //ShowMessage('��ftp�����ص��������ļ��ɹ�!');
end;

procedure TDDMLDownload.InitFTPConfig;
begin
  FTPTransportControl.FTPConfig := TPubJsConfig.DLFTPConfig;
end;

function TDDMLDownload.JieYaRar:Boolean;
var
  s_pathName,d_pathName:string;
  files:TStrings;
begin
  Result := True;
  files := TStringList.Create;
  files.Add('Ickddds.mdb') ;
  files.Add('jstime.txt');
  s_pathName := AppPath + DDMLFile_DIRName +'��������.RAR';
  d_pathName := AppPath + DDMLFile_DIRName;
  if unRar.OpenFile(s_pathName) then
  begin
    result := unRar.Extract(d_pathName,True,files);
  end;
  files.Free;
end;

procedure TDDMLDownload.OnRarPasswordRequired(Sender: TObject;
  const HeaderPassword: Boolean; const FileName: string;
  out NewPassword: string; out Cancel: Boolean);
begin
  Cancel := False;
  NewPassword := 'thinker';
end;

function TDDMLDownload.testFtpCon(out errmsg:string): Boolean;
begin
  result := False;
  //����Telnet�������Զ��������SQL����˿��Ƿ��
  with FTPTransportControl do
  begin
    if not TTFDBAutoConnect.TelnetServerDB(FTPConfig.strHost,FTPConfig.nPort,1000) then
    begin
      errmsg :='FTP������δ�򿪼����˿ڣ��޷�����!';
      exit;
    end;
  end;

  result := True;
end;

end.
