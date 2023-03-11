import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL


static:
  when not defined SecondCompile:
    # md5sum: 44a2217179f06fda478fe0133ff421a9  atcoder.tar.xz

    template getFileName():string = instantiationInfo().filename
    let fn = getFileName()
    block:
      let (output, ex) = gorgeEx("if [ -e ./atcoder ]; then exit 1; else exit 0; fi")
      doAssert ex == 0, "atcoder directory already exisits"
    discard staticExec("echo \"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\" | base64 -d > atcoder.tar.xz && tar -Jxvf atcoder.tar.xz")
    let (output, ex) = gorgeEx("nim cpp -d:release -d:SecondCompile -d:danger --path:./ --opt:speed --multimethods:on --warning[SmallLshouldNotBeUsed]:off --checks:off -o:a.out " & fn)
    discard staticExec("rm -rf ./atcoder");doAssert ex == 0, output;quit(0)


# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/header.nim
include atcoder/header

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/tree/rerooting.nim
import atcoder/extra/tree/rerooting


type Data = int
type Weight = tuple[d, w:int]

proc f_merge(a, b:Data):Data = max(a, b)
proc f_up(a:Data, u:int, w:Weight):Data =
  let (d, w) = w
  return max(a, d) + w

proc solve(N:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]) =
  var g = initReRooting[Data, Weight](N, f_up, f_merge, -int.inf)
  for i in 0 ..< N - 1:
    g.addBiEdge(A[i], B[i], (D[B[i]], C[i]), (D[A[i]], C[i]))
  g.solve()
  for i in 0 ..< N:
    echo g[i]
  return

var N = nextInt()
var A = newSeqWith(N-1, 0)
var B = newSeqWith(N-1, 0)
var C = newSeqWith(N-1, 0)
for i in 0..<N-1:
  A[i] = nextInt() - 1
  B[i] = nextInt() - 1
  C[i] = nextInt()
var D = newSeqWith(N, nextInt())
solve(N, A, B, C, D)
