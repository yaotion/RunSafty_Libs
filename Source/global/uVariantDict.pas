unit uVariantDict;

interface
uses
  Classes,SysUtils,Variants;
type
  ROleDictItem = record
    key: string;
    value: OleVariant;
  end;
  POleDictItem = ^ROleDictItem;

  TOleVariantDict = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_lst: TList;
    procedure SetValue(key: string;v: OleVariant);
    function GetValue(key: string): OleVariant;
  public
    function Find(key: string;var v: OleVariant): Boolean;
    function IndexOf(key: string): integer;
    procedure Remove(key: string);
    procedure Delete(index: integer);
    procedure Clear();
    property Values[key: string]: OleVariant read GetValue write SetValue;
  end;

  RDictItem = record
    key: string;
    value: Variant;
  end;

  PDictItem = ^RDictItem;

  TVariantDict = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_lst: TList;
    procedure SetValue(key: string;v: Variant);
    function GetValue(key: string): Variant;
  public
    function Find(key: string;var v: Variant): Boolean;
    function IndexOf(key: string): integer;
    procedure Remove(key: string);
    procedure Delete(index: integer);
    procedure Clear();
    
    function ValueAsString(key: string): string;
    function ValueAsBoolean(key: string): Boolean;
    function ValueAsInt(key: string): integer;
    function ValueAsDateTime(key: string): TDateTime;
    
    property Values[key: string]: Variant read GetValue write SetValue;
  end;

implementation

{ TVariantsDict }

procedure TOleVariantDict.SetValue(key: string; v: OleVariant);
var
  DictItem: POleDictItem;
  index: integer;
begin
  index := IndexOf(key);
  if index > -1 then
  begin
    POleDictItem(m_lst.Items[index]).value := v;
  end
  else
  begin
    New(DictItem);
    DictItem^.Key := Key;
    DictItem^.Value := v;
    m_lst.Add(DictItem);
  end;
end;

procedure TOleVariantDict.Clear;
begin
  while m_lst.Count > 0 do
  begin
    Delete(m_lst.Count - 1);
  end;
end;

constructor TOleVariantDict.Create;
begin
  m_lst := TList.Create; 
end;

procedure TOleVariantDict.Delete(index: integer);
var
  DictItem: POleDictItem;
begin
  if (index > -1) and (index < m_lst.Count) then
  begin
    DictItem := POleDictItem(m_lst.Items[index]);
    
    VarClear(DictItem.value);

    DictItem.key := '';

    Dispose(DictItem);
    
    m_lst.Delete(index);
  end
  else
    raise Exception.Create('索引超出列表长度');

end;

destructor TOleVariantDict.Destroy;
begin
  Clear;
  m_lst.Free;
  inherited;
end;

function TOleVariantDict.Find(key: string; var v: OleVariant): Boolean;
var
  index: integer;
begin
  index := IndexOf(key);
  Result := index > -1;
  if Result then
  begin
    v := POleDictItem(m_lst.Items[index]).value;
  end;
end;

function TOleVariantDict.GetValue(key: string): OleVariant;
var
  index: integer;
begin
  index := IndexOf(key);
  if index > -1 then
  begin
    Result := POleDictItem(m_lst.Items[index]).value;
  end
  else
    Result := null;
end;

function TOleVariantDict.IndexOf(key: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to m_lst.Count - 1 do
  begin
    if POleDictItem(m_lst.Items[i]).key = key then
    begin
      Result := i;
      break;
    end;

  end;
end;

procedure TOleVariantDict.Remove(key: string);
var
  index: integer;
begin
  index := IndexOf(key);
  if index > -1 then
    Delete(index);
end;

{ TVariantDict }

procedure TVariantDict.Clear;
begin
  while m_lst.Count > 0 do
  begin
    Delete(m_lst.Count - 1);
  end;
end;

constructor TVariantDict.Create;
begin
  m_lst := TList.Create; 
end;

procedure TVariantDict.Delete(index: integer);
var
  DictItem: PDictItem;
begin
  if (index > -1) and (index < m_lst.Count) then
  begin
    DictItem := PDictItem(m_lst.Items[index]);
    
    VarClear(DictItem.value);

    DictItem.key := '';

    Dispose(DictItem);
    
    m_lst.Delete(index);
  end
  else
    raise Exception.Create('索引超出列表长度');

end;

destructor TVariantDict.Destroy;
begin
  Clear;
  m_lst.Free;
  inherited;
end;

function TVariantDict.Find(key: string; var v: Variant): Boolean;
var
  index: integer;
begin
  index := IndexOf(key);
  Result := index > -1;
  if Result then
  begin
    v := PDictItem(m_lst.Items[index]).value;
  end;
end;

function TVariantDict.GetValue(key: string): Variant;
var
  index: integer;
begin
  index := IndexOf(key);
  if index > -1 then
  begin
    Result := PDictItem(m_lst.Items[index]).value;
  end
  else
    Result := null;
end;


function TVariantDict.IndexOf(key: string): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to m_lst.Count - 1 do
  begin
    if PDictItem(m_lst.Items[i]).key = key then
    begin
      Result := i;
      break;
    end;

  end;
end;
procedure TVariantDict.Remove(key: string);
var
  index: integer;
begin
  index := IndexOf(key);
  if index > -1 then
    Delete(index);
end;

procedure TVariantDict.SetValue(key: string; v: Variant);
var
  DictItem: PDictItem;
  index: integer;
begin
  index := IndexOf(key);
  if index > -1 then
  begin
    PDictItem(m_lst.Items[index]).value := v;
  end
  else
  begin
    New(DictItem);
    DictItem^.Key := Key;
    DictItem^.Value := v;
    m_lst.Add(DictItem);
  end;
end;

function TVariantDict.ValueAsBoolean(key: string): Boolean;
begin
  if Values[key] <> null then
    Result := Values[key]
  else
    Result := False;
end;

function TVariantDict.ValueAsDateTime(key: string): TDateTime;
begin
  if Values[key] <> null then
    Result := Values[key]
  else
    Result := 0;
end;

function TVariantDict.ValueAsInt(key: string): integer;
begin
  if Values[key] <> null then
    Result := Values[key]
  else
    Result := 0;
end;

function TVariantDict.ValueAsString(key: string): string;
begin
  Result := VarToStrDef(Values[key],'');
end;

end.
