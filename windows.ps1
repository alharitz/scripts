$Output = "windows_baseline.json"

# Installed programs
$programs = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Select-Object DisplayName, DisplayVersion
$programs_user = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Select-Object DisplayName, DisplayVersion

# Winget list
$winget = winget list | Out-String

# Python
$python = pip list --format=json | Out-String

# Node
$node = npm ls -g --json | Out-String

# Ruby
$ruby = gem list --local | Out-String

# Composer PHP
$php = composer global show --format=json | Out-String

# .NET SDK
$dotnet_sdks = dotnet --list-sdks
$dotnet_rt = dotnet --list-runtimes

$data = @{
    programs_hklm = $programs
    programs_hkcu = $programs_user
    winget        = $winget
    python        = $python
    node          = $node
    ruby          = $ruby
    php           = $php
    dotnet_sdks   = $dotnet_sdks
    dotnet_runtime = $dotnet_rt
}

$data | ConvertTo-Json -Depth 5 | Out-File $Output
Write-Host "Generated $Output"
