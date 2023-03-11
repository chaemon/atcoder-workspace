include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(S:string) =
  var ans = 0
  for n in 0..9999:
    var n = n
    var s = Seq[10: false]
    for i in 0..<4:
      var r = n mod 10
      s[r] = true
      n = n div 10
    var ok = true
    for i in 0..9:
      if S[i] == '?': continue
      elif S[i] == 'o':
        if not s[i]: ok = false
      elif S[i] == 'x':
        if s[i]: ok = false
      else: assert false
    if ok: ans.inc
  echo ans
  return

# input part {{{
block:
  var S = nextString()
  solve(S)
#}}}

