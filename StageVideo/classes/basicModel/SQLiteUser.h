

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@interface SQLiteUser : NSObject
{
    sqlite3 *database;
}

+ (SQLiteUser *)shared;
-(sqlite3*)getHandle;
-(void)createDBHandle;
-(BOOL)deleteDatabase;


@end
