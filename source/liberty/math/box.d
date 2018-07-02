/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:			$(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/math/box.d, _box.d)
 * Documentation:
 * Coverage:
 */
module liberty.math.box;
import liberty.math.vector : Vector;
///
struct Box(T, int N) if (N >= 1 && N <= 3) {
	///
	enum dim = N;
	///
	alias type = T;
	///
	alias BoundType = Vector!(T, N);
	///
	BoundType min;
	///
	BoundType max;
	///
	this(BoundType min, BoundType max) pure nothrow @safe @nogc {
		this.min = min;
		this.max = max;
	}
	static if (N == 1) {
		///
		this(T min, T max) pure nothrow @safe @nogc {
			this.min.x = min;
			this.max.x = max;
		}
	}
	static if (N == 2) {
		///
		this(T min_x, T min_y, T max_x, T max_y) pure nothrow @safe @nogc {
			min = BoundType(min_x, min_y);
			max = BoundType(max_x, max_y);
		}
	}
	static if (N == 3) {
		this(T min_x, T min_y, T min_z, T max_x, T max_y, T max_z) pure nothrow @safe @nogc {
			min = BoundType(min_x, min_y, min_z);
			max = BoundType(max_x, max_y, max_z);
		}
	}
	/// Returns dimensions of the box.
	BoundType size() pure nothrow const @safe @nogc @property {
		return max - min;
	}
	/// Returns center of the box.
	BoundType center() pure nothrow const @safe @nogc @property {
		return (min + max) / 2;
	}
	/// Returns width of the box.
	T width() pure nothrow const @safe @nogc @property {
		return max.x - min.x;
	}
	static if (N >= 2) {
		/// Returns height of the box.
		T height() pure nothrow const @safe @nogc @property {
			return max.y - min.y;
		}
	}
	static if (N >= 3) {
		/// Returns depth of the box.
		T depth() pure nothrow const @safe @nogc @property {
			return max.z - min.z;
		}
	}
	/// Returns signed volume of the box.
	T volume() pure nothrow const @safe @nogc @property {
		T ret = 1;
		BoundType size = size();
		static foreach (i; 0..N) {
			ret *= size[i];
		}
		return ret;
	}
	/// Returns true if empty.
	bool empty() pure nothrow const @safe @nogc @property {
		BoundType size = size();
		static foreach (i; 0..N) {
			if (min[i] == max[i]) {
				return true;
			}
		}
		return false;
	}
	/// Returns true if it contains point.
	bool contains(BoundType point) pure nothrow const @safe @nogc
	in {
		assert(isSorted());
	} do {
		static foreach (i; 0..N) {
			if (!(point[i] >= min[i] && point[i] < max[i])) {
				return false;
			}
		}
		return true;
	}
	///
	bool contains(Box other) pure nothrow const @safe @nogc
	in {
		assert(isSorted());
		assert(other.isSorted());
	} do {
		static foreach (i; 0..N) {
			if ((other.min[i] < min[i]) || (other.max[i] > max[i])) {
				return false;
			}
		}
		return true;
	}
	///
	real squaredDistance(BoundType point) pure nothrow const @safe @nogc
	in {
		assert(isSorted());
	} do {
		real distanceSquared = 0;
		static foreach (i; 0..N) {
			if (point[i] < min[i]) {
				distanceSquared += (point[i] - min[i]) ^^ 2;
			}
			if (point[i] > max[i]) {
				distanceSquared += (point[i] - max[i]) ^^ 2;
			}
		}
		return distanceSquared;
	}
	///
	real distance(BoundType point) pure nothrow const @safe @nogc {
		import liberty.math.functions : sqrt;
		return sqrt(squaredDistance(point));
	}
	///
	real squaredDistance(Box o) pure nothrow const @safe @nogc
	in {
		assert(isSorted());
		assert(o.isSorted());
	} do {
		real distanceSquared = 0;
		static foreach (i; 0..N) {
			if (o.max[i] < min[i]) {
				distanceSquared += (o.max[i] - min[i]) ^^ 2;
			}
			if (o.min[i] > max[i]) {
				distanceSquared += (o.min[i] - max[i]) ^^ 2;
			}
		}
		return distanceSquared;
	}
	///
	real distance(Box o) pure nothrow const @safe @nogc {
		import liberty.math.functions : sqrt;
		return sqrt(squaredDistance(o));
	}
	///
	Box intersection(Box o) pure nothrow const @safe @nogc
	in {
		assert(isSorted());
		assert(o.isSorted());
	} do {
		if (empty()) {
			return this;
		}
		if (o.empty()) {
			return o;
		}
		Box ret;
		T maxOfMins = 0;
		T minOfMaxs = 0;
		static foreach (i; 0..N) {
			maxOfMins = (min.v[i] > o.min.v[i]) ? min.v[i] : o.min.v[i];
			minOfMaxs = (max.v[i] < o.max.v[i]) ? max.v[i] : o.max.v[i];
			ret.min.v[i] = maxOfMins;
			ret.max.v[i] = minOfMaxs >= maxOfMins ? minOfMaxs : maxOfMins;
		}
		return ret;
	}
	///
	bool intersects(Box other) pure nothrow const @safe @nogc {
		Box inter = this.intersection(other);
		return inter.isSorted() && !inter.empty();
	}
	///
	Box grow(BoundType space) pure nothrow const @safe @nogc {
		Box ret = this;
		ret.min -= space;
		ret.max += space;
		return ret;
	}
	///
	Box shrink(BoundType space) pure nothrow const @safe @nogc {
		return grow(-space);
	}
	///
	Box grow(T space) pure nothrow const @safe @nogc {
		return grow(BoundType(space));
	}
	///
	Box translate(BoundType offset) pure nothrow const @safe @nogc {
		return Box(min + offset, max + offset);
	}
	///
	Box shrink(T space) pure nothrow const @safe @nogc {
		return shrink(BoundType(space));
	}
	///
	Box expand(BoundType point) pure nothrow const @safe @nogc {
		import liberty.math.vector : minByElem, maxByElem;
		return Box(minByElem(min, point), maxByElem(max, point));
	}
	///
	Box expand(Box other) pure nothrow const @safe @nogc
	in {
		assert(isSorted());
		assert(other.isSorted());
	} do {
		if (empty()) {
			return other;
		}
		if (other.empty()) {
			return this;
		}
		Box ret;
		T minOfMins = 0;
		T maxOfMaxs = 0;
		static foreach (i; 0..N) {
			minOfMins = (min.v[i] < other.min.v[i]) ? min.v[i] : other.min.v[i];
			maxOfMaxs = (max.v[i] > other.max.v[i]) ? max.v[i] : other.max.v[i];
			ret.min.v[i] = minOfMins;
			ret.max.v[i] = maxOfMaxs;
		}
		return ret;
	}
	///
	bool isSorted() pure nothrow const @safe @nogc {
		static foreach (i; 0..N) {
			if (min[i] > max[i]) {
				return false;
			}
		}
		return true;
	}
	///
	ref Box opAssign(U)(U x) nothrow @safe @nogc if (isBox!U) {
		static if(is(U.type : T)) {
			static if(U.dim == dim) {
				min = x.min;
				max = x.max;
			} else  {
				static assert(false, "No conversion between boxes with different dimensions available!");
			}
		} else {
			static assert(false, "No conversion from " ~ U.type.stringof ~ " to " ~ type.stringof ~ " available!");
		}
		return this;
	}
	///
	bool opEquals(U)(U other) pure nothrow const @safe @nogc if (is(U : Box)) {
		return (min == other.min) && (max == other.max);
	}
	/// Cast to other box types.
	U opCast(U)() pure nothrow const @safe @nogc if (isBox!U) {
		U b = void;
		static foreach (i; 0..N) {
			b.min[i] = cast(U.type)(min[i]);
			b.max[i] = cast(U.type)(max[i]);
		}
		return b;
	}
	static if (N == 2) {
		///
		static Box rectangle(T x, T y, T width, T height) pure nothrow @safe @nogc {
			return Box(x, y, x + width, y + height);
		}
	}
}
///
alias DimensionType(T : Box!U, U...) = U[0];
///
unittest {
	static assert (is(DimensionType!Box2F == float));
	static assert (is(DimensionType!Box3D == double));
}
///
enum isBox(T) = is(T : Box!U, U...);
///
pure nothrow @safe @nogc unittest {
	static assert (isBox!Box2F);
	static assert (isBox!Box3I);
	static assert (isBox!(Box!(double, 2)));
	static assert (!isBox!(Vector!(float, 3)));
}
///
template Box2(T) {
	alias Box2 = Box!(T, 2);
}
///
template Box3(T) {
	alias Box3 = Box!(T, 3);
}
///
alias Box2I = Box2!int;
///
alias Box3I = Box3!int;
///
alias Box2F = Box2!float;
///
alias Box3F = Box3!float;
///
alias Box2D = Box2!double;
///
alias Box3D = Box3!double;