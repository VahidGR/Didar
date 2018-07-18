//
//  SlideView.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 7/31/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit
import Auk
import Alamofire
import SwiftyJSON
import SystemConfiguration

struct Global {
    static var productID = Int()
    static var catID = Int()
    static var productCatID = Int()
    static var LinkO = String()
    static var LinkTwo = String()
    static var LinkeThree = String()
    static var CatArray = [[String:Any]]()
    static var productsGlobalArray = [[String:Any]]()
    static var productsImageArrayGlobal = [String]()
    static var CatOrTopTag = Int()
    static var topProductsArray = [[String:Any]]()
    static let sh2 = "2A252798728A8277F4366836BB695"
    static var catTitle = String()
    static var tempColor = UIColor()
    static var temp2ndColor = UIColor()
}

class SlideView: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var allCollectionsView: UICollectionView!
    var topProducsView: UICollectionView!
    var scrollView: UIScrollView!
    let relativeFontConstant:CGFloat = 0.025
    let relativeFontConstantForCells:CGFloat = 0.02
    
    var CataArrayResult = [[String:Any]]()
    var productArrayResult = [[String:Any]]()
    var topProductArrayResult = [[String:Any]]()

    let getAllDataURL = "https://www.jahanco.net/api/DigitalCatalog/v1/getAllData"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func collectionAll() {
        Global.CatOrTopTag = 0
        self.performSegue(withIdentifier: "catagory", sender: self)
    }
    
    @objc func goToProduct() {
        Global.CatOrTopTag = 1
        self.performSegue(withIdentifier: "showCat", sender: self)
    }

    @objc func contactUsPressed() {
        let actionSheet = UIAlertController(title: "Contact Us", message: "Ways to get to us", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Linkedin", style: .default, handler: { (action:UIAlertAction) in
            print("Linkedin Pressed")
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Telegram", style: .default, handler: { (action:UIAlertAction) in
            print("Telegram Pressed")
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        let linkZero = Global.LinkO
        let linkOne = Global.LinkTwo
        let linkTwo = Global.LinkeThree

        print(scrollView.auk.currentPageIndex!)
        if scrollView.auk.currentPageIndex! == 0 {
            let url = URL(string: linkZero)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else if scrollView.auk.currentPageIndex! == 1 {
            let url = URL(string: linkOne)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            let url = URL(string: linkTwo)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var label = UILabel()
    
    func StartIndicator() {
        navigationController?.navigationBar.barTintColor = UIColor.clear
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        label = UILabel(frame: CGRect(x: (view.frame.size.width / 2) - 60, y: (view.frame.size.height / 2) + 30, width: 120, height: 40))
        label.text = "در حال بارگیری"
        label.textAlignment = .center
        label.textColor = UIColor.blue
        view.addSubview(label)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func EndIndicator() {
        activityIndicator.stopAnimating()
        label.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
        
        let sh1 = UserDefaults.standard.string(forKey: "sh1")
        if sh1 == nil {
            let appDomain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        }
    }
    
    @objc func retry() {
        for view in view.subviews{
            view.removeFromSuperview()
        }
        showView()
    }
    
    func showView() {
        if ConnectionCheck.isConnectedToNetwork() {
            StartIndicator()
            loadEverything()
        } else {
            noConnection()
        }
    }
    
    func loadEverything() {
        AFManager.request(getAllDataURL, method: .post, parameters: ["sh2": Global.sh2], encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                if let jsonDict = response.result.value as? [String:Any], let cataArray = jsonDict["categories"] as? [[String:Any]], let slidersArray = jsonDict["slides"] as? [[String:Any]], let productsArray = jsonDict["products"] as? [[String:Any]], let settingsArray = jsonDict["settings"] as? [String:Any]  {
                    let slidersIDArray = slidersArray.flatMap { $0["id"] as? Int }
                    let slidersLinkArray = slidersArray.flatMap { $0["link"] as? String }
                    let productsImageArray = productsArray.flatMap { $0["image"] as? String }
                    
                    self.CataArrayResult = cataArray
                    self.productArrayResult = productsArray

                    var templateColorString = settingsArray["primary_color"] as! String
                    var templateColorSecondaryString = settingsArray["second_color"] as! String
                    
                    templateColorString.remove(at: templateColorString.startIndex)
                    templateColorSecondaryString.remove(at: templateColorSecondaryString.startIndex)
                    
                    let templateColor = UIColor(hex: templateColorString)
                    let templateSecondaryColor = UIColor(hex: templateColorSecondaryString)
                    
                    Global.tempColor = templateColor
                    Global.temp2ndColor = templateSecondaryColor

                    Global.CatArray = cataArray
                    Global.productsGlobalArray = productsArray
                    Global.productsImageArrayGlobal = productsImageArray
                    Global.LinkO = slidersLinkArray[0]
                    Global.LinkTwo = slidersLinkArray[1]
                    Global.LinkeThree = slidersLinkArray[2]
                    Global.topProductsArray = self.topProductArrayResult
                    
                    var i = 0
                    for var product in productsArray {
                        if product["top"] as? String == "yes" {
                            self.topProductArrayResult.append(product)
                            i += 1
                        }
                    }
                    
                    // MARK - LOAD VIEW ELEMENTS
                    self.navigationController?.navigationBar.barTintColor = templateColor
                    
                    let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: templateSecondaryColor]
                    self.navigationController?.navigationBar.titleTextAttributes = titleDict as! [NSAttributedStringKey : Any]
                    self.navigationController?.navigationBar.tintColor = templateSecondaryColor

                    self.setNeedsStatusBarAppearanceUpdate()
                    self.addSlideMenuButton()
                    let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: self.view.frame.size.height))
                    contentScrollView.contentSize.height = 667
                    self.view.addSubview(contentScrollView)
                    
                    let viewWidth = contentScrollView.frame.size.width
                    let scrollViewHeight = (viewWidth * 9) / 16
                    
                    self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: scrollViewHeight))
                    
                    for index in 0...2 {
                        self.scrollView.auk.show(url: "https://jahanco.net/api/DigitalCatalog/v1/getSlideImage?id=" + "\(slidersIDArray[index])")
                    }
                    
                    self.scrollView.auk.startAutoScroll(delaySeconds: 3)
                    
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    self.scrollView.addGestureRecognizer(tap)
                    self.scrollView.isUserInteractionEnabled = true
                    contentScrollView.addSubview(self.scrollView)
                    
                    let catagoryButton = UIButton(frame: CGRect(x: viewWidth / 2, y: scrollViewHeight + 8, width: (viewWidth / 2) - 8, height: 30))
                    catagoryButton.addTarget(self, action: #selector(self.collectionAll), for: .touchUpInside)
                    let catagoryButtonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    catagoryButtonLabel.backgroundColor = UIColor.clear
                    catagoryButton.addSubview(catagoryButtonLabel)
                    contentScrollView.addSubview(catagoryButton)
                    
                    let catagoryLabelRect = CGRect(x: 0, y: 0, width: (viewWidth / 2) - 8, height: 30)
                    let catagoryLabel = UILabel(frame: catagoryLabelRect)
                    catagoryLabel.backgroundColor = UIColor.clear
                    catagoryLabel.text = "دسته بندی محصولات"
                    catagoryLabel.textAlignment = .right
                    catagoryLabel.textColor = UIColor.darkGray
                    catagoryLabel.font = catagoryLabel.font.withSize(self.view.frame.height * self.relativeFontConstant)
                    catagoryButton.addSubview(catagoryLabel)
                    
                    let allButtonRect = CGRect(x: 8, y: scrollViewHeight + 8, width: viewWidth / 4, height: 30)
                    let allButton = UIButton(frame: allButtonRect)
                    allButton.backgroundColor = UIColor.clear
                    allButton.addTarget(self, action: #selector(self.collectionAll), for: .touchUpInside)
                    contentScrollView.addSubview(allButton)
                    
                    let allButtonLabelRect = CGRect(x: 0, y: 0, width: viewWidth / 4, height: 30)
                    let allButtonLabel = UILabel(frame: allButtonLabelRect)
                    allButtonLabel.backgroundColor = UIColor.clear
                    allButtonLabel.text = "همه >"
                    allButtonLabel.textAlignment = .left
                    allButtonLabel.textColor = UIColor.darkGray
                    allButtonLabel.font = allButtonLabel.font.withSize(self.view.frame.height * self.relativeFontConstant)
                    allButton.addSubview(allButtonLabel)
                    
                    
                    let topProductsButtonRect = CGRect(x: viewWidth / 2, y: scrollViewHeight + 174, width: (viewWidth / 2) - 8, height: 30)
                    let topProductsButton = UIButton(frame: topProductsButtonRect)
                    topProductsButton.addTarget(self, action: #selector(self.goToProduct), for: .touchUpInside)
                    topProductsButton.backgroundColor = UIColor.clear
                    contentScrollView.addSubview(topProductsButton)
                    
                    let topProductsLabelRect = CGRect(x: 0, y: 0, width: (viewWidth / 2) - 8, height: 30)
                    let topProductsLabel = UILabel(frame: topProductsLabelRect)
                    topProductsLabel.backgroundColor = UIColor.clear
                    topProductsLabel.text = "محصولات ویژه"
                    topProductsLabel.textAlignment = .right
                    topProductsLabel.textColor = UIColor.darkGray
                    topProductsLabel.font = topProductsLabel.font.withSize(self.view.frame.height * self.relativeFontConstant)
                    topProductsButton.addSubview(topProductsLabel)
                                        
                    let contactUs = UIButton(frame: CGRect(x: 0, y: self.view.frame.size.height - 40, width: viewWidth, height: 40))
                    contactUs.backgroundColor = templateColor
                    contactUs.addTarget(self, action: #selector(self.contactUsPressed), for: .touchUpInside)
                    self.view.addSubview(contactUs)
                    
                    let contactUsLabelRect = CGRect(x: (contactUs.frame.size.width / 2) - 50, y: 10, width: 100, height: 20)
                    let contactUsLabel = UILabel(frame: contactUsLabelRect)
                    contactUsLabel.backgroundColor = UIColor.clear
                    contactUsLabel.text = "ارتباط با ما"
                    contactUsLabel.textAlignment = .center
                    contactUsLabel.textColor = templateSecondaryColor
                    contactUs.addSubview(contactUsLabel)
                    
                    let corpIconRect = CGRect(x: (contactUs.frame.size.width / 2) + 50, y: 5, width: 30, height: 30)
                    let corpIcon = UIImageView(frame: corpIconRect)
                    corpIcon.image = UIImage(named: "logologin")
                    contactUs.addSubview(corpIcon)
                    
                    let flowLayout = UICollectionViewFlowLayout()
                    flowLayout.scrollDirection = .horizontal
                    
                    self.allCollectionsView = UICollectionView(frame: CGRect(x: 8, y: scrollViewHeight + 46, width: viewWidth - 8, height: 120), collectionViewLayout: flowLayout)
                    self.allCollectionsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
                    self.allCollectionsView.delegate = self
                    self.allCollectionsView.dataSource = self
                    self.allCollectionsView.backgroundColor = UIColor.clear
                    
                    let flowLayoutT = UICollectionViewFlowLayout()
                    flowLayoutT.scrollDirection = .horizontal
                    
                    self.topProducsView = UICollectionView(frame: CGRect(x: 8, y: scrollViewHeight + 212, width: viewWidth - 8, height: 120), collectionViewLayout: flowLayoutT)
                    self.topProducsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "topProducsCell")
                    self.topProducsView.delegate = self
                    self.topProducsView.dataSource = self
                    self.topProducsView.backgroundColor = UIColor.clear
                    
                    contentScrollView.addSubview(self.allCollectionsView)
                    contentScrollView.addSubview(self.topProducsView)
                    // LOAD VIEW ENDS
                    
                    
                    self.allCollectionsView.reloadData()
                    self.topProducsView.reloadData()
                    self.EndIndicator()
                } else {
                    self.EndIndicator()
                    let alert = UIAlertController(title: "Error", message:"No such data!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                }
                
                break
            case .failure(let error):
                self.EndIndicator()
                print(error)
                if error._code == NSURLErrorTimedOut {
                    let alert = UIAlertController(title: "Error", message:"Connection timed out", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                    self.noConnection()
                } else {
                    let alert = UIAlertController(title: "Error", message:"Connection error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                    self.noConnection()
                }
            }
        }
        
        let sh1 = UserDefaults.standard.string(forKey: "sh1")
        
        if sh1 != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(addTapped))
        }
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "slidersView", sender: self)
    }
    
    func noConnection() {
        
        navigationController?.navigationBar.barTintColor = UIColor.clear
        
        let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: self.view.frame.size.height))
        contentScrollView.contentSize.height = 667
        self.view.addSubview(contentScrollView)
        
        let noConnection = UIImageView(frame: CGRect(x: view.frame.size.width / 8, y: 100, width: (view.frame.size.width * 3) / 4, height: (view.frame.size.width * 3) / 4))
        noConnection.image = UIImage(named: "lost")
        contentScrollView.addSubview(noConnection)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 20, y: ((view.frame.size.width * 3) / 4) + 150, width: view.frame.size.width - 40, height: 60))
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor.darkGray
        let firstLine = "اتصالی به اینترنت وجود ندارد."
        let secondLine = "برای برقراری ارتباط با سرورهای ما لطفا به اینترنت متصل شوید."
        descriptionLabel.text = firstLine + " " + secondLine
        descriptionLabel.numberOfLines = 0
        contentScrollView.addSubview(descriptionLabel)
        
        let WiFiSettingsButton = UIButton(frame: CGRect(x: (view.frame.size.width / 2) - 50, y: ((view.frame.size.width * 3) / 4) + 240, width: 100, height: 30))
        let WiFiSettingsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        WiFiSettingsLabel.text = "اتصال به WiFi"
        WiFiSettingsLabel.textColor = UIColor.blue
        WiFiSettingsLabel.textAlignment = .center
        WiFiSettingsButton.addSubview(WiFiSettingsLabel)
        WiFiSettingsButton.addTarget(self, action: #selector(WiFiSettings), for: .touchUpInside)
        contentScrollView.addSubview(WiFiSettingsButton)
        
        let dismiss = UIButton(frame: CGRect(x: (view.frame.size.width / 2) - 50, y: ((view.frame.size.width * 3) / 4) + 290, width: 100, height: 30))
        let dismissLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        dismissLabel.text = "تلاش دوباره"
        dismissLabel.textColor = UIColor.blue
        dismissLabel.textAlignment = .center
        dismiss.addSubview(dismissLabel)
        dismiss.addTarget(self, action: #selector(retry), for: .touchUpInside)
        contentScrollView.addSubview(dismiss)
    }
    
    @objc func WiFiSettings() {
        let url=URL(string: "App-Prefs:root=Privacy&path=Location")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {sucess in
                
            })
        } else {
            UIApplication.shared.open(url!, options: [:], completionHandler: {sucess in
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.allCollectionsView {
            return CataArrayResult.count
        } else {
            return topProductArrayResult.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.allCollectionsView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath)
            let dict = CataArrayResult[indexPath.row]

            cell.backgroundColor = UIColor.clear
            let cellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 100))
            let catID = dict["id"] as! Int
            let url = "https://jahanco.net/api/DigitalCatalog/v1/getCatImage?" + "id=\(catID)"
            self.downloadImage(url, inView: cellImage)
            cellImage.contentMode = .scaleAspectFit
            
            let cellLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 120, height: 20))
            cellLabel.text = dict["title"] as? String
            cellLabel.textAlignment = .center
            cellLabel.textColor = UIColor.darkGray
            cellLabel.font = cellLabel.font.withSize(self.view.frame.height * relativeFontConstantForCells)
            
            cell.addSubview(cellImage)
            cell.addSubview(cellLabel)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topProducsCell", for: indexPath as IndexPath)
            let dict = topProductArrayResult[indexPath.row]

            cell.backgroundColor = UIColor.clear
            let cellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 100))
            let productID = dict["id"] as! Int
            let url = "https://jahanco.net/api/DigitalCatalog/v1/getImage?id=\(productID)&name=primary"
            // + imagesForCells!
            self.downloadImage(url, inView: cellImage)
            cellImage.contentMode = .scaleAspectFit
            
            let cellLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 120, height: 20))
            cellLabel.text = dict["title"] as? String
            cellLabel.textAlignment = .center
            cellLabel.textColor = UIColor.darkGray
            cellLabel.font = cellLabel.font.withSize(self.view.frame.height * relativeFontConstantForCells)
            
            cell.addSubview(cellImage)
            cell.addSubview(cellLabel)
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.allCollectionsView {
            let catsIDArray = CataArrayResult.flatMap { $0["id"] as? Int }
            let catsTitleArray = CataArrayResult.flatMap { $0["title"] as? String }
            let catsID = catsIDArray[indexPath.row]
            let catsTitle = catsTitleArray[indexPath.row]
            Global.catID = catsID
            Global.catTitle = catsTitle
            self.performSegue(withIdentifier: "showCat", sender: self)
        } else {
            let productsIDArray = topProductArrayResult.flatMap { $0["id"] as? Int }
            let productsID = productsIDArray[indexPath.row]
            Global.productID = productsID
            self.performSegue(withIdentifier: "product", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func downloadImage(_ uri : String, inView: UIImageView) {
        
        let url = URL(string: uri)
        
        let task = URLSession.shared.dataTask(with: url!) {responseData,response,error in
            if error == nil {
                if let data = responseData {
                    
                    DispatchQueue.main.async {
                        inView.image = UIImage(data: data)
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Error", message:"No data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                }
            } else {
                let alert = UIAlertController(title: "Error", message:"\(error!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                self.present(alert, animated: true){}
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
