//: Playground - noun: a place where people can play
//: Author: Josue Aviles Vera
import UIKit

let sampleImage = UIImage(named: "sample")!

// Process the image!
class Image {
    var image = UIImage()
    
    init (myImage: UIImage) {
        image = myImage
    }
    
    func averageColors(avgImage: UIImage) -> Dictionary<String, Int> {
        var thisMyRGBA = RGBAImage(image: avgImage)!
        var totalBlue = 0
        var totalRed = 0
        var totalGreen = 0
        for y in 0..<thisMyRGBA.height {
            for x in 0..<thisMyRGBA.width {
                let index = y * thisMyRGBA.width + x
                var pixel  = thisMyRGBA.pixels[index]
                totalBlue += Int(pixel.blue)
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
            }
        }
    
        let count = thisMyRGBA.height * thisMyRGBA.width
        let avgRed = totalRed/count
        let avgBlue = totalBlue/count
        let avgGreen = totalGreen/count
        return ["red": avgRed, "blue": avgBlue, "green": avgGreen]
    }
    
    func Filter (filter: String, intensity: Int)->UIImage{
        
        var RGBAinstaImage = RGBAImage(image: image)!
        
        switch filter {
            case "bw":
                for y in 0..<RGBAinstaImage.height{
                    for x in 0..<RGBAinstaImage.width{
                        let index = y*RGBAinstaImage.width + x
                        var pixel = RGBAinstaImage.pixels[index]
                    
                        let red = Int(pixel.red)
                        let blue = Int(pixel.blue)
                        let green = Int(pixel.green)
                        let greyUInt8 = UInt8((red+blue+green)/3)
                    
                        pixel.red = greyUInt8
                        pixel.blue = greyUInt8
                        pixel.green = greyUInt8
                    
                        RGBAinstaImage.pixels[index] = pixel
                    
                    }
                
                }
            
        case "ct":
            for y in 0..<RGBAinstaImage.height{
                for x in 0..<RGBAinstaImage.width{
                    let index = y*RGBAinstaImage.width + x
                    var pixel = RGBAinstaImage.pixels[index]
                    let factor = (259 * (intensity + 255)) / (255 * (259 - intensity))
                    let red = Int(pixel.red)
                    let blue = Int(pixel.blue)
                    let green = Int(pixel.green)
                    pixel.red = UInt8(max(0,min(255,factor * (red   - 128) + 128)))
                    pixel.green = UInt8(max(0,min(255,factor * (green   - 128) + 128)))
                    pixel.blue  = UInt8(max(0,min(255,factor * (blue   - 128) + 128)))
                    RGBAinstaImage.pixels[index] = pixel
                    
                }
            }

        case "cl":
            for y in 0..<RGBAinstaImage.height{
                for x in 0..<RGBAinstaImage.width{
                    let index = y*RGBAinstaImage.width + x
                    var pixel = RGBAinstaImage.pixels[index]
                    let alpha = Int(pixel.alpha)
                    pixel.alpha=UInt8(alpha/intensity)
                    RGBAinstaImage.pixels[index]=pixel
                }
            }
            
        case "s":
            var RGBaverage: [String: Int] = averageColors(image)
            let avgRed = RGBaverage["red"]!
            let avgBlue = RGBaverage["blue"]!
            let avgGreen = RGBaverage["green"]!
            for y in 0..<RGBAinstaImage.height {
                for x in 0..<RGBAinstaImage.width {
                    let index = y * RGBAinstaImage.height + x
                    var pixel = RGBAinstaImage.pixels[index]
                    let greenDiff = Int(pixel.green) - avgGreen
                    let redDiff = Int(pixel.red) - avgRed
                    let blueDiff = Int(pixel.blue) - avgBlue
                    pixel.green = UInt8( max(0, min(250, avgGreen + greenDiff / intensity  ) ) )
                    pixel.blue = UInt8( max(0, min(250, avgBlue + blueDiff / intensity ) ) )
                    pixel.red = UInt8( max(0, min(250, avgRed + redDiff / intensity ) ) )
                    RGBAinstaImage.pixels[index] = pixel
                }
            }
            
        default:
            print ("No filter.")
        }

        
        return RGBAinstaImage.toUIImage()!
        
    }
    
}


var testBlacknWhiteFilter = Image(myImage: sampleImage)
let FilteredImage = testBlacknWhiteFilter.Filter("bw", intensity: 0)

var testContrastAdjusmentFilter = Image(myImage: sampleImage)
let FilteredImage2 = testContrastAdjusmentFilter.Filter("ct", intensity: 128)


var testClarityDecreasing = Image(myImage: sampleImage)
let FilteredImage3 = testClarityDecreasing.Filter("cl",intensity: 2)

var testSephia = Image(myImage: sampleImage)
let FilteredImage4 = testSephia.Filter("s", intensity: 3)
