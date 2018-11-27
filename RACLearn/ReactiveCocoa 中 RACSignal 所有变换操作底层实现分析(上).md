### 前言

[地址](https://halfrost.com/reactivecocoa_racsignal_operations1/)

在[上篇文章](https://halfrost.com/reactivecocoa_racsignal/)中，详细分析了RACSignal是创建和订阅的详细过程。看到底层源码实现后，就能发现，ReactiveCocoa这个FRP的库，实现响应式（RP）是用Block闭包来实现的，而并不是用KVC / KVO实现的。

在ReactiveCocoa整个库中，RACSignal占据着比较重要的位置，而RACSignal的变换操作更是整个RACStream流操作核心之一。在上篇文章中也详细分析了bind操作的实现。RACsignal很多变换操作都是基于bind操作来实现的。在开始本篇底层实现分析之前，先简单回顾一下上篇文章中分析的bind函数，这是这篇文章分析的基础。

bind函数可以简单的缩写成下面这样子。

```objectivec
- (RACSignal *)bind:(RACStreamBindBlock (^)(void))block;
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        RACStreamBindBlock bindBlock = block();
        [self subscribeNext:^(id x) {    //(1)
            BOOL stop = NO;
            RACSignal *signal = (RACSignal *)bindBlock(x, &stop); //(2)
            if (signal == nil || stop) {
                [subscriber sendCompleted];
            } else {
                [signal subscribeNext:^(id x) {
                    [subscriber sendNext:x];  //(3)
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                } completed:^{
                
                }];
            }
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
```

当bind变换之后的信号被订阅，就开始执行bind函数中return的block闭包。

1. 在bind闭包中，先订阅原先的信号A。
2. 在订阅原信号A的didSubscribe闭包中进行信号变换，变换中用到的block闭包是外部传递进来的，也就是bind函数的入参。变换结束，得到新的信号B
3. 订阅新的信号B，拿到bind变化之后的信号的订阅者subscriber，对其发送新的信号值。

