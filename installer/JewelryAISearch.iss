#define MyAppName "Jewelry AI Search"
#define MyAppVersion "0.98.3"
#define MyAppPublisher "Роман Киселёв"
#define MyAppExeName "JewelryAISearch.exe"
#ifndef AppDistDir
  #define AppDistDir "..\dist\JewelryAISearch"
#endif

[Setup]
AppId={{8E55619E-B337-4DF9-AFA1-0BF02255E38A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={localappdata}\Programs\Jewelry AI Search
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\release
OutputBaseFilename=Jewelry_AI_Search_Setup_v0.98.3
Compression=lzma2
SolidCompression=no
WizardStyle=modern
SetupIconFile=..\assets\jewelry-ai-search.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "Создать ярлык на рабочем столе"; GroupDescription: "Ярлыки:"; Flags: unchecked
Name: "ollamapage"; Description: "Открыть страницу установки Ollama после завершения"; GroupDescription: "Локальный Qwen:"; Flags: checkedonce

[Files]
Source: "{#AppDistDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\assets\jewelry-ai-search.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\assets\jewelry-ai-search.png"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{autoprograms}\{#MyAppName} - Удалить программу"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Запустить {#MyAppName}"; Flags: nowait postinstall skipifsilent
Filename: "https://ollama.com/download/windows"; Description: "Установить Ollama для локального Qwen"; Flags: shellexec postinstall skipifsilent; Tasks: ollamapage

[Code]
var
  RemoveJewelryData: Boolean;
  RemoveOllamaAndModels: Boolean;

function InitializeUninstall: Boolean;
var
  CleanupDialog: TSetupForm;
  IntroText: TNewStaticText;
  DataDescription: TNewStaticText;
  OllamaDescription: TNewStaticText;
  SafetyNotice: TNewStaticText;
  DataCheckbox: TNewCheckBox;
  OllamaCheckbox: TNewCheckBox;
  ConfirmButton: TNewButton;
  CancelButton: TNewButton;
begin
  RemoveJewelryData := False;
  RemoveOllamaAndModels := False;
  Result := True;

  { Silent removal must never erase shared AI models or private user data. }
  if UninstallSilent then
    Exit;

#if Ver >= 0x06060000
  CleanupDialog := CreateCustomForm(ScaleX(570), ScaleY(330), False, False);
#else
  CleanupDialog := CreateCustomForm;
  CleanupDialog.ClientWidth := ScaleX(570);
  CleanupDialog.ClientHeight := ScaleY(330);
#endif
  try
    CleanupDialog.Caption := 'Удаление Jewelry AI Search';
    CleanupDialog.CenterOnShow := True;

    IntroText := TNewStaticText.Create(CleanupDialog);
    IntroText.Parent := CleanupDialog;
    IntroText.Left := ScaleX(20);
    IntroText.Top := ScaleY(17);
    IntroText.Width := ScaleX(530);
    IntroText.Height := ScaleY(45);
    IntroText.AutoSize := False;
    IntroText.WordWrap := True;
    IntroText.Caption := 'Программа будет удалена. При необходимости выберите, что ещё нужно очистить:';

    DataCheckbox := TNewCheckBox.Create(CleanupDialog);
    DataCheckbox.Parent := CleanupDialog;
    DataCheckbox.Left := ScaleX(21);
    DataCheckbox.Top := ScaleY(77);
    DataCheckbox.Width := ScaleX(527);
    DataCheckbox.Height := ScaleY(22);
    DataCheckbox.Caption := 'Удалить локальную базу, кэш, настройки и автоархивы Jewelry AI';
    DataCheckbox.Checked := False;

    DataDescription := TNewStaticText.Create(CleanupDialog);
    DataDescription.Parent := CleanupDialog;
    DataDescription.Left := ScaleX(42);
    DataDescription.Top := ScaleY(102);
    DataDescription.Width := ScaleX(504);
    DataDescription.Height := ScaleY(42);
    DataDescription.AutoSize := False;
    DataDescription.WordWrap := True;
    DataDescription.Caption := 'Удаляются индекс, обучение и автоматические ZIP рядом с программой. Фотографии и архивы, сохранённые в другом месте, остаются.';

    OllamaCheckbox := TNewCheckBox.Create(CleanupDialog);
    OllamaCheckbox.Parent := CleanupDialog;
    OllamaCheckbox.Left := ScaleX(21);
    OllamaCheckbox.Top := ScaleY(160);
    OllamaCheckbox.Width := ScaleX(527);
    OllamaCheckbox.Height := ScaleY(22);
    OllamaCheckbox.Caption := 'Удалить Ollama и ВСЕ скачанные через неё нейросети';
    OllamaCheckbox.Checked := False;

    OllamaDescription := TNewStaticText.Create(CleanupDialog);
    OllamaDescription.Parent := CleanupDialog;
    OllamaDescription.Left := ScaleX(42);
    OllamaDescription.Top := ScaleY(184);
    OllamaDescription.Width := ScaleX(504);
    OllamaDescription.Height := ScaleY(44);
    OllamaDescription.AutoSize := False;
    OllamaDescription.WordWrap := True;
    OllamaDescription.Caption := 'Будут удалены Ollama, модели Qwen и другие модели Ollama, даже если они хранятся в отдельной папке.';

    SafetyNotice := TNewStaticText.Create(CleanupDialog);
    SafetyNotice.Parent := CleanupDialog;
    SafetyNotice.Left := ScaleX(21);
    SafetyNotice.Top := ScaleY(240);
    SafetyNotice.Width := ScaleX(530);
    SafetyNotice.Height := ScaleY(35);
    SafetyNotice.AutoSize := False;
    SafetyNotice.WordWrap := True;
    SafetyNotice.Caption := 'Внимание: Ollama может использоваться другими программами. Если сомневаетесь - оставьте обе галочки выключенными.';

    ConfirmButton := TNewButton.Create(CleanupDialog);
    ConfirmButton.Parent := CleanupDialog;
    ConfirmButton.Left := ScaleX(320);
    ConfirmButton.Top := ScaleY(288);
    ConfirmButton.Width := ScaleX(130);
    ConfirmButton.Height := ScaleY(29);
    ConfirmButton.Caption := 'Удалить';
    ConfirmButton.ModalResult := mrOk;
    ConfirmButton.Default := True;

    CancelButton := TNewButton.Create(CleanupDialog);
    CancelButton.Parent := CleanupDialog;
    CancelButton.Left := ScaleX(458);
    CancelButton.Top := ScaleY(288);
    CancelButton.Width := ScaleX(92);
    CancelButton.Height := ScaleY(29);
    CancelButton.Caption := 'Отмена';
    CancelButton.ModalResult := mrCancel;
    CancelButton.Cancel := True;

    Result := CleanupDialog.ShowModal = mrOk;
    if Result then
    begin
      RemoveJewelryData := DataCheckbox.Checked;
      RemoveOllamaAndModels := OllamaCheckbox.Checked;
    end;
  finally
    CleanupDialog.Free;
  end;
end;

procedure RemoveKnownFolder(const Folder: String; const ExpectedLeaf: String);
begin
  if (Folder = '') or (ExpectedLeaf = '') then
    Exit;
  if CompareText(ExtractFileName(Folder), ExpectedLeaf) <> 0 then
    Exit;
  if DirExists(Folder) then
    DelTree(Folder, True, True, True);
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ProfileDirectory: String;
  OllamaDirectory: String;
  OllamaUninstaller: String;
  CustomModels: String;
  ResultCode: Integer;
begin
  if CurUninstallStep <> usUninstall then
    Exit;

  ProfileDirectory := GetEnv('USERPROFILE');
  if RemoveJewelryData and (ProfileDirectory <> '') then
    RemoveKnownFolder(ProfileDirectory + '\.jewelry_ai_search',
                      '.jewelry_ai_search');

  if not RemoveOllamaAndModels then
    Exit;

  OllamaDirectory := ExpandConstant('{localappdata}\Programs\Ollama');
  OllamaUninstaller := OllamaDirectory + '\unins000.exe';
  if FileExists(OllamaUninstaller) then
    Exec(OllamaUninstaller, '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '',
         SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);

  CustomModels := GetEnv('OLLAMA_MODELS');
  if CustomModels <> '' then
  begin
    RemoveKnownFolder(AddBackslash(CustomModels) + 'blobs', 'blobs');
    RemoveKnownFolder(AddBackslash(CustomModels) + 'manifests', 'manifests');
  end;
  if ProfileDirectory <> '' then
    RemoveKnownFolder(ProfileDirectory + '\.ollama', '.ollama');
  RemoveKnownFolder(ExpandConstant('{localappdata}\Ollama'), 'Ollama');
  RemoveKnownFolder(OllamaDirectory, 'Ollama');
  RemoveKnownFolder(ExpandConstant('{userappdata}\Ollama'), 'Ollama');
  RegDeleteValue(HKCU, 'Environment', 'OLLAMA_MODELS');
end;
