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

Int K;

void solve(){
	while(K%2==0)K/=2;
	while(K%5==0)K/=5;
	if(K==1){
		cout<<1<<endl;
		return;
	}
	vector<bool> listed(K);
	vector<int> v;
	queue<int> q;
	int t = 1;
	do{
		t *= 10;
		t %= K;
		listed[t] = true;
		v.push_back(t);
		q.push(t);
	}while(t!=1);
	int d = 1;
	while(!q.empty()){
		queue<int> q2;
		while(!q.empty()){
			int t = q.front();q.pop();
			for(auto a:v){
				int t2 = a + t;
				if(t2>=K)t2 -= K;
				if(listed[t2])continue;
				if(t2==0){
					cout<<d+1<<endl;
					return;
				}
				listed[t2] = true;
				q2.push(t2);
			}
		}
		q = q2;
		d++;
	}
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> K;
	solve();
	return 0;
}

//}}}

