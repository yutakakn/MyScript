<#
�e�L�X�g�t�@�C���̕�����(���s������)���J�E���g����

���s��:
PS C:\Users\yutaka> C:\usr\GitHub\MyScript\PowerShell\wc.ps1 C:\sample\�t�^.txt
Characters : 53409

(C) 2016 Yutaka Hirata
#>

function PrintWordCountFile($filename) {
#    Write-Output "Filename: " $filename

    # SJIS�t�@�C����ǂݍ���
    $local:file = Get-Content -Encoding Default $filename

#    Write-Output "Lines�͍s��, Characters�͕�����(���o�C�g��), Words�͒P�ꐔ" 
#                 "�s���ɂ͋󔒍s���܂܂Ȃ�" 
#                 "�������ɂ͉��s�͊܂܂Ȃ�"
#    $file | Measure-Object -Line -Character -Word | Format-List Lines,Characters,Words
     $file | Measure-Object -Line -Character -Word | Format-List Characters

#    Write-Output "�󔒍s���܂ލs��"
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
