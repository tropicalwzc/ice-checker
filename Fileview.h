//
//  Fileview.h
//  ice_checker
//
//  Created by 王子诚 on 2019/2/27.
//  Copyright © 2019 王子诚. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "file.h"
#import "Namelist.h"
#import "smallwindow.h"
#import "Booklist.h"
#ifndef Fileview_h
#define Fileview_h

@interface Fileview:UITableViewController
<UITableViewDataSource,UITableViewDelegate>
{
    filer* file_controller;
    smallwindow* window_controller;
    Namelist* father_window;
    Booklist* father_booklist_window;
    long focus_id;
    int file_total_number;
    UITableViewCell* Cellstore[100];
    NSString* saver_prefixes[100];
    NSMutableArray* savers;
    long saver_total_number;
}
-(Fileview*)init_with_father_window:(Namelist*)father_win;
-(void)set_name_and_booklist:(Namelist*)father_win booklist:(Booklist*)father_booklist;
-(NSMutableArray*)fetch_saver_file_names;
-(void)save_current_to_saver_file;
-(void)Save_Current_All_file_to:(NSString*)prefix;
-(void)Read_func;
-(void)Write_func;
-(void)Read_All_file_from:(NSString*)prefix;
-(void)Delete_All_file_from:(NSString*)prefix;
-(void)Move_All_file_from:(NSString*)origin to:(NSString*)aim;
-(void)Build_a_new_saver:(NSString*)prefix;

-(NSString*)Read_saver_time_file:(NSString*)prefix;
-(NSString*)saver_time_file_name:(NSString*)prefix;
-(NSString*)paid_file_name:(NSString*)prefix;
-(NSString*)namelist_file_name:(NSString*)prefix;
-(NSString*)booknumber_file_name:(NSString*)prefix;
-(NSString*)booknames_file_name:(NSString*)prefix id:(int)ider;
-(NSString*)bookprices_file_name:(NSString*)prefix id:(int)ider;
-(NSString*)booklist_file_name:(NSString*)prefix id:(int)ider;
@end

#endif /* Fileview_h */
