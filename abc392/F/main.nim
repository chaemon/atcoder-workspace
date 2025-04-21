when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/structure/splay_tree

solveProc solve(N:int, P:seq[int]):
  Pred P
  var st = initSplayTree[int]()
  for i in N:
    var
      nd = st.initNode(i)
      (t1, t2) = st.split_index(st.root, P[i])
    st.root = st.merge(st.merge(t1, nd), t2)
  var ans:seq[int]
  for i in N:
    var
      (t1, t2) = st.split_index(st.root, i)
      (t3, t4) = st.split_index(t2, 1)
    ans.add t3.key + 1
    st.root = st.merge(t1, st.merge(t3, t4))
  echo ans.join(" ")
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

