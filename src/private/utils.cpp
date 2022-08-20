#include "utils.h"

namespace ClipperLib {
  Paths BooleanOp(ClipType cliptype, PolyFillType fillType,
    const Paths& subjects, const Paths& clips)
  {
    Paths result;
    Clipper clipper;
    clipper.AddPaths(subjects, PolyType::ptSubject, true);
    clipper.AddPaths(clips, PolyType::ptSubject, true);
    clipper.Execute(cliptype, result, fillType);
    return result;
  }

  Paths Intersect(const Paths& subjects, const Paths& clips, PolyFillType fillType)
  {
    return BooleanOp(ClipType::ctIntersection, fillType, subjects, clips);
  }

  Paths Union(const Paths& subjects, const Paths& clips, PolyFillType fillType)
  {
    return BooleanOp(ClipType::ctUnion, fillType, subjects, clips);
  }

  Paths Difference(const Paths& subjects, const Paths& clips, PolyFillType fillType)
  {
    return BooleanOp(ClipType::ctDifference, fillType, subjects, clips);
  }

  Paths Xor(const Paths& subjects, const Paths& clips, PolyFillType fillType)
  {
    return BooleanOp(ClipType::ctXor, fillType, subjects, clips);
  }
}