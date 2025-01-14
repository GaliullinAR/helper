Add-Type -assembly System.Windows.Forms
 
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Helper'
$main_form.Width = 1200
$main_form.Height = 470
$main_form.AutoSize = $false


# ============== ������ ������ ��� ������ � ������������� =====================

$GroupBox = New-Object System.Windows.Forms.GroupBox
$GroupBox.Text = "������ � ��������"
$GroupBox.AutoSize = $false
$GroupBox.Location  = New-Object System.Drawing.Point(780,0)
$GroupBox.Size  = New-Object System.Drawing.Size(400,425)

$UserInfoBtn = New-Object System.Windows.Forms.Button
$UserInfoBtn.Text = '�� ����'
$UserInfoBtn.Size  = New-Object System.Drawing.Size(120,40)
$UserInfoBtn.Location = New-Object System.Drawing.Point(275,15)
$UserInfoBtn.Add_Click({
    if ($UserNameInput.Text.Length -gt 3) {
        $Name = '*' + $UserNameInput.Text + '*'
        $global:Users = Get-ADUser -Filter {((Name -Like $Name) -or (SamAccountName -Like $Name)) -and (Enabled -eq 'true')} -Properties *
        if ($Users.Name.Count -eq 1) {
            $UserNameInput.Text = $Users.SamAccountName
            $FullUserNameInput.Text = $Users.DisplayName
            $UserDepartamentOutputLabel.Text = $Users.Department
            $UserCompanyOutputLabel.Text = $Users.Company
            $UserCityOutputLabel.Text = $Users.City
            $UserOfficeNameOutputLabel.Text = $Users.physicalDeliveryOfficeName
            $UserEmailInput.Text = $Users.Mail
            $UserJobPhoneNumberOutputLabel.Text = $Users.ipPhone
            $UserMobilPhoneNumberInput.Text = $Users.telephoneNumber
            if ($Users.LockedOut) {
                $UserStatusOutputLabel.Text = '������������'
            } else {
                $UserStatusOutputLabel.Text = '�� ������������'
            }
            $UserStartPasswordOutputLabel.Text = $Users.PasswordLastSet

            $Time = $Users.PasswordLastSet
            $end = $Time.AddDays(40)
            $UserEndPasswordOutputLabel.Text = $end
        } elseif ($Users.Name.Count -gt 1) {
            $UserInfoPOPUP_FORM = New-Object System.Windows.Forms.Form
            $UserInfoPOPUP_FORM.Text ='UserInfo'
            $UserInfoPOPUP_FORM.Width = 400
            $UserInfoPOPUP_FORM.Height = 400
            $UserInfoPOPUP_FORM.AutoSize = $false

            $UserInfoListBox = New-Object System.Windows.Forms.ListBox
            $UserInfoListBox.Location  = New-Object System.Drawing.Point(5,5)
            $UserInfoListBox.Size  = New-Object System.Drawing.Size(375,350)

            if ($UserInfoListBox.Items.Count -gt 0) {
                $UserInfoListBox.Items.Clear()
            }

            foreach ($user in $Users) {
                $usrname = $user.Name
                $samaccountname = $user.SamAccountName
                $UserInfoListBox.Items.Add("Name: $usrname | SamAccountName: $samaccountname")
            }

            $UserInfoListBox.Add_Click({
                # $str = ''
                $Selected = $UserInfoListBox.SelectedItem
                $Selected = $Selected.Split(' ')
                $SelectedLogin = $Selected[6]
                
                $CurrentUser = $Users | where {$_.SamAccountName -Like $SelectedLogin}
                $Users = $CurrentUser
                
                $UserNameInput.Text = $CurrentUser.SamAccountName
                $FullUserNameInput.Text = $CurrentUser.DisplayName
                $UserDepartamentOutputLabel.Text = $CurrentUser.Department
                $UserCompanyOutputLabel.Text = $CurrentUser.Company
                $UserCityOutputLabel.Text = $CurrentUser.City
                $UserOfficeNameOutputLabel.Text = $CurrentUser.physicalDeliveryOfficeName
                $UserEmailInput.Text = $CurrentUser.Mail
                $UserJobPhoneNumberOutputLabel.Text = $CurrentUser.ipPhone
                $UserMobilPhoneNumberInput.Text = $CurrentUser.telephoneNumber
                if ($CurrentUser.LockedOut) {
                    $UserStatusOutputLabel.Text = '������������'
                } else {
                    $UserStatusOutputLabel.Text = '�� ������������'
                }
                $UserStartPasswordOutputLabel.Text = $CurrentUser.PasswordLastSet
    
                $Time = $CurrentUser.PasswordLastSet
                $end = $Time.AddDays(40)
                $UserEndPasswordOutputLabel.Text = $end

                $UserInfoPOPUP_FORM.Close()
            })

            $UserInfoPOPUP_FORM.Controls.Add($UserInfoListBox)

            $UserInfoPOPUP_FORM.ShowDialog()
        }
    }

})

$ADGroupsBtn = New-Object System.Windows.Forms.Button
$ADGroupsBtn.Text = '������ AD'
$ADGroupsBtn.Size  = New-Object System.Drawing.Size(120,40)
$ADGroupsBtn.Location = New-Object System.Drawing.Point(275,60)
$ADGroupsBtn.Add_Click({
    if (($UserNameInput.Text.Length -gt 3) -and ($Users -ne $null)) {
        $MemberOf = $Users.MemberOf.Split(',')
        $Groups = $MemberOf | where {$_[0] -eq 'C'}
        $UserInfoPOPUP_FORM = New-Object System.Windows.Forms.Form
        $UserInfoPOPUP_FORM.Text ='ADGroup'
        $UserInfoPOPUP_FORM.Width = 400
        $UserInfoPOPUP_FORM.Height = 400
        $UserInfoPOPUP_FORM.AutoSize = $false

        $UserInfoListBox = New-Object System.Windows.Forms.ListBox
        $UserInfoListBox.Location  = New-Object System.Drawing.Point(5,5)
        $UserInfoListBox.Size  = New-Object System.Drawing.Size(375,350)

        if ($UserInfoListBox.Items.Count -gt 0) {
            $UserInfoListBox.Items.Clear()
        }
        foreach ($group in $Groups) {
            $group = $group -replace ".*="
            $UserInfoListBox.Items.Add($group)
        }

        $UserInfoPOPUP_FORM.Controls.Add($UserInfoListBox)

        $UserInfoPOPUP_FORM.ShowDialog()
    }
})


$ADUserLocationBtn = New-Object System.Windows.Forms.Button
$ADUserLocationBtn.Text = '����������� �� � AD'
$ADUserLocationBtn.Size  = New-Object System.Drawing.Size(120,40)
$ADUserLocationBtn.Location = New-Object System.Drawing.Point(275,105)
$ADUserLocationBtn.Add_Click({
    if (($UserNameInput.Text.Length -gt 3) -and ($Users -ne $null)) {
        msg * $Users.DistinguishedName
    }
})

$ADUserAuthBtn = New-Object System.Windows.Forms.Button
$ADUserAuthBtn.Text = '��� ����������� ������������'
$ADUserAuthBtn.Size  = New-Object System.Drawing.Size(120,40)
$ADUserAuthBtn.Location = New-Object System.Drawing.Point(275,150)

$ClearFormBtn = New-Object System.Windows.Forms.Button
$ClearFormBtn.Text = '�������� �����'
$ClearFormBtn.Size  = New-Object System.Drawing.Size(120,40)
$ClearFormBtn.Location = New-Object System.Drawing.Point(275,380)
$ClearFormBtn.Add_ClicK({
    $UserNameInput.Text = ''
    $FullUserNameInput.Text = ''
    $UserDepartamentOutputLabel.Text = ''
    $UserCompanyOutputLabel.Text = ''
    $UserCityOutputLabel.Text = ''
    $UserOfficeNameOutputLabel.Text = ''
    $UserEmailInput.Text = $Users.Mail
    $UserJobPhoneNumberOutputLabel.Text = ''
    $UserMobilPhoneNumberInput.Text = ''
    $UserStatusOutputLabel.Text = ''
    $UserStartPasswordOutputLabel.Text = ''
    $UserEndPasswordOutputLabel.Text = ''
    $UserGeneratingPasswordInput.Text = ''
})

$UserNameLabel = New-Object System.Windows.Forms.Label
$UserNameLabel.Text = "������� ��� ��"
$UserNameLabel.Location  = New-Object System.Drawing.Point(5,25)
$UserNameLabel.AutoSize = $true

$FullUserNameLabel = New-Object System.Windows.Forms.Label
$FullUserNameLabel.Text = "���:"
$FullUserNameLabel.Location  = New-Object System.Drawing.Point(5,50)
$FullUserNameLabel.AutoSize = $true

$UserNameInput = New-Object System.Windows.Forms.TextBox
$UserNameInput.Size = New-Object System.Drawing.Size(170,40)
$UserNameInput.Location  = New-Object System.Drawing.Point(100,22)

$FullUserNameInput = New-Object System.Windows.Forms.TextBox
$FullUserNameInput.Size = New-Object System.Drawing.Size(227,40)
$FullUserNameInput.Location  = New-Object System.Drawing.Point(43,47)
$FullUserNameInput.Text = ''
$FullUserNameInput.Enabled = $false

$UserDepartamentLabel = New-Object System.Windows.Forms.Label
$UserDepartamentLabel.Text = "�������������:"
$UserDepartamentLabel.Location  = New-Object System.Drawing.Point(5,75)
$UserDepartamentLabel.AutoSize = $true

$UserDepartamentOutputLabel = New-Object System.Windows.Forms.Label
$UserDepartamentOutputLabel.Text = ""
$UserDepartamentOutputLabel.Location  = New-Object System.Drawing.Point(90,75)
$UserDepartamentOutputLabel.AutoSize = $true

$UserCompanyLabel = New-Object System.Windows.Forms.Label
$UserCompanyLabel.Text = "�����������:"
$UserCompanyLabel.Location  = New-Object System.Drawing.Point(5,95)
$UserCompanyLabel.AutoSize = $true

$UserCompanyOutputLabel = New-Object System.Windows.Forms.Label
$UserCompanyOutputLabel.Text = ""
$UserCompanyOutputLabel.Location  = New-Object System.Drawing.Point(78,95)
$UserCompanyOutputLabel.AutoSize = $true

$UserCityLabel = New-Object System.Windows.Forms.Label
$UserCityLabel.Text = "�����:"
$UserCityLabel.Location  = New-Object System.Drawing.Point(5,115)
$UserCityLabel.AutoSize = $true

$UserCityOutputLabel = New-Object System.Windows.Forms.Label
$UserCityOutputLabel.Text = ""
$UserCityOutputLabel.Location  = New-Object System.Drawing.Point(40,115)
$UserCityOutputLabel.AutoSize = $true

$UserOfficeNameLabel = New-Object System.Windows.Forms.Label
$UserOfficeNameLabel.Text = "�������:"
$UserOfficeNameLabel.Location  = New-Object System.Drawing.Point(5,135)
$UserOfficeNameLabel.AutoSize = $true

$UserOfficeNameOutputLabel = New-Object System.Windows.Forms.Label
$UserOfficeNameOutputLabel.Text = ""
$UserOfficeNameOutputLabel.Location  = New-Object System.Drawing.Point(52,135)
$UserOfficeNameOutputLabel.AutoSize = $true

$UserEmailLabel = New-Object System.Windows.Forms.Label
$UserEmailLabel.Text = "e-mail:"
$UserEmailLabel.Location  = New-Object System.Drawing.Point(5,155)
$UserEmailLabel.AutoSize = $true

$UserEmailInput = New-Object System.Windows.Forms.TextBox
$UserEmailInput.Location  = New-Object System.Drawing.Point(48,153)
$UserEmailInput.AutoSize = $false
$UserEmailInput.Text = ''
$UserEmailInput.Enabled = $false
$UserEmailInput.Size = New-Object System.Drawing.Size(180,20)

$UserJobPhoneNumberLabel = New-Object System.Windows.Forms.Label
$UserJobPhoneNumberLabel.Text = "������� �������:"
$UserJobPhoneNumberLabel.Location  = New-Object System.Drawing.Point(5,175)
$UserJobPhoneNumberLabel.AutoSize = $true

$UserJobPhoneNumberOutputLabel = New-Object System.Windows.Forms.Label
$UserJobPhoneNumberOutputLabel.Text = ""
$UserJobPhoneNumberOutputLabel.Location  = New-Object System.Drawing.Point(100,175)
$UserJobPhoneNumberOutputLabel.AutoSize = $true

$UserMobilPhoneNumberLabel = New-Object System.Windows.Forms.Label
$UserMobilPhoneNumberLabel.Text = "��������� �������:"
$UserMobilPhoneNumberLabel.Location  = New-Object System.Drawing.Point(5,195)
$UserMobilPhoneNumberLabel.AutoSize = $true

$UserMobilPhoneNumberInput = New-Object System.Windows.Forms.TextBox
$UserMobilPhoneNumberInput.Location  = New-Object System.Drawing.Point(117,193)
$UserMobilPhoneNumberInput.AutoSize = $false
$UserMobilPhoneNumberInput.Text = ''
$UserMobilPhoneNumberInput.Enabled = $false
$UserMobilPhoneNumberInput.Size = New-Object System.Drawing.Size(153,20)

$UserStatusLabel = New-Object System.Windows.Forms.Label
$UserStatusLabel.Text = "������ ��:"
$UserStatusLabel.Location  = New-Object System.Drawing.Point(5,215)
$UserStatusLabel.AutoSize = $true

$UserStatusOutputLabel = New-Object System.Windows.Forms.Label
$UserStatusOutputLabel.Text = ""
$UserStatusOutputLabel.Location  = New-Object System.Drawing.Point(65,215)
$UserStatusOutputLabel.AutoSize = $true

$UserStartPasswordLabel = New-Object System.Windows.Forms.Label
$UserStartPasswordLabel.Text = "����� ������ �����:"
$UserStartPasswordLabel.Location = New-Object System.Drawing.Point(5,235)
$UserStartPasswordLabel.AutoSize = $true

$UserStartPasswordOutputLabel = New-Object System.Windows.Forms.Label
$UserStartPasswordOutputLabel.Text = ""
$UserStartPasswordOutputLabel.Location = New-Object System.Drawing.Point(115,235)
$UserStartPasswordOutputLabel.AutoSize = $true

$UserEndPasswordLabel = New-Object System.Windows.Forms.Label
$UserEndPasswordLabel.Text = "����� ������ �����������:"
$UserEndPasswordLabel.Location  = New-Object System.Drawing.Point(5,255)
$UserEndPasswordLabel.AutoSize = $true

$UserEndPasswordOutputLabel = New-Object System.Windows.Forms.Label
$UserEndPasswordOutputLabel.Text = ""
$UserEndPasswordOutputLabel.Location  = New-Object System.Drawing.Point(150,255)
$UserEndPasswordOutputLabel.AutoSize = $true

$UserGeneratingPasswordLabel = New-Object System.Windows.Forms.Label
$UserGeneratingPasswordLabel.Text = "��������� �������"
$UserGeneratingPasswordLabel.Location  = New-Object System.Drawing.Point(5,330)
$UserGeneratingPasswordLabel.AutoSize = $true

$UserGeneratingPasswordInput = New-Object System.Windows.Forms.TextBox
$UserGeneratingPasswordInput.Location  = New-Object System.Drawing.Point(5,347)
$UserGeneratingPasswordInput.AutoSize = $false
$UserGeneratingPasswordInput.Text = ''
$UserGeneratingPasswordInput.Enabled = $false
$UserGeneratingPasswordInput.Size = New-Object System.Drawing.Size(153,20)

$UserGeneratingPasswordBtn = New-Object System.Windows.Forms.Button
$UserGeneratingPasswordBtn.Text = '������������� ������'
$UserGeneratingPasswordBtn.Size  = New-Object System.Drawing.Size(120,40)
$UserGeneratingPasswordBtn.Location = New-Object System.Drawing.Point(5,380)
$UserGeneratingPasswordBtn.Add_Click({
    Add-Type -AssemblyName System.Web
    $UserGeneratingPasswordInput.Text = [System.Web.Security.Membership]::GeneratePassword(12,1)
})

$UserCopyGeneratingPasswordBtn = New-Object System.Windows.Forms.Button
$UserCopyGeneratingPasswordBtn.Text = '����������� ������'
$UserCopyGeneratingPasswordBtn.Size  = New-Object System.Drawing.Size(120,40)
$UserCopyGeneratingPasswordBtn.Location = New-Object System.Drawing.Point(130,380)
$UserCopyGeneratingPasswordBtn.Add_Click({
    if ($UserGeneratingPasswordInput.Text.Length -gt 0) {
        $Text = $UserGeneratingPasswordInput.Text
        Set-Clipboard -Value $Text
    }
})

$GroupBox.Controls.Add($ADGroupsBtn)
$GroupBox.Controls.Add($UserInfoBtn)
$GroupBox.Controls.Add($ADUserLocationBtn)
$GroupBox.Controls.Add($ADUserAuthBtn)
$GroupBox.Controls.Add($ClearFormBtn)
$GroupBox.Controls.Add($UserNameLabel)
$GroupBox.Controls.Add($FullUserNameLabel)
$GroupBox.Controls.Add($UserNameInput)
$GroupBox.Controls.Add($FullUserNameInput)
$GroupBox.Controls.Add($UserDepartamentOutputLabel)
$GroupBox.Controls.Add($UserDepartamentLabel)
$GroupBox.Controls.Add($UserCompanyOutputLabel)
$GroupBox.Controls.Add($UserCompanyLabel)
$GroupBox.Controls.Add($UserCityOutputLabel)
$GroupBox.Controls.Add($UserCityLabel)
$GroupBox.Controls.Add($UserOfficeNameOutputLabel)
$GroupBox.Controls.Add($UserOfficeNameLabel)
$GroupBox.Controls.Add($UserEmailLabel)
$GroupBox.Controls.Add($UserEmailInput)
$GroupBox.Controls.Add($UserJobPhoneNumberOutputLabel)
$GroupBox.Controls.Add($UserJobPhoneNumberLabel)
$GroupBox.Controls.Add($UserMobilPhoneNumberInput)
$GroupBox.Controls.Add($UserMobilPhoneNumberLabel)
$GroupBox.Controls.Add($UserStatusOutputLabel)
$GroupBox.Controls.Add($UserStatusLabel)
$GroupBox.Controls.Add($UserStartPasswordOutputLabel)
$GroupBox.Controls.Add($UserStartPasswordLabel)
$GroupBox.Controls.Add($UserEndPasswordOutputLabel)
$GroupBox.Controls.Add($UserEndPasswordLabel)
$GroupBox.Controls.Add($UserGeneratingPasswordLabel)
$GroupBox.Controls.Add($UserGeneratingPasswordInput)
$GroupBox.Controls.Add($UserGeneratingPasswordBtn)
$GroupBox.Controls.Add($UserCopyGeneratingPasswordBtn)

# ============== ����� ������ ��� ������ � ������������� ======================




# ====================== ������ ������ ��� ������ � �� ========================

# ---------------------- PCGroupBox Buttons -----------------------------------

$PCGroupBox = New-Object System.Windows.Forms.GroupBox
$PCGroupBox.Text = "������ � ��"
$PCGroupBox.AutoSize = $false
$PCGroupBox.Location  = New-Object System.Drawing.Point(5,0)
$PCGroupBox.Size  = New-Object System.Drawing.Size(772,425)

$PCGetInfoBtn = New-Object System.Windows.Forms.Button
$PCGetInfoBtn.Text = '�������� ���� � ��'
$PCGetInfoBtn.Size  = New-Object System.Drawing.Size(80,50)
$PCGetInfoBtn.Location = New-Object System.Drawing.Point(5,15)

$PCGetLinkBtn = New-Object System.Windows.Forms.Button
$PCGetLinkBtn.Text = '��������� �����������'
$PCGetLinkBtn.Size  = New-Object System.Drawing.Size(80,50)
$PCGetLinkBtn.Location = New-Object System.Drawing.Point(90,15)

$PCRebootBtn = New-Object System.Windows.Forms.Button
$PCRebootBtn.Text = '������������� ��'
$PCRebootBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCRebootBtn.Location = New-Object System.Drawing.Point(5,72)

$PCGetProcessBtn = New-Object System.Windows.Forms.Button
$PCGetProcessBtn.Text = '���������� ��������'
$PCGetProcessBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCGetProcessBtn.Location = New-Object System.Drawing.Point(5,130)

$PCServicesBtn = New-Object System.Windows.Forms.Button
$PCServicesBtn.Text = '���������� ��������'
$PCServicesBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCServicesBtn.Location = New-Object System.Drawing.Point(5,190)

$PCForceSCCMPolicyBtn = New-Object System.Windows.Forms.Button
$PCForceSCCMPolicyBtn.Text = 'Force SCCM Polices'
$PCForceSCCMPolicyBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCForceSCCMPolicyBtn.Location = New-Object System.Drawing.Point(5,250)
$PCForceSCCMPolicyBtn.Enabled = $false

$PCGetLinkPrintersBtn = New-Object System.Windows.Forms.Button
$PCGetLinkPrintersBtn.Text = '������������ ��������'
$PCGetLinkPrintersBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCGetLinkPrintersBtn.Location = New-Object System.Drawing.Point(5,310)

$PCGetProgramListBtn = New-Object System.Windows.Forms.Button
$PCGetProgramListBtn.Text = '������ ��'
$PCGetProgramListBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCGetProgramListBtn.Location = New-Object System.Drawing.Point(5,370)

$PCSPOOLRestartBtn = New-Object System.Windows.Forms.Button
$PCSPOOLRestartBtn.Text = 'SPOOL Restart'
$PCSPOOLRestartBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCSPOOLRestartBtn.Location = New-Object System.Drawing.Point(180,310)
$PCSPOOLRestartBtn.Enabled = $false

$PCChangeDescriptionBtn = New-Object System.Windows.Forms.Button
$PCChangeDescriptionBtn.Text = '�������� �������� ��'
$PCChangeDescriptionBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCChangeDescriptionBtn.Location = New-Object System.Drawing.Point(180,370)

$PCFARBtn = New-Object System.Windows.Forms.Button
$PCFARBtn.Text = 'FAR C:\'
$PCFARBtn.Size  = New-Object System.Drawing.Size(50,50)
$PCFARBtn.Location = New-Object System.Drawing.Point(355,310)
$PCFARBtn.Enabled = $false

$PCADDestBtn = New-Object System.Windows.Forms.Button
$PCADDestBtn.Text = '���� � AD'
$PCADDestBtn.Size  = New-Object System.Drawing.Size(50,50)
$PCADDestBtn.Location = New-Object System.Drawing.Point(355,370)

$PCSCCMReinstallBtn = New-Object System.Windows.Forms.Button
$PCSCCMReinstallBtn.Text = '�������������� SCCM'
$PCSCCMReinstallBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCSCCMReinstallBtn.Location = New-Object System.Drawing.Point(415,310)
$PCSCCMReinstallBtn.Enabled = $false

$PCControlPanelBtn = New-Object System.Windows.Forms.Button
$PCControlPanelBtn.Text = '���������� ���'
$PCControlPanelBtn.Size  = New-Object System.Drawing.Size(165,50)
$PCControlPanelBtn.Location = New-Object System.Drawing.Point(415,370)

$PCCheckBlockBtn = New-Object System.Windows.Forms.Button
$PCCheckBlockBtn.Text = '�������� ����������'
$PCCheckBlockBtn.Size  = New-Object System.Drawing.Size(175,50)
$PCCheckBlockBtn.Location = New-Object System.Drawing.Point(590,310)

$PCOpenUserFolderBtn = New-Object System.Windows.Forms.Button
$PCOpenUserFolderBtn.Text = '����� C:\'
$PCOpenUserFolderBtn.Size  = New-Object System.Drawing.Size(175,50)
$PCOpenUserFolderBtn.Location = New-Object System.Drawing.Point(590,370)

$PCRestartSCCMBtn = New-Object System.Windows.Forms.Button
$PCRestartSCCMBtn.Text = 'Restart SCCM'
$PCRestartSCCMBtn.Size  = New-Object System.Drawing.Size(175,50)
$PCRestartSCCMBtn.Location = New-Object System.Drawing.Point(590,250)
$PCRestartSCCMBtn.Enabled = $false

$PCControlAdapterBtn = New-Object System.Windows.Forms.Button
$PCControlAdapterBtn.Text = '���������� ����������'
$PCControlAdapterBtn.Size  = New-Object System.Drawing.Size(175,50)
$PCControlAdapterBtn.Location = New-Object System.Drawing.Point(590,190)
$PCControlAdapterBtn.Enabled = $false

$PCPingBtn = New-Object System.Windows.Forms.Button
$PCPingBtn.Text = 'Ping'
$PCPingBtn.Size  = New-Object System.Drawing.Size(55,50)
$PCPingBtn.Location = New-Object System.Drawing.Point(590,130)
$PCPingBtn.Add_Click({
    $Value = $UserNameInput.Text
    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -verb runas -ArgumentList '/c ping', "$Value"
})

$PCPingABtn = New-Object System.Windows.Forms.Button
$PCPingABtn.Text = 'Ping -a'
$PCPingABtn.Size  = New-Object System.Drawing.Size(55,50)
$PCPingABtn.Location = New-Object System.Drawing.Point(650,130)
$PCPingABtn.Add_Click({
    $Value = $UserNameInput.Text
    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -verb runas -ArgumentList '/c ping -a', "$Value"
})

$PCPingTBtn = New-Object System.Windows.Forms.Button
$PCPingTBtn.Text = 'Ping -t'
$PCPingTBtn.Size  = New-Object System.Drawing.Size(55,50)
$PCPingTBtn.Location = New-Object System.Drawing.Point(710,130)
$PCPingTBtn.Add_Click({
    $Value = $UserNameInput.Text
    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -verb runas -ArgumentList '/c ping -t', "$Value"
})

$PCConnectToPCBtn = New-Object System.Windows.Forms.Button
$PCConnectToPCBtn.Text = '������������ � ��'
$PCConnectToPCBtn.Size  = New-Object System.Drawing.Size(175,50)
$PCConnectToPCBtn.Location = New-Object System.Drawing.Point(590,72)

$PCClearDNSsufBtn = New-Object System.Windows.Forms.Button
$PCClearDNSsufBtn.Text = '�������� DNS ��������'
$PCClearDNSsufBtn.Size  = New-Object System.Drawing.Size(175,50)
$PCClearDNSsufBtn.Location = New-Object System.Drawing.Point(590,15)

# ---------------------- PCGroupBox Buttons -----------------------------------


# ---------------------- PCGroupBox Labels and Inputs ------------------------

$PSName = New-Object System.Windows.Forms.Label
$PSName.Text = "������� ��� ��:"
$PSName.Location  = New-Object System.Drawing.Point(175,30)
$PSName.AutoSize = $true

$PSNameInput = New-Object System.Windows.Forms.TextBox
$PSNameInput.Size = New-Object System.Drawing.Size(270,40)
$PSNameInput.Location  = New-Object System.Drawing.Point(270,28)

$PSMemoryLabel = New-Object System.Windows.Forms.Label
$PSMemoryLabel.Text = "������ ��:"
$PSMemoryLabel.Location  = New-Object System.Drawing.Point(175,60)
$PSMemoryLabel.AutoSize = $true

$PSMemoryOutput = New-Object System.Windows.Forms.Label
$PSMemoryOutput.Location  = New-Object System.Drawing.Point(240,60)
$PSMemoryOutput.AutoSize = $true

$PSRAMLabel = New-Object System.Windows.Forms.Label
$PSRAMLabel.Text = "RAM:"
$PSRAMLabel.Location  = New-Object System.Drawing.Point(175,90)
$PSRAMLabel.AutoSize = $true

$PSRAMOutput = New-Object System.Windows.Forms.Label
$PSRAMOutput.Text = ""
$PSRAMOutput.Location  = New-Object System.Drawing.Point(205,90)
$PSRAMOutput.AutoSize = $true

$PSCurrentUserLabel = New-Object System.Windows.Forms.Label
$PSCurrentUserLabel.Text = "������� ������������:"
$PSCurrentUserLabel.Location  = New-Object System.Drawing.Point(175,120)
$PSCurrentUserLabel.AutoSize = $true

$PSCurrentUserOutput = New-Object System.Windows.Forms.Label
$PSCurrentUserOutput.Text = ""
$PSCurrentUserOutput.Location  = New-Object System.Drawing.Point(300,120)
$PSCurrentUserOutput.AutoSize = $true

$PSOSInfoOutput = New-Object System.Windows.Forms.Label
$PSOSInfoOutput.Text = ""
$PSOSInfoOutput.Location  = New-Object System.Drawing.Point(175,150)
$PSOSInfoOutput.AutoSize = $true

$PSBIOSTypeLabel = New-Object System.Windows.Forms.Label
$PSBIOSTypeLabel.Text = "BIOS:"
$PSBIOSTypeLabel.Location  = New-Object System.Drawing.Point(175,180)
$PSBIOSTypeLabel.AutoSize = $true

$PSBIOSTypeOutput = New-Object System.Windows.Forms.Label
$PSBIOSTypeOutput.Text = ""
$PSBIOSTypeOutput.Location  = New-Object System.Drawing.Point(205,180)
$PSBIOSTypeOutput.AutoSize = $true

$PSWorkTimeLabel = New-Object System.Windows.Forms.Label
$PSWorkTimeLabel.Text = "����� ������:"
$PSWorkTimeLabel.Location  = New-Object System.Drawing.Point(175,210)
$PSWorkTimeLabel.AutoSize = $true

$PSWorkTimeOutput = New-Object System.Windows.Forms.Label
$PSWorkTimeOutput.Text = ""
$PSWorkTimeOutput.Location  = New-Object System.Drawing.Point(255,210)
$PSWorkTimeOutput.AutoSize = $true

$PSIPAddressLabel = New-Object System.Windows.Forms.Label
$PSIPAddressLabel.Text = "IP:"
$PSIPAddressLabel.Location  = New-Object System.Drawing.Point(175,240)
$PSIPAddressLabel.AutoSize = $true

$PSIPAddressOutput = New-Object System.Windows.Forms.Label
$PSIPAddressOutput.Text = ""
$PSIPAddressOutput.Location  = New-Object System.Drawing.Point(195,240)
$PSIPAddressOutput.AutoSize = $true

$PSSerialNumberLabel = New-Object System.Windows.Forms.Label
$PSSerialNumberLabel.Text = "S/N:"
$PSSerialNumberLabel.Location  = New-Object System.Drawing.Point(175,270)
$PSSerialNumberLabel.AutoSize = $true

$PSSerialNumberOutput = New-Object System.Windows.Forms.TextBox
$PSSerialNumberOutput.Text = ""
$PSSerialNumberOutput.Location  = New-Object System.Drawing.Point(201,267)
$PSSerialNumberOutput.Size  = New-Object System.Drawing.Size(150,40)
$PSSerialNumberOutput.AutoSize = $true
$PSSerialNumberOutput.Enabled = $false

# ---------------------- PCGroupBox Labels and Inputs ------------------------

$PCGroupBox.Controls.Add($PCGetInfoBtn)
$PCGroupBox.Controls.Add($PCGetLinkBtn)
$PCGroupBox.Controls.Add($PCRebootBtn)
$PCGroupBox.Controls.Add($PCGetProcessBtn)
$PCGroupBox.Controls.Add($PCServicesBtn)
$PCGroupBox.Controls.Add($PCForceSCCMPolicyBtn)
$PCGroupBox.Controls.Add($PCGetLinkPrintersBtn)
$PCGroupBox.Controls.Add($PCGetProgramListBtn)
$PCGroupBox.Controls.Add($PCSPOOLRestartBtn)
$PCGroupBox.Controls.Add($PCChangeDescriptionBtn)
$PCGroupBox.Controls.Add($PCFARBtn)
$PCGroupBox.Controls.Add($PCADDestBtn)
$PCGroupBox.Controls.Add($PCSCCMReinstallBtn)
$PCGroupBox.Controls.Add($PCControlPanelBtn)
$PCGroupBox.Controls.Add($PCCheckBlockBtn)
$PCGroupBox.Controls.Add($PCOpenUserFolderBtn)
$PCGroupBox.Controls.Add($PCRestartSCCMBtn)
$PCGroupBox.Controls.Add($PCControlAdapterBtn)
$PCGroupBox.Controls.Add($PCPingBtn)
$PCGroupBox.Controls.Add($PCPingABtn)
$PCGroupBox.Controls.Add($PCPingTBtn)
$PCGroupBox.Controls.Add($PCConnectToPCBtn)
$PCGroupBox.Controls.Add($PCClearDNSsufBtn)

$PCGroupBox.Controls.Add($PSNameInput)
$PCGroupBox.Controls.Add($PSName)
$PCGroupBox.Controls.Add($PSMemoryOutput)
$PCGroupBox.Controls.Add($PSMemoryLabel)
$PCGroupBox.Controls.Add($PSRAMOutput)
$PCGroupBox.Controls.Add($PSRAMLabel)
$PCGroupBox.Controls.Add($PSCurrentUserOutput)
$PCGroupBox.Controls.Add($PSCurrentUserLabel)
$PCGroupBox.Controls.Add($PSOSInfoOutput)
$PCGroupBox.Controls.Add($PSBIOSTypeOutput)
$PCGroupBox.Controls.Add($PSBIOSTypeLabel)
$PCGroupBox.Controls.Add($PSWorkTimeOutput)
$PCGroupBox.Controls.Add($PSWorkTimeLabel)
$PCGroupBox.Controls.Add($PSIPAddressOutput)
$PCGroupBox.Controls.Add($PSIPAddressLabel)
$PCGroupBox.Controls.Add($PSSerialNumberOutput)
$PCGroupBox.Controls.Add($PSSerialNumberLabel)

# ===================== ����� ������ ��� ������ � �� ==========================



$main_form.Controls.Add($GroupBox)
$main_form.Controls.Add($PCGroupBox)
$main_form.ShowDialog()