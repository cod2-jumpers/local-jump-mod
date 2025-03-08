roundToOneDecimal(num) // Function to round to one decimal point
{
    return int(num * 10) / 10.0;
}

// Implementation of atan2 for GSC
// Returns the arctangent of y/x, with the result in radians
// Takes into account which quadrant the point is in
atan2(y, x)
{
    // Constants
    PI = 3.14159265358979;
    
    // Special cases
    if (x == 0)
    {
        if (y > 0)
            return PI / 2; // 90 degrees
        else if (y < 0)
            return (0 - PI) / 2; // -90 degrees
        else
            return 0; // undefined, but return 0
    }
    
    // Calculate basic arctangent (this only works correctly in the first quadrant)
    atanValue = atan(y / x);
    
    // Adjust the result based on which quadrant the point is in
    if (x > 0)
    {
        // Quadrant I (x > 0, y > 0) or IV (x > 0, y < 0)
        return atanValue;
    }
    else // x < 0
    {
        // Quadrant II (x < 0, y > 0) or III (x < 0, y < 0)
        if (y >= 0)
            return atanValue + PI; // Add 180 degrees
        else
            return atanValue - PI; // Subtract 180 degrees
    }
}


roundDown(value)
{
    if (value == int(value)) // If the value is already an integer
    {
        return value;
    }
    else
    {
        return int(value); // Simply truncate the decimal part
    }
}


removeFirstElement(array)
{
    newArray = [];
    for (i = 1; i < array.size; i++)
    {
        newArray[i-1] = array[i];
    }
    return newArray;
}

triggerOff()
{
	if (!isdefined (self.realOrigin))
		self.realOrigin = self.origin;

	if (self.origin == self.realorigin)
		self.origin += (0, 0, -10000);
}

triggerOn()
{
	if (isDefined (self.realOrigin) )
		self.origin = self.realOrigin;
}

error(msg)
{
	println("^c*ERROR* ", msg);
	wait .05;	// waitframe
/#
	if (getcvar("debug") != "1")
		assertmsg("This is a forced error - attach the log file");
#/
}

vectorScale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

add_to_array(array, ent)
{
	if(!isdefined(ent))
		return array;
		
	if(!isdefined(array))
		array[0] = ent;
	else
		array[array.size] = ent;
	
	return array;	
}

exploder(num)
{
	num = int(num);
	ents = level._script_exploders;

	for(i = 0; i < ents.size; i++)
	{
		if(!isdefined(ents[i]))
			continue;

		if (ents[i].script_exploder != num)
			continue;

		if (isdefined(ents[i].script_fxid))
			level thread cannon_effect(ents[i]);

		if (isdefined (ents[i].script_sound))
			ents[i] thread exploder_sound();

		if (isdefined(ents[i].targetname))
		{
			if(ents[i].targetname == "exploder")
				ents[i] thread brush_show();
			else
			if((ents[i].targetname == "exploderchunk") || (ents[i].targetname == "exploderchunk visible"))
				ents[i] thread brush_throw();
			else
			if(!isdefined(ents[i].script_fxid))
				ents[i] thread brush_delete();
		}
		else
		if (!isdefined(ents[i].script_fxid))
			ents[i] thread brush_delete();
	}
}
// Returns the minimum of two values
min(a, b)
{
    if(a < b)
        return a;
    return b;
}
sqrt(x)
{
    if (x < 0)
    {
        return undefined;
    }
    if (x == 0 || x == 1)
    {
        return x; 
    }
    
    guess = x / 2;
    epsilon = 0.00001; 
    
    for (i = 0; i < 20; i++)
    {
        if (abs((guess * guess) - x) <= epsilon)
        {
            break;
        }
        guess = (guess + (x / guess)) / 2;
    }
    
    return guess;
}

// Returns the maximum of two values
max(a, b)
{
    if(a > b)
        return a;
    return b;
}

exploder_sound()
{
	if(isdefined(self.script_delay))
		wait self.script_delay;
		
	self playSound(level.scr_sound[self.script_sound]);
}

cannon_effect(source)
{
	if(!isdefined(source.script_delay))
		source.script_delay = 0;

	if((isdefined(source.script_delay_min)) && (isdefined(source.script_delay_max)))
		source.script_delay = source.script_delay_min + randomfloat (source.script_delay_max - source.script_delay_min);

	org = undefined;
	if(isdefined(source.target))
		org = (getent(source.target, "targetname")).origin;

	level thread maps\mp\_fx::OneShotfx(source.script_fxid, source.origin, source.script_delay, org);
}

brush_delete()
{
	if(isdefined(self.script_delay))
		wait(self.script_delay);

	self delete();
}

brush_show()
{
	if(isdefined(self.script_delay))
		wait(self.script_delay);

	self show();
	self solid();
}

brush_throw()
{
	if(isdefined(self.script_delay))
		wait(self.script_delay);

	ent = undefined;
	if(isdefined(self.target))
		ent = getent(self.target, "targetname");

	if(!isdefined(ent))
	{
		self delete();
		return;
	}

	self show();

	org = ent.origin;

	temp_vec = (org - self.origin);

//	println("start ", self.origin , " end ", org, " vector ", temp_vec, " player origin ", level.player getorigin());

	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];

	self rotateVelocity((x,y,z), 12);
	self moveGravity((x, y, z), 12);

	wait(6);
	self delete();
}

saveModel()
{
	info["model"] = self.model;
	info["viewmodel"] = self getViewModel();
	attachSize = self getAttachSize();
	info["attach"] = [];
	
	for(i = 0; i < attachSize; i++)
	{
		info["attach"][i]["model"] = self getAttachModelName(i);
		info["attach"][i]["tag"] = self getAttachTagName(i);
		info["attach"][i]["ignoreCollision"] = self getAttachIgnoreCollision(i);
	}
	
	return info;
}

loadModel(info)
{
	self detachAll();
	self setModel(info["model"]);
	self setViewModel(info["viewmodel"]);

	attachInfo = info["attach"];
	attachSize = attachInfo.size;
    
	for(i = 0; i < attachSize; i++)
		self attach(attachInfo[i]["model"], attachInfo[i]["tag"], attachInfo[i]["ignoreCollision"]);
}

getPlant()
{
	start = self.origin + (0, 0, 10);

	range = 11;
	forward = anglesToForward(self.angles);
	forward = maps\mp\_utility::vectorScale(forward, range);

	traceorigins[0] = start + forward;
	traceorigins[1] = start;

	trace = bulletTrace(traceorigins[0], (traceorigins[0] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1)
	{
		//println("^6Using traceorigins[0], tracefraction is", trace["fraction"]);
		
		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orientToNormal(trace["normal"]);
		return temp;
	}

	trace = bulletTrace(traceorigins[1], (traceorigins[1] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1)
	{
		//println("^6Using traceorigins[1], tracefraction is", trace["fraction"]);

		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orientToNormal(trace["normal"]);
		return temp;
	}

	traceorigins[2] = start + (16, 16, 0);
	traceorigins[3] = start + (16, -16, 0);
	traceorigins[4] = start + (-16, -16, 0);
	traceorigins[5] = start + (-16, 16, 0);

	besttracefraction = undefined;
	besttraceposition = undefined;
	for(i = 0; i < traceorigins.size; i++)
	{
		trace = bulletTrace(traceorigins[i], (traceorigins[i] + (0, 0, -1000)), false, undefined);

		//ent[i] = spawn("script_model",(traceorigins[i]+(0, 0, -2)));
		//ent[i].angles = (0, 180, 180);
		//ent[i] setmodel("xmodel/105");

		//println("^6trace ", i ," fraction is ", trace["fraction"]);

		if(!isdefined(besttracefraction) || (trace["fraction"] < besttracefraction))
		{
			besttracefraction = trace["fraction"];
			besttraceposition = trace["position"];

			//println("^6besttracefraction set to ", besttracefraction, " which is traceorigin[", i, "]");
		}
	}
	
	if(besttracefraction == 1)
		besttraceposition = self.origin;
	
	temp = spawnstruct();
	temp.origin = besttraceposition;
	temp.angles = orientToNormal(trace["normal"]);
	return temp;
}

orientToNormal(normal)
{
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);

	if(!hor_length)
		return (0, 0, 0);
	
	hor_dir = vectornormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = vectortoangles(tangent);

	//println("^6hor_normal is ", hor_normal);
	//println("^6hor_length is ", hor_length);
	//println("^6hor_dir is ", hor_dir);
	//println("^6neg_height is ", neg_height);
	//println("^6tangent is ", tangent);
	//println("^6plant_angle is ", plant_angle);

	return plant_angle;
}

array_levelthread (ents, process, var, excluders)
{
	exclude = [];
	for (i=0;i<ents.size;i++)
		exclude[i] = false;

	if (isdefined (excluders))
	{
		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;
	}

	for (i=0;i<ents.size;i++)
	{
		if (!exclude[i])
		{
			if (isdefined (var))
				level thread [[process]](ents[i], var);
			else
				level thread [[process]](ents[i]);
		}
	}
}

// Vector cross product
vectorCross(a, b)
{
    return (
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0]
    );
}
// Helper function to replace characters in a string
replaceChar(str, find, replace)
{
    result = "";
    for(i = 0; i < str.size; i++)
    {
        if(str[i] == find)
            result += replace;
        else
            result += str[i];
    }
    return result;
}

// Helper function to get jump data with null check
getJumpDataValue(key)
{
    if(isDefined(self.jumpData[key]))
        return self.jumpData[key];
    return 0;
}

// Helper function to format decimal values consistently
formatDecimal(value)
{
    return int(value * 100) / 100;
}

// Helper function to safely write to a file and handle errors
safeFileWrite(filename, content, mode)
{
    fileHandle = openfile(filename, mode);
    if(fileHandle == -1)
        return false;
    
    fprintln(fileHandle, content);
    closefile(fileHandle);
    return true;
}
// Convert degrees to radians
deg2rad(degrees)
{
    return degrees * 3.14159265 / 180;
}

// Convert radians to degrees
rad2deg(radians)
{
    return radians * 180 / 3.14159265;
}

// Convert string to float
float(str)
{
    value = int(str);
    
    // Handle decimal portion if present
    if(str[0] == "-")
        isNegative = true;
    else
        isNegative = false;
    
    decimal = 0;
    for(i = 0; i < str.size; i++)
    {
        if(str[i] == ".")
        {
            if(i + 1 < str.size)
            {
                decimal = int(str[i+1]) * 0.1;
                if(i + 2 < str.size)
                    decimal += int(str[i+2]) * 0.01;
            }
            break;
        }
    }
    
    if(isNegative)
        return value - decimal;
    else
        return value + decimal;
} 
set_ambient (track)
{
	level.ambient = track;
	if ((isdefined (level.ambient_track)) && (isdefined (level.ambient_track[track])))
	{
		ambientPlay (level.ambient_track[track], 2);
		println ("playing ambient track ", track);
	}
}


// Add helper function for linear interpolation (lerp)
lerp(a, b, t)
{
    if(!isDefined(a) || !isDefined(b) || !isDefined(t))
        return 0;
        
    return a + (b - a) * t;
}

// Add helper function for clamping values
clamp(value, min_val, max_val)
{
    if(!isDefined(value) || !isDefined(min_val) || !isDefined(max_val))
        return 0;
        
    if(value < min_val)
        return min_val;
    if(value > max_val)
        return max_val;
    return value;
}

// Add helper function for absolute value
abs(value)
{
    if(!isDefined(value))
        return 0;
        
    if(value < 0)
    {
        negValue = 0 - value;
        return negValue;
    }
    return value;
} 
deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
	{
		//println("DELETED: ", entities[i].classname);
		entities[i] delete();
	}
}

// Check if a file exists
fileExists(filename)
{
    fileHandle = openfile(filename, "read");
    if(fileHandle == -1)
        return false;
    
    closefile(fileHandle);
    return true;
}

// Measurement and analysis functions moved from _jumpAnalysis.gsc
MeasureDist()
{
    fireTime = 0.33;  // Duration of firing animation for kar98k
    rechamberTime = 1.0;  // Rechamber time for kar98k

    self notify("stop_measureDist");
    self endon("stop_measureDist");
    self endon("disconnect");

    while(1)
    {
        if (self.sessionstate != "spectator" && (self getcurrentweapon() == "kar98k_sniper_mp") && self attackButtonPressed())
        {
            vec = anglestoforward(self getplayerangles());
            trace = bullettrace(self geteye() + (0, 0, 18), self geteye() + (5000 * vec[0], 5000 * vec[1], 5000 * vec[2] + 18), false, self);

            if (!self.hasmeasure)
            {
                self.hasmeasure = true;
                self.measureorigin = trace["position"];
                self iprintlnbold(&"CJ_POINT1_X", self.measureorigin[0]);
                self iprintlnbold(&"CJ_POINT1_Y", self.measureorigin[1]);
                
                // Store first measure point for edge distance calculation
                self.measurePoint1 = (self.measureorigin[0], self.measureorigin[1], self.measureorigin[2]);
            }
            else
            {
                self.hasmeasure = false;

                // Create flattened points (same z-coordinates)
                point1_flattened = (trace["position"][0], trace["position"][1], 0);
                point2_flattened = (self.measureorigin[0], self.measureorigin[1], 0);

                // Calculate total distance using only x and y axes
                totalDistance = Distance(point1_flattened, point2_flattened) + 0.25;

                // Calculate height difference
                heightDifference = trace["position"][2] - self.measureorigin[2];

                self iprintlnbold(&"CJ_POINT2_X", trace["position"][0]);
                self iprintlnbold(&"CJ_POINT2_Y", trace["position"][1]);
                self iprintlnbold(&"CJ_DIST", totalDistance, &"CJ_HDIST", heightDifference);
                
                // Store second measure point for edge distance calculation
                self.measurePoint2 = (trace["position"][0], trace["position"][1], trace["position"][2]);
                
                // Calculate dominant axis (X or Y)
                xDiff = abs(self.measurePoint2[0] - self.measurePoint1[0]);
                yDiff = abs(self.measurePoint2[1] - self.measurePoint1[1]);
                
                if(xDiff > yDiff)
                {
                    self.dominantAxis = "X";
                    self iPrintLnBold(&"CJ_DOMINANT_AXIS_X");
                }
                else
                {
                    self.dominantAxis = "Y";
                    self iPrintLnBold(&"CJ_DOMINANT_AXIS_Y");
                }
                
                // Calculate edge distances if a jump is being tracked
                if(isDefined(self.jumpData) && self.dominantAxis != "")
                {
                    // Recalculate edge distances based on the most recent jump positions
                    self thread calculateEdgeDistances();
                }
            }

            wait(fireTime + rechamberTime);  // Wait for the duration of firing and rechambering
            
            while(self attackButtonPressed()) 
                wait 0.05; 
        }

        wait 0.05;  
    }
}

calculateEdgeDistances()
{
    self notify("stop_calculateEdgeDistances");
    self endon("stop_calculateEdgeDistances");
    self endon("disconnect");
    
    if(!isDefined(self.measurePoint1) || !isDefined(self.measurePoint2) || self.dominantAxis == "")
    {
        return;
    }
    
    // Get current jump start and end positions
    startPos = (self.jumpData["startx"], self.jumpData["starty"], 0);
    endPos = (self.jumpData["endx"], self.jumpData["endy"], 0);
    
    edgeStart = (self.measurePoint1[0], self.measurePoint1[1], 0);
    edgeEnd = (self.measurePoint2[0], self.measurePoint2[1], 0);
    
    // Calculate edge distances based on dominant axis
    startDistance = 0;
    endDistance = 0;
    
    if(self.dominantAxis == "X")
    {
        // For X-axis, explicitly calculate the absolute differences
        startDistance = abs(startPos[0] - edgeStart[0]);
        endDistance = abs(endPos[0] - edgeEnd[0]);
    }
    else // Y axis
    {
        // For Y-axis, explicitly calculate the absolute differences
        startDistance = abs(startPos[1] - edgeStart[1]);
        endDistance = abs(endPos[1] - edgeEnd[1]);
    }
    
    startDistance = int(startDistance * 100) / 100;
    endDistance = int(endDistance * 100) / 100;
    
    // Calculate total distance (edge start + edge end + raw distance + 0.25 offset)
    rawDistance = self.jumpData["distance"];
    totalDistance = startDistance + endDistance + rawDistance + 0.25;
    totalDistance = int(totalDistance * 100) / 100;
    
    // Update HUD with new values
    if(isDefined(self.jumpStatsHUD) && isDefined(self.jumpStatsHUD["edgedist_start"]))
    {
        self.jumpStatsHUD["edgedist_start"] setValue(startDistance);
        self.jumpStatsHUD["edgedist_end"] setValue(endDistance);
        self.jumpStatsHUD["total_distance"] setValue(totalDistance);
    }
    
    // Store edge distance values for use in saveJumpToHTML
    self.edgeDistanceStart = startDistance;
    self.edgeDistanceEnd = endDistance;
    self.totalDistance = totalDistance;
    
    // Explicitly set these in jumpData for HTML saving
    self.jumpData["edgedistance_start"] = startDistance;
    self.jumpData["edgedistance_end"] = endDistance;
    self.jumpData["total_distance"] = totalDistance;
}

// Function to store jump data for tracking and HTML recording
storeJumpData(prestrafe, poststrafe, maxHeight, startYaw, endYaw, yawDiff, startPos, endPos, distance)
{
    self.jumpData["prestrafe"] = prestrafe;
    self.jumpData["poststrafe"] = poststrafe;
    self.jumpData["maxheight"] = maxHeight;
    self.jumpData["startyaw"] = startYaw;
    self.jumpData["endyaw"] = endYaw;
    self.jumpData["yawdiff"] = yawDiff;
    self.jumpData["startx"] = startPos[0];
    self.jumpData["starty"] = startPos[1];
    self.jumpData["endx"] = endPos[0];
    self.jumpData["endy"] = endPos[1];
    self.jumpData["distance"] = distance;
}

    // Helper function to normalize yaw difference to range -180 to 180 degrees
    normalizeYawDifference(yawDiff)
    {
        if (yawDiff > 180)
            yawDiff -= 360;
        else if (yawDiff < -180)
            yawDiff += 360;
            
        return yawDiff;
    }