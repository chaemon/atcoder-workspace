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

when not declared ATCODER_CUMULATIVE_SUM_HPP:
  const ATCODER_CUMULATIVE_SUM_HPP* = 1
  import std/sequtils

  type CumulativeSum*[T; reverse:static[bool]] = object
    n: int
    pos: int
    data: seq[T]

  proc initCumulativeSum*(n:int, T:typedesc, reverse:static[bool] = false):CumulativeSum[T, reverse] =
    result = CumulativeSum[T, reverse](data: newSeqWith(n + 1, T.default), pos:0, n:n)

  proc `[]=`*[T;reverse:static[bool]](self: var CumulativeSum[T, reverse], k:int, x:T) =
    when reverse: (let k = self.n - k)
    if k < self.pos: doAssert(false)
    if self.data.len < k + 2: self.data.setLen(k + 2)
    self.data[k + 1] = x

  proc propagate*[T;reverse:static[bool]](self: var CumulativeSum[T, reverse]) =
    if self.data.len < self.pos + 2: self.data.setLen(self.pos + 2)
    self.data[self.pos + 1] += self.data[self.pos]
    self.pos.inc
  proc initCumulativeSum*[T](data:seq[T], reverse:static[bool] = false):CumulativeSum =
    result = initCumulativeSum[T, reverse]()
    for i,d in data: result[i] = d
  proc sum*[T;reverse:static[bool]](self: var CumulativeSum[T, reverse], k:int):T =
    if k < 0: return T(0)
    while self.pos < k: self.propagate()
    return self.data[k]
  proc `[]`*[T;reverse:static[bool]](self: var CumulativeSum[T, reverse], s:Slice[int]):T =
    when reverse: (let s = self.n - s.b .. self.n - s.a)
    if s.a > s.b: return T(0)
    return self.sum(s.b + 1) - self.sum(s.a)


const DEBUG = false

const cat = true
var p:int
when cat: p = 10

proc solve(N:int, A:seq[int]) =
  if N == 1:
    echo A[0].float / 2
    return
  var
    A = A
    s = 0.0 # sum of Ai
    cs = initCumulativeSum(N, float)
  A.sort
  var ans = (A.sum).float
  for i in 0..<N: cs[i] = A[i]
  for i in 0 ..< N - 1:
    # 2x is between A[i] .. A[i + 1]
    # left: i
    # right: N - i
    # (i + 1) * x + cs[i + 1 ..< N] - (N - (i + 1)) * x
    let d = (i + 1) - (N - (i + 1))
    var x:float
    if d >= 0:
      x = A[i].float / 2
    else:
      x = A[i + 1].float / 2
    debug i, d, x
    ans.min= d * x + cs[i + 1 ..< N]
  echo ans / N
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

