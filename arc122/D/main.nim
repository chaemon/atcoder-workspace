include atcoder/extra/header/chaemon_header
import atcoder/extra/other/bitutils

const DEBUG = true

import macros

macro solveProc(head, body:untyped):untyped =
  var params = @[ident"auto"]
  var callparams:seq[NimNode]
  for i in 1..<head.len:
    var identDefs = newNimNode(nnkIdentDefs)
    identDefs.add(head[i][0])
    callparams.add(head[i][0])
    identDefs.add(head[i][1])
    identDefs.add(newEmptyNode())
    params.add(identDefs)
  var mainBody, naiveBody, testBody, generateBody = newStmtList()
  var hasNaive, hasTest, hasGenerate = false
  for b in body:
    if b.kind == nnkCall:
      case b[0].toStr:
        of "Naive":
          hasNaive = true
          naiveBody.add b[1]
        of "Test":
          hasTest = true
          testBody.add b[1]
        of "Generate":
          hasGenerate = true
          generateBody.add b[1]
        else:
          mainBody.add(b)
    else:
      mainBody.add(b)
  result = newStmtList()
  let procName = head[0].toStr
  var p = newNimNode(nnkPragma)
  p.add ident("discardable")
  result.add newProc(name = ident(procName), params = params, body = mainBody, pragmas = p)
  if hasNaive:
    let naiveProcName = procName & "naive"
    result.add newProc(name = ident(naiveProcName), params = params, body = naiveBody, pragmas = p)
    var b = newNimNode(nnkInfix)
    var l = newNimNode(nnkCall).add(ident("solve"))
    for c in callparams: l.add(c)
    var r = newNimNode(nnkCall).add(ident("solve_naive"))
    for c in callparams: r.add(c)
    b.add(ident("=="))
    b.add(l)
    b.add(r)
    result.add newProc(name = ident("test"), params = params, body = b)
  if hasGenerate:
    discard
  if hasTest:
    discard
  echo result.repr

dumpTree:
  solve(a, b) == solve_naive(a, b)


solveProc solve(N:int, A:seq[int]):
  proc calc_min(a, b:seq[int], k:int):int =
    # dummy
    #result = 2^30
    #for a in a:
    #  for b in b:
    #    result.min=a xor b
    result = 2^30
    if k == -1: return 0
    if a.len == 1 and b.len == 1:
      return a[0] xor b[0]
    var a0, a1, b0, b1 = Seq[int]
    for a in a:
      if a[k]: a1.add(a xor [k])
      else: a0.add(a)
    for b in b:
      if b[k]: b1.add(b xor [k])
      else: b0.add(b)
    if a0.len > 0 and b0.len > 0:
      result.min=calc_min(a0, b0, k - 1)
    if a1.len > 0 and b1.len > 0:
      result.min=calc_min(a1, b1, k - 1)
    if result < 2^30: return
    if a0.len > 0 and b1.len > 0:
      result.min=calc_min(a0, b1, k - 1) xor [k]
    if a1.len > 0 and b0.len > 0:
      result.min=calc_min(a1, b0, k - 1) xor [k]

  proc calc(a:seq[int], k:int):int =
    if a.len == 0: return 0
    if k == -1: return 0
    assert a.len mod 2 == 0
    let N = a.len div 2
    var zero, one = Seq[int]
    for i in 0..<N * 2:
      if a[i][k]: one.add(a[i] xor [k])
      else: zero.add(a[i])
    if zero.len mod 2 == 0:
      assert one.len mod 2 == 0
      return max(calc(zero, k - 1), calc(one, k - 1))
    else:
      # minimum of zero[i] xor one[j]
      return calc_min(zero, one, k - 1) xor [k]
  result = calc(A, 29)
  echo result
  Naive:
      return 12
  return

doAssert test(4, @[3, 1, 4, 2])

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(2*N, nextInt())
  solve(N, A)
#}}}

