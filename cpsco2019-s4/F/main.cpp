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

Int K;
vector<vector<Int>> D;

struct S{
	int root;
	vector<int> v;
	S():root(-1){}
};

template<class U>
U &operator<<(U &os, const S &s){
	os<<"S: "<<s.root<<" "<<s.v;
	return os;
}

void solve(){
	vector<int> parent(K,-1);
	vector<Int> dist(K,0);
	function<void(int,Int,const vector<int>&)> build = [&](int root, Int root_dist, const vector<int> &v){
		if(v.size()<=1){
			REP(i,v.size()){
				if(v[i]!=root){
					parent[v[i]] = root;
					dist[v[i]] = D[0][v[i]] - root_dist;
				}
			}
			return;
		}
		int base = -1;
		for(int i = 0;i < v.size();i++){
			if(v[i]!=root){
				base = v[i];
				break;
			}
		}
		assert(base>=0);
		
		map<Int,S> d2n;//dist, node
		auto &s = d2n[root_dist];
		s.root = root;
//		s.v.push_back(root);
		for(int i = 0;i < v.size();i++){
			Int d = (D[base][0] + D[v[i]][0] - D[base][v[i]])/2;
			Int d2 = (D[0][v[i]] + D[base][v[i]] - D[base][0])/2;
			auto &s = d2n[d];
			s.v.push_back(v[i]);
			if(d2==0){
				s.root = v[i];
			}
		}
		int prev_parent = -1;
		Int prev_dist;
		for(auto &&p:d2n){
			auto &d = p.first;
			auto &s = p.second;
			if(s.root==-1){
				s.root = parent.size();
				parent.push_back(-1);
				dist.push_back(0);
			}
			if(d > root_dist){
				parent[s.root] = prev_parent;
				dist[s.root] = d - prev_dist;
			}
			if(v.size()>1){
				build(s.root,d,s.v);
			}
			prev_parent = s.root;
			prev_dist = d;
		}
		return;
	};
	vector<int> v;
	for(int u = 0;u < K;u++)v.push_back(u);
	build(0,0,v);
//	cout<<parent<<endl;
//	cout<<dist<<endl;
	cout<<parent.size()<<endl;
	REP(u,parent.size()){
		if(parent[u]!=-1){
			cout<<u+1<<" "<<parent[u]+1<<" "<<dist[u]<<endl;
		}
	}
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> K;
    D.assign(K, vector<Int>(K));
    for(int i = 0 ; i < K ; i++){
        for(int j = 0 ; j < K ; j++){
            cin >> D[i][j];
        }
    }
	solve();
	return 0;
}
