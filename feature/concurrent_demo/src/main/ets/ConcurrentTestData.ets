/**
 * 用来测试多线程并发传递的数据对象
 */
"use shared"

@Sendable
export class ConcurrentTestData {
  id: number | null = null
  title: string | null = null
  desc: string | null = null

  getTestId(): number {
    return 0;
  }
}