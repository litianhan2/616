/*
 * Copyright (c) 2021 JianGuo Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import RdbUtils from '../common/RdbUtils';
import { CommentItemStyle, NewsItemStyle, Title } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
import { CollectBean } from '../mode/CollectBean';

@Entry
@Component
struct MyCollect {

  @State account: string = '';
  @State  newsList: Array<NewsBean> = new Array<NewsBean>();
  async aboutToAppear() {
    try {
      let that = this;
      await RdbUtils.dataPreferences.get('account', '', function (err, val) {
        if (err) {
          console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
          return;
        }
        console.info("Succeeded in getting value of 'account'. val： " + val);
        if(val)
        {
          that.account = val.toString();
        }
      })
      //查询收藏列表
      await RdbUtils.queryCollectByAccount(this.account).then((list: Array<CollectBean>) => {
        for ( var i = 0; i < list.length; i++) {
          RdbUtils.queryNewsByID(list[i].nid).then((newsBean:NewsBean) => {
            this.newsList.push(newsBean);
          })
        }
        console.log("查询到" + list.length + "条数据")
      }).catch((error) => {
        console.log("获取数据失败：" + error)
      })

    } catch (err) {
      console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
    }
  }
  build() {
    Column() {
      Title({text:'我的收藏'})
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
  }
}
