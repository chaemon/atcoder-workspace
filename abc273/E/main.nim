when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/structure/persistent_array

type P = tuple[a:PersistentArray[int], p:int]

# Failed to predict input format
solveProc solve():
  var b = initTable[int, P]()
  let Q = nextInt()
  var A = initPersistentArray[int](0.repeat(Q + 1))
  var A_orig = A
  var
    p = 0
    ans = Seq[int]
  for _ in Q:
    let command = nextString()
    if command == "ADD":
      let x = nextInt()
      A[p] = x
      p.inc
    elif command == "DELETE":
      if p > 0:
        p.dec
    elif command == "SAVE":
      let y = nextInt()
      b[y] = (A, p)
    elif command == "LOAD":
      let z = nextInt()
      if z notin b:
        A = A_orig
        p = 0
      else:
        (A, p) = b[z]
    else:
      doAssert false
    if p == 0:
      ans.add -1
    else:
      ans.add A[p - 1]
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

