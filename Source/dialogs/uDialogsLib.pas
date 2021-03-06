unit uDialogsLib;

interface
uses
  Classes,Forms,Windows;
const
  _LIBNAME = 'RsDialogs.dll';
type
  //无焦点对话框，最多支持三条消息，各条消息分行显示
  //ShowTime为自动关闭时间，如为0则不自动关闭
  TNoFocusBox = class
  public
    class procedure ShowBox(Msg : string; ShowTime : Cardinal = 2000);overload;

    class procedure ShowBox(Msg1,Msg2 : string; ShowTime : Cardinal = 2000);overload;

    class procedure ShowBox(Msg1,Msg2,Msg3 : string; ShowTime : Cardinal = 2000);overload;
  end;

  //进度对话框，非SHOWMADAL显示
  TNoFocusProgress = class
  public
    constructor Create();
    destructor Destroy;override;
  private
    FForm: Pointer;
  public
    //进度条步进
    //PartsComplete:当前已完成进度
    //TotalParts:总进度
    //Msg:进度附加的提示信息，如没有，则传入空字符串
    procedure Step(PartsComplete,TotalParts: integer;Msg: string);
    procedure Close();
  end;

  //无焦点提示框
  TNoFocusHint = class
  public
    constructor Create();
    destructor Destroy;override;
  private
    FForm: Pointer;
  public
    //弹出无焦点提示框，提示 Msg指定的信息，重新调用则刷新显示信息
    //用完后需要调用 CLOSE关闭显示窗
    procedure Hint(Msg: string);
    procedure Close();
  end;

  //系统对话框封装
  TMessageBox = class
  public
    //信息提示框
    class procedure Box(msg: string);
    //警告提示框
    class procedure Warn(msg: string);
    //错误提示框
    class procedure Err(msg: string);
    //询问提示框
    class function Question(msg: string): Boolean;    
  end;

	function InputDateTime(var value: TDateTime): Boolean;stdcall;external _LIBNAME;
	
implementation
  procedure NoFocusBoxMsg(Msg : array of PAnsiChar; ShowTime : Cardinal);stdcall;external _LIBNAME;

  
  function NoFocusProgress_Create(): Pointer;stdcall;external _LIBNAME;
  procedure NoFocusProgress_Step(Form: Pointer;PartsComplete,TotalParts: integer;Msg: PAnsiChar);stdcall;external _LIBNAME;
  procedure NoFocusProgress_Close(Form: Pointer);stdcall;external _LIBNAME;
  procedure NoFocusProgress_Free(Form: Pointer);stdcall;external _LIBNAME;

  function NoFocusHint_Create(): Pointer;stdcall;external _LIBNAME;
  procedure NoFocusHint_Hint(Form: Pointer;Msg: PAnsiChar);stdcall;external _LIBNAME;
  procedure NoFocusHint_Close(Form: Pointer);stdcall;external _LIBNAME;
  procedure NoFocusHint_Free(Form: Pointer);stdcall;external _LIBNAME;


{ TNoFocusBox }

class procedure TNoFocusBox.ShowBox(Msg: string; ShowTime: Cardinal);
begin
  NoFocusBoxMsg([PAnsiChar(Msg)],ShowTime);
end;

class procedure TNoFocusBox.ShowBox(Msg1, Msg2: string; ShowTime: Cardinal);
begin
  NoFocusBoxMsg([PAnsiChar(Msg1),PAnsiChar(Msg2)],ShowTime);
end;

class procedure TNoFocusBox.ShowBox(Msg1, Msg2, Msg3: string;
  ShowTime: Cardinal);
begin
  NoFocusBoxMsg([PAnsiChar(Msg1),PAnsiChar(Msg2),PAnsiChar(Msg3)],ShowTime);
end;

procedure InitApp(Handle: THandle);external _LIBNAME;
{ TNoFocusProgress }

procedure TNoFocusProgress.Close;
begin
  NoFocusProgress_Close(FForm);
end;

constructor TNoFocusProgress.Create;
begin
  FForm := NoFocusProgress_Create();
end;

destructor TNoFocusProgress.Destroy;
begin
  NoFocusProgress_Free(FForm);
  inherited;
end;

procedure TNoFocusProgress.Step(PartsComplete, TotalParts: integer;
  Msg: string);
begin
  NoFocusProgress_Step(FForm,PartsComplete, TotalParts,PAnsiChar(Msg));
end;

{ TNoFocusHint }

procedure TNoFocusHint.Close;
begin
  NoFocusHint_Close(FForm);
end;

constructor TNoFocusHint.Create;
begin
  FForm := NoFocusHint_Create;
end;

destructor TNoFocusHint.Destroy;
begin
  NoFocusHint_Free(FForm);
  inherited;
end;

procedure TNoFocusHint.Hint(Msg: string);
begin
  NoFocusHint_Hint(FForm,PAnsiChar(Msg));
end;

{ TDialogs }

class procedure TMessageBox.Box(msg: string);
begin
  Application.MessageBox(PChar(msg), PChar('提示'), MB_ICONINFORMATION + MB_OK);
end;

class procedure TMessageBox.Err(msg: string);
begin
  Application.MessageBox(PChar(msg),PChar('错误'), MB_ICONSTOP + MB_OK);
end;

class function TMessageBox.Question(msg: string): Boolean;
begin
  Result := Application.MessageBox(PChar(msg), PChar('提示'),
    MB_ICONQUESTION + MB_OKCANCEL) = IDOK;
end;

class procedure TMessageBox.Warn(msg: string);
begin
    Application.MessageBox(PChar(msg), PChar('警告'), MB_ICONWARNING + MB_OK);
end;

initialization
  if not IsLibrary then
    InitApp(Application.Handle);
finalization
  if not IsLibrary then
    InitApp(0);
end.
