//
//  restAPI.m
//  fetchHelloWorld
//
//  Created by GDB Consultants on 21/03/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import "restAPI.h"

@interface restAPI() <NSURLConnectionDataDelegate>

@property(nonatomic,strong)NSMutableData *receivedData;
@property (nonatomic,strong)NSURLConnection *requestConnection;
@end

@implementation restAPI

-(NSMutableData *) receivedData{
    if(!_receivedData){
        
        _receivedData = [[NSMutableData alloc]init];
    }
    return _receivedData;
}


-(NSURLConnection *) requestConnection{
    if(!_requestConnection){
        
        _requestConnection =[[NSURLConnection alloc ]init];
    }
    return _requestConnection;
}

-(void) httpRequest:(NSMutableURLRequest *)request{
    
    self.requestConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.receivedData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response{
    
    
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [self.delegate getReceivedData:self.receivedData sender:self];
    self.delegate=nil;
    self.receivedData=nil;
    self.requestConnection=nil;
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}
@end
