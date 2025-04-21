import matplotlib.pyplot as plt
import matplotlib.patches as patches

def get_cmap(n, name='hsv'):
    '''Returns a function that maps each index in 0, 1, ..., n-1 to a distinct 
    RGB color; the keyword argument name must be a standard mpl colormap name.'''
    return plt.cm.get_cmap(name, n)



#plt.clf()
fig, ax = plt.subplots(figsize=(10,10))
ax.set_xlim(0, 10000)
ax.set_ylim(0, 10000)
#plt.figure(figsize=(10,10))

ax.set_aspect('equal')
ax.axis('off')
fig.subplots_adjust(left=0,right=1,bottom=0,top=1)

N = 800
ans_p = []

with open("./visualizer_data.txt") as f:
    prev = None
    for i in range(N):
        x, y = map(int, next(f).split(" "))
        p = [x, y]
        ax.plot(x, y, marker=".", color='black')
        ans_p.append(p)

print(ans_p)

query = []
trees = []

with open("./out0") as f:
    while True:
        line = next(f).strip().split(" ")
        if line[0] == '!': break
        query.append(list(map(int, line[2:])))
    for line in f:
        a = list(map(int, line.strip().split()))
        print(a)
        n = len(a)
        tree = []
        for _ in range(n - 1):
            line = list(map(int, next(f).strip().split()))
            assert len(line) == 2
            i, j = line
            tree.append((i,j))
        trees.append(tree)

print(trees)

cmap = get_cmap(len(trees))

for x,tree in enumerate(trees):
    c = cmap(x)
    for p in tree:
        print(p)
        i, j = p
        ax.plot([ans_p[i][0], ans_p[j][0]], [ans_p[i][1], ans_p[j][1]], c=c)

plt.show(block=True)
