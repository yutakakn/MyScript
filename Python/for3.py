# coding: UTF-8

from __future__ import unicode_literals, print_function, division, absolute_import


def main():
    # 九九を求める

    def kuku(MaxValue):

        i_max = MaxValue + 1
        # val = 0
        for i in range(1, i_max):
            for j in range(1, i_max):
                val = i * j
                # print('%3d') % (val),
                print("{0:3} ".format(val), end='')
            print('')

    print('九九を求める -日本式-')
    kuku(9)

    print('九九を求める -インド式-')
    kuku(20)


if __name__ == '__main__':
    main()
    exit(0)

