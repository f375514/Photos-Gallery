//
//  ViewController.swift
//  Multi-image-Picker
//
//  Created by Md. Faysal Ahmed on 21/10/22.
//

import UIKit
import PhotosUI
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [UIImage] = [UIImage]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        addButton.layer.cornerRadius = 0.5 * addButton.frame.size.height
        
    }
    
    // some comment

    
    // MARK: - Private method -
    
    func setupCollectionView() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        var phPickerConfig = PHPickerConfiguration()
        phPickerConfig.selectionLimit = 25
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}

// MARK: - Collection View Delegate & data source -

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.configure(image: images[indexPath.row])
        //cell.imageView.image = selectedImageArr[indexPath.row] //without configrtn
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "FullVC", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FullVC") as! FullVC
        vc.imagesArr = images
        vc.selectedImageIndexPath = indexPath
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Collection View Layout Item size
extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/4 - 1, height: width/4 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

// MARK: PHPicker -for picking multiple image from photo source
extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: .none)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) {object, error in
                if let image = object as? UIImage {
                    self.images.append(image)
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData();
                }
            }
        }
    }
}

// MARK: Helper function to get device is Potrait of Landscape
struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isLandscape
                : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isPortrait
                : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}

extension ViewController: GetArr { //Will call first after geting back (cus delegate)
    func getImageArr(_ image: [UIImage]) {
        images = image
        collectionView.reloadData()
    }
}
