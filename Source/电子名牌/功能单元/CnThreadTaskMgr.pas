unit CnThreadTaskMgr;
{
改写自cnpack组件 CnThreadTaskMgr
增加相同任务覆盖功能
}

interface


uses
  Windows, SysUtils, Classes;

type
  TTaskStatus = (tsWaiting, tsWorking, tsFinished, tsFailure);

  TTask = class;
  TTaskThread = class;
  TThreadTaskMgr = class;

  TExecuteTaskEvent = procedure (ATask: TTask) of object;

  TTask = class
  protected
    FStartTick: Cardinal;
    FTimeOut: Cardinal;
    FStatus: TTaskStatus;
    FData: Pointer;
    FOnExecute: TExecuteTaskEvent;
  public
    constructor Create;
    destructor Destroy; override;
    property Status: TTaskStatus read FStatus;
    property TimeOut: Cardinal read FTimeOut write FTimeOut;
    property Data: Pointer read FData write FData;
    property OnExecute: TExecuteTaskEvent read FOnExecute write FOnExecute;
  end;

  TTaskThread = class(TThread)
  protected
    FMgr: TThreadTaskMgr;
    FTask: TTask;
    procedure Execute; override;
    procedure DoExecute; virtual;
    function CanTerminate: Boolean; virtual;
  public
    constructor Create(AMgr: TThreadTaskMgr; ATask: TTask); virtual;
    destructor Destroy; override;
    property Task: TTask read FTask;
  end;

  TCnTaskThreadClass = class of TTaskThread;
  
  TThreadTaskMgr = class
  private
    //全部任务，非安全列表，只能在同一个线程使用
    // AddTask、FindTask、Destroy时会使用
    FTasks: TStringList;
    FMaxThreads: Integer;
    FThreads: TThreadList;
    FThreadCount: Integer;
    FThreadMonitor: TThread;
    FWaitTasks: TThreadList;
    FWorkingTasks: TThreadList;
    FFinishTasks: TThreadList;
    procedure SetMaxThreads(const Value: Integer);
    function GetCount: Integer;
    function GetThreadListCount(AList: TThreadList): Integer;
    function GetFinishCount: Integer;
    function GetWaitingCount: Integer;
    function GetWorkingCount: Integer;
  protected
    function GetThreadClass: TCnTaskThreadClass; virtual;
    function FindTask(ATaskId: string): TTask;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTask(ATaskId: string; ATask: TTask);
    property MaxThreads: Integer read FMaxThreads write SetMaxThreads;
    property Count: Integer read GetCount;
    property WaitingCount: Integer read GetWaitingCount;
    property WorkingCount: Integer read GetWorkingCount;
    property FinishCount: Integer read GetFinishCount;
  end;
  
implementation

type
  //结束死线程、创建线程来执行任务
  TMonitorThread = class(TThread)
  protected
    FMgr: TThreadTaskMgr;      
    procedure Execute; override;
  public
    constructor Create(AMgr: TThreadTaskMgr);
    destructor Destroy; override;
  end;

{ TTask }

constructor TTask.Create;
begin
  FStatus := tsWaiting;
  FStartTick := 0;
  FTimeOut := 3 * 60 * 1000;
end;

destructor TTask.Destroy;
begin
  inherited;
end;

{ TTaskThread }

function TTaskThread.CanTerminate: Boolean;
begin
  Result := True;
end;

constructor TTaskThread.Create(AMgr: TThreadTaskMgr; ATask: TTask);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FTask := ATask;
  FMgr := AMgr;
  FMgr.FWaitTasks.Remove(FTask);
  FMgr.FWorkingTasks.Add(FTask);
  FMgr.FThreads.Add(Self);
  if FMgr.FThreadMonitor = nil then
    TMonitorThread.Create(FMgr);
  InterlockedIncrement(FMgr.FThreadCount);
end;

destructor TTaskThread.Destroy;
begin
  if (FTask <> nil) and (FTask.FStatus <> tsFinished) then
    FTask.FStatus := tsFailure;
  if FMgr <> nil then
  begin
    InterlockedDecrement(FMgr.FThreadCount);
    FMgr.FWorkingTasks.Remove(FTask);
    FMgr.FFinishTasks.Add(FTask);
  end;
  inherited;
end;

procedure TTaskThread.DoExecute;
begin
  if Assigned(FTask) and Assigned(FTask.FOnExecute) then
    FTask.FOnExecute(FTask);
end;

procedure TTaskThread.Execute;
begin
  FTask.FStatus := tsWorking;
  FTask.FStartTick := GetTickCount;
  try
    DoExecute;
  except
    ;
  end;
  // 自动退出时进行处理，强制退出时由监视线程处理
  if FMgr <> nil then
    FMgr.FThreads.Remove(Self);
end;

{ TCnMonitorThread }

constructor TMonitorThread.Create(AMgr: TThreadTaskMgr);
begin            
  inherited Create(false);
  FreeOnTerminate := True;  
  FMgr := AMgr;   
  FMgr.FThreadMonitor := Self;
end;

destructor TMonitorThread.Destroy;
begin
  FMgr.FThreadMonitor := nil;
  inherited;
end;

procedure TMonitorThread.Execute;
var
  Threads, Tasks: TList;
  Task: TTask;
  TaskThread: TTaskThread;
  i: integer;
begin
  while not Terminated do
  begin
    Sleep(100);
    Threads := FMgr.FThreads.LockList;
    try
      for i := Threads.Count - 1 downto 0 do
      begin
        TaskThread := TTaskThread(Threads[i]);
        try
          // 超时判断
          if (TaskThread.FTask <> nil) and
            (TaskThread.FTask.FTimeOut <> 0) and
            (TaskThread.FTask.FStartTick <> 0) then
          begin
            if Abs(GetTickCount - TaskThread.FTask.FStartTick) >=
              Integer(TaskThread.FTask.FTimeOut) then
            begin
              if TaskThread.CanTerminate then
              begin
                Windows.TerminateThread(TaskThread.Handle, 0);
                TaskThread.Free;
              end
              else
              begin
                TaskThread.FMgr := nil;
                TaskThread.FTask := nil;
              end;  
              Threads.Remove(TaskThread);
            end;
          end;
        except
          ;
        end;
      end;
    finally
      FMgr.FThreads.UnlockList;
    end;

    if FMgr.FThreadCount < FMgr.FMaxThreads then
    begin
      Task := nil;
      Tasks := FMgr.FWaitTasks.LockList;
      try
        if Tasks.Count > 0 then
        begin
          Task := TTask(Tasks[0]);
        end;
      finally
        FMgr.FWaitTasks.UnlockList;
      end;
      if Task <> nil then
        FMgr.GetThreadClass.Create(FMgr, Task);
    end;
  end;
end;

{ TThreadTaskMgr }

constructor TThreadTaskMgr.Create;
begin
  FTasks := TStringList.Create;
  FTasks.Sorted := True;
  FWaitTasks := TThreadList.Create;
  FWorkingTasks := TThreadList.Create;
  FFinishTasks := TThreadList.Create;
  FThreads := TThreadList.Create;
  FMaxThreads := 10;
end;

destructor TThreadTaskMgr.Destroy;
var
  i: integer;
  Threads: TList;
  TaskThread: TTaskThread;
begin
  if FThreadMonitor <> nil then
  begin                   
    TerminateThread(FThreadMonitor.Handle, 0);
    FThreadMonitor.Free;
  end;

  Threads := FThreads.LockList;
  try
    for i := Threads.Count - 1 downto 0 do
    begin
      TaskThread := TTaskThread(Threads[i]);
      if TaskThread.CanTerminate then
      begin
        TerminateThread(TaskThread.Handle, 0);
        TaskThread.Free;
      end
      else
      begin
        TaskThread.FMgr := nil;
        TaskThread.FTask := nil;
      end;  
    end;
  finally
    FThreads.UnlockList;
  end;
  FThreads.Free;

  for i := FTasks.Count - 1 downto 0 do
    FTasks.Objects[i].Free;
  FTasks.Free;
  
  FWaitTasks.Free;
  FWorkingTasks.Free;
  FFinishTasks.Free;
  inherited;
end;

function TThreadTaskMgr.FindTask(ATaskId: string): TTask;
begin
  if (ATaskId <> '') and (FTasks.IndexOf(ATaskId) >= 0) then
    Result := TTask(FTasks.Objects[FTasks.IndexOf(ATaskId)])
  else
    Result := nil;
end;

function TThreadTaskMgr.GetCount: integer;
begin
  Result := FTasks.Count;
end;

function TThreadTaskMgr.GetThreadClass: TCnTaskThreadClass;
begin
  Result := TTaskThread;
end;

function TThreadTaskMgr.GetThreadListCount(AList: TThreadList): Integer;
var
  lst: TList;
begin
  lst := AList.LockList;
  try
    Result := lst.Count;
  finally
    AList.UnlockList;
  end;
end;

function TThreadTaskMgr.GetFinishCount: Integer;
begin
  Result := GetThreadListCount(FFinishTasks);
end;

function TThreadTaskMgr.GetWaitingCount: Integer;
begin
  Result := GetThreadListCount(FWaitTasks);
end;

function TThreadTaskMgr.GetWorkingCount: Integer;
begin
  Result := GetThreadListCount(FWorkingTasks);
end;

procedure TThreadTaskMgr.AddTask(ATaskId: string; ATask: TTask);
begin
  FTasks.AddObject(ATaskId, ATask);
  case ATask.FStatus of
    tsWaiting, tsWorking:
      begin
        ATask.FStatus := tsWaiting;
        FWaitTasks.Add(ATask);
        if FThreadCount < FMaxThreads then
          GetThreadClass.Create(Self, ATask);
      end;
    tsFinished, tsFailure:
      begin
        FFinishTasks.Add(ATask);
      end;
  end;
end;

procedure TThreadTaskMgr.SetMaxThreads(const Value: Integer);
begin
  if Value > 0 then
  begin
    FMaxThreads := Value;
  end;
end;
                       
end.

