when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  var SAB, SCA, SBC = nextString()[0]
  SCA = if SCA == '<': '>' else: '<'
  if SAB == '<' and SBC == '<':
    echo 'B'
  elif SAB == '>' and SBC == '>':
    echo 'B'
  elif SBC == '<' and SCA == '<':
    echo 'C'
  elif SBC == '>' and SCA == '>':
    echo 'C'
  elif SCA == '<' and SAB == '<':
    echo 'A'
  elif SCA == '>' and SAB == '>':
    echo 'A'
  discard

when not DO_TEST:
  solve()
else:
  discard

