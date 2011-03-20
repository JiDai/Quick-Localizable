//
//  LocalizateAppDelegate.h
//  Localizate
//
//  Created by Jordi Dosne on 20/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LocalizateAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
