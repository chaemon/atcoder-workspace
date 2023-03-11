import sequtils, strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false

let YES = "Yes"
let NO = "No"


proc rotate(a:seq[string]):seq[string] = 
  let N = a.len
  let M = a[0].len
  result = newSeqWith(M, ".".repeat(N))
  for i in 0..<N:
    for j in 0..<M:
      result[M - 1 - j][i] = a[i][j]

proc main():void =
  let H, W = nextInt()
  let S = newSeqWith(H, nextString())
  var T = newSeqWith(H, nextString())
  for d in 0..<4:
    for x in -10..10:
      for y in -10..10:
        var valid = true
        for i in 0..<T.len:
          for j in 0..<T[0].len:
            if T[i][j] == '.': continue
            if x + i notin 0..<H or y + j notin 0..<W: valid = false;continue
            if S[x + i][y + j] == '#': valid = false
        if valid: echo YES;return
    T = rotate(T)
  echo NO
  return

main()
