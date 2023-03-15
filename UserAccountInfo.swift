//
//  UserAccountInfo.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 2/12/23.
//

import UIKit

class UserAccountInfo : UIViewController{
    lazy var dict = UserDefaults.standard.dictionary(forKey: "UserDB")
    var arr:[String] = []

    var user = User(email: "", name: "", password: "")
    
    let scrollView = UIScrollView()

    func setup(){
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }
        // create a vertical stack view to hold the rows of buttons
        if dict?.count != nil{
            let verticalStackView = UIStackView()
            verticalStackView.axis = .vertical
            
            // we're going to use auto-layout
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            verticalStackView.translatesAutoresizingMaskIntoConstraints = false
            
            // add Scrollview to view
            self.view.addSubview(scrollView)
            
            // add stack view to scrollView
            scrollView.addSubview(verticalStackView)
        
        
            let arr1:[String] = Array(dict!.keys)
            arr = arr1
            for (index, element) in arr.enumerated(){
                // add row
                let row = UIStackView()
                // add it to the vertical stack view
                verticalStackView.addArrangedSubview(row)
                verticalStackView.setCustomSpacing(15, after: row)
                let lb = UILabel()
                lb.font = UIFont.boldSystemFont(ofSize: 20)
//                lb.backgroundColor = UIColor.systemGray
//                lb.textColor = UIColor.black
                lb.textAlignment = .left
                lb.text = element
                row.addArrangedSubview(lb)
                row.setCustomSpacing(5, after: lb)
                NSLayoutConstraint.activate([
                    lb.widthAnchor.constraint(equalToConstant: 150.0),
                    lb.heightAnchor.constraint(equalToConstant: 30.0),
                ])
                
                let bt1 = UIButton()
                bt1.setTitle("Edit", for: .normal)
                bt1.layer.cornerRadius = 15
                bt1.backgroundColor = .systemGreen
                bt1.tag = index
                bt1.addTarget(self, action: #selector(handle_C), for: .touchUpInside)
                row.addArrangedSubview(bt1)
                row.setCustomSpacing(5, after: bt1)
                NSLayoutConstraint.activate([
                    bt1.widthAnchor.constraint(equalToConstant: 80.0),
                    bt1.heightAnchor.constraint(equalToConstant: 30.0),
                ])
                
                let bt2 = UIButton()
                bt2.setTitle("X", for: .normal)
                bt2.layer.cornerRadius = 15
                bt2.backgroundColor = .systemRed
                bt2.tag = index
                bt2.addTarget(self, action: #selector(del_user), for: .touchUpInside)
                row.addArrangedSubview(bt2)
                row.setCustomSpacing(5, after: bt2)
                NSLayoutConstraint.activate([
                    bt2.widthAnchor.constraint(equalToConstant: 30.0),
                    bt2.heightAnchor.constraint(equalToConstant: 30.0),
                ])
            }
            
            // finally, let's set our constraints
            // respect safe-area
            let safeG = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                // constrain scrollView
                //  10-pts from bottom of label
                //  Leading and Trailing to safe-area with 10-pts "padding"
                //  Bottom to safe-area with 50-pts "padding"
                scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 50.0),
                scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 5.0),
                scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -5.0),
                scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -75.0),
                
                // constrain vertical stack view to scrollView Content Layout Guide
                //  8-pts all around (so we have a little "padding")
                verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5.0),
                verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 5.0),
                verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -5.0),
                verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -5.0),
            ])
        } else {
            return
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        view.frame = CGRect(x : 0, y: 0, width: 400, height: 600)
        setup()
        view.addSubview(AddUser)
        view.addSubview(UserAccount)
        AddUser.translatesAutoresizingMaskIntoConstraints = false
        UserAccount.translatesAutoresizingMaskIntoConstraints = false
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            UserAccount.topAnchor.constraint(equalTo: safeG.topAnchor,constant:5.0),
            UserAccount.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.75),
            UserAccount.heightAnchor.constraint(equalToConstant: 30.0),
            AddUser.topAnchor.constraint(equalTo: safeG.topAnchor,constant:5.0),
            AddUser.leftAnchor.constraint(equalTo: UserAccount.rightAnchor,constant: 10.0),
            AddUser.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.2),
            AddUser.heightAnchor.constraint(equalToConstant: 30.0),
        ])
//        start2()
        navi()
    }
    lazy var AddUser : UIButton = {
        let AU = UIButton()
        AU.setTitle("Add User", for: .normal)
        AU.backgroundColor = UIColor.systemGreen
        AU.layer.cornerRadius = 10
        AU.tag = 999
        AU.addTarget(self, action: #selector(handle_C), for : .touchUpInside)
        return AU
    }()
    
    private func start2(){
        AddUser.frame = CGRect(x : 300, y: 60, width: 80, height: 30 )
        view.addSubview(AddUser)
        UserAccount.frame = CGRect(x : 0, y: 60, width: 300, height: 30 )
        view.addSubview(UserAccount)
    }
    
    private let UserAccount: UILabel = {
         let userAccount = UILabel()
//         userAccount.numberOfLines = 0
         userAccount.textAlignment = .center
//         userAccount.textColor = UIColor.black
         userAccount.font = UIFont.boldSystemFont(ofSize: 25)
         userAccount.text = "User Accounts"
//         userAccount.backgroundColor = UIColor.systemYellow
         return userAccount
     }()

    @objc func handle_C(sender:UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let index = sender.tag
        if(index == 999){
            let vc = RegistrationVC()
            vc.user = self.user
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated : true)
        }else{
            let vc = RegistrationVC()
            user.name = arr[index]
            vc.user = self.user
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated : true)
        }
    }
    
    @objc func del_user(sender:UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let key = arr[sender.tag]
        dict?.removeValue(forKey: key)
        UserDefaults.standard.setValue(dict, forKey: "UserDB")
        let vc = UserAccountInfo()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
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
        let vc = ScanBarcode()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
}
