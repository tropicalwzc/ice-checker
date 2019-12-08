//
//  BIDSwitchViewController.h
//  multi_view_test
//
//  Created by 王子诚 on 2018/11/28.
//  Copyright © 2018 王子诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "file.h"
#import "smallwindow.h"
#import "Sendview.h"
NS_ASSUME_NONNULL_BEGIN

@interface Namelist : UITableViewController
<UITableViewDataSource,UITableViewDelegate>
{

    int choice;
    int focus_id;
    bool isipad;
    filer* file_controller;
    smallwindow* window_controller;
    int has_homework[200];
    int has_paid[200];
    int current_booknumber;
    UITableViewCell* Cellstore[200];
    int home_work_mode;
    NSString* currentname;
    NSString* homework_file_title;
    NSString* paid_file_title;
    NSString* booknames_str[200];

    int total_book_number;
    int users_books[200][200];
    float pricer[200];
    NSString* prices[200];
}
-(NSString*)get_pricefile_title:(int)ider;
-(NSString*)get_bookedlist_file_title:(int)ider;
-(NSString*)get_book_names_file_title:(int)ider;
-(NSString*)generate_simple_list:(int)ider;
-(NSString*)generate_final_name_book_list;
-(NSString*)current_time_str;
-(NSArray*)get_classmate_names;
-(float)User_total_price:(int)user_id;
-(void)load_origin_data_from_files;
-(void)toggle_paid_condition:(int)user_id;
-(void)fetch_price;
-(void)fetch_booknames;
-(void)set_home_work_mode:(int)mode;
-(void)set_total_booknumber:(int)booknum;
-(void)set_user_books_data:(int[200][200])data;
-(void)set_user_books_bit_at:(int)x y:(int)y val:(int)val;
-(void)set_books_name:(NSString*)booknames at:(int)ider;

-(NSString*)pack_book:(int[200])aim;
-(int)release_book:(NSString*)data aim:(int[200])aim;

-(void) flush_view;
-(void) clear_homework_list;
-(void)read_all_from_booklistfiles;
-(int)fetch_total_booknum;
-(void)save_total_booknum:(int)booknumber;
@end

NS_ASSUME_NONNULL_END
