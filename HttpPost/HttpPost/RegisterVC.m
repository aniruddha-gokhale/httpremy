//
//  RegisterVC.m
//  HttpPost
//
//  Created by GDB Consultants on 25/03/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import "RegisterVC.h"
#import "restAPI.h"
#import "VerifyOTP.h"

@interface RegisterVC ()<restAPIDelegate>

@property(nonatomic , strong) restAPI *restApi;

@end

@interface RegisterVC ()

@end

@implementation RegisterVC{
    
    NSString *receivedid;
    NSString *status;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Numberfield.delegate=self;
    self.NameField.delegate=self;
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"verifyotp"]) {
        
        
        VerifyOTP *destViewController = segue.destinationViewController;
        destViewController.number=[NSString stringWithFormat:@"+91-%@", self.Numberfield.text ];
        destViewController.receivedId=receivedid;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(restAPI *) restApi
{
    
    if(!_restApi){
        
        _restApi =[[restAPI alloc  ]init];
    }
    
    return _restApi;
}

-(void)httppostrequest
{
    NSString *number=[NSString stringWithFormat:@"+91-%@", self.Numberfield.text ];
    NSString *name =self.NameField.text;
    NSString *pushid=@"regpushid";
    
    NSString *str =@"http://localhost:3000/register";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:POST];
   // NSString *postString = @"number=%2B91-9890098900&pushId=testpush&name=gokhale2";
    NSString *pstring=[NSString stringWithFormat:@"number=%@&name=%@&pushId=%@",number,name,pushid];
    pstring = [pstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [request setHTTPBody:[pstring dataUsingEncoding:NSUTF8StringEncoding]];
    self.restApi.delegate=self;
    [self.restApi httpRequest:request];
    
}

-(void)getReceivedData:(NSMutableData *)data sender:(restAPI *)sender{
    
    NSError *error=nil;
    NSDictionary *receiveddata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    receivedid=[receiveddata objectForKey:@"id"];
    status=[receiveddata objectForKey:@"status"];
    
    if ([status isEqualToString:@"Success"]) {
        [self performSegueWithIdentifier:@"verifyotp" sender:self];
    }
    
}

- (IBAction)RegisterButton:(id)sender {
    
    [self httppostrequest];
   
    
}




@end
