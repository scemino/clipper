#include "ClipperLib/clipper.hpp"

namespace ClipperLib {
Paths BooleanOp(ClipType cliptype, PolyFillType fillType, const Paths& subjects, const Paths& clips);

Paths Intersect(const Paths& subjects, const Paths& clips, PolyFillType fillType);
Paths Union(const Paths& subjects, const Paths& clips, PolyFillType fillType);
Paths Difference(const Paths& subjects, const Paths& clips, PolyFillType fillType);
Paths Xor(const Paths& subjects, const Paths& clips, PolyFillType fillType);
}
