//
//  UserInfoView.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 8/12/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit

class UserInfoView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let yearsPickerArray = ["سال", "1385", "1386", "1387", "1388", "1389", "1390", "1391", "1392", "1393", "1394", "1395", "1396"]
    let monthsPickerArray = ["ماه", "فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"]
    let daysPirckerArray = ["روز", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22" ,"23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var selectedYear: String = ""
    var selectedMonth: String = ""
    var selectedDay: String = ""
    
    var userGender: String = "Female"

    @IBOutlet weak var year: UIPickerView!
    @IBOutlet weak var month: UIPickerView!
    @IBOutlet weak var day: UIPickerView!
    
    @IBOutlet weak var genderChanged: UISegmentedControl!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == year {
            return yearsPickerArray.count
        } else if pickerView == month {
            return monthsPickerArray.count
        } else {
            return daysPirckerArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == year {
            selectedYear = yearsPickerArray[row]
            print(selectedYear)
        } else if pickerView == month {
            selectedMonth = monthsPickerArray[row]
            print(selectedMonth)
        } else {
            selectedDay = daysPirckerArray[row]
            print(selectedDay)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        year.dataSource = self
        year.delegate = self
        
        month.dataSource = self
        month.delegate = self

        day.dataSource = self
        day.delegate = self
        
        print(userGender)
        genderChanged.addTarget(self, action: #selector(genderChangedPressed(segControl:)), for: .valueChanged)
    }
    
    @objc func genderChangedPressed(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex{
        case 0:
            userGender = "Female"
            print(userGender)
        case 1:
            userGender = "Male"
            print(userGender)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == year {
            let yearView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
            let yearLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 70, height: 30))
            yearLabel.text = yearsPickerArray[row]
            
            yearView.addSubview(yearLabel)

            return yearView
        } else if pickerView == month {
            let monthView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
            let monthLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 70, height: 30))
            monthLabel.text = monthsPickerArray[row]
            
            monthView.addSubview(monthLabel)

            return monthView
        } else {
            let dayView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
            let dayLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 70, height: 30))
            dayLabel.text = daysPirckerArray[row]
            
            dayView.addSubview(dayLabel)

            return dayView
        }
    }
}
