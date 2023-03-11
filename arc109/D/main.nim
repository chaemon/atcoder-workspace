include atcoder/extra/header/chaemon_header


proc solve() =
  var ax, ay, bx, by, cx, cy = nextInt()
  var ans = 0
  if ax < 0 or bx < 0 or cx < 0:
    ans.inc
    ax *= -1
    bx *= -1
    cx *= -1
  if ay < 0 or by < 0 or cy < 0:
    ans.inc
    ay *= -1
    by *= -1
    cy *= -1
  let px = min([ax, bx, cx])
  let py = min([ay, by, cy])
  if (px, py) notin [(ax, ay), (bx, by), (cx, cy)]:
    discard
  else:
    ans.dec
  echo ans + max(px, py) * 2
  return

# input part {{{
block:
  for _ in 0..<nextInt():
    solve()
#}}}
