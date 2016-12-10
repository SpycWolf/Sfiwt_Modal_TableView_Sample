import UIKit

class ViewController: UIViewController, ModalViewControllerDelegate {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var btnShowModal: UIButton!
    
    var masterData = ["hoge1","hoge2","hoge3"]
    var detailData = [["fuga1", "fuga2", "fuga3", "fuga4", "fuga5"],
                      ["fuga6", "fuga7", "fuga8", "fuga9", "fuga10"],
                      ["fuga11", "fuga12", "fuga13", "fuga14", "fuga15"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubview(toFront: baseView)
        view.bringSubview(toFront: modalView)
        baseView.isHidden = true
        modalView.isHidden = true
        baseView.alpha = 0
        modalView.alpha = 0
        modalView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestureTapViewModalBase))
        baseView.addGestureRecognizer(gesture)
    }

    @IBAction func actionBtnShowModal(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Modal", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()! as! ModalViewController
        // Master&Detail構成の場合false, Detailのみの場合はtureを指定
        viewController.isDetail = false
        // 複数選択の有無によってtureもしくはfalse
        viewController.allowsMultiple = true
        viewController.masterData = masterData
        viewController.detailData = detailData
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(viewController)
        self.view.addSubview(subView: viewController.view, toView: modalView)
        viewController.delegate = self
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.baseView.isHidden = false
            self.modalView.isHidden = false
            self.modalView.alpha = 1.0
            self.modalView.layer.borderWidth = 1.0
            self.modalView.layer.borderColor = UIColor.black.cgColor
            self.baseView.alpha = 0.5
            self.modalView.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        }, completion: { _ in
            self.modalView.transform = CGAffineTransform.identity
        })
    }
    
    func gestureTapViewModalBase() {
        hiddenModalView()
    }
    
    func modalDidFinished(selectedItem: [String]) {
        debugPrint(selectedItem)
        
        hiddenModalView()
    }
    
    func hiddenModalView() {
        baseView.isHidden = true
        modalView.isHidden = true
        baseView.alpha = 0
        modalView.alpha = 0
        modalView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

