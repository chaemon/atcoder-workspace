when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string):
  var q = initDeque[char]()
  for s in S:
    if s == ')':
      if q.len == 0: echo NO;return
      let t = q.popLast()
      if t != '(': echo NO;return
    elif s == ']':
      if q.len == 0: echo NO;return
      let t = q.popLast()
      if t != '[': echo NO;return
    elif s == '>':
      if q.len == 0: echo NO;return
      let t = q.popLast()
      if t != '<': echo NO;return
    else:
      q.addLast s
  if q.len == 0:
    echo YES
  else:
    echo NO
  doAssert false

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

