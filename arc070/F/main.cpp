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

const int INF=0x3f3f3f3f;

typedef long long Int;
typedef unsigned long long uInt;
typedef long double rn;

typedef pair<int,int> pii;

/*
#ifdef MYDEBUG
#include"debug.h"
#include"print.h"
#endif
*/
// }}}

int A,B;

//{{{ Union-Find
struct UnionFind {
	vector<int> data;
	UnionFind(int size) : data(size, -1) { }
	bool unionSet(int x, int y) {
		x = root(x); y = root(y);
		if (x != y) {
			if (data[y] < data[x]) swap(x, y);
			data[x] += data[y]; data[y] = x;
		}
		return x != y;
	}
	bool findSet(int x, int y) {
		return root(x) == root(y);
	}
	int root(int x) {
		int r;
		compress(x,r);
		return r;
	}
	int size(int x) {
		return -data[root(x)];
	}
	void compress(int x,int &r){
		if(data[x]<0){
			r=x;
			return;
		}
		compress(data[x],r);
		data[x]=r;
	}
};
//}}}

int main(){
	cin>>A>>B;
	const int N = A+B;
	if(A<=B){
		cout<<"Impossible"<<endl;
		fflush(stdout);
		return 0;
	}
	/*
	else if(A==0){
		string ans(N,'0');
		cout<<"! "<<ans<<endl;
		fflush(stdout);
		return 0;
	}
	*/
	string ans(N,'?');
	UnionFind uf(N);
	queue<int> q;
	REP(i,N)q.push(i);
	int h;
	int num = 0;
	while(q.size()>1){
//		dump(q.size());
		queue<int> q2;
		while(q.size()>=2){
			int a = q.front();
			q.pop();
			int b = q.front();
			q.pop();
			string r0,r1;
			cout<<"?"<<" "<<a<<" "<<b<<endl;
			fflush(stdout);
			num++;
			cin>>r0;
			cout<<"?"<<" "<<b<<" "<<a<<endl;
			fflush(stdout);
			num++;
			cin>>r1;
			if(r0[0]=='Y' and r1[0]=='Y'){
				uf.unionSet(a,b);
				q2.push(a);
			}
		}
		if(q.size()>0){
			if(q2.size()==0){
//				h = uf.root(q.front());
				break;
			}
			assert(q.size()==1);
			q2.push(q.front());
			q.pop();
		}
		q = q2;
	}
	if(q.size()>0){
		h = uf.root(q.front());
	}
	ans[h] = '1';
	REP(p,N){
		int pr = uf.root(p);
		if(ans[pr]=='?'){
			string result;
			cout<<"? "<<h<<" "<<pr<<endl;
			fflush(stdout);
			num++;
			cin>>result;
			if(result[0]=='Y'){
				ans[pr] = '1';
			}else{
				ans[pr] = '0';
			}
		}
		ans[p] = ans[pr];
	}
	/*
	if(!(num<=2*N)){
		while(1){
			
		}
	}
	*/
	cout<<"!"<<" "<<ans<<endl;
	fflush(stdout);
	return 0;
}

