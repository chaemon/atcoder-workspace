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

template<class T>
T floor_div(const T &a,const T &b){
	return a/b;
}

template<class T>
T ceil_div(const T &a,const T &b){
	return (a+b-T(1))/b;
}

Int N;
Int X;
vector<Int> b;
vector<Int> l;
vector<Int> u;

void solve(){
	vector<pair<Int,int> > v;
	REP(i,N){
		v.push_back({u[i]*X - u[i]*b[i] + l[i]*b[i], i});
	}
	sort(ALL(v));
	reverse(ALL(v));
	vector<Int> sums(N+1);
	sums[0] = 0;
	REP(i,N){
		sums[i+1] = sums[i] + v[i].first;
	}
	Int sum = 0, ans = X*N, study_time = 0;
	REP(i,N)sum += - l[i] * b[i];
	int vi = 0;

	auto calc = [&](int i, int skip_i){
		Int s = sums[i+1];
		if(skip_i<=i){
			s -= v[skip_i].first;
		}
		return s;
	};
	auto test = [&](int m){
		Int s = calc(m,vi) + sum;
		if(s>=0){
			ans = min(ans, X*m);
			return -1;
		}
		s += l[m] * b[m];
		if(s>=0){
			ans = min(ans, X*m + b[vi]);
			return -1;
		}
	};
	for(auto &&p:v){
		Int d = p.first;
		int i = p.second;
		
		int l = 0, r = N;
		while(r-l>1){
			int m = (l+r)/2;
			if(test(m)==-1){
				r = m;
			}else{
				l = m;
			}
		}
		
		do{
		// x - b[i] : negative, c[i] = l[i]
			Int study_time0;
			if(sum>=0){
				study_time0 = study_time;
			}else{
				Int x = ceil_div(-sum,l[i]);
				if(b[i]<x)break;
				study_time0 = study_time + x;
				assert(0<=x and x<=b[i]);
			}
			ans = min(ans,study_time0);
		}while(0);
		do{
		// x - b[i] : positive, c[i] = u[i]
			Int study_time0;
			Int sum0 = sum + l[i] * b[i];//study b[i] hour
			if(sum0>=0){
				study_time0 = study_time + b[i];
			}else{
				Int x = max(b[i], ceil_div(- sum + (u[i]-l[i])*b[i], u[i]));
				if(X<x)break;
				assert(b[i]<=x and x<=X);
				study_time0 = study_time + x;
			}
			ans = min(ans,study_time0);
		}while(0);
//		sum += d;
//		study_time += X;
		vi ++;
	}
	assert(ans!=inf<Int>());
	cout<<ans<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> X;
	b.assign(N,Int());
	l.assign(N,Int());
	u.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> b[i];
		cin >> l[i];
		cin >> u[i];
	}
	solve();
	return 0;
}

//}}}

