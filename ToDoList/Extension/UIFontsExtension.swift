import UIKit
import SwiftUI

extension UIFont {
    static var body: UIFont? { UIFont(name: "SFProText-Regular", size: 17) }
    static var subHead: UIFont? { UIFont(name: "SFProText-Regular", size: 15) }
    static var footNote: UIFont? { UIFont(name: "SFProText-Semibold", size: 13) }
    static var largeTitle: UIFont? { UIFont(name: "SFProDisplay-Bold", size: 38) }
    static var title: UIFont? { UIFont(name: "SFProDisplay-Semibold", size: 20) }
    static var headLine: UIFont? { UIFont(name: "SFProText-Semibold", size: 17) }
}

extension Font {
    static var body: Font { Font.custom("SFProText-Regular", size: 17)}
    static var subHead: Font { Font.custom("SFProText-Regular", size: 15)}
    static var fNote: Font { Font.custom("SFProText-Semibold", size: 13)}
    static var lTitle: Font { Font.custom("SFProDisplay-Bold", size: 38)}
    static var title: Font { Font.custom("SFProDisplay-Semibold", size: 20)}
    static var headLine: Font { Font.custom("SFProText-Semibold", size: 17)}
}
