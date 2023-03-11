const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off warnings:off assertions:on optimization:speed.}
  {.checks:off.}
  when declared(DO_CHECK):
    when DO_CHECK:
      {.checks:on.}
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
  import std/streams as streams_lib

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
#  import std/sugar
  when not declared ATCODER_READER_HPP:
    const ATCODER_READER_HPP* = 1
    import streams
    import strutils
    import sequtils
  #  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
    #proc getchar(): char {.header: "<stdio.h>", varargs.}
  #  proc nextInt*(): int = scanf("%lld",addr result)
  #  proc nextFloat*(): float = scanf("%lf",addr result)
    proc nextString*(f:auto = stdin): string =
      var get = false
      result = ""
      while true:
        let c = f.readChar
        if c.int > ' '.int:
          get = true
          result.add(c)
        elif get: return
    proc nextInt*(f:auto = stdin): int = parseInt(f.nextString)
    proc nextFloat*(f:auto = stdin): float = parseFloat(f.nextString)
  #  proc nextString*():string = stdin.nextString()
  
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
    template inf*(T:typedesc): untyped = 
      when T is SomeFloat: T(Inf)
      elif T is SomeInteger: T.high div 2
      else:
        static: assert(false)
    proc `∞`*(T:typedesc):T = T.inf
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
  when not declared ATCODER_SOLVEPROC_HPP:
    const ATCODER_SOLVEPROC_HPP* = 1
    import std/macros
    import std/strformat
    import std/algorithm
    proc mainBodyHeader():NimNode =
      result = newStmtList()
      result.add parseStmt "result = \"\""
      result.add parseStmt "var resultPointer = result.addr"
  #    let macro_def = "(for s in {x.repr}: (result &= $s;(when output_stdout: stdout.write $s)));(result &= \"\\n\";when output_stdout: stdout.write \"\\n\")"
      let d = &"proc echo(x:varargs[string, `$`]) = (for s in x: (resultPointer[] &= $s; when output_stdout: stdout.write $s)); (resultPointer[] &= \"\\n\"; when output_stdout: stdout.write \"\\n\")"
      result.add parseStmt(d)
  
    macro solveProc*(head, body:untyped):untyped =
      var prev_type:NimNode
      var params:seq[NimNode]
      for i in countdown(head.len - 1, 1):
        var identDefs = newNimNode(nnkIdentDefs)
        if head[i].kind == nnkExprColonExpr:
          identDefs.add(head[i][0])
          prev_type = head[i][1]
        elif head[i].kind == nnkIdent:
          identDefs.add(head[i])
        identDefs.add(prev_type)
        identDefs.add(newEmptyNode())
        params.add(identDefs)
      params.add(ident"auto")
      params.reverse()
      var callparams:seq[NimNode]
      for i in 1..<params.len:
        callparams.add(params[i][0])
  #    var mainBody, naiveBody = mainBodyHeader()
      var mainBody, checkBody, naiveBody, testBody, generateBody = newStmtList()
      var hasNaive, hasCheck, hasTest, hasGenerate = false
      for b in body:
        if b.kind == nnkCall:
          if b[0] == ident"Check":
            hasCheck = true
            checkBody.add b[1]
          elif b[0] == ident"Naive":
            hasNaive = true
            naiveBody.add b[1]
          elif b[0] == ident"Test":
            hasTest = true
            testBody.add b[1]
          elif b[0] == ident"Generate":
            hasGenerate = true
            generateBody.add b[1]
          else:
            mainBody.add b
        else:
          mainBody.add b
      mainBody = newStmtList().add newBlockStmt(newEmptyNode(), newStmtList().add(mainBodyHeader()).add(mainBody))
      if hasCheck:
        mainBody.add(checkBody)
      result = newStmtList()
      let procName = $head[0]
      var discardablePragma = newNimNode(nnkPragma).add(ident("discardable"))
      var mainParams = params
      mainParams[0] = ident"string"
      var identDefs = newNimNode(nnkIdentDefs)
      identDefs.add(ident"output_stdout")
      identDefs.add(newNimNode(nnkBracketExpr).add(ident"static").add(ident"bool"))
      identDefs.add(ident"true")
      mainParams.add(identDefs)
      var mainProcDef = newNimNode(nnkProcDef).add(ident"solve").add(newEmptyNode()).add(newEmptyNode()).add(newNimNode(nnkFormalParams).add(mainParams)).add(discardablePragma).add(newEmptyNode()).add(newEmptyNode())
      result.add(mainProcDef)
      if hasNaive:
        var naiveProcDef = newNimNode(nnkProcDef).add(ident"solve_naive").add(newEmptyNode()).add(newEmptyNode()).add(newNimNode(nnkFormalParams).add(mainParams)).add(discardablePragma).add(newEmptyNode()).add(newEmptyNode())
        result.add(naiveProcDef)
  
  
      var naiveParams = mainParams
      result.add newProc(name = ident(procName), params = mainParams, body = mainBody, pragmas = discardablePragma)
  #    echo mainParams.repr
      if hasNaive:
        let naiveProcName = procName & "naive"
        naiveBody = mainBodyHeader().add(newBlockStmt(newEmptyNode(), naiveBody))
        result.add newProc(name = ident(naiveProcName), params = naiveParams, body = naiveBody, pragmas = discardablePragma)
  #      var b = newNimNode(nnkInfix)
        var test_body = newStmtList()
        var var_names = newSeq[string]()
        for procName in [procName, procName & "_naive"]:
          let var_name = "v" & procName
          var_names.add(var_name)
          var l = newNimNode(nnkCall).add(ident(procName))
          for c in callparams: l.add(c)
          l.add(ident"false")
          test_body.add(
            newNimNode(nnkLetSection).add(
              newNimNode(nnkIdentDefs).add(ident(var_name)).add(newEmptyNode()).add(l)
            ))
        var test_params = params
        var vars = ""
        for i in 1..<params.len:
          let p = params[i][0]
          vars &= &"  {p.repr} = {{{p.repr}}}\\n"
        test_params[0] = ident"bool"
        test_body.add parseStmt(&"if vsolve != vsolve_naive: echo &\"test failed for\\n{vars}\", \"[solve]\\n\", vsolve, \"[solve_naive]\\n\", vsolve_naive;doAssert false")
        result.add newProc(name = ident"test", params = test_params, body = test_body, pragmas = discardablePragma)
      if hasGenerate:
        discard
      if hasTest:
        discard
  #    echo result.repr
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
  discard

when not declared ATCODER_SET_MAP_HPP:
  const ATCODER_SET_MAP_HPP* = 1
  const USE_RED_BLACK_TREE = true
  {.push discardable inline.}
  when not declared ATCODER_BINARY_TREE_UTILS_HPP:
    const ATCODER_BINARY_TREE_UTILS_HPP* = 1
    when not declared ATCODER_BINARY_TREE_NODE_UTILS_HPP:
      const ATCODER_BINARY_TREE_NODE_UTILS_HPP* = 1
      type BinaryTreeNode* = concept x, type T
        x.l is T
        x.r is T
        x.p is T
    #    T.Countable
      type BinaryTree* = concept x, type T
        x.Node is BinaryTreeNode
        x.root is x.Node
    
      proc greater_func*[K](a,b:K):bool = a < b
    
      proc isLeaf*[Node:BinaryTreeNode](self:Node):bool =
        return self.l == self
    
      proc leftMost*[Node:BinaryTreeNode](self: Node):Node =
        if self.l.isLeaf: return self
        else: return self.l.leftMost
      proc rightMost*[Node:BinaryTreeNode](self: Node): Node =
        if self.r.isLeaf: return self
        else: return self.r.rightMost
      proc parentLeft*[Node:BinaryTreeNode](node: Node): Node =
        var node = node
        while true:
          if node.p == nil: return nil
          elif node.p.l == node: return node.p
          node = node.p
      proc parentRight*[Node:BinaryTreeNode](node: Node): Node =
        var node = node
        while true:
          if node.p == nil: return nil
          elif node.p.r == node: return node.p
          node = node.p
      proc front*[Tree:BinaryTree](self: Tree): Tree.Node = self.root.leftMost
      proc tail*[Tree:BinaryTree](self: Tree): Tree.Node =  self.root.rightMost
      proc begin*[Tree:BinaryTree](self:Tree):Tree.Node = self.root.leftMost
    
      proc succ*[Node:BinaryTreeNode](node: Node): Node =
        if not node.r.isLeaf: return node.r.leftMost
        else: return node.parentLeft
      proc pred*[Node:BinaryTreeNode](node: Node): Node =
        if not node.l.isLeaf: return node.l.rightMost
        else: return node.parentRight
      proc inc*[Node:BinaryTreeNode](node: var Node) =
        var node2 = node.succ
        swap node, node2
      proc dec*[Node:BinaryTreeNode](node: var Node) =
        var node2 = node.pred
        swap node, node2
      proc `+=`*[Node:BinaryTreeNode](node: var Node, n:int) =
        if n < 0: node -= (-n)
        for i in 0..<n: node.inc
      proc `-=`*[Node:BinaryTreeNode](node: var Node, n:int) =
        if n < 0: node += (-n)
        for i in 0..<n: node.dec
    
      proc index*[Node:BinaryTreeNode](t:Node):int =
    #    static:
    #      assert Node.Countable isnot void
        result = t.l.cnt
        var (t, p) = (t, t.p)
        while p != nil:
          if p.r == t: result += p.l.cnt + 1
          t = t.p
          p = p.p
      proc distance*[Node:BinaryTreeNode](t1, t2:Node):int =
    #    static:
    #      assert Node.Countable isnot void
        return t2.index - t1.index
      discard
    {.push discardable inline.}
    type SomeSortedTree* = concept x, type T
      T.Tree is BinaryTree
      T.K is typedesc
      T.V is typedesc
      T.Node is typedesc
      T.multi is typedesc
      T.p
      x.End
    type SomeSortedSet* = concept x, type T
      T is SomeSortedTree
      T.V is void
      T.multi is void
    type SomeSortedMap* = concept x, type T
      T is SomeSortedTree
      T.V isnot void
      T.multi is void
    type SomeSortedMultiSet* = concept x, type T
      T is SomeSortedTree
      T.V is void
      T.multi isnot void
    type SomeSortedMultiMap* = concept x, type T
      T is SomeSortedTree
      T.V isnot void
      T.multi isnot void
  
    proc getKey*[T:SomeSortedTree](self: T, t:T.Node):auto =
      when T.V is void: t.key
      else: t.key[0]
  
    template calc_comp*[T:SomeSortedTree](self:T, x, y:T.K):bool =
      when T.p[0] is typeof(nil):
        x < y
      else:
        let comp = T.p[0]
        comp(x, y)
  
    proc lower_bound*[T:SomeSortedTree](self: var T, t:var T.Node, x:T.K):T.Node =
      if t.isLeaf: return t
      if t != self.End and self.calc_comp(self.getKey(t), x):
        return self.lower_bound(t.r, x)
      else:
        var t2 = self.lower_bound(t.l, x)
        if t2.isLeaf: return t
        else: return t2
  
    proc lower_bound*[T:SomeSortedTree](self:var T, x:T.K):T.Node =
      assert self.root != nil
      self.lower_bound(self.root, x)
  
    proc upper_bound*[T:SomeSortedTree](self: var T, t:var T.Node, x:T.K):T.Node =
      if t.isLeaf: return t
      if t == self.End or self.calc_comp(x, self.getKey(t)):
        var t2 = self.upper_bound(t.l, x)
        if t2.isLeaf: return t
        else: return t2
      else:
        return self.upper_bound(t.r, x)
  
    proc upper_bound*[T:SomeSortedTree](self: var T, x:T.K):T.Node =
      assert self.root != nil
      self.upper_bound(self.root, x)
  
  #  proc find*[T:SomeSortedTree](self: var T, t:var T.Node, x:T.K):T.Node =
  #    echo "find:  ", t.key
  #    if t == self.End or t.isLeaf: return self.End
  #    if self.calc_comp(x, self.getKey(t)): return self.find(t.l, x)
  #    elif self.calc_comp(self.getKey(t), x): return self.find(t.r, x)
  #    else: return t
    proc find*[T:SomeSortedTree](self:var T, x:T.K):T.Node =
      var t = self.lower_bound(x)
      if t != self.End and self.getKey(t) == x: return t
      else: return self.End
  #    result = self.find(self.root, x)
    proc contains*[T:SomeSortedTree](self: var T, x:T.K):bool =
      self.find(x) != self.End
  
    proc insert*[T:SomeSortedMultiSet](self: var T, x:T.K):T.Node =
      T.Tree(self).insert(self.upper_bound(x), x)
    proc insert*[T:SomeSortedMultiMap](self: var T, x:(T.K, T.V)):T.Node =
      T.Tree(self).insert(self.upper_bound(x[0]), x)
  
    proc insert*[T:SomeSortedSet](self: var T, x:T.K):T.Node =
      var t = self.lower_bound(x)
      if t != self.End and t.key == x: return t
      else: return T.Tree(self).insert(t, x)
    proc insert*[T:SomeSortedMap](self: var T, x:(T.K, T.V)):T.Node =
      var it = self.lower_bound(x[0])
      if it != self.End and it.key[0] == x[0]: it.key[1] = x[1]; return it
      else: return T.Tree(self).insert(it, x)
    proc incl*[T:SomeSortedSet | SomeSortedMultiSet](self:var T, x:T.K):T.Node =
      self.insert(x)
    proc incl*[T:SomeSortedMap | SomeSortedMultiMap](self:var T, x:(T.K, T.V)):T.Node =
      self.insert(x)
  
    template getAddr*[T:SomeSortedMap](self:var T, x:T.K):auto =
      mixin default
      var t = self.lower_bound(x)
      if t == self.End or t.key[0] != x:
        var v = T.V.default
        t = T.Tree(self).insert(t, (x, v))
      t.key[1].addr
  
    template `[]`*[T:SomeSortedMap](self: var T, x:T.K):auto =
      var t = self.getAddr(x)
      t[]
    proc `[]=`*[T:SomeSortedMap](self: var T, x:T.K, v:T.V) =
      var t = self.getAddr(x)
      t[] = v
  
    proc erase*[T:SomeSortedTree](self: var T, x:T.K):T.Node =
      mixin erase
      var t = self.lower_bound(x)
      if t == self.End or self.getKey(t) != x: return self.End()
      else: return T.Tree(self).erase(t)
    proc erase*[T:SomeSortedTree](self: var T, t:T.Node): T.Node =
      return T.Tree(self).erase(t)
    proc excl*[T:SomeSortedTree](self: var T, x:T.K):T.Node =
      self.erase(x)
    proc excl*[T:SomeSortedTree](self: var T, t:T.Node):T.Node =
      self.erase(t)
  
    proc kth_element*[T:SomeSortedTree](self: var T, t:T.Node, k:int):T.Node =
  #    static:
  #      assert T.Tree.Countable isnot void
      let p = t.l.cnt
      if k < p: return self.kth_element(t.l, k)
      elif k > p: return self.kth_element(t.r, k - p - 1)
      else: return t
    
    proc kth_element*[T:SomeSortedTree](self: var T, k:int):T.Node =
      return self.kth_element(T.Tree(self).root, k)
    proc `{}`*[T:SomeSortedTree](self: var T, k:int):T.Node =
      return self.kth_element(k)
  
    proc index*[T:SomeSortedTree](self:T, t:T.Node):int =
  #    static:
  #      assert T.Tree.Countable isnot void
      return index(t)
    proc distance*[T:SomeSortedTree](self:T, t1, t2:T.Node):int =
  #    static:
  #      assert T.Tree.Countable isnot void
      return index(t2) - index(t1)
  
    iterator items*[T:SomeSortedSet or SomeSortedMultiSet](self:T):T.K =
      var it = self.begin
      while it != self.End:
        yield it.key
        it.inc
    iterator pairs*[T:SomeSortedMap or SomeSortedMultiMap](self:T):(T.K, T.V) =
      var it = self.begin
      while it != self.End:
        yield it.key
        it.inc
    proc `end`*[Tree:SomeSortedTree](self:Tree):Tree.Node = self.End
    {.pop.}
    discard
  type MULTI_TRUE = int32
  type MULTI_FALSE = void
  type SortedTree*[Tree, Node, multi, K, V; p:static[tuple]] = object of Tree
    End*: Node

  when USE_RED_BLACK_TREE:
    when not declared ATCODER_RED_BLACK_TREE_HPP:
      const ATCODER_RED_BLACK_TREE_HPP* = 1
      import std/sugar
    #  {.experimental: "codeReordering".}
      {.push inline.}
      type
        Color* = enum red, black
        RedBlackTreeNode*[K; Countable] = ref object
          p*, l*, r*: RedBlackTreeNode[K, Countable]
          key*: K
          color*: Color
          id*: int
          when Countable isnot void:
            cnt*: int
        RedBlackTreeType*[K, Node; Countable] = object of RootObj
          root*, leaf*: Node
          size*: int
          next_id*: int
        RedBlackTree*[K; Countable] = RedBlackTreeType[K, RedBlackTreeNode[K, Countable], Countable]
    
      proc newNode[T:RedBlackTree](self: var T, parent: T.Node): T.Node =
        result = T.Node(p:parent, l:self.leaf, r: self.leaf, color: Color.red, id: self.next_id)
        when T.Countable isnot void:
          result.cnt = 1
    
      proc newNode[T:RedBlackTree](self: var T, parent: T.Node, key: T.K): T.Node =
        result = self.newNode(parent)
        result.key = key
        self.next_id += 1
    
      proc initRedBlackTree*[K](root:RedBlackTreeNode[K, false] = nil): RedBlackTree[K, false] =
        var leaf = RedBlackTreeNode[K](color: Color.black, id: -1)
        leaf.l = leaf;leaf.r = leaf
        result = RedBlackTree[K](root: root, next_id: 0, leaf:leaf)
      proc initCountableRedBlackTree*[K](root:RedBlackTreeNode[K, true] = nil): RedBlackTree[K, true] =
        result = initRedBlackTree[K](root)
        result.cnt = 1
    
    #  proc isLeaf*[Node:RedBlackTreeNode](self: Node):bool =
    #    assert self != nil
        #### type1
      #  result = self.l == self
      #  if result: assert(self.r == self)
        #### type 2
    #    return self.id == -1
    
    
    
      proc `*`*[T:RedBlackTreeNode](node:T):auto = node.key
      template update*[T:RedBlackTree](self:T, node: T.Node) =
        when T.Countable isnot void:
          if node == self.leaf or node == nil: return
          node.cnt = node.l.cnt + node.r.cnt
          node.cnt.inc
        discard
    
      proc rotateLeft[T:RedBlackTree](self: var T, parent: T.Node) =
        if parent == nil: return
        var right = parent.r
        parent.r = right.l
        if right.l != self.leaf: right.l.p = parent
        right.p = parent.p
        if parent.p == nil: self.root = right
        elif parent.p.l == parent: parent.p.l = right
        else: parent.p.r = right
        right.l = parent
        parent.p = right
        self.update(parent)
        self.update(right)
    #    self.update(right.p)
      proc rotateRight[T:RedBlackTree](self: var T, parent: T.Node) =
        if parent == nil: return
        var left = parent.l
        parent.l = left.r
        if left.r != self.leaf : left.r.p = parent
        left.p = parent.p
        if parent.p == nil: self.root = left
        elif parent.p.r == parent: parent.p.r = left
        else: parent.p.l = left
        left.r = parent
        parent.p = left
        self.update(parent)
        self.update(left)
    #    self.update(left.p)
    
      # insert {{{
      proc fixInsert[T:RedBlackTree](self: var T, node: T.Node) =
        ## Rebalances a tree after an insertion
        if T.Countable isnot void:
          var curr = node
          while curr != nil:
            self.update(curr)
            curr = curr.p
    
        var curr = node
        while curr != self.root and curr.p.color == Color.red:
          if curr.p.p != nil and curr.p == curr.p.p.l:
            var uncle = curr.p.p.r
            if uncle.color == Color.red:
              curr.p.color = Color.black
              uncle.color = Color.black
              curr.p.p.color = Color.red
              curr = curr.p.p
            else:
              if curr == curr.p.r:
                curr = curr.p
                self.rotateLeft(curr)
              curr.p.color = Color.black
              if curr.p.p != nil:
                curr.p.p.color = Color.red
                self.rotateRight(curr.p.p)
          elif curr.p.p != nil:
            var uncle = curr.p.p.l
            if uncle.color == Color.red:
              curr.p.color = Color.black
              uncle.color = Color.black
              curr.p.p.color = Color.red
              curr = curr.p.p
            else:
              if curr == curr.p.l:
                curr = curr.p
                self.rotateRight(curr)
              curr.p.color = Color.black
              if curr.p.p != nil:
                curr.p.p.color = Color.red
                self.rotateLeft(curr.p.p)
        self.root.color = Color.black
    
    
      proc insert*[T:RedBlackTree](self: var T, node:T.Node, next:T.Node): T.Node {.discardable.} =
        self.size += 1
        if next.l == self.leaf:
          # insert at next.l
          next.l = node
          node.p = next
        else:
          var curr = next.l.rightMost
          # insert at curr.r
          curr.r = node
          node.p = curr
        self.fixInsert(node)
        return node
    
      proc insert*[T:RedBlackTree](self: var T, next:T.Node, x:T.K): T.Node {.discardable.} =
        var node = self.newNode(T.Node(nil), x)
        return self.insert(node, next)
      # }}}
    
      # erase {{{
      proc fixErase*[T:RedBlackTree](self: var T, node: T.Node, parent: T.Node) =
    
        var
          child = node
          parent = parent
        while child != self.root and child.color == Color.black:
          if parent == nil: break # add!!!!!!!!
          if child == parent.l:
            var sib = parent.r
            if sib.color == Color.red:
              sib.color = Color.black
              parent.color = Color.red
              self.rotateLeft(parent)
              sib = parent.r
      
            if sib.l.color == Color.black and sib.r.color == Color.black:
              sib.color = Color.red
              child = parent
              parent = child.p
            else:
              if sib.r.color == Color.black:
                sib.l.color = Color.black
                sib.color = Color.red
                self.rotateRight(sib)
                sib = parent.r
              sib.color = parent.color
              parent.color = Color.black
              sib.r.color = Color.black
              self.rotateLeft(parent)
              child = self.root
              parent = child.p
          else:
            var sib = parent.l
            if sib.color == Color.red:
              sib.color = Color.black
              parent.color = Color.red
              self.rotateRight(parent)
              sib = parent.l
    
            if sib.r.color == Color.black and sib.l.color == Color.black:
              sib.color = Color.red
              child = parent
              parent = child.p
            else:
              if sib.l.color == Color.black:
                sib.r.color = Color.black
                sib.color = Color.red
                self.rotateLeft(sib)
                sib = parent.l
              sib.color = parent.color
              parent.color = Color.black
              sib.l.color = Color.black
              self.rotateRight(parent)
              child = self.root
              parent = child.p
        child.color = Color.black
    
    
      
      proc write*[T:RedBlackTree](rbt: T, self: T.Node, h = 0) =
        for i in 0..<h: stderr.write " | "
        if self == rbt.leaf:
          stderr.write "*\n"
        else:
          stderr.write "id: ",self.id, " key: ", self.key, " color: ", self.color, " cnt: ", self.cnt, " "
      #    if self.key == T.K.inf: stderr.write "inf"
          if self.p != nil: stderr.write " parent: ", self.p.id
          else: stderr.write " parent: nil"
          stderr.write "\n"
          if h >= 200:
            stderr.write "too deep!!!\n"
            assert false
            return
          rbt.write(self.l, h + 1)
          rbt.write(self.r, h + 1)
      
      proc write*[T:RedBlackTree](self: T) =
        stderr.write "======= RB-TREE =============\n"
        self.write(self.root, 0)
        stderr.write "======= END ==========\n"
      
      proc erase*[T:RedBlackTree](self: var T, node: T.Node) =
        # TODO
    #    if node == nil:
    #      echo "warning: erase nil"
    #    if node == self.End or node == nil or node.isLeaf: return
        var node = node
      
        self.size.dec
      
        if node.l != self.leaf and node.r != self.leaf:
          let pred = node.pred
          swap(node.color, pred.color)
          when T.Countable isnot void:
            swap(node.cnt, pred.cnt)
          # swap node and pred
          if node.l == pred:
            let tmp = pred.r
            pred.r = node.r
            if node.l != self.leaf:
              node.l.p = pred
            if node.r != self.leaf:
              node.r.p = pred
            node.l = pred.l
            node.r = tmp
            pred.l = node
            pred.p = node.p
            node.p = pred
            if pred.p != nil:
              if pred.p.l == node:
                pred.p.l = pred
              if pred.p.r == node:
                pred.p.r = pred
          else:
            swap(node.p, pred.p)
            swap(node.l, pred.l)
            swap(node.r, pred.r)
            if node.p != nil:
              if node.p.l == pred:
                node.p.l = node
              if node.p.r == pred:
                node.p.r = node
            if node.l != self.leaf:
              node.l.p = node
            if node.r != self.leaf:
              node.r.p = node
            if pred.p != nil:
              if pred.p.l == node:
                pred.p.l = pred
              if pred.p.r == node:
                pred.p.r = pred
            if pred.l != self.leaf:
              pred.l.p = pred
            if pred.r != self.leaf:
              pred.r.p = pred
          if self.root == node:
            self.root = pred
      #    self.write()
      #    node.key = pred.key
      #    node.value = pred.value
      #    node = pred
        when T.Countable isnot void:
          proc update_parents(self:T, node:T.Node) =
            var curr = node
            while curr != nil:
              self.update(curr)
              curr = curr.p
    
        let child = if node.l != self.leaf: node.l else: node.r
        if child != self.leaf:
          child.p = node.p
          if node.p == nil:
            self.root = child
          elif node == node.p.l:
            node.p.l = child
          else:
            node.p.r = child
          when T.Countable isnot void:
            self.update_parents(node.p)
          if node.color == Color.black:
            self.fixErase(child, node.p)
        else:
          if node.p == nil:
            self.root = self.leaf
          elif node == node.p.l:
            node.p.l = self.leaf
          else:
            assert node == node.p.r
            node.p.r = self.leaf
          when T.Countable isnot void:
            self.update_parents(node.p)
          if node.color == Color.black:
            self.fixErase(self.leaf, node.p)
      # }}}
      
      proc len*[T:RedBlackTree](self: T): int =
        return self.size
      proc empty*[T:RedBlackTree](self: T): bool =
        return self.len == 0
      
      iterator iterOrder*[T:RedBlackTree](self: T): auto =
        var node = self.root
        var stack: seq[T.Node] = @[]
        while stack.len() != 0 or node != self.leaf:
          if node != self.leaf:
            stack.add(node)
            node = node.l
          else:
            node = stack.pop()
            if node == self.End: break
            yield node.key
            node = node.r
      {.pop.}
      discard
    type
      SortedSetType*[K, Countable; p:static[tuple]] = SortedTree[RedBlackTree[K, Countable], RedBlackTreeNode[K, Countable], MULTI_FALSE, K, void, p]
      SortedMultiSetType*[K, Countable; p:static[tuple]] = SortedTree[RedBlackTree[K, Countable], RedBlackTreeNode[K, Countable], MULTI_TRUE, K, void, p]
      SortedMapType*[K; V:not void; Countable; p:static[tuple]] = SortedTree[RedBlackTree[(K, V), Countable], RedBlackTreeNode[(K, V), Countable], MULTI_FALSE, K, V, p]
      SortedMultiMapType*[K; V:not void; Countable; p:static[tuple]] = SortedTree[RedBlackTree[(K, V), Countable], RedBlackTreeNode[(K, V), Countable], MULTI_TRUE, K, V, p]

    type SetOrMap = SortedMultiSetType or SortedSetType or SortedMultiMapType or SortedMapType
    proc init*[Tree:SetOrMap](self: var Tree) =
      when Tree.V is void:
        type T = Tree.K
      else:
        type T = (Tree.K, Tree.V)
      type Countable = Tree.Tree.Countable
      var End = RedBlackTreeNode[T, Countable](color: Color.black, id: -2)
      var leaf = RedBlackTreeNode[T, Countable](color: Color.black, id: -1)
      leaf.l = leaf; leaf.r = leaf
      End.p = nil
      End.l = leaf; End.r = leaf
      when Tree.Tree.Countable isnot void:
        leaf.cnt = 0
      self.root = End
      self.End = End
      self.leaf = leaf
      self.next_id = 0

  else:
    when not declared ATCODER_EXTRA_RANDOMIZED_BINARY_SEARCH_TREE_HPP:
      {.experimental: "codeReordering".}
      const ATCODER_EXTRA_RANDOMIZED_BINARY_SEARCH_TREE_HPP* = 1
      {.push inline.}
      import std/sugar
      import std/random
      when not declared ATCODER_RANGEUTILS_HPP:
        const ATCODER_RANGEUTILS_HPP* = 1
        type RangeType* = Slice[int] | HSlice[int, BackwardsIndex]
        type IndexType* = int | BackwardsIndex
        template halfOpenEndpoints*(p:Slice[int]):(int,int) = (p.a, p.b + 1)
        template `^^`*(s, i: untyped): untyped =
          (when i is BackwardsIndex: s.len - int(i) else: int(i))
        template halfOpenEndpoints*[T](s:T, p:RangeType):(int,int) =
          (p.a, s^^p.b + 1)
        discard
      import std/strutils
      type RBST_TRUE = int32
      type RBST_FALSE = void
      type RBSTNode*[D, L, useSum] = ref object
        cnt*:int
        l*,r*:RBSTNode[D, L, useSum]
        p*:RBSTNode[D, L, useSum]
        key*:D
        when useSum isnot void:
          sum*:D
        when L isnot void:
          lazy*:L
        id*:int
    
      type RBSTType*[D,L,Node,useP, useSum;p:static[tuple]] = object of RootObj
        root*, leaf*: Node
        when D isnot void:
          D0:D
        when L isnot void:
          L0:L
        r:Rand
        id_max:int
      type RandomizedBinarySearchTree*[D] = RBSTType[D,void,RBSTNode[D,void,RBST_FALSE],RBST_FALSE,RBST_FALSE,()]
      type LazyRandomizedBinarySearchTree*[D,L,useP,useSum] = RBSTType[D,L,RBSTNode[D,L,useSum],useP,useSum,()]
    
      type SomeRBST* = RBSTType or RandomizedBinarySearchTree or LazyRandomizedBinarySearchTree
    
      template calc_op[ST:RBSTType](self:typedesc[ST], a, b:ST.D):auto =
        block:
          let op = ST.p.op
          op(a, b)
      template calc_mapping[ST:RBSTType](self:typedesc[ST], a:ST.L, b:ST.D):auto =
        block:
          let mapping = ST.p.mapping
          mapping(a, b)
      template calc_composition[ST:RBSTType](self:typedesc[ST], a, b:ST.L):auto =
        block:
          let composition = ST.p.composition
          composition(a, b)
      template calc_p[ST:RBSTType](self:typedesc[ST], a:ST.L, b:Slice[int]):auto =
        block:
          let s = ST.p.p
          s(a, b)
    
      proc hasSum*[RBST:SomeRBST](t:typedesc[RBST]):bool {.compileTime.} =
        when t isnot RandomizedBinarySearchTree:
          return false
        else:
          t.useSum isnot RBST_FALSE
      #proc hasData*(t:typedesc):bool {.compileTime.} = t.D isnot void
      proc hasLazy*[RBST:SomeRBST](t:typedesc[RBST]):bool {.compileTime.} =
        when t isnot RandomizedBinarySearchTree:
          # TODO
          return false
        else:
          t.L isnot void
    #  proc hasP*(t:typedesc):bool {.compileTime.} = t.useP isnot void
      #proc isPersistent*(t:typedesc):bool {.compileTime.} = t.Persistent isnot void
      proc isLeaf*[Node:RBSTNode](node:Node):bool =
        return node.l == node
    
      proc initNode*[RBST:SomeRBST](self:RBST, k:RBST.D, p:RBST.L, id:int, cnt:int):auto =
        result = RBSTNode[RBST.D, RBST.L, RBST.useSum](cnt:cnt, key:k, lazy:p, l:self.leaf, r:self.leaf, p:nil , id:id)
        when RBST.hasSum: result.sum = k
      proc initNode*[RBST:SomeRBST](self:RBST, k:RBST.D, id:int, cnt:int):auto =
        result = RBSTNode[RBST.D, RBST.L, RBST.useSum](cnt:cnt, key:k, l:self.leaf, r:self.leaf, p:nil, id:id)
        when RBST.hasSum: result.sum = k
      proc alloc*[RBST:SomeRBST](self: var RBST, key:RBST.D, cnt = 1):RBST.Node =
        when RBST.hasLazy:
          result = self.initNode(key, self.L0, self.id_max, cnt)
        else:
          result = self.initNode(key, self.id_max, cnt)
        self.id_max.inc
      #  return &(pool[ptr++] = Node(key, self.L0));
    
      proc setRBST*[RBST:SomeRBST](self: var RBST, seed = 2019) =
        # leaf
        var leaf = RBST.Node(cnt:0, p:nil, id: -2)
        leaf.l = leaf;leaf.r = leaf
        self.leaf = leaf
    
        self.root = self.leaf
        self.r = initRand(seed)
        self.id_max = 0
    
      proc initRandomizedBinarySearchTree*[D](seed = 2019):auto =
        type Node = RBSTNode[D, void, void]
        result = RBSTType[D,void,Node,false,void,()]()
        result.setRBST()
      proc initRandomizedBinarySearchTree*[D](f:static[(D,D)->D], D0:D, seed = 2019):auto =
        type Node = RBSTNode[D, void, int]
        result = RBSTType[D,void,Node,false,int,(op:f)](D0:D0)
        result.setRBST()
      proc initRandomizedBinarySearchTree*[D, L](f:static[(D,D)->D], g:static[(L,D)->D], h:static[(L,L)->L], D0:D, L0:L, seed = 2019):auto =
        type Node = RBSTNode[D, L, int]
        result = RBSTType[D,L,Node,false,int,(op:f,mapping:g,composition:h)](D0:D0, L0:L0)
        result.setRBST()
      proc initRandomizedBinarySearchTree*[D, L](f:static[(D,D)->D], g:static[(L,D)->D], h:static[(L,L)->L], p:static[(L,Slice[int])->L],D0:D,L0:L,seed = 2019):auto =
        type Node = RBSTNode[D, L, int]
        result = RBSTType[D,L,Node,true,int,(op:f,mapping:g,composition:h,p:p)](D0:D0, L0:L0)
        result.setRBST()
    
      template clone*[D,L,useSum](t:RBSTNode[D, L, useSum]):auto = t
      proc test*[RBST:SomeRBST](self: var RBST, n, s:int):bool = 
        const randMax = 18_446_744_073_709_551_615u64
        let
          q = randMax div n.uint64
          qn = q * n.uint64
        while true:
          let x = self.r.next()
          if x < qn: return x < s.uint64 * q
      
    #K  proc count*[RBST:SomeRBST](self: RBST, t:RBST.Node):int = (if t != nil: t.cnt else: 0)
    #  proc count*[RBST:SomeRBST](self: RBST, t:RBST.Node):int = t.cnt
    #  proc sum*[RBST:SomeRBST](self: RBST, t:RBST.Node):auto = (if t != nil: t.sum else: self.D0)
      proc sum*[RBST:SomeRBST](self: RBST, t:RBST.Node):auto = t.sum
      proc len*[RBST:SomeRBST](self: RBST, t:RBST.Node):int = t.cnt
      proc len*[RBST:SomeRBST](self: RBST):int = self.len(self.root)
    
      proc update*[RBST:SomeRBST](self: RBST, t:RBST.Node):RBST.Node {.inline.} =
    #    t.cnt = self.count(t.l) + self.count(t.r) + 1
        t.cnt = t.l.cnt + t.r.cnt + 1
        when RBST.hasSum:
          t.sum = RBST.calc_op(RBST.calc_op(t.l.sum, t.key), t.r.sum)
        t
    
      proc propagate*[RBST:SomeRBST](self: var RBST, t:RBST.Node):auto =
        when RBST.hasLazy:
          var t = clone(t)
          if t.lazy != self.L0:
            when RBST.useP is RBST_TRUE:
              var (li, ri) = (0, 0)
            if t.l != self.leaf:
              t.l = clone(t.l)
              t.l.lazy = RBST.calc_composition(t.lazy, t.l.lazy)
              when RBST.useP is RBST_TRUE: ri = li + t.l.cnt
              t.l.sum = RBST.calc_mapping(when RBST.useP is RBST_TRUE: RBST.calc_p(t.lazy, li..<ri) else: t.lazy, t.l.sum)
            when RBST.useP is RBST_TRUE: li = ri
            t.key = RBST.calc_mapping(when RBST.useP is RBST_TRUE: RBST.calc_p(t.lazy, li..<li+1) else: t.lazy, t.key)
            when RBST.useP is RBST_TRUE: li.inc
            if t.r != self.leaf:
              t.r = clone(t.r)
              t.r.lazy = RBST.calc_composition(t.lazy, t.r.lazy)
              when RBST.useP is RBST_TRUE: ri = li + t.r.cnt
              t.r.sum = RBST.calc_mapping(when RBST.useP is RBST_TRUE: RBST.calc_p(t.lazy, li..<ri) else: t.lazy, t.r.sum)
            t.lazy = self.L0
          self.update(t)
        else:
          t
      
      proc merge*[RBST:SomeRBST](self: var RBST, l, r:RBST.Node):auto =
        if l == self.leaf: return r
        elif r == self.leaf: return l
        var (l, r) = (l, r)
        if self.test(l.cnt + r.cnt, l.cnt):
          when RBST.hasLazy:
            l = self.propagate(l)
          l.r = self.merge(l.r, r)
          if l.r != self.leaf: l.r.p = l
          return self.update(l)
        else:
          when RBST.hasLazy:
            r = self.propagate(r)
          r.l = self.merge(l, r.l)
          if r.l != self.leaf: r.l.p = r
          return self.update(r)
      
      proc split*[RBST:SomeRBST](self:var RBST, t:RBST.Node, k:int):(RBST.Node, RBST.Node) =
        if t == self.leaf: return (t, t)
        var t = t
        when RBST.hasLazy:
          t = self.propagate(t)
        if k <= t.l.cnt:
          var s = self.split(t.l, k)
          t.l = s[1]
          if t.l != self.leaf: t.l.p = t
          if s[0] != self.leaf: s[0].p = nil
          return (s[0], self.update(t))
        else:
          var s = self.split(t.r, k - t.l.cnt - 1)
          t.r = s[0]
          if t.r != self.leaf: t.r.p = t
          if s[1] != self.leaf: s[1].p = nil
          return (self.update(t), s[1])
    
      proc split*[RBST:SomeRBST](self:var RBST, t:RBST.Node, p:RBST.Node):(RBST.Node, RBST.Node) =
        if t == self.leaf: return (t, t)
        var t = t
        when RBST.hasLazy:
          proc propagate_up(self: var RBST, t:RBST.Node, p:RBST.Node) =
            if p == nil: return
            self.propagate_up(p.p)
            p = self.propagate(p)
        var p = p
        result[0] = p.l
        p.l = self.leaf
        result[1] = p
        while p != nil:
          if p == t: break
          # p is divided into (result[0], result[1])
          let q = p.p
          if q.l == p: #          result[0], (result[1], q.r)
            q.l = result[1]
            if q.l != self.leaf: q.l.p = q
            if result[0] != self.leaf: result[0].p = nil
            result = (result[0], self.update(q))
          else: # q.r == p,       (q.l, result[0]), result[1]
            q.r = result[0]
            if q.r != self.leaf: q.r.p = q
            if result[1] != self.leaf: result[1].p = nil
            result = (self.update(q), result[1])
          p = q
    
      proc build*[RBST:SomeRBST](self: var RBST, s:Slice[int], v:seq[RBST.D]):auto =
        let (l, r) = (s.a, s.b + 1)
        if l + 1 >= r: return self.alloc(v[l])
        var (x, y) = (self.build(l..<(l + r) shr 1, v), self.build((l + r) shr 1..<r, v))
        return self.merge(x, y)
      
      proc build*[RBST:SomeRBST](self: var RBST, v:seq[RBST.D]) =
        self.root = self.build(0..<v.len, v)
      
      proc to_vec*[RBST:SomeRBST](self: RBST, r:RBST.Node, v:var seq[RBST.D]) =
        if r == self.leaf: return
        when RBST.hasLazy:
          var r = r
          r = self.propagate(r)
        self.to_vec(r.l, v)
        v.add(r.key)
      #  *it = r.key;
        self.to_vec(r.r, v)
      
      proc to_vec*[RBST:SomeRBST](self: RBST, r:RBST.Node):auto =
        result = newSeq[RBST.D]()
        self.to_vec(r, result)
      
      proc to_string*[RBST:SomeRBST](self: RBST, r:RBST.Node):string =
        return "{" & self.to_vec(r).join(", ") & "}"
      
      proc write_tree*[RBST:SomeRBST](self: var RBST, r:RBST.Node, h = 0) =
        if h == 0: echo "========== tree ======="
        if r == self.leaf:
          for i in 0..<h: stdout.write "  "
          echo "*"
          return
        when RBST.hasLazy:
          var r = r
          r = self.propagate(r)
        for i in 0..<h: stdout.write "  "
    #    stdout.write r.id, ": ", r.key, ", ", r.sum
        stdout.write r.id, ": ", r.key, " ", r.cnt
        when RBST.hasLazy:
          stdout.write ", ", r.lazy
        echo ""
        self.write_tree(r.l, h+1)
        self.write_tree(r.r, h+1)
        if h == 0: echo "========== end ======="
      proc write_tree*[RBST:SomeRBST](self: var RBST) =
        self.write_tree(self.root)
      
      proc insert_index*[RBST:SomeRBST](self: var RBST, t:var RBST.Node, k:int, v:RBST.D) =
        var x = self.split(t, k)
        t = self.merge(self.merge(x[0], self.alloc(v)), x[1])
    
      proc insert*[RBST:SomeRBST](self: var RBST, t:var RBST.Node, p:RBST.Node, v:RBST.D):RBST.Node {.discardable.} =
        var x = self.split(t, p)
        result = self.alloc(v)
        t = self.merge(self.merge(x[0], result), x[1])
    
      proc erase_index*[RBST:SomeRBST](self: var RBST, t:var RBST.Node, k:int) =
        var x = self.split(t, k)
        t = self.merge(x[0], self.split(x[1], 1)[1])
    
      proc erase*[RBST:SomeRBST](self: var RBST, t:var RBST.Node, p:RBST.Node):RBST.Node {.discardable.} =
        var p2 = p.succ
        var x = self.split(t, p)
        t = self.merge(x[0], self.split(x[1], p2)[1])
        return p2
    
      proc prod*[RBST:SomeRBST](self: var RBST, t:var RBST.Node, p:Slice[int]):auto =
        let (a, b) = p.halfOpenEndpoints
        var
          x = self.split(t, a)
          y = self.split(x[1], b - a)
        result = self.sum(y[0])
        var m = self.merge(y[0], y[1])
        t = self.merge(x[0], m)
      
      proc apply*[RBST:SomeRBST](self:var RBST, t:var RBST.Node, s:Slice[int], p:RBST.L) =
        static: assert RBST.hasLazy
        let (a, b) = s.halfOpenEndpoints
        var
          x = self.split(t, a)
          y = self.split(x[1], b - a)
        y[0].lazy = RBST.calc_composition(p, y[0].lazy)
        var m = self.merge(self.propagate(y[0]), y[1])
        t = self.merge(x[0], m)
      
      proc set*[RBST:SomeRBST](self: var RBST, t:var RBST.Node, k:int, x:RBST.D) =
        when RBST.hasLazy:
          t = self.propagate(t)
        if k < t.l.cnt: self.set(t.l, k, x)
        elif k == t.l.cnt:
          t.key = x
          t.sum = x
        else: self.set(t.r, k - t.l.cnt - 1, x)
        t = self.update(t)
      
      proc empty*[RBST:SomeRBST](self: var RBST, t:RBST.Node):bool = self.len == 0
    
    
      proc insert_index*[RBST:SomeRBST](self: var RBST, k:int, v:RBST.D) = self.insert_index(self.root, k, v)
      proc insert*[RBST:SomeRBST](self: var RBST, p:RBST.Node, v:RBST.D):RBST.Node {.discardable.} =
        self.insert(self.root, p, v)
      proc erase_index*[RBST:SomeRBST](self: var RBST, k:int) = self.erase_index(self.root, k)
      proc erase*[RBST:SomeRBST](self: var RBST, p:RBST.Node):RBST.Node {.discardable.} =
        self.erase(self.root, p)
      proc prod*[RBST:SomeRBST](self: var RBST, p:Slice[int]):auto = self.prod(self.root, p)
      proc `[]`*[RBST:SomeRBST](self: var RBST, p:Slice[int]):auto = self.prod(self.root, p)
      proc apply*[RBST:SomeRBST](self:var RBST, s:Slice[int], p:RBST.L) = self.apply(self.root, s, p)
      proc set*[RBST:SomeRBST](self: var RBST, k:int, x:RBST.D) = self.set(self.root, k, x)
      proc `[]=`*[RBST:RBSTType](self: var RBST, k:int, x:RBST.D) = self.set(self.root, k, x)
      proc empty*[RBST:SomeRBST](self: var RBST):bool = self.empty(self.root)
      proc check_tree*[RBST:SomeRBST](self: RBST, t:RBST.Node):int =
        if t == self.leaf: return 0
        result = 1
        if t.l != self.leaf:
          doAssert t.l.p == t
          result += self.check_tree(t.l)
        if t.r != self.leaf:
          doAssert t.r.p == t
          result += self.check_tree(t.r)
      proc check_tree*[RBST:SomeRBST](self: RBST):int {.discardable.} =
        doAssert self.root.p == nil
        self.check_tree(self.root)
      {.pop.}
      discard
 
    type SortedSetType*[K, Countable; p:static[tuple]] = SortedTree[RandomizedBinarySearchTree[K], RBSTNode[K, void, void], MULTI_FALSE, K, void, p]
    type SortedMultiSetType*[K, Countable; p:static[tuple]] = SortedTree[RandomizedBinarySearchTree[K], RBSTNode[K, void, void], MULTI_TRUE, K, void, p]
    type SortedMapType*[K, V, Countable; p:static[tuple]] = SortedTree[RandomizedBinarySearchTree[(K, V)], RBSTNode[(K, V), void, void], MULTI_FALSE, K, V, p]
    type SortedMultiMapType*[K, V, Countable; p:static[tuple]] = SortedTree[RandomizedBinarySearchTree[(K, V)], RBSTNode[(K, V), void, void], MULTI_TRUE, K, V, p]
  
    type SetOrMap = SortedMultiSetType or SortedSetType or SortedMultiMapType or SortedMapType
  
    proc init*[Tree:SetOrMap](self: var Tree) =
      when Tree.V is void:
        type T = Tree.K
      else:
        type T = (Tree.K, Tree.V)
      Tree.Tree(self).setRBST()
      var end_node = RBSTNode[T, void, void](cnt: 1, p:nil, id: -1)
      end_node.l = self.leaf; end_node.r = self.leaf;
      self.End = end_node
      self.root = self.End
  
  #  RBST(sz, [&](T x, T y) { return x; }, T()) {}
    
    proc `*`*[Node:RBSTNode](it:Node):auto = it.key
  
    proc len*[Tree:SetOrMap](self:Tree):int = Tree.Tree(self).len() - 1
    proc empty*[Tree:SetOrMap](self:Tree):bool = self.len() == 0
    proc check_tree*(self:SetOrMap) =
      doAssert self.len + 1 == self.check_tree()
  
#    proc `$`*(self: SetOrMap):string = self.Tree(self).to_string(self.root)
  {.pop.}

  template SortedSet*(K:typedesc, comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedSetType[K, void, (comp,)]
  template SortedMultiSet*(K:typedesc, comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedMultiSetType[K, void, (comp,)]
  template SortedMap*(K:typedesc; V:typedesc[not void], comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedMapType[K, V, void, (comp,)]
  template SortedMultiMap*(K:typedesc; V:typedesc[not void], comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedMultiMapType[K, V, void, (comp,)]
  template CountableSortedSet*(K:typedesc, comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedSetType[K, int, (comp,)]
  template CountableSortedMultiSet*(K:typedesc, comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedMultiSetType[K, int, (comp,)]
  template CountableSortedMap*(K:typedesc; V:typedesc[not void], comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedMapType[K, V, int, (comp,)]
  template CountableSortedMultiMap*(K:typedesc; V:typedesc[not void], comp:static[proc(a, b:K):bool] = nil):typedesc =
    SortedMultiMapType[K, V, int, (comp,)]

  proc default*[T:SetOrMap](self:typedesc[T]):T =
    result.init()
  proc initSortedSet*(K:typedesc, countable:static[bool] = false, comp:static[proc(a, b:K):bool] = nil):auto =
    var r: SortedSetType[K, when countable: int else: void, (comp,)]
    r.init()
    return r
  proc initSortedMultiSet*(K:typedesc, countable:static[bool] = false, comp:static[proc(a, b:K):bool] = nil):auto =
    var r: SortedMultiSetType[K, when countable: int else: void, (comp,)]
    r.init()
    return r
  proc initSortedMap*(K:typedesc, V:typedesc[not void], countable:static[bool] = false, comp:static[proc(a, b:K):bool] = nil):auto =
    var r: SortedMapType[K, V, when countable: int else: void, (comp,)]
    r.init()
    return r
  proc initSortedMultiMap*(K:typedesc, V:typedesc[not void], countable:static[bool] = false, comp:static[proc(a, b:K):bool] = nil):auto =
    var r: SortedMultiMapType[K, V, when countable: int else: void, (comp,)]
    r.init()
    return r

  proc `$`*(self: SetOrMap): string =
    var a = newSeq[string]()
    var node = self.root
    var stack: seq[self.Node] = @[]
    while stack.len() != 0 or not node.isLeaf:
      if not node.isLeaf:
        if node != self.End:
          stack.add(node)
        node = node.l
      else:
        node = stack.pop()
        when self.V is void:
          var k = ""
          k.addQuoted(node.key)
          a &= k
        else:
          var k, v = ""
          k.addQuoted(node.key[0])
          v.addQuoted(node.key[1])
          a &= k & ": " & v
        node = node.r
    return "{" & a.join(", ") & "}"


  discard
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
  proc `&`*[B:SomeInteger](a:B, b:openarray[int]):auto = a and b
  proc `|`*[B:SomeInteger](a:B, b:openarray[int]):auto = a or b
  proc `&`*(a:SomeInteger, b:SomeInteger):auto = a and b
  proc `|`*(a:SomeInteger, b:SomeInteger):auto = a or b

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
  discard
when not declared ATCODER_DIRECTION:
  const ATCODER_DIRECTION* = 1
  let dir4* = [(1, 0), (0, 1), (-1, 0), (0, -1)]
  let dir8* = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

  iterator neighbor*(p:(int, int), d:openArray[(int, int)]):(int, int) =
    for d in d:
      let (i, j) = (p[0] + d[0], p[1] + d[1])
      yield (i, j)
  iterator neighbor*(p:(int, int), d:openArray[(int, int)], limit:(Slice[int], Slice[int])):(int, int) =
    for (i, j) in p.neighbor(d):
      if i notin limit[0] or j notin limit[1]: continue
      yield (i, j)
  discard

var N2:int
id(i, j:int) => i * N2 + j

solveProc solve(N:int, K:int, S:seq[string]):
  N2 = N
  var a = initSortedSet(uint)
#  proc id(i, j:int):int = i * N + j
  for i in N:
    for j in N:
      if S[i][j] == '#': continue
      a.incl(0u | [id(i, j)])
  for _ in K - 1:
    var a2 = initSortedSet(uint)
    for b in a:
      var t = Seq[N, N: false]
      for i in N:
        for j in N:
          if b[id(i, j)]: t[i][j] = true
      for i in N:
        for j in N:
          if S[i][j] == '#' or t[i][j]: continue
          var found = false
          for (i2, j2) in (i, j).neighbor(dir4, (0..<N, 0..<N)):
            if t[i2][j2]: found = true; break
          if found:
            a2.incl(b or [id(i, j)])
    swap(a, a2)
  echo a.len
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, K, S)
