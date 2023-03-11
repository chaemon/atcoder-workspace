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

const string nl = "\n";

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
	matrix(int a, Weight w=0):vector<vector<Weight> >(a,vector<Weight>(a,w)){}
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

void write(const Matrix &A){
	REP(i,A.size()){
		REP(j,A[0].size()){
			if(A[i][j]==inf<Weight>)cout<<"inf";
			else cout<<A[i][j];
			cout<<"\t";
		}
		cout<<endl;
	}
	cout<<endl;
}

int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);
	int a,b,c,d,e;
	cin>>a>>b>>c>>d>>e;
	unordered_map<string,int> rid, cid, pid;
	vector<vector<int> > road_adj;
	struct Road{
		Weight l;
		int f,src,dst;
		Road(Weight l,int f):l(l),f(f){}
	};
	vector<Road> rinfo;
	REP(i,a){
		string r;
		int l,f;
		cin>>r>>l>>f;
		int ri = rid.size();
		if(f==1){
			r += "SE";
			rid[r] = ri;
			rinfo.emplace_back(l,f);
		}else{
			// bidirection
			rid[r+"SE"] = ri;
			rid[r+"ES"] = ri + 1;
			rinfo.emplace_back(l,f);
			rinfo.emplace_back(l,f);
		}
	}
	vector<vector<pii> > cinfo;
	REP(i,b){
		string c, rin, rout;
		cin>>c>>rin>>rout;
		int ci = cid.size();
		if(cid.find(c)==cid.end())cid[c] = ci, cinfo.emplace_back();
		else ci = cid[c];
		assert(rid.find(rin)!=rid.end());
		assert(rid.find(rout)!=rid.end());
		int ri = rid[rin], ro = rid[rout];
		rinfo[ri].dst = ci;
		rinfo[ro].src = ci;
		cinfo[ci].emplace_back(ri,ro);
	}
	vector<string> ps;
	vector<pii> pinfo;//road_id, distance
	REP(i,c){
		string p, r;
		int s;
		cin>>p>>r>>s;
		ps.push_back(p);
		r += p.substr(4,2);
		int pi = pid.size(), ri = rid[r];
		pid[p] = pi;
		if(p[4]=='S')pinfo.emplace_back(ri,s);//SE
		else pinfo.emplace_back(ri,rinfo[ri].l - s);
	}
	vector<string> ds;
	unordered_map<string,pii> dinfo;//road_id, distance
	REP(i,d){
		string dst, r;
		int u;
		cin>>dst>>r>>u;
		ds.push_back(dst);
		int ri = rid[r+"SE"];
		dinfo[dst] = {ri,u};
	}
	Matrix Car(rid.size(),inf<Weight>), Trolley(cid.size(),inf<Weight>);
//	REP(u,rid.size())Car[u][u] = 0;
	REP(u,cid.size())Trolley[u][u] = 0;
	for(auto &&v:cinfo){
		for(auto &&p:v){
			Car[p.first][p.second] = rinfo[p.second].l;
		}
	}
	for(auto &&p:rinfo){
		Trolley[p.src][p.dst] = min(Trolley[p.src][p.dst],p.l);
		Trolley[p.dst][p.src] = min(Trolley[p.dst][p.src],p.l);
	}
	auto shortestPath = [](Matrix &dist){
		int n = dist.size();
		REP(k, n) REP(i, n) REP(j, n) {
			Weight s = dist[i][k] + dist[k][j];
			if (dist[i][j] > s) {
				dist[i][j] = s;
			}
		}
	};
	shortestPath(Car);
	shortestPath(Trolley);
	auto calcDist = [&](int q, string x, string y){
		if(q==0){
			// car: p -> p
			int xi = pid[x], yi = pid[y];
			int rxi = pinfo[xi].first, ryi = pinfo[yi].first;//road
			const Road &rx = rinfo[rxi], &ry = rinfo[ryi];
			pair<int,Weight> px = {rxi,rx.l - pinfo[xi].second}, py = {ryi,ry.l - pinfo[yi].second};//road, dist
			if(px.first==py.first and px.second >= py.second){
				return px.second - py.second;
			}else{
				return Car[px.first][py.first] + px.second - py.second;
			}
		}else{
			// trolley: d -> p or d
			int r0, r1;
			Weight u0, u1;
			vector<pii> xs, ys;
			{
				int ri = dinfo[x].first, u = dinfo[x].second;
				xs.emplace_back(rinfo[ri].src,u);
				xs.emplace_back(rinfo[ri].dst,rinfo[ri].l - u);
				r0 = ri;
				u0 = u;
			}
			{
				int ri, u;
				if(y[0]=='P'){
					if(y.substr(4,2)=="ES"){
						y[4] = 'S';
						y[5] = 'E';
					}
					int pyi = pid[y];
					ri = pinfo[pyi].first;
					u = pinfo[pyi].second;
				}else{
					ri = dinfo[y].first;
					u = dinfo[y].second;
				}
				ys.emplace_back(rinfo[ri].src, u);
				ys.emplace_back(rinfo[ri].dst, rinfo[ri].l - u);
				r1 = ri;
				u1 = u;
			}
			Weight ans = inf<Weight>;
			for(auto &&px:xs)for(auto &&py:ys){
				ans = min(ans,Trolley[px.first][py.first] + px.second + py.second);
			}
			if(r0==r1){
				ans = min(ans,abs(u0-u1));
			}
			return ans;
		}

	};
	REP(i,e){
		int q;
		string x,y;
		cin>>q>>x>>y;
		cout<<calcDist(q,x,y)<<endl;
	}
	for(auto &&p:ps){
		for(auto &&q:ps){
			cout<<calcDist(0,p,q)<<" ";
		}
		cout<<endl;
	}
	for(auto &&p:ds){
		for(auto &&q:ps){
			cout<<calcDist(1,p,q)<<" ";
		}
		for(auto &&q:ds){
			cout<<calcDist(1,p,q)<<" ";
		}
		cout<<endl;
	}
}

