unit uDrinkExtls;

interface
type
  //�����Ϣ��ѯ����
  RRsDrinkQuery = record
    //�������ID
    nWorkTypeID : integer;   
    //����Ա����
    strTrainmanNumber : string;
    //���ʱ��-��ʼ
    dtBeginTime : TDateTime;   
    //���ʱ��-����
    dtEndTime : TDateTime;
  end;
   //�����Ϣ
  RRsDrinkInfo = record
    //��Ƽ�¼GUID
    strGUID:string ;
    //��Ƽ�¼ID
    nDrinkInfoID : integer;
    //����ԱGUID
    strTrainmanGUID : string;
    //����Ա����
    strTrainmanNumber : string;    
    //����Ա����
    strTrainmanName: string;
    //��ƽ��
    nDrinkResult : integer;
    //���ʱ��
    dtCreateTime : TDateTime;
    //ʶ��ʽ
    nVerifyID : integer;
    //ֵ��Ա����
    strDutyNumber : string;
    //�������ID
    nWorkTypeID : integer;
    //�����Ƭ������nilʱ������Ƭ
    DrinkImage : OleVariant;
    strPictureURL: string;
    nDelFlag: integer;

    //�ƾ���(mg/100ml)
    dwAlcoholicity : Integer ;
     //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    {����}
    strTrainNo : String;

  end;
implementation

end.
