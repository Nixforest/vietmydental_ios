//
//  ListAgencyViewController.swift
//  dental
//
//  Created by Lâm Phạm on 8/1/18.
//  Copyright © 2018 SPJ. All rights reserved.
//

import UIKit
import harpyframework

protocol ListAgencyViewControllerDelegate: class {
    func listAgencyViewControllerDidPick(listAgents: [ConfigBean])
}

class ListAgencyViewController: ChildExtViewController {

    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var tbView: UITableView!
    
    var delegate: ListAgencyViewControllerDelegate!
    var listAgent: [ConfigBean] = []
    var selectedAgents: [ConfigBean] = []
    let cellID = "ListAgentTableViewCell"
    
    init(selectedAgents: [ConfigBean]) {
        self.selectedAgents = selectedAgents
        super.init(nibName: "ListAgencyViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar(title: "Danh sách chi nhánh")
        btnOK.drawRadius(6)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        processListAgents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isAgentSelected(agent: ConfigBean) -> Bool {
        for a in selectedAgents {
            if agent.id == a.id {
                return true
            }
        }
        return false
    }
    
    func indexOf(agent: ConfigBean, inList: [ConfigBean]) -> Int {
        var ind = -1
        for a in selectedAgents {
            if agent.id == a.id {
                ind = selectedAgents.index(of: a)!
            }
        }
        return ind
    }
    
    func processListAgents() {
        let customerAgentsID = BaseModel.shared.getUserInfo().getAgentId()
        for id in customerAgentsID {
            for bean in LoginBean.shared.list_agent {
                if bean.id == id {
                    listAgent.append(bean)
                }
            }
        }
    }
    
    @IBAction func btnOKAction(_ sender: Any) {
        delegate.listAgencyViewControllerDidPick(listAgents: selectedAgents)
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ListAgencyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAgent.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ListAgentTableViewCell
        cell.selectionStyle = .none
        let agent = listAgent[indexPath.row]
        cell.loadAgent(agent)
        if self.isAgentSelected(agent: agent) {
            cell.select()
        } else {
            cell.notSelect()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let agent = listAgent[indexPath.row]
        if agent.id == "-1" {
            selectedAgents.removeAll()
            selectedAgents.append(agent)
        } else {
            if self.isAgentSelected(agent: agent) {
                let ind = self.indexOf(agent: agent, inList: selectedAgents)
                selectedAgents.remove(at: ind)
            } else {
                selectedAgents.append(agent)
            }
        }
        tbView.reloadData()
    }
}











