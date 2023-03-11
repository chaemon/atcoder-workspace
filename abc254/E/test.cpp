#include<iostream>
#include<map>
#include<cstdio>

using namespace std;

int main(){
    map<int, int> mp;
    mp[3] = 4;
    mp[5] = 2;
    mp[7] = 9;
    mp.erase(7);
    cout<<mp.end()->first<<endl;
    cout<<mp.end()->second<<endl;
    return 0;
}
