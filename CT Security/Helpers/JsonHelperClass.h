//
//  JsonHelperClass.h
//  BFT
//
//  Created by Media3 on 6/13/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface JsonHelperClass : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate>

+(void)postExecuteWithParams:(NSString *)first  secondParm:(NSDictionary *)inParams onCompletion:(JSONResponseBlock)completionBlock;

+(void)getExecuteWithParams:(NSString *)first  secondParm:(NSDictionary *)inParams onCompletion:(JSONResponseBlock)completionBlock;

@end
