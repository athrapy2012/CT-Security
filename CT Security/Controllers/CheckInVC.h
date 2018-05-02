//
//  CheckInVC.h
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) IBOutlet UITextField *visitorName;
@property (strong, nonatomic) IBOutlet UITextField *cmpnyName;
@property (strong, nonatomic) IBOutlet UITextField *licensePlt;

@property (weak, nonatomic) IBOutlet UIButton *btnsubmit;

@property (strong, nonatomic) IBOutlet UILabel *currentUsrName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
- (IBAction)addVisitorBtn:(id)sender;
- (IBAction)addLicenseBtn:(id)sender;
- (IBAction)addCheckinBtn:(id)sender;



- (IBAction)backBtn:(id)sender;
- (IBAction)submitBtn:(id)sender;
@property (strong, nonatomic)  NSString *locationStr;
@property (strong, nonatomic) NSString *userNameStr;
@property (strong, nonatomic) NSString *currentNameStr;
@property (strong, nonatomic) NSString *idStr;

@property (strong, nonatomic) NSString *userIdStr;

//@property (strong, nonatomic) NSMutableArray *visitorNameArr;
//@property (strong, nonatomic) NSMutableArray *cmpnyNameArr;
//@property (strong, nonatomic) NSMutableArray *licensePltArr;
//@property (strong, nonatomic) NSMutableArray *visitorImgArr;
//@property (strong, nonatomic) NSMutableArray *licenseImgArr;
//@property (strong, nonatomic) NSMutableArray *checkInImgArr;

- (IBAction)visitorsAction:(id)sender;

- (IBAction)licenseAction:(id)sender;
- (IBAction)checkInAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *visitorImgRef;
@property (strong, nonatomic) IBOutlet UIButton *licenseImgRef;
@property (strong, nonatomic) IBOutlet UIButton *checkInImgRef;

@end
