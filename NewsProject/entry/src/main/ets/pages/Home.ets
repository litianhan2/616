import router from '@ohos.router';
import RdbUtils from '../common/RdbUtils';
import { NewsItemStyle } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
import { NewsType } from '../mode/NewsType';

@Entry
@Component
export struct Home {

  private newsTypes: NewsType[] = [new NewsType(0,"热点",""),new NewsType(1,"社会",""),new NewsType(2,"娱乐",""),new NewsType(3,"体育",""),new NewsType(4,"美女",""),new NewsType(5,"科技",""),new NewsType(6,"体育",""),new NewsType(7,"时尚","")]
  @State currentTabIndex: number = 0
  @State  newsList: Array<NewsBean> = new Array<NewsBean>();
  @State changeValue: string = '';
  @State submitValue: string = '';
  @State loadData: boolean = false;
  controller: SearchController = new SearchController();

  @Builder
  BarItemBuilder(name: string, index: number) {
    Column() {
      Text(name)
        .fontSize(16)
        .fontColor(this.getTabBarColor(index))
        .fontWeight(this.currentTabIndex === index ? 500 : 300)
        .margin({ bottom: 7, top: 10 })
      Divider()
        .strokeWidth(2)
        .color(Color.Red)
        .width('40')
        .opacity(this.currentTabIndex === index ? 1 : 0)
    }

  }

  async aboutToAppear() {
    await RdbUtils.queryByType(0).then((list: Array<NewsBean>) => {
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
        Image($r('app.media.ic_logo'))
          .height(48)
          .width(48)
          .margin({ left: 20 })

        Search({ value: this.changeValue, placeholder: '输入你想搜的', controller: this.controller })
          .searchButton('搜索')
          .width('75%')
          .height(40)
          .backgroundColor($r('app.color.home_search_btn_background'))
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onSubmit((value: string) => {
            this.submitValue = value;
            console.log("-------------------"+value)
            router.pushUrl({ url: 'pages/SearchPage', params: { data: value } })
          })
          .onChange((value: string) => {
            this.changeValue = value;
          })
          .margin(20)
      }.width('100%')
      .height('50')
      .backgroundColor($r('app.color.home_title_background'))
      //新闻类型栏
      Row() {
        Tabs({ barPosition: BarPosition.Start }) {
          ForEach(this.newsTypes, (newsType: NewsType, index: number) => {
            TabContent() {
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
                }, item => item.id.toString())
              }
              .listDirection(Axis.Vertical) // 排列方向
              .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
              .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
              .chainAnimation(false) // 联动特效关闭
              .margin({bottom:60,top:10})
              .onScrollIndex((firstIndex: number, lastIndex: number) => {
                console.info('first' + firstIndex)
                console.info('last' + lastIndex)
              })
            }
            .tabBar(this.BarItemBuilder(newsType.name, index))
            .backgroundColor(Color.White)
            .height('100%')
          }, item => item.id.toString())
        }.barWidth('100%')
        .barHeight('40')
        .onChange((index:number) => {
          console.log(this.currentTabIndex+"-----------load-----------"+index)
          if(this.currentTabIndex != index)
          {
            this.getNewsDataByType(index)
          }
          this.currentTabIndex = index
        })

      }.width('100%')
      .height('100%')
      .borderColor(Color.Red)
      .backgroundColor($r('app.color.home_tabs_background'))

    }.alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }

  private getTabBarColor(index: number) {
    return this.currentTabIndex == index ? $r('app.color.bottom_btn_selected_background') : $r('app.color.bottom_btn_background')
  }

  private async  getNewsDataByType(newType:number)
  {
    await RdbUtils.queryByType(newType).then((news: Array<NewsBean>) => {
      this.newsList = news;
      console.log("查询到" + news.length + "条数据")
    }).catch((error) => {
      console.log("获取数据失败：" + error)
    })
  }
}