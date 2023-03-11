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
#define UNIQUE(v) (sort(ALL(v)),(v).erase(unique(ALL(v)),(v).end()))
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

//{{{ Union-Find
struct UnionFind {
	vector<int> id;
	vector<vector<int> > di;
	UnionFind(int size) : id(size),  di(size){
		REP(i,size)id[i] = i, di[i].push_back(i);
	}
	void unionSet(int x, int y){
		if(id[x]!=id[y]){
			int ix = id[x], iy = id[y];
			if(di[ix].size() < di[iy].size()){
				swap(ix,iy);
			}
			for(auto &&p:di[iy])id[p] = ix;
			di[ix].insert(di[ix].end(),ALL(di[iy]));
			di[iy].clear();
		}
	}
	bool findSet(int x, int y) {
		return id[x] == id[y];
	}
};
//}}}

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
		priority_queue<edge<Weight> > Q; // "e < f" <=> "e.weight > f.weight"
		for (Q.push(edge<Weight>(-2, s, 0)); !Q.empty(); ) {
			edge<Weight> e = Q.top(); Q.pop();
			if (prev[e.dst] != -1) continue;
			prev[e.dst] = e.src;
			for(auto f:g[e.dst]) {
//				assert(e.weight<=g.inf);
//				assert(0<=f.weight and f.weight<=g.inf);
				Weight w = e.weight + f.weight;
				if (dist[f.dst] > w) {
					dist[f.dst] = w;
					Q.push(edge<Weight>(f.src, f.dst, w));
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

Int N;
Int M;
vector<int> p;
vector<int> q;
vector<int> c;

void solve(){
	unordered_map<int,vector<pair<int,int> > > cs;
	REP(i,M){
		cs[c[i]].push_back({p[i],q[i]});
	}
	vector<vector<int> > S;
	for(auto &&p:cs){
		auto &&v = p.second;
		vector<int> vu;
		for(auto &&q:v)vu.push_back(q.first), vu.push_back(q.second);
		UNIQUE(vu);
		UnionFind uf(vu.size());
		for(auto &&q:v){
			int qi = lower_bound(ALL(vu),q.first) - vu.begin();
			int qj = lower_bound(ALL(vu),q.second) - vu.begin();
			uf.unionSet(qi,qj);
		}
		auto w = uf.di;
		REP(i,w.size()){
			REP(j,w[i].size()){
				w[i][j] = vu[w[i][j]];
			}
		}
		REP(i,w.size()){
			if(w[i].size()>0)S.push_back(w[i]);
		}
	}
	Graph G(N+S.size()*2);
	int i = 0;
	for(auto &&v:S){
		addEdge(G,{N + i*2, N+i*2+1},1);
		for(auto &&u:v){
			addEdge(G,{u,N+i*2},0);
			addEdge(G,{N+i*2+1,u},0);
		}
		i++;
	}
	auto stp = shortest_path(G,0);
	Weight d = stp.dist[N-1];
	if(d==G.inf){
		cout<<-1<<endl;
	}else{
		cout<<d<<endl;
	}
}


//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
    cin >> M;
    p.resize(M);
    q.resize(M);
    c.resize(M);
    for(int i = 0 ; i < M ; i++){
        cin >> p[i];
        cin >> q[i];
        cin >> c[i];
		c[i]--;
		p[i]--;q[i]--;
    }
	solve();
	return 0;
}

//}}}

