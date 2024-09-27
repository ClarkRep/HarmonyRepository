class LifecycleDemoLogger {
  static TAG: string = "LifecycleDemoLogger -> "

  public static i(msg: string) {
    console.log(LifecycleDemoLogger.TAG + msg);
  }
}