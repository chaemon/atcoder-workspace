when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string):
  var S = '(' & S & ')'
  var s = initSet[char]()
  proc calc(i:var int) =
    doAssert S[i] == '('
    var old_s = s
    i.inc
    while i < S.len:
      if S[i] == '(':
        calc(i)
      elif S[i] == ')':
        i.inc
        break
      else:
        if S[i] in s:
          echo NO;quit(0)
        else:
          s.incl S[i]
        i.inc
    s = old_s.move
  var i = 0
  calc(i)
  doAssert i == S.len
  echo YES
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

