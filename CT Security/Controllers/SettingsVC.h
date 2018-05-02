//
//  SettingsVC.h
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>


@property(strong,nonatomic)NSMutableArray * pickerArray;
@property(strong,nonatomic)NSMutableArray * pickerArr;
@property(strong,nonatomic)NSMutableArray * pickerArr1;
@property(strong,nonatomic)NSMutableArray * idArr;
@property(strong,nonatomic)NSString * idStr;


@property (strong, nonatomic) NSString *userIdStr;

@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UILabel *userLbl;
- (IBAction)userBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
- (IBAction)locationBtn:(id)sender;
- (IBAction)manualSync:(id)sender;
- (IBAction)submitBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
- (IBAction)doneBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerRef;
@property (strong, nonatomic) IBOutlet UIButton *userBtnRef;
@property (strong, nonatomic) IBOutlet UIButton *locationBtnRef;
@property (strong, nonatomic) IBOutlet UILabel *currentUsrName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;


@property (strong, nonatomic)  NSString *currentUserlctnStr;
@property (strong, nonatomic) NSString *currentUsernameStr;
@property (strong, nonatomic) NSString *currentUseridStr;

@property (strong, nonatomic)  NSString *currentUserlctnStr1;
@property (strong, nonatomic) NSString *currentUsernameStr1;
@property (strong, nonatomic) NSString *currentUseridStr1;


- (IBAction)addUserBtn:(id)sender;




@end
