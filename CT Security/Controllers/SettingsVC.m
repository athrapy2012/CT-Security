//
//  SettingsVC.m
//  CT Security
//
//  Created by Media3 on 7/3/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()
{
    Reuse * reuseObj;
    NSMutableDictionary *dictionary;
    NSMutableArray *nameArr;
    NSMutableArray *dateArr;
    NSMutableArray *companyArr;
    NSMutableArray *licenseArr ;
    NSMutableArray *userIdArr ;
    NSMutableArray *visitorImgArr ;
    NSMutableArray *licenseImgArr ;
    NSMutableArray *checkInImgArr;
    NSMutableArray *checkintimeArr;
    NSMutableArray *checkindateArr;
    NSMutableArray *locationArr;
    int i;
    NSString * iAmFromBtn;
    NSMutableArray *allUsersAry;
}
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    allUsersAry = [[NSMutableArray alloc]init];
    reuseObj = [[Reuse alloc]init];
    _userView.layer.cornerRadius=5;
    _userView.layer.borderWidth = 0.5f;
    
    _locationView.layer.cornerRadius=5;
    _locationView.layer.borderWidth = 0.5f;
    
    _pickerView.hidden = YES;
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"str"] isEqualToString:@"yes"])
    {
        _currentUsrName.text = [[NSString alloc]initWithString:_currentUsernameStr];
        _userLbl.text = [[NSString alloc]initWithString:_currentUsernameStr];
        
        _locationLbl.text = [[NSString alloc]initWithString:_currentUserlctnStr];
        _currentUseridStr1 = [[NSString alloc]initWithString:_currentUseridStr];
        _idStr = _currentUseridStr1;
        
        [[NSUserDefaults standardUserDefaults] setObject:_currentUseridStr1 forKey:@"userId"];
        
        NSLog(@"%@",_currentUsrName.text);
        NSLog(@"%@",_currentUserlctnStr1);
        NSLog(@"%@",_currentUseridStr1);
        
    }
    
    else {
        _currentUsernameStr1 = @"";
        _currentUserlctnStr1 = @"";
        _currentUseridStr1 = @"";
        
    }
    // timer is set & will be triggered each second
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    _timeLbl.text=dateString;
    
    [self retrivePlistData];
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

- (IBAction)userBtn:(id)sender {
    iAmFromBtn = @"first";
    _pickerView.hidden = NO;
    [self.pickerRef reloadAllComponents];
    
    
}
- (IBAction)locationBtn:(id)sender {
    iAmFromBtn = @"second";
    
    _pickerView.hidden = NO;
    [self.pickerRef reloadAllComponents];
}

- (IBAction)manualSync:(id)sender {
    
    
    if (([_userLbl.text isEqualToString:@"Current User Name"])){
        
        [reuseObj showAlertMsg:@"Please Select valid Current User Name" secondParm:self];
    }
    else if (([_locationLbl.text isEqualToString:@"Current Location"])){
        
        [reuseObj showAlertMsg:@"Please Select valid Current Location" secondParm:self];
    }
    
    else {
        [self addVisitorServices];
        
    }
    
}

- (IBAction)submitBtn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"str"];
    
    
    if (([_userLbl.text isEqualToString:@"Select User Name"])){
        
        [reuseObj showAlertMsg:@"Please Select valid Current User Name" secondParm:self];
    }
    else if (([_locationLbl.text isEqualToString:@"Select Location"])){
        
        [reuseObj showAlertMsg:@"Please Select valid Current Location" secondParm:self];
    }
    
    
    else {
        
        
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
        homeVC.userNameStr=_userLbl.text;
        homeVC.locationStr=_locationLbl.text;
        homeVC.currentNameStr=_currentUsrName.text;
        homeVC.userIdStr=_idStr;
        [[NSUserDefaults standardUserDefaults] setObject:_idStr forKey:kUSER_ID_STR];
        
        [AppDelegate shared].userIdStr=_idStr;
        [[AppDelegate shared] callApis];
        
        NSLog(@"userId is: %@",_idStr);
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransactionDisableActions;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        
        [self.navigationController pushViewController:homeVC animated:NO];
        
    }
    
}

- (IBAction)doneBtn:(id)sender {
    
    _pickerView.hidden = YES;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([iAmFromBtn isEqualToString:@"first" ])
    {
        
        return _pickerArr.count;
    }
    else
        
    {
        return _pickerArr1.count;
        
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([iAmFromBtn isEqualToString:@"first" ])
    {
        
        return [_pickerArr objectAtIndex:row];
    }
    else
        
    {
        return [_pickerArr1 objectAtIndex:row];
        
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ((_idArr.count == 0) || (_pickerArr1.count == 0)){
        return;
    }
    else{
    if ([iAmFromBtn isEqualToString:@"first" ])
        
    {
        
        NSString *userid =[_idArr objectAtIndex:row];
        
        
        NSString *title = [_pickerArr objectAtIndex:row];
        _userLbl.text=title;
        _currentUsrName.text=title;
        _idStr=userid;
        _userLbl.textColor=[UIColor blackColor];
        NSLog(@"%@",userid);
    }
    
    else
        
    {
        NSString *title = [_pickerArr1 objectAtIndex:row];
        _locationLbl.text=title;
        _locationLbl.textColor=[UIColor blackColor];
        
    }
    
    }
}

-(void)getUsersServices
{
    
    [JsonHelperClass getExecuteWithParams:@"users"  secondParm:nil onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            
            _pickerArray = [json valueForKey:@"users"];
            
            [allUsersAry removeAllObjects];
            allUsersAry = _pickerArray;
            
            [self saveUserListToLocalDB:allUsersAry];
            
            for (NSDictionary *dict in _pickerArray)
            {
                
                [_pickerArr addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]]];
                [_pickerArr1 addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]]];
                [_idArr addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"_id"]]];
            }
        }
        
        
    }];
    
    [self.pickerRef reloadAllComponents];
    [MBProgressHUD hideHUDForView:self.view animated:true];
}

-(void)addVisitorServices
{
    [JsonHelperClass postExecuteWithParams:@"addvisitors"  secondParm:[self addVisitorParams] onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            
            
            NSDictionary *dict =[NSDictionary new];
            
            dict= [json valueForKey:@"data"];
            
            [[NSUserDefaults standardUserDefaults]setObject:@"userId" forKey:[dict valueForKey:@"_id"]];
            NSLog(@"plist data %@",dict);
            
            [self removePlistData];
            
        }
        
        
    }];
    
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
    
    nameArr = [[NSMutableArray alloc]init];
    companyArr = [[NSMutableArray alloc]init];
    licenseArr = [[NSMutableArray alloc]init];
    userIdArr = [[NSMutableArray alloc]init];
    checkintimeArr = [[NSMutableArray alloc]init];
    checkindateArr = [[NSMutableArray alloc]init];
    visitorImgArr = [[NSMutableArray alloc]init];
    licenseImgArr = [[NSMutableArray alloc]init];
    checkInImgArr = [[NSMutableArray alloc]init];
    locationArr = [[NSMutableArray alloc]init];
    
    nameArr = [dict objectForKey:@"name"];
    companyArr = [dict objectForKey:@"company"];
    licenseArr = [dict objectForKey:@"licence"];
    userIdArr = [dict objectForKey:@"userId"];
    checkindateArr = [dict objectForKey:@"date"];
    checkintimeArr = [dict objectForKey:@"time"];
    visitorImgArr = [dict objectForKey:@"visitorImg"];
    licenseImgArr = [dict objectForKey:@"licenseImg"];
    checkInImgArr = [dict objectForKey:@"checkInImg"];
    locationArr = [dict objectForKey:@"location"];
    
    NSLog(@" data from plist %@",dict);
}

-(void)checkNetworkConnection {
    _pickerArr=[[NSMutableArray alloc]init];
    _pickerArr1=[[NSMutableArray alloc]init];
    _idArr=[[NSMutableArray alloc]init];
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self GetUserListFromLocalDB];
    }
    else
    {
        [self getUsersServices];
        
    }
}



-(NSDictionary *)addVisitorParams
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    
    if ((nameArr.count!=0)) {
        params[@"name"] =[nameArr objectAtIndex:0];
        params[@"company_name"] = [companyArr objectAtIndex:0];
        params[@"licence_plate"] = [licenseArr objectAtIndex:0];
        params[@"checkindate"] = [checkindateArr objectAtIndex:0];
        params[@"checkintime"] = [checkintimeArr objectAtIndex:0];
        params[@"location"] = [locationArr objectAtIndex:0];;
        params[@"security_id"] =[userIdArr objectAtIndex:0];
        params[@"visitor_image"] =[visitorImgArr objectAtIndex:0];
        params[@"file"] = [licenseImgArr objectAtIndex:0];
        params[@"file2"] = [checkInImgArr objectAtIndex:0];
        
    }
    
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
                                                                                 message:@"No data available."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                      {
                                          [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"str"];
                                          
                                          if (([_userLbl.text isEqualToString:@"Select User Name"])){
                                              
                                              [reuseObj showAlertMsg:@"Please Select valid Current User Name" secondParm:self];
                                          }
                                          else if (([_locationLbl.text isEqualToString:@"Select Location"])){
                                              
                                              [reuseObj showAlertMsg:@"Please Select valid Current Location" secondParm:self];
                                          }
                                          
                                          
                                          else {
                                              
                                              
                                              
                                              UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                              
                                              HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
                                              homeVC.userNameStr=_userLbl.text;
                                              homeVC.locationStr=_locationLbl.text;
                                              homeVC.currentNameStr=_currentUsrName.text;
                                              homeVC.userIdStr=_idStr;
                                              NSLog(@"%@",_idStr);
                                              CATransition* transition = [CATransition animation];
                                              transition.duration = 0.5f;
                                              transition.type = kCATransitionMoveIn;
                                              transition.subtype = kCATransactionDisableActions;
                                              [self.navigationController.view.layer addAnimation:transition
                                                                                          forKey:kCATransition];
                                              
                                              [self.navigationController pushViewController:homeVC animated:NO];
                                              
                                          }
                                          
                                      }];
        
        [alertController addAction:okBtnAction];
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    
    return params;
    
}



-(void)removePlistData {
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"register.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"register" ofType:@"plist"];
    }
    
    dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:(NSString *)plistPath];
    
    nameArr = [dictionary objectForKey:@"name"];
    companyArr = [dictionary objectForKey:@"company"];
    licenseArr = [dictionary objectForKey:@"licence"];
    checkInImgArr = [dictionary objectForKey:@"checkInImg"];
    userIdArr = [dictionary objectForKey:@"userId"];
    dateArr = [dictionary objectForKey:@"date"];
    visitorImgArr = [dictionary objectForKey:@"visitorImg"];
    licenseImgArr = [dictionary objectForKey:@"licenseImg"];
    checkindateArr = [dictionary objectForKey:@"date"];
    checkintimeArr = [dictionary objectForKey:@"time"];
    locationArr = [dictionary objectForKey:@"location"];
    
    [nameArr removeObjectAtIndex:0];
    [companyArr removeObjectAtIndex:0];
    [licenseArr removeObjectAtIndex:0];
    [userIdArr removeObjectAtIndex:0];
    [visitorImgArr removeObjectAtIndex:0];
    [licenseImgArr removeObjectAtIndex:0];
    [checkInImgArr removeObjectAtIndex:0];
    [checkindateArr removeObjectAtIndex:0];
    [checkintimeArr removeObjectAtIndex:0];
    [locationArr removeObjectAtIndex:0];
    
    NSLog(@"%lu",(unsigned long)nameArr.count);
    [dictionary writeToFile:plistPath atomically:YES];
    
    
    if ((nameArr.count!=0)) {
        
        [self addVisitorServices];
        
    }
    
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
                                                                                 message:@"Data synchronisation successfull."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                      {
                                          [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"str"];
                                          
                                          UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                          
                                          HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
                                          homeVC.userNameStr=_userLbl.text;
                                          homeVC.locationStr=_locationLbl.text;
                                          homeVC.currentNameStr=_currentUsrName.text;
                                          homeVC.userIdStr=_idStr;
                                          NSLog(@"%@",_idStr);
                                          NSLog(@"%@",homeVC.userNameStr);
                                          NSLog(@"%@",homeVC.locationStr);
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
    
    
}


- (IBAction)addUserBtn:(id)sender {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
    [reuseObj showAlertMsg:@"Please Connect to Internet" secondParm:self];
    }
    else{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddUserVC *addUserVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddUserVC"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransactionDisableActions;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController pushViewController:addUserVC animated:NO];
    
    }
}

//- (IBAction)assignJobBtn:(id)sender {
//
//
//    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"str"];
//
//     [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"Merging"];
//
//    if (([_userLbl.text isEqualToString:@"Current User Name"])){
//
//        [reuseObj showAlertMsg:@"Please Select valid Current User Name" secondParm:self];
//    }
//    else if (([_locationLbl.text isEqualToString:@"Current Location"])){
//
//        [reuseObj showAlertMsg:@"Please Select valid Current Location" secondParm:self];
//    }
//
//
//    else {
//
//
//
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//        HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
//        homeVC.userNameStr=_userLbl.text;
//        homeVC.locationStr=_locationLbl.text;
//        homeVC.currentNameStr=_currentUsrName.text;
//        homeVC.userIdStr=_idStr;
//        NSLog(@"%@",_idStr);
//        CATransition* transition = [CATransition animation];
//        transition.duration = 0.5f;
//        transition.type = kCATransitionMoveIn;
//        transition.subtype = kCATransactionDisableActions;
//        [self.navigationController.view.layer addAnimation:transition
//                                                    forKey:kCATransition];
//
//        [self.navigationController pushViewController:homeVC animated:NO];
//
//    }
//
//}

-(void)saveUserListToLocalDB: (NSMutableArray *) usersInfoAry {
    
    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
    NSString *filepath=[self UserListFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        
        NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        
        //set values
        [regDictionary setValue:usersInfoAry forKey:@"usersAry"];
        
        
        
        NSLog(@"my registration dictionary is %@",regDictionary);
        
        [regDictionary writeToFile:filepath atomically:YES];
        
    }
    
    else {
        
        NSFileManager *filemanager=[NSFileManager defaultManager];
        
        [filemanager createFileAtPath:filepath contents:nil attributes:regDictionary];
        //set value for key
        [regDictionary setValue:usersInfoAry forKey:@"usersAry"];
        
        [regDictionary writeToFile:filepath atomically:YES];
        
        NSLog(@" Users data is %@",regDictionary);
        
    }
    
    
    
}

-(void)GetUserListFromLocalDB {
    
    
    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
    NSString *filepath=[self UserListFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        
        NSMutableDictionary *regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        //get previous values1
        [allUsersAry removeAllObjects];
        allUsersAry=[regDictionary valueForKey:@"usersAry"];
        NSLog(@"All users Data is %@",regDictionary);
    }
    
    else {
        //[self ShowAlert:@"Alert" msg:@"No User Available"];
        [reuseObj showAlertMsg:@"No User Available" secondParm:self];    }
    
    _pickerArray = allUsersAry.mutableCopy;
    for (NSDictionary *dict in _pickerArray)
    {
        
        [_pickerArr addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]]];
        [_pickerArr1 addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]]];
        [_idArr addObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"_id"]]];
        
        
    }
    
    
    [self.pickerRef reloadAllComponents];
    [MBProgressHUD hideHUDForView:self.view animated:true];
    
}



-(NSString *)UserListFilePath{
    NSArray *documentArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir=[documentArray objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"listOfUsers.plist"];
}

-(void)ShowAlert: (NSString *) title  msg: (NSString *) message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okBtnAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
