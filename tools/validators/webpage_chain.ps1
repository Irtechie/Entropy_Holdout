param(
  [Parameter(Mandatory=$true)]
  [string]$RunRoot,
  [string]$SpecPath = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path 'benchmarks/entropy_workloads/webpage_chain.json')
)

$ErrorActionPreference = 'Stop'

function Fail($message) {
  throw "webpage-chain validation failed: $message"
}

function Read-JsonFile($path) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    Fail "missing spec: $path"
  }
  return Get-Content -Raw -LiteralPath $path | ConvertFrom-Json -Depth 32
}

function Assert-Contains($text, $needle, $message) {
  if ($text -notlike "*$needle*") {
    Fail $message
  }
}

$spec = Read-JsonFile $SpecPath
$siteRoot = Join-Path $RunRoot $spec.output_dir
if (-not (Test-Path -LiteralPath $siteRoot -PathType Container)) {
  Fail "missing site directory: $siteRoot"
}

$pages = @($spec.pages)
foreach ($page in $pages) {
  $pagePath = Join-Path $siteRoot $page.path
  if (-not (Test-Path -LiteralPath $pagePath -PathType Leaf)) {
    Fail "missing page: $($page.path)"
  }
  $html = Get-Content -Raw -LiteralPath $pagePath
  Assert-Contains $html '<!doctype html>' "page $($page.path) is missing doctype"
  Assert-Contains $html ([string]$page.title) "page $($page.path) is missing title text"
  if ($page.backlink) {
    Assert-Contains $html "href=`"$($page.backlink)`"" "page $($page.path) is missing backlink to $($page.backlink)"
  }
}

$requiredNavPages = @($pages | Where-Object { [int]$_.order -le 4 })
foreach ($page in $requiredNavPages) {
  $pagePath = Join-Path $siteRoot $page.path
  $html = Get-Content -Raw -LiteralPath $pagePath
  if ([int]$page.order -ge [int]$spec.shared_nav_required_from_stage) {
    foreach ($navPage in $requiredNavPages) {
      Assert-Contains $html "href=`"$($navPage.path)`"" "page $($page.path) shared nav is missing $($navPage.path)"
    }
  }
}

$finalPages = @($pages | Where-Object { [int]$_.order -le 5 })
foreach ($page in $finalPages) {
  $pagePath = Join-Path $siteRoot $page.path
  $html = Get-Content -Raw -LiteralPath $pagePath
  if ([int]$page.order -ge [int]$spec.shared_table_required_from_stage -or $page.path -eq 'index.html') {
    Assert-Contains $html 'data-entropy-shared-table="factory-links"' "page $($page.path) is missing shared nested table"
  }
}

[pscustomobject]@{
  ok = $true
  workload = $spec.id
  pages_checked = $pages.Count
  site_root = $siteRoot
} | ConvertTo-Json -Compress
