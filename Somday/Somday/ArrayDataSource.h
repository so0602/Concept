#import <Foundation/Foundation.h>


typedef void (^TableViewCellConfigureBlock)(id cell, id item);
typedef void (^TableViewCellEditBlock)(UITableViewCellEditingStyle editingStyle, id item);


@interface ArrayDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *items;

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
      editCellBlock:(TableViewCellEditBlock)aEditCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
