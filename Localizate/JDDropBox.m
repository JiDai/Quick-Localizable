//
//  JDDropBox.m
//  LProjGenerator
//
//  Created by Jordi Dosne on 18/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import "JDDropBox.h"


@implementation JDDropBox

@synthesize capturedPath;
@synthesize receiverTextField;
@synthesize delegate;


- (void)awakeFromNib
{
	[self registerForDraggedTypes:[NSArray arrayWithObject: NSFilenamesPboardType]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
	if (sourceDragMask & NSDragOperationLink)
	{
		return NSDragOperationLink;
	}
	else if (sourceDragMask & NSDragOperationCopy)
	{
		return NSDragOperationCopy;
	}
	return NSDragOperationNone;
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];

	if ([files count] > 0)
	{
		self.capturedPath = [files objectAtIndex:0];
		[self didReceiveFile];
		return YES;
	}
	else
	{
		return NO;
	}
}

- (void)didReceiveFile
{
	if ( [delegate respondsToSelector:@selector(didReceiveFile:)] ) 
	{
		[delegate didReceiveFile:self];
	}
}

- (void)dealloc
{
	[capturedPath release];
}

@end
