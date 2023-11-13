import macros

proc cleanUp(n: NimNode) =
  for i, x in n:
    case x.kind
    of nnkSym:
      n[i] = ident $x
    of nnkHiddenStdConv:
      cleanup x[^1]
      n[i] = x[^1][0]
      cleanup(n[i])
    of nnkHiddenCallConv:
      cleanup x
      n[i] = x[^1]
      cleanup(n[i])
    else:
      cleanup(x)


macro redef(x: typed, arg: untyped, newType: typed): untyped =
  
  result = x.getImpl
  result[0] = ident $x
  assert result.kind == nnkProcDef
  for n in result[3]:
    if n.kind == nnkIdentDefs:
      for i in 0 .. n.len - 2:
        n[i] = ident $n[i]
      
      if n[0].eqIdent arg:
        n[^2] = newType
  result[^1].cleanUp()
  x.getImpl.treerepr.echo
  result.treeRepr.echo

proc someProc(x: int) = echo x

redef(someProc, x, float)

someProc(42)
someProc(100.10)
