include atcoder/extra/header/chaemon_header

proc solve(S:string) =
  var
    a = 0
    b = 0
  for i in 0..<26:
    let t = S.count(('a'.ord + i).chr)
    if t mod 2 == 1:a.inc
    b += t div 2
  if a == 0 or a == 1:echo S.len;return
  else: echo (b div a) * 2 + 1
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}
