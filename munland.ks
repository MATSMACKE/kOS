function calculateSuicideStart {
    declare local engineList to 0.
    list engines in engineList.
    set ISP to 280.
    set suicideTime to ((ship:mass * 1000) - ((ship:mass * 1000) / (constant:e ^ ((sqrt(2 * 9.802 * (alt:radar - trueAGLOffset))) / (9.8 * ISP))))) / ((ship:maxthrust * 1000) / (9.8 * ISP)).
    set suicideAlt to ((sqrt(2 * 9.802 * (alt:radar - trueAGLOffset)) ) / 2) * suicideTime.
    return suicideAlt.
}