<#
���K�p�̃e�X�g�X�N���v�g�W

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# �E�B���h�E�n���h���ƃ^�C�g����񋓂���
function getWindowHandle() {
    PARAM($parm)

    $list = [System.Diagnostics.Process]::GetProcesses()
    foreach ($hd in $list) {
       $s =  "Handle=" + [String]$hd.Handle + " PID=" + $hd.Id + ":" +  $hd.MainWindowTitle
       echo $s
    }
}

#
# ���C�����[�`��
#
getWindowHandle @()
