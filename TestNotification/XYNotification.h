//
//  XYNotification.h
//  TestNotification
//
//  Created by 建星 on 16/6/22.
//  Copyright © 2016年 建星. All rights reserved.
//
// 定义静态常量字符串
#define ybf_staticConstString(__string)               static const char * __string = #__string;

#define ybf_def_notification_name( __name)            ybf_staticConstString( __name )

#define ybf_handleNotification(__name,__notification)\
        - (void)__ybf_handleNotification_##__name:(NSNotification *)__notification

#import <Foundation/Foundation.h>


@interface XYNotification : NSObject

@end

@interface NSObject (XYNotification)

@property(nonatomic,readonly,strong)NSMutableDictionary *ybf_notifications;

-(void)ybf_registerNotification:(const char *)name;

-(void)ybf_unregisterNotification:(const char *)name;
-(void)ybf_unregisterAllNotification;

-(void)ybf_postNotification:(const char *)name userInfo:(id)userInfo;

@end
