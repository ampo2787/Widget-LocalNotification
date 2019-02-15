//
//  AreaTableViewController.m
//  Widget+LocalNotification
//
//  Created by JihoonPark on 05/12/2018.
//  Copyright © 2018 JihoonPark. All rights reserved.
//

#import "AreaTableViewController.h"
#import "AirKoreaData.h"
#import "DetailViewController.h"

@interface AreaTableViewController ()

@property (nonatomic, strong) NSString * elementName;
@property (nonatomic, strong) NSString * nodeValue;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableDictionary * dataDic;

@end

@implementation AreaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AirKoreaData getDataFromServer:[AirKoreaData AirKoreaRestURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:data];
        
        [xmlParser setDelegate:self];
        [xmlParser parse];
    }];
    self.title = @"대전";
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    NSLog(@"parser:didStartElement::(%@)", elementName);
    
    if([elementName isEqualToString:@"items"]){
        self.dataArray = [[NSMutableArray alloc]init];
    }
    else if([elementName isEqualToString:@"item"]){
        self.dataDic = [[NSMutableDictionary alloc]init];
    }
    else{
        self.elementName = [NSString stringWithString:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"parser:didEndElement");
    if([elementName isEqualToString:@"item"]){
        [self.dataArray addObject:self.dataDic];
    }
    else if([elementName isEqualToString:@"items"]){
        NSLog(@"complete parse");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSString *replaceString = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    replaceString = [replaceString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    replaceString = [replaceString stringByReplacingOccurrencesOfString:@"  " withString:@""];
    if(replaceString.length >0 && !([self.elementName isEqualToString:@"items"] || [self.elementName isEqualToString:@"body"]|| [self.elementName isEqualToString:@"response"] || [self.elementName isEqualToString:@"resultCode"] || [self.elementName isEqualToString:@"resultMsg"])){
        NSLog(@"elementName::%@", self.elementName);
        NSLog(@"parser:foundCharacters(%@)", replaceString);
        [self classify:replaceString];
    }
}

-(void)classify:(NSString *)string{
    if(!self.dataDic) return;
    [self.dataDic setObject:[NSString stringWithString:string] forKey:[NSString stringWithString:self.elementName]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
    NSDictionary *dataDic = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[dataDic objectForKey:AIRKOREA_KEY_STATION_NAME]];
    [cell.detailTextLabel setText:[dataDic objectForKey:AIRKOREA_KEY_PM10]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath){
            DetailViewController * detailVC = [segue destinationViewController];
            detailVC.dataDic = [self.dataArray objectAtIndex:indexPath.row];
        }
    }
}

@end
