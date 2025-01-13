
# Получение серийного номера устройства
$SerialNumber = (Get-WmiObject win32_bios | select Serialnumber).Serialnumber

# Получить тип биоса UEFI или Legacy
$env:firmware_type

# Открыть папку С
Invoke-Item \\server\c$