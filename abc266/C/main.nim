const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import complex

const YES = "Yes"
const NO = "No"

solveProc solve(A_x:int, A_y:int, B_x:int, B_y:int, C_x:int, C_y:int, D_x:int, D_y:int):
  var P = Seq[Complex[float]]
  P.add complex(A_x, A_y)
  P.add complex(B_x, B_y)
  P.add complex(C_x, C_y)
  P.add complex(D_x, D_y)
  for i in 4:
    let j = (i + 1) mod 4
    let k = (j + 1) mod 4
    let t = (P[i] - P[j]) / (P[k] - P[j])
    if t.phase <=~ 0.0: echo No;return
  echo YES
  discard

when not defined(DO_TEST):
  var A_x = nextInt()
  var A_y = nextInt()
  var B_x = nextInt()
  var B_y = nextInt()
  var C_x = nextInt()
  var C_y = nextInt()
  var D_x = nextInt()
  var D_y = nextInt()
  solve(A_x, A_y, B_x, B_y, C_x, C_y, D_x, D_y)
else:
  discard

