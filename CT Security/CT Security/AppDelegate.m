
//  AppDelegate.m
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    Reachability* reach;
    
    
}
@end

@implementation AppDelegate

+(AppDelegate*)shared {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Allocate a reachability object
    //    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach = [Reachability reachabilityForInternetConnection];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"str"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUSER_ID_STR];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginstatus"];
    
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeVC *viewRef = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:viewRef];
    self.window.rootViewController = nav;
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveContext];
}


//start block Offsureit

- (void)checkInVistor:(NSString *)filepath regDictionary:(NSMutableDictionary *)regDictionary visitorsAry:(NSMutableArray *)visitorsAry dicVistor:(NSMutableDictionary *)dicVistor i:(int)i {
    [JsonHelperClass postExecuteWithParams:@"addvisitors"  secondParm:dicVistor onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            
            NSDictionary *dict =[NSDictionary new];
            
            dict= [json valueForKey:@"data"];
            [dicVistor setValue:[dict valueForKey:kVISITOR_CHECK_IN_ID] forKey:kVISITOR_CHECK_IN_ID];
            
            NSArray *tempAry2 = [visitorsAry valueForKey:kTIME_STAMP];
            
            NSInteger index = [tempAry2 indexOfObject:[dict valueForKey:kTIME_STAMP]];
            if(index!=NSNotFound){
                [visitorsAry replaceObjectAtIndex:index withObject:dicVistor];
            }
            NSLog(@"%@",dict);
            
            [regDictionary setValue:visitorsAry forKey:kVISIORS_ARRAY];
            
            NSLog(@"my registration dictionary is %@",regDictionary);
            
            [regDictionary writeToFile:filepath atomically:YES];
            //            [self GetCheckOutList];
        }
        
        //[self callOnLastInterval:visitorsAry i:i];
    }];
}

- (void)checkInAndCheckOutVistor:(NSString *)filepath regDictionary:(NSMutableDictionary *)regDictionary visitorsAry:(NSMutableArray *)visitorsAry i:(int)i dicVistor:(NSMutableDictionary *)dicVistor {
    
    
    
    
    [JsonHelperClass postExecuteWithParams:@"checkoutComplete"  secondParm:dicVistor onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            NSDictionary *dict =[NSDictionary new];
            
            dict= [json valueForKey:@"data"];
            
            NSMutableArray *vistorArray = [self getCheckOutList];
            
            
            NSArray *tempAry2 = [vistorArray valueForKey:kTIME_STAMP];
            
            NSInteger index = [tempAry2 indexOfObject:[dict valueForKey:kTIME_STAMP]];
            if(index!=NSNotFound){
                [vistorArray removeObjectAtIndex:index];
            }
            
            [regDictionary setValue:vistorArray forKey:kVISIORS_ARRAY];
            
            NSLog(@"my registration dictionary is %@",regDictionary);
            
            [regDictionary writeToFile:filepath atomically:YES];
            
        }
        
        
        
    }];
}

-(NSMutableArray*)getCheckOutList{
    NSMutableArray* checkOutList = [NSMutableArray new];
    NSString *checkOutFilepath=[self dataFilePath];
    //checkout
    if ([[NSFileManager defaultManager] fileExistsAtPath:checkOutFilepath]) {
        NSMutableDictionary *regCheckOutDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:checkOutFilepath];
        checkOutList = [regCheckOutDictionary valueForKey:kVISIORS_ARRAY];
    }
    return checkOutList;
}

//-(void) GetCheckOutList {
//
//
//    NSString * userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:kUSER_ID_STR];
//    if (![ userIdStr isEqualToString:@""])
//    {
//        // Request to reload table view data
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUPDATE_VISITOR_SERVICES object:nil];
//
//    }
//}
//-(void)callOnLastInterval:(NSMutableArray*)visitorsAry  i:(int)i{
////    if(i==(visitorsAry.count-1)){
////        [self GetCheckOutList];
////    }
//}

-(void) reachabilityChanged:(NSNotification*)notification {
    if (reach.isReachable){
        [self callApis];
    } else {
        printf("No service avalaible!!!");
    }
}



-(void)callApis{
    
    if (reach.isReachable && _userIdStr != nil)
    {
        NSString *filepath=[self dataFilePath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
            
            NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
            //get previous values
            
            NSMutableArray*  visitorsAry = [NSMutableArray new];
            visitorsAry = [regDictionary valueForKey:kVISIORS_ARRAY];
            if (visitorsAry == nil){
                visitorsAry = [NSMutableArray new];
            }
            
            
            if(visitorsAry.count>0){
                
                NSMutableArray *tempAry2 = [NSMutableArray new];
                //NSString * userIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUSER_ID_STR]];
                
                for (int i =0;i<visitorsAry.count; i++) {
                    NSDictionary *visDic=visitorsAry[i];
                    if([_userIdStr isEqualToString:[NSString stringWithFormat:@"%@",[visDic valueForKey:kSECURITY_ID]]]){
                        [tempAry2 addObject:visDic];
                    }
                }
                
                
                for (int i =0;i<tempAry2.count; i++) {
                    
                    NSMutableDictionary *dicVistor = [visitorsAry objectAtIndex:i];
                    
                    if([[dicVistor valueForKey:kCHECK_OUT_DATE]  isEqual: @"in"]&& [[dicVistor valueForKey:kVISITOR_CHECK_IN_ID]  isEqual: @""]){
                        [self checkInVistor:filepath regDictionary:regDictionary visitorsAry:visitorsAry dicVistor:dicVistor i:i];
                    }
                    if(![[dicVistor valueForKey:kCHECK_OUT_DATE]  isEqual: @"in"] && ![[dicVistor valueForKey:kCHECK_OUT_TIME]  isEqual: @""]){
                        
                        [self checkInAndCheckOutVistor:filepath regDictionary:regDictionary visitorsAry:visitorsAry i:i dicVistor:dicVistor];
                    }
                    
                }
            }
        }
        
    }
    
}

-(NSString *)dataFilePath{
    NSArray *documentArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir=[documentArray objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"register.plist"];
}

//start block Offsureit
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CT_Security"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
