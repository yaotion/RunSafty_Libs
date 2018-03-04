unit uThreadTask;

interface
uses SysUtils,Classes,uTFSystem,windows,ActiveX,Contnrs ;

Type
  TTask = class;

  //����֪ͨ
  TTaskEvent = procedure(Task:TTask) of object;

  ////////////////////////////////////////
  ///  ����:TTask
  ///  ˵��:ִ��������,���ഴ�������ݸ�TThreadTask��
  ///  Ĭ������ִ����ϻ��Զ�FREE,������ֶ�FREE������ͨ���Զ�Free
  ///  ��������Task��m_bFreeOnTerminate����ΪFalse,
  //   һ������ѭ�������ʱ�򣬶����ֶ�FREE
  ///  ͨ��m_bCycle�����Ƿ���һ��ѭ������Ĭ�ϲ���һ��ѭ������,ִ��һ�ξͽ���
  ////////////////////////////////////////
  TTask = class
  public
    constructor Create();virtual;
    destructor Destroy();override;
  protected
    //����ִ�н������Ƿ��ͷ�
    m_bFreeOnTerminate : Boolean;
    //ִ��task�Ƿ�ɹ�,trueΪ�ɹ�
    m_bDoTaskResult : Boolean;
    //ִ��task�쳣�󣬷��صĴ�����Ϣ
    m_strDoTaskErrorMessage : String;
    //�Ƿ���һ��ѭ������
    m_bCycle : Boolean;
    //ѭ��ִ��Ƶ��
    m_nFrequency : int64;
  private
    //�������
    m_CriticalSection : TRTLCriticalSection;
  public
    //���뻥��
    procedure EnterCritical();
    //�뿪����
    procedure LeaveCritical();
  
  public
    //����ʼ֪ͨ
    OnTaskBeginEvent : TOnEvent;
    //�������֪ͨ
    OnTaskEndEvent : TOnEvent;
  protected
    //ִ������
    procedure DoTask();virtual;
    //����ִ�����
    procedure Done();virtual;
  end;

  ////////////////////////////////////////
  ///  ����:TThreadTask
  ///  ˵��:�����߳�ִ����
  ////////////////////////////////////////
  TThreadTask = class(TThread)
  public
    constructor Create(Task:TTask);overload;
  public
    procedure Execute();override;
  private
    //ִ������
    m_Task : TTask;
  end;

  TThreadTaskList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TThreadTask;
    procedure SetItem(Index: Integer; ThreadTask: TThreadTask);
  public
    function Add(ThreadTask: TThreadTask): Integer;
    property Items[Index: Integer]: TThreadTask read GetItem write SetItem; default;
  end;



implementation

{ TThreadTask }

constructor TThreadTask.Create(Task: TTask);
begin
  inherited Create(False);
  m_Task := Task;
end;

procedure TThreadTask.Execute;
begin
  inherited;
  CoInitialize(nil);
  try
    if Assigned(m_Task.OnTaskBeginEvent) then
      Synchronize(m_Task.OnTaskBeginEvent);
  except on E: Exception do
  end;
  if m_Task.m_bCycle then
  begin
    //�����һ��ѭ��������ô��ѭ��һֱִ��
    while Terminated = false do
    begin
      //�����߳̽��뻥��
      Synchronize(m_Task.EnterCritical);
      try
        m_Task.m_bDoTaskResult := True;
        m_Task.DoTask;
      except
        on E: Exception do
        begin
          m_Task.m_bDoTaskResult := False;
          m_Task.m_strDoTaskErrorMessage := E.Message;
        end;
      end;

      try
        Synchronize(m_Task.Done);
      except on E: Exception do
      end;

      //�����߳��뿪����
      Synchronize(m_Task.LeaveCritical);

      Sleep(m_Task.m_nFrequency);
    end;
  end
  else
  begin
    //�������ѭ������,��ô��ִֻ��һ��
    //�����߳̽��뻥��
    Synchronize(m_Task.EnterCritical);
    try
      m_Task.m_bDoTaskResult := True;
      m_Task.DoTask;
    except
      on E: Exception do
      begin
        m_Task.m_bDoTaskResult := False;
        m_Task.m_strDoTaskErrorMessage := E.Message;
      end;
    end;
    try
      Synchronize(m_Task.Done);
    except on E: Exception do
    end;
    //�����߳��뿪����
    Synchronize(m_Task.LeaveCritical);
  end;


  try
    if Assigned(m_Task.OnTaskEndEvent) then
      Synchronize(m_Task.OnTaskEndEvent);
  except on E: Exception do
  end;
  
  if m_Task.m_bFreeOnTerminate then
    FreeAndNil(m_Task);

  CoUninitialize();    
end;

{ TTask }
constructor TTask.Create;
begin
  m_bFreeOnTerminate := True;
  //Ĭ�ϲ���һ��ѭ������
  m_bCycle := false;
  //Ĭ��ѭ��Ƶ��Ϊ3��
  m_nFrequency := 5000;
  InitializeCriticalSection(m_CriticalSection);
end;

destructor TTask.Destroy;
begin
  DeleteCriticalSection(m_CriticalSection);
  inherited;
end;

procedure TTask.Done;
begin
//
end;
procedure TTask.DoTask;
begin
//
end;

procedure TTask.EnterCritical;
begin
  EnterCriticalSection(m_CriticalSection);
end;

procedure TTask.LeaveCritical;
begin
  LeaveCriticalSection(m_CriticalSection);
end;

{ TThreadTaskList }

function TThreadTaskList.Add(ThreadTask: TThreadTask): Integer;
begin
  Result := inherited Add(ThreadTask);
end;

function TThreadTaskList.GetItem(Index: Integer): TThreadTask;
begin
  Result := TThreadTask(inherited GetItem(Index));
end;

procedure TThreadTaskList.SetItem(Index: Integer; ThreadTask: TThreadTask);
begin
  inherited SetItem(Index,ThreadTask);
end;

end.
