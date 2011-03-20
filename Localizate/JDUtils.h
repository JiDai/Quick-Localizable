//
//  JDUtils.h
//  LProjGenerator
//
//  Created by Jordi Dosne on 19/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JDUtils : NSObject {
@private
    
}

+ (NSString *)getHumanReadableSize:(float)size;
+ (NSString *)round:(float)f decimals:(int)d;


@end
