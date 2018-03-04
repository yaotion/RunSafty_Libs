unit RsLibPoolImpl;

interface
uses
  Classes,Contnrs,Windows,Forms,uRsLibPoolLib,uRsLibUtils;
type
  TRsLibItem = class
    //类库ID
    HLID : Cardinal;
    //类库名称
    LibName : string;
    //类库路径
    LibPath : string;
  end;
  
  TRsLibPool = class(TInterfacedObject,IRsLibPool)
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_Libs : TObjectList;
    //类库内接口列表
    m_Entries : TInterfaceList;
  public
    //加载所有类库
    procedure LoadLibs(XMLConfig : WideString;AppHandle : Cardinal); stdcall;
    //卸载所有类库
    procedure UnloadLibs;stdcall;
    //添加接口
    procedure AddEntry(Entry : IInterface);
    //取出接口池中已有的接口
    function  PullFromPool(IID : TGUID; out Entry : IInterface):  boolean;stdcall;
    //获取指定类型的接口
    function  FindEntry(IID : TGUID; var Entry : IInterface) :  boolean;stdcall;
  end;
  function ReflectPool: IRsLibPool;

implementation

uses
  XMLDoc,XMLIntf,SysUtils,ActiveX;
var
  _LibPool : IRsLibPool;
{ TRsLibPool }
function ReflectPool: IRsLibPool;
begin
  if _LibPool = nil then
  begin
    _LibPool := TRsLibPool.Create;
  end;
  result := _LibPool;
end;
procedure TRsLibPool.AddEntry(Entry: IInterface);
begin
  m_Entries.Add(Entry);
end;

constructor TRsLibPool.Create;
begin
  m_Libs := TObjectList.Create;
    //类库内接口列表
  m_Entries := TInterfaceList.Create;
end;

destructor TRsLibPool.Destroy;
begin
  m_Libs.Free;
    //类库内接口列表
  m_Entries.Free;
  inherited;
end;

function TRsLibPool.FindEntry(IID: TGUID;var Entry : IInterface) : boolean;
var
  i: Integer;
  lib : TRsLibItem;
  Proc: function (IID : TGUID): IInterface;stdcall;
begin
  result := false;

  for i := 0 to m_Libs.Count - 1 do
  begin
    lib := TRsLibItem(m_Libs[i]);
    if TRsLibItem(m_Libs[i]).HLID > 0 then
    begin
      Proc := GetProcAddress(lib.HLID,'ReflectEntry');
      if not Assigned(Proc) then
      begin
        Raise Exception.CreateFmt('加载%s方法失败!',['ReflectEntry']);
      end;
      Entry := Proc(IID);
      if Entry <> nil then
      begin
        Result := true;
        exit;
      end;
    end;
  end;
end;

procedure TRsLibPool.LoadLibs(XMLConfig : WideString;AppHandle : Cardinal);
var
  i : integer;
  xml : IXMLDocument;
  libNode :  IXMLNode;
  lib : TRsLibItem;
  Proc : procedure (EntryPool : IRsLibPool;AppHandle : Cardinal);stdcall;
begin
    xml := NewXMLDocument();
    xml.LoadFromFile(XMLConfig);
    m_Libs.Clear;
    for i := 0 to xml.DocumentElement.ChildNodes.Count - 1 do
    begin
      //读取动态库信息并加载
      libNode := xml.DocumentElement.ChildNodes[i];
      lib := TRsLibItem.Create;
      lib.LibName := libNode.Attributes['LibName'];
      lib.LibPath := ExtractFilePath(XMLConfig) +  libNode.Attributes['LibPath'];
      lib.HLID :=  LoadLibrary(pchar(lib.LibPath));
      if lib.HLID = 0 then
          Raise Exception.CreateFmt('加载%s 失败!',[lib.LibName]);
      m_Libs.Add(lib);

      //调用动态库的初始化接口池方法赋值
      Proc := GetProcAddress(lib.HLID,'InitEntryPool');
      if not Assigned(Proc) then
      begin
        Raise Exception.CreateFmt('加载%s的%s方法失败!',[lib.LibName,'InitEntryPool']);
      end;
      try
        Proc(Self,AppHandle);
      except on e : exception do
        begin
          Raise Exception.CreateFmt('执行%s的%s方法失败:%s',[lib.LibName,'InitEntryPool',e.Message]);        
        end;
      end;
    end;
end;

function TRsLibPool.PullFromPool(IID: TGUID; out Entry: IInterface): boolean;
var
  i: Integer;
begin
  result := false;
  Entry := nil;
  for i := 0 to m_Entries.Count - 1 do
  begin
    if m_Entries[i].QueryInterface(IID,Entry) = 0 then
    begin
      result := true;
      Entry := m_Entries[i];
      exit;    
    end; 
  end;
end;

procedure TRsLibPool.UnloadLibs;
var
  i: Integer;
begin  
  m_Entries.Clear;
  for i := 0 to m_Libs.Count - 1 do
  begin
    if TRsLibItem(m_Libs[i]).HLID > 0 then
    begin
      FreeLibrary(TRsLibItem(m_Libs[i]).HLID);
    end;
  end;
  m_Libs.Clear;
end;


initialization
  _LibPool := nil;
  CoInitialize(nil);
finalization
  CoUninitialize();
end.
