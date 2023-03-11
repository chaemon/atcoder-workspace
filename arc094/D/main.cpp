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
#define dump(x)  cerr << #x << " = " << (x) << endl;
#define debug(x) cerr << #x << " = " << (x) << " (L" << __LINE__ << ")" << " " << __FILE__ << endl;
#define debug_v(x) cerr << #x << " = [";REP(__ind,(x).size()){cerr << (x)[__ind] << ", ";}cerr << "] (L" << __LINE__ << ")" << endl;

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

Int Q;
vector<Int> A;
vector<Int> B;

Int calc(Int A, Int B){
	if(A>B)swap(A,B);
	if(A==B){
		return A*2-2;
	}
	Int t = (Int)(sqrt((rn)(A*B-1))+1e-13L);
	if(t*(t+1)>=A*B){
		return t*2-2;
	}else{
		return t*2-1;
	}
}

void solve(){
	REP(i,Q)cout<<calc(A[i],B[i])<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> Q;
    A.resize(Q);
    B.resize(Q);
    for(int i = 0 ; i < Q ; i++){
        cin >> A[i];
        cin >> B[i];
    }
	solve();
	return 0;
}

//}}}

