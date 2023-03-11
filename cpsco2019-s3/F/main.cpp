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

//{{{ optional<T>
template<typename T>
class optional {
public:
	optional() : is_engaged_(false), value_() {}

	explicit optional(T const& value) :
		is_engaged_(true), value_(value) {}

	optional& operator=(T const& value) {
		value_ = value;
		is_engaged_ = true;
		return *this;
	}

	operator bool() const { return is_engaged_; }

	T const& operator*() const { return value_; }
	T& operator*() { return value_; }
private:
	bool is_engaged_;
	T value_;
};
//}}}

Int N;
Int A;
Int B;
Int M;

vector<vector<vector<mod_int> > > dp;//index, # of right, # of over among a

//{{{ init vector
template<typename T>
void init(T &t){
	return;
}
template<typename T, typename ... Args>
void init(vector<T> &v, int n, Args ... args){
	v.resize(n);
	for(auto &&a:v){
		init(a, args...);
	}
}
//}}}

void solve(){
	const int N2 = A + B;
	init(dp,N2+1,N2+1,N2+1);
	dp[0][0][0] = 1;
	REP(i,N2){
		//distribute dp[i][*][*] according to i-th element
		for(int a = 0;a <= N2;a++){
			for(int t = 0;t <= a;t++){
				if(a<N2)dp[i+1][a+1][t] += dp[i][a][t] * t;
				if(t>0)dp[i+1][a][t-1] += dp[i][a][t] * t * t;
				if(a<N2 and t<N2)dp[i+1][a+1][t+1] += dp[i][a][t];
				dp[i+1][a][t] += dp[i][a][t] * t;
			}
		}
	}
	cout<<binom_memo(N,A+B) * dp[A+B][A][0]<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> A;
    cin >> B;
	solve();
	return 0;
}
