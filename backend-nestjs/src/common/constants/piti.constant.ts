/**
 * 请愿相关常量
 */
export const PITI_CONSTANTS = {
  //  发起人进入现场距离米数
    OER_NEED_DISTANCE: 88,
  //  成员进入现场距离米数
    OMEMBER_NEED_DISTANCE: 888,
  // 成员进入现场比发起人更多时间秒数【发起人必须在请愿发起时间内进入现场，否则无法进入
    OMEMBER_NEED_TIME_MORE: 2.5*60*60,
  // 进入现场的容错时间秒数
    ENTER_SCENE_TIME_GIVE: 5*60,
  // 发起人手动响应的时间秒数[25*60:发起人必须在成员申请后的25min内响应]
    MANUEL_RESPONSE_TIME: 25*60,
};