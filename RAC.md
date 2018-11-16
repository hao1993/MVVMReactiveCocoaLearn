#ReactiveCocoa

- https://draveness.me/index

- `RACSignal` 其实是抽象类 `RACStream` 的子类，在整个 ReactiveObjc 工程中有另一个类 `RACSequence` 也继承自抽象类 `RACStream`：

- ```objectivec
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber>subscriber) {
          [subscriber sendNext:@1];
          [subscriber sendNext:@2];
          [subscriber sendCompleted];
          return [RACDisposable disposableWithBlock:^{
              NSLog(@"dispose");
          }];
      }];
  [signal subscribeNext:^(id  _Nullable x) {
      NSLog(@"%@", x);
  }];
  ```

  RACSignal  信号 

  RACSubscriber  订阅者 

  RACDisposable  〈美口〉使用后随即抛掉的东西（尤指容器等）

  subscribe	认购;认捐，捐赠;签署，题词，署名;订阅，订购

  RACSequence  顺序;[数]数列，序列;	

  RACStream   河流，小河，川，溪

  reactive  反应的;活性的;电抗的

  bind 捆绑;约束;

  monad 单孢体，单细胞生物