#include <bits/stdc++.h>
using namespace std;


long long N;
long long M;
long long S;
std::std::vector<long long> U;
std::std::vector<long long> V;
std::std::vector<long long> A;
std::std::vector<long long> B;
std::std::vector<long long> C;
std::std::vector<long long> D;

void solve(){

}

// Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
int main(){
    std::cin >> N;
    std::cin >> M;
    std::cin >> S;
    U.assign(M, 0);
    V.assign(M, 0);
    A.assign(M, 0);
    B.assign(M, 0);
    for(int i = 0 ; i < M ; i++){
        std::cin >> U[i];
        std::cin >> V[i];
        std::cin >> A[i];
        std::cin >> B[i];
    }
    C.assign(N, 0);
    D.assign(N, 0);
    for(int i = 0 ; i < N ; i++){
        std::cin >> C[i];
        std::cin >> D[i];
    }
    solve();
    return 0;
}
