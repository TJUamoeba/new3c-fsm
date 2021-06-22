<p>
    <h1 style='border-bottom:none'  align='center'>New 3C FSM</h1>
</p>

[![](https://img.shields.io/badge/-DaVinci-MediumPurple)](http://api.projectdavinci.com/)
[![](https://img.shields.io/badge/project-Ava-ff69b4)](https://github.com/lilith-avatar/avatar-ava/projects/1)
[![](https://img.shields.io/badge/-api%20plugin-9cf)](https://github.com/lilith-avatar/davinci-api-wrap)
[![](https://img.shields.io/badge/smap-download-success)](https://github.com/lilith-avatar/new3c-fsm/blob/main/Smap/FrameFsm_Beta.smap)
-------------------------------------------------------

## Quick Look

```lua
---state位移接口
PlayerActState:Move(_isSprint)  --水平位移 @param _isSprint 是否有冲刺

PlayerActState:Swim(_multiple) --游泳位移 @param _multiple 速度倍率

PlayerActState:Fly() --飞行位移

PlayerActState:UpAndDown() --上下浮动位移


---state监听接口 返回bool
PlayerActState:MoveMonitor() --移动监听 

PlayerActState:FloorMonitor(_dis) --地面监听 @param _dis 判定为落地的最大距离

PlayerActState:SwimMonitor() --游泳监听

PlayerActState:SpeedMonitor(_maxSpeed) --速度监听 @param _maxSpeed 目前的最大速度
```

## About
* 开发者：[@lilith-avatar-richardzhou](https://github.com/lilith-avatar-richardzhou)
* 描述：新3C状态机系统
* 编辑器版本：线上版

## Input Setting
* WSAD 上下左右
* Shift 冲刺
* F 飞行
* Q 上浮 E 下沉（仅在飞行和游泳）


## Video
[![fsm](https://user-images.githubusercontent.com/4829591/122093827-0ad5a580-ce3e-11eb-9a12-fb56a91f5672.jpg)](https://user-images.githubusercontent.com/4829591/122094080-525c3180-ce3e-11eb-83a1-22a67765ff66.mp4)
