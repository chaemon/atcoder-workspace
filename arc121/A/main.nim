include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let N = nextInt()
  let (x, y) = unzip(N, (nextInt(), nextInt()))
  var xs, ys = Seq[(int, int)]
  for i in 0..<N:
    xs.add((x[i], i))
    ys.add((y[i], i))
  xs.sort()
  ys.sort()
  var s = initSet[(int, int)]()
  for i in 0..1:
    for j in 0..1:
      block:
        let i0 = xs[i][1]
        let j0 = xs[^(j + 1)][1]
        if (i0, j0) in s or (j0, i0) in s: continue
        s.incl (i0, j0)
      block:
        let i0 = ys[i][1]
        let j0 = ys[^(j + 1)][1]
        if (i0, j0) in s or (j0, i0) in s: continue
        s.incl (i0, j0)
  var ans = Seq[int]
  for (i, j) in s:
    ans.add max(abs(x[i] - x[j]), abs(y[i] - y[j]))
  ans.sort()
  echo ans[^2]
  discard

