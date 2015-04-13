//
//  YouTubeHelper.m
//  TopTastic
//
//  Created by Davy, Martin on 4/10/15.
//  Copyright (c) 2015 Mandi. All rights reserved.
//

#import "YouTubeHelper.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2WindowController.h"


@interface YouTubeHelper()

@property (strong, nonatomic) GTLServiceYouTube *youTubeService;
@property (strong, nonatomic) NSArray *playListItems;

@end


@implementation YouTubeHelper


- (GTLServiceYouTube *) youTubeService
{
    if (_youTubeService == nil)
    {
        _youTubeService = [[GTLServiceYouTube alloc] init];
        _youTubeService.APIKey = @"AIzaSyAoODrllcXVEL1RRZzG0nKmSHlbwIP4I2c";
    }
    
    return _youTubeService;
}

- (void) getPlayList
{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"snippet"];
    query.playlistId = @"PLtZ7tJkCfjGz8PRCfv3NcekipiDXolbLF";
    query.maxResults = 40;
    
    __block NSArray *result = nil;
    
    GTLServiceTicket *ticket = [ self.youTubeService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error)
    {
        
        if (error == nil)
        {
            GTLYouTubePlaylistItemListResponse *response = object;
            result = response.items;
            self.playListItems = result;
                
        }
    }];
}

@end