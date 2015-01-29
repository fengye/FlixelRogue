package;

import flixel.FlxG;

class GeomUtility
{
	static public function BresenhamLine(start:IntPoint, end:IntPoint ) : Array<IntPoint> 
	{
		var x0 = start.x;
		var y0 = start.y;
		var x1 = end.x;
		var y1 = end.y;

		var pts = [];
		var swapXY = fastAbs(y1 - y0) > fastAbs(x1 - x0);
		var tmp : Int;
		if ( swapXY ) 
		{
			// swap x and y
			tmp = x0; x0 = y0; y0 = tmp; // swap x0 and y0
			tmp = x1; x1 = y1; y1 = tmp; // swap x1 and y1
		}
		if ( x0 > x1 ) 
		{
			// make sure x0 < x1
			tmp = x0; x0 = x1; x1 = tmp; // swap x0 and x1
			tmp = y0; y0 = y1; y1 = tmp; // swap y0 and y1
		}
		var deltax = x1 - x0;
		var deltay = fastFloor(fastAbs(y1 - y0));
		var error = fastFloor(deltax / 2);
		var y = y0;
		var ystep = if ( y0 < y1 ) 1 else -1;
		
		if( swapXY )
		{
			// Y / X
			for ( x in x0...x1+1 ) 
			{
				pts.push(new IntPoint(y, x));
				error -= deltay;
				if ( error < 0 ) 
				{
					y = y + ystep;
					error = error + deltax;
				}
			}
		}
		else
		{
			// X / Y
			for ( x in x0...x1+1 ) 
			{
				pts.push(new IntPoint(x, y));
				error -= deltay;
				if ( error < 0 ) 
				{
					y = y + ystep;
					error = error + deltax;
				}
			}
		}
		return pts;
	}

	static public function BresenhamLineCheck(start:IntPoint, end:IntPoint, checkFunc:Int->Int->Bool, determineFunc:Int->Int->Void) : Bool
	{
		var x0 = start.x;
		var y0 = start.y;
		var x1 = end.x;
		var y1 = end.y;

		var pts = [];

		var swapXY = fastAbs(y1 - y0) > fastAbs(x1 - x0);
		var changeOrder = false;
		var tmp : Int;
		if ( swapXY ) 
		{
			// swap x and y
			tmp = x0; x0 = y0; y0 = tmp; // swap x0 and y0
			tmp = x1; x1 = y1; y1 = tmp; // swap x1 and y1
			//changeOrder = !changeOrder;
		}
		if ( x0 > x1 ) 
		{
			// make sure x0 < x1
			tmp = x0; x0 = x1; x1 = tmp; // swap x0 and x1
			tmp = y0; y0 = y1; y1 = tmp; // swap y0 and y1

			changeOrder = !changeOrder;
		}
		var deltax = x1 - x0;
		var deltay = fastFloor(fastAbs(y1 - y0));
		var error = fastFloor(deltax / 2);
		var y = y0;

		var ystep:Int;
		if (y0 < y1)
		{
			ystep = 1;
		}
		else
		{
			ystep = -1;
			//changeOrder = !changeOrder;
		}
		
		if( swapXY )
		{
			// Y / X
			for ( x in x0...x1+1 ) 
			{
				if (checkFunc(y, x))
				{
					pts.push(new IntPoint(y, x));
					//outputPos.set(y, x);
					//return true;
				}

				
				error -= deltay;
				if ( error < 0 ) 
				{
					y = y + ystep;
					error = error + deltax;
				}
			}
		}
		else
		{
			// X / Y
			for ( x in x0...x1+1 ) 
			{
				if (checkFunc(x, y))
				{
					pts.push(new IntPoint(x, y));
					//outputPos.set(x, y);
					//return true;
				}
				
				error -= deltay;
				if ( error < 0 ) 
				{
					y = y + ystep;
					error = error + deltax;
				}
			}
		}

		if (pts.length > 0)
		{
			if (changeOrder)
			{
				determineFunc(pts[pts.length-1].x, pts[pts.length-1].y);
			}
			else
			{
				determineFunc(pts[0].x, pts[0].y);
			}
			return true;
		}

		return false;
	}

	static public inline function fastAbs(v:Int) : Int 
	{
		return (v ^ (v >> 31)) - (v >> 31);
	}

	static public inline function fastFloor(v:Float) : Int 
	{
		return Std.int(v);
	}

}