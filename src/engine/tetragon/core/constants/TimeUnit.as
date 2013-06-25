/* *      _________  __      __ *    _/        / / /____ / /________ ____ ____  ___ *   _/        / / __/ -_) __/ __/ _ `/ _ `/ _ \/ _ \ *  _/________/  \__/\__/\__/_/  \_,_/\_, /\___/_//_/ *                                   /___/ *  * Tetragon : Game Engine for multi-platform ActionScript projects. * http://www.tetragonengine.com/ - Copyright (C) 2012 Sascha Balkau *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE * SOFTWARE. */package tetragon.core.constants{	/**	 * Provides constants for time measurement units.	 */	public final class TimeUnit	{		//-----------------------------------------------------------------------------------------		// Constants		//-----------------------------------------------------------------------------------------				public static const MILLISECOND:int					= 1;		public static const SECOND:int						= 1000;		public static const MINUTE:int						= SECOND * 60;	// 60.000		public static const HOUR:int						= MINUTE * 60;	// 3.600.000		public static const DAY:int							= HOUR * 24;	// 86.400.000		public static const WEEK:int						= DAY * 7;		// 604.800.000		public static const YEAR:Number						= DAY * 365;	// 31.536.000.000				public static const SYMBOL_MILLISECOND:String		= "ms";		public static const SYMBOL_SECOND:String			= "s";		public static const SYMBOL_MINUTE:String			= "m";		public static const SYMBOL_HOUR:String				= "h";		public static const SYMBOL_DAY:String				= "d";		public static const SYMBOL_WEEK:String				= "w";		public static const SYMBOL_YEAR:String				= "y";				public static const SYMBOL_LONG_MILLISECOND:String	= "Millisecond";		public static const SYMBOL_LONG_SECOND:String		= "Second";		public static const SYMBOL_LONG_MINUTE:String		= "Minute";		public static const SYMBOL_LONG_HOUR:String			= "Hour";		public static const SYMBOL_LONG_DAY:String			= "Day";		public static const SYMBOL_LONG_WEEK:String			= "Week";		public static const SYMBOL_LONG_YEAR:String			= "Year";	}}