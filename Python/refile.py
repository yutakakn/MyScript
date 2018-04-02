# coding: utf-8
#
# Pythonでの正規表現サンプル
#
# [Usage]
#   refile.py <Tera Term's logfile>
#
# Update: 2018/4/3
#

import re
import sys

# 検索対象のテキスト
textdata = '''
Welcome to Infra workshop!
Kusotsui
Hikariare
Misogi
Misogi999
Misogi9999
'''.strip()

# ファイル名
Filename = ''

def displaymatch(m):
	if (m is None):
		print('No match')
	else:
		print('Match: %r, groups=%r' 
			% (m.group(), m.groups()) 
		)
#		print m.groups(0)

def check_parameter():
	global Filename
	
	# 引数のリスト(実行プログラムも含む)
	av = sys.argv
	ac = len(av)
	print av, ac
	if (ac != 2):
		print "Usage: python %s filename" % av[0]
		sys.exit()
	
	Filename = av[1]

# メインルーチン
def main():
	check_parameter()
	
	# ファイルオープン
	try:
		print Filename
		fp = open(Filename, 'r')
	except IOError as e:
		print 'File open error', e.args
		quit()
	else:
		# オープン成功
		None
	fp.close()
		
		
	
#	print textdata

	# Misogi999の999を探す
	rep = re.compile(r"[Mm].*?(\d+)")
	m = rep.search(textdata)
	displaymatch(m)	
	
if __name__ == "__main__":
	main()
	