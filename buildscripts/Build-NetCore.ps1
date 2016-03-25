$dotnetHome = Join-Path (Get-Location) ".dotnet"
$dotnetPath = Join-Path $dotnetHome "bin"

Write-Host "Downloading dnvm to: $dotnetPath"
if (!(Test-Path $dotnetPath)) { md $dotnetPath | Out-Null }

$installPs1Path = Join-Path $dotnetPath "install.ps1"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile('https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/install.ps1', $installPs1Path)

$env:InstallDir = $dotnetHome

Write-Host "Downloading dotnet/cli"

. $installPs1Path -Channel Production -InstallDir $installPs1Path

$env:PATH = ("$dotnetPath;" + $env:PATH)

dotnet --version

Write-Host "Downloading packages"

cd src/Castle.Core
dotnet restore
cd ../Castle.Core.Tests
dotnet restore

Write-Host "Building"

dotnet build --configuration Release --out build/NETCORE

Write-Host "Running tests"

dotnet test

exit $LASTEXITCODE
