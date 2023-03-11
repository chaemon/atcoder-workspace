const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitset

const YES = "Yes"
const NO = "No"

const BMAX = 3600000
var b:array[2001, BitSet[BMAX + 1]]

solveProc solve(N:int, A:int, B:int, D:seq[int]):
  var
    X = A + B
    Y = A - B
    Dsum = D.sum
  if X.floorMod(2) != Dsum mod 2 or Y.floorMod(2) != Dsum mod 2: echo NO;return
  X += Dsum
  Y += Dsum
  X.div= 2
  Y.div= 2
  if X < 0 or BMAX < X or Y < 0 or BMAX < Y: echo NO; return
  b[0] = initBitSet[BMAX + 1]()
  b[0][0] = 1
  for i in 0..<N:
    b[i + 1] = b[i]
    b[i + 1].or= b[i] shl D[i]
  var a = newSeq[seq[int]]()
  for x in [X, Y]:
    if b[N][x] == 0: echo NO; return
    var v = newSeq[int](N)
    var x = x
    for i in countdown(N - 1, 0):
      if b[i][x] == 0:
        let x2 = x - D[i]
        assert x2 >= 0 and b[i][x2] == 1
        x = x2
        v[i] = 1
      else:
        v[i] = -1
    a.add v
  var ans = ""
  for i in 0..<N:
    if a[0][i] == 1:
      if a[1][i] == 1:
        ans &= 'R'
      else:
        ans &= 'U'
    else:
      if a[1][i] == 1:
        ans &= 'D'
      else:
        ans &= 'L'
  echo YES
  echo ans
  block check:
    var
      A0 = 0
      B0 = 0
    for i in 0..<N:
      if ans[i] == 'R':
        A0 += D[i]
      elif ans[i] == 'L':
        A0 -= D[i]
      elif ans[i] == 'U':
        B0 += D[i]
      else:
        B0 -= D[i]
    assert A0 == A and B0 == B
  return

when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var D = newSeqWith(N, nextInt())
  solve(N, A, B, D)
else:
  discard

