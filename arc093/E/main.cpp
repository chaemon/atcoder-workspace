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

int N;
int M;
Int X;
vector<int> U;
vector<int> V;
vector<Int> W;

void solve(){
	if(N <= 2){
		cout<<0<<endl;
		return;
	}else if(N==3){
		if(M==1){
			cout<<0<<endl;
			assert(false);
		}else if(M==2){
			if(W[0] + W[1] == X){
				cout<<2<<endl;
			}else{
				cout<<0<<endl;
			}
		}else{
			vector<Int> v = {W[0] + W[1], W[1] + W[2], W[2] + W[0]};
			sort(ALL(v));
			int ct = 0;
			REP(i,3)if(v[i]==X)ct++;
			if(ct==0){
				cout<<0<<endl;
			}else if(ct==3){
				cout<<6<<endl;
			}else if(v[0] < X){
				cout<<2<<endl;
			}else if(v[0] == X){
				assert(false);
				if(v[1]==X){
					
				}else{
					cout<<4<<endl;
				}
			}else{
				assert(false);
			}
		}
		return;
	}
	vector<vector<Int> > max_weight(N,vector<Int>(N,-1));
	vector<int> id(N);
	vector<vector<int> > di(N);
	REP(u,N)id[u] = u, di[u].push_back(u);
	vector<pair<Int,pair<int,int> > > e;
	REP(i,M)e.push_back({W[i],{U[i],V[i]}});
	Int mst_weight = 0;
	sort(ALL(e));
	for(int i = 0;i < M;){
		int j;
		for(j = i;j < M and e[i].first == e[j].first;j++);
		for(int k = i;k < j;k++){
			int u = e[k].second.first, v = e[k].second.second;
			Int w = e[k].first;
			if(id[u]==id[v]){
				continue;
			}else{
				int iu = id[u], iv = id[v];
				for(auto &&a:di[iu]){
					for(auto &&b:di[iv]){
						max_weight[a][b] = max_weight[b][a] = w;
					}
				}
				if(di[iu].size()<di[iv].size())swap(u,v),swap(iu,iv);
				for(auto &&a:di[iv])id[a] = iu, di[iu].push_back(a);
				mst_weight += w;
			}
		}
		i = j;
	}
	if(X<mst_weight){
		cout<<0<<endl;
		return;
	}
	int just = 0, over = 0;
	for(int i = 0;i < M;i++){
		int u = e[i].second.first, v = e[i].second.second;
		Int w = e[i].first;
		Int mw = max_weight[u][v];
		Int t = mst_weight - mw + w;
		if(t == X){
			just++;
		}else if(t>X){
			over++;
		}
	}
	if(X==mst_weight){
		cout<<(mod_pow((mod_int)2,just) - 2) * mod_pow((mod_int)2,over) <<endl;
	}else{
		cout<<(mod_pow((mod_int)2,just) - 1) * mod_pow((mod_int)2,over) * 2<<endl;
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> M;
	cin >> X;
	U.assign(M,Int());
	V.assign(M,Int());
	W.assign(M,Int());
	for(int i = 0 ; i < M ; i++){
		cin >> U[i];
		cin >> V[i];
		cin >> W[i];
		U[i]--;V[i]--;
	}
	solve();
	return 0;
}

//}}}

