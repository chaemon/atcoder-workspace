{.hints:off warnings:off optimization:speed.}
import sugar, strutils, sequtils

import streams
proc nextString[F](f:F): string =
  echo "nextString!!"
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    dump(c)
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get:
      echo "return: ", result
      return
proc nextInt[F](f:F): int =
  let s = f.nextString
  dump(s)
  parseInt(s)
#proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()


#proc nextString[F](f:F): string =
#  var get = false
#  result = ""
#  while true:
##    let c = getchar()
#    let c = f.readChar()
#    if c.int > ' '.int:
#      get = true
#      result.add(c)
#    elif get: return
#proc nextString():string = stdin.nextString()


let N = stdin.nextInt()
dump(N)
for i in 0..<N-1:
  var
    p = stdin.nextInt()
    q = stdin.nextInt()
  dump(i)
  dump(p)
  dump(q)
let c = nextString()
