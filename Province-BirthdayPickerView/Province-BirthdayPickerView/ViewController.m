//
//  ViewController.m
//  Province-BirthdayPickerView
//
//  Created by 李云龙 on 15/8/27.
//  Copyright (c) 2015年 hihilong. All rights reserved.
//

#import "ViewController.h"
#import "Province.h"

@interface ViewController () <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
/**  省会数组：Province */
@property (nonatomic, strong) NSMutableArray *provinces;
// 记录下当前选中的省会
@property (nonatomic, assign) NSInteger selProvinceIndex;

@property (nonatomic, weak) UIDatePicker *datePicker;

@end

@implementation ViewController


- (NSMutableArray *)provinces
{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
        
        for (NSDictionary *dict in dictArr) {
            
            Province *p = [Province provinceWithDict:dict];
            
            [_provinces addObject:p];
        }
    }
    
    return _provinces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 设置文本框的代理，拦截用户的输入
    _birthdayTextField.delegate = self;
    
    _cityTextField.delegate = self;
    
    // 自定义生日键盘
    [self setUpBirthdayKeyboard];
    
    // 自定义城市键盘
    [self setUpCityKeyboard];
    
}
#pragma mark - 自定义城市键盘
- (void)setUpCityKeyboard
{
    UIPickerView *pickerV = [[UIPickerView alloc] init];
    
    pickerV.delegate = self;
    pickerV.dataSource = self;
    
    _cityTextField.inputView = pickerV;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 第0列 有多少个省
    if (component == 0) {
        return self.provinces.count;
    }else //  第1列 描述第0列选中的省，有多少个城市
    {
        // 获取第0列选中的省
        NSInteger proIndex = [pickerView selectedRowInComponent:0];
        Province *p = self.provinces[_selProvinceIndex];
        
        return p.cities.count;
        
    }
    
}
#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) { // 描述省会名称
        
        Province *p = self.provinces[row];
        
        return p.name;
    }else{ // 第1列 第0列选中的省的城市名称
        
        
        Province *p = self.provinces[_selProvinceIndex];
        //  问题：获取的选中的省会 跟界面显示的不符合
        // 不能获取最新的选中的城市，应该是获取界面上的省会城市
        
        // 天津省 只有1城市 row 11
        NSLog(@"%@--%ld--%ld",p.name,p.cities.count,row);
        
#warning BUG
        return p.cities[row];
    }
}
// 当用户选中第component列第row的行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) { // 选中新的省会
        
        // 记录下当前选中的省会
        _selProvinceIndex = row;
        
        // 刷新第1列
        [pickerView reloadComponent:1];
        
    }
    
    // 获取当前选中的省
    Province *p = self.provinces[_selProvinceIndex];
    
    // 获取当前选中的城市
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];
    NSString *city = p.cities[cityIndex];
    
    // 设置城市文本框文字
    _cityTextField.text = [NSString stringWithFormat:@"%@ %@",p.name,city];
}


#pragma mark - 自定义生日键盘
- (void)setUpBirthdayKeyboard
{
    // c创建UIDatePicker
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    // 设置datePicker的日期模式
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    // 设置本地区域
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    _datePicker = datePicker;
    
    // inputView:用来自定义文本框的键盘
    _birthdayTextField.inputView = datePicker;
}


// 就是给生日文本框赋值
- (void)dateChange:(UIDatePicker *)picker
{
    NSLog(@"%@",picker.date);
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    
    // 给生日文本框赋值
    _birthdayTextField.text = [dateFmt stringFromDate:picker.date];
}

// 文本框开始编辑的时候调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _birthdayTextField) { // 生日键盘
        [self dateChange:_datePicker];
    }
}


// 是否允许用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}



@end
