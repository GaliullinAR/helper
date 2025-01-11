Add-Type -assembly System.Windows.Forms
 
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Helper'
$main_form.Width = 1200
$main_form.Height = 470
$main_form.AutoSize = $false

$Users = ''

$GroupBox = New-Object System.Windows.Forms.GroupBox
$GroupBox.Text = "Работа с профилем"
$GroupBox.AutoSize = $false
$GroupBox.Location  = New-Object System.Drawing.Point(780,0)
$GroupBox.Size  = New-Object System.Drawing.Size(400,425)

$UserInfoBtn = New-Object System.Windows.Forms.Button
$UserInfoBtn.Text = 'УЗ Инфо'
$UserInfoBtn.Size  = New-Object System.Drawing.Size(120,40)
$UserInfoBtn.Location = New-Object System.Drawing.Point(275,15)
$UserInfoBtn.Add_ClicK({
    if ($UserNameInput.Text.Length -gt 4) {
        $Name = $UserNameInput.Text
        $Users = Get-ADUser -Filter "(Name -Like '*$Name*') -or (SamAccountName -Like '*$Name*')" -Properties *
        if ($Users -ne $null) {
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
                $UserStatusOutputLabel.Text = 'Заблокирован'
            } else {
                $UserStatusOutputLabel.Text = 'Не заблокирован'
            }
            $UserStartPasswordOutputLabel.Text = $Users.PasswordLastSet

            $Time = $Users.PasswordLastSet
            $end = $Time.AddDays(40)
            $UserEndPasswordOutputLabel.Text = $end
        }
    }

})

$ADGroupsBtn = New-Object System.Windows.Forms.Button
$ADGroupsBtn.Text = 'Группы AD'
$ADGroupsBtn.Size  = New-Object System.Drawing.Size(120,40)
$ADGroupsBtn.Location = New-Object System.Drawing.Point(275,60)

$ADUserLocationBtn = New-Object System.Windows.Forms.Button
$ADUserLocationBtn.Text = 'Распложение УЗ в AD'
$ADUserLocationBtn.Size  = New-Object System.Drawing.Size(120,40)
$ADUserLocationBtn.Location = New-Object System.Drawing.Point(275,105)

$ADUserAuthBtn = New-Object System.Windows.Forms.Button
$ADUserAuthBtn.Text = 'Где авторизован пользователь'
$ADUserAuthBtn.Size  = New-Object System.Drawing.Size(120,40)
$ADUserAuthBtn.Location = New-Object System.Drawing.Point(275,150)

$ClearFormBtn = New-Object System.Windows.Forms.Button
$ClearFormBtn.Text = 'Очистить форму'
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
$UserNameLabel.Text = "Введите имя УЗ"
$UserNameLabel.Location  = New-Object System.Drawing.Point(5,25)
$UserNameLabel.AutoSize = $true

$FullUserNameLabel = New-Object System.Windows.Forms.Label
$FullUserNameLabel.Text = "ФИО:"
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
$UserDepartamentLabel.Text = "Подразделение:"
$UserDepartamentLabel.Location  = New-Object System.Drawing.Point(5,75)
$UserDepartamentLabel.AutoSize = $true

$UserDepartamentOutputLabel = New-Object System.Windows.Forms.Label
$UserDepartamentOutputLabel.Text = ""
$UserDepartamentOutputLabel.Location  = New-Object System.Drawing.Point(90,75)
$UserDepartamentOutputLabel.AutoSize = $true

$UserCompanyLabel = New-Object System.Windows.Forms.Label
$UserCompanyLabel.Text = "Предприятие:"
$UserCompanyLabel.Location  = New-Object System.Drawing.Point(5,95)
$UserCompanyLabel.AutoSize = $true

$UserCompanyOutputLabel = New-Object System.Windows.Forms.Label
$UserCompanyOutputLabel.Text = ""
$UserCompanyOutputLabel.Location  = New-Object System.Drawing.Point(78,95)
$UserCompanyOutputLabel.AutoSize = $true

$UserCityLabel = New-Object System.Windows.Forms.Label
$UserCityLabel.Text = "Город:"
$UserCityLabel.Location  = New-Object System.Drawing.Point(5,115)
$UserCityLabel.AutoSize = $true

$UserCityOutputLabel = New-Object System.Windows.Forms.Label
$UserCityOutputLabel.Text = ""
$UserCityOutputLabel.Location  = New-Object System.Drawing.Point(40,115)
$UserCityOutputLabel.AutoSize = $true

$UserOfficeNameLabel = New-Object System.Windows.Forms.Label
$UserOfficeNameLabel.Text = "Кабинет:"
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
$UserJobPhoneNumberLabel.Text = "Рабочий телефон:"
$UserJobPhoneNumberLabel.Location  = New-Object System.Drawing.Point(5,175)
$UserJobPhoneNumberLabel.AutoSize = $true

$UserJobPhoneNumberOutputLabel = New-Object System.Windows.Forms.Label
$UserJobPhoneNumberOutputLabel.Text = "Рабочий телефон:"
$UserJobPhoneNumberOutputLabel.Location  = New-Object System.Drawing.Point(120,175)
$UserJobPhoneNumberOutputLabel.AutoSize = $true

$UserMobilPhoneNumberLabel = New-Object System.Windows.Forms.Label
$UserMobilPhoneNumberLabel.Text = "Мобильный телефон:"
$UserMobilPhoneNumberLabel.Location  = New-Object System.Drawing.Point(5,195)
$UserMobilPhoneNumberLabel.AutoSize = $true

$UserMobilPhoneNumberInput = New-Object System.Windows.Forms.TextBox
$UserMobilPhoneNumberInput.Location  = New-Object System.Drawing.Point(117,193)
$UserMobilPhoneNumberInput.AutoSize = $false
$UserMobilPhoneNumberInput.Text = ''
$UserMobilPhoneNumberInput.Enabled = $false
$UserMobilPhoneNumberInput.Size = New-Object System.Drawing.Size(153,20)

$UserStatusLabel = New-Object System.Windows.Forms.Label
$UserStatusLabel.Text = "Статус УЗ:"
$UserStatusLabel.Location  = New-Object System.Drawing.Point(5,215)
$UserStatusLabel.AutoSize = $true

$UserStatusOutputLabel = New-Object System.Windows.Forms.Label
$UserStatusOutputLabel.Text = ""
$UserStatusOutputLabel.Location  = New-Object System.Drawing.Point(65,215)
$UserStatusOutputLabel.AutoSize = $true

$UserStartPasswordLabel = New-Object System.Windows.Forms.Label
$UserStartPasswordLabel.Text = "Когда пароль задан:"
$UserStartPasswordLabel.Location = New-Object System.Drawing.Point(5,235)
$UserStartPasswordLabel.AutoSize = $true

$UserStartPasswordOutputLabel = New-Object System.Windows.Forms.Label
$UserStartPasswordOutputLabel.Text = ""
$UserStartPasswordOutputLabel.Location = New-Object System.Drawing.Point(115,235)
$UserStartPasswordOutputLabel.AutoSize = $true

$UserEndPasswordLabel = New-Object System.Windows.Forms.Label
$UserEndPasswordLabel.Text = "Когда пароль завершается:"
$UserEndPasswordLabel.Location  = New-Object System.Drawing.Point(5,255)
$UserEndPasswordLabel.AutoSize = $true

$UserEndPasswordOutputLabel = New-Object System.Windows.Forms.Label
$UserEndPasswordOutputLabel.Text = ""
$UserEndPasswordOutputLabel.Location  = New-Object System.Drawing.Point(150,255)
$UserEndPasswordOutputLabel.AutoSize = $true

$UserGeneratingPasswordLabel = New-Object System.Windows.Forms.Label
$UserGeneratingPasswordLabel.Text = "Генератор паролей"
$UserGeneratingPasswordLabel.Location  = New-Object System.Drawing.Point(5,330)
$UserGeneratingPasswordLabel.AutoSize = $true

$UserGeneratingPasswordInput = New-Object System.Windows.Forms.TextBox
$UserGeneratingPasswordInput.Location  = New-Object System.Drawing.Point(5,347)
$UserGeneratingPasswordInput.AutoSize = $false
$UserGeneratingPasswordInput.Text = ''
$UserGeneratingPasswordInput.Enabled = $false
$UserGeneratingPasswordInput.Size = New-Object System.Drawing.Size(153,20)

$UserGeneratingPasswordBtn = New-Object System.Windows.Forms.Button
$UserGeneratingPasswordBtn.Text = 'Сгенерировать пароль'
$UserGeneratingPasswordBtn.Size  = New-Object System.Drawing.Size(120,40)
$UserGeneratingPasswordBtn.Location = New-Object System.Drawing.Point(5,380)
$UserGeneratingPasswordBtn.Add_Click({
    Add-Type -AssemblyName System.Web
    $UserGeneratingPasswordInput.Text = [System.Web.Security.Membership]::GeneratePassword(12,1)
})

$UserCopyGeneratingPasswordBtn = New-Object System.Windows.Forms.Button
$UserCopyGeneratingPasswordBtn.Text = 'Скопировать пароль'
$UserCopyGeneratingPasswordBtn.Size  = New-Object System.Drawing.Size(120,40)
$UserCopyGeneratingPasswordBtn.Location = New-Object System.Drawing.Point(130,380)

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

$main_form.Controls.Add($GroupBox)



$main_form.ShowDialog()