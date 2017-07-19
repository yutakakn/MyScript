# coding: UTF-8
# 九九を求める

def kuku(MaxValue):
	max = MaxValue + 1
	val = 0
	for i in range(1, max):
		for j in range(1, max):
			val = i * j
			print('%3d') % (val),
		print('')

print('九九を求める -日本式-')
kuku(9)

print('九九を求める -インド式-')
kuku(20)


