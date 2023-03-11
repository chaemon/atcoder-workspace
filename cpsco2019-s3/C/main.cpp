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
vector<Int> s;
vector<Int> t;

void solve(){
	vector<pair<Int,int> > v;
	REP(i,N)v.push_back({s[i],-1}),v.push_back({t[i],1});
	sort(ALL(v));
	int num = 0, ans = 0;
	for(int i = 0;i<v.size();){
		int prev_num = num;
		int j;
		for(j = i;j<v.size() and v[j].first==v[i].first;j++);
		for(int k = i;k < j;k++)num+=-v[k].second;
		if(prev_num==0 and num>0)ans++;
		i = j;
	}
	cout<<ans<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    s.assign(N,Int());
    t.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> s[i];
        cin >> t[i];
    }
	solve();
	return 0;
}
