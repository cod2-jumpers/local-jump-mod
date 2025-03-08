#include maps\mp\gametypes\_utility;
#include maps\mp\gametypes\_hudmod;
#include maps\mp\gametypes\_jumpAnalysis;

// Sets the player's FPS value and updates related variables
initializeFPS(fpsValue)
{ 
    // Validate FPS value is one of the supported values
    validFPS = [];
    validFPS[0] = 43;
    validFPS[1] = 76;
    validFPS[2] = 125;
    validFPS[3] = 250;
    validFPS[4] = 333;
    
    isValid = false;
    
    for(i = 0; i < validFPS.size; i++)
        if(fpsValue == validFPS[i])
            isValid = true;
            
    if(!isValid)
        return;
        
    self.fpsValue = fpsValue;
    self.fpsVariable = true;
    
    // Set legacy flags for backward compatibility
    self.fpsone = (fpsValue == 125);
    self.fpstwo = (fpsValue == 250);
    self.fpsthree = (fpsValue == 333);
    self.fpsfour = (fpsValue == 76);
    self.fpsfive = (fpsValue == 43);
    
    self setClientCvar("com_maxfps", fpsValue);
}

// Resets all FPS-related flags and stops display threads
turnOffAllFPS()
{
    self.fpsone = false;
    self.fpstwo = false;
    self.fpsthree = false;
    self.fpsfour = false;
    self.fpsfive = false;

    self notify("stop_fps_display");
    self notify("stop_fpsHUD_125");
    self notify("stop_fpsHUD_250");
    self notify("stop_fpsHUD_333");
    self notify("stop_fpsHUD_76");
    self notify("stop_fpsHUD_43");
}

// Changes player's FPS setting while preserving state and HUD
switchFPS(fpsValue)
{
    self destroyAllHUD();
    self notify("stop_fps_display"); 

    self initializeFPS(fpsValue);
    
    self thread maps\mp\gametypes\_jumpAnalysis::initializeHUD(fpsValue);
}

// Get the current FPS value
getCurrentFPS()
{
    if(isDefined(self.fpsValue))
        return self.fpsValue;
        
    // Legacy support - determine from individual flags
    if(self.fpsone)
        return 125;
    else if(self.fpstwo)
        return 250;
    else if(self.fpsthree)
        return 333;
    else if(self.fpsfour)
        return 76;
    else if(self.fpsfive)
        return 43;
        
    return 125;
}
