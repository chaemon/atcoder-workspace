#[allow(unused_imports)]
use proconio::{input, marker::Chars, source::line::LineSource};

mod perm {
    pub struct PermutationIterator<T: Ord + Clone> {
        li: Vec<T>,
        is_finished: bool,
    }

    impl<T: Ord + Clone> PermutationIterator<T> {
        pub fn new(mut li: Vec<T>) -> PermutationIterator<T> {
            let is_finished = li.is_empty();
            li.sort();
            PermutationIterator { li, is_finished }
        }
    }

    impl<T: Ord + Clone> Iterator for PermutationIterator<T> {
        type Item = Vec<T>;

        // C++ の next_permutation 実装をもとに
        // ref. https://cpprefjp.github.io/reference/algorithm/next_permutation.html
        fn next(&mut self) -> Option<Self::Item> {
            if self.is_finished {
                return None;
            }

            if self.li.len() == 1 {
                self.is_finished = true;
                return Some(self.li.clone());
            }

            let mut i = self.li.len() - 1;
            let res = self.li.clone();

            loop {
                let ii = i;
                i -= 1;
                if self.li[i] < self.li[ii] {
                    let mut j = self.li.len() - 1;
                    while self.li[i] >= self.li[j] {
                        j -= 1;
                    }

                    self.li.swap(i, j);
                    self.li[ii..].reverse();
                    return Some(res);
                }
                if i == 0 {
                    self.li.reverse();
                    self.is_finished = true;
                    return Some(res);
                }
            }
        }
    }

    pub trait Permutation<T: Ord + Clone> {
        fn permutation(self) -> PermutationIterator<T>;
    }

    // Vec<T> に対してのみの実装する
    // impl <T: Ord + Clone> Permutation<T> for Vec<T> {
    //     fn permutation(self) -> PermutationIterator<T> {
    //         PermutationIterator::new(self)
    //     }
    // }

    // IntoIterator を実装するものに対して Permutation を実装する
    impl<T: Ord + Clone, I: IntoIterator<Item = T>> Permutation<T> for I {
        fn permutation(self) -> PermutationIterator<T> {
            PermutationIterator::new(self.into_iter().collect())
        }
    }
}

fn solve(n: usize, p: Vec<usize>) -> Vec<usize> {
    //input! {n: usize, mut p: [usize; 2*n]};

    if n == 1 {
        if p[0] > p[1] {
            println!("1");
            println!("1");
        } else {
            println!("0");
            println!("");
        }
        std::process::exit(0);
    }
    let mut p = p;
    let mut q = p.clone();
    let mut res = vec![];
    for i in 0..2 * n - 2 {
        let (a, b, c) = (q[i], q[i + 1], q[i + 2]);
        if i % 2 == 0 {
            if a > b && a > c {
                q.swap(i, i + 1);
                res.push(i + 1);
            } else if c > b && c > a {
                q.swap(i + 1, i + 2);
                res.push(i + 2);
            }
        } else {
            if a < b && a < c {
                q.swap(i, i + 1);
                res.push(i + 1);
            } else if c < b && c < a {
                q.swap(i + 1, i + 2);
                res.push(i + 2);
            }
        }
    }
    if res.len() <= n {
        println!("{}", res.len());
        for i in 0..res.len() {
            if i > 0 {
                print!(" ");
            }
            print!("{}", res[i]);
        }
        println!("");
        return res;
        //std::process::exit(0);
    }

    let mut res = vec![];
    for i in (2..2 * n).rev() {
        let (a, b, c) = (p[i - 2], p[i - 1], p[i]);
        if i % 2 == 0 {
            if a > b && a > c {
                p.swap(i - 2, i - 1);
                res.push(i - 1);
            } else if c > b && c > a {
                p.swap(i - 1, i);
                res.push(i);
            }
        } else {
            if a < b && a < c {
                p.swap(i - 2, i - 1);
                res.push(i - 1);
            } else if c < b && c < a {
                p.swap(i - 1, i);
                res.push(i);
            }
        }
    }
    println!("{}", res.len());
    for i in 0..res.len() {
        if i > 0 {
            print!(" ");
        }
        print!("{}", res[i]);
    }
    println!("");
    return res;
}

fn main() {
    use perm::Permutation;
    let n: usize = 3;
    let mut v: Vec<usize> = [].to_vec();
    for i in 1..=n * 2 {
        v.push(i)
    }
    for p in v.permutation() {
        println!("{:?}", p);
        let res = solve(n, p);
        assert!(res.len() <= n);
        println!("{:?}", res);
    }
}
