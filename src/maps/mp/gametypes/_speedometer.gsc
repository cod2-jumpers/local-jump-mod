#include maps\mp\gametypes\_utility;
#include maps\mp\gametypes\_hudmod;
// Initialize the speedometer system
initializeSpeedometer()
{
    self.maxSpeedDuringJump = 0;
    self.lastDisplayedSpeed = 0;
    
    // Initialize the speed HUD using hudmod
    self initSpeedHUD();
}

// Calculate current ground speed from velocity
calculateSpeed()
{
    newvel = self getVelocity();
    speedSquared = (newvel[0] * newvel[0]) + (newvel[1] * newvel[1]);
    return sqrt(speedSquared);
}

// Track maximum speed during a jump
trackMaxSpeedDuringJump(speed)
{
    MAX_SPEED_JUMP = 10000; // Local constant
    
    if (!self isOnGround() && speed > self.maxSpeedDuringJump && speed <= MAX_SPEED_JUMP)
    {
        self.maxSpeedDuringJump = speed;
        self.lastDisplayedSpeed = speed;  // Store the actual displayed speed
    }
}

// Check if speed is sufficient for jump tracking
isSpeedValidForJumpStart(speed)
{
    MIN_SPEED_ON_GROUND = 240; // Local constant
    
    return (speed > MIN_SPEED_ON_GROUND);
}

// Reset speed tracking values
resetSpeedTracking()
{
    self.maxSpeedDuringJump = 0;
    self.lastDisplayedSpeed = 0;
}

// Get the current max speed during jump
getMaxJumpSpeed()
{
    return self.maxSpeedDuringJump;
}

// Get the last displayed speed value
getLastDisplayedSpeed()
{
    return self.lastDisplayedSpeed;
} 