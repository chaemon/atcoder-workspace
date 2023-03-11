// #includes {{{
#pragma GCC optimize ("O3")
#pragma GCC optimize ("unroll-loops")

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
//typedef long double rn;

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

using namespace std;

//using rn = long double;
using rn = __float128;
typedef vector<rn> Vector;
typedef vector<Vector> Matrix;

const rn EPS = 1e-13L;
enum { OPTIMAL, UNBOUNDED, NOSOLUTION, UNKNOWN };
struct two_stage_simplex {
  int N, M, st;
  Matrix a;
  vector<int> s;
  two_stage_simplex(Matrix A, Vector b, const Vector &c)
    : N(A.size()), M(A[0].size()), a(N+2, Vector(M+N+1)), s(N+2), st(UNKNOWN) {
    for(int i = 0;i < N;i++){
        if(b[i] < -EPS){
            b[i] = -b[i];
            for(int j = 0;j < M;j++){
                A[i][j] = -A[i][j];
            }
        }
    }
    for (int j = 0; j < M; ++j) a[N+1][j] = c[j]; // make simplex table
    for (int i = 0; i < N; ++i)
      for (int j = 0; j < M; ++j) a[i+1][j] = A[i][j];
    for (int i = 0; i < N; ++i) a[i+1][M+N] = b[i]; // add helper table
    
    for (int i = 0; i < N; ++i) a[ 0 ][i+M] = 1;
    //for (int i = 0; i < N; ++i) a[ 0 ][i+M] = -1; //change
    
    for (int i = 0; i < N; ++i) a[i+1][i+M] = 1;
    for (int i = 0; i < N; ++i) s[i+1]      = i+M;
    for (int i = 1; i <= N; ++i)
      for (int j = 0; j <= N+M; ++j){
          //a[0][j] += a[i][j];
          a[0][j] -= a[i][j];
      }
    //print();
    st = solve();
  }

  void print(){
    cout<<"============"<<endl;
    for(int i = 0;i < s.size();i++){
        cout<<s[i]<<" ";
    }
    cout<<endl;
    for(int i = 0;i < a.size();i++){
      for(int j = 0;j < a[0].size();j++){
        printf("%.3Lf\t",a[i][j]);
      }
      printf("\n");
    }
    cout<<"============"<<endl;
  }

  int status() const { return st; }
  double solution() const { return -a[0][M]; }
  double solution(Vector &x) const {
    x.resize(M, 0);
    for (int i = 0; i < N; ++i)
      if(s[i + 1] < x.size())
        x[s[i+1]] = a[i+1].back();
    return -a[0][M];
  }
  int solve() {
    M += N; N += 1;
    solve_sub(); // solve stage one
    //print();
    if (solution() > EPS) return NOSOLUTION;
    N -= 1; M -= N;
    swap(a[0], a.back()); a.pop_back(); // modify table
    for (int i = 0; i <= N; ++i) {
      swap(a[i][M], a[i].back());
      a[i].resize(M+1);
    }
    //print();

    return solve_sub(); // solve stage two
  }
  int solve_sub() {
    int p, q;
    while (1) {
      //print();
      for (q = 0; q <= M && a[0][q] >= -EPS; ++q);
      for (p = 0; p <= N && a[p][q] <=  EPS; ++p);
      if (q >= M || p > N) break;
      for (int i = p+1; i < N; ++i) // bland's care for cyclation
        if (a[i][q] > EPS)
          if (a[i][M]/a[i][q] < a[p][M]/a[p][q] ||
             (a[i][M]/a[i][q] == a[p][M]/a[p][q] && s[i] < s[q])) p = i;
      pivot(p, q);
    }
    if (q >= M) return OPTIMAL;
    else        return UNBOUNDED;
  }
  void pivot(int p, int q) {
    for (int j = 0; j <= N; ++j)
      for (int k = M; k >= 0; --k)
        if (j != p && k != q)
          a[j][k] -= a[p][k] * a[j][q] / a[p][q];
    for (int j = 0; j <= N; ++j)
      if (j != p) a[j][q] = 0;
    for (int k = 0; k <= M; ++k)
      if (k != q) a[p][k] = a[p][k]/a[p][q];
    a[p][q] = 1.0L;
    s[p] = q;
  }
};

vector<long long> dx = {1, 1, 0, -1, -1, -1, 0, 1};
vector<long long> dy = {0, 1, 1,  1,  0, -1, -1, -1};

void solve(long long A, long long B, string s){
    vector<int> id;
    for(int i = 0;i < 8;i++){
        if(s[i] == '1')id.push_back(i);
    }
    // min c^T x s.t. Ax = b
    Matrix A0(2, Vector(id.size()));
    Vector b = {rn(A), rn(B)};
    for(int i = 0;i < id.size();i++){
        int j = id[i];
        A0[0][i] = rn(dx[j]);
        A0[1][i] = rn(dy[j]);
    }
    Vector c(id.size(), rn(1));
    auto tss = two_stage_simplex(A0, b, c);
    //cout<<"status: "<<tss.status()<<endl;
    //tss.print();
    if(tss.status() == NOSOLUTION){
        cout<<-1<<endl;
    }else{
        Vector x;
        cout<<(long long)(tss.solution(x) + 0.5L)<<endl;
        vector<long long> ans;
        for(int i = 0;i < id.size();i++){
            ans.push_back((long long)(x[i] + 0.5L));
        }
        long long A0 = 0, B0 = 0;
        for(int i = 0;i < id.size();i++){
            A0 += dx[id[i]] * ans[i];
            B0 += dy[id[i]] * ans[i];
        }
        assert(A0 == A and B0 == B);
    }
}

int main(){
    /*
    {
        Matrix A = {{4.0, 8.0}, {9.0, 6.0}};
        Vector b = {40.0, 54.0}, c = {-2.0, -3.0};
        auto tss = two_stage_simplex(A, b, c);
        cout<<tss.status()<<endl;
        //vec x;
        //cout<<tss.solution(x)<<endl;
        //REP(i, x.size())cout<<x[i]<<" ";
        cout<<tss.solution()<<endl;
        cout<<endl;
        tss.print();
    }
    */
    /*
    {
        Matrix A = {{1.0, 3.0, -1.0, 0.0}, {2.0, 1.0, 0.0, -1.0}};
        Vector b = {4.0, 3.0}, c = {4.0, 1.0, 0.0, 0.0};
        auto tss = two_stage_simplex(A, b, c);
        cout<<tss.status()<<endl;
        Vector x;
        cout<<tss.solution(x)<<endl;
        cout<<"x = ";
        for(int i = 0;i < x.size();i++)cout<<x[i]<<" ";
        cout<<endl;
        tss.print();
    }
    */
    /*
    {
        Matrix A = {{-1.0, -3.0, 1.0, 0.0}, {-2.0, -1.0, 0.0, 1.0}};
        Vector b = {-4.0, -3.0}, c = {4.0, 1.0, 0.0, 0.0};
        auto tss = two_stage_simplex(A, b, c);
        cout<<tss.status()<<endl;
        Vector x;
        cout<<tss.solution(x)<<endl;
        cout<<"x = ";
        for(int i = 0;i < x.size();i++)cout<<x[i]<<" ";
        cout<<endl;
        tss.print();
    }
    */
    /*
    {
        mat A = {
            {1.0, 2.0, 1.0, 0.0}, 
            {2.0, 1.0, 0.0, 1.0}};
        vec b = {6.0, 6.0};
        vec c = {-1.0, -1.0, 0.0, 0.0};
        auto tss = two_stage_simplex(A, b, c);
        cout<<tss.status()<<endl;
        cout<<tss.solution()<<endl;
    }
    */
    //{
    //    Matrix A = {
    //        {1.0, 1.0}};
    //    vector b = {5.0};
    //    vector c = {1.0, 0.0};
    //    auto tss = two_stage_simplex(A, b, c);
    //    cout<<tss.status()<<endl;
    //    cout<<tss.solution()<<endl;
    //    //tss.print();
    //}
    /*
    {
        //Matrix A = {
        //    {2.0, 1.0,-1.0, 0.0, 0.0}, 
        //    {1.0, 1.0, 0.0,-1.0, 0.0}, 
        //    {1.0, 2.0, 0.0, 0.0,-1.0}, 
        //};
        Matrix A = {
            {2.0, 1.0}, 
            {1.0, 1.0}, 
            {1.0, 2.0}, 
        };

        vector b = {8.0, 6.0, 8.0};
        //vector c = {4.0, 3.0, 0.0, 0.0, 0.0};
        vector c = {4.0, 3.0};
        // to maximize
        //REP(i, c.size())c[i] *= -1.0;
        auto tss = two_stage_simplex(A, b, c);
        cout<<tss.status()<<endl;
        cout<<"solution: "<<endl;
        cout<<tss.solution()<<endl;
        //tss.print();
    }
    */

    int T;
    cin >> T;
    for(int i = 0;i < T;i++){
        int A, B;
        string s;
        cin >> A >> B >> s;
        solve(A, B, s);
    }
    //cout<<"Hello World"<<endl;
    return 0;
}
