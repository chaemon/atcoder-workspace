type S[T; p:static[tuple]] = object
  x:int
  when T is int:
    a:int
  else:
    a:string

template calc[T:S](self: T or typedesc[T], a, b:int):int =
  T.p.op(a, b)

proc plus(a, b:int):int = a + b

template gen(plus:static[proc(a, b:int):int]):auto =
  S[int, (op:plus)]()
var s = gen(plus)

echo s.calc(3, 4)

type M[p:static[tuple]] = object
  a:int

type SomeM = M

converter toM*(a:int):SomeM =
  echo "converter!! ", result.p.N

echo M[(N:13, )](19)

