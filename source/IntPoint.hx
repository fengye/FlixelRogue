package;

import flixel.FlxG;
import flash.geom.Point;
import flixel.interfaces.IFlxPooled;
import flixel.util.FlxStringUtil;
import flixel.util.FlxRect;
import flixel.util.FlxPool;
import flixel.util.FlxMath;

/**
 * Stores a 2D integer coordinate.
 */
class IntPoint implements IFlxPooled
{
	private static var _pool = new FlxPool<IntPoint>(IntPoint);
	
	/**
	 * Recycle or create a new IntPoint. 
	 * Be sure to put() them back into the pool after you're done with them!
	 * 
	 * @param	X		The X-coordinate of the point in space.
	 * @param	Y		The Y-coordinate of the point in space.
	 * @return	This point.
	 */
	public static inline function get(X:Int = 0, Y:Int = 0):IntPoint
	{
		var point = _pool.get().set(X, Y);
		point._inPool = false;
		return point;
	}
	
	/**
	 * Recycle or create a new IntPoint which will automatically be released 
	 * to the pool when passed into a flixel function.
	 * 
	 * @param	X		The X-coordinate of the point in space.
	 * @param	Y		The Y-coordinate of the point in space.
	 * @return	This point.
	 */
	public static inline function weak(X:Int = 0, Y:Int = 0):IntPoint
	{
		var point = _pool.get().set(X, Y);
		point._weak = true;
		return point;
	}
	
	public var x(default, set):Int = 0;
	public var y(default, set):Int = 0;
	
	private var _weak:Bool = false;
	private var _inPool:Bool = false;
	
	public function new(X:Int = 0, Y:Int = 0) 
	{
		set(X, Y);
	}
	
	/**
	 * Add this IntPoint to the recycling pool.
	 */
	public function put():Void
	{
		if (!_inPool)
		{
			_inPool = true;
			_pool.putUnsafe(this);
		}
	}
	
	/**
	 * Add this IntPoint to the recycling pool if it's a weak reference (allocated via weak()).
	 */
	public inline function putWeak():Void
	{
		if (_weak)
		{
			put();
		}
	}
	
	/**
	 * Set the coordinates of this point.
	 * 
	 * @param	X	The X-coordinate of the point in space.
	 * @param	Y	The Y-coordinate of the point in space.
	 * @return	This point.
	 */
	public function set(X:Int = 0, Y:Int = 0):IntPoint
	{
		x = X;
		y = Y;
		return this;
	}
	
	/**
	 * Adds the to the coordinates of this point.
	 * 
	 * @param	X	Amount to add to x
	 * @param	Y	Amount to add to y
	 * @return	This point.
	 */
	public inline function add(X:Int = 0, Y:Int = 0):IntPoint
	{
		x += X;
		y += Y;
		return this;
	}
	
	/**
	 * Adds the coordinates of another point to the coordinates of this point.
	 * 
	 * @param	point	The point to add to this point
	 * @return	This point.
	 */
	public function addPoint(point:IntPoint):IntPoint
	{
		x += point.x;
		y += point.y;
		point.putWeak();
		return this;
	}
	
	/**
	 * Adds the to the coordinates of this point.
	 * 
	 * @param	X	Amount to subtract from x
	 * @param	Y	Amount to subtract from y
	 * @return	This point.
	 */
	public inline function subtract(X:Int = 0, Y:Int = 0):IntPoint
	{
		x -= X;
		y -= Y;
		return this;
	}
	
	/**
	 * Adds the coordinates of another point to the coordinates of this point.
	 * 
	 * @param	point	The point to subtract from this point
	 * @return	This point.
	 */
	public function subtractPoint(point:IntPoint):IntPoint
	{
		x -= point.x;
		y -= point.y;
		point.putWeak();
		return this;
	}
	
	/**
	 * Helper function, just copies the values from the specified point.
	 * 
	 * @param	point	Any IntPoint.
	 * @return	A reference to itself.
	 */
	public inline function copyFrom(point:IntPoint):IntPoint
	{
		x = point.x;
		y = point.y;
		return this;
	}
	
	/**
	 * Helper function, just copies the values from this point to the specified point.
	 * 
	 * @param	Point	Any IntPoint.
	 * @return	A reference to the altered point parameter.
	 */
	public function copyTo(?point:IntPoint):IntPoint
	{
		if (point == null)
		{
			point = IntPoint.get();
		}
		point.x = x;
		point.y = y;
		return point;
	}
	
	/**
	 * Helper function, just copies the values from the specified Flash point.
	 * 
	 * @param	Point	Any Point.
	 * @return	A reference to itself.
	 */
	public inline function copyFromFlash(FlashPoint:Point):IntPoint
	{
		x = Std.int(FlashPoint.x);
		y = Std.int(FlashPoint.y);
		return this;
	}
	
	/**
	 * Helper function, just copies the values from this point to the specified Flash point.
	 * 
	 * @param	Point	Any Point.
	 * @return	A reference to the altered point parameter.
	 */
	public inline function copyToFlash(FlashPoint:Point):Point
	{
		FlashPoint.x = x;
		FlashPoint.y = y;
		return FlashPoint;
	}
	
	/**
	 * Returns true if this point is within the given rectangular block
	 * 
	 * @param	RectX		The X value of the region to test within
	 * @param	RectY		The Y value of the region to test within
	 * @param	RectWidth	The width of the region to test within
	 * @param	RectHeight	The height of the region to test within
	 * @return	True if the point is within the region, otherwise false
	 */
	public inline function inCoords(RectX:Float, RectY:Float, RectWidth:Float, RectHeight:Float):Bool
	{
		return FlxMath.pointInCoordinates(x, y, RectX, RectY, RectWidth, RectHeight);
	}
	
	/**
	 * Returns true if this point is within the given rectangular block
	 * 
	 * @param	Rect	The FlxRect to test within
	 * @return	True if pointX/pointY is within the FlxRect, otherwise false
	 */
	public inline function inFlxRect(Rect:FlxRect):Bool
	{
		return FlxMath.pointInFlxRect(x, y, Rect);
	}
	
	/**
	 * Calculate the distance to another point.
	 * 
	 * @param 	AnotherPoint	A IntPoint object to calculate the distance to.
	 * @return	The distance between the two points as a Float.
	 */
	public inline function distanceTo(AnotherPoint:IntPoint):Float
	{
		return FlxMath.vectorLength(x - AnotherPoint.x, y - AnotherPoint.y);
	}
	
	/**
	 * Necessary for IFlxDestroyable.
	 */
	public function destroy() {}
	
	/**
	 * Convert object to readable string name. Useful for debugging, save games, etc.
	 */
	public inline function toString():String
	{
		return FlxStringUtil.getDebugString([ 
			LabelValuePair.weak("x", x),
			LabelValuePair.weak("y", y)]);
	}
	
	/**
	 * Necessary for FlxPointHelper in FlxSpriteGroup.
	 */
	private function set_x(Value:Int):Int 
	{ 
		return x = Value;
	}
	
	/**
	 * Necessary for FlxPointHelper in FlxSpriteGroup.
	 */
	private function set_y(Value:Int):Int
	{
		return y = Value; 
	}
}
