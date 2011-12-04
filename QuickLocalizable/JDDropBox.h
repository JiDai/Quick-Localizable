//
//  JDDropBox.h
//  LProjGenerator
//
//  Created by Jordi Dosne on 18/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@protocol JDDropBoxDelegate;

@interface JDDropBox : NSBox {
	NSString *capturedPath;
	NSTextField *receiverTextField;
	
	id<JDDropBoxDelegate> delegate;
}

@property (nonatomic, retain)  NSString *capturedPath;
@property (nonatomic, retain)  NSTextField *receiverTextField;
@property (assign) id<JDDropBoxDelegate> delegate;

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender;
- (void)didReceiveFile;

@end


@protocol JDDropBoxDelegate <NSObject>

@optional
- (void)didReceiveFile:(JDDropBox *)dropBox;

@end

