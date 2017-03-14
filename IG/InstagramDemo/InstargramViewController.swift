//
//  InstargramViewController.swift
//  InstagramDemo
//
//  Created by Enzo Ames on 3/13/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import Parse

class InstargramViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var messages: [PFObject]? = []
    
    
    func getPosts()
    {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
        if let posts = posts
        {
                self.messages = posts
                print("RELOADING TABLE")
                self.tableView.reloadData()
        }
        else
        {
            print("error: \(error?.localizedDescription)")
        }}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getPosts()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postCellTableViewCell
        let post = messages?[indexPath.row]
        
        cell.instagramPost = post
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func onTapLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
                })
            }
            else {
                let alert = UIAlertController(title: "Opps!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                // add the OK action to the alert controller
                alert.addAction(OKAction)
                self.present(alert, animated: true) {
                    
                }
            }
        }
    }
    
    @IBAction func onTapNewPost(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage
    {
        let resizeImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newResizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newResizedImage!
    }

    
    
    //Jose helped me with the imagePickerController function. This method reduces the number of files to deak with. It's not the most efficient method if I wanted to expand the app further, but it does the work that you're required to do
    //I will continue to work on this project and properly implement the other view controllers and keep my code more organized and easier to read.
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //let sizedOrigImage = resize(image: originalImage, newSize: CGSize(width: 1008, height: 756))
        let sizedEditedImage = resize(image: editedImage, newSize: CGSize(width: 1008, height: 756))
        
        dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Add a comment...", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Comment..."
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(CancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            PostModel.postUserImage(image: sizedEditedImage, withCaption: alert.textFields?[0].text, withCompletion: { (success: Bool, error: Error?) in
                if success {
                    self.getPosts()
                    self.tableView.reloadData()
                }
                else{
                    let alert = UIAlertController(title: "Opps!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true) {
                        
                    }
                }
            })
        }
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    

}
