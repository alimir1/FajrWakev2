//
//  RingtoneSettingsViewController.swift
//  FajrWake
//
//  Created by Ali Mir on 9/4/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class RingtoneSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let alarm = Alarm.shared
    
    enum TableSection: Int {
        case athan = 0, dua, munajat, nature, total
    }
    
    var selectedIndexPath: IndexPath?
    
    let SectionHeaderHeight: CGFloat = 25
    
    var data = [TableSection : [[String: String]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if alarm.status != .activeAndFired {
            Alarm.shared.soundPlayer.stop()
        }
    }
    
    func sortData() {
        data[.athan] = Ringtones.data.filter({ $0["genre"] == "athan" })
        data[.dua] = Ringtones.data.filter({ $0["genre"] == "dua" })
        data[.munajat] = Ringtones.data.filter({ $0["genre"] == "munajat" })
        data[.nature] = Ringtones.data.filter({ $0["genre"] == "nature" })
    }
    
}


extension RingtoneSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = TableSection(rawValue: section), let ringtoneData = data[tableSection] {
            return ringtoneData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = TableSection(rawValue: section), let ringtoneData = data[tableSection], ringtoneData.count > 0 {
            return SectionHeaderHeight
        }
        return 0
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SectionHeaderHeight))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .athan:
                label.text = "Athan"
            case .dua:
                label.text = "Dua"
            case .munajat:
                label.text = "Munajat"
            case .nature:
                label.text = "Nature"
            default:
                label.text = ""
            }
        }
        view.addSubview(label)
        return view
    }*/
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let tableSection = TableSection(rawValue: section) {
            switch tableSection {
            case .athan:
                 return "Athan"
            case .dua:
                return "Dua"
            case .munajat:
                return "Munajat"
            case .nature:
                return "Nature"
            default: break
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ringtoneCell", for: indexPath)
        
        guard let tableSection = TableSection(rawValue: indexPath.section), let ringtone = data[tableSection]?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = ringtone["title"]
        
        // handle checkmarks
        if let ringtoneID = ringtone["fileName"], let ringtoneExtension = ringtone["fileExtension"] {
            if ringtoneID == alarm.soundPlayer.setting.ringtoneID && ringtoneExtension == alarm.soundPlayer.setting.ringtoneExtension {
                selectedIndexPath = indexPath
            }
        }
        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard indexPath != selectedIndexPath else {
            if alarm.status != .activeAndFired {
                alarm.soundPlayer.play()
            }
            return
        }
        
        guard let newlySelectedCell = tableView.cellForRow(at: indexPath), let tableSection = TableSection(rawValue: indexPath.section), let ringtone = data[tableSection]?[indexPath.row], let ringtoneID = ringtone["fileName"], let ringtoneExtension = ringtone["fileExtension"] else { return }
        
        // Add checkmark to newly selected cell
        if newlySelectedCell.accessoryType == .none {
            newlySelectedCell.accessoryType = .checkmark
        }
        
        // Remove checkmark from old cell
        
        if let oldSelectedIndexPath = selectedIndexPath, let oldCell = tableView.cellForRow(at: oldSelectedIndexPath) {
            if oldCell.accessoryType == .checkmark {
                oldCell.accessoryType = .none
            }
        }
        
        // Save newly selected indexPath
        selectedIndexPath = indexPath
        
        // set newly selected choice to alarm object
        alarm.setSoundSetting(SoundSetting(ringtoneID: ringtoneID, ringtoneExtension: ringtoneExtension, isRepeated: true))
        if alarm.status != .activeAndFired {
            alarm.soundPlayer.play()
        }
    }
}

