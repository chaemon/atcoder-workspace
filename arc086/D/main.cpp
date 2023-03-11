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
vector<Int> a;

void solve(){
	Int max_abs = -1;
	int max_index = -1;
	REP(i,N){
		if(max_abs < abs(a[i])){
			max_abs = abs(a[i]);
			max_index = i;
		}
	}
	cout<<N*2-1<<endl;
	if(a[max_index]>=0){
		for(int i = 0;i < N;i++){
			cout<<max_index+1<<" "<<i+1<<endl;
		}
		for(int i = 0;i < N - 1;i++){
			cout<<i + 1<<" "<<i + 2<<endl;
		}
	}else{
		for(int i = 0;i < N;i++){
			cout<<max_index+1<<" "<<i+1<<endl;
		}
		for(int i = N-1;i >= 1;i--){
			cout<<i + 1<<" "<<i<<endl;
		}
	}
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	a.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> a[i];
	}
	solve();
	return 0;
}
//}}}
