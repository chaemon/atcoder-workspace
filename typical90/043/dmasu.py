
H, W = list(map(int, input().split()))
rs, cs = list(map(int, input().split()))
rs, cs = rs - 1, cs - 1
rt, ct = list(map(int, input().split()))
rt, ct = rt - 1, ct - 1

S = []
for _ in range(H):
    S.append(list(input()))

def id(i, j, d):
    return i * W * 4 + j * 4 + d
def id_tuple(t):
    return id(t[0], t[1], t[2])

D = [(-1,0),(1,0),(0,1),(0,-1)]
G = [None for i in range(H * W * 4)]
for i in range(H):
    for j in range(W):
        if S[i][j] == '.':
            for k in range(4):
                G[id(i,j,k)] = []
                for l in range(4):
                    if l != k:
                        G[id(i,j,k)].append([id(i,j,l), 1])
                for d in range(4):
                    dy, dx = D[d]
                    if 0<=i+dy<H and 0<=j+dx<W and S[i+dy][j+dx] == '.' and k == d:
                        G[id(i,j,k)].append([id(i+dy, j+dx, k),0])

def dijkstra(N,G,a,INF=10**15):
    '''
     - 幅優先探索:ある頂点からの距離を計算する
     - 計算量はO((V+E)logV) #二分ヒープ
    n:頂点数 1始まりを想定
    g:グラフ
    s:距離の始点
    return:sからの距離の配列。dist[0]=-1
    '''
    from collections import deque
    #import heapq
    dq = deque()
    dist = [INF for i in range(len(G))]# dist[i]：頂点 0 から頂点 i への暫定的な経路長
    for s in a:
        dist[s] = 0
        dq.append(s)
    done = [False for key in range(len(G))]      # done[i]：頂点 i の最短距離が確定しているか

    #hq = [] # (仮の最短距離、頂点番号) を管理するヒープ
    #heapq.heapify(hq)

    # ヒープに最初の時点における情報を入れておく(いらない？)
    #for v in G:
    #    heapq.heappush(hq, (dist[v], v))

    #while len(hq) > 0:
    while len(dq) > 0:
        # ヒープの先頭要素を取り出す (v は頂点番号、d は 0 → v の仮の最短距離)
        #[d, v] = heapq.heappop(hq)
        v = dq.popleft()
        # 頂点 v の最短距離がすでに確定しているなら、何もしない
        if done[v]: continue

        # 頂点 v を始点とする辺 e について、更新を行う
        for e in G[v]:
            if dist[e[0]] > dist[v] + e[1]:
                # 距離の更新がある場合には、ヒープに更新後の情報を入れる
                dist[e[0]] = dist[v] + e[1]
                #heapq.heappush(hq, (dist[e[0]], e[0]))
                if e[1] == 1:
                    dq.append(e[0])
                elif e[1] == 0:
                    dq.appendleft(e[0])
        # 頂点 v の最短距離を確定させる
        done[v] = True
    return dist

N = W*H*4
ans = 10**10
a = []
for d1 in range(4):
    s = id(rs, cs, d1)
    a.append(s)

#res = dijkstra(N,G,a)

for d2 in range(4):
    ans = min(ans, res[id(rt, ct, d2)])
print(ans)


