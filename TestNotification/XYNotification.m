//
//  XYNotification.m
//  TestNotification
//
//  Created by 建星 on 16/6/22.
//  Copyright © 2016年 建星. All rights reserved.
//

#import "XYNotification.h"
#import <objc/runtime.h>
#import <objc/message.h>
//Objective-C叫传递消息。
//objc_msgSend函数一旦找到应该调用的方法实现之后，就会“跳转过去”。
void (*XYNotification_action1)(id, SEL, id) = (void (*)(id, SEL, id))objc_msgSend;


@interface XYNotification ()

@property(nonatomic,weak)id target;
@property(nonatomic,assign)SEL selector;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,weak)id sender;
@property(nonatomic,strong)id userInfo;

@end

@implementation XYNotification

-(instancetype)initWithName:(NSString *)name
                     sender:(id)sender
                      target:(id)taget selector:(SEL)selector
{
    self = [super init];
    if (self) {
        _name = name;
        _sender = sender;
        _target = taget;
        _selector = selector;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)                                                            name:name                                                            object:sender];
    }
    
    return self;
}

-(void)handleNotification:(NSNotification *)notification
{
    (_target && _selector) ? XYNotification_action1(_target, _selector, notification) : nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil];
}

@end

@implementation NSObject (XYNotification)

ybf_staticConstString(NSObject_notifications)

-(id)ybf_notifications
{
    // 获取相关联的对象时使用Objective-C函数objc_getAssociatedObject
    
    return objc_getAssociatedObject(self, NSObject_notifications) ?: ({
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        
        //创建关联要使用Objective-C的运行时函数：objc_setAssociatedObject来把一个对象与另一个对象进行关联。
        //4个参数分别是（源对象，关键字，关联对象，关联策略）。
        
        objc_setAssociatedObject(self, NSObject_notifications, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        dic;
    });
}

-(void)ybf_registerNotification:(const char *)name
{
    NSString *str = [NSString stringWithUTF8String:name];
    SEL aSel = NSSelectorFromString([NSString stringWithFormat:@"__ybf_handleNotification_%@:",str]);
    if ([self respondsToSelector:aSel]) {
        [self notificationWihtName:name target:self selector:aSel];
        return;
    }
}

- (void)notificationWihtName:(const char *)name target:(id)target selector:(SEL)selector
{
    NSString *str = [NSString stringWithUTF8String:name];
    XYNotification *notification = [[XYNotification alloc] initWithName:str sender:nil target:target selector:selector];
    
    NSString *key = [NSString stringWithFormat:@"%@", str];
    [self.ybf_notifications setObject:notification forKey:key];
}

- (void)ybf_postNotification:(const char *)name userInfo:(id)userInfo
{
    NSString *str = [NSString stringWithUTF8String:name];
    [[NSNotificationCenter defaultCenter] postNotificationName:str object:self userInfo:userInfo];
}

- (void)ybf_unregisterNotification:(const char *)name
{
    NSString *key = [NSString stringWithFormat:@"%s", name];
    [self.ybf_notifications removeObjectForKey:key];
}

- (void)ybf_unregisterAllNotification
{
    [self.ybf_notifications removeAllObjects];
}
@end
