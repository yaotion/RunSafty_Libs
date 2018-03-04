unit uRsAlcoholLib;

interface
uses
  uRsLibUtils,classes,sysutils,windows,Forms,uRsLibClass;
type
  //测酒窗口位置
  TPositionOp = (ptNormal,ptRightBottom);
  IAlcoholOption = interface
  ['{C3E17D15-A04C-4C5E-9E28-D20CF693DC52}']
    function GetPosition : Integer;stdcall;
    procedure SetPosition(Value : Integer);stdcall;
    function GetLocalSound : Boolean;stdcall;
    procedure SetLocalSound(Value : Boolean);stdcall;
    function GetAppHandle : Cardinal;stdcall;
    procedure SetAppHandle(Value : Cardinal);stdcall;

    //测酒窗口位置
    property Position: Integer read GetPosition write SetPosition;
    //是否使用软件播放语音
    property LocalSound: Boolean read GetLocalSound write SetLocalSound;
    //应用程序句柄
    property AppHandle : Cardinal read GetAppHandle write SetAppHandle;
  end;
  IAlcoholUI = interface
    ['{37334F70-C2EC-4B13-AE37-1213F0F9FAFF}']
    function GetTrainmanNumber : WideString;stdcall;
    procedure SetTrainmanNumber(Value : WideString);stdcall;
    function GetTrainmanName : WideString;stdcall;
    procedure SetTrainmanName(Value : WideString);stdcall;
    function GetTrainNo : WideString;stdcall;
    procedure SetTrainNo(Value : WideString);stdcall;
    function GetTrainTypeName : WideString;stdcall;
    procedure SetTrainTypeName(Value : WideString);stdcall;
    function GetTrainNumber : WideString;stdcall;
    procedure SetTrainNumber(Value : WideString);stdcall;
    function GetTestTime : TDateTime;stdcall;
    procedure SetTestTime(Value : TDateTime);stdcall;
    function GetPicture : OleVariant;stdcall;
    procedure SetPicture(Value : OleVariant);stdcall;

     //工号
    property TrainmanNumber: WideString read GetTrainmanNumber write SetTrainmanNumber;
    //姓名
    property TrainmanName: WideString read GetTrainmanName write SetTrainmanName;
    //车次
    property TrainNo: WideString read GetTrainNo write SetTrainNo;
    //车型
    property TrainTypeName: WideString read GetTrainTypeName write SetTrainTypeName;
    //车号
    property TrainNumber: WideString read GetTrainNumber write SetTrainNumber;
    //测试时间
    property TestTime: TDateTime read GetTestTime write SetTestTime;
    //标准照片
    property Picture: OleVariant read GetPicture write SetPicture;
  end;
  IAlcoholResult = interface
    ['{7AE04A50-EB94-433D-A1F1-4E9215FD4A0E}']
    function GetTestResult : integer;stdcall;
    procedure SetTestResult(Value : integer);stdcall;
    function GetAlcoholity : integer;stdcall;
    procedure SetAlcoholity(Value : integer);stdcall;
    function GetTestTime : TDateTime;stdcall;
    procedure SetTestTime(Value : TDateTime);stdcall;
    function GetPicture : OleVariant;stdcall;
    procedure SetPicture(Value : OleVariant);stdcall;

    //测酒结果
    property TestResult: integer read GetTestResult write SetTestResult;
    //酒精含量
    property Alcoholity: integer read GetAlcoholity write SetAlcoholity;
    //测试时间
    property TestTime: TDateTime read GetTestTime write SetTestTime;
    //测酒照片
    property Picture: OleVariant read GetPicture write SetPicture;
  end;
  
  IAlcoholCtl = interface
  ['{3F26D9E4-2EF5-41C2-A79B-669137EC18B3}']
    procedure Test;
    function GetOption : IAlcoholOption;
    function GetUI : IAlcoholUI;
    function GetTestResult : IAlcoholResult;
    property Option : IAlcoholOption read GetOption;
    property UI : IAlcoholUI read GetUI;
    property TestResult : IAlcoholResult read GetTestResult;
  end;



implementation


end.
