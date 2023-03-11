include atcoder/extra/header/chaemon_header

let N = nextInt()
let a = Seq(N, nextInt())
var m = -int.inf
ans := 0
for i in 0..<N:
  if m < a[i]:ans.inc
  m.max=a[i]

echo ans
