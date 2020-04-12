$CygWinSetupDir = "$env:temp\cygInstall"
$CygWinInstallDir = "C:\Cygwin"

if (!(Test-Path -Path $CygWinSetupDir -PathType Container)) {
  $null = New-Item -Type Directory -Path $CygWinSetupDir -Force
}

function Install-Chocolatey {
  Invoke-WebRequest -useb https://chocolatey.org/install.ps1 | Invoke-Expression
}

function Install-Cygwin {
  if (Test-Path -Path $CygWinInstallDir -PathType Container) {
    return
  }
  Invoke-WebRequest -Uri "https://cygwin.com/setup-x86_64.exe" -OutFile "$CygWinSetupDir\setup.exe"
  Start-Process -Wait -FilePath "$CygWinSetupDir\setup.exe" -ArgumentList "-q -n -l $CygWinSetupDir -s http://cygwin.mirror.constant.com -R $CygWinInstallDir"
}

function Install-Cygwin-Package ($package) {
  Start-Process -Wait -FilePath "$CygWinSetupDir\setup.exe" -ArgumentList "-q -n -l $CygWinSetupDir -s http://cygwin.mirror.constant.com -R $CygWinInstallDir -P $package"
}

function Install-Choco-Packages {
  choco install --no-progress --limit-output --yes notepad2-mod vscode GoogleChrome autohotkey openssh nodejs yarn
}

Install-Cygwin
Install-Chocolatey

# reload Path workded better than dot sourcing
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Install-Cygwin-Package "python3"
Install-Cygwin-Package "python3-setuptools"
Install-Cygwin-Package "vim"
Install-Choco-Packages

# Todo: find a way to call this from a Cygwin instance
# python3 -m ensurepip

