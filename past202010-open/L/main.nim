include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let N, Q = nextInt()
  var h = Seq[N: nextInt()]
  var a = initTable[int, int]()
  # odd - even
  for i in countup(0, N - 1, 2):
    for j in [i - 1, i + 1]:
      if j notin 0..<N: continue
      let d = h[j] - h[i]
      if d notin a: a[d] = 0
      a[d].inc
  var odd_diff, even_diff = 0
  for _ in Q:
    let t = nextInt()
    case t:
      of 1:
        let v = nextInt()
        even_diff += v
      of 2:
        let v = nextInt()
        odd_diff += v
      of 3:
        let u = nextInt() - 1
        let v = nextInt()
        for j in [u - 1, u + 1]:
          if j notin 0..<N: continue
          let d = 
            if u mod 2 == 0:
              h[j] - h[u]
            else:
              h[u] - h[j]
          a[d].dec
        h[u] += v
        for j in [u - 1, u + 1]:
          if j notin 0..<N: continue
          let d = 
            if u mod 2 == 0:
              h[j] - h[u]
            else:
              h[u] - h[j]
          if d notin a: a[d] = 0
          a[d].inc
      else:
        assert false
    let s = -(odd_diff - even_diff)
    if s notin a:
      echo 0
    else:
      echo a[s]


  discard

