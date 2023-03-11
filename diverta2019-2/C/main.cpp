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

Int N;
deque<Int> A;

void solve(){
	sort(ALL(A));
	reverse(ALL(A));
	bool all_minus = true, all_plus = true;
	REP(i,N){
		if(A[i]>0)all_minus = false;
		if(A[i]<0)all_plus = false;
	}
	if(all_minus){
		Int sum = accumulate(ALL(A),0ll);
		cout<<A[0] * 2 - sum<<endl;
		Int result = A[0];
		REP(i,N-1){
			cout<<result<<" "<<A[i+1]<<endl;
			result = result - A[i+1];
		}
		return;
	}
	if(all_plus){
		Int sum = accumulate(ALL(A),0ll);
		cout<<sum - A.back() * 2<<endl;
		if(A.size()==2){
			cout<<A[0]<<" "<<A[1]<<endl;
			return;
		}
		Int result = A.back();
		A.pop_back();
//		assert(A.size()>=2);
		for(int i = 0;i < (int)A.size() - 1;i++){
			cout<<result<<" "<<A[i]<<endl;
			result = result - A[i];
		}
		cout<<A.back()<<" "<<result<<endl;
		return;
	}
	deque<Int> vp, vn;
	REP(i,N){
		if(A[i]>0)vp.push_back(A[i]);
		else vn.push_back(A[i]);
	}
	cout<<accumulate(ALL(vp),0ll)-accumulate(ALL(vn),0ll)<<endl;
	Int result;
	if(vp.size()==1){
		result = vp.front();
		vp.pop_front();
	}else{
		result = vn.front();
		vn.pop_front();
		REP(i,vp.size()-1){
			cout<<result<<" "<<vp[i]<<endl;
			result = result - vp[i];
		}
		cout<<vp.back()<<" "<<result<<endl;
		result = vp.back() - result;
	}
	REP(i,vn.size()){
		cout<<result<<" "<<vn[i]<<endl;
		result = result - vn[i];
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	
	/*
	N = rand()%1000;
	A.assign(N,Int());
	REP(i,N)A[i] = rand()%2000 - 1000;
	*/

	cin >> N;
	A.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> A[i];
	}
	solve();
	return 0;
}

//}}}

