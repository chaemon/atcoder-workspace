proc f(a, b:int):int = a + b
proc f(a:int):int = a
proc g(a, b:int):int = a * b
#proc f(a, b:float):float = a + b
#proc f(a:int):int = a

type S[T; p:static[tuple]] = object
  discard

template evalAdd[T](s:typedesc[S], a, b:T):T =
  let f = s.p[0]
  f(a, b)
template evalMult[T](s:typedesc[S], a, b:T):T =
  let g = s.p[1]
  g(a, b)

#template eval[T](s:typedesc[S], a, b:T): untyped =
#  s.evalImpl(a, b) # Use x, y so it's not replaced by template

template typeS(T:typedesc, f, g:untyped):typedesc = S[T, ((proc(x, y:T):T)f, (proc(x, y:T):T)g)]

type S0 = typeS(int, f, g)
echo S0.evalAdd(3, 4)
echo S0.evalMult(3, 4)
