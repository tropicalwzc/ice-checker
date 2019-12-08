//
//  Sendview.h
//  ice_checker
//
//  Created by 王子诚 on 2019/2/22.
//  Copyright © 2019 王子诚. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef Sendview_h
#define Sendview_h
@interface Sendview:UIViewController
{
    NSString* contents;
}
- (void)selectAllTextInField:(UITextField *)textField;
-(void)set_contents:(NSString*)texter;
@end

#endif /* Sendview_h */
