
export const QUEUE_JOB_NAMES = {
  /** mission-complete */
  MISSION_COMPLETE: 'mission-complete',//mission-complete
  // /** activity-completion */
  // ACTIVITY_COMPLETION: 'activity-completion',
} as const;

/* 导出类型，方便 TS 类型检查 */
export type QueueJobName = typeof QUEUE_JOB_NAMES[keyof typeof QUEUE_JOB_NAMES];