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

@interface QuickLocalizableAppDelegate : NSObject <NSApplicationDelegate, JDDropBoxDelegate, CHCSVParserDelegate, NSOpenSavePanelDelegate, NSWindowDelegate> {
@private
	NSWindow *window;
    
    NSTabView *mainTabView;
	
	/* Generate strings */
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
	
	/* Generate CSV */
	IBOutlet JDDropBox *dropBoxFolder;
	IBOutlet NSTextField *folderPathNameTextField;
	IBOutlet NSTextField *folderPathValueTextField;
	IBOutlet NSTextField *stringsPathNameTextField;
	IBOutlet NSTextField *stringsPathValueTextField;
	IBOutlet NSTextField *languagesPathNameTextField;
	IBOutlet NSTextField *languagesPathValueTextField;
	IBOutlet NSTextField *tableViewTitleTextField;
	IBOutlet NSTextField *folderHelpTextField;
	IBOutlet NSTableView *previewTableView;
	NSMutableArray *mFiles;
	NSMutableArray *foundOccurrences;
    NSMutableDictionary *allStrings;
	NSMutableSet *foundLanguages;
	IBOutlet NSArrayController *ac;
    IBOutlet NSButton *previewDataButton;
    IBOutlet NSButton *exportDataButton;
    NSString *stringsPath;
    BOOL stringsFound;
	
	
	NSMutableString *contentOfGeneratedFile;
	NSString *outputDirectoryPath;
	NSArray *rowsOfCSV;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet JDDropBox *dropBox;

@property (nonatomic, retain) IBOutlet NSTextField *pathNameTextField;
@property (nonatomic, retain) IBOutlet NSTabView *mainTabView;
@property (nonatomic, retain) IBOutlet NSTextField *pathValueTextField;
@property (nonatomic, retain) IBOutlet NSTextField *sizeNameLabel;
@property (nonatomic, retain) IBOutlet NSTextField *sizeValueLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbRowsNameLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbRowsValueLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbLanguagesNameLabel;
@property (nonatomic, retain) IBOutlet NSTextField *nbLanguagesValueLabel;
@property (nonatomic, retain) IBOutlet NSTextField *outputDirectoryLabel;
@property (nonatomic, retain) IBOutlet NSTextField *tableViewTitleTextField;
@property (nonatomic, retain) IBOutlet NSTextField *folderHelpTextField;
@property (nonatomic, retain) IBOutlet NSButton *parseCommentCheckBox;
@property (nonatomic, retain) IBOutlet NSButton *createFoldersCheckBox;
@property (nonatomic, retain) IBOutlet NSTextField *parseCommentLabel;
@property (nonatomic, retain) IBOutlet NSTextField *createFoldersLabel;
@property (nonatomic, retain) IBOutlet NSButton *generateButton;
@property (nonatomic, retain) IBOutlet NSButton *chooseFolderButton;

@property (nonatomic, retain) IBOutlet JDDropBox *dropBoxFolder;
@property (nonatomic, retain) IBOutlet NSTextField *folderPathNameTextField;
@property (nonatomic, retain) IBOutlet NSTextField *folderPathValueTextField;
@property (nonatomic, retain) IBOutlet NSTextField *stringsPathNameTextField;
@property (nonatomic, retain) IBOutlet NSTextField *stringsPathValueTextField;
@property (nonatomic, retain) IBOutlet NSTextField *languagesPathNameTextField;
@property (nonatomic, retain) IBOutlet NSTextField *languagesPathValueTextField;
@property (nonatomic, retain) IBOutlet NSTableView *previewTableView;
@property (nonatomic, retain) NSMutableArray *foundOccurrences;
@property (nonatomic, retain) NSMutableDictionary *allStrings;
@property (nonatomic, retain) NSMutableSet *foundLanguages;
@property (nonatomic, retain) IBOutlet NSButton *previewDataButton;
@property (nonatomic, retain) IBOutlet NSButton *exportDataButton;
@property (nonatomic, retain) NSString *stringsPath;


- (void)findImplementationFiles:(NSString *)path;
- (void)parseImplementationFiles;
- (IBAction)previewDataAction:(id)sender;
- (void)previewData;
- (IBAction)exportCSV:(id)sender;
- (void)exportDocument:(NSString*)name toType:(NSString*)typeUTI content:(NSString *)exportString;

- (void)launchParsing:(NSString *)path;
- (IBAction)generate:(id)sender;
- (IBAction)chooseOutputDirectory:(id)sender;
- (IBAction)revealInFinder:(id)sender;

- (void)showCSVInfo;
- (void)hideCSVInfo;

- (void)showFolderInfo;
- (void)hideFolderInfo;

- (void)showWarnAlerWithMessage:(NSString *)message;

@end
