//
//  WTRequestCenter.m
//  TestCache
//
//  Created by song on 14-7-19.
//  Copyright (c) Mike song(mailto:275712575@qq.com). All rights reserved.
//  site:https://github.com/swtlovewtt/WTRequestCenter

#import "WTRequestCenter.h"
#import "WTURLRequestOperation.h"
#import "WTURLRequestSerialization.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
#endif
//请求开始的消息
NSString * const WTNetworkingOperationDidStartNotification = @"WTNetworkingOperationDidStartNotification";
//请求结束的消息
NSString * const WTNetworkingOperationDidFinishNotification = @"WTNetworkingOperationDidFinishNotification";


BOOL const WTRequestCenterDebugMode = YES;

@implementation WTRequestCenter



#pragma mark - 请求队列和缓存
//请求队列
static NSOperationQueue *sharedQueue = nil;
+(NSOperationQueue*)sharedQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setSuspended:NO];
        [sharedQueue setMaxConcurrentOperationCount:32];
        sharedQueue.name = @"WTRequestCentersharedQueue";
    });
    return sharedQueue;
}


//缓存
static NSURLCache* sharedCache = nil;
+(NSURLCache*)sharedCache
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *diskPath = [NSString stringWithFormat:@"WTRequestCenter"];
        sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1024*1024*10 diskCapacity:1024*1024*1024 diskPath:diskPath];
    });
    //    10M内存  1G硬盘
    return sharedCache;
}


#pragma mark - 配置设置

-(BOOL)isRequesting
{
    BOOL requesting = NO;
    NSOperationQueue *sharedQueue = [WTRequestCenter sharedQueue];
    
    if ([sharedQueue operationCount]!=0) {
        requesting = YES;
    }
    return requesting;
}

//清除所有缓存(clearAllCache)
+(void)clearAllCache
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeAllCachedResponses];
    
}



//当前缓存大小
+(NSUInteger)currentDiskUsage
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    
    return [cache currentDiskUsage];
}


//当前缓存用量，直接根据大小来调节单位的显示，KB，MB，GB，TB，PB，EB
+(NSString*)currentDiskUsageString
{
    NSUInteger usage = [self currentDiskUsage];
    //    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    //    formatter.includesActualByteCount = YES;
    //    formatter.countStyle = NSByteCountFormatterCountStyleFile;
    return [NSByteCountFormatter stringFromByteCount:usage countStyle:NSByteCountFormatterCountStyleFile];
}

+(void)cancelAllRequest
{
    [[WTRequestCenter sharedQueue] cancelAllOperations];
}


//清除请求的缓存
+(void)removeRequestCache:(NSURLRequest*)request
{
    NSURLCache *cache = [WTRequestCenter sharedCache];
    [cache removeCachedResponseForRequest:request];
}
#pragma mark - 辅助
+(id)JSONObjectWithData:(NSData*)data
{
    if (!data) {
        return nil;
    }
    //    容器解析成可变的，string解析成可变的，并且允许顶对象不是dict或者array
    NSJSONReadingOptions option = NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments;
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:option
                                             error:nil];
}

+(NSData*)dataFromJSONObject:(id)object
{
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        return data;
    }
    return nil;
}


//这个方法用于类型不固定时候的一个过滤
//传入一个NSNumber，NSString或者NSNull类型的数据即可
+(NSString*)stringWithData:(NSObject*)data
{
    if ([data isEqual:[NSNull null]]) {
        return @"";
    }
    if ([data isKindOfClass:[NSString class]]) {
        return (NSString*)data;
    }
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber*)data;
        return [number stringValue];
    }
    return @"";
}

+(NSString*)stringFromParameters:(NSDictionary*)parameters
{
    if (parameters && [[parameters allKeys] count]>0) {
        NSMutableString *paramString = [[NSMutableString alloc] init];
        
        
        
        [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL *stop) {
            if (index!=0) {
                [paramString appendFormat:@"&"];
            }
            [paramString appendFormat:@"%@=%@",key,[parameters valueForKey:key]];
            
        }];
        return [paramString copy];
    }
    else
    {
        return @"";
    }
}

#pragma mark - Get

//get请求
//Available in iOS 5.0 and later.

+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    return [self getWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
}

+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary *)parameters
                    option:(WTRequestCenterCachePolicy)option
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization GETRequestWithURL:url parameters:parameters];
    
    [self doURLRequest:request option:option finished:finished failed:failed];
    
    return request;
}

+(NSURLRequest*)getWithIndex:(NSInteger)index
                  parameters:(NSDictionary *)parameters
                    finished:(WTRequestFinishedBlock)finished
                      failed:(WTRequestFailedBlock)failed
{
    return [self getWithIndex:index parameters:parameters option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
}
+(NSURLRequest*)getWithIndex:(NSInteger)index
                  parameters:(NSDictionary *)parameters
                      option:(WTRequestCenterCachePolicy)option
                    finished:(WTRequestFinishedBlock)finished
                      failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization GETRequestWithURL:[self URLWithIndex:index] parameters:parameters];
    [self doURLRequest:request option:option finished:finished failed:failed];
    return request;
}


+(NSURLRequest*)getWithIndex:(NSInteger)index
                  parameters:(NSDictionary *)parameters
                  expireTime:(NSTimeInterval)time
                    finished:(WTRequestFinishedBlock)finished
                      failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization GETRequestWithURL:[self URLWithIndex:index] parameters:parameters];
    
    NSCachedURLResponse *cacheURLResponse = [[WTRequestCenter sharedCache] cachedResponseForRequest:request];
    BOOL needRequest = YES;
    if (cacheURLResponse) {
        if ([cacheURLResponse.response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *tempResponse = (NSHTTPURLResponse*)cacheURLResponse.response;
            NSDate *date = [WTURLRequestSerialization dateFromHTTPURLResponse:tempResponse];
            NSTimeInterval responseTime = [date timeIntervalSince1970];
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            if (now-responseTime < time) {
                needRequest = NO;
            }
            
        }
    }
    
    if (needRequest) {
        [self getWithIndex:index parameters:parameters finished:finished failed:failed];
    }else
    {
        if (finished) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                finished(cacheURLResponse.response,cacheURLResponse.data);
            }];
            
        }
    }
    
    return request;
}

+(NSURLRequest*)getWithURL:(NSString*)url
                parameters:(NSDictionary *)parameters
                expireTime:(NSTimeInterval)time
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization GETRequestWithURL:url parameters:parameters];
    
    NSCachedURLResponse *cacheURLResponse = [[WTRequestCenter sharedCache] cachedResponseForRequest:request];
    BOOL needRequest = YES;
    if (cacheURLResponse) {
        if ([cacheURLResponse.response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *tempResponse = (NSHTTPURLResponse*)cacheURLResponse.response;
            NSDate *date = [WTURLRequestSerialization dateFromHTTPURLResponse:tempResponse];
            NSTimeInterval responseTime = [date timeIntervalSince1970];
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            if (now-responseTime < time) {
                needRequest = NO;
            }
            
        }
    }
    
    if (needRequest) {
        
        [self getWithURL:url
              parameters:parameters
                finished:finished
                  failed:failed];
    }else
    {
        if (finished) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                finished(cacheURLResponse.response,cacheURLResponse.data);
            }];
            
        }
    }
    
    return request;
}


#pragma mark - POST


+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization POSTRequestWithURL:url parameters:parameters];
    [self doURLRequest:request finished:finished failed:failed];
    return request;
}

+(NSURLRequest*)postWithIndex:(NSInteger)index
                   parameters:(NSDictionary*)parameters
                     finished:(WTRequestFinishedBlock)finished
                       failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization POSTRequestWithURL:[self URLWithIndex:index] parameters:parameters];
    [WTRequestCenter doURLRequest:request finished:finished failed:failed];
    return request;
}



+(NSURLRequest*)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
  constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization POSTRequestWithURL:url parameters:parameters constructingBodyWithBlock:block];
    [self doURLRequest:request finished:finished failed:failed];
    return request;
}


+(NSURLRequest*)putWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization PUTRequestWithURL:url parameters:parameters];
    [self doURLRequest:request finished:finished failed:failed];
    return request;
}


#pragma mark - Request
+(void)doURLRequest:(NSURLRequest*)request
           finished:(WTRequestFinishedBlock)finished
             failed:(WTRequestFailedBlock)failed
{
    //    有效性判断
    assert(request != nil);
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary *userInfo = @{@"request": request};
        [[NSNotificationCenter defaultCenter] postNotificationName:WTNetworkingOperationDidStartNotification object:request userInfo:userInfo];
    }];
    
    
    NSTimeInterval startTimeInterval = [[NSDate date] timeIntervalSince1970];
    if (WTRequestCenterDebugMode) {
        NSLog(@"WTRequestCenter request start:%@",request);
        
    }
    
    void (^complection)(NSURLResponse *response,NSData *data,NSError *error);
    
    complection = ^(NSURLResponse *response,NSData *data,NSError *connectionError)
    {
        NSTimeInterval endTimeInterval = [[NSDate date] timeIntervalSince1970];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSDictionary *userInfo = @{@"request": request};
            [[NSNotificationCenter defaultCenter] postNotificationName:WTNetworkingOperationDidFinishNotification object:request userInfo:userInfo];
        }];
        
        
        if (connectionError) {
            if (WTRequestCenterDebugMode) {
                //                    访问出错
                NSLog(@"WTRequestCenter request failed:\n\nrequest:%@\n\nresponse：%@\n\nerror：%@  time:%f",request,response,connectionError,endTimeInterval-startTimeInterval);
            }
        }else
        {
            NSCachedURLResponse *tempURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            [[self sharedCache] storeCachedResponse:tempURLResponse forRequest:request];
            if (WTRequestCenterDebugMode) {
                NSLog(@"WTRequestCenter request finished:%@  time:%f",request,endTimeInterval-startTimeInterval);
            }
        }
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (connectionError) {
                if (failed) {
                    failed(response,connectionError);
                }
                
            }else
            {
                if (finished) {
                    finished(response,data);
                }
            }
        }];
    };
    
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    UIDevice *currentDevice = [UIDevice currentDevice];
    if ([currentDevice.systemVersion floatValue]>=7.0) {
        [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
            
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError){
                complection(response,data,connectionError);
            }];
            [task resume];
        }];
        
        
    }else
    {
        
        [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
            [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                complection(response,data,connectionError);
            }];
            
        }];
    }
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
        [NSURLConnection sendAsynchronousRequest:request queue:[WTRequestCenter sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            complection(response,data,connectionError);
        }];
    }];
#endif
    
}


+(void)doURLRequest:(NSURLRequest*)request
             option:(WTRequestCenterCachePolicy)option
           finished:(WTRequestFinishedBlock)finished
             failed:(WTRequestFailedBlock)failed
{
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            //            [self doURLRequest:request finished: failed:failed];
            [self doURLRequest:request finished:finished failed:failed];
            
        }
            break;
            
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
            }else
            {
                [self doURLRequest:request finished:finished failed:failed];
            }
        }
            break;
            
        case WTRequestCenterCachePolicyOnlyCache:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(response.response,response.data);
                    
                }
            });
        }
            break;
            
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            
            //          如果有本地的，也去刷新，刷新后不回调，如果没有，则用网络的
            
            if (response) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                [self doURLRequest:request finished:nil failed:nil];
            }else
            {
                [self doURLRequest:request finished:finished failed:failed];
            }
            
            
        }
            break;
        case WTRequestCenterCachePolicyCacheAndWeb:
        {
            if (response) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                [self doURLRequest:request finished:finished failed:failed];
            }else
            {
                [self doURLRequest:request finished:finished failed:failed];
            }
            
            
        }
            break;
            
            
        default:
            break;
    }
    
}















#pragma mark - URL

static NSString * const baseURL = @"http://www.baidu.com";
+(NSString *)baseURL
{
    return baseURL;
}

//实际应用示例
+(NSString*)URLWithIndex:(NSInteger)index
{
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    //    0-9
    [urls addObject:@"article/detail"];
    [urls addObject:@"interface1"];
    [urls addObject:@"interface2"];
    [urls addObject:@"interface3"];
    
    
    NSString *url = urls[index];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",[WTRequestCenter baseURL],url];
    return urlString;
}


+ (NSString *)debugDescription
{
    return @"just a joke";
}


#pragma mark - Testing Method



+(WTURLRequestOperation*)testdoURLRequest:(NSURLRequest*)request
                                 progress:(WTDownLoadProgressBlock)progress
                                 finished:(WTRequestFinishedBlock)finished
                                   failed:(WTRequestFailedBlock)failed
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    WTURLRequestOperation *operation = nil;
    operation = [[WTURLRequestOperation alloc] initWithRequest:request];
    if (progress) {
        operation.downloadProgress = progress;
    }
    [operation setCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (failed) {
                failed(response,error);
            }
        }else
        {
            if (finished) {
                finished(response,data);
            }
        }
    }];
    [[self sharedQueue] addOperation:operation];
    return operation;
#pragma clang diagnostic pop
    
}


+(WTURLRequestOperation*)testdoURLRequest:(NSURLRequest*)request
                                   option:(WTRequestCenterCachePolicy)option
                                 progress:(WTDownLoadProgressBlock)progress
                                 finished:(WTRequestFinishedBlock)finished
                                   failed:(WTRequestFailedBlock)failed
{
    WTURLRequestOperation *operation = nil;
    operation = [[WTURLRequestOperation alloc] initWithRequest:request];
    if (progress) {
        operation.downloadProgress = progress;
    }
    NSCachedURLResponse *response = [[self sharedCache] cachedResponseForRequest:request];
    switch (option) {
        case WTRequestCenterCachePolicyNormal:
        {
            operation = [self testdoURLRequest:request progress:progress finished:finished failed:failed];
        }
            break;
        case WTRequestCenterCachePolicyCacheElseWeb:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
            }else
            {
                operation =  [self testdoURLRequest:request progress:progress finished:finished failed:failed];
            }
        }
            break;
        case WTRequestCenterCachePolicyOnlyCache:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(nil,nil);
                    }
                });
            }
        }
            break;
        case WTRequestCenterCachePolicyCacheAndRefresh:
        {
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                
            }
            
            operation = [self testdoURLRequest:request progress:progress finished:finished failed:failed];
        }
            break;
        case WTRequestCenterCachePolicyCacheAndWeb:
        {
            
            if (response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(response.response,response.data);
                    }
                });
                operation = [self testdoURLRequest:request progress:nil finished:nil failed:nil];
            }else
            {
                operation = [self testdoURLRequest:request progress:progress finished:finished failed:failed];
            }
        }
            break;
            
        default:
            break;
    }
    
    return operation;
}



+(WTURLRequestOperation*)testGetWithURL:(NSString *)url parameters:(NSDictionary *)parameters finished:(WTRequestFinishedBlock)finished failed:(WTRequestFailedBlock)failed
{
    return [self testGetWithURL:url parameters:parameters option:WTRequestCenterCachePolicyNormal finished:finished failed:failed];
}
+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed
{
    return [self testGetWithURL:url parameters:parameters option:option progress:nil finished:finished failed:failed];
}

+(WTURLRequestOperation*)testGetWithURL:(NSString*)url
                             parameters:(NSDictionary *)parameters
                                 option:(WTRequestCenterCachePolicy)option
                               progress:(WTDownLoadProgressBlock)progress
                               finished:(WTRequestFinishedBlock)finished
                                 failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization GETRequestWithURL:url parameters:parameters];
    WTURLRequestOperation *operation = [self testdoURLRequest:request option:option progress:progress finished:finished failed:failed];
    return operation;
}



+(WTURLRequestOperation*)testPOSTWithURL:(NSString*)url
                              parameters:(NSDictionary *)parameters
                                finished:(WTRequestFinishedBlock)finished
                                  failed:(WTRequestFailedBlock)failed
{
    NSURLRequest *request = [WTURLRequestSerialization POSTRequestWithURL:url parameters:parameters];
    WTURLRequestOperation *operation = [self testdoURLRequest:request progress:nil finished:finished failed:failed];
    return operation;
}

@end
