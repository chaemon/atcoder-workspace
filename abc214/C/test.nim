{.emit:"""
typedef __uint128_t NU128;
typedef __int128_t NI128;
""".}


type
  int128 {.importc: "NI128"} = object
    hi, lo: uint64
  
  helperInt128 = object
    hi, lo: uint64

proc toHelper(val: int128): helperInt128 =
  (cast[ptr helperInt128](unsafeAddr val))[]

proc toInt128(val: helperInt128): int128 =
  (cast[ptr int128](unsafeAddr val))[]

# Then you can use it like this
proc make128(hi: uint64, lo: uint64): int128 =
  let r = helperInt128(hi: hi, lo: lo)
  return r.toInt128()

func `+`*(x, y: int128): int128 = {.emit: "`result` = (NI128)((NU128)(`x`) + (NU128)(`y`));".}
func `-`*(x, y: int128): int128 = {.emit: "`result` = (NI128)((NU128)(`x`) - (NU128)(`y`));".}
func `*`*(x, y: int128): int128 = {.emit: "`result` = (NI128)((NU128)(`x`) * (NU128)(`y`));".}
func `/`*(x, y: int128): int128 = {.emit: "`result` = (NI128)((NU128)(`x`) / (NU128)(`y`));".}
# func `shl`(x, y: int128): int128 {.magic: "ShlI".}
#   # Generates c_3kT3fyGcLUlO9cGAfoG5F0w = ()((NU128)(a_H4uaduhuKIzzvSo9a5XGckw) << (NU128)(b_s7Jde6jEzqXVu63vxBEZxg));
#   # Notice how the parenthesis is empty

func `shl`(x, y: int128): int128 =
  {.emit: "`result` = (NI128)((NU128)(`x`) << (NU128)(`y`));".}
  # Works

var x = make128(uint64(0), uint64(4))

#x = x shl x
x = x + x
echo x.toHelper

#echo x
