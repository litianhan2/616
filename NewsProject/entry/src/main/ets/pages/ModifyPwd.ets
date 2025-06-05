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
import RdbUtils from '../common/RdbUtils';
import { CommentItemStyle, NewsItemStyle, Title } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
import { CollectBean } from '../mode/CollectBean';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct ModifyPwd {

  @State account: string = '';
  @State oriPwd: string = '';
  @State inputOriPwd: string = '';
  @State newsPwd: string = '';
  @State comPwd: string = '';
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
      await RdbUtils.dataPreferences.get('password', '', function (err, val) {
        if (err) {
          console.error("Failed to get value of 'password'. code =" + err.code + ", message =" + err.message);
          return;
        }
        console.info("Succeeded in getting value of 'password'. val： " + val);
        if(val)
        {
          that.oriPwd = val.toString();
        }
      })
    } catch (err) {
      console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
    }
  }
  build() {
    Column() {
      Title({text:'修改密码'})
      TextInput({
        placeholder: '请输入原密码'
      })
        .width('80%')
        .type(InputType.Password)
        .margin({top:20})
        .onChange((val: string) => this.inputOriPwd = val)
      TextInput({
        placeholder: '请输入新密码'
      })
        .width('80%')
        .margin({top:20})
        .onChange((val: string) => this.newsPwd = val).type(InputType.Password)
      TextInput({
        placeholder: '请输入确认密码'
      })
        .width('80%')
        .margin({top:20})
        .onChange((val: string) => this.comPwd = val).type(InputType.Password)
      Button('修改')
        .width("80%")
        .backgroundColor('#ff080909')
        .margin({top:50})
        .onClick(() => {
          if(this.oriPwd != this.inputOriPwd)
          {
            promptAction.showToast({
              message: "原密码不对",
              duration: 3000
            })
            return
          }
          if(this.newsPwd != this.comPwd)
          {
            promptAction.showToast({
              message: "两次密码不一致",
              duration: 3000
            })
            return
          }
          RdbUtils.modifyPwd(this.account,this.oriPwd,{account:this.account,password:this.newsPwd}).then((updateNum:number) => {
            if(updateNum > 0)
            {
              promptAction.showToast({
                message: "修改成功",
                duration: 3000
              })
              router.pushUrl({url:'pages/Login'})
            }else{
              promptAction.showToast({
                message: "修改失败",
                duration: 3000
              })
            }
          })
        })
    }
  }
}
