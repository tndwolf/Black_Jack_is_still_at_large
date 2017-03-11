##Pomodoros
1. World, GameComponent, Behavior, GameSystem
2. HTML, Services, UserInput, -Card, -Deck
    - First issue, not getting focus from Canvas
3. --Widget, Map, MapFactory

Stop

4. Map, Renderer, GameOutput
5. Map, -Services, Color, MapFactory, UserInput
6. Map.toString...
    - One full pomodoro for serialization... let's move this to the nice-to-have
    
Lunch

7. FoV, -Actor, -PhysicalActor, World
8. Fov, -EntityFactory, -GameMechanics
9. FoV, EntityFactory, -UserInputs, GameMechanics, RenderObject,
    - @ moving around!
10. HTML, FoV

Stop

11. HTML, GameMechanics
12. GameMechanics, Suites, PhysicalObject, GameOutput
    - Blackjack essentially implemented
13. GameMechanics, Actor, EntityFactory
    - Attacking 1
14. GameMechanics, Renderer, GameOutput
    - Attacking 2, Z order, Pointer
    
Stop + Dinner

15. TurnManager, UserInputs, -Actor, GameMechanics
    - Started Turn Manager
16.  TurnManager, UserInputs, World, GameMechanics
    - Tried dynamic turn updates... rolled back to fixed updates
    - Also issues with list.where
17. -Renderer, GameMechanics, -GridManager, World, -GameSystem
    - LoS
19. GameMechanics
    - Still issues with attacking...
    
## Second Day

20. MapFactory
    - Started working on map generation
21. MapFactory
    - Decided to use specialized diggers
22. MapFactory
    - Desert and open Mines essentially done
24. MapFactory, GameMap
    - Improvement to Mines, now complete
    
Stop

25. MapFactory, 
    - Exits 1
26. MapFactory, World, GameMechanics
    - Level transitions completed, player is permanent
    
Lunch

27. -Actor, GameMechanics
    - Enemy AI, fixed attack bug
28. -Widget, TextBox, AnimatedText, GameMechanics
    - Flee AI, Animated text for notifications
29. GameMechanics, PhysicalObject, -MapFactory
    - Fixed latest bug with Health, bit of refactoring
30. GameMechanics, EntityFactory, EntityTemplates
    - Enemy creation 1

Stop

31. GameMechanics, EntityFactory, EntityTemplates
    - Enemy creation 2
32. GameMechanics, EntityFactory, AnimatedTextQueue
    - Fixed and finished enemy creation
    
Headache

33. GameMechanics, EntityFactory, AnimatedTextQueue, World
    - Bugfixing
34. GameMechanics, EntityTemplates
    - Enemies and enemies creation on the map
    
Headache + Sleep


## Third Day

35. GameOutput, -GameMechanics, -Card
    - Identification of enemies and better description boxes
36. GameMechanics, AnimatedTextQueue, -EntityFactory
    - Refinement and bug fixing

Dinner

37. GameMechanics, AnimatedTextQueue, -World
    - More bugfixing and refinement
38. GameMechanics, AnimatedTextQueue, -UserInputs
    - Implemented Endgame, in theory the game is done!
    
## Fourth Day

39. GameMechanics, UserInputs, GridManager, GameOutput
    - Better AI, implemented BUSTED status (buggy? cannot understand), Basic sound!
40. GameMechanics, MapFactory, EntityFactory
    - Fixed generation of mines and enemies generation
41. GameMechanics, EntityFactory
    - More bugfixing
    
## Fifth Day

42. GameMechanics, GridManager, -PhysicalObject, Tile, GameOutput
    - Started implementing cover
43. GameMechanics, -GridManager, UserInputs, GameOutput
    - Implemented Cover
44. GameMechanics, Fade, -World
    - Winning condition better implemented
    
## Sixth Day

45. AssetsManager, GameMechanics, Main, -GameOutput
    - Fixed pointer bug and invisibility bug, assets management for sound
46. GameMechanics, UserInputs, GameOutput
    - Game Screens (Title, HELP, DEAD)
47. GameMechanics, UserInputs, GameOutput, Fade, AssetsManager, -Main
    - Background images and completed game screens and reload after death
    
## Seventh Day

48. Renderer, UserInputs, TextBox, Fade, Widget, GameMechanics, GameMap, RenderObject
    - Center screen around player, better fade and LoS graphics
49. Tile, EntityTemplates, GameMechanics, MapFactory, GameMap
    - Better colors and tile display