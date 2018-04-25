//
//  ViewController.swift
//  FaceDetection
//
//  Created by Apple on 4/25/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let image = UIImage(named:"ed_pic2") else {return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width/image.size.width * image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
          
          
            if let err = err{
                print("Failed to dect faces",err)
                return
            }
            print(req)
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    print(res)
                    guard let faceObservation = res  as? VNFaceObservation else {return}
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width , height: height)
                    self.view.addSubview(redView)
                    print(faceObservation.boundingBox)
                }
              
            })
        }
        
        guard let cgImage = image.cgImage else {return}
        DispatchQueue.global(qos:.background).async {
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr{
                print("Finled to perform req",reqErr)
                
            }
            
        }
        
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

