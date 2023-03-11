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
Int g_A;
Int s_A;
Int b_A;
Int g_B;
Int s_B;
Int b_B;

Int calc(const vector<pair<Int,Int> > &v, Int N){
	if(v.size()==0)return N;
	else if(v.size()==1){
		Int q = N/v[0].first, r = N%v[0].first;
		return q * v[0].second + r;
	}else if(v.size()==2){
		Int ans = 0;
		for(Int i = 0;;i++){
			Int N0 = N - v[0].first * i;
			if(N0<0)break;
			Int q = N0/v[1].first, r = N0%v[1].first;
			ans = max(ans, i * v[0].second + q * v[1].second + r);
		}
		return ans;
	}else{
		assert(v.size()==3);
		Int ans = 0;
		for(Int i = 0;;i++){
			Int N0 = N - v[0].first * i;
			if(N0<0)break;
			for(Int j = 0;;j++){
				Int N1 = N0 - v[1].first * j;
				if(N1<0)break;
				Int q = N1/v[2].first, r = N1%v[2].first;
				ans = max(ans, i * v[0].second + j * v[1].second + q * v[2].second + r);
			}
		}
		return ans;
	}
}

void solve(){
	vector<pair<Int,Int> > p,q;
	if(g_A<g_B)p.push_back({g_A,g_B});
	else if(g_A>g_B)q.push_back({g_B,g_A});
	if(s_A<s_B)p.push_back({s_A,s_B});
	else if(s_A>s_B)q.push_back({s_B,s_A});
	if(b_A<b_B)p.push_back({b_A,b_B});
	else if(b_A>b_B)q.push_back({b_B,b_A});
	N = calc(p,N);
	N = calc(q,N);
	cout<<N<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> g_A;
	cin >> s_A;
	cin >> b_A;
	cin >> g_B;
	cin >> s_B;
	cin >> b_B;
	solve();
	return 0;
}

//}}}

