type S = object
  a:int

proc default(t:typedesc[S]):S = S(a:42)

var s:S
echo s # (a: 0) not (a: 42)
