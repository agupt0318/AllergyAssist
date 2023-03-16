//
//  myAllergens.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 2/12/23.
//

import UIKit
class myAllergens: UIViewController {
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
    let pageTitle = UILabel()
    let warning = UILabel()
    let segmentItems = ["Avoid", "Limit this", "Can eat"]
    var myAvoid:[String] = []
//    var myAvoid = ["Shellfish","Egg","Peanut","Tree Nut","Dairy","Fish","Sesame","Soybean","Wheat","Additive","Seed","Meat","Fruit"]
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
        pageTitle.text = "My Allergens"
        warning.font = UIFont.boldSystemFont(ofSize: 25)
        warning.backgroundColor = UIColor.yellow
        warning.textColor = UIColor.red
        warning.textAlignment = .center
        warning.text = "Leave it if you are not sure!!!"
        
        // create a vertical stack view to hold the rows of buttons
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        // we're going to use auto-layout
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        warning.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // add label to view
        view.addSubview(pageTitle)
        view.addSubview(warning)
        
        // add Scrollview to view
        self.view.addSubview(scrollView)
        
        // add stack view to scrollView
        scrollView.addSubview(verticalStackView)
        
        for _ in 0..<allergens.count{
            sgControl.append(UISegmentedControl(items: segmentItems))
        }
        
        let dt = UserDefaults.standard.dictionary(forKey: "UserDB")
        if let arr = dt?[user.name] as? [[String]]{
            myAvoid = arr[1]
            myLimit = arr[2]
        }else{
        }
        
        for i in 0..<allergens.count{
            // add row
            let row = UIStackView()
            // add it to the vertical stack view
            verticalStackView.addArrangedSubview(row)
            verticalStackView.setCustomSpacing(15, after: row)
            let lb = UILabel()
            lb.font = UIFont.boldSystemFont(ofSize: 20)
            lb.textAlignment = .left
            lb.text = allergens[i][0]
            row.addArrangedSubview(lb)
            row.setCustomSpacing(5, after: lb)
            NSLayoutConstraint.activate([
                lb.widthAnchor.constraint(equalToConstant: 90.0),
                lb.heightAnchor.constraint(equalToConstant: 30.0),
            ])
            
            let bt0 = UIButton()
            if allergens[i][1]=="+"{
                bt0.setTitle(allergens[i][1], for: .normal)
                bt0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                //                bt0.frame = CGRectMake(0, 0, 20, 20)
                //                bt0.clipsToBounds = true
                bt0.layer.cornerRadius = 15
                bt0.backgroundColor = .systemGreen
                switch (allergens[i][0]) {
                case "Shellfish":
                    bt0.addTarget(self, action: #selector(Shellfish), for: .touchUpInside)
                    break
                case "Tree Nut":
                    bt0.addTarget(self, action: #selector(TreeNut), for: .touchUpInside)
                    break
                case "Additive":
                    bt0.addTarget(self, action: #selector(Additive), for: .touchUpInside)
                    break
                case "Seed":
                    bt0.addTarget(self, action: #selector(Seed), for: .touchUpInside)
                    break
                case "Meat":
                    bt0.addTarget(self, action: #selector(Meat), for: .touchUpInside)
                    break
                case "Fruit":
                    bt0.addTarget(self, action: #selector(Fruit), for: .touchUpInside)
                    break
                default:
                    break
                }
            }
            row.addArrangedSubview(bt0)
            row.setCustomSpacing(5, after: bt0)
            NSLayoutConstraint.activate([
                bt0.widthAnchor.constraint(equalToConstant: 30.0),
                bt0.heightAnchor.constraint(equalToConstant: 30.0),
            ])

            sgControl[i].addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
            if myAvoid.contains(allergens[i][0]){
                sgControl[i].selectedSegmentIndex = 0
            } else if myLimit.contains(allergens[i][0]){
                sgControl[i].selectedSegmentIndex = 1
            } else {
                sgControl[i].selectedSegmentIndex = 2
            }
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
            //  50-pts from top
            //  80% of the width
            pageTitle.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 0.0),
            pageTitle.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.75),
            pageTitle.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: 10.0),
            // constrain label
            //  50-pts from top
            //  80% of the width
            //  centered horizontally
            warning.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15.0),
            warning.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.95),
            warning.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            // constrain scrollView
            //  10-pts from bottom of label
            //  Leading and Trailing to safe-area with 10-pts "padding"
            //  Bottom to safe-area with 50-pts "padding"
            scrollView.topAnchor.constraint(equalTo: warning.bottomAnchor, constant: 20.0),
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
//        edit_pf()
        save_pf()
        navi()
    }
    
    //method declaration
//    private func edit_pf(){
//        edit_pf_bt.frame = CGRect(x: 250, y: 60, width: 50, height: 30)
//        edit_pf_bt.layer.cornerRadius = 10
//        edit_pf_bt.layer.masksToBounds = true
//        edit_pf_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
//        view.addSubview(edit_pf_bt)
//    }
    
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
        let vc = UserAccountInfo()
        save_info()
//        for i in 0..<allergens.count{
//            if sgControl[i].selectedSegmentIndex == 0{
//                myAvoid.insert(allergens[i][0])
//            } else if sgControl[i].selectedSegmentIndex == 1{
//                myLimit.insert(allergens[i][0])
//            }
//        }
//        if var dt = UserDefaults.standard.dictionary(forKey: "UserDB"){
//            dt[user.name]=[[user.email, user.password], myAvoid, myLimit]
//            UserDefaults.standard.setValue(dt, forKey: "UserDB")
//        } else {
//            let dt = [user.name:[[user.email, user.password],myAvoid, myLimit]]
//            UserDefaults.standard.setValue(dt, forKey: "UserDB")
//        }
//        print(user.name,user.email,myAvoid,myLimit)
        vc.user = self.user
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func save_info(){
        var set1 = Set(myAvoid)
        var set2 = Set(myLimit)
        for i in 0..<allergens.count{
            if sgControl[i].selectedSegmentIndex == 0{
                set1.insert(allergens[i][0])
                set2.remove(allergens[i][0])
//                if myAvoid.contains(allergens[i][0]) == false{
//                    myAvoid.append(allergens[i][0])
//                    myLimit = myLimit.filter {$0 != allergens[i][0]}
//                }
            } else if sgControl[i].selectedSegmentIndex == 1{
                set2.insert(allergens[i][0])
                set1.remove(allergens[i][0])
//                if myLimit.contains(allergens[i][0]) == false{
//                    myLimit.append(allergens[i][0])
//                    myAvoid = myAvoid.filter {$0 != allergens[i][0]}
//                }
            } else{
                set1.remove(allergens[i][0])
                set2.remove(allergens[i][0])
            }
        }
        if var dt = UserDefaults.standard.dictionary(forKey: "UserDB"){
            dt[user.name]=[[user.email], Array(set1), Array(set2)]
            UserDefaults.standard.setValue(dt, forKey: "UserDB")
        } else {
            let dt = [user.name:[[user.email],Array(set1), Array(set2)]]
            UserDefaults.standard.setValue(dt, forKey: "UserDB")
        }
    }
//
//    let edit_pf_bt : UIButton = {
//        let bt = UIButton()
//        bt.setTitle("Edit", for: .normal)
//        bt.backgroundColor = UIColor.systemBlue
//        return bt
//    }()
    
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
    
    @objc func Shellfish(sender: UIButton!) {
        save_info()
        let vc = ShellFishVC()
        vc.user = self.user
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func TreeNut(sender: UIButton!) {
        let vc = TreenutVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func Additive(sender: UIButton!) {
        warning.text = sender.title(for: .normal)
    }
    
    @objc func Seed(sender: UIButton!) {
        warning.text = sender.title(for: .normal)
    }
    
    @objc func Meat(sender: UIButton!) {
        warning.text = sender.title(for: .normal)
    }
    
    @objc func Fruit(sender: UIButton!) {
        warning.text = sender.title(for: .normal)
    }
    
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
