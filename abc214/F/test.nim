import macros
macro testMacro():untyped =
  result = newStmtList()
  var params:seq[NimNode]
  params.add(ident("string"))
  var mainParams = params
  var identDefs = newNimNode(nnkIdentDefs).add(ident"static_arg").add(newNimNode(nnkBracketExpr).add(ident"static").add(ident"bool")).add(newEmptyNode())
  mainParams.add(identDefs)
  var mainProcDef = newNimNode(nnkProcDef).add(ident"solve").add(newEmptyNode()).add(newEmptyNode()).add(newNimNode(nnkFormalParams).add(mainParams)).add(newEmptyNode()).add(newEmptyNode()).add(newEmptyNode())
  result.add mainProcDef
  var mainBody = newStmtList().add(newNimNode(nnkDiscardStmt).add(newEmptyNode()))
  result.add newProc(name = ident"solve", params = mainParams, body = mainBody, pragmas = newEmptyNode())
  echo result.repr
  #### this outputs the following
  # proc solve(static_arg: static[bool]): string {.discardable.}
  # proc solve(static_arg: static[bool]): string {.discardable.} =
  #   discard

testMacro()

discard solve(true)

