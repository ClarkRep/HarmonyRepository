export class LoggerUtil {
  static debug(tag: string, message: string) {
    console.debug(tag + message);
  }

  static log(tag: string, message: string) {
    console.log(tag + message);
  }


  static info(tag: string, message: string) {
    console.info(tag + message);
  }

  static warn(tag: string, message: string) {
    console.warn(tag + message);
  }

  static error(tag: string, message: string) {
    console.error(tag + message);
  }
}