import UIKit

public protocol ZoomableViewDelegate: AnyObject {
    func zoomableViewShouldZoom(_ view: ZoomableView) -> Bool
    func zoomableViewDidZoom(_ view: ZoomableView)
    func zoomableViewEndZoom(_ view: ZoomableView)
    func zoomableViewGetBackground(_ view: ZoomableView) -> UIView?
}

public struct ZoomableNotification {
    static let didZoom = Notification.Name("zoomableViewDidZoom")
    static let endZoom = Notification.Name("zoomableViewEndZoom")
}

public class ZoomableView: UIView {
    public weak var delegate: ZoomableViewDelegate?
    /// Enable/Disable zoom ability
    public var isEnableZoom = true
    
    /// View's zoom status
    public var isZooming = false
    
    /// Add/remove gesture if the view is/isn't zoomable
    public var isZoomable: Bool = false {
        didSet {
            if isZoomable {
                pinchGesture.map { removeGestureRecognizer($0) }
                panGesture.map { removeGestureRecognizer($0) }
                inititialize()
                isUserInteractionEnabled = true
                pinchGesture.map { addGestureRecognizer($0) }
                panGesture.map { addGestureRecognizer($0) }
            } else {
                pinchGesture.map { removeGestureRecognizer($0) }
                panGesture.map { removeGestureRecognizer($0) }
            }
        }
    }

    /// View's pinch gesture
    public var pinchGesture: UIPinchGestureRecognizer?

    /// View's pan gesture
    public var panGesture: UIPanGestureRecognizer?
    
    /// View's background when zooming
    public var backgroundView: UIView?
    
    /// ZoomableView is the superview of sourceView which will be zoomed when the gestures recognize
    /// sourceView is needed to set reference so as to be zoomed
    public var sourceView: UIView? {
        didSet {
            guard let sourceView = sourceView else { 
                return
            }
            self.subviews.forEach({ $0.removeFromSuperview() })
            self.addSubview(sourceView)
            sourceView.translatesAutoresizingMaskIntoConstraints = false
            sourceView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            sourceView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            sourceView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            sourceView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
    }
    
    /// View's scale
    private var scale: CGFloat = 1.0
    
    /// Background view when the view is zooming
    private func getBackgroundView() -> UIView {
        var backgroundView: UIView
        if let view = delegate?.zoomableViewGetBackground(self) {
            backgroundView = view
        } else {
            // default background view
            backgroundView = UIView(frame: UIScreen.main.bounds)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
        if let pinchSourceView = sourceView {
            let rect = pinchSourceView.convert(pinchSourceView.bounds, to: UIApplication.shared.getKeyWindow())
            backgroundView.addSubview(pinchSourceView)
            pinchSourceView.translatesAutoresizingMaskIntoConstraints = true
            pinchSourceView.frame = rect
        }
        self.backgroundView = backgroundView
        return backgroundView
    }

    /// Initialize pinch & pan gestures
    private func inititialize() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(imagePinched(_:)))
        pinchGesture?.delegate = self
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(imagePanned(_:)))
        panGesture?.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reset),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    /// Perform the pinch to zoom if needed.
    ///
    /// - Parameter sender: UIPinvhGestureRecognizer
    @objc private func imagePinched(_ pinch: UIPinchGestureRecognizer) {
        if !isEnableZoom || !(delegate?.zoomableViewShouldZoom(self) ?? true) {
            return
        }
        if pinch.state == .began {
            isZooming = true
            sourceView?.translatesAutoresizingMaskIntoConstraints = true
            UIApplication.shared.getKeyWindow()?.addSubview(getBackgroundView())
            delegate?.zoomableViewDidZoom(self)
            NotificationCenter.default.post(name: ZoomableNotification.didZoom, object: nil, userInfo: ["view": self])
        }
        if pinch.state == .changed {
            if pinch.scale >= 1.0 {
                scale = pinch.scale
                transform(withTranslation: .zero)
            }
        }
        if pinch.state != .ended { return }
        reset()
    }

    /// Perform the panning if needed
    @objc private func imagePanned(_ pan: UIPanGestureRecognizer) {
        if !isEnableZoom || !(delegate?.zoomableViewShouldZoom(self) ?? true) {
            return
        }
        if scale > 1.0 {
            transform(withTranslation: pan.translation(in: self))
        }
    }
    
    /// Set the image back to it's initial state.
    @objc func reset() {
        scale = 1.0
        self.backgroundView?.backgroundColor = .clear
        UIView.animate(withDuration: 0.35) {
            self.sourceView?.transform = .identity
        } completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.backgroundView?.removeFromSuperview()
            if let zoomableSourceView = self.sourceView {
                self.addSubview(zoomableSourceView)
                zoomableSourceView.translatesAutoresizingMaskIntoConstraints = false
                zoomableSourceView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                zoomableSourceView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                zoomableSourceView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                zoomableSourceView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }
            self.isZooming = false
            self.delegate?.zoomableViewEndZoom(self)
            NotificationCenter.default.post(name: ZoomableNotification.endZoom, object: nil, userInfo: ["view": self])
        }
    }

    /// Will transform the image with the appropriate
    private func transform(withTranslation translation: CGPoint) {
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, scale, scale, 1.0)
        transform = CATransform3DTranslate(transform, translation.x, translation.y, 0)
        sourceView?.layer.transform = transform
    }
}

extension ZoomableView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ZoomableViewDelegate {
    func zoomableViewGetBackground(_ view: ZoomableView) -> UIView? {
        return nil
    }
}

public extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}

public protocol ZoomableTableViewCell: UITableViewCell {
    var zoomableView: ZoomableView { get }
}

public class ZoomableTableView: UITableView {
    public func stopZooming() {
        for cell in visibleCells {
            if let cell = cell as? ZoomableTableViewCell {
                cell.zoomableView.reset()
            }
        }
    }

    public override func reloadData() {
        stopZooming()
        super.reloadData()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(disableScroll(_:)),
            name: ZoomableNotification.didZoom,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableScroll(_:)),
            name: ZoomableNotification.didZoom,
            object: nil
        )
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(disableScroll(_:)),
            name: ZoomableNotification.didZoom,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableScroll(_:)),
            name: ZoomableNotification.didZoom,
            object: nil
        )
    }
    
    @objc private func disableScroll(_ notification: NSNotification?) {
        if let userInfo = notification?.userInfo,
           let view = userInfo["view"] as? ZoomableView,
           view.isDescendant(of: self) {
            isScrollEnabled = false
        }
    }
    
    @objc private func enableScroll(_ notification: NSNotification?) {
        if let userInfo = notification?.userInfo,
           let view = userInfo["view"] as? ZoomableView,
           view.isDescendant(of: self) {
            isScrollEnabled = true
        }
    }
}
