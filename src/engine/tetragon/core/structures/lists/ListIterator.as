/* *      _________  __      __ *    _/        / / /____ / /________ ____ ____  ___ *   _/        / / __/ -_) __/ __/ _ `/ _ `/ _ \/ _ \ *  _/________/  \__/\__/\__/_/  \_,_/\_, /\___/_//_/ *                                   /___/ *  * Tetragon : Game Engine for multi-platform ActionScript projects. * http://www.tetragonengine.com/ - Copyright (C) 2012 Sascha Balkau *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE * SOFTWARE. */package tetragon.core.structures.lists{	import tetragon.core.exception.IllegalArgumentException;	import tetragon.core.exception.IllegalStateException;	import tetragon.core.exception.NoSuchElementException;	import tetragon.core.structures.IIterator;		/**	 * Iterator for List classes.	 */	public class ListIterator implements IIterator	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/** @private */		private var _list:IList;		/** @private */		private var _index:int;						//-----------------------------------------------------------------------------------------		// Constructor		//-----------------------------------------------------------------------------------------				/**		 * Creates a new ListIterator instance.		 * 		 * @param list The list to iterate over.		 * @throws com.hexagonstar.exception.IllegalArgumentException if the specified list		 *             is null.		 */		public function ListIterator(list:IList)		{			if (!list)			{				throw new IllegalArgumentException("[ListIterator] The specified list is null.");			}						_list = list;			reset();		}						//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * Removes the currently iterated element from the list on which this iterator is		 * used and returns it.		 * 		 * @return The element that was removed from the list.		 * @throws com.hexagonstar.exception.IllegalStateException if there is no element		 *             selected that can be removed, e.g. if remove() is called before		 *             calling next() at least once.		 */		public function remove():*		{			if (_index < 0)			{				throw new IllegalStateException(_list.toString() + "[ListIterator]"				+ " Tried to remove an element from the list before calling the next method."				+ " There is thus no element selected to remove.");				return null;			}			return _list.removeAt(_index);		}						/**		 * Resets the list iterator. After calling this method the iterator is in the same		 * state like it was created for the first time.		 */		public function reset():void		{			_index = -1;		}						//-----------------------------------------------------------------------------------------		// Getters & Setters		//-----------------------------------------------------------------------------------------				/**		 * Returns whether the iterator has a next element to iterate over.		 */		public function get hasNext():Boolean		{			return (_index < _list.size - 1);		}						/**		 * Returns whether the iterator has a previous element to iterate over.		 */		public function get hasPrevious():Boolean		{			return (_index > -1);		}						/**		 * Returns the next element of the list that this iterator is used on.		 * 		 * @return The next element of the list.		 * @throws com.hexagonstar.exception.NoSuchElementException if there is no next		 *             element to iterate over, e.g. if the list is empty.		 */		public function get next():*		{			if (!hasNext)			{				throw new NoSuchElementException(_list.toString()					+ " [ListIterator] There is no next element in the list to iterate over.");				return null;			}			return _list.getElementAt(++_index);		}						/**		 * Returns the previous element of the list that this iterator is used on.		 * 		 * @return The previous element of the list.		 * @throws com.hexagonstar.exception.NoSuchElementException if there is no previous		 *             element to iterate over, e.g. if the list is empty.		 */		public function get previous():*		{			if (!hasPrevious)			{				throw new NoSuchElementException(_list.toString()					+ "[ListIterator] There is no previous element in the list to iterate over.");				return null;			}			return _list.getElementAt(_index--);		}						/**		 * Returns the next iterated index.		 * 		 * @return The next iterated index.		 */		public function get nextIndex():int		{			if (!hasNext)				return _list.size;			else				return _index + 1;		}						/**		 * Returns the previous iterated index.		 * 		 * @return The previous iterated index.		 */		public function get previousIndex():int		{			if (!hasPrevious)				return -1;			else				return _index - 1;		}	}}