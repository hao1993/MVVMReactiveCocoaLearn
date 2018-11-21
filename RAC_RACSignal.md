# ReactiveCocoa 中 RACSignal 是如何发送信号的

#### 目录-<https://halfrost.com/reactivecocoa_racsignal/>

- 1.什么是ReactiveCocoa？
- 2.RAC中的核心RACSignal发送与订阅流程
- 3.RACSignal操作的核心bind实现
- 4.RACSignal基本操作concat和zipWith实现
- 5.最后

#### 一. 什么是ReactiveCocoa？

RAC具有函数式编程(FP)和响应式编程(RP)的特性。

ReactiveCocoa 的宗旨是Streams of values over time ，随着时间变化而不断流动的数据流。

ReactiveCocoa 主要解决了以下这些问题：

- UI数据绑定

UI控件通常需要绑定一个事件，RAC可以很方便的绑定任何数据流到控件上。

- 用户交互事件绑定

RAC为可交互的UI控件提供了一系列能发送Signal信号的方法。这些数据流会在用户交互中相互传递。

- 解决状态以及状态之间依赖过多的问题

有了RAC的绑定之后，可以不用在关心各种复杂的状态，isSelect，isFinish……也解决了这些状态在后期很难维护的问题。

- 消息传递机制的大统一

OC中编程原来消息传递机制有以下几种：Delegate，Block Callback，Target-Action，Timers，KVO，objc上有一篇关于OC中这5种消息传递方式改如何选择的文章[Communication Patterns](https://www.objccn.io/issue-7-4/)，推荐大家阅读。现在有了RAC之后，以上这5种方式都可以统一用RAC来处理。

#### 二. RAC中的核心RACSignal

ReactiveCocoa 中最核心的概念之一就是信号RACStream。RACStream中有两个子类——RACSignal 和 RACSequence。本文先来分析RACSignal。

```objectivec
RACSignal *signal = [RACSignal createSignal:
                     ^RACDisposable *(id<RACSubscriber> subscriber)
{
    [subscriber sendNext:@1];
    [subscriber sendNext:@2];
    [subscriber sendNext:@3];
    [subscriber sendCompleted];
    return [RACDisposable disposableWithBlock:^{
        NSLog(@"signal dispose");
    }];
}];
RACDisposable *disposable = [signal subscribeNext:^(id x) {
    NSLog(@"subscribe value = %@", x);
} error:^(NSError *error) {
    NSLog(@"error: %@", error);
} completed:^{
    NSLog(@"completed");
}];

[disposable dispose];
```

这是一个RACSignal被订阅的完整过程。被订阅的过程中，究竟发生了什么？

```objectivec
+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe {
 return [RACDynamicSignal createSignal:didSubscribe];
}
```

RACSignal调用createSignal的时候，会调用RACDynamicSignal的createSignal的方法。

RACDynamicSignal是RACSignal的子类。createSignal后面的参数是一个block。

```objectivec
(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
```

block的返回值是RACDisposable类型，block名叫didSubscribe。block的唯一一个参数是id类型的subscriber，这个subscriber是必须遵循RACSubscriber协议的。

RACSubscriber是一个协议，其下有以下4个协议方法：

```objectivec
@protocol RACSubscriber <NSObject>
@required

- (void)sendNext:(id)value;
- (void)sendError:(NSError *)error;
- (void)sendCompleted;
- (void)didSubscribeWithDisposable:(RACCompoundDisposable *)disposable;

@end
```

所以新建Signal的任务就全部落在了RACSignal的子类RACDynamicSignal上了。

```objectivec
@interface RACDynamicSignal ()
// The block to invoke for each subscriber.
@property (nonatomic, copy, readonly) RACDisposable * (^didSubscribe)(id<RACSubscriber> subscriber);
@end
```

RACDynamicSignal这个类很简单，里面就保存了一个名字叫didSubscribe的block。

```objectivec
+ (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe {
     RACDynamicSignal *signal = [[self alloc] init];
     signal->_didSubscribe = [didSubscribe copy];
     return [signal setNameWithFormat:@"+createSignal:"];
}
```

这个方法中新建了一个RACDynamicSignal对象signal，并把传进来的didSubscribe这个block保存进刚刚新建对象signal里面的didSubscribe属性中。最后再给signal命名+createSignal:。

```objectivec
- (instancetype)setNameWithFormat:(NSString *)format, ... {
 if (getenv("RAC_DEBUG_SIGNAL_NAMES") == NULL) return self;

   NSCParameterAssert(format != nil);

   va_list args;
   va_start(args, format);

   NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
   va_end(args);

   self.name = str;
   return self;
}
```

setNameWithFormat是RACStream里面的方法，由于RACDynamicSignal继承自RACSignal，所以它也能调用这个方法。

RACSignal的block就这样被保存起来了，那什么时候会被执行呢？

================================

block闭包在订阅的时候才会被“释放”出来。

RACSignal调用subscribeNext方法，返回一个RACDisposable。

```objectivec
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock completed:(void (^)(void))completedBlock {
   NSCParameterAssert(nextBlock != NULL);
   NSCParameterAssert(errorBlock != NULL);
   NSCParameterAssert(completedBlock != NULL);
 
   RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock error:errorBlock completed:completedBlock];
   return [self subscribe:o];
}
```

在这个方法中会新建一个RACSubscriber对象，并传入nextBlock，errorBlock，completedBlock。

```objectivec
@interface RACSubscriber ()

// These callbacks should only be accessed while synchronized on self.
@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^completed)(void);
@property (nonatomic, strong, readonly) RACCompoundDisposable *disposable;

@end
```

RACSubscriber这个类很简单，里面只有4个属性，分别是nextBlock，errorBlock，completedBlock和一个RACCompoundDisposable信号。

```objectivec
+ (instancetype)subscriberWithNext:(void (^)(id x))next error:(void (^)(NSError *error))error completed:(void (^)(void))completed {
 RACSubscriber *subscriber = [[self alloc] init];

   subscriber->_next = [next copy];
   subscriber->_error = [error copy];
   subscriber->_completed = [completed copy];

   return subscriber;
}
```

subscriberWithNext方法把传入的3个block都保存分别保存到自己对应的block中。

RACSignal调用subscribeNext方法，最后return的时候，会调用[self subscribe:o]，这里实际是调用了RACDynamicSignal类里面的subscribe方法。

```objectivec
- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
 NSCParameterAssert(subscriber != nil);

   RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
   subscriber = [[RACPassthroughSubscriber alloc] initWithSubscriber:subscriber signal:self disposable:disposable];

   if (self.didSubscribe != NULL) {
      RACDisposable *schedulingDisposable = [RACScheduler.subscriptionScheduler schedule:^{
      RACDisposable *innerDisposable = self.didSubscribe(subscriber);
      [disposable addDisposable:innerDisposable];
  }];

    [disposable addDisposable:schedulingDisposable];
 }
 
 return disposable;
}
```

RACDisposable有3个子类，其中一个就是RACCompoundDisposable。

```objectivec
@interface RACCompoundDisposable : RACDisposable
+ (instancetype)compoundDisposable;
+ (instancetype)compoundDisposableWithDisposables:(NSArray *)disposables;
- (void)addDisposable:(RACDisposable *)disposable;
- (void)removeDisposable:(RACDisposable *)disposable;
@end
```

RACCompoundDisposable虽然是RACDisposable的子类，但是它里面可以加入多个RACDisposable对象，在必要的时候可以一口气都调用dispose方法来销毁信号。当RACCompoundDisposable对象被dispose的时候，也会自动dispose容器内的所有RACDisposable对象。

RACPassthroughSubscriber是一个私有的类。

```objectivec
@interface RACPassthroughSubscriber : NSObject <RACSubscriber>
@property (nonatomic, strong, readonly) id<RACSubscriber> innerSubscriber;
@property (nonatomic, unsafe_unretained, readonly) RACSignal *signal;
@property (nonatomic, strong, readonly) RACCompoundDisposable *disposable;
- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber signal:(RACSignal *)signal disposable:(RACCompoundDisposable *)disposable;
@end
```

RACPassthroughSubscriber类就只有这一个方法。目的就是为了把所有的信号事件从一个订阅者subscriber传递给另一个还没有disposed的订阅者subscriber。

RACPassthroughSubscriber类中保存了3个非常重要的对象，RACSubscriber，RACSignal，RACCompoundDisposable。RACSubscriber是待转发的信号的订阅者subscriber。RACCompoundDisposable是订阅者的销毁对象，一旦它被disposed了，innerSubscriber就再也接受不到事件流了。

这里需要注意的是内部还保存了一个RACSignal，并且它的属性是unsafe_unretained。这里和其他两个属性有区别， 其他两个属性都是strong的。这里之所以不是weak，是因为引用RACSignal仅仅只是一个DTrace probes动态跟踪技术的探针。如果设置成weak，会造成没必要的性能损失。所以这里仅仅是unsafe_unretained就够了。

```objectivec
- (instancetype)initWithSubscriber:(id<RACSubscriber>)subscriber signal:(RACSignal *)signal disposable:(RACCompoundDisposable *)disposable {
   NSCParameterAssert(subscriber != nil);

   self = [super init];
   if (self == nil) return nil;

   _innerSubscriber = subscriber;
   _signal = signal;
   _disposable = disposable;

   [self.innerSubscriber didSubscribeWithDisposable:self.disposable];
   return self;
}
```

回到RACDynamicSignal类里面的subscribe方法中，现在新建好了RACCompoundDisposable和RACPassthroughSubscriber对象了。

```objectivec
if (self.didSubscribe != NULL) {
  RACDisposable *schedulingDisposable = [RACScheduler.subscriptionScheduler schedule:^{
   RACDisposable *innerDisposable = self.didSubscribe(subscriber);
   [disposable addDisposable:innerDisposable];
  }];

  [disposable addDisposable:schedulingDisposable];
 }
```

RACScheduler.subscriptionScheduler是一个全局的单例。

```objectivec
+ (instancetype)subscriptionScheduler {
   static dispatch_once_t onceToken;
   static RACScheduler *subscriptionScheduler;
   dispatch_once(&onceToken, ^{
    subscriptionScheduler = [[RACSubscriptionScheduler alloc] init];
   });

   return subscriptionScheduler;
}
```

RACScheduler再继续调用schedule方法。

```objectivec
- (RACDisposable *)schedule:(void (^)(void))block {
   NSCParameterAssert(block != NULL);
   if (RACScheduler.currentScheduler == nil) return [self.backgroundScheduler schedule:block];
   block();
   return nil;
}
```

```objectivec
+ (BOOL)isOnMainThread {
 return [NSOperationQueue.currentQueue isEqual:NSOperationQueue.mainQueue] || [NSThread isMainThread];
}

+ (instancetype)currentScheduler {
 RACScheduler *scheduler = NSThread.currentThread.threadDictionary[RACSchedulerCurrentSchedulerKey];
 if (scheduler != nil) return scheduler;
 if ([self.class isOnMainThread]) return RACScheduler.mainThreadScheduler;

 return nil;
}
```

在取currentScheduler的过程中，会判断currentScheduler是否存在，和是否在主线程中。如果都没有，那么就会调用后台backgroundScheduler去执行schedule。

schedule的入参就是一个block，执行schedule的时候会去执行block。也就是会去执行：

```objectivec
RACDisposable *innerDisposable = self.didSubscribe(subscriber);
   [disposable addDisposable:innerDisposable];
```

这两句关键的语句。之前信号里面保存的block就会在此处被“释放”执行。self.didSubscribe(subscriber)这一句就执行了信号保存的didSubscribe闭包。

在didSubscribe闭包中有sendNext，sendError，sendCompleted，执行这些语句会分别调用RACPassthroughSubscriber里面对应的方法。

```objectivec
- (void)sendNext:(id)value {
 if (self.disposable.disposed) return;
 if (RACSIGNAL_NEXT_ENABLED()) {
  RACSIGNAL_NEXT(cleanedSignalDescription(self.signal), cleanedDTraceString(self.innerSubscriber.description), cleanedDTraceString([value description]));
 }
 [self.innerSubscriber sendNext:value];
}

- (void)sendError:(NSError *)error {
 if (self.disposable.disposed) return;
 if (RACSIGNAL_ERROR_ENABLED()) {
  RACSIGNAL_ERROR(cleanedSignalDescription(self.signal), cleanedDTraceString(self.innerSubscriber.description), cleanedDTraceString(error.description));
 }
 [self.innerSubscriber sendError:error];
}

- (void)sendCompleted {
 if (self.disposable.disposed) return;
 if (RACSIGNAL_COMPLETED_ENABLED()) {
  RACSIGNAL_COMPLETED(cleanedSignalDescription(self.signal), cleanedDTraceString(self.innerSubscriber.description));
 }
 [self.innerSubscriber sendCompleted];
}
```

这个时候的订阅者是RACPassthroughSubscriber。RACPassthroughSubscriber里面的innerSubscriber才是最终的实际订阅者，RACPassthroughSubscriber会把值再继续传递给innerSubscriber。

```objectivec
- (void)sendNext:(id)value {
 @synchronized (self) {
  void (^nextBlock)(id) = [self.next copy];
  if (nextBlock == nil) return;

  nextBlock(value);
 }
}

- (void)sendError:(NSError *)e {
 @synchronized (self) {
  void (^errorBlock)(NSError *) = [self.error copy];
  [self.disposable dispose];

  if (errorBlock == nil) return;
  errorBlock(e);
 }
}

- (void)sendCompleted {
 @synchronized (self) {
  void (^completedBlock)(void) = [self.completed copy];
  [self.disposable dispose];

  if (completedBlock == nil) return;
  completedBlock();
 }
}
```

innerSubscriber是RACSubscriber，调用sendNext的时候会先把自己的self.next闭包copy一份，再调用，而且整个过程还是线程安全的，用@synchronized保护着。最终订阅者的闭包在这里被调用。

sendError和sendCompleted也都是同理。

总结一下：

1. RACSignal调用subscribeNext方法，新建一个RACSubscriber。
2. 新建的RACSubscriber会copy，nextBlock，errorBlock，completedBlock存在自己的属性变量中。
3. RACSignal的子类RACDynamicSignal调用subscribe方法。
4. 新建RACCompoundDisposable和RACPassthroughSubscriber对象。RACPassthroughSubscriber分别保存对RACSignal，RACSubscriber，RACCompoundDisposable的引用，注意对RACSignal的引用是unsafe_unretained的。
5. RACDynamicSignal调用didSubscribe闭包。先调用RACPassthroughSubscriber的相应的sendNext，sendError，sendCompleted方法。
6. RACPassthroughSubscriber再去调用self.innerSubscriber，即RACSubscriber的nextBlock，errorBlock，completedBlock。注意这里调用同样是先copy一份，再调用闭包执行。

#### 三. RACSignal操作的核心bind实现

在RACSignal的源码里面包含了两个基本操作，concat和zipWith。不过在分析这两个操作之前，先来分析一下更加核心的一个函数，bind操作。

先来说说bind函数的作用：

1. 会订阅原始的信号。
2. 任何时刻原始信号发送一个值，都会绑定的block转换一次。
3. 一旦绑定的block转换了值变成信号，就立即订阅，并把值发给订阅者subscriber。
4. 一旦绑定的block要终止绑定，原始的信号就complete。
5. 当所有的信号都complete，发送completed信号给订阅者subscriber。
6. 如果中途信号出现了任何error，都要把这个错误发送给subscriber

```objectivec
- (RACSignal *)bind:(RACStreamBindBlock (^)(void))block {
 NSCParameterAssert(block != NULL);

 return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
  RACStreamBindBlock bindingBlock = block();

  NSMutableArray *signals = [NSMutableArray arrayWithObject:self];

  RACCompoundDisposable *compoundDisposable = [RACCompoundDisposable compoundDisposable];

  void (^completeSignal)(RACSignal *, RACDisposable *) = ^(RACSignal *signal, RACDisposable *finishedDisposable) { /*这里暂时省略*/ };
  void (^addSignal)(RACSignal *) = ^(RACSignal *signal) { /*这里暂时省略*/ };

  @autoreleasepool {
   RACSerialDisposable *selfDisposable = [[RACSerialDisposable alloc] init];
   [compoundDisposable addDisposable:selfDisposable];

   RACDisposable *bindingDisposable = [self subscribeNext:^(id x) {
    // Manually check disposal to handle synchronous errors.
    if (compoundDisposable.disposed) return;

    BOOL stop = NO;
    id signal = bindingBlock(x, &stop);

    @autoreleasepool {
     if (signal != nil) addSignal(signal);
     if (signal == nil || stop) {
      [selfDisposable dispose];
      completeSignal(self, selfDisposable);
     }
    }
   } error:^(NSError *error) {
    [compoundDisposable dispose];
    [subscriber sendError:error];
   } completed:^{
    @autoreleasepool {
     completeSignal(self, selfDisposable);
    }
   }];

   selfDisposable.disposable = bindingDisposable;
  }

  return compoundDisposable;
 }] setNameWithFormat:@"[%@] -bind:", self.name];
}
```

为了弄清楚bind函数究竟做了什么，写出测试代码:

```objectivec
RACSignal *signal = [RACSignal createSignal:
                         ^RACDisposable *(id<RACSubscriber> subscriber)
    {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal dispose");
        }];
    }];
    
    RACSignal *bindSignal = [signal bind:^RACStreamBindBlock{
        return ^RACSignal *(NSNumber *value, BOOL *stop){
            value = @(value.integerValue * 2);
            return [RACSignal return:value];
        };
    }];
    
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"subscribe value = %@", x);
    }];
```

由于前面第一章节详细讲解了RACSignal的创建和订阅的全过程，这个也为了方法讲解，创建RACDynamicSignal，RACCompoundDisposable，RACPassthroughSubscriber这些都略过，这里着重分析一下bind的各个闭包传递创建和订阅的过程。

为了防止接下来的分析会让读者看晕，这里先把要用到的block进行编号

```objectivec
RACSignal *signal = [RACSignal createSignal:
                         ^RACDisposable *(id<RACSubscriber> subscriber)
    {
        // block 1
    }

    RACSignal *bindSignal = [signal bind:^RACStreamBindBlock{
        // block 2
        return ^RACSignal *(NSNumber *value, BOOL *stop){
            // block 3
        };
    }];

    [bindSignal subscribeNext:^(id x) {
        // block 4
    }];

- (RACSignal *)bind:(RACStreamBindBlock (^)(void))block {
        // block 5
    return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        // block 6
        RACStreamBindBlock bindingBlock = block();
        NSMutableArray *signals = [NSMutableArray arrayWithObject:self];
        
        void (^completeSignal)(RACSignal *, RACDisposable *) = ^(RACSignal *signal, RACDisposable *finishedDisposable) {
        // block 7
        };
        
        void (^addSignal)(RACSignal *) = ^(RACSignal *signal) {
        // block 8
            RACDisposable *disposable = [signal subscribeNext:^(id x) {
            // block 9
            }];
        };
        
        @autoreleasepool {
            RACDisposable *bindingDisposable = [self subscribeNext:^(id x) {
                // block 10
                id signal = bindingBlock(x, &stop);
                
                @autoreleasepool {
                    if (signal != nil) addSignal(signal);
                    if (signal == nil || stop) {
                        [selfDisposable dispose];
                        completeSignal(self, selfDisposable);
                    }
                }
            } error:^(NSError *error) {
                [compoundDisposable dispose];
                [subscriber sendError:error];
            } completed:^{
                @autoreleasepool {
                    completeSignal(self, selfDisposable);
                }
            }];
        }
        return compoundDisposable;
    }] ;
}
```

