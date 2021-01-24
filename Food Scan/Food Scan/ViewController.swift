//
//  ViewController.swift
//  Food Scan
//
//  Created by Adesh Gautam on 15/10/17.
//  Copyright © 2017 adeshgautam. All rights reserved.
//

import UIKit
import Alamofire

class Data {
    static var foodGuess: String = ""
}

class ViewController: UIViewController {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
        var prediction: String? = "" {
        didSet {
            if prediction != nil {
//                if let arrayOfTabBarItems = tabBarController?.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
//                        tabBarItem.isEnabled = true
//                }
                
                let tabBarControllerItems = self.tabBarController?.tabBar.items
                
                if let tabArray = tabBarControllerItems {
                    let tabBarItem1 = tabArray[1]
                    let tabBarItem2 = tabArray[2]
                    
                    tabBarItem1.isEnabled = true
                    tabBarItem2.isEnabled = true
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
//        if  let arrayOfTabBarItems = tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
//            tabBarItem.isEnabled = false
//        }
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        if let tabArray = tabBarControllerItems {
            let tabBarItem1 = tabArray[1]
            let tabBarItem2 = tabArray[2]
            
            tabBarItem1.isEnabled = false
            tabBarItem2.isEnabled = false
        }
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        //guessLabel.text = "Show me something..."
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func clickPhoto(_ sender: UIButton) {
        //guessLabel.text = "Show me something..."
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.availableCaptureModes(for: .front) != nil {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.cameraCaptureMode = .photo
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func guessImage(_ sender: UIButton) {
        
        //        let request = NSMutableURLRequest(url: NSURL(string: "http://arduino-app.herokuapp.com/process_data/")! as URL)
        //        request.httpMethod = "POST"
        //        let postString = "ard_data=OFF"
        //        request.httpBody = postString.data(using: String.Encoding.utf8)
        //        let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
        //            guard error == nil && data != nil else{
        //                print("error")
        //                return
        //            }
        //            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
        //                print("statusCode should be 200, but is \(httpStatus.statusCode)")
        //                print("response = \(String(describing: response))")
        //            }
        //            let responseString = String(data: data!, encoding: String.Encoding.utf8)
        //            print("responseString = \(String(describing: responseString))")
        //        }
        //        task.resume()
        
        let parameters = [String:AnyObject]()
        let URL = "http://food-scan.herokuapp.com/post_images/"
        self.guessLabel.text = " "
        self.activityIndicator.startAnimating()
        
        if let image = self.foodImage.image as? UIImage? {
            if image != nil {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(UIImageJPEGRepresentation(image!, 0.5)!, withName: "image", fileName: "img.png", mimeType: "image/png")
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }, to: URL)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            //self.delegate?.showSuccessAlert()
                            //print(response.request)  // original URL request
                            //print(response.response) // URL response
                            //print(response.data)     // server data
                            //print(response.result)   // result of response serialization
                            //                        self.showSuccesAlert()
                            //self.removeImage("frame", fileExtension: "txt")
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                let dict = JSON as? Dictionary<String, Double>
                                var d = dict!.sorted(by: { (a, b) in (a.value as Double!) > (b.value as Double!)})
                                print(d)
                                let guess =  d[(d.startIndex)].key
                                print(guess)
                                
                                self.activityIndicator.stopAnimating()
                                self.guessLabel.text? = "Its " + guess + " !"
                                self.prediction = guess
                                Data.foodGuess = guess
                            }
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                    
                }
            }
        }
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        foodImage?.image = image
        picker.dismiss(animated: true, completion: nil)
        self.guessLabel.text? = "Nice Picture !"
    }
}
