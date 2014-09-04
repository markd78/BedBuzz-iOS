//
//  Utilities.m
//  swapMUG
//
//  Created by Mark Davies on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+ (NSString*)readURLConnection
{
	NSString *url = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"bedBuzzServerBaseURL"];
	return url;
}

+(NSString*)GetDoucmentsPathForFile:(NSString *)oldPath
{
    NSString *file = [[oldPath componentsSeparatedByString:@"/"] lastObject];
    
    // Find the path to the documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *newPath = [documentsDirectory stringByAppendingPathComponent:file];

    return newPath;
}

@end
