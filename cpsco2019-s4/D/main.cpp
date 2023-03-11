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
Int K;
vector<Int> a;

bool valid(const vector<int> &v, int k){
	int ans = 0;
	REP(i,v.size()){
		ans += v[i]/(k+1);
	}
	return ans <= K;
}

void solve(){
	vector<int> v;
	for(int i = 0;i < N;){
		int j;
		for(j = i;j < N and a[i]==a[j];j++);
		v.push_back(j-i);
		i = j;
	}
	int l = 0, r = N;
	for(;r-l>1;){
		int m = (l+r)/2;
		if(valid(v,m))r = m;
		else l = m;
	}
	cout<<r<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> K;
    a.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> a[i];
    }
	solve();
	return 0;
}
