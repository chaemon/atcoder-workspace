include atcoder/extra/header/chaemon_header
import sets

let N = nextInt()

var s = initSet[int]()
for i in 1..2*N+1:
  s.incl(i)

while true:
  assert s.len > 0
  for e in s:
    echo e
    s.excl e
    break
  let e = nextInt()
  if e == 0: break
  s.excl(e)
