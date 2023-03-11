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

//{{{ Graph<Weight> g(size); addEdge(g,{src,dst},weight); matrix<Weight> A(n,m);
typedef int Node;
template<class Weight>
struct edge {
	int src, dst;
	Weight weight;
	int rev;
	edge(int src, int dst, Weight weight=1,int rev=-1) :
		src(src), dst(dst), weight(weight), rev(rev){ }
};
template<class Weight>
bool operator < (const edge<Weight> &e, const edge<Weight> &f) {
	return e.weight != f.weight ? e.weight > f.weight : // !!INVERSE!!
		e.src != f.src ? e.src < f.src : e.dst < f.dst;
}
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
	Weight inf{::inf<Weight>()};
	graph(){}
	graph(const int &n):vector<vector<edge<Weight> > >(n){}
	void _add_edge(int from, int to, Weight w, int rev=-1){
		if((int)this->size() < from + 1)this->resize(from + 1);
		this->at(from).push_back(edge<Weight>(from,to,w,rev));
	}
};
//add bi-directional edge
template<class Weight>
void addBiEdge(graph<Weight> &g, const pair<int,int> &e, Weight w=1){
	const int &from = e.first, &to = e.second;
	g._add_edge(from,to,w,g[to].size());
	g._add_edge(to,from,w,g[from].size()-1);
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

pair<vector<vector<int> >,vector<int> > build_tree(const Graph &G, int r = 0){
	const int n = G.size();
	vector<vector<int> > child(n);
	vector<int> parent(n);
	function<void(int,int)> dfs = [&](int u, int p){
		parent[u] = p;
		for(auto &&e:G[u]){
			if(e.dst==p)continue;
			child[u].push_back(e.dst);
			dfs(e.dst,u);
		}
	};
	dfs(r,-1);
	return {child,parent};
}

Int N;
vector<Int> a;
vector<Int> b;

void solve(){
	Graph G(N);
	REP(i,N-1)addBiEdge(G,{a[i],b[i]});
	auto pr = build_tree(G,0);
	auto child = pr.first;
	auto parent = pr.second;
	vector<vector<pii> > dp(N);
	function<pii(int,int)> dfs = [&](int u, int p){
		if(child[u].size()==0){
			return pii{1,0};
		}
		vector<pii> cv;
		for(auto &&c:child[u]){
			cv.push_back(dfs(c,u));
		}
		dp[u] = cv;
		// no leaf
		int no_leaf;
		
		// antenna at u
		int s = 1, t = 0;
		for(auto &&p:cv)s += p.second;
		// no antenna at u
		for(auto &&p:cv)t += p.first;
		no_leaf = min(s,t);
		
		// probably one leaf
		int one_leaf = no_leaf;
		for(auto &&p:cv){
			one_leaf = min(one_leaf,t - p.first + p.second);
		}
		return pii(no_leaf,one_leaf);
	};
	dfs(0,-1);
	function<pii(int,int,pii)> dfs2 = [&](int u, int p, pii d){
		
	};
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	a.assign(N-2-0+1,Int());
	b.assign(N-2-0+1,Int());
	for(int i = 0 ; i < N-2-0+1 ; i++){
		cin >> a[i];
		cin >> b[i];
	}
	solve();
	return 0;
}

//}}}

