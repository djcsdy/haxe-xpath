/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.type;
import dcxml.Xml;
import xpath.type.XPathValue;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;


/** Class implementing the node set data type used by XPath queries. */
class XPathNodeSet extends XPathValue {
	
	private var nodes:Array<Xml>;
	
	
	/** Constructs a new XPathNodeSet with the specified value. */
	public function new (?nodes:Array<Xml>) {
		super(this);
		typeName = "node set";
		if (nodes == null) this.nodes = new Array<Xml>();
		else this.nodes = nodes;
	}
	
	/** Gets the boolean value of this XPathNodeSet as per the boolean() function
	 * defined by the XPath specification. The node set is true if and only if
	 * it is non-empty. */
	public function getBool () :Bool {
		return nodes.length != 0;
	}
	
	/** Gets the numeric value of this XPathNodeSet as per the number() function
	 * defined by the XPath specification. The XPathNodeSet is first converted to
	 * a string by calling getString. The conversion is then the same as specified
	 * by XPathString.getFloat(). */
	public function getFloat () :Float {
		return Std.parseFloat(this.getString());
	}
	
	/** Gets the string value of this XPathNodeSet as per the string() function
	 * defined by the XPath specification. The node set is converted by returning
	 * the string value of the node in the node set that is first in document
	 * order. If the node set is empty, an empty string is returned. */
	public function getString () :String {
		if (nodes.length > 0) return getFirstNodeDocumentOrder().getStringValue();
		else return "";
	}
	
	/** Gets an array of the nodes contained by this node set. */
	public function getNodes () :Array<Xml> {
		return nodes;
	}

	/** Gets an array of the nodes contained by this node set in
	 * document order. */
	public function getNodesDocumentOrder () :Array<Xml> {
		if (nodes.length == 0) return nodes;
		
		var result:Array<Xml> = new Array<Xml>();
		var xml:Xml = nodes[0];
		while (xml.parent != null) xml = xml.parent;
		
		for (node1 in xml) {
			for (node2 in nodes) {
				if (node1 === node2) result.push(node1);
			}
			for (node2 in node1.attributes()) {
				if (node1 === node2) result.push(node1);
			}
		}
		
		return result;
	}
	
	/** Gets the node contained by this node set that is first in
	 * document order. */
	public function getFirstNodeDocumentOrder () :Xml {
		if (nodes.length == 0) return null;
		
		var xml:Xml = nodes[0];
		while (xml.parent != null) xml = xml.parent;
		
		for (node1 in xml) {
			for (node2 in nodes) {
				if (node1 === node2) return node1;
			}
			for (node2 in node1.attributes()) {
				if (node1 === node2) return node1;
			}
		}
		
		return null;
	}
	
	/** Performs the equality operation as defined by the XPath specification. */
	public function equals (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (leftNode in nodes) {
				var leftString:String = leftNode.getStringValue();
				for (rightNode in rightNodes) {
					if (leftString == rightNode.getStringValue()) {
						return new XPathBoolean(true);
					}
				}
			}
			return new XPathBoolean(false);
		} else {
			return rightOperand.xPathValueApi.equals(this);
		}
	}
	
	/** Performs the inequality operation as defined by the XPath specification. */
	public function notEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (leftNode in nodes) {
				var leftString:String = leftNode.getStringValue();
				for (rightNode in rightNodes) {
					if (leftString != rightNode.getStringValue()) {
						return new XPathBoolean(true);
					}
				}
			}
			return new XPathBoolean(false);
		} else {
			return rightOperand.xPathValueApi.notEqual(this);
		}
	}
	
	/** Performs the less-than-or-equal operation as defined by the XPath
	 * specification. */
	public function lessThanOrEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (leftNode in nodes) {
				var leftString:String = leftNode.getStringValue();
				var leftValue:Float = Std.parseFloat(StringTools.trim(leftString));
				for (rightNode in rightNodes) {
					var rightString:String = rightNode.getStringValue();
					var rightValue:Float = Std.parseFloat(StringTools.trim(rightString));
					if (leftValue <= rightValue) {
						return new XPathBoolean(true);
					}
				}
			}
			return new XPathBoolean(false);
		} else {
			for (node in nodes) {
				var nodeString:String = node.getStringValue();
				var nodeValue:Float = Std.parseFloat(StringTools.trim(nodeString));
				if (nodeValue <= rightOperand.xPathValueApi.getFloat()) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		}
	}
	
	/** Performs the greater-than-or-equal operation as defined by the XPath
	 * specification. */
	public function greaterThanOrEqual (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (leftNode in nodes) {
				var leftString:String = leftNode.getStringValue();
				var leftValue:Float = Std.parseFloat(StringTools.trim(leftString));
				for (rightNode in rightNodes) {
					var rightString:String = rightNode.getStringValue();
					var rightValue:Float = Std.parseFloat(StringTools.trim(rightString));
					if (leftValue >= rightValue) {
						return new XPathBoolean(true);
					}
				}
			}
			return new XPathBoolean(false);
		} else {
			for (node in nodes) {
				var nodeString:String = node.getStringValue();
				var nodeValue:Float = Std.parseFloat(StringTools.trim(nodeString));
				if (nodeValue >= rightOperand.xPathValueApi.getFloat()) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		}
	}
	
	/** Performs the less-than operation as defined by the XPath specification. */
	public function lessThan (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (leftNode in nodes) {
				var leftString:String = leftNode.getStringValue();
				var leftValue:Float = Std.parseFloat(StringTools.trim(leftString));
				for (rightNode in rightNodes) {
					var rightString:String = rightNode.getStringValue();
					var rightValue:Float = Std.parseFloat(StringTools.trim(rightString));
					if (leftValue < rightValue) {
						return new XPathBoolean(true);
					}
				}
			}
			return new XPathBoolean(false);
		} else {
			for (node in nodes) {
				var nodeString:String = node.getStringValue();
				var nodeValue:Float = Std.parseFloat(StringTools.trim(nodeString));
				if (nodeValue < rightOperand.xPathValueApi.getFloat()) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		}
	}
	
	/** Performs the greater-than operation as defined by the XPath specification. */
	public function greaterThan (rightOperand:XPathValue) :XPathBoolean {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			for (leftNode in nodes) {
				var leftString:String = leftNode.getStringValue();
				var leftValue:Float = Std.parseFloat(StringTools.trim(leftString));
				for (rightNode in rightNodes) {
					var rightString:String = rightNode.getStringValue();
					var rightValue:Float = Std.parseFloat(StringTools.trim(rightString));
					if (leftValue > rightValue) {
						return new XPathBoolean(true);
					}
				}
			}
			return new XPathBoolean(false);
		} else {
			for (node in nodes) {
				var nodeString:String = node.getStringValue();
				var nodeValue:Float = Std.parseFloat(StringTools.trim(nodeString));
				if (nodeValue > rightOperand.xPathValueApi.getFloat()) return new XPathBoolean(true);
			}
			return new XPathBoolean(false);
		}
	}

	/** Performs the union operation as defined by the XPath specification.
	 * Throws XPathEvaluationException if rightOperand is not an XPathNodeSet */
	override public function union (rightOperand:XPathValue) :XPathNodeSet {
		if (Std.is(rightOperand, XPathNodeSet)) {
			var leftNodes:Array<Xml> = this.getNodes();
			var rightNodes:Array<Xml> = cast(rightOperand, XPathNodeSet).getNodes();
			return new XPathNodeSet(leftNodes.concat(rightNodes));
		} else {
			return super.union(rightOperand);
		}
	}
	
}