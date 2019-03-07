unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TfrmLuckyDraw = class(TForm)
    OpenDialog: TOpenDialog;
    lblPList: TLabel;
    lblWList: TLabel;
    lblAdd: TLabel;
    lblAmount: TLabel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    btnDraw: TButton;
    edtName: TEdit;
    mmDrawerList: TMemo;
    edtAmount: TEdit;
    lbParticipantsList: TListBox;
    btnNew: TButton;
    btnLoad: TButton;
    Label1: TLabel;
    btnPrizeAdd: TButton;
    edtPrize: TEdit;
    rgOption: TRadioGroup;
    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDrawClick(Sender: TObject);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnNewClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnPrizeAddClick(Sender: TObject);
    procedure edtAmountKeyPress(Sender: TObject; var Key: Char);
    procedure edtPrizeKeyPress(Sender: TObject; var Key: Char);
    procedure lbParticipantsListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    private
    { Private declarations }
    procedure ClearItem;
    procedure AddItem;
    procedure DeleteItem;
    procedure AddPrize;
    procedure LoadFromFile;
    procedure LuckyDraw;
    function OverDrawCheck: Boolean;
    procedure MoveWinnersName;
    procedure RemoveRepeatedName(AIndex: Integer);
  public
    { Public declarations }
  end;

var
  frmLuckyDraw: TfrmLuckyDraw;

implementation

{$R *.dfm}

procedure TfrmLuckyDraw.FormShow(Sender: TObject);
begin
  edtName.SetFocus;
end;

procedure TfrmLuckyDraw.btnClearClick(Sender: TObject);
begin
  //Clear
  ClearItem;
end;

procedure TfrmLuckyDraw.btnAddClick(Sender: TObject);
begin
  //Add
  AddItem;
end;

procedure TfrmLuckyDraw.btnDeleteClick(Sender: TObject);
begin
  //Delete
  DeleteItem;
end;

procedure TfrmLuckyDraw.btnCloseClick(Sender: TObject);
begin
  //Close
  Close;
end;

procedure TfrmLuckyDraw.btnDrawClick(Sender: TObject);
begin
  //Draw
  LuckyDraw;
end;

procedure TfrmLuckyDraw.btnNewClick(Sender: TObject);
begin
  //New
  ClearItem;
end;

procedure TfrmLuckyDraw.btnPrizeAddClick(Sender: TObject);
begin
  //AddPrize
  AddPrize;
end;

procedure TfrmLuckyDraw.btnLoadClick(Sender: TObject);
begin
  //Load
  LoadFromFile;
end;

procedure TfrmLuckyDraw.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    AddItem;
end;

procedure TfrmLuckyDraw.edtPrizeKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    AddPrize;
end;

procedure TfrmLuckyDraw.edtAmountKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmLuckyDraw.lbParticipantsListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
    DeleteItem;
end;

procedure TfrmLuckyDraw.ClearItem;
begin
  lbParticipantsList.Items.Clear;
  mmDrawerList.Lines.Clear;
  edtName.Text := '';
  edtAmount.Text := '3';
  edtName.SetFocus;
end;

procedure TfrmLuckyDraw.AddItem;
begin
  if Trim(edtName.Text) = '' then
  begin
    Exit;
  end;

  lbParticipantsList.AddItem(Trim(edtName.Text),nil);

  edtName.Text := '';
end;

procedure TfrmLuckyDraw.DeleteItem;
begin
  lbParticipantsList.DeleteSelected;
end;

procedure TfrmLuckyDraw.AddPrize;
begin
  if Trim(edtPrize.Text) = '' then
  begin
    Exit;
  end;

  mmDrawerList.Lines.Add('<'+Trim(edtPrize.Text)+'>');

  edtPrize.Text := '';
end;

procedure TfrmLuckyDraw.LoadFromFile;
var
  DrawerList: TStringList;
  FileName : String;
begin
  OpenDialog.InitialDir := GetCurrentDir;
  //OpenDialog.Filter := 'Text files (*.txt)|*.TXT';

  if OpenDialog.Execute then
    //ShowMessage('File : '+OpenDialog.FileName)
  else
    ShowMessage('Open file was cancelled');

  FileName := OpenDialog.FileName;

  if (FileExists(FileName)) then
  begin
    DrawerList := TStringList.Create;
    DrawerList.Loadfromfile(FileName);
    lbParticipantsList.Items := DrawerList;
    DrawerList.Free;
  end;
end;

procedure TfrmLuckyDraw.LuckyDraw;
begin
  if OverDrawCheck then
  begin
    MoveWinnersName;
  end;
end;

function TfrmLuckyDraw.OverDrawCheck: Boolean;
begin
  Result := False;

  //참여자가 없다면
  if lbParticipantsList.Count <= 0 then
  begin
    ShowMessage('Plz, Insert participants name');
    Exit;
  end;

  //참여자가 당첨예정자 수보다 적다면

  Result := True;
end;

procedure TfrmLuckyDraw.MoveWinnersName;
var
  DrawCount   : Integer;
  RoopCounter : Integer;
  WinnerIndex : Integer;
  WinnerName  : String;
begin
  DrawCount := StrToInt(edtAmount.Text);

  for RoopCounter := 1 to DrawCount do
  begin
    if lbParticipantsList.Items.Count <= 0 then
    begin
      Exit;
    end;

    WinnerIndex := Random(lbParticipantsList.Items.Count);
    WinnerName := lbParticipantsList.Items.Strings[WinnerIndex];

    mmDrawerList.Lines.Add(WinnerName);

    RemoveRepeatedName(WinnerIndex);
  end;


// 당첨자 이름을 참여자 박스에서 옮겨오기
end;

procedure TfrmLuckyDraw.RemoveRepeatedName(AIndex: Integer);
var
  LoopI : Integer;
  WinnerName: String;
begin
  if rgOption.ItemIndex = 0 then
  begin
    //단일 당첨 시 (참여자 목록에서 동일한 이름 제거)
    WinnerName := lbParticipantsList.Items.Strings[AIndex];

    for LoopI := lbParticipantsList.Items.Count - 1 downto 0 do
    begin
      if WinnerName = lbParticipantsList.Items.Strings[LoopI] then
      begin
        lbParticipantsList.Items.Delete(LoopI);
      end;
    end;
  end
  else
  begin
    //중복 당첨 시 (참여자 목록에서 해당 이름만 제거)
    lbParticipantsList.Items.Delete(AIndex);
  end;
end;

//TODO: 다수의 상품을 한번에 추첨하도록 처리

end.
