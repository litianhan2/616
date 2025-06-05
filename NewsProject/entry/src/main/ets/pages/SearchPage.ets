import router from '@ohos.router';
import RdbUtils from '../common/RdbUtils';
import { NewsItemStyle } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';

@Entry
@Component
export struct SearchPage {

  @Provide  newsList: Array<NewsBean> = new Array<NewsBean>();
  @State changeValue: string = '';
  @State submitValue: string = '';
  controller: SearchController = new SearchController();
  @State content: string = router.getParams()['data'];

  async  aboutToAppear(){
    console.log('-----------------'+this.content)
    await RdbUtils.search(this.content).then((list: Array<NewsBean>) => {
      this.newsList = list;
      console.log("查询到" + list.length + "条数据")
    }).catch((error) => {
      console.log("获取数据失败：" + error)
    })
  }
  build() {
    Column() {
      //顶部搜索栏
      Row() {
        Image($r('app.media.ic_back'))
          .height(32)
          .width(32)
          .margin({ left: 10 })
          .onClick(() =>{
            router.back()
          })
        Search({ value: this.changeValue, placeholder: '输入你想搜的', controller: this.controller })
          .searchButton('搜索')
          .width('80%')
          .height(40)
          .backgroundColor($r('app.color.home_search_btn_background'))
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onSubmit((value: string) => {
            this.submitValue = value;
            RdbUtils.search(value).then((list: Array<NewsBean>) => {
              this.newsList = list;
              console.log("查询到sssssssssss" + list.length + "条数据")
            }).catch((error) => {
              console.log("获取数据失败：" + error)
            })
          })
          .onChange((value: string) => {
            this.changeValue = value;
          })
          .margin(20)
      }.width('100%')
      .height('50')
      //搜索结果列表
      Row() {
        List({ space: 10, initialIndex: 0 }) {
         ForEach(this.newsList, (bean:NewsBean,index:number) => {
            ListItem() {
              NewsItemStyle({
                news_id:bean.id,
                image:bean.image,
                title:bean.title,
                m_desc:bean.mdesc,
                type:bean.type,
                time:bean.time
              })
            }
          }, bean => bean.id.toString())
        }
        .listDirection(Axis.Vertical) // 排列方向
        .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
        .chainAnimation(false) // 联动特效关闭
        .margin({bottom:60,top:80})
        .onScrollIndex((firstIndex: number, lastIndex: number) => {
          console.info('first' + firstIndex)
          console.info('last' + lastIndex)
        })
        .height('100%')
        .alignListItem(ListItemAlign.Start)
      }.width('100%')
      .height('100%')
      .borderColor(Color.Red)
      .backgroundColor($r('app.color.home_tabs_background'))

    }
    .width('100%')
    .height('100%')
  }

}