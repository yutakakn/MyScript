#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# ラムダ式(Python3)
#

def sub(price, money):
	change = money - (int)( (lambda a:a*1.08)(price) )
	print("おつりは{}円 {}".format(change, "（´･ω･｀）"))


def main():
	sub(100, 500)

if __name__ == "__main__":
	main()
