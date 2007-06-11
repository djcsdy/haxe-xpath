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


package dcxml.parser;
import dcxml.Xml;
import dcxml.XmlException;
import dcxml.XmlError;


/** Event handler for XmlParser which builds a tree of Xml objects. */
class XmlBuilder implements XmlHandler {
	
	private var nodeStack:Array<Xml>;
	private var node:Xml;
	private var done:Bool;
	
	
	/** Constructs a new XmlBuilder. */
	public function new () {
		nodeStack = new Array<Xml>();
		done = false;
	}
	
	/** Receive notification of the beginning of a document. */
	public function startDocument () :Void {
		if (node == null) {
			node = Xml.createDocument();
		} else {
			throw new XmlError("Unexpected startDocument event");
		}
	}
	
	/** Receive notification of the end of a document. */
	public function endDocument () :Void {
		if (nodeStack.length == 0 && !done) {
			done = true;
		} else {
			throw new XmlError("Unexpected endDocument event");
		}
	}
	
	/** Receive notification of the beginning of an element. */
	public function startElement (name:String, attributes:Hash<String>) :Void {
		if (node == null || done) {
			throw new XmlError("Unexpected startElement event");
		} else {
			nodeStack.push(node);
			var tmpNode:Xml = Xml.createElement(name, attributes);
			node.addChild(tmpNode);
			node = tmpNode;
		}
	}
	
	/** Receive notification of the end of an element. */
	public function endElement (name:String) :Void {
		if (node == null || node.type != Element) {
			throw new XmlError("Unexpected endElement event");
		} else if (node.name != name) {
			throw new XmlException("Invalid XML markup");
		} else {
			node = nodeStack.pop();
		}
	}
	
	/** Receive notification of character data. */
	public function characters (data:String) :Void {
		if (node == null) {
			throw new XmlError("Unexpected characters event");
		} else {
			node.addChild(Xml.createText(data));
		}
	}
	
	/** Receive notification of a processing instruction. */
	public function processingInstruction (target:String, data:String) :Void {
		if (node == null) {
			throw new XmlError("Unexpected processingInstruction event");
		} else {
			node.addChild(Xml.createProcessingInstruction(target, data));
		}
	}
	
	/** Receive notification of a comment. */
	public function comment (data:String) :Void {
		if (node == null || node.type != Element) {
			throw new XmlError("Unexpected comment event");
		} else {
			// TODO
		}
	}
		
	/** Receive notification of the start of a CDATA section. */
	public function startCData () :Void {
	}
	
	/** Receive notification of the end of a CDATA section. */
	public function endCData () :Void {
	}
	
	/** Gets the resulting XML tree. Throws XmlException if the builder has not
	 * yet reached the end of the document and constructed the entire tree */
	public function getXml () :Xml {
		if (done) return node;
		else throw new XmlException("XML tree construction incomplete");
	}
	
}