import Foundation


func solve(_ R:Int, _ C:Int, _ A:[[Int]], _ B:[[Int]]) {
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
    let R = readInt()
    let C = readInt()
    var A = [[Int]](repeating: [Int](repeating: 0, count: C-1), count: R)
    for i in 0..<R {
        for j in 0..<C-1 {
            A[i][j] = readInt()
        }
    }
    var B = [[Int]](repeating: [Int](repeating: 0, count: C), count: R-1)
    for i in 0..<R-1 {
        for j in 0..<C {
            B[i][j] = readInt()
        }
    }
    _ = solve(R, C, A, B)
}

#if DEBUG
let caseNumber = 1
_ = freopen("in_\(caseNumber).txt", "r", stdin)
#endif

main()
