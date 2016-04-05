//
//  RegisterVC.h
//  HttpPost
//
//  Created by GDB Consultants on 25/03/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *Numberfield;
@property (weak, nonatomic) IBOutlet UITextField *NameField;

- (IBAction)RegisterButton:(id)sender;
@end
