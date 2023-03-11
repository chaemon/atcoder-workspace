import Foundation


func solve(_ N:Int, _ D:Int, _ H:Int, _ d:[Int], _ h:[Int]) {
    var ans = 0

    print(ans)
}

func main() {
    var tokenIndex = 0, tokenBuffer = [String]()
    func readString() -> String {
        if tokenIndex >= tokenBuffer.count {
            tokenIndex = 0
            tokenBuffer = readLine()!.split(separator: " ").map { String($0) }
        }
        defer { tokenIndex += 1 }
        return tokenBuffer[tokenIndex]
    }
    func readInt() -> Int { Int(readString())! }
    func readDouble() -> Double { Double(readString())! }
    let N = readInt()
    let D = readInt()
    let H = readInt()
    var d = [Int](repeating: 0, count: N)
    var h = [Int](repeating: 0, count: N)
    for i in 0..<N {
        d[i] = readInt()
        h[i] = readInt()
    }
    _ = solve(N, D, H, d, h)
}

#if DEBUG
let caseNumber = 1
_ = freopen("in_\(caseNumber).txt", "r", stdin)
#endif

main()
