/* dcxml by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
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


package dcxml;
import dcxml.parser.XmlParser;
import dcxml.parser.XmlBuilder;


/** Class representing an XML node. */
class Xml {
	
	/** reference to parent node, or null if this node has no parent */
	public var parent(default, null):Xml;

	/** reference to previous and next sibling nodes in document order, or null if there
	 * are no previous or next sibling nodes */
	public var previousSibling(default, null):Xml;
	public var nextSibling(default, null):Xml;
	
	/** reference to first and last child nodes */
	public var firstChild(default, null):Xml;
	public var lastChild(default, null):Xml;
	
	/** type of the node */
	public var type(default, null):XmlType;
	
	/** name of the node (only set for element and attribute nodes) */
	public var name(default, null):String;
	
	/** text of the node (only set for text, attribute, processing instruction and doctype nodes) */
	public var text(default, null):String;
	
	// attributes of the node (only set for element nodes)
	private var attrs:Hash<Xml>;
	
	
	private function new () {
		attrs = new Hash<Xml>();
	}
	
	/** Creates an XML document node. */
	public static function createDocument () :Xml {
		var node:Xml = new Xml();
		node.type = Document;
		return node;
	}
	
	/** Creates an XML element node. */
	public static function createElement (name:String, ?attributes:Hash<String>) {
		var node:Xml = new Xml();
		node.type = Element;
		node.name = name;
		if (attributes != null) {
			for (attrName in attributes.keys()) {
				node.setAttributeValue(attrName, attributes.get(attrName));
			}
		}
		return node;
	}
	
	/** Creates an XML processing instruction node. */
	public static function createProcessingInstruction (name:String, text:String) :Xml {
		var node:Xml = new Xml();
		node.type = ProcessingInstruction;
		node.name = name;
		node.text = text;
		return node;
	}
	
	/** Creates an XML text node. */
	public static function createText (text:String) :Xml {
		var node:Xml = new Xml();
		node.type = Text;
		node.text = text;
		return node;
	}
	
	/** Parses XML input from a string. */
	public static function parse (xmlString:String) :Xml {
		var builder:XmlBuilder = new XmlBuilder();
		XmlParser.parse(xmlString, builder);
		return builder.getXml();
	}
	
	/** Downloads an XML document via HTTP and parses it. */
	public static function parseFromHTTP (url:String) :Xml {
		var builder:XmlBuilder = new XmlBuilder();
		XmlParser.parseFromHTTP(url, builder);
		return builder.getXml();
	}
	
	/** Gets an iterator over children in document order. */
	public function iterator () :Iterator<Xml> {
		return new XmlIterator(this);
	}
	
	/** Gets an iterator over child elements in document order. */
	public function elements () :Iterator<Xml> {
		return new XmlElementIterator(this);
	}
	
	/** Gets an iterator over all child elements with the specified name in document order. */
	public function elementsNamed (name:String) :Iterator<Xml> {
		return new XmlElementIterator(this, name);
	}
	
	/** Gets an iterator over all attributes. */
	public function attributes () :Iterator<Xml> {
		return attrs.iterator();
	}
	
	/** Tests if an attribute with the specified name exists. */
	public function existsAttribute (name:String) :Bool {
		return attrs.exists(name);
	}
	
	/** Gets an attribute. */
	public function getAttribute (name:String) :Xml {
		return attrs.get(name);
	}
	
	/** Gets the value of an attribute. */
	public function getAttributeValue (name:String) :String {
		return attrs.get(name).text;
	}
	
	/** Gets the child with the specified index. */
	public function getChild (?i:Int) :Xml {
		if (i==null) i=0;
		else if (i<0) return null;

		return firstChild.getSibling(i);
	}
	
	/** Gets the sibling that is i steps away in document order; or, if i is negative, the sibling that
	 * is -i steps away in reverse document order. */
	public function getSibling (i:Int) :Xml {
		var sibling:Xml = this;
		
		if (i >= 0) {
			for (j in 0...i) {
				sibling = sibling.nextSibling;
				if (sibling == null) return null;
			}
		} else {
			for (j in 0...-i) {
				sibling = sibling.previousSibling;
				if (sibling == null) return null;
			}
		}
		
		return sibling;
	}
	
	/** Gets the node that is i steps away in document order; or, if i is negative, the node that is -i
	 * steps away in reverse document order. */
	public function getNode (?i:Int) :Xml {
		if (i==null) i=0;
		var node:Xml = this;
		
		while (i > 0) {
			if (node.firstChild != null) {
				node = node.firstChild;
			} else if (node.nextSibling == null) {
				while (node.nextSibling == null) {
					node = node.parent;
					if (node == null) return null;
				}
				node = node.nextSibling;
			} else {
				node = node.nextSibling;
			}
			--i;
		}
		
		while (i < 0) {
			if (node.previousSibling == null) {
				node = node.parent;
				if (node == null) return null;
				++i;
			} else {
				node = node.previousSibling;
				while (node.lastChild != null) {
					node = node.lastChild;
				}
				++i;
			}
		}
		
		return node;
	}
	
	/** Sets an attribute value. */
	public function setAttributeValue (name:String, value:String) :Void {
		var attribute:Xml = new Xml();
		attribute.type = Attribute;
		attribute.parent = this;
		attribute.name = name;
		attribute.text = value;
		attrs.set(name, attribute);
	}
	
	/** Removes an attribute. */
	public function removeAttribute (name:String) :Void {
		attrs.get(name).parent = null;
		attrs.remove(name);
	}
	
	/** Removes the node from the XML document. */
	public function remove () :Void {
		var previousSiblingNextSibling:Xml = nextSibling;
		var nextSiblingPreviousSibling:Xml = previousSibling;
		
		if (previousSibling == null) {
			if (parent != null) {
				parent.firstChild = nextSibling;
			}
		} else {
			previousSibling.nextSibling = previousSiblingNextSibling;
			previousSibling = null;
		}
		
		if (nextSibling == null) {
			if (parent != null) {
				parent.lastChild = previousSibling;
			}
		} else {
			nextSibling.previousSibling = nextSiblingPreviousSibling;
			nextSibling = null;
		}
		
		parent = null;			
	}
	
	/** Inserts a child node at the specified index.
	 * Throws XmlException if the specified index is out of bounds.
	 * Throws XmlException if the child node already has a parent. */
	public function insertChild (?i:Int, child:Xml) :Void {
		if (child.parent != null) {
			throw new XmlException("new child already has a parent");
		}
		
		if (i==null) i=0;
		else if (i<0) throw new XmlException("index '" + i + "' out of bounds");

		var siblingAfter:Xml = firstChild;
		for (j in 0...i) {
			if (siblingAfter == null) {
				throw new XmlException("index '" + i + "' out of bounds");
			}

			siblingAfter = siblingAfter.nextSibling;
		}
		
		if (siblingAfter == null) {
			addChild(child);
		} else {
			siblingAfter.insertSiblingBefore(child);
		}
	}
	
	/** Inserts a child node after existing children.
	 * Throws XmlException if the child already has a parent. */
	public function addChild (child:Xml) :Void {
		if (child.parent != null) {
			throw new XmlException("new child already has a parent");
		}
		
		if (lastChild != null) {
			// conjoin adjacent text nodes
			if (lastChild.type == Text && child.type == Text) {
				lastChild.text += child.text;
				return;
			}
			
			lastChild.nextSibling = child;
		} else {
			firstChild = child;
		}
		child.parent = this;
		child.previousSibling = lastChild;
		child.nextSibling = null;
		lastChild = child;
	}
	
	/** Inserts a sibling before this node. */
	public function insertSiblingBefore (sibling:Xml) :Void {
		if (sibling.parent != null) {
			throw new XmlException("new sibling already has a parent");
		}
		
		// conjoin adjacent text nodes
		if (sibling.type == Text) {
			if (type == Text) {
				text = sibling.text + text;
				return;
			} else if (previousSibling != null && previousSibling.type == Text) {
				previousSibling.text += sibling.text;
				return;
			}
		}
		
		sibling.parent = parent;
		sibling.previousSibling = previousSibling;
		sibling.nextSibling = this;
		
		if (previousSibling == null) parent.firstChild = sibling;
		previousSibling = sibling;
	}
	
	/** Inserts a sibling after this node. */
	public function insertSiblingAfter (sibling:Xml) :Void {
		if (sibling.parent != null) {
			throw new XmlException("new sibling already has a parent");
		}
		
		// conjoin adjacent text nodes
		if (sibling.type == Text) {
			if (type == Text) {
				text += sibling.text;
				return;
			} else if (nextSibling != null && nextSibling.type == Text) {
				nextSibling.text = sibling.text + nextSibling.text;
				return;
			}
		}
		
		sibling.parent = parent;
		sibling.previousSibling = this;
		sibling.nextSibling = nextSibling;
		
		if (nextSibling == null) parent.lastChild = sibling;
		nextSibling = sibling;
	}

	/** Gets the string value of the node per XPath spec:<ul>
	 * <li>For document and element nodes, the concatenation of the string values of all
	 *     text node descendants in document order.
	 * <li>For processing instruction nodes, the part of the processing instruction
	 *     following any target and any whitespace, not including the terminating ?&gt;.
	 * <li>For text nodes, the character data.</ul> */
	public function getStringValue () :String {
		if (type == Document || type == Element) {
			var buf:StringBuf = new StringBuf();
			for (child in this) {
				buf.add(child.getStringValue());
			}
			return buf.toString();
		} else {
			return text;
		}
	}
	
	/** Gets the string markup representation of the XML node. */
	public function toString () :String {
		switch (type) {
			case Document:
			var result:StringBuf = new StringBuf();
			for (node in this) {
				result.add(node.toString());
			}
			return result.toString();
			
			case Element:
			var result:StringBuf = new StringBuf();
			result.add("<" + name);
			for (attr in attrs) {
				result.add(" " + attr.toString());
			}
			result.add(">");
			for (node in this) {
				result.add(node.toString());
			}
			result.add("</" + name + ">");
			return result.toString();
			
			case Text:
			return encodeText(text);
			
			case Attribute:
			return name + '="' + encodeText(text) + '"';
			
			case DocType:
			// TODO
			return "";
			
			case ProcessingInstruction:
			return "<?" + name + " " + text + "?>";
		}
		return "";
	}
	
	private function encodeText (text:String) :String {
		var result:StringBuf = new StringBuf();
		var i:Int = 0;
		while (i < text.length) {
			var charCode:Int = text.charCodeAt(i);
			if (charCode < 32 || charCode > 126) {
				result.add("&#" + Std.string(charCode) + ";");
			} else if (charCode == 34) {
				result.add("&quot;");
			} else if (charCode == 38) {
				result.add("&amp;");
			} else if (charCode == 39) {
				result.add("&apos;");
			} else if (charCode == 60) {
				result.add("&lt;");
			} else if (charCode == 62) {
				result.add("&gt;");
			} else {
				result.add(Std.chr(i));
			}
		}
		return result.toString();
	}
	
}

/** Iterator over XML children. */
private class XmlIterator {
	
	private var parent:Xml;
	private var current:Xml;
	
	
	public function new (parent:Xml) {
		this.parent = parent;
	}
	
	public function hasNext () :Bool {
		if (current == null) return (parent.getNode(1) != null);
		else return (current.getSibling(1) != null);
	}
	
	public function next () :Xml {
		if (current == null) current = parent.getNode(1);
		else current = current.getSibling(1);
		return current;
	}

}

/** Iterator over XML child elements. */
private class XmlElementIterator {
	
	private var parent:Xml;
	private var name:String;
	private var currentOrNext:Xml;
	private var isCurrent:Bool;
	
	
	public function new (parent:Xml, ?name:String) {
		this.parent = parent;
		this.name = name;
		isCurrent = true;
	}
	
	public function hasNext () :Bool {
		getNext();
		return (currentOrNext != null);
	}
	
	public function next () :Xml {
		getNext();
		return currentOrNext;
	}
	
	private function getNext () :Void {
		if (!isCurrent) {
			while (
				currentOrNext != null && currentOrNext.type != Element &&
				currentOrNext.name != name
			) {
				currentOrNext = currentOrNext.getSibling(1);
			}
		}
	}
	
}

/** Enumeration of the possible types of XML node */
enum XmlType {
	
	/** Document root node */
	Document;
	
	/** Element node */
	Element;
	
	/** Text node (corresponding to one or more sequential CDATA or PCDATA sections) */
	Text;
	
	/** Attribute node */
	Attribute;
	
	/** DOCTYPE declaration */
	DocType;
	
	/** Processing instruction */
	ProcessingInstruction;
	
}