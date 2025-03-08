#include maps\mp\gametypes\_utility;
#include maps\mp\gametypes\_fpsManager;

// Sets up the jump recording system and initializes required values
initializeJumpRecording()
{
    self endon("disconnect");
    
    if(!isDefined(self.FileName) || self.FileName == "")
    {
        self thread initJumpHTMLFile();
        wait 0.1;
        
        self iPrintLnBold("Jump recording initialized");
        self iPrintLnBold("Recording to: " + self.FileName);
    }
    
    self.isRecordingEnabled = true;
    
    if(!isDefined(self.goldenValues))
    {
        self initGoldenValues();
    }
}

// Sets default target values for jump performance metrics
initGoldenValues()
{
    self.goldenValues = [];
    self.goldenValues["prestrafe"] = 264;
    self.goldenValues["poststrafe"] = 350;
    self.goldenValues["maxheight"] = 41;
}

// Attempts to write content to file with fallback options if initial write fails
tryWriteToFile(baseFilename, content, writeMode, timestamp, randomSuffix)
{
    if(safeFileWrite(baseFilename, content, writeMode))
        return baseFilename;
    
    alternateFilename = "jumps_player_" + timestamp + "_" + randomSuffix + ".html";
    if(safeFileWrite(alternateFilename, content, writeMode))
        return alternateFilename;
    
    fallbackFilename = "jumps_" + randomInt(10000) + ".html";
    if(safeFileWrite(fallbackFilename, content, writeMode))
        return fallbackFilename;
    
    return "";
}

// Removes invalid characters from filename to prevent file system errors
sanitizeFilename(name)
{
    invalidChars = [];
    replacements = [];
    
    invalidChars[0] = " ";  replacements[0] = "_";
    invalidChars[1] = "/";  replacements[1] = "-";
    invalidChars[2] = "\\"; replacements[2] = "-";
    invalidChars[3] = ":";  replacements[3] = "-";
    invalidChars[4] = "*";  replacements[4] = "-";
    invalidChars[5] = "?";  replacements[5] = "-";
    invalidChars[6] = "\""; replacements[6] = "-";
    invalidChars[7] = "<";  replacements[7] = "-";
    invalidChars[8] = ">";  replacements[8] = "-";
    invalidChars[9] = "|";  replacements[9] = "-";
    
    sanitized = name;
    
    for(i = 0; i < invalidChars.size; i++)
    {
        sanitized = replaceChar(sanitized, invalidChars[i], replacements[i]);
    }
    
    return sanitized;
}

// Creates a styled HTML section with consistent formatting
createHtmlSection(backgroundColor, borderColor, title, content)
{
    htmlSection = "<div style='background-color: " + backgroundColor + "; padding: 10px; margin-bottom: 15px; border-left: 5px solid " + borderColor + ";'>\n" +
                "<h3>" + title + "</h3>\n" +
                content +
                "</div>\n";
    
    return htmlSection;
}

// Generates HTML content for golden values section of the report
createGoldenValuesSection()
{
    content = "";
    
    if(isDefined(self.goldenValues["prestrafe"]))
        content += "<p>Prestrafe: <span style='color: gold; font-weight: bold;'>" + self.goldenValues["prestrafe"] + "</span> units/sec</p>\n";
    else
        content += "<p>Prestrafe: <span style='color: gold; font-weight: bold;'>264</span> units/sec</p>\n";
        
    if(isDefined(self.goldenValues["poststrafe"]))
        content += "<p>Poststrafe: <span style='color: gold; font-weight: bold;'>" + self.goldenValues["poststrafe"] + "</span> units/sec</p>\n";
    else
        content += "<p>Poststrafe: <span style='color: gold; font-weight: bold;'>350</span> units/sec</p>\n";
        
    if(isDefined(self.goldenValues["maxheight"]))
        content += "<p>Max Height: <span style='color: gold; font-weight: bold;'>" + self.goldenValues["maxheight"] + "</span> units</p>\n";
    else
        content += "<p>Max Height: <span style='color: gold; font-weight: bold;'>41</span> units</p>\n";
    
    content += "<p class='info'>Colors range from red (far from golden) to green (close to golden value)</p>\n" +
              "<p class='info'>Perfect (green): Exact match or better | Excellent: Very slight deviation | Good: Minor deviation | Average: Moderate deviation | Bad (red): Poor match</p>\n";
    
    return self createHtmlSection("#fffde6", "#ffcc00", "Golden Values", content);
}

// Generates HTML content for reference jump information section
createReferenceInfoSection()
{
    if (!isDefined(self.reference_z_worldpos))
        return "";
        
    point1Info = "not set";
    point2Info = "not set";
    axisInfo = "not set";
    
    if (isDefined(self.measurePoint1))
    {
        point1Info = "X: " + formatDecimal(self.measurePoint1[0]) + ", Y: " + formatDecimal(self.measurePoint1[1]);
    }
    
    if (isDefined(self.measurePoint2))
    {
        point2Info = "X: " + formatDecimal(self.measurePoint2[0]) + ", Y: " + formatDecimal(self.measurePoint2[1]);
    }
    
    if (isDefined(self.dominantAxis) && self.dominantAxis != "")
    {
        axisInfo = self.dominantAxis + "-axis";
    }
    
    content = "<p>Reference Height: " + formatDecimal(self.reference_z_worldpos) + " units</p>\n" +
              "<h4>Measurement Points</h4>\n" +
              "<p>Point 1: " + point1Info + "</p>\n" +
              "<p>Point 2: " + point2Info + "</p>\n" +
              "<p>Dominant Axis: " + axisInfo + "</p>\n";
    
    return self createHtmlSection("#e6f7ff", "#0099cc", "Reference Jump Information", content);
}

// Creates and initializes HTML file for recording jump data
initJumpHTMLFile()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    if(!isDefined(self.goldenValues))
    {
        self initGoldenValues();
    }
    
    playerName = sanitizeFilename(self.name);
    currentMap = GetCvar("mapname");
    
    timestamp = GetTime();
    randomSuffix = randomInt(1000); 
    
    baseFilename = "jumps_" + playerName + "_" + currentMap + "_" + timestamp + "_" + randomSuffix;
    self.FileName = baseFilename + ".html";
    
    referenceInfo = self createReferenceInfoSection();
    goldenValuesInfo = self createGoldenValuesSection();
    
    htmlHeader = "<html>\n" +
                 "<head>\n" +
                 "<title>Jump Data</title>\n" +
                 "<style>\n" +
                 "table { border-collapse: collapse; width: 100%; table-layout: auto; }\n" +
                 "th, td { border: 1px solid #dddddd; text-align: left; padding: 12px 15px; white-space: nowrap; }\n" +
                 "tr:nth-child(even) { background-color: #f2f2f2; }\n" +
                 "th { background-color: #4CAF50; color: white; font-weight: bold; }\n" +
                 ".success { color: green; font-weight: bold; }\n" +
                 ".failure { color: red; font-weight: bold; }\n" +
                 ".perfect { color: #009900; font-weight: bold; background-color: #ccffcc; }\n" +
                 ".excellent { color: #339900; font-weight: bold; background-color: #e6ffcc; }\n" +
                 ".good { color: #999900; font-weight: bold; background-color: #ffffcc; }\n" +
                 ".average { color: #cc9900; font-weight: bold; background-color: #fff9cc; }\n" +
                 ".below-average { color: #cc6600; font-weight: bold; background-color: #ffebcc; }\n" +
                 ".poor { color: #cc3300; font-weight: bold; background-color: #ffd9cc; }\n" +
                 ".bad { color: #cc0000; font-weight: bold; background-color: #ffcccc; }\n" +
                 ".info { color: #666666; font-style: italic; }\n" +
                 "</style>\n" +
                 "</head>\n" +
                 "<body>\n" +
                 "<h2>Jump Data for " + playerName + " on " + currentMap + "</h2>\n" +
                 referenceInfo +
                 goldenValuesInfo +
                 "<div style='overflow-x: auto;'>\n" +
                 "<table>\n" +
                 "<tr><th>FPS</th><th>Prestrafe</th><th>Poststrafe</th><th>Max Height</th><th>Start Yaw</th><th>End Yaw</th><th>Yaw Diff</th><th>Start X</th><th>Start Y</th><th>End X</th><th>End Y</th><th>Distance</th><th>Edge Start</th><th>Edge End</th><th>Total Distance</th><th>Status</th></tr>\n";
    
    successfulFilename = self tryWriteToFile(self.FileName, htmlHeader, "write", timestamp, randomSuffix);
    
    if(successfulFilename == "")
    {
        self iPrintLnBold(&"CJ_ERROR_OPEN_FILE");
        return;
    }
    
    self.FileName = successfulFilename;
    self.jumpNumber = 0;
    
    self iPrintLnBold("Jump data will be saved to: " + self.FileName);
}

// Calculates metric percentage based on comparison to golden values
getMetricPercentage(value, goldenValue, metricName)
{
    if(value >= goldenValue)
        return 100; // Perfect score if at or above golden value
        
    // Special scaling for different metrics
    if(metricName == "maxheight")
    {
        diff = goldenValue - value;
        if(diff <= 0)
            return 100;
        else if(diff <= 0.2)
            return 95;
        else if(diff <= 0.5)
            return 85;
        else if(diff <= 1.0)
            return 70;
        else if(diff <= 1.5)
            return 55;
        else if(diff <= 2.0)
            return 40;
        else
            return 25;
    }
    else if(metricName == "prestrafe")
    {
        diff = goldenValue - value;
        if(diff <= 0)
            return 100;
        else if(diff <= 1)
            return 95;
        else if(diff <= 2)
            return 85;
        else if(diff <= 4)
            return 70;
        else if(diff <= 8)
            return 55;
        else if(diff <= 15)
            return 40;
        else
            return 25;
    }
    else if(metricName == "poststrafe")
    {
        diff = goldenValue - value;
        if(diff <= 0)
            return 100;
        else if(diff <= 3)
            return 95;
        else if(diff <= 7)
            return 85;
        else if(diff <= 15)
            return 70;
        else if(diff <= 25)
            return 55;
        else if(diff <= 40)
            return 40;
        else
            return 25;
    }
    
    // Default calculation for other metrics
    return (value / goldenValue) * 100;
}

// Evaluates how close a value is to golden value and returns appropriate CSS class
getValueColorClass(value, metricName)
{
    if(!isDefined(self.goldenValues))
    {
        self initGoldenValues();
    }
    
    if(!isDefined(value) || value == 0)
    {
        return "";
    }
    
    // Get golden value with fallbacks
    if(!isDefined(self.goldenValues[metricName]))
    {
        if(metricName == "prestrafe")
            goldenValue = 264;
        else if(metricName == "poststrafe")
            goldenValue = 350;
        else if(metricName == "maxheight")
            goldenValue = 41;
        else
            return "";
    }
    else
    {
        goldenValue = self.goldenValues[metricName];
    }
    
    if(!isDefined(goldenValue) || goldenValue == 0)
    {
        return "";
    }
    
    percentage = 0;
    
    if(metricName == "yawdiff")
    {
        // For yaw diff, closer to exact value is better
        deviation = abs(value - goldenValue);
        maxDeviation = goldenValue;
        percentage = 100 - (deviation / maxDeviation * 100);
    }
    else
    {
        // For other metrics, use the specialized percentage calculation
        percentage = self getMetricPercentage(value, goldenValue, metricName);
    }
    
    // Return appropriate color class based on percentage
    if(percentage >= 100)
        return "class='perfect'";
    else if(percentage >= 95)
        return "class='excellent'";
    else if(percentage >= 85)
        return "class='good'";
    else if(percentage >= 70)
        return "class='average'";
    else if(percentage >= 55)
        return "class='below-average'";
    else if(percentage >= 40)
        return "class='poor'";
    else
        return "class='bad'";
}

// Formats an HTML table cell with optional color styling
getFormattedCell(value, colorClass)
{
    if(colorClass != "")
        return "<td " + colorClass + ">" + value + "</td>";
    else
        return "<td>" + value + "</td>";
}

// Records jump data to HTML file with metrics and comparison to golden values
saveJumpToHTML()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    prestrafeRaw = getJumpDataValue("prestrafe");
    poststrafeRaw = getJumpDataValue("poststrafe");
    maxHeightRaw = getJumpDataValue("maxheight");
    
    prestrafeValue = formatDecimal(prestrafeRaw);
    poststrafe = formatDecimal(poststrafeRaw);
    maxHeight = formatDecimal(maxHeightRaw);
    startYaw = formatDecimal(getJumpDataValue("startyaw"));
    endYaw = formatDecimal(getJumpDataValue("endyaw"));
    yawDiff = formatDecimal(getJumpDataValue("yawdiff"));
    startX = formatDecimal(getJumpDataValue("startx"));
    startY = formatDecimal(getJumpDataValue("starty"));
    endX = formatDecimal(getJumpDataValue("endx"));
    endY = formatDecimal(getJumpDataValue("endy"));
    distance = formatDecimal(getJumpDataValue("distance"));
    
    edgeDistanceStart = 0;
    edgeDistanceEnd = 0;
    
    jumpStartPos = (startX, startY, 0);
    jumpEndPos = (endX, endY, 0);
    
    if(isDefined(self.recordingReferencePoint1) && isDefined(self.recordingReferencePoint2) && isDefined(self.recordingDominantAxis) && self.recordingDominantAxis != "")
    {
        // Store these values for the edge distance calculation
        self.jumpData["startx"] = startX;
        self.jumpData["starty"] = startY;
        self.jumpData["endx"] = endX;
        self.jumpData["endy"] = endY;
        
        // Use the measurePoint values for calculation
        self.measurePoint1 = self.recordingReferencePoint1;
        self.measurePoint2 = self.recordingReferencePoint2;
        self.dominantAxis = self.recordingDominantAxis;
        
        // Calculate edge distances using _utility.gsc function
        self thread calculateEdgeDistances();
        wait 0.05; // Short wait to allow calculation to complete
        
        // Retrieve calculated values
        edgeDistanceStart = self.edgeDistanceStart;
        edgeDistanceEnd = self.edgeDistanceEnd;
    }
    else if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && isDefined(self.dominantAxis) && self.dominantAxis != "")
    {
        // Store these values for the edge distance calculation
        self.jumpData["startx"] = startX;
        self.jumpData["starty"] = startY;
        self.jumpData["endx"] = endX;
        self.jumpData["endy"] = endY;
        
        // Calculate edge distances using _utility.gsc function
        self thread calculateEdgeDistances();
        wait 0.05; // Short wait to allow calculation to complete
        
        // Retrieve calculated values
        edgeDistanceStart = self.edgeDistanceStart;
        edgeDistanceEnd = self.edgeDistanceEnd;
    }
    
    edgeDistanceStart = formatDecimal(edgeDistanceStart);
    edgeDistanceEnd = formatDecimal(edgeDistanceEnd);
    
    totalDist = formatDecimal(edgeDistanceStart + edgeDistanceEnd + distance + 0.25);
    
    self.edgeDistanceStart = edgeDistanceStart;
    self.edgeDistanceEnd = edgeDistanceEnd;
    self.totalDistance = totalDist;
    
    self.jumpData["edgedistance_start"] = edgeDistanceStart;
    self.jumpData["edgedistance_end"] = edgeDistanceEnd;
    self.jumpData["total_distance"] = totalDist;
    
    self.jumpData["success"] = self determineJumpSuccess();
    
    if (prestrafeValue == 0 || poststrafe == 0 || (!self.jumpData["success"] && poststrafe < 300))
    {
        return;
    }
    
    self.jumpNumber++;
    self.totalJumps++;
    
    if (self.jumpData["success"])
    {
        self.successfulJumps++;
    }
    
    currentFPS = self maps\mp\gametypes\_fpsManager::getCurrentFPS();
    
    successRate = int((self.successfulJumps / self.totalJumps) * 100);
    
    if (self.jumpData["success"])
    {
        successClass = "class='success'";
        successText = "Success";
    }
    else
    {
        successClass = "class='failure'";
        successText = "Failure";
    }
    
    prestrafeClass = self getValueColorClass(prestrafeRaw, "prestrafe");
    poststrafeClass = self getValueColorClass(poststrafeRaw, "poststrafe");
    maxHeightClass = self getValueColorClass(maxHeightRaw, "maxheight");
    
    // Build the HTML row using the helper function for consistent formatting
    htmlRow = "<tr>";
    htmlRow += self getFormattedCell(currentFPS, "");
    htmlRow += self getFormattedCell(prestrafeValue, prestrafeClass);
    htmlRow += self getFormattedCell(poststrafe, poststrafeClass);
    htmlRow += self getFormattedCell(maxHeight, maxHeightClass);
    htmlRow += self getFormattedCell(startYaw, "");
    htmlRow += self getFormattedCell(endYaw, "");
    htmlRow += self getFormattedCell(yawDiff, "");
    htmlRow += self getFormattedCell(startX, "");
    htmlRow += self getFormattedCell(startY, "");
    htmlRow += self getFormattedCell(endX, "");
    htmlRow += self getFormattedCell(endY, "");
    htmlRow += self getFormattedCell(distance, "");
    htmlRow += self getFormattedCell(edgeDistanceStart, "");
    htmlRow += self getFormattedCell(edgeDistanceEnd, "");
    htmlRow += self getFormattedCell(totalDist, "");
    htmlRow += self getFormattedCell(successText, successClass);
    htmlRow += "</tr>\n";
    
    if(!safeFileWrite(self.FileName, htmlRow, "append"))
    {
        self iPrintLn(&"CJ_ERROR_OPEN_FILE");
        self thread initJumpHTMLFile();
        return;
    }
}

// Finalizes HTML file with statistics and closes file
closeJumpHTMLFile()
{
    if(self.jumpNumber > 0)
    {
        successRate = int((self.successfulJumps / self.totalJumps) * 100);
        
        htmlFooter = "</table>\n" +
                    "</div>\n" +
                    "<div style='margin-top: 20px; padding: 10px; background-color: #f0f0f0; border-radius: 5px;'>\n" +
                    "<h3>Jump Session Statistics</h3>\n" +
                    "<p>Total Jumps: " + self.totalJumps + "</p>\n" +
                    "<p>Successful Jumps: " + self.successfulJumps + "</p>\n" +
                    "<p>Failed Jumps: " + (self.totalJumps - self.successfulJumps) + "</p>\n" +
                    "<p>Success Rate: " + successRate + "%</p>\n" +
                    "</div>\n" +
                    "</body>\n" +
                    "</html>";
        
        if(!safeFileWrite(self.FileName, htmlFooter, "append"))
        {
            self iPrintLn(&"CJ_ERROR_CLOSE_FILE");
        }
        else
        {
            self iPrintLn("Jump data saved to: " + self.FileName);
        }
    }
}

// Handles cleanup when player disconnects
onPlayerDisconnect()
{
    self waittill("disconnect");
    self closeJumpHTMLFile();
}

// Checks cvar values to control recording state 
monitorRecordingCvar()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    wait 0.5;
    
    while(1)
    {
        recordingControlValue = getcvar("stat");
        
        if (recordingControlValue == "record" || recordingControlValue == "RECORD")
        {
            if (!self.isRecordingEnabled)
            {
                self markReferenceJump();
            }
            else
            {
                if (!isDefined(self.lastReferenceMessageTime) || (GetTime() - self.lastReferenceMessageTime > 3000))
                {
                    self iPrintLnBold("Recording already active. Set stat to 'stop' first.");
                    self.lastReferenceMessageTime = GetTime();
                }
            }
            
            setcvar("stat", "idle");
        }
        else if (recordingControlValue == "stop" || recordingControlValue == "STOP")
        {
            if (self.isRecordingEnabled)
            {
                self stopRecordingSession();
            }
            else
            {
                self iPrintLnBold("No active recording to stop.");
            }
            
            setcvar("stat", "idle");
        }
        
        wait 0.5; 
    }
}

// Establishes reference point for jump recording
markReferenceJump()
{
    self.z_worldpos = self.origin[2];
    self.firstSuccessRecorded = true;
    self.isTrackingJumps = true;
    self.reference_z_worldpos = self.origin[2];
    
    if(!isDefined(self.goldenValues))
    {
        self initGoldenValues();
    }
    
    if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && isDefined(self.dominantAxis) && self.dominantAxis != "")
    {
        self.recordingReferencePoint1 = self.measurePoint1;
        self.recordingReferencePoint2 = self.measurePoint2;
        self.recordingDominantAxis = self.dominantAxis;
    }
    
    self thread initJumpHTMLFile();
    
    wait 0.1; 
    self.isRecordingEnabled = true;
    
    self iPrintLnBold("Recording enabled. Set stat to 'stop' to end recording");
    
    self.lastJumpTracked = false;
}

// Ends recording session and resets tracking variables
stopRecordingSession()
{
    self closeJumpHTMLFile();
    
    self.referenceJumpsCount = 0;
    self.isRecordingEnabled = false;
    self.isTrackingJumps = false;
    self.reference_z_worldpos = 0;
    self.jumpNumber = 0;
    self.successfulJumps = 0;
    self.totalJumps = 0;
    
    self.recordingReferencePoint1 = undefined;
    self.recordingReferencePoint2 = undefined;
    self.recordingDominantAxis = "";
    
    self iPrintLnBold("Recording stopped");
}

// Determines jump success based on height deviation from reference point
determineJumpSuccess()
{
    if (!self.firstSuccessRecorded)
    {
        return true; 
    }
    
    zDeviation = abs(self.origin[2] - self.z_worldpos);
    
    if (zDeviation > 5) 
    {
        return false;
    }
    return true;
} 