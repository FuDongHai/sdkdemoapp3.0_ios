//
//  EMCallSettingsViewController.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2018/12/28.
//  Copyright © 2018 XieYajie. All rights reserved.
//

#import "EMCallSettingsViewController.h"

#import "EMDemoOptions.h"
#import "DemoCallManager.h"

@interface EMCallSettingsViewController ()

@end

@implementation EMCallSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    [self _setupSubviews];
    
    [DemoCallManager sharedManager];
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    [self addPopBackLeftItem];
    self.title = @"实时音视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 55;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = kColor_LightGray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 2;
            break;
        case 2:
            count = 2;
            break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"UITableViewCellValue1";
    if (section != 3 && row == 0) {
        cellIdentifier = @"UITableViewCellSwitch";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UISwitch *switchControl = nil;
    // Configure the cell...
    if (cell == nil) {
        if (section != 2 && row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 65, 10, 50, 40)];
            switchControl.tag = 100 - section;
            [switchControl addTarget:self action:@selector(cellSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchControl];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (section != 2 && row == 0) {
        switchControl = [cell.contentView viewWithTag:(100 - section)];
    }
    
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"离线推送呼叫";
            [switchControl setOn:options.isSendPushIfOffline animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.textLabel.text = @"显示视频通话信息";
            [switchControl setOn:[EMDemoOptions sharedOptions].isShowCallInfo animated:YES];
        } else if (row == 1) {
            cell.textLabel.text = @"默认摄像头";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [EMDemoOptions sharedOptions].isUseBackCamera ? @"后置摄像头" : @"前置摄像头";
        }
    } else if (section == 2) {
        if (row == 0) {
            cell.textLabel.text = @"视频最大码率";
            cell.detailTextLabel.text = @(options.maxVideoKbps).stringValue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (row == 1) {
            cell.textLabel.text = @"视频最小码率";
            cell.detailTextLabel.text = @(options.minVideoKbps).stringValue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 3) {
        return 10;
    }
    
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 3) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    if (section == 0) {
        label.text = @"    用户离线时推送呼叫请求";
    } else if (section == 2) {
        label.numberOfLines = 2;
        label.text = @"    固定分辨率会受到网络不稳定等因素影响";
    }
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        if (row == 1) {
            [self updateCameraDirection];
        }
    } else if (section == 2) {
        if (row == 0) {
            [self updateMaxVideoKbps];
        } else if (row == 1) {
            [self updateMinVideoKbps];
        }
    }
}

#pragma mark - Action

- (void)cellSwitchValueChanged:(UISwitch *)aSwitch
{
    NSInteger tag = aSwitch.tag;
    if (tag == 0) {
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        options.isSendPushIfOffline = aSwitch.on;
        [[DemoCallManager sharedManager] saveCallOptions];
    } else if (tag == 1) {
        [EMDemoOptions sharedOptions].isShowCallInfo = aSwitch.isOn;
        [[EMDemoOptions sharedOptions] archive];
    }
}

- (void)updateCameraDirection
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"默认摄像头方向" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    EMDemoOptions *options = [EMDemoOptions sharedOptions];
    [alertController addAction:[UIAlertAction actionWithTitle:@"前置摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        options.isUseBackCamera = NO;
        [options archive];
        [self.tableView reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"后置摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        options.isUseBackCamera = YES;
        [options archive];
        [self.tableView reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateMaxVideoKbps
{
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"视频最大码率" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入视频最大码率(150-1000)";
        textField.text = @(options.maxVideoKbps).stringValue;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        int value = [textField.text intValue];
        if ((value >= 150 && value <= 1000) || value == 0) {
            options.maxVideoKbps = value;
            [[DemoCallManager sharedManager] saveCallOptions];
            [self.tableView reloadData];
        } else {
            [EMAlertController showErrorAlert:@"最大视频码率范围150 - 1000"];
        }
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateMinVideoKbps
{
    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"视频最小码率" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入视频最小码率";
        textField.text = @(options.maxVideoKbps).stringValue;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        int value = [textField.text intValue];
        if (value < 0) {
            value = 0;
        }
        options.minVideoKbps = value;
        [[DemoCallManager sharedManager] saveCallOptions];
        [self.tableView reloadData];
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
