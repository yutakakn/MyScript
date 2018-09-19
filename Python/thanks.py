#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from time import sleep

msg = [u'あ', u'り', u'が', u'う']
wait = 0.7

for m in msg:
	print(m, end="", flush=True)
	sleep(wait)

print('\b', end="", flush=True)
sleep(wait)
print(u'と', end="", flush=True)
sleep(wait)
print(u'う', end="", flush=True)
sleep(wait)

print("""
Q.「IEEE」の読みを答えよ

＿人人人人人人人＿
 ＞イエーーー！＜
 ￣Y^Y^Y^Y^Y^Y￣
　 _n
　( ｜　 ハ_ハ
　 ＼＼ ( ‘-^　 )
　　 ＼￣￣　 )
　　　 ７　　/
""")