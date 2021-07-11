//
//  ViewController.swift
//  MLTestApp
//
//  Created by Артем Хребтов on 11.07.2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = "Select image"
        imageView.image = UIImage(systemName: "photo")
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapImage))
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    @objc func didTapImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = image
        guard let ciImage = CIImage(image: image) else { return }
        detect(image: ciImage)
    }
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("Loading CoreML model Failed!")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image!")
            }
            
            if let firstResult = results.first {
                self.labelText.text = firstResult.identifier
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        
        
    }
    
}

