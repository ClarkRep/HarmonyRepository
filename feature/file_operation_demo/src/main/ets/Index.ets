import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  async createFile() {
    const context = getContext(this)
    const filesDir = context.filesDir;
    // 新建并打开文件
    const file = await fs.open(filesDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    // 写入一段内容至文件
    let writeLen = await fs.write(file.fd, "Try to write str.");
    console.info("测试The length of str is: " + writeLen);
    // 从文件读取一段内容
    let arrayBuffer = new ArrayBuffer(1024);
    let readOptions: ReadOptions = {
      offset: 0,
      length: arrayBuffer.byteLength
    };
    let readLen = await fs.read(file.fd, arrayBuffer, readOptions);
    let buf = buffer.from(arrayBuffer, 0, readLen);
    fs.close(file);
    console.info("测试 the content of file: " + buf.toString());
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
        .onClick(() => {
          console.log('测试start')
          this.createFile()
          console.log('测试end')
        })
    }
    .height('100%')
    .width('100%')
  }
}