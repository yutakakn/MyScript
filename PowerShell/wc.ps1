#
# �e�L�X�g�t�@�C���̍s���ƒP�ꐔ���J�E���g����
#

#param(
#    [Parameter(Mandatory=$true)][string]$filename
#)

function PrintWordCountFile($filename) {
    Write-Output "Filename: " $filename

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

for ($i = 0 ; $i -lt $args.Length ; $i++) {
    PrintWordCountFile($args[$i])
}
