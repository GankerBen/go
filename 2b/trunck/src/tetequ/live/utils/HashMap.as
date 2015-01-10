/*
*  Copyright (c) 2008 Jonathan Wagner
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package tetequ.live.utils
{
	import flash.utils.Dictionary;
	
	public class HashMap
	{
		private var map:Dictionary
		
		public function HashMap() {
			map = new Dictionary(false);
		}
		
		public function put(key:*, value:*):void {
            map[key] = value;
        }
        
        public function remove(key:*):void {
            delete map[key];
        } 
        
        public function containsKey(key:*):Boolean {
            return map[key] != null;
        } 
        
        public function getValue(key:*):* {
            return map[key];
        } 
        
        public function getValues():Array {
            var values:Array = [];
            for (var key:* in map)
            {
                values.push( map[key] );
            }
            
            return values;
        }
        
        public function getKeys():Array {
            var keys:Array = [];

            for (var key:* in map)
            {
                keys.push( key );
            }
            
            return keys;
        }                                      
	}
}