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

#ifdef MY_DEBUG
#include"print.hpp"
#include"debug.hpp"
#endif
// }}}

Int N;
vector<Int> x;
vector<Int> y;
vector<string> d;
vector<pair<rn,rn> > X(3),Y(3);//index: slope + 1, min, max

using Range = pair<rn,rn>;

Range intersection(const Range &l, const Range &r){
	return {max(l.first,r.first),min(l.second,r.second)};
}

rn quad_min(rn a, rn b, rn c, const Range &r){
	rn vl = a*r.first*r.first + b*r.first + c;
	rn vr = a*r.second*r.second + b*r.second + c;
	rn ret = min(vl,vr);
	if(a>0){
		auto p = - b/(a*2.0L);
		if(r.first<p and p<r.second)ret = min(a*p*p + b*p + c,ret);
	}
	return ret;
}

template<class T, class U>
void update(pair<T,T> &p, const U &x){
	p.first = min(p.first,(T)x);
	p.second = max(p.second,(T)x);
}

rn calc(rn t){
	rn xmin = inf<rn>, xmax = -inf<rn>;
	REP(i,3){
		xmin = min((i - 1) * t + X[i].first, xmin);
		xmax = max((i - 1) * t + X[i].second, xmax);
	}
	rn ymin = inf<rn>, ymax = -inf<rn>;
	REP(i,3){
		ymin = min((i - 1) * t + Y[i].first, ymin);
		ymax = max((i - 1) * t + Y[i].second, ymax);
	}
//	dump(xmin,xmax,ymin,ymax);
	return (xmax - xmin) * (ymax - ymin);
}

void solve(){
	REP(i,3){
		X[i] = {inf<rn>,-inf<rn>};
		Y[i] = {inf<rn>,-inf<rn>};
	}
	REP(i,N){
		if(d[i]=="U"){
			update(X[1],x[i]);
			update(Y[2],y[i]);
		}else if(d[i]=="D"){
			update(X[1],x[i]);
			update(Y[0],y[i]);
		}else if(d[i]=="L"){
			update(Y[1],y[i]);
			update(X[0],x[i]);
		}else if(d[i]=="R"){
			update(Y[1],y[i]);
			update(X[2],x[i]);
		}
	}
	auto get_range = [&](const vector<pair<rn,rn> > &X){
		vector<pair<pair<rn,rn>,pair<rn,rn> > > v;
		REP(i,3)REP(j,3){
			//min: i, max: j
			rn tmin = -inf<rn>, tmax = inf<rn>;
			REP(i1,3){
				if(i==i1)continue;
				rn s = i - i1, xd = X[i1].first - X[i].first;
				if(s>0){
					tmax = min(tmax,xd/s);
				}else{
					tmin = max(tmin,xd/s);
				}
			}
			REP(j1,3){
				if(j==j1)continue;
				rn s = j - j1, xd = X[j1].second - X[j].second;
				if(s>0){
					tmin = max(tmin,xd/s);
				}else{
					tmax = min(tmax,xd/s);
				}
			}
			if(tmax<0)continue;
			else tmin = max(tmin,0.0L);
			if((isfinite(tmin) or isfinite(tmax)) and tmin <= tmax){
				v.push_back({{tmin,tmax},{X[j].second - X[i].first,j-i}});
			}
		}
		sort(ALL(v));
		return v;
	};
	rn ans = inf<rn>;
	auto rx = get_range(X);
	auto ry = get_range(Y);
	REP(i,rx.size()){
		REP(j,ry.size()){
			const Range &r = intersection(rx[i].first,ry[j].first);
			if(r.first>r.second)continue;
			rn a0 = rx[i].second.second, b0 = rx[i].second.first;
			rn a1 = ry[j].second.second, b1 = ry[j].second.first;
			ans = min(ans,quad_min(a0*a1,a0*b1+a1*b0,b0*b1,r));
		}
	}
	cout<<setprecision(12)<<fixed<<ans<<endl;
}

//{{{ main fucnction
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL);

	cin >> N;
	x.assign(N,Int());
	y.assign(N,Int());
	d.assign(N,string());
	for(int i = 0 ; i < N ; i++){
		cin >> x[i];
		cin >> y[i];
		cin >> d[i];
	}
	solve();
	return 0;
}

//}}}

