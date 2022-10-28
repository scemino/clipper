import std/strutils

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passc: "-I" & currentSourceDir() & "/private/ClipperLib" & " -I" & currentSourceDir() & "/private".}
{.compile: "private/ClipperLib/clipper.cpp",
  compile: "private/utils.cpp".}

{.push header: "<clipper.hpp>", header: "utils.h".}

type
  IntPoint* {.importcpp: "ClipperLib::IntPoint".} = object
    X*: cint
    Y*: cint
  Path* {.importcpp: "ClipperLib::Path".} = object
  Paths* {.importcpp: "ClipperLib::Paths".} = object
  PolyType* {.importcpp: "ClipperLib::PolyType".} = enum
    ptSubject,
    ptClip
  PolyFillType* {.importcpp: "ClipperLib::PolyFillType".} = enum
    pftEvenOdd,
    pftNonZero,
    pftPositive,
    pftNegative
  ClipType* {.importcpp: "ClipperLib::ClipType".} = enum
    ctIntersection,
    ctUnion,
    ctDifference,
    ctXor
{.pop.} # {.push header: "<clipper.h>".}

proc Intersect*(subjects, clips: Paths, fillType: PolyFillType): Paths {.importcpp: "ClipperLib::Intersect(@)".}
  ## This function intersects subject paths with clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Union*(subjects, clips: Paths, fillType: PolyFillType): Paths {.importcpp: "ClipperLib::Union(@)".}
  ## This function 'unions' together subject paths, with or without clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Difference*(subjects, clips: Paths, fillType: PolyFillType): Paths {.importcpp: "ClipperLib::Difference(@)".}
  ## This function 'differences' subject paths from clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Xor*(subjects, clips: Paths, fillType: PolyFillType): Paths {.importcpp: "ClipperLib::Xor(@)".}
  ## This function 'XORs' subject paths and clip paths. For more complex clipping operations, you'll likely need to use Clipper64 (or ClipperD) directly.
proc Orientation*(poly: Path): bool {.importcpp: "ClipperLib::Orientation(@)".}
  ## Orientation is only important to closed paths. Given that vertices are declared in a specific order, orientation refers to the direction (clockwise or counter-clockwise) that these vertices progress around a closed path.

proc len*(v: Path): csize_t {.importcpp: "size".}
proc len*(v: Paths): csize_t {.importcpp: "size".}
proc unsafeIndex(self: var Paths, i: csize_t): var Path {.importcpp: "#[#]".}
proc unsafeIndex(self: Paths, i: csize_t): lent Path {.importcpp: "#[#]".}
proc unsafeIndex(self: var Path, i: csize_t): var IntPoint {.importcpp: "#[#]".}
proc unsafeIndex(self: Path, i: csize_t): lent IntPoint {.importcpp: "#[#]".}
proc add*(self: var Paths, path: Path) {.importcpp: "push_back".}
proc add*(self: var Path, point: IntPoint) {.importcpp: "push_back".}

# Element access
proc `[]`*(self: Paths, idx: Natural): lent Path {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i)

proc `[]`*(self: var Paths, idx: Natural): var Path {.inline.} =
  let i = csize_t(idx)
  (addr self.unsafeIndex(i))[]

proc `[]=`*[T](self: var Paths, idx: Natural, val: Path) {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i) = val

proc `[]`*(self: Path, idx: Natural): lent IntPoint {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i)

proc `[]`*(self: var Path, idx: Natural): var IntPoint {.inline.} =
  let i = csize_t(idx)
  (addr self.unsafeIndex(i))[]

proc `[]=`*[T](self: var Path, idx: Natural, val: IntPoint) {.inline.} =
  let i = csize_t(idx)
  self.unsafeIndex(i) = val

iterator items*(v: Paths): Path =
  for idx in 0.csize_t ..< v.len():
    yield v[idx]

iterator items*(v: Path): IntPoint =
  for idx in 0.csize_t ..< v.len():
    yield v[idx]

when isMainModule:
  var subject, clip: Paths
  var path, path2: Path
  path.add IntPoint(X: 100, Y: 50)
  path.add IntPoint(X: 10, Y: 79)
  path.add IntPoint(X: 65, Y: 2)
  path.add IntPoint(X: 65, Y: 98)
  path.add IntPoint(X: 10, Y: 21)

  path2.add IntPoint(X: 98, Y: 63)
  path2.add IntPoint(X: 4, Y: 68)
  path2.add IntPoint(X: 77, Y: 8)
  path2.add IntPoint(X: 52, Y: 100)
  path2.add IntPoint(X: 19, Y: 12)
  subject.add path
  clip.add path2
  let solution = Intersect(subject, clip, pftNonZero)

  echo solution.len
  for path in solution:
    for pt in path:
      echo $pt
