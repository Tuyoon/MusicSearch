//
//  SearchViewController.m
//  MusicSearch
//
//  Created by Mac on 04.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "SearchViewController.h"
#import "MusicsDataSource.h"
#import "HistoryDataSource.h"
#import "MusicDetailsViewController.h"
#import "HistoryItem.h"
#import "Searcher.h"

@interface SearchViewController ()<MusicsDataSourceDelegate, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation SearchViewController {
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UIView *_emptyResultsView;
    UIActivityIndicatorView *_activityView;
    id<MusicWebConnectorProtocol> _webConnector;
    MusicsDataSource *_musicsDataSource;
    HistoryDataSource *_historyDataSource;
    id<SearcherProtocol> _searcher;
    NSString *_query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subscribe];
    [self hideNavigationBar];
    [self createActivityIndicator];
    [self configure];
    [self updateHistory];
    [self showMusic];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNavigationBar];
}

- (void)dealloc {
    [self unsubscribe];
}

#pragma mark - Private Methods

- (void)subscribe {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_tableView setContentInset:UIEdgeInsetsZero];
}

- (void)configure {
    _webConnector = [[MusicWebConnector alloc] init];
    _searcher = [[Searcher alloc] initWithWebConnector:_webConnector];
    _musicsDataSource = [[MusicsDataSource alloc] initWithSearcher:_searcher];
    _musicsDataSource.delegate = self;
    _historyDataSource = [[HistoryDataSource alloc] initWithSearcher:_searcher];
}

- (void)hideNavigationBar {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)showNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)showMusic {
    _tableView.tableHeaderView = _emptyResultsView;
    _tableView.dataSource = _musicsDataSource;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.backgroundColor = [UIColor whiteColor];
    }];
    [self updateUI];
}

- (void)showHistory {
    _tableView.tableHeaderView = nil;
    _tableView.dataSource = _historyDataSource;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.backgroundColor = [UIColor lightGrayColor];
    }];
    
    [self updateUI];
}

- (void)updateHistory {
    [_historyDataSource updateHistory];
}

- (void)updateUI {
    _tableView.tableHeaderView = _musicsDataSource.items.count == 0 ? _emptyResultsView : nil;
    [_tableView reloadData];
}

- (void)searchForItem:(HistoryItem *)item {
    _query = item.query;
    _searchBar.text = _query;
    [self search];
}

- (void)search {
    [self showActivityView];
    _tableView.tableHeaderView = nil;
    [_musicsDataSource loadMusicsWithQuery:_query completion:^(NSArray *items) {
        [self hideActivityView];
        [self updateHistory];
        [self updateUI];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[MusicDetailsViewController class]]) {
        MusicDetailsViewController* controller = (MusicDetailsViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)sender];
        controller.item = _musicsDataSource.items[(NSUInteger)indexPath.row];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.dataSource == _historyDataSource) {
        [_searchBar resignFirstResponder];
        [self showMusic];
        HistoryItem *item = _historyDataSource.items[(NSUInteger)indexPath.row];
        [self searchForItem:item];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showHistory];
    _query = searchBar.text;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _query = searchBar.text;
    [searchBar resignFirstResponder];
    [self showMusic];
    [self search];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = _query;
    [self showMusic];
}

#pragma mark - Activity View

- (void)createActivityIndicator {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = self.view.bounds;
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _activityView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
}

- (void)showActivityView {
    self.view.userInteractionEnabled = NO;
    [_activityView startAnimating];
}

- (void)hideActivityView {
    [_activityView stopAnimating];
    self.view.userInteractionEnabled = YES;
}

@end
