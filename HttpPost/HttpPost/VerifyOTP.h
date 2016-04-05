//
//  VerifyOTP.h
//  HttpPost
//
//  Created by GDB Consultants on 25/03/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyOTP : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberlabel;
@property (weak, nonatomic) IBOutlet UITextField *Otpinput;
@property(nonatomic,strong) NSString *number;
@property(nonatomic,strong)NSString *receivedId;

- (IBAction)verifyotp:(id)sender;

@end
