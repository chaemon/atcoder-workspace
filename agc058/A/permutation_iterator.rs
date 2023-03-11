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

#[derive(Debug)]
struct MyInt(i32);

impl PartialEq for MyInt {
    fn eq(&self, other: &Self) -> bool {
        self.0.eq(&other.0)
    }
}

impl Eq for MyInt {}

impl PartialOrd for MyInt {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        self.0.partial_cmp(&other.0)
    }
}

impl Ord for MyInt {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.0.cmp(&other.0)
    }
}

fn type_of<T>(_: &T) -> &str {
    std::any::type_name::<T>()
}

pub fn main() {
    use perm::{Permutation, PermutationIterator};

    for p in PermutationIterator::new(vec![1, 2, 3]) {
        println!("{:?}", p);
    }

    // Permutation trait によりメソッド呼び出しの形で iterate できる
    // trait 由来のメソッドを使う場合はその trait を use で宣言する必要がある
    // 普段 IDE を使うとはいえコードを読むときにどこから来たものか追いやすくなっていると思う
    // また仮に同じ名前のメソッドが別 trait で提供されることがあっても選択ができる (ただこれはバッドノウハウにもなりえそう)
    for p in vec![4, 5, 6, 7].permutation() {
        println!("{:?}", p);
    }

    let xs = vec![&MyInt(1), &MyInt(2), &MyInt(3)];

    // &T は Clone を実装しているので ok
    for p in xs.permutation() {
        println!("{}, {:?}", type_of(&p), p);
        // println!("{:p}, {:p}, {:p}", p[0], p[1], p[2]);
    }

    let xs = vec![MyInt(1), MyInt(2), MyInt(3)];

    // Iterator<Item=T> は IntoIterator<Item=T> も実装しているので
    for p in xs.iter().permutation() {
        println!("{}, {:?}", type_of(&p), p);
        // println!("{:p}, {:p}, {:p}", p[0], p[1], p[2]);
    }

    // そもそも Vec<T> 自体に IntoIterator<Item=T> が実装されている
    // ただここで欲しいのは &MyFoo なので
    // impl<T, A: Allocator> IntoIterator for Vec<T, A> ではなく
    // impl<'a, T, A: Allocator> IntoIterator for &'a Vec<T, A> を使っている?
    for p in xs.permutation() {
        println!("{}, {:?}", type_of(&p), p);
        // println!("{:p}, {:p}, {:p}", p[0], p[1], p[2]);
    }
}
