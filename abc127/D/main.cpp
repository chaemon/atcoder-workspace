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

int main(){
	int N, M;
	cin>>N>>M;
	vector<Int> A(N);
	REP(i,N)cin>>A[i];
	sort(ALL(A));
	vector<pair<Int,Int> > v;
	REP(i,M){
		Int B,C;
		cin>>B>>C;
		v.push_back({C,B});
	}
	sort(ALL(v));
	reverse(ALL(v));
	Int ans = 0;
	int i = 0;
	for(auto &&p:v){
		if(i == N)break;
		for(int t = 0;t < p.second and i < N;t++,i++){
			if(p.first >= A[i])ans += p.first;
			else break;
		}
	}
	if(i<N){
		for(int j = i;j < N;j++)ans += A[j];
	}
	cout<<ans<<endl;
}

