include atcoder/extra/header/chaemon_header

import atcoder/string

let S = nextString()
let rS = S.reversed.join("")
let N = S.len

let z = S.z_algorithm
let rz = rS.z_algorithm

var ans = 0

for i in 1..N - 2:
  if N - i >= i: continue
  a := z[i]
  b := rz[N - i]
  let s = a + b
  if s < N - i: continue
  # t•¶Žš‚ÆN - i - t•¶Žš
  # 1 <= t <= a
  # 1 <= N - i - t <= b
  # N - i < i
  var tmin = -int.inf
  var tmax = int.inf
  tmin.max=1
  tmax.min=a
  tmin.max=N - i - b
  tmax.min=N - i - 1
#  debug i, a, b, tmin, tmax
  if tmin <= tmax: ans += tmax - tmin + 1

echo ans
