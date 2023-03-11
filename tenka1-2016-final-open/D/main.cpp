// #includes {{{
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
// }}}

Int N;
Int M;
Int C;
Int D;
vector<Int> A;
vector<Int> B;
vector<Int> X;
vector<Int> Y;

void solve(){
	vector<vector<vector<Int> > > dp(2);
	REP(i,2){
		dp[i].resize(2);
		REP(j,2){
			dp[i][j].assign(1<<N, inf<Int>());
		}
	}
	vector<uint> dep(N);
	REP(i,M){
		dep[Y[i]] |= (1u<<X[i]);
	}
	Int ans = inf<Int>();
	const uint B0 = (1u<<N);
	dp[0][0][0] = dp[0][1][0] = 0;
	REP(ct,N){
		REP(b,B0){
			REP(i,N){
				if(b&(1<<i))continue;
				if((b&dep[i])==dep[i]){
					Int &r0 = dp[0][0][b|(1<<i)];
					r0 = min(r0,dp[0][0][b] + A[i]);
					Int &r1 = dp[0][1][b|(1<<i)];
					r1 = min(r1,dp[0][1][b] + B[i]);
				}
			}
			REP(i,2){
				dp[1][i][b] = dp[0][1-i][b] + C*ct + D;
			}
		}
		ans = min(ans,min(dp[0][0][B0-1],dp[0][1][B0-1]));
		swap(dp[0],dp[1]);
	}
	cout<<ans<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> M;
    cin >> C;
    cin >> D;
    A.resize(N);
    B.resize(N);
    for(int i = 0 ; i < N ; i++){
        cin >> A[i];
        cin >> B[i];
    }
    X.resize(M);
    Y.resize(M);
    for(int i = 0 ; i < M ; i++){
        cin >> X[i];
        cin >> Y[i];
		X[i]--;Y[i]--;
    }
	solve();
	return 0;
}

//}}}

