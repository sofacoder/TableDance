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
#import "DetailObject.h"

@interface MasterViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *objects;
@property NSMutableArray *filteredObjects;
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
    
    // falsche Schätzungen führen unter iOS 8 zu sprüngen der Auswahl, wenn die Tabelle ein Stück gescrollt wurde!
    // also keine Vorgabe für iOS 8 - mal immer in der Annahme, dass man die Angabe eben schätzt, und nicht weiß
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        self.tableView.estimatedRowHeight = 44;
    }
    
    UITableView *searchResultsTableView = self.searchDisplayController.searchResultsTableView;
    // Hmpf. Nette Idee, aber leider Quatsch, weil das Layout selbst ja im Storyboard steckt, und nicht
    // in der Klasse - also dann doch self.tableView bei dequeueReusableCellWithIdentifier nutzen...
//    // Cell auch für den searchResultsTableView registrieren und damit den gleichen Prototypen für die Suche verwenden
//    [searchResultsTableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];
    searchResultsTableView.estimatedRowHeight = self.tableView.estimatedRowHeight;
    searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // ein paar Objekte erstellen, damit schön was angezeigt werden kann
    self.objects = [[NSMutableArray alloc] init];
    for (int i=0; i < 100; i++) {
        [self.objects addObject:[[DetailObject alloc]
                                 initWithTitle:[NSString stringWithFormat:@"Ereignis %i", i]
                                 andDate:[NSDate dateWithTimeIntervalSinceNow:i*100000]]];
    }
    self.filteredObjects = [NSMutableArray arrayWithCapacity:[self.objects count]];
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
    DetailObject *object = [[DetailObject alloc] initWithTitle:@"Neues Ereignis" andDate:[NSDate date]];
    [self.objects insertObject:object atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        if (self.searchDisplayController.active) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            DetailObject *object = self.filteredObjects[indexPath.row];
            [[segue destinationViewController] setDetailItem:object];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            DetailObject *object = self.objects[indexPath.row];
            [[segue destinationViewController] setDetailItem:object];
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredObjects.count;
    }
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell forTableView:tableView atIndexPath:indexPath];
    return cell;
}

- (void) configureCell:(TableViewCell *)cell forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    DetailObject *object;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        object = self.filteredObjects[indexPath.row];
    } else {
        object = self.objects[indexPath.row];
    }
    NSLog(@"configureCell %@", object);
    cell.leftLabel.text = [object.date description];
    cell.rightLabel.text = object.title;
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

/**
 * OK, du hast dir da natürlich gleich einen etwas speziellen Fall ausgedacht. Aus einem Grunde den ich nicht mehr kenne, 
 berechnet der TableView die Größe der Zelle zu einem ungünstigen Zeitpunkt. Du muss ihm helfen und das Layout fuer ihn 
 schon mal machen. Wie gesagt, es gab dafuer keine guten, aber soweit ich mich erinnere nachvollziehbare Gruende. Cool ist das nicht.
 
 Mit iOS 7.0 kann das auch zu performance Problemen kommen, weil 7.0 das fuer alle Zellen (auch die nicht sichtbaren) macht. 
 Sprich 7.0 ruft nicht estimatedHeightForRowAtIndexPath auf, selbst wenn man es implementiert hat. Mit 7.1 ist das aber gefixed.
 
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static TableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    });
    
    [self configureCell:sizingCell forTableView:tableView atIndexPath:indexPath];
    CGFloat height = [self calculateHeightForConfiguredSizingCell:sizingCell];
    NSLog(@"heightForRowAtIndexPath %f", height);
    return height;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    return size.height;
}

#pragma mark - Filtering

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString];
    return YES;
}

-(void)filterContentForSearchText:(NSString*)searchText {
    [self.filteredObjects removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    self.filteredObjects = [NSMutableArray arrayWithArray:[self.objects filteredArrayUsingPredicate:predicate]];
    NSLog(@"filteredObjects: %i", self.filteredObjects.count);
}

@end
