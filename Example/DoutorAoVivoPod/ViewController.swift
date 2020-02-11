//
//  ViewController.swift
//  DoutorAoVivoPod
//
//  Created by fabiooh on 02/10/2020.
//  Copyright (c) 2020 fabiooh. All rights reserved.
//

import UIKit
import DoutorAoVivoPod

class ViewController: UIViewController {

    @IBOutlet weak var btDAV: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //btDAV.addTarget(self, action: #selector(openDavView), for: .touchUpInside)
    }
    
    @IBAction func openDavView(_ sender: AnyObject) {
        let DaVConsultorio = DavViewController()
        DaVConsultorio.DAV_URL_ACCESS = "https://demonstracao.dev.dav.med.br/accessroom/0ca387ce-e668-467c-a0aa-3345a2b5453c"
        DaVConsultorio.davColorPrimary = UIColor.white
        DaVConsultorio.davBackgroundActionsRoom = UIColor(red: 25/255.0 , green: 0, blue: 250/255.0, alpha: 1.0)
        DaVConsultorio.davBackgroundVideoHeaderParticipant = UIColor.darkGray
        DaVConsultorio.davTextColorVideoHeaderParticipant = UIColor.lightGray
        DaVConsultorio.davTextColorButtonActionsRoom = UIColor.white
        DaVConsultorio.davBackgroundButtonEndCallActionsRoom = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        DaVConsultorio.davBackgroundButtonActionsRoom = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        DaVConsultorio.davBackgroundBallonOtherColor = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        DaVConsultorio.davTextColorBallonOther = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        DaVConsultorio.davBackgroundBallonMineColor = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        DaVConsultorio.davTextColorballonMine = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        self.present(DaVConsultorio, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DavViewController
        {
            let vc = segue.destination as? DavViewController
            vc?.DAV_URL_ACCESS = "https://demonstracao.dev.dav.med.br/accessroom/0ca387ce-e668-467c-a0aa-3345a2b5453c"
            vc?.davColorPrimary = UIColor.white
            vc?.davBackgroundActionsRoom = UIColor(red: 25/255.0 , green: 45/255.0, blue: 175/255.0, alpha: 1.0)
            vc?.davBackgroundVideoHeaderParticipant = UIColor.darkGray
            vc?.davTextColorVideoHeaderParticipant = UIColor.lightGray
            vc?.davTextColorButtonActionsRoom = UIColor.white
            vc?.davBackgroundButtonEndCallActionsRoom = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
            vc?.davBackgroundButtonActionsRoom = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
            vc?.davBackgroundBallonOtherColor = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
            vc?.davTextColorBallonOther = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
            vc?.davBackgroundBallonMineColor = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
            vc?.davTextColorballonMine = UIColor(red: 255/255.0 , green: 0, blue: 13/255.0, alpha: 1.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

