//
//  importname.h
//  Book_checker
//
//  Created by 王子诚 on 2019/9/30.
//  Copyright © 2019 王子诚. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "file.h"
#include "Namelist.h"
#ifndef importname_h
#define importname_h

@interface importname:UIViewController
{
    NSString* contents;
    Namelist* father_win;
    filer* file_controller;
}
- (void)selectAllTextInField:(UITextField *)textField;
-(void)set_contents:(NSString*)texter;
-(void)set_father_win:(Namelist*)father;
@end

#endif /* importname_h */
