//
//  CheckOutVC.h
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckOutVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *currentUsrName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFldSearch;

//@property (strong, nonatomic) NSMutableArray *visitorImgArr;
//@property (strong, nonatomic) NSMutableArray *licenceImgArr;
//@property (strong, nonatomic) NSMutableArray *visitorNameArr;
//@property (strong, nonatomic) NSMutableArray *companyArr;
//@property (strong, nonatomic) NSMutableArray *checkintimeArr;
//@property (strong, nonatomic) NSMutableArray *checkindateArr;
//@property (strong, nonatomic) NSMutableArray *checkouttimeArr;
//@property (strong, nonatomic) NSMutableArray *checkoutdateArr;
//@property (strong, nonatomic) NSMutableArray *checkoutimgArr;
//@property (strong, nonatomic) NSMutableArray *checkinIdArr;
//@property (strong, nonatomic) NSMutableArray *checkInImgArr1;
//@property (strong, nonatomic) NSMutableArray *licenseArr;
//@property (strong, nonatomic) NSMutableArray *locationArr;
//@property (strong, nonatomic) NSMutableArray *timeStampArr;








@property (strong, nonatomic)  NSString *locationStr;
@property (strong, nonatomic) NSString *userNameStr;
@property (strong, nonatomic) NSString *currentNameStr;
@property (strong, nonatomic) NSString *idStr;
@property (strong, nonatomic)  NSString *lctnStr;
@property (strong, nonatomic) NSString *nameStr;
@property (strong, nonatomic) NSString *userIdStr;
@end
