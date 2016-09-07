//
//  ViewController.m
//  RACCommandDemo
//
//  Created by Jentle on 16/9/7.
//  Copyright © 2016年 Jentle. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self RACCommand];
//    [self switchToLatest];

}

- (void)RACCommand{
    [self commandFirstUse];
//    [self commandSecondUse];
//    [self commandThirdUse];
}

/**
 *  第一种用法
 */
- (void)commandFirstUse{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    RACSignal *signal = [command execute:@"执行命令"];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //监听事件有没有完成
    [command.executing subscribeNext:^(id x) {
        BOOL isCompleted = ![x integerValue];
        if (isCompleted) {
            NSLog(@"当前正在执行...");
        }else{
            NSLog(@"执行完成/没有执行");
        }
    }];
}

/**
 *  第二种用法
 */
- (void)commandSecondUse{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    
    //一定要在执行命令前
    [command.executionSignals subscribeNext:^(RACSignal *signal) {
        [signal subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    [command execute:@"执行命令"];
}

- (void)commandThirdUse{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // input:执行命令传入参数
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    
    //一定要在执行命令前
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [command execute:@"执行命令"];
}

/**
 *  switchToLatest的用法：获取信号中的信号发送的最新信号
 */
- (void)switchToLatest{
    //信号中的信号
    RACSubject *signalOfSignal = [RACSubject subject];
    //信号
    RACSubject *signal = [RACSubject subject];
    
//    [signalOfSignal subscribeNext:^(RACSubject *signal) {
//        [signal subscribeNext:^(id x) {
//            NSLog(@"%@",x);
//        }];
//    }];
    [signalOfSignal.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [signalOfSignal sendNext:signal];
    [signal sendNext:@"信号..."];
}

@end
