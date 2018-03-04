unit GlobalTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,RsGlobal_TLB,uTFComObject, StdCtrls;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    m_Global: IGlobalProxy;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  m_Global.Site.ID := 'SITEID';
  m_Global.Site.Number := 'SITENUMBER';
  m_Global.Site.Name := 'SITENAME';

  m_Global.User.ID := 'USERID';
  m_Global.User.Number := 'USERNUMBER';
  m_Global.User.Name := 'USERNAME';

  m_Global.WorkShop.Name := 'workshopname';
  m_Global.WorkShop.ID := 'workshopid';

end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Add(m_Global.Site.ID);
  Memo1.Lines.Add(m_Global.Site.Number);
  Memo1.Lines.Add(m_Global.Site.Name);
  Memo1.Lines.Add(m_Global.User.ID);
  Memo1.Lines.Add(m_Global.User.Number);
  Memo1.Lines.Add(m_Global.User.Name);
  Memo1.Lines.Add(m_Global.WorkShop.ID);
  Memo1.Lines.Add(m_Global.WorkShop.Name);
end;

procedure TForm5.Button3Click(Sender: TObject);
begin
  m_Global.WriteIniConfig('sysConfig','val1','value1');
end;

procedure TForm5.Button4Click(Sender: TObject);
begin
  Memo1.Lines.Add(m_Global.ReadIniConfig('sysConfig','val1'));
end;

procedure TForm5.FormCreate(Sender: TObject);
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try

    ifObj.Init(ExtractFilePath(ParamStr(0)) + 'libs\RsGlobal.dll',CLASS_Global,IUnKnown);

    m_Global := (ifObj.DefaultInterface  as IGLObal).GetProxy;

  finally
    ifObj.Free;
  end;
end;

end.
