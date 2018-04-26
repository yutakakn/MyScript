#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# 生年月日から曜日を求める(Python3)
#
# Update: 2018/4/26
#

import sys
import datetime
import math

#              0     1    2     3    4     5    6
weekdaystr = ['月', '火', '水', '木', '金', '土', '日']

# ツェラーの公式で求める
def sub2(year, month, day):
	if (month == 1 or month == 2):
		month += 12
		year -= 1
	
	C = math.floor(year / 100)
	Y = year % 100
	v = math.floor( 26*(month+1)/10 )
	w = math.floor(Y / 4)
	x = -2*C + math.floor(C / 4)
	h = (day + v + Y + w + x) % 7
#	print(year, month, day)
#	print(C, Y, v, w, x, h)
	# 0-6で土曜-金曜となるため、+5ずらす。
	h = (h + 5) % 7
	print("{}/{}/{}は{}曜日でした".format(year, month, day, weekdaystr[h]) )

# 標準モジュールで求める
def sub1(argstr):
	try:
		s = datetime.datetime.strptime(argstr, '%Y/%m/%d')
		print("{}は{}曜日でした".format(argstr, weekdaystr[s.weekday()]) )
	except ValueError:
		print("入力エラーです: {}".format(argstr))

# メインルーチン
def main():
	# 人類滅亡の日、改めいつもの七夕
	birthday = '1999/7/7'
	sub1(birthday)
	sub2(1999, 7, 7)
		
	sys.exit(0)
	
if __name__ == "__main__":
	main()
