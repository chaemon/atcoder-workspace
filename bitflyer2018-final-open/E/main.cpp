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

void assert2(const bool &b){
	if(not b){
		while(1){}
	}
}

using Mint =  Num<MOD>;

using P = vector<Mint>;

struct T{
	char op;// -1: a, '+', '-', '*'
	int id;
	Mint val;
	T *a, *b;
	P p;//p[0] + p[1] x
	T(Mint val, int id): val(val), op(-1), id(id){}
	T(T *a, char op, T *b): a(a), op(op), b(b){}
	void apply(){
		if(op==-1){
			assert2(false);
		}else if(op == '+')val = a->val + b->val;
		else if(op == '-')val = a->val - b->val;
		else if(op == '*')val = a->val * b->val;
		else assert2(false);
	}
};

string S;
int Q;
vector<Mint> a;
int a_ct = 0, a_ct2 = 0;

T* term(int&);
T* expr(int&);

T* value(int &i){
	T* ret;
	if(i==(int)S.size()){
		assert(false);
		return NULL;
	}
	if(S[i]=='a'){
		ret = new T(a[a_ct], a_ct);
		a_ct++;
		i++;
	}else{
		assert(S[i]=='(');
		i++;
		ret = expr(i);
		assert(S[i]==')');
		i++;
	}
	return ret;
}

T* term(int &i){
	vector<T*> v;
	v.push_back(value(i));
	while(1){
		if(i==(int)S.size())break;
		if(S[i]=='*'){
			i++;
			v.push_back(value(i));
		}else{
			break;
		}
	}
	if(v.size()==1)return v[0];
	else{
		T *t = new T(v[0], '*', v[1]);
		for(int i = 2;i < (int)v.size();i++){
			t = new T(t, '*' ,v[i]);
		}
		return t;
	}
}

T* expr(int &i){
	vector<pair<char,T*> > v;
	v.push_back({-1,term(i)});
	while(1){
		if(i==(int)S.size())break;
		if(S[i]=='+' or S[i]=='-'){
			char op = S[i];
			i++;
			v.push_back({op,term(i)});
		}else{
			break;
		}
	}
	if(v.size()==1)return v[0].second;
	else{
		T *t = new T(v[0].second, v[1].first, v[1].second);
		for(int i = 2;i < (int)v.size();i++){
			t = new T(t,v[i].first, v[i].second);
		}
		return t;
	}
}

vector<P> p;

P operator+(P p, P q){
//	assert2(p.size()==2 and q.size() == 2);
	return P({p[0] + q[0], p[1] + q[1]});
}
P operator-(P p, P q){
//	assert2(p.size()==2 and q.size() == 2);
	return P({p[0] - q[0], p[1] - q[1]});
}
P operator*(P p, P q){
//	assert2(p.size()==2 and q.size() == 2);
	return P({p[0] * q[0], p[1] * q[0] + q[1] * p[0]});
}

P apply_op(P p, char op, P q){
//	assert2(p.size()==2 and q.size() == 2);
	if(op=='+')return p + q;
	else if(op=='-')return p - q;
	else if(op=='*')return p * q;
	else assert(false);
}

P apply_f(P f, P p){
//	assert2(f.size()==2 and p.size() == 2);
	return {f[0] + f[1] * p[0], f[1] * p[1]};
}

void dfs(T *t){
	if(t->op==-1){
	}else{
		dfs(t->a);
		dfs(t->b);
		t->apply();
	}
}

const P X{0,1};

P const_poly(Mint v){
	return {v,0};
}

void dfs2(T *t, P poly){
	if(t->op==-1){
//		cerr<<"set: "<<t->op<<endl;
		a_ct2++;
		assert2(p.size() > t->id);
		p[t->id] = poly;
	}else{
		{
			P polyl = apply_f(poly, apply_op(X, t->op, const_poly(t->b->val)));
			dfs2(t->a,polyl);
		}
		{
			P polyr = apply_f(poly, apply_op(const_poly(t->a->val), t->op, X));
			dfs2(t->b,polyr);
		}
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	cin>>S>>Q;
	for(auto &&s:S){
		Mint x;
		if(s=='a')cin>>x,a.push_back(x);
	}
	int i = 0;
	T* t = expr(i);
	assert(i == S.size());
	assert(a_ct == a.size());
	
	p.resize(a_ct);
	
	dfs(t);
	dfs2(t, X);
	
	assert2(a_ct2 == a.size());
	REP(i,Q){
		int b, x;
		cin>>b>>x;
		b--;
		cout<<apply_f(p[b],{x,0})[0]<<endl;
	}
	return 0;
}
//}}}
