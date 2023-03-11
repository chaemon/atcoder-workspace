#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

template SeqImpl(lens: seq[int]; init; d, l: static[int]): auto =
  when d == l:
    when init is typedesc: newSeq[init](lens[d - 1])
    else: newSeqWith(lens[d - 1], init)
  else: newSeqWith(lens[d - 1], SeqImpl(lens, init, d + 1, l))

template Seq(lens: varargs[int]; init): auto = SeqImpl(@lens, init, 1, lens.len)

template ArrayImpl(lens: varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val
  discard

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 1, lens.len).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 1, lens.len)
    ArrayFill(a, init)
    a
#}}}

# editDistance(S, T:string) {{{
import sequtils

proc editDistance(S,T:string):int =
  let
    N = S.len
    M = T.len
  dump(S)
  dump(T)
  var dp = newSeqWith(N + 1, newSeqWith(M + 1, N + M))
  for i in 0..N: dp[i][0] = i
  for j in 0..M: dp[0][j] = j
  for i in 1..N:
    for j in 1..M:
      dp[i][j] = min(dp[i][j], dp[i - 1][j] + 1)
      dp[i][j] = min(dp[i][j], dp[i][j - 1] + 1)
      dp[i][j] = min(dp[i][j], dp[i - 1][j - 1] + (if S[i - 1] != T[j - 1]: 1 else: 0))
  return dp[N][M]
# }}}

# Interactive {{{
const CHECK = true

when CHECK:
  type Interactive = object
    ans: string
    time, limit: int
    L: int
#  var interactive = Interactive(ans: "Atcod3rIsGreat", L:128, time: 0, limit: 850)
  var interactive = Interactive(ans: "abaadcabbba", L:128, time: 0, limit: 850)

  import streams, deques
  
#  var output = newStringStream()
  var output = initDeque[string]()
  print = proc(x: varargs[string,toStr]) = output.addLast(print0(@x,sep = " "))

  proc ask(self: var Interactive):int = 
    self.time += 1
    var s = output.popFirst().strip()
    stderr.write "time: ", self.time, " query: ", s, "\n"
    if self.time > self.limit: 
      stderr.write "too many query!!"
      assert(false)
    result = editDistance(self.ans, s.split(" ")[1])
    stderr.write "                  result:  ", result, "\n"
  proc judge(self: var Interactive) =
    let s = output.popFirst().strip().split(" ")[1]
    stderr.write "judge: ", s, "\n"
    assert(s == interactive.ans)

proc ask(s:string):int =
  print "?", s
  let T = when CHECK: interactive.ask() else: nextString()
  return T

proc judge(s:string) =
  print "!", s
  when CHECK: interactive.judge()
# }}}

# Failed to predict input format

proc main() =
  discard ask("AtcoderIsBad")
  let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  var
    cs = ""
    a = newSeq[int]()
    ansLen = 0
  for c in chars:
    a.add(ask(c.toStr))
  if a.max == a.min:
    cs = chars
    ansLen = a[0] + 1
  else:
    ansLen = a.max
    for i,c in chars:
      if a[i] < ansLen:
        cs.add(c)
  proc findFirstChar(pref, suff:string, i, base:int):int =
    let s = cs[i..<cs.len]
    if ask(pref & s & suff) == base + s.len:
      return -1
    var
      l = i
      r = cs.len
    while r - l > 1:
      let m = (l + r) div 2
      let s = cs[i..<m]
      dump(s)
      if ask(pref & s & suff) == base + s.len: # not exists
        echo "not exists"
        l = m
      else:
        echo "exists"
        r = m
    return l
  proc f(pref, suff:string, i:int) =
    discard
#    pref + cs[i..<cs.len] + ff
  dump(ansLen)
  dump(cs)
# "abaadcabbba"
  echo findFirstChar("aaa", "aa", 1, 6)
  return

main()
