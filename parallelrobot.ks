set controlSpeed to 0.1.

until false {
    set lRPos to lRPos + (ship:control:pilotyaw * controlSpeed).
    set bFPos to bFPos + (ship:control:pilotpitch * controlSpeed).
    set uDPos to uDPos + (ship:control:pilotroll * controlSpeed).
}