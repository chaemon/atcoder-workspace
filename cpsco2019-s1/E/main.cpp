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

Int N;
Int Q;
vector<uint> A;
vector<Int> L;
vector<Int> R;
vector<Int> X;

void solve(){
	multiset<uint> st;
	st.insert(ALL(A));
	REP(i,Q){
		auto bi = st.lower_bound(L[i]);
		auto ei = st.lower_bound(R[i] + 1);
		int ct = distance(bi,ei);
		uint ans = 0;
		for(auto it = bi;it != ei;){
			ans ^= *it;
			auto it2 = it;
			it++;
			st.erase(it2);
		}
		cout<<ans<<endl;
		if(ct%2==1){
			st.insert(X[i]);
		}
	}
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> Q;
    A.resize(N);
    for(int i = 0 ; i < N ; i++){
        cin >> A[i];
    }
    L.resize(Q);
    R.resize(Q);
    X.resize(Q);
    for(int i = 0 ; i < Q ; i++){
        cin >> L[i];
        cin >> R[i];
        cin >> X[i];
    }
	solve();
	return 0;
}

//}}}

