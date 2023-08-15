when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:string):
  var
    v:seq[int]
    ans = newSeq[int](N)
  for i in N:
    if S[i] == '1':
      ans[i] = i
    else:
      v.add i
  if v.len == 1:
    echo -1;return
  for i in v.len:
    let j = (i + 1) mod v.len
    ans[v[i]] = v[j]
  for i in N:
    ans[i].inc
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

