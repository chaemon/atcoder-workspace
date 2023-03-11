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

// heavy-light decomposition
// HLDecomposition(Graph G)
// build();
// for_each(int u, int v, const function<void(int, int)>& f);
// for_each_edge(int u, int v, const function<void(int, int)>& f);
// lca(int u, int v); distance(int u, int v);
//{{{ HLDecomposition
struct HLDecomposition {
	const Graph &G;
	int n,pos;
	vector<int> vid, head, sub, hvy, par, dep, inv, type;

//	HLDecomposition(){}
	HLDecomposition(const Graph &G):
		G(G), n(G.size()),pos(0),
		vid(n,-1),head(n),sub(n,1),hvy(n,-1),
		par(n),dep(n),inv(n),type(n){}

	/*
	void add_edge(int u, int v) {
		G[u].push_back(v);
		G[v].push_back(u);
	}
	*/

	void build(vector<int> rs=vector<int>(1,0)) {
		int c=0;
		for(int r:rs){
			dfs(r);
			bfs(r, c++);
		}
	}

	void dfs(int rt) {
		using T = pair<int,int>;
		stack<T> st;
		par[rt]=-1;
		dep[rt]=0;
		st.emplace(rt,0);
		while(!st.empty()){
			int v=st.top().first;
			int &i=st.top().second;
			if(i<(int)G[v].size()){
				int u = G[v][i++].dst;
				if(u==par[v]) continue;
				par[u]=v;
				dep[u]=dep[v]+1;
				st.emplace(u,0);
			}else{
				st.pop();
				int res=0;
				for(auto e:G[v]){
					int u = e.dst;
					if(u==par[v]) continue;
					sub[v]+=sub[u];
					if(res<sub[u]) res=sub[u],hvy[v]=u;
				}
			}
		}
	}

	void bfs(int r,int c) {
		int &k=pos;
		queue<int> q({r});
		while(!q.empty()){
			int h=q.front();q.pop();
			for(int i=h;i!=-1;i=hvy[i]) {
				type[i]=c;
				vid[i]=k++;
				inv[vid[i]]=i;
				head[i]=h;
				for(auto e:G[i]){
					int j = e.dst;
					if(j!=par[i]&&j!=hvy[i]) q.push(j);
				}
			}
		}
	}

	// for_each(vertex)
	// [l,r] <- attention!!
	void for_each(int u, int v, const function<void(int, int)>& f) {
		while(1){
			if(vid[u]>vid[v]) swap(u,v);
			f(max(vid[head[v]],vid[u]),vid[v]);
			if(head[u]!=head[v]) v=par[head[v]];
			else break;
		}
	}

	// for_each(edge)
	// [l,r] <- attention!!
	void for_each_edge(int u, int v, const function<void(int, int)>& f) {
		while(1){
			if(vid[u]>vid[v]) swap(u,v);
			if(head[u]!=head[v]){
				f(vid[head[v]],vid[v]);
				v=par[head[v]];
			} else{
				if(u!=v) f(vid[u]+1,vid[v]);
				break;
			}
		}
	}

	int lca(int u,int v){
		while(1){
			if(vid[u]>vid[v]) swap(u,v);
			if(head[u]==head[v]) return u;
			v=par[head[v]];
		}
	}

	int distance(int u,int v){
		return dep[u]+dep[v]-2*dep[lca(u,v)];
	}
};
//}}}

// segment tree point update, range query
// SegmentTree<T>(int n, T unit, function<T(T,T)> append)
// point_update(int i, T z), range_concat(int l, int r), build(vector<T> &v)
//{{{ class SegmentTree
template <typename T>
struct SegmentTree { // on monoid
	int n;
	vector<T> a;
	function<T (T,T)> append; // associative
	T unit; // unit
	SegmentTree() = default;
	SegmentTree(int a_n, T a_unit, function<T (T,T)> a_append) {
		n = pow(2,ceil(log2(a_n)));
		a.resize(2*n-1, a_unit);
		unit = a_unit;
		append = a_append;
	}
	void point_update(int i, T z) {
		a[i+n-1] = append(a[i+n-1],z);
		for (i = (i+n)/2; i > 0; i /= 2) {
			a[i-1] = append(a[2*i-1], a[2*i]);
		}
	}
	T range_concat(int l, int r) {
		return range_concat(0, 0, n, l, r);
	}
	T range_concat(int i, int il, int ir, int l, int r) {
		if (l <= il and ir <= r) {
			return a[i];
		} else if (ir <= l or r <= il) {
			return unit;
		} else {
			return append(
					range_concat(2*i+1, il, (il+ir)/2, l, r),
					range_concat(2*i+2, (il+ir)/2, ir, l, r));
		}
	}
	void build(int i, int il, int ir, const vector<T> &v){
		if(ir-il==1){
			if(il<n)a[i] = v[il];
			else a[i] = unit;
		}else{
			int im = (il+ir)/2;
			build(v,i*2+1,il,im);
			build(v,i*2+2,im,ir);
			a[i] = append(a[i*2+1],a[i*2+2]);
		}
	}
	void build(const vector<T> &v){
		build(0,0,n,v);
	}
};
//}}}

//{{{ minimumSpanningTree(Graph g)
pair<Weight, Edges> minimumSpanningTree(const Graph &g, int r = 0) {
	int n = g.size();
	Edges T;
	Weight total = 0;

	vector<bool> visited(n);
	priority_queue<Edge> Q;
	Q.push( Edge(-1, r, 0) );
	while (!Q.empty()) {
		Edge e = Q.top(); Q.pop();
		if (visited[e.dst]) continue;
		if(e.src>=0)T.push_back(e);
		total += e.weight;
		visited[e.dst] = true;
		FOR(f, g[e.dst]) if (!visited[f->dst]) Q.push(*f);
	}
	return pair<Weight, Edges>(total, T);
}
//}}}

int N;
int M;
vector<int> a;
vector<int> b;
vector<int> c;
int Q;
vector<int> S;
vector<int> T;

void solve(){
	Graph G(N), GT(N);
	REP(i,M)addBiEdge(G,{a[i],b[i]},(Int)c[i]);
	auto p = minimumSpanningTree(G);
	for(auto e:p.second){
		addBiEdge(GT,{e.src,e.dst},e.weight);
	}
	HLDecomposition hl(GT);
	hl.build();
	SegmentTree<Int> st(N,-inf<Int>(),
			[&](Int a,Int b){return max(a,b);}
			);
	function<void(int,int)> dfs = [&](int u, int p){
		for(auto &&e:GT[u]){
			if(e.dst==p)continue;
			int v = hl.vid[e.dst];
			st.point_update(v,e.weight);
			dfs(e.dst,u);
		}
	};
	dfs(0,-1);
	REP(i,Q){
		Int ans = -inf<Int>();
		hl.for_each_edge(S[i],T[i],[&](int l, int r){
				ans = max(ans,st.range_concat(l,r+1));
				});
		ans = p.first - ans;
		cout<<ans<<endl;
	}
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> M;
	a.assign(M,Int());
	b.assign(M,Int());
	c.assign(M,Int());
	for(int i = 0 ; i < M ; i++){
		cin >> a[i];
		cin >> b[i];
		cin >> c[i];
		a[i]--;b[i]--;
	}
	cin >> Q;
	S.assign(Q,Int());
	T.assign(Q,Int());
	for(int i = 0 ; i < Q ; i++){
		cin >> S[i];
		cin >> T[i];
		S[i]--;T[i]--;
	}
	solve();
	return 0;
}

//}}}

