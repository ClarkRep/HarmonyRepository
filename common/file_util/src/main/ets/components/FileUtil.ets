import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { FileOperationLogger } from '@clark/logger';
import process from '@ohos.process';

export class FileUtil {
}

/**
 * 同步执行文件写操作
 * @param filePath
 * @param writeInfo
 */
export function doWriteFileSync(filePath: string, writeInfo: string): boolean {
  let exist = fs.accessSync(filePath, fs.OpenMode.READ_ONLY);
  FileOperationLogger.info("FileUtil.doWriteFileSync()" + "，process.tid=" + process.tid + "，文件是否存在：exist=" +
    exist);
  if (exist) {
    // 文件存在，需要先删除
    fs.unlinkSync(filePath);
    // 删除成功
    FileOperationLogger.info("FileUtil.doWriteFileSync()" + "，process.tid=" + process.tid + "，删除文件完成：exist=" +
      exist);
  } else {
    // 文件不存在
  }
  // 将内容写入文件
  let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let writeLen = fs.writeSync(file.fd, writeInfo);
  FileOperationLogger.info("FileUtil.doWriteFileSync()" + "，process.tid=" + process.tid + "，写入文件完成：writeLen=" +
    writeLen);
  // 关闭文件
  fs.closeSync(file);
  return true
}

/**
 * async await 写文件
 * @param filePath
 * @param writeInfo
 * @returns
 */
export async function doWriteFileAsyncAwait(filePath: string, writeInfo: string): Promise<boolean> {
  let exist = await fs.access(filePath, fs.OpenMode.READ_ONLY);
  FileOperationLogger.info("FileUtil.doWriteFileAsyncAwait()" + "，process.tid=" + process.tid +
    "，文件是否存在：exist=" + exist);
  if (exist) {
    // 文件存在，需要先删除
    let unlink = await fs.unlink(filePath);
    // 删除成功
    FileOperationLogger.info("FileUtil.doWriteFileAsyncAwait()" + "，process.tid=" + process.tid +
      "，删除文件完成");
  } else {
    // 文件不存在
  }
  // 将内容写入文件
  let openFile = await fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  let writeLength = await fs.write(openFile.fd, writeInfo);
  FileOperationLogger.info("FileUtil.doWriteFileAsyncAwait()" + "，process.tid=" + process.tid +
    "，写入文件完成：writeLength=" + writeLength);
  // 关闭文件
  await fs.close(openFile);
  return true;
}

/**
 * async then 写文件
 * @param filePath
 * @param writeInfo
 */
export async function doWriteFileAsyncThen(filePath: string, writeInfo: string): Promise<boolean> {
  let result = await new Promise<boolean>((resolve, reject) => {
    let existPromise = fs.access(filePath, fs.OpenMode.READ_ONLY);
    existPromise.then(exist => {
      FileOperationLogger.info("FileUtil.doWriteFileAsyncThen()" + "，process.tid=" + process.tid + "，文件是否存在：exist=" +
        exist);
      if (exist) {
        // 文件存在，需要先删除
        let unlinkPromise = fs.unlink(filePath);
        unlinkPromise.then(() => {
          // 删除成功
          FileOperationLogger.info("FileUtil.doWriteFileAsyncThen()" + "，process.tid=" + process.tid +
            "，删除文件完成：exist=" +
            exist);
          // 将内容写入文件
          let openPromise = fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          openPromise.then(openFile => {
            let writePromise = fs.write(openFile.fd, writeInfo);
            writePromise.then(writeLen => {
              FileOperationLogger.info("FileUtil.doWriteFileAsyncThen()" + "，process.tid=" + process.tid +
                "，写入文件完成：writeLen=" +
                writeLen);
              // 关闭文件
              fs.close(openFile);
              resolve(true);
            })
          })
        })
      } else {
        // 文件不存在
        // 将内容写入文件
        let openPromise = fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        openPromise.then(openFile => {
          let writePromise = fs.write(openFile.fd, writeInfo);
          writePromise.then(writeLen => {
            FileOperationLogger.info("FileUtil.doWriteFileAsyncThen()" + "，process.tid=" + process.tid +
              "，写入文件完成：writeLen=" + writeLen);
            // 关闭文件
            fs.close(openFile);
            resolve(true);
          })
        })
      }
    })
  })
  return result;
}

/**
 * 同步方式读文件
 * @param filePath
 * @returns
 */
export function doReadFileSync(filePath: string): string {
  // 从文件读取一段内容
  let readContent: string = ""
  let exist = fs.accessSync(filePath, fs.OpenMode.READ_ONLY)
  FileOperationLogger.info("FileUtil.doReadFileSync()" + "，process.tid=" + process.tid + "，文件是否存在：exist=" +
    exist);
  if (exist) {
    // 文件存在，直接读取
    let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    let arrayBuffer = new ArrayBuffer(1024);
    let readOptions: ReadOptions = {
      offset: 0,
      length: arrayBuffer.byteLength
    };
    let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
    let buf = buffer.from(arrayBuffer, 0, readLen);
    readContent = buf.toString()
    FileOperationLogger.info("FileUtil.doReadFileSync()" + "，process.tid=" + process.tid +
      "，文件存在，读取内容：readContent=" +
      readContent);
    // 关闭文件
    fs.closeSync(file);
  } else {
    // 文件不存在，报错
    FileOperationLogger.info("FileUtil.doReadFileSync()" + "，process.tid=" + process.tid + "，异常：文件不存在");
  }
  return readContent;
}


/**
 * async await 方式读文件
 * @param filePath
 * @returns
 */
export async function doReadFileAsyncAwait(filePath: string): Promise<string> {
  // 从文件读取一段内容
  let readContent: string = ""
  let exist = await fs.access(filePath, fs.OpenMode.READ_ONLY)
  FileOperationLogger.info("FileUtil.doReadFileAsyncAwait()" + "，process.tid=" + process.tid + "，文件是否存在：exist=" +
    exist);
  if (exist) {
    // 文件存在，直接读取
    let openFile = await fs.open(filePath, fs.OpenMode.READ_ONLY);
    let arrayBuffer = new ArrayBuffer(1024);
    let readOptions: ReadOptions = {
      offset: 0,
      length: arrayBuffer.byteLength
    };
    let readLen = await fs.read(openFile.fd, arrayBuffer, readOptions);
    let buf = buffer.from(arrayBuffer, 0, readLen);
    readContent = buf.toString()
    FileOperationLogger.info("FileUtil.doReadFileAsyncAwait()" + "，process.tid=" + process.tid +
      "，文件存在，读取内容：readContent=" +
      readContent);
    // 关闭文件
    await fs.close(openFile);
  } else {
    // 文件不存在，报错
    FileOperationLogger.info("FileUtil.doReadFileAsyncAwait()" + "，process.tid=" + process.tid + "，异常：文件不存在");
  }
  return readContent;
}

/**
 * async then 方式读文件
 * @param filePath
 * @returns
 */
export async function doReadFileAsyncThen(filePath: string): Promise<string> {
  let content = await new Promise<string>((resolve, reject) => {
    fs.access(filePath, fs.OpenMode.READ_ONLY).then(exist => {
      FileOperationLogger.info("FileUtil.doReadFileAsyncThen()" + "，process.tid=" + process.tid +
        "，文件是否存在：exist=" +
        exist);
      if (exist) {
        fs.open(filePath, fs.OpenMode.READ_ONLY).then(openFile => {
          let arrayBuffer = new ArrayBuffer(1024);
          let readOptions: ReadOptions = {
            offset: 0,
            length: arrayBuffer.byteLength
          };
          fs.read(openFile.fd, arrayBuffer, readOptions).then(readLen => {
            let buf = buffer.from(arrayBuffer, 0, readLen);
            let readContent = buf.toString()
            FileOperationLogger.info("FileUtil.doReadFileAsyncThen()" + "，process.tid=" + process.tid +
              "，文件存在，读取内容：readContent=" +
              readContent);
            fs.close(openFile);
            resolve(readContent);
          });
        });
      } else {
        FileOperationLogger.info("FileUtil.doReadFileAsyncThen()" + "，process.tid=" + process.tid +
          "，异常：文件不存在");
        reject(new Error("FileUtil.doReadFileAsyncThen()文件不存在，filePath=" + filePath));
      }
    })
  })
  return content;
}