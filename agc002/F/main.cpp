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

const string nl = "\n";

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

//{{{ gcd and inverse
#define __GCD_H
Int gcd(Int a, Int b) {
	return b != 0 ? gcd(b, a % b) : a;
}
Int lcm(Int a, Int b) {
	return a / gcd(a, b) *b;
}
// a x + b y = gcd(a, b)
Int extgcd(Int a, Int b, Int &x, Int &y) {
	Int g = a; x = 1; y = 0;
	if (b != 0) g = extgcd(b, a % b, y, x), y -= (a / b) * x;
	return g;
}
Int invMod(Int a, Int m) {
	Int x, y;
	if (extgcd(a, m, x, y) == 1) return (x + m) % m;
	else                         return 0; // unsolvable
}
//}}}

const int MOD = 1000000007;
//{{{ Modular algebra, Mint
struct Mint{
	int v;
	template<class T>
	Mint(T n){
		v = n%MOD;
		if(v<0)v+=MOD;
	}
	Mint():v(0){}
	explicit operator int() const {return v;}
	explicit operator long long() const {return v;}
	inline void operator *=(const Mint &a) {
		v = (v*(long long)a.v)%MOD;
	}
	inline Mint operator *(const Mint &a) {
		Mint n(*this);n*=a;
		return n;
	}
	inline void operator+=(const Mint &a){
		v+=a.v;
		if(v>=MOD)v-=MOD;
		//	assert(0<=v and v<MOD);
	}
	inline Mint operator+(const Mint &a){
		Mint n(*this);n+=a;
		return n;
	}
	inline Mint operator -(){
		if(v==0)return 0;
		else return Mint(MOD-v);
	}
	inline void operator -=(const Mint &a){
		v-=a.v;
		if(v<0)v+=MOD;
	}
	inline Mint operator -(const Mint &a){
		Mint n(*this);n-=a;
		return n;
	}
#ifdef __GCD_H
	inline Mint inv(){
		return Mint(invMod(this->v,MOD));
	}
	inline void operator /=(const Mint &a){
		(*this)*=invMod(a.v,MOD);
	}
	inline Mint operator /(const Mint &a){
		Mint n(*this);n/=a;
		return n;
	}
#endif
};

template<class T>
T& operator <<(T &os, const Mint &n){
	os<<(int)n.v;
	return os;
}

template<class T>
T& operator >>(T &is, Mint &n){
	long long v;is >> v;
	n = Mint(v);
	return is;
}
//}}}

//{{{ fact, binom, multinom
inline Mint fact(int n){
	static vector<Mint> __fact(1,1);
	while(n>=(int)__fact.size())__fact.push_back(__fact.back()*__fact.size());
	return __fact[n];
}
inline Mint inv_fact(int n){
	static vector<Mint> __inv_fact(1,1);
	while(n>=(int)__inv_fact.size())__inv_fact.push_back(Mint(1)/fact(__inv_fact.size()));
	return __inv_fact[n];
}


inline Mint binom_memo(int n,int r){
	static vector<vector<Mint> > __binom;
	static vector<vector<bool> > __vis;
	if(n<0 or r<0 or n<r)return 0;
	while(n>=(int)__vis.size())__binom.push_back(vector<Mint>(__binom.size()+1)), __vis.push_back(vector<bool>(__vis.size()+1,false));
//	while(n>=(int)__binom.size())__binom.push_back(vector<Mint >(__binom.size()+1,-1));
	if(__vis[n][r])return __binom[n][r];
	__vis[n][r] = true;
	if(r==0 or n==r)return __binom[n][r].v = 1;
	else return __binom[n][r] = binom_memo(n-1,r-1) + binom_memo(n-1,r);
}

#ifdef __GCD_H
inline Mint binom(int n,int r){
	if(n<0 or r<0 or n<r)return 0;
	return fact(n)*inv_fact(r)*inv_fact(n-r);
//	Mint fn = fact(n), fr = fact(r), fr2 = fact(n-r);
	//	return fact(n)/(fact(r)*fact(n-r));
//	return fn/(fr*fr2);
}

inline Mint multinom(const vector<int> &v){
	Mint num(fact(accumulate(ALL(v),0))), denom(1);
	REP(i,v.size())denom*=fact(v[i]);
	return num/denom;
}
#endif
//}}}

Mint dp[2020][2020];

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	int N,K;
	cin>>N>>K;
	if(K==1){
		cout<<1<<endl;
		return 0;
	}
	dp[0][0] = 1;
	int K1 = K - 1;
	for(int a = 0;a <= N;a++){
		int d = N*K - a - 1;
		for(int b = 0;b <= a;b++){
			dp[a+1][b] += dp[a][b];
			dp[a][b+1] += dp[a][b] * binom(d, K - 2) * (N - b);
			d -= K1;
		}
	}
	cout<<dp[N][N]<<endl;
}

