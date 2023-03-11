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


//{{{ io
FILE *file_in=stdin,*file_out=stdout;
#define fin normal_in
#define fout normal_out
//const char fname[]="";
//FILE *fin=fopen(fname,"r"),*fout=fopen(fname,"w");
#ifdef __MINGW32__
#define LLD "%I64d"
#define LLU "%I64u"
#else
#define LLD "%lld"
#define LLU "%llu"
#endif
struct NORMAL_IN{
	bool cnt;
	NORMAL_IN():cnt(true){}
	operator int() const {return cnt;}
#define endl "\n"
	NORMAL_IN& operator>>(int &n){cnt=fscanf(file_in,"%d",&n)!=EOF;return *this;}
	NORMAL_IN& operator>>(unsigned int &n){cnt=fscanf(file_in,"%u",&n)!=EOF;return *this;}
	NORMAL_IN& operator>>(long long &n){cnt=fscanf(file_in,LLD,&n)!=EOF;return *this;}
	NORMAL_IN& operator>>(unsigned long long &n){cnt=fscanf(file_in,LLU,&n)!=EOF;return *this;}
	NORMAL_IN& operator>>(double &n){cnt=fscanf(file_in,"%lf",&n)!=EOF;return *this;}
	NORMAL_IN& operator>>(long double &n){cnt=fscanf(file_in,"%Lf",&n)!=EOF;return *this;}
	NORMAL_IN& operator>>(char *c){cnt=fscanf(file_in,"%s",c)!=EOF;return *this;}
	NORMAL_IN& operator>>(string &s){
		s.clear();
		for(bool r=false;;){
			const char c=getchar();
			if(c==EOF){ cnt=false; break;}
			const int t=isspace(c);
			if(!r and !t)r=true;
			if(r){
				if(!t)s.push_back(c);
				else break;
			}
		}
		return *this;
	}
	template<class T>
	NORMAL_IN& operator>>(vector<T> &v){
		int v_size = v.size();
		REP(i,v_size){
			*this>>v[i];
		}
		return *this;
	}
} normal_in;

struct NORMAL_OUT{
	NORMAL_OUT& operator<<(const int &n){fprintf(file_out,"%d",n);return *this;}
	NORMAL_OUT& operator<<(const unsigned int &n){fprintf(file_out,"%u",n);return *this;}
	NORMAL_OUT& operator<<(const long long &n){fprintf(file_out,LLD,n);return *this;}
	NORMAL_OUT& operator<<(const unsigned long long &n){fprintf(file_out,LLU,n);return *this;}
	NORMAL_OUT& operator<<(const double &n){fprintf(file_out,"%lf",n);return *this;}
	NORMAL_OUT& operator<<(const long double &n){fprintf(file_out,"%Lf",n);return *this;}
	NORMAL_OUT& operator<<(const char c[]){fprintf(file_out,"%s",c);return *this;}
	NORMAL_OUT& operator<<(const string &s){fprintf(file_out,"%s",s.c_str());return *this;}
} normal_out;
struct ERR_OUT{
	template<class T>
	ERR_OUT& operator<<(const T &a){
		cerr<<"\x1b[7m"<<a<<"\x1b[m";
		return *this;
	}
} ferr;
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
 
typedef Int Weight;
typedef edge<Weight> Edge;
typedef vector<edge<Weight> > Edges;
typedef graph<Weight> Graph;
typedef matrix<Weight> Matrix;
 
#ifdef MY_DEBUG
#include"graph/graphviz.hpp"
#endif
//}}}

//{{{ LCA
struct LCA {
	vector<int> height, euler, first, segtree;
	vector<Weight> dist;
	vector<bool> visited;
	int n;

	LCA(const Graph &g, int root = 0) {
		n = g.size();
		height.resize(n);
		first.resize(n);
		euler.reserve(n * 2);
		dist.resize(n);
		visited.assign(n, false);
		dfs(g, root);
		int m = euler.size();
		segtree.resize(m * 4);
		build(1, 0, m - 1);
	}

	void dfs(const Graph &g, int node, int h = 0, Weight d = 0) {
		visited[node] = true;
		height[node] = h;
		dist[node] = d;
		first[node] = euler.size();
		euler.push_back(node);
		for (auto e : g[node]) {
			if (!visited[e.dst]) {
				dfs(g, e.dst, h + 1, d + e.weight);
				euler.push_back(node);
			}
		}
	}

	void build(int node, int b, int e) {
		if (b == e) {
			segtree[node] = euler[b];
		} else {
			int mid = (b + e) / 2;
			build(node << 1, b, mid);
			build(node << 1 | 1, mid + 1, e);
			int l = segtree[node << 1], r = segtree[node << 1 | 1];
			segtree[node] = (height[l] < height[r]) ? l : r;
		}
	}

	int query(int node, int b, int e, int L, int R) {
		if (b > R || e < L)
			return -1;
		if (b >= L && e <= R)
			return segtree[node];
		int mid = (b + e) >> 1;

		int left = query(node << 1, b, mid, L, R);
		int right = query(node << 1 | 1, mid + 1, e, L, R);
		if (left == -1) return right;
		if (right == -1) return left;
		return height[left] < height[right] ? left : right;
	}

	int lca(int u, int v) {
		int left = first[u], right = first[v];
		if (left > right)
			swap(left, right);
		return query(1, 0, euler.size() - 1, left, right);
	}
	
	pair<int,Int> distance(int u,int v){
		int w = lca(u,v);
		pair<int,Int> ret = {height[u]+height[v]-height[w]*2, dist[u]+dist[v]-dist[w]*2};
		return ret;
	}
};
//}}}

vector<int> centroid_parent, centroid_hop;//parent of centroid
vector<Int> centroid_dist;

struct S{
	vector<Int> s;
	unordered_map<int,vector<Int> > vs;
	unordered_map<int,int> branch;
};
vector<S> info;

pair<int,pair<int,Int> > OneCentroid(int root, const Graph &g, const vector<bool> &dead, int sum_hop, Int sum_dist) {
	static vector<int> sz(g.size()); //caution
	function<void (int, int)> get_sz = [&](int u, int prev) {
		sz[u] = 1;
		for (auto e : g[u]) if (e.dst != prev && !dead[e.dst]) {
			get_sz(e.dst, u);
			sz[u] += sz[e.dst];
		}
	};
	get_sz(root, -1);
	int n = sz[root];
	function<pair<int,pair<int,Int> > (int, int, int, Int)> dfs = [&](int u, int prev, int sum_hop, Int sum_dist) {
		for (auto e : g[u]) if (e.dst != prev && !dead[e.dst]) {
			if (sz[e.dst] > n / 2) {
				return dfs(e.dst, u, sum_hop + 1, sum_dist + e.weight);
			}
		}
		return make_pair(u,make_pair(sum_hop, sum_dist));
	};
	return dfs(root, -1, sum_hop, sum_dist);
}

int DivideConquerCentroid(const Graph &g) {
	int res = 0;
	int n = (int) g.size();
	vector<bool> dead(n, false);
	function<void (int, int, Int)> rec = [&](int start, int parent_centroid, Int sum_dist) {
		auto p = OneCentroid(start, g, dead, 1, sum_dist);
		int c = p.first;
		dead[c] = true;
		centroid_parent[c] = parent_centroid;
		centroid_hop[c] = p.second.first;
		centroid_dist[c] = p.second.second;

		//compute something within a subtree alone (without the centroid)
		for (auto e : g[c]) if (!dead[e.dst]) {
			rec(e.dst, c, e.weight);
		}

		//compute something with the centroid
		S t;
		auto &s = t.s;
		s.resize(1);s[0] = 1;
		auto &vs = t.vs;
		auto &branch = t.branch;
		for (auto e : g[c]) if (!dead[e.dst]) {
			vector<Int> v;
			function<void (int, int, int)> dfs = [&](int u, int prev, int level) {
				if(v.size()<level+1)v.resize(level+1);
				v[level]++;
				branch[u] = e.dst;
				for (auto e : g[u]){
					if (e.dst != prev && !dead[e.dst]) {
						dfs(e.dst, u, level + 1);
					}
				}
			};
			dfs(e.dst, c, 1);
			if(s.size()<v.size())s.resize(v.size());
			REP(i,v.size())s[i] += v[i];
			vs[e.dst] = v;
		}
		//end
		info[c] = move(t);

		dead[c] = false;
	};
	rec(0, -1, 0);
	return res;
}

void solve(long long N, long long Q, std::vector<long long> A, std::vector<long long> B, std::vector<long long> v, std::vector<long long> k){
	centroid_parent.resize(N);
	centroid_hop.resize(N);
	centroid_dist.resize(N);
	info.resize(N);
//	poly_line.assign(N,vector<pair<Int,pair<Int,Int>>>());
	Graph G(N);
	REP(i,N-1)addBiEdge(G,{A[i],B[i]});
	DivideConquerCentroid(G);

	/*
	Graph H(N);
	graphviz(G,"graph.pdf");
	REP(u,N){
		if(centroid_parent[u]!=-1)addBiEdge(H,{u,centroid_parent[u]},centroid_dist[u]);
		else cerr<<"root: "<<u<<endl;
	}
	graphviz(H,"centroid.pdf");
	*/

	LCA lca(G);
	vector<map<Int,Int> > result(N);

	REP(i,Q){
		int c = v[i];
		Int ans = 0;
		for(;c!=-1;c = centroid_parent[c]){
			pair<int,Int> d = lca.distance(v[i],c);
			Int t = k[i] - d.first;
			if(t<0)continue;
			/*
			dump(info[c].branch);
			dump(v[i]);
			dump(d.first);
			dump(info[c].s);
			dump(t);
			*/
			if(t<info[c].s.size())ans += info[c].s[t];
			if(d.first!=0){
				auto it = info[c].branch.find(v[i]);
				assert(it!=info[c].branch.end());
				int b = it->second;
				if(t<info[c].vs[b].size())ans -= info[c].vs[b][t];
			}
		}
		fout<<ans<<endl;
	}
}

int main(){
	long long N;
	scanf("%lld",&N);
	long long Q;
	scanf("%lld",&Q);
	std::vector<long long> A(N-1);
	std::vector<long long> B(N-1);
	for(int i = 0 ; i < N-1 ; i++){
		scanf("%lld",&A[i]);
		scanf("%lld",&B[i]);
		A[i]--;B[i]--;
	}
	std::vector<long long> v(Q);
	std::vector<long long> k(Q);
	for(int i = 0 ; i < Q ; i++){
		scanf("%lld",&v[i]);
		scanf("%lld",&k[i]);
		v[i]--;
	}
	solve(N, Q, std::move(A), std::move(B), std::move(v), std::move(k));
	return 0;
}
