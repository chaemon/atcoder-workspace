import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL


import macros;macro ImportExpand(s:untyped):untyped = parseStmt($s[2])
const
  DEBUG = true

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/header/chaemon_header.nim
ImportExpand "src/atcoder/extra/header/chaemon_header.nim" <=== "when not declared ATCODER_CHAEMON_HEADER_HPP:\n  const ATCODER_CHAEMON_HEADER_HPP* = 1\n\n  {.hints:off warnings:off assertions:on optimization:speed.}\n  when declared(DO_CHECK):\n    when DO_CHECK:\n      static: echo \"check is on\"\n      {.checks:on.}\n    else:\n      static: echo \"check is off\"\n      {.checks:off.}\n  else:\n    static: echo \"check is on\"\n    {.checks:on.}\n\n  import std/algorithm as algorithm_lib\n  import std/sequtils as sequtils_lib\n  import std/macros as macros_lib\n  import std/math as math_lib\n  import std/sets as sets_lib\n  import std/tables as tables_lib\n  import std/strutils as strutils_lib\n  import std/strformat as strformat_lib\n  import std/options as options_lib\n  import std/bitops as bitops_lib\n  import std/streams as streams_lib\n  import std/deques as deques_lib\n\n  #[ import atcoder/extra/other/internal_sugar ]#\n  when not declared ATCODER_INTERNAL_SUGAR_HPP:\n    const ATCODER_INTERNAL_SUGAR_HPP* = 1\n    import std/macros\n    import std/typetraits\n    \n    proc checkPragma(ex, prag: var NimNode) =\n    #  since (1, 3):\n      block:\n        if ex.kind == nnkPragmaExpr:\n          prag = ex[1]\n          if ex[0].kind == nnkPar and ex[0].len == 1:\n            ex = ex[0][0]\n          else:\n            ex = ex[0]\n    \n    proc createProcType(p, b: NimNode): NimNode {.compileTime.} =\n      result = newNimNode(nnkProcTy)\n      var\n        formalParams = newNimNode(nnkFormalParams).add(b)\n        p = p\n        prag = newEmptyNode()\n    \n      checkPragma(p, prag)\n    \n      case p.kind\n      of nnkPar, nnkTupleConstr:\n        for i in 0 ..< p.len:\n          let ident = p[i]\n          var identDefs = newNimNode(nnkIdentDefs)\n          case ident.kind\n          of nnkExprColonExpr:\n            identDefs.add ident[0]\n            identDefs.add ident[1]\n          else:\n            identDefs.add newIdentNode(\"i\" & $i)\n            identDefs.add(ident)\n          identDefs.add newEmptyNode()\n          formalParams.add identDefs\n      else:\n        var identDefs = newNimNode(nnkIdentDefs)\n        identDefs.add newIdentNode(\"i0\")\n        identDefs.add(p)\n        identDefs.add newEmptyNode()\n        formalParams.add identDefs\n    \n      result.add formalParams\n      result.add prag\n    \n    macro `=>`*(p, b: untyped): untyped =\n      ## Syntax sugar for anonymous procedures.\n      ## It also supports pragmas.\n      var\n        params = @[ident\"auto\"]\n        name = newEmptyNode()\n        kind = nnkLambda\n        pragma = newEmptyNode()\n        p = p\n    \n      checkPragma(p, pragma)\n    \n      if p.kind == nnkInfix and p[0].kind == nnkIdent and p[0].eqIdent\"->\":\n        params[0] = p[2]\n        p = p[1]\n    \n      checkPragma(p, pragma) # check again after -> transform\n  #    since (1, 3):\n      block:\n  #      if p.kind == nnkCall:\n        if p.kind in {nnkCall, nnkObjConstr}:\n          # foo(x, y) => x + y\n          kind = nnkProcDef\n          name = p[0]\n          let newP = newNimNode(nnkPar)\n          for i in 1..<p.len:\n            newP.add(p[i])\n          p = newP\n    \n      case p.kind\n      of nnkPar, nnkTupleConstr:\n        var untypedBeforeColon = 0\n        for i, c in p:\n          var identDefs = newNimNode(nnkIdentDefs)\n          case c.kind\n          of nnkExprColonExpr:\n            let t = c[1]\n    #        since (1, 3):\n            block:\n              # + 1 here because of return type in params\n              for j in (i - untypedBeforeColon + 1) .. i:\n                params[j][1] = t\n            untypedBeforeColon = 0\n            identDefs.add(c[0])\n            identDefs.add(t)\n            identDefs.add(newEmptyNode())\n          of nnkIdent:\n            identDefs.add(c)\n            identDefs.add(newIdentNode(\"auto\"))\n            identDefs.add(newEmptyNode())\n            inc untypedBeforeColon\n          of nnkInfix:\n            if c[0].kind == nnkIdent and c[0].eqIdent\"->\":\n              var procTy = createProcType(c[1], c[2])\n              params[0] = procTy[0][0]\n              for i in 1 ..< procTy[0].len:\n                params.add(procTy[0][i])\n            else:\n              error(\"Expected proc type (->) got (\" & c[0].strVal & \").\", c)\n            break\n          else:\n            error(\"Incorrect procedure parameter list.\", c)\n          params.add(identDefs)\n      of nnkIdent:\n        var identDefs = newNimNode(nnkIdentDefs)\n        identDefs.add(p)\n        identDefs.add(ident\"auto\")\n        identDefs.add(newEmptyNode())\n        params.add(identDefs)\n      else:\n        error(\"Incorrect procedure parameter list.\", p)\n      result = newProc(body = b, params = params,\n                       pragmas = pragma, name = name,\n                       procType = kind)\n  \n    macro `->`*(p, b: untyped): untyped =\n      result = createProcType(p, b)\n    \n    macro dump*(x: untyped): untyped =\n      let s = x.toStrLit\n      let r = quote do:\n        debugEcho `s`, \" = \", `x`\n      return r\n    \n    # TODO: consider exporting this in macros.nim\n    proc freshIdentNodes(ast: NimNode): NimNode =\n      # Replace NimIdent and NimSym by a fresh ident node\n      # see also https://github.com/nim-lang/Nim/pull/8531#issuecomment-410436458\n      proc inspect(node: NimNode): NimNode =\n        case node.kind:\n        of nnkIdent, nnkSym:\n          result = ident($node)\n        of nnkEmpty, nnkLiterals:\n          result = node\n        else:\n          result = node.kind.newTree()\n          for child in node:\n            result.add inspect(child)\n      result = inspect(ast)\n    \n    macro capture*(locals: varargs[typed], body: untyped): untyped =\n      var params = @[newIdentNode(\"auto\")]\n      let locals = if locals.len == 1 and locals[0].kind == nnkBracket: locals[0]\n                   else: locals\n      for arg in locals:\n        if arg.strVal == \"result\":\n          error(\"The variable name cannot be `result`!\", arg)\n        params.add(newIdentDefs(ident(arg.strVal), freshIdentNodes getTypeInst arg))\n      result = newNimNode(nnkCall)\n      result.add(newProc(newEmptyNode(), params, body, nnkProcDef))\n      for arg in locals: result.add(arg)\n    \n    #[ import atcoder/extra/other/internal_underscored_calls ]#\n    when not declared ATCODER_INTERNAL_UNDERSCORED_CALLS_HPP:\n      const ATCODER_INTERNAL_UNDERSCORED_CALLS_HPP* = 1\n      import macros\n    \n      proc underscoredCall(n, arg0: NimNode): NimNode =\n        proc underscorePos(n: NimNode): int =\n          for i in 1 ..< n.len:\n            if n[i].eqIdent(\"_\"): return i\n          return 0\n    \n        if n.kind in nnkCallKinds:\n          result = copyNimNode(n)\n          result.add n[0]\n    \n          let u = underscorePos(n)\n          for i in 1..u-1: result.add n[i]\n          result.add arg0\n          for i in u+1..n.len-1: result.add n[i]\n        elif n.kind in {nnkAsgn, nnkExprEqExpr}:\n          var field = n[0]\n          if n[0].kind == nnkDotExpr and n[0][0].eqIdent(\"_\"):\n            # handle _.field = ...\n            field = n[0][1]\n          result = newDotExpr(arg0, field).newAssignment n[1]\n        else:\n          # handle e.g. 'x.dup(sort)'\n          result = newNimNode(nnkCall, n)\n          result.add n\n          result.add arg0\n    \n      proc underscoredCalls*(result, calls, arg0: NimNode) =\n        expectKind calls, {nnkArgList, nnkStmtList, nnkStmtListExpr}\n    \n        for call in calls:\n          if call.kind in {nnkStmtList, nnkStmtListExpr}:\n            underscoredCalls(result, call, arg0)\n          else:\n            result.add underscoredCall(call, arg0)\n      discard\n  \n    macro dup*[T](arg: T, calls: varargs[untyped]): T =\n      result = newNimNode(nnkStmtListExpr, arg)\n      let tmp = genSym(nskVar, \"dupResult\")\n      result.add newVarStmt(tmp, arg)\n      underscoredCalls(result, calls, tmp)\n      result.add tmp\n    \n    \n    proc transLastStmt(n, res, bracketExpr: NimNode): (NimNode, NimNode, NimNode) =\n      # Looks for the last statement of the last statement, etc...\n      case n.kind\n      of nnkIfExpr, nnkIfStmt, nnkTryStmt, nnkCaseStmt:\n        result[0] = copyNimTree(n)\n        result[1] = copyNimTree(n)\n        result[2] = copyNimTree(n)\n        for i in ord(n.kind == nnkCaseStmt)..<n.len:\n          (result[0][i], result[1][^1], result[2][^1]) = transLastStmt(n[i], res, bracketExpr)\n      of nnkStmtList, nnkStmtListExpr, nnkBlockStmt, nnkBlockExpr, nnkWhileStmt,\n          nnkForStmt, nnkElifBranch, nnkElse, nnkElifExpr, nnkOfBranch, nnkExceptBranch:\n        result[0] = copyNimTree(n)\n        result[1] = copyNimTree(n)\n        result[2] = copyNimTree(n)\n        if n.len >= 1:\n          (result[0][^1], result[1][^1], result[2][^1]) = transLastStmt(n[^1], res, bracketExpr)\n      of nnkTableConstr:\n        result[1] = n[0][0]\n        result[2] = n[0][1]\n        if bracketExpr.len == 1:\n          bracketExpr.add([newCall(bindSym\"typeof\", newEmptyNode()), newCall(\n              bindSym\"typeof\", newEmptyNode())])\n        template adder(res, k, v) = res[k] = v\n        result[0] = getAst(adder(res, n[0][0], n[0][1]))\n      of nnkCurly:\n        result[2] = n[0]\n        if bracketExpr.len == 1:\n          bracketExpr.add(newCall(bindSym\"typeof\", newEmptyNode()))\n        template adder(res, v) = res.incl(v)\n        result[0] = getAst(adder(res, n[0]))\n      else:\n        result[2] = n\n        if bracketExpr.len == 1:\n          bracketExpr.add(newCall(bindSym\"typeof\", newEmptyNode()))\n        template adder(res, v) = res.add(v)\n        result[0] = getAst(adder(res, n))\n    \n    macro collect*(init, body: untyped): untyped =\n      # analyse the body, find the deepest expression 'it' and replace it via\n      # 'result.add it'\n      let res = genSym(nskVar, \"collectResult\")\n      expectKind init, {nnkCall, nnkIdent, nnkSym}\n      let bracketExpr = newTree(nnkBracketExpr,\n        if init.kind == nnkCall: init[0] else: init)\n      let (resBody, keyType, valueType) = transLastStmt(body, res, bracketExpr)\n      if bracketExpr.len == 3:\n        bracketExpr[1][1] = keyType\n        bracketExpr[2][1] = valueType\n      else:\n        bracketExpr[1][1] = valueType\n      let call = newTree(nnkCall, bracketExpr)\n      if init.kind == nnkCall:\n        for i in 1 ..< init.len:\n          call.add init[i]\n      result = newTree(nnkStmtListExpr, newVarStmt(res, call), resBody, res)\n    discard\n#  import std/sugar\n  #[ import atcoder/extra/other/reader ]#\n  when not declared ATCODER_READER_HPP:\n    const ATCODER_READER_HPP* = 1\n    import streams\n    import strutils\n    import sequtils\n  #  proc scanf*(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n    #proc getchar(): char {.header: \"<stdio.h>\", varargs.}\n  #  proc nextInt*(): int = scanf(\"%lld\",addr result)\n  #  proc nextFloat*(): float = scanf(\"%lf\",addr result)\n    proc nextString*(f:auto = stdin): string =\n      var get = false\n      result = \"\"\n      while true:\n        let c = f.readChar\n        #doassert c.int != 0\n        if c.int > ' '.int:\n          get = true\n          result.add(c)\n        elif get: return\n    proc nextInt*(f:auto = stdin): int = parseInt(f.nextString)\n    proc nextFloat*(f:auto = stdin): float = parseFloat(f.nextString)\n  #  proc nextString*():string = stdin.nextString()\n  \n    proc toStr*[T](v:T):string =\n      proc `$`[T](v:seq[T]):string =\n        v.mapIt($it).join(\" \")\n      return $v\n    \n    proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =\n      result = \"\"\n      for i,v in x:\n        if i != 0: addSep(result, sep = sep)\n        add(result, v)\n      result.add(\"\\n\")\n      stdout.write result\n    \n    var print*:proc(x: varargs[string, toStr])\n    print = proc(x: varargs[string, toStr]) =\n      discard print0(@x, sep = \" \")\n    discard\n  #[ import atcoder/extra/other/cfor ]#\n  when not declared ATCODER_CFOR_HPP:\n    import std/macros\n    const ATCODER_CFOR_HPP* = 1\n    macro For*(preLoop, condition, postLoop, body:untyped):NimNode =\n      var\n        preLoop = if preLoop.repr == \"()\": ident(\"discard\") else: preLoop\n        condition = if condition.repr == \"()\": ident(\"true\") else: condition\n        postLoop = if postLoop.repr == \"()\": ident(\"discard\") else: postLoop\n      quote do:\n        `preLoop`\n        var start_cfor {.gensym.} = true\n        while true:\n          if start_cfor:\n            start_cfor = false\n          else:\n            `postLoop`\n          if not `condition`:\n            break\n          `body`\n    template cfor*(preLoop, condition, postLoop, body:untyped):NimNode =\n      For(preLoop, condition, postLoop, body)\n    discard\n  #[ import atcoder/extra/other/sliceutils ]#\n  when not declared ATCODER_SLICEUTILS_HPP:\n    const ATCODER_SLICEUTILS_HPP* = 1\n    proc index*[T](a:openArray[T]):Slice[int] =\n      a.low..a.high\n    type ReversedSlice[T] = distinct Slice[T]\n    type StepSlice[T] = object\n      s:Slice[T]\n      d:T\n    proc rev*[T](p:Slice[T]):ReversedSlice[T] = ReversedSlice[T](p)\n    iterator items*(n:int):int = (for i in 0..<n: yield i)\n    iterator items*[T](p:ReversedSlice[T]):T =\n      if Slice[T](p).b >= Slice[T](p).a:\n        var i = Slice[T](p).b\n        while true:\n          yield i\n          if i == Slice[T](p).a:break\n          i.dec\n    proc `>>`*[T](s:Slice[T], d:T):StepSlice[T] =\n      assert d != 0\n      StepSlice[T](s:s, d:d)\n    proc `<<`*[T](s:Slice[T], d:T):StepSlice[T] =\n      assert d != 0\n      StepSlice[T](s:s, d: -d)\n    proc low*[T](s:StepSlice[T]):T = s.s.a\n    proc high*[T](s:StepSlice[T]):T =\n      let p = s.s.b - s.s.a\n      if p < 0: return s.low - 1\n      let d = abs(s.d)\n      return s.s.a + (p div d) * d\n    iterator items*[T](p:StepSlice[T]):T = \n      assert p.d != 0\n      if p.s.a <= p.s.b:\n        if p.d > 0:\n          var i = p.low\n          let h = p.high\n          while i <= h:\n            yield i\n            if i == h: break\n            i += p.d\n        else:\n          var i = p.high\n          let l = p.low\n          while i >= l:\n            yield i\n            if i == l: break\n            i += p.d\n    proc `[]`*[T:SomeInteger, U](a:openArray[U], s:Slice[T]):seq[U] =\n      for i in s:result.add(a[i])\n    proc `[]=`*[T:SomeInteger, U](a:var openArray[U], s:StepSlice[T], b:openArray[U]) =\n      var j = 0\n      for i in s:\n        a[i] = b[j]\n        j.inc\n    discard\n  #[ import atcoder/extra/other/assignment_operator ]#\n  when not declared ATCODER_ASSIGNMENT_OPERATOR_HPP:\n    import std/macros\n    import std/strformat\n    const ATCODER_ASSIGNMENT_OPERATOR_HPP* = 1\n    template `>?=`*(x,y:typed):void = x.max= y\n    template `<?=`*(x,y:typed):void = x.min= y\n    proc `//`*[T:SomeInteger](x,y:T):T = x div y\n    proc `%`*[T:SomeInteger](x,y:T):T = x mod y\n    macro generateAssignmentOperator*(ops:varargs[untyped]) =\n      var strBody = \"\"\n      for op in ops:\n        let op = op.repr\n        var op_raw = op\n        if op_raw[0] == '`':\n          op_raw = op_raw[1..^2]\n        strBody &= fmt\"\"\"proc `{op_raw}=`*[S, T](a:var S, b:T):auto {{.inline discardable.}} = (mixin {op};a = `{op_raw}`(a, b);return a){'\\n'}\"\"\"\n      parseStmt(strBody)\n    generateAssignmentOperator(`mod`, `div`, `and`, `or`, `xor`, `shr`, `shl`, `<<`, `>>`, max, min, `%`, `//`, `&`, `|`, `^`)\n    discard\n  #[ import atcoder/extra/other/inf ]#\n  when not declared ATCODER_INF_HPP:\n    const ATCODER_INF_HPP* = 1\n    import sequtils\n    template inf*(T:typedesc): untyped = \n      when T is SomeFloat: T(Inf)\n      elif T is SomeInteger: T.high div 2\n      else:\n        static: assert(false)\n    template infRepr*[T](x:T):string =\n      when T is seq or T is array:\n        \"@[\" & x.mapIt(it.infRepr).join(\", \") & \"]\"\n      elif x is SomeInteger or x is SomeFloat:\n        if x >= T.inf: \"inf\"\n        elif x <= -T.inf: \"-inf\"\n        else: $x\n      else:\n        $x\n    proc `∞`*(T:typedesc):T = T.inf\n    proc `*!`*[T:SomeInteger](a, b:T):T =\n      if a == T(0) or b == T(0): return T(0)\n      var sgn = T(1)\n      if a < T(0): sgn = -sgn\n      if b < T(0): sgn = -sgn\n      let a = abs(a)\n      let b = abs(b)\n      if b > T.inf div a: result = T.inf\n      else: result = min(T.inf, a * b)\n      result *= sgn\n    proc `+!`*[T:SomeInteger](a, b:T):T =\n      result = a + b\n      result = min(T.inf, result)\n      result = max(-T.inf, result)\n    proc `-!`*[T:SomeInteger](a, b:T):T =\n      result = a - b\n      result = min(T.inf, result)\n      result = max(-T.inf, result)\n    discard\n  #[ import atcoder/extra/other/warlus_operator ]#\n  when not declared ATCODER_CHAEMON_WARLUS_OPERATOR_HPP:\n    const ATCODER_CHAEMON_WARLUS_OPERATOR_HPP* = 1\n    import macros\n    proc discardableId*[T](x: T): T {.discardable.} = x\n  \n    proc warlusImpl(x, y:NimNode):NimNode =\n      return quote do:\n        when declaredInScope(`x`):\n          `x` = `y`\n        else:\n          var `x` = `y`\n  \n    macro `:=`*(x, y: untyped): untyped =\n      result = newStmtList()\n      if x.kind == nnkCurly:\n        for i,xi in x: result.add warlusImpl(xi, y)\n      elif x.kind == nnkPar:\n        for i,xi in x: result.add warlusImpl(xi, y[i])\n      else:\n        result.add warlusImpl(x, y)\n        result.add quote do:\n          discardableId(`x`)\n    discard\n  #[ import atcoder/extra/other/seq_array_utils ]#\n  when not declared ATCODER_SEQ_ARRAY_UTILS:\n    const ATCODER_SEQ_ARRAY_UTILS* = 1\n    import std/strformat\n    import std/macros\n    type SeqType = object\n    type ArrayType = object\n    let\n      Seq* = SeqType()\n      Array* = ArrayType()\n  \n    template fill*[T](a:var T, init:untyped) =\n      when T is init.type:\n        a = init\n      else:\n        for x in a.mitems: fill(x, init)\n  \n    template makeSeq*(x:int; init):auto =\n      when init is typedesc: newSeq[init](x)\n      else:\n        var a = newSeq[typeof(init, typeofProc)](x)\n        a.fill(init)\n        a\n  \n    template makeArray*(x:int or Slice[int]; init):auto =\n      var v:array[x, init.type]\n      v\n  \n    macro `[]`*(x:ArrayType or SeqType, args:varargs[untyped]):auto =\n      var a:string\n      if $x == \"Seq\" and args.len == 1 and args[0].kind != nnkExprColonExpr:\n        a = fmt\"newSeq[{args[0].repr}]()\"\n      else:\n        let tail = args[^1]\n        assert tail.kind == nnkExprColonExpr, \"Wrong format of tail\"\n        let\n          args = args[0 .. ^2] & tail[0]\n          init = tail[1]\n        a = fmt\"{init.repr}\"\n        if $x == \"Array\":\n          for i in countdown(args.len - 1, 0): a = fmt\"makeArray({args[i].repr}, {a})\"\n          a = fmt\"{'\\n'}block:{'\\n'}  var a = {a}{'\\n'}  when {init.repr} isnot typedesc:{'\\n'}    a.fill({init.repr}){'\\n'}  a\"\n        elif $x == \"Seq\":\n          for i in countdown(args.len - 1, 0): a = fmt\"makeSeq({args[i].repr}, {a})\"\n          a = fmt\"{'\\n'}block:{'\\n'}  {a}\"\n        else:\n          assert(false)\n      parseStmt(a)\n    discard\n  #[ include atcoder/extra/other/debug ]#\n  when not declared ATCODER_DEBUG_HPP:\n    const ATCODER_DEBUG_HPP* = 1\n    import macros\n    import strformat\n    import terminal\n    #[ import atcoder/extra/other/inf ]#\n  \n    macro debugImpl*(n:varargs[untyped]): untyped =\n      #  var a = \"stderr.write \"\n      var a = \"\"\n  #    a.add \"setForegroundColor fgYellow\\n\"\n  #    a.add \"stdout.write \"\n  #    a.add \"stderr.write \"\n      a.add \"styledWriteLine stderr, fgYellow, \"\n      for i,x in n:\n        if x.kind == nnkStrLit:\n          a &= fmt\"{x.repr}  \"\n        else:\n          a &= fmt\"\"\" \"{x.repr} = \", {x.repr}.infRepr \"\"\"\n        if i < n.len - 1:\n          a.add(\"\"\", \", \",\"\"\")\n  #    a.add(\", \\\"\\\\n\\\"\")\n      a.add \"\\n\"\n  #    a.add \"resetAttributes()\"\n      parseStmt(a)\n    template debug*(n: varargs[untyped]): untyped =\n      const EVAL =\n        when declared DEBUG: DEBUG\n        else: false\n      when EVAL:\n        debugImpl(n)\n    discard\n  #[ import atcoder/extra/other/reference ]#\n  when not declared ATCODER_REFERENCE_HPP:\n    const ATCODER_REFERENCE_HPP* = 1\n    import std/macros\n    import std/strformat\n  \n    template byaddr*(lhs, typ, ex) =\n      when typ is typeof(nil):\n        let tmp = addr(ex)\n      else:\n        let tmp: ptr typ = addr(ex)\n      template lhs: untyped = tmp[]\n  \n    macro `=&`*(lhs, rhs:untyped) =\n      parseStmt(fmt\"\"\"byaddr({lhs.repr}, {rhs.repr}.type, {rhs.repr})\"\"\")\n    discard\n  #[ import atcoder/extra/other/floatutils ]#\n  when not declared ATCODER_FLOAT_UTILS_HPP:\n    const ATCODER_FLOAT_UTILS_HPP* = 1\n    import std/math as math_lib_floatutils\n    import std/strutils\n    #[ import atcoder/element_concepts ]#\n    when not declared ATCODER_ELEMENT_CONCEPTS_HPP:\n      const ATCODER_ELEMENT_CONCEPTS_HPP* = 1\n      proc inv*[T:SomeFloat](a:T):auto = T(1) / a\n      proc init*(self:typedesc[SomeFloat], a:SomeNumber):auto = self(a)\n      type AdditiveGroupElem* = concept x, y, type T\n        x + y\n        x - y\n        -x\n        T(0)\n      type MultiplicativeGroupElem* = concept x, y, type T\n        x * y\n        x / y\n    #    x.inv()\n        T(1)\n      type RingElem* = concept x, y, type T\n        x + y\n        x - y\n        -x\n        x * y\n        T(0)\n        T(1)\n      type FieldElem* = concept x, y, type T\n        x + y\n        x - y\n        x * y\n        x / y\n        -x\n    #    x.inv()\n        T(0)\n        T(1)\n      type FiniteFieldElem* = concept x, type T\n        T is FieldElem\n        T.mod\n        T.mod() is int\n        x.pow(1000000)\n      type hasInf* = concept x, type T\n        T(Inf)\n      discard\n    #[ import atcoder/extra/other/static_var ]#\n    when not declared ATCODER_STATIC_VAR_HPP:\n      const ATCODER_STATIC_VAR_HPP* = 1\n      import std/macros\n      import std/strformat\n      macro staticVar*(T:typedesc, body: untyped) =\n        var s = \"\"\n        for n in body:\n          let name = n[0]\n          let t = n[1]\n          let t2 = fmt\"{t.repr[1..<t.repr.len]}\"\n          s &= fmt\"\"\"{'\\n'}proc get_global_addr_of_{name.repr}*[U:{T.repr}](self:typedesc[U] or U):ptr[{t2}] ={'\\n'}  when self is typedesc:{'\\n'}    var a {{.global.}}:{t2}.type{'\\n'}    a.addr{'\\n'}  else:{'\\n'}    get_global_addr_of_{name.repr}(self.type){'\\n'}\n    \"\"\"\n        parseStmt(s)\n      \n      macro `$.`*(t, name:untyped):untyped =\n        let s = fmt\"{t.repr}.get_global_addr_of_{name.repr}()[]\"\n        parseStmt(s)\n      discard\n    proc getParameters*(Real:typedesc):ptr[tuple[n:int, pi, eps, inf:Real]] =\n      var p {.global.}:tuple[n:int, pi, eps, inf:Real]\n      return p.addr\n  \n    converter floatConverter*(a:SomeInteger):float = a.float\n    converter float64Converter*(a:SomeInteger):float64 = a.float64\n    converter float32Converter*(a:SomeInteger):float32 = a.float32\n    converter floatConverter*(a:string):float = a.parseFloat\n    converter float64Converter*(a:string):float64 = a.parseFloat.float64\n    converter float32Converter*(a:string):float32 = a.parseFloat.float32\n  \n    staticVar FieldElem:\n      pi:U.type\n      eps:U.type\n      inf:U.type\n  \n    proc getPi*(Real:typedesc):Real = Real.getParameters()[].pi\n    proc getEPS*(Real:typedesc):Real = Real.getParameters()[].eps\n    proc getINF*(Real:typedesc):Real = Real.getParameters()[].inf\n    proc setEPS*(Real:typedesc, x:Real) = Real.getParameters()[].eps = x\n  \n    proc valid_range*[Real](l, r:Real):bool =\n      # assert(l <= r)\n      var (l, r) = (l, r)\n      if l > r: swap(l, r)\n      let d = r - l\n      let eps = Real$.eps\n      if d < eps: return true\n      if l <= Real(0) and Real(0) <= r: return false\n      return d < eps * min(abs(l), abs(r))\n  \n    template initPrec*(Real:typedesc) =\n      Real$.pi = PI.Real\n      Real$.inf = Inf.Real\n      when Real is float or Real is float64:\n        Real$.eps = 1e-9.Real\n      elif Real is float32:\n        Real$.eps = 1e-9.Real\n      # float comp\n      # TODO: relative error\n      proc `=~`*(a,b:Real):bool = abs(a - b) < Real$.eps\n      proc `!=~`*(a,b:Real):bool = abs(a - b) > Real$.eps\n      proc `<~`*(a,b:Real):bool = a + Real$.eps < b\n      proc `>~`*(a,b:Real):bool = a > b + Real$.eps\n      proc `<=~`*(a,b:Real):bool = a < b + Real$.eps\n      proc `>=~`*(a,b:Real):bool = a + Real$.eps > b\n  \n    # for OMC\n    proc estimateRational*[Real](x:Real, n:int) =\n      var m = Real$.inf\n      var q = 1\n      while q <= n:\n        let p = round(x * q.Real)\n        let d = abs(p / q.Real - x)\n        if d < m:\n          m = d\n          echo \"found: \", p, \"/\", q, \"   \", \"error: \", d\n        q.inc\n      return\n  \n    float.initPrec()\n  #  float64.initPrec()\n    float32.initPrec()\n    discard\n  #[ import atcoder/extra/other/zip ]#\n  when not declared ATCODER_ZIP_HPP:\n    const ATCODER_ZIP_HPP* = 1\n    import macros\n  \n    macro zip*(v:varargs[untyped]):untyped =\n      result = newStmtList()\n      var par = newPar()\n      for i,a in v:\n        var ts = newNimNode(nnkTypeSection)\n        par.add(ident(\"T\" & $i))\n        ts.add(newNimNode(nnkTypeDef).add(\n          ident(\"T\" & $i),\n          newEmptyNode(),\n          newDotExpr(newNimNode(nnkBracketExpr).add(a, newIntLitNode(0)), ident(\"type\"))\n        ))\n        result.add ts\n      var varSection = newNimNode(nnkVarSection)\n      varSection.add newIdentDefs(ident(\"a\"), newEmptyNode(), newCall(\n        newNimNode(nnkBracketExpr).add(\n          ident(\"newSeq\"), \n          par\n        ), \n        ident(\"n\")\n      ))\n      result.add newNimNode(nnkLetSection).add(newIdentDefs(ident(\"n\"), newEmptyNode(), \n        newDotExpr(v[0] , ident(\"len\"))\n      ))\n      result.add(varSection)\n    \n      var forStmt = newNimNode(nnkForStmt).add(ident(\"i\")).add(\n        newNimNode(nnkInfix).add(ident(\"..<\")).add(newIntLitNode(0), ident(\"n\"))\n      )\n      var fs = newStmtList()\n      for j,a in v:\n        fs.add newAssignment(\n          newNimNode(nnkBracketExpr).add(\n            newNimNode(nnkBracketExpr).add(\n              ident(\"a\"), \n              ident(\"i\")\n            ), \n            newIntLitNode(j)), \n          newNimNode(nnkBracketExpr).add(\n            a, \n            ident(\"i\")\n          )\n        )\n      forStmt.add fs\n      result.add(forStmt)\n      result.add(ident(\"a\"))\n      result = newBlockStmt(newEmptyNode(), result)\n    \n    macro unzip*(n:int, p:tuple):untyped = \n      result = newStmtList()\n      result.add(newNimNode(nnkLetSection).add(newIdentDefs(ident(\"n\"), newEmptyNode(), n)))\n      for i,a in p:\n        var a = newPar(a)\n        var t = newCall(\n          newNimNode(nnkBracketExpr).add(\n            ident(\"newSeq\"), \n            newDotExpr(a, ident(\"type\"))\n          ), \n          ident(\"n\")\n        )\n        var varSection = newNimNode(nnkVarSection).add(\n          newIdentDefs(ident(\"a\" & $i), newEmptyNode(), t), \n        )\n        result.add(varSection)\n      var forStmt = newNimNode(nnkForStmt).add(ident(\"i\"))\n      var rangeDef = newNimNode(nnkInfix).add(ident(\"..<\")).add(newIntLitNode(0), ident(\"n\"))\n      forStmt.add(rangeDef)\n      var fs = newStmtList()\n      for i,a in p:\n        fs.add newAssignment(\n          newNimNode(nnkBracketExpr).add(\n            ident(\"a\" & $i), \n            ident(\"i\")), \n          a\n        )\n      forStmt.add fs\n      result.add(forStmt)\n      var par = newPar()\n      for i, a in p:\n        par.add(ident(\"a\" & $i))\n      result.add(par)\n      result = newBlockStmt(newEmptyNode(), result)\n  \n    discard\n  #[ import atcoder/extra/other/solve_proc ]#\n  when not declared ATCODER_SOLVEPROC_HPP:\n    const ATCODER_SOLVEPROC_HPP* = 1\n    import std/macros\n    import std/strformat\n    import std/algorithm\n    import std/sequtils\n    import std/streams\n    import std/strutils\n    import math\n  \n    proc compare_answer_string*(s, t:string, error:float = NaN):bool =\n      if error.classify == fcNaN:\n        return s == t\n      else:\n        var\n          s = s.split(\"\\n\")\n          t = t.split(\"\\n\")\n        if s.len != t.len: return false\n        for i in 0 ..< s.len:\n          var s = s[i].split()\n          var t = t[i].split()\n          if s.len != t.len: return false\n          for j in 0 ..< s.len:\n            if s[j].len == 0:\n              if t[j].len != 0: return false\n            elif t[j].len == 0:\n              return false\n            else:\n              var fs = s[j].parseFloat\n              var ft = t[j].parseFloat\n              if abs(fs - ft) > error and abs(fs - ft) > min(abs(ft), abs(fs)) * error: return false\n        return true\n      doAssert false\n  \n    proc mainBodyHeader():NimNode =\n  #    let macro_def = \"(for s in {x.repr}: (result &= $s;(when output_stdout: stdout.write $s)));(result &= \\\"\\\\n\\\";when output_stdout: stdout.write \\\"\\\\n\\\")\"\n      result = newStmtList()\n      result.add quote(\"@@\") do:\n        mixin echo\n        result = \"\"\n        var resultPointer = result.addr\n        proc echo(x:varargs[string, `$`]) =\n          for s in x:\n            resultPointer[] &= $s\n            when output_stdout: stdout.write $s\n          resultPointer[] &= \"\\n\"\n          when output_stdout: stdout.write \"\\n\"\n  \n    macro solveProc*(head, body:untyped):untyped =\n      var prev_type:NimNode\n      var params:seq[NimNode]\n      for i in countdown(head.len - 1, 1):\n        var identDefs = newNimNode(nnkIdentDefs)\n        if head[i].kind == nnkExprColonExpr:\n          identDefs.add(head[i][0])\n          prev_type = head[i][1]\n        elif head[i].kind == nnkIdent:\n          identDefs.add(head[i])\n        identDefs.add(prev_type)\n        identDefs.add(newEmptyNode())\n        params.add(identDefs)\n      params.add(ident\"auto\")\n      params.reverse()\n      var callparams:seq[NimNode]\n      for i in 1..<params.len:\n        callparams.add(params[i][0])\n  #    var mainBody, naiveBody = mainBodyHeader()\n      var mainBody, checkBody, naiveBody, testBody, generateBody = newStmtList()\n      var hasNaive, hasCheck, hasTest, hasGenerate = false\n      for b in body:\n        if b.kind == nnkCall:\n          if b[0] == ident\"Check\":\n            hasCheck = true\n            var checkStmt = if b.len == 2: b[1] else: b[2]\n            var strmName = if b.len == 2: ident(\"strm\") else: b[1]\n            checkBody.add(newNimNode(nnkWhenStmt).add(\n              newNimNode(nnkElifBranch).add(ident\"DO_CHECK\").add(\n                newBlockStmt(newEmptyNode(), \n                  newStmtList().add(\n                    quote do:\n                      var `strmName` = newStringStream(resultOutput)\n                  ).add(checkStmt)\n            ))))\n          elif b[0] == ident\"Naive\":\n            hasNaive = true\n            naiveBody.add b[1]\n          elif b[0] == ident\"Test\":\n            hasTest = true\n            testBody.add b[1]\n          elif b[0] == ident\"Generate\":\n            hasGenerate = true\n            generateBody.add b[1]\n          else:\n            mainBody.add b\n        else:\n          mainBody.add b\n      mainBody = newStmtList().add(mainBodyHeader()).add(mainBody)\n      #if hasCheck:\n      #  mainBody.add(checkBody)\n      result = newStmtList()\n      let procName = head[0]\n      var discardablePragma = newNimNode(nnkPragma).add(ident(\"discardable\"))\n      var mainParams = params\n      mainParams[0] = ident\"string\"\n  #    var identDefsSub = newNimNode(nnkIdentDefs).add(ident\"output_stdout\").add(newNimNode(nnkBracketExpr).add(ident\"static\").add(ident\"bool\")).add(ident\"true\")\n      var identDefs = newNimNode(nnkIdentDefs).add(ident\"output_stdout\").add(newNimNode(nnkBracketExpr).add(ident\"static\").add(ident\"bool\")).add(ident\"true\")\n      proc copy(a:seq[NimNode]):seq[NimNode] = a.mapIt(it.copy)\n  #    var identDefs = newNimNode(nnkIdentDefs).add(ident\"output_stdout\").add(newNimNode(nnkBracketExpr).add(ident\"static\").add(ident\"bool\")).add(newEmptyNode())\n      mainParams.add(identDefs)\n      #var mainProcDef = newNimNode(nnkProcDef).add(ident\"solve\").add(newEmptyNode()).add(newEmptyNode()).add(newNimNode(nnkFormalParams).add(mainParams.copy())).add(discardablePragma).add(newEmptyNode()).add(newEmptyNode())\n      #result.add(mainProcDef)\n      if hasCheck:\n        result.add(quote do:\n          type CheckResult {.inject.} = ref object of Exception\n            output, err:string\n          template check(b:untyped) =\n            if not b:\n              raise CheckResult(err: b.astToStr, output: resultOutput)\n        )\n      if hasNaive:\n        var naiveProcDef = newNimNode(nnkProcDef).add(ident\"solve_naive\").add(newEmptyNode()).add(newEmptyNode()).add(newNimNode(nnkFormalParams).add(mainParams.copy())).add(discardablePragma).add(newEmptyNode()).add(newEmptyNode())\n        result.add(naiveProcDef)\n  \n      var naiveParams = mainParams.copy()\n      #result.add newProc(name = ident(procName), params = mainParams.copy(), body = mainBody, pragmas = discardablePragma)\n      \n      var mainProcImpl =\n        newStmtList().add(parseStmt(\"mixin echo\")).add quote do:\n        proc solve():string =\n          `mainBody`\n        var resultOutput {.inject.} = solve()\n      var mainTemplateBody = newStmtList().add quote do:\n        `mainProcImpl`\n      if hasCheck:\n        mainTemplateBody.add checkBody\n      mainTemplateBody.add quote do:\n        resultOutput\n      var mainTemplate = quote do:\n        proc `procName`():string {.discardable.} =\n          `mainTemplateBody`\n      mainTemplate[3].add mainParams[1..^1].copy()\n      result.add mainTemplate\n  \n      if hasNaive:\n        let naiveProcName = $procName & \"naive\"\n        naiveBody = mainBodyHeader().add(newBlockStmt(newEmptyNode(), naiveBody))\n        result.add newProc(name = ident(naiveProcName), params = naiveParams, body = naiveBody, pragmas = discardablePragma)\n        var test_body = newStmtList()\n        var var_names = newSeq[string]()\n        for procName in [$procName, $procName & \"_naive\"]:\n          let var_name = \"v\" & procName\n          var_names.add(var_name)\n          var l = newNimNode(nnkCall).add(ident(procName))\n          for c in callparams: l.add(c)\n          l.add(ident\"false\")\n          test_body.add(\n            newNimNode(nnkLetSection).add(\n              newNimNode(nnkIdentDefs).add(ident(var_name)).add(newEmptyNode()).add(l)\n            ))\n        var test_params = params\n        var vars = \"\"\n        for i in 1..<params.len:\n          let p = params[i][0]\n          vars &= &\"  {p.repr} = {{{p.repr}}}\\\\n\"\n        test_params[0] = ident\"bool\"\n  \n        var identDefs = newNimNode(nnkIdentDefs).add(ident\"error\").add(ident\"float\").add(ident(\"NaN\"))\n        test_params.add identDefs\n        test_body.add parseStmt(&\"if not compare_answer_string(vsolve, vsolve_naive, error): echo &\\\"test failed for\\\\n{vars}\\\", \\\"[solve]\\\\n\\\", vsolve, \\\"[solve_naive]\\\\n\\\", vsolve_naive;doAssert false\")\n        result.add newProc(name = ident\"test\", params = test_params, body = test_body, pragmas = discardablePragma)\n      elif hasCheck:\n        var test_body_sub = newStmtList()\n        var var_names = newSeq[string]()\n        for procName in [$procName]:\n          let var_name = \"v\" & procName\n          var_names.add(var_name)\n          var l = newNimNode(nnkCall).add(ident(procName))\n          for c in callparams: l.add(c)\n          l.add(ident\"false\")\n          test_body_sub.add(\n            newNimNode(nnkLetSection).add(\n              newNimNode(nnkIdentDefs).add(ident(var_name)).add(newEmptyNode()).add(l)\n            ))\n        var test_params = params\n        var vars = \"\"\n        for i in 1..<params.len:\n          let p = params[i][0]\n          vars &= &\"  {p.repr} = {{{p.repr}}}\\\\n\"\n        test_params[0] = ident\"bool\"\n        var test_body = newStmtList()\n        var d = &\"try:\\n  {test_body_sub.repr.strip}\\nexcept CheckResult as e:\\n  echo &\\\"check failed for\\\\n{vars}\\\", \\\"[failed statement]\\\\n\\\", e.err.strip, \\\"\\\\n[output]\\\\n\\\", e.output;doAssert false\"\n        test_body.add parseStmt(d)\n        result.add newProc(name = ident\"test\", params = test_params, body = test_body, pragmas = discardablePragma)\n  \n      if hasGenerate:\n        discard\n      if hasTest:\n        discard\n    discard\n\n  when declared USE_DEFAULT_TABLE:\n    when USE_DEFAULT_TABLE:\n      proc `[]`[A, B](self: var Table[A, B], key: A): var B =\n        discard self.hasKeyOrPut(key, B.default)\n        tables_lib.`[]`(self, key)\n\n  # converter toBool[T:ref object](x:T):bool = x != nil\n  # converter toBool[T](x:T):bool = x != T(0)\n  # misc\n  proc `<`[T](a, b:seq[T]):bool =\n    for i in 0 ..< min(a.len, b.len):\n      if a[i] < b[i]: return true\n      elif a[i] > b[i]: return false\n    if a.len < b.len: return true\n    else: return false\n\n  proc ceilDiv*[T:SomeInteger](a, b:T):T =\n    assert b != 0\n    if b < 0: return ceilDiv(-a, -b)\n    result = a.floorDiv(b)\n    if a mod b != 0: result.inc\n\n  template `/^`*[T:SomeInteger](a, b:T):T = ceilDiv(a, b)\n  discard\n"

import random
import times
import sequtils
import math
import algorithm
# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/other/bitutils.nim
ImportExpand "src/lib/other/bitutils.nim" <=== "when not declared ATCODER_BITUTILS_HPP:\n  const ATCODER_BITUTILS_HPP* = 1\n  import bitops\n\n  proc `<<`*[B:SomeInteger](b:B, n:SomeInteger):B = b shl n\n  proc `>>`*[B:SomeInteger](b:B, n:SomeInteger):B = b shr n\n\n  proc seqToBits*[B:SomeInteger](v:varargs[int]): B =\n    result = 0\n    for x in v: result = (result or (B(1) shl B(x)))\n\n  proc `[]`*[B:SomeInteger](b:B,n:int):int = (if b.testBit(n): 1 else: 0)\n  proc `[]`*[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))\n  \n  proc `[]=`*[B:SomeInteger](b:var B,n:int,t:int) =\n    if t == 0: b.clearBit(n)\n    elif t == 1: b.setBit(n)\n    else: doAssert(false)\n  proc `and`*[B:SomeInteger](b:B, v:openArray[int]):B = b and seqToBits[B](v)\n  proc `or`*[B:SomeInteger](b:B, v:openArray[int]):B = b or seqToBits[B](v)\n  proc `xor`*[B:SomeInteger](b:B, v:openArray[int]):B = b xor seqToBits[B](v)\n  proc `&`*[B:SomeInteger](a:B, b:openarray[int]):auto = a and b\n  proc `|`*[B:SomeInteger](a:B, b:openarray[int]):auto = a or b\n  proc `&`*(a:SomeInteger, b:SomeInteger):auto = a and b\n  proc `|`*(a:SomeInteger, b:SomeInteger):auto = a or b\n\n  proc `@`*[B:SomeInteger](b:B): seq[int] =\n    result = newSeq[int]()\n    for i in 0..<(8 * sizeof(B)):\n      if b[i] == 1: result.add(i)\n  proc `@^`*(v:openArray[int]): int =\n    result = 0\n    for i in v:\n      result[i] = 1\n\n  proc toBitStr*[B:SomeInteger](b:B, n = -1):string =\n    let n = if n == -1: sizeof(B) * 8 else: n\n    result = \"\"\n    for i in countdown(n-1,0):result.add if b[i] == 1: '1' else: '0'\n  proc allSetBits*[B:SomeInteger](n:int):B =\n    if n == 64:\n      return not uint64(0)\n    else:\n      return (B(1) shl B(n)) - B(1)\n  iterator subsets*(v:seq[int], B:typedesc[SomeInteger] = int):B =\n    var s = B(0)\n    yield s\n    while true:\n      var found = false\n      for i in v:\n        if not s.testBit(i):\n          found = true\n          s.setBit(i)\n          yield s\n          break\n        else:\n          s[i] = 0\n      if not found: break\n\n  iterator subsets*[B:SomeInteger](b:B):B =\n    for b in subsets[B](@b):\n      yield b\n  discard\n"

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/graph/hungarian.nim
ImportExpand "src/lib/graph/hungarian.nim" <=== "when not declared ATCODER_HUNGARIAN_HPP:\n  const ATCODER_HUNGARIAN_HPP* = 1\n  import std/sequtils\n  proc hungarian*[T](A:seq[seq[T]]):(T, seq[int]) =\n    let\n      N = A.len + 1\n      M = A[0].len + 1\n    var\n      P = newSeq[int](M)\n      way = newSeq[int](M)\n      U = newSeqWith(N, 0)\n      V = newSeqWith(M, 0)\n      minV:seq[int]\n      used:seq[bool]\n    for i in 1..<N:\n      P[0] = i\n      minV = newSeqWith(M, T.inf)\n      used = newSeqWith(M, false)\n      var j0 = 0\n      while P[j0] != 0:\n        var (i0, j1) = (P[j0], 0)\n        used[j0] = true\n        var delta = T.inf\n        for j in 1..<M:\n          if used[j]: continue\n          let curr = A[i0-1][j-1] - U[i0] - V[j]\n          if curr < minV[j]: minV[j] = curr; way[j] = j0\n          if minV[j] < delta: delta = minV[j]; j1 = j\n        for j in 0..<M:\n          if used[j]: U[P[j]] += delta; V[j] -= delta\n          else: minV[j] -= delta\n        j0 = j1\n      while true:\n        P[j0] = P[way[j0]];\n        j0 = way[j0];\n        if j0 == 0: break\n    var Q = newSeq[int](N - 1)\n    for j in 1..<M:\n      Q[P[j] - 1] = j - 1\n    return (-V[0], Q)\n  discard\n"

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/graph/graph_template.nim
ImportExpand "src/lib/graph/graph_template.nim" <=== "when not declared ATCODER_GRAPH_TEMPLATE_HPP:\n  const ATCODER_GRAPH_TEMPLATE_HPP* = 1\n  import std/sequtils\n  import std/tables\n\n  type\n    ADJTYPE_SEQ* = object\n    ADJTYPE_TABLE* = object\n    ADJTYPE_PROC* = object\n    ADJTYPE_ITER* = object\n    USEID_TRUE* = object\n    USEID_FALSE* = object\n#    Edge*[T] = ref object\n    Edge*[T, U] = object\n      src*,dst*:U\n      weight*:T\n      rev*:int\n    Edges*[T, U] = seq[Edge[T, U]]\n    Graph*[T, U, adjType, useId] = object\n      len*:int\n      when adjType is ADJTYPE_SEQ:\n        adj*: seq[seq[Edge[T, U]]]\n      elif adjType is ADJTYPE_TABLE:\n        adj*: Table[U, seq[Edge[T, U]]]\n      elif adjType is ADJTYPE_ITER:\n        adj_iter*: iterator(u:U):tuple[dst:U, weight:T]\n      elif adjType is ADJTYPE_PROC:\n        adj*: proc(u:U):seq[tuple[dst:U, weight:T]]\n      else:\n        discard\n      when useId is USEID_TRUE:\n        id*:proc(u:U):int\n    Matrix*[T] = seq[seq[T]]\n\n  proc initEdge*[T, U](src,dst:U,weight:T = 1,rev:int = -1):Edge[T, U] =\n    return Edge[T, U](src:src, dst:dst, weight:weight, rev:rev)\n  proc `<`*[T, U](a, b:Edge[T, U]):bool = a.weight < b.weight\n  \n  proc initGraph*(n:int, T:typedesc = int, U:typedesc[int] = int):Graph[T, U, ADJTYPE_SEQ, USEID_FALSE] =\n    return Graph[T, int, ADJTYPE_SEQ, USEID_FALSE](len:n, adj:newSeqWith(n, newSeq[Edge[T, U]]()))\n  proc initGraph*(T:typedesc = int, U:typedesc = int):Graph[T, U, ADJTYPE_TABLE, USEID_FALSE] =\n    return Graph[T, U, ADJTYPE_TABLE, USEID_FALSE](len: 0, adj:initTable[U, seq[Edge[T, U]]]())\n\n  proc initGraph*[U](n:int, id:proc(u:U):int, T:typedesc = int):Graph[T, U, ADJTYPE_SEQ, USEID_TRUE] =\n    return Graph[T, U, ADJTYPE_SEQ, USEID_TRUE](len:n, adj:newSeqWith(n,newSeq[Edge[T, U]]()), id:id)\n  proc initGraph*[T, U](n:int, id:proc(u:U):int, adj:proc(u:U):seq[(U, T)]):Graph[T, U, ADJTYPE_PROC, USEID_TRUE] =\n    return Graph[T, U, ADJTYPE_PROC, USEID_TRUE](len:n, adj:adj, id:id)\n  proc initGraph*[T, U](n:int, id:proc(u:U):int, adj_iter:iterator(u:U):(U, T)):Graph[T, U, ADJTYPE_ITER, USEID_TRUE] =\n    return Graph[T, U, ADJTYPE_ITER, USEID_TRUE](len:n, adj_iter:adj_iter, id:id)\n  proc initGraph*[T, U](adj:proc(u:U):seq[(U, T)]):auto =\n    return Graph[T, U, ADJTYPE_PROC, USEID_FALSE](len:0, adj:adj)\n  proc initGraph*[T, U](adj_iter:iterator(u:U):(U, T)):auto =\n    return Graph[T, U, ADJTYPE_ITER, USEID_FALSE](len:0, adj_iter:adj_iter)\n\n  template `[]`*[G:Graph](g:G, u:G.U):auto =\n    when G.adjType is ADJTYPE_SEQ:\n      when u is int: g.adj[u]\n      else: g.adj[g.id(u)]\n    elif G.adjType is ADJTYPE_TABLE:\n      if u notin g.adj:\n        g.adj[u] = newSeq[Edge[G.T, G.U]]()\n      g.adj[u]\n    else:\n      g.adj(u)\n\n  proc addBiEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId], e:Edge[T, U]):void =\n    when adjType is ADJTYPE_SEQ | ADJTYPE_TABLE:\n#    var e_rev = initEdge[T](e.src, e.dst, e.weight, e.rev)\n      var e_rev = e\n      swap(e_rev.src, e_rev.dst)\n      let (r, s) = (g[e.src].len, g[e.dst].len)\n      g[e.src].add(e)\n      g[e.dst].add(e_rev)\n      g[e.src][^1].rev = s\n      g[e.dst][^1].rev = r\n    else:\n      static_assert false\n\n  proc addBiEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId],src,dst:U,weight:T = 1):void =\n    g.addBiEdge(initEdge(src, dst, weight))\n\n  proc addEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId], e:Edge[T, U]) = g[e.src].add(e)\n  proc addEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId], src, dst:U, weight:T = 1):void =\n    g.addEdge(initEdge[T, U](src, dst, weight, -1))\n\n  proc initUndirectedGraph*[T, U](n:int, a,b:seq[U], c:seq[T]):Graph[T, U, ADJTYPE_SEQ, USEID_FALSE] =\n    result = initGraph[T](n, U)\n    for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])\n  proc initUndirectedGraph*[U](n:int, a,b:seq[U]):Graph[int, U, ADJTYPE_SEQ, USEID_FALSE] =\n    result = initGraph[int](n, U)\n    for i in 0..<a.len: result.addBiEdge(a[i], b[i])\n  proc initDirectedGraph*[T, U](n:int, a,b:seq[U],c:seq[T]):Graph[T, U, ADJTYPE_SEQ, USEID_FALSE] =\n    result = initGraph[T](n, U)\n    for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])\n  proc initDirectedGraph*[U](n:int, a,b:seq[U]):Graph[int, U, ADJTYPE_SEQ, USEID_FALSE] =\n    result = initGraph[int](n, U)\n    for i in 0..<a.len: result.addEdge(a[i], b[i])\n\n  template id*[G:Graph](g:G, u:int):int = \n    when G.U is int: u\n    else: g.id(u)\n\n  iterator adj*[T, U, useID](g:Graph[T, U, ADJTYPE_ITER, useID], u:U):tuple[dst:U, weight:T] =\n    var iter:type(g.adj_iter)\n    iter.deepCopy(g.adj_iter)\n    for e in iter(u):\n      yield e\n\n  iterator adj_by_id*[G:Graph](g:G, u:int):auto =\n    when G.adjType is ADJTYPE_SEQ:\n      for e in g.adj[u]: yield e\n    else:\n      for e in g.adj(u): yield e\n\n  type NodeArray*[U, VAL, useId] = object\n    default_val*:VAL\n    when useId is USEID_TRUE:\n      id*: proc(u:U):int\n    when useId is USEID_TRUE or U is int:\n      v*:seq[VAL]\n    else:\n      v*:Table[U, VAL]\n\n  proc initNodeArray*[VAL](g:Graph, default_val:VAL, len = 0):auto =\n    result = NodeArray[g.U, VAL, g.useId](default_val:default_val)\n    when g.useId is USEID_TRUE or g.U is int:\n      if len > 0:\n        result.v = newSeqWith(len, default_val)\n    when g.useId is USEID_TRUE:\n      result.id = g.id\n\n  proc `[]`*[U, useId, VAL](a:var NodeArray[U, VAL, useId], u:U):ptr[VAL] =\n    when useId is USEID_TRUE or U is int:\n      when U is int:\n        var i = u\n      else:\n        var i = a.id(u)\n      while i >= a.v.len:\n        a.v.add a.default_val\n      a.v[i].addr\n    else:\n      if u notin a.v:\n        (a.v)[u] = a.default_val\n      a.v[u].addr\n\n  proc contains*[U, useId, VAL](a:var NodeArray[U, VAL, useId], u:U):bool =\n    when useId is USEID_TRUE or U is int:\n      when U is int:\n        var i = u\n      else:\n        var i = a.id(u)\n      return i < a.v.len\n    else:\n      return u in a.v\n  discard\n"

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/graph/dijkstra.nim
ImportExpand "src/lib/graph/dijkstra.nim" <=== "when not declared ATCODER_EXTRA_DIJKSTRA_HPP:\n  const ATCODER_EXTRA_DIJKSTRA_HPP* = 1\n  import std/heapqueue\n  import std/sequtils\n  import std/deques\n  import std/options\n  import std/sets\n  import std/tables\n  #[ import atcoder/extra/graph/graph_template ]#\n  when not declared ATCODER_GRAPH_TEMPLATE_HPP:\n    const ATCODER_GRAPH_TEMPLATE_HPP* = 1\n    import std/sequtils\n    import std/tables\n  \n    type\n      ADJTYPE_SEQ* = object\n      ADJTYPE_TABLE* = object\n      ADJTYPE_PROC* = object\n      ADJTYPE_ITER* = object\n      USEID_TRUE* = object\n      USEID_FALSE* = object\n  #    Edge*[T] = ref object\n      Edge*[T, U] = object\n        src*,dst*:U\n        weight*:T\n        rev*:int\n      Edges*[T, U] = seq[Edge[T, U]]\n      Graph*[T, U, adjType, useId] = object\n        len*:int\n        when adjType is ADJTYPE_SEQ:\n          adj*: seq[seq[Edge[T, U]]]\n        elif adjType is ADJTYPE_TABLE:\n          adj*: Table[U, seq[Edge[T, U]]]\n        elif adjType is ADJTYPE_ITER:\n          adj_iter*: iterator(u:U):tuple[dst:U, weight:T]\n        elif adjType is ADJTYPE_PROC:\n          adj*: proc(u:U):seq[tuple[dst:U, weight:T]]\n        else:\n          discard\n        when useId is USEID_TRUE:\n          id*:proc(u:U):int\n      Matrix*[T] = seq[seq[T]]\n  \n    proc initEdge*[T, U](src,dst:U,weight:T = 1,rev:int = -1):Edge[T, U] =\n      return Edge[T, U](src:src, dst:dst, weight:weight, rev:rev)\n    proc `<`*[T, U](a, b:Edge[T, U]):bool = a.weight < b.weight\n    \n    proc initGraph*(n:int, T:typedesc = int, U:typedesc[int] = int):Graph[T, U, ADJTYPE_SEQ, USEID_FALSE] =\n      return Graph[T, int, ADJTYPE_SEQ, USEID_FALSE](len:n, adj:newSeqWith(n, newSeq[Edge[T, U]]()))\n    proc initGraph*(T:typedesc = int, U:typedesc = int):Graph[T, U, ADJTYPE_TABLE, USEID_FALSE] =\n      return Graph[T, U, ADJTYPE_TABLE, USEID_FALSE](len: 0, adj:initTable[U, seq[Edge[T, U]]]())\n  \n    proc initGraph*[U](n:int, id:proc(u:U):int, T:typedesc = int):Graph[T, U, ADJTYPE_SEQ, USEID_TRUE] =\n      return Graph[T, U, ADJTYPE_SEQ, USEID_TRUE](len:n, adj:newSeqWith(n,newSeq[Edge[T, U]]()), id:id)\n    proc initGraph*[T, U](n:int, id:proc(u:U):int, adj:proc(u:U):seq[(U, T)]):Graph[T, U, ADJTYPE_PROC, USEID_TRUE] =\n      return Graph[T, U, ADJTYPE_PROC, USEID_TRUE](len:n, adj:adj, id:id)\n    proc initGraph*[T, U](n:int, id:proc(u:U):int, adj_iter:iterator(u:U):(U, T)):Graph[T, U, ADJTYPE_ITER, USEID_TRUE] =\n      return Graph[T, U, ADJTYPE_ITER, USEID_TRUE](len:n, adj_iter:adj_iter, id:id)\n    proc initGraph*[T, U](adj:proc(u:U):seq[(U, T)]):auto =\n      return Graph[T, U, ADJTYPE_PROC, USEID_FALSE](len:0, adj:adj)\n    proc initGraph*[T, U](adj_iter:iterator(u:U):(U, T)):auto =\n      return Graph[T, U, ADJTYPE_ITER, USEID_FALSE](len:0, adj_iter:adj_iter)\n  \n    template `[]`*[G:Graph](g:G, u:G.U):auto =\n      when G.adjType is ADJTYPE_SEQ:\n        when u is int: g.adj[u]\n        else: g.adj[g.id(u)]\n      elif G.adjType is ADJTYPE_TABLE:\n        if u notin g.adj:\n          g.adj[u] = newSeq[Edge[G.T, G.U]]()\n        g.adj[u]\n      else:\n        g.adj(u)\n  \n    proc addBiEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId], e:Edge[T, U]):void =\n      when adjType is ADJTYPE_SEQ | ADJTYPE_TABLE:\n  #    var e_rev = initEdge[T](e.src, e.dst, e.weight, e.rev)\n        var e_rev = e\n        swap(e_rev.src, e_rev.dst)\n        let (r, s) = (g[e.src].len, g[e.dst].len)\n        g[e.src].add(e)\n        g[e.dst].add(e_rev)\n        g[e.src][^1].rev = s\n        g[e.dst][^1].rev = r\n      else:\n        static_assert false\n  \n    proc addBiEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId],src,dst:U,weight:T = 1):void =\n      g.addBiEdge(initEdge(src, dst, weight))\n  \n    proc addEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId], e:Edge[T, U]) = g[e.src].add(e)\n    proc addEdge*[T, U, adjType, useId](g:var Graph[T, U, adjType, useId], src, dst:U, weight:T = 1):void =\n      g.addEdge(initEdge[T, U](src, dst, weight, -1))\n  \n    proc initUndirectedGraph*[T, U](n:int, a,b:seq[U], c:seq[T]):Graph[T, U, ADJTYPE_SEQ, USEID_FALSE] =\n      result = initGraph[T](n, U)\n      for i in 0..<a.len: result.addBiEdge(a[i], b[i], c[i])\n    proc initUndirectedGraph*[U](n:int, a,b:seq[U]):Graph[int, U, ADJTYPE_SEQ, USEID_FALSE] =\n      result = initGraph[int](n, U)\n      for i in 0..<a.len: result.addBiEdge(a[i], b[i])\n    proc initDirectedGraph*[T, U](n:int, a,b:seq[U],c:seq[T]):Graph[T, U, ADJTYPE_SEQ, USEID_FALSE] =\n      result = initGraph[T](n, U)\n      for i in 0..<a.len: result.addEdge(a[i], b[i], c[i])\n    proc initDirectedGraph*[U](n:int, a,b:seq[U]):Graph[int, U, ADJTYPE_SEQ, USEID_FALSE] =\n      result = initGraph[int](n, U)\n      for i in 0..<a.len: result.addEdge(a[i], b[i])\n  \n    template id*[G:Graph](g:G, u:int):int = \n      when G.U is int: u\n      else: g.id(u)\n  \n    iterator adj*[T, U, useID](g:Graph[T, U, ADJTYPE_ITER, useID], u:U):tuple[dst:U, weight:T] =\n      var iter:type(g.adj_iter)\n      iter.deepCopy(g.adj_iter)\n      for e in iter(u):\n        yield e\n  \n    iterator adj_by_id*[G:Graph](g:G, u:int):auto =\n      when G.adjType is ADJTYPE_SEQ:\n        for e in g.adj[u]: yield e\n      else:\n        for e in g.adj(u): yield e\n  \n    type NodeArray*[U, VAL, useId] = object\n      default_val*:VAL\n      when useId is USEID_TRUE:\n        id*: proc(u:U):int\n      when useId is USEID_TRUE or U is int:\n        v*:seq[VAL]\n      else:\n        v*:Table[U, VAL]\n  \n    proc initNodeArray*[VAL](g:Graph, default_val:VAL, len = 0):auto =\n      result = NodeArray[g.U, VAL, g.useId](default_val:default_val)\n      when g.useId is USEID_TRUE or g.U is int:\n        if len > 0:\n          result.v = newSeqWith(len, default_val)\n      when g.useId is USEID_TRUE:\n        result.id = g.id\n  \n    proc `[]`*[U, useId, VAL](a:var NodeArray[U, VAL, useId], u:U):ptr[VAL] =\n      when useId is USEID_TRUE or U is int:\n        when U is int:\n          var i = u\n        else:\n          var i = a.id(u)\n        while i >= a.v.len:\n          a.v.add a.default_val\n        a.v[i].addr\n      else:\n        if u notin a.v:\n          (a.v)[u] = a.default_val\n        a.v[u].addr\n  \n    proc contains*[U, useId, VAL](a:var NodeArray[U, VAL, useId], u:U):bool =\n      when useId is USEID_TRUE or U is int:\n        when U is int:\n          var i = u\n        else:\n          var i = a.id(u)\n        return i < a.v.len\n      else:\n        return u in a.v\n    discard\n  #[ import atcoder/extra/other/inf ]#\n\n\n  type DijkstraObj*[T, U] = object\n    src*, dst*: U\n    weight*: T\n  proc `<`*[T, U](a, b:DijkstraObj[T, U]):bool = a.weight < b.weight\n  proc initDijkstraObj[T, U](src, dst:U, weight:T):DijkstraObj[T, U] =\n    DijkstraObj[T, U](src:src, dst:dst, weight:weight)\n\n  #[ include atcoder/extra/graph/dijkstra_result ]#\n  when not declared ATCODER_DIJKSTRA_RESULT_HPP:\n    const ATCODER_DIJKSTRA_RESULT_HPP* = 1\n    import std/algorithm\n    #[ import atcoder/extra/graph/graph_template ]#\n    type DijkstraResult*[T, U, useId] = object\n      a*: NodeArray[U, tuple[dist:T, prev_set:bool, prev:U], useId]\n    proc contains*[T, U, useId](d:var DijkstraResult[T, U, useId], u:U):bool =\n      u in d.a\n    proc `[]`*[T, U, useId](d:var DijkstraResult[T, U, useId], u:U):T =\n      d.a[u][].dist\n    proc prev*[T, U, useId](d:var DijkstraResult[T, U, useId], u:U):U =\n      d.a[u][].prev\n    proc path*[T, U, useId](d:var DijkstraResult[T, U, useId], t:U): seq[U] = \n      var u = t\n      while true:\n        result.add(u)\n  #      if u == d.s: break\n        var p = d.prev(u)\n        if u == p: break\n        u = p\n      result.reverse()\n    discard\n\n  proc dijkstra01*[G:Graph](g:G, s:G.U or seq[G.U]): auto = \n    var default_val: tuple[dist:G.T, prev_set:bool, prev:G.U]\n    default_val.dist = G.T.inf\n    default_val.prev_set = false\n    var\n      a = initNodeArray(g, default_val, g.len)\n      Q = initDeque[DijkstraObj[G.T, G.U]]()\n    when s is G.U:\n      var p = a[s]\n      p[].dist = G.T(0)\n      p[].prev = s\n      Q.addFirst(DijkstraObj[G.T, G.U](src:s, dst:s, weight:G.T(0)))\n    else:\n      for s in s:\n        var p = a[s]\n        p[].dist = G.T(0)\n        p[].prev = s\n        Q.addFirst(DijkstraObj[G.T, G.U](src: s, dst:s, weight:G.T(0)))\n    while Q.len > 0:\n      var e = Q.popFirst()\n      var p = a[e.dst]\n      if p[].prev_set: continue\n      p[].prev_set = true\n      p[].prev = e.src\n      for f in g[e.dst]:\n        var w = e.weight + f.weight\n        var p = a[f.dst]\n        if p[].dist > w:\n          p[].dist = w;\n          if f.weight == 0:\n            Q.addFirst(initDijkstraObj(e.dst, f.dst, w))\n          else:\n            Q.addLast(initDijkstraObj(e.dst, f.dst, w))\n    result = DijkstraResult[G.T, G.U, G.useId](a:a)\n\n  proc dijkstra*[G:Graph](g:var G, s:G.U or seq[G.U]): auto = \n    var default_val: tuple[dist:G.T, prev_set:bool, prev:G.U]\n    default_val.dist = G.T.inf\n    default_val.prev_set = false\n    var\n      a = initNodeArray(g, default_val, g.len)\n      Q = initHeapQueue[DijkstraObj[G.T, G.U]]()\n    when s is G.U:\n      var p = a[s]\n      p[].dist = g.T(0)\n      Q.push(initDijkstraObj(s,s,g.T(0)))\n    else:\n      for s in s:\n        var p = a[s]\n        p[].dist = g.T(0)\n        Q.push(initDijkstraObj(s,s,g.T(0)))\n    while Q.len > 0:\n      var e = Q.pop()\n      var p = a[e.dst]\n      if p.prev_set: continue\n      p[].prev_set = true\n      p[].prev = e.src\n      for f in g[e.dst]:\n        var w = e.weight + f.weight\n        var p = a[f.dst]\n        if p[].dist > w:\n          p[].dist = w;\n          Q.push(initDijkstraObj(e.dst, f.dst, w))\n    result = DijkstraResult[G.T, G.U, G.useId](a:a)\n  discard\n"


let start_time = epochTime()

randomize()
let seed = random.rand(0..2^31)
stderr.write("seed: ", seed, "\n")

#randomize(383758548)

let dir:array[4, tuple[dx, dy:int]] = [(0, -1), (-1, 0), (0, 1), (1, 0)]
let dir_str = "LURD"

type Input = object
  N, T:int

type State = object
  a: seq[seq[int]]
  p: tuple[x, y:int]
  score: int

proc counter_direction(d:int):int = d xor 2

const D = 10^8
var cx, cy: int

proc getTree(state:State):seq[tuple[p:int, a:seq[tuple[x, y:int]]]] =
  let N = state.a.len
  var
    vis = Seq[N, N: false]
    group = Seq[(int, int)]
    loop = false
  proc dfs(x, y, p:int):int =
    doAssert state.a[x][y] != 0
    group.add((x, y))
    vis[x][y] = true
    result = 1
    for d, (dx, dy) in dir:
      if p == d or state.a[x][y][d] == 0: continue
      let (x2, y2) = (x + dx, y + dy)
      let d2 = d.counter_direction
      if x2 notin 0 ..< N or y2 notin 0 ..< N or state.a[x2][y2][d2] == 0 : continue
      if vis[x2][y2]:
        loop = true
        continue
      let d = dfs(x2, y2, d2)
      result += d
  var v = Seq[int]
  for x in 0 ..< N:
    for y in 0 ..< N:
      if vis[x][y] or state.a[x][y] == 0: continue
      group.setLen(0)
      let d = dfs(x, y, -1)
      result.add (d, group)
  result.sort(SortOrder.Descending)

proc calcScore(v:seq[(int, seq[(int, int)])]):int =
  var v = v.mapIt(it[1].len)
  result += v[0] * D
  for i in 1 ..< v.len:
    result += v[i] * (100 - v.len - i)

proc calcScore(state:State):int =
  # 最大: D倍
  # その他: 
  (state.getTree).calcScore

proc updateZero(state:var State) =
  found_cnt := 0
  for x in 0..<state.a.len:
    for y in 0..<state.a[0].len:
      if state.a[x][y] == 0:
        state.p = (x, y)
        found_cnt.inc
  doAssert found_cnt == 1

proc updateScore(state:var State) =
  state.score = state.calcScore

proc change[State, Input](state: var State, input: Input, d:int) =
  let
    N = input.N
    (x, y) = state.p
  var
    x2 = x + dir[d].dx
    y2 = y + dir[d].dy
  doAssert x2 in 0..<N and y2 in 0..<N
  doAssert state.a[x][y] == 0
  swap state.a[x][y], state.a[x2][y2]
  state.p = (x2, y2)

#proc neighbor0[State, Input](state:var State, input: Input):auto =
#  let
#    (x, y) = state.p
#    N = input.N
#  candidate := Seq[int]
#  for d, (dx, dy) in dir:
#    let (x2, y2) = (x + dx, y + dy)
#    if x2 notin 0 ..< N or y2 notin 0 ..< N: continue
#    candidate.add d
#  let
#    old_score = state.score
#    d = random.sample(candidate)
#    prev_state = state.prev
#  state.change(input, d)
#  state.score = state.calcScore
#  state.prev = Dir(d:d, prev:prev_state)
#  return (d.counter_direction, old_score)
#
#proc undo0[State, Input](state: var State, input: Input, d:auto) =
#  let (d, old_score) = d
#  state.change(input, d)
#  state.prev = state.prev.prev
#  state.score = old_score

proc neighbor0[State, Input](state:var State, input: Input):auto =
  let N = input.N
  #proc getRandomNoFirst(state:State):(int, int, int, int) =
  #  let t = state.getTree
  #  # (x0, y0)は主要でない木から選ぶ
  #  var x0, y0, x1, y1:int
  #  let M = N^2 - 1 - t[0].a.len
  #  var p = random.rand(0 ..< M)
  #  for i in 1 ..< t.len:
  #    if p < t[i].a.len:
  #      (x0, y0) = t[i].a[p]
  #      break
  #    p -= t[i].a.len
  #    doAssert i < t.len - 1
  #  while true:
  #    x1 = random.rand(0..<N)
  #    y1 = random.rand(0..<N)
  #    if (x0, y0) != (x1, y1) and (x0, y0) != state.p and (x1, y1) != state.p: break
  #  return (x0, y0, x1, y1)

  proc getRandom(state:State):(int, int, int, int) =
    var x0, y0, x1, y1:int
    while true:
      x0 = random.rand(0..<N)
      y0 = random.rand(0..<N)
      x1 = random.rand(0..<N)
      y1 = random.rand(0..<N)
      if (x0, y0) == (x1, y1): continue
      if x0 in cx ..< cx+3 and y0 in cy ..< cy+3 and x1 in cx ..< cx+3 and y1 in cy ..< cy+3:
        break
      if (x0, y0) != state.p and (x1, y1) != state.p: break
    return (x0, y0, x1, y1)

  proc getUnconnected(state: State):(int, int, int, int) =
    proc count_connected(x, y:int):int =
      result = 0
      for d in 4:
        let
          x2 = x + dir[d][0]
          y2 = y + dir[d][1]
        if x2 notin 0..<N or y2 notin 0..<N: continue
        let d2 = d.counter_direction
        if state.a[x2][y2][d2] == 1: result[d] = 1
    var
      c = Seq[N, N: int]
    let (x, y) = block:
      var
        max_val = -int.inf
        v:seq[(int, int)]
      for x in N:
        for y in N:
          if state.a[x][y] == 0: continue
          c[x][y] = count_connected(x, y)
          let k = ((c[x][y] xor state.a[x][y])).popCount
          if max_val < k:
            max_val = k
            v.setLen 0
          if max_val <= k:
            v.add (x, y)
      random.sample(v)
    let (x2, y2) = block:
      var
        min_val = int.inf
        v:seq[(int, int)]
      for x2 in N:
        for y2 in N:
          if state.a[x2][y2] == 0: continue
          let k = ((c[x][y] xor state.a[x2][y2]).popCount + (c[x2][y2] xor state.a[x][y]).popCount)
          if min_val > k:
            min_val = k
            v.setLen 0
          if min_val >= k:
            v.add (x2, y2)
          discard
      v.sample()
    return (x, y, x2, y2)

  var x0, y0, x1, y1: int
  #if random.rand(1.0) < 0.5:
  #  (x0, y0, x1, y1) = state.getRandomNoFirst()
  #else:
  if random.rand(1.0) < 0.95:
    (x0, y0, x1, y1) = state.getRandom()
  else:
    (x0, y0, x1, y1) = state.getUnconnected()
  # var x2, y2, x3, y3:int
  # if (x0, y0) != state.p and (x1, y1) != state.p:
  #   while true:
  #     (x2, y2, x3, y3) = state.getRandom()
  #     if (x2, y2) != state.p and (x3, y3) != state.p:
  #       break
  # else:
  #   x2 = -1
  #   y2 = -1
  #   x3 = -1
  #   y3 = -1
  let old_score = state.score
  if x0 != -1:
    swap state.a[x0][y0], state.a[x1][y1]
  #if x2 != -1:
  #  swap state.a[x2][y2], state.a[x3][y3]
  state.updateZero()
  state.updateScore()
  #state.score = t.calcScore
  return (x0, y0, x1, y1, old_score)
  #return (x0, y0, x1, y1, x2, y2, x3, y3, old_score)

proc undo0[State, Input](state: var State, input: Input, d:auto) =
  #let (x0, y0, x1, y1, x2, y2, x3, y3, old_score) = d
  let (x0, y0, x1, y1, old_score) = d
  #if x2 != -1:
  #  swap state.a[x2][y2], state.a[x3][y3]
  if x0 != -1:
    swap state.a[x0][y0], state.a[x1][y1]
  state.updateZero()
  state.score = old_score

proc solveAnnealing[State, Input](initial_state:State or seq[State], input: Input, T0 = 2000.0, T1 = 600.0, TL = 2.5, end_score = int.inf):auto {.discardable.} =
  var
#    state = State.init(input)
    state = when initial_state isnot seq: @[initial_state] else: initial_state
    T = T0
    best = state[0].score
    best_out = state[0]
    cnt = 0
  for i in 1 ..< state.len:
    let s = state[i].score
    if s > best:
      best = s
      best_out = state[i]
  block Anneling:
    while true:
      cnt.inc
      if (cnt and ((1 shl 8) - 1)) == 0:
        let t = (epochTime() - start_time) / TL
        if t >= 1.0:
          break Anneling
        T = T0.pow(1.0 - t) * T1.pow(t)
      for state in state.mitems:
        let old_score = state.score
        #if rand(1.0) <= 0.5:
        when true:
          let d = state.neighbor0(input)
          if old_score > state.score and rand(1.0) > exp((state.score - old_score).float/T):
            state.undo0(input, d)
        #else:
        #  let d = state.neighbor1(input)
        #  if old_score > state.score and rand(1.0) > exp((state.score - old_score).float/T):
        #    state.undo1(input, d)
        if best < state.score:
          best = state.score
          best_out = state
          if best >= end_score:
            break Anneling
  stderr.write "cnt: ", cnt, "\n"
  stderr.write "time: ", epochTime() - start_time, "\n"
  stderr.write "found: ", input.N^2 - 1 - (best div D), "\n"
  best_out

proc get_direction(d:int):seq[string] =
  result = Seq[3: '.'.repeat(3)]
  if d != 0: result[1][1] = '#'
  else:
    for i in 3:
      for j in 3:
        result[i][j] = ' '
  # 左
  if d[0] == 1:
    result[1][0] = '#'
  # 上
  if d[1] == 1:
    result[0][1] = '#'
  # 右
  if d[2] == 1:
    result[1][2] = '#'
  # 下
  if d[3] == 1:
    result[2][1] = '#'


proc write(state:State) =
  let N = state.a.len
  var ans = Seq[N * 3: ' '.repeat(N * 3)]
  for i in N:
    for j in N:
      var v = get_direction(state.a[i][j])
      for i2 in 3:
        for j2 in 3:
          ans[i * 3 + i2][j * 3 + j2] = v[i2][j2]
  for a in ans:
    echo a

proc calc_inversion(a:seq[int]):int =
  result = 0
  for i in a.len:
    for j in i + 1..<a.len:
      if a[i] > a[j]: result.inc


proc find_9_puzzle(a, dst:seq[int]):seq[int] =
  # 現状はaで
  # [1, 2, 3
  #  4, 5, 6
  #  7, 8, 0]にしたい
  let D = 9 * 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1
  var
    dist = Seq[D: int.inf]
    vis = Seq[D: false]
    di = Seq[D: seq[int]]
    id = initTable[seq[int], int]()
    prev = Seq[D: tuple[i, d:int]]
  block:
    var
      a = (0..<9).toSeq
      i = 0
    while true:
      di[i] = a
      id[a] = i
      if not a.nextPermutation: break
      i.inc
  dist[id[a]] = 0
  var q = initDeque[tuple[src, dst:seq[int], d:int]]()
  q.addLast (newSeq[int](), a, -1)
  while q.len > 0:
    var
      (src, a, d) = q.popFirst
      zi = 0
    let u = id[a]
    if vis[u]: continue
    vis[u] = true
    if d == -1:
      prev[u] = (-1, d)
    else:
      prev[u] = (id[src], d)
    while zi < a.len:
      if a[zi] == 0: break
      zi.inc
    doAssert zi in 0 ..< a.len
    let da = dist[u]
    let
      i = zi div 3
      j = zi mod 3
    var a_prev = a
    for d in dir.len:
      let
        i2 = i + dir[d][0]
        j2 = j + dir[d][1]
      if i2 notin 0 ..< 3 or j2 notin 0 ..< 3: continue
      let zi2 = i2 * 3 + j2
      swap a[zi], a[zi2]
      let u2 = id[a]
      if dist[u2] > da + 1:
        dist[u2] = da + 1
        q.addLast((a_prev, a, d))
      swap a[zi], a[zi2]
  block:
    var i = id[dst]
    while true:
      var (i2, d) = prev[i]
      if d == -1: break
      result.add d
      swap i, i2
    result.reverse

proc find_3_by_3(src, dst:seq[int]):seq[int] =
  #var a = @[
  #  -1, 1, 2,
  #  3, 0, 3,
  #  3, 3, 3]
  #var a2 = @[
  #  -1, 2, 1,
  #   3, 0, 3,
  #   3, 3, 3]
  var
    q = initDeque[tuple[src, dst:seq[int], d:int]]()
    vis = initSet[seq[int]]()
    dist = initTable[seq[int], int]()
    prev = initTable[seq[int], tuple[src:seq[int], d:int]]()
  q.addLast (src:newSeq[int](), dst:src, d: -1)
  dist[src] = 0
  while q.len > 0:
    var
      (s, a, d) = q.popFirst
      zi = 0
    if a in vis: continue
    vis.incl a
    prev[a] = (s, d)
    while zi < a.len:
      if a[zi] == 0: break
      zi.inc
    doAssert zi in 0 ..< a.len
    let da = dist[a]
    let
      i = zi div 3
      j = zi mod 3
    doAssert i in 0..<3 and j in 0..<3
    var
      a_prev = a
    for d in dir.len:
      let
        i2 = i + dir[d][0]
        j2 = j + dir[d][1]
      if i2 notin 0..<3 or j2 notin 0..<3: continue
      if a[i2][j2] == -1: continue
      let zi2 = i2 * 3 + j2
      swap a[zi], a[zi2]
      if a notin dist:
        dist[a] = int.inf
      if dist[a] > da + 1:
        dist[a] = da + 1
        q.addLast (a_prev, a, d)
      swap a[zi], a[zi2]
  block:
    var a2 = dst
    while true:
      var (a, d) = prev[a2]
      if d == -1: break
      result.add d
      swap a, a2
    result.reverse

proc set_zero_pos(state: var State) =
  for x in state.a.len:
    for y in state.a[x].len:
      if state.a[x][y] == 0:
        state.p = (x, y)


proc shuffle(state: var State) =
  let N = state.a.len
  var a = newSeq[int]()
  for i in N:
    a &= state.a[i]
  a.shuffle()
  for i in N:
    state.a[i] = a[i * N ..< (i + 1) * N]
  state.set_zero_pos()

proc main() =
  let
    N, T = nextInt()
    a = Seq[N: nextString()]
  cx = N div 2 - 1
  if N mod 2 == 0:
    cy = cx - 1
  else:
    cy = cx
  let zp = (N div 2, N div 2)
  #let zp = (N - 1, N - 1)
  var
    state = State(a:Seq[N, N: 0])
    input = Input(N:N, T:T)
  for i in N:
    for j in N:
      state.a[i][j] = 
        if a[i][j] in '0'..'9': a[i][j].ord - '0'.ord
        else: a[i][j].ord - 'a'.ord + 10
  state.set_zero_pos()
  var
    state_ans: State
    state_v: seq[State]
  for i in 5:
    var state = state
    state.shuffle
    if state.p != zp:
      swap state.a[state.p[0]][state.p[1]], state.a[zp[0]][zp[1]]
      state.p = zp
    state.score = state.calcScore
    state_v.add state
  state_ans = solveAnnealing(state_v, input, TL = 2.1, end_score = (N^2 - 1) * D)
  #state_ans.write
  proc id(i, j:int):int =
    doAssert i in 0..<N and j in 0..<N
    i * N + j
  proc calc_cost(x, y, x2, y2:int):int =
    let
      dx = abs(x - x2)
      dy = abs(y - y2)
      m = min(dx, dy)
      M = max(dx, dy)
    #return (M - m) * 5 + m * 3 + m * 3 + M + m
    return M * 6 + m * 2
  proc id_rev(n:int):(int, int) =
    doAssert n in 0..<N^2
    (n div N, n mod N)
  var dst, dst_inv = Seq[N^2: int]
  proc set_dst(first = false) =
    var A = Seq[N^2, N^2: 10^11]
    var zero_dist:int
    for i in N:
      for j in N:
        let p = id(i, j)
        for i2 in N:
          for j2 in N:
            # (i, j)を(i2, j2)に持っていくコストを記述
            let p2 = id(i2, j2)
            if state.a[i][j] != state_ans.a[i2][j2]: continue
            if state.a[i][j] == 0:
              zero_dist = abs(i - i2) + abs(j - j2)
              A[p][p2] = 0
            else:
              A[p][p2] = calc_cost(i, j, i2, j2)
    var (m, dst_tmp) = A.hungarian
    dst = dst_tmp
    block check:
      var s = 0
      for i in A.len:
        s += A[i][dst[i]]
      doAssert m == s
    if first:
      proc change_dst(dst:var seq[int]) =
        var type_to_pos = Seq[16: seq[(int, int)]]
        for i in N:
          for j in N:
            if state.a[i][j] == 0: continue
            type_to_pos[state.a[i][j]].add (i, j)
        debug "CHANGE!!"
        var
          max_val = -int.inf
          max_index = -1
        for i in 1 ..< type_to_pos.len:
          if max_val < type_to_pos[i].len:
            max_val = type_to_pos[i].len
            max_index = i
        doAssert max_val >= 2
        let
          p = type_to_pos[max_index][^1]
          q = type_to_pos[max_index][^2]
          i = id(p[0], p[1])
          j = id(q[0], q[1])
        swap(dst[i], dst[j])
        discard
      if calc_inversion(dst) mod 2 != zero_dist mod 2:
        dst.change_dst()
        doAssert calc_inversion(dst) mod 2 == zero_dist mod 2
    # dstの順列を見る
    for i in dst.len:
      dst_inv[dst[i]] = i

  set_dst(true)

  var initial_cost = Seq[N * N: int]
  for i in N:
    for j in N:
      let p2 = dst[id(i, j)]
      let (i2, j2) = id_rev(p2)
      initial_cost[id(i2, j2)] = calc_cost(i, j, i2, j2)

  proc write_dst() =
    for i in 0..<N:
      echo dst[i * N ..< (i + 1) * N]
    echo ""

  var move_log = Seq[int]
  block:
    var (x, y) = state.p

    proc make_move(d:int) =
      # dstとdst_inv, x, yだけを変更
      # (i, j)に行き先がdst[id(i, j)]のものを配置する
      var
        p = id(x, y)
        x2 = x + dir[d][0]
        y2 = y + dir[d][1]
        p2 = id(x2, y2)
#      debug "move: ", x, y, x2, y2
      doAssert x2 in 0 ..< N and y2 in 0 ..< N
      swap state.a[x][y], state.a[x2][y2]
      move_log.add d
      # (x, y)と(x2, y2)が入れ替わる
      swap dst[p], dst[p2]
      dst_inv[dst[p]] = p
      dst_inv[dst[p2]] = p2
      x = x2
      y = y2
      discard
    var wall = Seq[N: '.'.repeat(N)]
    proc calc_dist(a, b:(int, int)):int = abs(a[0] - b[0]) + abs(a[1] - b[1])
    type P = tuple[z, t: (int, int)]
    proc get_route(src, dst: P):seq[int] =
      proc isValid(x:(int, int)):bool =
        x[0] in 0..<N and x[1] in 0..<N and wall[x[0]][x[1]] == '.'
      # (i, j)から(i2, j2)のルートを検索
      # ただし、wall[i][j]が#なところは通らない
      var
        dist = initTable[P, int]()
        vis = initSet[P]()
        prev = initTable[P, tuple[src:P, d:int]]() # (x, y)からdで戻る
      dist[src] = 0
      var q = initDeque[tuple[src, dst:P, d:int]]()
      q.addLast (((-1, -1), (-1, -1)), src, -1)
      while q.len > 0:
        var (src, dst, d) = q.popFirst
        if dst in vis: continue
        vis.incl dst
        prev[dst] = (src, d)
        let da = dist[dst]
        var dist_zt = calc_dist(dst.z, dst.t)
        doAssert dist_zt > 0
        if dist_zt >= 2: # 距離が2以上のときは距離を縮める動きしか認められない
          for d in dir.len:
            let z2 = (dst.z[0] + dir[d][0], dst.z[1] + dir[d][1])
            if not z2.isValid: continue
            if calc_dist(z2, dst.t) >= dist_zt: continue
            if (z2, dst.t) notin dist: dist[(z2, dst.t)] = int.inf
            if dist[(z2, dst.t)] > da + 1:
              dist[(z2, dst.t)] = da + 1
              q.addLast((dst, (z2, dst.t), d))
        else:
          for d in dir.len:
            let z2 = (dst.z[0] + dir[d][0], dst.z[1] + dir[d][1])
            if not z2.isValid: continue
            var t2 = dst.t
            if z2 == t2:
              t2 = dst.z
            if (z2, t2) notin dist: dist[(z2, t2)] = int.inf
            if dist[(z2, t2)] > da + 1:
              dist[(z2, t2)] = da + 1
              q.addLast((dst, (z2, t2), d))
      var p = dst
      doAssert p in prev
      result = newSeq[int]()
      while true:
        let (src, d) = prev[p]
        if d == -1: break
        result.add d
        p = src
      result.reverse
    var
      initial_sum = 0
      actual_sum = 0
    proc move_block(i, j, zi, zj: int, i2 = -1, j2 = -1) =
      # マス(i, j)に(i2, j2)に置くべきものを置く
      # (zi, zj)は空マスを動かしたい位置
      var
        i2 = i2
        j2 = j2
      # (i, j)に(i2, j2)のパネルを移動させる
      if i2 == -1:
        var p2 = dst_inv[id(i, j)]
        (i2, j2) = id_rev(p2)
        doAssert dst[id(i2, j2)] == id(i, j)
      #if (i, j) == (i2, j2): return
      # 空きますを(i2, j2)の隣に持ってくる
      initial_sum += initial_cost[id(i, j)]
      actual_sum += calc_cost(i, j, i2, j2)
      #debug i, j, i2, j2, calc_cost(i, j, i2, j2), initial_cost[id(i, j)]
      doAssert wall[i2][j2] == '.'
      var r = get_route(((x, y), (i2, j2)), ((zi, zj), (i, j)))
      for d in r:
        make_move(d)
#      doAssert dst[id(i, j)] == id(i, j)
      # 空きますとのペアで調べる
      discard
    
    proc move_block_row(p:(int, int), d, n:int):(int, int) =
      var
        (x, y) = p
        d2 = (d + 1) mod 4
      for i in n - 2:
        let (zx, zy) = (x + dir[d2].dx, y + dir[d2].dy)
        move_block(x, y, zx, zy)
        wall[x][y] = '#'
        x += dir[d][0]
        y += dir[d][1]
      # x0
      # x   x1
      # x2
      var
        (x1, y1) = (x + dir[d2].dx, y + dir[d2].dy)
        (zx, zy) = (x1, y1)
        (x2, y2) = (x + dir[d].dx, y + dir[d].dy)
        (x0, y0) = (x - dir[d].dx, y - dir[d].dy)
        p2 = dst_inv[id(x2, y2)]
        (i2, j2) = id_rev(p2) # (x2, y2)にもっていきたいものの今ある場所→これを(x, y)にもってく
      move_block(x, y, zx, zy, i2, j2)
      zx -= dir[d].dx; zy -= dir[d].dy
      wall[x][y] = '#'

      proc id_local(x, y:int):int = x * 3 + y
      let
        bx = min([x0, x0 + dir[d].dx * 2, x0 + dir[d2].dx * 2])
        by = min([y0, y0 + dir[d].dy * 2, y0 + dir[d2].dy * 2])
      # (x0, y0)からd方向とd2方向に3つずつ
      if dst[id(x2, y2)] != id(x, y):

        var src, dst:auto = 3.repeat(9)
        (i2, j2) = id_rev(dst_inv[id(x, y)])
        move_block(x1, y1, zx, zy, i2, j2)
        src[id_local(x0 - bx, y0 - by)] = -1
        dst[id_local(x0 - bx, y0 - by)] = -1
        src[id_local(x  - bx, y  - by)] = 2
        src[id_local(x1 - bx, y1 - by)] = 1
        src[id_local(zx - bx, zy - by)] = 0
        dst[id_local(x  - bx, y  - by)] = 1
        dst[id_local(x2 - bx, y2 - by)] = 2
        dst[id_local(x1 - bx, y1 - by)] = 0
        let r = find_3_by_3(src, dst)
        for d in r: make_move(d)
      else:
        var src, dst = 3.repeat(9)
        src[id_local(x0 - bx, y0 - by)] = -1
        dst[id_local(x0 - bx, y0 - by)] = -1
        src[id_local(x  - bx, y  - by)] = 2
        src[id_local(x1 - bx, y1 - by)] = 0
        src[id_local(x2 - bx, y2 - by)] = 1
        dst[id_local(x  - bx, y  - by)] = 1
        dst[id_local(x1 - bx, y1 - by)] = 0
        dst[id_local(x2 - bx, y2 - by)] = 2
        let r = find_3_by_3(src, dst)
        for d in r: make_move(d)
      x += dir[d][0]
      y += dir[d][1]
      return (x, y)
    var bx, by: int
    block:
      var
        x0 = 0
        y0 = 0
        n = N
      for i in (N - 3) div 2:
        (x0, y0) = move_block_row((x0, y0), 2, n)
        x0 += dir[3][0];y0 += dir[3][1]
        (x0, y0) = move_block_row((x0, y0), 3, n - 1)
        x0 += dir[0][0];y0 += dir[0][1]
        (x0, y0) = move_block_row((x0, y0), 0, n - 1)
        x0 += dir[1][0];y0 += dir[1][1]
        (x0, y0) = move_block_row((x0, y0), 1, n - 2)
        x0 += dir[2][0];y0 += dir[2][1]
        n -= 2
      bx = x0
      by = y0
      if N mod 2 == 0:
        bx.inc
        (x0, y0) = move_block_row((x0, y0), 2, n)
        x0 += dir[3][0];y0 += dir[3][1]
        (x0, y0) = move_block_row((x0, y0), 3, n - 1)
        x0 += dir[0][0];y0 += dir[0][1]
      doAssert bx == cx and by == cy
    block:
      # (bx, by)を左上とする3 x 3を並べ替え
      var c = 1
      var src_b, dst_b = Seq[9: 0]
      for i in 3:
        for j in 3:
          let
            x = bx + i
            y = by + j
            (x2, y2) = id_rev(dst[id(x, y)])
            i2 = x2 - bx
            j2 = y2 - by
          # (x, y)を(x2, y2)に持っていきたい
          if state_ans.a[x2][y2] != 0:
            src_b[i * 3 + j] = c
            dst_b[i2 * 3 + j2] = c
            c.inc
      var r = find_9_puzzle(src_b, dst_b)
      for d in r:
        make_move(d)
    var ans = ""
    for d in move_log:
      ans.add dir_str[d]
    if ans.len > T: ans = ans[0 ..< T]
    echo ans
    debug initial_sum, actual_sum, ans.len



    #for i in 0 .. N - 4:
    #  # (i, i) 〜 (i, N - 3)
    #  for j in i .. N - 3:
    #    # (i, j)にあるべきものを置く
    #    # (i + 1, j)を空きますにする
    #    move_block(i, j, i + 1, j)
    #    wall[i][j] = '#'
    #  # (i, N - 2), (i, N - 1)について
    #  # (i, N - 2)に(i, N - 1)にあるべきものを置く
    #  block:
    #    let p2 = dst_inv[id(i, N - 1)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(i, N - 2, i + 1, N - 2, i2, j2)
    #    wall[i][N - 2] = '#'
    #  # (i + 1, N - 2)に(i, N - 2)にあるべきものを置く
    #  if dst[id(i, N - 1)] != id(i, N - 2):
    #    let p2 = dst_inv[id(i, N - 2)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(i + 1, N - 2, i + 1, N - 3, i2, j2)
    #    make_move(3)
    #    make_move(2)
    #    make_move(2)
    #    make_move(1)
    #    make_move(1)
    #    make_move(0)
    #    make_move(3)
    #  else:
    #    var
    #      src = @[
    #        -1, 2, 1,
    #         3, 0, 3, 
    #         3, 3, 3]
    #      dst = @[
    #        -1, 1, 2,
    #         3, 0, 3,
    #         3, 3, 3]
    #    let r = find_3_by_3(src, dst)
    #    for d in r: make_move(d)
    #  wall[i][N - 1] = '#'
    #  # let dir_str = "LURD"

    #  # (i + 1, i) 〜 (N - 3, i)
    #  for j in i + 1 .. N - 3:
    #    move_block(j, i, j, i + 1)
    #    wall[j][i] = '#'
    #  # (N - 2, i)と(N - 1, i)について
    #  block:
    #    let p2 = dst_inv[id(N - 1, i)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(N - 2, i, N - 2, i + 1, i2, j2)
    #    wall[N - 2][i] = '#'
    #  if dst[id(N - 1, i)] != id(N - 2, i):
    #    let p2 = dst_inv[id(N - 2, i)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(N - 2, i + 1, N - 3, i + 1, i2, j2)
    #    make_move(2)
    #    make_move(3)
    #    make_move(3)
    #    make_move(0)
    #    make_move(0)
    #    make_move(1)
    #    make_move(2)
    #  else:
    #    var
    #      src = @[
    #        -1, 3, 3,
    #         2, 0, 3, 
    #         1, 3, 3]
    #      dst = @[
    #        -1, 3, 3,
    #         1, 0, 3,
    #         2, 3, 3]
    #    let r = find_3_by_3(src, dst)
    #    for d in r:
    #      make_move(d)
    #  wall[N - 1][i] = '#'
    #  #set_dst(true)

  # 最後に3 x 3を動かす
  # 最終配置は
  # (N - 3, N - 3), (N - 3, N - 2), (N - 3, N - 1)
  # (N - 2, N - 3), (N - 2, N - 2), (N - 2, N - 1)
  # (N - 1, N - 3), (N - 1, N - 2), (N - 1, N - 1)
  #  block:
  #    proc convert_val(x:int):int =
  #      var (i, j) = id_rev(x)
  #      doAssert i in N - 3 .. N - 1
  #      doAssert j in N - 3 .. N - 1
  #      i -= N - 3
  #      j -= N - 3
  #      if i == 2 and j == 2: return 0
  #      else: return i * 3 + j + 1
  #    var a = Seq[9:int]
  #    for i in 0 ..< 3:
  #      for j in 0 ..< 3:
  #        a[i * 3 + j] = convert_val(dst[id(N - 3 + i, N - 3 + j)])
  #    var r = find_9_puzzle(a)
  #    for d in r:
  #      make_move(d)
  #  var ans = ""
  #  for d in move_log:
  #    ans.add dir_str[d]
  #  if ans.len > T: ans = ans[0 ..< T]
  #  echo ans
  #  debug initial_sum, actual_sum, ans.len

main()
