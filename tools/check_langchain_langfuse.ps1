$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$script = Join-Path $PSScriptRoot 'langchain_completion.py'
. (Join-Path $PSScriptRoot 'Import-DotEnv.ps1')

Write-Host "Python:"
python --version

Write-Host "Checking LangChain/Langfuse dependencies and environment..."
$tmp = New-TemporaryFile
try {
  '{}' | Set-Content -LiteralPath $tmp.FullName -Encoding UTF8
  $output = & python $script --request $tmp.FullName --check 2>&1
  $exitCode = $LASTEXITCODE
  $output | ForEach-Object { Write-Host $_ }
  if ($exitCode -ne 0) {
    throw "LangChain/Langfuse preflight failed with exit code ${exitCode}"
  }
} finally {
  Remove-Item -LiteralPath $tmp.FullName -Force -ErrorAction SilentlyContinue
}

Write-Host "LangChain/Langfuse preflight passed"
