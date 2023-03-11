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

const string YES = "Yes";
const string NO = "No";
Int N;

void solve(){
	if(__builtin_popcount(N)==1){
		cout<<NO<<endl;
		return;
	}
	cout<<YES<<endl;
	
	//node: b(center), N+b
	bool start = true;
	unordered_set<int> listed;
	vector<pii> ans;
	if(N%2==0){
		int b = 1;
		while((N&(b))==0)b<<=1;
		assert((N&b)!=0);

		listed.insert(N);
		listed.insert(b);
		listed.insert(b^1);
		listed.insert(N^b);
		listed.insert(N^b^1);
		
		ans.push_back({(N^b^1),1});
		ans.push_back({1,b^1});
		ans.push_back({b,1});
		ans.push_back({b,(b^1)+N});
		ans.push_back({b,N});
		ans.push_back({(N^b^1)+N,N});
		ans.push_back({(N^b^1)+N,N+1});
		start = false;
		ans.push_back({N,N^b});
		ans.push_back({N^b,b+N});
		ans.push_back({b+N,N+N});
		ans.push_back({N+N,(N^b)+N});
	}
	for(int i = 2;i <= N;i++){
		int j = (i^1);
		if(i>j)continue;
		if(N%2==0){
			if(i==N)continue;
			if(listed.find(i)!=listed.end() or listed.find(j)!=listed.end())continue;
		}
		//i < j
		ans.push_back({i,1});
		ans.push_back({j,1});
		ans.push_back({i,N+j});
		ans.push_back({j,N+i});
		if(start){
			ans.push_back({N+i,N+1});
			start = false;
		}
	}
	assert(ans.size()==2*N-1);
	for(auto &&e:ans){
		assert(e.first<=2*N and e.second<=2*N);
		cout<<e.first<<" "<<e.second<<endl;
	}
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	solve();
	return 0;
}
//}}}
