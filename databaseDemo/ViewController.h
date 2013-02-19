//
//  ViewController.h
//  databaseDemo
//
//  Created by andre trosky on 19/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *theName;
@property (weak, nonatomic) IBOutlet UITextField *theAddress;
@property (weak, nonatomic) IBOutlet UITextField *thePhone;
@property (weak, nonatomic) IBOutlet UILabel *theStatus;




- (IBAction)nameDone:(UITextField *)sender;
- (IBAction)addressDone:(UITextField *)sender;
- (IBAction)phoneDone:(UITextField *)sender;

- (IBAction)saveData:(UIButton *)sender;
- (IBAction)findContact:(UIButton *)sender;


@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *contactDB;

@end
