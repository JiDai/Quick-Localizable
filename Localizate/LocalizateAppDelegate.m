//
//  LProjGeneratorAppDelegate.m
//  LProjGenerator
//
//  Created by Jordi Dosne on 18/03/11.
//  Copyright 2011 Quadupède. All rights reserved.
//

#import "LocalizateAppDelegate.h"
#import "JDUtils.h"
#import "RegexKitLite.h"

@implementation LocalizateAppDelegate

@synthesize dropBox;
@synthesize pathNameTextField;
@synthesize pathValueTextField;
@synthesize sizeNameLabel;
@synthesize sizeValueLabel;
@synthesize nbRowsNameLabel;
@synthesize nbRowsValueLabel;
@synthesize nbLanguagesNameLabel;
@synthesize nbLanguagesValueLabel;
@synthesize outputDirectoryLabel;
@synthesize parseCommentCheckBox;
@synthesize createFoldersCheckBox;
@synthesize parseCommentLabel;
@synthesize createFoldersLabel;
@synthesize generateButton;
@synthesize chooseFolderButton;
@synthesize dropBoxFolder;
@synthesize folderPathNameTextField;
@synthesize folderPathValueTextField;
@synthesize previewTableView;
@synthesize foundOccurrences;
@synthesize foundLanguages;
@synthesize previewDataButton;
@synthesize exportDataButton;
@synthesize stringsPathNameTextField;
@synthesize stringsPathValueTextField;
@synthesize languagesPathNameTextField;
@synthesize languagesPathValueTextField;
@synthesize stringsPath;


@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	dropBox.delegate = self;
	dropBoxFolder.delegate = self;
	[window setDelegate:self]; 
	
	[self.dropBox setTitle:NSLocalizedString(@"lbl_drop_here", @"")];
	[self.pathNameTextField setTitleWithMnemonic:NSLocalizedString(@"lbl_path", @"")];
	[self.nbRowsNameLabel setTitleWithMnemonic:NSLocalizedString(@"lbl_nb_rows", @"")];
	[self.nbLanguagesNameLabel setTitleWithMnemonic:NSLocalizedString(@"lbl_nb_languages", @"")];
	[self.sizeNameLabel setTitleWithMnemonic:NSLocalizedString(@"lbl_size", @"")];
	[self.parseCommentCheckBox setTitleWithMnemonic:NSLocalizedString(@"lbl_option_comment", @"")];
	[self.createFoldersCheckBox setTitleWithMnemonic:NSLocalizedString(@"lbl_option_create_folders", @"")];
	[self.parseCommentLabel setTitleWithMnemonic:NSLocalizedString(@"lbl_option_comment_info", @"")];
	[self.createFoldersLabel setTitleWithMnemonic:NSLocalizedString(@"lbl_option_create_folders_info", @"")];
	[self.chooseFolderButton setTitleWithMnemonic:NSLocalizedString(@"choose_output_directory", @"")];
	[self.generateButton setTitleWithMnemonic:NSLocalizedString(@"lbl_generate", @"")];
	[self.generateButton setEnabled:NO];
    
	[self.folderPathNameTextField setTitleWithMnemonic:NSLocalizedString(@"lbl_folder_path", @"")];
	[self.stringsPathNameTextField setTitleWithMnemonic:NSLocalizedString(@"lbl_strings_path", @"")];
	[self.languagesPathNameTextField setTitleWithMnemonic:NSLocalizedString(@"lbl_found_lg", @"")];
	[self.folderPathNameTextField setTitleWithMnemonic:NSLocalizedString(@"lbl_folder_path", @"")];
	[self.previewDataButton setTitleWithMnemonic:NSLocalizedString(@"lbl_refresh", @"")];
    [self.previewDataButton setEnabled:NO];
	[self.exportDataButton setTitleWithMnemonic:NSLocalizedString(@"lbl_export", @"")];
    [self.exportDataButton setEnabled:NO];
}



- (BOOL)windowShouldClose:(id)sender
{
	[NSApp terminate:self];
	return NO;
}

- (void)dealloc {
	[window release];
	[dropBox release];
	[pathNameTextField release];
	[pathValueTextField release];
	[sizeNameLabel release];
	[sizeValueLabel release];
	[nbRowsNameLabel release];
	[nbRowsValueLabel release];
	[nbLanguagesNameLabel release];
	[nbLanguagesValueLabel release];
	[parseCommentCheckBox release];
	[createFoldersCheckBox release];
	[generateButton release];
	[outputDirectoryPath release];
	[super dealloc];
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	[self launchParsing:filename];
	return YES;
}


#pragma mark - Generate CSV


- (void)findImplementationFiles:(NSString *)path
{
	NSFileManager *localFileManager = [NSFileManager defaultManager];	
	if (mFiles) {
		[mFiles release];
	}
	mFiles = [[NSMutableArray alloc] initWithCapacity:0];
	if (foundLanguages) {
		[foundLanguages release];
	}
	foundLanguages = [[NSMutableSet alloc] initWithCapacity:0];
	
	NSString *docsDir = path;
	NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
	
	NSString *file;
    stringsFound = NO;
    stringsPath = @"";
	while ((file = [dirEnum nextObject]))
	{
		if ([[file pathExtension] isEqualToString: @"m"])
		{
			[mFiles addObject:[NSString stringWithFormat:@"%@/%@", path, file]];
		}
		if ([[file pathExtension] isEqualToString: @"lproj"])
		{
            [foundLanguages addObject:[[file lastPathComponent] stringByDeletingPathExtension]];
		}
		if ([[file lastPathComponent] isEqualToString: @"Localizable.strings"])
		{
            stringsFound = YES;
            stringsPath = [path stringByAppendingString:file];
            NSLog(@"stringsPath = %@", stringsPath);
		}
	}
	[languagesPathValueTextField setTitleWithMnemonic:[[foundLanguages allObjects] componentsJoinedByString:@", "]];
    [stringsPathValueTextField setTitleWithMnemonic:stringsPath];
	[localFileManager release];
	[self parseImplementationFiles];
}

- (void)parseImplementationFiles
{
	if (foundOccurrences) {
		[foundOccurrences release];
	}
	foundOccurrences = [[NSMutableArray alloc] initWithCapacity:0];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	for (NSString *file in mFiles)
	{
		NSString *contents = [[NSString alloc] initWithData:[fileManager contentsAtPath:file] encoding:NSUTF8StringEncoding];
		NSString *regexString     = @"NSLocalizedString\\(\\s?([^\\)]+)\\s?\\)";

		for(NSString *match in [contents componentsMatchedByRegex:regexString]) {
			NSArray *c = [match componentsSeparatedByString:@"\""];
			NSString *keyString = [c objectAtIndex:1];
			NSString *commentString = [c objectAtIndex:3];

			[ac addObject:[NSDictionary dictionaryWithObjectsAndKeys:keyString, @"key", commentString, @"comment", file, @"file", @"", @"value", nil]];
		}		
	}	
}

- (void)previewDataAction:(id)sender
{
	[self previewData];
}

- (void)previewData
{
	[previewTableView reloadData];
}

- (IBAction)exportCSV:(id)sender;
{

    NSMutableString *exportString = [[NSMutableString alloc] initWithString:@""];
    [exportString appendFormat:@";%@\n", @"fr"];
    for (NSDictionary *d in [ac arrangedObjects])
    {
        if (![[d objectForKey:@"key"] isEqualToString:@""]) {
            [exportString appendFormat:@"// %@ in %@\n", [d objectForKey:@"comment"], [d objectForKey:@"file"]];
        }
        [exportString appendFormat:@"%@;%@\n", [d objectForKey:@"key"], [d objectForKey:@"value"]];
        
    }
    //save panel
    [self exportDocument:@"export" toType:@"public.comma-separated-values-text" content:exportString];
}


- (void)exportDocument:(NSString*)name toType:(NSString*)typeUTI content:(NSString *)exportString
{
    // Build a new name for the file using the current name and
    // the filename extension associated with the specified UTI.
    CFStringRef newExtension = UTTypeCopyPreferredTagWithClass((CFStringRef)typeUTI,
                                                               kUTTagClassFilenameExtension);
    NSString* newName = [[name stringByDeletingPathExtension]
                         stringByAppendingPathExtension:(NSString*)newExtension];
    CFRelease(newExtension);
    
    // Set the default name for the file and show the panel.
    NSSavePanel*    panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:newName];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSError *error = nil;
            NSURL*  theFile = [panel URL];
            [exportString writeToURL:theFile atomically:NO encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"error = %@", error);
            }
        }
    }];
}


#pragma mark - Generate Strings Actions


- (void)launchParsing:(NSString *)path
{
	NSStringEncoding encoding = 0;
	CHCSVParser * p = [[CHCSVParser alloc] initWithContentsOfCSVFile:path usedEncoding:&encoding error:nil];
	
	[p setParserDelegate:self];
	[p parse];
	[p release];
	
	NSError *error = nil;
	if (rowsOfCSV) {
		[rowsOfCSV release];
	}
	rowsOfCSV = [[NSArray arrayWithContentsOfCSVFile:dropBox.capturedPath usedEncoding:&encoding error:&error] retain];	
	
	[self.nbRowsValueLabel setTitleWithMnemonic:[NSString stringWithFormat:@"%ld", [rowsOfCSV count] ]];
	
	if ([rowsOfCSV count] > 0)
	{
		// Headers 
		[self.nbLanguagesValueLabel setTitleWithMnemonic:[NSString stringWithFormat:@"%ld", ([[rowsOfCSV objectAtIndex:0] count]-1)]];
	}
	NSLog(@"error: %@", error);
	//NSLog(@"%@", rows);
	
}

- (void)openDoc:(id)sender
{
	int result;
	NSArray *fileTypes = [NSArray arrayWithObjects: @"txt", @"csv",
                        NSFileTypeForHFSTypeCode( 'TEXT' ), nil];
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
	[oPanel setAllowsMultipleSelection:YES];
	result = [oPanel runModalForDirectory:NSHomeDirectory()
												file:nil types:fileTypes];
	if (result == NSOKButton) {
		NSArray *filesToOpen = [oPanel filenames];
		int i, count = [filesToOpen count];
		for (i=0; i<count; i++) {
			NSString *aFile = [filesToOpen objectAtIndex:i];
			[self launchParsing:aFile];
		}
	}
}

- (IBAction)chooseOutputDirectory:(id)sender
{
	NSInteger result;
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
	[oPanel setCanChooseFiles:NO];
	[oPanel setCanCreateDirectories:YES];
	[oPanel setCanChooseDirectories:YES];
	[oPanel setAllowsMultipleSelection:NO];
	[oPanel setTitle: NSLocalizedString(@"choose_output_directory", @"")];
	[oPanel setDelegate:self];
	result = [oPanel runModalForDirectory:NSHomeDirectory() file:nil types:nil];
	
	if (result == NSOKButton)
	{
		outputDirectoryPath = [[[oPanel directoryURL] path] retain];
		[self.outputDirectoryLabel setTitleWithMnemonic:[[oPanel directoryURL] path]];
	}
}

- (IBAction)generate:(id)sender
{
	contentOfGeneratedFile = [[NSMutableString alloc] initWithString:@"//\n// Localizable.strings\n// File generated by Localizate\n// http://localizate.dosne.eu"];
	
	double nbRows = [rowsOfCSV count];
	
	int nbVars = 0;
	int nbComments = 0;
	int nbLocales = 0;
	
	NSError *error = nil;
	
	if (nbRows > 0)
	{
		// Headers 
		NSArray *headerRows = [NSArray arrayWithArray:[rowsOfCSV objectAtIndex:0]];
		double nbHeaderFields = [headerRows count];
		
		NSLog(@"nbHeaderFields = %f", nbHeaderFields);
		for (int l = 1; l < nbHeaderFields; l++)
		{
			nbVars = 0;
			nbComments = 0;
			[contentOfGeneratedFile setString:@""];
			if (![[headerRows objectAtIndex:l] isEqualToString:@""])
			{
				for (int i = 1; i < nbRows; i++)
				{
					NSArray *row = [[rowsOfCSV objectAtIndex:i] retain];
					double nbFields = [row count];
					if( ![[row objectAtIndex:0] isEqualToString:@""])
					{
						if (nbFields >= 1)
						{
							NSString *firstCell = [row objectAtIndex:0];
							
							if ([[firstCell substringToIndex:1] isEqualToString:@"#"] && [firstCell length] > 1 && [parseCommentCheckBox state])
							{
								// Is a comment
								[contentOfGeneratedFile appendFormat:@"\n/*\n * %@\n */\n", [firstCell substringFromIndex:1]];
								nbComments++;
							}
							else if ([[firstCell substringToIndex:2] isEqualToString:@"//"] && [firstCell length] > 2 && [parseCommentCheckBox state])
							{
								// Is a comment too
								[contentOfGeneratedFile appendFormat:@"\n/*\n * %@\n */\n", [firstCell substringFromIndex:2]];
								nbComments++;
							}
							else if (![firstCell isEqualToString:@""] && nbFields > 1)
							{
								// Get locale data
								NSString *localizableCell = [row objectAtIndex:l];
								[contentOfGeneratedFile appendFormat:@"\"%@\" = \"%@\";\n", firstCell, localizableCell];
								nbVars++;
								NSLog(@"nbVars = %d", nbVars);
							}
							else
							{
								NSLog(@"No data for row");
							}
						}	
					}
					[row release];
				}
				nbLocales++;
				NSFileManager *fileManager = [NSFileManager defaultManager];
				
				BOOL isDir;
				if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.lproj", outputDirectoryPath, [headerRows objectAtIndex:l]] isDirectory:&isDir])
				{
					[contentOfGeneratedFile writeToFile:[NSString stringWithFormat:@"%@/%@.lproj/%@", outputDirectoryPath, [headerRows objectAtIndex:l], @"Localizable.strings"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
				}
				else
				{
					if ([createFoldersCheckBox state])
					{
						[fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@.lproj", outputDirectoryPath, [headerRows objectAtIndex:l]] withIntermediateDirectories:NO attributes:nil error:&error];
						[contentOfGeneratedFile writeToFile:[NSString stringWithFormat:@"%@/%@.lproj/%@", outputDirectoryPath, [headerRows objectAtIndex:l], @"Localizable.strings"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
					}
				}
			}
		}
	}	
	
	if (error)
	{
		NSLog(@"error = %@", error);
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setInformativeText:NSLocalizedString(@"err_unable_creating_files", @"")];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert runModal];
	}
	else
	{
		
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:NSLocalizedString(@"job_done", @"")];
		[alert setInformativeText:[NSString stringWithFormat:@"%@ : %d\n%@ : %d\n%@ : %d\n", 
											NSLocalizedString(@"lbl_nb_vars", @""),
											nbVars,
											NSLocalizedString(@"lbl_nb_comments", @""),
											nbComments,
											NSLocalizedString(@"lbl_nb_languages", @""),
											nbLocales]];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert runModal];
	}
	
	
}


-(void)revealInFinder:(id)sender
{
	[[NSWorkspace sharedWorkspace] selectFile:outputDirectoryPath inFileViewerRootedAtPath:nil];
}

#pragma mark - Manage display


- (void)showWarnAlerWithMessage:(NSString *)message
{
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:NSLocalizedString(@"err_title", @"") ];
	[alert setInformativeText:message];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert runModal];	
}

- (void)showCSVInfo
{
	[self.pathNameTextField setHidden:NO];
	[self.pathValueTextField setHidden:NO];
	[self.nbRowsNameLabel setHidden:NO];
	[self.nbRowsValueLabel setHidden:NO];
	[self.nbLanguagesNameLabel setHidden:NO];
	[self.nbLanguagesValueLabel setHidden:NO];
	[self.sizeNameLabel setHidden:NO];
	[self.sizeValueLabel setHidden:NO];
}

- (void)hideCSVInfo
{
	[self.pathNameTextField setHidden:YES];
	[self.pathValueTextField setHidden:YES];
	[self.nbRowsNameLabel setHidden:YES];
	[self.nbRowsValueLabel setHidden:YES];
	[self.nbLanguagesNameLabel setHidden:YES];
	[self.nbLanguagesValueLabel setHidden:YES];
	[self.sizeNameLabel setHidden:YES];
	[self.sizeValueLabel setHidden:YES];
}
- (void)showFolderInfo
{
	[self.folderPathNameTextField setHidden:NO];
	[self.folderPathValueTextField setHidden:NO];
	[self.stringsPathNameTextField setHidden:NO];
	[self.stringsPathValueTextField setHidden:NO];
	[self.languagesPathNameTextField setHidden:NO];
	[self.languagesPathValueTextField setHidden:NO];
}

- (void)hideFolerInfo
{
	[self.folderPathNameTextField setHidden:YES];
	[self.folderPathValueTextField setHidden:YES];
	[self.stringsPathNameTextField setHidden:YES];
	[self.stringsPathValueTextField setHidden:YES];
	[self.languagesPathNameTextField setHidden:YES];
	[self.languagesPathValueTextField setHidden:YES];
}




#pragma mark - Delegate DropBox

- (void)didReceiveFile:(JDDropBox *)aDropBox
{
	if (aDropBox == dropBox)
	{
		[self.pathValueTextField setTitleWithMnemonic:aDropBox.capturedPath];
		
		NSFileManager *filemgr = [NSFileManager defaultManager];	
		NSError *error;
		NSDictionary *attributes = [filemgr attributesOfItemAtPath:dropBox.capturedPath error:&error];
		
		
		[self.sizeValueLabel setTitleWithMnemonic:[JDUtils getHumanReadableSize:[[attributes objectForKey:NSFileSize] floatValue]]];
		
		
		if ([[dropBox.capturedPath pathExtension] isEqualToString:@"csv"])
		{
			[generateButton setEnabled:YES];
			[self showCSVInfo];
			[self launchParsing:dropBox.capturedPath];
		}
		else
			[self showWarnAlerWithMessage:NSLocalizedString(@"err_file_type", @"")];
	}
	else if (aDropBox == dropBoxFolder)
	{
		[self.folderPathValueTextField setTitleWithMnemonic:aDropBox.capturedPath];
        NSLog(@"aDropBox.capturedPath = %@", aDropBox.capturedPath);
		[self findImplementationFiles:aDropBox.capturedPath];
        [self.previewDataButton setEnabled:YES];
        [self.exportDataButton setEnabled:YES];
        [self showFolderInfo];
	}
}


#pragma mark - CSV Parsing Delegate

- (void) parser:(CHCSVParser *)parser didStartDocument:(NSString *)csvFile {
	NSLog(@"parser started: %@", csvFile);
}
- (void) parser:(CHCSVParser *)parser didStartLine:(NSUInteger)lineNumber {
	NSLog(@"Starting line: %u", lineNumber);
}
- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field {
	NSLog(@"   field: %@", field);
}
- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber {
	NSLog(@"Ending line: %u", lineNumber);
}
- (void) parser:(CHCSVParser *)parser didEndDocument:(NSString *)csvFile {
	NSLog(@"parser ended: %@", csvFile);
}
- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"ERROR: %@", error);
}

@end
