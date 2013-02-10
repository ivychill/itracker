//
//  LYSearchBarView.h
//  Easyway95
//
//  Created by Sean.Yie on 12-10-26.
//
//

#import <UIKit/UIKit.h>
#import "LYVCDelegate.h"

@interface LYSearchBarView : UIView <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *uiInputTxtField;
- (IBAction)didSearching:(id)sender;
- (IBAction)didCloseCustSearchBar:(id)sender;

- (void) setInputDelegate;
- (void) dismissKeyboard;

@property id <LYVCDelegate> delegate;

@end
