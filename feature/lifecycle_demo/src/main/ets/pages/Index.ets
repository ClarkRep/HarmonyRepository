@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    console.log("LifecycleDemo -> Index.aboutToAppear()")
  }

  aboutToDisappear(): void {
    console.log("LifecycleDemo -> Index.aboutToDisappear()")
  }

  onPageShow(): void {
    console.log("LifecycleDemo -> Index.onPageShow()")
  }

  onPageHide(): void {
    console.log("LifecycleDemo -> Index.onPageHide()")
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}