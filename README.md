# HPFastTouchButton
Resolve problem "Passing touch info from button to super view".

For example:

- Button in vieew.
- Button in scrollView, tableview, collectionview

With button in UIKit you can't scroll the scrollbar after button receive pan gesture. Just replace the original button by HPFastTouchButton, the problem will be solved.
Magic is here :")

### Use

HPFastTouchButton has the same protocols with UIButton in UIKit.
