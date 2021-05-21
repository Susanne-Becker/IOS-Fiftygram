import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    let context = CIContext()
    var original: UIImage!

    @IBAction func applySepia() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }

    @IBAction func applyNoir() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func applyVintage() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }
    
    @IBAction func applyMono() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }
    
    @IBAction func applyEffectTransfer() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectTransfer")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }
    // bron: https://stackoverflow.com/questions/54274668/uiimagewritetosavedphotosalbum-error-use-of-unresolved-identifier/54274778#54274778
    //error or save message
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let message = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            message.addAction(UIAlertAction(title: "OK", style: .default))
            present(message, animated: true)
        } else {
            let message = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            message.addAction(UIAlertAction(title: "OK", style: .default))
            present(message, animated: true)
        }
    }
    
    // action save button
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }
}
