#ifdef MY_DEBUG
#include "header/header.hpp"
#else
#include <bits/stdc++.h>
#endif

using namespace std;

#define REP(i,n) for(int i=0;i<(int)(n);++i)
#define RREP(i,a,b) for(int i=(int)(a);i<(int)(b);++i)
#define FOR(i,c) for(__typeof((c).begin()) i=(c).begin();i!=(c).end();++i)
#define LET(x,a) __typeof(a) x(a)
//#define IFOR(i,it,c) for(__typeof((c).begin())it=(c).begin();it!=(c).end();++it,++i)
#define ALL(c) (c).begin(), (c).end()
#define MP make_pair

#define EXIST(e,s) ((s).find(e)!=(s).end())

#define RESET(a) memset((a),0,sizeof(a))
#define SET(a) memset((a),-1,sizeof(a))
#define PB push_back
#define DEC(it,command) __typeof(command) it=command

//debug
#define dump(x)  cerr << #x << " = " << (x) << endl;
#define debug(x) cerr << #x << " = " << (x) << " (L" << __LINE__ << ")" << " " << __FILE__ << endl;
#define debug_v(x) cerr << #x << " = [";REP(__ind,(x).size()){cerr << (x)[__ind] << ", ";}cerr << "] (L" << __LINE__ << ")" << endl;

#define whole(f,x,...) ([&](decltype((x)) whole) { return (f)(begin(whole), end(whole), ## __VA_ARGS__); })(x)

typedef long long Int;
typedef unsigned long long uInt;
typedef long double rn;

template<class T>
T inf(){
	return numeric_limits<T>::has_infinity?numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"debug.hpp"
#include"print.hpp"
#endif

const long long MOD = 2019;
const string YES = "YES";
const string NO = "NO";

void solve(long long N, long long M, long long Q, long long MOD, std::vector<long long> A, std::vector<long long> B, std::vector<long long> C, std::vector<long long> S, std::vector<long long> T, std::vector<long long> R){

}

int main(){
    long long N;
    scanf("%lld",&N);
    long long M;
    scanf("%lld",&M);
    long long Q;
    scanf("%lld",&Q);
    long long MOD;
    scanf("%lld",&MOD);
    std::vector<long long> A(M);
    std::vector<long long> B(M);
    std::vector<long long> C(M);
    for(int i = 0 ; i < M ; i++){
        scanf("%lld",&A[i]);
        scanf("%lld",&B[i]);
        scanf("%lld",&C[i]);
    }
    std::vector<long long> S(Q);
    std::vector<long long> T(Q);
    std::vector<long long> R(Q);
    for(int i = 0 ; i < Q ; i++){
        scanf("%lld",&S[i]);
        scanf("%lld",&T[i]);
        scanf("%lld",&R[i]);
    }
    solve(N, M, Q, MOD, std::move(A), std::move(B), std::move(C), std::move(S), std::move(T), std::move(R));
    return 0;
}
