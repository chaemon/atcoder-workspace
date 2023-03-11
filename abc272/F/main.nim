when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/string
import atcoder/segtree

#proc einf():int = int.inf
#proc e0():int = 0

solveProc solve(N:int, S:string, T:string):
  # 0 ..< N * 2 - 1: S
  # N * 2 .. ^1: T
  s := S & S[0 .. ^2] & '?' & T & T[0 .. ^2]
  var
    sa = suffix_array(s)
    la = s.lcp_array(sa)
    st = initSegTree[int](la, (a, b:int) => min(a, b), proc():int = int.inf)
    #st = initSegTree[int](la, (a, b:int) => min(a, b), einf)
    st2 = initSegTree[int](sa.len, (a, b:int) => a + b, proc():int = 0)
    #st2 = initSegTree[int](sa.len, (a, b:int) => a + b, e0)
    ans = 0
  #for i in s.len:
  #  debug i, s[sa[i] .. ^1]

  for i in sa.len:
    if sa[i] in N * 2 ..< N * 2 + N:
      st2[i] = 1
    else:
      st2[i] = 0

  for i in sa.len:
    if sa[i] < N:
      # st[j .. i - 1] >= Nとなる最小のj
      proc f(a:int):bool = a >= N
      var j = if i > 0: st.minLeft(i, f) else: 0
      ans += st2[j .. ^1]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

