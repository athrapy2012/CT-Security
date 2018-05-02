//
//  CheckInVC.m
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "CheckInVC.h"

@interface CheckInVC ()
{
    Reuse * reuseObj;
    NSString *base64VistorImg , *base64LicenseImg, *base64CheckInImg;
    UIImagePickerController *imgPicker;
    NSString * iAmFromBtn;
//    NSMutableArray *userIdArr;
//    NSMutableArray *nameArr;
//    NSMutableArray *companyArr;
//    NSMutableArray *licenseArr;
//    NSMutableArray *visitorImgArr1;
//    NSMutableArray *licenseImgArr1;
//    NSMutableArray *checkInImgArr1;
//    NSMutableArray *checkintimeArr;
//    NSMutableArray *checkindateArr;
//    NSMutableArray *checkouttimeArr;
//    NSMutableArray *checkoutdateArr;
//    NSMutableArray *checkoutimgArr;
//    NSMutableArray *locationArr;
//    NSMutableArray *timeStampArr;
    NSString *dateString1,*timeStamp;
    NSString *dateString2;
    UIImage * visitorImg, *licenseImg, *checkInImg;
    NSString * strVisitorImg, *strLicenseImg, *strCheckInImg;
    
    
    
    NSData *imageData;
    NSMutableArray *visitorsAry;
}

@end

@implementation CheckInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    imgPicker =[[UIImagePickerController alloc]init];
    
    
    imgPicker.delegate =self;
    
    self.userNameLbl.text = self.userNameStr;
    self.locationLbl.text = self.locationStr;
    self.currentUsrName.text = self.currentNameStr;
    _userIdStr = self.idStr;
    NSLog(@"user id: %@",_userIdStr);
    NSLog(@"location is %@",self.locationLbl.text);
    reuseObj = [[Reuse alloc]init];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    _timeLbl.text=dateString;
    
    //NSLog(@"%@",localDateString);
    
    NSDate *currDate1 = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
    dateString1 = [dateFormatter1 stringFromDate:currDate1];
    
    NSDate *currDate2 = [NSDate date];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"hh:mm a"];
    dateString2 = [dateFormatter2 stringFromDate:currDate2];
    _dateLabel.text=[@"On" stringByAppendingString:[@" " stringByAppendingString:[dateString1 stringByAppendingString:[@" , " stringByAppendingString:dateString2]]]];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Check NetWork connection

-(void)checkNetworkConnection {
    timeStamp = [self getCurrentTimeStamp];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self saveDataToLocalDataBase];
        
    }
    else
    {
        
        [self addVisitorServices];
        
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == _visitorName) {
        
        [self.cmpnyName becomeFirstResponder];
    }
    if (textField == _cmpnyName) {
        
        [self.licensePlt becomeFirstResponder];
    }
    
    else {
        [self.licensePlt resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Image Picker

-(void)getImagePicker {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
//        
//        [alert addAction:action];
//        
//        [self presentViewController:alert animated:YES completion:nil];
        
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else{
        
        //UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.allowsEditing = YES;
        //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([iAmFromBtn isEqualToString:@"first" ])
    {
        
        visitorImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [_visitorImgRef setImage:visitorImg forState:UIControlStateNormal];
        
        imageData = UIImageJPEGRepresentation([self resizeImage:visitorImg], 0.2);
        
        
        base64VistorImg = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    
    else if ([iAmFromBtn isEqualToString:@"second" ])
    {
        
        licenseImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [_licenseImgRef setImage:licenseImg forState:UIControlStateNormal];
        
        NSData *imageData1 = UIImageJPEGRepresentation([self resizeImage:licenseImg], 0.2);
        
        base64LicenseImg = [imageData1 base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    
    else {
        
        checkInImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [_checkInImgRef setImage:checkInImg forState:UIControlStateNormal];
        
        
        NSData *imageData2 = UIImageJPEGRepresentation([self resizeImage:checkInImg], 0.2);
        
        base64CheckInImg = [imageData2 base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    //[self upload];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300;
    float maxWidth = 200;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageDataa = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    UIImage *imagee = [UIImage imageWithData:imageDataa];
    return imagee;
}


- (IBAction)addVisitorBtn:(id)sender {
    //[self retrivePlistData];
    iAmFromBtn = @"first";
    [self getImagePicker];
}

- (IBAction)addLicenseBtn:(id)sender {
    iAmFromBtn = @"second";
    [self getImagePicker];
}

- (IBAction)addCheckinBtn:(id)sender {
    
    iAmFromBtn = @"third";
    [self getImagePicker];
}

- (void)homeScreen {
  UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
    homeVC.userNameStr=_userNameLbl.text;
    homeVC.locationStr=_locationLbl.text;
    homeVC.currentNameStr=_currentUsrName.text;
    homeVC.userIdStr=_userIdStr;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransactionDisableActions;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)backBtn:(id)sender {
    
    [self homeScreen];
    
}

- (IBAction)submitBtn:(id)sender {
    
   // _btnsubmit.userInteractionEnabled = false;
    [self.view endEditing:YES];
    
    
    if(self.visitorName.text.length != 0) {
        
        if(self.cmpnyName.text.length != 0) {
            
            if(self.licensePlt.text.length != 0) {
                
                if ((base64VistorImg != nil) && (base64LicenseImg != nil) && base64CheckInImg != nil){
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self checkNetworkConnection];
                }
                else
                {
                    [self showVistorImageAlert];
                    return;
                }
                
            }
            
            else
            {
                [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
            }
            
        }
        else
        {
            [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
        }
    }
    else
        
    {
        [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
    }
    
}

- (void)showVistorImageAlert {
    
    [reuseObj showAlertMsg:@"Please add all three images" secondParm:self];

}

#pragma mark: make dictionary from current details to save in local db
-(NSMutableDictionary *)makeCkeckInDict {
    
    NSMutableDictionary *checkInDict = [NSMutableDictionary new];
    checkInDict[kVISITOR_CHECK_IN_ID] = @"";
    checkInDict[kVISITOR_NAME] = _visitorName.text;
    checkInDict[kCOMPANY_NAME] = _cmpnyName.text;
    checkInDict[kLICENCE_PLATE] = _licensePlt.text;
    checkInDict[kCHECK_IN_DATE] = dateString1;
    checkInDict[kCHECK_IN_TIME] = dateString2;
    checkInDict[kLOCATION] = _locationLbl.text;
    checkInDict[kSECURITY_ID] =_userIdStr;
    checkInDict[kTIME_STAMP] = timeStamp;
    
    if(base64VistorImg!=nil){
        checkInDict[kBASE64_VISITOR_IMAGE] = base64VistorImg;
    }
    
    if(base64LicenseImg!=nil){
        checkInDict[kBASE64_LICENCE_IMAGE] = base64LicenseImg; //file image
    }
    
    if(base64CheckInImg!=nil){
        // checkIn Image
        checkInDict[kBASE64_CHECK_IN_IMAGE] = base64CheckInImg; //file 2
    }
    checkInDict[kCHECK_OUT_DATE] = @"in";
    checkInDict[kCHECK_IN_TIME] = @"";
    checkInDict[kBASE64_CHECK_OUT_IMAGE] = @"";
    
    
    //NSLog(@"%@", checkInDict);
    return checkInDict;
}

#pragma mark: make dictionary from API response to save in local db
-(NSMutableDictionary *)makeCkeckInDictFromAPIresponse:(NSDictionary *) dict {
    
    NSMutableDictionary *checkInDict = [NSMutableDictionary new];
    checkInDict[kVISITOR_CHECK_IN_ID] = [dict valueForKey:kVISITOR_CHECK_IN_ID];
    checkInDict[kVISITOR_NAME] = [dict valueForKey:kVISITOR_NAME];
    checkInDict[kCOMPANY_NAME] = [dict valueForKey:kCOMPANY_NAME];
    checkInDict[kLICENCE_PLATE] = [dict valueForKey:kLICENCE_PLATE];
    checkInDict[kCHECK_IN_DATE] = [dict valueForKey:kCHECK_IN_DATE];
    checkInDict[kCHECK_IN_TIME] = [dict valueForKey:kCHECK_IN_TIME];
    checkInDict[kLOCATION] = [dict valueForKey:kLOCATION];
    checkInDict[kSECURITY_ID] = [dict valueForKey:kSECURITY_ID];
    
    NSURL *visitorImgUrl = [NSURL URLWithString:[dict valueForKey:kBASE64_VISITOR_IMAGE]];
    NSString * imageString= [self ImageFromUrl:visitorImgUrl];
    if( imageString != nil){
        checkInDict[kBASE64_VISITOR_IMAGE] = imageString;
    }else{
        checkInDict[kBASE64_VISITOR_IMAGE] = visitorImgUrl;
    }
    
    checkInDict[kBASE64_LICENCE_IMAGE] = [dict valueForKey:kBASE64_LICENCE_IMAGE];
    
    
    checkInDict[kCHECK_OUT_DATE] = @"in";
    checkInDict[kCHECK_OUT_TIME] = @"";
    checkInDict[kBASE64_CHECK_OUT_IMAGE] = @"";
    checkInDict[kTIME_STAMP] = [dict valueForKey:kTIME_STAMP];
    
    NSLog(@"check in Dictionary From Api response is: %@", checkInDict);
    return checkInDict;
}

#pragma mark: Save data to local db when internet is not available
-(void)saveDataToLocalDataBase {
    
    if (![_visitorName.text isEqualToString:@""] && ![_cmpnyName.text isEqualToString:@""] && ![_licensePlt.text isEqualToString:@""]) {
       
        if ((base64VistorImg != nil) && (base64LicenseImg != nil) && base64CheckInImg != nil){
            
        NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
        NSString *filepath=[self dataFilePath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
            
            NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
            
             //get previous values
            visitorsAry = [NSMutableArray new];
             visitorsAry = [regDictionary valueForKey:kVISIORS_ARRAY];
            if (visitorsAry == nil){
                visitorsAry = [NSMutableArray new];
            }
            //add object
             [visitorsAry addObject:[self makeCkeckInDict]];
            NSLog(@"CheckIN Dictionary is: %@", [self makeCkeckInDict]);
            
             //set values
             [regDictionary setValue:visitorsAry forKey:kVISIORS_ARRAY];
             
             
             NSLog(@"my registration dictionary is %@",regDictionary);
            
            
            [regDictionary writeToFile:filepath atomically:YES];
            
            }
        
        else
        {
            NSFileManager *filemanager=[NSFileManager defaultManager];
            
            [filemanager createFileAtPath:filepath contents:nil attributes:regDictionary];
            
            visitorsAry = [NSMutableArray new];
            
            //add object
            [visitorsAry addObject:[self makeCkeckInDict]];
            NSLog(@"CheckIN Dictionary is: %@", [self makeCkeckInDict]);
            
            
            //set values
            [regDictionary setValue:visitorsAry forKey:kVISIORS_ARRAY];
            
            [regDictionary writeToFile:filepath atomically:YES];
            
            NSLog(@" My Plist data is %@",regDictionary);
            
        }
            
             [MBProgressHUD hideHUDForView:self.view animated:true];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
                                                                                 message:@"Details Saved to local database."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                      {
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"str"];
                                          
                                          [self homeScreen];
                                          
                                      }];
        
        [alertController addAction:okBtnAction];
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        [self presentViewController:alertController animated:YES completion:nil];

    }
        else
        {
            [self showVistorImageAlert];
            return;
        }
    }
    else
    {
        [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
    }

}

// save data received from api
-(void)saveDataFromApiToLocalDataBase:(NSDictionary *) dict {
    
            NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
            NSString *filepath=[self dataFilePath];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                
                NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
                //get previous values
                
                visitorsAry = [NSMutableArray new];
                visitorsAry = [regDictionary valueForKey:kVISIORS_ARRAY];
                if (visitorsAry == nil){
                    visitorsAry = [NSMutableArray new];
                }
                //add object
                [visitorsAry addObject:dict];
               
                
                //set values
                [regDictionary setValue:visitorsAry forKey:kVISIORS_ARRAY];
                
                NSLog(@"my registration dictionary is %@",regDictionary);
                
                [regDictionary writeToFile:filepath atomically:YES];
                
            }
            
            else {
                
                
                NSFileManager *filemanager=[NSFileManager defaultManager];
                
                [filemanager createFileAtPath:filepath contents:nil attributes:regDictionary];
                
                //add object
                visitorsAry = [NSMutableArray new];
                [visitorsAry addObject:dict];
                
                
                //set values
                [regDictionary setValue:visitorsAry forKey:kVISIORS_ARRAY];
                
                [regDictionary writeToFile:filepath atomically:YES];
                
                NSLog(@" My Plist data is %@",regDictionary);
                
            }
    
}

-(NSString *)ImageFromUrl:(NSURL *) url {
    
    NSData * imgData = [NSData dataWithContentsOfURL:url]; ;
    
    NSString *newbase64VistorImg = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return  newbase64VistorImg;
}

-(NSString *)dataFilePath{
    NSArray *documentArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir=[documentArray objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"register.plist"];
}



-(void)addVisitorServices
{
    [JsonHelperClass postExecuteWithParams:@"addvisitors"  secondParm:[self addVisitorParams] onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            
            
            NSDictionary *dict =[NSDictionary new];
            
            dict= [json valueForKey:@"data"];
            NSDictionary *newVisitorDict = [self makeCkeckInDictFromAPIresponse:dict];
            [self saveDataFromApiToLocalDataBase:newVisitorDict];
            
            NSLog(@"%@",dict);
             [MBProgressHUD hideHUDForView:self.view animated:true];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
                                                                                     message:@"Checked In Successfully ."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                          {
                                              [self homeScreen];
                                              
                                          }];
            
            [alertController addAction:okBtnAction];
            [alertController setModalPresentationStyle:UIModalPresentationPopover];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        else {
            
            [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
            
        }
        
    }];
    
}

-(NSDictionary *)addVisitorParams
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"name"] = _visitorName.text;
    params[@"company_name"] = _cmpnyName.text;
    params[@"licence_plate"] = _licensePlt.text;
    params[@"checkindate"] = dateString1;
    params[@"checkintime"] = dateString2;
    params[@"location"] = _locationLbl.text;
    params[@"security_id"] =_userIdStr;
    
    if(base64VistorImg!=nil){
        params[@"visitor_image"] = base64VistorImg;
        
    }
    if(base64LicenseImg!=nil){
        params[@"file"] = base64LicenseImg;
    }
    
    if(base64CheckInImg!=nil){
        params[@"file2"] = base64CheckInImg;
    }    
    params[kTIME_STAMP] = timeStamp;
    
    NSLog(@"Add visitor Parameters%@", params);
    return params;
    
}

-(void)retrivePlistData {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"register.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"register" ofType:@"plist"];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    visitorsAry = [NSMutableArray new];
    visitorsAry = [dict valueForKey:visitorsAry];
    
   
    
    NSLog(@" data from plist %@",dict);
}




- (IBAction)visitorsAction:(id)sender {
    
    iAmFromBtn = @"first";
    [self getImagePicker];
    
}

- (IBAction)licenseAction:(id)sender {
    
    iAmFromBtn = @"second";
    [self getImagePicker];
}

- (IBAction)checkInAction:(id)sender {
    
    iAmFromBtn = @"third";
    [self getImagePicker];
}

-(NSString *)getCurrentTimeStamp {
    
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//     NSLog(@"timeStamp :%f", timeStamp);
//    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
//    int timeStampInt = (int)timeStampObj.intValue;
//    NSNumber *timeStNum = [NSNumber numberWithInt:timeStampInt];
    NSString *timeStampStr = [NSString stringWithFormat:@"%lld",milliseconds];
//    NSLog(@"timeStampStr :%@", timeStampStr);
    return timeStampStr;
}


@end
