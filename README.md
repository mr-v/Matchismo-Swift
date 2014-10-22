# Matchismo
A Swift version of Matchismo game from Stanford's cs193p course "Developing iOS 7 Apps for iPhone and iPad" (2013/2014).

Requires Xcode 6.1 to build.

## Idea
Use applications functionality from lectures/assignments as a set of requirements, but don't follow class design from lectures.
Differences in approach to code design and implementation:
  - design without insight into how application will change during next lecture (e.g. avoid creating inheritance hierarchies prematurely)
  - use MVVM-like view-model adapter between game logic and UI
  - keep view controllers light
  - develop game's logic and view-model in a TDD manner
- take advantage of Swift language features, including:
  - enums
  - structs
  - generics
- use UICollectionView for cards' layout
  - to switch between layouts - pinch-in/out
  - custom layouts features:
    - scales collection view items to fit all on screen
    - UIDynamics driven layout for gathering cards in a stack and moving them around

## Tags
Each set of requirements is tagged (milestones: lectures, assignments)

## Credits
PlayingCardView - based on a code from lectures, converted to Swift
playing card images - taken from cs193p's SuperCard project

