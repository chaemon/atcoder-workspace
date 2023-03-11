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


const string YES = "YES";
const string NO = "NO";

Int N;
Int M;
Int A;
Int B;

vector<string> c;

bool build(){
	while(1){
		/*
		cerr<<N<<" "<<M<<" "<<A<<" "<<B<<endl;
		REP(i,c.size())cerr<<c[i]<<endl;
		cerr<<endl;
		cerr<<endl;
		*/
		if(N<=2){
			if(N==1){
				if(B>0)return false;
				else{
					for(int j = 0;j + 1 < M;j+=2){
						if(A>0)c[0][j] = '<', c[0][j+1] = '>', A--;
					}
					if(A>0)return false;
					else return true;
				}
			}else{
				REP(j,B){
					c[0][j] = '^';
					c[1][j] = 'v';
				}
				for(int j = B;j + 1 < M;j+=2){
					if(A>0)c[0][j] = '<',c[0][j+1] = '>',A--;
					if(A>0)c[1][j] = '<',c[1][j+1] = '>',A--;
				}
				if(A>0)return false;
				else{
					assert(A==0);
					return true;
				}
			}
		}
		if(M<=2){
			if(M==1){
				if(A>0)return false;
				else{
					for(int i = 0;i + 1 < N;i += 2){
						if(B>0){
							c[i][0] = '^';
							c[i][1] = 'v';
							B--;
						}
					}
					if(B>0)return false;
					else{
						assert(B==0);
						return true;
					}
				}
			}else{
				REP(i,A){
					c[i][0] = '<',c[i][1] = '>';
				}
				for(int i = A;i + 1 < N;i+=2){
					if(B>0){
						c[i][0]   = '^';
						c[i+1][0] = 'v';
						B--;
					}
					if(B>0){
						c[i][1]   = '^';
						c[i+1][1] = 'v';
						B--;
					}
				}
				if(B>0)return false;
				else{
					assert(B==0);
					return true;
				}
			}
		}
		bool reductN = false, reductM = false;
		if(N<=M){
			if(A>=N)reductM = true;
			else if(B>=M)reductN = true;
		}else{
			if(B>=M)reductN = true;
			else if(A>=N)reductM = true;
		}
		if(reductM){
			REP(i,N)c[i][M-2] = '<',c[i][M-1] = '>';
			A -= N;
			M -= 2;
			continue;
		}
		if(reductN){
			REP(j,M)c[N-2][j] = '^',c[N-1][j] = 'v';
			B -= M;
			N -= 2;
			continue;
		}
		if(N==3 and M==3){
			//A<=2 and B<=2
			if(A>0){
				c[0][0] = '<',c[0][1] = '>';
				A--;
			}
			if(A>0){
				c[2][1] = '<',c[2][2] = '>';
				A--;
			}
			if(B>0){
				c[1][0] = '^';
				c[2][0] = 'v';
				B--;
			}
			if(B>0){
				c[0][2] = '^';
				c[1][2] = 'v';
				B--;
			}
			return true;
		}else{
			if(N>M){
				REP(i,N){
					if(A>0)c[i][0] = '<', c[i][1] = '>',A--;
				}
				for(int i = 0;i + 1 < N;i += 2){
					for(int j = 2;j < M;j++){
						if(B>0){
							c[i][j]   = '^';
							c[i+1][j] = 'v';
							B--;
						}
					}
				}
			}else{
				REP(j,M){
					if(B>0){
						c[0][j] = '^';
						c[1][j] = 'v';
						B--;
					}
				}
				for(int j = 0;j + 1 < M;j += 2){
					for(int i = 2;i < N;i++){
						if(A>0){
							c[i][j]   = '<',c[i][j+1] = '>';
							A--;
						}
					}
				}
			}
			return true;
		}
	}
}

void solve(){
	if(N%2==1 and M%2==1)assert(false);
	if(N*M<(A+B)*2 or M/2*N<A or N/2*M<B){
		fout<<NO<<endl;
		return;
	}
	c.resize(N);
	REP(i,N)c[i].assign(M,'.');
	bool result = build();
	if(!result){
		fout<<NO<<endl;
	}else{
		fout<<YES<<endl;
		REP(i,c.size())fout<<c[i]<<endl;
	}
}

//{{{ main function
int main(){
	fin >> N;
	fin >> M;
	fin >> A;
	fin >> B;
	solve();
	return 0;
}

//}}}

