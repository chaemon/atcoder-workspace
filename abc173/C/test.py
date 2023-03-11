a = [0,0,0,0,0,0]

def f(i):
    if i == 6:
        print(a)
        return
    a[i] = 0
    f(i + 1)
    a[i] = 1
    f(i + 1)

f(0)
