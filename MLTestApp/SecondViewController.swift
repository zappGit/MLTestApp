//
//  SecondViewController.swift
//  MLTestApp
//
//  Created by Артем Хребтов on 14.07.2021.
//

import UIKit
import Vision

class SecondViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        //label.backgroundColor = .white
        label.text = "Running"
        return label
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "ex1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        recognizeText(image: imageView.image)
        
    }
    override func viewDidLayoutSubviews() {
        imageView.frame = CGRect(x: 20,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-40,
                                 height: view.frame.size.width-40)
        label.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
    }
    
    private func recognizeText (image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        //Handler
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //Request
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observation = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let text = observation.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            DispatchQueue.main.async {
                self?.label.text = text
            }
            
        }
        
        // Process request
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
    
}
