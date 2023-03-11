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

bool judge(int p){
	if(p>N){
		REP(i,a.size()){
			if(a[i]%p!=0)return false;
		}
		return true;
	}
	vector<Int> c(p-1);
	int j = 0;
	REP(i,N+1){
		c[j] += a[i];
		c[j] %= p;
		j++;
		if(j==p-1)j = 0;
	}
	bool all_zero = true;
	for(auto &&ci:c){
		if(ci%p!=0)all_zero = false;
	}
	if(all_zero)return true;
	for(int x = 1;x <= (p-1)/2;x++){
		Int x0 = 1;
		Int s0 = 0, s1 = 0;
		for(int i = 0;i <= N;i++){
			s0 += c[i] * x0;
			if(i%2==0){
				s1 += c[i] * x0;
			}else{
				s1 -= c[i] * x0;
			}
			x0 *= x;x0 %= p;
			s0 %= p;s1 %= p;
			if(s1<0)s1 += p;
		}
		if(s0%p!=0)return false;
		if(s1%p!=0)return false;
	}
	return true;
}

void solve(){
	reverse(ALL(a));
	Int a_ = -1;
	for(int i = 0;i < a.size();i++){
		if(a[i] != 0){
			a_ = abs(a[i]);
			break;
		}
	}
	vector<Int> pdiv;
	for(Int p = 2;p*p<=a_;p++){
		if(a_%p==0){
			pdiv.push_back(p);
			while(a_%p==0)a_/=p;
		}
	}
	if(a_>1)pdiv.push_back(a_);
	sort(ALL(pdiv));
	for(auto &&p:pdiv){
		if(judge(p)){
			cout<<p<<endl;
		}
	}
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	a.assign(N-0+1,Int());
	for(int i = 0 ; i < N-0+1 ; i++){
		cin >> a[i];
	}
	solve();
	return 0;
}
//}}}
