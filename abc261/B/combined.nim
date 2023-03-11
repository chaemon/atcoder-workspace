import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL


static:
  when not defined SecondCompile:
    discard staticExec("echo \"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\" | base64 -d > atcoder.tar.xz && tar -Jxvf atcoder.tar.xz && rm atcoder.tar.xz")
    let (output, ex) = gorgeEx("nim cpp -d:release -d:SecondCompile --path:./ --opt:speed --multimethods:on --warning[SmallLshouldNotBeUsed]:off --checks:off -o:a.out Main.nim")
    doAssert ex == 0, output;quit(0)


const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/header/chaemon_header.nim
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, A:seq[string]):
  for i in N:
    for j in N:
      if i == j: continue
      if A[i][j] == 'W':
        if A[j][i] != 'L':
          echo "incorrect";return
      elif A[i][j] == 'L':
        if A[j][i] != 'W':
          echo "incorrect";return
      elif A[i][j] == 'D':
        if A[j][i] != 'D':
          echo "incorrect";return
  echo "correct"
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextString())
  solve(N, A)
else:
  discard
