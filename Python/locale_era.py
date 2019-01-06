#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Linuxのロケールファイルの元号(Unicode)を変換する
#  for Python3
# 
# @ glibc
#   glibc-2.27-37-g39071a5539/localedata/locales/ja_JP ファイル
#
# Update: 2019/1/6
# Yutaka Hirata

import os, re, sys

def main():
    file = open('ja_JP')   # ファイルオープン
    lines = file.readlines()

    for line in lines:
        outstr = ""
        while True:
            r = re.search('(<U([0-9a-fA-F]+)>)', line)
            if r:
                outstr += line[:r.start()] + chr(int(r.group(2), base=16))
                line = line[r.end():]
            else:
                outstr += line
                break

        sys.stdout.buffer.write(outstr.encode('utf8'))

    file.close()

if __name__ == "__main__":
	main()
