//
//  BIDBlueViewController.h
//  multi_view_test
//
//  Created by 王子诚 on 2018/11/28.
//  Copyright © 2018 王子诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "file.h"
#import "smallwindow.h"
#import "Namelist.h"

NS_ASSUME_NONNULL_BEGIN
#ifndef Booklist_h
#define Booklist_h
@interface Booklist : UITableViewController
<UITableViewDataSource,UITableViewDelegate>
{
    Namelist*father_window;
    UITableViewCell* Cellstore[200];
    int total_list_mode;
    int booked_this[200];
    int booked_total_num[200];
    float pricer[200];
    bool isipad;
    NSString* prices[200];
    NSString* booknames_str[200];
    int total_book_number;
    NSString* classmate_name[200];
    NSArray* classmate_name_array;
    NSMutableArray* newly_recev_books;
    int classmate_total_number;
    int book_id;
    float total_use;
    int focus_id;
    filer* file_controller;
    smallwindow* window_controller;
    NSString* booklist_file_title;
    NSString* current_title;
    NSString* inputed_str;
    @public
    int users_books[200][200];
}
-(Booklist*)init_with_father_window:(Namelist*)father_win;
-(void)set_father_window:(Namelist*)aim;
-(void)set_bookid:(int)ider;
-(void)set_newly_recev_books:(NSMutableArray*)newbooks;
-(NSString*)get_pricefile_title:(int)ider;
-(NSString*)get_bookedlist_file_title:(int)ider;
-(NSString*)get_book_names_file_title:(int)ider;
-(NSString*)pack_book:(int[200])aim;
-(int)release_book:(NSString*)data to:(int[200])list;
-(float)calculate_price;
-(void)delete_all_act;
-(void)display_price;
-(void)set_class_mate_names:(NSArray*) str;
-(void)read_all_from_booklistfiles;
-(void)calculate_total_booknumbers;
-(void)fetch_price;
-(void)fetch_booknames;
-(void)fetch_classmate_names;
-(void)flush_view;
-(int)fetch_total_booknum;
-(void)save_total_booknum;
-(BOOL)Delete_book:(int)ider;
-(void)Booked_all_member_to_focus_id;
-(void)load_origin_data_from_files;
-(void)name_input:(NSString*)texter;
-(void)price_input:(NSString*)texter;
-(void)Input_a_new_price:(NSString*)origin_name price:(NSString*)origin_price_str;
-(void)Input_a_new_name:(NSString*)origin_name;
@end
#endif
NS_ASSUME_NONNULL_END
