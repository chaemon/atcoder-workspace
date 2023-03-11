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
vector<uint> a;

void solve(){
	map<uint,int> s;
	for(auto t:a)s[t]++;
	if(s.size()==1){
		if(a[0]==0){
			cout<<YES<<endl;
		}else{
			cout<<NO<<endl;
		}
	}else{
		if(N%3!=0){
			cout<<NO<<endl;
		}else{
			int t = N/3;
			if(s.size()==2){
				if(s.begin()->first==0){
					if(s.begin()->second!=t){
						cout<<NO<<endl;
					}else{
						auto it = s.begin();
						it++;
						if(it->second!=t*2){
							cout<<NO<<endl;
						}else{
							cout<<YES<<endl;
						}
					}
				}else{
					cout<<NO<<endl;
				}
			}else if(s.size()==3){
				vector<uint> v;
				bool valid = true;
				for(auto p:s){
					v.push_back(p.first);
					if(p.second!=t)valid = false;
				}
				if(!valid){
					cout<<NO<<endl;
				}else{
					if((v[0]^v[1])==v[2] or
						(v[1]^v[2])==v[0] or 
						(v[2]^v[0])==v[1] ){
						cout<<YES<<endl;
					}else{
						cout<<NO<<endl;
					}
				}
			}else{
				cout<<NO<<endl;
			}
		}
	}
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	a.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> a[i];
	}
	solve();
	return 0;
}
//}}}
