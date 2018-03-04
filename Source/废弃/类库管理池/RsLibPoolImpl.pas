unit RsLibPoolImpl;

interface
uses
  Classes,Contnrs,Windows,Forms,uRsLibPoolLib,uRsLibUtils;
type
  TRsLibItem = class
    //���ID
    HLID : Cardinal;
    //�������
    LibName : string;
    //���·��
    LibPath : string;
  end;
  
  TRsLibPool = class(TInterfacedObject,IRsLibPool)
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_Libs : TObjectList;
    //����ڽӿ��б�
    m_Entries : TInterfaceList;
  public
    //�����������
    procedure LoadLibs(XMLConfig : WideString;AppHandle : Cardinal); stdcall;
    //ж���������
    procedure UnloadLibs;stdcall;
    //��ӽӿ�
    procedure AddEntry(Entry : IInterface);
    //ȡ���ӿڳ������еĽӿ�
    function  PullFromPool(IID : TGUID; out Entry : IInterface):  boolean;stdcall;
    //��ȡָ�����͵Ľӿ�
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
    //����ڽӿ��б�
  m_Entries := TInterfaceList.Create;
end;

destructor TRsLibPool.Destroy;
begin
  m_Libs.Free;
    //����ڽӿ��б�
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
        Raise Exception.CreateFmt('����%s����ʧ��!',['ReflectEntry']);
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
      //��ȡ��̬����Ϣ������
      libNode := xml.DocumentElement.ChildNodes[i];
      lib := TRsLibItem.Create;
      lib.LibName := libNode.Attributes['LibName'];
      lib.LibPath := ExtractFilePath(XMLConfig) +  libNode.Attributes['LibPath'];
      lib.HLID :=  LoadLibrary(pchar(lib.LibPath));
      if lib.HLID = 0 then
          Raise Exception.CreateFmt('����%s ʧ��!',[lib.LibName]);
      m_Libs.Add(lib);

      //���ö�̬��ĳ�ʼ���ӿڳط�����ֵ
      Proc := GetProcAddress(lib.HLID,'InitEntryPool');
      if not Assigned(Proc) then
      begin
        Raise Exception.CreateFmt('����%s��%s����ʧ��!',[lib.LibName,'InitEntryPool']);
      end;
      try
        Proc(Self,AppHandle);
      except on e : exception do
        begin
          Raise Exception.CreateFmt('ִ��%s��%s����ʧ��:%s',[lib.LibName,'InitEntryPool',e.Message]);        
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
