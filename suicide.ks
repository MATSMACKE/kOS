lock steering to ship:srfretrograde.
wait until ship:verticalspeed < -10.
until suicideVelocity() > -100 {
    keepVelocity(suicideVelocity(), 10).
}
set gear to true.
print("Extending Legs").
until alt:radar < trueAGLOffset + 0.5 {
    keepVelocity(suicideVelocity(), 10).
}
lock throttle to 0.
print("Touchdown").

function verticallyAccelerate {
    parameter acceleration. parameter angle is 0.
    set shipWeight to ship:mass*9.802.
    lock throttle to (shipWeight + (acceleration*ship:mass)) / ship:maxthrust.
}

function keepVelocity {
    parameter targetVelocity, aggression is 5.
    set targetVelocityDelta to aggression*(targetVelocity - ship:verticalspeed).
    verticallyAccelerate(targetVelocityDelta).
}

function suicideVelocity {
    set squareRoot to 2 * (((ship:maxthrust) - (ship:mass*9.802)) / ship:mass) * (alt:radar - trueAGLOffset).
    if squareRoot > 0 {
        return -1*sqrt(squareRoot) + 1.
    }
    else {
        return 0.
    }.
}