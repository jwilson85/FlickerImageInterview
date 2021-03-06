//
//  ViewController.swift
//  FlickerImages
//
//  Created by Wilson, Jeremy on 11/9/21.
//

import UIKit
import Foundation

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    var hasGradient = false

    override func layoutSubviews() {
        super.layoutSubviews()
        if !hasGradient {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = [UIColor.clear.cgColor,UIColor.gray.cgColor]
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
            hasGradient = true
        }
        
    }
}

class ViewController: UIViewController {

    
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var photoData: PhotoData?
    
    var imageLoader = ImageLoader()
    
    var lastGottenPage = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        searchTextField.returnKeyType = .done
        searchTextField.text = "yellowstone"
        searchPhotos(text: "yellowstone", page: lastGottenPage)
        
        tableView.prefetchDataSource = self
    }

    func searchPhotos(text: String, page: Int) {
        APIController.searchEndpoint.searchPhotos(text: text, page: page) { photoData, error in
            if page > 1 {
                guard let photoArray = photoData?.photos?.photo else {return}
                self.photoData?.photos?.photo?.append(contentsOf: photoArray)
            } else {
                self.photoData = photoData
            }
            
            DispatchQueue.main.async {
                self.checkNoResults()
                self.tableView.reloadData()
            }
        }
    }
    
    func checkNoResults(){
        noResultsView.isHidden = photoData?.photos?.photo?.count ?? 0 > 1
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func showImageDetailsViewController(imageURL: String) {
        if let vc = UIStoryboard.init(name: "ImageDetailsViewController", bundle: nil).instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ImageDetailsViewController {
            
            vc.viewModel = ImageDetailsViewModel(imageUrl: imageURL)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUpNavbar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            //Rest pagination on any text changes
            self.lastGottenPage = 1
            self.searchPhotos(text: text, page: lastGottenPage)
        }
        self.dismissKeyboard()
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    static let imageTableViewCellID = "ImageTableViewCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoData?.photos?.photo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.imageTableViewCellID, for: indexPath) as? ImageTableViewCell else {
                    fatalError("Unable to dequeue ReminderCell")
                }
        let photoObject = photoData?.photos?.photo?[indexPath.row]
        
        if let imageUrlString = photoObject?.urlS {
            imageLoader.obtainImageWithPath(imagePath: imageUrlString) { image in
                cell.mainImageView.image = image
            }
        }
        cell.titleLable.text = photoObject?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoObject = photoData?.photos?.photo?[indexPath.row]
        
        if let imageUrlString = photoObject?.urlL {
            self.showImageDetailsViewController(imageURL: imageUrlString)
        }
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    //Quick and dirty infinate scroll this would be better with a diffable data source
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let row = indexPaths.first?.row {
            if row >= (self.lastGottenPage * 20){
                print("getting data")
                self.lastGottenPage += 1
                self.searchPhotos(text: searchTextField.text ?? "", page: self.lastGottenPage)
            }
        }
        
        //smooth scrolling and reduce image load time
        for indexPath in indexPaths {
            let photoObject = photoData?.photos?.photo?[indexPath.row]
            if let imageUrlString = photoObject?.urlS {
                imageLoader.obtainImageWithPath(imagePath: imageUrlString) { image in}
            }
        }
    }
}
