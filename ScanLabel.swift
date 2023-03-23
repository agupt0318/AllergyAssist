//
//  ScanLabel.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 3/5/23.
//
import Vision
import UIKit
import NaturalLanguage

class ScanLabel : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    lazy var dict = UserDefaults.standard.dictionary(forKey: "UserDB")
    var dataArray:[String] = []
    var user = User(email: "", name: "", password: "", race: Race.Asian)
    var myAvoid:[String] = []
    var myLimit:[String] = []
    let scrollView = UIScrollView()
    let myPickerView = UIPickerView()
    let wordCollection = ["Shellfish": ["shellfish","shellfishes"],
                          "Egg":["egg","eggs"],
                          "Peanut":["peanut","peanuts"],
                          "Tree Nut":["treenut","treenuts","tree nut","tree nuts"],
                          "Dairy":["dairy","dairies","milk","milks","yogurt","yogurts", "cheese","cheeses"],
                          "Fish":["fish","fishes"],
                          "Sesame":["sesame","sesames"],
                          "Soybean":["soybean","soybeans"],
                          "Wheat":["wheat","wheats"],
                          "Additive":["additive","additives"],
                          "Seed":["seed","seeds"],
                          "Meat":["meat","meats"],
                          "Fruit":["fruit","fruits"],
                          "Crustaceans":["crustacean","crustaceans"],"Mollusks":["mollusk","mollusks"],
                          "Almond":["almond","almonds"],"Beech nut":["beech nut","beechnut","beech nuts","beechnuts"],"Brazil nut":["brazil nut","brazil nuts"],"Butternut":["butternut","butternuts"],"Bush":["bush","bushes"],"Cashew":["cashew","cashews"],"Chestnut":["chestnut","chestnuts"],"Chinquapin":["chinquapin","chinquapins"],"Coconut":["coconut","coconuts"],"Filbert":["filbert","filberts"],"Ginkgo":["ginkgoes","ginkgos","gingkos","gingkoes","ginkgo","ginkgo nut","ginkgo nuts"],"Hazelnut":["hazelnut","hazelnuts"],"Hickory":["hickory nut","hickory nuts","hickory"],"Macadamia nut":["macadamia nut","macadamia nuts","macadamia","macadamias"],"Pecan":["pecan","pecans"],"Pili nut":["pili nut","pili nuts","pilis","pili"],"Pine nut":["pine nut","pine nuts"],"Pinon nut":["pinon nut","pinon nuts"],"Pistachio":["pistachio","pistachios"],"Shea nut":["shea nut","shea nuts"],"Walnut":["walnut","walnuts"],
                          "Monosodium glutamate":["monosodium glutamate","msg","msgs"],"Yellow Dye #5":["yellow dye #5","yellow dye number 5","fd&c yellow 5"],"FD&C Blue No. 2":["fd&c blue no. 2","fd&c blue number 2"],"Food preservative":["food preservative","food preservatives"],"Aspartame":["aspartame","aspartames"],"Sucrose":["sucrose","sucroses"], "Artificial sweetener":["artificial sweetener","artificial sweeteners"],"Caffeine":["caffeine","caffeines"],
                          "Sesame seed":["sesame seed","sesame seeds","sesame","sesames"],"Sunflower seed":["sunflower seed","sunflower seeds"],"Cocoa":["cocoa","cocoas"],"Quinoa":["quinoa","quinoas"],
                          "Beaf":["beef","beefs"],"Poultry":["poultry","poultries","chicken","chickens","turkey","turkeys"],"Lamb":["lamb","lambs"],"Duck":["duck","ducks","goose","geese"],"Goat":["goat","goats","sheep"],
                          "Apple":["apple","apples"],"Peach":["peach","peaches"],"Kiwi":["kiwi","kiwis"],"Acerola":["acerola","acerolas"],"Apricot":["apricot","apricots"],"Banana":["banana","bananas"], "Cherry":["cherry","cherries"],"Date":["date","dates"],"Fig":["fig","figs"],"Grape":["grape","grapes"],"Lychee":["lychee","lychees","lytchis"],"Mango":["mango","mangos"],"Melon":["melon","melons"],"Orange":["orange","oranges"],"Pear":["pear","pears"],"Persimmon":["persimmon","persimmons"],"Pineapple":["pineapple","pineapples"],"Pomegranate":["pomegranate","pomegranates"],"Prune":["prune","prunes"],"Strawberry":["strawberry","strawberries"],"Tomato":["tomato","tomatoes"],"Celery":["celery","celeries"],"Asparagus":["asparagus","asparagus","asparaguses"],"Avocado":["avocado","avocados"],"Bell pepper":["bell pepper","bell peppers"],"Cabbage":["cabbage","cabbages"],"Carrot":["carrot","carrots"],"Lettuce":["lettuce","lettuces"],"Potato":["potato","potatoes"],"Pumpkin":["pumpkin","pumpkins"],"Turnip":["turnip","turnips"],"Zucchini":["zucchini","zucchinis"]
    ]
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        if dict?.count != nil{
            dataArray = Array(dict!.keys)
        }
        
        myPickerView.delegate = self // set the delegate to self if you want to implement UIPickerViewDelegate methods
        myPickerView.dataSource = self // set the dataSource to self if you want to implement UIPickerViewDataSource methods
        view.addSubview(myPickerView)

//        let scrollView = UIScrollView()
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        // we're going to use auto-layout
        AllergyAssist.translatesAutoresizingMaskIntoConstraints = false
        PhotoIcon.translatesAutoresizingMaskIntoConstraints = false
        ScanAnItem.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        Image_Selector.translatesAutoresizingMaskIntoConstraints = false

        // add Scrollview to view
        view.addSubview(AllergyAssist)
        view.addSubview(PhotoIcon)
        view.addSubview(ScanAnItem)
        view.addSubview(Image_Selector)
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(image_view)
        verticalStackView.setCustomSpacing(10, after: image_view)
        NSLayoutConstraint.activate([
            image_view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            image_view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image_view.heightAnchor.constraint(equalToConstant: 250.0),
        ])
        // add row
        let row = UIStackView()
        // add it to the vertical stack view
        verticalStackView.addArrangedSubview(row)
        verticalStackView.setCustomSpacing(5, after: row)
        row.addArrangedSubview(ChooseUser)
        row.setCustomSpacing(0, after: ChooseUser)
        NSLayoutConstraint.activate([
            ChooseUser.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            ChooseUser.heightAnchor.constraint(equalToConstant: 50.0),
        ])
        row.addArrangedSubview(myPickerView)
        row.setCustomSpacing(5, after: myPickerView)
        NSLayoutConstraint.activate([
            myPickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            myPickerView.heightAnchor.constraint(equalToConstant: 50.0),
        ])
        if dict?.count != nil && dict!.count < 2 {
            verticalStackView.addArrangedSubview(check_bt)
            verticalStackView.setCustomSpacing(10, after: check_bt)
            NSLayoutConstraint.activate([
                check_bt.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                check_bt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                check_bt.heightAnchor.constraint(equalToConstant: 30.0),
            ])
        }
        verticalStackView.addArrangedSubview(warning)
        verticalStackView.setCustomSpacing(10, after: warning)
        NSLayoutConstraint.activate([
            warning.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            warning.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warning.heightAnchor.constraint(equalToConstant: 50.0),
        ])
        verticalStackView.addArrangedSubview(IngredientList)
        NSLayoutConstraint.activate([
            IngredientList.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            IngredientList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            IngredientList.heightAnchor.constraint(equalToConstant: 250.0),
        ])
        
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            AllergyAssist.topAnchor.constraint(equalTo: safeG.topAnchor,constant:5.0),
            AllergyAssist.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.75),
            AllergyAssist.heightAnchor.constraint(equalToConstant: 30.0),
            AllergyAssist.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            PhotoIcon.topAnchor.constraint(equalTo: AllergyAssist.bottomAnchor,constant:5.0),
            PhotoIcon.leftAnchor.constraint(equalTo: safeG.leftAnchor,constant: 10.0),
            PhotoIcon.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.075),
            PhotoIcon.heightAnchor.constraint(equalToConstant: 30.0),
            ScanAnItem.topAnchor.constraint(equalTo: AllergyAssist.bottomAnchor,constant:5.0),
            ScanAnItem.leftAnchor.constraint(equalTo: PhotoIcon.rightAnchor,constant: 5.0),
            ScanAnItem.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.4),
            ScanAnItem.heightAnchor.constraint(equalToConstant: 30.0),
            Image_Selector.topAnchor.constraint(equalTo: AllergyAssist.bottomAnchor,constant:5.0),
            Image_Selector.leftAnchor.constraint(equalTo: ScanAnItem.rightAnchor,constant: 5.0),
            Image_Selector.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.4),
            Image_Selector.heightAnchor.constraint(equalToConstant: 30.0),
            scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 80.0),
            scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 5.0),
            scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -5.0),
            scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -50.0),
            verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5.0),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 5.0),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -5.0),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -5.0),
        ])
        
        recognizeText(image: image_view.image)
//        start3()
        navi()
    }
    
    let image_view : UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named : "example2") //iv.image = UIImage(named : "sample.png")
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    let Image_Selector : UIButton = {
        let bt = UIButton()
        bt.setTitle("Upload Image", for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        bt.backgroundColor = UIColor.systemGreen
        bt.layer.cornerRadius = 10
//        bt.addTarget(self, action: #selector(pick_image(sender: )), for: .touchUpInside)
        bt.addTarget(self, action: #selector(takePhoto(sender: )), for: .touchUpInside)
        return bt
    }()
    
    let check_bt : UIButton = {
        let check_bt = UIButton()
        check_bt.setTitle("Check", for: .normal)
        check_bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        check_bt.backgroundColor = UIColor.systemGreen
        check_bt.layer.cornerRadius = 10
        check_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
        return check_bt
    }()
    
    @objc func pick_image(sender : UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @objc func takePhoto(sender : UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let selected_Image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        image_view.image = selected_Image
        recognizeText(image: image_view.image)
        self.dismiss(animated: true)
    }
    
    @objc func h1(sender : UIButton){
        let username = dataArray[0]
        check(key: username)
//        warning.text = sender.title(for: .normal)
//        let vc = ViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
    
    private let AllergyAssist: UILabel = {
        let allergyAssist = UILabel()
        allergyAssist.numberOfLines = 0
        allergyAssist.textAlignment = .center
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 25)
        allergyAssist.text = "Allergy Assist"
        return allergyAssist
     }()
    
    private let ChooseUser: UILabel = {
        let chooseUser = UILabel()
        chooseUser.numberOfLines = 2
        chooseUser.textAlignment = .center
        chooseUser.font = UIFont.boldSystemFont(ofSize: 12)
        chooseUser.text = "Choose User To Scan"
        return chooseUser
     }()
    
    private let warning: UITextView = {
        let warning = UITextView()
        warning.textColor = UIColor.red
        warning.font = UIFont.boldSystemFont(ofSize: 12)
        warning.text = ""
        warning.isEditable = false
        warning.isUserInteractionEnabled = true
        warning.backgroundColor = UIColor.systemYellow
        warning.layer.borderWidth = 1
        warning.layer.borderColor = UIColor.black.cgColor
        return warning
    }()
    
    private let IngredientList: UITextView = {
        let iList = UITextView()
        //iList.numberOfLines = 12
        //iList.textAlignment = .center
        iList.textColor = UIColor.black
        iList.font = UIFont.boldSystemFont(ofSize: 12)
        iList.text = ""
        iList.isEditable = false
        iList.isUserInteractionEnabled = true
        //chooseUser.cornerRadius = 10
        iList.backgroundColor = UIColor.white
        iList.layer.borderWidth = 1
        iList.layer.borderColor = UIColor.black.cgColor
        return iList
     }()
    
    private let ScanAnItem: UILabel = {
         let SAI = UILabel()
        SAI.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        SAI.numberOfLines = 2
        SAI.textAlignment = .center
        SAI.textColor = UIColor.black
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item label to see if it is safe for you to eat"
        SAI.backgroundColor = UIColor.white
        return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
    }
    
    //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
    }
    
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
           }).joined(separator: " ,")
    
            DispatchQueue.main.async {
        self?.IngredientList.text = text
            }
        }
    //Process the Request
           do {
               try handler.perform([request])
           }
           catch{
               IngredientList.text = ("\(error)")
           }
        
       }
    
   //Data Analysis
   public func DA(mes : String) -> Bool{
           //var text1 = mes
           print(mes)
       //passing the raw data in form of string
       // convert the string into array and split the substring by special symbols such as , ; space...
       // "the food contains peanut, fruit, milk" -> ["the", "food", "contains", "peanut", "fruit", "milk"]
       let res : Bool = false;
       var cnt : Int = 0
       let arr = mes.split(separator: ", ")
       print(arr)
       var percentage_arr = [String]()
       for item in arr {
           if item.contains("%") {
               percentage_arr.append(String(item))
           }
       }
       print(percentage_arr)
       for i in 0..<arr.count {
           let lb = UILabel()
           lb.numberOfLines = -1
           let size : CGFloat = CGFloat(arr[i].count * 18 + 10)
           let x : CGFloat = 10
           let y = CGFloat(i) * 20 + 300
           lb.frame = CGRect(x: x, y: y, width: size, height: 20)
           lb.backgroundColor = UIColor.black
           lb.clipsToBounds = true
           lb.layer.cornerRadius = 3
           lb.textColor = .white
           lb.font = UIFont.boldSystemFont(ofSize: 18)
           lb.text = String(arr[i])
           view.addSubview(lb)
       }
       return res;
   }
    
    let user_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        bt.addTarget(self, action: #selector(User_Account), for: .touchUpInside)
        return bt
    }()
    let sb_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "barcode"), for: .normal)
        bt.addTarget(self, action: #selector(Scan_Barcode), for: .touchUpInside)
        return bt
    }()
    let sl_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "camera"), for: .normal)
        bt.addTarget(self, action: #selector(Scan_Label), for: .touchUpInside)
        return bt
    }()
    
    private func navi(){
        user_bt.translatesAutoresizingMaskIntoConstraints = false
        sb_bt.translatesAutoresizingMaskIntoConstraints = false
        sl_bt.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(user_bt)
        view.addSubview(sb_bt)
        view.addSubview(sl_bt)
        let safeG = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            user_bt.bottomAnchor.constraint(equalTo: safeG.bottomAnchor,constant: -20.0),
            user_bt.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: 20.0),
            user_bt.widthAnchor.constraint(equalToConstant: 20.0),
            user_bt.heightAnchor.constraint(equalToConstant: 20.0),
            sb_bt.bottomAnchor.constraint(equalTo: safeG.bottomAnchor,constant: -20.0),
            sb_bt.centerXAnchor.constraint(equalTo: safeG.centerXAnchor,constant: 0.0),
            sb_bt.widthAnchor.constraint(equalToConstant: 20.0),
            sb_bt.heightAnchor.constraint(equalToConstant: 20.0),
            sl_bt.bottomAnchor.constraint(equalTo: safeG.bottomAnchor,constant: -20.0),
            sl_bt.rightAnchor.constraint(equalTo: safeG.rightAnchor, constant: -20.0),
            sl_bt.widthAnchor.constraint(equalToConstant: 20.0),
            sl_bt.heightAnchor.constraint(equalToConstant: 20.0),
        ])
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        user.name = dataArray[row]
        check(key: user.name)
    }
    
    private func check(key : String){
        // Assuming the string you want to highlight is stored in the "text" property of the TaxiView class
        var wordsToHighlight:[String] = [] // Replace with the word you want to highlight
        if let arr = dict?[key] as? [[String]]{
            myAvoid = arr[1]
            myLimit = arr[2]
            var set1: Set<String> = []
            for item in myAvoid {
                let arr = wordCollection[item]! as [String]
                set1 = set1.union(Set(arr))
            }
//            print(set1)
            let words = IngredientList.text.components(separatedBy: CharacterSet(charactersIn: ",:()."))
            for item in words{
                let trimmedString = item.trimmingCharacters(in: .whitespaces)
//                print(trimmedString)
                if set1.contains(trimmedString.lowercased()){
                    wordsToHighlight.append(String(trimmedString))
                }
            }
            let set2 = Set(wordsToHighlight)
            wordsToHighlight = Array(set2)
//            print(wordsToHighlight)
            warning.text = "This product contains " + wordsToHighlight.joined(separator: ", ") + "."
        }
        
        // Create an attributed string with the original text
        let attributedString = NSMutableAttributedString(string: IngredientList.text)
        atrributedString = cleanUpString(attributedString)
        // Loop through all the words to match
        for word in wordsToHighlight {
            // Create a regular expression object
            let regex = try! NSRegularExpression(pattern: "\\b\(word)\\b", options: .caseInsensitive)
            
            // Find all matches of the regular expression in the text
            let matches = regex.matches(in: IngredientList.text, options: [], range: NSRange(location: 0, length: IngredientList.text.utf16.count))
            // Apply highlighting to each match
            for match in matches {
                let matchRange = match.range
                let nsRange = NSRange(location: matchRange.lowerBound, length: matchRange.upperBound - matchRange.lowerBound)
                attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: nsRange)
            }
        }
        // Set the attributed text of the text view
        IngredientList.attributedText = attributedString
    }
    
    private func cleanUpString(text: String) -> String{
        // Remove any non-printable characters and unnecessary whitespace
        var cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            .filter { $0.isASCII}
        cleanedText = filterPrintableCharacters(in: cleanedText)

        // Remove any non-alphanumeric characters (except spaces and some punctuation)
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.formUnion(CharacterSet(charactersIn: "()"))
        cleanedText = cleanedText.components(separatedBy: allowedCharacterSet.inverted)
            .joined(separator: " ")

        // Convert any remaining whitespace to a single space
        let whitespaceCharacterSet = CharacterSet.whitespaces
        cleanedText = cleanedText.components(separatedBy: whitespaceCharacterSet)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        // Remove the word "Ingredients" and anything before it
        if let range = cleanedText.range(of: "Ingredients") {
            cleanedText.removeSubrange(cleanedText.startIndex..<range.upperBound)
        }
        cleanedText = cleanedText.replacingOccurrences(of: " and ", with: " ", options: [.caseInsensitive, .diacriticInsensitive])
        cleanedText = cleanedText.replacingOccurrences(of: " or ", with: " ", options: [.caseInsensitive, .diacriticInsensitive])
        if let range = cleanedText.range(of: "Ingredients") {
            cleanedText.removeSubrange(cleanedText.startIndex..<range.upperBound)
        }
        print(cleanedText)
        if let range = cleanedText.range(of: "CONTAINS") {
            cleanedText.removeSubrange(range.lowerBound..<cleanedText.endIndex)
        }
        return cleanedText
    }
}
