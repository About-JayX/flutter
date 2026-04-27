export class TimeUtil {
  /**
   * 统一时间格式化：将任何时间格式转换为 "YYYY-MM-DD HH:mm:ss" 格式
   */
  static formatTime(timeInput: string | Date | number): string {
    const date = this.parseTime(timeInput);
    
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  /**
   * 解析各种时间格式为 Date 对象
   */
  static parseTime(timeInput: string | Date | number): Date {
    if (timeInput instanceof Date) {
      return timeInput;
    }

    if (typeof timeInput === 'number') {
      return new Date(timeInput);
    }

    if (typeof timeInput === 'string') {
      let date: Date;

      // 1. 处理 ISO 格式：2025-10-10T12:01:00.000Z
      if (timeInput.includes('T')) {
        date = new Date(timeInput);
        if (!isNaN(date.getTime())) return date;
      }

      // 2. 处理目标格式：2025-10-10 12:01:00
      if (timeInput.match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/)) {
        // 直接解析，不添加时区信息
        const [datePart, timePart] = timeInput.split(' ');
        const [year, month, day] = datePart.split('-').map(Number);
        const [hours, minutes, seconds] = timePart.split(':').map(Number);
        
        date = new Date(year, month - 1, day, hours, minutes, seconds);
        if (!isNaN(date.getTime())) return date;
      }

      // 3. 处理带时区的格式：2025-10-10T12:01:00+08:00
      if (timeInput.match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[-+]\d{2}:\d{2}$/)) {
        date = new Date(timeInput);
        if (!isNaN(date.getTime())) return date;
      }

      // 4. 处理其他常见格式
      // 尝试直接解析
      date = new Date(timeInput);
      if (!isNaN(date.getTime())) return date;

      // 5. 尝试添加时间部分
      if (timeInput.match(/^\d{4}-\d{2}-\d{2}$/)) {
        date = new Date(timeInput + 'T00:00:00');
        if (!isNaN(date.getTime())) return date;
      }

      throw new Error(`无法解析的时间格式: ${timeInput}`);
    }

    throw new Error(`不支持的时间输入类型: ${typeof timeInput}`);
  }

  /**
   * 计算两个时间的时间差（毫秒）
   * @param time1 时间1
   * @param time2 时间2（默认为当前时间）
   * @returns 时间差（毫秒），time1 - time2
   */
  static calculateTimeDiff(
    time1: string | Date | number, 
    time2?: string | Date | number
  ): number {
    const date1 = this.parseTime(time1);
    const date2 = time2 ? this.parseTime(time2) : new Date();
    
    return date1.getTime() - date2.getTime();
  }

  /**
   * 计算两个时间的时间差（格式化显示）
   */
  static formatTimeDiff(
    time1: string | Date | number, 
    time2?: string | Date | number
  ): string {
    const diffMs = this.calculateTimeDiff(time1, time2);
    return this.formatDuration(diffMs);
  }

  /**
   * 格式化时间间隔
   */
  static formatDuration(milliseconds: number): string {
    const absMs = Math.abs(milliseconds);
    const sign = milliseconds < 0 ? '-' : '';
    
    if (absMs <= 0) return '0秒';

    const seconds = Math.floor(absMs / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (days > 0) {
      return `${sign}${days}天 ${hours % 24}小时 ${minutes % 60}分钟`;
    } else if (hours > 0) {
      return `${sign}${hours}小时 ${minutes % 60}分钟 ${seconds % 60}秒`;
    } else if (minutes > 0) {
      return `${sign}${minutes}分钟 ${seconds % 60}秒`;
    } else {
      return `${sign}${seconds}秒`;
    }
  }

  /**
   * 检查时间是否在未来
   */
  static isFuture(time: string | Date | number): boolean {
    return this.calculateTimeDiff(time) > 0;
  }

  /**
   * 检查时间是否在过去
   */
  static isPast(time: string | Date | number): boolean {
    return this.calculateTimeDiff(time) < 0;
  }

  /**
   * 获取当前时间的格式化字符串
   */
  static nowFormatted(): string {
    return this.formatTime(new Date());
  }

  /**
   * 在指定时间上添加时间间隔
   */
  static addTime(
    time: string | Date | number, 
    durationMs: number
  ): string {
    const date = this.parseTime(time);
    const newDate = new Date(date.getTime() + durationMs);
    return this.formatTime(newDate);
  }
  static addTimeDate(
    time: string | Date | number, 
    durationMs: number
  ): Date {
    const date = this.parseTime(time);
    const newDate = new Date(date.getTime() + durationMs);
    return newDate;
  }
  // function addSeconds(date: Date, seconds: number): Date {
  //     return new Date(date.getTime() + seconds * 1000);
  // }

  /**
   * 验证时间格式是否正确
   */
  static isValidTime(timeInput: string | Date | number): boolean {
    try {
      this.parseTime(timeInput);
      return true;
    } catch {
      return false;
    }
  }

  /**
   * 比较两个时间
   * @returns 1: time1 > time2, 0: time1 = time2, -1: time1 < time2
   */
  static compare(
    time1: string | Date | number, 
    time2: string | Date | number
  ): number {
    const date1 = this.parseTime(time1);
    const date2 = this.parseTime(time2);
    
    if (date1.getTime() > date2.getTime()) return 1;
    if (date1.getTime() < date2.getTime()) return -1;
    return 0;
  }
}