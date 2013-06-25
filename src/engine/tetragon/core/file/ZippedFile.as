/* *      _________  __      __ *    _/        / / /____ / /________ ____ ____  ___ *   _/        / / __/ -_) __/ __/ _ `/ _ `/ _ \/ _ \ *  _/________/  \__/\__/\__/_/  \_,_/\_, /\___/_//_/ *                                   /___/ *  * Tetragon : Game Engine for multi-platform ActionScript projects. * http://www.tetragonengine.com/ - Copyright (C) 2012 Sascha Balkau *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE * SOFTWARE. */package tetragon.core.file{	import tetragon.core.constants.ZipConstants;	import tetragon.core.file.types.IFile;	import tetragon.core.file.types.ZipEntry;	import tetragon.core.file.types.ZipFile;	import tetragon.core.signals.Signal;	import tetragon.util.compr.Inflate;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.filesystem.File;	import flash.filesystem.FileMode;	import flash.filesystem.FileStream;	import flash.utils.ByteArray;			/**	 * @playerversion AIR 1.0	 */	public class ZippedFile implements IBulkFile	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/** @private */		protected var _file:IFile;		/** @private */		protected var _entry:ZipEntry;		/** @private */		protected var _offset:Number;		/** @private */		protected var _stream:FileStream;		/** @private */		protected var _buffer:ByteArray;		/** @private */		protected var _zipFile:File;		/** @private */		protected var _fileSize:Number;		/** @private */		protected var _bufferSize:Number;		/** @private */		protected var _over:Number;		/** @private */		protected var _extraLength:int;		/** @private */		protected var _retryCount:int;		/** @private */		protected var _status:String;		/** @private */		protected var _loading:Boolean;		/** @private */		protected static var _inflate:Inflate;						//-----------------------------------------------------------------------------------------		// Signals		//-----------------------------------------------------------------------------------------				/** @private */		protected var _fileOpenSignal:Signal;		/** @private */		protected var _fileProgressSignal:Signal;		/** @private */		protected var _fileCompleteSignal:Signal;		/** @private */		protected var _fileIOErrorSignal:Signal;						//-----------------------------------------------------------------------------------------		// Constructor		//-----------------------------------------------------------------------------------------				/**		 * Creates a new instance of the class.		 * 		 * @param file The file to be wrapped into the BulkFile.		 * @param entry		 * @param offset		 * @param stream		 * @param buffer		 * @param zipFile		 */		public function ZippedFile(file:IFile, entry:ZipEntry, offset:Number, stream:FileStream,			buffer:ByteArray, zipFile:File)		{			_fileOpenSignal = new Signal();			_fileProgressSignal = new Signal();			_fileCompleteSignal = new Signal();			_fileIOErrorSignal = new Signal();						_file = file;			_entry = entry;			_offset = offset;			_stream = stream;			_buffer = buffer;			_zipFile = zipFile;			_bufferSize = ZipLoader.bufferSize;						_status = BulkFile.STATUS_INITIALIZED;			_retryCount = 0;			_loading = false;			_extraLength = -1;						_fileSize = entry.compressionMethod == ZipConstants.DEFLATE				? _entry.compressedSize : _entry.size;
			_file.bytesTotal = _fileSize;		}				
		//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * @inheritDoc		 */		public function load(useAbsoluteFilePath:Boolean, preventCaching:Boolean):void		{			if (_loading) return;						_loading = true;			_status = BulkFile.STATUS_PROGRESSING;						_buffer.clear();			if (_fileOpenSignal) _fileOpenSignal.dispatch(this);						_stream.addEventListener(ProgressEvent.PROGRESS, onStreamProgress);			_stream.addEventListener(IOErrorEvent.IO_ERROR, onStreamError);			_stream.addEventListener(Event.COMPLETE, onStreamComplete);			
			_over = (_offset + _bufferSize) - _zipFile.size;						_stream.openAsync(_zipFile, FileMode.READ);			_stream.position = _offset;
			_stream.readAhead = _bufferSize;		}				
		/**		 * @inheritDoc		 */		public function dispose():void		{
			removeEventListeners();			removerSignalListeners();
			ZippedFile._inflate = null;		}						/**		 * @inheritDoc		 */		public function toString():String		{			return "[ZippedFile, path=" + _file.path + "]";		}						//-----------------------------------------------------------------------------------------		// Getters & Setters		//-----------------------------------------------------------------------------------------				/**		 * @inheritDoc		 */		public function get loading():Boolean		{			return _loading;		}						/**		 * @inheritDoc		 */		public function get file():IFile		{			return _file;		}						/**		 * @inheritDoc		 */		public function get priority():Number		{			return _file.priority;		}						/**		 * @inheritDoc		 */		public function get weight():int		{			return _file.weight;		}						/**		 * @inheritDoc		 */		public function get callback():Function		{			return _file.callback;		}						/**		 * @inheritDoc		 */		public function get params():Array		{			return _file.params;		}						/**		 * @inheritDoc		 */		public function get status():String		{			return _status;		}		public function set status(v:String):void		{			_status = v;		}						/**		 * Not used for ZippedFile!		 */		public function get retryCount():int		{			return 0;		}		public function set retryCount(v:int):void		{		}						/**		 * @inheritDoc		 */		public function get bytesLoaded():uint		{			return _file.bytesLoaded;		}						/**		 * @inheritDoc		 */		public function get bytesTotal():uint		{			return _file.bytesTotal;		}						/**		 * @inheritDoc		 */		public function get percentLoaded():Number		{			return _file.percentLoaded;		}						/**		 * Signal that is dispatched when a zipped file has been opened.		 * Listener signature: <code>onZippedFileOpen(zf:IBulkFile):void</code>		 */		public function get fileOpenSignal():Signal		{			return _fileOpenSignal;		}						/**		 * Listener signature: <code>onZippedFileProgress(zf:IBulkFile):void</code>		 */		public function get fileProgressSignal():Signal		{			return _fileProgressSignal;		}						/**		 * Listener signature: <code>onZippedFileComplete(zf:IBulkFile):void</code>		 */		public function get fileCompleteSignal():Signal		{			return _fileCompleteSignal;		}						/**		 * Listener signature: <code>onZippedFileIOError(zf:IBulkFile):void</code>		 */		public function get fileIOErrorSignal():Signal		{			return _fileIOErrorSignal;		}						/**		 * Not used for ZippedFile!		 */		public function get fileHTTPStatusSignal():Signal		{			return null;		}						/**		 * Not used for ZippedFile!		 */		public function get fileSecurityErrorSignal():Signal		{			return null;		}						//-----------------------------------------------------------------------------------------		// Event Handlers		//-----------------------------------------------------------------------------------------				/**		 * @private		 */		protected function onStreamProgress(e:ProgressEvent):void
		{
			_file.bytesLoaded = _buffer.length > _fileSize ? _fileSize : _buffer.length;						/* Only executed once! */
			if (_extraLength == -1)
			{				/* We only need the beginning two bytes of the chunk first */				if (_stream.bytesAvailable >= 2)				{					_extraLength = _stream.readShort();					_stream.position += _entry.path.length + _extraLength;
					_extraLength += _entry.path.length + 2;				}			}			else			{				if (_buffer.length >= _fileSize)				{					_stream.position = _zipFile.size;					return;				}				if (_stream.bytesAvailable >= _bufferSize)				{
					_stream.readBytes(_buffer, _stream.position - _offset - _extraLength, _bufferSize); 				}			}						_fileProgressSignal.dispatch(this);		}				
		/**		 * @private		 */		protected function onStreamError(e:IOErrorEvent):void		{			_status = BulkFile.STATUS_ERROR;			_loading = false;
			removeEventListeners();			_file.errorMessage = e.text;			_fileIOErrorSignal.dispatch(this);
		}						/**		 * @private		 */		protected function onStreamComplete(e:Event):void		{
			/* If _over is larger than 0 it means that the file chunk is within the end area			 * of the zip file that is smaller than the buffer size. This means that the end			 * is reached before the buffer is filled in onStreamProgress and onStreamComplete			 * is called before we can fetch the buffer so we need to take care of that here. */			if (_over > 0)			{				_stream.readBytes(_buffer, 0, _fileSize); 			}						/* Check if buffer length is sufficient. If not it might have loaded			 * a single stored file where we need to add the rest data from the stream. */			if (_buffer.length < _fileSize)			{
				_stream.readBytes(_buffer, _stream.position - _offset - _extraLength,					_fileSize - _buffer.length);			}			
			_file.bytesLoaded = _fileSize;						/* Special rule for ZipFiles: loaded size is not set on their			 * size property but their compressedSize since the size property			 * of a ZipFile should return it's uncompressed size to follow			 * same behavior with ZippedFiles! */			if (_file is ZipFile) ZipFile(_file).compressedSize = bytesLoaded;			else _file.bytesLoaded = bytesLoaded;						_fileProgressSignal.dispatch(this);			processBuffer();		}						/**		 * @private		 */		protected function onFileReady(file:IFile):void 		{			_fileCompleteSignal.dispatch(this);		}						//-----------------------------------------------------------------------------------------		// Private Methods		//-----------------------------------------------------------------------------------------				/**		 * @private		 */		protected function processBuffer():void		{			removeEventListeners();						var b:ByteArray = new ByteArray();			_buffer.readBytes(b, 0, _fileSize);						/* Decompress if necessary. */
			if (_entry.compressionMethod == ZipConstants.DEFLATE)			{				if (!ZippedFile._inflate) ZippedFile._inflate = new Inflate();				_buffer.clear();				ZippedFile._inflate.process(b, _buffer);			}			else			{				_buffer = b;			}						_status = BulkFile.STATUS_LOADED;			_loading = false;						/* Add content to file object and listen for file's complete event. */			_file.completeSignal.addOnce(onFileReady);			_file.content = _buffer;		}						/**		 * @private		 */		protected function removeEventListeners():void		{			if (!_stream) return;			_stream.removeEventListener(ProgressEvent.PROGRESS, onStreamProgress);			_stream.removeEventListener(IOErrorEvent.IO_ERROR, onStreamError);			_stream.removeEventListener(Event.COMPLETE, onStreamComplete);		}						/**		 * @private		 */		protected function removerSignalListeners():void		{			if (_fileOpenSignal) _fileOpenSignal.removeAll();			if (_fileProgressSignal) _fileProgressSignal.removeAll();			if (_fileCompleteSignal) _fileCompleteSignal.removeAll();			if (_fileIOErrorSignal) _fileIOErrorSignal.removeAll();		}	}}