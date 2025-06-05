import router from '@ohos.router'
import RdbUtils from '../common/RdbUtils'
import { Users } from '../mode/Users'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Login {
  @State account: string = ''
  @State password: string = ''

  build() {
    Column({ space: 10 }) {
      Image($r('app.media.ic_logo'))
        .width('100vp')
        .borderRadius(50)
        .margin({ top: 120 })

      TextInput({
        placeholder: '请输入账号'
      })
        .width(300)
        .onChange((val: string) => this.account = val)
      TextInput({
        placeholder: '请输入密码'
      })
        .width(300)
        .onChange((val: string) => this.password = val).type(InputType.Password)
      Button('登录')
        .width("80%")
        .backgroundColor('#ff080909')
        .margin({top:50})
        .onClick(() => {
          console.log(this.account+'--'+this.password)
          RdbUtils.queryUserByAccount(this.account).then((users: Users) => {
            if(users == null)
            {
              RdbUtils.insertOne("USERS",{
                account:this.account,
                password:this.password
              }) .then((updateNumber) => {
                console.log('插入成功:' + updateNumber)
                //保存缓存
                RdbUtils.saveCache('account',this.account)
                RdbUtils.saveCache('password',this.password)
                promptAction.showToast({
                  message: "注册成功",
                  duration: 3000
                })
                router.pushUrl({url:'pages/Index'})
              }).catch((error) => {
                console.log('插入失败:' + error)
                promptAction.showToast({
                  message: "注册失败",
                  duration: 3000
                })
              })

            }else
            {
              if(this.password != users.password)
              {
                promptAction.showToast({
                    message: "账号或密码错误",
                    duration: 3000
                })
              }else
              {
                 //将用户信息保存到缓存中
                 RdbUtils.saveCache('account',this.account)
                 RdbUtils.saveCache('password',this.password)
                 router.pushUrl({url:'pages/Index'})
              }
            }
          }).catch((error) => {
            console.log("获取数据失败：" + error)
          })

        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff38e8e')
  }
}