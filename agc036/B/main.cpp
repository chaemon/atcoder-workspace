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

#define whole(f,x,...) ([&](decltype((x)) whole) { return (f)(begin(whole), end(whole), ## __VA_ARGS__); })(x)

typedef long long Int;
typedef unsigned long long uInt;
typedef long double rn;

template<class T>
constexpr T inf = numeric_limits<T>::has_infinity ? numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);

int __inf_ignore(){
	int t = inf<int>;
	return t;
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

Int N;
Int K;
vector<Int> A;

const int B = 200000;

void solve(){
	vector<int> npos(B+1,N), next(N);
	vector<int> q;
	for(int i = N - 1;i >= 0;i--){
		if(npos[A[i]] != N)next[i] = npos[A[i]];
		else q.push_back(i);
		npos[A[i]] = i;
	}
	for(auto &&i:q){
		next[i] = npos[A[i]] + N;
	}
	int t = 0;
	Int u = 0;
	do{
		u += next[t] - t + 1;
		t = u % N;
	}while(t!=0);
	K %= (u/N);
	Int M = K * N;
	for(Int i = 0;i < M;){
		int j = i % N;
		Int ni = i + next[j] - j;
		if(ni<M){
			i = ni + 1;
			continue;
		}else{
			for(Int j = i;j < M;j++){
				int k = j % N;
				Int nj = j + next[k] - k;
				if(nj<M){
					j = nj;
				}else{
					cout<<A[k]<<" ";
				}
			}
			cout<<endl;
			break;
		}
	}
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> K;
    A.assign(N-1-0+1,Int());
    for(int i = 0 ; i < N-1-0+1 ; i++){
        cin >> A[i];
    }
	solve();
	return 0;
}
//}}}
