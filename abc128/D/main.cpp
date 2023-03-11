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
T inf(){
	return numeric_limits<T>::has_infinity?numeric_limits<T>::infinity():(numeric_limits<T>::max()/2);
}

typedef pair<int,int> pii;

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

Int N;
Int K;
vector<Int> V;

void solve(){
	int ans0 = -inf<int>();
	for(int i = 0;i <= N;i++){//: 0,1,2,...,i-1
		vector<int> v;
		REP(k,i)v.push_back(V[k]);
		for(int j = i;j <= N;j++){//: j,j+1,...,N-1
			vector<int> v2(v);
			RREP(k,j,N){
				v2.push_back(V[k]);
			}
			if(v2.size()>K)continue;
			sort(ALL(v2));
			int ans = accumulate(ALL(v2),0);
			int t = K - v2.size();
			REP(k,t){
				if(k<v2.size() and v2[k]<0){
					ans -= v2[k];
				}
			}
			ans0 = max(ans,ans0);
		}
	}
	cout<<ans0<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> K;
    V.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> V[i];
    }
	solve();
	return 0;
}

//}}}

