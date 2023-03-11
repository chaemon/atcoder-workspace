include atcoder/extra/header/chaemon_header

const DEBUG = true

let N = nextInt()

var x, y: int

block:
  l := 0
  r := N
  while r - l > 1:
    let m = (l + r) shr 1
    # 0 ..< mを調べる
    echo "? ", 1, " ", m, " ", 1, " ", N
    let T = nextInt()
    if T == m:
      l = m
    else:
      r = m
    x = r
block:
  l := 0
  r := N
  while r - l > 1:
    let m = (l + r) shr 1
    # 0 ..< mを調べる
    echo "? ", 1, " ", N, " ", 1, " ", m
    let T = nextInt()
    if T == m:
      l = m
    else:
      r = m
    y = r

echo "! ", x, " ", y
