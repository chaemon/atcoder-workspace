include atcoder/extra/header/chaemon_header

import atcoder/modint
type mint = modint1000000007

import atcoder/extra/math/combination
import atcoder/extra/structure/set_map

let N = nextInt()
let a = Seq(N, nextInt() - 1)

var ans = mint(0)
var mp = initSortedSet[int]()

for i in 0..<N: mp.insert(i)

for i in 0..<N:
  let k = mp.lower_bound(a[i])
  ans += k * mint.fact(N - 1 - i)
  mp.erase(a[i])

echo ans + 1
