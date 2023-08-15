when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

type Node = ref object
  next:array[2, Node] # 次のノード
  ct: int # 個数
  sample: int # ct >= 1のときの下位の一つ
  xor_min: int # Nodeの下位の異なる2つのxorの最小値

const B = 30

# Failed to predict input format
solveProc solve():
  proc allocNode():Node = Node(ct:0, sample: 0, xor_min: int.inf)
  var root = allocNode()
  proc update_node(nd:var Node, h:int) =
    # xor_minの設定
    nd.xor_min = int.inf
    if nd.next[0].ct >= 2 or nd.next[1].ct >= 2:
      for x in 0 .. 1:
        nd.xor_min.min=nd.next[x].xor_min
    elif nd.next[0].ct >= 1 and nd.next[1].ct >= 1:
      nd.xor_min.min= (1 shl h) + (nd.next[0].sample xor nd.next[1].sample)
    if nd.ct > 0:
      for x in 0 .. 1:
        if nd.next[x].ct >= 1:
          nd.sample = x * (1 shl h) + nd.next[x].sample
          break

  proc add(x:int) =
    proc addImpl(nd: var Node, h:int) =
      nd.ct.inc
      if h == -1:
        if nd.ct >= 2:
          nd.xor_min = 0
        return
      let d = x[h]
      for x in 0 .. 1:
        if nd.next[x].isNil:
          nd.next[x] = allocNode()
      nd.next[d].addImpl(h - 1)
      update_node(nd, h)
    root.addImpl(B - 1)
  proc remove(x:int) =
    proc removeImpl(nd: var Node, h:int) =
      nd.ct.dec
      if h == -1:
        if nd.ct <= 1:
          nd.xor_min = int.inf
        return
      let d = x[h]
      for x in 0 .. 1:
        if nd.next[x].isNil:
          nd.next[x] = allocNode()
      nd.next[d].removeImpl(h - 1)
      update_node(nd, h)
    root.removeImpl(B - 1)

  let Q = nextInt()
  for _ in Q:
    let t = nextInt()
    if t == 1:
      let x = nextInt()
      add(x)
    elif t == 2:
      let x = nextInt()
      remove(x)
    elif t == 3:
      echo root.xor_min
    else:
      doAssert false
      discard


  discard

when not DO_TEST:
  solve()
else:
  discard

