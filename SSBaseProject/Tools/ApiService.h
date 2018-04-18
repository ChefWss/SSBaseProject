//
//  ApiService.h
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleteHandler)(id content, NSError *error);

@interface ApiService : NSObject

@property(nonatomic, assign)BOOL netWork;//是否有网络
@property(nonatomic, copy)NSString *token;//用户token

+ (ApiService *)shareApiService;
- (void)saveToken:(NSString *)token;
- (void)clearToken;
//通用网络请求
- (void)SendPostRequest:(NSString *)page Content:(NSMutableDictionary *)param CompleteHandler:(CompleteHandler)completeHandler;
- (void)SendGetRequest:(NSString *)page Content:(NSMutableDictionary *)param CompleteHandler:(CompleteHandler)completeHandler;
//登陆
- (void)LoginByNumber:(NSString *)name Password:(NSString*)password CompleteHandler:(CompleteHandler)completeHandler;

@end
