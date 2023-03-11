type S = object of RootObj
  a:int

type T = object of S
  b:int

var t = T(S(a: 2020))
