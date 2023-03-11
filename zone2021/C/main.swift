import Foundation


func solve(_ N:Int, _ A:[Int], _ B:[Int], _ C:[Int], _ D:[Int], _ E:[Int]) {
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
    var A = [Int](repeating: 0, count: N)
    var B = [Int](repeating: 0, count: N)
    var C = [Int](repeating: 0, count: N)
    var D = [Int](repeating: 0, count: N)
    var E = [Int](repeating: 0, count: N)
    for i in 0..<N {
        A[i] = readInt()
        B[i] = readInt()
        C[i] = readInt()
        D[i] = readInt()
        E[i] = readInt()
    }
    _ = solve(N, A, B, C, D, E)
}

#if DEBUG
let caseNumber = 1
_ = freopen("in_\(caseNumber).txt", "r", stdin)
#endif

main()
