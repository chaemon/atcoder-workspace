import java.io.*;
import java.util.*;

class Main {

    // Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
    public static void main(String[] args) throws Exception {
        final Scanner sc = new Scanner(System.in);
        long N;
        N = sc.nextLong();
        long[] a = new long[(int)(N)];
        for(int i = 0 ; i < N ; i++){
                a[i] = sc.nextLong();
        }
        long[] b = new long[(int)(N)];
        for(int i = 0 ; i < N ; i++){
                b[i] = sc.nextLong();
        }
        solve(N, a, b);
    }

    static void solve(long N, long[] a, long[] b){

    }
}
