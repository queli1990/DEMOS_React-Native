//
//  CalendarManager.m
//  IOS_RN_DEMO
//
//  Created by Holy on 17/1/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CalendarManager.h"
#import <React/RCTConvert.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>


@implementation CalendarManager

@synthesize bridge = _bridge;

//默认名称
RCT_EXPORT_MODULE()

//对外提供方法
RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
  NSLog(@"Pretending to create an event %@ at %@",name,location);
}

//对外提供方法,为了掩饰时间格式化secondsSinceUnixEpoch
RCT_EXPORT_METHOD(addEventMore:(NSString *)name location:(NSString *)location data:(NSNumber *)secondsSinceUnixEpoch)
{
  NSData *data = [RCTConvert NSData:secondsSinceUnixEpoch];
}

//对外提供方法,为了演示时间格式化ISO8601DateString
RCT_EXPORT_METHOD(addEventMoreTwo:(NSString *)name location:(NSString *)location date:(NSString *)ISO8601DateString)
{
  NSDate *date = [RCTConvert NSDate:ISO8601DateString];
}

//对外提供调用方法,为了演示事件时间格式化 自动类型转换
RCT_EXPORT_METHOD(addEventMoreDate:(NSString *)name location:(NSString *)location date:(NSDate *)date)
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  NSLog(@"获取的事件信息:%@,地点:%@,时间:%@",name,location,[formatter stringFromDate:date]);
}

//对外提供调用方法,为了演示事件时间格式化 传入属性字段
RCT_EXPORT_METHOD(addEventMoreDetails:(NSString *)name details:(NSDictionary *)dictionry)
{
  NSString *location = [RCTConvert NSString:dictionry[@"location"]];
  NSDate *time = [RCTConvert NSDate:dictionry[@"time"]];
  NSString *description = [RCTConvert NSString:dictionry[@"description"]];
  NSLog(@"获取的事件信息:%@,地点:%@,时间:%@,备注信息：%@",name,location,time,description);
}

#pragma mark  回调数据给RN，传回一个数组
RCT_EXPORT_METHOD(findEvents:(RCTResponseSenderBlock)callback)
{
  NSArray *events = @[@"张三",@"李四",@"王五"];
  callback(@[[NSNull null],events]);
}

#pragma mark   promise对象
RCT_REMAP_METHOD(findEventsPromise,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject
                 )
{
  NSArray *events = @[@"张三",@"李四",@"王五"];
  if (events) {
    resolve(events);
  }else {
    NSError *error = [NSError errorWithDomain:@"我是promise回调的错误信息。。。" code:101 userInfo:nil];
    reject(@"no_events",@"There were no events",error);
  }
}


//演示Thread使用
RCT_EXPORT_METHOD(doSomethingExpensive:(NSString *)param callback:(RCTResponseSenderBlock)callback)
{
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //后台执行的耗时操作
    callback(@[[NSNull null],@"耗时操作执行完成..."]);
  });
}

//进行设置封装敞亮给JavaScript进行调用
- (NSDictionary *)constantsToExport {
  return @{@"firstDayOfTheWeek":@"Monday"};
}



//进行触发发送通知事件
RCT_EXPORT_METHOD(sendNotification:(NSString *)name){
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarEventReminderReceived:) name:nil object:nil];
}

//进行设置发送事件通知给JavaScript端
- (void)calendarEventReminderReceived:(NSNotification *)notification
{
  [self.bridge.eventDispatcher sendAppEventWithName:@"EventReminder"
                                               body:@{@"name": @"张三"}];
}





@end
