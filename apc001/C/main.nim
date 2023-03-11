include atcoder/extra/header/chaemon_header

import posix

const TEST = false

type Interactive = object
  case check: bool
    of true:
      ans: string
      time, limit: int
    of false:
      discard

proc ask(self: var Interactive, i:int):string = 
  if self.check:
    self.time.inc
    assert(self.time <= self.limit, "Query Limit Exceed!!")
    case self.ans[i]:
      of 'V': result = "Vacant"
      of 'M': result = "Male"
      of 'F': result = "Female"
      else: assert(false)
    echo "input: ", i
    echo "          answer: ", result
  else:
    echo i
    return nextString()


proc add_stdin(s:string) =
  var s = s
  s &= "\n"
  var fd:array[0..1, cint]
  discard pipe(fd)
  discard close(0)
  discard dup2(fd[0], 0.cint)
  discard close(fd[0])
  fd[0] = 0.cint
  discard write(fd[1], s.cstring, s.len)

when TEST:
  let ans = "FMFMFMVMFMFMFMFVMFMFMFMFMFMVMFMFMFMFMFM"
  add_stdin(ans.len.toStr)
  var interactive = Interactive(check:true, ans: ans, time: 0, limit: 20)
else:
  var interactive = Interactive(check:false)

proc solve(N:int) =
  var
    l = 0
    r = N - 1
  var lv = interactive.ask(l)
  if lv == "Vacant": return
  var rv = interactive.ask(r)
  if rv == "Vacant": return
  while r - l > 1:
    let m = (l + r) shr 1
    var mv = interactive.ask(m)
    if mv == "Vacant": return
    if (lv == mv and (m - l) mod 2 == 1) or (lv != mv and (m - l) mod 2 == 0):
      r = m
      rv = mv
    else:
      l = m
      lv = mv
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
