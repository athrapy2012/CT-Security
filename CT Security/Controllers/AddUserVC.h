//
//  AddUserVC.h
//  CT Security
//
//  Created by Media3 on 9/28/17.
//  Copyright © 2017 Media3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUserVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *locationTxtFld;
- (IBAction)submitBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
