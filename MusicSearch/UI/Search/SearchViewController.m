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
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;;
@end

@implementation SearchViewController {
    IBOutlet UISearchBar *_searchBar;
    UIActivityIndicatorView *_activityView;
    MusicsDataSource *_musicsDataSource;
    HistoryDataSource *_historyDataSource;
    NSString *_term;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideNavigationBar];
    [self createActivityIndicator];
    [self settingDataSouces];
    [self updateHistory];
    [self showMusic];
    [self subscribe];
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
        self.tableViewBottomConstraint.constant = keyboardSize.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.tableViewBottomConstraint.constant = 0;
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
    self.tableView.dataSource = _musicsDataSource;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.backgroundColor = [UIColor whiteColor];
    }];
    [self updateUI];
}

- (void)showHistory {
    self.tableView.dataSource = _historyDataSource;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.backgroundColor = [UIColor grayColor];
    }];
    
    [self updateUI];
}

- (void)updateHistory {
    [_historyDataSource updateHistory];
}

- (void)updateUI {
    [self.tableView reloadData];
}

- (void)searchForItem:(HistoryItem *)item {
    _searchBar.text = item.term;
    [self searchBarSearchButtonClicked:_searchBar];
}

- (void)search:(NSString *)term {
    [self showActivityView];
    [_musicsDataSource loadMusicsWithTerm:term];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailsSegue"] && [segue.destinationViewController isKindOfClass:[MusicDetailsViewController class]]) {
        MusicDetailsViewController* controller = (MusicDetailsViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        controller.item = _musicsDataSource.items[(NSUInteger)indexPath.row];
    }
}

#pragma mark - MusicsDataSourceDelegate

- (void)dataSourceChanged:(MusicsDataSource *)dataSource {
    [self hideActivityView];
    [self updateHistory];
    [self updateUI];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    _term = searchBar.text;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _term = searchBar.text;
    [searchBar resignFirstResponder];
    [self showMusic];
    [self search:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = _term;
    [self showMusic];
}

#pragma mark - Activity

- (void)createActivityIndicator {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)showActivityView {
    if ([NSThread isMainThread]) {
        [self startAnimatingActivity];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimatingActivity];
        });
    }
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
    if ([NSThread isMainThread]) {
        [self stopAnimatingActivity];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimatingActivity];
        });
    }
}

- (void)stopAnimatingActivity {
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

@end
