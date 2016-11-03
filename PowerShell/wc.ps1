<#
テキストファイルの文字数(改行を除く)をカウントする

実行例:
PS C:\Users\yutaka> C:\usr\GitHub\MyScript\PowerShell\wc.ps1 C:\sample\付録.txt
Characters : 53409

(C) 2016 Yutaka Hirata
#>

function PrintWordCountFile($filename) {
#    Write-Output "Filename: " $filename

    # SJISファイルを読み込む
    $local:file = Get-Content -Encoding Default $filename

#    Write-Output "Linesは行数, Charactersは文字数(≠バイト数), Wordsは単語数" 
#                 "行数には空白行を含まない" 
#                 "文字数には改行は含まない"
#    $file | Measure-Object -Line -Character -Word | Format-List Lines,Characters,Words
     $file | Measure-Object -Line -Character -Word | Format-List Characters

#    Write-Output "空白行を含む行数"
#    $file | Measure-Object | Format-List Count
}

# main routine

$helpmsg = @'
Help: Word count program"
wc.ps1 <text file1> [<text file2> .. ]

Example:
wc.ps1 test.txt
wc.ps1 *.txt
'@

if ($args.Length -eq 0) {
    Write-Output($helpmsg)
    exit
}

for ($i = 0 ; $i -lt $args.Length ; $i++) {
    PrintWordCountFile($args[$i])
}
