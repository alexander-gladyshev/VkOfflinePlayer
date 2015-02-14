//
//  MPOnlinePlaylistViewController.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MPOnlinePlaylistViewController.h"
#import "VKUserManager.h"
#import "MPSongViewCell.h"
#import "SongMO+Actions.h"
#import "AppDelegate.h"
#import "MPAudioPlayer.h"

@interface MPOnlinePlaylistViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController * allSongsFetchResultCtrl;

@end

@implementation MPOnlinePlaylistViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loaderIndicatorView.hidden = NO;
    if ([VKUserManager sharedInstance].user && ! self.offlineMode){
        [[VKUserManager sharedInstance] getUserInfoWithCompletion:^{
            self.nickNameLabel.text = [[VKUserManager sharedInstance] getFullUserName];
            self.loaderIndicatorView.hidden =YES;
            [self loadSongs];
        } failedCompletion:^{
            self.nickNameLabel.text = @"ошибка загрузки информации о пользователе";
            self.loaderIndicatorView.hidden =YES;
        }];
    }else if (!self.offlineMode){
        [self performSegueWithIdentifier:@"LoginAuthSegue" sender:self];
    }else{
        [self getSongsFromDataBase];
    }
}

-(void)loadSongs{
    [[VKUserManager sharedInstance] getUserPlaylistWithCompletion:^{
        [self getSongsFromDataBase];
    } failedCompletion:^{
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"LoginAuthSegue"]){
        ((LoginViewController *)segue.destinationViewController).delegate = self;
    }
}

-(void)getSongsFromDataBase{
    self.allSongsFetchResultCtrl = [SongMO getFetchResultControllerWithAllSongs];
    self.allSongsFetchResultCtrl.delegate = self;
    [self.tableView reloadData];
    [self checkForEmptyList];
}

#pragma mark tableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allSongsFetchResultCtrl.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPSongViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MPSongViewCell"];
    [cell fillWithSong:self.allSongsFetchResultCtrl.fetchedObjects[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SongMO * selectedSong = self.allSongsFetchResultCtrl.fetchedObjects[indexPath.row];
    if ([[MPAudioPlayer sharedInstance] isCurrentSong:selectedSong]){
        if ([MPAudioPlayer sharedInstance].state == MPAudioPlayerStatePlaying){
            [[MPAudioPlayer sharedInstance] pause];
        }else if([MPAudioPlayer sharedInstance].state == MPAudioPlayerStatePaused){
            [[MPAudioPlayer sharedInstance] play];
        }
        
    }else{
        [[MPAudioPlayer sharedInstance] playSong:selectedSong];
    }
}

#pragma mark NSFetchedResultsControllerDelegate


-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"controllerDidChangeContent");
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch (type) {
        case NSFetchedResultsChangeDelete:
            break;
        case NSFetchedResultsChangeInsert:
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        default:
            break;
    }
    NSLog(@"didChangeObject");
    [self checkForEmptyList];
}


-(void)checkForEmptyList{
    if (![self.allSongsFetchResultCtrl.fetchedObjects count]){
        self.tableView.hidden = YES;
        self.emptyListView.frame = self.view.bounds;
        [self.view addSubview:self.emptyListView];
    }else{
        self.tableView.hidden = NO;
        [self.emptyListView removeFromSuperview];
    }
}
@end
