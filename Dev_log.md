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