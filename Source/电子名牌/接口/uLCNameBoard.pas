unit uLCNameBoard;

interface

uses
  SysUtils,Classes,uTrainman,superobject,uBaseWebInterface,uSaftyEnum,uTrainmanJiaolu,
  uLLCommonFun;

type
  TRsLCNameBoard = class(TBaseWebInterface)
  public
    //��ȡԤ����Ա��Ϣ
    //TF.Runsafty.NamePlate.NameGroup.GetPreparedTrainmans
    function GetPrepareTrainman(WorkShopGUID : string ;out TrainmanArray : TRsTrainmanArray;out ErrStr:string):Boolean;
    //��ȡ����ת��Ա��Ϣ
    //TF.Runsafty.NamePlate.NameGroup.GetUnRunTrainmans
    function GetUnRunTrainmans(WorkShopGUID : string ;out TrainmanArray : TRsTrainmanLeaveArray;out ErrStr:string):Boolean;
    //����任���ڵ�
    //TF.Runsafty.NamePlate.NameGroup.ChangeDutyPlace
    function  ChangeGroupPlace(GroupGUID,SrcPlaceID,DstPlaceID:string;out ErrStr:string):Boolean;
    //��ȡָ�����ε�ָ�����ڵ��µ�
    //TF.Runsafty.NamePlate.NameGroup.GetNormalGroup
    function GetNormalGroup(TrainmanjiaoluID:string;PlaceID,trainmanID:string;out GroupArray:TRsGroupArray;out ErrStr:string):Boolean;
    //��ȡָ�����ε�ָ�����ڵ��µ��ֳ˻����б�
    //TF.Runsafty.NamePlate.OrderGroup.GetOrderGroup
    function GetOrderGroup(TrainmanjiaoluID:string;PlaceID:string;TrainmanID:string;out OrderGroupArray:TRsOrderGroupArray;out ErrStr:string):Boolean;
    //��ȡ �ͻ������б�
    //TF.Runsafty.NamePlate.NameGroup.GetNamedJiaoluGroups
    function GetNamedGroup(TrainmanjiaoluID:string;out NamedGroupArray : TRsNamedGroupArray;out ErrStr:string):Boolean;
    //��ȡ  ����ʽ�����б�
    //TF.Runsafty.NamePlate.NameGroup.GetTogetherTrains
    function GetTogetherGroup(TrainmanjiaoluID:string;out TogetherTrainArray : TRsTogetherTrainArray;out ErrStr:string):Boolean;

    //ɾ��һ����Ա��·�Ļ���
    //TF.Runsafty.NameGroup.DeleteNamedGroupByJiaoLu
    function DeleteNamedGroupByJiaoLu(TrainmanjiaoluID:string;out ErrStr:string):Boolean;
  private
    //json -> ordergroup
    procedure JsonToOrderGroup(var OrderGroup:RRsOrderGroup;Json: ISuperObject);
    //json->namedgroup
    procedure JsonToNamedGroup(var NamedGroup:RRsNamedGroup;Json: ISuperObject);
    //json->togetherGroup
    procedure JsonToTogetherTrain(var TogetherTrain:RRsTogetherTrain;Json: ISuperObject);
    // JSON->trainman
    procedure JsonToTrainman(var Trainman: RRsTrainman;  Json: ISuperObject);
    //json->����ת��Ա
    procedure JsonToLeaveTrainman(var TrainmanLeaveInfo: RRsTrainmanLeaveInfo;Json: ISuperObject);
  end;


implementation

{ TRsLCNameBoard }

function TRsLCNameBoard.ChangeGroupPlace(GroupGUID, SrcPlaceID,
  DstPlaceID: string; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson ;
  json.S['groupID'] := GroupGUID ;
  json.S['sourcePlaceID'] := SrcPlaceID ;
  json.S['destPlaceID'] := DstPlaceID ;
  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.ChangeDutyPlace',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCNameBoard.DeleteNamedGroupByJiaoLu(TrainmanjiaoluID: string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['TrainmanjiaoluID'] := TrainmanjiaoluID ;
  try
    strResult := Post('TF.Runsafty.NameGroup.DeleteNamedGroupByJiaoLu',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCNameBoard.GetNamedGroup(TrainmanjiaoluID: string;
  out NamedGroupArray: TRsNamedGroupArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strTrainmanJiaoluGUID'] := TrainmanjiaoluID;
  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetNamedJiaoluGroups',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(NamedGroupArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToNamedGroup(NamedGroupArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCNameBoard.GetNormalGroup(TrainmanjiaoluID, PlaceID,
  trainmanID: string; out GroupArray: TRsGroupArray;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['placeID'] := PlaceID ;
  json.S['trainmanjiaoluID'] := TrainmanjiaoluID;
  json.S['trainmanID'] := TrainmanID ;
  try

    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetNormalGroup',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(GroupArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToGroup(GroupArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCNameBoard.GetOrderGroup(TrainmanjiaoluID, PlaceID,
  TrainmanID: string; out OrderGroupArray: TRsOrderGroupArray;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['placeID'] := PlaceID ;
  json.S['trainmanjiaoluID'] := TrainmanjiaoluID;
  json.S['trainmanID'] := TrainmanID ;

  try
    strResult := Post('TF.Runsafty.NamePlate.OrderGroup.GetOrderGroup',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(OrderGroupArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToOrderGroup(OrderGroupArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCNameBoard.GetPrepareTrainman(WorkShopGUID: string;
  out TrainmanArray: TRsTrainmanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strWorkShopGUID'] := WorkShopGUID ;

  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetPreparedTrainmans',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainman(TrainmanArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


function TRsLCNameBoard.GetTogetherGroup(TrainmanjiaoluID: string;
  out TogetherTrainArray: TRsTogetherTrainArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strTrainmanJiaoluGUID'] := TrainmanjiaoluID;
  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetTogetherTrains',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TogetherTrainArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTogetherTrain(TogetherTrainArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCNameBoard.GetUnRunTrainmans(WorkShopGUID: string;
  out TrainmanArray: TRsTrainmanLeaveArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strWorkShopGUID'] := WorkShopGUID ;

  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetUnRunTrainmans',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToLeaveTrainman(TrainmanArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

procedure TRsLCNameBoard.JsonToLeaveTrainman(
  var TrainmanLeaveInfo: RRsTrainmanLeaveInfo; Json: ISuperObject);
begin
  with TrainmanLeaveInfo do
  begin
    JsonToTrainman(Trainman,Json);
    strLeaveTypeGUID := Json.S['strLeaveTypeGUID'];
    strLeaveTypeName := Json.S['strLeaveTypeName'];
  end;
end;

procedure TRsLCNameBoard.JsonToNamedGroup(var NamedGroup: RRsNamedGroup;
  Json: ISuperObject);
begin
  with NamedGroup do
  begin
      strCheciGUID := json.S['strCheciGUID'];
      strTrainmanJiaoluGUID := json.S['strTrainmanJiaoluGUID'];
      nCheciOrder := json.I['nCheciOrder'];
      nCheciType := TRsCheciType(json.I['nCheciType']);
      strCheci1 := json.S['strCheci1'];
      strCheci2 := json.S['strCheci2'];
      if Json.S['dtLastArriveTime'] <> '' then
        dtLastArriveTime := StrToDateTime( Json.S['dtLastArriveTime'] );
      JsonToGroup(Group,Json.O['Group']);
  end;
end;

procedure TRsLCNameBoard.JsonToOrderGroup(var OrderGroup: RRsOrderGroup;
  Json: ISuperObject);
begin
  with OrderGroup do
  begin
    strOrderGUID := Json.s['orderID'];
    //������·GUID
    strTrainmanJiaoluGUID := Json.s['trainmanjiaoluID'];
    //���
    nOrder :=  StrToInt( Json.s['order'] );
    //�������ʱ��
    if Json.S['lastArriveTime'] <> '' then
      dtLastArriveTime := StrToDateTime( Json.S['lastArriveTime'] );

    JsonToGroup(Group,Json.O['group']);
  end;
end;



procedure TRsLCNameBoard.JsonToTogetherTrain(
  var TogetherTrain: RRsTogetherTrain; Json: ISuperObject);
var
  jsonOrderGroupInTrainArray:TSuperArray ;
  jsonGroup:ISuperObject ;
  i : Integer ;
begin
  with TogetherTrain do
  begin
    //���˻���GUID
    strTrainGUID := Json.S['strTrainGUID'];
    //������·GUID
    strTrainmanJiaoluGUID := Json.S['strTrainmanJiaoluGUID'];
    //��������
    strTrainTypeName := Json.S['strTrainTypeName'];
    //������
    strTrainNumber := Json.S['strTrainNumber'];

    jsonOrderGroupInTrainArray := json.O['Groups'].AsArray;

    SetLength(Groups,jsonOrderGroupInTrainArray.Length);
    for I := 0 to jsonOrderGroupInTrainArray.Length - 1 do
    begin
      with Groups[i] do
      begin
        //����GUID
        strOrderGUID := jsonOrderGroupInTrainArray[i].S['strOrderGUID'];
        //��������GUID
        strTrainGUID := jsonOrderGroupInTrainArray[i].S['strTrainGUID'];
        //���
        nOrder := jsonOrderGroupInTrainArray[i].I['nOrder'];
        //���һ�ε���ʱ��
        if jsonOrderGroupInTrainArray[i].S['dtLastArriveTime'] <> '' then
          dtLastArriveTime := StrToDateTime( jsonOrderGroupInTrainArray[i].S['dtLastArriveTime'] );

        jsonGroup := jsonOrderGroupInTrainArray[i].O['Group'] ;
        JsonToGroup(Group,jsonGroup);
      end;
    end;
  end;
end;

procedure TRsLCNameBoard.JsonToTrainman(var Trainman: RRsTrainman;
  Json: ISuperObject);
begin
  with Trainman do
  begin
    strTrainmanGUID := Json.S['trainmanID'] ;
    strTrainmanNumber := Json.S['trainmanNumber'] ;
    strTrainmanName := Json.S['trainmanName'] ;
    nPostID :=  TRsPost ( strtoint(Json.S['postID']) ) ;
    strPostName := Json.S['postName'] ;
    strTelNumber := Json.S['telNumber'] ;
    strMobileNumber := strTelNumber ;
    //strMobileNumber := Json.S['mobileNumber'];
    nTrainmanState := TRsTrainmanState   (StrToInt(Json.S['trainmanState']));
    strPostName := Json.S['postName'] ;
    nDriverType := TRsDriverType ( strtoint ( Json.S['driverTypeID'] ) ) ;
    strDriverTypeName := Json.S['driverTypeName'] ;
    strABCD := Json.S['ABCD'] ;
    bIsKey :=  ( StrToInt(Json.S['isKey']) ) ;

    if Json.S['callWorkState'] <> '' then
      nCallWorkState :=  TRsCallWorkState ( StrToInt(Json.S['callWorkState']) );
    if Json.S['callWorkID'] <> '' then
      strCallWorkGUID := Json.S['callWorkID'];
  end;
end;



end.
