//
//  TableViewController.m
//  TopTastic
//
//  Created by Davy, Martin on 4/10/15.
//  Copyright (c) 2015 Mandi. All rights reserved.
//

#import "TableViewController.h"
#import "GTLYouTube.h"
#import "MusicVideo.h"

@interface TableViewController ()

@property (strong, nonatomic) GTLServiceYouTube *youTubeService;
@property (strong, nonatomic) NSArray *musicVideos;

@end

@implementation TableViewController

- (GTLServiceYouTube *) youTubeService
{
    if (_youTubeService == nil)
    {
        _youTubeService = [[GTLServiceYouTube alloc] init];
        _youTubeService.APIKey = @"AIzaSyAoODrllcXVEL1RRZzG0nKmSHlbwIP4I2c";
    }
    
    return _youTubeService;
}

@synthesize musicVideos = _musicVideos;

- (NSArray*) musicVideos
{
    return _musicVideos;
}

- (void) setMusicVideos:(NSArray *)musicVideos
{
    _musicVideos = musicVideos;
    [self.tableView reloadData];
}

- (void) updatePlayList
{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"snippet"];
    query.playlistId = @"PLtZ7tJkCfjGz8PRCfv3NcekipiDXolbLF";
    query.maxResults = 40;
    
    
    [self.youTubeService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error)
     {
         
         if (error == nil)
         {
             GTLYouTubePlaylistItemListResponse *response = object;
             __block NSMutableArray *result = [[NSMutableArray alloc] init];
             
             for (GTLYouTubePlaylistItem *item in response.items)
             {
                 GTLYouTubeThumbnailDetails *thumbnails = item.snippet.thumbnails;
                 GTLYouTubeThumbnail *thumbnail = thumbnails.standard;
                 
                 NSArray *at = [item.snippet.title componentsSeparatedByString:@"-"];
                 NSString *artist = item.snippet.title;
                 NSString *title = item.snippet.title;
                 
                 if (at.count == 2)
                 {
                     artist = [at[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                     title = [at[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                 }
                 
                 MusicVideo* video = [[MusicVideo alloc] init];
                 video.artist = artist;
                 video.title = title;
                 video.thumbnailUrl = thumbnail.url;
                 
                 
                 GTLYouTubeResourceId *resourceId = item.snippet.resourceId;
                 video.videoId = [resourceId.JSON objectForKey:@"videoId"];
                 
                 [result addObject:video];
                 
             }
             
             self.musicVideos = result;
         }
     }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self updatePlayList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    // Return the number of rows in the section.
    return self.musicVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *myReuseId = @"MyReuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myReuseId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myReuseId];
    }
    
    MusicVideo *video = self.musicVideos[indexPath.row];
    
    cell.textLabel.text = video.artist;
    cell.detailTextLabel.text = video.title;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbnailUrl]]];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
