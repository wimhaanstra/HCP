//
//  ExtendedLogFormatter.m
//  HomeWizard
//
//  Created by Wim Haanstra on 18/03/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

#import "ExtendedLogFormatter.h"

@implementation ExtendedLogFormatter

- (NSString*) formatLogMessage:(DDLogMessage *)logMessage {
	NSString* prefix = @"";
	
	switch (logMessage->logFlag) {
        case LOG_FLAG_ERROR: prefix   = @"ERROR:   "; break;
        case LOG_FLAG_DEBUG: prefix   = @"DEBUG:   "; break;
        case LOG_FLAG_INFO: prefix    = @"INFO:    "; break;
        case LOG_FLAG_VERBOSE: prefix = @"VERBOSE: "; break;
        case LOG_FLAG_WARN: prefix    = @"WARNING: "; break;
        default: prefix               = @"UNKNOWN: "; break;
	}

	NSDateFormatter* dateFormatter = [NSDateFormatter new];
	[dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
	
	NSString* filePath = [NSString stringWithFormat:@"%s", logMessage->file];
	filePath = [filePath lastPathComponent];
	
	return [NSString stringWithFormat:@"%@ [%@:%d %s] %@", [dateFormatter stringFromDate:logMessage->timestamp], filePath, logMessage->lineNumber, logMessage->function,  logMessage->logMsg];
}

@end
