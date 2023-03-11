include atcoder/extra/header/chaemon_header

let T = nextInt()

for _ in 0..<T:
  let N = nextInt()
  let a = Seq(N, nextInt())
  var ct = initTable[int, int]()
  for i in 0..<N:
    if a[i] notin ct: ct[a[i]] = 0
    ct[a[i]].inc
  var pair = true
  for k, v in ct:
    if v mod 2 == 1: pair = false
  if pair:
    echo "Second"
  elif N mod 2 == 1:
    echo "Second"
  else:
    echo "First"
