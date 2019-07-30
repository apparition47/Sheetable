# Sheetable

Present any UIViewController as a bottom sheet modal with interactive dismissal.

Originally based on [HalfModalPresentationController](https://github.com/martinnormark/HalfModalPresentationController).

![Demo](https://user-images.githubusercontent.com/47551890/62125201-74f70700-b307-11e9-8d9a-41cb92734ed8.gif)

# How to use

1. Conform the `UIViewController` you want to present as a bottom sheet modal to `Sheetable`. 
**[Optional]** Override `height` to how much of the screen you want your view to take up from the bottom.

```swift
class DetailViewController: UIViewController {}

extension DetailViewController: Sheetable { // <--
    var height: CGFloat { return 400 } // optional
}
```

2. Before presenting your `UIViewController` from the nav stack, call `setTransitioningDelegate()`.

```swift
class HomeViewController: UIViewController {
    @IBAction func showModalButtonPressed(_ sender: Any) {
        let vc = DetailViewController()
        vc.setTransitioningDelegate() // <--
        navigationController.present(vc, animated: true)
    }
}
```

# License

MIT
