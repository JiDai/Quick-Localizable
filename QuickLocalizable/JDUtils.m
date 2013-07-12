//
//  JDUtils.m
//  LProjGenerator
//
//  Created by Jordi Dosne on 19/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import "JDUtils.h"


@implementation JDUtils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *)getHumanReadableSize:(float)size
{
	if(size < 1000)
		return [NSString stringWithFormat:@"%@ o", [JDUtils round:size decimals:2]];
	else if(size < 1000000)
		return [NSString stringWithFormat:@"%@ Ko", [JDUtils round:(size/1000) decimals:2]];
	else if(size < 1000000000)
		return [NSString stringWithFormat:@"%@ Mo", [JDUtils round:(size/1000000) decimals:2]];
	else if(size < 1000000000000)
		return [NSString stringWithFormat:@"%@ Go", [JDUtils round:(size/1000000000) decimals:2]];
	else
		return [NSString stringWithFormat:@"%@ o", [JDUtils round:size decimals:2]];
}

+ (NSString *)round:(float)f decimals:(int)d
{
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setMaximumFractionDigits:d];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSLog(@"[numberFormatter stringFromNumber:[NSNumber numberWithFloat:f]] = %@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:f]]);
	return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:f]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
