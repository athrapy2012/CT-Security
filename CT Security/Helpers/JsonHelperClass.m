  //
//  JsonHelperClass.m
//  BFT
//
//  Created by Media3 on 6/13/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "JsonHelperClass.h"

@implementation JsonHelperClass


+(void)postExecuteWithParams:(NSString *)first  secondParm:(NSDictionary *)inParams onCompletion:(JSONResponseBlock)completionBlock {
    
//    NSString *baseURL = @"http://104.236.111.220/";
   
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:first parameters:inParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         
         NSLog(@"JSON: %@", responseObject);
         completionBlock(responseObject);
         
   
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}

+(void)getExecuteWithParams:(NSString *)first  secondParm:(NSDictionary *)inParams onCompletion:(JSONResponseBlock)completionBlock {
    
    
    
    //NSString *baseURL = @"http://104.236.111.220/";
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    [manager GET:first parameters:inParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         
         NSLog(@"JSON: %@", responseObject);
         completionBlock(responseObject);
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    
}
@end
