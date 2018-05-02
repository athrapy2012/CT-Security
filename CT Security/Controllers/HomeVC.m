//
//  HomeVC.m
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()
{
    Reuse * reuseObj;
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnCheckOut.exclusiveTouch = true;
    _btnCheckIn.exclusiveTouch = true;
    _btnSetting.exclusiveTouch = true;
    [self.navigationController setNavigationBarHidden:YES];
      reuseObj = [[Reuse alloc]init];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"str"] isEqualToString:@"yes"])
    {
        
        _nameStr = [[NSString alloc]initWithString:_userNameStr];
        _lctnStr = [[NSString alloc]initWithString:_locationStr];
        _curntUserNameStr = [[NSString alloc]initWithString:_currentNameStr];
        _idStr = [[NSString alloc]initWithString:_userIdStr];
    }
    else {
        _nameStr = @"";
        _lctnStr = @"";
        _curntUserNameStr = @"";
        _idStr = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkInBtn:(id)sender {
   
   
    if ([_idStr isEqualToString:@""]){
        [reuseObj showAlertMsg:@"Please Select a user from setting" secondParm:self];
        
    }
    else
    {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CheckInVC *checkInVc = [storyBoard instantiateViewControllerWithIdentifier:@"CheckInVC"];
        checkInVc.userNameStr =_nameStr;
        checkInVc.locationStr =_lctnStr;
        checkInVc.currentNameStr =_curntUserNameStr;
        checkInVc.idStr =_idStr;
        NSLog(@"user Name: %@",checkInVc.userNameStr);
        NSLog(@"location is: %@",checkInVc.locationStr);
        NSLog(@"Current User Name: %@",checkInVc.currentNameStr);
        NSLog(@"id is: %@",checkInVc.idStr);
        [self.navigationController  pushViewController:checkInVc animated:YES];
    }
}

- (IBAction)ChectOutBtn:(id)sender {
    
    if ([_idStr isEqualToString:@""]){
        [reuseObj showAlertMsg:@"Please Select a user from setting" secondParm:self];
      
    }
    else
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CheckOutVC *checkOutVc = [storyBoard instantiateViewControllerWithIdentifier:@"CheckOutVC"];
        checkOutVc.userNameStr=_nameStr;
        checkOutVc.locationStr=_lctnStr;
        checkOutVc.currentNameStr=_curntUserNameStr;
        checkOutVc.userIdStr=_idStr;
        [self.navigationController  pushViewController:checkOutVc animated:YES];
    }
    
}

- (IBAction)settingsBtn:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsVC *settingsVc = [storyBoard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    settingsVc.currentUserlctnStr=_lctnStr;
    settingsVc.currentUsernameStr=_curntUserNameStr;
    settingsVc.currentUseridStr=_idStr;
    [self.navigationController  pushViewController:settingsVc animated:YES];
    
}
@end
