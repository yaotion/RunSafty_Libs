unit uLeaveListInfo;

interface

uses
  SysUtils,uSaftyEnum;

type
  //���״̬ö��
  TRsAskLeaveStatus = (alsNormal=0{δ���},alsLeaveing=1{�����},alsFollow=2{������},alsCancel=3{������});
  //������ͽṹ��
  RRsLeaveType = record
    strTypeGUID: string;
    strTypeName: string;
    nClassID: integer;
    strClassName: string;
  end;




  TRsLeaveTypeArray = array of RRsLeaveType;

  //������ṹ��
  RRsLeaveClass = record
    nClassID: integer;
    strClassName: string;
  end;

  TRsLeaveClassArray = array of RRsLeaveClass;


  //�����Ϣ
  RRsAskLeave = record
    strAskLeaveGUID: string;
    strTrainManID: string; 
    strTrainmanName: string;
    dtBeginTime: TDateTime;
    dtEndTime: TDateTime;
    strLeaveTypeGUID: string;
    nStatus: integer;

    //liulin add 20131029 
    strAskProverID: string;
    strAskProverName: string;
    dtAskCreateTime: TDateTime;
    strAskDutyUserName: string; 
    strMemo: string;      
    nPostID: TRsPost;
    strGuideGroupName: string;
  end;

  //�����ϸ��Ϣ
  RRsAskLeaveDetail = record
    strAskLeaveDetailGUID: string;
    strAskLeaveGUID: string;
    strMemo: string;
    dtBeginTime: TDateTime;
    dtEndTime: TDateTime;
    strProverID: string;
    strProverName: string;
    dtCreateTime: TDateTime;
    strDutyUserID: string;
    strDutyUserName: string;
    strSiteID: string;
    strSiteName: string;
    Verify: TRsRegisterFlag;
  end;

  //���ٽṹ��
  RRsFollowLeaveDetail = record
    strFollowLeaveGUID: string;
    strAskLeaveGUID: string;
    dtEndTime: TDateTime;
    strMemo: string;
    strProverID: string;
    strProverName: string;
    dtCreateTime: TDateTime;
    strDutyUserID: string;
    strDutyUserName: string;
    strSiteID: string;
    strSiteName: string;
    //Verify: TRsRegisterFlag;
    Verify: integer;
  end;

  TRsFollowLeaveDetailArray = array of RRsFollowLeaveDetail;

//���ٽṹ��
  RRsCancelLeaveDetail = record
    strCancelLeaveGUID: string;
    strAskLeaveGUID: string;
    strTrainmanID : string;
    strProverID: string;
    strProverName: string;
    dtCancelTime : TDateTime;
    dtCreateTime: TDateTime;
    strDutyUserID: string;
    strDutyUserName: string;
    strSiteID: string;
    strSiteName: string;
    Verify: TRsRegisterFlag;
  end;

  //��������������Ƶ������Ϣ
  RRsAskLeaveWithType = record
    AskLeave: RRsAskLeave;
    strTypeName: string;
  end;

  TRsAskLeaveWithTypeArray = array of RRsAskLeaveWithType;
implementation

end.
