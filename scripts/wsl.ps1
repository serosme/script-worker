$DateStr = (Get-Date).ToString('yyyyMMdd')
$Name = $DateStr
$User = "u$DateStr"
$Pass = $DateStr

$tmp = [IO.Path]::GetTempFileName()
try {
    [IO.File]::WriteAllText($tmp, "$User`n$Pass`n$Pass`n")
    $p = Start-Process -FilePath 'wsl.exe' `
        -ArgumentList @('--install', '--name', $Name, '-d', 'Debian') `
        -RedirectStandardInput $tmp -NoNewWindow -Wait -PassThru -ErrorAction Stop
    if ($p.ExitCode -ne 0) {
        throw "wsl --install failed (exit $($p.ExitCode))"
    }
} finally {
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
}

Write-Output "OK name=$Name user=$User"
