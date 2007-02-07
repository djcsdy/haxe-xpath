/* dcxml by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package dcxml.parser;
import haxe.Http;
import dcxml.XmlException;


/** Event based parser for XML documents. */
class XmlParser {
	
	private var handler:XmlHandler;
	private var predefinedEntities:Hash<String>;
	private var entities:Hash<String>;
	
	
	private function new (handler:XmlHandler, entities:Hash<String>) {
		this.handler = handler;
		if (entities == null) this.entities = new Hash<String>();
		else this.entities = entities;
		predefinedEntities = new Hash<String>();
		predefinedEntities.set("lt", "&#60;");
		predefinedEntities.set("gt", "&#62;");
		predefinedEntities.set("amp", "&#38;");
		predefinedEntities.set("apos", "&#39;");
		predefinedEntities.set("quot", "&#34;");
	}
	
	/** Parses an XML document from a string. */
	public static function parse (xmlString:String, handler:XmlHandler, ?entities:Hash<String>) :Void {
		var parser:XmlParser = new XmlParser(handler, entities);
		parser.onData(xmlString);
	}
	
	/** Downloads an XML document via HTTP and parses it. */
	public static function parseFromHTTP (url:String, handler:XmlHandler, ?entities:Hash<String>) :Void {
		var http:Http = new Http(url);
		var parser:XmlParser = new XmlParser(handler, entities);
		http.onData = parser.onData;
		http.onError = function (msg:String) {
			throw new XmlException("XML HTTP download failed: " + msg);
		}
		http.request(false);
	}
	
	
	private function onData (data:String) {
		handler.startDocument();
		parseData(data);
		handler.endDocument();
	}
	
	private function parseData (data:String) :Void {
		var i:Int = 0;
		var j:Int = 0;
		while (j < data.length) {
			var c:String = data.charAt(j);
			if (c == "<") {
				if (j > i) handler.characters(data.substr(i, j-i));
				i=j = parseTag(data, j+1);
			} else if (c == "&") {
				if (j > i) handler.characters(data.substr(i, j-i));
				i=j = parseReference(data, j+1);
			} else {
				++j;
			}
		}
		if (j > i) handler.characters(data.substr(i, j-i));
	}
	
	private function parseReference (data:String, i:Int) :Int {
		var j:Int = data.indexOf(";", i);
		if (j == -1) throw new XmlException("Invalid XML markup");
		
		if (data.charAt(i) == "#") {
			// character reference
			var charCode:Int;
			++i;
			if (data.charAt(i) == "x") {
				charCode = Std.parseInt("0" + data.substr(i, j-i));
			} else {
				#if flash8
				while(data.charAt(j) == "0" && j-i>1) {
					++j;
				}
				#end
				charCode = Std.parseInt(data.substr(i, j-i));
			}
			if (Math.isNaN(charCode)) throw new XmlException("Invalid XML markup");
			handler.characters(Std.chr(charCode));
		} else {
			// entity reference
			var entityName:String = data.substr(i, j-i);
			var entity:String = resolveEntity(entityName);
			if (entity == null) handler.characters("&" + entityName + ";");
			else parseData(entity);
		}

		return j+1;
	}
	
	private function parseTag (data:String, i:Int) :Int {
		var c:String = data.charAt(i);
		if (c == "!") {
			if (data.charAt(i+1) == "[") {
				if (data.substr(i+2, 6) == "CDATA[") {
					// CDATA
					i+=8;
					var j:Int = data.indexOf("]]>", i);
					if (j == -1) {
						throw new XmlException("Invalid XML markup");
					}
					handler.startCData();
					handler.characters(data.substr(i, j-i));
					handler.endCData();
					return j+3;
				} else {
					throw new XmlException("Invalid XML markup");
				}
			} else if (data.substr(i+1, 2) == "--") {
				// comment
				var j:Int = i;
				i+=3;
				do {
					j = data.indexOf("-->", j+3);
					if (j == -1) throw new XmlException("Invalid XML markup");
				} while (data.charAt(j-1) == "-");
				handler.comment(data.substr(i, j-i));
				return j+3;
			} else {
				// DOCTYPE or other <! ... >
				var j:Int = i;
				do {
					++j;
					if (j >= data.length) throw new XmlException("Invalid XML markup");
					var c:String = data.charAt(j);
					if (c == '"' || c == "'") {
						var quote:String = c;
						do {
							++j;
							if (j >= data.length) throw new XmlException("Invalid XML markup");
						} while (data.charAt(j) != quote);
					}
				} while (data.charAt(j) != ">");
				return j+1;
			}
		} else if (c == "?") {
			// processing instruction
			++i;
			var j:Int = i;
			c = data.charAt(j);
			while (c != " " && c != "/" && c != "?" && c != "\t" && c != "\r" && c != "\n") {
				++j;
				if (j >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(j);
			}
			var target:String = data.substr(i, j-i);
			
			while (c == " " || c == "\t" || c == "\r" || c == "\n") {
				++j;
				if (j >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(j);
			}
			
			i = data.indexOf("?>", j);
			if (i == -1) throw new XmlException("Invalid XML markup");
			var text:String = data.substr(j, i-j);
			
			handler.processingInstruction(target, text);
			return i+2;
		} else if (c == "/") {
			// end element
			++i;
			var j:Int = i;
			var c:String = data.charAt(j);
			while (c != " " && c != "/" && c != ">" && c != "\t" && c != "\r" && c != "\n") {
				++j;
				if (j >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(j);
			}
			var name:String = data.substr(i, j-i);
			while (c == " " || c == "\t" || c == "\r" || c == "\n") {
				++j;
				if (j >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(j);
			}
			if (c != ">") throw new XmlException("Invalid XML markup");
			handler.endElement(name);
			return j+1;
		} else {
			// element
			var j:Int = i;
			var c:String = data.charAt(j);
			while (c != " " && c != "/" && c != ">" && c != "\t" && c != "\r" && c != "\n") {
				++j;
				if (j >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(j);
			}
			var name:String = data.substr(i, j-i);
			while (c == " " || c == "\t" || c == "\r" || c == "\n") {
				++j;
				if (j >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(j);
			}

			i = j;
			var attributes:Hash<String> = new Hash<String>();
			while (c != "/" && c != ">") {
				while (c != " " && c != "/" && c != ">" && c != "\t" && c != "\r" && c != "\n" && c != "=") {
					++i;
					if (i >= data.length) throw new XmlException("Invalid XML markup");
					c = data.charAt(i);
				}
				var attrName:String = data.substr(j, i-j);
				while (c == " " || c == "\t" || c == "\r" || c == "\n") {
					++i;
					if (i >= data.length) throw new XmlException("Invalid XML markup");
					c = data.charAt(i);
				}
				if (c != "=") throw new XmlException("Invalid XML markup");
				
				j = i+1;
				c = data.charAt(j);
				while (c == " " || c == "\t" || c == "\r" || c == "\n") {
					++j;
					if (j >= data.length) throw new XmlException("Invalid XML markup");
					c = data.charAt(j);
				}
					
				var quote:String = c;
				if (quote != "'" && quote != '"') throw new XmlException("Invalid XML markup");
				++j; i=j;
				c = data.charAt(i);
				while (c != quote) {
					++i;
					if (i >= data.length) throw new XmlException("Invalid XML markup");
					c = data.charAt(i);
				}
				var attrValue:String = data.substr(j, i-j);
				
				++i;
				if (i >= data.length) throw new XmlException("Invalid XML markup");
				c = data.charAt(i);
				while (c == " " || c == "\t" || c == "\r" || c == "\n") {
					++i;
					if (i >= data.length) throw new XmlException("Invalid XML markup");
					c = data.charAt(i);
				}
				j=i;
			
				attributes.set(attrName, attrDecode(attrValue));
			}
			if (c == "/") {
				if (data.charAt(i+1) == ">") {
					handler.startElement(name, attributes);
					handler.endElement(name);
					return i+2;
				} else {
					throw new XmlException("Invalid XML markup");
				}
			} else if (c == ">") {
				handler.startElement(name, attributes);
				return i+1;
			} else {
				throw new XmlException("Invalid XML markup");
			}
		}
	}
	
	private function resolveEntity (entityName:String) :String {
		if (entities.exists(entityName)) return entities.get(entityName);
		else return predefinedEntities.get(entityName);
	}
	
	private function attrDecode (value:String) :String {
		var result:StringBuf = new StringBuf();
		var i:Int = 0;
		while (i < value.length) {
			var c:String = value.charAt(i);
			if (c == "&") {
				var j:Int = value.indexOf(";", i);
				if (j == -1) throw new XmlException("Invalid XML markup");
				
				if (value.charAt(i) == "#") {
					// character reference
					var charCode:Int;
					++i;
					if (value.charAt(i) == "x") {
						charCode = Std.parseInt("0" + value.substr(i, j-i));
					} else {
						#if flash8
						while(value.charAt(j) == "0" && j-i>1) {
							++j;
						}
						#end
						charCode = Std.parseInt(value.substr(i, j-i));
					}
					if (Math.isNaN(charCode)) throw new XmlException("Invalid XML markup");
					result.add(Std.chr(charCode));
				} else {
					// entity reference
					var entityName:String = value.substr(i, j-i);
					var entity:String = resolveEntity(entityName);
					if (entity.indexOf("<") != -1) throw new XmlException("Invalid XML markup");
					else if (entity == null) result.add("&" + entityName + ";");
					else result.add(attrDecode(entity));
				}
			} else {
				result.add(c);
			}
			++i;
		}
		
		return result.toString();
	}

}