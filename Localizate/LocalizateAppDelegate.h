//
//  LProjGeneratorAppDelegate.h
//  LProjGenerator
//
//  Created by Jordi Dosne on 18/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JDDropBox.h"
#import "CHCSV.h"

@interface LocalizateAppDelegate : NSObject <NSApplicationDelegate, JDDropBoxDelegate, CHCSVParserDelegate, NSOpenSavePanelDelegate, NSWindowDelegate> {
@private
	NSWindow *window;
	IBOutlet JDDropBox *dropBox;
	IBOutlet NSTextField *pathNameTextField;
	IBOutlet NSTextField *pathValueTextField;
	IBOutlet NSTextField *sizeNameLabel;
	IBOutlet NSTextField *sizeValueLabel;
	IBOutlet NSTextField *nbRowsNameLabel;
	IBOutlet NSTextField *nbRowsValueLabel;
	IBOutlet NSTextField *nbLanguagesNameLabel;
	IBOutlet NSTextField *nbLanguagesValueLabel;
	IBOutlet NSTextField *outputDirectoryLabel;
	IBOutlet NSButton *parseCommentCheckBox;
	IBOutlet NSButton *createFoldersCheckBox;
	IBOutlet NSTextField *parseCommentLabel;
	IBOutlet NSTextField *createFoldersLabel;
	IBOutlet NSButton *generateButton;
	IBOutlet NSButton *chooseFolderButton;
	
	NSMutableString *contentOfGeneratedFile;
	NSString *outputDirectoryPath;
	NSArray *rowsOfCSV;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet JDDropBox *dropBox;

@property (nonatomic, retain) IBOutlet NSTextField *pathNameTextField;
@property (nonatomic, retain) IBOutlet NSTextField *pathValueTextField;
@property (nonatomic, retain) IBOutlet NSTextField *sizeNameLabel;
@property (nonatomic, retain) IBOutlet NSTextField *sizeValueLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbRowsNameLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbRowsValueLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbLanguagesNameLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbLanguagesValueLabel;
@property (nonatomic, retain) IBOutlet NSTextField *outputDirectoryLabel;
@property (nonatomic, retain) IBOutlet NSButton *parseCommentCheckBox;
@property (nonatomic, retain) IBOutlet NSButton *createFoldersCheckBox;
@property (nonatomic, retain)  IBOutlet NSTextField *parseCommentLabel;
@property (nonatomic, retain)  IBOutlet NSTextField *createFoldersLabel;
@property (nonatomic, retain) IBOutlet NSButton *generateButton;
@property (nonatomic, retain)  IBOutlet NSButton *chooseFolderButton;

- (IBAction)generate:(id)sender;
- (IBAction)chooseOutputDirectory:(id)sender;
- (IBAction)revealInFinder:(id)sender;
- (void)showInfo;
- (void)hideInfo;
- (void)launchParsing;
- (void)showWarnAlerWithMessage:(NSString *)message;

@end
