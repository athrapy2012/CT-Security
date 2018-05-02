//
//  UpdateVisitorVC.m
//  CT Security
//
//  Created by Media3 on 7/21/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "UpdateVisitorVC.h"

@interface UpdateVisitorVC ()
{
    
    Reuse * reuseObj;
    NSString *dateString1;
    NSString *dateString2;
    NSString *base64CheckOutImg;
    UIImagePickerController *imgPicker;
    UIImage * image;
    NSString * imgStr;
    NSData *imageData;
    
    NSMutableArray *userIdArr;
    NSMutableArray *nameArr;
    NSMutableArray *companyArr;
    NSMutableArray *licenseArr;
    NSMutableArray *visitorImgArr1;
    NSMutableArray *licenseImgArr1;
    NSMutableArray *checkInImgArr1;
    NSMutableArray *checkintimeArr;
    NSMutableArray *checkindateArr;
    NSMutableArray *checkouttimeArr;
    NSMutableArray *checkoutdateArr;
    NSMutableArray *checkoutimgArr;
    NSMutableArray *locationArr;
    NSMutableArray *timeStampArr;
}

@end

@implementation UpdateVisitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    reuseObj = [[Reuse alloc]init];
    
    imgPicker =[[UIImagePickerController alloc]init];
    imgPicker.delegate =self;
    
    _nameStr = [[NSString alloc]initWithString:_userNameStr];
    _lctnStr = [[NSString alloc]initWithString:_locationStr];
    _currentUsrName.text=_nameStr;
    _idStr =_userIdStr;
    
//    self.visitorImg.image = [UIImage imageNamed:setImageWithURL:[NSURL URLWithString:self.visitorImg1];
//    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
//    {
    [self.visitorImg setImage:[UIImage imageNamed:@"placeholder"]];
    if (self.visitorImg != nil){
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString: self.visitorImg1 options:0];
        UIImage *image = [UIImage imageWithData:decodedData];
        self.visitorImg.image = image;
    }
//    }
//    else{
//        [self.visitorImg setImageWithURL:[NSURL URLWithString: self.visitorImg1 ]placeholderImage:[UIImage imageNamed:@"placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    }
   
    
  
    
    
     NSLog(@"visitor image%@",self.visitorImg1);
    NSLog(@" licence image %@",self.licenceImg1);
    self.visitorName.text = self.visitorName1;
    self.cmpnyName.text = self.cmpnyName1;
    self.checkInTime.text = self.checkInTime1;
    self.checkinId = _checkinId1;
    
    NSLog(@"%@Licence image@",self.checkinId);
    NSLog(@"my checkin time %@",self.checkInTime.text);
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    _timeLbl.text=dateString;
    
    NSDate *currDate1 = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
    dateString1 = [dateFormatter1 stringFromDate:currDate1];
    
    NSDate *currDate2 = [NSDate date];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"hh:mm a"];
    dateString2 = [dateFormatter2 stringFromDate:currDate2];
    
    _checkOutTime.text=[dateString1 stringByAppendingString:[@" " stringByAppendingString:dateString2]];
    NSLog(@"CheckOut time: %@",_checkOutTime.text);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [_visitorCheckOutImgRef setImage:image forState:UIControlStateNormal];
        
        imageData = UIImageJPEGRepresentation([self resizeImage:image], 0.2);
        
        
        base64CheckOutImg = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
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
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    UIImage *imagee = [UIImage imageWithData:imageData];
    return imagee;
}


-(void)upload
{
    
    NSString *urlString=@"http://104.236.111.220/upload";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    float low_bound = 0;
    float high_bound =5000;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);//image1
    int intRndValue = (int)(rndValue + 0.5);
    NSString *str_image1 = [@(intRndValue) stringValue];
    
    //UIImage *chosenImage1=[UIImage imageNamed:@"air.png"];
    
        imageData = UIImageJPEGRepresentation(image, 90);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"banner_image\"; filename=\"%@.png\"\r\n",str_image1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // set request body
        [request setHTTPBody:body];
        
        //return and test
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        
        NSData *data = [returnString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        
        
        
        
        
        imgStr =[NSString stringWithFormat:@"%@",[json valueForKey:@"data"]];
        NSLog(@"fgdhsgfdgfdj jdfjgjd %@",imgStr);
  
    
    
}



- (IBAction)visitorCheckOutImg:(id)sender {
    
    [self getImagePicker];
    
}

- (IBAction)checkOutBtn:(id)sender {
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
        {
            [self saveCheckOutUserToLocalDB:[self updateVisitorParams]];
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [self showAlert];
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
//            homeVC.userNameStr=_nameStr;
//            homeVC.locationStr=_lctnStr;
//            homeVC.currentNameStr=_currentUsrName.text;
//            homeVC.userIdStr=_idStr;
//            CATransition* transition = [CATransition animation];
//            transition.duration = 0.5f;
//            transition.type = kCATransitionMoveIn;
//            transition.subtype = kCATransactionDisableActions;
//            [self.navigationController.view.layer addAnimation:transition
//                                                        forKey:kCATransition];
//            
//            [self.navigationController pushViewController:homeVC animated:NO];
        }
        else
        {
            //[self saveDataToLocalDataBase];
            [self updateVisitorsService];
            
        }
    
    //[self updateVisitorsService];
}

- (IBAction)backBtn:(id)sender {
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
    homeVC.userNameStr=_nameStr;
    homeVC.locationStr=_lctnStr;
    homeVC.currentNameStr=_currentUsrName.text;
    homeVC.userIdStr=_idStr;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransactionDisableActions;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController pushViewController:homeVC animated:NO];
    

}


-(void)saveCheckOutUserToLocalDB: (NSDictionary *) usersInfo {
    
    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
    NSString *filepath=[self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        
        NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        NSMutableArray *tempAry = [regDictionary valueForKey:kVISIORS_ARRAY];
        
        NSArray *tempAry2 = [tempAry valueForKey:kTIME_STAMP];
        
        NSInteger index = [tempAry2 indexOfObject:_timeStamp];
        
        
        NSMutableDictionary *vistorDic = [tempAry objectAtIndex:index];
        [vistorDic setValue:[usersInfo valueForKey:@"checkoutdate"] forKey:kCHECK_OUT_DATE];
        [vistorDic setValue:[usersInfo valueForKey:@"checkouttime"] forKey:kCHECK_OUT_TIME];
        [vistorDic setValue:[usersInfo valueForKey:@"checkoutimage"] forKey:kBASE64_CHECK_OUT_IMAGE];
        
        [tempAry replaceObjectAtIndex:index withObject:vistorDic];
        vistorDic = nil;

        
//        //get previous values
//        if([[usersInfo valueForKey:@"_id"] isEqual:@""]){
//            
//            NSMutableDictionary *vistorDic = [tempAry objectAtIndex:index];
//            [vistorDic setValue:[usersInfo valueForKey:@"checkoutdate"] forKey:kCHECK_OUT_DATE];
//            [vistorDic setValue:[usersInfo valueForKey:@"checkouttime"] forKey:kCHECK_OUT_TIME];
//            [vistorDic setValue:[usersInfo valueForKey:@"checkoutimage"] forKey:kBASE64_CHECK_OUT_IMAGE];
//            
//            [tempAry replaceObjectAtIndex:index withObject:vistorDic];
//            vistorDic = nil;
//        }else{
//            
//            if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
//                NSMutableDictionary *vistorDic = [tempAry objectAtIndex:index];
//                [vistorDic setValue:[usersInfo valueForKey:@"checkoutdate"] forKey:kCHECK_OUT_DATE];
//                [vistorDic setValue:[usersInfo valueForKey:@"checkouttime"] forKey:kCHECK_OUT_TIME];
//                [vistorDic setValue:[usersInfo valueForKey:@"checkoutimage"] forKey:kBASE64_CHECK_OUT_IMAGE];
//                
//                [tempAry replaceObjectAtIndex:index withObject:vistorDic];
//                vistorDic = nil;
//            }else{
//                NSMutableDictionary *vistorDic = [tempAry objectAtIndex:index];
//                [vistorDic setValue:[usersInfo valueForKey:@"checkoutdate"] forKey:kCHECK_OUT_DATE];
//                [vistorDic setValue:[usersInfo valueForKey:@"checkouttime"] forKey:kCHECK_OUT_TIME];
//                [vistorDic setValue:[usersInfo valueForKey:@"checkoutimage"] forKey:kBASE64_CHECK_OUT_IMAGE];
//                [tempAry replaceObjectAtIndex:index withObject:vistorDic];
//                vistorDic = nil;
//            }
//            
//            
//        }
        
        [regDictionary setValue:tempAry forKey:kVISIORS_ARRAY];
        
        
        NSLog(@"my registration dictionary is %@",regDictionary);
        
        [regDictionary writeToFile:filepath atomically:YES];
        
    }
    

    
    
    
}



-(NSString *)dataFilePath{
    NSArray *documentArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir=[documentArray objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"register.plist"];
}

-(void)updateVisitorsService
{
    
    [JsonHelperClass postExecuteWithParams:@"checkoutComplete"  secondParm:[self updateVisitorParams] onCompletion:^(NSDictionary *json) {
//    [JsonHelperClass postExecuteWithParams:@"updatevisitor"  secondParm:[self updateVisitorParams] onCompletion:^(NSDictionary *json) {
    
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            
            
            NSDictionary *dict =[NSDictionary new];
            
            dict= [json valueForKey:@"data"];
            
            
            NSLog(@"%@",dict);
            
            [self saveCheckOutUserToLocalDB:dict];
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [self showAlert];
            //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
//                                                                                     message:@"Checked Out Successfully ."
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
//                                          {
//                                              UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                              
//                                              HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
//                                              homeVC.userNameStr=_nameStr;
//                                              homeVC.locationStr=_lctnStr;
//                                              homeVC.currentNameStr=_currentUsrName.text;
//                                              homeVC.userIdStr=_idStr;
//                                              CATransition* transition = [CATransition animation];
//                                              transition.duration = 0.5f;
//                                              transition.type = kCATransitionMoveIn;
//                                              transition.subtype = kCATransactionDisableActions;
//                                              [self.navigationController.view.layer addAnimation:transition
//                                                                                          forKey:kCATransition];
//                                              
//                                              [self.navigationController pushViewController:homeVC animated:NO];
//                                              
//                                              
//                                          }];
//            
//            [alertController addAction:okBtnAction];
//            [alertController setModalPresentationStyle:UIModalPresentationPopover];
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
            
        }
        
    }];
    
}


-(NSDictionary *)updateVisitorParams
{
    
    //NSMutableDictionary *params = [NSMutableDictionary new];
    //params[@"id"] = _checkinId;
    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
    NSString *filepath=[self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        NSMutableArray *tempAry = [regDictionary valueForKey:kVISIORS_ARRAY];
        
        NSArray *tempAry2 = [tempAry valueForKey:kTIME_STAMP];
        
        NSInteger index = [tempAry2 indexOfObject:_timeStamp];
        if(index !=NSNotFound){
            NSMutableDictionary *vistorDic = [tempAry objectAtIndex:index];            
            _vistorDic[@"_id"] = [vistorDic valueForKey:kVISITOR_CHECK_IN_ID];
        }else{
            _vistorDic[@"_id"] = _checkinId;
           
        }
        
    }
    
    _vistorDic[@"checkoutdate"] = dateString1;
    _vistorDic[@"checkouttime"] = dateString2;
    _vistorDic[@"checkoutimage"] = base64CheckOutImg != nil ? base64CheckOutImg: @"";
    
    return _vistorDic;
    
}


-(void)showAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
                                                                             message:@"Checked Out Successfully ."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                  {
                                      UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                      
                                      HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
                                      homeVC.userNameStr=_nameStr;
                                      homeVC.locationStr=_lctnStr;
                                      homeVC.currentNameStr=_currentUsrName.text;
                                      homeVC.userIdStr=_idStr;
                                      CATransition* transition = [CATransition animation];
                                      transition.duration = 0.5f;
                                      transition.type = kCATransitionMoveIn;
                                      transition.subtype = kCATransactionDisableActions;
                                      [self.navigationController.view.layer addAnimation:transition
                                                                                  forKey:kCATransition];
                                      
                                      [self.navigationController pushViewController:homeVC animated:NO];
                                      
                                      
                                  }];
    
    [alertController addAction:okBtnAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:alertController animated:YES completion:nil];
}

//-(NSDictionary *)updateVisitorParams
//{
//
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    params[@"id"] = _checkinId;
//    params[@"checkoutdate"] = dateString1;
//    params[@"checkouttime"] = dateString2;
//    params[@"checkoutimage"] = base64CheckOutImg != nil ? base64CheckOutImg: @"";
//    return params;
//    
//}

@end
