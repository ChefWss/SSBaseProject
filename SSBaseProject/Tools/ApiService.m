//
//  ApiService.m
//  SSBaseProject
//
//  Created by 王少帅 on 2018/1/30.
//  Copyright © 2018年 王少帅. All rights reserved.
//

#import "ApiService.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

#define Key_Token    @"token"

static AFHTTPSessionManager *manager;

@implementation ApiService

+ (ApiService *)shareApiService
{
    static dispatch_once_t onceToken;
    static ApiService *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ApiService alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self=[super init];
    if (self) {
        [self monitorNetworkState];
        [self getSaveUser];
    }
    return self;
}

- (void)getSaveUser
{
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    self.token=[Defaults objectForKey:Key_Token];
}

#pragma mark 网络监测
-(void)monitorNetworkState
{
    AFNetworkReachabilityManager *manager=[AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.netWork=NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //没有网络
                self.netWork=NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.netWork=YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.netWork=YES;
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark 账号登录
- (void)LoginByNumber:(NSString *)name Password:(NSString *)password CompleteHandler:(CompleteHandler)completeHandler
{
    NSString *url = [self makeUrl:@"passport/login"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = name;
    param[@"password"] = password;
    [[self shareManager] POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self doResponse:responseObject CompleteHanler:^(id content, NSError *error){
            if(content){
                [self saveToken:[content objectForKey:@"token"]];
                UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
                keychainStore[@"number"] = name;
                keychainStore[@"password"] = password;
            }
            if (error) {
                if(completeHandler){
                    completeHandler(nil,error);
                }
            }
        }];
    } failure:^(NSURLSessionDataTask *task,NSError *error) {
        NSError *newerror;
        newerror=[NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}];
        if(completeHandler){
            completeHandler(nil,newerror);
        }
    }];
}

#pragma mark 通用POST网络请求
- (void)SendPostRequest:(NSString *)page Content:(NSMutableDictionary *)param CompleteHandler:(CompleteHandler)completeHandler
{
    NSString *url=[self makeUrl:page];
    [[self shareManager] POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task,id responseObject){
        [self doResponse:responseObject CompleteHanler:completeHandler];
    } failure:^(NSURLSessionDataTask *task,NSError *error) {
         NSError *newerror;
         newerror=[NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}];
         if(completeHandler){
             completeHandler(nil, newerror);
         }
     }];
}

#pragma mark 通用GET网络请求
- (void)SendGetRequest:(NSString *)page Content:(NSMutableDictionary *)param CompleteHandler:(CompleteHandler)completeHandler
{
    NSString *url=[self makeUrl:page];
    [[self shareManager] GET:url parameters:param progress:nil success:^(NSURLSessionDataTask *task,id responseObject){
        [self doResponse:responseObject CompleteHanler:completeHandler];
    } failure:^(NSURLSessionDataTask *task,NSError *error) {
         NSError *newerror;
         newerror=[NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}];
         if(completeHandler){
             completeHandler(nil, newerror);
         }
     }];
}

#pragma mark -数据解析
- (void)doResponse:(NSData *)data CompleteHanler:(CompleteHandler)completeHandler
{
    NSError *error=nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        if (completeHandler) {
            error = [NSError errorWithDomain:@"response" code:0 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            completeHandler(nil, error);
        }
    }
    else {
        if ([[json objectForKey:@"code"] integerValue]==200) {
            if(completeHandler) {
                completeHandler([json objectForKey:@"data"],nil);
            }
        }
        else {
            error = [NSError errorWithDomain:@"response" code:[[json objectForKey:@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:[json objectForKey:@"message"]}];
            if(completeHandler){
                completeHandler(nil,error);
            }
        }
    }
}

- (NSString *)makeUrl:(NSString *)page{
    return [NSString stringWithFormat:@"%@%@", SeverAddress, page];
}

- (AFHTTPSessionManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval=60;
    });
    return manager;
}

- (void)saveToken:(NSString *)token{
    self.token=token;
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    [Defaults setObject:self.token forKey:Key_Token];
    [Defaults synchronize];
}

- (void)clearToken{
    self.token=nil;
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    [Defaults setObject:self.token forKey:Key_Token];
    [Defaults synchronize];
}




@end
