//
//  ViewController.swift
//  name_to_faces
//
//  Created by Erin Moon on 10/19/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Array of pictures.
    var people = [Person]()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        //Generates a Universal Unique ID, and turns it into a string.
        let imageName = UUID().uuidString
        
        //Creates a new path in the documents directory based on the imageName.
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        //Turns the image into a jpeg and sets it's quality to 80 out of 100.
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        
        //Adds a new person to the people array, and refreshes the view.
        let person = Person(name: "\(imageName)", image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        //Dismisses the view controller that was presented modally by the view controller.
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        //Gets the path to the users documents directory. Second parameter states that the path is relative to the user's home directory.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //Sets the number of items in the view to the size of the people array.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    //Cycles through all the items in the view, and assigns them a picture.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Creates a new cell based on the PersonCell class we created.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        let person = people[indexPath.item]
        
        //Assigns the cell name that we created in imagePickerController using UUID.
        cell.name.text = person.name
        
        //Grabs the path to the image that we created in imagePickerController.
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        //Assigns the cell view to the jpeg picture.
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        //Styling for each cell.
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
.cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    //Allows users to remane individual pictures.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.collectionView?.reloadData()
        })
    
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Adds a "+" button to the nav bar.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

