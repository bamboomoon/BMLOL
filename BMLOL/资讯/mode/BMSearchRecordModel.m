//
//  BMSearchRecordModel.m
//  BMLOL
//
//  Created by donglei on 16/5/3.
//  Copyright © 2016年 donglei. All rights reserved.
//

#import "BMSearchRecordModel.h"
#import <sqlite3.h>



@interface BMSearchRecordModel()

@property(nonatomic,copy) NSString *fileName; //数据库文件路径

@end



static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
static BMSearchRecordModel *instance = nil;
@implementation BMSearchRecordModel



+(instancetype) getShareInstace{
  
    return [[self alloc] init];
}
-(instancetype)init
{
    if (!instance) {
        instance  = [super init];
        [instance openAndCreateTable];
    }
    return instance;
}




-(NSString *)fileName
{
    if (!_fileName) {
        _fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"search.sqlite"];
       
    }
    return _fileName;
}


-(BOOL) openAndCreateTable{

    BOOL isSuccess = YES;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: self.fileName ] == NO){
        
   
        const char *dbpath = [self.fileName UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="create table  SerchRecord (serchWord varchar(30) primary key)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table %s",errMsg);
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
         }

    return  isSuccess;
}

- (BOOL) saveDataName:(NSString*)serchWord
{
    const char *dbpath = [self.fileName UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into SerchRecord (serchWord) values (\"%@\")",serchWord];
                                const char *insert_stmt = [insertSQL UTF8String];
                                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                                if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                     sqlite3_reset(statement);
                                  sqlite3_close(database);
                                    return YES;
                                } 
                                else {
                                     sqlite3_reset(statement);
                                 sqlite3_close(database);
                                    return NO;
                                }
     }
    sqlite3_reset(statement);

  return NO;
 }


- (NSArray*) findSearch
{
    const char *dbpath = [self.fileName UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      
        NSString *querySQL = [NSString stringWithFormat:@"select serchWord from SerchRecord"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"find");
                NSString *serchWord = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:serchWord];
               
            }
            
            sqlite3_reset(statement);
            sqlite3_close(database);
            return resultArray;
        }
       
    }
  
    return nil;
}

-(BOOL) deleteRecord:(NSString *)recordString
{
    const char *dbpath = [self.fileName UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *sqlString =  [NSString stringWithFormat:@"DELETE from SerchRecord where serchWord='%@'",recordString];
       
        const char *deleteStm = [sqlString UTF8String];
        sqlite3_prepare_v2(database, deleteStm,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        else {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return NO;
        }
    }
    
      return NO;
}


-(BOOL) cleanRecordTable{
    const char *dbpath = [self.fileName UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *sqlString =  [NSString stringWithFormat:@"delete from SerchRecord"];
        
        const char *deleteStm = [sqlString UTF8String];
        sqlite3_prepare_v2(database, deleteStm,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"清空数据库表 OK");
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }
        else {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return NO;
        }
    }
    
    return NO;
}
@end
