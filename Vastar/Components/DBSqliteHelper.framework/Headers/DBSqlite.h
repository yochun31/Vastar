//
//  DBSqlite.h
//  DBSqliteHelper
//
//  Created by geosat on 2020/3/23.
//  Copyright © 2020 geosat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBSqlite : NSObject

-(sqlite3 *)openDataBase:(NSString *)dbName;
-(void)closeDataBase;
-(NSString *)getDataBaseFullPath:(NSString *)fileName;
-(void)copyDataBaseIfNeeded:(NSString *)fileName oftype:(NSString *)ofTypeName;
-(BOOL)checkDataBaseIfNeed:(NSString *)fileName oftype:(NSString *)ofTypeName;
-(sqlite3_stmt *)executeQuery:(NSString *)query;
-(void)errMsg;
-(void)removeFile:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
