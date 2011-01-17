//
//  PreferencesManager.m
//  Xenophobe
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	Last Updated - 10/30/2010 @ 8PM - Alexander
//	- Wrote code to handle manipulation of our SQL preferences file

#import "PreferencesManager.h"
#import "SynthesizeSingleton.h"

@interface PreferencesManager(Private)
- (void)createWriteablePreferencesFile;
@end

@implementation PreferencesManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PreferencesManager)

- (void)dealloc {
	[super dealloc];
}

- (id)init {
	[self createWriteablePreferencesFile];
	return self;
}

- (void)createWriteablePreferencesFile {
	//Instantiate some file managers to check if the DB already exists in our editable area and return if it does
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"preferences.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success) return;
	
    //If it doesn't exist we're going to move it to the appropriate area
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"preferences.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (success) {
		//TODO: Change method to return BOOL indicating success or failure
	}
}

- (NSString *)getPreferenceValueForKey:(NSString *)aKey {
	//Create an accessible instance of our DB
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *preferencesSQL = [documentsDirectory stringByAppendingPathComponent:@"preferences.sqlite"];
	NSMutableArray *arrayForReturn = [NSMutableArray new];	
	sqlite3 *preferencesSQLDB = NULL;
	
    //Open the database for queries
	if (sqlite3_open([preferencesSQL UTF8String], &preferencesSQLDB) == SQLITE_OK) {
        //Create a query string to retrieve value for a certain key in the preferences file
		NSString *queryString;
		
		queryString = [NSString stringWithFormat:@"SELECT pref_value FROM preferences WHERE pref_key = %@", aKey];
		
		//Run our query against the DB and add the resulting rows to an array for return later
		const char *sqlStatement = [queryString UTF8String];
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare(preferencesSQLDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *preferencesValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				[arrayForReturn addObject:preferencesValue];
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(preferencesSQLDB);
		
    //We're only expecting there to be one row returned from the query, so we return that one result that we stored
	if ([arrayForReturn count] == 1) {
		NSString *returnString = [[NSString alloc] initWithString:[arrayForReturn objectAtIndex:0]];
		[arrayForReturn release];
		return [returnString autorelease];
	}
	else {
		[arrayForReturn release];
		return nil;
	}
}

- (BOOL)setPreferenceValue:(NSString *)aValue forKey:(NSString *)aKey {
	//Create an accessible instance of our database
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *preferencesSQL = [documentsDirectory stringByAppendingPathComponent:@"preferences.sqlite"];
	sqlite3 *preferencesSQLDB = NULL;
	
    //Open the database for queries
	if(sqlite3_open([preferencesSQL UTF8String], &preferencesSQLDB) == SQLITE_OK) {
		
        //Create a query that will update the preference value for the given preference key with the given value
		const char* sql = [[NSString stringWithFormat:@"UPDATE preferences SET pref_value = '%@' WHERE pref_key = '%@'", aValue, aKey] cStringUsingEncoding:NSUTF8StringEncoding];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(preferencesSQLDB, sql, -1, &statement, NULL) == SQLITE_OK)
		{
			int result = sqlite3_step(statement);
			sqlite3_reset(statement);
			
			if(result != SQLITE_ERROR) {
                return YES;
			}
            else {
                return NO;
            }
		}
        else {
            return NO;
        }
	}
    else {
        return NO;
    }
    
	sqlite3_close(preferencesSQLDB);
}

@end
