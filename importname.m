//
//  importname.m
//  Book_checker
//
//  Created by 王子诚 on 2019/9/30.
//  Copyright © 2019 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "importname.h"

@interface importname()
@property (weak, nonatomic) IBOutlet UITextView *SendText;

@end

@implementation importname
- (void)viewDidLoad {
    [super viewDidLoad];
    _SendText.text=contents;
    if(file_controller==nil)
    file_controller=[[filer alloc]init];
    
    NSMutableArray* currenter=[file_controller File_read_Mutable_Array:@"classnametotal"];
    NSString* nstr=@"";
    for(int i=0;i<currenter.count;i++)
    {
        nstr=[nstr stringByAppendingFormat:@"%@\n",currenter[i]];
    }
    _SendText.text=nstr;
}
-(void)set_contents:(NSString*)texter
{
    contents=texter;
    _SendText.text=texter;
}
- (IBAction)select_all_now:(UIButton *)sender {
     [self selectAllTextIn_Textview:_SendText];
}
-(void)set_father_win:(Namelist*)father
{
    father_win=father;
}
- (IBAction)import_all:(UIButton *)sender {
    NSString* alldata=_SendText.text;

    NSMutableArray *array = (NSMutableArray *)[alldata componentsSeparatedByString:@"\n"];
    [file_controller File_Save_Mutable_Array:array to:@"classnametotal"];
    [father_win.navigationController popViewControllerAnimated:YES];
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
