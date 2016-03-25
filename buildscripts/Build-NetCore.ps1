$dotnetHome = Join-Path (Get-Location) ".dotnet"
$dotnetPath = Join-Path $dotnetHome "bin"

Write-Host "Downloading dnvm to: $dotnetPath"
if (!(Test-Path $dotnetPath)) { md $dotnetPath | Out-Null }

$installPs1Path = Join-Path $dotnetPath "install.ps1"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile('https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/install.ps1', $installPs1Path)

$env:InstallDir = $dotnetHome

printenv

Write-Host "Downloading dotnet/cli"

. $installPs1Path

$env:PATH = ("$dotnetPath;" + $env:PATH)

dotnet --version

Write-Host "Downloading packages"

dotnet restore

Write-Host "Building"

dotnet build src/Castle.Core src/Castle.Core.Tests --configuration Release --out build/NETCORE

Write-Host "Running tests"

cd src/Castle.Core.Tests
dotnet test

exit $LASTEXITCODE
