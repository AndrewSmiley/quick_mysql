//
//  ViewSchemasViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/13/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "SchemasListViewController.h"
#import "TablesListViewController.h"
#import "SchemaOptionsViewController.h"
#import "MySQLConstants.h"
#import "mysql.h"
#import "UIAlertView+Blocks.h"
@interface SchemasListViewController ()

@end

@implementation SchemasListViewController
@synthesize schemas, server, tableView, connection, flag;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newButtonPressed)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    //    self.navigationItem.leftBarButtonItem = upButton;
    self.navigationItem.rightBarButtonItems= @[newButton, refreshButton];

        self.clearsSelectionOnViewWillAppear = YES;
    [self setTitle:[NSString stringWithFormat:@"Schemas on %@", [server serverName]]];
    
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    schemas  = [[NSMutableArray alloc] init];
    [self reloadSchemas];
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
    return [schemas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchemaCell" forIndexPath:indexPath];
    cell.textLabel.text = [schemas objectAtIndex:indexPath.row];
    return cell;
}

-(void) newButtonPressed{
    [UIAlertView showWithTitle:nil message:@"Name for new schema" style:UIAlertViewStylePlainTextInput cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Create"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0 ) {
            NSString *sql = [NSString stringWithFormat:@"CREATE SCHEMA %@", [[alertView textFieldAtIndex:0] text]];
            int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
            if (status != 0) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat: @"Could not create schema %@",[[alertView textFieldAtIndex:0] text] ] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"Created schema %@ successfully",[[alertView textFieldAtIndex:0] text] ] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
            [self.tableView reloadData];
            
        }
        
    }];
    
}

-(void) refreshButtonPressed{
    [self reloadSchemas];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (flag ==1) {
        SchemaOptionsViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"SchemaOptionsViewController"];
        [sovc setSchema:[schemas objectAtIndex:indexPath.row]];
        [sovc setServer:server];
        [sovc setConnection:connection];
        [self.storyboard instantiateViewControllerWithIdentifier:@"SchemaOptionsViewController"];
        [self.navigationController pushViewController:sovc animated:YES];
    }else if (flag == 2){
        TablesListViewController * tlvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TablesListViewController"];
        [tlvc setServer:server];
        [tlvc setConnection:connection];
        [tlvc setSchema:[schemas objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:tlvc animated:YES];

    }
}


-(void) reloadSchemas{
    [schemas removeAllObjects];
    NSString *sql = @"SHOW SCHEMAS;";
    int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
    if (status != 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not fetch the schema list." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        MYSQL_RES *result = mysql_store_result(&connection);
        if (result == NULL) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not fetch the schema list." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            MYSQL_ROW row;
            while ((row = mysql_fetch_row(result))) {
                char *charData = row[0];
                NSString *stringData = [[NSString alloc] initWithCString:charData encoding:NSUTF8StringEncoding];
                [schemas addObject:stringData];
            }
        }
    }
    [self.tableView reloadData];
}

@end
