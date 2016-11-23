<#
練習用のテストスクリプト集

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# ウィンドウハンドルとタイトルを列挙する
function getWindowHandle() {
    PARAM($parm)

    $list = [System.Diagnostics.Process]::GetProcesses()
    foreach ($hd in $list) {
       $s =  "Handle=" + [String]$hd.Handle + " PID=" + $hd.Id + ":" +  $hd.MainWindowTitle
       echo $s
    }
}

#
# メインルーチン
#
getWindowHandle @()
