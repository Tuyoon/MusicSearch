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

@interface SearchViewController ()<MusicsDataSourceDelegate, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation SearchViewController {
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet NSLayoutConstraint *_tableViewBottomConstraint;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak UIView *_emptyResultsView;
    UIActivityIndicatorView *_activityView;
    MusicsDataSource *_musicsDataSource;
    HistoryDataSource *_historyDataSource;
    NSString *_query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
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

- (void)configure {
    [self subscribe];
    [self hideNavigationBar];
    [self createActivityIndicator];
    [self settingDataSouces];
    [self updateHistory];
    [self showMusic];
}

- (void)subscribe {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        _tableViewBottomConstraint.constant = keyboardSize.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        _tableViewBottomConstraint.constant = 0;
    }];
}

- (void)settingDataSouces {
    _musicsDataSource = [[MusicsDataSource alloc] init];
    _musicsDataSource.delegate = self;
    _historyDataSource = [[HistoryDataSource alloc] init];
}

- (void)hideNavigationBar {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)showNavigationBar {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)showMusic {
    _tableView.dataSource = _musicsDataSource;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.backgroundColor = [UIColor whiteColor];
    }];
    [self updateUI];
}

- (void)showHistory {
    _tableView.dataSource = _historyDataSource;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.backgroundColor = [UIColor grayColor];
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
    [self showMusic];
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
    if ([segue.identifier isEqualToString:@"DetailsSegue"] && [segue.destinationViewController isKindOfClass:[MusicDetailsViewController class]]) {
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

#pragma mark - Activity

- (void)createActivityIndicator {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)showActivityView {
    [self startAnimatingActivity];
}

- (void)startAnimatingActivity {
    _activityView.frame = self.view.bounds;
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _activityView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    _activityView.hidden = NO;
    _activityView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
}

- (void)hideActivityView {
    [self stopAnimatingActivity];
}

- (void)stopAnimatingActivity {
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

@end
