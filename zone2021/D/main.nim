include atcoder/extra/header/chaemon_header

import deques

const DEBUG = true

proc solve(S:string) =
  d := initDeque[char]()
  reversed := false
  for s in S:
    if s == 'R':
      reversed = not reversed
    else:
      if not reversed:
        d.addLast(s)
        if d.len >= 2 and d[^1] == d[^2]:
          discard d.popLast()
          discard d.popLast()
      else:
        d.addFirst(s)
        if d.len >= 2 and d[0] == d[1]:
          discard d.popFirst()
          discard d.popFirst()
  var T = ""
  for s in d: T.add s
  if reversed: T = T.reversed.join("")
  echo T
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

