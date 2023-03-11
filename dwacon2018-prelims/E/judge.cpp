/////////start template
#include <bits/stdc++.h>

using namespace std;

ofstream log_s("./log");

void quitAC(){
	log_s<<"Judge: AC"<<endl;
	exit(0);
}
void quitWA(const string message = ""){
	log_s<<"Judge: WA"<<" ( "<<message<<" )"<<endl;
	exit(1);
}

const string header_prefix = "Input                 Output\n----------------------------------";
const string input_prefix  = "                      ";

string input(){
	string s;
	getline(cin,s);
	log_s<<input_prefix<<s<<endl;
	return s;
}

void output(const string &s){
	log_s<<s<<endl;
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
//}}}
typedef Int Weight;
typedef edge<Weight> Edge;
typedef vector<edge<Weight> > Edges;
typedef graph<Weight> Graph;

void output(int n){
	stringstream ss;
	ss<<n;
	output(ss.str());
}

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
	log_s<<header_prefix<<endl;
	ifstream in_s_2(argv[1]);
	while(in_s_2){
		string s;
		getline(in_s_2,s);
		cout<<s<<endl;
		log_s<<s<<endl;
	}
	ifstream in_s(argv[1]), out_s(argv[2]);
	//////////////// end template
	int N, Q;
	in_s>>N>>Q;
	Graph G(N);
	for(int i = 0;i < N - 1;i++){
		int a,b;
		in_s >> a >> b;
		a--;b--;
		addBiEdge(G,{a,b});
	}
	int home;
	out_s >> home;
	home--;
	int ct = 0;
	while(1){
		string line = input();
		stringstream ss(line);
		char q;
		ss>>q;
		if(q=='?'){
			ct++;
			if(ct>Q)quitWA("too many queries");
			int u, v;
			ss>>u>>v;
			u--;v--;
			int du = dist(G,u,home), dv = dist(G,v,home);
			if(du<dv)output(u + 1);
			else if(du>dv)output(v + 1);
			else output(0);
		}else if(q=='!'){
			int u;
			ss>>u;
			u--;
			if(u == home){
				quitAC();
			}else{
				quitWA("incorrect output");
			}
		}
	}
}

