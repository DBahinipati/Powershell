#region ScriptForm Designer

#region Constructor

#Class for a new form
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#Set the surrnet user name and machine name for the logging purpose
$RunningUserName = (Invoke-Expression [Environment]::UserDomainName).ToUpper() + "\" + (Invoke-Expression [Environment]::UserName).ToUpper() + " From " + (Invoke-Expression [Environment]::MachineName).ToUpper() + " Machine"
$User = (Invoke-Expression [Environment]::UserName).ToUpper()
$Domain = (Invoke-Expression [Environment]::UserDomainName).ToUpper()
#Importing required Modules
Import-Module ReadINI
Import-Module ADAuthenticate
#Import-Module ChangeServiceAccount

#Setting Global Variables
$LocalLog = Get-IniValue "$PSScriptRoot\Params.ini" "LOG" "LocalLogLocation"
$LocalInput = Get-IniValue "$PSScriptRoot\Params.ini" "inputfile" "LocalInputFileLocation"
$SharedLog  = Get-IniValue "$PSScriptRoot\Params.ini" "LOG" "SharedLogLocation"
$SharedCSV  = Get-IniValue "$PSScriptRoot\Params.ini" "CSV" "SharedCSVImportLocation"
$LocalCSV  = Get-IniValue "$PSScriptRoot\Params.ini" "CSV" "LocalCSVImportLocation"
$ImageRoot = Get-IniValue "$PSScriptRoot\Params.ini" "ImageRootPath" "ImageRoot"

$SharedCSVFolder = $SharedCSV + "\$User\$Domain\" + (Get-Date -format yyyyMMdd)
$SharedLogFile = $SharedCSVFolder + "\" + (Get-Date -format yyyyMMdd) + ".txt"
$LocalCSVFolder = $LocalCSV + "\$User\$Domain\" + (Get-Date -format yyyyMMdd)
$LocalLogFile = $LocalCSVFolder + "\" + (Get-Date -format yyyyMMdd) + ".txt"
$Global:setvariables = 0

#endregion

#region Post-Constructor Custom Code

#endregion

#region Form Creation
#Warning: It is recommended that changes inside this region be handled using the ScriptForm Designer.
#When working with the ScriptForm designer this region and any changes within may be overwritten.
#~~< WindowsServicePassChanger >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$WindowsServicePassChanger = New-Object System.Windows.Forms.Form
$WindowsServicePassChanger.ClientSize = New-Object System.Drawing.Size(1200, 800)
$WindowsServicePassChanger.Text = "Remote Service Log-on Credential Changer"
$WindowsServicePassChanger.BackColor = [System.Drawing.Color]::Silver
#~~< FetchedTaskDetails >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchedTaskDetails = New-Object System.Windows.Forms.GroupBox
$FetchedTaskDetails.Location = New-Object System.Drawing.Point(929, 12)
$FetchedTaskDetails.Size = New-Object System.Drawing.Size(259, 190)
$FetchedTaskDetails.TabIndex = 10
$FetchedTaskDetails.TabStop = $false
$FetchedTaskDetails.Text = "Scheduled Tasks"
#~~< FetchedTaskListBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchedTaskListBox = New-Object System.Windows.Forms.ListBox
$FetchedTaskListBox.FormattingEnabled = $true
$FetchedTaskListBox.Location = New-Object System.Drawing.Point(6, 20)
$FetchedTaskListBox.SelectedIndex = -1
$FetchedTaskListBox.Size = New-Object System.Drawing.Size(245, 160)
$FetchedTaskListBox.TabIndex = 0
$FetchedTaskDetails.Controls.Add($FetchedTaskListBox)
#~~< FetchedAppPoolDetails >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchedAppPoolDetails = New-Object System.Windows.Forms.GroupBox
$FetchedAppPoolDetails.Location = New-Object System.Drawing.Point(553, 12)
$FetchedAppPoolDetails.Size = New-Object System.Drawing.Size(370, 190)
$FetchedAppPoolDetails.TabIndex = 9
$FetchedAppPoolDetails.TabStop = $false
$FetchedAppPoolDetails.Text = "Application Pools"
#~~< FetchedAppPoolListBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchedAppPoolListBox = New-Object System.Windows.Forms.ListBox
$FetchedAppPoolListBox.FormattingEnabled = $true
$FetchedAppPoolListBox.Location = New-Object System.Drawing.Point(6, 22)
$FetchedAppPoolListBox.SelectedIndex = -1
$FetchedAppPoolListBox.Size = New-Object System.Drawing.Size(358, 160)
$FetchedAppPoolListBox.TabIndex = 0
$FetchedAppPoolDetails.Controls.Add($FetchedAppPoolListBox)
#~~< ResultBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ResultBox = New-Object System.Windows.Forms.GroupBox
$ResultBox.Location = New-Object System.Drawing.Point(477, 12)
$ResultBox.Size = New-Object System.Drawing.Size(70, 123)
$ResultBox.TabIndex = 8
$ResultBox.TabStop = $false
$ResultBox.Text = "Result"
#~~< ResultPicBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ResultPicBox = New-Object System.Windows.Forms.PictureBox
$ResultPicBox.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
$ResultPicBox.Location = New-Object System.Drawing.Point(7, 16)
$ResultPicBox.Size = New-Object System.Drawing.Size(57, 99)
$ResultPicBox.TabIndex = 0
$ResultPicBox.TabStop = $false
$ResultPicBox.Text = ""
$ResultBox.Controls.Add($ResultPicBox)
#~~< ChangeServiceDetails >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ChangeServiceDetails = New-Object System.Windows.Forms.GroupBox
$ChangeServiceDetails.Location = New-Object System.Drawing.Point(824, 204)
$ChangeServiceDetails.Size = New-Object System.Drawing.Size(183, 327)
$ChangeServiceDetails.TabIndex = 7
$ChangeServiceDetails.TabStop = $false
$ChangeServiceDetails.Text = "Change Service Details"
#~~< ChangeScheduleTaskButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ChangeScheduleTaskButton = New-Object System.Windows.Forms.Button
$ChangeScheduleTaskButton.AccessibleDescription = "Update Password for all the scdule tasks Discovered"
$ChangeScheduleTaskButton.Location = New-Object System.Drawing.Point(17, 259)
$ChangeScheduleTaskButton.Size = New-Object System.Drawing.Size(142, 23)
$ChangeScheduleTaskButton.TabIndex = 25
$ChangeScheduleTaskButton.Text = "Update Tasks"
$ChangeScheduleTaskButton.UseVisualStyleBackColor = $true
#~~< ChangeAppPoolButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ChangeAppPoolButton = New-Object System.Windows.Forms.Button
$ChangeAppPoolButton.AccessibleDescription = "Update tehn password for all the application pools discovered"
$ChangeAppPoolButton.Location = New-Object System.Drawing.Point(17, 230)
$ChangeAppPoolButton.Size = New-Object System.Drawing.Size(142, 23)
$ChangeAppPoolButton.TabIndex = 24
$ChangeAppPoolButton.Text = "Update AppPools"
$ChangeAppPoolButton.UseVisualStyleBackColor = $true
$ChangeAppPoolButton.add_Click({ChangeAllAppPoolAccount($ChangeAppPoolButton)})
#~~< RestartSerrviceButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$RestartSerrviceButton = New-Object System.Windows.Forms.Button
$RestartSerrviceButton.Location = New-Object System.Drawing.Point(17, 146)
$RestartSerrviceButton.Size = New-Object System.Drawing.Size(142, 23)
$RestartSerrviceButton.TabIndex = 21
$RestartSerrviceButton.Text = "Restart Service"
$RestartSerrviceButton.UseVisualStyleBackColor = $true
$RestartSerrviceButton.add_Click({RestartService($RestartSerrviceButton)})
#~~< StopServiceButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$StopServiceButton = New-Object System.Windows.Forms.Button
$StopServiceButton.Location = New-Object System.Drawing.Point(17, 201)
$StopServiceButton.Size = New-Object System.Drawing.Size(142, 23)
$StopServiceButton.TabIndex = 23
$StopServiceButton.Text = "Stop Service"
$StopServiceButton.UseVisualStyleBackColor = $true
$StopServiceButton.add_Click({StopService($StopServiceButton)})
#~~< StartServiceButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$StartServiceButton = New-Object System.Windows.Forms.Button
$StartServiceButton.Location = New-Object System.Drawing.Point(17, 175)
$StartServiceButton.Size = New-Object System.Drawing.Size(142, 23)
$StartServiceButton.TabIndex = 22
$StartServiceButton.Text = "Start Service"
$StartServiceButton.UseVisualStyleBackColor = $true
$StartServiceButton.add_Click({StartService($StartServiceButton)})
#~~< ChangeAllServiceAccountButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ChangeAllServiceAccountButton = New-Object System.Windows.Forms.Button
$ChangeAllServiceAccountButton.Location = New-Object System.Drawing.Point(17, 117)
$ChangeAllServiceAccountButton.Size = New-Object System.Drawing.Size(142, 23)
$ChangeAllServiceAccountButton.TabIndex = 20
$ChangeAllServiceAccountButton.Text = "Change All Logon Account"
$ChangeAllServiceAccountButton.UseVisualStyleBackColor = $true
$ChangeAllServiceAccountButton.add_Click({ChangeAllLogonAccount($ChangeAllServiceAccountButton)})
#~~< ChangeServiceAccountButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ChangeServiceAccountButton = New-Object System.Windows.Forms.Button
$ChangeServiceAccountButton.Location = New-Object System.Drawing.Point(17, 88)
$ChangeServiceAccountButton.Size = New-Object System.Drawing.Size(142, 23)
$ChangeServiceAccountButton.TabIndex = 19
$ChangeServiceAccountButton.Text = "Change Logon Account"
$ChangeServiceAccountButton.UseVisualStyleBackColor = $true
$ChangeServiceAccountButton.add_Click({ChangeLogonAccount($ChangeServiceAccountButton)})
#~~< RestartRadioButtonLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$RestartRadioButtonLabel = New-Object System.Windows.Forms.Label
$RestartRadioButtonLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$RestartRadioButtonLabel.Location = New-Object System.Drawing.Point(17, 19)
$RestartRadioButtonLabel.Size = New-Object System.Drawing.Size(151, 21)
$RestartRadioButtonLabel.TabIndex = 21
$RestartRadioButtonLabel.Text = "Service Restart Options"
$RestartRadioButtonLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< RestartNoRadioButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$RestartNoRadioButton = New-Object System.Windows.Forms.RadioButton
$RestartNoRadioButton.Location = New-Object System.Drawing.Point(17, 63)
$RestartNoRadioButton.Size = New-Object System.Drawing.Size(130, 19)
$RestartNoRadioButton.TabIndex = 18
$RestartNoRadioButton.Text = "Skip Service Restart"
$RestartNoRadioButton.UseVisualStyleBackColor = $true
#~~< RestartYesRadioButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$RestartYesRadioButton = New-Object System.Windows.Forms.RadioButton
$RestartYesRadioButton.Checked = $true
$RestartYesRadioButton.Location = New-Object System.Drawing.Point(17, 40)
$RestartYesRadioButton.Size = New-Object System.Drawing.Size(104, 20)
$RestartYesRadioButton.TabIndex = 17
$RestartYesRadioButton.TabStop = $true
$RestartYesRadioButton.Text = "Restart Service"
$RestartYesRadioButton.UseVisualStyleBackColor = $true
$RestartYesRadioButton.add_CheckedChanged({ServiceRestartCheckChanged($RestartYesRadioButton)})
$ChangeServiceDetails.Controls.Add($ChangeScheduleTaskButton)
$ChangeServiceDetails.Controls.Add($ChangeAppPoolButton)
$ChangeServiceDetails.Controls.Add($RestartSerrviceButton)
$ChangeServiceDetails.Controls.Add($StopServiceButton)
$ChangeServiceDetails.Controls.Add($StartServiceButton)
$ChangeServiceDetails.Controls.Add($ChangeAllServiceAccountButton)
$ChangeServiceDetails.Controls.Add($ChangeServiceAccountButton)
$ChangeServiceDetails.Controls.Add($RestartRadioButtonLabel)
$ChangeServiceDetails.Controls.Add($RestartNoRadioButton)
$ChangeServiceDetails.Controls.Add($RestartYesRadioButton)
#~~< FetchedServiceDetails >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchedServiceDetails = New-Object System.Windows.Forms.GroupBox
$FetchedServiceDetails.Location = New-Object System.Drawing.Point(553, 204)
$FetchedServiceDetails.Size = New-Object System.Drawing.Size(265, 327)
$FetchedServiceDetails.TabIndex = 6
$FetchedServiceDetails.TabStop = $false
$FetchedServiceDetails.Text = "Fetched Service Details"
#~~< FetchedServiceListbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchedServiceListbox = New-Object System.Windows.Forms.ListBox
$FetchedServiceListbox.FormattingEnabled = $true
$FetchedServiceListbox.Location = New-Object System.Drawing.Point(6, 24)
$FetchedServiceListbox.SelectedIndex = -1
$FetchedServiceListbox.Size = New-Object System.Drawing.Size(253, 290)
$FetchedServiceListbox.TabIndex = 12
$FetchedServiceDetails.Controls.Add($FetchedServiceListbox)
#~~< FetchDetails >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchDetails = New-Object System.Windows.Forms.GroupBox
$FetchDetails.Location = New-Object System.Drawing.Point(381, 141)
$FetchDetails.Size = New-Object System.Drawing.Size(166, 359)
$FetchDetails.TabIndex = 5
$FetchDetails.TabStop = $false
$FetchDetails.Text = "Fetch Details"
#~~< CheckBoxFetchScheduledTask >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CheckBoxFetchScheduledTask = New-Object System.Windows.Forms.CheckBox
$CheckBoxFetchScheduledTask.Checked = $true
$CheckBoxFetchScheduledTask.CheckState = [System.Windows.Forms.CheckState]::Checked
$CheckBoxFetchScheduledTask.Location = New-Object System.Drawing.Point(6, 280)
$CheckBoxFetchScheduledTask.Size = New-Object System.Drawing.Size(104, 24)
$CheckBoxFetchScheduledTask.TabIndex = 19
$CheckBoxFetchScheduledTask.Text = "Fetch Tasks"
$CheckBoxFetchScheduledTask.UseVisualStyleBackColor = $true
#~~< CheckBoxFetchAppPool >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CheckBoxFetchAppPool = New-Object System.Windows.Forms.CheckBox
$CheckBoxFetchAppPool.Checked = $true
$CheckBoxFetchAppPool.CheckState = [System.Windows.Forms.CheckState]::Checked
$CheckBoxFetchAppPool.Location = New-Object System.Drawing.Point(6, 259)
$CheckBoxFetchAppPool.Size = New-Object System.Drawing.Size(104, 24)
$CheckBoxFetchAppPool.TabIndex = 18
$CheckBoxFetchAppPool.Text = "Fetch AppPools"
$CheckBoxFetchAppPool.UseVisualStyleBackColor = $true
#~~< CheckBoxFetchService >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$CheckBoxFetchService = New-Object System.Windows.Forms.CheckBox
$CheckBoxFetchService.Checked = $true
$CheckBoxFetchService.CheckState = [System.Windows.Forms.CheckState]::Checked
$CheckBoxFetchService.Location = New-Object System.Drawing.Point(6, 238)
$CheckBoxFetchService.Size = New-Object System.Drawing.Size(104, 24)
$CheckBoxFetchService.TabIndex = 17
$CheckBoxFetchService.Text = "Fetch Service"
$CheckBoxFetchService.UseVisualStyleBackColor = $true
#~~< FetchAllServiceDetailsButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchAllServiceDetailsButton = New-Object System.Windows.Forms.Button
$FetchAllServiceDetailsButton.Location = New-Object System.Drawing.Point(6, 201)
$FetchAllServiceDetailsButton.Size = New-Object System.Drawing.Size(75, 23)
$FetchAllServiceDetailsButton.TabIndex = 16
$FetchAllServiceDetailsButton.Text = "Fetch All >"
$FetchAllServiceDetailsButton.UseVisualStyleBackColor = $true
$FetchAllServiceDetailsButton.add_Click({OnClickFetchAllService($FetchAllServiceDetailsButton)})
#~~< FetchServiceDetailsButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchServiceDetailsButton = New-Object System.Windows.Forms.Button
$FetchServiceDetailsButton.Location = New-Object System.Drawing.Point(6, 172)
$FetchServiceDetailsButton.Size = New-Object System.Drawing.Size(75, 23)
$FetchServiceDetailsButton.TabIndex = 15
$FetchServiceDetailsButton.Text = "Fetch >"
$FetchServiceDetailsButton.UseVisualStyleBackColor = $true
$FetchServiceDetailsButton.add_Click({OnClickFetchService($FetchServiceDetailsButton)})
#~~< ServiceAccountCheckBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ServiceAccountCheckBox = New-Object System.Windows.Forms.CheckBox
$ServiceAccountCheckBox.Checked = $true
$ServiceAccountCheckBox.CheckState = [System.Windows.Forms.CheckState]::Checked
$ServiceAccountCheckBox.Location = New-Object System.Drawing.Point(6, 142)
$ServiceAccountCheckBox.Size = New-Object System.Drawing.Size(121, 24)
$ServiceAccountCheckBox.TabIndex = 14
$ServiceAccountCheckBox.Text = "Service Account"
$ServiceAccountCheckBox.UseVisualStyleBackColor = $true
$ServiceAccountCheckBox.add_CheckedChanged({ServiceAccountCheckChanged($ServiceAccountCheckBox)})
#~~< ServiceNameCheckBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ServiceNameCheckBox = New-Object System.Windows.Forms.CheckBox
$ServiceNameCheckBox.Location = New-Object System.Drawing.Point(6, 121)
$ServiceNameCheckBox.Size = New-Object System.Drawing.Size(121, 24)
$ServiceNameCheckBox.TabIndex = 13
$ServiceNameCheckBox.Text = "Service Name"
$ServiceNameCheckBox.UseVisualStyleBackColor = $true
$ServiceNameCheckBox.add_CheckedChanged({ServiceNameCheckBoxCheckChanged($ServiceNameCheckBox)})
#~~< DisplayNameCheckBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$DisplayNameCheckBox = New-Object System.Windows.Forms.CheckBox
$DisplayNameCheckBox.Location = New-Object System.Drawing.Point(6, 100)
$DisplayNameCheckBox.Size = New-Object System.Drawing.Size(121, 24)
$DisplayNameCheckBox.TabIndex = 12
$DisplayNameCheckBox.Text = "Display Name"
$DisplayNameCheckBox.UseVisualStyleBackColor = $true
$DisplayNameCheckBox.add_CheckedChanged({DisplayNameCheckBoxCheckChanged($DisplayNameCheckBox)})
#~~< FetchCriterialabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$FetchCriterialabel = New-Object System.Windows.Forms.Label
$FetchCriterialabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$FetchCriterialabel.Location = New-Object System.Drawing.Point(6, 76)
$FetchCriterialabel.Size = New-Object System.Drawing.Size(98, 21)
$FetchCriterialabel.TabIndex = 12
$FetchCriterialabel.Text = "Fetch Criteria"
$FetchCriterialabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< SearchCriteriaTextbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$SearchCriteriaTextbox = New-Object System.Windows.Forms.TextBox
$SearchCriteriaTextbox.Location = New-Object System.Drawing.Point(6, 40)
$SearchCriteriaTextbox.Size = New-Object System.Drawing.Size(145, 20)
$SearchCriteriaTextbox.TabIndex = 11
$SearchCriteriaTextbox.Text = ""
$SearchCriteriaTextbox.add_TextChanged({SearchCriteriaTextChanged($SearchCriteriaTextbox)})
#~~< SearchCriterialabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$SearchCriterialabel = New-Object System.Windows.Forms.Label
$SearchCriterialabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$SearchCriterialabel.Location = New-Object System.Drawing.Point(6, 16)
$SearchCriterialabel.Size = New-Object System.Drawing.Size(98, 21)
$SearchCriterialabel.TabIndex = 11
$SearchCriterialabel.Text = "Search Keyword"
$SearchCriterialabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$FetchDetails.Controls.Add($CheckBoxFetchScheduledTask)
$FetchDetails.Controls.Add($CheckBoxFetchAppPool)
$FetchDetails.Controls.Add($CheckBoxFetchService)
$FetchDetails.Controls.Add($FetchAllServiceDetailsButton)
$FetchDetails.Controls.Add($FetchServiceDetailsButton)
$FetchDetails.Controls.Add($ServiceAccountCheckBox)
$FetchDetails.Controls.Add($ServiceNameCheckBox)
$FetchDetails.Controls.Add($DisplayNameCheckBox)
$FetchDetails.Controls.Add($FetchCriterialabel)
$FetchDetails.Controls.Add($SearchCriteriaTextbox)
$FetchDetails.Controls.Add($SearchCriterialabel)
#~~< LogtextBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogtextBox = New-Object System.Windows.Forms.TextBox
$LogtextBox.Location = New-Object System.Drawing.Point(428, 538)
$LogtextBox.Multiline = $true
$LogtextBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$LogtextBox.Size = New-Object System.Drawing.Size(753, 250)
$LogtextBox.TabIndex = 4
$LogtextBox.Text = ""
$LogtextBox.BackColor = [System.Drawing.SystemColors]::WindowText
$LogtextBox.ForeColor = [System.Drawing.SystemColors]::Window
$LogtextBox.add_TextChanged({savelog($LogtextBox)})
#~~< LogFileDetailsGroupBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogFileDetailsGroupBox = New-Object System.Windows.Forms.GroupBox
$LogFileDetailsGroupBox.Location = New-Object System.Drawing.Point(40, 506)
$LogFileDetailsGroupBox.Size = New-Object System.Drawing.Size(382, 282)
$LogFileDetailsGroupBox.TabIndex = 3
$LogFileDetailsGroupBox.TabStop = $false
$LogFileDetailsGroupBox.Text = "Log File Details"
#~~< OpenLogFileButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$OpenLogFileButton = New-Object System.Windows.Forms.Button
$OpenLogFileButton.Location = New-Object System.Drawing.Point(301, 97)
$OpenLogFileButton.Size = New-Object System.Drawing.Size(75, 23)
$OpenLogFileButton.TabIndex = 10
$OpenLogFileButton.Text = "Open"
$OpenLogFileButton.UseVisualStyleBackColor = $true
$OpenLogFileButton.add_Click({OnClickOpenLog($OpenLogFileButton)})
#~~< LogFileRefreshButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogFileRefreshButton = New-Object System.Windows.Forms.Button
$LogFileRefreshButton.Location = New-Object System.Drawing.Point(301, 68)
$LogFileRefreshButton.Size = New-Object System.Drawing.Size(75, 23)
$LogFileRefreshButton.TabIndex = 9
$LogFileRefreshButton.Text = "Refresh"
$LogFileRefreshButton.UseVisualStyleBackColor = $true
$LogFileRefreshButton.add_Click({OnClickRefreshFiles($LogFileRefreshButton)})
#~~< LogFileValidationlabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogFileValidationlabel = New-Object System.Windows.Forms.Label
$LogFileValidationlabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LogFileValidationlabel.Location = New-Object System.Drawing.Point(69, 45)
$LogFileValidationlabel.Size = New-Object System.Drawing.Size(171, 20)
$LogFileValidationlabel.TabIndex = 16
$LogFileValidationlabel.Text = "Valid Log Location"
$LogFileValidationlabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$LogFileValidationlabel.Visible = $false
$LogFileValidationlabel.ForeColor = [System.Drawing.Color]::Green
#~~< AllLogFilesListbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$AllLogFilesListbox = New-Object System.Windows.Forms.ListBox
$AllLogFilesListbox.FormattingEnabled = $true
$AllLogFilesListbox.Location = New-Object System.Drawing.Point(69, 68)
$AllLogFilesListbox.SelectedIndex = -1
$AllLogFilesListbox.Size = New-Object System.Drawing.Size(221, 199)
$AllLogFilesListbox.TabIndex = 15
$AllLogFilesListbox.Visible = $false
#~~< LogFileLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogFileLabel = New-Object System.Windows.Forms.Label
$LogFileLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$LogFileLabel.Location = New-Object System.Drawing.Point(6, 20)
$LogFileLabel.Size = New-Object System.Drawing.Size(49, 22)
$LogFileLabel.TabIndex = 14
$LogFileLabel.Text = "Log Files"
$LogFileLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< LogFileTextbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogFileTextbox = New-Object System.Windows.Forms.TextBox
$LogFileTextbox.Location = New-Object System.Drawing.Point(69, 22)
$LogFileTextbox.Size = New-Object System.Drawing.Size(221, 20)
$LogFileTextbox.TabIndex = 7
$LogFileTextbox.Text = ""
#~~< LogFileValidateButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$LogFileValidateButton = New-Object System.Windows.Forms.Button
$LogFileValidateButton.Location = New-Object System.Drawing.Point(301, 20)
$LogFileValidateButton.Size = New-Object System.Drawing.Size(75, 23)
$LogFileValidateButton.TabIndex = 8
$LogFileValidateButton.Text = "Validate"
$LogFileValidateButton.UseVisualStyleBackColor = $true
$LogFileValidateButton.add_Click({OnClickLogValidate($LogFileValidateButton)})
$LogFileDetailsGroupBox.Controls.Add($OpenLogFileButton)
$LogFileDetailsGroupBox.Controls.Add($LogFileRefreshButton)
$LogFileDetailsGroupBox.Controls.Add($LogFileValidationlabel)
$LogFileDetailsGroupBox.Controls.Add($AllLogFilesListbox)
$LogFileDetailsGroupBox.Controls.Add($LogFileLabel)
$LogFileDetailsGroupBox.Controls.Add($LogFileTextbox)
$LogFileDetailsGroupBox.Controls.Add($LogFileValidateButton)
#~~< InputFileGroupBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$InputFileGroupBox = New-Object System.Windows.Forms.GroupBox
$InputFileGroupBox.Location = New-Object System.Drawing.Point(40, 141)
$InputFileGroupBox.Size = New-Object System.Drawing.Size(335, 359)
$InputFileGroupBox.TabIndex = 2
$InputFileGroupBox.TabStop = $false
$InputFileGroupBox.Text = "Input File Details"
#~~< AutoFetchButon >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$AutoFetchButon = New-Object System.Windows.Forms.Button
$AutoFetchButon.Location = New-Object System.Drawing.Point(246, 38)
$AutoFetchButon.Size = New-Object System.Drawing.Size(75, 23)
$AutoFetchButon.TabIndex = 12
$AutoFetchButon.Text = "Auto Fetch"
$AutoFetchButon.UseVisualStyleBackColor = $true
$AutoFetchButon.add_Click({AutoFetchServers($AutoFetchButon)})
#~~< InputFileValidationlabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$InputFileValidationlabel = New-Object System.Windows.Forms.Label
$InputFileValidationlabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$InputFileValidationlabel.Location = New-Object System.Drawing.Point(69, 40)
$InputFileValidationlabel.Size = New-Object System.Drawing.Size(221, 20)
$InputFileValidationlabel.TabIndex = 11
$InputFileValidationlabel.Text = "Fetched Data From Input File"
$InputFileValidationlabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$InputFileValidationlabel.Visible = $false
$InputFileValidationlabel.ForeColor = [System.Drawing.Color]::Green
#~~< InputFileValueListbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$InputFileValueListbox = New-Object System.Windows.Forms.ListBox
$InputFileValueListbox.FormattingEnabled = $true
$InputFileValueListbox.Location = New-Object System.Drawing.Point(69, 63)
$InputFileValueListbox.SelectedIndex = -1
$InputFileValueListbox.Size = New-Object System.Drawing.Size(221, 290)
$InputFileValueListbox.TabIndex = 7
$InputFileValueListbox.Visible = $false
#~~< InputFileTextbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$InputFileTextbox = New-Object System.Windows.Forms.TextBox
$InputFileTextbox.Location = New-Object System.Drawing.Point(69, 17)
$InputFileTextbox.Size = New-Object System.Drawing.Size(171, 20)
$InputFileTextbox.TabIndex = 5
$InputFileTextbox.Text = ""
#~~< InputFileValidateButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$InputFileValidateButton = New-Object System.Windows.Forms.Button
$InputFileValidateButton.Location = New-Object System.Drawing.Point(246, 16)
$InputFileValidateButton.Size = New-Object System.Drawing.Size(75, 23)
$InputFileValidateButton.TabIndex = 6
$InputFileValidateButton.Text = "Validate"
$InputFileValidateButton.UseVisualStyleBackColor = $true
$InputFileValidateButton.add_Click({OnClickInputValidate($InputFileValidateButton)})
#~~< InputFileLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$InputFileLabel = New-Object System.Windows.Forms.Label
$InputFileLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$InputFileLabel.Location = New-Object System.Drawing.Point(6, 16)
$InputFileLabel.Size = New-Object System.Drawing.Size(57, 20)
$InputFileLabel.TabIndex = 6
$InputFileLabel.Text = "Input File"
$InputFileLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$InputFileGroupBox.Controls.Add($AutoFetchButon)
$InputFileGroupBox.Controls.Add($InputFileValidationlabel)
$InputFileGroupBox.Controls.Add($InputFileValueListbox)
$InputFileGroupBox.Controls.Add($InputFileTextbox)
$InputFileGroupBox.Controls.Add($InputFileValidateButton)
$InputFileGroupBox.Controls.Add($InputFileLabel)
#~~< AuthenticationGroupBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$AuthenticationGroupBox = New-Object System.Windows.Forms.GroupBox
$AuthenticationGroupBox.Location = New-Object System.Drawing.Point(40, 12)
$AuthenticationGroupBox.Size = New-Object System.Drawing.Size(431, 123)
$AuthenticationGroupBox.TabIndex = 1
$AuthenticationGroupBox.TabStop = $false
$AuthenticationGroupBox.Text = "Authentication"
#~~< AuthenticationStatusLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$AuthenticationStatusLabel = New-Object System.Windows.Forms.Label
$AuthenticationStatusLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$AuthenticationStatusLabel.Location = New-Object System.Drawing.Point(225, 64)
$AuthenticationStatusLabel.Size = New-Object System.Drawing.Size(166, 20)
$AuthenticationStatusLabel.TabIndex = 10
$AuthenticationStatusLabel.Text = ""
$AuthenticationStatusLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$AuthenticationStatusLabel.Visible = $false
$AuthenticationStatusLabel.ForeColor = [System.Drawing.Color]::Red
#~~< PasswordFailedLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$PasswordFailedLabel = New-Object System.Windows.Forms.Label
$PasswordFailedLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$PasswordFailedLabel.Location = New-Object System.Drawing.Point(225, 64)
$PasswordFailedLabel.Size = New-Object System.Drawing.Size(108, 20)
$PasswordFailedLabel.TabIndex = 9
$PasswordFailedLabel.Text = "Invalid Password"
$PasswordFailedLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$PasswordFailedLabel.Visible = $false
$PasswordFailedLabel.ForeColor = [System.Drawing.Color]::Red
#~~< UserNameFailedLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$UserNameFailedLabel = New-Object System.Windows.Forms.Label
$UserNameFailedLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$UserNameFailedLabel.Location = New-Object System.Drawing.Point(225, 39)
$UserNameFailedLabel.Size = New-Object System.Drawing.Size(98, 20)
$UserNameFailedLabel.TabIndex = 8
$UserNameFailedLabel.Text = "Invalid User ID"
$UserNameFailedLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$UserNameFailedLabel.Visible = $false
$UserNameFailedLabel.ForeColor = [System.Drawing.Color]::Red
#~~< ServiceAccountHeaderLable >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ServiceAccountHeaderLable = New-Object System.Windows.Forms.Label
$ServiceAccountHeaderLable.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$ServiceAccountHeaderLable.Location = New-Object System.Drawing.Point(71, 16)
$ServiceAccountHeaderLable.Size = New-Object System.Drawing.Size(143, 21)
$ServiceAccountHeaderLable.TabIndex = 7
$ServiceAccountHeaderLable.Text = "Service Account Details"
$ServiceAccountHeaderLable.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< SkipAuthenticationCheckBox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$SkipAuthenticationCheckBox = New-Object System.Windows.Forms.CheckBox
$SkipAuthenticationCheckBox.Location = New-Object System.Drawing.Point(306, 91)
$SkipAuthenticationCheckBox.Size = New-Object System.Drawing.Size(121, 24)
$SkipAuthenticationCheckBox.TabIndex = 4
$SkipAuthenticationCheckBox.Text = "Skip Authentication"
$SkipAuthenticationCheckBox.UseVisualStyleBackColor = $true
$SkipAuthenticationCheckBox.add_CheckedChanged({SkipAuthenticationCheckChanged($SkipAuthenticationCheckBox)})
#~~< DomainLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$DomainLabel = New-Object System.Windows.Forms.Label
$DomainLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$DomainLabel.Location = New-Object System.Drawing.Point(6, 92)
$DomainLabel.Size = New-Object System.Drawing.Size(57, 20)
$DomainLabel.TabIndex = 5
$DomainLabel.Text = "Domain"
$DomainLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< AuthenticateButton >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$AuthenticateButton = New-Object System.Windows.Forms.Button
$AuthenticateButton.Location = New-Object System.Drawing.Point(225, 93)
$AuthenticateButton.Size = New-Object System.Drawing.Size(75, 23)
$AuthenticateButton.TabIndex = 3
$AuthenticateButton.Text = "Authenticate"
$AuthenticateButton.UseVisualStyleBackColor = $true
$AuthenticateButton.add_Click({OnClickAuthenticate($AuthenticateButton)})
#~~< PasswordLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$PasswordLabel = New-Object System.Windows.Forms.Label
$PasswordLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$PasswordLabel.Location = New-Object System.Drawing.Point(6, 66)
$PasswordLabel.Size = New-Object System.Drawing.Size(57, 20)
$PasswordLabel.TabIndex = 4
$PasswordLabel.Text = "Password"
$PasswordLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< UserNameLabel >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$UserNameLabel = New-Object System.Windows.Forms.Label
$UserNameLabel.Font = New-Object System.Drawing.Font("Tahoma", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$UserNameLabel.Location = New-Object System.Drawing.Point(6, 39)
$UserNameLabel.Size = New-Object System.Drawing.Size(46, 20)
$UserNameLabel.TabIndex = 3
$UserNameLabel.Text = "User ID"
$UserNameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#~~< DomainCombobox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$DomainCombobox = New-Object System.Windows.Forms.ComboBox
$DomainCombobox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$DomainCombobox.FormattingEnabled = $true
$DomainCombobox.Location = New-Object System.Drawing.Point(69, 92)
$DomainCombobox.Size = New-Object System.Drawing.Size(145, 21)
$DomainCombobox.TabIndex = 2
$DomainCombobox.Text = "FCCDOMAIN"
$DomainCombobox.Items.AddRange([System.Object[]](@("FCCDOMAIN", "RRRDOMAIN", "SERVICING")))
$DomainCombobox.SelectedIndex = 0
#~~< PasswordTextbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$PasswordTextbox = New-Object System.Windows.Forms.TextBox
$PasswordTextbox.Location = New-Object System.Drawing.Point(69, 66)
$PasswordTextbox.Size = New-Object System.Drawing.Size(145, 20)
$PasswordTextbox.TabIndex = 1
$PasswordTextbox.Text = ""
$PasswordTextbox.UseSystemPasswordChar = $true
#~~< UserIDTextbox >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$UserIDTextbox = New-Object System.Windows.Forms.TextBox
$UserIDTextbox.Location = New-Object System.Drawing.Point(69, 40)
$UserIDTextbox.Size = New-Object System.Drawing.Size(145, 20)
$UserIDTextbox.TabIndex = 0
$UserIDTextbox.Text = ""
$AuthenticationGroupBox.Controls.Add($AuthenticationStatusLabel)
$AuthenticationGroupBox.Controls.Add($PasswordFailedLabel)
$AuthenticationGroupBox.Controls.Add($UserNameFailedLabel)
$AuthenticationGroupBox.Controls.Add($ServiceAccountHeaderLable)
$AuthenticationGroupBox.Controls.Add($SkipAuthenticationCheckBox)
$AuthenticationGroupBox.Controls.Add($DomainLabel)
$AuthenticationGroupBox.Controls.Add($AuthenticateButton)
$AuthenticationGroupBox.Controls.Add($PasswordLabel)
$AuthenticationGroupBox.Controls.Add($UserNameLabel)
$AuthenticationGroupBox.Controls.Add($DomainCombobox)
$AuthenticationGroupBox.Controls.Add($PasswordTextbox)
$AuthenticationGroupBox.Controls.Add($UserIDTextbox)
$WindowsServicePassChanger.Controls.Add($FetchedTaskDetails)
$WindowsServicePassChanger.Controls.Add($FetchedAppPoolDetails)
$WindowsServicePassChanger.Controls.Add($ResultBox)
$WindowsServicePassChanger.Controls.Add($ChangeServiceDetails)
$WindowsServicePassChanger.Controls.Add($FetchedServiceDetails)
$WindowsServicePassChanger.Controls.Add($FetchDetails)
$WindowsServicePassChanger.Controls.Add($LogtextBox)
$WindowsServicePassChanger.Controls.Add($LogFileDetailsGroupBox)
$WindowsServicePassChanger.Controls.Add($InputFileGroupBox)
$WindowsServicePassChanger.Controls.Add($AuthenticationGroupBox)

#endregion

#region Custom Code

#endregion

#region Event Loop

function Main{
	[System.Windows.Forms.Application]::EnableVisualStyles()
	[System.Windows.Forms.Application]::Run($WindowsServicePassChanger)
}

#endregion

#endregion

#region Event Handlers


function ChangeAccount($RemoteCompName, $RemoteService)
{
    #$command = "sc.exe `"\\" + $RemoteCompName + "`" config `"" + $RemoteService + "`" obj= `"" + $DomainCombobox.SelectedItem+ "\" + $UserIDTextbox.Text + "`" Password= `"" + $PasswordTextbox.Text + "`""
    #$Output = Invoke-Expression -Command $Command -ErrorAction StopWrite-Host "Getting the Service details"
    $User = $UserIDTextbox.Text
    $Domain = $DomainCombobox.SelectedItem
    $UserID = "$Domain\$User"
    $Pass= $PasswordTextbox.Text
    $svcD=gwmi win32_service -computername $RemoteCompName | Where-Object{$_.StartName -like "*$User*"} #| Format-Table
    Write-Host "Got the Service details"

    $svcD | ForEach-Object {

    $Value = $_.change($null,$null,$null,$null,$null,$null,"$UserID","$Pass",$null,$null,$null) 

    }
    if($Value.Returnvalue -eq 0)
    {
        return 1
    } 
    else 
    {
        return 0
    }   
    
}

function OnClickAuthenticate( )
{
    ShowYellow
    if ($UserIDTextbox.Text -eq "" -or $PasswordTextbox.Text -eq "")
    {
        $AuthenticationStatusLabel.Visible = $False
        if($UserIDTextbox.Text -eq "")
        {
            $UserNameFailedLabel.Visible = $True
        }
        else
        {
            $UserNameFailedLabel.Visible = $False
        }
        if($PasswordTextbox.Text -eq "")
        {
            $PasswordFailedLabel.Visible = $True
        }
        else
        {
            $PasswordFailedLabel.Visible = $False
        }
        $LogtextBox.AppendText("Invalid Credentials : " + $RunningUserName + "`n")
        ShowRed
        return 0
    }
    else
    {
        $UserNameFailedLabel.Visible = $False
        $PasswordFailedLabel.Visible = $False
        if(Authenticate $UserIDTextbox.Text $PasswordTextbox.Text $DomainCombobox.SelectedItem)
        {
            $AuthenticationStatusLabel.Text = "Authentication Successfull"
            $AuthenticationStatusLabel.ForeColor = "Green"
            $AuthenticationStatusLabel.Visible = $True
            $LogtextBox.AppendText("Authentication Success : " + $RunningUserName + "`n")
            ShowGreen
            ShowInput
            return 1
        }
        else
        {
            #HideInput
            #HideFetchDetails
            #HideLogFileDetails
            #HideOpenLogFileDetails
            #$InputFileValueListbox.Visible = $False
            #$FetchedServiceListbox.Visible = $False
            $AuthenticationStatusLabel.Text = "Authentication Failed"
            $AuthenticationStatusLabel.ForeColor = "Red"
            $AuthenticationStatusLabel.Visible = $True
            $LogtextBox.AppendText("Authentication Failed : " + $RunningUserName + "`n")
            ShowRed
            return 0
        }
    }
}

function AutoFetchServers()
{
    ShowYellow    
    $InputFileValueListbox.Items.Clear()
    $URI = "http://spsinfratoolboxAWS.sps.local/AppMap.svc"
    $proxy = New-WebServiceProxy -Uri $URI -Class holiday -Namespace webservice
    $Domain = $DomainCombobox.SelectedItem
    $UserID = $UserIDTextbox.Text
    $ServerDomain = [Environment]::UserDomainName
    $AccountDetailsTable = $proxy.GetServersForSQLSVCAccount("$UserID","$Domain","$ServerDomain")
    foreach($Row in $AccountDetailsTable.Tables[0].Rows)
    {
        #write-host "$($Row.ServerName) - $($Row.ServerDomain)   -  $($Row.UserID)"
        [void]$InputFileValueListbox.Items.Add($($Row.ServerName))
    }
    $InputFileValidationlabel.Visible = $True
    $InputFileValidationlabel.ForeColor = "Green"
	$InputFileValidationlabel.Text = "Auto Fetch Completed"
    ShowLogFileDetails
    $InputFileValueListbox.Visible = $true
    $LogtextBox.AppendText("Auto Fetch Success : " + $RunningUserName + "`n")
    EnableFetchAll
    ShowGreen
}

function OnClickInputValidate()
{
    ShowYellow
	if ($InputFileTextbox.Text -eq "")
	{
		$InputFileValidationlabel.Text = "Invalid input File"
		$InputFileValidationlabel.ForeColor = "Red"
		$InputFileValidationlabel.Visible = $True
		$FetchAllServiceDetailsButton.Visible = $False
		$InputFileValueListbox.Visible = $False
		$LogtextBox.AppendText("Invalid Input File : " + $RunningUserName + "`n")
		#HideFetchDetails
		HideLogFileDetails
		HideOpenLogFileDetails
		HideChangeAndRestart
		HideFetchDetails
		$FetchedServiceListbox.Visible = $False
		$FetchedServiceListLabel.Visible = $False
        ShowRed

	}
	else
	{
		$InputFileValidationlabel.Visible = $True
		if ((Test-Path $InputFileTextbox.Text) -and ($InputFileTextbox.Text.EndsWith("txt")))
		{
			$InputFileValidationlabel.ForeColor = "Green"
			$InputFileValidationlabel.Text = "Fetched Data From the Input File"
			$items = Get-Content $InputFileTextbox.Text
			$InputFileValueListbox.Items.Clear()
			if ($items –ne $Null)
			{
				foreach ($item in $items)
				{
					[void]$InputFileValueListbox.Items.Add($item)
				}
			}
			#ShowFetchDetails
			ShowLogFileDetails
			$InputFileValueListbox.Visible = $true
			$LogtextBox.AppendText("Input File Validation Success : " + $RunningUserName + "`n")
            ShowGreen
			            
		}
		else
		{
			$InputFileValidationlabel.ForeColor = "Red"
			$InputFileValidationlabel.Text = "Invalid input File"
			$FetchAllServiceDetailsButton.Visible = $False
			$InputFileValueListbox.Visible = $False
			$LogtextBox.AppendText("Input File Validation Failed : " + $RunningUserName + "`n")
			#HideFetchDetails
			HideLogFileDetails
			HideOpenLogFileDetails
			HideChangeAndRestart
			HideFetchDetails
			$FetchedServiceListbox.Visible = $False
			#$FetchedServiceListLabel.Visible = $False
            ShowRed
		}
	}
}

function OnClickFetchService()
{
    ShowYellow
    if($SkipAuthenticationCheckBox.Checked -eq $True)
    {
        if($InputFileValueListbox.SelectedItem -ne $null)
        {
            if($CheckBoxFetchService.Checked -eq $True)
            {
                $FetchedServiceListbox.Items.Clear()
                #A PowerShell array holds a list of data items
                $Result = @()
                #Loop through all SQL Instances listed under F:\PowerSQL\List.txt
                #List only sql related services, gwmi is an alias of Get-WmiObject
                $computerName = $InputFileValueListbox.SelectedItem
                if($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True -and $ServiceAccountCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Startname -like '*'+$UserIDTextbox.Text+'*'}
                }
                elseif($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($ServiceAccountCheckBox.Checked -eq $True -and $DisplayNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($ServiceAccountCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($ServiceAccountCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*'}
                }
                elseif($ServiceNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($DisplayNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                else
                {
                    $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem
                }
                #$Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                #Test for unsuccesful connection
                if(!(Test-Connection -Cn $InputFileValueListbox.SelectedItem -BufferSize 16 -Count 1 -ea 0 -quiet))
                {
                    echo “Problem still exists in connecting to $computerName” >> "E:\SQLExec\SPSFailfinal.txt"
                    $LogtextBox.AppendText("Failed to connect to the System $computerName : " + $RunningUserName + "`n")
                }
                else {
                $services | foreach {
                if ($_)
                { 
                    [void] $FetchedServiceListbox.Items.Add($computerName+"#"+$_.Name)
                $Result += New-Object PSObject -Property @{
                ‘Service Display Name’ = $_.Displayname
                ‘Service Name’ = $_.Name
                ‘start Mode’ = $_.Startmode
                ‘Service Account Name’ = $_.Startname
                ‘State’ = $_.State
                ‘Status’= $_.Status
                ‘System Name’ = $_.Systemname
                }
                }
                }
                }
                if($FetchedServiceListbox.Items.Count -eq 0)
                {
                    [void] $FetchedServiceListbox.Items.Add("No Services Found For the given Service Account")
                }
                $LogtextBox.AppendText("Service details Fetched from System $computerName : " + $RunningUserName + "`n")
                #$FetchedServiceListbox.Visible = $True
				#$FetchedServiceListLabel.Visible = $True
				#ShowFetchedServiceDetails
                #ShowChangeAndRestart
            }
            if($CheckBoxFetchAppPool.Checked -eq $True)
            {
                $FetchedAppPoolListBox.Items.Clear()
                $Result = @()
                $computerName = $InputFileValueListbox.SelectedItem

                $tmp = $NULL
                $tmp = Get-WmiObject -class IISApplicationPoolSetting -namespace "root\microsoftiisv2" -computer $computerName -authentication 6
                $PoolsThatMatch = @()
                if($DomainCombobox.SelectedItem -eq "FCCDOMAIN")
                {
                    if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "fairbankscapital.com\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "FCCDOMAIN\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@fairbankscapital.com"}}
                }
                elseif($DomainCombobox.SelectedItem -eq "SERVICING")
                {
                    if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "sps.local\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "servicing\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@sps.local"}}
                }
                else
                {
                    if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "rrrdomain.local\$($UserIDTextbox.Text)"}}
                }
                $Test = $PoolsThatMatch | select __Server,name,WAMUserName

                $Test | foreach {
                if ($_)
                { 
                    [void] $FetchedAppPoolListBox.Items.Add($computerName+"#"+$_.Name)
                $PoolsThatMatch += New-Object PSObject -Property @{
                ‘Server Name’ = $computerName
                ‘Application Pool’ = $_.Name
                ‘Application Pool Identity’ = $_.WAMUserName
                }
                }
                }
                if($FetchedAppPoolListBox.Items.Count -eq 0)
                {
                    [void] $FetchedAppPoolListBox.Items.Add("No Application Pools Service Account")
                }
                $LogtextBox.AppendText("Application Pool details Fetched from System $computerName : " + $RunningUserName + "`n") 
                #ShowFetchedAppPoolDetails               
            }
            if($CheckBoxFetchScheduledTask.Checked -eq $True)
            {
                #ShowFetchedScheduleTaskDetails
            }
            ShowFetchedDataDetails
            #ShowChangeAndRestart
            ShowChangeAndRestart
        }
        else
        {
            Write-Host "Invalid Selection"
            $LogtextBox.AppendText("Invalid Selection : " + $RunningUserName + "`n")
        }
    }
    else
    {
        if(OnClickAuthenticate)
        {
            if($InputFileValueListbox.SelectedItem -ne $null)
            {
                if($CheckBoxFetchService.Checked -eq $True)
                {
                    $FetchedServiceListbox.Items.Clear()
                    #A PowerShell array holds a list of data items
                    $Result = @()
                    #Loop through all SQL Instances listed under F:\PowerSQL\List.txt
                    #List only sql related services, gwmi is an alias of Get-WmiObject
                    $computerName = $InputFileValueListbox.SelectedItem
                    if($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True -and $ServiceAccountCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Startname -like '*'+$UserIDTextbox.Text+'*'}
                    }
                    elseif($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($ServiceAccountCheckBox.Checked -eq $True -and $DisplayNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($ServiceAccountCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($ServiceAccountCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*'}
                    }
                    elseif($ServiceNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($DisplayNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    else
                    {
                        $Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem
                    }
                    #$Services=gwmi win32_service -computername $InputFileValueListbox.SelectedItem | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    #Test for unsuccesful connection
                    if(!(Test-Connection -Cn $InputFileValueListbox.SelectedItem -BufferSize 16 -Count 1 -ea 0 -quiet))
                    {
                        echo “Problem still exists in connecting to $computerName” >> "E:\SQLExec\SPSFailfinal.txt"
                        $LogtextBox.AppendText("Failed to connect to the System $computerName : " + $RunningUserName + "`n")
                    }
                    else {
                    $services | foreach {
                    if ($_)
                    { 
                        [void] $FetchedServiceListbox.Items.Add($computerName+"#"+$_.Name)
                    $Result += New-Object PSObject -Property @{
                    ‘Service Display Name’ = $_.Displayname
                    ‘Service Name’ = $_.Name
                    ‘start Mode’ = $_.Startmode
                    ‘Service Account Name’ = $_.Startname
                    ‘State’ = $_.State
                    ‘Status’= $_.Status
                    ‘System Name’ = $_.Systemname
                    }
                    }
                    }
                    }
                    if($FetchedServiceListbox.Items.Count -eq 0)
                    {
                        [void] $FetchedServiceListbox.Items.Add("No Services Found For the given Service Account")
                    }
                    $LogtextBox.AppendText("Service details Fetched from System $computerName : " + $RunningUserName + "`n")
                    #$FetchedServiceListbox.Visible = $True
					     #$FetchedServiceListLabel.Visible = $True
					     #ShowFetchedServiceDetails
                    #ShowChangeAndRestart
                }
                if($CheckBoxFetchAppPool.Checked -eq $True)
                {
                    $FetchedAppPoolListBox.Items.Clear()
                    $Result = @()
                    $computerName = $InputFileValueListbox.SelectedItem

                    $tmp = $NULL
                    $tmp = Get-WmiObject -class IISApplicationPoolSetting -namespace "root\microsoftiisv2" -computer $computerName -authentication 6
                    $PoolsThatMatch = @()
                    if($DomainCombobox.SelectedItem -eq "FCCDOMAIN")
                    {
                        if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "fairbankscapital.com\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "FCCDOMAIN\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@fairbankscapital.com"}}
                    }
                    elseif($DomainCombobox.SelectedItem -eq "SERVICING")
                    {
                        if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "sps.local\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "servicing\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@sps.local"}}
                    }
                    else
                    {
                        if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "rrrdomain.local\$($UserIDTextbox.Text)"}}
                    }
                    $Test = $PoolsThatMatch | select __Server,name,WAMUserName

                    $Test | foreach {
                    if ($_)
                    { 
                        [void] $FetchedAppPoolListBox.Items.Add($computerName+"#"+$_.Name)
                    $PoolsThatMatch += New-Object PSObject -Property @{
                    ‘Server Name’ = $computerName
                    ‘Application Pool’ = $_.Name
                    ‘Application Pool Identity’ = $_.WAMUserName
                    }
                    }
                    }
                    if($FetchedAppPoolListBox.Items.Count -eq 0)
                    {
                        [void] $FetchedAppPoolListBox.Items.Add("No Application Pools Service Account")
                    }
                    $LogtextBox.AppendText("Application Pool details Fetched from System $computerName : " + $RunningUserName + "`n")
                    #ShowFetchedAppPoolDetails                
                }
                if($CheckBoxFetchScheduledTask.Checked -eq $True)
                {
                    #ShowFetchedScheduleTaskDetails
                }
                ShowFetchedDataDetails
                ShowChangeAndRestart
            }
            else
            {
                Write-Host "Invalid Selection"
                $LogtextBox.AppendText("Invalid Selection : " + $RunningUserName + "`n")
            }
        }
    }
    ShowGreen
}

function OnClickFetchAllService()
{
    ShowYellow
    if($SkipAuthenticationCheckBox.Checked -eq $True)
    {
        if($CheckBoxFetchService.Checked -eq $True)
        {
            $FetchedServiceListbox.Items.Clear()
            $Result = @()
            foreach($server in $InputFileValueListbox.Items)
            {
                if($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True -and $ServiceAccountCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Startname -like '*'+$UserIDTextbox.Text+'*'}
                }
                elseif($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($ServiceAccountCheckBox.Checked -eq $True -and $DisplayNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($ServiceAccountCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($ServiceAccountCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*'}
                }
                elseif($ServiceNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                elseif($DisplayNameCheckBox.Checked -eq $True)
                {
                    $Services=gwmi win32_service -computername $server | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                }
                else
                {
                    $Services=gwmi win32_service -computername $server
                }
                #$Services=gwmi win32_service -computername $server | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                #Test for unsuccesful connection
                if(!(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet))
                {
                    echo “Problem still exists in connecting to $server” >> "E:\SQLExec\SPSFailfinal.txt"
                    $LogtextBox.AppendText("Failed to connect to the System $Server : " + $RunningUserName + "`n")
                }
                else 
                {
                    $services | foreach {
                        if ($_)
                        { 
                            [void] $FetchedServiceListbox.Items.Add($server+"#"+$_.Name)
                            $Result += New-Object PSObject -Property @{
                                ‘Service Display Name’ = $_.Displayname
                                ‘Service Name’ = $_.Name
                                ‘start Mode’ = $_.Startmode
                                ‘Service Account Name’ = $_.Startname
                                ‘State’ = $_.State
                                ‘Status’= $_.Status
                                ‘System Name’ = $_.Systemname
                            }
                        }
                    }
                    $LogtextBox.AppendText("Service details Fetched from System $Server : " + $RunningUserName + "`n")
                }
            }      
            $today = Get-Date -format HHmmss
            $CSVFileName = "WindowsServiceLogFile_" + $today + ".csv"
            $Result |Export-Csv $SharedCSVFolder\$CSVFileName
            $Result |Export-Csv $LocalCSVFolder\$CSVFileName
            if($FetchedServiceListbox.Items.Count -eq 0)
            {
                [void] $FetchedServiceListbox.Items.Add("No Services Found For the given Service Account")
            }
            #$FetchedServiceListbox.Visible = $True
            #$FetchedServiceListLabel.Visible = $True
            #ShowFetchedServiceDetails
		    #ShowChangeAndRestart
        }
        if($CheckBoxFetchAppPool.Checked -eq $True)
        {
            $FetchedAppPoolListBox.Items.Clear()
            $ReasultAllPools = @()
            #$computerName = $InputFileValueListbox.SelectedItem
            foreach($computerName in $InputFileValueListbox.Items)
            {
                $tmp = $NULL
                $tmp = Get-WmiObject -class IISApplicationPoolSetting -namespace "root\microsoftiisv2" -computer $computerName -authentication 6
                $PoolsThatMatch = @()
                if($DomainCombobox.SelectedItem -eq "FCCDOMAIN")
                {
                    if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "fairbankscapital.com\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "FCCDOMAIN\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@fairbankscapital.com"}}
                }
                elseif($DomainCombobox.SelectedItem -eq "SERVICING")
                {
                    if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "sps.local\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "servicing\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@sps.local"}}
                }
                else
                {
                    if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "rrrdomain.local\$($UserIDTextbox.Text)"}}
                }
                $Test = $PoolsThatMatch | select __Server,name,WAMUserName

                $Test | foreach {
                if ($_)
                { 
                    [void] $FetchedAppPoolListBox.Items.Add($computerName+"#"+$_.Name)
                $ReasultAllPools += New-Object PSObject -Property @{
                ‘Server Name’ = $computerName
                ‘Application Pool’ = $_.Name
                ‘Application Pool Identity’ = $_.WAMUserName
                }
                }
                }

                $LogtextBox.AppendText("Application Pool details Fetched from System $computerName : " + $RunningUserName + "`n")   

            }
            $today = Get-Date -format HHmmss
            $ApppoolCSVFileName = ""
            $ApppoolCSVFileName = "AppPoolLogFile_" + $today + ".csv"
            $ReasultAllPools | Export-Csv $SharedCSVFolder\$ApppoolCSVFileName
            $ReasultAllPools | Export-Csv $LocalCSVFolder\$ApppoolCSVFileName
            if($FetchedAppPoolListBox.Items.Count -eq 0)
            {
                [void] $FetchedAppPoolListBox.Items.Add("No Application Pools Service Account")
            }
            #ShowFetchedAppPoolDetails
                         
        }
        if($CheckBoxFetchScheduledTask.Checked -eq $True)
        {
              ShowFetchedScheduleTaskDetails  
        }
        ShowFetchedDataDetails
        ShowChangeAndRestart
    }
    else
    {
        if(OnClickAuthenticate)
        {
            if($CheckBoxFetchService.Checked -eq $True)
            {
                $FetchedServiceListbox.Items.Clear()
                $Result = @()
                foreach($server in $InputFileValueListbox.Items)
                {

                    if($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True -and $ServiceAccountCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Startname -like '*'+$UserIDTextbox.Text+'*'}
                    }
                    elseif($DisplayNameCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($ServiceAccountCheckBox.Checked -eq $True -and $DisplayNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($ServiceAccountCheckBox.Checked -eq $True -and $ServiceNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*' -or $_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($ServiceAccountCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.Startname -like '*'+$UserIDTextbox.Text +'*'}
                    }
                    elseif($ServiceNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    elseif($DisplayNameCheckBox.Checked -eq $True)
                    {
                        $Services=gwmi win32_service -computername $server | where {$_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    }
                    else
                    {
                        $Services=gwmi win32_service -computername $server
                    }
                    #$Services=gwmi win32_service -computername $server | where {$_.Name -like '*'+$SearchCriteriaTextbox.Text+'*' -or $_.DisplayName -like '*'+$SearchCriteriaTextbox.Text+'*'}
                    #Test for unsuccesful connection
                    if(!(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet))
                    {
                        echo “Problem still exists in connecting to $server” >> "E:\SQLExec\SPSFailfinal.txt"
                        $LogtextBox.AppendText("Failed to connect to the System $Server : " + $RunningUserName + "`n")
                    }
                    else 
                    {
                        $services | foreach {
                            if ($_)
                            { 
                                [void] $FetchedServiceListbox.Items.Add($server+"#"+$_.Name)
                                $Result += New-Object PSObject -Property @{
                                    ‘Service Display Name’ = $_.Displayname
                                    ‘Service Name’ = $_.Name
                                    ‘start Mode’ = $_.Startmode
                                    ‘Service Account Name’ = $_.Startname
                                    ‘State’ = $_.State
                                    ‘Status’= $_.Status
                                    ‘System Name’ = $_.Systemname
                                }
                            }
                        }
                        $LogtextBox.AppendText("Service details Fetched from System $Server : " + $RunningUserName + "`n")
                    }
                }
                $today = Get-Date -format HHmmss
                $CSVFileName = "LogFile_" + $today + ".csv"
                $Result |Export-Csv $SharedCSVFolder\$CSVFileName
                $Result |Export-Csv $LocalCSVFolder\$CSVFileName
                if($FetchedServiceListbox.Items.Count -eq 0)
                {
                    [void] $FetchedServiceListbox.Items.Add("No Services Found For the given Service Account")
                }
                #$FetchedServiceListbox.Visible = $True
                #$FetchedServiceListLabel.Visible = $True
                #ShowFetchedServiceDetails
			    #ShowChangeAndRestart
            }
            if($CheckBoxFetchAppPool.Checked -eq $True)
            {
                $FetchedAppPoolListBox.Items.Clear()
                $ReasultAllPools = @()
                #$computerName = $InputFileValueListbox.SelectedItem
                foreach($computerName in $InputFileValueListbox.Items)
                {
                    $tmp = $NULL
                    $tmp = Get-WmiObject -class IISApplicationPoolSetting -namespace "root\microsoftiisv2" -computer $computerName -authentication 6
                    $PoolsThatMatch = @()
                    if($DomainCombobox.SelectedItem -eq "FCCDOMAIN")
                    {
                        if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "fairbankscapital.com\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "FCCDOMAIN\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@fairbankscapital.com"}}
                    }
                    elseif($DomainCombobox.SelectedItem -eq "SERVICING")
                    {
                        if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "sps.local\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "servicing\$($UserIDTextbox.Text)" -or $_.WAMUserName -like "$($UserIDTextbox.Text)@sps.local"}}
                    }
                    else
                    {
                        if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "rrrdomain.local\$($UserIDTextbox.Text)"}}
                    }
                    $Test = $PoolsThatMatch | select __Server,name,WAMUserName

                    $Test | foreach {
                    if ($_)
                    { 
                        [void] $FetchedAppPoolListBox.Items.Add($computerName+"#"+$_.Name)
                    $ReasultAllPools += New-Object PSObject -Property @{
                    ‘Server Name’ = $computerName
                    ‘Application Pool’ = $_.Name
                    ‘Application Pool Identity’ = $_.WAMUserName
                    }
                    }
                    }

                    $LogtextBox.AppendText("Application Pool details Fetched from System $computerName : " + $RunningUserName + "`n")   

                }
                $today = Get-Date -format HHmmss
                $ApppoolCSVFileName = "AppPoolLogFile_" + $today + ".csv"
                $ReasultAllPools | Export-Csv "$SharedCSVFolder\$CSVFileName"
                $ReasultAllPools | Export-Csv "$LocalCSVFolder\$CSVFileName"
                if($FetchedAppPoolListBox.Items.Count -eq 0)
                {
                    [void] $FetchedAppPoolListBox.Items.Add("No Application Pools Service Account")
                }
                #ShowFetchedAppPoolDetails
                         
            }
            if($CheckBoxFetchScheduledTask.Checked -eq $True)
            {
                  #ShowFetchedScheduleTaskDetails  
            }
            ShowFetchedDataDetails
            ShowChangeAndRestart
        }
    }
    ShowGreen
}

function OnClickLogValidate()
{
	ShowYellow
    if ($LogFileTextbox.Text.substring($LogFileTextbox.Text.Length -5, 5).Contains("."))
	{
		Write-Host "Invalid Folder Location"
		HideOpenLogFileDetails
		HideFetchDetails
		$LogFileValidationlabel.Text = "Invalid Log path"
		$LogFileValidationlabel.ForeColor = "Red"
		$LogFileValidationlabel.Visible = $True
		$FetchedServiceListbox.Visible = $False
		$FetchedServiceListLabel.Visible = $False
		HideChangeAndRestart
		$LogtextBox.AppendText("Invalid Log Folder Location : " + $RunningUserName + "`n")
        ShowRed
		return 0
	}
	else
	{
		if (($LogFileTextbox.Text -ne "") -and (Test-Path $LogFileTextbox.Text))
		{
			ShowFetchDetails
			ShowOpenLogFileDetails
			$AllLogFilesListbox.Items.Clear()
			$LogFiles = @()
			$LogFileValidationlabel.Text = "Valid Log path"
			$LogFileValidationlabel.ForeColor = "Green"
			$LogFileValidationlabel.Visible = $True
			$LogFiles += Get-ChildItem $LogFileTextbox.Text | select FullName
			for ($i = 0 ; $i -le $LogFiles.count -1 ; $i++)
			{
				$AllLogFilesListbox.Items.Add($LogFiles[$i].FullName)
			}
			$LogtextBox.AppendText("Log File loation validated and files refreshed in the system $computerName : " + $RunningUserName + "`n")
            ShowGreen
			return 1
		}
		else
		{
			HideOpenLogFileDetails
			HideFetchDetails
			$LogFileValidationlabel.Text = "Invalid Log path"
			$LogFileValidationlabel.ForeColor = "Red"
			$LogFileValidationlabel.Visible = $True
			$FetchedServiceListbox.Visible = $False
			$FetchedServiceListLabel.Visible = $False
			HideChangeAndRestart
			$LogtextBox.AppendText("Invalid Log Folder Location : " + $RunningUserName + "`n")
            ShowRed
			return 0
		}
	}
	    
}

function OnClickRefreshFiles()
{
	OnClickLogValidate
}

function OnClickOpenLog()
{
	if ($AllLogFilesListbox.SelectedItem -ne "")
	{
		Invoke-Item $AllLogFilesListbox.SelectedItem
		$LogtextBox.AppendText("Opened Log File " + $AllLogFilesListbox.SelectedItem + " : " + $RunningUserName + "`n")
	}
}

function HideLogFileDetails()
{
	#$LogFileHeaderlabel.Visible = $False
	$LogFileValidationlabel.Visible = $False
	$LogFileValidateButton.Visible = $False
	$LogFileLabel.Visible = $False
	$LogFileTextbox.Visible = $False
	$LogFileDetailsGroupBox.Visible = $False
}

function ShowLogFileDetails()
{
	#$LogFileHeaderlabel.Visible = $True
	#$LogFileValidationlabel.Visible = $True
	$LogFileValidateButton.Visible = $True
	$LogFileLabel.Visible = $True
	$LogFileTextbox.Visible = $True
	$LogFileDetailsGroupBox.Visible = $True
}

function HideFetchDetails()
{
	$FetchServiceDetailsButton.Visible = $False
	$ServiceAccountCheckBox.Visible = $False
	$ServiceNameCheckBox.Visible = $False
	$DisplayNameCheckBox.Visible = $False
	$FetchCriterialabel.Visible = $False
	$SearchCriterialabel.Visible = $False
	$SearchCriteriaTextbox.Visible = $False
	$FetchAllServiceDetailsButton.Visible = $False
	$FetchDetails.Visible = $False
	
}

function ShowFetchDetails()
{
	$FetchServiceDetailsButton.Visible = $True
	$ServiceAccountCheckBox.Visible = $True
	$ServiceNameCheckBox.Visible = $true
	$DisplayNameCheckBox.Visible = $True
	$FetchCriterialabel.Visible = $True
	$SearchCriterialabel.Visible = $True
	$SearchCriteriaTextbox.Visible = $true
    $FetchAllServiceDetailsButton.Visible = $True
	EnableFetchAll
	$FetchDetails.Visible = $True
}

function EnableFetchAll()
{
    if ($InputFileValueListbox.Items.Count -lt 2)
	{
		$FetchAllServiceDetailsButton.Enabled = $flase
		#Write-Host $InputFileValueListbox.Items.Count
	}
    else
    {
		$FetchAllServiceDetailsButton.Enabled = $true
		#Write-Host $InputFileValueListbox.Items.Count
	}
}

function ShowInput()
{
	#$InputFileHeaderlabel.Visible = $True
	$InputFileTextbox.Visible = $True
	$InputFileLabel.Visible = $True
	$InputFileValidateButton.Visible = $True
	#$InputFileValidationlabel.Visible = $True
	$InputFileGroupBox.Visible = $True
    
}

function HideInput()
{
	#$InputFileHeaderlabel.Visible = $False
	$InputFileTextbox.Visible = $False
	$InputFileLabel.Visible = $False
	$InputFileValidateButton.Visible = $False
	$InputFileValidationlabel.Visible = $False
	$InputFileGroupBox.Visible = $false
}

#Function to Hide Log File details
function HideOpenLogFileDetails()
{
	$OpenLogFileButton.Visible = $False
	$AllLogFilesListbox.Visible = $False
	$LogFileRefreshButton.Visible = $False
}

#Function to Show Log File details
function ShowOpenLogFileDetails()
{
	$OpenLogFileButton.Visible = $True
	$AllLogFilesListbox.Visible = $True
	$LogFileRefreshButton.Visible = $True
}

#Function to hide change and restart details
function HideChangeAndRestart()
{
	$RestartRadioButtonLabel.Visible = $False
	$RestartYesRadioButton.Visible = $False
	$RestartNoRadioButton.Visible = $False
	$ChangeServiceAccountButton.Visible = $False
	$ChangeAllServiceAccountButton.Visible = $False
	$ChangeServiceDetails.Visible = $False
}

#Function to Show change and restart details
function ShowChangeAndRestart()
{
	$RestartRadioButtonLabel.Visible = $True
	$RestartYesRadioButton.Visible = $True
	$RestartNoRadioButton.Visible = $True
	$ChangeServiceAccountButton.Visible = $True
	$ChangeAllServiceAccountButton.Visible = $True
	#$ChangeServiceDetails.Visible = $True
    if($FetchedServiceListbox.Items.Count -ne 0 -or $FetchedAppPoolListBox.Items.Count -ne 0 -or $FetchedTaskListBox.Items.Count -ne 0)
    {
        $ChangeServiceDetails.Visible = $True
        EnableDisableChangeAndRestart       
    }
}

function EnableDisableChangeAndRestart()
{
    if($FetchedServiceListbox.Items.Count -ne 0)
    {
    	$RestartRadioButtonLabel.Enabled = $True
	    $RestartYesRadioButton.Enabled = $True
	    $RestartNoRadioButton.Enabled = $True
	    $ChangeServiceAccountButton.Enabled = $True
	    $ChangeAllServiceAccountButton.Enabled = $True
        $RestartSerrviceButton.Enabled = $True
        $StartServiceButton.Enabled = $True
        $StopServiceButton.Enabled = $True
    }
    else
    {
    	$RestartRadioButtonLabel.Enabled = $False
	    $RestartYesRadioButton.Enabled = $False
	    $RestartNoRadioButton.Enabled = $False
	    $ChangeServiceAccountButton.Enabled = $False
	    $ChangeAllServiceAccountButton.Enabled = $False
        $RestartSerrviceButton.Enabled = $False
        $StartServiceButton.Enabled = $False
        $StopServiceButton.Enabled = $False       
    }
    if($FetchedAppPoolListBox.Items.Count -ne 0)
    {
        $ChangeAppPoolButton.Enabled = $True
    }
    else
    {
        $ChangeAppPoolButton.Enabled = $False
    }
    if($FetchedTaskListBox.Items.Count -ne 0)
    {
        $ChangeScheduleTaskButton.Enabled = $True
    }
    else
    {
        $ChangeScheduleTaskButton.Enabled = $False
    }
    if($SkipAuthenticationCheckBox.Checked -eq $true)
    {
        $RestartRadioButtonLabel.Enabled = $False
	    $RestartYesRadioButton.Enabled = $False
	    $RestartNoRadioButton.Enabled = $False
	    $ChangeServiceAccountButton.Enabled = $False
	    $ChangeAllServiceAccountButton.Enabled = $False
        $RestartSerrviceButton.Enabled = $False
        $StartServiceButton.Enabled = $False
        $StopServiceButton.Enabled = $False
        $ChangeAppPoolButton.Enabled = $False
        $ChangeScheduleTaskButton.Enabled = $False
    }
}

<#function ShowFetchedServiceDetails()
{
	$FetchedServiceDetails.Visible = $True
}

function ShowFetchedAppPoolDetails()
{
	$FetchedAppPoolDetails.Visible = $True
}

function ShowFetchedScheduleTaskDetails()
{
	$FetchedTaskDetails.Visible = $True
}

function HideFetchedServiceDetails( )
{
	$FetchedServiceDetails.Visible = $False
}#>

function HideFetchedDataDetails()
{
	$FetchedTaskDetails.Visible = $False
    $FetchedAppPoolDetails.Visible = $False
    $FetchedServiceDetails.Visible = $False
}

function ShowFetchedDataDetails()
{
	$FetchedTaskDetails.Visible = $True
    $FetchedAppPoolDetails.Visible = $True
    $FetchedServiceDetails.Visible = $True
}
#Function for Account credentials change for the service

function ChangeLogonAccount()
{
    ShowYellow   
    $RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    if(OnclickAuthenticate)
    {
        if(ChangeAccount $RemoteCompName $RemoteService)
        {
            Write-Host "$RemoteCompName : Successfully changed the logon credentials for $RemoteService service" -foregroundcolor green
            $LogtextBox.AppendText("$RemoteCompName : Successfully changed the logon credentials for $RemoteService service : " + $RunningUserName + "`n")
            #$successcomputers +=$ComputerName
            if($RestartYesRadioButton.checked -eq $True)
            {
                RestartService
            }

        }
        else
        {
            Write-Host "$RemoteCompName : Failed to change the logon credentials for $RemoteService
            More details: $Output" -foregroundcolor red
            $LogtextBox.AppendText("$RemoteCompName : Failed to change the logon credentials for $RemoteService service : " + $RunningUserName + "`n")
            #$failedcomputers +=$ComputerName
        }
    }
    ShowGreen 
}
function ChangeAllLogonAccount()
{
    ShowYellow
    foreach($item in $FetchedServiceListbox.Items)
    {
        $RemoteCompName = ($item -split "#")[0]
        $RemoteService = ($item -split "#")[1]
        Write-Host $RemoteCompName
        Write-Host $RemoteService
        if(OnclickAuthenticate)
        {
            if(ChangeAccount $RemoteCompName $RemoteService)
            {
                Write-Host "$RemoteCompName : Successfully changed the logon credentials for $RemoteService service" -foregroundcolor green
                $LogtextBox.AppendText("$RemoteCompName : Successfully changed the logon credentials for $RemoteService service : " + $RunningUserName + "`n")
                #$successcomputers +=$ComputerName
                if($RestartYesRadioButton.checked -eq $True)
                {
                    RestartServiceChangeAll "$RemoteCompName" "$RemoteService"
                }

            }
            else
            {
                Write-Host "$RemoteCompName : Failed to change the logon credentials for $RemoteService
                More details: $Output" -foregroundcolor red
                $LogtextBox.AppendText("$RemoteCompName : Failed to change the logon credentials for $RemoteService service : " + $RunningUserName + "`n")
                #$failedcomputers +=$ComputerName
            }
        }
    }
    ShowGreen 
    <#$RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    if(OnclickAuthenticate)
    {
        if(ChangeAccount $RemoteCompName $RemoteService)
        {
            Write-Host "$RemoteCompName : Successfully changed the logon credentials for $RemoteService service" -foregroundcolor green
            $LogtextBox.AppendText("$RemoteCompName : Successfully changed the logon credentials for $RemoteService service : " + $RunningUserName + "`n")
            #$successcomputers +=$ComputerName
            if($RestartYesRadioButton.checked -eq $True)
            {
                RestartService
            }

        }
        else
        {
            Write-Host "$RemoteCompName : Failed to change the logon credentials for $RemoteService
            More details: $Output" -foregroundcolor red
            $LogtextBox.AppendText("$RemoteCompName : Failed to change the logon credentials for $RemoteService service : " + $RunningUserName + "`n")
            #$failedcomputers +=$ComputerName
        }
    }#>
}

#Function to restart the service after changing the credentials and doing a proper validation of the credentials
function RestartService()
{
 
    $RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    #$service = Get-Service -ComputerName "$RemoteCompName" -name $RemoteService
    $service = Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}
    #if((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
    if((Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}).status -eq 'Running')
    {
        Write-Host "Attempting to Stop Service $($RemoteService) on Server $RemoteCompName" -ForegroundColor Green
        $LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
        $service.stop()
        #$LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
        do
        {
            $LogtextBox.AppendText(".")
            Start-Sleep -Milliseconds 100
        }
        until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Stopped')
        $LogtextBox.AppendText("`n")
        Write-Host "$RemoteCompName : Successfully stpooed $RemoteService service" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully stopped $RemoteService service : " + $RunningUserName + "`n")
        Write-Host "Attempting to Start the Service $($RemoteService) on Server $RemoteCompName" -ForegroundColor Green
        $LogtextBox.AppendText("$RemoteCompName : Startig $RemoteService service...")
        #Start-Sleep -Milliseconds 10
        $service.start()
        do
        {
            $LogtextBox.AppendText(".")
            Start-Sleep -Milliseconds 200
            $ExitBit=""
            try{$ExitBit = Get-IniValue "$PSScriptRoot\Params.ini" "Break" "ExitBit"}
            catch{}
            if($ExitBit -eq "1")
            {
                $LogtextBox.AppendText("`n")
                Write-Host "Loop Exited without checking the service status because of ExitBit" -foregroundcolor green
                $LogtextBox.AppendText("$RemoteCompName : Loop Exited without checking the service status because of ExitBit : " + $RunningUserName + "`n")
                break
            }
        }
        until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
        $LogtextBox.AppendText("`n")
        Write-Host "$RemoteCompName : Successfully started $RemoteService service" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully Started $RemoteService service : " + $RunningUserName + "`n")
    }


    
}

#Function to restart the service after changing the credentials and doing a proper validation of the credentials for Change All Account Click
function RestartServiceChangeAll($CompName, $svcname)
{
 
    $RemoteCompName = $CompName
    $RemoteService = $svcname
    #$service = Get-Service -ComputerName "$RemoteCompName" -name $RemoteService
    $service = Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}
    #if((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
    if((Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}).status -eq 'Running')
    {
        Write-Host "Attempting to Stop Service $($RemoteService) on Server $RemoteCompName" -ForegroundColor Green
        $LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
        $service.stop()
        #$LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
        do
        {
            $LogtextBox.AppendText(".")
            Start-Sleep -Milliseconds 100
            $ExitBit=""
            try{$ExitBit = Get-IniValue "$PSScriptRoot\Params.ini" "Break" "ExitBit"}
            catch{}
            if($ExitBit -eq "1")
            {
                $LogtextBox.AppendText("`n")
                Write-Host "Loop Exited without checking the service status because of ExitBit" -foregroundcolor green
                $LogtextBox.AppendText("$RemoteCompName : Loop Exited without checking the service status because of ExitBit : " + $RunningUserName + "`n")
                break
            }
        }
        until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Stopped')
        $LogtextBox.AppendText("`n")
        Write-Host "$RemoteCompName : Successfully stpooed $RemoteService service" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully stopped $RemoteService service : " + $RunningUserName + "`n")
        Write-Host "Attempting to Start the Service $($RemoteService) on Server $RemoteCompName" -ForegroundColor Green
        $LogtextBox.AppendText("$RemoteCompName : Startig $RemoteService service...")
        #Start-Sleep -Milliseconds 10
        $service.start()
        do
        {
            $LogtextBox.AppendText(".")
            Start-Sleep -Milliseconds 200
            $ExitBit=""
            try{$ExitBit = Get-IniValue "$PSScriptRoot\Params.ini" "Break" "ExitBit"}
            catch{}
            if($ExitBit -eq "1")
            {
                $LogtextBox.AppendText("`n")
                Write-Host "Loop Exited without checking the service status because of ExitBit" -foregroundcolor green
                $LogtextBox.AppendText("$RemoteCompName : Loop Exited without checking the service status because of ExitBit : " + $RunningUserName + "`n")
                break
            }
        }
        until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
        $LogtextBox.AppendText("`n")
        Write-Host "$RemoteCompName : Successfully started $RemoteService service" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully Started $RemoteService service : " + $RunningUserName + "`n")
    }  
}

#Finction to stop a service using sc.exe
function StopService()
{
    <#$RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    #Write-Host $RemoteCompName
    $command = "sc.exe \\" + $RemoteCompName + " stop " + $RemoteService
    $LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
    $Output = Invoke-Expression -Command $Command -ErrorAction Stop
    do
    { 
        $LogtextBox.AppendText(".")
        Start-Sleep -Milliseconds 200
    }
    until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Stopped')
    $LogtextBox.AppendText("`n")
    if($LASTEXITCODE -ne 0)
    {
        Write-Host "$RemoteCompName : Failed to start $RemoteService
        More details: $Output" -foregroundcolor red
        $LogtextBox.AppendText("$RemoteCompName : Failed to stop $Service service : " + $RunningUserName + "`n")
        #$failedcomputers +=$ComputerName
    } 
    else 
    {
        Write-Host "$RemoteCompName : Successfully changed $Service service to delayed start" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully stopped $Service service : " + $RunningUserName + "`n")
        #$successcomputers +=$ComputerName
    }#>
    $RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    #$service = Get-Service -ComputerName "$RemoteCompName" -name $RemoteService
    $service = Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}
    #if((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
    if((Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}).status -eq 'Running')
    {
        Write-Host "Attempting to Stop Service $($RemoteService) on Server $RemoteCompName" -ForegroundColor Green
        $LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
        $service.stop()
        #$LogtextBox.AppendText("$RemoteCompName : Stopping $RemoteService service...")
        do
        {
            $LogtextBox.AppendText(".")
            Start-Sleep -Milliseconds 100
            $ExitBit=""
            try{$ExitBit = Get-IniValue "$PSScriptRoot\Params.ini" "Break" "ExitBit"}
            catch{}
            if($ExitBit -eq "1")
            {
                $LogtextBox.AppendText("`n")
                Write-Host "Loop Exited without checking the service status because of ExitBit" -foregroundcolor green
                $LogtextBox.AppendText("$RemoteCompName : Loop Exited without checking the service status because of ExitBit : " + $RunningUserName + "`n")
                break
            }
        }
        until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Stopped')
        $LogtextBox.AppendText("`n")
        Write-Host "$RemoteCompName : Successfully stpooed $RemoteService service" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully stopped $RemoteService service : " + $RunningUserName + "`n")
    }
}

#Finction to start a service using sc.exe
function StartService()
{
    <#$RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    #Write-Host $RemoteCompName
    $command = "sc.exe \\" + $RemoteCompName + " start " + $RemoteService
    $LogtextBox.AppendText("$RemoteCompName : Starting $RemoteService service...")
    $Output = Invoke-Expression -Command $Command -ErrorAction Stop
    do
    { 
        $LogtextBox.AppendText(".")
        Start-Sleep -Milliseconds 200
    }
    until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
    $LogtextBox.AppendText("`n")
    if($LASTEXITCODE -ne 0)
    {
        Write-Host "$RemoteCompName : Failed to start $RemoteService
        More details: $Output" -foregroundcolor red
        $LogtextBox.AppendText("$RemoteCompName : Failed to start $Service service : " + $RunningUserName + "`n")
        #$failedcomputers +=$ComputerName
    } 
    else 
    {
        Write-Host "$RemoteCompName : Successfully changed $Service service to delayed start" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully Started $Service service : " + $RunningUserName + "`n")
        #$successcomputers +=$ComputerName
    }#>
    $RemoteCompName = ($FetchedServiceListbox.SelectedItem -split "#")[0]
    $RemoteService = ($FetchedServiceListbox.SelectedItem -split "#")[1]
    #$service = Get-Service -ComputerName "$RemoteCompName" -name $RemoteService
    $service = Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}
    #if((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Stopped')
    if((Get-Service -ComputerName "$RemoteCompName" | Where-Object{$_.Name -eq "$RemoteService"}).status -eq 'Stopped')
    {
        Write-Host "Attempting to Start the Service $($RemoteService) on Server $RemoteCompName" -ForegroundColor Green
        $LogtextBox.AppendText("$RemoteCompName : Startig $RemoteService service...")
        #Start-Sleep -Milliseconds 10
        $service.start()
        do
        {
            $LogtextBox.AppendText(".")
            Start-Sleep -Milliseconds 200
            $ExitBit=""
            try{$ExitBit = Get-IniValue "$PSScriptRoot\Params.ini" "Break" "ExitBit"}
            catch{}
            if($ExitBit -eq "1")
            {
                $LogtextBox.AppendText("`n")
                Write-Host "Loop Exited without checking the service status because of ExitBit" -foregroundcolor green
                $LogtextBox.AppendText("$RemoteCompName : Loop Exited without checking the service status because of ExitBit : " + $RunningUserName + "`n")
                break
            }
        }
        until ((Get-Service -ComputerName "$RemoteCompName" -Name $RemoteService).status -eq 'Running')
        $LogtextBox.AppendText("`n")
        Write-Host "$RemoteCompName : Successfully started $RemoteService service" -foregroundcolor green
        $LogtextBox.AppendText("$RemoteCompName : Successfully Started $RemoteService service : " + $RunningUserName + "`n")
    }
}

function SkipAuthenticationCheckChanged()
{
    if($SkipAuthenticationCheckBox.Checked -eq $True)
    {
        $AuthenticateButton.Enabled = $False
        $LogtextBox.AppendText("Authentication Skipped, Demo Mode Activated : " + $RunningUserName + "`n")
        $ChangeServiceAccountButton.Enabled = $False
        $ChangeAllServiceAccountButton.Enabled = $False
        ShowInput
    }
    else
    {
        $AuthenticateButton.Enabled = $True
        $LogtextBox.AppendText("Authentication Enabled, Demo Mode Deactivated : " + $RunningUserName + "`n")
        $ChangeServiceAccountButton.Enabled = $True
        $ChangeAllServiceAccountButton.Enabled = $True

    }
}

function ServiceRestartCheckChanged()
{
    if($RestartYesRadioButton.Checked -eq $True)
    {
        $LogtextBox.AppendText("Restarting the service after credential change has been Enabled : " + $RunningUserName + "`n")
    }
    else
    {
        $LogtextBox.AppendText("Restarting the service after credential change has been Disabled : " + $RunningUserName + "`n")
    }
}

function SearchCriteriaTextChanged()
{
    if($SearchCriteriaTextbox.Text -eq "")
    {
        $DisplayNameCheckBox.Checked = $False
        $ServiceNameCheckBox.Checked = $False
    }
}

function DisplayNameCheckBoxCheckChanged()
{
    if($SearchCriteriaTextbox.Text -eq "")
    {
        $DisplayNameCheckBox.Checked = $False
        $LogtextBox.AppendText("Please Enter the search Criteria : " + $RunningUserName + "`n")
    }
    else
    {
        $LogtextBox.AppendText("Fetch Criteria Changed : " + $RunningUserName + "`n")
    }
    if($DisplayNameCheckBox.Checked -eq $True)
    {
        $ChangeServiceAccountButton.Enabled = $False
        $ChangeAllServiceAccountButton.Enabled = $False
    }
    else
    {
        $ChangeServiceAccountButton.Enabled = $True
        $ChangeAllServiceAccountButton.Enabled = $True
    }
}

function ServiceNameCheckBoxCheckChanged()
{
    if($SearchCriteriaTextbox.Text -eq "")
    {
        $ServiceNameCheckBox.Checked = $False
        $LogtextBox.AppendText("Please Enter the search Criteria : " + $RunningUserName + "`n")
    }
    else
    {
        $LogtextBox.AppendText("Fetch Criteria Changed : " + $RunningUserName + "`n")
    }
    if($ServiceNameCheckBox.Checked -eq $True)
    {
        $ChangeServiceAccountButton.Enabled = $False
        $ChangeAllServiceAccountButton.Enabled = $False
    }
    else
    {
        $ChangeServiceAccountButton.Enabled = $True
        $ChangeAllServiceAccountButton.Enabled = $True
    }
}

function ServiceAccountCheckChanged()
{
    if($ServiceAccountCheckBox.Checked -eq $True)
    {
        if($SkipAuthenticationCheckBox.Checked -eq $True)
        {
            if($UserIDTextbox.Text -eq "")
            {
                $ServiceAccountCheckBox.Checked = $False
                $LogtextBox.AppendText("Invalid Serive Account Credentials : " + $RunningUserName + "`n")
            }
            else
            {
                $LogtextBox.AppendText("Fetch Criteria Changed : " + $RunningUserName + "`n")
            }
        }
        else
        {
            if(OnClickAuthenticate)
            {
                $LogtextBox.AppendText("Fetch Criteria Changed : " + $RunningUserName + "`n")
            }
            else
            {
                $ServiceAccountCheckBox.Checked = $False
                $LogtextBox.AppendText("Invalid Serive Account Credentials : " + $RunningUserName + "`n")
            }

        }
    }
}

function SetGlobalVars()
{
    #$setvariables = 0
    Showyellow
    $LogFileTextbox.Text = $LocalLog
    $InputFileTextbox.Text = $LocalInput
    write-host $SharedLogFile
    if(Test-Path $SharedCSVFolder)
    {
        $LogtextBox.AppendText("Shared Log Folder already present : $SharedCSVFolder :" + $RunningUserName + "`n")
        ShowGreen
    }
    else
    {
        try{
            New-Item $SharedCSVFolder -type directory
            $LogtextBox.AppendText("Shared Log Folder created : $SharedCSVFolder :" + $RunningUserName + "`n")
        }
        catch{
            $LogtextBox.AppendText("Shared Log Folder creation failed : $SharedCSVFolder :" + $RunningUserName + "`n")
            ShowRed             
        }
    }
    if(Test-Path $LocalCSVFolder)
    {
        $LogtextBox.AppendText("Local Log Folder already present : $LocalCSVFolder :" + $RunningUserName + "`n")
        ShowGreen
    }
    else
    {
        try{
            New-Item $LocalCSVFolder -type directory
            $LogtextBox.AppendText("Local Log Folder created : $LocalCSVFolder :" + $RunningUserName + "`n")
            ShowGreen
        }
        catch{
            $LogtextBox.AppendText("Local Log Folder creation failed : $LocalCSVFolder :" + $RunningUserName + "`n")
            ShowRed            
        }
    }
    if(Test-Path $SharedLogFile)
    {
        $LogtextBox.AppendText("Shared Log File already present : $SharedLogFile :" + $RunningUserName + "`n")
        ShowGreen
    }
    else
    {
        try{
        write-host $SharedLogFile
            New-Item $SharedLogFile -type file
            $LogtextBox.AppendText("Shared Log File cretaed : $SharedLogFile :" + $RunningUserName + "`n")
            ShowGreen
        }
        catch{
            $LogtextBox.AppendText("Shared Log File Creation Failed : $SharedLogFile :" + $RunningUserName + "`n")
            ShowRed
        }
    }
    if(Test-Path $LocalLogFile)
    {
        $LogtextBox.AppendText("Local Log File Already present : $LocalLogFile :" + $RunningUserName + "`n")
        ShowGreen
    }
    else
    {
        try{
            New-Item $LocalLogFile -type file
            $LogtextBox.AppendText("Local Log File cretaed : $LocalLogFile :" + $RunningUserName + "`n")
            ShowGreen
        }
        catch{
            $LogtextBox.AppendText("Local Log File Creation Failed : $LocalLogFile :" + $RunningUserName + "`n")
            ShowRed
        }
    }
    $global:setvariables = 1
}

function savelog()
{
    if($setvariables -eq 1)
    {
        $LogtextBox.Text | Out-File $LocalLogFile
        $LogtextBox.Text | Out-File $SharedLogFile
    }
}

Function VerifyAppPoolPassword($ComputerName,$Domain1,$UserID,$Pass)
{
    #write-host $Pass
    $failpoolchangecount = 0
    $tmp = $NULL
    $tmp = Get-WMIObject -class IISApplicationPoolSetting -namespace "root\microsoftiisv2" -computer $ComputerName -authentication 6
    $PoolsThatMatch = @()
    if($Domain1 -eq "FCCDOMAIN"){if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "FCCDOMAIN\$UserID" -OR $_.WAMUserName -like "fairbankscapital.com\$UserID" -OR $_.WAMUserName -like "$UserID@fairbankscapital.com"}}}
    elseif($Domain1 -eq "servicing"){if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "servicing\$UserID" -OR $_.WAMUserName -like "sps.local\$UserID" -OR $_.WAMUserName -like "$UserID@sps.local"}}}
    else{write-host "Invalid Domain"}

    #$PoolsThatMatch | Select __Server,name,WAMUserName,WAMUserPass
    foreach($matchpool in $PoolsThatMatch)
    {
        #write-host $($matchpool.WAMUserPass)
        if($($matchpool.WAMUserPass) -eq $Pass)
        {
            write-host "Password Change completed Successfully and verified on server $ComputerName for pool  $($matchpool.Name)" -ForegroundColor Green
            $LogtextBox.AppendText("Password Change completed Successfully and verified on server $ComputerName for pool  $($matchpool.Name) : " + $RunningUserName + "`n")
        }
        else
        {
            write-host "Password Change Failed on server $ComputerName for pool  $($matchpool.Name)" -ForegroundColor Red
            $failpoolchangecount += 1
            $LogtextBox.AppendText("Password Change Failed on server $ComputerName for pool  $($matchpool.Name) :" + $RunningUserName + "`n")
        }
    }
    if($failpoolchangecount -eq 0)
    {
        ShowGreen   
    }
    else
    {
        ShowRed
    }
    #$i = $PoolsThatMatch.Count
    #write-host $i
}

Function UpdateAppPoolPassword($serverstobechanged)
{
    $Domain1 = $($DomainCombobox.SelectedItem)
    $UserID = $($UserIDTextbox.Text)
    $pass = $($PasswordTextbox.Text)
    ForEach($server in  $serverstobechanged)
    {
        $tmp = $NULL
        $tmp = Get-WMIObject -class IISApplicationPoolSetting -namespace "root\microsoftiisv2" -computer $Server -authentication 6
        $PoolsThatMatch = @()
        if($Domain1 -eq "FCCDOMAIN"){if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "FCCDOMAIN\$UserID" -OR $_.WAMUserName -like "fairbankscapital.com\$UserID" -OR $_.WAMUserName -like "$UserID@fairbankscapital.com"}}}
        elseif($Domain1 -eq "servicing"){if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "servicing\$UserID" -OR $_.WAMUserName -like "sps.local\$UserID" -OR $_.WAMUserName -like "$UserID@sps.local"}}}
        else{write-host "Invalid Domain"}
        #if ($tmp) { $PoolsThatMatch += $tmp | where {$_.WAMUserName -like "$Domain1\$UserID" -OR $_.WAMUserName -like "$Domain2\$UserID"}}
        $PoolsThatMatch | Select __Server,name,WAMUserName,WAMUserPass
        $i = $PoolsThatMatch.Count
        write-host $i
        for ($k = 0; $k -lt $i; $k++)
		{
            $PoolsThatMatch[$k].Properties["WAMUserPass"].Value =$pass
            $PoolsThatMatch[$k].Put()
        }
        VerifyAppPoolPassword $server $Domain1 $UserID $pass
    
    }
}

function ChangeAllAppPoolAccount()
{
    ShowYellow
    $ServerArray = New-Object System.Collections.ArrayList
    foreach($item in $FetchedAppPoolListBox.Items)
    {
        $RemoteCompName = ($item -split "#")[0]
        $AppPoolName = ($item -split "#")[1]
        Write-Host $RemoteCompName
        Write-Host $AppPoolName
        [void] $ServerArray.Add($RemoteCompName)
        
    }
    if(OnclickAuthenticate)
    {
        UpdateAppPoolPassword $ServerArray  
    }
}

function ShowRed()
{
    $file = (get-item "$ImageRoot\Red.PNG")
    $img = [System.Drawing.Image]::Fromfile($file);
    $ResultPicBox.BackgroundImage = $img
    $ResultPicBox.Refresh();
}

function ShowYellow()
{
    $file = (get-item "$ImageRoot\Yellow.PNG")
    $img = [System.Drawing.Image]::Fromfile($file);
    $ResultPicBox.BackgroundImage = $img
    $ResultPicBox.Refresh();
}

function ShowGreen()
{
    $file = (get-item "$ImageRoot\Green.PNG")
    $img = [System.Drawing.Image]::Fromfile($file);
    $ResultPicBox.BackgroundImage = $img
    $ResultPicBox.Refresh();
}
write-host $SharedLogFile
HideInput
HideFetchDetails
HideLogFileDetails
HideOpenLogFileDetails
HideChangeAndRestart
HideFetchedDataDetails
SetGlobalVars
ShowGreen

Main # This call must remain below all other event functions

#endregion
#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%temp%</extractdir>
#    <files>C:\Users\DebasishBA\Documents\AdminScriptEditor\Params.ini|C:\Users\DebasishBA\Documents\AdminScriptEditor\ADAuthenticate.psm1</files>
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>true</altcreds>
#    <efs>false</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <username>DebasishBDA</username>
#    <domain>servicing</domain>
#    <abortonfail>true</abortonfail>
#    <product>RemoteServiceCredentialChanger</product>
#    <internalname>RSCC</internalname>
#    <version>1.0.0.5</version>
#    <versionstring>1.5</versionstring>
#    <description>Change the Remote service credentials</description>
#    <comments />
#    <company>SPS Inc.</company>
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>2</snapinautoadd>
#    <snapinpermanentpath />
#    <cpumode>1</cpumode>
#    <hidepsconsole>false</hidepsconsole>
#  </ScriptPackager>
#</ScriptSettings>
#endregion



############################################################################################################################
# File Name : GUI Remote Password Changer.ps1
#
# Author : Debasish Bahinipati
#
# Version : 1.00
# Date : 2-Nov-2014 
# Notes : Initial Creation
# Created By : Debasish Bahinipati
###########################################################################################################################