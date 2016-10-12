//
//  SX_DataRequest.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "SX_DataRequest.h"

@implementation SX_DataRequest


+ (NSString *)uuid {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}



+ (void)POSTRequestWithString:(NSString *)string body:(NSDictionary *)body block:(void (^)(id))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"iPhone6,2" forKey:@"deviceType"];
    [dic setObject:[[UIDevice currentDevice] name] forKey:@"deviceType"];
    [dic setObject:[self uuid] forKey:@"deviceId"];
//    [dic setObject:@"iOS" forKey:@"os"];
    [dic setObject:[[UIDevice currentDevice] systemName] forKey:@"os"];
    [dic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osVersion"];
    [dic setObject:@"GSApp" forKey:@"app"];
    [dic setObject:@"2.3.3" forKey:@"appVersion"];
    [dic setObject:body forKey:@"request"];

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (block != nil) {
                    block(result);
                }
            }
        });
    }];
    [dataTask resume];
}

+ (void)GETRequestWithString:(NSString *)string block:(void(^)(id))block {
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (block != nil) {
                    block(result);
                }
            }
        });
    }];
    [dataTask resume];
}

@end
