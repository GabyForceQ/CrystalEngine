/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/math/traits.d)
 * Documentation:
 * Coverage:
**/
module liberty.math.traits;

import liberty.math.matrix;
import liberty.math.quaternion;
import liberty.math.box;
import liberty.math.vector;
import liberty.math.shapes; 

/**
 * True if T is some kind of Vector.
**/
enum isVector(T) = is(T : Vector!U, U...);

/**
 *
**/
  unittest {
  static assert(isVector!Vector2F);
  static assert(isVector!Vector3I);
  static assert(isVector!(Vector4!uint));
  static assert(!isVector!real);
}

/**
 * The numeric type used to measure coordinates of a vector.
**/
alias DimensionType(T : Vector!U, U...) = U[0];

/**
 *
**/
  unittest {
  static assert(is(DimensionType!Vector2F == float));
  static assert(is(DimensionType!Vector3D == double));
  static assert(is(DimensionType!Vector4U == uint));
}

/**
 *
**/
template isMatrixInstance(U) {
	private static void isMatrix(T, int R, int C)(Matrix!(T, R, C) x) {}
	enum bool isMatrixInstance = is(typeof(isMatrix(U.init)));
}

/**
 *
**/
template isQuaternionInstance(U) {
	private static void isQuaternion(T)(Quaternion!T x) {}
	enum bool isQuaternionInstance = is(typeof(isQuaternion(U.init)));
}

/**
 *
**/
alias DimensionType(T : Box!U, U...) = U[0];

/**
 *
**/
  unittest {
	static assert(is(DimensionType!Box2F == float));
	static assert(is(DimensionType!Box3D == double));
}

/**
 *
**/
enum isBox(T) = is(T : Box!U, U...);

/**
 *
**/
  unittest {
	static assert(isBox!Box2F);
	static assert(isBox!Box3I);
	static assert(isBox!(Box!(double, 2)));
	static assert(!isBox!(Vector!(float, 3)));
}

/**
 *
**/
enum isSegment(T) = is(T : Segment!U, U...);

/**
 *
**/
enum isTriangle(T) = is(T : Triangle!U, U...);

/**
 *
**/
enum isSphere(T) = is(T : Sphere!U, U...);

/**
 *
**/
enum isRay(T) = is(T : Ray!U, U...);

/**
 *
**/
enum isPlane(T) = is(T : Plane!U, U);

/**
 *
**/
enum isFrustum(T) = is(T : Frustum!U, U);

/**
 *
**/
enum isSegment2D(T) = is(T : Segment!(U, 2), U);

/**
 *
**/
enum isTriangle2D(T) = is(T : Triangle!(U, 2), U);

/**
 *
**/
enum isSphere2D(T) = is(T : Sphere!(U, 2), U);

/**
 *
**/
enum isRay2D(T) = is(T : Ray!(U, 2), U);

/**
 *
**/
enum isSegment3D(T) = is(T : Segment!(U, 3), U);

/**
 *
**/
enum isTriangle3D(T) = is(T : Triangle!(U, 3), U);

/**
 *
**/
enum isSphere3D(T) = is(T : Sphere!(U, 3), U);

/**
 *
**/
enum isRay3D(T) = is(T : Ray!(U, 3), U);

/**
 *
**/
alias DimensionType(T : Segment!U, U...) = U[0];

/**
 *
**/
alias DimensionType(T : Triangle!U, U...) = U[0];

/**
 *
**/
alias DimensionType(T : Sphere!U, U...) = U[0];

/**
 *
**/
alias DimensionType(T : Ray!U, U...) = U[0];

/**
 *
**/
alias DimensionType(T : Plane!U, U) = U;

/**
 *
**/
alias DimensionType(T : Frustum!U, U) = U;

/**
 *
**/
  unittest {
	static assert(is(DimensionType!Segment2I == int));
	static assert(is(DimensionType!Triangle3F == float));
	static assert(is(DimensionType!Sphere2D == double));
	static assert(is(DimensionType!Ray3F == float));
	static assert(is(DimensionType!PlaneD == double));
	static assert(is(DimensionType!(Frustum!float) == float));
}