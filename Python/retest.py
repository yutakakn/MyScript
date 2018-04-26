# coding: utf-8
#
# Pythonでの正規表現サンプル
#
# Update: 2018/3/21
#

import re

# 検索対象のテキスト
textdata = '''
Welcome to Infra workshop!
Kusotsui
Hikariare
Misogi
Misogi999
Misogi9999
'''.strip()

def displaymatch(m):
	if (m is None):
		print('No match')
	else:
		print('Match: %r, groups=%r' 
			% (m.group(), m.groups()) 
		)
#		print m.groups(0)
	

# メインルーチン
def main():
#	print textdata

	# Misogi999の999を探す
	rep = re.compile(r"[Mm].*?(\d+)")
	m = rep.search(textdata)
	displaymatch(m)	
	
if __name__ == "__main__":
	main()
	