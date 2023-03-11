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
#define debug2(x) cerr << #x << " = [";REP(__ind,(x).size()){cerr << (x)[__ind] << ", ";}cerr << "] (L" << __LINE__ << ")" << endl;


typedef long long Int;
typedef unsigned long long uInt;
typedef long double rn;

typedef pair<int,int> pii;
const Int INF=0x3f3f3f3f3f3fll;

/*
#ifdef MYDEBUG
#include"debug.h"
#include"print.h"
#endif
*/
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
			int n;fscanf(file_in,"%d",&n);
			REP(i,n){
				T t;*this>>t;
				v.push_back(t);
			}
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
//}}}
//{{{ Graph
typedef Int Weight;
struct Edge {
	int src, dst, rev;
	Weight weight;
	Edge(int src, int dst, Weight weight=1,int rev=-1) :
		src(src), dst(dst), weight(weight), rev(rev) { }
};
bool operator < (const Edge &e, const Edge &f) {
	return e.weight != f.weight ? e.weight > f.weight : // !!INVERSE!!
		e.src != f.src ? e.src < f.src : e.dst < f.dst;
}
typedef vector<Edge> Edges;
//typedef vector<Edges> Graph;

typedef vector<Weight> Array;
typedef vector<Array> Matrix;

struct Graph:vector<Edges>{
	Graph(){}
	Graph(const int &n){this->assign(n,Edges());}
	//add bi-directional edge
	void addBiEdge(int from ,int to, Weight w=1){
		while(this->size()<max(from,to)+1)this->push_back(Edges());
		this->at(from).push_back(Edge(from,to,w,this->at(to).size()));
		this->at(to).push_back(Edge(to,from,w,this->at(from).size()-1));
	}
	//add directional edge
	void addEdge(int from ,int to, Weight w=1){
		while(this->size()<from+1)this->push_back(Edges());
		this->at(from).push_back(Edge(from,to,w));
	}
};
#ifdef DEBUG
#include"graph/graphviz.h"
#endif
//}}}

//{{{ bellmanford shortest path
struct shortestPath{
	bool result;
	const int n;
	vector<Weight> dist;
	vector<int> prev;
	const Graph &g;
	vector<int> buildPath(const vector<int> &prev, int t) {
		vector<int> path;
		for (int u = t; u >= 0; u = prev[u])
			path.push_back(u);
		reverse(path.begin(), path.end());
		return path;
	}
	Weight operator[](int i){
		return dist[i];
	}
	shortestPath(const Graph &g, int s):g(g),n(g.size()),result(true), dist(n,INF), prev(n,-2){
		dist[s] = 0;
		REP(k, n) REP(i, n) FOR(e,g[i]) {
			if(dist[e->src] == INF) continue;
			Weight d = dist[e->src] + e->weight;
			if (dist[e->dst] > d) {
				dist[e->dst] = d;
				prev[e->dst] = e->src;
				if (k == n-1) {
					dist[e->dst] = -INF;
					result = false;
				}
			}
		}
	}
	void calc_dist(){
		REP(k, n) REP(i, n) FOR(e,g[i]) {
//			Weight d = (dist[e->src]==-INF) ? -INF : dist[e->src] + e->weight;
//			if (dist[e->dst] > d) {
//				dist[e->dst] = d;
//				prev[e->dst] = e->src;
//			}
			if(dist[e->src] == -INF)dist[e->dst] = -INF;
		}
	}
};
//}}}

int main(){
	int N,M;
	fin>>N>>M;
	Graph G(N);
	REP(i,M){
		int a,b,c;
		fin>>a>>b>>c;
		a--;b--;
		G.addEdge(a,b,-c);
	}
	auto s(shortestPath(G,0));
	s.calc_dist();
	if(s[N-1]==-INF){
		fout<<"inf"<<endl;
	}else{
		fout<<-s[N-1]<<endl;
	}
}


