<#
Windows reproducible build script for the project.
- Finds Visual Studio developer tools (via vswhere) and calls VsDevCmd.bat to set MSVC environment.
- Runs `cargo build --release` inside that environment to ensure the MSVC linker is used.
Usage:
  - Open PowerShell as Administrator or normal user.
  - From repo root: .\build.ps1
  - Optionally: .\build.ps1 -Arch x64
#>

param(
    [ValidateSet('x86','x64','arm64')]
    [string]$Arch = 'x64'
)

Write-Host "Starting reproducible Windows release build (arch: $Arch)..."

# Try to locate vswhere and use it to find a Visual Studio installation
$vswherePath = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'

$vsDevCmd = $null
if (Test-Path $vswherePath) {
    try {
        $instPath = & $vswherePath -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null
        if ($instPath) {
            $candidate = Join-Path $instPath 'Common7\Tools\VsDevCmd.bat'
            if (Test-Path $candidate) {
                $vsDevCmd = $candidate
            }
        }
    } catch {
        Write-Warning "vswhere invocation failed: $_"
    }
}

# Fallback: common locations (if vswhere not present)
if (-not $vsDevCmd) {
    $fallback = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat'
    if (Test-Path $fallback) { $vsDevCmd = $fallback }
}

if ($vsDevCmd) {
    Write-Host "Found VsDevCmd: $vsDevCmd"
    # Use cmd to call VsDevCmd and then run cargo in the same process (so environment is applied).
    $cmd = "call `"$vsDevCmd`" -arch=$Arch && cargo build --release"
    Write-Host "Running: cmd /c $cmd"
    $exitCode = cmd /c $cmd
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed (exit code $LASTEXITCODE). See output above."
        exit $LASTEXITCODE
    } else {
        Write-Host "Release build finished successfully."
    }
} else {
    Write-Warning "VsDevCmd not found. Make sure Visual Studio with 'Desktop development with C++' is installed."
    Write-Host "Falling back to running 'cargo build --release' in the current environment."
    cargo build --release
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } else { Write-Host "Release build finished." }
}

# Optional post-build suggestions
Write-Host ""
Write-Host "Artifact:"
if (Test-Path "target\release") {
    Get-ChildItem -Path target\release -Filter *.exe -File -ErrorAction SilentlyContinue | Select-Object Name, Length | ForEach-Object {
        Write-Host " - $($_.Name) ($([math]::Round($_.Length / 1KB, 1)) KB)"
    }
}
Write-Host ""
Write-Host "Tip: sign the executable for distribution and consider compressing with UPX if desired."

Notes:
- The Makefile project executes `powershell -ExecutionPolicy Bypass -File build.ps1 -Arch x64` for both Debug and Release configurations.
- Ensure `build.ps1` is executable and that your AV/Defender is not blocking files in `target\`.
- Use `cargo clean` to remove build artifacts if you encounter file-lock or permission issues.