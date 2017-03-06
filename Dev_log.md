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


31. GameMechanics, EntityFactory, EntityTemplates
    - Enemy creation 2
32. GameMechanics, EntityFactory, AnimatedTextQueue
    - Fixed and finished enemy creation