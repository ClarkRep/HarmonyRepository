import { ConcurrentTestData } from '../ConcurrentTestData';
import { taskpool } from '@kit.ArkTS';
import { ConcurrentDemoLogger } from '@clark/logger';
import process from '@ohos.process';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Column({ space: 20 }) {

        Button("多线程传递对象作为参数")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            ConcurrentDemoLogger.info("获取子线程对象数据click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" + process.tid)
            taskpool.execute(getResultFromSubThread, 1).then(resultData => {
              if (resultData instanceof ConcurrentTestData) {
                ConcurrentDemoLogger.info("获取子线程对象数据回调" +
                  "，process.pid=" + process.pid + "，process.tid=" + process.tid +
                  "，resultData=+"
                  + "{id:" + resultData.id + ",title:" + resultData.title + ",desc=" + resultData.desc +
                  ", resultData.getTestId()=" + resultData.getTestId() + "}");
              } else {
                ConcurrentDemoLogger.info("获取子线程对象数据回调" +
                  "，process.pid=" + process.pid + "，process.tid=" + process.tid +
                  "，类型转换不匹配：resultData=" + resultData);
              }
            }).catch((e: string) => {
              ConcurrentDemoLogger.info("获取子线程对象数据回调异常：" +
                "，process.pid=" + process.pid + "，process.tid=" + process.tid +
                "，e=" + e);
            })
          })

        Button("同步读文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {

          })

        Button("异步写文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {

          })

        Button("异步读文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {

          })
      }.width('100%')
      .margin({ top: 50 })
    }
    .height('100%')
    .width('100%')
  }
}

@Concurrent
async function getResultFromSubThread(id: number): Promise<ConcurrentTestData> {
  let responsePromise: ConcurrentTestData = await new Promise((resolve, reject) => {
    let resultData = new ConcurrentTestData()
    resultData.id = id;
    resultData.title = "我是测试数据 title"
    resultData.desc = "我是测试数据 desc"
    resolve(resultData)
  });
  return responsePromise;
}
