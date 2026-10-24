$ErrorActionPreference = "Stop"

$TargetDir = Join-Path $HOME ".gemini\antigravity-cli"
$TargetFile = Join-Path $TargetDir "settings.json"
$SourceFile = Join-Path $PSScriptRoot "settings.json"

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

$NewSettings = Get-Content $SourceFile -Raw | ConvertFrom-Json

if (Test-Path $TargetFile) {
    $CurrentSettings = Get-Content $TargetFile -Raw | ConvertFrom-Json
    foreach ($Property in $NewSettings.PSObject.Properties) {
        $CurrentSettings | Add-Member -NotePropertyName $Property.Name -NotePropertyValue $Property.Value -Force
    }
    $CurrentSettings | ConvertTo-Json -Depth 10 | Set-Content $TargetFile -Encoding UTF8
} else {
    Copy-Item $SourceFile $TargetFile -Force
}

Write-Host "Updated $TargetFile successfully." -ForegroundColor Green
Get-Content $TargetFile
