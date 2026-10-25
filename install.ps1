$ErrorActionPreference = "Stop"

$TargetDir = Join-Path $HOME ".gemini\antigravity-cli"
$TargetFile = Join-Path $TargetDir "settings.json"
$SourceFile = Join-Path $PSScriptRoot "settings.json"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

$NewSettings = Get-Content $SourceFile -Raw -Encoding UTF8 | ConvertFrom-Json

if (Test-Path $TargetFile) {
    try {
        $RawCurrent = [System.IO.File]::ReadAllText($TargetFile, $Utf8NoBom).TrimStart([char]0xFEFF)
        $CurrentSettings = $RawCurrent | ConvertFrom-Json
    } catch {
        $CurrentSettings = [PSCustomObject]@{}
    }
    foreach ($Property in $NewSettings.PSObject.Properties) {
        $CurrentSettings | Add-Member -NotePropertyName $Property.Name -NotePropertyValue $Property.Value -Force
    }
    $JsonOutput = ($CurrentSettings | ConvertTo-Json -Depth 10) + "`n"
    [System.IO.File]::WriteAllText($TargetFile, $JsonOutput, $Utf8NoBom)
} else {
    $RawSource = [System.IO.File]::ReadAllText($SourceFile, $Utf8NoBom).TrimStart([char]0xFEFF)
    [System.IO.File]::WriteAllText($TargetFile, $RawSource, $Utf8NoBom)
}

Write-Host "Updated $TargetFile successfully (UTF-8 without BOM)." -ForegroundColor Green
Get-Content $TargetFile
