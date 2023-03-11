import future

var f:(int,int)->int # NG
#var g = (int,int)->int # OK

type S[P] = object
  f:(P,P)->P #NG

var s = S[string](f:(a:string,b:string)=>a & b)
