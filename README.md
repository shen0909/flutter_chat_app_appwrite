--功能
    √ 登录、注册
    √ 退出登录
    √ 连接数据库
    √ 添加数据到数据库
    √ 查找数据 -- 查找朋友
    √ 实时功能
    UI界面

-----2024.4.11------
1.优化发送消息
    -- 先本地显示再上传
2.监听到数据发生变化后利用事件总线EventBus 通知需要的地方进行修改
    -- eventbus的使用：https://blog.csdn.net/weixin_43244083/article/details/131597147
待解决：
1.不同平台怎么实现实时监听？
2.如何实现数据持久化？每次开始时先读取本地消息？

