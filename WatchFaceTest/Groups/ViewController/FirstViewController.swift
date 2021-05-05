//
//  MainViewController.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/28/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    // - Data
    var imageFace: UIImage!
    var document: Document?
    // - UI
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    // - ImagePicker
    let imagePicker = UIImagePickerController()
    
    private lazy var localRoot: URL? = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAvatar()
    }
    @IBAction func createButtonAction(_ sender: Any) {
        if let title = textField.text, let imageData = imageFace.pngData(){
            if title.count > 0 {
            configureDocument(image: imageData, title: title )
                showWarningAlert(title: "Файл создан", message: "Смотрите в файлах")
            } else {
                showWarningAlert(title: "Ошибка", message: "Введите название файла")
            }
        }
    }
    
    
    @IBAction func chooseButtonAction(_ sender: Any) {
        showAlert()
    }
    
    
    
}
// MARK: -
// MARK: Configure ViewController
extension FirstViewController {
    // - make image of button last used
    func configureAvatar() {
        if let imageData = UserDefaults.standard.object(forKey: "avatarImage") as? Data {
            let avatar = UIImage(data: imageData)!
            imageButton.setImage(avatar, for: .normal)
            imageButton.clipsToBounds = true
        } else {
            imageButton.setImage(UIImage(named: "camera"), for: .normal)
        }
    }
    // - show allert for choosing new image
    func showAlert() {
        let alertController = UIAlertController(title: "Выбрать фон для циферблата", message: nil, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (alert) in
            //
        }
        let cameraAction = UIAlertAction(title:"Камера", style: .default) { (alert ) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let galeryAction = UIAlertAction(title: "Фотогалерея", style: .default) { (alert) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(galeryAction)
        alertController.addAction(cancelAction)
    }
    
    func showWarningAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
               present(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
                   //
               }
        alertController.addAction(okAction)
    }
    
    // - configure new .watchface
    func configureDocument(image data: Data, title: String) {
        var watchface: Watchface = .init(
            photosWatchface: PhotosWatchface(
                device_size: 2, position: .top, snapshot: Data(), no_borders_snapshot: Data(), topComplication: nil, bottomComplication: nil, resources: .init(images: .init(imageList: []), files: [:])))
        let imageData: Data? = data
        let movieData: Data? = nil
        
        let filenameBase = UUID().uuidString
        print(filenameBase)
        
        let item = Watchface.Resources.Metadata.Item(
            topAnalysis: .init(bgBrightness: 0, bgHue: 0, bgSaturation: 0, coloredText: false, complexBackground: false, shadowBrightness: 0, shadowHue: 0, shadowSaturation: 0, textBrightness: 0, textHue: 0, textSaturation: 0),
            leftAnalysis: .init(bgBrightness: 0, bgHue: 0, bgSaturation: 0, coloredText: false, complexBackground: false, shadowBrightness: 0, shadowHue: 0, shadowSaturation: 0, textBrightness: 0, textHue: 0, textSaturation: 0),
            bottomAnalysis: .init(bgBrightness: 0, bgHue: 0, bgSaturation: 0, coloredText: false, complexBackground: false, shadowBrightness: 0, shadowHue: 0, shadowSaturation: 0, textBrightness: 0, textHue: 0, textSaturation: 0),
            rightAnalysis: .init(bgBrightness: 0, bgHue: 0, bgSaturation: 0, coloredText: false, complexBackground: false, shadowBrightness: 0, shadowHue: 0, shadowSaturation: 0, textBrightness: 0, textHue: 0, textSaturation: 0),
            imageURL: "\(filenameBase).jpg",
            irisDuration: 0,
            irisStillDisplayTime: 0,
            irisVideoURL: "\(filenameBase).mov",
            isIris: movieData != nil,
            localIdentifier: "",
            modificationDate: Date(),
            cropH: 0,
            cropW: 0,
            cropX: 0,
            cropY: 0,
            originalCropH: 0,
            originalCropW: 0,
            originalCropX: 0,
            originalCropY: 0)
        watchface.resources?.images.imageList.append(item)
        watchface.resources?.files[item.imageURL] = imageData
        watchface.resources?.files[item.irisVideoURL] = movieData
        let name = getDocFilename(for: title ?? "Photo")
        guard let fileURL = getDocURL(for: name) else {return}
        let doc = Document(fileURL: fileURL)
        doc.watchface = watchface
        print(watchface)
        doc.save(to: fileURL, for: .forCreating) {
            [weak self] success in
            guard success else {
                fatalError("Failed to create file.")
            }
            print("File created at: \(fileURL)")
        }
    }
    // - get url of file
    func getDocURL(for filename: String) -> URL? {
        return localRoot?.appendingPathComponent(filename, isDirectory: false)
    }
    // - get name of file
    func getDocFilename(for prefix: String) -> String {
        var newDocName = String(format: "%@.%@", prefix, "watchface")
        var docCount = 1
        newDocName = String(format: "%@ %d.%@", prefix, docCount, "watchface")
        return newDocName
    }
    
    
}

// MARK: -
// MARK: ImagePickerDelegate
extension FirstViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    // - choosing image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserDefaults.standard.set(image.pngData(), forKey: "avatarImage")
            configureAvatar()
            imageFace = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageButton.setImage(UIImage(named: "camera"), for: .normal)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

