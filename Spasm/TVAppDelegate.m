#import "Grubber.h"
#import "TVAdBlocker.h"

#import "TVAppDelegate.h"

@implementation TVAppDelegate

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  [self initialize];

  return self;
}

- (void)initialize {
  [[NSApplication sharedApplication] setMainMenu:[self mainMenu]];

  [_adBlockToggle setState:[TVAdBlocker shouldBlockAds]];

  _window  = [[TVWindow alloc] init];
  [_window makeKeyAndOrderFront:NSApp];
}

- (void)blockAds:(id)sender {
  [TVAdBlocker setShouldBlockAds:![TVAdBlocker shouldBlockAds]];
  [_adBlockToggle setState:[TVAdBlocker shouldBlockAds]];
}

- (NSMenu *)mainMenu {
  return [NSMenu grub:(^(Grubber *grub) {
    grub.submenu(@"Spasm", ^(Grubber *grub) {
      grub.item(@"About Spasm", @selector(orderFrontStandardAboutPanel:), @"");
      grub.separator();
      grub.item(@"Logout", @selector(logout:), @"");
      _adBlockToggle = grub.item(@"Block Ads", @selector(blockAds:), @"");
      grub.separator();
      grub.item(@"Hide Spasm", @selector(hide:), @"Cmd-h");
      grub.item(@"Hide Others", @selector(hideOtherApplications:), @"Cmd-Alt-h");
      grub.item(@"Show All", @selector(unhideAllApplications:), @"");
      grub.separator();
      grub.item(@"Quit Spasm", @selector(terminate:), @"Cmd-q");
    });
    grub.submenu(@"Edit", ^(Grubber *grub) {
      grub.item(@"Undo", @selector(undo), @"Cmd-z");
      grub.item(@"Redo", @selector(redo), @"Shift-Cmd-z");
      grub.separator();
      grub.item(@"Cut", @selector(cut:), @"Cmd-x");
      grub.item(@"Copy", @selector(copy:), @"Cmd-c");
      grub.item(@"Paste", @selector(paste:), @"Cmd-v");
      grub.item(@"Paste and Match Style", @selector(pasteAsPlainText:), @"Alt-Shift-Cmd-v");
      grub.item(@"Delete", @selector(delete:), @"");
      grub.item(@"Select All", @selector(selectAll:), @"Cmd-a");
      grub.separator();
      grub.submenu(@"Find", ^(Grubber *grub) {
        grub.item(@"Find…", @selector(performFindPanelAction:), @"Cmd-f");
        grub.item(@"Find and Replace…", @selector(performFindPanelAction:), @"Alt-Cmd-f");
        grub.item(@"Find Next…", @selector(performFindPanelAction:), @"Cmd-g");
        grub.item(@"Find Previous…", @selector(performFindPanelAction:), @"Shift-Cmd-g");
        grub.item(@"Use Selection for Find…", @selector(performFindPanelAction:), @"Cmd-e");
        grub.item(@"Jump to Selection…", @selector(centerSelectionInVisibleArea:), @"Cmd-j");
      });
      grub.submenu(@"Spelling and Grammar", ^(Grubber *grub) {
        grub.item(@"Show Spelling and Grammar", @selector(showGuessPanel:), @"Cmd-:");
        grub.item(@"Check Document Now", @selector(checkSpelling:), @"Cmd-;");
        grub.separator();
        grub.item(@"Check Spelling While Typing", @selector(toggleContinuousSpellChecking:), @"");
        grub.item(@"Check Grammar With Spelling", @selector(toggleGrammarChecking:), @"");
        grub.item(@"Correct Spelling Automatically", @selector(toggleAutomaticSpellingCorrection:), @"");
      });
      grub.submenu(@"Substitutions", ^(Grubber *grub) {
        grub.item(@"Show Substitutions", @selector(orderFrontSubstitutionsPanel:), @"");
        grub.separator();
        grub.item(@"Smart Copy/Paste", @selector(toggleSmartInsertDelete:), @"");
        grub.item(@"Smart Quotes", @selector(toggleAutomaticQuoteSubstitution:), @"");
        grub.item(@"Smart Dashes", @selector(toggleAutomaticDashSubstitution:), @"");
        grub.item(@"Smart Links", @selector(toggleAutomaticLinkDetection:), @"");
        grub.item(@"Data Detectors", @selector(toggleAutomaticDataDetection:), @"");
        grub.item(@"Text Replacement", @selector(toggleAutomaticTextReplacement:), @"");
      });
      grub.submenu(@"Transformations", ^(Grubber *grub) {
        grub.item(@"Make Upper Case", @selector(uppercaseWord:), @"");
        grub.item(@"Make Lower Case", @selector(lowercaseWord:), @"");
        grub.item(@"Capitalize", @selector(capitalizeWord:), @"");
      });
      grub.submenu(@"Speech", ^(Grubber *grub) {
        grub.item(@"Start Speaking", @selector(startSpeaking:), @"");
        grub.item(@"Stop Speaking", @selector(stopSpeaking:), @"");
      });
    });
    grub.submenu(@"Window", ^(Grubber *grub) {
      grub.item(@"Toggle Show Only Stream", @selector(maximizeStream:), @"Cmd-l");
      grub.separator();
      grub.item(@"New Tab", @selector(newTab:), @"Cmd-t");
      grub.item(@"Close Tab", @selector(closeActiveTab:), @"Cmd-w");
      grub.item(@"Next Tab", @selector(nextTab:), @"Ctrl-\x09");
      grub.item(@"Previous Tab", @selector(previousTab:), @"Ctrl-Shift-\x09");
      grub.separator();
      grub.item(@"Minimize", @selector(performMiniaturize:), @"Cmd-m");
      grub.item(@"Zoom", @selector(performZoom:), @"");
      grub.separator();
      grub.item(@"Bring All to Front", @selector(arrangeInFront:), @"");
    });
  })];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application {
  return YES;
}

@end
