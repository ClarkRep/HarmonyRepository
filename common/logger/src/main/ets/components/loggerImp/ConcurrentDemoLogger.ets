import { LoggerUtil } from '../LoggerUtil';

export class ConcurrentDemoLogger {
  static TAG: string = "ConcurrentDemoLogger -> "

  public static info(msg: string) {
    LoggerUtil.info(ConcurrentDemoLogger.TAG, msg);
  }

  public static error(msg: string) {
    LoggerUtil.error(ConcurrentDemoLogger.TAG, msg);
  }
}