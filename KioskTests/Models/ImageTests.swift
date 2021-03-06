import Quick
import Nimble
@testable
import Kiosk

let size = CGSize(width: 100, height: 100)

class ImageTests: QuickSpec {
    override func spec() {
        let id = "wah-wah"
        let url = "http://url.com"

        it("converts from JSON") {

            let imageFormats = ["big", "small", "patch"]
            let data:[String: AnyObject] = [ "id": id, "image_url": url, "image_versions": imageFormats, "original_width": size.width, "original_height": size.height]

            let image = Image.fromJSON(data)

            expect(image.id) == id
            expect(image.imageFormatString) == url
            expect(image.imageVersions.count) == imageFormats.count
            expect(image.imageSize) == size
        }

        it("generates a thumbnail url") {
            var image = self.imageForVersion("large")
            expect(image.thumbnailURL()).to(beAnInstanceOf(NSURL))

            image = self.imageForVersion("medium")
            expect(image.thumbnailURL()).to(beAnInstanceOf(NSURL))

            image = self.imageForVersion("larger")
            expect(image.thumbnailURL()).to(beAnInstanceOf(NSURL))
        }

        it("handles unknown image formats"){
            let image = self.imageForVersion("unknown")
            expect(image.thumbnailURL()).to(beNil())
        }

        it("handles incorrect image_versions JSON") {
            let data:[String: AnyObject] = [ "id": id, "image_url": url, "image_versions": "something invalid"]

            expect(Image.fromJSON(data)).toNot( throwError() )
        }

        it("assumes it's not default if not specified") {
            let image = Image.fromJSON([
                "id": "",
                "image_url":"http://image.com/:version.jpg",
                "image_versions" : ["small"],
                "original_width": size.width,
                "original_height": size.height
            ])

            expect(image.isDefault) == false
        }
    }

    func imageForVersion(version:String) -> Image {
        return Image.fromJSON([
            "id": "",
            "image_url":"http://image.com/:version.jpg",
            "image_versions" : [version],
            "original_width": size.width,
            "original_height": size.height
        ])
    }
}
