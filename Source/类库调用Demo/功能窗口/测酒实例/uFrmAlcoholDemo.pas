unit uFrmAlcoholDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls,uTFVariantUtils, jpeg,uRsCameraObject,uRsAlcoholObject;

type
  TfrmAlcoholDemo = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    btnStartTest: TButton;
    btnClose: TButton;
    edtTrainmanName: TEdit;
    edtTrainmanNumber: TEdit;
    edtTrainNo: TEdit;
    edtTrainTypeName: TEdit;
    edtTrainNumber: TEdit;
    checkLocalSound: TCheckBox;
    RzPanel1: TRzPanel;
    ImgPicture: TImage;
    RzPanel2: TRzPanel;
    imgTestPicture: TImage;
    edtTestTime: TEdit;
    edtTestResult: TEdit;
    edtAlcoholity: TEdit;
    checkRightBottomShow: TCheckBox;
    rbPC: TRadioButton;
    rbZiZhu: TRadioButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnStartTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Class procedure Show; 
  end;



implementation
uses
  uGlobalDM,RsAlcoholLib_TLB,RsCameraLib_TLB;
var
  frmAlcoholDemo: TfrmAlcoholDemo;
{$R *.dfm}

{ TfrmAlcoholDemo }

procedure TfrmAlcoholDemo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlcoholDemo.btnStartTestClick(Sender: TObject);
var
  AlcoholCtl: IAlcoholCtl ;
  ms : TMemoryStream;
  jpeg : TBitmap;
begin
  AlcoholCtl := GlobalDM.Alcohol.DefaultInterface as IAlcoholCtl ;
  try
    if rbPC.Checked then
      AlcoholCtl.Mode := amPC
    else
      AlcoholCtl.Mode := amZizHU ;

    AlcoholCtl.Option.Position :=ptNormal;
    if checkRightBottomShow.Checked then
      AlcoholCtl.Option.Position :=ptRightBottom;

    AlcoholCtl.Option.LocalSound := checkLocalSound.Checked;
    AlcoholCtl.Option.AppHandle := Application.Handle;
    AlcoholCtl.UI.TrainmanNumber := edtTrainmanNumber.Text;
    AlcoholCtl.UI.TrainmanName := edtTrainmanName.Text;
    AlcoholCtl.UI.TrainNo := edtTrainNo.Text;
    AlcoholCtl.UI.TrainTypeName := edtTrainTypeName.Text;
    AlcoholCtl.UI.TrainNumber := edtTrainNumber.Text;
    AlcoholCtl.UI.TestTime := Now;
    ms := TMemoryStream.Create;
    try
      ImgPicture.Picture.Graphic.SaveToStream(ms);
      ms.Position := 0;
      AlcoholCtl.UI.Picture := TTFVariantUtils.StreamToTemplateOleVariant(ms);
    finally
      ms.Free;
    end;
    (GlobalDM.Alcohol.DefaultInterface as IAlcoholCtl).StartTest;

    edtTestTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',AlcoholCtl.TestResult.TestTime);
    edtTestResult.Text := Format('%d',[AlcoholCtl.TestResult.TestResult]);
    edtAlcoholity.Text := Format('%d',[AlcoholCtl.TestResult.Alcoholity]);
    if ( AlcoholCtl.TestResult.TestResult in [0,1,2] )then
    begin
      ms := TMemoryStream.Create;
      try
        TTFVariantUtils.TemplateOleVariantToStream(AlcoholCtl.TestResult.Picture,ms);
        jpeg := TBitmap.Create;
        try
          ms.Position := 0;
          jpeg.LoadFromStream(ms);
          imgTestPicture.Picture.Bitmap := jpeg;
        finally
          jpeg.Free;
        end;
      finally
        ms.Free;
      end;
    end;
  except

  end;

end;

procedure TfrmAlcoholDemo.FormCreate(Sender: TObject);
var
  Alcohol:IAlcoholCtl;
begin

  GlobalDM.Camera := TRsCameraObject.Create ;

  GlobalDM.Camera.Init(ExtractFilePath(Application.ExeName) + 'libs\RsCameraLib.dll',
    CLASS_Camera,IUnKnown);
  (GlobalDM.Camera.DefaultInterface as ICamera ).Refresh ;



  GlobalDM.Alcohol := TRsAlcoholObject.Create;
  GlobalDM.Alcohol.Init(ExtractFilePath(Application.ExeName) + 'libs\RsAlcoholLib.dll',CLASS_AlcoholCtl,IUnKnown);
  Alcohol := (GlobalDM.Alcohol.DefaultInterface)  as IAlcoholCtl;
  Alcohol.Camera :=  GlobalDM.Camera.DefaultInterface ;

end;

procedure TfrmAlcoholDemo.FormDestroy(Sender: TObject);
begin
  GlobalDM.Camera.Free ;
  GlobalDM.Alcohol.Free;
end;

class procedure TfrmAlcoholDemo.Show;
begin
  frmAlcoholDemo:= TfrmAlcoholDemo.Create(nil);
  try
    frmAlcoholDemo.ShowModal;
  finally
    frmAlcoholDemo.Free;
  end;
end;

end.
