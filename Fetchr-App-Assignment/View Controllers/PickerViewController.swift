//
//  PickerViewController.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/6/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import UIKit

protocol PickerViewDelegate: class {
    func didSelectRowAt(_ index: Int)
}

class PickerViewController: UITableViewController {
    
    var selectedRowIndex = 0
    
    weak var delegate: PickerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.selectRow(at: IndexPath(row: strongSelf.selectedRowIndex, section: 0), animated: false, scrollPosition: .top)
        }
        
    }

    @IBAction func cancelButtonHandler(btn: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonHandler(btn: UIBarButtonItem) {
        
        delegate?.didSelectRowAt(tableView.indexPathForSelectedRow?.row ?? 0)
        dismiss(animated: true, completion: nil)
        
    }

}
