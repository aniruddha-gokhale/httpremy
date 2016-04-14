//
//  Contacts.h
//  Remy
//
//  Created by GDB Consultants on 16/02/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Contacts : UITableViewController<UITableViewDataSource,UITabBarDelegate>{
    
    NSMutableArray *searchname;
}

@property(nonatomic, strong)NSMutableArray *contactList;
@property(nonatomic, strong)NSMutableArray *fetchedcontacts;
@property (weak, nonatomic) IBOutlet UITableView *tblcontacts;
- (IBAction)addToAddressbook:(id)sender;
@property(nonatomic,strong)NSString *PId;

@end
