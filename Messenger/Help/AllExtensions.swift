//
//  ImgExtensions.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 10/05/2023.
//

import Foundation
import UIKit

extension UIImage{
    var isPortrait : Bool {return size.height > size.width}
    var isLandscape : Bool {return size.height < size.width}
    
    //return a minimum value of width and height to create a square
    var breadth: CGFloat {return min(size.width,size.height)}
    
    //make a squared from min amount, and cut
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth)}
    
    //Make a rectangle from breadSize
    var breadthRe: CGRect {return CGRect(origin: .zero, size: breadthSize)}
    
    var circleImage: UIImage?{
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        //set defer block to end graphich context when execution leave the scope
        defer{UIGraphicsEndImageContext()}
        
        //CREATE new cgImge by croppong the iamge to square size of breadthSzie
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height-size.width) / 2 ) : 0), size: breadthSize)) else{
            return nil
        }
        //Make a oval image, radious of BreadRe
        UIBezierPath(ovalIn: breadthRe).addClip()
        
        //draw image inside specific breadTh size rectangle
        UIImage(cgImage: cgImage).draw(in: breadthRe)
        
        
        //return the image from current image
        return UIGraphicsGetImageFromCurrentImageContext()
        
        }
    }

extension Date{
    func longDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        return dateFormatter.string(from: self)
    }
}
