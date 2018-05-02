//
//  UpdateVisitorVC.h
//  CT Security
//
//  Created by Media3 on 7/21/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateVisitorVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *visitorImg;

@property (strong, nonatomic) IBOutlet UILabel *visitorName;
@property (strong, nonatomic) IBOutlet UILabel *cmpnyName;
@property (strong, nonatomic) IBOutlet UILabel *checkInTime;
@property (strong, nonatomic) IBOutlet UILabel *checkOutTime;
- (IBAction)checkOutBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *currentUsrName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic)  NSString *locationStr;
@property (strong, nonatomic) NSString *userNameStr;
@property (strong, nonatomic) NSString *currentNameStr;
@property (strong, nonatomic) NSString *idStr;
@property (strong, nonatomic)  NSString *lctnStr;
@property (strong, nonatomic) NSString *nameStr;
@property (strong, nonatomic) NSString *userIdStr;

@property (strong, nonatomic)  NSString *visitorImg1;
@property (strong, nonatomic)  NSString *licenceImg1;
@property (strong, nonatomic)  NSString *visitorName1;
@property (strong, nonatomic)  NSString *cmpnyName1;
@property (strong, nonatomic)  NSString *checkInTime1;
@property (strong, nonatomic)  NSString *checkinId;
@property (strong, nonatomic)  NSString *checkinId1;
@property (strong, nonatomic)  NSString *timeStamp;
@property (strong, nonatomic)  NSMutableDictionary *vistorDic;


- (IBAction)visitorCheckOutImg:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *visitorCheckOutImgRef;


@end
