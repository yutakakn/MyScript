#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# フィボナッチ数列を求める(Python3)
#

(a, b) = (0, 1)
while (b < 100):
	print("{} ".format(b), end="")
	(a, b) = (b, a + b)
print("")
	