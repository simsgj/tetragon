/* *      _________  __      __ *    _/        / / /____ / /________ ____ ____  ___ *   _/        / / __/ -_) __/ __/ _ `/ _ `/ _ \/ _ \ *  _/________/  \__/\__/\__/_/  \_,_/\_, /\___/_//_/ *                                   /___/ *  * Tetragon : Game Engine for multi-platform ActionScript projects. * http://www.tetragonengine.com/ - Copyright (C) 2012 Sascha Balkau *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE * SOFTWARE. */package tetragon.core.file{	import tetragon.core.file.types.*;			/**	 * FileTypes serves as an index for mapping filename extensions to file type classes.	 * You can use this index to obtain a class object which is of a type that can be used	 * to load files of the specified file extension.<br>	 * 	 * <p>For example using the <code>getFileClass()</code> method and specifying jpg as	 * the extension will return a class object of type ImageFile.</p><br>	 * 	 * <p>You can use the <code>registerFileExtension()</code> method to register any file	 * extensions that are not mapped by default.</p>	 * 	 * @see com.hexagonstar.file.types.IFile	 */	public final class FileTypes	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/**		 * @private		 */		private static const _types:Object =		{			"png":	ImageFile,			"jpg":	ImageFile,			"jpeg":	ImageFile,			"gif":	ImageFile,						"swf":	SWFFile,						"txt":	TextFile,			"html":	TextFile,			"htm":	TextFile,			"ini":	TextFile,			"css":	TextFile,			"php":	TextFile,			"as":	TextFile,			"js":	TextFile,						"xml":	XMLFile,						"mp3":	SoundFile,						"pbj":	BinaryFile,						"zip":	ZipFile		};						//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * Allows you to register any custom file extensions for the file type classes.		 * 		 * @param extension The file type extension to register.		 * @param filetypeClass The file type class (must implement IFile).		 * @return true if the file type extension was registered successfully, false if not		 *         (extension already exists).		 */		public static function registerFileExtension(extension:String, filetypeClass:Class):Boolean
		{			var e:String = extension.toLowerCase();
			var c:Class = _types[e];			if (c == null)
			{
				_types[e] = filetypeClass;				return true;			}			return false;		}						/**		 * Returns a file type class that can be used to contain files of the specified file		 * extension.		 * 		 * @param extension The file type extension for which to return a file object.		 * @return A class object of type IFile or <code>null</code> if the specified		 *         extension is not mapped to any file type class.		 */		public static function getFileClass(extension:String):Class
		{
			if (!extension || extension.length < 1) return null;
			return _types[extension.toLowerCase()];		}	}}