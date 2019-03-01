//
//  MusicDetailsViewController.m
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "MusicDetailsViewController.h"
#import "MusicItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MusicDetailsViewController ()

@end

@implementation MusicDetailsViewController {
    IBOutlet UILabel *_collectionLabel;
    IBOutlet UILabel *_artistNameLabel;
    IBOutlet UILabel *_releaseDateLabel;
    IBOutlet UILabel *_primaryGenreNameLabel;
    IBOutlet UIImageView *_artworkImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setItem:(MusicItem *)item {
    _item = item;
    [self updateUI];
}

- (void)updateUI {
    self.title = self.item.trackName;
    _collectionLabel.text = self.item.collectionName;
    _artistNameLabel.text = self.item.artistName;
    _releaseDateLabel.text = self.item.releaseDate;
    _primaryGenreNameLabel.text = self.item.primaryGenreName;
    [_artworkImageView sd_setImageWithURL:[NSURL URLWithString:self.item.artworkUrl100]];
}

@end
