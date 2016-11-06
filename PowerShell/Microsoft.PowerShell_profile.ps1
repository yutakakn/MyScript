<#
PowerShell用プロファイル設定 for Windows10(PowerShell 5.1)

PS>notepad $profile

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# コマンドラインの操作モードをEmacs系にする・ベル音を消す・ヒストリの重複をなくす
Set-PSReadlineOption -EditMode Emacs -BellStyle None -HistoryNoDuplicates

# カレントディレクトリの設定
Set-Location C:\usr\GitHub\MyScript\PowerShell

# タイトルを設定する
$a = (Get-Host).UI.RawUI 
$add_str = " - Yutaka Hirata"
if (! $a.WindowTitle.Contains($add_str)) {
   $a.WindowTitle += $add_str
}

# F2キーを押すと、行全体を選択状態にする。
#Set-PSReadlineKeyHandler -Key F2 -Function SelectAll


#
# F2キーを押すと、行全体を選択状態にして、クリップボードへコピーする。
#
Set-PSReadlineKeyHandler -Chord F2 `
                         -BriefDescription SelectEntireCommandLine `
                         -Description "Selects the entire command line" `
                         -ScriptBlock {
    param($key, $arg)
  
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine($key, $arg)
  
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # 選択状態にする  
    while ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar($key, $arg)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    }

    # クリップボードへ送信する
    [Microsoft.PowerShell.PSConsoleReadLine]::CopyOrCancelLine($key, $arg)
}



#
# F7キーを押すと、下記ヒストリファイルから過去の履歴を表示および選択可能になる。
# 
# (get-psreadlineoption).HistorySavePath
# C:\Users\yutaka\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt
#
Set-PSReadlineKeyHandler -Key F7 `
                         -BriefDescription History `
                         -LongDescription 'Show command history' `
                         -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern)
    {
        $pattern = [regex]::Escape($pattern)
    }

    $history = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadlineOption).HistorySavePath))
        {
            if ($line.EndsWith('`'))
            {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines)
                {
                    "$lines`n$line"
                }
                else
                {
                    $line
                }
                continue
            }

            if ($lines)
            {
                $line = "$lines`n$line"
                $lines = ''
            }

            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
            {
                $last = $line
                $line
            }
        }
    )
    $history.Reverse()

    $command = $history | Out-GridView -Title History -PassThru
    if ($command)
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
    }
}


