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

const int Inf = inf<int>;
#define index_of(as, x) \
distance(as.begin(), lower_bound(as.begin(), as.end(), x))
vector<int> lis_fast(const vector<int>& a) {
	const int n = a.size();
	vector<int> A(n, Inf);
	vector<int> id(n);
	for (int i = 0; i < n; ++i) {
		id[i] = index_of(A, a[i]);
		A[ id[i] ] = a[i];
	}
	int m = *max_element(id.begin(), id.end());
	vector<int> b(m+1);
	for (int i = n-1; i >= 0; --i)
		if (id[i] == m) b[m--] = a[i];
	return b;
}

Int N;
vector<Int> A;
vector<Int> B;

void solve(){
	vector<pii> p;
	REP(i,N)p.emplace_back(A[i],B[i]);
	sort(ALL(p));
	vector<int> v;
	for(int i = 0;i < N;){
		int j = i;
		while(j<N and p[j].first==p[i].first)j++;
		for(int k = j - 1;k >= i;k--)v.emplace_back(p[k].second);
		i = j;
	}
	cout<<lis_fast(v).size()<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	A.assign(N,Int());
	B.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> A[i];
		cin >> B[i];
		if(A[i] > B[i])swap(A[i],B[i]);
	}
	solve();
	return 0;
}
//}}}
