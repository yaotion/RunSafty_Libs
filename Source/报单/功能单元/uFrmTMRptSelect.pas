unit uFrmTMRptSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFSystem;

type
  TfrmTMRptSelect = class(TForm)
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    lstboxModules: TListBox;
    checkRemeber: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_FileList : TStringList;
    m_AppPath: string;
    function GetSelectFile: string;
    { Private declarations }
  public
    property  SelectFile : string read GetSelectFile;
  public
    { Public declarations }
    class function Select(out SelectFile : string;UserConfig : boolean = true):boolean;
    class procedure Config();
  end;


implementation
uses
  uGlobal;
var
  frmTMRptSelect: TfrmTMRptSelect;

{$R *.dfm}

procedure Searchfile(path: string;FileLst : TStringList);
var
  SearchRec: TSearchRec;
  found: integer;
begin
  found := FindFirst(path + '\' + '*.fr3', faAnyFile, SearchRec);
  while found = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
      (SearchRec.Attr <> faDirectory) then
      FileLst.Add(SearchRec.Name);
    found := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end;

procedure TfrmTMRptSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTMRptSelect.btnOKClick(Sender: TObject);
begin
  if lstboxModules.ItemIndex < 0 then
  begin
    Box('请选择一个报单模版文件');
    exit;
  end;
  TConfig.RemeberPrintModule := checkRemeber.Checked;
  TConfig.PrintModuleFile := GetSelectFile;  
  ModalResult := mrOk;
end;

class procedure TfrmTMRptSelect.Config;
begin

  frmTMRptSelect:= TfrmTMRptSelect.Create(nil);
  try
    frmTMRptSelect.ShowModal;
  finally
    frmTMRptSelect.Free;
  end;
end;


procedure TfrmTMRptSelect.FormCreate(Sender: TObject);
begin
  m_FileList := TStringList.Create;
  m_AppPath := ExtractFilePath(ParamStr(0));
end;

procedure TfrmTMRptSelect.FormDestroy(Sender: TObject);
begin
  m_FileList.Free;
end;

procedure TfrmTMRptSelect.FormShow(Sender: TObject);
begin
  Searchfile(m_AppPath + 'RptFile',m_FileList);
  lstboxModules.Items.AddStrings(m_FileList);
  
  checkRemeber.Checked := TConfig.RemeberPrintModule;
  lstboxModules.ItemIndex := lstboxModules.Items.IndexOf(ExtractFileName(TConfig.PrintModuleFile));
end;

function TfrmTMRptSelect.GetSelectFile: string;
begin
  result := '';
  if lstboxModules.ItemIndex < 0 then exit;
  result := m_AppPath + 'RptFile\' +  m_FileList[lstboxModules.ItemIndex];
end;

class function TfrmTMRptSelect.Select(out SelectFile: string;UserConfig : boolean = true): boolean;
begin
  result := false;
  if (TConfig.RemeberPrintModule = true) then
  begin
    if TConfig.PrintModuleFile <> '' then
    begin
      SelectFile := TConfig.PrintModuleFile;
      result := true;
      exit;
    end;
  end;
  frmTMRptSelect:= TfrmTMRptSelect.Create(nil);
  try
    if frmTMRptSelect.ShowModal = mrCancel then exit;
    SelectFile := frmTMRptSelect.SelectFile;
    result := true;
  finally
    frmTMRptSelect.Free;
  end;
end;

end.
