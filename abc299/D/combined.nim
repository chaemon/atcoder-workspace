import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL


static:
  when not defined SecondCompile:
    # md5sum: a12a529b8e8f3203706d3db08ac8c5ef  atcoder.tar.xz

    template getFileName():string = instantiationInfo().filename
    let fn = getFileName()
    block:
      let (output, ex) = gorgeEx("if [ -e ./atcoder ]; then exit 1; else exit 0; fi")
      doAssert ex == 0, "atcoder directory already exisits"
    discard staticExec("echo \"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\" | base64 -d > atcoder.tar.xz && tar -Jxvf atcoder.tar.xz")
    let (output, ex) = gorgeEx("nim cpp -d:release -d:SecondCompile -d:danger --path:./ --opt:speed --multimethods:on --warning[SmallLshouldNotBeUsed]:off --checks:off -o:a.out " & fn)
    discard staticExec("rm -rf ./atcoder");doAssert ex == 0, output;quit(0)


when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/header/chaemon_header.nim
include atcoder/extra/header/chaemon_header


solveProc solve():
  let N = nextInt()
  var
    zero = 1
    one = N
  while zero + 1 < one:
    let m = (zero + one) div 2
    echo "? " & $m
    stdout.flushFile()
    let S = nextInt()
    if S == 0:
      zero = m
    else:
      one = m
  echo "! " & $zero
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

