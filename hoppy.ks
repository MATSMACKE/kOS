//set flight variables
set targetAlt to 1000.
set ascentSpeed to 200.
set translateSpeed to 10.
set translationHeading to 0.

function main {
    lock steering to up.
    set trueAGLOffset to alt:radar + 0.3.
    clearscreen.

    set launchSiteLat to ship:geoposition:lat.
    set launchSiteLng to ship:geoposition:lng.

    doCountdown().

    until alt:radar > trueAGLOffset - 3.9 {
        lock throttle to 1.
    }
    print("Liftoff, retracting legs").
    set gear to false.
    set translationHeading to translationHeading - 90.
    until ship:obt:apoapsis > targetAlt {
        keepVelocity2d(0.01,ascentSpeed, 5).
    }
    print("Apoapsis is now " + targetAlt + "m True AGL, slowing to 0m/s").
    until ship:verticalspeed < 0.1 keepVelocity(0). 
    print("Hovering, starting translation").
    set translationHeading to 0.
    until addons:tr:impactpos:lat > -0.048 {
        keepVelocity2d(translateSpeed, 0).
    }

    //until ship:groundspeed < 1 {
        //keepVelocity2d(0, 0, 2).
    //}

    //translateTo(launchSiteLat, launchSiteLng).

    lock throttle to 0.
    runpath("0:/kOS/suicide.ks").
}

function translateTo {
    parameter lat. parameter lng.
    set translationHeading to 180.
    until addons:tr:impactpos:lat < lat - 0.0017 {
        keepVelocity2d(translateSpeed, 0).
    }

    until ship:groundspeed < 1 {
        keepVelocity2d(0, 0, 2).
    }

    set translationHeading to 90.
    until addons:tr:impactpos:lng > lng {
        keepVelocity2d(translateSpeed, 0, 2).
    }

    until ship:groundspeed < 1 {
        keepVelocity2d(0, 0, 2).
    }
}

function doCountdown {
    wait 2.
    print("Ready to launch").
    wait 2.
    print("T - 3").
    wait 1.
    print("T - 2").
    wait 1.
    print("T - 1").
    wait 1.
    stage.
    print("Ignition").
}

function verticallyAccelerate {
    parameter acceleration. parameter angle is 0.
    set shipWeight to ship:mass*9.802.
    lock throttle to (shipWeight + (acceleration*ship:mass)) / ship:maxthrust.
}

function accelerate2d {
    parameter accelerationx, accelerationy.
    set shipWeight to ship:mass*9.802.
    if accelerationx < 0 lock steering to heading(translationHeading + 180, arctan2((accelerationy*ship:mass) + shipWeight, accelerationx), 0).
    if accelerationx > 0 lock steering to heading(translationHeading, arctan2((accelerationy*ship:mass) + shipWeight, accelerationx), 0).
    if accelerationx = 0 lock steering to up.
    lock throttle to sqrt((accelerationx^2) + ((accelerationy + shipWeight)^2)) / ship:maxthrust.
}

function keepVelocity {
    parameter targetVelocity, aggression is 5.
    set targetVelocityDelta to aggression*(targetVelocity - ship:verticalspeed).
    verticallyAccelerate(targetVelocityDelta).
}

function keepVelocity2d {
    parameter targetVelocityx, targetVelocityy, aggression is 5.
    set targetVelocityDeltax to aggression*(targetVelocityx - ship:groundspeed).
    set targetVelocityDeltay to aggression*(targetVelocityy - ship:verticalspeed).
    set shipWeight to ship:mass*9.802.
    if targetVelocityx = 0 {
        if ship:verticalspeed > 50 {lock steering to (v(2,2,2)*rotatefromto(ship:srfprograde:forevector,v(0,0,0))).} else lock steering to heading(translationHeading, arctan2((targetVelocityDeltay*ship:mass) + shipWeight, targetVelocityDeltax), 0).
    }
    else lock steering to heading(translationHeading, arctan2((targetVelocityDeltay*ship:mass) + shipWeight, targetVelocityDeltax), 0).
    lock throttle to sqrt((targetVelocityDeltax^2) + ((targetVelocityDeltay + shipWeight)^2)) / ship:maxthrust.
}

main().