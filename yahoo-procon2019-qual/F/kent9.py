n=int(input())
h=list(map(int,input().split()))
for i in range(n):
    try:
        if h[i]-1>=h[i+1]:
            h[i]=h[i]-1
    except IndexError:
        pass
for i in range(n):
    try:
        if h[i]>h[i+1]:
                print("No")
                exit()
    except IndexError:
        pass
print("Yes")

