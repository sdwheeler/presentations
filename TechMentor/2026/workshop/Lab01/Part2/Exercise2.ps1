function Enable-sjWindowsWidget {
  # check if running as admin
  if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
      [Security.Principal.WindowsBuiltInRole] 'Administrator'
    )) {
    Write-Warning 'This function must be run as an administrator.'
    return
  }

  # Enable "Allow widgets"
  $registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'
  if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
  }
  Set-ItemProperty -Path $registryPath -Name 'AllowNewsAndInterests' -Type DWord -Value 1
  gpupdate /target:computer /force
}


function Disable-sjWindowsWidget {
  # check if running as admin
  if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
      [Security.Principal.WindowsBuiltInRole] 'Administrator'
    )) {
    Write-Warning 'This function must be run as an administrator.'
    return
  }

  # Disable "Allow widgets"
  $registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh'
  if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
  }
  Set-ItemProperty -Path $registryPath -Name 'AllowNewsAndInterests' -Type DWord -Value 0
  gpupdate /target:computer /force
}

