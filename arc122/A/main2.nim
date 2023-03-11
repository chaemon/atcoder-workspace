when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off warnings:off assertions:on optimization:speed.}
  when defined MYDEBUG:
    {.checks:on.}
  else:
    {.checks:off.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/tables as tables_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib
  import std/options as options_lib
  import std/bitops as bitops_lib

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
    import std/strformat
    import std/macros
    import std/sequtils
    template makeSeq*(x:int; init):auto =
      when init is typedesc: newSeq[init](x)
      else: newSeqWith(x, init)
  
    type SeqType = object
    type ArrayType = object
    let
      Seq* = SeqType()
      Array* = ArrayType()
  
    template fill*[T](a:var T, init) =
      when a isnot seq and a isnot array:
        a = init
      else:
        for v in a.mitems: fill(v, init)
  
    template makeArray*(x:int or Slice[int]; init):auto =
      var v:array[x, init.type]
      v
  
    macro `[]`*(x:ArrayType or SeqType, args:varargs[untyped]):auto =
      var a:string
      if $x == "Seq" and args.len == 1 and args[0].kind != nnkExprColonExpr:
        a = fmt"newSeq[{args[0].repr}]()"
      else:
        let tail = args[^1]
        assert tail.kind == nnkExprColonExpr, "Wrong format of tail"
        let
          args = args[0 .. ^2] & tail[0]
          init = tail[1]
        a = fmt"{init.repr}"
        if $x == "Array":
          for i in countdown(args.len - 1, 0): a = fmt"makeArray({args[i].repr}, {a})"
          a = fmt"{'\n'}block:{'\n'}  var a = {a}{'\n'}  when {init.repr} isnot typedesc:{'\n'}    a.fill({init.repr}){'\n'}  a"
        elif $x == "Seq":
          for i in countdown(args.len - 1, 0): a = fmt"makeSeq({args[i].repr}, {a})"
          a = fmt"{'\n'}block:{'\n'}  {a}"
        else:
          assert(false)
      parseStmt(a)
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
      a.add "stdout.write "
  #    a.add "stderr.write "
      for i,x in n:
        a = a & fmt""" "{x.repr} = ", {x.repr} """
        if i < n.len - 1:
          a.add(""", ", ",""")
      a.add(", \"\\n\"")
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
    import std/strutils
    when not declared ATCODER_ELEMENT_CONCEPTS_HPP:
      const ATCODER_ELEMENT_CONCEPTS_HPP* = 1
      proc inv*[T:SomeFloat](a:T):auto = T(1) / a
      proc init*(self:typedesc[SomeFloat], a:SomeNumber):auto = self(a)
      type AdditiveGroupElem* = concept x, y, type T
        x + y
        x - y
        -x
        T(0)
      type MultiplicativeGroupElem* = concept x, y, type T
        x * y
        x / y
    #    x.inv()
        T(1)
      type RingElem* = concept x, y, type T
        x + y
        x - y
        -x
        x * y
        T(0)
        T(1)
      type FieldElem* = concept x, y, type T
        x + y
        x - y
        x * y
        x / y
        -x
    #    x.inv()
        T(0)
        T(1)
      type FiniteFieldElem* = concept x, type T
        T is FieldElem
        T.mod
        T.mod() is int
        x.pow(1000000)
      type hasInf* = concept x, type T
        T(Inf)
      discard
    when not declared ATCODER_STATIC_VAR_HPP:
      const ATCODER_STATIC_VAR_HPP* = 1
      import std/macros
      import std/strformat
      macro staticVar*(T:typedesc, body: untyped) =
        var s = ""
        for n in body:
          let name = n[0]
          let t = n[1]
          let t2 = fmt"{t.repr[1..<t.repr.len]}"
          s &= fmt"""{'\n'}proc get_global_addr_of_{name.repr}*[U:{T.repr}](self:typedesc[U] or U):ptr[{t2}] ={'\n'}  when self is typedesc:{'\n'}    var a {{.global.}}:{t2}.type{'\n'}    a.addr{'\n'}  else:{'\n'}    get_global_addr_of_{name.repr}(self.type){'\n'}
    """
        parseStmt(s)
      
      macro `$.`*(t, name:untyped):untyped =
        let s = fmt"{t.repr}.get_global_addr_of_{name.repr}()[]"
        parseStmt(s)
      discard
  #  proc getParameters*(Real:typedesc):ptr[tuple[n:int, pi, eps, inf:Real]] =
  #    var p {.global.}:tuple[n:int, pi, eps, inf:Real]
  #    return p.addr
  
    converter floatConverter*(a:SomeInteger):float = a.float
    converter float64Converter*(a:SomeInteger):float64 = a.float64
    converter float32Converter*(a:SomeInteger):float32 = a.float32
    converter floatConverter*(a:string):float = a.parseFloat
    converter float64Converter*(a:string):float64 = a.parseFloat.float64
    converter float32Converter*(a:string):float32 = a.parseFloat.float32
  
    staticVar FieldElem:
      pi:U.type
      eps:U.type
      inf:U.type
  
  #  proc getPi*(Real:typedesc):Real = Real.getParameters()[].pi
  #  proc getEPS*(Real:typedesc):Real = Real.getParameters()[].eps
  #  proc getINF*(Real:typedesc):Real = Real.getParameters()[].inf
  #  proc setEPS*(Real:typedesc, x:Real) = Real.getParameters()[].eps = x
  
    proc valid_range*[Real](l, r:Real):bool =
      # assert(l <= r)
      var (l, r) = (l, r)
      if l > r: swap(l, r)
      let d = r - l
      let eps = Real$.eps
      if d < eps: return true
      if l <= Real(0) and Real(0) <= r: return false
      return d < eps * min(abs(l), abs(r))
  
    template initPrec*(Real:typedesc) =
      Real$.pi = PI.Real
      Real$.inf = Inf.Real
      when Real is float or Real is float64:
        Real$.eps = 1e-9.Real
      elif Real is float32:
        Real$.eps = 1e-9.Real
      # float comp
      # TODO: relative error
      proc `=~`*(a,b:Real):bool = abs(a - b) < Real$.eps
      proc `!=~`*(a,b:Real):bool = abs(a - b) > Real$.eps
      proc `<~`*(a,b:Real):bool = a + Real$.eps < b
      proc `>~`*(a,b:Real):bool = a > b + Real$.eps
      proc `<=~`*(a,b:Real):bool = a < b + Real$.eps
      proc `>=~`*(a,b:Real):bool = a + Real$.eps > b
  
    # for OMC
    proc estimateRational*[Real](x:Real, n:int) =
      var m = Real$.inf
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
  #  float64.initPrec()
    float32.initPrec()
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

#  converter toBool[T:ref object](x:T):bool = x != nil
#  converter toBool[T](x:T):bool = x != T(0)
  # misc
  proc `<`[T](a, b:seq[T]):bool =
    for i in 0 ..< min(a.len, b.len):
      if a[i] < b[i]: return true
      elif a[i] > b[i]: return false
    if a.len < b.len: return true
    else: return false

  proc ceilDiv*[T:SomeInteger](a, b:T):T =
    assert b != 0
    if b < 0: return ceilDiv(-a, -b)
    result = a.floorDiv(b)
    if a mod b != 0: result.inc

when not declared ATCODER_MODINT_HPP:
  const ATCODER_MODINT_HPP* = 1
  import std/macros
  import std/strformat
  when not declared ATCODER_GENERATE_DEFINITIONS_NIM:
    const ATCODER_GENERATE_DEFINITIONS_NIM* = 1
    import std/strformat
    import std/macros
  
    template generateDefinitions*(name, l, r, typeObj, typeBase, body: untyped): untyped {.dirty.} =
      proc name*(l, r: typeObj): auto {.inline.} =
        type T = l.type
        body
      proc name*(l: typeBase; r: typeObj): auto {.inline.} =
        type T = r.type
        body
      proc name*(l: typeObj; r: typeBase): auto {.inline.} =
        type T = l.type
        body
  
    template generatePow*(name) {.dirty.} =
      proc pow*(m: name; p: SomeInteger): name {.inline.} =
        if (p.type)(0) <= p:
          var
            p = p.uint
            m = m
          result = m.unit()
          while p > 0'u:
            if (p and 1'u) != 0'u: result *= m
            m *= m
            p = p shr 1'u
        else:
          return pow(m.inv(), -p)
      proc `^`*[T:name](m: T; p: SomeInteger): T {.inline.} = m.pow(p)
  
    macro generateConverter*(name, from_type, to_type) =
      parseStmt(fmt"""type {name.repr}* = {to_type.repr}{'\n'}converter to{name.repr}OfGenerateConverter*(a:{from_type}):{name.repr} {{.used.}} = {name.repr}.init(a){'\n'}""")
    discard

  type
    StaticModInt*[M: static[int]] = object
      a:uint32
    DynamicModInt*[T: static[int]] = object
      a:uint32

  type ModInt* = StaticModInt or DynamicModInt

  proc isStaticModInt*(T:typedesc):bool = T is StaticModInt
  proc isDynamicModInt*(T:typedesc):bool = T is DynamicModInt
  proc isModInt*(T:typedesc):bool = T.isStaticModInt or T.isDynamicModInt
  proc isStatic*(T:typedesc[ModInt]):bool = T is StaticModInt

  when not declared ATCODER_INTERNAL_MATH_HPP:
    const ATCODER_INTERNAL_MATH_HPP* = 1
    import std/math
  
    # Fast moduler by barrett reduction
    # Reference: https:#en.wikipedia.org/wiki/Barrett_reduction
    # NOTE: reconsider after Ice Lake
    type Barrett* = object
      m*, im:uint
  
    # @param m `1 <= m`
    proc initBarrett*(m:uint):auto = Barrett(m:m, im:(0'u - 1'u) div m + 1)
  
    # @return m
    proc umod*(self: Barrett):uint =
      self.m
  
    {.emit: """
  inline unsigned long long calc_mul(const unsigned long long &a, const unsigned long long &b){
    return (unsigned long long)(((unsigned __int128)(a)*b) >> 64);
  }
  """.}
    proc calc_mul*(a,b:culonglong):culonglong {.importcpp: "calc_mul(#,#)", nodecl.}
    # @param a `0 <= a < m`
    # @param b `0 <= b < m`
    # @return `a * b % m`
    proc mul*(self: Barrett, a:uint, b:uint):uint =
      # [1] m = 1
      # a = b = im = 0, so okay
  
      # [2] m >= 2
      # im = ceil(2^64 / m)
      # -> im * m = 2^64 + r (0 <= r < m)
      # let z = a*b = c*m + d (0 <= c, d < m)
      # a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
      # c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
      # ((ab * im) >> 64) == c or c + 1
      let z = a * b
      #  #ifdef _MSC_VER
      #      unsigned long long x;
      #      _umul128(z, im, &x);
      #  #else
      ##TODO
      #      unsigned long long x =
      #        (unsigned long long)(((unsigned __int128)(z)*im) >> 64);
      #  #endif
      let x = calc_mul(z.culonglong, self.im.culonglong).uint
      var v = z - x * self.m
      if self.m <= v: v += self.m
      return v
  
    # @param n `0 <= n`
    # @param m `1 <= m`
    # @return `(x ** n) % m`
    proc pow_mod_constexpr*(x,n,m:int):int =
      if m == 1: return 0
      var
        r = 1
        y = floorMod(x, m)
        n = n
      while n != 0:
        if (n and 1) != 0: r = (r * y) mod m
        y = (y * y) mod m
        n = n shr 1
      return r.int
    
    # Reference:
    # M. Forisek and J. Jancina,
    # Fast Primality Testing for Integers That Fit into a Machine Word
    # @param n `0 <= n`
    proc is_prime_constexpr*(n:int):bool =
      if n <= 1: return false
      if n == 2 or n == 7 or n == 61: return true
      if n mod 2 == 0: return false
      var d = n - 1
      while d mod 2 == 0: d = d div 2
      for a in [2, 7, 61]:
        var
          t = d
          y = pow_mod_constexpr(a, t, n)
        while t != n - 1 and y != 1 and y != n - 1:
          y = y * y mod n
          t =  t shl 1
        if y != n - 1 and t mod 2 == 0:
          return false
      return true
    proc is_prime*[n:static[int]]():bool = is_prime_constexpr(n)
  #  
  #  # @param b `1 <= b`
  #  # @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
    proc inv_gcd*(a, b:int):(int,int) =
      var a = floorMod(a, b)
      if a == 0: return (b, 0)
    
      # Contracts:
      # [1] s - m0 * a = 0 (mod b)
      # [2] t - m1 * a = 0 (mod b)
      # [3] s * |m1| + t * |m0| <= b
      var
        s = b
        t = a
        m0 = 0
        m1 = 1
    
      while t != 0:
        var u = s div t
        s -= t * u;
        m0 -= m1 * u;  # |m1 * u| <= |m1| * s <= b
    
        # [3]:
        # (s - t * u) * |m1| + t * |m0 - m1 * u|
        # <= s * |m1| - t * u * |m1| + t * (|m0| + |m1| * u)
        # = s * |m1| + t * |m0| <= b
    
        var tmp = s
        s = t;t = tmp;
        tmp = m0;m0 = m1;m1 = tmp;
      # by [3]: |m0| <= b/g
      # by g != b: |m0| < b/g
      if m0 < 0: m0 += b div s
      return (s, m0)
  
    # Compile time primitive root
    # @param m must be prime
    # @return primitive root (and minimum in now)
    proc primitive_root_constexpr*(m:int):int =
      if m == 2: return 1
      if m == 167772161: return 3
      if m == 469762049: return 3
      if m == 754974721: return 11
      if m == 998244353: return 3
      var divs:array[20, int]
      divs[0] = 2
      var cnt = 1
      var x = (m - 1) div 2
      while x mod 2 == 0: x = x div 2
      var i = 3
      while i * i <= x:
        if x mod i == 0:
          divs[cnt] = i
          cnt.inc
          while x mod i == 0:
            x = x div i
        i += 2
      if x > 1:
        divs[cnt] = x
        cnt.inc
      var g = 2
      while true:
        var ok = true
        for i in 0..<cnt:
          if pow_mod_constexpr(g, (m - 1) div divs[i], m) == 1:
            ok = false
            break
        if ok: return g
        g.inc
    proc primitive_root*[m:static[int]]():auto =
      primitive_root_constexpr(m)
    discard

  proc getBarrett*[T:static[int]](t:typedesc[DynamicModInt[T]]):ptr Barrett =
    var Barrett_of_DynamicModInt {.global.} = initBarrett(998244353.uint)
    return Barrett_of_DynamicModInt.addr
  proc getMod*[T:static[int]](t:typedesc[DynamicModInt[T]]):uint32 {.inline.} =
    (t.getBarrett)[].m.uint32
  proc setMod*[T:static[int]](t:typedesc[DynamicModInt[T]], M:SomeInteger){.used inline.} =
    (t.getBarrett)[] = initBarrett(M.uint)

  proc `$`*(m: ModInt): string {.inline.} = $(m.val())

  template umod*[T:ModInt](self: typedesc[T] or T):uint32 =
    when T is typedesc:
      when T is StaticModInt:
        T.M.uint32
      elif T is DynamicModInt:
        T.getMod()
      else:
        static: assert false
    else: T.umod

  proc `mod`*[T:ModInt](self:typedesc[T] or T):int = T.umod.int

  proc init*[T:ModInt](t:typedesc[T], v: SomeInteger or T): auto {.inline.} =
    when v is T: return v
    else:
      when v is SomeUnsignedInt:
        if v.uint < T.umod:
          return T(a:v.uint32)
        else:
          return T(a:(v.uint mod T.umod.uint).uint32)
      else:
        var v = v.int
        if 0 <= v:
          if v < T.mod: return T(a:v.uint32)
          else: return T(a:(v mod T.mod).uint32)
        else:
          v = v mod T.mod
          if v < 0: v += T.mod
          return T(a:v.uint32)
  proc unit*[T:ModInt](t:typedesc[T] or T):T = T.init(1)
  template initModInt*(v: SomeInteger or ModInt; M: static[int] = 1_000_000_007): auto =
    StaticModInt[M].init(v)

# TODO
#  converter toModInt[M:static[int]](n:SomeInteger):StaticModInt[M] {.inline.} = initModInt(n, M)

#  proc initModIntRaw*(v: SomeInteger; M: static[int] = 1_000_000_007): auto {.inline.} =
#    ModInt[M](v.uint32)
  proc raw*[T:ModInt](t:typedesc[T], v:SomeInteger):auto = T(a:v)

  proc inv*[T:ModInt](v:T):T {.inline.} =
    var
      a = v.a.int
      b = T.mod
      u = 1
      v = 0
    while b > 0:
      let t = a div b
      a -= t * b;swap(a, b)
      u -= t * v;swap(u, v)
    return T.init(u)

  proc val*(m: ModInt): int {.inline.} = int(m.a)

  proc `-`*[T:ModInt](m: T): T {.inline.} =
    if int(m.a) == 0: return m
    else: return T(a:m.umod() - m.a)

  proc `+=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    m.a += T.init(n).a
    if m.a >= T.umod: m.a -= T.umod

  proc `-=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    m.a -= T.init(n).a
    if m.a >= T.umod: m.a += T.umod

  proc `*=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    when T is StaticModInt:
      m.a = (m.a.uint * T.init(n).a.uint mod T.umod).uint32
    elif T is DynamicModInt:
      m.a = T.getBarrett[].mul(m.a.uint, T.init(n).a.uint).uint32
    else:
      static: assert false

  proc `/=`*[T:ModInt](m: var T; n: SomeInteger | T) {.inline.} =
    m.a = (m.a.uint * T.init(n).inv().a.uint mod T.umod).uint32

  generateDefinitions(`+`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result += n

  generateDefinitions(`-`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result -= n

  generateDefinitions(`*`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result *= n

  generateDefinitions(`/`, m, n, ModInt, SomeInteger):
    result = T.init(m)
    result /= n

  generateDefinitions(`==`, m, n, ModInt, SomeInteger):
    result = (T.init(m).val() == T.init(n).val())

  proc inc*(m: var ModInt) {.inline.} =
    m.a.inc
    if m.a == m.umod.uint32:
      m.a = 0

  proc dec*(m: var ModInt) {.inline.} =
    if m.a == 0.uint32:
      m.a = m.umod - 1
    else:
      m.a.dec

  generatePow(ModInt)

  template useStaticModint*(name, M) =
    generateConverter(name, int, StaticModInt[M])
  template useDynamicModInt*(name, M) =
    generateConverter(name, int, DynamicModInt[M])

  useStaticModInt(modint998244353, 998244353)
  useStaticModInt(modint1000000007, 1000000007)
  useDynamicModInt(modint, -1)
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true
proc solve(N:int, A:seq[int]):mint =
  var num_p, num_m = mint(0)
  var sum_p, sum_m = mint(0)
  num_p = 1
  sum_p = A[0]
  for i in 1..<N:
    var num_p2, num_m2 = mint(0)
    var sum_p2, sum_m2 = mint(0)
    # set plus
    num_p2 += num_p + num_m
    sum_p2 += sum_p + A[i] * num_p + sum_m + A[i] * num_m
    # set minus
    num_m2 += num_p
    sum_m2 += sum_p - A[i] * num_p
    swap num_p, num_p2
    swap num_m, num_m2
    swap sum_p, sum_p2
    swap sum_m, sum_m2
  echo sum_p + sum_m

#proc solve(N:int, A:seq[int]):mint =
#  var f = Seq[N + 1: mint]
#  f[0] = 1
#  f[1] = 2
#  for n in 2..N: f[n] = f[n - 1] + f[n - 2]
#  var ans = mint(0)
#  for i in 0..<N:
#    # set plus
#    if i == 0:
#      ans += f[N - 1 - i] * A[i]
#    else:
#      ans += f[i - 1] * f[N - 1 - i] * A[i]
#    # set minus
#    if i >= 1:
#      if i == 1:
#        ans -= f[N - i - 2] * A[i]
#      elif i == N - 1:
#        ans -= f[i - 2] * A[i]
#      else:
#        ans -= f[i - 2] * f[N - i - 2] * A[i]
#  echo ans
#  return ans

const DO_TEST = false

when DO_TEST:
when not declared ATCODER_BITUTILS_HPP:
  const ATCODER_BITUTILS_HPP* = 1
  import bitops

  proc `<<`*[B:SomeInteger](b:B, n:SomeInteger):B = b shl n
  proc `>>`*[B:SomeInteger](b:B, n:SomeInteger):B = b shr n

  proc seqToBits*[B:SomeInteger](v:varargs[int]): B =
    result = 0
    for x in v: result = (result or (B(1) shl B(x)))

  proc `[]`*[B:SomeInteger](b:B,n:int):bool = (if b.testBit(n): true else: false)
  proc `[]`*[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))
  
  proc `[]=`*[B:SomeInteger](b:var B,n:int,t:int) =
    if t == 0: b.clearBit(n)
    elif t == 1: b.setBit(n)
    else: doAssert(false)
  proc `and`*[B:SomeInteger](b:B, v:openArray[int]):B = b and seqToBits[B](v)
  proc `or`*[B:SomeInteger](b:B, v:openArray[int]):B = b or seqToBits[B](v)
  proc `xor`*[B:SomeInteger](b:B, v:openArray[int]):B = b xor seqToBits[B](v)
  proc `&`*(a:SomeInteger, b:SomeInteger or openarray[int]):auto = a and b
  proc `|`*(a:SomeInteger, b:SomeInteger or openarray[int]):auto = a or b

  proc `@`*[B:SomeInteger](b:B): seq[int] =
    result = newSeq[int]()
    for i in 0..<(8 * sizeof(B)):
      if b[i]: result.add(i)
  proc `@^`*(v:openArray[int]): int =
    result = 0
    for i in v:
      result[i] = 1

  proc toBitStr*[B:SomeInteger](b:B, n = -1):string =
    let n = if n == -1: sizeof(B) * 8 else: n
    result = ""
    for i in countdown(n-1,0):result.add if b[i]: '1' else: '0'
  proc allSetBits*[B:SomeInteger](n:int):B =
    if n == 64:
      return not uint64(0)
    else:
      return (B(1) shl B(n)) - B(1)
  iterator subsets*[B:SomeInteger](v:seq[int]):B =
    var s = B(0)
    yield s
    while true:
      var found = false
      for i in v:
        if not s.testBit(i):
          found = true
          s.setBit(i)
          yield s
          break
        else:
          s[i] = 0
      if not found: break

  iterator subsets*[B:SomeInteger](b:B):B =
    for b in subsets[B](@b):
      yield b
  
  proc solve_naive(N:int, A:seq[int]):mint =
    var s = mint(0)
    for b in 2^(N - 1):
      var valid = true
      for i in 0..<N - 2:
        if b[i] and b[i + 1]: valid = false
      if not valid: continue
      s += A[0]
      for i in 0..<N - 1:
        if b[i]: s -= A[i + 1]
        else: s += A[i + 1]
    return s

  proc test() =
    var A = @[1000000000,1000000000,1000000000]
    let N = A.len
    doAssert solve(N, A) == solve_naive(N, A)
  test()
else:
  block:
    var N = nextInt()
    var A = newSeqWith(N, nextInt())
    discard solve(N, A)

