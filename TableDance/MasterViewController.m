//
//  MasterViewController.m
//  TableDance
//
//  Created by Christian Beck on 23.11.14.
//  Copyright (c) 2014 Christian Beck. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "TableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Die estimatedRowHeight ist ein Richtwert, den der TableView nur fuer das berechnen des Scroll Bars verwendet. Wenn der nicht halbwegs passt, feangt der Bar
    // an zu huepfen und veraendert ein wenig die Groesse. Kannste mal ausproboeren indem du hier mal 10.0 oder so angibst und dann ne ganze Menge Cells erzeugst.
    // Das ist dann halt der Tradeoff, wenn man nicht will, dass fuer alle Cells schon das Layout gemacht wird, was einfach imperformat waere. Aber ohne Layout
    // kann man auch nicht wissen wie hoch das ganze wird.
    // Wir haben in einer unserer Apps estimatedHeightForRowAtIndexPath implementiert und schauen dort auf den Text des labels, dass am meisten Text hat. Mit einer Heuristik
    // berechnen wir dann wir hoch die Zeile wird. Das wir dann aber mit den neune iPhone Breiten eher unschoener Code.
    self.tableView.estimatedRowHeight = 44.0;
    // iOS 8 kann das mit dem Berechnen nun allein, warum man das nicht im IB angeben kann, oder das gleich einfach so passiert weiss ich auch nicht (hab mich damit noch nicht
    // naeher befasst).
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // Was ist das?
    NSLog(@"%f", UITableViewAutomaticDimension);
    NSLog(@"%f", self.tableView.rowHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.leftLabel.text = [object description];
    cell.rightLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
