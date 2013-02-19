//
//  ViewController.m
//  databaseDemo
//
//  Created by andre trosky on 19/02/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;
    
    //get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                        NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    //build path to the database file
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:_databasePath] == NO){
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK){
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                _theStatus.text = @"Failed to create table.";
            }
            sqlite3_close(_contactDB);
        } else {
            _theStatus.text = @"Failed to open/create database.";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveData:(UIButton *)sender {
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\" )", self.theName.text,
                                                self.theAddress.text,
                                                self.thePhone.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            self.theStatus.text = @"Contact added.";
            self.theName.text = @"";
            self.theAddress.text = @"";
            self.thePhone.text = @"";
        } else {
            self.theStatus.text = @"Failed to add contact.";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    
    }
}

- (IBAction)findContact:(UIButton *)sender {
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT address, phone FROM contacts WHERE name=\"%@\"", _theName.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                _theAddress.text = addressField;
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                _thePhone.text = phoneField;
                
                _theStatus.text = @"Match found";
            } else {
                _theStatus.text =@"Match not found.";
                _theAddress.text = @"";
                _thePhone.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
}

- (IBAction)nameDone:(UITextField *)sender {
    [_theName resignFirstResponder];
}

- (IBAction)addressDone:(UITextField *)sender {
    [_theAddress resignFirstResponder];
}

- (IBAction)phoneDone:(UITextField *)sender {
    [_thePhone resignFirstResponder];
}

@end
