<#
ファイルのSHAチェックサムを計算する

実行例:

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# コマンドラインオプションの定義
 param (
    [string]$Filename,
    [ValidateSet("SHA1", "SHA256", "SHA384", "SHA512")]$a,
    [string]$c
 )

 # デフォルトハッシュアルゴリズム
$DefaultHashAlgorithm = "SHA256"

function getChecksumFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $algo = [String]$parm[1]

#    echo "$filename, $algo"
    $s = Get-FileHash -Algorithm "$algo" "$filename" | Format-List Hash | Out-String -Stream | ?{$_ -ne ""}
    # Hash : 096FB4548E5EAF7DAE2C06AF318866E2EF3C8186D284120BBBC6C99F52CEF7FF
    $t = $s.Split("")
    # Hash
    # :
    # 096FB4548E5EAF7DAE2C06AF318866E2EF3C8186D284120BBBC6C99F52CEF7FF
    $hash = $t[2].ToLower()
    return $hash
}

function verifyChecksumFile() {
    PARAM($parm)
    $filename = [String]$parm[0]
    $algo = [String]$parm[1]
    $sumfile = [String]$parm[2]

    # パスからファイル名のみを取り出す
    $basename = [System.IO.Path]::GetFileName($filename)
#    echo $basename

    # チェックサムファイルからハッシュ値を取り出す。
    $expected_checksum = ((Get-Content $sumfile | Select-String -Pattern $basename) -split " ")[3].ToLower()
 #   echo $expected_checksum

    $download_checksum = getChecksumFile @($filename, $algo)

    echo "Download Checksum: $download_checksum"
    echo "Expected Checksum: $expected_checksum"
    if ( $download_checksum -eq "$expected_checksum" ) {
	    echo "Checksum test passed!"
    } else {
	    echo "Checksum test failed."
    }
}

 # コマンドラインヘルプ
$helpmsg = @'
Usage: checksum.ps1 <FILE>
           checksum.ps1 [-a SHA1|SHA256|SHA384|SHA512] <FILE>
           checksum.ps1 [-c sumfile] <FILE>
Print or check SHA checksums.
  -a   Hash Algorithm(SHA1, SHA256, SHA384, SHA512)
  -c   read SHA sums from the FILEs and check them

Example:
./checksum.ps1 D:\Linux\Fedora.iso
./checksum.ps1 -a SHA1 D:\Linux\Fedora.iso
 ./checksum.ps1 -c D:\Linux\Fedora-CHECKSUM D:\Linux\Fedora.iso
'@

# ファイル名の指定がなければ、コマンドラインヘルプを表示する。
if ([String]::IsNullOrEmpty($Filename)) {
    Write-Output($helpmsg)
    exit
}

# アルゴリズムの指定がない場合
if ([String]::IsNullOrEmpty($a)) {
    $a = $DefaultHashAlgorithm
}

#echo "$Filename"
#echo "$c"
#echo "$a"

# チェックサムファイルの指定がない場合、そのままハッシュ計算する。
if ([String]::IsNullOrEmpty($c)) {
    $ret = getChecksumFile @($Filename, $a)
    echo "$ret *$Filename"

} else {
    verifyChecksumFile @($Filename, $a, $c)
}
