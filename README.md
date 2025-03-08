# Jumper Mod

Requirements : 
- node 


Watch files to generate iwd
```bash
npm install
node watch.js
```

# Jumper Mod

## FPS Settings (Press V+4)
- 1: 125 FPS
- 2: 250 FPS
- 3: 333 FPS
- 4: 76 FPS
- 5: 43 FPS

## Other Settings (Press V+5)
- 1: Toggle jumptimer
- 2: Toggle position HUD
- 3: Choose pistol
- 4: Toggle fall damage

## Position Management
- Double-tap Shift/Melee: Save position 
- Double-tap F/Use: Load most recent position
- F + Left Mouse: Load position history
- Hold F + Left Mouse: Cycle through saved positions

## Measurement Tool
- Equip Kar98k and press attack button twice to measure distance
- First press sets start point, second sets end point
- Displays horizontal distance and height difference
- Edge Distance: Measures the distance from jump start/end points to the measured edges
- Use the measurement tool to mark platform edges before jumping
- After jumping, edge distances will be calculated automatically
- Shows how far from the edge you started and landed your jump

## Jump Recording & HUD
- Set the console command "stat record" to start recording jumps.
- Jump data is automatically saved to an HTML file in main folder 'scriptdata'.
- Set "stat stop" to end recording session and reset reference values.
- HTML reports now include color-coded metrics that show how close your jump was to "golden values"

###  HUD Elements
- Dynamic speed display that changes color based on acceleration/deceleration
- WASD + Space keyboard visualization
- jump statistics including edge distances and total jump distance
- Position coordinates with pitch and yaw angle display

## Known Issues / Missing Features
- Edge distance calculation may be inaccurate on certain angles or when measurement points are improperly set

Contact: Duck (JH Discord)
