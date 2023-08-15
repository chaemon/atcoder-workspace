when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve():
  let D = nextInt()
  let A, B = nextString()
  var
    c = 0
    ans = ""
  let m = max(A.len, B.len)
  proc get(A:string, i:int):char =
    let i = A.len - 1 - i
    if i < 0: return '0'
    else: return A[i]
  for i in m:
    if A.get(i) == '.':
      ans.add '.'
    else:
      c += A.get(i) - '0'
      c += B.get(i) - '0'
      let q = c div 10
      c = c mod 10
      ans.add '0' + c
      c = q
  if c != 0:
    ans.add '0' + c
  ans.reverse
  echo ans
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

