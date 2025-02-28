--- This file is generated by ava-x2l.exe,
--- Don't change it manaully.
--- @copyright Lilith Games, Project Da Vinci(Avatar Team)
--- @see Official Website: https://www.projectdavinci.com/
--- @see Dev Framework: https://github.com/lilith-avatar/avatar-ava
--- @see X2L Tool: https://github.com/lilith-avatar/avatar-ava-xls2lua
--- source file: ./Xls/ActAnimations.xlsx

local ActAnimXls = {
    [1] = {
        ID = 1,
        ShowName = '鼓掌',
        anim = {'anim_human_social_applause_begin', 'anim_human_social_applause_loop', 'anim_human_social_applause_end'},
        dur = {0.2, -1, 0.2},
        speed = 1.0,
        layer = 0,
        transIn = 0.2,
        transOut = 0.2,
        isInterrupt = true,
        isLoop = true,
        speedScale = 1.0
    },
    [2] = {
        ID = 2,
        ShowName = '落败',
        anim = {'anim_human_social_fail_begin', 'anim_human_social_fail_loop', 'anim_human_social_fail_end'},
        dur = {0.8, -1, 0.6},
        speed = 1.0,
        layer = 0,
        transIn = 0.2,
        transOut = 0.2,
        isInterrupt = true,
        isLoop = true,
        speedScale = 1.0
    },
    [3] = {
        ID = 3,
        ShowName = '大笑',
        anim = {'anim_human_social_laughing_begin', 'anim_human_social_laughing_loop', 'anim_human_social_laughing_end'},
        dur = {0.2, -1, 1},
        speed = 1.0,
        layer = 0,
        transIn = 0.2,
        transOut = 0.2,
        isInterrupt = true,
        isLoop = true,
        speedScale = 1.0
    },
    [4] = {
        ID = 4,
        ShowName = '装死',
        anim = {'anim_human_social_playdead_begin', 'anim_human_social_playdead_loop', 'anim_human_social_playdead_end'},
        dur = {2, -1, 0.5},
        speed = 1.0,
        layer = 0,
        transIn = 0.2,
        transOut = 0.2,
        isInterrupt = true,
        isLoop = true,
        speedScale = 1.0
    }
}

return ActAnimXls
