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

void solve(){
	Int D = (N-1)*(N-2)/2;
	if(K>D){
		cout<<-1<<endl;
	}else{
		assert(K<=D);
		vector<pii> vs;
		REP(u,N-1)for(int v = u + 1;v < N-1;v++){
			vs.push_back({u,v});
		}
		vector<pii> e;
		REP(u,N-1)e.push_back({u,N-1});
		REP(i,D - K)e.push_back(vs[i]);
		cout<<e.size()<<endl;
		for(auto &&p:e){
			cout<<p.first + 1<<" "<<p.second + 1<<endl;
		}
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> K;
	solve();
	return 0;
}

//}}}

