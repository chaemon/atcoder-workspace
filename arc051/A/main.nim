include atcoder/extra/header/chaemon_header

const YES = "YES"
const NO = "NO"

dist2(x1, y1, x2, y2:int)=>(x1 - x2)^2 + (y1 - y2)^2

proc solve() =
  let x1, y1, r = nextInt()
  let x2, y2, x3, y3 = nextInt()
  var RED, BLUE:string
  if x1 in x2..x3 and y1 in y2..y3:
    # center is inner
    if abs(x2 - x1) >= r and abs(x3 - x1) >= r and abs(y2 - y1) >= r and abs(y3 - y1) >= r:
      RED = NO
    else:
      RED = YES
  else:
    # center is outer
    RED = YES

  BLUE = NO
  if dist2(x1, y1, x2, y2) > r^2:BLUE = YES
  if dist2(x1, y1, x2, y3) > r^2:BLUE = YES
  if dist2(x1, y1, x3, y2) > r^2:BLUE = YES
  if dist2(x1, y1, x3, y3) > r^2:BLUE = YES
  echo RED
  echo BLUE
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
