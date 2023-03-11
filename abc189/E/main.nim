include atcoder/extra/header/chaemon_header
import atcoder/extra/math/matrix

proc solve() =
  let N = nextInt()
  var X, Y = Seq(N, int)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  let M = nextInt()
  type Mat = MatrixType(int)
  var A = Mat.init([[1, 0], [0, 1]])
  var b = Mat.initVector([0, 0])
  var vA = @[A]
  var vb = @[b]
  let rotate = Mat.init([[0, -1], [1, 0]])
  let mrotate = Mat.init([[0, 1], [-1, 0]])
  for i in 0..<M:
    let t = nextInt()
    if t == 1:
      A = mrotate * A
      b = mrotate * b
    elif t == 2:
      A = rotate * A
      b = rotate * b
    elif t == 3:
      let p = nextInt()
      A[0][0] *= -1
      A[0][1] *= -1
      b[0] *= -1
      b[0] += 2 * p
    elif t == 4:
      let p = nextInt()
      A[1][0] *= -1
      A[1][1] *= -1
      b[1] *= -1
      b[1] += 2 * p
    else:
      assert false
    vA.add(A)
    vb.add(b)
  let Q = nextInt()
  for _ in 0..<Q:
    var A, B = nextInt()
    B.dec
    let x = vA[A] * Mat.initVector([X[B], Y[B]]) + vB[A]
    echo x[0], " ", x[1]
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
