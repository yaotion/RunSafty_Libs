unit uLeaveListInfo;

interface

uses
  SysUtils,uSaftyEnum;

type
  //请假状态枚举
  TRsAskLeaveStatus = (alsNormal=0{未请假},alsLeaveing=1{已请假},alsFollow=2{已续假},alsCancel=3{已销假});
  //请假类型结构体
  RRsLeaveType = record
    strTypeGUID: string;
    strTypeName: string;
    nClassID: integer;
    strClassName: string;
  end;




  TRsLeaveTypeArray = array of RRsLeaveType;

  //请假类别结构体
  RRsLeaveClass = record
    nClassID: integer;
    strClassName: string;
  end;

  TRsLeaveClassArray = array of RRsLeaveClass;


  //请假信息
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

  //请假详细信息
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

  //续假结构体
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

//销假结构体
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

  //带有请假类型名称的请假信息
  RRsAskLeaveWithType = record
    AskLeave: RRsAskLeave;
    strTypeName: string;
  end;

  TRsAskLeaveWithTypeArray = array of RRsAskLeaveWithType;
implementation

end.
