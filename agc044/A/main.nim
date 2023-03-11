include atcoder/extra/header/chaemon_header
import heapqueue

const DEBUG = true

proc main() =
  let T = nextInt()
  for _ in T:
    var ans = int.inf
    let N, A, B, C, D = nextInt()
    q := initHeapQueue[tuple[d, N:int]]()
    dist := initTable[int,int]()
    q.push((0, N))
    let a = [A, B, C]
    while q.len > 0:
      let (d, N) = q.pop()
      if N in dist: continue
      dist[N] = d
      ans.min= (N *! D) +! d
#      debug d, N, N * D + d
      if N == 0: break
      for i,p in [2, 3, 5]:
        if N < p: q.push((d + N * D, 0))
        else:
          var r = N mod p
          q.push((d + r * D + a[i], (N - r) div p))
          if r != 0:
            let r = p - r
            q.push((d + r * D + a[i], (N + r) div p))
    echo ans
  return

main()
