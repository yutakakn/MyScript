<#
テキストファイルの行数・文字数・単語数をカウントする

実行例:
PS C:\usr\GitHub\MyScript\PowerShell> ./wc.ps1 -Encoding SJIS C:\usr\doc\sample.txt
行数(空白行を除く)は下記のとおりです
Lines : 21
文字数(改行を除く)は下記のとおりです
Characters : 548
単語数は下記のとおりです
Words : 28

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# コマンドラインオプションの定義
Param(
    [switch]$c,
    [switch]$l,
    [switch]$w,
    [ValidateSet("Default", "SJIS", "UTF8")]$Encoding,
    [string]$Filename
)

function GetLineCountFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $enc = [String]$parm[1]
    $file = Get-Content -Encoding $enc -Path $filename

    Write-Output "行数(空白行を除く)は下記のとおりです"
     $file | Measure-Object -Line -Character -Word | Format-List Lines
}

function GetCharacterCountFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $enc = [String]$parm[1]
    $file = Get-Content -Encoding $enc -Path $filename

    Write-Output "文字数(改行を除く)は下記のとおりです"
     $file | Measure-Object -Line -Character -Word | Format-List Characters
}

function GetWordCountFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $enc = [String]$parm[1]
    $file = Get-Content -Encoding $enc -Path $filename

    Write-Output "単語数は下記のとおりです"
     $file | Measure-Object -Line -Character -Word | Format-List Words
}

# コマンドラインヘルプ
$helpmsg = @'
Usage: wc.ps1 [OPTION] <FILE>
Word count program prints newline, word, and byte counts for each FILE.
FILE can accept wildcard character.

  -c   print byte counts
  -l   print newline counts
  -w   print word counts
  -Encoding  SJIS|UTF8
      specify encoding character

Example:
./wc.ps1 -Encoding SJIS -Filename test.txt
./wc.ps1 -l -Encoding SJIS test.txt
./wc.ps1 -c -Encoding SJIS *.txt
'@

# ファイル名の指定がなければ、コマンドラインヘルプを表示する。
if ([String]::IsNullOrEmpty($Filename)) {
    Write-Output($helpmsg)
    exit
}

if ([String]::IsNullOrEmpty($Encoding)) {
    $Encoding = "Default"
}
if ($Encoding -eq "SJIS") {
    $Encoding = "Default"
}

#echo "[$Filename]"
#echo "[$Encoding]"

$n = 0
if ($l) {
    GetLineCountFile @($Filename, $Encoding)
    $n++
}
if ($c) {
    GetCharacterCountFile @($Filename, $Encoding)
    $n++
}
if ($w) {
    GetWordCountFile @($Filename, $Encoding)
    $n++
}

# すべてのオプションが未指定の場合、全表示する。
if ($n -eq 0) {
    GetLineCountFile @($Filename, $Encoding)
    GetCharacterCountFile @($Filename, $Encoding)
    GetWordCountFile @($Filename, $Encoding)
}
