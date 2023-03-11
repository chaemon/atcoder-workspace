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
#include"debug.hpp"
#include"print.hpp"
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
	void _add_edge(int from, int to, Weight w, int rev = -1){
		if((int)this->size() < from + 1)this->resize(from + 1);
		this->at(from).push_back(edge<Weight>(from,to,w,rev));
	}
};
//add bi-directional edge
template<class Weight>
void addBiEdge(graph<Weight> &g, const pair<int,int> &e, Weight w = 1){
	const int &from = e.first, &to = e.second;
	g._add_edge(from,to,w,g[to].size());
	g._add_edge(to,from,w,g[from].size()-1);
}
//add directional edge
template<class Weight>
void addEdge(graph<Weight> &g, const pair<int,int> &e, Weight w = 1){
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
 
//{{{ shortest_path(graph g, int s) : Dijkstra
template<class Weight>
struct dijkstra_t{
//	vector<mod_int> dp;
	const graph<Weight> &g;
	const int &s;
	vector<Weight> dist;
	vector<int> prev;
//	dijkstra_t(const graph<Weight> &g,int s):g(g),s(s),dist(g.size(),g.inf),prev(g.size(),-1){}
	dijkstra_t(const graph<Weight> &g,const int &s):g(g),s(s),dist(g.size(),g.inf),prev(g.size(),-1){
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

vector<pii> dir = {{0,1},{1,0},{0,-1},{-1,0}};
//vector<pii> dir = {{0,1},{1,0}};

Int H;
Int W;
Int X;
int s_x;
int s_y;
int g_x;
int g_y;
vector<vector<int>> A;
vector<Int> C;

struct S{
	vector<int> p;
	Int d;
	S(const vector<int> &p,Int d):p(p),d(d){}
	bool operator<(const S &s)const{
		return d > s.d;//INVERSE
	}
};


void solve(){
	Graph G(H*W+X);
	REP(x,H)REP(y,W){
		for(auto &&dr:dir){
			int x2 = x + dr.first, y2 = y + dr.second;
			if(0<=x2 and x2<H and 0<=y2 and y2<W){
				if(A[x][y]>0){
					int i = A[x][y] - 1;
					if(A[x2][y2]>0){
						int j = A[x2][y2] - 1;
						addEdge(G,{H*W+i,H*W+j},C[i]);
					}else{
						addEdge(G,{H*W+i,x2*W+y2},C[i]);
					}
				}else{
					if(A[x2][y2]>0){
						int j = A[x2][y2] - 1;
						addEdge(G,{x*W+y,H*W+j},0ll);
					}else{
						addEdge(G,{x*W+y,x2*W+y2},0ll);
					}
				}
			}
		}
	}
	auto d = shortest_path(G,s_x*W+s_y);
	cout<<d.dist[g_x*W+g_y]<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> H;
	cin >> W;
	cin >> X;
	cin >> s_x;
	cin >> s_y;
	cin >> g_x;
	cin >> g_y;
	s_x--;s_y--;g_x--;g_y--;
	A.resize(H);
	for(int i = 0 ; i < H ; i++){
		A[i].resize(W);
		for(int j = 0 ; j < W ; j++){
			cin >> A[i][j];
		}
	}
	C.resize(X);
	for(int i = 0 ; i < X ; i++){
		cin >> C[i];
	}
	solve();
	return 0;
}

//}}}

