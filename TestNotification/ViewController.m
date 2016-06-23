//
//  ViewController.m
//  TestNotification
//
//  Created by 建星 on 16/6/22.
//  Copyright © 2016年 建星. All rights reserved.
//

#import "ViewController.h"
#import "XYNotification.h"
#import "NotificationCenter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册
    [self ybf_registerNotification:abc];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //这里发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"abc" object:nil];
}
//接收通知实现实现
ybf_handleNotification(abc, __notification)
{
    NSLog(@"abc相应了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
