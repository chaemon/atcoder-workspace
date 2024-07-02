when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/structure/randomized_binary_search_tree_with_parent

type D = int # 和
proc op(a, b:int):int = a + b

proc lowerBound[ST:SomeRBST](self:ST, x:int):int =
  proc lowerBoundImpl(t:ST.Node):int =
    if t == self.leaf: return 0
    if x <= t.key:
      return lowerBoundImpl(t.l)
    else:
      return lowerBoundImpl(t.r) + t.l.cnt + 1
    discard
  return lowerBoundImpl(self.root)

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var
    A = Seq[N:nextInt()]
    S = A.sum
  var
    st = initRandomizedBinarySearchTree[D](op, 0)
    k = 0
  for a in A.sorted:
    st.insert_index(k, a)
    k.inc
  #st.write_tree()
  let Q = nextInt()
  for _ in Q:
    let t = nextInt()
    case t:
      of 1:
        var k, d = nextInt()
        k.dec
        # A[k]を削除
        block:
          let t = st.lowerBound(A[k])
          st.erase_index(t)
        A[k] += d
        S += d
        # A[k]を追加
        block:
          let t = st.lowerBound(A[k])
          st.insert_index(t, A[k])
      of 2:
        x := nextInt()
        k := st.lowerBound(x)
        var (t1, t2) = st.split(st.root, k)
        var
          S2 = t2.sum
          S1 = S - S2
          ans = S2 - x * t2.cnt + x * t1.cnt - S1
        echo ans
        st.root = st.merge(t1, t2)
      else:
        doAssert false
    # debug st.to_vec(st.root)
  discard

when not DO_TEST:
  solve()
else:
  discard

