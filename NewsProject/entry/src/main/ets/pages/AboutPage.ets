/**
 * This template implements the about function and contains three components.
 * The top is the LogoAndVersion component, the middle shows the relevant information of the application, and the
 * bottom is the privacy agreement and copyright statement.
 * Developers can enrich the application information and improve the relevant link information.
 */
@Entry
@Component
struct AboutPage {
  build() {
    Column() {
      Navigation()
        .title(this.NavigationTitle())
        .hideToolBar(true)
        .height(30)
        .width('100%')
    }
  }

  @Builder NavigationTitle() {
    Text("关于")
      .fontSize(15)
      .fontColor(Color.Black)
      .fontWeight(500)
  }
}