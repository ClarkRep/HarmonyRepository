import { common } from '@kit.AbilityKit';
import { taskpool } from '@kit.ArkTS';
import process from '@ohos.process';
import { FileOperationLogger } from '@clark/logger';
import {
  doReadFileAsyncAwait,
  doReadFileAsyncThen,
  doReadFileSync,
  doWriteFileAsyncAwait,
  doWriteFileAsyncThen,
  doWriteFileSync,
} from '@clark/file_util';

@Entry
@Component
struct Index {
  // 上下文
  private context = getContext(this) as common.UIAbilityContext;
  // 要访问的本地文件路径
  private filePath: string = this.context.filesDir + '/FileOperationTest.txt';
  // 要写入本地文件的内容
  private jsonStr: string = "HelloWorld";
  // 日志分割线
  private logDividerStr: string =
    "==================================================================================================================================";

  build() {
    RelativeContainer() {
      Column({ space: 20 }) {

        Button("async await 方式写文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            FileOperationLogger.info(this.logDividerStr);
            FileOperationLogger.info("async await 方式写文件：click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);

            // async await 方式写文件
            doWriteFileAsyncAwait(this.filePath, this.jsonStr).then(success => {
              FileOperationLogger.info("async await 方式写文件：调用结束" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid +
                "，success=" + success);
            })

            FileOperationLogger.info("async await 方式写文件：click()结束" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);
          })

        Button("async await 方式读文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            FileOperationLogger.info(this.logDividerStr);
            FileOperationLogger.info("async await 方式读文件：click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);

            // async await 方式读文件
            doReadFileAsyncAwait(this.filePath).then(readContent => {
              FileOperationLogger.info("async await 方式读文件：调用结束" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid +
                "，readContent=" + readContent);
            })

            FileOperationLogger.info("async await 方式读文件：click()结束" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);
          })

        Button("async then 方式写文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({ top: 30 })
          .onClick(() => {
            FileOperationLogger.info(this.logDividerStr);
            FileOperationLogger.info("async then 方式写文件：click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);

            doWriteFileAsyncThen(this.filePath, this.jsonStr).then(success => {
              FileOperationLogger.info("async then 方式写文件：调用结束" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid +
                "，success=" + success);
            })

            FileOperationLogger.info("async then 方式写文件：click()结束" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);
          })

        Button("async then 方式读文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            FileOperationLogger.info(this.logDividerStr);
            FileOperationLogger.info("async then 方式读文件：click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);

            // 同步调用方式
            doReadFileAsyncThen(this.filePath).then(readContent => {
              FileOperationLogger.info("async then 方式读文件：调用结束" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid +
                "，readContent=" + readContent);
            })

            FileOperationLogger.info("async then 方式读文件：click()结束" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);
          })

        Button("Concurrent 多线程方式写文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .margin({ top: 30 })
          .onClick(() => {
            FileOperationLogger.info(this.logDividerStr);
            FileOperationLogger.info("Concurrent 多线程方式写文件：click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);

            taskpool.execute(writeFileConcurrent, this.filePath, this.jsonStr).then(() => {
              FileOperationLogger.info("Concurrent 多线程方式写文件：执行结束" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid);
            }).catch((err: string) => {
              FileOperationLogger.error("Concurrent 多线程方式写文件：执行异常" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid + "，err=" + err);
            });

            // 测试直接传入非Promise方法，发现没有办法处理结果和异常情况。
            // taskpool.execute(writeFileConcurrent2, this.filePath, this.jsonStr).then(() => {
            //   FileOperationLogger.info("Concurrent 多线程方式写文件：执行结束" + "，process.pid=" + process.pid +
            //     "，process.tid=" +
            //   process.tid);
            // }).catch((err: string) => {
            //   FileOperationLogger.error("Concurrent 多线程方式写文件：执行异常" + "，process.pid=" + process.pid +
            //     "，process.tid=" +
            //   process.tid + "，err=" + err);
            // });

            FileOperationLogger.info("Concurrent 多线程方式写文件：click()结束" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);
          })

        Button("Concurrent 多线程方式读文件")
          .id('HelloWorld')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            FileOperationLogger.info(this.logDividerStr);
            FileOperationLogger.info("Concurrent 多线程方式读文件：click()开始" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);

            // 异步调用方式
            taskpool.execute(readFileConcurrent, this.filePath).then((result: Object) => {
              FileOperationLogger.info("Concurrent 多线程方式读文件：执行结束" + "，process.pid=" + process.pid +
                "，process.tid=" +
              process.tid + "，result=" + result);
            }).catch((err: string) => {
              FileOperationLogger.error("Concurrent 多线程方式读文件：执行异常" + "，process.pid=" + process.pid +
                "，process.tid=" +
                "，process.tid " + "，err=" + err);
            });

            FileOperationLogger.info("Concurrent 多线程方式读文件：click()结束" + "，process.pid=" + process.pid +
              "，process.tid=" +
            process.tid);
          })
      }.width('100%')
      .margin({ top: 50 })
    }
    .height('100%')
    .width('100%')
  }
}

/**
 * 并发调用写文件操作
 * @param filePath
 * @param writeInfo
 * @returns
 */
@Concurrent
async function writeFileConcurrent(filePath: string, writeInfo: string): Promise<boolean> {
  let ret: boolean = await new Promise((resolve, reject) => {
    try {
      let result = doWriteFileSync(filePath, writeInfo)
      resolve(result)
    } catch (e) {
      reject(e)
    }
  });
  return ret; // 支持。直接返回Promise的结果。
}

/**
 * 并发调用写文件操作，直接传递个非Promise方法进去，发现TaskPool就没办法回调数据了
 * @param filePath
 * @param writeInfo
 */
@Concurrent
async function writeFileConcurrent2(filePath: string, writeInfo: string): Promise<boolean> {
  return doWriteFileSync(filePath, writeInfo)
}

@Concurrent
async function readFileConcurrent(filePath: string): Promise<string> {
  let ret: string = await new Promise((resolve, reject) => {
    try {
      // 从文件读取一段内容
      let readContent: string = doReadFileSync(filePath)
      resolve(readContent);
    } catch (e) {
      reject(e)
    }
  });
  return ret; // 支持。直接返回Promise的结果。
}