// #includes {{{
#include <bits/stdc++.h>
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

/*
#ifdef MYDEBUG
#include"debug.h"
#include"print.h"
#endif
*/
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
 
typedef int Weight;
typedef edge<Weight> Edge;
typedef vector<edge<Weight> > Edges;
typedef graph<Weight> Graph;
typedef matrix<Weight> Matrix;
 
#ifdef DEBUG
#include"graph/graphviz.h"
#endif
//}}}

Int N;
vector<Int> D;
Graph G;

Int dfs(int u,int level = 0,int p = -1){
	Int ret = level;
	for(auto &&e:G[u]){
		if(e.dst==p)continue;
		ret += dfs(e.dst,level+1,u);
	}
	return ret;
}

void solve(){
	vector<pii> e;
	vector<pair<Int,int> > vp;
	REP(i,D.size()){
		vp.push_back({D[i],i});
	}
	sort(ALL(vp));
	reverse(ALL(vp));
	map<Int,pair<int,int>> mp;//id, num of child
	REP(u,D.size()){
		mp[D[u]] = {u,1};
	}
	REP(t,D.size()-1){
		int i = vp[t].second;
		Int d = D[i];
		auto x = mp[d];
		Int d2 = d - (N - 2*x.second);
		auto it = mp.find(d2);
		if(it==mp.end()){
			cout<<-1<<endl;
			return;
		}
		it->second.second+=x.second;
		e.push_back({mp[d].first,it->second.first});
	}
	G.assign(N,Edges());
	for(auto &&p:e){
		addBiEdge(G,{p.first,p.second});
	}
	int umin = vp[D.size()-1].second;
	Int k = dfs(umin);
	if(k!=D[umin]){
		cout<<-1<<endl;
		return;
	}
	REP(i,e.size()){
		cout<<e[i].first+1<<" "<<e[i].second+1<<endl;
	}
	return;
}

//{{{ main function
int main(){	
	cin >> N;
	D.assign(N-1+1,Int());
	for(int i = 0 ; i <= N-1 ; i++){
		cin >> D[i];
	}
	solve();
	return 0;
}
//}}}

