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

const int MOD = 1000000007;
//{{{ modular algebra
template<int mod=MOD>
struct Num{
	int v;
	template<class T>
	Num(T n){
		v = n%mod;
		if(v<0)v+=mod;
	}
	Num():v(0){}
	operator int() const {return v;}
	operator long long() const {return v;}
	inline void operator *=(const Num<mod> &a) {
		v = (v*(long long)a.v)%mod;
	}
	inline Num operator *(const Num<mod> &a) {
		Num n(*this);n*=a;
		return n;
	}
	inline void operator+=(const Num<mod> &a){
		v+=a.v;
		if(v>=mod)v-=mod;
		//	assert(0<=v and v<mod);
	}
	inline Num operator+(const Num<mod> &a){
		Num n(*this);n+=a;
		return n;
	}
	inline Num operator -(){
		if(v==0)return 0;
		else return Num(mod-v);
	}
	inline void operator -=(const Num<mod> &a){
		v-=a.v;
		if(v<0)v+=mod;
	}
	inline Num operator -(const Num<mod> &a){
		Num n(*this);n-=a;
		return n;
	}
#ifdef __GCD_H
	inline Num inv(){
		return Num(invMod(this->v,mod));
	}
	inline void operator /=(const Num<mod> &a){
		(*this)*=invMod(a.v,mod);
	}
	inline Num operator /(const Num<mod> &a){
		Num n(*this);n/=a;
		return n;
	}
#endif
};

template<class T, int mod>
T& operator <<(T &os, const Num<mod> &n){
	os<<(int)n.v;
	return os;
}

template<class T, int mod>
T& operator >>(T &is, Num<mod> &n){
	is>>n.v;
	return is;
}
//}}}
using Mint =  Num<MOD>;

int N;
int M;
vector<int> S;
vector<int> T;

Mint prev_sum[100010];
Mint dp[2020][2020];

void solve(){
	memset(prev_sum,0,sizeof(prev_sum));
	for(int i = 0;i <= N;i++)dp[i][0] = 1;
	for(int j = 0;j <= M;j++)dp[0][j] = 1;
	for(int i = 1;i <= N;i++){
		for(int j = 1;j <= M;j++){
			prev_sum[T[j-1]] += dp[i-1][j-1];
			dp[i][j] = prev_sum[S[i-1]] + dp[i-1][j];
		}
		REP(j,M)prev_sum[T[j]] = 0;
	}
	cout<<dp[N][M]<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> M;
    S.assign(N,Int());
    for(int i = 0 ; i < N ; i++){
        cin >> S[i];
    }
    T.assign(M,Int());
    for(int i = 0 ; i < M ; i++){
        cin >> T[i];
    }
	solve();
	return 0;
}

//}}}

