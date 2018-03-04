unit uPubJsPrintCtl;

interface
uses
  Classes,SysUtils,uTrainPlan,uLCWriteCardSectionV2,uSection,uTFSystem,uWriteCardSection;
type
  TPubJsPrintCtl = class
  private

  public
    class procedure Print(chuqinPlan: RRsChuQinPlan);
    class procedure GetQuDuan(PlanGUID: string;out SectionArray: TRsWriteCardSectionArray);
  end;
implementation

uses uLib_PubJsCtl,uGlobal;

{ TPubJsPrintCtl }

class procedure TPubJsPrintCtl.GetQuDuan(PlanGUID: string;out SectionArray: TRsWriteCardSectionArray);
var
  webWriteCard :TRsLCWriteCardSectionV2;
begin
  webWriteCard :=TRsLCWriteCardSectionV2.Create(g_WebAPIUtils);

  try
    webWriteCard.GetPlanSelectedSections(PlanGUID,SectionArray);

  finally
    webWriteCard.Free;
  end;

end;

class procedure TPubJsPrintCtl.Print(chuqinPlan: RRsChuQinPlan);
var
  SectionArray: TRsWriteCardSectionArray;
  PubJsCtl: IPubJsCtl;
  Param: IParam;
  I: Integer;
begin
  PubJsCtl := CoPubJsCtl.DefaultIntf();
  try
    GetQuDuan(chuqinPlan.TrainPlan.strTrainPlanGUID,SectionArray);

    Param := PubJsCtl.Param;



    Param.SetCC(chuqinPlan.TrainPlan.strTrainNo);
    Param.SetJCH(chuqinPlan.TrainPlan.strTrainNumber);
    Param.SetCQTime(chuqinPlan.TrainPlan.dtStartTime);

    with chuqinPlan.ChuQinGroup.Group do
    begin
      if Trainman1.strTrainmanNumber <> '' then
      begin
        Param.AddTM(Trainman1.strTrainmanNumber,Trainman1.strTrainmanName);
      end;

      if Trainman2.strTrainmanNumber <> '' then
      begin
        Param.AddTM(Trainman2.strTrainmanNumber,Trainman2.strTrainmanName);
      end;

    end;


    for I := 0 to Length(SectionArray) - 1 do
    begin

      Param.AddSection(StrToIntDef(SectionArray[i].strJWDNumber,0),
        StrToIntDef(SectionArray[i].strSectionID,0));
    end;


    PubJsCtl.Print();
  finally
    PubJsCtl := nil;
    Param := nil;
    CoPubJsCtl.FreeLib;
  end;
end;

end.
