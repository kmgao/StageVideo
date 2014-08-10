

#import "SQLiteUser.h"

#define kSQLDatabaseName  @"stageVideo.db"


@implementation SQLiteUser

static SQLiteUser *sharedInstance = nil;

+ (SQLiteUser *)shared
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[SQLiteUser alloc] init];
        }
        [sharedInstance createDBHandle];
    }
    return sharedInstance;
}

-(NSString*)getDatabaseName
{     
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    NSString * databasePath = [NSString stringWithFormat:@"%@",[docsDir stringByAppendingPathComponent: kSQLDatabaseName]];
    return databasePath;
}

-(id)init
{
    if (self = [super init])
    { 
       
    }
    return self;
}

-(void)createDBHandle
{
    if(NULL == database)
    {
        NSString * databasePath = [self getDatabaseName];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open_v2(dbpath, &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK) {
            //     NSLog(@"%@",@"open db ok");
        }
        else {
            //     NSLog(@"%@",@"can't open db");
        }
    }
}

-(sqlite3*)getHandle
{
    return database;
}

-(NSString *)getChatName:(NSString *)name
{
    NSString *a = [name substringFromIndex:1];
    return a;
}

-(BOOL)existChatTable:(NSString *)chatName
{
    if(chatName == nil) return NO;
    NSString *sqlStr = [NSString stringWithFormat:@"select * from chat%@",[self getChatName:chatName]];
    const char *querySQL = [sqlStr UTF8String];
    sqlite3_stmt *stmt = nil;
    int count = 0;
    if(sqlite3_prepare_v2(database, querySQL, -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            count = sqlite3_column_count(stmt);
        }
        sqlite3_finalize(stmt);
    }
    return count > 0;
}


#define kSizeSeparator @","
- (NSString*)getSizeString:(CGFloat)width height:(CGFloat)height
{
    return [NSString stringWithFormat:@"%.1f%@%.1f", width, kSizeSeparator,height];
}

- (CGSize)getSizeFor:(NSString*)sizeString
{
    NSArray *array = [sizeString componentsSeparatedByString:kSizeSeparator];
    if(array)
    {
        NSInteger count = [array count];
        if(count == 2)
        {
            CGFloat width = [[array objectAtIndex:0] floatValue];
            CGFloat height = [[array objectAtIndex:1] floatValue];
            return CGSizeMake(width, height);
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}

- (int)getRowNumberOfChatTable:(NSString*)table
{
    int count = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM chat%@",[self getChatName:table]];
    const char *sqlStr = [sql UTF8String];
    sqlite3_stmt *statement;
    if( sqlite3_prepare_v2(database, sqlStr, -1, &statement, NULL) == SQLITE_OK )
    {
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            count = sqlite3_column_int(statement, 0);
        }
    }    
    sqlite3_finalize(statement);
    return count;
}

-(void)deleteFromChatTableById:(NSString *)name byID:(int)primaryKey
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM chat%@ WHERE UID=%d",[self getChatName:name],primaryKey];
    char *errorMsg;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
      //  KFLog_Normal(NO,@"删除id=%d错误:%s", primaryKey,errorMsg);
    }
    else{
      //  KFLog_Normal(NO,@"删除id=%d%@OK！", primaryKey,name);
    }    
}



-(BOOL)deleteChatTable:(NSString*)name
{
    //删除数据库表
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE chat%@",[self getChatName:name]];
    char *errorMsg;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkColumn:(NSString*)name existInTable:(NSString*)tableName
{
    BOOL columnExists = NO;
    sqlite3_stmt *selectStmt;
    NSString *sql = [NSString stringWithFormat:@"select %@ from chat%@",name,[self getChatName:tableName]];
    const char *sqlStatement = [sql UTF8String];
    NSInteger ret = sqlite3_prepare_v2(database, sqlStatement, -1, &selectStmt, NULL);
    if(ret == SQLITE_OK){
        columnExists = YES;
    }
    return columnExists;
}

-(BOOL) hasEqualRecord:(NSString*)tableName queryID:(int)aID andName:(NSString*)name
{
    if(aID <= 0) return YES;
    
    int count = 0;
    sqlite3_stmt *stmt;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE PHONEID=%d AND NAME='%@'",tableName,aID,name];
    if(sqlite3_prepare16_v2(database, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            count = sqlite3_column_int(stmt, 0);
        }
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);         
    }
    return count > 0;
}


-(NSString*)getNameByTelNumber:(NSString*)telNumber
{
    NSString *querySQL = nil,*telName=nil;
    querySQL = [NSString stringWithFormat:@"SELECT NAME FROM JIEYUHUA WHERE NUMBER='%@' AND ISJIEYUHUA=1",telNumber];
    
    sqlite3_stmt *statement;
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
    {
        //依次读取数据库表格中每行的内容
        while (sqlite3_step(statement) == SQLITE_ROW) {
            const char *name = (char *)sqlite3_column_text(statement,0);
            if(!name) name = "?";
            telName = [NSString stringWithUTF8String:name];
            break;
        }
        sqlite3_finalize(statement);
    }
    return telName;
}

-(void)dealloc
{
    sqlite3_close(database);
}

#pragma mark-
#pragma mark ----- 系统通讯录表 ------

//解语花用户表
-(void)createContactsTable
{
    //添加了通讯录中创建时间、最后修改时间，以及通讯录中记录id字段 @added by Yong 2013-04-11
    NSString *sqlString =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ContactsTable (PHONEID INTEGER PRIMARY KEY,\
                   RECORDID INTEGER,\
                   PHONENUMBER TEXT,\
                   NAME TEXT,\
                   RECOREMODITIME INTEGER,\
                   CREATETIME INTEGER,\
                   LASTMODIFYTIME INTEGER,\
                   ISJIEYUHUA INTEGER,\
                   ISFAVORITE INTEGER);"];
    char *errorMsg;
    if (sqlite3_exec(database, [sqlString UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
      //  NSLog(@"创建数据库表错误: %s", errorMsg);
    }
}

- (int)hasContactTableData
{
    const char  *selectSQL = "SELECT * FROM ContactsTable";
    NSString  *sqlStr = [NSString stringWithUTF8String:selectSQL];
    sqlite3_stmt *statement = NULL;
    int rowLine = 0;
    int queryCode = sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL);
    if(queryCode == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            rowLine ++;
        }
    }
    return rowLine;
}

-(int)serchContactsTable:(NSMutableArray*)array
{
     return 1;
}

- (BOOL)deleteAllFromContactTable{
    NSString *sql = @"DELETE FROM ContactsTable";
    char *errorMsg;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
     //   NSLog(@"删除数据库错误: %s", errorMsg);
        return NO;
    }
    else{
      //  NSLog(@"清除数据库Contacts Table 全部数据 >> OK！");
    }
    return YES;
}

//删除记录，并不是真正的删除这条记录，而是重置ISDELETE标识为1
- (BOOL)deleteContactByPhoneID:(int)phoneID sameRecord:(int)record
{
//    NSString *delSQL = [NSString stringWithFormat: @"DELETE FROM ContactsTable WHERE PHONEID=%d",phoneID];
    NSString *delSQL = [NSString stringWithFormat: @"DELETE FROM ContactsTable WHERE PHONEID=%d",phoneID];
    char *errorMsg;
    if (sqlite3_exec(database, [delSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
     //   NSLog(@"SQLiteUser>>>>>>>>>>>>>>>>>>>>>>>删除数据库错误: %s", errorMsg);
        return NO;
    }
    else{
     //   NSLog(@"SQLiteUser========================成功删除 cid = %d; 的记录！",phoneID);
    }
    return YES;
}

- (BOOL)deleteDBContactByRecordID:(int)recordID 
{
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM ContactsTable WHERE RECORDID = %d",recordID];
    char  *errorMsg = NULL;
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
    {
      //  NSLog(@"成功删除 recordid = %d 的记录",recordID);
        return YES;
    }
    return NO;
}

- (BOOL)deleteDBContactByPhoneNumber:(NSString*)phoneNumber
{
    if(nil == phoneNumber || phoneNumber.length <= 0) return NO;
    NSString *sql = [NSString stringWithFormat: @"DELETE FROM ContactsTable WHERE PHONENUMBER = %@",phoneNumber];
    char  *errorMsg = NULL;
    if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK)
    {
     //   NSLog(@"成功删除 phoneNumber = %@ 的记录",phoneNumber);
        return YES;
    }
    return NO;
}

-(int)isContactUserWithPhone:(NSString*)sysPhoneNum
{
    if(sysPhoneNum == nil) return -1;
    
    int count=0;
    sqlite3_stmt *stmt;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ContactsTable WHERE PHONENUMBER='%@'",sysPhoneNum];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt)==SQLITE_ROW){
            count=sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    return count!=0;
    
}


-(BOOL)deleteDatabase
{
    NSString *dbPahtName = [self getDatabaseName];
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:dbPahtName error:NULL];
    if(YES == ret)
    {
        database = NULL;
    }
    return ret;
}

@end
