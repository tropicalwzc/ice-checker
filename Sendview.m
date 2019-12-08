//
//  Sendview.m
//  ice_checker
//
//  Created by 王子诚 on 2019/2/22.
//  Copyright © 2019 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Sendview.h"
@interface Sendview()
@property (weak, nonatomic) IBOutlet UITextView *SendText;

@end

@implementation Sendview
- (void)viewDidLoad {
    [super viewDidLoad];
    _SendText.text=contents;
}
-(void)set_contents:(NSString*)texter
{
    contents=texter;
    _SendText.text=texter;
}
- (IBAction)Select_all_data:(UIBarButtonItem *)sender {
    [self selectAllTextIn_Textview:_SendText];
}
- (void)selectAllTextIn_Textview:(UITextView *)textField {
   
  textField.selectedRange = NSMakeRange(0, textField.text.length);
}
- (void)selectAllTextInField:(UITextField *)textField {
    UITextPosition  *theStart   = [textField beginningOfDocument];
    UITextPosition  *theEnd     = [textField endOfDocument];
    UITextRange     *theRange   = [textField textRangeFromPosition:theStart toPosition:theEnd];
    [textField setSelectedTextRange:theRange];
}
@end
