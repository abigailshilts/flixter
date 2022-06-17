//
//  CustomCell.h - for use in tableView
//  flixter
//
//  Created by Abigail Shilts on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCell : UITableViewCell

// Outlets to cell items
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end

NS_ASSUME_NONNULL_END
