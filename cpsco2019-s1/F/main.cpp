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
#include"debug.hpp"
#include"print.hpp"
#endif
// }}}

Int N;
vector<Int> t;
vector<Int> A;
vector<Int> B;

bool calc(Int K){
	vector<pair<Int,Int> > days;
	REP(i,N){
		if(A[i]<K)continue;
		Int d = (A[i]-K)/B[i];
		days.push_back({t[i]-d, t[i]+d});
	}
	sort(ALL(days));
	priority_queue<Int,vector<Int>,greater<Int> > q;//from smaller
	int di = 0;
	for(int d = 1;d<=N;d++){
		for(;di<days.size() and days[di].first<=d;di++){
			if(d<=days[di].second){
				q.push(days[di].second);
			}
		}
		for(;!q.empty() and q.top() < d;){
			q.pop();
		}
		if(q.empty())return false;
		q.pop();
	}
	return true;
}

void solve(){
	Int l = -1e+10, r = 1e+10;
	while(r-l>1){
		Int m = (l+r)/2;
		if(calc(m))l = m;
		else r = m;
	}
	cout<<l<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	t.resize(N);
	A.resize(N);
	B.resize(N);
	for(int i = 0 ; i < N ; i++){
		cin >> t[i];
		cin >> A[i];
		cin >> B[i];
	}
	solve();
	return 0;
}

//}}}

