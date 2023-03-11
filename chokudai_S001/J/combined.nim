when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/tables as tables_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib

  when not declared ATCODER_INTERNAL_SUGAR_HPP:
    const ATCODER_INTERNAL_SUGAR_HPP* = 1
    import std/macros
    import std/typetraits
    
    proc checkPragma(ex, prag: var NimNode) =
    #  since (1, 3):
      block:
        if ex.kind == nnkPragmaExpr:
          prag = ex[1]
          if ex[0].kind == nnkPar and ex[0].len == 1:
            ex = ex[0][0]
          else:
            ex = ex[0]
    
    proc createProcType(p, b: NimNode): NimNode {.compileTime.} =
      result = newNimNode(nnkProcTy)
      var
        formalParams = newNimNode(nnkFormalParams).add(b)
        p = p
        prag = newEmptyNode()
    
      checkPragma(p, prag)
    
      case p.kind
      of nnkPar, nnkTupleConstr:
        for i in 0 ..< p.len:
          let ident = p[i]
          var identDefs = newNimNode(nnkIdentDefs)
          case ident.kind
          of nnkExprColonExpr:
            identDefs.add ident[0]
            identDefs.add ident[1]
          else:
            identDefs.add newIdentNode("i" & $i)
            identDefs.add(ident)
          identDefs.add newEmptyNode()
          formalParams.add identDefs
      else:
        var identDefs = newNimNode(nnkIdentDefs)
        identDefs.add newIdentNode("i0")
        identDefs.add(p)
        identDefs.add newEmptyNode()
        formalParams.add identDefs
    
      result.add formalParams
      result.add prag
    
    macro `=>`*(p, b: untyped): untyped =
      ## Syntax sugar for anonymous procedures.
      ## It also supports pragmas.
  
      var
        params = @[ident"auto"]
        name = newEmptyNode()
        kind = nnkLambda
        pragma = newEmptyNode()
        p = p
    
      checkPragma(p, pragma)
    
      if p.kind == nnkInfix and p[0].kind == nnkIdent and p[0].eqIdent"->":
        params[0] = p[2]
        p = p[1]
    
      checkPragma(p, pragma) # check again after -> transform
  #    since (1, 3):
      block:
  #      if p.kind == nnkCall:
        if p.kind in {nnkCall, nnkObjConstr}:
          # foo(x, y) => x + y
          kind = nnkProcDef
          name = p[0]
          let newP = newNimNode(nnkPar)
          for i in 1..<p.len:
            newP.add(p[i])
          p = newP
    
      case p.kind
      of nnkPar, nnkTupleConstr:
        var untypedBeforeColon = 0
        for i, c in p:
          var identDefs = newNimNode(nnkIdentDefs)
          case c.kind
          of nnkExprColonExpr:
            let t = c[1]
    #        since (1, 3):
            block:
              # + 1 here because of return type in params
              for j in (i - untypedBeforeColon + 1) .. i:
                params[j][1] = t
            untypedBeforeColon = 0
            identDefs.add(c[0])
            identDefs.add(t)
            identDefs.add(newEmptyNode())
          of nnkIdent:
            identDefs.add(c)
            identDefs.add(newIdentNode("auto"))
            identDefs.add(newEmptyNode())
            inc untypedBeforeColon
          of nnkInfix:
            if c[0].kind == nnkIdent and c[0].eqIdent"->":
              var procTy = createProcType(c[1], c[2])
              params[0] = procTy[0][0]
              for i in 1 ..< procTy[0].len:
                params.add(procTy[0][i])
            else:
              error("Expected proc type (->) got (" & c[0].strVal & ").", c)
            break
          else:
            error("Incorrect procedure parameter list.", c)
          params.add(identDefs)
      of nnkIdent:
        var identDefs = newNimNode(nnkIdentDefs)
        identDefs.add(p)
        identDefs.add(ident"auto")
        identDefs.add(newEmptyNode())
        params.add(identDefs)
      else:
        error("Incorrect procedure parameter list.", p)
      result = newProc(body = b, params = params,
                       pragmas = pragma, name = name,
                       procType = kind)
  
    macro `->`*(p, b: untyped): untyped =
      result = createProcType(p, b)
    
    macro dump*(x: untyped): untyped =
      let s = x.toStrLit
      let r = quote do:
        debugEcho `s`, " = ", `x`
      return r
    
    # TODO: consider exporting this in macros.nim
    proc freshIdentNodes(ast: NimNode): NimNode =
      # Replace NimIdent and NimSym by a fresh ident node
      # see also https://github.com/nim-lang/Nim/pull/8531#issuecomment-410436458
      proc inspect(node: NimNode): NimNode =
        case node.kind:
        of nnkIdent, nnkSym:
          result = ident($node)
        of nnkEmpty, nnkLiterals:
          result = node
        else:
          result = node.kind.newTree()
          for child in node:
            result.add inspect(child)
      result = inspect(ast)
    
    macro capture*(locals: varargs[typed], body: untyped): untyped =
      var params = @[newIdentNode("auto")]
      let locals = if locals.len == 1 and locals[0].kind == nnkBracket: locals[0]
                   else: locals
      for arg in locals:
        if arg.strVal == "result":
          error("The variable name cannot be `result`!", arg)
        params.add(newIdentDefs(ident(arg.strVal), freshIdentNodes getTypeInst arg))
      result = newNimNode(nnkCall)
      result.add(newProc(newEmptyNode(), params, body, nnkProcDef))
      for arg in locals: result.add(arg)
    
    when not declared ATCODER_INTERNAL_UNDERSCORED_CALLS_HPP:
      const ATCODER_INTERNAL_UNDERSCORED_CALLS_HPP* = 1
      import macros
    
      proc underscoredCall(n, arg0: NimNode): NimNode =
        proc underscorePos(n: NimNode): int =
          for i in 1 ..< n.len:
            if n[i].eqIdent("_"): return i
          return 0
    
        if n.kind in nnkCallKinds:
          result = copyNimNode(n)
          result.add n[0]
    
          let u = underscorePos(n)
          for i in 1..u-1: result.add n[i]
          result.add arg0
          for i in u+1..n.len-1: result.add n[i]
        elif n.kind in {nnkAsgn, nnkExprEqExpr}:
          var field = n[0]
          if n[0].kind == nnkDotExpr and n[0][0].eqIdent("_"):
            # handle _.field = ...
            field = n[0][1]
          result = newDotExpr(arg0, field).newAssignment n[1]
        else:
          # handle e.g. 'x.dup(sort)'
          result = newNimNode(nnkCall, n)
          result.add n
          result.add arg0
    
      proc underscoredCalls*(result, calls, arg0: NimNode) =
        expectKind calls, {nnkArgList, nnkStmtList, nnkStmtListExpr}
    
        for call in calls:
          if call.kind in {nnkStmtList, nnkStmtListExpr}:
            underscoredCalls(result, call, arg0)
          else:
            result.add underscoredCall(call, arg0)
      discard
  
    macro dup*[T](arg: T, calls: varargs[untyped]): T =
      result = newNimNode(nnkStmtListExpr, arg)
      let tmp = genSym(nskVar, "dupResult")
      result.add newVarStmt(tmp, arg)
      underscoredCalls(result, calls, tmp)
      result.add tmp
    
    
    proc transLastStmt(n, res, bracketExpr: NimNode): (NimNode, NimNode, NimNode) =
      # Looks for the last statement of the last statement, etc...
      case n.kind
      of nnkIfExpr, nnkIfStmt, nnkTryStmt, nnkCaseStmt:
        result[0] = copyNimTree(n)
        result[1] = copyNimTree(n)
        result[2] = copyNimTree(n)
        for i in ord(n.kind == nnkCaseStmt)..<n.len:
          (result[0][i], result[1][^1], result[2][^1]) = transLastStmt(n[i], res, bracketExpr)
      of nnkStmtList, nnkStmtListExpr, nnkBlockStmt, nnkBlockExpr, nnkWhileStmt,
          nnkForStmt, nnkElifBranch, nnkElse, nnkElifExpr, nnkOfBranch, nnkExceptBranch:
        result[0] = copyNimTree(n)
        result[1] = copyNimTree(n)
        result[2] = copyNimTree(n)
        if n.len >= 1:
          (result[0][^1], result[1][^1], result[2][^1]) = transLastStmt(n[^1], res, bracketExpr)
      of nnkTableConstr:
        result[1] = n[0][0]
        result[2] = n[0][1]
        if bracketExpr.len == 1:
          bracketExpr.add([newCall(bindSym"typeof", newEmptyNode()), newCall(
              bindSym"typeof", newEmptyNode())])
        template adder(res, k, v) = res[k] = v
        result[0] = getAst(adder(res, n[0][0], n[0][1]))
      of nnkCurly:
        result[2] = n[0]
        if bracketExpr.len == 1:
          bracketExpr.add(newCall(bindSym"typeof", newEmptyNode()))
        template adder(res, v) = res.incl(v)
        result[0] = getAst(adder(res, n[0]))
      else:
        result[2] = n
        if bracketExpr.len == 1:
          bracketExpr.add(newCall(bindSym"typeof", newEmptyNode()))
        template adder(res, v) = res.add(v)
        result[0] = getAst(adder(res, n))
    
    macro collect*(init, body: untyped): untyped =
      # analyse the body, find the deepest expression 'it' and replace it via
      # 'result.add it'
      let res = genSym(nskVar, "collectResult")
      expectKind init, {nnkCall, nnkIdent, nnkSym}
      let bracketExpr = newTree(nnkBracketExpr,
        if init.kind == nnkCall: init[0] else: init)
      let (resBody, keyType, valueType) = transLastStmt(body, res, bracketExpr)
      if bracketExpr.len == 3:
        bracketExpr[1][1] = keyType
        bracketExpr[2][1] = valueType
      else:
        bracketExpr[1][1] = valueType
      let call = newTree(nnkCall, bracketExpr)
      if init.kind == nnkCall:
        for i in 1 ..< init.len:
          call.add init[i]
      result = newTree(nnkStmtListExpr, newVarStmt(res, call), resBody, res)
    discard
  when not declared ATCODER_READER_HPP:
    const ATCODER_READER_HPP* = 1
    import streams
    import strutils
    import sequtils
    proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
    #proc getchar(): char {.header: "<stdio.h>", varargs.}
    proc nextInt*(): int = scanf("%lld",addr result)
    proc nextFloat*(): float = scanf("%lf",addr result)
    proc nextString*[F](f:F): string =
      var get = false
      result = ""
      while true:
    #    let c = getchar()
        let c = f.readChar
        if c.int > ' '.int:
          get = true
          result.add(c)
        elif get: return
    proc nextInt*[F](f:F): int = parseInt(f.nextString)
    proc nextFloat*[F](f:F): float = parseFloat(f.nextString)
    proc nextString*():string = stdin.nextString()
  
    proc toStr*[T](v:T):string =
      proc `$`[T](v:seq[T]):string =
        v.mapIt($it).join(" ")
      return $v
    
    proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
      result = ""
      for i,v in x:
        if i != 0: addSep(result, sep = sep)
        add(result, v)
      result.add("\n")
      stdout.write result
    
    var print*:proc(x: varargs[string, toStr])
    print = proc(x: varargs[string, toStr]) =
      discard print0(@x, sep = " ")
    discard
  when not declared ATCODER_SLICEUTILS_HPP:
    const ATCODER_SLICEUTILS_HPP* = 1
    proc index*[T](a:openArray[T]):Slice[int] =
      a.low..a.high
    type ReversedSlice[T] = distinct Slice[T]
    type StepSlice[T] = object
      s:Slice[T]
      d:T
    proc rev*[T](p:Slice[T]):ReversedSlice[T] = ReversedSlice[T](p)
    iterator items*(n:int):int = (for i in 0..<n: yield i)
    iterator items*[T](p:ReversedSlice[T]):T =
      if Slice[T](p).b >= Slice[T](p).a:
        var i = Slice[T](p).b
        while true:
          yield i
          if i == Slice[T](p).a:break
          i.dec
    proc `>>`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d:d)
    proc `<<`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d: -d)
    proc low*[T](s:StepSlice[T]):T = s.s.a
    proc high*[T](s:StepSlice[T]):T =
      let p = s.s.b - s.s.a
      if p < 0: return s.low - 1
      let d = abs(s.d)
      return s.s.a + (p div d) * d
    iterator items*[T](p:StepSlice[T]):T = 
      assert p.d != 0
      if p.s.a <= p.s.b:
        if p.d > 0:
          var i = p.low
          let h = p.high
          while i <= h:
            yield i
            if i == h: break
            i += p.d
        else:
          var i = p.high
          let l = p.low
          while i >= l:
            yield i
            if i == l: break
            i += p.d
    proc `[]`*[T:SomeInteger, U](a:openArray[U], s:Slice[T]):seq[U] =
      for i in s:result.add(a[i])
    proc `[]=`*[T:SomeInteger, U](a:var openArray[U], s:StepSlice[T], b:openArray[U]) =
      var j = 0
      for i in s:
        a[i] = b[j]
        j.inc
    discard
  when not declared ATCODER_ASSIGNMENT_OPERATOR_HPP:
    import std/macros
    import std/strformat
    const ATCODER_ASSIGNMENT_OPERATOR_HPP* = 1
    template `>?=`*(x,y:typed):void = x.max= y
    template `<?=`*(x,y:typed):void = x.min= y
    proc `//`*[T](x,y:T):T = x div y
    proc `%`*[T](x,y:T):T = x mod y
    macro generateAssignmentOperator*(ops:varargs[untyped]) =
      var strBody = ""
      for op in ops:
        let op = op.repr
        var op_raw = op
        if op_raw[0] == '`':
          op_raw = op_raw[1..^2]
        strBody &= fmt"""proc `{op_raw}=`*[S, T](a:var S, b:T):auto {{.inline discardable.}} = (mixin {op};a = `{op_raw}`(a, b);return a){'\n'}"""
      parseStmt(strBody)
    generateAssignmentOperator(`mod`, `div`, `and`, `or`, `xor`, `shr`, `shl`, `<<`, `>>`, max, min, `%`, `//`, `&`, `|`, `^`)
    discard
  when not declared ATCODER_INF_HPP:
    const ATCODER_INF_HPP* = 1
    template inf*(T): untyped = 
      when T is SomeFloat: T(Inf)
      elif T is SomeInteger: T.high div 2
      else:
        static: assert(false)
    proc `*!`*[T:SomeInteger](a, b:T):T =
      if a == T(0) or b == T(0): return T(0)
      var sgn = T(1)
      if a < T(0): sgn = -sgn
      if b < T(0): sgn = -sgn
      let a = abs(a)
      let b = abs(b)
      if b > T.inf div a: result = T.inf
      else: result = min(T.inf, a * b)
      result *= sgn
    proc `+!`*[T:SomeInteger](a, b:T):T =
      result = a + b
      result = min(T.inf, result)
      result = max(-T.inf, result)
    proc `-!`*[T:SomeInteger](a, b:T):T =
      result = a - b
      result = min(T.inf, result)
      result = max(-T.inf, result)
    discard
  when not declared ATCODER_CHAEMON_WARLUS_OPERATOR_HPP:
    const ATCODER_CHAEMON_WARLUS_OPERATOR_HPP* = 1
    import strformat
    import macros
    proc discardableId*[T](x: T): T {.discardable.} = x
  
    proc warlusImpl(x, y:string):string =
      fmt"""when declaredInScope({x}):{'\n'} {x} = {y}{'\n'}else:{'\n'}  var {x} = {y}{'\n'}"""
  
    macro `:=`*(x, y: untyped): untyped =
      var strBody = ""
      if x.kind == nnkCurly:
        for i,xi in x: strBody &= warlusImpl(xi.repr, y.repr)
      elif x.kind == nnkPar:
        for i,xi in x: strBody &= warlusImpl(xi.repr, y[i].repr)
      else:
        strBody &= warlusImpl(x.repr, y.repr)
        strBody &= fmt"discardableId({x.repr})"
      parseStmt(strBody)
    discard
  when not declared ATCODER_SEQ_ARRAY_UTILS:
    const ATCODER_SEQ_ARRAY_UTILS* = 1
    import strformat
    import macros
    import sequtils
    template makeSeq*(x:int; init):auto =
      when init is typedesc: newSeq[init](x)
      else: newSeqWith(x, init)
    macro Seq*(lens: varargs[int]; init):untyped =
      var a = fmt"{init.repr}"
      for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
      parseStmt(fmt"""
  block:
    {a}""")
  
    template fill*[T](a:var T, init) =
      when a isnot seq and a isnot array:
        a = init
      else:
        for v in a.mitems: fill(v, init)
  
    template makeArray*(x:int or Slice[int]; init):auto =
      var v:array[x, init.type]
      v
  
    macro Array*(lens: varargs[typed], init):untyped =
      var a = fmt"{init.repr}"
      for i in countdown(lens.len - 1, 0):
        a = fmt"makeArray({lens[i].repr}, {a})"
      parseStmt(fmt"""
  block:
    var a = {a}
    when {init.repr} isnot typedesc:
      a.fill({init.repr})
    a""")
  
  
    discard
  when not declared ATCODER_DEBUG_HPP:
    const ATCODER_DEBUG_HPP* = 1
    import macros
    import strformat
    import terminal
    macro debugImpl*(n: varargs[untyped]): untyped =
      #  var a = "stderr.write "
      var a = ""
      a.add "setForegroundColor fgYellow\n"
      a.add "echo "
      for i,x in n:
        a = a & fmt""" "{x.repr} = ", {x.repr} """
        if i < n.len - 1:
          a.add(""", ", ",""")
      a.add "\n"
      a.add "resetAttributes()"
      parseStmt(a)
    template debug*(n: varargs[untyped]): untyped =
      const EVAL =
        when declared DEBUG: DEBUG
        else: false
      when EVAL:
        debugImpl(n)
    discard
  when not declared ATCODER_REFERENCE_HPP:
    const ATCODER_REFERENCE_HPP* = 1
    import std/macros
    import std/strformat
  
    template byaddr*(lhs, typ, ex) =
      when typ is typeof(nil):
        let tmp = addr(ex)
      else:
        let tmp: ptr typ = addr(ex)
      template lhs: untyped = tmp[]
  
    macro `=&`*(lhs, rhs:untyped) =
      parseStmt(fmt"""byaddr({lhs.repr}, {rhs.repr}.type, {rhs.repr})""")
    discard
  when not declared ATCODER_FLOAT_UTILS_HPP:
    const ATCODER_FLOAT_UTILS_HPP* = 1
    import std/math as math_lib_floatutils
    proc getParameters*(Real:typedesc):ptr[tuple[n:int, pi, eps, inf:Real]] =
      var p {.global.}:tuple[n:int, pi, eps, inf:Real]
      return p.addr
  
    converter floatConverter*(a:SomeInteger):float = a.float
  
    proc getPi*(Real:typedesc):Real = Real.getParameters()[].pi
    proc getEPS*(Real:typedesc):Real = Real.getParameters()[].eps
    proc getINF*(Real:typedesc):Real = Real.getParameters()[].inf
    proc setEPS*(Real:typedesc, x:Real) = Real.getParameters()[].eps = x
  
    proc valid_range*[Real](l, r:Real):bool =
      # assert(l <= r)
      var (l, r) = (l, r)
      if l > r: swap(l, r)
      let d = r - l
      let eps = Real.getEPS
      if d < eps: return true
      if l <= Real(0) and Real(0) <= r: return false
      return d < eps * min(abs(l), abs(r))
  
    # float comp
    # TODO: relative error
    proc `=~`*[Real](a,b:Real):bool = abs(a - b) < Real.getEPS
    proc `!=~`*[Real](a,b:Real):bool = abs(a - b) > Real.getEPS
    proc `<~`*[Real](a,b:Real):bool = a + Real.getEPS < b
    proc `>~`*[Real](a,b:Real):bool = a > b + Real.getEPS
    proc `<=~`*[Real](a,b:Real):bool = a < b + Real.getEPS
    proc `>=~`*[Real](a,b:Real):bool = a + Real.getEPS > b
  
    proc initPrec*(Real:typedesc[SomeFloat], n = 0) =
      when Real is float or Real is float64:
        Real.getParameters()[] = (n, PI.Real, 1e-9.Real, Inf.Real)
      elif Real is float32:
        Real.getParameters()[] = (n, PI.Real, 1e-6.Real, Inf.Real)
  
    proc estimateRational*[Real](x:Real, n:int) =
      var m = Real.getInf
      var q = 1
      while q <= n:
        let p = round(x * q.Real)
        let d = abs(p / q.Real - x)
        if d < m:
          m = d
          echo "found: ", p, "/", q, "   ", "error: ", d
        q.inc
      return
  
    float.initPrec()
    float32.initPrec()
    float64.initPrec()
    discard
  when not declared ATCODER_ZIP_HPP:
    const ATCODER_ZIP_HPP* = 1
    import macros
  
    macro zip*(v:varargs[untyped]):untyped =
      result = newStmtList()
      var par = newPar()
      for i,a in v:
        var ts = newNimNode(nnkTypeSection)
        par.add(ident("T" & $i))
        ts.add(newNimNode(nnkTypeDef).add(
          ident("T" & $i),
          newEmptyNode(),
          newDotExpr(newNimNode(nnkBracketExpr).add(a, newIntLitNode(0)), ident("type"))
        ))
        result.add ts
      var varSection = newNimNode(nnkVarSection)
      varSection.add newIdentDefs(ident("a"), newEmptyNode(), newCall(
        newNimNode(nnkBracketExpr).add(
          ident("newSeq"), 
          par
        ), 
        ident("n")
      ))
      result.add newNimNode(nnkLetSection).add(newIdentDefs(ident("n"), newEmptyNode(), 
        newDotExpr(v[0] , ident("len"))
      ))
      result.add(varSection)
    
      var forStmt = newNimNode(nnkForStmt).add(ident("i")).add(
        newNimNode(nnkInfix).add(ident("..<")).add(newIntLitNode(0), ident("n"))
      )
      var fs = newStmtList()
      for j,a in v:
        fs.add newAssignment(
          newNimNode(nnkBracketExpr).add(
            newNimNode(nnkBracketExpr).add(
              ident("a"), 
              ident("i")
            ), 
            newIntLitNode(j)), 
          newNimNode(nnkBracketExpr).add(
            a, 
            ident("i")
          )
        )
      forStmt.add fs
      result.add(forStmt)
      result.add(ident("a"))
      result = newBlockStmt(newEmptyNode(), result)
    
    macro unzip*(n:int, p:tuple):untyped = 
      result = newStmtList()
      result.add(newNimNode(nnkLetSection).add(newIdentDefs(ident("n"), newEmptyNode(), n)))
      for i,a in p:
        var a = newPar(a)
        var t = newCall(
          newNimNode(nnkBracketExpr).add(
            ident("newSeq"), 
            newDotExpr(a, ident("type"))
          ), 
          ident("n")
        )
        var varSection = newNimNode(nnkVarSection).add(
          newIdentDefs(ident("a" & $i), newEmptyNode(), t), 
        )
        result.add(varSection)
      var forStmt = newNimNode(nnkForStmt).add(ident("i"))
      var rangeDef = newNimNode(nnkInfix).add(ident("..<")).add(newIntLitNode(0), ident("n"))
      forStmt.add(rangeDef)
      var fs = newStmtList()
      for i,a in p:
        fs.add newAssignment(
          newNimNode(nnkBracketExpr).add(
            ident("a" & $i), 
            ident("i")), 
          a
        )
      forStmt.add fs
      result.add(forStmt)
      var par = newPar()
      for i, a in p:
        par.add(ident("a" & $i))
      result.add(par)
      result = newBlockStmt(newEmptyNode(), result)
  
    discard

  converter toBool[T:ref object](x:T):bool = x != nil
  converter toBool[T](x:T):bool = x != T(0)

  proc ceilDiv*[T:SomeInteger](a, b:T):T =
    assert b != 0
    if b < 0: return ceilDiv(-a, -b)
    result = a.floorDiv(b)
    if a mod b != 0: result.inc

when not declared ATCODER_SET_MAP_HPP:
  const ATCODER_SET_MAP_HPP* = 1
  when not declared ATCODER_EXTRA_RANDOMIZED_BINARY_SEARCH_TREE_HPP:
    const ATCODER_EXTRA_RANDOMIZED_BINARY_SEARCH_TREE_HPP* = 1
    {.push inline.}
    import std/sugar
    import std/random
    when not declared ATCODER_RANGEUTILS_HPP:
      const ATCODER_RANGEUTILS_HPP* = 1
      proc halfOpenEndpoints*(p:Slice[int]):(int,int) = (p.a, p.b + 1)
    
    
      discard
    type RBSTNode*[D, L, useSum] = ref object
      cnt*:int
      l*,r*:RBSTNode[D, L, useSum]
      key*:D
      when useSum isnot void:
        sum*:D
      when L isnot void:
        lazy*:L
      id:int
  
    type RandomizedBinarySearchTree*[D,L,Node;useP:static[bool], useSum;p:static[tuple]] = object of RootObj
      root*: Node
      when D isnot void:
        D0:D
      when L isnot void:
        L0:L
      r:Rand
      id_max:int
  
    template calc_op[ST:RandomizedBinarySearchTree](self:typedesc[ST], a, b:ST.D):auto =
      block:
        let op = ST.p.op
        op(a, b)
    template calc_mapping[ST:RandomizedBinarySearchTree](self:typedesc[ST], a:ST.L, b:ST.D):auto =
      block:
        let mapping = ST.p.mapping
        mapping(a, b)
    template calc_composition[ST:RandomizedBinarySearchTree](self:typedesc[ST], a, b:ST.L):auto =
      block:
        let composition = ST.p.composition
        composition(a, b)
    template calc_p[ST:RandomizedBinarySearchTree](self:typedesc[ST], a:ST.L, b:Slice[int]):auto =
      block:
        let s = ST.p.p
        s(a, b)
  
    proc hasSum*(t:typedesc[RandomizedBinarySearchTree] or typedesc[RBSTNode]):bool {.compileTime.} = t.useSum isnot void
    #proc hasData*(t:typedesc):bool {.compileTime.} = t.D isnot void
    proc hasLazy*(t:typedesc):bool {.compileTime.} = t.L isnot void
  #  proc hasP*(t:typedesc):bool {.compileTime.} = t.useP isnot void
    #proc isPersistent*(t:typedesc):bool {.compileTime.} = t.Persistent isnot void
  
  
    proc initNode*[RBST:RandomizedBinarySearchTree](self:RBST, k:RBST.D, p:RBST.L, id:int):auto =
      result = RBSTNode[RBST.D, RBST.L, RBST.useSum](cnt:1, key:k, lazy:p, l:nil, r:nil, id:id)
      when RBST.hasSum: result.sum = k
    proc initNode*[RBST:RandomizedBinarySearchTree](self:RBST, k:RBST.D, id:int):auto =
      result = RBSTNode[RBST.D, RBST.L, RBST.useSum](cnt:1, key:k, l:nil, r:nil, id:id)
      when RBST.hasSum: result.sum = k
    
    proc initRandomizedBinarySearchTree*[D](seed = 2019):auto =
      type Node = RBSTNode[D, void, void]
      RandomizedBinarySearchTree[D,void,Node,false,void,()](root:nil, r:initRand(seed), id_max:0)
    proc initRandomizedBinarySearchTree*[D](f:static[(D,D)->D], D0:D, seed = 2019):auto =
      type Node = RBSTNode[D, void, int]
      RandomizedBinarySearchTree[D,void,Node,false,int,(op:f)](root:nil, D0:D0, r:initRand(seed), id_max: 0)
    proc initRandomizedBinarySearchTree*[D, L](f:static[(D,D)->D], g:static[(L,D)->D], h:static[(L,L)->L], D0:D, L0:L, seed = 2019):auto =
      type Node = RBSTNode[D, L, int]
      RandomizedBinarySearchTree[D,L,Node,false,int,(op:f,mapping:g,composition:h)](root:nil, D0:D0, L0:L0, r:initRand(seed), id_max: 0)
    proc initRandomizedBinarySearchTree*[D, L](f:static[(D,D)->D], g:static[(L,D)->D], h:static[(L,L)->L], p:static[(L,Slice[int])->L],D0:D,L0:L,seed = 2019):auto =
      type Node = RBSTNode[D, L, int]
      RandomizedBinarySearchTree[D,L,Node,true,int,(op:f,mapping:g,composition:h,p:p)](root:nil, D0:D0, L0:L0, r:initRand(seed), id_max: 0)
    
    proc alloc*[RBST](self: var RBST, key:RBST.D):auto =
      when RBST.hasLazy:
        result = self.initNode(key, self.L0, self.id_max)
      else:
        result = self.initNode(key, self.id_max)
      self.id_max.inc
    #  return &(pool[ptr++] = Node(key, self.L0));
    
    template clone*[D,L,useSum](t:RBSTNode[D, L, useSum]):auto = t
    proc test*[RBST:RandomizedBinarySearchTree](self: var RBST, n, s:int):bool = 
      const randMax = 18_446_744_073_709_551_615u64
      let
        q = randMax div n.uint64
        qn = q * n.uint64
      while true:
        let x = self.r.next()
        if x < qn: return x < s.uint64 * q
    
    proc count*[RBST:RandomizedBinarySearchTree](self: RBST, t:RBST.Node):auto = (if t != nil: t.cnt else: 0)
    proc sum*[RBST:RandomizedBinarySearchTree](self: RBST, t:RBST.Node):auto = (if t != nil: t.sum else: self.D0)
    
    proc update*[RBST:RandomizedBinarySearchTree](self: RBST, t:var RBST.Node):RBST.Node {.inline.} =
      t.cnt = self.count(t.l) + self.count(t.r) + 1
      when RBST.hasSum:
        t.sum = RBST.calc_op(RBST.calc_op(self.sum(t.l), t.key), self.sum(t.r))
      t
    
    proc propagate*[RBST:RandomizedBinarySearchTree](self: var RBST, t:RBST.Node):auto =
      when RBST.hasLazy:
        var t = clone(t)
        if t.lazy != self.L0:
          when RBST.useP:
            var
              li = 0
              ri = 0
          if t.l != nil:
            t.l = clone(t.l)
            t.l.lazy = RBST.calc_composition(t.lazy, t.l.lazy)
            when RBST.useP: ri = li + self.count(t.l)
            t.l.sum = RBST.calc_mapping(when RBST.useP: RBST.calc_p(t.lazy, li..<ri) else: t.lazy, t.l.sum)
          when RBST.useP: li = ri
          t.key = RBST.calc_mapping(when RBST.useP: RBST.calc_p(t.lazy, li..<li+1) else: t.lazy, t.key)
          when RBST.useP: li.inc
          if t.r != nil:
            t.r = clone(t.r)
            t.r.lazy = RBST.calc_composition(t.lazy, t.r.lazy)
            when RBST.useP: ri = li + self.count(t.r)
            t.r.sum = RBST.calc_mapping(when RBST.useP: RBST.calc_p(t.lazy, li..<ri) else: t.lazy, t.r.sum)
          t.lazy = self.L0
        self.update(t)
      else:
        t
    
    proc merge*[RBST:RandomizedBinarySearchTree](self: var RBST, l, r:RBST.Node):auto =
      if l == nil: return r
      elif r == nil: return l
    #  when RBST.hasLazy:
      var (l, r) = (l, r)
  #    if self.r.rand(l.cnt + r.cnt - 1) < l.cnt:
      if self.test(l.cnt + r.cnt, l.cnt):
        when RBST.hasLazy:
          l = self.propagate(l)
        l.r = self.merge(l.r, r)
        return self.update(l)
      else:
        when RBST.hasLazy:
          r = self.propagate(r)
        r.l = self.merge(l, r.l)
        return self.update(r)
    
    proc split*[RBST:RandomizedBinarySearchTree](self:var RBST, t:RBST.Node, k:int):(RBST.Node, RBST.Node) =
      if t == nil: return (t, t)
      var t = t
      when RBST.hasLazy:
        t = self.propagate(t)
      if k <= self.count(t.l):
        var s = self.split(t.l, k)
        t.l = s[1]
        return (s[0], self.update(t))
      else:
        var s = self.split(t.r, k - self.count(t.l) - 1)
        t.r = s[0]
        return (self.update(t), s[1])
    
    proc build*[RBST:RandomizedBinarySearchTree](self: var RBST, s:Slice[int], v:seq[RBST.D]):auto =
      let (l, r) = (s.a, s.b + 1)
      if l + 1 >= r: return self.alloc(v[l])
      var (x, y) = (self.build(l..<(l + r) shr 1, v), self.build((l + r) shr 1..<r, v))
      return self.merge(x, y)
    
    proc build*[RBST:RandomizedBinarySearchTree](self: var RBST, v:seq[RBST.D]) =
      self.root = self.build(0..<v.len, v)
    #  ptr = 0;
    #  return build(0, (int) v.size(), v);
    
    proc to_vec*[RBST:RandomizedBinarySearchTree](self: var RBST, r:RBST.Node, v:var seq[RBST.D], i:var int) =
      if r == nil: return
      when RBST.hasLazy:
        var r = r
        r = self.propagate(r)
      self.to_vec(r.l, v, i)
      v[i] = r.key
      i.inc
    #  *it = r.key;
      self.to_vec(r.r, v, i);
    
    proc to_vec*[RBST:RandomizedBinarySearchTree](self: var RBST, r:RBST.Node):auto =
      result = newSeq[RBST.D](self.count(r))
      var i = 0
      self.to_vec(r, result, i)
    
    proc to_string*[RBST:RandomizedBinarySearchTree](self: var RBST, r:RBST.Node):string =
      return self.to_vec(r).join(", ")
    
    proc write_tree*[RBST:RandomizedBinarySearchTree](self: var RBST, r:RBST.Node, h = 0) =
      if h == 0: echo "========== tree ======="
      if r == nil: return
      when RBST.hasLazy:
        var r = r
        r = self.propagate(r)
      for i in 0..<h: stdout.write "  "
      stdout.write r.id, ": ", r.key, ", ", r.sum
      when RBST.hasLazy:
        stdout.write ", ", r.lazy
      echo ""
      self.write_tree(r.l, h+1)
      self.write_tree(r.r, h+1)
      if h == 0: echo "========== end ======="
    
    proc insert*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var RBST.Node, k:int, v:RBST.D) =
      var x = self.split(t, k)
      t = self.merge(self.merge(x[0], self.alloc(v)), x[1]);
    
    proc erase*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var RBST.Node, k:int) =
      var x = self.split(t, k)
      t = self.merge(x[0], self.split(x[1], 1)[1])
    
    proc prod*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var RBST.Node, p:Slice[int]):auto =
      let (a, b) = p.halfOpenEndpoints
      var
        x = self.split(t, a)
        y = self.split(x[1], b - a)
      result = self.sum(y[0])
      var m = self.merge(y[0], y[1])
      t = self.merge(x[0], m)
    
    proc apply*[RBST:RandomizedBinarySearchTree](self:var RBST, t:var RBST.Node, s:Slice[int], p:RBST.L) =
      static: assert RBST.hasLazy
      let (a, b) = s.halfOpenEndpoints
      var
        x = self.split(t, a)
        y = self.split(x[1], b - a)
      y[0].lazy = RBST.calc_composition(p, y[0].lazy)
      var m = self.merge(self.propagate(y[0]), y[1])
      t = self.merge(x[0], m)
    
    proc set*[RBST:RandomizedBinarySearchTree](self: var RBST, t:var RBST.Node, k:int, x:RBST.D) =
      when RBST.hasLazy:
        t = self.propagate(t)
      if k < self.count(t.l): self.set(t.l, k, x)
      elif k == self.count(t.l):
        t.key = x
        t.sum = x
      else: self.set(t.r, k - self.count(t.l) - 1, x)
      t = self.update(t)
    
    proc len*[RBST:RandomizedBinarySearchTree](self: var RBST, t:RBST.Node):auto = self.count(t)
    proc empty*[RBST:RandomizedBinarySearchTree](self: var RBST, t:RBST.Node):bool = return t == nil
    proc makeset*[RBST:RandomizedBinarySearchTree](self: var RBST):RBST.Node = nil 
  
  
    proc insert*[RBST:RandomizedBinarySearchTree](self: var RBST, k:int, v:RBST.D) = self.insert(self.root, k, v)
    proc erase*[RBST:RandomizedBinarySearchTree](self: var RBST, k:int) = self.erase(self.root, k)
    proc prod*[RBST:RandomizedBinarySearchTree](self: var RBST, p:Slice[int]):auto = self.prod(self.root, p)
    proc `[]`*[RBST:RandomizedBinarySearchTree](self: var RBST, p:Slice[int]):auto = self.prod(self.root, p)
    proc apply*[RBST:RandomizedBinarySearchTree](self:var RBST, s:Slice[int], p:RBST.L) = self.apply(self.root, s, p)
    proc set*[RBST:RandomizedBinarySearchTree](self: var RBST, k:int, x:RBST.D) = self.set(self.root, k, x)
    proc `[]=`*[RBST:RandomizedBinarySearchTree](self: var RBST, k:int, x:RBST.D) = self.set(self.root, k, x)
    proc len*[RBST:RandomizedBinarySearchTree](self: var RBST):auto = self.len(self.root)
    proc empty*[RBST:RandomizedBinarySearchTree](self: var RBST):bool = self.empty(self.root)
    {.pop.}
  
  
  
  
    discard
  type SortedMultiSet*[K, T] = object
    rbst: RandomizedBinarySearchTree[K,void,RBSTNode[K, void, void], false, void, ()]
  type SortedSet*[K, T] = object
    rbst: RandomizedBinarySearchTree[K,void,RBSTNode[K, void, void], false, void, ()]
  type SortedMultiMap*[K, T] = object
    rbst: RandomizedBinarySearchTree[T,void,RBSTNode[T, void, void], false, void, ()]
  type SortedMap*[K, T] = object
    rbst: RandomizedBinarySearchTree[T,void,RBSTNode[T, void, void], false, void, ()]

  type anySet = SortedSet or SortedMultiSet
  type anyMap = SortedMap or SortedMultiMap

  type SetOrMap = SortedMultiSet or SortedSet or SortedMultiMap or SortedMap

  template getType*(T:typedesc[anySet], K):typedesc =
    T[K, K]
  template getType*(T:typedesc[anyMap], K, V):typedesc =
    T[K, (K, V)]

  proc init*(T:typedesc[SetOrMap]):T =
    result.rbst = initRandomizedBinarySearchTree[T.T]()
#    result.rbst = initRandomizedBinarySearchTree[T.T](proc(a, b:T.T):T.T = (0, 0), (0, 0))
    result.rbst.root = nil

  proc initSortedMultiSet*[K]():auto = SortedMultiSet.getType(K).init()
  proc initSortedSet*[K]():auto = SortedSet.getType(K).init()
  proc initSortedMultiMap*[K, V]():auto = SortedMultiMap.getType(K, V).init()
  proc initSortedMap*[K, V]():auto = SortedMap.getType(K, V).init()

  #RBST(sz, [&](T x, T y) { return x; }, T()) {}
  
  proc getKey*[T:SetOrMap; Node:RBSTNode](self: T, t:Node):auto =
    when self.type is anySet: t.key
    else: t.key[0]
  
  proc lower_bound*[T:SetOrMap; Node:RBSTNode](self: var T, t:var Node, x:T.K):int {.inline.}=
    if t == nil: return 0
    if x <= self.getKey(t): return self.lower_bound(t.l, x)
    return self.lower_bound(t.r, x) + self.rbst.count(t.l) + 1
  
  proc lower_bound*[T:SetOrMap](self:var T, x:T.K):int {.inline.} =
    self.lower_bound(self.rbst.root, x)

  proc upper_bound*[T:SetOrMap; Node:RBSTNode](self: var T, t:var Node, x:T.K):int {.inline.} =
    if t == nil: return 0
    if x < self.getKey(t): return self.upper_bound(t.l, x)
    return self.upper_bound(t.r, x) + self.rbst.count(t.l) + 1
  
  proc find*[T:SetOrMap, Node:RBSTNode](self: var T, t:var Node, x:T.K):auto {.inline.}=
#    if t == nil: return nil
    if t == nil: return t
    if x < self.getKey(t): return self.find(t.l, x)
    elif x > self.getKey(t): return self.find(t.r, x)
    else: return t
  proc find*[T:SetOrMap](self:var T, x:T.K):auto {.inline.} =
    self.find(self.rbst.root, x)
  
  proc contains*[T:SetOrMap](self: var T, x:T.K):bool {.inline.} =
    self.find(x) != nil
  
  proc upper_bound*[T:SetOrMap](self: var T, x:T.K):int {.inline.} =
    self.upper_bound(self.rbst.root, x)
  
  proc kth_element*[T:SetOrmap; Node:RBSTNode](self: var T, t:Node, k:int):T.T {.inline.} =
    let p = self.rbst.count(t.l)
    if k < p: return self.kth_element(t.l, k)
    elif k > p: return self.kth_element(t.r, k - self.rbst.count(t.l) - 1)
    else: return t.key

  proc kth_element*[T:SetOrMap](self: var T, k:int):T.T {.inline.} =
    return self.kth_element(self.rbst.root, k)
  
  proc insert*[T:SortedMultiSet](self: var T, x:T.K) {.inline.} =
    self.rbst.insert(self.lower_bound(x), x)
  proc insert*[T:SortedMultiMap](self: var T, x:T.T) =
    self.rbst.insert(self.lower_bound(x[0]), x)

  proc count*[T:SetOrMap](self: var T, x:T.K):int {.inline.} =
    return self.upper_bound(x) - self.lower_bound(x)
  
  proc erase_key*[T:SetOrMap](self: var T, x:T.K) {.inline.} =
    if self.count(x) == 0: return
    self.rbst.erase(self.lower_bound(x))
  
  proc insert*[T:SortedSet](self: var T, x:T.K) {.inline.} =
    var t = self.find(x)
    if t != nil: return
    self.rbst.insert(self.lower_bound(x), x)
  proc insert*[T:SortedMap](self: var T, x:T.T) {.inline.} =
    var t = self.find(x[0])
    if t != nil: t.key = x
    else: self.rbst.insert(self.lower_bound(x[0]), x)
  proc `[]`*[K, V](self: var SortedMap[K, tuple[K:K, V:V]], x:K):auto {.inline.} =
    var t = self.find(x)
    if t != nil: return t.key[1]
    result = V.default
    self.insert((x, result))
  proc `[]=`*[K, V](self: var SortedMap[K, tuple[K:K, V:V]], x:K, v:V) {.inline.} =
    var t = self.find(x)
    if t != nil:
      t.key[1] = v
      return
    self.insert((x, v))
  
  proc len*(self:var SetOrMap):int {.inline.} = self.rbst.len()
  proc empty*(self:var SetOrMap):bool {.inline.} = self.rbst.empty()


const DEBUG = true

var s = initSortedSet[int]()
let N = nextInt()
var ans = 0
for i in 0..<N:
  let a = nextInt()
  let l = s.lower_bound(a)
  ans += l
  s.insert(a)

echo N * (N - 1) div 2 - ans
