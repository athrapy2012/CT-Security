//
//  CheckOutVC.m
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "CheckOutVC.h"

@interface CheckOutVC ()
{
    Reuse * reuseObj;
}
@end

@implementation CheckOutVC
{
    NSString *findVistorsStr;
    NSString *findVistorsStr1;
    // NSMutableDictionary *regDictionary;
    NSMutableArray *visitorsAry;
    NSMutableArray *visitorsSearchAry;
    
    NSMutableArray *checkOutVistorAry;
    BOOL needToCheckOnline;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:true];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUPDATE_VISITOR_SERVICES object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeNotificationObserver)
                                                 name:kUPDATE_VISITOR_SERVICES
                                               object:nil];
    

    reuseObj = [[Reuse alloc]init];
    visitorsAry = [NSMutableArray new];
     visitorsSearchAry = [NSMutableArray new];
    _nameStr = [[NSString alloc]initWithString:_userNameStr];
    _lctnStr = [[NSString alloc]initWithString:_locationStr];
    _currentUsrName.text=_nameStr;
    _idStr =_userIdStr;
    
    //regDictionary=[NSMutableDictionary dictionary];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    _timeLbl.text=dateString;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [MBProgressHUD ];
    [self checkNetworkConnection];
    
    
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)viewWillAppear:(BOOL)animated {
    
    //[_visitorImgArr removeAllObjects];
    
    
    [self.collectionView reloadData];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return visitorsAry.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckOutCollectionViewCell * Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *oneVisitorDict = [visitorsAry objectAtIndex:indexPath.row];
    [Cell.visitorImg setImage:[UIImage imageNamed:@"placeholder"]];
    
    
    UIImage *image = [UIImage imageNamed:@"placeholder" ];
    if([oneVisitorDict valueForKey:kBASE64_VISITOR_IMAGE] != nil ) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString: [oneVisitorDict valueForKey:kBASE64_VISITOR_IMAGE] options:0];
        image = [UIImage imageWithData:decodedData];
        Cell.visitorImg.image = image;
    }else{
        
        Cell.visitorImg.image = image;
    }
    
    Cell.visitorName.text = [oneVisitorDict valueForKey:kVISITOR_NAME];
    Cell.licencePlate.text = [oneVisitorDict valueForKey:kLICENCE_PLATE];
    return Cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UpdateVisitorVC *detailVc = [storyBoard instantiateViewControllerWithIdentifier:@"UpdateVisitorVC"];
    
    NSMutableDictionary *oneVisitorDict = [[visitorsAry objectAtIndex:indexPath.row] mutableCopy];
    
    detailVc.visitorImg1= [oneVisitorDict valueForKey:kBASE64_VISITOR_IMAGE];
    
    detailVc.userNameStr=_nameStr;
    detailVc.locationStr=_lctnStr;
    detailVc.currentNameStr=_currentUsrName.text;
    detailVc.userIdStr=_idStr;
    
    detailVc.visitorName1 = [oneVisitorDict valueForKey:kVISITOR_NAME];
    detailVc.cmpnyName1 = [oneVisitorDict valueForKey:kCOMPANY_NAME];
    detailVc.checkInTime1 = [[oneVisitorDict valueForKey:kCHECK_IN_DATE] stringByAppendingString:[@" " stringByAppendingString: [oneVisitorDict valueForKey:kCHECK_IN_TIME]]];
    detailVc.checkinId1 = [oneVisitorDict valueForKey:kVISITOR_CHECK_IN_ID];
    
    detailVc.timeStamp = [oneVisitorDict valueForKey:kTIME_STAMP];
    detailVc.vistorDic = oneVisitorDict;
    
    NSLog(@"%@",detailVc.visitorImg1);
    
    NSLog(@"visitorImage: %@",detailVc.visitorImg1);
    
    NSLog(@"company name: %@",detailVc.cmpnyName1);
    NSLog(@"checkIn Time: %@",detailVc.checkInTime1);
    
    NSLog(@"Visitor's checkIn Id: %@",detailVc.checkinId1);
    NSLog(@"User Id: %@",detailVc.userIdStr);
    NSLog(@"visitor Name: %@",detailVc.visitorName1);
    
    
    [self.navigationController pushViewController:detailVc animated:YES];
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

-(void)removeNotificationObserver{
    
    [self updateVisitorsServices];
}

-(void)updateVisitorsServices
{
    
    
    //    NSString *parm =
    NSString *parm = [NSString stringWithFormat:@"findvisitor/%@", _userIdStr];
    NSLog(@"%@", parm);
    
    [JsonHelperClass getExecuteWithParams:parm  secondParm:nil onCompletion:^(NSDictionary *json){
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){

            
            [self getDataFromLocalDataBase];
            
            NSArray *allVisitorsArray = [json valueForKey:@"data"];
            if(allVisitorsArray.count>0){ 
                [self addUserFromServerResponse:allVisitorsArray];
                [self removeCheckOutUserFromLocal:allVisitorsArray];
                [self saveDataFromApiToLocalDataBase:visitorsAry];
                if(checkOutVistorAry.count>0){
                    [self changeStatusOfCheckOutUser:allVisitorsArray];
                }
            }
            [self copyVistorArrayToSearchArray];
            [self.collectionView reloadData];
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
    }];
}

-(void) addUserFromServerResponse:(NSArray *)allVisitorsArray{
    
    
    
    NSArray *localVisitorsTimeStampAry = [visitorsAry valueForKey:kTIME_STAMP];
    NSInteger allVisitorsArrayCount = allVisitorsArray.count;
    NSInteger localVisitorsTimeStampAryCount = localVisitorsTimeStampAry.count;
    checkOutVistorAry = [NSMutableArray new];
    
    NSString *filepath=[self dataFilePath];
    
    NSMutableDictionary *regDictionary= [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i<allVisitorsArrayCount; i++) {
        NSMutableDictionary * vistorDic = [allVisitorsArray[i] mutableCopy];
        if(localVisitorsTimeStampAryCount>0){
            NSInteger index = [localVisitorsTimeStampAry indexOfObject:[vistorDic valueForKey:kTIME_STAMP]];
            
            if(index == NSNotFound){
                [self changeVistoreImagesUrlToByte64String:vistorDic ];
            }else{
                
                NSMutableDictionary * localVistorDic = [visitorsAry objectAtIndex:index];
                
                if(![[localVistorDic valueForKey:kCHECK_OUT_DATE]  isEqual: @"in"]){
                    [checkOutVistorAry addObject:localVistorDic];
                    [visitorsAry removeObjectAtIndex:index];
                }else{
                    if([[localVistorDic valueForKey:kVISITOR_CHECK_IN_ID] isEqualToString:@""]){
                        [localVistorDic setValue:[vistorDic valueForKey:kVISITOR_CHECK_IN_ID] forKey:kVISITOR_CHECK_IN_ID];
                        
                        //NSString *filepath=[self dataFilePath];
                        
                        if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                            
                            regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
                            
                            NSMutableArray *tempAry = [regDictionary valueForKey:kVISIORS_ARRAY];
                            
                            if(tempAry.count>0){
                                [tempAry replaceObjectAtIndex:index withObject:localVistorDic];
                                [regDictionary setValue:tempAry forKey:kVISIORS_ARRAY];
                                [regDictionary writeToFile:filepath atomically:YES];
                            }
                        }

                    }
                    
                    
                    
                }
                
            }
            
        }else{
            [self changeVistoreImagesUrlToByte64String:vistorDic];
        }
        vistorDic = nil;
    }
}

-(void)removeCheckOutUserFromLocal:(NSArray *)allVisitorsArray{
    
    NSArray *allVisitorsTimeStampAry = [allVisitorsArray valueForKey:kTIME_STAMP];
    for (int i = 0; i<visitorsAry.count; i++) {
        
        NSMutableDictionary * vistorDic = [visitorsAry[i] mutableCopy];
        
        NSInteger index = [allVisitorsTimeStampAry indexOfObject:[vistorDic valueForKey:kTIME_STAMP]]
        ;
        if(index != NSNotFound){
            NSString *filepath=[self dataFilePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                
                NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
                
                
                NSLog(@"%@", regDictionary);
                
                NSArray *tempAry = [regDictionary valueForKey:kVISIORS_ARRAY];
                
                if(tempAry.count>0){
                    NSArray *tempAryTimeStampAry = [tempAry valueForKey:kTIME_STAMP];
                    index = [tempAryTimeStampAry indexOfObject:[vistorDic valueForKey:kTIME_STAMP]];
                    if(index != NSNotFound){
                        vistorDic = [tempAry objectAtIndex:index];
                        if(![[vistorDic valueForKey:kCHECK_OUT_DATE] isEqualToString:@"in"])
                        {
                            [checkOutVistorAry addObject:vistorDic];
                            if([[vistorDic valueForKey:kTIME_STAMP] isEqualToString:[visitorsAry[i] valueForKey:kTIME_STAMP]]){
                                [visitorsAry removeObjectAtIndex:i];
                            }
                        }
                    }
                    

                }
            }
        }
    }
}



-(void)changeVistoreImagesUrlToByte64String:(NSMutableDictionary*)vistorDic {
    
    NSURL *imageUrl = [NSURL URLWithString:[vistorDic valueForKey:kBASE64_VISITOR_IMAGE]];
    NSString *base64Img = [self ImageFromUrl:imageUrl];
    if (base64Img != nil){
        [vistorDic setObject:base64Img forKey:kBASE64_VISITOR_IMAGE];
    }
    
    imageUrl = [NSURL URLWithString:[vistorDic valueForKey:kBASE64_LICENCE_IMAGE]];
    base64Img = [self ImageFromUrl:imageUrl];
    if (base64Img != nil){
        [vistorDic setObject:base64Img forKey:kBASE64_LICENCE_IMAGE];
    }
    
    
    imageUrl = [NSURL URLWithString:[vistorDic valueForKey:kBASE64_CHECK_IN_IMAGE]];
    base64Img = [self ImageFromUrl:imageUrl];
    if (base64Img != nil){
        [vistorDic setObject:base64Img forKey:kBASE64_CHECK_IN_IMAGE];
    }
    
    [visitorsAry addObject:vistorDic];
    

    
    imageUrl = nil;
    base64Img = nil;
    vistorDic = nil;
}

-(NSDictionary *)updateVisitorsParams
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    //params[@"location"] = _lctnStr;
    
    params[@"id"] = _userIdStr;
    
    return params;
    
}

-(void)checkNetworkConnection {
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        needToCheckOnline = false;
        [self getDataFromLocalDataBase];
        [self copyVistorArrayToSearchArray];
        [self.collectionView reloadData];
        
    }
    else
    {
        needToCheckOnline = true;
        //[self getDataFromLocalDataBase];
        [self updateVisitorsServices];
        [self.collectionView reloadData];
        
    }
}

-(void)getDataFromLocalDataBase {
    
    NSString *filepath=[self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        
        NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        
        
        NSLog(@"%@", regDictionary);
        //get data from DB
        visitorsAry = [NSMutableArray new];
        if (visitorsAry == nil){
            visitorsAry = [NSMutableArray new];
        }
        
        NSArray *tempAry = [regDictionary valueForKey:kVISIORS_ARRAY];
        NSString * userIdStr =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUSER_ID_STR]];
        
        
        
        for (NSMutableDictionary *tempDict in tempAry){
            if ([[tempDict valueForKey:kCHECK_OUT_DATE] isEqualToString:@"in"] &&
                [[tempDict valueForKey:kSECURITY_ID] isEqualToString:userIdStr]){
                [visitorsAry addObject:tempDict];
            }
        }
        
        NSLog(@"my registration dictionary is %@",regDictionary);
        
    }
    else {
        if (needToCheckOnline == false){
            [reuseObj showAlertMsg:@"No data Available" secondParm:self];
        }
    }
    
    if (needToCheckOnline == false){
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }
    
}
// Save data to database
-(void)saveDataFromApiToLocalDataBase:(NSMutableArray *) visitAry {
    
    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
    NSString *filepath=[self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    }else{
        NSFileManager *filemanager=[NSFileManager defaultManager];
        [filemanager createFileAtPath:filepath contents:nil attributes:regDictionary];
    }
    
    NSMutableArray *tempArray1 = [regDictionary valueForKey:kVISIORS_ARRAY];
    
    if(tempArray1!=nil){
    NSArray *tempAry2 = [tempArray1 valueForKey:kTIME_STAMP];
    
    for (int i=0; i<visitAry.count; i++) {
        NSMutableDictionary* dict =[visitAry[i]mutableCopy];
        NSInteger index = [tempAry2 indexOfObject:[dict valueForKey:kTIME_STAMP]];
        
        if(index==NSNotFound){
            [tempArray1 addObject:dict];
        }
    }
        [regDictionary setValue:tempArray1 forKey:kVISIORS_ARRAY];
    }else{
        [regDictionary setValue:visitAry forKey:kVISIORS_ARRAY];
    }
    
   
    
    

    
    //set values
    
    
    NSLog(@"my registration dictionary is %@",regDictionary);
    
    [regDictionary writeToFile:filepath atomically:YES];
    
    
}


-(NSString *)dataFilePath{
    NSArray *documentArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir=[documentArray objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"register.plist"];
}

-(NSString *)ImageFromUrl:(NSURL *) url {
    
    NSData * imgData = [NSData dataWithContentsOfURL:url]; ;
    
    NSString *newbase64VistorImg = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return  newbase64VistorImg;
}

-(void)changeStatusOfCheckOutUser :(NSArray *)allVisitorsArray {
    
    for (int i = 0 ; i<checkOutVistorAry.count; i++) {
        
        NSMutableDictionary *dicVistor = [[checkOutVistorAry objectAtIndex:i] mutableCopy];
        
        [JsonHelperClass postExecuteWithParams:@"checkoutComplete"  secondParm:dicVistor onCompletion:^(NSDictionary *json) {
            
            if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
                NSDictionary *dict =[NSDictionary new];
                NSString *filepath=[self dataFilePath];
                 dict= [json valueForKey:@"data"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
                    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
                    
                    NSMutableArray *vistorArraytemp = [regDictionary valueForKey:kVISIORS_ARRAY];
                    NSArray *tempAry2 = [vistorArraytemp valueForKey:kTIME_STAMP];
                    
                    NSInteger index = [tempAry2 indexOfObject:[dict valueForKey:kTIME_STAMP]];
                    if(index!=NSNotFound){
                        [vistorArraytemp removeObjectAtIndex:index];
                    }
                    
                    [regDictionary setValue:vistorArraytemp forKey:kVISIORS_ARRAY];
                    
                    NSLog(@"my registration dictionary is %@",regDictionary);
                    
                    [regDictionary writeToFile:filepath atomically:YES];
                }
                
            }
        }];
        
        
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strSearch= @"";
    
    if (range.length == 0) {
        strSearch = [textField.text stringByAppendingString:string];
    } else {
        strSearch = [textField.text substringToIndex:textField.text.length-1];
    }
    
    if(textField==_txtFldSearch) {
        [self searchPredicate:strSearch];
    }
    
    return YES;
}



#pragma mark - Search Predicate
-(void)searchPredicate:(NSString *)searchText {
    
    [visitorsAry removeAllObjects];
    //[arrayUnisTemp removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"licence_plate CONTAINS[cd] %@",searchText];
    
    visitorsAry = [NSMutableArray arrayWithArray:[visitorsSearchAry filteredArrayUsingPredicate:resultPredicate]];
    //visitorsAry = [NSMutableArray arrayWithArray:[visitorsAry filteredArrayUsingPredicate:resultPredicate]];
    
    if (visitorsAry.count==0) {
        if(![searchText isEqualToString:@""]){
            [self.collectionView setHidden:YES];
        }else{
            [self.collectionView setHidden:NO];
        }
        [visitorsAry addObjectsFromArray:visitorsSearchAry];
        
//        tbSchoolList.hidden = YES;
//        [viewMajor removeFromSuperview];
    }else{
        [self.collectionView setHidden:NO];
    }
    [self.collectionView reloadData];
    //else {
        
//        if (![self.view.subviews containsObject:viewMajor]) {
//            viewMajor.frame = CGRectMake(imgSearch.frame.origin.x,imgSearch.frame.origin.y+imgSearch.frame.size.height + 2, self.view.frame.size.width,self.view.frame.size.height - 54  );
//            viewMajor.hidden=true;
//            //[self.view addSubview:viewMajor];
//        }
//        tbSchoolList.hidden = NO;
  //  }
    
//    if (searchText.length==0) {
//        arraySchoolTemp = [arraySchool mutableCopy];
//        arrayUnisTemp = [arrayUnis mutableCopy];
//        tbSchoolList.hidden = NO;
//        if (![self.view.subviews containsObject:viewMajor]) {
//            viewMajor.frame = CGRectMake(imgSearch.frame.origin.x,imgSearch.frame.origin.y+imgSearch.frame.size.height + 2, self.view.frame.size.width,self.view.frame.size.height - 54  );
//            viewMajor.hidden=true;
//            //[self.view addSubview:viewMajor];
//        }
//    }
//    
//    [tbSchoolList reloadData];
//    
//    tbSchoolList.scrollsToTop = YES;
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
//    [tbSchoolList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

-(void) copyVistorArrayToSearchArray{
    if(visitorsSearchAry.count>0){
        [visitorsSearchAry removeAllObjects];
    }
    [visitorsSearchAry addObjectsFromArray:visitorsAry];
}

@end
