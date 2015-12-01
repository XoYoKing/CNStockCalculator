//
//  Record.m
//  StockCalculator
//
//  Created by jack on 15/11/11.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "Record.h"
#import "Rate.h"
#import "StockCalculator-Swift.h"
@interface Record()
-(instancetype)init;
@end
@implementation Record
+ (instancetype)sharedRecord {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[Record alloc] init];
            return instance;
        }
        return instance;
    }
}

-(instancetype)init {
    if (self = [super init]) {
        self.db = [[SQLiteManager alloc]initWithDatabaseNamed:@"stockcalc.db"];

        /*
        {
            NSFileManager *f = [NSFileManager defaultManager];
            BOOL bRet = [f fileExistsAtPath:[self.db getDatabasePath]];
            if (bRet) {
                NSError *err;
                [f removeItemAtPath:[self.db getDatabasePath] error:&err];
            }
            self.db = [[SQLiteManager alloc]initWithDatabaseNamed:@"stockcalc.db"];
            
        }
         */
        

        NSString* sqlSentence = @"CREATE TABLE IF NOT EXISTS record ([code] TEXT, [buy.price] FLOAT, [buy.quantity] FLOAT, [sell.price] FLOAT, [sell.quantity] FLOAT, [rate.commission] FLOAT, [rate.stamp] Float, [rate.transfer] Float,[commission] FLOAT, [stamp] Float, [transfer] Float, [fee] FLOAT, [result] FLOAT, [time] TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));";
        
        NSError *error = [self.db doQuery:sqlSentence];
        
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
            return nil;
        }
        
        //NSLog(@"%@", [self.db getDatabaseDump]);
        
        return self;
    }
    return nil;
}

-(BOOL)add:(NSDictionary*)record{

    NSMutableArray* keys = [NSMutableArray arrayWithCapacity:14];
    for (NSString* k in [record allKeys]) {
        [keys addObject:[NSString stringWithFormat:@"[%@]", k]];
    }
    NSArray* values = [NSArray arrayWithArray:[record allValues]];

    for (id v in values) {
        NSLog(@"%@", [v class]);
        if ([[v class] isEqual:@"NSString"]) {
            NSString* value = (NSString*)v;
            value = [NSString stringWithFormat:@"'%@'", v];
        }
    }
    
    NSString *sqlSentence = [NSString stringWithFormat:@"INSERT INTO record (%@) values (%@);",[keys componentsJoinedByString:@","], [values componentsJoinedByString:@","]];
    NSLog(@"%@", sqlSentence);

    NSError *error = [self.db doQuery:sqlSentence];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    NSLog(@"%@", [self.db getDatabaseDump]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordChanged" object:nil];
    return YES;
    
}

-(NSUInteger)count {
    NSArray* r = [self.db getRowsForQuery:@"SELECT count(*) FROM record"];
    return ((NSNumber*)r[0][@"count(*)"]).integerValue;
}

-(NSArray*)getRecords:(NSRange)range {
    NSString* sql = [NSString stringWithFormat:@"SELECT ROWID,* FROM record ORDER BY ROWID DESC LIMIT %ld OFFSET %ld",  range.length, range.location];
    NSArray* r = [self.db getRowsForQuery:sql];
    return r;
}

-(NSDictionary*)recordForIndexPath:(NSInteger)indexPath {
    NSRange range = {indexPath, 1};
    NSArray* r = [self getRecords:range];
    return r[0];
    
}
-(void)removeAtIndex:(NSInteger)index {
    NSString *sqlSentence = [NSString stringWithFormat:@"DELETE FROM record WHERE ROWID=%ld", index];
    NSLog(@"%lu", (unsigned long)[self count]);
    
    NSError *error = [self.db doQuery:sqlSentence];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    NSLog(@"%lu", (unsigned long)[self count]);

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordChanged" object:nil];
    return;
}

@end
