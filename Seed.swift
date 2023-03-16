//
//  Seed.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 2/19/23.
//

import UIKit

class Seed: UIViewController {
    var user = User(email: "sample@gmail.com", name: "Joe")
    lazy var dict = UserDefaults.standard.dictionary(forKey: "UserDB")
    let allergens : [[String]] = [["Shellfish","+"],
                                  ["Egg",""],
                                  ["Peanut",""],
                                  ["Tree Nut","+"],
                                  ["Dairy",""],
                                  ["Fish",""],
                                  ["Sesame",""],
                                  ["Soybean",""],
                                  ["Wheat",""],
                                  ["Additive","+"],
                                  ["Seed","+"],
                                  ["Meat","+"],
                                  ["Fruit","+"]]
    let allergy_ls : [String] = ["Sesame seed","Sunflower seed","Cocoa","Quinoa"]
    let pageTitle = UILabel()
    let warning = UILabel()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lobsters")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let desc = UILabel()
    let segmentItems = ["Avoid", "Limit this", "Can eat"]
    var myAvoid:[String] = []
    var myLimit:[String] = []
    let scrollView = UIScrollView()
    var sgControl: [UISegmentedControl] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.systemBackground
        //setup layout
        pageTitle.font = UIFont.boldSystemFont(ofSize: 25)
        pageTitle.textAlignment = .center
        pageTitle.text = "My Allergens - Seed"
        warning.font = UIFont.boldSystemFont(ofSize: 25)
        warning.backgroundColor = UIColor.yellow
        warning.textColor = UIColor.red
        warning.textAlignment = .center
        warning.text = "Leave it if you are not sure!!!"
        desc.textAlignment = .left
        desc.text = "Allergic reactions to seeds can be severe. Sesame, sunflower and poppy seeds have been known to cause anaphylaxis. Seeds are often used in bakery and bread products, and extracts of some seeds have been found in hair care products.\n Some seed oils are highly refined, a process that removes the allergy-causing proteins from the oil. But as not all seed oils are highly refined, individuals with a seed allergy should be careful when eating foods prepared with seed oils."
        desc.numberOfLines = 10
        
        // create a vertical stack view to hold the rows of buttons
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        // we're going to use auto-layout
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        warning.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add label to view
        view.addSubview(pageTitle)
        view.addSubview(warning)
        view.addSubview(imageView)
        view.addSubview(desc)
        
        // add Scrollview to view
        self.view.addSubview(scrollView)
        
        // add stack view to scrollView
        scrollView.addSubview(verticalStackView)
        
        for _ in 0..<allergy_ls.count{
            sgControl.append(UISegmentedControl(items: segmentItems))
        }
        
        for i in 0..<allergy_ls.count{
            // add row
            let row = UIStackView()
            // add it to the vertical stack view
            verticalStackView.addArrangedSubview(row)
            verticalStackView.setCustomSpacing(15, after: row)
            let lb = UILabel()
            lb.font = UIFont.boldSystemFont(ofSize: 20)
            lb.textAlignment = .left
            lb.text = allergy_ls[i]
            row.addArrangedSubview(lb)
            row.setCustomSpacing(5, after: lb)
            NSLayoutConstraint.activate([
                lb.widthAnchor.constraint(equalToConstant: 120.0),
                lb.heightAnchor.constraint(equalToConstant: 30.0),
            ])

            sgControl[i].addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
            sgControl[i].selectedSegmentIndex = 0
            row.addArrangedSubview(sgControl[i])
            NSLayoutConstraint.activate([
                sgControl[i].widthAnchor.constraint(equalToConstant: 240.0),
                sgControl[i].heightAnchor.constraint(equalToConstant: 30.0),
            ])
        }
        
        // finally, let's set our constraints
        // respect safe-area
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // constrain label
            pageTitle.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 0.0),
            pageTitle.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.75),
            pageTitle.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: 10.0),
            // constrain label
            warning.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15.0),
            warning.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.95),
            warning.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            // constrain label
            imageView.topAnchor.constraint(equalTo: warning.bottomAnchor, constant: 15.0),
            imageView.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            // constrain label
            desc.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15.0),
            desc.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.95),
            desc.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            // constrain scrollView
            //  10-pts from bottom of label
            //  Leading and Trailing to safe-area with 10-pts "padding"
            //  Bottom to safe-area with 50-pts "padding"
            scrollView.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 10.0),
            scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 5.0),
            scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -5.0),
            scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -60.0),
            
            // constrain vertical stack view to scrollView Content Layout Guide
            //  8-pts all around (so we have a little "padding")
            verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5.0),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 5.0),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -5.0),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -5.0),
        ])
        //method call
        save_pf()
        navi()
    }
    
    //method declaration
    private func save_pf(){
        save_pf_bt.frame = CGRect(x: 330, y: 60, width: 50, height: 30)
        save_pf_bt.layer.cornerRadius = 10
        save_pf_bt.layer.masksToBounds = true
        save_pf_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
        view.addSubview(save_pf_bt)
    }
    
    private func navi(){
        user_bt.frame = CGRect(x: 30, y: 770, width: 100, height: 30)
        user_bt.layer.cornerRadius = 10
        user_bt.addTarget(self, action: #selector(User_Account), for: .touchUpInside)
        view.addSubview(user_bt)
        sb_bt.frame = CGRect(x: 140, y: 770, width: 120, height: 30)
        sb_bt.layer.cornerRadius = 10
        sb_bt.addTarget(self, action: #selector(Scan_Barcode), for: .touchUpInside)
        view.addSubview(sb_bt)
        sl_bt.frame = CGRect(x: 270, y: 770, width: 100, height: 30)
        sl_bt.layer.cornerRadius = 10
        sl_bt.addTarget(self, action: #selector(Scan_Label), for: .touchUpInside)
        view.addSubview(sl_bt)
    }
    
    @objc func h1(sender : UIButton){
        let vc = myAllergens()
        vc.user = self.user
        var dt = UserDefaults.standard.dictionary(forKey: "UserDB")
        if let arr = dt?[user.name] as? [[String]]{
            var set1 = Set(arr[1])
            var set2 = Set(arr[2])
            for i in 0..<allergy_ls.count{
                if sgControl[i].selectedSegmentIndex == 0{
                    set1.insert(allergy_ls[i])
                    set2.remove(allergy_ls[i])
                } else if sgControl[i].selectedSegmentIndex == 1{
                    set2.insert(allergy_ls[i])
                    set1.remove(allergy_ls[i])
                } else {
                    set1.remove(allergy_ls[i])
                    set2.remove(allergy_ls[i])
                }
            }
            dt?[user.name]=[[user.email], Array(set1), Array(set2)]
            print(set1,set2)
            UserDefaults.standard.setValue(dt, forKey: "UserDB")
        } else {
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    let save_pf_bt : UIButton = {
        let bt = UIButton()
        bt.setTitle("Save", for: .normal)
        bt.backgroundColor = UIColor.systemGreen
        return bt
    }()
    
//    let home_bt : UIButton = {
//        let bt = UIButton()
//        bt.setTitle("Home", for: .normal)
//        bt.backgroundColor = UIColor.systemBlue
//        return bt
//    }()
//
//    let sb_bt : UIButton = {
//        let bt = UIButton()
//        bt.setTitle("Scan Barcode", for: .normal)
//        bt.backgroundColor = UIColor.systemBlue
//        return bt
//    }()
//
//    let sl_bt : UIButton = {
//        let bt = UIButton()
//        bt.setTitle("Scan Label", for: .normal)
//        bt.backgroundColor = UIColor.systemBlue
//        return bt
//    }()
    
    let user_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        return bt
    }()
    let sb_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "barcode"), for: .normal)
        return bt
    }()
    let sl_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "camera"), for: .normal)
        return bt
    }()
    
    @objc func segmentControl(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            print("Avoid")
            break
        case 1:
            print("Limit")
            break
        case 2:
            print("Can eat")
            break
        default:
            break
        }
    }
    
    @objc func User_Account(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = UserAccountInfo()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
    @objc func Scan_Label(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanLabel()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
    @objc func Scan_Barcode(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = BarcodeScanner()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
}
