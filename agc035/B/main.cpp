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

Int N;
Int M;
vector<Int> A;
vector<Int> B;

//{{{ Graph<Weight> g(size); addEdge(g,{src,dst},weight); matrix<Weight> A(n,m);
typedef int Node;
template<class Weight>
struct edge {
	int src, dst;
	Weight weight;
	int eid;
	int rev;
	edge(int src, int dst, Weight weight=1,int eid=-1,int rev=-1) :
		src(src), dst(dst), weight(weight), eid(eid),rev(rev){ }
};
//typedef vector<edge> edges;
//typedef vector<edges> Graph;

template<class Weight>
struct matrix:vector<vector<Weight> >{
	matrix(const array<int,2> &a, Weight w=0):vector<vector<Weight> >(a[0],vector<Weight>(a[1],w)){}
	matrix(const array<int,1> &a, Weight w=0):vector<vector<Weight> >(a[0],vector<Weight>(a[0],0)){}
	matrix(){}
};

template<class Weight>
struct graph:vector<vector<edge<Weight> > >{
	Weight inf{::inf<Weight>};
	graph(){}
	graph(const int &n):vector<vector<edge<Weight> > >(n){}
	void _add_edge(int from, int to, Weight w, int eid, int rev=-1){
		if((int)this->size() < from + 1)this->resize(from + 1);
		this->at(from).push_back(edge<Weight>(from,to,w,eid,rev));
	}
};
//add bi-directional edge
template<class Weight>
void addBiEdge(graph<Weight> &g, const pair<int,int> &e, Weight w=1,int eid=-1){
	const int &from = e.first, &to = e.second;
	g._add_edge(from,to,w,eid,g[to].size());
	g._add_edge(to,from,w,eid,g[from].size()-1);
}
//add directional edge
template<class Weight>
void addEdge(graph<Weight> &g, const pair<int,int> &e, Weight w=1){
	const int &from = e.first, &to = e.second;
	g._add_edge(from,to,w);
}


#ifdef DEBUG
#include"graph/graphviz.h"
#endif
//}}}
typedef Int Weight;
typedef edge<Weight> Edge;
typedef vector<edge<Weight> > Edges;
typedef graph<Weight> Graph;
typedef matrix<Weight> Matrix;

void solve(){
	if(M%2==1){
		cout<<-1<<endl;
		return;
	}
	Graph G(N);
	REP(i,M)addBiEdge(G,{A[i],B[i]},1ll,i);
	vector<bool> vis(N,false);
	vector<bool> vis_edge(M,false);
	vector<int> outdeg(N,0);
	vector<pii> ans;
	bool valid = true;
	function<void(int,int)> dfs = [&](int u,int p){
		vis[u] = true;
		for(auto &&e:G[u]){
			int v = e.dst;
			if(v==p)continue;
			if(vis_edge[e.eid])continue;
			vis_edge[e.eid] = true;
			if(vis[v]){
				//edge u -> v
				outdeg[u]++;
				ans.push_back({u,v});
			}else{
				dfs(v,u);
			}
		}
		//decide edge between u, p
		if(p!=-1){
			if(outdeg[u]%2==0){// p -> u
				ans.push_back({p,u});
				outdeg[p]++;
			}else{
				ans.push_back({u,p});
				outdeg[u]++;
			}
		}else{
			if(outdeg[u]%2==0){
			}else{
				valid = false;
			}
		}
	};
	dfs(0,-1);
	if(!valid){
		cout<<-1<<endl;
	}else{
		for(auto &&p:ans){
			cout<<p.first+1<<" "<<p.second+1<<endl;
		}
	}
}
//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> M;
	A.assign(M,Int());
	B.assign(M,Int());
	for(int i = 0 ; i < M ; i++){
		cin >> A[i];
		cin >> B[i];
		A[i]--;
		B[i]--;
	}
	solve();
	return 0;
}
//}}}
