//
//  RecordViewController.h
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/13.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UIBarButtonItem* edit;
-(IBAction)edit:(id)sender;
@end

