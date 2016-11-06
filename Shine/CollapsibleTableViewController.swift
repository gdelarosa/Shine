//
//  CollapsibleTableViewController.swift
//  Shine
//
//  Created by Gina De La Rosa on 9/21/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = duration
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = kCAFillModeForwards
        
        if let delegate: AnyObject completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

class CollapsibleTableViewController: UITableViewController {

    struct Section {
        var name: String!
        var details: [String]!
        var collapsed: Bool!
        
        init(name: String, details: [String], collapsed: Bool = false) {
            self.name = name
            self.details = details
            self.collapsed = collapsed
        }
    }
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            Section(name: "Detailed List", details: []),
            Section(name: "McDonald/Wright Building", details: ["1625 N. Schrader Blvd.", "323-993-7400", "lalgbtcenter.org", "M-F 9am-9pm, Saturday 9am-1pm", "Family Violence/STOP Domestic Violence, Health Services, Human Resources, Mental Health/Counseling"]),
            Section(name: "The Village at Ed Gould Plaza", details: ["1125 N. McCadden Place", "M-F 6pm-10pm, Sat 9am-5pm",  "AIDS/LifeCycle, Conversation Groups, Senior Services"]),
            Section(name: "Youth Center on Highland", details: [ "1220 N. Highland Ave.", "323-860-2280", "M-F 8:30am-5:30pm", "Clothing, Food, Showers, Counseling and Social Services"]),
            Section(name: "Los Angeles LGBT Center We-Ho", details: ["8745 Santa Monica Blvd, 2nd Floor", "323-993-7440", "M-F 11am-2:30pm, 4pm-7pm. 4th Wednesday of even numbered months: 11am-2:30pm", "HIV/STD Testing, STD Treatment, PrEP and PEP"]),
            Section(name: "Highland Annex", details: ["1220 N. Highland Ave", "Hours vary by program", "Legal Services, LifeWorks, RISE - Foster Youth Services"]),
            Section(name: "Mi Centro", details: ["553 S. Clarence St.", "M-F 9am-5pm", "Legal Immigation Services, Senior Services, Transgender Support Servies"]),
            Section(name: "Triangle Square", details: ["1602 Ivar Ave", "Senior Services, Affordable Housing"]),
            Section(name: "The Village Family", details: ["6801 Goldwater Canyon"]),
            Section(name: "Los Angeles Youth", details: ["17545 Taft Ave"]),
            Section(name: "Safe Place For Youth", details: ["2469 Lincoln Blvd", "https://safeplaceforyouth.org/"]),
            Section(name: "Bienestar East Los Angeles Center", details: ["5326 E. Beverly Blvd", "323-727-7985", "Tue 11am-2:45pm, Thur 12pm-1:45pm, 3pm-4:45pm", "Food bank is closed on the 5th Tuesday and 5th Thursday of each month and holidays"]),
            Section(name: "My Friend's Place", details: ["5850 Hollywood Blvd", "323-908-0011", "http://myfriendsplace.org/", "M-F 9am-5:30pm", "Homeless Youth Services"]),
            Section(name: "Friends Community Center", details: ["1419 N. La Brea", "323-463-1601", "Health Services and Research"]),
            Section(name: "COLORS", details: ["400 CorporatePointe, Culver City", "323-953-5130", "http://www.colorsyouth.org/", "Youth Counseling and psychotherapy services under 25"]),
            Section(name: "Covenant House", details: ["1325 N. Western Ave, Hollywood", "323-461-3131","http://covenanthousecalifornia.org/", "24hrs/365 days of the year", "Shelter, Medical, Mental Health, Life Skills"])
        ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section].collapsed!) ? 0 : sections[section].details.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! CollapsibleTableViewHeader
        
        header.toggleButton.tag = section
        header.titleLabel.text = sections[section].name
        header.toggleButton.rotate(sections[section].collapsed! ? 0.0 : CGFloat(M_PI_2))
        header.toggleButton.addTarget(self, action: #selector(CollapsibleTableViewController.toggleCollapse), for: .touchUpInside)
        
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        cell?.textLabel?.text = sections[(indexPath as NSIndexPath).section].details[(indexPath as NSIndexPath).row]
        
        return cell!
    }
    
    func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed!
        
        // Reload section
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
}
