import macros;macro ImportExpand(s:untyped):untyped = parseStmt($s[2])
ImportExpand "cplib/tmpl/sheep.nim" <=== "when not declared CPLIB_TMPL_SHEEP:\n    const CPLIB_TMPL_SHEEP* = 1\n    {.warning[UnusedImport]: off.}\n    {.hint[XDeclaredButNotUsed]: off.}\n    import algorithm\n    import sequtils\n    import tables\n    import macros\n    import math\n    import sets\n    import strutils\n    import strformat\n    import sugar\n    import heapqueue\n    import streams\n    import deques\n    import bitops\n    import std/lenientops\n    import options\n    #入力系\n    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n    proc getchar(): char {.importc: \"getchar_unlocked\", header: \"<stdio.h>\", discardable.}\n    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n    proc lii(N: int): seq[int] {.inline.} = newSeqWith(N, ii())\n    proc si(): string {.inline.} =\n        result = \"\"\n        var c: char\n        while true:\n            c = getchar()\n            if c == ' ' or c == '\\n':\n                break\n            result &= c\n    #chmin,chmax\n    template `max=`(x, y) = x = max(x, y)\n    template `min=`(x, y) = x = min(x, y)\n    #bit演算\n    proc `%`(x: int, y: int): int = (((x mod y)+y) mod y)\n    proc `//`(x: int, y: int): int = (((x) - (x%y)) div (y))\n    proc `%=`(x: var int, y: int): void = x = x%y\n    proc `//=`(x: var int, y: int): void = x = x//y\n    proc `**`(x: int, y: int): int = x^y\n    proc `**=`(x: var int, y: int): void = x = x^y\n    proc `^`(x: int, y: int): int = x xor y\n    proc `|`(x: int, y: int): int = x or y\n    proc `&`(x: int, y: int): int = x and y\n    proc `>>`(x: int, y: int): int = x shr y\n    proc `<<`(x: int, y: int): int = x shl y\n    proc `~`(x: int): int = not x\n    proc `^=`(x: var int, y: int): void = x = x ^ y\n    proc `&=`(x: var int, y: int): void = x = x & y\n    proc `|=`(x: var int, y: int): void = x = x | y\n    proc `>>=`(x: var int, y: int): void = x = x >> y\n    proc `<<=`(x: var int, y: int): void = x = x << y\n    proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0\n    #便利な変換\n    proc `!`(x: char, a = '0'): int = int(x)-int(a)\n    #定数\n    const INF = int(3300300300300300491)\n    #converter\n\n    #range\n    iterator range(start: int, ends: int, step: int): int =\n        var i = start\n        if step < 0:\n            while i > ends:\n                yield i\n                i += step\n        elif step > 0:\n            while i < ends:\n                yield i\n                i += step\n    iterator range(ends: int): int = (for i in 0..<ends: yield i)\n    iterator range(start: int, ends: int): int = (for i in\n            start..<ends: yield i)\n    \n    #joinが非stringでめちゃくちゃ遅いやつのパッチ\n    proc join*[T: not string](a: openArray[T], sep: string = \"\"): string = a.mapit($it).join(sep)\n"

proc solve(N, M:int, A, B, C:seq[int]):seq[int] =
  var (A, B) = (A, B)
  var G = newseq[seq[(int,int)]](N)
  var top = newSeqWith(N,true)
  for i in range(M):
    A[i]-=1
    B[i]-=1
    G[B[i]].add (A[i],C[i])
    top[A[i]] = false
  
  var alr = newSeqWith(N,-1)
  var bits : seq[int]
  var scores = newSeqWith(N,-1)
  var cnt = 0
  for i in range(N):
    if top[i]:
      var tmp : seq[int]
      alr[i] = cnt
      var now = 0
      proc dfs(x:int)=
        tmp.add(now)
        scores[x] = now
        for (i,c) in G[x]:
          if alr[i] == -1:
            now += c
            alr[i] = cnt
            dfs(i)
            now -= c
      dfs(i)
      var bit = 0
      for x in tmp:
          bit |= (1<<x)
      bits.add(bit)
      cnt += 1
  var ans = newSeqWith(N,newSeqWith(N,false))
  
  for i in range(N):
    for w in range(scores[i],N):
      var tmp = bits[alr[i]] << (w-scores[i])
      if (tmp&((1<<N)-1)).popcount() == bits[alr[i]].popcount() and tmp[w]:
        assert tmp[w]
        var Z = initHashSet[(int,int)]()
        var dbg : seq[string]
        proc dfs(j,now:int):bool=
          if (j,now) in Z:
            return false
          if j == len(bits):
            if (now == ((1<<N) - 1)):
              ans[i][w] = true
              return true
  
          if j == alr[i]:
            return dfs(j+1,now)
          for k in range(N-fastLog2(bits[j])):
            if now&(bits[j] << k) == 0 and dfs(j+1,now|(bits[j] << k)):
              return true
          Z.incl((j,now))
          return false
        discard dfs(0,tmp)
  
  var anss : seq[int]
  for i in range(N):
    if ans[i].countit(it) == 1:
      anss.add(ans[i].find(true)+1)
    else:
      anss.add(-1)
  echo "kemuniku's output: ", anss
  return anss

proc solve_naive(N, M:int, A, B, C:seq[int]):seq[int] =
  var
    P = (0 ..< N).toSeq
    (A, B) = (A, B)
  for i in 0 ..< M:
    A[i].dec;B[i].dec
  proc ok(P:seq[int]):bool =
    for i in 0 ..< M:
      if P[A[i]] - P[B[i]] != C[i]: return false
    return true
  var ans = newSeqWith(N, 0)
  while true:
    if ok(P):
      for i in 0 ..< N:
        if ans[i] == -1:
          discard
        if ans[i] == 0: ans[i] = P[i] + 1
        elif ans[i] != P[i] + 1: ans[i] = -1
    if not P.nextPermutation(): break
  echo "answer: ", ans
  return ans

proc test(N, M:int, A, B, C:seq[int]) =
  doAssert solve(N, M, A, B, C) == solve_naive(N, M, A, B, C)

var
  N = 4
  M = 2
  A, B, C:seq[int]

const GENERATE = false

when GENERATE:
  import std/random
  
  random.randomize()
  
  var P = (0 ..< N).toSeq
  P.shuffle
  
  for i in 0 ..< M:
    var s = initHashSet[(int, int)]()
    while true:
      var
        a = random.rand(0 ..< N)
        b = random.rand(0 ..< N)
      if a == b or (a, b) in s: continue
      s.incl (a, b)
      var c = P[a] - P[b]
      if c < 0:
        c *= -1
        swap(a, b)
      A.add a + 1
      B.add b + 1
      C.add c
      break
else:
  A = @[4, 4]
  B = @[3, 2]
  C = @[2, 3]


echo "input: "
echo "N, M = ", N, " ", M
echo "A, B, C = ", A, B, C

for _ in 0 ..< 100:
  test(N, M, A, B, C)
