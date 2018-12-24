#!

#
# 「先頭がof_で始まる関数」を含むオブジェクトファイルを探す
#

keys='[[:space:]]+of_.+'

for line in `find . -name "*.o"`
do
	nm $line | egrep $keys
	if [ $? -eq 0 ]; then
		echo -e "\e[31;1m$line\e[m"
		echo ''
	fi
done


