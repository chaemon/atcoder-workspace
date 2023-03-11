include atcoder/extra/header/chaemon_header

const DEBUG = true

# Failed to predict input format
block main:
  let N, M = nextInt()
  let a = Seq[N : nextString()]
  var ans = Seq[N, M: int]
  for i in 0..<N:
    for j in 0..<M:
      s := 0
      for d in -1..1:
        let i2 = i + d
        if i2 notin 0..<N: continue
        for e in -1..1:
          let j2 = j + e
          if j2 notin 0..<M: continue
          if a[i2][j2] == '#': s.inc
      ans[i][j] = s
  for i in 0..<N:
    echo ans[i].join()

