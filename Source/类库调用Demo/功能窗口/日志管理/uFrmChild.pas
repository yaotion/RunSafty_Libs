unit uFrmChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, AdvMemo, StdCtrls, Mask, RzEdit, RzCmboBx, RzPanel,
  RzButton, RzStatus, ExtCtrls, RzCommon, RzRadChk, AdvmPS,uMemoStyler;

type
  PLogTitle = ^RLogTitle;
  RLogTitle = record
    lineNo: integer;
    logLevel: integer;
    catalog: string;
  end;


  TStatubarHintEvent = procedure(const hint: string) of object;
  TFrmChild = class(TForm)
    memLog: TAdvMemo;
    AdvMemoFindDialog1: TAdvMemoFindDialog;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    chkInfo: TRzCheckBox;
    RzFrameController1: TRzFrameController;
    chkDebug: TRzCheckBox;
    chkError: TRzCheckBox;
    AdvDefaultSource: TAdvMemoSource;
    AdvFilterSrc: TAdvMemoSource;
    Label1: TLabel;
    edtCatalog: TRzEdit;
    RzSpacer4: TRzSpacer;
    RzSpacer1: TRzSpacer;
    BtnView: TRzToolButton;
    AdvPascalMemoStyler1: TAdvPascalMemoStyler;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_OnStatubarHint: TStatubarHintEvent;
    m_FilterIndex: TList;
    m_MemoLogStyler: TAdvMemoLogStyler;
    procedure ClearIndex();
    procedure WriteStatuhint(const hint: string);
    procedure ReadLog(const FileName: string;lines: TStrings);
  public
    { Public declarations }
    procedure FindString();
    procedure GoToLine();
    procedure LoadLog(const FileName: string);
    property OnStatubarHint: TStatubarHintEvent read m_OnStatubarHint write m_OnStatubarHint;
  end;


implementation

{$R *.dfm}
function LevelStringToInt(const levelString: string): integer;
begin
  if SameText(levelString,'info') then
    Result := 1
  else
  if SameText(levelString,'debug') then
    Result := 2
  else
  if SameText(levelString,'error') then
    Result := 4
  else
    Result := -1;


end;
type
  TStringArray = array of string;
function GetTitleElement(const line: string):  TStringArray;
var
  I,nStartPos: Integer;
  inElement: Boolean;
begin
  inElement := False;
  nStartPos := 0;
  for I := 1 to length(line) do
  begin
    if line[i] = '[' then
    begin
      inElement := True;
      nStartPos := i;
    end;

    if line[i] = ']' then
    begin
      if inElement then
      begin
        SetLength(Result,Length(result) + 1);
        result[Length(result) - 1] := Copy(line,nStartPos + 1,i - nStartPos - 1);
        inElement := False;
      end;
    end;
  end;
end;
procedure TFrmChild.BtnViewClick(Sender: TObject);
  function CombineSelectLevel(): integer;
  begin
    Result := 0;

    if chkInfo.Checked then
      Inc(Result,1);

    if chkDebug.Checked then
      Inc(Result,2);

    if chkError.Checked then
      Inc(Result,4);
  end;
  
  procedure GetLogLevel(const line: string;var level: integer;var catalog: string);
  var
    elements: TStringArray;
  begin
    catalog := '';
    level := -1;
    elements := GetTitleElement(line);
    if Length(elements) > 0 then
    begin
      level := LevelStringToInt(elements[0]);
    end;

    if Length(elements) > 1 then
    begin
      catalog := elements[1];
    end;

  end;

  procedure ExtractFilterIndex();
  var
    I: Integer;
    nLevel: integer;
    catalog: string;
    LogTitle: PLogTitle;
  begin
    i := 0;
    while i < AdvDefaultSource.Lines.Count - 1 do
    begin
      if (AdvDefaultSource.Lines[i] <> '') and (AdvDefaultSource.Lines[i][1] = '[') then
      begin
        GetLogLevel(AdvDefaultSource.Lines[i],nLevel,catalog);

        New(LogTitle);
        LogTitle.lineNo := i;
        LogTitle.logLevel := nLevel;
        LogTitle.catalog := catalog;

        m_FilterIndex.Add(LogTitle);
      end;

      INC(i);
    end;

  end;

  procedure ExtractFilterLog();
  var
    I: Integer;
    sLevel: integer;
    j: Integer;
    nEndLine: integer;
  begin
    AdvFilterSrc.Lines.BeginUpdate;
    AdvFilterSrc.Lines.Clear;
    sLevel := CombineSelectLevel();
    
    for I := 0 to m_FilterIndex.Count - 1 do
    begin

      if PLogTitle(m_FilterIndex.Items[i]).logLevel and sLevel <> 0 then
      begin
        if edtCatalog.Text <> '' then
        begin
          if PLogTitle(m_FilterIndex.Items[i]).catalog <> edtCatalog.Text then
            Continue;
        end;


        if i < m_FilterIndex.Count - 1 then
          nEndLine := PLogTitle(m_FilterIndex.Items[i + 1]).lineNo - 1
        else
          nEndLine := AdvDefaultSource.Lines.Count - 1;

        for j := PLogTitle(m_FilterIndex.Items[i]).lineNo to nEndLine do
        begin
          AdvFilterSrc.Lines.Add(AdvDefaultSource.Lines.Strings[j]);
        end;
      end;
    end;
    AdvFilterSrc.Lines.EndUpdate;
  end;
begin
  if m_FilterIndex.Count = 0 then
  begin
    ExtractFilterIndex();
  end;
  
  if chkInfo.Checked and chkDebug.Checked and chkError.Checked and (Trim(edtCatalog.Text) = '') then
  begin
    memLog.MemoSource := AdvDefaultSource;
    WriteStatuhint(Format('共 %d 行',[AdvDefaultSource.Lines.Count]));
  end
  else
  begin
    ExtractFilterLog();
    memLog.MemoSource := AdvFilterSrc;
    WriteStatuhint(Format('共 %d 行',[AdvFilterSrc.Lines.Count]));
  end;
end;

procedure TFrmChild.ClearIndex;
var
  I: Integer;
begin
  for I := 0 to m_FilterIndex.Count - 1 do
  begin
    Dispose(PLogTitle(m_FilterIndex.Items[i]));
  end;
  m_FilterIndex.Clear;
end;

procedure TFrmChild.FindString;
begin
  AdvMemoFindDialog1.Execute;
end;

procedure TFrmChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmChild.FormCreate(Sender: TObject);
begin
  m_FilterIndex := TList.Create;
  m_MemoLogStyler := TAdvMemoLogStyler.Create(self);
  memLog.SyntaxStyles := m_MemoLogStyler;
  AdvDefaultSource.SyntaxStyler := m_MemoLogStyler;
  AdvFilterSrc.SyntaxStyler := m_MemoLogStyler;
end;

procedure TFrmChild.FormDestroy(Sender: TObject);
begin
  ClearIndex();
  m_FilterIndex.Free;
  m_MemoLogStyler.Free;
end;

procedure TFrmChild.GoToLine;
var
  lineNo: string;
  nLineNo: integer;
begin
  lineNo := IntToStr(memLog.CurY);
  if InputQuery('输入','请输入行号:',lineNo) then
  begin
    if TryStrToInt(lineNo,nLineNo) then
    begin
      memLog.CurY := nLineNo;
    end;
  end;
end;

procedure TFrmChild.LoadLog(const FileName: string);
begin
  AdvDefaultSource.Lines.Clear();
  AdvDefaultSource.Lines.BeginUpdate;
  ReadLog(FileName,AdvDefaultSource.Lines);

  AdvDefaultSource.Lines.EndUpdate;
  memLog.MemoSource := AdvDefaultSource;
end;

procedure TFrmChild.ReadLog(const FileName: string; lines: TStrings);
var
  log: TextFile;
  line: string;
begin
  AssignFile(log,FileName);

  Reset(log);
  try
    while not Eof(log)  do
    begin
      Readln(log,line);
      lines.Add(line);
    end;
    WriteStatuhint(Format('读取完成，共 %d 行',[lines.Count]));
  finally
    CloseFile(log);
  end;
end;

procedure TFrmChild.WriteStatuhint(const hint: string);
begin
  if Assigned(m_OnStatubarHint) then
    m_OnStatubarHint(hint);
end;



end.
