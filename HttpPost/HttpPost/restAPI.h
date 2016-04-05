//
//  restAPI.h
//  fetchHelloWorld
//
//  Created by GDB Consultants on 21/03/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@class restAPI;
@protocol restAPIDelegate

-(void)getReceivedData:(NSMutableData *)data sender:(restAPI *)sender;
@end

@interface restAPI : NSObject

-(void)httpRequest:(NSMutableURLRequest *)request;

@property(nonatomic , weak) id <restAPIDelegate> delegate;

@end

#define POST @"POST"
#define GET  @"GET"