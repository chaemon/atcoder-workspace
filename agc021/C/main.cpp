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

queue<pair<char,char> > Aq, Bq;

const string YES = "YES";
const string NO = "NO";

Int N;
Int M;
Int A;
Int B;

vector<string> c;
vector<vector<bool> > visit;

bool test(int N, int M, int A, int B){
	if(N<0 or M<0 or A<0 or B<0)return false;
	int Amax = M/2*N, Bmax = N/2*M;
	int t = (N*M)/2;
	if(t<A+B or Amax<A or Bmax<B){
		return false;
	}

//	assert((N*M)%2==0);
//	assert((N*M)/2==A+B);
	if((N*M)%4==0){
		if(A%2==0 and B%2==0)return true;
		else return false;
	}else{
		if(N%2==0){
			if(A%2==0)return true;
			else return false;
		}else if(M%2==0){
			if(B%2==0)return true;
			else return false;
		}else{
			assert(false);
		}
	}
}

void build(int N, int M){
	if(N%2==0){
		for(int j = 0;j + 1 < M;j += 2){
			REP(i,N){
				if(!Aq.empty()){
					auto t = Aq.front();
					c[i][j] = t.first, c[i][j+1] = t.second, Aq.pop();
					visit[i][j] = true, visit[i][j+1] = true;
				}
			}
		}
		for(int i = 0;i + 1 < N;i += 2){
			REP(j,M){
				if(!visit[i][j]){
					assert(!Bq.empty());
					auto t = Bq.front();
					c[i][j]   = t.first;
					c[i+1][j] = t.second;
					visit[i][j] = true;
					visit[i+1][j] = true;
					Bq.pop();
				}
			}
		}
	}else{
		//M%2==0
		for(int i = 0;i + 1 < N;i += 2){
			REP(j,M){
				if(!Bq.empty()){
					auto t = Bq.front();
					c[i][j]   = t.first;
					c[i+1][j] = t.second;
					visit[i][j] = true;
					visit[i+1][j] = true;
					Bq.pop();
				}
			}
		}
		for(int j = 0;j + 1 < M;j += 2){
			REP(i,N){
				if(!visit[i][j]){
					assert(!Aq.empty());
					auto t = Aq.front();
					c[i][j] = t.first, c[i][j+1] = t.second;
					visit[i][j] = true;visit[i][j+1] = true;
					Aq.pop();
				}
			}
		}
	}
}

void build31(){
	int i0 = N-3, j0 = M-3;
	pair<char,char> t;
	t = Aq.front();
	c[i0][j0+0] = t.first;c[i0][j0+1] = t.second;
	Aq.pop();
	t = Aq.front();
	c[i0+1][j0+0] = t.first;c[i0+1][j0+1] = t.second;
	Aq.pop();
	t = Aq.front();
	c[i0+2][j0+0] = t.first;c[i0+2][j0+1] = t.second;
	Aq.pop();
	t = Bq.front();
	c[i0][j0+2] = t.first;c[i0+1][j0+2] = t.second;
	Bq.pop();
}

void build22(){
	int i0 = N-3, j0 = M-3;
	pair<char,char> t;
	t = Aq.front();
	c[i0][j0] = t.first;c[i0][j0+1] = t.second;
	Aq.pop();
	t = Aq.front();
	c[i0+2][j0+1] = t.first;c[i0+2][j0+2] = t.second;
	Aq.pop();
	t = Bq.front();
	c[i0+1][j0] = t.first;c[i0+2][j0] = t.second;
	Bq.pop();
	t = Bq.front();
	c[i0][j0+2] = t.first;c[i0+1][j0+2] = t.second;
	Bq.pop();
}

void build13(){
	int i0 = N-3, j0 = M-3;
	pair<char,char> t;
	t = Bq.front();
	c[i0+0][j0] = t.first;c[i0+1][j0] = t.second;
	Bq.pop();
	t = Bq.front();
	c[i0+0][j0+1] = t.first;c[i0+1][j0+1] = t.second;
	Bq.pop();
	t = Bq.front();
	c[i0+0][j0+2] = t.first;c[i0+1][j0+2] = t.second;
	Bq.pop();
	t = Aq.front();
	c[i0+2][j0] = t.first;c[i0+2][j0+1] = t.second;
	Aq.pop();

}

void put_up(){
	for(int i = 0;i < N-3;i+=2){
		REP(j,3){
			auto t = Bq.front();
			c[i][M-3+j]   = t.first;
			c[i+1][M-3+j] = t.second;
			Bq.pop();
		}
	}
}

void put_left(){
	for(int j = 0;j < M-3;j+=2){
		REP(i,3){
			auto t = Aq.front();
			c[N-3+i][j] = t.first;c[N-3+i][j+1] = t.second;
			Aq.pop();
		}
	}
}

void solve(){
	int Amax = M/2*N, Bmax = N/2*M;
	int t = (N*M)/2;
	if(t<A+B or Amax<A or Bmax<B){
		fout<<NO<<endl;
		return;
	}
	if((N*M)%2==0 and t==A+B and !test(N,M,A,B)){
		fout<<NO<<endl;
		return;
	}
	REP(i,A)Aq.push({'<','>'});
	REP(i,B)Bq.push({'^','v'});
	c.resize(N);
	REP(i,N)c[i].assign(M,'.');
	visit.resize(N);
	REP(i,N)visit[i].assign(M,false);
	int rest = t - A - B;
	if((N*M)%4==0){
		// both even
		// Amax, Bmax: even
		if(rest>0 and Aq.size()%2==1){
			Aq.push({'.','.'});
			rest--;
		}
		if(rest>0 and Bq.size()%2==1){
			Bq.push({'.','.'});
			rest--;
		}
		//		assert(rest%2==0);
		while(rest>0){
			if(Aq.size()<Amax){
				Aq.push({'.','.'});
				Aq.push({'.','.'});
			}else if(Bq.size()<Bmax){
				Bq.push({'.','.'});
				Bq.push({'.','.'});
			}
			rest-=2;
		}
	}else if(N%2==0){
		// A: even, B: odd
		// Amax: even, Bmax; odd
		if(rest>0 and Aq.size()%2==1){
			Aq.push({'.','.'});
			rest--;
		}
		if(rest>0 and Bq.size()%2==0){
			Bq.push({'.','.'});
			rest--;
		}
		//		assert(rest%2==0);
		while(rest>0){
			if(Aq.size()<Amax){
				Aq.push({'.','.'});
				Aq.push({'.','.'});
			}else if(Bq.size()<Bmax){
				Bq.push({'.','.'});
				Bq.push({'.','.'});
			}
			rest-=2;
		}
	}else if(M%2==0){
		// A: odd, B: even
		// Bmax: even, Amax: odd
		if(rest>0 and Aq.size()%2==0){
			Aq.push({'.','.'});
			rest--;
		}
		if(rest>0 and Bq.size()%2==1){
			Bq.push({'.','.'});
			rest--;
		}
		//		assert(rest%2==0);
		while(rest>0){
			if(Aq.size()<Amax){
				Aq.push({'.','.'});
				Aq.push({'.','.'});
			}else if(Bq.size()<Bmax){
				Bq.push({'.','.'});
				Bq.push({'.','.'});
			}
			rest-=2;
		}
	}else if(N%2==1 and M%2==1){
		while(rest>0 and Aq.size()<Amax)Aq.push({'.','.'}),rest--;
		REP(i,rest)Bq.push({'.','.'});
	}else{
		assert(false);
	}
	//	assert(rest==0);
	assert(Aq.size()<=Amax and Bq.size()<=Bmax and Aq.size()+Bq.size()==t);
	if(N*M%2==0){
		build(N,M);
	}else{
		if(N==1){
			for(int j = 0;j + 1 < M;j+=2){
				auto t = Aq.front();
				c[0][j] = t.first;c[0][j+1] = t.second;
				Aq.pop();
			}
		}else if(M==1){
			for(int i = 0;i + 1 < N;i+=2){
				auto t = Bq.front();
				c[i][0] = t.first;c[i+1][0] = t.second;
				Bq.pop();
			}
		}else{
			do{
				{
					//A = 3, B = 1
					int A2 = Aq.size() - 3, B2 = Bq.size() - 1;
					if(B2>=(N-3)*3/2 and test(N,M-3,A2,B2-(N-3)*3/2)){
						build31();
						put_up();
						build(N,M-3);
						break;
					}
					if(A2>=(M-3)*3/2 and test(N-3,M,A2-(M-3)*3/2,B2)){
						build31();
						put_left();
						build(N-3,M);
						break;
					}
				}
				{
					//A = 2, B = 2
					int A2 = Aq.size() - 2, B2 = Bq.size() - 2;
					if(B2>=(N-3)*3/2 and test(N,M-3,A2,B2-(N-3)*3/2)){
						build22();
						put_up();
						build(N,M-3);
						break;
					}
					if(A2>=(M-3)*3/2 and test(N-3,M,A2-(M-3)*3/2,B2)){
						build22();
						put_left();
						build(N-3,M);
						break;
					}
				}
				{
					//A = 1, B = 3
					int A2 = Aq.size() - 1, B2 = Bq.size() - 3;
					if(B2>=(N-3)*3/2 and test(N,M-3,A2,B2-(N-3)*3/2)){
						build13();
						put_up();
						build(N,M-3);
						break;
					}
					if(A2>=(M-3)*3/2 and test(N-3,M,A2-(M-3)*3/2,B2)){
						build13();
						put_left();
						build(N-3,M);
						break;
					}
				}
				assert(false);
			}while(0);
		}
	}
	fout<<YES<<endl;
	REP(i,c.size())fout<<c[i]<<endl;
}

void test(){
	N = 10, M = 11, A = 12, B = 43;
	queue<pair<char,char> > Aq, Bq;
	REP(i,A)Aq.push({'<','>'});
	REP(i,B)Bq.push({'^','v'});
	c.resize(N);
	REP(i,N)c[i].assign(M,'.');
	build(N,M);
	REP(i,N)cout<<c[i]<<endl;
}

//{{{ main function
int main(){
	//	test();
	fin >> N;
	fin >> M;
	fin >> A;
	fin >> B;
	solve();
	return 0;
}

//}}}

