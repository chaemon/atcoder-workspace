when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var a = {"tourist":3858,
    "ksun48":3679,
    "Benq":3658,
    "Um_nik":3648,
    "apiad":3638,
    "Stonefeang":3630,
    "ecnerwala":3613,
    "mnbvmar":3555,
    "newbiedmy":3516,
    "semiexp":3481
  }.toTable
  echo a[S]
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

