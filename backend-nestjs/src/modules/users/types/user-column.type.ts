export const USER_COLUMNS = ['id', 'updateTime'] as const;

export type UserColumn = (typeof USER_COLUMNS)[number];
