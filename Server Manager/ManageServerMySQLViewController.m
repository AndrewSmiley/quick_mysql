//
//  ManageServerMySQLViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/13/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ManageServerMySQLViewController.h"
#import "mysql.h"
#import "SchemasListViewController.h"
#import "MySQLConstants.h"
#import "EditSQLViewController.h"
@interface ManageServerMySQLViewController (){
    MYSQL connection;
}

@end

@implementation ManageServerMySQLViewController
@synthesize tableView, server, tmpPassword, options;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"Manage %@", [server serverName]]];
    options = [[NSMutableArray alloc] initWithObjects: @"Manage Schemas", @"Manage Tables", @"SQL Console", nil];
    //initialize nigga
    mysql_init(&connection);
    NSLog([NSString stringWithFormat:@"%s", [[server host] UTF8String]]);
    //so we HAVE to to cast to a char * first before we call mysql_real_connect
    char *host = [[server host] UTF8String];
    char *user = [[server username] UTF8String];
    char *pass = [[server password] UTF8String];
    unsigned int port = [[server port] intValue];
    
    if (!mysql_real_connect(&connection, host, user, pass, NULL, port, NULL, 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error code %u: %s",mysql_errno(&connection), mysql_error(&connection)] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    self.clearsSelectionOnViewWillAppear = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [options count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *CellIdentifier = @"MySQLOptionCell";
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//Server *server = [servers objectAtIndex:indexPath.row];
cell.textLabel.text = [options objectAtIndex:indexPath.row];
//cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@", server.host, server.port];
//cell.textLabel.numberOfLines =2;
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];

return cell;

}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //other VCs will go here dawg
    if (indexPath.row == 0) {
                SchemasListViewController *slvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"SchemasListViewController"];
        [slvc setServer:server];
        [slvc setConnection:connection];
        [slvc setFlag:1];
        [self.navigationController pushViewController:slvc animated:YES];
        
    }else if (indexPath.row == 1){
        SchemasListViewController *slvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"SchemasListViewController"];
        [slvc setServer:server];
        [slvc setConnection:connection];
        [slvc setFlag:2];
        [self.navigationController pushViewController:slvc animated:YES];
        //case when we want to edit sql
    }else if (indexPath.row == 2){
        EditSQLViewController *esvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditSQLViewController"];
        [esvc setServer:server];
        [esvc setConnection:connection];
        [self.navigationController pushViewController:esvc animated:YES];
        
        
    }else if (indexPath.row == 3){
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
