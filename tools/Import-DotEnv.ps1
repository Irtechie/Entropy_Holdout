param(
  [string]$Path = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path '.env'),
  [switch]$Override
)

if (-not (Test-Path -LiteralPath $Path)) {
  return
}

foreach ($line in Get-Content -LiteralPath $Path) {
  $trimmed = $line.Trim()
  if (-not $trimmed -or $trimmed.StartsWith('#')) {
    continue
  }

  $separator = $trimmed.IndexOf('=')
  if ($separator -lt 1) {
    continue
  }

  $name = $trimmed.Substring(0, $separator).Trim()
  $value = $trimmed.Substring($separator + 1).Trim()
  if (-not $name -or $name -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
    continue
  }

  if (
    ($value.StartsWith('"') -and $value.EndsWith('"')) -or
    ($value.StartsWith("'") -and $value.EndsWith("'"))
  ) {
    $value = $value.Substring(1, $value.Length - 2)
  }

  if ($Override -or -not [Environment]::GetEnvironmentVariable($name, 'Process')) {
    [Environment]::SetEnvironmentVariable($name, $value, 'Process')
  }
}
