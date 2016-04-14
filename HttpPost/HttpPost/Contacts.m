//
//  Contacts.m
//  Remy
//
//  Created by GDB Consultants on 16/02/16.
//  Copyright © 2016 GDB Consultants. All rights reserved.
//



#import "Contacts.h"
#import "restAPI.h"
#import <Contacts/Contacts.h>

@interface Contacts ()<restAPIDelegate>
@property(nonatomic , strong) restAPI *restApi;
@end

@implementation Contacts{
    
    NSArray *searchResults;
    
    NSMutableArray *allcontact;
    NSMutableArray *temparray;
    NSMutableString *allcontactstring;
    NSMutableArray  *gotcontacts;
 
     NSMutableArray *arrayTableData;
}

@synthesize PId;


- (void)viewDidLoad {
    [super viewDidLoad];
   [self fetchcontacts];
    [self getallcontacts];
    [self gotcontacts];
    self.tblcontacts.delegate = self;
    self.tblcontacts.dataSource = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(restAPI *) restApi
{
    
    if(!_restApi){
        
        _restApi =[[restAPI alloc  ]init];
    }
    
    return _restApi;
}

-(NSMutableArray *) contactList{
    if(!_contactList){
        
        _contactList = [[NSMutableArray alloc]init];
    }
    return _contactList;
}

-(NSMutableArray *) fetchedcontacts{
    if(!_fetchedcontacts){
        
        _fetchedcontacts = [[NSMutableArray alloc]init];
    }
    return _fetchedcontacts;
}


-(void)fetchcontacts{
    
    
    CNContactStore * store = [[CNContactStore alloc]init];
    NSArray * keytoFetch =@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
    
    NSError *err = nil;
    NSString *containerId = store.defaultContainerIdentifier;
    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
    NSArray *arrFetchedRecord  = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keytoFetch error:&err];
    
    //NSLog(@"%@",err.description);
    //NSLog(@"%@",arrFetchedRecord);
    
    NSString *phone;
    NSMutableString *phonenumber;
    NSString *fullName;
    NSString *firstName;
    NSString *lastName;
    NSMutableArray *contactNumbersArray;
    
    for (int i=0;i<arrFetchedRecord.count;i++) {
        
        CNContact *contact=[arrFetchedRecord objectAtIndex:i];
        
        firstName = contact.givenName;
        lastName =contact.familyName;
        if (lastName == nil) {
            fullName=[NSString stringWithFormat:@"%@",firstName];
            
        }else if (firstName == nil){
            fullName=[NSString stringWithFormat:@"%@",lastName];
        }
        else{
            fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
            
        }
        
        
        
        for (CNLabeledValue *label in contact.phoneNumbers) {
            phone = [label.value stringValue];
            
            phonenumber = [NSMutableString stringWithCapacity:phone.length];
            
            NSScanner *scanner = [NSScanner scannerWithString:phone];
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            
            while ([scanner isAtEnd] == NO)
            {
                NSString *buffer;
                if ([scanner scanCharactersFromSet:numbers intoString:&buffer])
                {
                    [phonenumber appendString:buffer];
                }
                else
                {
                    [scanner setScanLocation:([scanner scanLocation] + 1)];
                }
            }
            
            NSLog(@"%@", phonenumber);
            if ([phonenumber length] > 0) {
                [contactNumbersArray addObject:phonenumber];
            }
        }
        
        
        
        NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",phonenumber,@"PhoneNumbers", nil];
        
         [self.contactList addObject:personDict];
        
        
    }
    
    
    // sort alphabetically
    [self.contactList sortUsingDescriptors:
     [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fullName"
                                                            ascending:YES
                                                             selector:@selector(caseInsensitiveCompare:)]]];
    
    NSLog(@"%@",self.contactList);
    
    
    
    
}


    

   





-(void)getallcontacts{
    
    temparray =[self.contactList valueForKey:@"PhoneNumbers"];
    allcontact = [[NSMutableArray alloc]init];
    for (int i = 0; i < [temparray count]; i++) {
        id obj = [temparray objectAtIndex:i];
        if (![obj  isKindOfClass:[NSNull class]]) {
            [allcontact addObject:obj];
        }
    }
   
    
//    NSMutableString * result = [[NSMutableString alloc] init];
//    for (NSObject * obj in allcontact)
//    {
//        [result appendString:[obj description]];
//    }
//    NSLog(@"The concatenated string is %@,", result);
//    
    
//   NSMutableString *contactstring= [allcontact componentsJoinedByString:@" "];
//   NSLog(@"The concatenated string is %@", contactstring);
    
    NSString *contactstring= [allcontact componentsJoinedByString:@"+,+"];
    NSLog(@" contact string %@", contactstring);

//    NSString *string1 = [contactstring stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@")" withString:@""];
//    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *string4 = [string3 stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    
    NSLog(@" string4 %@", contactstring);
    
    allcontactstring =[NSString stringWithFormat:@"[+%@+]",contactstring];
    
    NSLog(@"%@",allcontactstring);

}




-(void)httppostrequest
{
    NSString *Id=PId;
    NSString *contacts=allcontactstring;
    
    NSString *str =@"http://localhost:3000/registeredContacts";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:POST];
    NSString *pstring1=[NSString stringWithFormat:@"id=%@&contacts=%@",Id,contacts];
    NSString *pstring2 = [pstring1 stringByReplacingOccurrencesOfString:@"+" withString:@"%22"];
    NSString *pstring3 = [pstring2 stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
    NSString *pstring4 = [pstring3 stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
     NSString *pstring5 = [pstring4 stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    
    NSLog(@"%@",pstring5);
    
    [request setHTTPBody:[pstring5 dataUsingEncoding:NSUTF8StringEncoding]];
    self.restApi.delegate=self;
    [self.restApi httpRequest:request];
    
}

-(void)getReceivedData:(NSMutableData *)data sender:(restAPI *)sender{
    
    NSError *error=nil;
    NSDictionary *receiveddata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    gotcontacts =[[NSMutableArray alloc]initWithArray:[receiveddata objectForKey:@"contacts"]];
    
   
    for (int i=0;i<gotcontacts.count;i++) {
        NSString *gotnumber =[gotcontacts objectAtIndex:i];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                 @"PhoneNumbers like %@", gotnumber];
        
          NSArray *matchingDicts = [self.contactList filteredArrayUsingPredicate:predicate];
          NSDictionary *dict = [matchingDicts lastObject];
        
            [self.fetchedcontacts addObject:dict];
            }
    
    NSLog(@"%@",self.fetchedcontacts);
    [self.tableView reloadData];
        }

    


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       
        return [searchResults count];
    } else {
        
        return self.fetchedcontacts.count;
    }
    
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContactsCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary* personDict = [self.fetchedcontacts objectAtIndex:indexPath.row];
   
    
    if (cell != nil) {
        cell=nil;
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary* personDict2 = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [personDict2 objectForKey:@"fullName"];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Regular" size:20.0];
    } else {
        
        cell.textLabel.text = [personDict objectForKey:@"fullName"];
            
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Regular" size:20.0];
    
    }
    
    
        

    return cell;
}

-(void)gotcontacts{
    
    [self httppostrequest];
}


@end
