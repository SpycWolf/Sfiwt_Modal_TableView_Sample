import UIKit

protocol ModalViewControllerDelegate {
    func modalDidFinished(selectedItem: [String])
}

class ModalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isDetail = true
    var allowsMultiple = false
    
    var tableData = [String]()
    var selectedItem = [String]()
    var masterData = [String]()
    var detailData = [[String]]()
    
    var cell = UITableViewCell()
    var delegate: ModalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if isDetail {
            btnDone.isHidden = false
            tableData = detailData[0]
            tableView.allowsMultipleSelection = allowsMultiple
        } else {
            btnDone.isHidden = true
            tableData = masterData
        }
    }

    @IBAction func actionDone(_ sender: UIButton) {
        self.delegate?.modalDidFinished(selectedItem: selectedItem)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        if isDetail {
            let originalRect = CGRect(x: tableView.frame.origin.x,
                                      y: tableView.frame.origin.y,
                                      width: tableView.frame.size.width,
                                      height: tableView.frame.size.height
            )
            let masterRect = CGRect(x: tableView.frame.origin.x + tableView.frame.size.width,
                                    y: tableView.frame.origin.y,
                                    width: 10,
                                    height: tableView.frame.size.height
            )
            
            UIView.animate(withDuration: 0.1, animations: {
                self.tableView.frame = masterRect
            }, completion: { finisihed in
                self.changeFromDetailToMaster()
                UIView.animate(withDuration: 0.0, animations: {
                    self.tableView.frame = originalRect
                }, completion: { finisihed in
                })
            })
        } else {
            self.delegate?.modalDidFinished(selectedItem: selectedItem)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel!.text = tableData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isDetail {
            cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            // 値の選択
            selectedItem.append(tableData[indexPath.row])
        } else {
            let originalRect = CGRect(x: tableView.frame.origin.x,
                                      y: tableView.frame.origin.y,
                                      width: tableView.frame.size.width,
                                      height: tableView.frame.size.height
            )
            let detailRect = CGRect(x: tableView.frame.origin.x,
                                    y: tableView.frame.origin.y,
                                    width: 10,
                                    height: tableView.frame.size.height
            )
            
            UIView.animate(withDuration: 0.1, animations: {
                self.tableView.frame = detailRect
            }, completion: { _ in
                self.changeFromMasterToDetail(indexPath: indexPath as NSIndexPath)
                UIView.animate(withDuration: 0.0, animations: {
                    self.tableView.frame = originalRect
                }, completion: { _ in
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isDetail {
            cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.none
            // 値の選択解除
            selectedItem.remove(at: selectedItem.index(of: tableData[indexPath.row])!)
        }
    }
    
    func changeFromMasterToDetail(indexPath: NSIndexPath) {
        isDetail = true
        btnDone.isHidden = false
        tableData.removeAll()
        tableData = detailData[indexPath.row]
        
        // 複数選択の許可
        tableView.allowsMultipleSelection = allowsMultiple
        
        tableView.reloadData()
        tableView.setContentOffset(CGPoint(x: 0,y :0), animated: false)
    }
    
    func changeFromDetailToMaster() {
        isDetail = false
        btnDone.isHidden = true
        
        tableData.removeAll()
        tableData = masterData
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
