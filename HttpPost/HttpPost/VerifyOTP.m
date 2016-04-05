//
//  VerifyOTP.m
//  HttpPost
//
//  Created by GDB Consultants on 25/03/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import "VerifyOTP.h"
#import "restAPI.h"

@interface VerifyOTP ()<restAPIDelegate>

@property(nonatomic , strong) restAPI *restApi;

@end


@implementation VerifyOTP

@synthesize numberlabel;
@synthesize number;
@synthesize receivedId;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.Otpinput.delegate=self;
    self.numberlabel.text=number;
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
    NSString *Id=receivedId;
    NSString *otp=self.Otpinput.text;
    
    NSString *str =@"http://localhost:3000/verifyOTP";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:POST];
    NSString *pstring=[NSString stringWithFormat:@"id=%@&otp=%@",Id,otp];
   // pstring = [pstring stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [request setHTTPBody:[pstring dataUsingEncoding:NSUTF8StringEncoding]];
    self.restApi.delegate=self;
    [self.restApi httpRequest:request];
    
}

-(void)getReceivedData:(NSMutableData *)data sender:(restAPI *)sender{
    
    NSError *error=nil;
    NSDictionary *receiveddata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
}


- (IBAction)verifyotp:(id)sender {
    
    [self httppostrequest];
}
@end
