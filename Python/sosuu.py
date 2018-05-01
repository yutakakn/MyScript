#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# 素数を求める(Python3)
#

# エラトステネスのふるい
def sub3(maxnum):
	sieve = [True] * maxnum
	sieve[0] = False
	sieve[1] = False
#	print(sieve)
	for i in range(2, maxnum//2):
		if sieve[i]:
			for j in range(i*2, maxnum, i):
				sieve[j] = False
	
	# 素数の表示
	for i in range(maxnum):
		if sieve[i]:
			print(i, end=" ")
	print("\n2～{}までで以上が素数です\n".format(maxnum))


def sub2(maxnum):
	for num in range(2, maxnum):
		flag = 0
		for i in range(2, num):
			if num % i == 0:
				#print("{0}は{1}×{2}と同じです".format(num, i, num//i))
				flag = 1
				continue
		if flag == 0:
			print(num, end=" ")
	print("\n2～{}までで以上が素数です\n".format(maxnum))

def sub1(maxnum):
	for num in range(2, maxnum):
		for i in range(2, num):
			if num % i == 0:
				#print("{0}は{1}×{2}と同じです".format(num, i, num//i))
				break
		else:
			# 前記forループを回りきるとelse節に入ってくる
			# 前記ifに対応するelseではない
			print(num, end=" ")
	print("\n2～{}までで以上が素数です\n".format(maxnum))

def main():
	sub1(50)
	sub2(50)
	sub3(50)

if __name__ == "__main__":
	main()
