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

Int N;
vector<Int> p_A;
vector<Int> q_A;
Int M;
vector<Int> p_B;
vector<Int> q_B;

void solve(){
	Graph G(N), H(M);
	REP(i,N-1)addBiEdge(G,{p_A[i],q_A[i]});
	REP(i,M-1)addBiEdge(H,{p_B[i],q_B[i]});
	function<vector<int>(const Graph &)> dists = [](const Graph &g){
		int n = g.size();
		vector<vector<pair<int, int>>> d(n);
		vector<int> far(n);
		function<void (int, int)> dfs = [&](int u, int prev) {
			for (auto e : g[u]) if (e.dst != prev) {
				dfs(e.dst, u);
				far[u] = max(far[u], far[e.dst] + 1);
				d[u].push_back({far[e.dst] + 1, e.dst});
			}
		};
		dfs(0, -1);
		
		sort(d[0].rbegin(), d[0].rend());
		function<void (int, int)> dfs2 = [&](int u, int prev) {
			for (auto e : g[u]) if (e.dst != prev) {
				if (d[u][0].second == e.dst) {
					d[e.dst].push_back({((int) d[u].size() == 1 ? 0 : d[u][1].first) + 1, u});
				} else { 
					d[e.dst].push_back({d[u][0].first + 1, u});
				}
				sort(d[e.dst].rbegin(), d[e.dst].rend());
				dfs2(e.dst, u);
			}
		};
		dfs2(0, -1);
		
		vector<int> ret(n,0);
		REP(u,n){
			for(auto &&p:d[u]){
				ret[u] = max(ret[u],p.first);
			}
		}
		return ret;
	};
	auto dG = dists(G), dH = dists(H);
	sort(ALL(dG));sort(ALL(dH));
//	dump(dG);
//	dump(dH);
	int t = max(*max_element(ALL(dG)),*max_element(ALL(dH)));
//	dump(t);
	Int ans = 0;
	Int t_dists = 0, t_dists2 = 0;
	for(int i = 0, j = dH.size() - 1;i < dG.size();i++){
		for(;j >=0 and dG[i] + dH[j] + 1 >= t;j--){}
		ans += (M-j-1)*(Int)dG[i];
		t_dists += j + 1;
	}
	for(int j = 0, i = dG.size() - 1;j < dH.size();j++){
		for(;i >=0 and dG[i] + dH[j] + 1 >= t;i--){}
		ans += (N-i-1)*(Int)dH[j];
		t_dists2 += i + 1;
	}
//	dump(t_dists,t_dists2);
	//	assert(t_dists==t_dists2);
	ans += N*M - t_dists;
	ans += t_dists * t;
	cout<<ans<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	p_A.assign(N-1,Int());
	q_A.assign(N-1,Int());
	for(int i = 0 ; i < N-1 ; i++){
		cin >> p_A[i];
		cin >> q_A[i];
		p_A[i]--;
		q_A[i]--;
	}
	cin >> M;
	p_B.assign(M-1,Int());
	q_B.assign(M-1,Int());
	for(int i = 0 ; i < M-1 ; i++){
		cin >> p_B[i];
		cin >> q_B[i];
		p_B[i]--;
		q_B[i]--;
	}
	solve();
	return 0;
}

//}}}

