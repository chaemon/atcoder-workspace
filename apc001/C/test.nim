type S = object
  case hasA: bool
    of true:
      a:int
      p:int
    of false:
      b:int
      q:int

static:
  echo sizeof(int)
  echo sizeof(S)

var s = S(hasA:true, a:10)
var s2 = S(hasA:false, b:30)
#var s2 = S(hasA:false, a:20) # compile error

echo s.hasA
s.hasA = false # runtime error
s.b = 12 # can be compiled but runtime error
