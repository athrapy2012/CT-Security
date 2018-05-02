//
//  HomeVC.h
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
- (IBAction)checkInBtn:(id)sender;
- (IBAction)ChectOutBtn:(id)sender;
- (IBAction)settingsBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckOut;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;


@property (strong, nonatomic)  NSString *locationStr;
@property (strong, nonatomic) NSString *userNameStr;
@property (strong, nonatomic) NSString *currentNameStr;
@property (strong, nonatomic) NSString *userIdStr;

@property (strong, nonatomic)  NSString *lctnStr;
@property (strong, nonatomic) NSString *nameStr;
@property (strong, nonatomic) NSString *curntUserNameStr;
@property (strong, nonatomic) NSString *idStr;
@end
