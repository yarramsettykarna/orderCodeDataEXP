//
//  ViewController.swift
//  OrderManagement
//
//  Created by karna yarramsetty on 09/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var order: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchOrders()
  }
    
    func fetchOrders() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Order")
        
        do {
            order = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

  @IBAction func addName(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "SAVE ORDER DETAILS", message: "", preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
        
        guard let orderNumberTF = alert.textFields?.first,
              let orderNumber = orderNumberTF.text else {
            return
        }
        guard let orderDueDateTF = alert.textFields?[1],
              let orderDueDate = orderDueDateTF.text else {
            return
        }
        guard let customerNameTF = alert.textFields?[2],
              let customerName = customerNameTF.text else {
            return
        }
        guard let customerAddressTF = alert.textFields?[3],
              let customerAddress = customerAddressTF.text else {
            return
        }
        guard let customerPhoneTF = alert.textFields?[4],
              let customerPhone = customerPhoneTF.text else {
            return
        }
        guard let orderTotalTF = alert.textFields?[5],
              let orderTotal = orderTotalTF.text else {
            return
        }
        
        self.save(orderNumber: orderNumber, orderDueDate: orderDueDate, customerName: customerName, customerAddress: customerAddress, customerPhone: customerPhone, orderTotal: orderTotal)
        self.tableView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alert.addTextField { (textFiled) in
      textFiled.placeholder = "Order Number"
    }
    alert.addTextField { (textFiled) in
      textFiled.placeholder = "Order Due Date"
    }
    alert.addTextField { (textFiled) in
      textFiled.placeholder = "Customer Name"
    }
    alert.addTextField { (textFiled) in
      textFiled.placeholder = "Customer Address"
    }
    alert.addTextField { (textFiled) in
      textFiled.placeholder = "Customer Phone"
    }
    alert.addTextField { (textFiled) in
      textFiled.placeholder = "Order Total"
    }
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    self.present(alert, animated: true, completion: nil)
  }

  func save(orderNumber: String, orderDueDate: String, customerName: String, customerAddress: String, customerPhone: String, orderTotal: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Order", in: managedContext)!
    let person = NSManagedObject(entity: entity, insertInto: managedContext)
    person.setValue(orderNumber, forKeyPath: "orderNumber")
    person.setValue(orderDueDate, forKeyPath: "orderDueDate")
    person.setValue(customerName, forKeyPath: "customerName")
    person.setValue(customerAddress, forKeyPath: "customerAddress")
    person.setValue(customerPhone, forKeyPath: "customerPhone")
    person.setValue(orderTotal, forKeyPath: "orderTotal")
    do {
      try managedContext.save()
      order.append(person)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return order.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let orderObj = order[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
    cell.OrderNumber.text = orderObj.value(forKeyPath: "orderNumber") as? String
    cell.OrderDate.text = orderObj.value(forKeyPath: "orderDueDate") as? String
    cell.CustomerName.text = orderObj.value(forKeyPath: "customerName") as? String
    cell.CustomerAddress.text = orderObj.value(forKeyPath: "customerAddress") as? String
    cell.CustomerPhone.text = orderObj.value(forKeyPath: "customerPhone") as? String
    cell.OrderTotal.text = orderObj.value(forKeyPath: "orderTotal") as? String
    return cell
  }
}
// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActionSheet(index: indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func showActionSheet(index: Int) {
        let alert = UIAlertController(title: "Please Select an Option", message: "", preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "EDIT", style: .default, handler: {_ in
            self.updateDataWithAlert(index: index)
        })
        let delete = UIAlertAction(title: "DELETE", style: .default, handler: {_ in
            self.deleteData(orderNumber: self.order[index].value(forKeyPath: "orderNumber") as? String ?? "")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateData(orderNumber: String, orderDueDate: String, customerName: String, customerAddress: String, customerPhone: String, orderTotal: String, index: Int) {

        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Order")
        let orderStr = self.order[index].value(forKeyPath: "orderNumber") as? String ?? ""
        fetchRequest.predicate = NSPredicate(format: "orderNumber = %@", orderStr)
        do
        {
            let test = try managedContext.fetch(fetchRequest)

                let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(orderNumber, forKeyPath: "orderNumber")
            objectUpdate.setValue(orderDueDate, forKeyPath: "orderDueDate")
            objectUpdate.setValue(customerName, forKeyPath: "customerName")
            objectUpdate.setValue(customerAddress, forKeyPath: "customerAddress")
            objectUpdate.setValue(customerPhone, forKeyPath: "customerPhone")
            objectUpdate.setValue(orderTotal, forKeyPath: "orderTotal")
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        catch
        {
            print(error)
        }
        fetchOrders()
        self.tableView.reloadData()
    }
    func deleteData(orderNumber: String){
       
       //As we know that container is set up in the AppDelegates so we need to refer that container.
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       
       //We need to create a context from this container
       let managedContext = appDelegate.persistentContainer.viewContext
       
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
       fetchRequest.predicate = NSPredicate(format: "orderNumber = %@", orderNumber)
      
       do
       {
           let test = try managedContext.fetch(fetchRequest)
           
           let objectToDelete = test[0] as! NSManagedObject
           managedContext.delete(objectToDelete)
           do{
               try managedContext.save()
           }
           catch
           {
               print(error)
           }
           
       }
       catch
       {
           print(error)
       }
        fetchOrders()
        self.tableView.reloadData()
   }
    
    func updateDataWithAlert(index: Int) {
        let orderObj = order[index]
          let alert = UIAlertController(title: "UPDATE ORDER DETAILS", message: "", preferredStyle: .alert)

          let saveAction = UIAlertAction(title: "Update", style: .default) { [unowned self] action in
              
              guard let orderNumberTF = alert.textFields?.first,
                    let orderNumber = orderNumberTF.text else {
                  return
              }
              guard let orderDueDateTF = alert.textFields?[1],
                    let orderDueDate = orderDueDateTF.text else {
                  return
              }
              guard let customerNameTF = alert.textFields?[2],
                    let customerName = customerNameTF.text else {
                  return
              }
              guard let customerAddressTF = alert.textFields?[3],
                    let customerAddress = customerAddressTF.text else {
                  return
              }
              guard let customerPhoneTF = alert.textFields?[4],
                    let customerPhone = customerPhoneTF.text else {
                  return
              }
              guard let orderTotalTF = alert.textFields?[5],
                    let orderTotal = orderTotalTF.text else {
                  return
              }
              
            self.updateData(orderNumber: orderNumber, orderDueDate: orderDueDate, customerName: customerName, customerAddress: customerAddress, customerPhone: customerPhone, orderTotal: orderTotal, index: index)
              self.tableView.reloadData()
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
          alert.addTextField { (textFiled) in
            textFiled.text = orderObj.value(forKeyPath: "orderNumber") as? String
          }
          alert.addTextField { (textFiled) in
            textFiled.text = orderObj.value(forKeyPath: "orderDueDate") as? String
          }
          alert.addTextField { (textFiled) in
            textFiled.text = orderObj.value(forKeyPath: "customerName") as? String
          }
          alert.addTextField { (textFiled) in
            textFiled.text = orderObj.value(forKeyPath: "customerAddress") as? String
          }
          alert.addTextField { (textFiled) in
            textFiled.text = orderObj.value(forKeyPath: "customerPhone") as? String
          }
          alert.addTextField { (textFiled) in
            textFiled.text = orderObj.value(forKeyPath: "orderTotal") as? String
          }
          alert.addAction(saveAction)
          alert.addAction(cancelAction)

          self.present(alert, animated: true, completion: nil)
        }
}
