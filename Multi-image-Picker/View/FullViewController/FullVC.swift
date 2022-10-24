//
//  FullVC.swift
//  Multi-image-Picker
//
//  Created by Md. Faysal Ahmed on 22/10/22.
//

import UIKit

protocol GetArr {
    func getImageArr(_ image: [UIImage])
}

class FullVC: UIViewController {

    @IBOutlet weak var fullCollectionView: UICollectionView!
    
    var imagesArr: [UIImage] = [UIImage]()
    var selectedImageIndexPath: IndexPath?
    
    var delegate: GetArr? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvSetUP()
        fullCollectionView.alpha = 0
        fullCollectionView.isPagingEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fullCollectionView.scrollToItem(at: self.selectedImageIndexPath ?? [0, 0], at: .centeredHorizontally, animated: false)
        fullCollectionView.isPagingEnabled = true
    
        UIView.animate(withDuration: 0.5) {
            self.fullCollectionView.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {    //call when return back
        super.viewWillDisappear(animated)
        print("hello")
                
        if let delegate = delegate {
            delegate.getImageArr(imagesArr)
        }
    }
    
    
    func cvSetUP() {
        let nib = UINib(nibName: "FullCVCell", bundle: nil)
        fullCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        fullCollectionView.delegate = self
        fullCollectionView.dataSource = self
    }

}

extension FullVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FullCVCell
        cell.img.image = imagesArr[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(deleteItemFromCV), for: .touchUpInside) //if delete need

        return cell
    }
    
    // MARK: Delete Item
    @objc func deleteItemFromCV(sender: UIButton) {
        print("")
        
        if let photoCVCell = sender.superview?.superview as? FullCVCell {
            let alert = UIAlertController(title: "Delete", message: "Do you want to delete this image?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                guard let indexPath = fullCollectionView.indexPath(for: photoCVCell) else {
                    return
                }
                self.imagesArr.remove(at: indexPath.row)
                print("Removed!")
                self.fullCollectionView.deleteItems(at: [indexPath])
                self.fullCollectionView.reloadData()
            }))
            
            alert.view.tintColor = .red
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: Layout item size both Potrait & Landscape
extension FullVC : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if DeviceInfoo.Orientation.isPortrait {
            return CGSize(width: view.frame.width, height: view.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


// MARK: Helper function to get device [is Potrait of Landscape?]
struct DeviceInfoo {
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
