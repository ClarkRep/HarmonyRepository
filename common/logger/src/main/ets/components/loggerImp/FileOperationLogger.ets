import { LoggerUtil } from '../LoggerUtil';

export class FileOperationLogger {
  static TAG: string = "FileOperationLogger -> "

  public static info(msg: string) {
    LoggerUtil.info(FileOperationLogger.TAG, msg);
  }

  public static error(msg: string) {
    LoggerUtil.error(FileOperationLogger.TAG, msg);
  }
}