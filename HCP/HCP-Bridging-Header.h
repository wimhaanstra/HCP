//
//  HCP-Briding-Header.h
//  HCP
//
//  Created by Wim Haanstra on 19/08/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

#ifndef Bridge_h
#define Bridge_h

#import <AFNetworking/AFNetworking.h>

#define MR_SHORTHAND
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import <CocoaLumberjack/CocoaLumberjack.h>
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import "ExtendedLogFormatter.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#import <UICKeyChainStore/UICKeyChainStore.h>
#import <DZNSegmentedControl/DZNSegmentedControl.h>
#import <Classy/Classy.h>

#endif