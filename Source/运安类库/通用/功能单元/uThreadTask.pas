unit uThreadTask;

interface
uses SysUtils,Classes,uTFSystem,windows,ActiveX,Contnrs ;

Type
  TTask = class;

  //任务通知
  TTaskEvent = procedure(Task:TTask) of object;

  ////////////////////////////////////////
  ///  类名:TTask
  ///  说明:执行任务类,该类创建并传递给TThreadTask后，
  ///  默认任务执行完毕会自动FREE,如果想手动FREE，不想通过自动Free
  ///  可以设置Task的m_bFreeOnTerminate属性为False,
  //   一般用作循环任务的时候，都会手动FREE
  ///  通过m_bCycle设置是否是一个循环任务，默认不是一个循环任务,执行一次就结束
  ////////////////////////////////////////
  TTask = class
  public
    constructor Create();virtual;
    destructor Destroy();override;
  protected
    //任务执行结束后是否释放
    m_bFreeOnTerminate : Boolean;
    //执行task是否成功,true为成功
    m_bDoTaskResult : Boolean;
    //执行task异常后，返回的错误信息
    m_strDoTaskErrorMessage : String;
    //是否是一个循环任务
    m_bCycle : Boolean;
    //循环执行频率
    m_nFrequency : int64;
  private
    //互斥对象
    m_CriticalSection : TRTLCriticalSection;
  public
    //进入互斥
    procedure EnterCritical();
    //离开互斥
    procedure LeaveCritical();
  
  public
    //任务开始通知
    OnTaskBeginEvent : TOnEvent;
    //任务结束通知
    OnTaskEndEvent : TOnEvent;
  protected
    //执行任务
    procedure DoTask();virtual;
    //任务执行完毕
    procedure Done();virtual;
  end;

  ////////////////////////////////////////
  ///  类名:TThreadTask
  ///  说明:任务线程执行类
  ////////////////////////////////////////
  TThreadTask = class(TThread)
  public
    constructor Create(Task:TTask);overload;
  public
    procedure Execute();override;
  private
    //执行任务
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
    //如果是一个循环任务，那么就循环一直执行
    while Terminated = false do
    begin
      //用主线程进入互斥
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

      //用主线程离开互斥
      Synchronize(m_Task.LeaveCritical);

      Sleep(m_Task.m_nFrequency);
    end;
  end
  else
  begin
    //如果不是循环任务,那么就只执行一次
    //用主线程进入互斥
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
    //用主线程离开互斥
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
  //默认不是一个循环任务
  m_bCycle := false;
  //默认循环频率为3秒
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
