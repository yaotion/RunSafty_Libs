unit uRsThreadTask;

interface
uses
  Classes,SysUtils,SyncObjs,windows,Forms,ActiveX;
type
//******************************************************************************
// 每一个TTaskThreadHost是一个线程，在添加任务时哪果AutoReplace为True，则
//会替换掉等待队列中相同ID的任务
//******************************************************************************
  TTask = class;
  TTaskThread = class;
  TExecuteTaskEvent = procedure (ATask: TTask;Thread: TTaskThread) of object;
  
  TTask = class
  protected
    m_TaskID: string;
    m_Data: Pointer;
    m_OnExecute: TExecuteTaskEvent;
  public
    property TaskID: string read m_TaskID write m_TaskID;
    property Data: Pointer read m_Data write m_Data;
    property OnExecute: TExecuteTaskEvent read m_OnExecute write m_OnExecute;
  end;


  TTaskThreadHost = class;

  TTaskThread = class(TThread)
  public
    constructor Create;
    destructor Destroy;override;
  protected
    m_Active: Boolean;
    m_SimpleEvent: TSimpleEvent;
    m_TaskThreadHost: TTaskThreadHost;
    m_WorkingTask: TTask;
    procedure Execute; override;
  end;
  
  TTaskThreadHost = class
  public
    constructor Create;
    destructor Destroy;override;
  protected
    m_TaskThread: TTaskThread;
    m_WaitTasks: TThreadList;
    m_AutoReplace: Boolean;
    function GetWaritCount: integer;
  public
    procedure Start();
    procedure Stop();
    procedure ClearTask();
    procedure AddTask(ATask: TTask);
  public
    property AutoReplace: Boolean read m_AutoReplace write m_AutoReplace;
  end;


  TCircleThreadHost = class(TThread)
  public
    constructor Create(Fun: TNotifyEvent);
    destructor Destroy;override;
  private
    m_Fun: TNotifyEvent;
    m_SimpleEvent: TSimpleEvent;
  protected
    procedure Execute; override;
  public
    procedure Delay(ms: Cardinal);
    property Terminated;
  end;
implementation


{ TTaskThread }

procedure TTaskThreadHost.AddTask(ATask: TTask);
var
  lst: TList;
  procedure RemoveTask(ID: string);
  var
    i: integer;
  begin
    i := 0;
    while i < lst.Count - 1 do
    begin
      if TTask(lst[i]).TaskID = ID then
      begin
        TTask(lst[i]).Free;
        lst.Delete(i);
      end
      else
        Inc(i);
    end;
  end;
begin
  lst := m_WaitTasks.LockList;
  if m_AutoReplace and (ATask.TaskID <> '') then
  begin
    RemoveTask(ATask.TaskID);
  end;
  
  lst.Add(ATask);
  m_WaitTasks.UnlockList;

  m_TaskThread.m_SimpleEvent.SetEvent;
end;


procedure TTaskThreadHost.ClearTask;
var
  lst: TList;
begin
  lst := m_WaitTasks.LockList;

  while lst.Count > 0 do
  begin
    TTask(lst[0]).Free;
    lst.Delete(0);
  end;
  
  m_WaitTasks.UnlockList;
end;
constructor TTaskThreadHost.Create;
begin
  m_WaitTasks := TThreadList.Create;
  m_TaskThread := TTaskThread.Create;
  m_TaskThread.m_TaskThreadHost := self;
  m_TaskThread.Resume;
end;

destructor TTaskThreadHost.Destroy;
begin
  ClearTask();
  m_TaskThread.Free;
  m_WaitTasks.Free;
  inherited;
end;

function TTaskThreadHost.GetWaritCount: integer;
begin
  Result := m_WaitTasks.LockList.Count;
  m_WaitTasks.UnlockList;
end;

procedure TTaskThreadHost.Start;
begin
  m_TaskThread.m_Active := True;

  if GetWaritCount > 0 then
    m_TaskThread.m_SimpleEvent.SetEvent;
end;

procedure TTaskThreadHost.Stop;
begin
  m_TaskThread.m_Active := False;
end;

{ TTaskThread }

constructor TTaskThread.Create;
begin
  inherited Create(True);
  m_SimpleEvent := TSimpleEvent.Create(nil,True,False,'');
end;

destructor TTaskThread.Destroy;
begin
  m_SimpleEvent.SetEvent;
  inherited;
  m_SimpleEvent.Free;
end;

procedure TTaskThread.Execute;
begin
  CoInitialize(nil);
  try
    while not Self.Terminated do
    begin
      m_SimpleEvent.WaitFor(INFINITE);
      if Self.Terminated then Exit;
    
      if m_Active then
      begin
        while not Self.Terminated do
        begin
          with m_TaskThreadHost.m_WaitTasks.LockList do
          begin
            if Count > 0 then
            begin
              m_WorkingTask := TTask(Items[0]);
              Delete(0);
            end
            else
              m_WorkingTask := nil;
          end;
        
          m_TaskThreadHost.m_WaitTasks.UnlockList;

          if Assigned(m_WorkingTask) then
          begin
            if Assigned(m_WorkingTask.m_OnExecute) then
            begin
              try
                m_WorkingTask.OnExecute(m_WorkingTask,self);
              except
                on E: Exception do
                begin
                end;
              end;

              FreeAndNil(m_WorkingTask);
            end;
          end
          else
            break;

        end;

      end;
      

    end;
  finally
    CoUninitialize;
  end;

end;


{ TCircleThreadHost }

constructor TCircleThreadHost.Create(Fun: TNotifyEvent);
begin
  inherited Create(True);
  m_Fun := Fun;
  FreeOnTerminate := False;
  m_SimpleEvent := TSimpleEvent.Create(nil,True,False,'');
end;

procedure TCircleThreadHost.Delay(ms: Cardinal);
begin
  m_SimpleEvent.WaitFor(ms);
end;

destructor TCircleThreadHost.Destroy;
begin
  m_SimpleEvent.SetEvent();
  inherited;
  m_SimpleEvent.Free;
end;

procedure TCircleThreadHost.Execute;
begin
  CoInitialize(nil);
  try
    if Assigned(m_Fun) then
      m_Fun(Self);
  except
  end;
  CoUninitialize;

end;

end.
