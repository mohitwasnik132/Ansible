  <powershell>
  net user devops devops /add /y
  net localgroup administrators devops /add
  winrm quickconfig -q
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
  winrm set winrm/config '@{MaxTimeoutms="1800000"}'
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/service/auth '@{Basic="true"}'
  netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
  netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
  net stop winrm
  sc.exe config winrm start=auto
  net start winrm

  Import-Module AWSPowerShell
$SecretAD = "admin_pwd"
$SecretObj = (Get-SECSecretValue -SecretId $SecretAD)
$Secret = ($SecretObj.SecretString  | ConvertFrom-Json)
$password   = $Secret.Password | ConvertTo-SecureString -asPlainText -Force

$UserAccount = Get-LocalUser -Name "administrator"
$UserAccount | Set-LocalUser -Password $Password


Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))

iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco install python -y
(new-object net.webclient).DownloadFile('https://s3.amazonaws.com/aws-cli/AWSCLI64.msi','c:\AWSCLI64.msi')
msiexec.exe /i 'C:\AWSCLI64.msi' /qn

</powershell>
  