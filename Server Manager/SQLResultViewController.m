//
//  SQLResultViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 4/8/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SQLResultViewController.h"

@interface SQLResultViewController ()

@end

@implementation SQLResultViewController
@synthesize data;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SQLResultCell" forIndexPath:indexPath];
//    NSUInteger count = 0, length = [dataString length];
//    NSRange range = NSMakeRange(0, length);
//    while(range.location != NSNotFound)
//    {
//        range = [dataString rangeOfString: @"\n" options:0 range:range];
//        if(range.location != NSNotFound)
//        {
//            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
//            count++; 
//        }
//    }
//    cell.textLabel.text = ([[data objectAtIndex:indexPath.row] class] == [NSMutableArray class]) ? [[data objectAtIndex:indexPath.row] objectAtIndex: 0] : [data objectAtIndex:indexPath.row];
    cell.textLabel.text=[[data objectAtIndex:indexPath.row] objectAtIndex: 0];
//    cell.detailTextLabel.text = dataString;
//    cell.detailTextLabel.numberOfLines = count;
//    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dataString =[[NSString alloc] init];
    for (int i = 0; i < [[data objectAtIndex:indexPath.row] count]; i++) {
        if (_fields != nil) {
            dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n\n",[_fields objectAtIndex:i], [[data objectAtIndex:indexPath.row] objectAtIndex:i]]];
        }else{
            dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[[data objectAtIndex:indexPath.row] objectAtIndex:i]]];
        }
        
        
    }
    
    UIAlertView *dataInfo = [[UIAlertView alloc] initWithTitle:nil message:dataString delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [dataInfo show];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
