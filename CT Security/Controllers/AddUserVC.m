//
//  AddUserVC.m
//  CT Security
//
//  Created by Media3 on 9/28/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import "AddUserVC.h"

@interface AddUserVC ()
{
    Reuse * reuseObj;
}

@end

@implementation AddUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    reuseObj = [[Reuse alloc]init];
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == _userNameTxtFld) {
        
        [self.emailTxtFld becomeFirstResponder];
    }
    if (textField == _emailTxtFld) {
        
        [self.locationTxtFld becomeFirstResponder];
    }
    
    else {
        [self.locationTxtFld resignFirstResponder];
    }
    
    return YES;
}



- (IBAction)submitBtn:(id)sender {
    [self.view endEditing:YES];
    
    
    if(self.userNameTxtFld.text.length != 0) {
        
        if(self.emailTxtFld.text.length != 0) {
            
            if(self.locationTxtFld.text.length != 0) {
                
                [self addUsersServices];
                
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

- (IBAction)backBtn:(id)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransactionDisableActions;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)addUsersServices
{
    [JsonHelperClass postExecuteWithParams:@"addUser"  secondParm:[self addUsersParams] onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            
            
            NSDictionary *dict =[NSDictionary new];
            
            dict= [json valueForKey:@"data"];
            
            
            NSLog(@"%@",dict);
            [self getUsersServices];
        }
        
        else {
            
         [reuseObj showAlertMsg:@"Please enter valid Details" secondParm:self];
            
        }
        
    }];
    
}

-(NSDictionary *)addUsersParams
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"username"] = _userNameTxtFld.text;
    params[@"email"] = _emailTxtFld.text;
    params[@"location"] = _locationTxtFld.text;
    
    return params;
    
}

-(void)getUsersServices
{
    
    [JsonHelperClass getExecuteWithParams:@"users"  secondParm:nil onCompletion:^(NSDictionary *json) {
        
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]){
            NSArray* _pickerArray = [json valueForKey:@"users"];
            [self saveUserListToLocalDB:_pickerArray];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CT Security"
                                                                                     message:@"New User Added Successfully ."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okBtnAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                          {
                                              UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                              
                                              HomeVC *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
                                              [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"str"];
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
        
        
    }];
    
    //[self.pickerRef reloadAllComponents];
    [MBProgressHUD hideHUDForView:self.view animated:true];
}


-(void)saveUserListToLocalDB: (NSMutableArray *) usersInfoAry {
    
    NSMutableDictionary *regDictionary=[NSMutableDictionary dictionary];
    NSString *filepath=[self UserListFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        
        regDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        
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

-(NSString *)UserListFilePath{
    NSArray *documentArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir=[documentArray objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"listOfUsers.plist"];
}

@end
