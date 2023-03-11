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
 
typedef int Weight;
typedef edge<Weight> Edge;
typedef vector<edge<Weight> > Edges;
typedef graph<Weight> Graph;
typedef matrix<Weight> Matrix;
 
#ifdef DEBUG
#include"graph/graphviz.h"
#endif
//}}}

//{{{ shortest_path(graph g, int s) : Dijkstra
template<class Weight>
struct dijkstra_t{
//	vector<mod_int> dp;
	const graph<Weight> &g;
	const int s;
	vector<Weight> dist;
	vector<int> prev;
//	dijkstra_t(const graph<Weight> &g,int s):g(g),s(s),dist(g.size(),g.inf),prev(g.size(),-1){}
	dijkstra_t(const graph<Weight> &g,int s):g(g),s(s),dist(g.size(),g.inf),prev(g.size(),-1){
		/*
		assert(dist.size()==g.size());
		REP(i,dist.size())assert(dist[i]>=0 and dist[i]+dist[i]>=0);
		*/
	}
	vector<int> path(int t) {
		vector<int> path;
		for (int u = t; u >= 0; u = prev[u])path.push_back(u);
		reverse(ALL(path));
		return path;
	}
	void dijkstra(){
		dist[s] = 0;
//		priority_queue<edge<Weight> > Q; // "e < f" <=> "e.weight > f.weight"
		deque<edge<Weight> > Q; // "e < f" <=> "e.weight > f.weight"
		for (Q.push_back(edge<Weight>(-2, s, 0)); !Q.empty(); ) {
			edge<Weight> e = Q.front(); Q.pop_front();
			if (prev[e.dst] != -1) continue;
			prev[e.dst] = e.src;
			for(auto f:g[e.dst]) {
//				assert(e.weight<=g.inf);
//				assert(0<=f.weight and f.weight<=g.inf);
				Weight w = e.weight + f.weight;
				if (dist[f.dst] > w) {
					dist[f.dst] = w;
					if(f.weight==1)Q.push_back(edge<Weight>(f.src, f.dst, w));
					else Q.push_front(edge<Weight>(f.src, f.dst, w));
				}
			}
		}
	}
	/*
	void count_dp(){
		vector<pair<Weight,int> > d;
		REP(u,g.size())d.push_back({dist[u],u});
		sort(ALL(d));
		dp.assign(g.size(),mod_int());
		dp[s] = 1;
		REP(i,d.size()){
			int u = d[i].second;
			for(auto &&e:g[u]){
				if(dist[e.dst]+e.weight==dist[u]){
					dp[u]+=dp[e.dst];
				}
			}
		}
	}
	*/
};
template<class Weight>
dijkstra_t<Weight> shortest_path(const graph<Weight> &g, int s) {
	dijkstra_t<Weight> ret(g,s);
	ret.dijkstra();
//	ret.count_dp();
	return ret;
}
//}}}

void solve(){
	Graph G(K);
	REP(u,K){
		addEdge(G,{u,(u+1)%K},1);
		addEdge(G,{u,(10*u)%K},0);
	}
	auto s = shortest_path(G,1);
	cout<<s.dist[0]+1<<endl;
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

