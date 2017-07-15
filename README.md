# RunnerGameV2


Follow this guide to setup your repository:
http://www.studica.com/blog/how-to-setup-github-with-unity-step-by-step-instructions

About:
- 2D platformer ..


Mechanics Requirements:
- Jumping (single)
- Players Riding on top of each other.
- Player on bottom controls movement when both are connected.
- Players can swap from bottom to top and top to bottom.

Mechanics Ideas: (P2 rides P1)
- When p2 jumps while p1 is in the air it pushes p1 to the ground (unit double jump)
- When p2 jumps then p1 jumps and hits p2 while p1 is in the air it
  pushes p2 upwards.
- one player is larger(and stronger than the other) larger player can jump higher but has less control in air.
- one player is smaller than the other can jump decently but has more control in air.
- Perhaps players have to defend something behind them (aka the thing can take X amt of hits then it dies.. Kinda like a tower defense 
  mix with endless runner. Players could have their own health as well. 

Control Ideas:
- Left and right side of keyboard for each player. (WASD for p1, < ^ v > for P2)
- Can be played single player with one person controlling both characters (this should be more difficult).
- Can be played with one controller. P1 on left side of controller. P2 on right side of controller. One hand on controller
  for each person.

Design Requirements:
- ~~Proper Camera following~~ The scene moves around the player(s). Camera is static.
- Permenant Death


To Do:
  Friday
- Concept art and design drawn out
- Setup Environment
- Finish Camera and scrolling environment
- Player 1 and Player 2 implementation
