<#
�e�L�X�g�t�@�C���̍s���E�������E�P�ꐔ���J�E���g����

���s��:
PS C:\usr\GitHub\MyScript\PowerShell> ./wc.ps1 -Encoding SJIS C:\usr\doc\sample.txt
�s��(�󔒍s������)�͉��L�̂Ƃ���ł�
Lines : 21
������(���s������)�͉��L�̂Ƃ���ł�
Characters : 548
�P�ꐔ�͉��L�̂Ƃ���ł�
Words : 28

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# �R�}���h���C���I�v�V�����̒�`
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

    Write-Output "�s��(�󔒍s������)�͉��L�̂Ƃ���ł�"
     $file | Measure-Object -Line -Character -Word | Format-List Lines
}

function GetCharacterCountFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $enc = [String]$parm[1]
    $file = Get-Content -Encoding $enc -Path $filename

    Write-Output "������(���s������)�͉��L�̂Ƃ���ł�"
     $file | Measure-Object -Line -Character -Word | Format-List Characters
}

function GetWordCountFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $enc = [String]$parm[1]
    $file = Get-Content -Encoding $enc -Path $filename

    Write-Output "�P�ꐔ�͉��L�̂Ƃ���ł�"
     $file | Measure-Object -Line -Character -Word | Format-List Words
}

# �R�}���h���C���w���v
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

# �t�@�C�����̎w�肪�Ȃ���΁A�R�}���h���C���w���v��\������B
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

# ���ׂẴI�v�V���������w��̏ꍇ�A�S�\������B
if ($n -eq 0) {
    GetLineCountFile @($Filename, $Encoding)
    GetCharacterCountFile @($Filename, $Encoding)
    GetWordCountFile @($Filename, $Encoding)
}
