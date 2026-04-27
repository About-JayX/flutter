/**
 * 消息层级类型类型枚举
 */
export enum NewsStatusLevelType {
  News = 'news',
  SystemNews = 'systemNews',
  SystemNewsItem = 'systemNewsItem',
}

/**
 * 获取消息层级类型类型描述
 */
export const BusinessTypeDescription = {
  [NewsStatusLevelType.News]: '描述：消息',
  [NewsStatusLevelType.SystemNews]: '描述：系统消息',
  [NewsStatusLevelType.SystemNewsItem]: '描述：系统消息子项',
};