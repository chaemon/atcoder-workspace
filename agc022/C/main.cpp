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

int N;
vector<int> a;
vector<int> b;

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
	Weight inf{::inf<Weight>};
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

//{{{ shortestpath warshall floyd
template<typename Weight>
struct shortestPath_t{
	Matrix dist;
	vector<vector<int> > inter;
	void buildPath(int s, int t, vector<int> &path) {
		int u = inter[s][t];
		if (u < 0) path.push_back(s);
		else buildPath(s, u, path), buildPath(u, s, path);
	}
	vector<int> buildPath(int s, int t) {
		vector<int> path;
		buildPath(s, t, path);
		path.push_back(t);
		return path;
	}
};

template<typename Weight>
shortestPath_t<Weight> shortestPath(const matrix<Weight> &g) {
	const int n = g.size();
	matrix<Weight> dist{g};
	vector<vector<int> > inter(n,vector<int>(n,-1));
	REP(k, n) REP(i, n) REP(j, n) {
		Weight d = dist[i][k] + dist[k][j];
		if (dist[i][j] > d) {
			dist[i][j] = d;
			inter[i][j] = k;
		}
	}
	return {dist,inter};
}
//}}}

void solve(){
	int M = 0;
	REP(i,N)M = max(M,a[i]), M = max(M,b[i]);
	M++;
	auto test = [&](uInt bt){
		Matrix g({M,M},inf<int>);
		REP(u,M)g[u][u] = 0;
		for(int k = 1;k < M;k++){
			if(bt & (1ull<<(k-1))){
				for(int n = 0;n < M;n++){
					int r = n%k;
					g[n][r] = 1;
				}
			}
		}
		auto s = shortestPath(g);
		REP(i,N){
			if(s.dist[a[i]][b[i]]>=inf<int>)return false;
		}
		return true;
	};
	uInt bt = (1ull<<(M - 1)) - 1;
	if(!test(bt)){
		cout<<-1<<endl;
		return;
	}
	for(int k = M - 2;k >= 0;k--){
		if(test(bt^(1ull<<k))){
			bt ^= (1ull<<k);
		}else{
			
		}
	}
	cout<<bt*2<<endl;
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
	b.assign(N,Int());
	for(int i = 0 ; i < N ; i++){
		cin >> b[i];
	}
	solve();
	return 0;
}
//}}}
