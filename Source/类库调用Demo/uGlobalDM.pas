unit uGlobalDM;

interface

uses
  SysUtils,classes,
  uRsLogObject,
  uRsFingerObject,
  uRsCameraObject,
  uRsAlcoholObject,
  uTFComObject;

const
  DEF_DLL_PATH:string    = 'libs' ;
  DEF_LOG_LIB:string     = 'RsLogLib.dll' ;
  DEF_FINGER_LIB:string  = 'RsFingerLib.dll' ;
  DEF_CAMERA_LIB:string  = 'RsCameraLib.dll' ;
  DEF_ALCOHOL_LIB:string = 'RsAlcoholLib.dll' ;
type
  TGlobalDM = class(TDataModule)
  public
      {功能：加载DLL}
    function LoadLibs():boolean;
    {功能：释放}
    procedure FreeLibs();
  private
    //日志
    m_LogObject       : TRsLogObject;
    m_LogConfigObject : TRsLogConfigObject;
    //指纹
    m_FingerObject    : TRsFingerObject;
    //摄像头
    m_CameraObject    : TRsCameraObject;
    //测酒
    m_AlcoholObject   : TRsAlcoholObject ;
  public
     property Log       :  TRsLogObject         read m_LogObject          write   m_LogObject;
     property LogConfig :  TRsLogConfigObject   read m_LogConfigObject    write   m_LogConfigObject;
     property Finger    :  TRsFingerObject      read m_FingerObject       write   m_FingerObject;
     property Camera    :  TRsCameraObject      read m_CameraObject       write   m_CameraObject;
     property Alcohol   :  TRsAlcoholObject     read m_AlcoholObject      write   m_AlcoholObject;
  end;

var
  GlobalDM: TGlobalDM;

implementation
{$R *.dfm}

{ TGlobalDM }



{ TGlobalDM }

procedure TGlobalDM.FreeLibs;
begin

end;

function TGlobalDM.LoadLibs: boolean;
begin
  result:= false;
end;

end.

