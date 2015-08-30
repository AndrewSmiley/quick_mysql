//
//  ViewTableDataViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/22/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ViewTableDataViewController.h"
#import "ServerOverviewViewController.h"
#import "NSMySQLRow.h"
@interface ViewTableDataViewController (){
    NSMutableArray *fields;
    NSMutableArray *rows;
    
}

@end

@implementation ViewTableDataViewController
@synthesize connection, server, table, schema, collectionView;
static NSString * const reuseIdentifier = @"DataCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView  registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    rows = [[NSMutableArray alloc] init];
    
    //let's make sure the connection to the db is still fresh
    if (mysql_ping(&connection)) {
        //if not lets
        ServerOverviewViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerOverviewViewController"];
        [self presentViewController:sovc animated:YES completion:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to database has been lost." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }];
    }else{
        char *db = [schema UTF8String];
        int result = mysql_select_db(&connection, db);
        if (result != 0) {
            ServerOverviewViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerOverviewViewController"];
            [self presentViewController:sovc animated:YES completion:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error code %u: %s", mysql_errno(&connection), mysql_error(&connection)] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }];
            
        }else{
            NSString *sql = [[NSString alloc] initWithFormat:@"SELECT * FROM %@ LIMIT 1000;", table];
            int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
            if (status == 0){
                MYSQL_RES *result = mysql_store_result(&connection);
                if (result != NULL) {
                    MYSQL_ROW row;
                    MYSQL_FIELD *field;
                    unsigned int num_fields = mysql_num_fields(result);
                        fields = [[NSMutableArray alloc] init];
                    while ((field = mysql_fetch_field(result))) {
                        [fields addObject:[NSValue valueWithPointer:field]];
                    }
                    for (int i = 0; i < fields.count; i++) {
                        MYSQL_FIELD *f = [[fields objectAtIndex:i] pointerValue];
                        NSLog([NSString stringWithFormat:@"%s", f->name]);
                    }

                    while ((row = mysql_fetch_row(result))) {
                        NSMySQLRow *r = [[NSMySQLRow alloc] init];
                        for (int i =0; i < num_fields; i++) {
                            char *charData = row[i];
                            NSString *stringData = charData ? [[NSString alloc] initWithCString:charData encoding:NSUTF8StringEncoding] : @"NULL";
                            [r addObject:stringData];
                        }
                        [rows addObject:r];
                    }
                    
                }else{
                    NSLog(@"This Schema seems to have no tables ");
                }
            }else{
                //not sure what to do here
                NSLog([NSString stringWithFormat:@"Error code %u: %s", mysql_errno(&connection), mysql_error(&connection)]);
            }
        }
        
        
    }

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return [fields count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return rows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UILabel *label =[[UILabel alloc] init];

    NSMySQLRow *my = [rows objectAtIndex:indexPath.row];
    
    label.text = [my objectAtIndex:0];
    label.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor grayColor];
    [cell addSubview:label];
    return cell;
}

- (void)viewDidLayoutSubviews {
    collectionView.contentSize = collectionView.frame.size;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
