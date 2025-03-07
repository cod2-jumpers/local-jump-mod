#include maps\mp\gametypes\_utility;
_MeleeKey()
{
    self endon("end_saveposition_threads");
	
    for(;;)
    {
        if(self meleeButtonPressed())
        {
            self thread savePos();
            
            // Add a delay to prevent repeated triggering while holding down the button
            wait 1;
        }
        else
        {
            wait 0.05;
        }
    }
}

_AttackAndUseKey()
{
    self endon("end_saveposition_threads");
    
    for(;;)
    {
        if(self AttackButtonPressed() && self useButtonPressed())
        {
            self thread loadPreviousPos();
            wait 0.3;  // To prevent multiple triggers in quick succession
        }

        wait 0.05;
    }
}

getArraySize(arr)
{
    if (!isDefined(arr))
    {
        return 0;
    }

    count = 0;
    while (isDefined(arr[count]))
    {
        count++;
    }
    return count;
}



_UseKey()
{
    self endon("end_saveposition_threads");

    for(;;)
    {
        // For double-click detection
        if (self useButtonPressed())
        {
            catch_next = false;

            for(i=0; i<=0.1; i+=0.01)  // 0.1 seconds window for double-click
            {
                if (catch_next && self useButtonPressed())
                {
                    self thread loadPos();  // Load the position on double-click
                    // Reset the index to point to the latest saved position
                    size = getArraySize(self.saved_positions);
					self.current_position_index = size - 1;

                    wait 0.2;  // Prevent multiple triggers
                    break;
                }
                else if (!self useButtonPressed())
                {
                    catch_next = true;
                }
                wait 0.01;
            }
        }

        // For holding Use and clicking Attack
        if (self useButtonPressed() && self AttackButtonPressed())
        {
            self thread loadPreviousPos();  // Load the previous position immediately
            wait 0.2;  // Slight delay to prevent rapid cycling
        }
        else if (self AttackButtonPressed())  // If only Attack is pressed, introduce a delay before cycling
        {
            wait 0.1;  // Introduce a delay to prevent rapid cycling
        }

        wait 0.05;
    }
}


loadPreviousPos()
{

    if (isDefined(self.saved_positions) && getArraySize(self.saved_positions) > 0)
    {
        if (!isDefined(self.current_position_index))
        {
            self.current_position_index = getArraySize(self.saved_positions) - 1;
        }
		self.justLoadedPosition = true;    
		self.LoadedPosition = true;
        self.current_position_index--;

        // Stop at the oldest save instead of wrapping around
        if (self.current_position_index < 0)
        {
            self.current_position_index = 0;  

            if (!isDefined(self.shownOldestSaveMsg) || !self.shownOldestSaveMsg)
            {
                self.shownOldestSaveMsg = true;
                self iprintlnbold(&"HUD_POSITION_OLD");
            }
            return;  // Exit the function early
        }
        else
        {
            self.shownOldestSaveMsg = false;  // Reset the flag if not at the oldest position
        }

        currentPosition = self.saved_positions[self.current_position_index];
        self setPlayerAngles(currentPosition["viewangles"]);
        self setOrigin(currentPosition["origin"]);

        self iprintln(&"HUD_POSITION_HLOAD");
    }
    else
    {
        self.shownOldestSaveMsg = false;  // Reset the flag if no positions to load
        self iprintlnbold(&"HUD_NOPOSITION_LOAD");
    }
}


savePos()
{

	
	if (self isOnGround())
	{
		if (!isDefined(self.saved_positions))
		{
			self.saved_positions = [];
		}

		currentPos = [];
		currentPos["origin"] = self.origin;
		currentPos["viewangles"] = self getPlayerAngles();
		currentPos["saveOnGround"] = self isOnGround();

		self.saved_positions[self.saved_positions.size] = currentPos;
		self.current_position_index = self.saved_positions.size - 1;
		
		self iprintln(&"HUD_POSITION_SAVE");
	}
	else
    {
		self iprintlnbold(&"HUD_GROUND_SAVE");
    }
}


loadPos()
{


    if (!isDefined(self.saved_positions) || getArraySize(self.saved_positions) == 0)
    {
        self iprintlnbold(&"HUD_POSITION_OLD");
        return;  // Exit early if there's no saved position
    }

    currentPosition = self.saved_positions[self.saved_positions.size - 1];
	
	self.justLoadedPosition = true;    
    self.LoadedPosition = true;
	
    // Immediately set player's origin
    self setOrigin(currentPosition["origin"]);
    
    if (currentPosition["saveOnGround"])
    {
        wait 0.05;
        self setOrigin(currentPosition["origin"]);
    }

    // Now, set other attributes related to the player
    self setPlayerAngles(currentPosition["viewangles"]);
    
    foo = spawn("script_origin", currentPosition["origin"]);
    self linkto(foo);
    
    wait 0.05;

    // Cleanup
    self unlink();
    foo delete();
    
    self stopShellshock();
    self stoprumble("damage_heavy");
    //self iprintln(&"HUD_POSITION_LOAD");
}
