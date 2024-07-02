a = []

def sumd(n):
    s = 0
    while n > 0:
        s += n % 10
        n //= 10
    return s


N = 0

for i in range(1, 241, 2):
    N *= 10 ** 60
    N += 5 ** 50 * i

print("N = ", N)

prev = 10**100000

for i in range(51):
    t = sumd(N)
    print(i, t)
    assert prev > t
    prev = t
    N *= 2
