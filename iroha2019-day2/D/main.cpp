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

Int N;
Int M;
vector<int> A;
vector<int> B;
vector<Int> C;

//{{{ Graph<Weight> g(size); addEdge(g,{src,dst},weight); matrix<Weight> A(n,m);
typedef int Node;
template<class Weight>
struct edge {
	int src, dst;
	Weight weight;
	int rev;
	int id;
	edge(int src, int dst, Weight weight=1,int rev=-1,int id=0) :
		src(src), dst(dst), weight(weight), rev(rev), id(id){ }
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
	void _add_edge(int from, int to, Weight w, int rev=-1,int id=0){
		if((int)this->size() < from + 1)this->resize(from + 1);
		this->at(from).push_back(edge<Weight>(from,to,w,rev,id));
	}
};
//add bi-directional edge
template<class Weight>
void addBiEdge(graph<Weight> &g, const pair<int,int> &e, Weight w=1, int id=0){
	const int &from = e.first, &to = e.second;
	g._add_edge(from,to,w,g[to].size(),id);
	g._add_edge(to,from,w,g[from].size()-1,id);
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
 
#ifdef DEBUG
#include"graph/graphviz.h"
#endif
//}}}

//{{{ minimumSpanningTree
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
		T.push_back(e);
		total += e.weight;
		visited[e.dst] = true;
		FOR(f, g[e.dst]) if (!visited[f->dst]) Q.push(*f);
	}
	return pair<Weight, Edges>(total, T);
}
//}}}

void solve(){
	Graph G(N);
	REP(i,M){
		addBiEdge(G,{A[i],B[i]},-C[i],i);
	}
	auto p = minimumSpanningTree(G);
	vector<int> v;
	for(auto e:p.second){
		if(e.src!=-1)v.push_back(e.id);
	}
	sort(ALL(v));
//	dump(v.size());
	for(auto i:v){
		cout<<i+1<<endl;
	}
//	cout<<-p.first<<endl;
}

//{{{ main function
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	cin >> M;
	A.resize(M);
	B.resize(M);
	C.resize(M);
	for(int i = 0 ; i < M ; i++){
		cin >> A[i];
		cin >> B[i];
		cin >> C[i];
		A[i]--;B[i]--;
	}
	solve();
	return 0;
}

//}}}

