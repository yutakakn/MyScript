#
# テキストファイルの行数と単語数をカウントする
#

#param(
#    [Parameter(Mandatory=$true)][string]$filename
#)

function PrintWordCountFile($filename) {
    Write-Output "Filename: " $filename

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

for ($i = 0 ; $i -lt $args.Length ; $i++) {
    PrintWordCountFile($args[$i])
}
