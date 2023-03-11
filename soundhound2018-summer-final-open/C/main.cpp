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

const int MOD = 1000000007;
//{{{ modular algebra
template<int mod=MOD>
struct Num{
	int v;
	Num(int n):v(n){}
	Num():v(0){}
	operator int() const {return v;}
	operator long long() const {return v;}
	template<class T>
	Num operator =(int n){v=n;return *this;}

	template<class T>
	inline void operator *=(const T &a) {
		v = (v*(long long)a)%mod;
	}
	template<class T>
	inline Num operator *(const T &a) {
		Num n(*this);n*=a;
		return n;
	}
	template<class T>
	inline void operator+=(const T &a){
		v+=(int)a;
		if(v>=mod)v-=mod;
		//	assert(0<=v and v<mod);
	}
	template<class T>
	inline Num operator+(const T &a){
		Num n(*this);n+=a;
		return n;
	}
	inline Num operator -(){
		if(v==0)return 0;
		else return Num(mod-v);
	}
	template<class T>
	inline void operator -=(const T &a){
		v-=(int)a;
		if(v<0)v+=mod;
	}
	template<class T>
	inline Num operator -(const T &a){
		Num n(*this);n-=a;
		return n;
	}
#ifdef __GCD_H
	inline Num inv(){
		return Num(invMod(this->v,mod));
	}
	template<class T>
	inline void operator /=(const T &a){
		(*this)*=invMod((int)a,mod);
	}
	template<class T>
	inline Num operator /(const T &a){
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
typedef Num<MOD> mod_int;

//{{{ mod_pow(Num<mod> x,Int k)
/* (x^k)%m */
template<int mod=MOD>
inline Num<mod> mod_pow(Num<mod> x, Int k){
	if(k==0) return 1;
	Num<mod> res(mod_pow(x,k/2));
	res*=res;
	if(k%2)res*=x;
	return res;
}
//}}}


//{{{ fact, binom, multinom
template<int mod=MOD>
inline Num<mod> fact(int n){
	static vector<Num<mod>> __fact(1,1);
	while(n>=(int)__fact.size())__fact.push_back(__fact.back()*__fact.size());
	return __fact[n];
}

template<int mod=MOD>
inline Num<mod> binom_memo(int n,int r){
	static vector<vector<Num<mod> > > __binom;
	if(n<0 or r<0 or n<r)return 0;
	while(n>=(int)__binom.size())__binom.push_back(vector<Num<mod> >(__binom.size()+1,-1));
	if((int)__binom[n][r]!=-1)return __binom[n][r];
	else if(r==0 or n==r)return __binom[n][r].v = 1;
	else return __binom[n][r] = binom_memo(n-1,r-1) + binom_memo(n-1,r);
}

#ifdef __GCD_H
template<int mod=MOD>
inline Num<mod> binom(int n,int r){
	if(n<0 or r<0 or n<r)return 0;
	Num<mod> fn = fact<mod>(n), fr = fact<mod>(r), fr2 = fact<mod>(n-r);
	//	return fact(n)/(fact(r)*fact(n-r));
	return fn/(fr*fr2);
}

template<int mod=MOD>
inline Num<mod> multinom(const vector<int> &v){
	Num<mod> num(fact<mod>(accumulate(ALL(v),0))), denom(1);
	REP(i,v.size())denom*=fact<mod>(v[i]);
	return num/denom;
}
#endif
//}}}

Int N;
Int D;

mod_int dp[32][32][32];//dist, remaining nodes, previous # of nodes

void solve(){
	memset(dp,0,sizeof(dp));
	dp[0][N-2][1] = 1;
	mod_int ans = 0;
	for(int d = 1;d <= N-1;d++){
		//d - 1 to d
		for(int n = 0;n <= N;n++){// from n nodes, take m nodes
			for(int k = 1;k <= N;k++){
				//previous: k nodes
				mod_int u = mod_pow((mod_int)2,k) - (mod_int)1;
//				if((int)dp[d-1][n][k]>=1)cerr<<d-1<<" "<<n<<" "<<k<<" "<<dp[d-1][n][k]<<" "<<u<<endl;
				for(int m = 0;m <=n;m++){
					if(d==D)
						dp[d][n-m][m+1] += dp[d-1][n][k] * binom_memo(n,m) * mod_pow((mod_int)2,binom_memo(m+1,2)) * mod_pow(u,m+1);
					else{
						if(m>0)dp[d][n-m][m] += dp[d-1][n][k] * binom_memo(n,m) * mod_pow((mod_int)2,binom_memo(m,2)) * mod_pow(u,m);
					}
				}
			}
		}
		if(d>=D)for(int k = 0;k <= N;k++)ans += dp[d][0][k];
	}
	cout<<ans<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> D;
	solve();
	return 0;
}

//}}}

