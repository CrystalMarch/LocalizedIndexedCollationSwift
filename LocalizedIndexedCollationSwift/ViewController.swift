//
//  ViewController.swift
//  LocalizedIndexedCollationSwift
//
//  Created by 朱慧平 on 16/6/13.
//  Copyright © 2016年 朱慧平. All rights reserved.
//使用苹果提供的UILocalizedIndexedCollation为tableview的表格添加索引
//初涉swift开发，请不要见笑

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var sectionTitlesArray = NSMutableArray()
    var dataSource = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setDataForTableview()
        self.addSubView()
    }
    func addSubView() {
        let myTableView = UITableView(frame: self.view.bounds)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.sectionIndexBackgroundColor = UIColor.clearColor()
        myTableView.sectionIndexColor = UIColor.lightGrayColor()
        myTableView.rowHeight = 68
        myTableView.sectionHeaderHeight = 28
        myTableView.sectionFooterHeight = 28
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
    }
    func setDataForTableview(){
        let testArr = ["786","朱慧平","孙悟空","白骨精","孙红雷","唐三藏","杨阳洋","TF—Boys","猪猪","哈利路亚","杨幂","黄轩","皇上","太上皇"]
        let personArr = NSMutableArray()
        for str :NSString in testArr {
            let p = Person.init(name: str as String)
            personArr.addObject(p)
        }
        let collation = UILocalizedIndexedCollation.currentCollation()
//        1.获取section的标题
        let titles:NSArray = collation.sectionTitles
//        2.构建每个section数组
        let sectionArray = NSMutableArray()
        for _ in 1...titles.count{
            let subArr = NSMutableArray()
            sectionArray.addObject(subArr)
            
        }
//       3.排序
//          3.1按照将需要排序的对象放入到对应分区数组
        for p in personArr {
            let section:NSInteger = collation
            .sectionForObject(p, collationStringSelector: Selector("name"))
            let subArr:NSMutableArray = sectionArray[section] as! NSMutableArray
            subArr.addObject(p)
            
        }
//          3.2分别对分区进行排序
        for subArr in sectionArray {
            let sortArr:NSArray = collation.sortedArrayFromArray(subArr as! [AnyObject], collationStringSelector: Selector("name"))
            subArr.removeAllObjects()
            subArr.addObjectsFromArray(sortArr as [AnyObject])
        }
//        4.删除分区为空的内容
        let temp = NSMutableArray()
        sectionArray.enumerateObjectsUsingBlock { (arr:AnyObject, idx :Int, stop : UnsafeMutablePointer<ObjCBool>) in
            let array:NSArray = arr as! NSArray
            if Bool(array.count) {
                let titleArr:NSArray = collation.sectionTitles
                self.sectionTitlesArray.addObject(titleArr.objectAtIndex(idx))
            }else{
                temp.addObject(arr)
            }
        }
        sectionArray.removeObjectsInArray(temp as [AnyObject])
        self.dataSource = sectionArray.copy() as! NSArray
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:-SectionTitles
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitlesArray.objectAtIndex(section) as? String
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionTitlesArray.copy() as? [String]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectAtIndex(section).count
    }
//MARK:－cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    func configureCell(cell :UITableViewCell , indexPath :NSIndexPath){
        cell.textLabel?.text = self.dataSource.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row).name
    }
}

