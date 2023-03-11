/////////start template
#include <bits/stdc++.h>

using namespace std;

void quitAC(){
	cerr<<"Judge: AC"<<endl;
	exit(0);
}
void quitWA(const string message = ""){
	cerr<<"Judge: WA"<<" ( "<<message<<" )"<<endl;
	exit(1);
}

const string header_prefix = "Input                 Output\n----------------------------------";
const string input_prefix  = "                      ";

string input(){
	string s;
	getline(cin,s);
	cerr<<input_prefix<<s<<endl;
	return s;
}

void output(const string &s){
	cerr<<s<<endl;
	cout<<s<<endl;
}

///////////////////end template

typedef long long Int;

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
struct graph:vector<vector<edge<Weight> > >{
	graph(){}
	graph(const int &n):vector<vector<edge<Weight> > >(n){}
	void _add_edge(int from, int to, Weight w, int rev=-1){
//		if((int)this->size() < from + 1)this->resize(from + 1);
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
//}}}
typedef Int Weight;
typedef edge<Weight> Edge;
typedef vector<edge<Weight> > Edges;
typedef graph<Weight> Graph;

int dist(const Graph &g, int u, int v){
	function<int(int,int)> dfs = [&](int u, int p){
		if(u==v)return 0;
		for(auto &&e:g[u]){
			if(e.dst==p)continue;
			int result = dfs(e.dst,u);
			if(result != -1)return result + 1;
		}
		return -1;
	};
	return dfs(u,-1);
}

int main(int argc, char *argv[]){
	//////////////// start template
	ifstream in_s(argv[1]), out_s(argv[2]);
	//////////////// end template
	int out;
	out_s >> out;
	if(out == -1){
		int t;
		cin >> t;
		if(t == out)quitAC();
		else quitWA("-1 is expected but not");
	}
	int N;
	in_s>>N;
	vector<Int> D(N);
	for(int i = 0;i < N;i++)in_s>>D[i];
	Graph g(N);
	for(int i = 0;i < N - 1;i++){
		int u, v;
		cin>>u>>v;
		u--;v--;
		addBiEdge(g,{u,v},1ll);
	}
	for(int u = 0;u < N;u++){
		Int d = 0;
		for(int v = 0;v < N;v++){
			d += dist(g,u,v);
		}
		if(d != D[u]){
			quitWA("invalid distance for node " + to_string(u + 1));
		}
	}
	quitAC();
}

