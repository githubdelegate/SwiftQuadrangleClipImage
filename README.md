# ZYQuadrangleClipImageView


![demo gif](https://github.com/githubdelegate/SwiftQuadrangleClipImage/blob/main/clipdemo.gif)


## Install

CocoaPods

```
 pod 'ZYQuadrangleClipImageView'
```

## Usage

```swift
  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        crop = ZYQuadRangleClipView()
        self.imv.addSubview(crop)
    }

    @IBAction func clipimgs(_ sender: Any) {
        if let cropimg =  self.crop.clipImage() {
            self.clipImv.image = cropimg
            UIView.animate(withDuration: 0.5) {
                self.clipImv.alpha = 1
                self.imv.alpha = 0
            }
        }
    }
```