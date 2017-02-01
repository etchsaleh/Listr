//
//  ItemDetailsVC.swift
//  Listr
//
//  Created by Hesham Saleh on 1/30/17.
//  Copyright © 2017 Hesham Saleh. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    var stores = [Store]()
    
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        //Navigation bar styling
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Create stores only if the context.count is equal to 0.
        let count = fetchStoreCount()
        if count == 0 {
            
            let store1 = Store(context: context)
            store1.name = "Best Buy"
            let store2 = Store(context: context)
            store2.name = "Amazon"
            let store3 = Store(context: context)
            store3.name = "Walmart"
            let store4 = Store(context: context)
            store4.name = "Carrefour"
            let store5 = Store(context: context)
            store5.name = "Home Depot"
            let store6 = Store(context: context)
            store6.name = "Target"
            let store7 = Store(context: context)
            store7.name = "K Mart"
            let store8 = Store(context: context)
            store8.name = "Tesco"
            let store9 = Store(context: context)
            store9.name = "Marks & Spencer"
            
            ad.saveContext()
        }
        
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
    }
    
    func numberOfComponents(in: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Update when selected
    }
    
    //Fetch stores.
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            //handle error
        }
    }
    
    //Fetch store count.
    func fetchStoreCount() -> Int {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            print("Current Store Data Count : \(count)")
            return count
        } catch let err as NSError {
            print(err.description)
            return 0
        }
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        
        picture.image = thumbImg.image
        
        //If creating a new entry
        if itemToEdit == nil {
            
            item = Item(context: context)
        
        //If modifying an existing entry
        } else {
            
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = priceField.text {
            
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        backToMainScreen()
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            
            ad.saveContext()
        }
        
        backToMainScreen()
    }
    
    func backToMainScreen() {
        
        //Dismiss view once new entry is made.
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData() {
        
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    
                    index += 1
                    
                } while (index < stores.count)
            }
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
