//
//  Reuse.m
//  CT Security
//
//  Created by Media3 on 7/4/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "Reuse.h"

@implementation Reuse


-(void)showAlertMsg:(NSString  *)msg  secondParm:(UIViewController *)viewRef
{
    
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:@"CT Security" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    
    [viewRef presentViewController:alert animated:YES completion:nil];
    
}


@end
