$dotnetHome = Join-Path (Get-Location) ".dotnet"
$dotnetPath = Join-Path $dotnetHome "bin"

Write-Host "Downloading install.ps1 to: $dotnetPath"
if (!(Test-Path $dotnetPath)) { md $dotnetPath | Out-Null }

$installPs1Path = Join-Path $dotnetPath "install.ps1"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile('https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/install.ps1', $installPs1Path)

$env:InstallDir = $dotnetHome

Write-Host "Downloading dotnet/cli"

. $installPs1Path -InstallDir $dotnetHome

$env:PATH = ("$dotnetPath;" + $env:PATH)

dotnet --version

Write-Host "Downloading packages"

cd src
dotnet restore

Write-Host "Building"

cd Castle.Core.Tests
dotnet build --configuration Release

Write-Host "Running tests"

dotnet test

exit $LASTEXITCODE
